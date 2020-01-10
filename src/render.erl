-module(render).
-export([renderer/3]).

-define(RENDER_INTERVAL_MS, 1000).

renderer(BlindersFPids, SunFPid, SunTemperature) ->
    receive
        {temperature, Temperature} ->
            self()!{render},
            renderer(BlindersFPids, SunFPid, Temperature);
        {render} ->
            print:print({clear}),
            [FPid!{draw} || FPid <- BlindersFPids],
            print:print({printxy,1,21,"Sun temperature: " ++ integer_to_list(SunTemperature)}),
            timer:sleep(?RENDER_INTERVAL_MS),
            SunFPid!{self(),getTemp},
            renderer(BlindersFPids, SunFPid, SunTemperature);
        terminate ->
            io:format("Stopped rendering~n")
        end.