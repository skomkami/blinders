-module(validator).
-export([convert/1]).

convert(Input) ->
  case Input of
    "t\n" ->
      terminate;
    "terminate\n" ->
      terminate;
    "closeAll\n" ->
      closeAll;
    "c\n" ->
      closeAll;
    "openAll\n" ->
      openAll;
    "o\n" ->
      openAll;
    _maybeCorrect ->
      {ok, Tokens, _EndLine} = erl_scan:string(Input),

      IntegerAtoms = lists:filter(fun isIntegerAtom/1, Tokens),
      Integers = lists:map(fun getIntegerFromAtom/1, IntegerAtoms),

      case length(Integers) of
        2 ->
          [Id, Level | _] = Integers,
          {Id, Level};
        1 ->
          [Level | _] = Integers,
          {all, Level};
        _ ->
          incorrect
      end
  end.

isIntegerAtom({integer, _, _}) ->
  true;
isIntegerAtom(_) ->
  false.

getIntegerFromAtom({integer, _, X}) ->
  X.