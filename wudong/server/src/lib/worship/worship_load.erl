%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 三月 2016 上午11:20
%%%-------------------------------------------------------------------
-module(worship_load).
-author("fengzhenlin").
-include("worship.hrl").
-include("server.hrl").

%% API
-compile([export_all]).

dbget_worhisp() ->
    Sql = io_lib:format("select worship_list from worship order by `time` desc limit 1", []),
    case db:get_row(Sql) of
        [] ->
            #worship{
                worship_list = []
            };
        [WorshipListBin] ->
            F = fun({Type, Pkey, UpdateTime}) ->
                    #worship_player{
                        type = Type,
                        pkey = Pkey,
                        update_time = UpdateTime
                    }
                end,
            L = lists:map(F, util:bitstring_to_term(WorshipListBin)),
            #worship{
                worship_list = L
            }
    end.

dbup_worship(Worship) ->
    #worship{
        worship_list = List
    } = Worship,
    F = fun(WP) ->
            #worship_player{
                type = Type,
                pkey = Pkey,
                update_time = UpdateTime
            } = WP,
            {Type, Pkey, UpdateTime}
        end,
    L = lists:map(F, List),
    Sql = io_lib:format("insert into worship set worship_list = '~s', `time`=~p", [util:term_to_bitstring(L), util:unixtime()]),
    db:execute(Sql),
    ok.