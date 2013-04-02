-module(pt2262).

-export([
    encode/2
  ]).

-include_lib("pie/include/pie.hrl").

-define(SHORT, 160).
-define(LONG, 500).

encode(Sig, Cmd) -> 
  Msg0 = lists:foldl(fun(_, Acc) -> 
      L = lists:foldl(fun(I, Acc0) -> 
          if ((Sig bsr (15-I)) band 1) =/= 0 -> 
              [?SHORT, ?PIE_LOW, ?LONG, ?PIE_HIGH | Acc0]; 
            true -> 
              [?LONG, ?PIE_LOW, ?SHORT, ?PIE_HIGH | Acc0] 
          end 
        end, 
        Acc,
        lists:seq(0, 15)
      ),
      R = lists:foldl(fun(I, Acc0) -> 
          if ((Cmd bsr (7-I)) band 1) =/= 0 ->
              [?SHORT, ?PIE_LOW, ?LONG, ?PIE_HIGH | Acc0]; 
            true ->
              [?LONG, ?PIE_LOW, ?SHORT, ?PIE_HIGH | Acc0] 
          end
        end,
        L,
        lists:seq(0, 7)
      ),
      [?LONG + 5000, ?PIE_LOW, ?SHORT, ?PIE_HIGH | R]
    end,
    [],
    lists:seq(0, 15)
  ),
  [LastWait | Msg1] = Msg0,
  lists:reverse([LastWait + 1000000 | Msg1]).
