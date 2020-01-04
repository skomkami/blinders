-module(controller).
-compile([export_all]).
-define(BLINDER_MAX_LEVEL, 18).

blindersController(BlindersFPids, CloseAll, BlindersLevels) ->
    receive
        closeAll ->
            % before closing get levels of all blinders
            [Blinder!{self(), get} || Blinder <- BlindersFPids],
            timer:sleep(100),
            [Blinder!{set, ?BLINDER_MAX_LEVEL} || Blinder <- BlindersFPids],
            blindersController(BlindersFPids, true, BlindersLevels);
        openAll ->
            % for each blinder set level to level before closeAll
            [lists:nth(Id, BlindersFPids)!{set, lists:nth(Id, BlindersLevels)} || Id <- lists:seq(1,length(BlindersFPids))],
            blindersController(BlindersFPids, false, BlindersLevels);
        {level, Id, Level} ->
            % save level of blinder
            blindersController(BlindersFPids, CloseAll, utils:setnth(Id, BlindersLevels, Level));
        {Id, Level} ->
            case CloseAll of
                true -> 
                    print:print({printxy,0,21,"Blinders are locked"}),
                    blindersController(BlindersFPids, true, BlindersLevels);
                false ->
                    lists:nth(Id, BlindersFPids)!{set, Level},
                    blindersController(BlindersFPids, false, BlindersLevels)
                end;
        terminate ->
            [Blinder!terminate || Blinder <- BlindersFPids]
    end.