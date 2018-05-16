%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 七月 2016 上午10:19
%%%-------------------------------------------------------------------
-module(guild_rank).
-author("fengzhenlin").
-include("server.hrl").
-include("guild.hrl").
-include("activity.hrl").
-include("common.hrl").

%% API
-export([
    get_info/1,
    reward/0,
    get_state/1,
    gm_reward/0
]).

-define(GUILD_RANK_GIFT, [29392, 29393, 29394]).

get_info(Player) ->
    MergeDay = config:get_merge_days(),
    if
        MergeDay > 4 -> skip;
        true ->
            GuildList = guild_util:get_guild_top_n_list(3),
            Len = length(GuildList),
            F = fun(Rank) ->
                    GiftId = lists:nth(Rank, ?GUILD_RANK_GIFT),
                    case Rank > Len of
                        true -> [Rank, GiftId, ?T("虚位以待"), 0];
                        false ->
                            Guild = lists:nth(Rank, GuildList),
                            [Rank, GiftId, Guild#guild.name, Guild#guild.cbp]
                    end
                end,
            GuildInfoList = lists:map(F, lists:seq(1, 3)),
            LeaveTime =
                case MergeDay > 3 of
                    true -> 0;
                    false -> 3*?ONE_DAY_SECONDS - ((MergeDay-1)*?ONE_DAY_SECONDS+(util:unixtime()-util:unixdate()))
                end,
            {ok, Bin} = pt_432:write(43221, {LeaveTime, GuildInfoList}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end.

reward() ->
    MergeDay = config:get_merge_days(),
    if
        MergeDay == 4 ->
            reward_helper();
        true ->
            skip
    end.

reward_helper() ->
    GuildList = guild_util:get_guild_top_n_list(3),
    F = fun(Guild, AccRank) ->
            GiftId = lists:nth(AccRank, ?GUILD_RANK_GIFT),
            MbList = guild_ets:get_guild_member_list(Guild#guild.gkey),
            MbKeyList = [Mb#g_member.pkey||Mb <- MbList],
            Title = ?T("仙盟争霸"),
            Msg = io_lib:format(?T("您所在的仙盟[~s]在合服仙盟争霸中获得第~p名,称霸全服指日可待!特发奖励如下,请查收!"),[Guild#guild.name,AccRank]),
            mail:sys_send_mail(MbKeyList, Title, Msg, [{GiftId, 1}]),
            F1= fun(Mb) ->
                    activity_log:log_get_gift(Mb#g_member.pkey,Mb#g_member.name,GiftId,1,174)
                end,
            lists:foreach(F1, MbList),
            AccRank + 1
        end,
    lists:foldl(F, 1, GuildList),
    ok.

get_state(_Player) ->
    MergeDay = config:get_merge_days(),
    if
        MergeDay == 0 -> -1;
        MergeDay > 4 -> -1;
        true -> 0
    end.

gm_reward() ->
    reward_helper().