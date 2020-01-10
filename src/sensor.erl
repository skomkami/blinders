-module(sensor).
-export([sensor/3]).

-define(TEMP_TRESHOLD, 60).


sensor(FPidSun, FPidController, Locked) ->
    receive
        measure ->
            FPidSun!{self(), getTemp},
            timer:sleep(500),
            self()!measure,
            sensor(FPidSun, FPidController, Locked);
        {temperature, Temp} ->
            case Temp > ?TEMP_TRESHOLD of
                true ->
                    case Locked of
                        true ->
                            sensor(FPidSun, FPidController, Locked);
                        false ->
                            FPidController!closeAll,
                            sensor(FPidSun, FPidController, true)
                    end;
                false ->
                    case Locked of
                        true ->
                            FPidController!openAll,
                            sensor(FPidSun, FPidController, false);
                        false ->
                            sensor(FPidSun, FPidController, Locked)
                    end
            end;
        terminate ->
            FPidSun!terminate,
            io:format("Sensor turned down~n") 
    end.