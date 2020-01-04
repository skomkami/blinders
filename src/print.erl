-module(print).
-compile([export_all]).

print({gotoxy,X,Y}) ->
   io:format("\e[~p;~pH",[Y,X]);
print({printxy,X,Y,Msg}) ->
   io:format("\e[~p;~pH~p",[Y,X,Msg]);   
print({clear}) ->
   io:format("\e[2J",[]).