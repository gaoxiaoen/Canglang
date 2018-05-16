%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 一月 2016 下午6:00
%%%-------------------------------------------------------------------
-module(rank_log).
-author("fengzhenlin").
-include("rank.hrl").

%% API
-export([
    log_rank/1
]).

log_rank(Type) ->
    RankList = rank:get_rank_top_N(Type, 100),
    case RankList == [] of
        true -> skip;
        false ->
            Now = util:unixtime(),
            Sql = io_lib:format("insert into log_rank (type,pkey,nickname,rank_data,rank,`time`,sex,vip,lv,guild_key,guild_name) VALUES ", []),
            F = fun(Rank, {AccSql, Num}) ->
                #a_rank{
                    rp = Rp,
                    rank = Order
                } = Rank,
                #rp{
                    pkey = Pkey,
                    nickname = Name,
                    sex = Sex,
                    vip = Vip,
                    lv = Lv,
                    guild_key = GuildKey
%%                    guild_name = GuildName
                } = Rp,
                {RankData1, _RankData2, _RankData3} = rank_handle:get_rank_data(Rank),
                case Num == 1 of
                    true ->
                        {io_lib:format("~s (~p,~p,'~s',~p,~p,~p,~p,~p,~p,~p,'~s')", [AccSql, Type, Pkey, Name, RankData1, Order, Now, Sex, Vip, Lv, GuildKey, ""]), Num + 1};
                    false ->
                        {io_lib:format("~s ,(~p,~p,'~s',~p,~p,~p,~p,~p,~p,~p,'~s')", [AccSql, Type, Pkey, Name, RankData1, Order, Now, Sex, Vip, Lv, GuildKey, ""]), Num + 1}
                end
                end,
            {Sql1, _Num1} = lists:foldl(F, {Sql, 1}, RankList),
            log_proc:log(Sql1)
    end,
    ok.

