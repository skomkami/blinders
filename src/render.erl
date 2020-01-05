-module(render).
-export([renderer/1]).

-define(RENDER_INTERVAL_MS, 1000).

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