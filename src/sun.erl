-module(sun).
-export([sun/2]).
-define(SUN_DELTA_TIME,0.1).
-define(SUN_INTERVAL_SECONDS, 15).

sun(Temperature, TimeSinceLastChange) ->
    receive
        shine ->
            timer:sleep(round(?SUN_DELTA_TIME * 1000)),
            self()!shine,
            case (TimeSinceLastChange + ?SUN_DELTA_TIME) < ?SUN_INTERVAL_SECONDS of
                true ->
                    sun(Temperature, TimeSinceLastChange + ?SUN_DELTA_TIME);
                false ->
                    Rand = rand:uniform(100),
                    sun(Rand, 0)
            end;
        {To, getTemp} ->
            To!{temperature, Temperature},
            sun(Temperature, TimeSinceLastChange);
        terminate ->
            io:format("Sun is setting down~n")
    end.