-module(main).
-export([start/0]).

-define(USERINPUT, 22).
-define(BLINDER_INIT_LEVEL, 8).
-define(SUN_INIT_TEMP, 30).

compile_all() ->
    compile:file(print),
    compile:file(blinder),
    compile:file(utils),
    compile:file(render),
    compile:file(controller),
    compile:file(sun),
    compile:file(validator),
    compile:file(sensor).

start() ->
    compile_all(),
    io:format("Enter number of blinders: "),
    {ok, [NoBlinders|_]} = io:fread('',"~d"),
    main(NoBlinders).

main(NoBlinders) ->
    print:print({clear}),
    FPidBlinders = [spawn(blinder, blinder, [Id, ?BLINDER_INIT_LEVEL, ?BLINDER_INIT_LEVEL]) || Id <- lists:seq(1,NoBlinders)],
    FPidController = spawn(controller, blindersController, [FPidBlinders, false, lists:duplicate(NoBlinders,0)]),
    FPidSun = spawn(sun, sun, [?SUN_INIT_TEMP,0.0]),
    FPidSun!shine,
    FPidRenderer = spawn(render, renderer, [FPidBlinders, FPidSun, ?SUN_INIT_TEMP]),
    FPidRenderer!{temperature,?SUN_INIT_TEMP},
    FPidSensor = spawn(sensor, sensor, [FPidSun, FPidController, false]),
    FPidSensor!measure,
    loop(FPidController, FPidRenderer, FPidSensor).

loop(FPidController, FPidRenderer, FPidSensor) ->
    print:print({gotoxy, 0, ?USERINPUT}),

    Input = io:get_line(" "),
    Value = validator:convert(Input),

    case Value of
        {all, Level} ->
            FPidController!{all, Level},
            loop(FPidController, FPidRenderer, FPidSensor);
        {Id, Level} ->
            FPidController!{Id, Level},
            loop(FPidController, FPidRenderer, FPidSensor);
        closeAll ->
            FPidController!closeAll,
            loop(FPidController, FPidRenderer, FPidSensor);
        openAll ->
            FPidController!openAll,
            loop(FPidController, FPidRenderer, FPidSensor);
        terminate ->
            print:print({clear}),
            print:print({gotoxy,0,0}),
            FPidRenderer!terminate,
            FPidController!terminate,
            FPidSensor!terminate;
        incorrect ->
            loop(FPidController, FPidRenderer, FPidSensor)
    end.