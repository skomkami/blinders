-module(print).
-export([print/1, printMenu/0]).

-define(USERINPUT, 1).
-define(OFFSET, 30).


print({gotoxy,X,Y}) ->
   io:format("\e[~p;~pH",[Y,X]);
print({printxy,X,Y,Msg}) ->
   io:format("\e[~p;~pH~s",[Y,X,Msg]);
print({clear}) ->
   io:format("\e[2J",[]).

printMenu() ->
   print({printxy, 0,           ?USERINPUT,   "Possible actions"}),
   print({printxy, ?OFFSET,     ?USERINPUT,   "Example"}),
   print({printxy, 0,           ?USERINPUT+2, "set all blinds (level)"}),
   print({printxy, ?OFFSET,     ?USERINPUT+2, "2"}),
   print({printxy, 0,           ?USERINPUT+3, "set one blind (id-level)"}),
   print({printxy, ?OFFSET,     ?USERINPUT+3, "1-12"}),
   print({printxy, 0,           ?USERINPUT+4, "close All"}),
   print({printxy, ?OFFSET,     ?USERINPUT+4, "c | closeAll"}),
   print({printxy, 0,           ?USERINPUT+5, "open All"}),
   print({printxy, ?OFFSET,     ?USERINPUT+5, "o | openAll"}),
   print({printxy, 0,           ?USERINPUT+6, "terminate the App"}),
   print({printxy, ?OFFSET,     ?USERINPUT+6, "t | terminate"}),
   print({printxy, 0,           ?USERINPUT+8, "action>"}).
