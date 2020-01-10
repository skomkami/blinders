-module(blinder).
-export([blinder/3]).

-define(BLINDER_WIDTH, 20).
-define(BLINDER_HEIGHT, 20).
-define(BLINDER_MARGIN_TOP,12).

blinder(Id, CurrentLevel, TargetLevel) ->
    receive
        {set, Level} ->
            blinder(Id, CurrentLevel, Level);
        {To, get} ->
            To!{level,Id, CurrentLevel},
            blinder(Id, CurrentLevel, TargetLevel);
        {draw} ->
            printBlinder(Id, CurrentLevel),
            case CurrentLevel of
                N when N < TargetLevel ->
                    blinder(Id, CurrentLevel + 1, TargetLevel);
                N when N > TargetLevel ->
                    blinder(Id, CurrentLevel - 1, TargetLevel);
                _ -> 
                    blinder(Id, CurrentLevel, TargetLevel)
                end;
        terminate ->
            io:format("Blinder ~p terminated~n",[Id])
    end.

printBlinder(Id, Row, Level) ->
    case Row =< ?BLINDER_HEIGHT of
        true ->
            case Row =< Level of
                true ->
                    print:print({printxy, 3+(Id-1)*?BLINDER_WIDTH, ?BLINDER_MARGIN_TOP + Row, "################"}),
                    printBlinder(Id, Row + 1, Level);
                false ->
                    print:print({printxy, 3+(Id-1)*?BLINDER_WIDTH, ?BLINDER_MARGIN_TOP + Row, "----------------"}),
                    printBlinder(Id, Row + 1, Level)
            end;
        false ->
            print:printMenu()
    end.

printBlinder(Id, Level) ->
    print:print({printxy, 6+(Id-1)*?BLINDER_WIDTH, ?BLINDER_MARGIN_TOP, "Blinder " ++ integer_to_list(Id)}),
    printBlinder(Id, 1, Level).