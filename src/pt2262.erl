-module(pt2262).

-export([
    encode/2
  ]).

-define(SHORT, 133).
-define(LONG, 400).
-define(LOW, 0).
-define(HIGH, 1).

encode(Sig, Cmd) -> 
  Msg0 = lists:foldl(fun(_, Acc) -> 
      L = lists:foldl(fun(I, Acc0) -> 
          if ((Sig bsr (15-I)) band 1) =/= 0 -> 
              [?SHORT, ?LOW, ?LONG, ?HIGH | Acc0]; 
            true -> 
              [?LONG, ?LOW, ?SHORT, ?HIGH | Acc0] 
          end 
        end, 
        Acc,
        lists:seq(0, 15)
      ),
      R = lists:foldl(fun(I, Acc0) -> 
          if ((Cmd bsr (7-I)) band 1) =/= 0 ->
              [?SHORT, ?LOW, ?LONG, ?HIGH | Acc0]; 
            true ->
              [?LONG, ?LOW, ?SHORT, ?HIGH | Acc0] 
          end
        end,
        L,
        lists:seq(0, 7)
      ),
      [?LONG + 5000, ?LOW, ?SHORT, ?HIGH | R]
    end,
    [],
    lists:seq(0, 15)
  ),
  [LastWait | Msg1] = Msg0,
  lists:reverse([LastWait + 1000000 | Msg1]).
