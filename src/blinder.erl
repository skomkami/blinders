-module(blinder).
-export([blinder/3]).

-define(BLINDWIDTH, 20).
-define(BLINDER_MAX_PRINT_LEVEL, 20).


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
    case Row < ?BLINDER_MAX_PRINT_LEVEL of
        true ->
            case Row < Level+1 of
                true ->
                    print:print({printxy, 3+(Id-1)*?BLINDWIDTH, Row, "################"}),
                    printBlinder(Id, Row + 1, Level);
                false ->
                    print:print({printxy, 3+(Id-1)*?BLINDWIDTH, Row, "----------------"}),
                    printBlinder(Id, Row + 1, Level)
            end;
        false ->
            print:printMenu()
    end.

printBlinder(Id, Level) ->
    print:print({printxy, 6+(Id-1)*?BLINDWIDTH, 1, "Blinder " ++ integer_to_list(Id)}),
    printBlinder(Id, 2, Level+1).