#!/usr/bin/escript
main(_) ->
 covid:init(),
 io:format("Dallas Numbers ~p\n", [covid:canDaveGoOut()]).
