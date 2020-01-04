-module(main).
-compile([export_all]).
-define(USERINPUT, 22).
-define(BLINDER_INIT_LEVEL, 8).
-define(SUN_INIT_TEMP, 30).

compile_all() ->
    compile:file(print),
    compile:file(utils),
    compile:file(render),
    compile:file(controller),
    compile:file(sun),
    compile:file(sensor).

start() ->
    compile_all(),
    io:format("Enter number of blinders: "),
    {ok, [NoBlinders|_]} = io:fread('',"~d"),
    main(NoBlinders).

main(NoBlinders) ->
    print:print({clear}),
    FPidBlinders = [spawn(blinder, blinder, [Id, ?BLINDER_INIT_LEVEL, ?BLINDER_INIT_LEVEL]) || Id <- lists:seq(1,NoBlinders)],
    FPidRenderer = spawn(render, renderer, [FPidBlinders]),
    FPidController = spawn(controller, blindersController, [FPidBlinders, false, lists:duplicate(NoBlinders,0)]),
    FPidRenderer!{render},
    FPidSun = spawn(sun, sun, [?SUN_INIT_TEMP]),
    FPidSun!{changeTemp},
    FPidSensor = spawn(sensor, sensor, [FPidSun, FPidController, false]),
    FPidSensor!measure,
    loop(FPidController, FPidRenderer, FPidSensor).

loop(FPidController, FPidRenderer, FPidSensor) ->
    print:print({gotoxy, 0, ?USERINPUT}),
    {ok, Input} = io:read(" "),
    case Input of
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
            FPidRenderer!terminate,
            FPidController!terminate,
            FPidSensor!terminate
    end.