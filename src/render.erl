-module(render).
-compile([export_all]).
-define(RENDER_INTERVAL_MS, 500).

renderer(BlindersFPids) ->
    receive
        {render} ->
            print:print({clear}),
            [FPid!{draw} || FPid <- BlindersFPids],
            timer:sleep(?RENDER_INTERVAL_MS),
            self()!{render},
            renderer(BlindersFPids);
        terminate ->
            io:format("Stopped rendering~n")
        end.