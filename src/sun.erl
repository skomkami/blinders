-module(sun).
-export([sun/1]).

-define(SUN_INTERVAL_SECONDS, 15).

sun(Temperature) ->
    receive
        {changeTemp} ->
            timer:sleep(timer:seconds(?SUN_INTERVAL_SECONDS)),
            Rand = rand:uniform(100),
            self()!{changeTemp},
            sun(Rand);
        {To, getTemp} ->
            To!{temperature, Temperature},
            sun(Temperature);
        terminate ->
            io:format("Sun is setting down~n")
    end.