%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 三月 2017 15:59
%%%-------------------------------------------------------------------
-module(wybq_load).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("wybq.hrl").

%% API
-export([
    update/1,
    get_all/0,
    get_by_key/1
]).

update(StWybq) ->
    #st_wybq{pkey = Pkey, cbp = Cbp, cbp_list = CbpList, lv = Lv} = StWybq,
    CbpListBin = util:term_to_bitstring(CbpList),
    Sql = io_lib:format("replace into player_wybq set pkey=~p, cbp=~p, cbp_list='~s', lv = ~p", [Pkey, Cbp, CbpListBin, Lv]),
    db:execute(Sql),
    ok.

get_by_key(Pkey) ->
    Sql = io_lib:format("select a.nickname, a.career, a.sex, b.cbp, a.lv, b.cbp_list from player_state a, player_wybq b where a.pkey=b.pkey and a.pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [NickName, Career, Sex, Cbp, Lv, CbpListBin] ->
            CbpList = util:bitstring_to_term(CbpListBin),
            {NickName, Career, Sex, Cbp, Lv, CbpList};
        _Other ->
            []
    end.

get_all() ->
    Sql = io_lib:format("select pkey, cbp, cbp_list, Lv from player_wybq order by cbp desc limit 100", []),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([Pkey, Cbp, CbpListBin, Lv]) ->
                CbpList = util:bitstring_to_term(CbpListBin),
                EtsSysWybq = #ets_sys_wybq{pkey = Pkey, cbp = Cbp, cbp_list = CbpList, lv = Lv},
                ets:insert(?ETS_SYS_WYBQ, EtsSysWybq)
            end,
            lists:map(F, Rows);
        _ ->
            []
    end.
