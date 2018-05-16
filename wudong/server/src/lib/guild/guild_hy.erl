%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 帮派活跃度
%%% @end
%%% Created : 20. 一月 2017 上午11:41
%%%-------------------------------------------------------------------
-module(guild_hy).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("guild.hrl").

%% API
-compile(export_all).

%%获取仙盟活跃度排行榜
get_guild_hy_rank(Player) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    if
        Gkey == 0 -> skip;
        true ->
            case guild_ets:get_guild(Gkey) of
                false -> skip;
                _Guild ->
                    MemberList = guild_ets:get_guild_member_list(Gkey),
                    InfoList = [{M#g_member.name, M#g_member.position, M#g_member.sum_hy_val} || M <- MemberList],
                    InfoList1 = lists:reverse(lists:keysort(3, InfoList)),
                    InfoList2 = [tuple_to_list(Info) || Info <- InfoList1],
                    MyHyVal =
                        case guild_ets:get_guild_member(Player#player.key) of
                            false -> 0;
                            MyMem -> MyMem#g_member.sum_hy_val
                        end,
                    {ok, Bin} = pt_400:write(40071, {InfoList2, MyHyVal}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok
            end
    end.

get_notice_player(Player) ->
    case check_get_guild_hy_gift(Player) of
        {false, _Res} ->
            case guild_daily_gift:check_get_daily_gift(Player) of
                {false, _} ->
                    case guild_demon:check_get_demon_gift(Player, 0) of
                        {false, _} -> guild_manor:get_box_reward_state(Player);
                        {ok, _, []} -> guild_manor:get_box_reward_state(Player);
                        _ ->
                            1
                    end;
                _ ->
                    1
            end;
        _ ->
            1
    end.

%%领取每日活跃度奖励
get_guild_hy_gift(Player) ->
    case check_get_guild_hy_gift(Player) of
        {false, Res} ->
            {false, Res};
        {ok, Guild} ->
            Now = util:unixtime(),
            NewGuild = Guild#guild{
                hy_gift_time = Now
            },
            guild_ets:set_guild(NewGuild),
            GiveGoodsList = goods:make_give_goods_list(502, [{?GUILD_DAILY_HY_GIFT_ID, 1}]),
            goods:give_goods(Player, GiveGoodsList),
            activity:get_notice(Player, [92], true),
            ok
    end.
check_get_guild_hy_gift(Player) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    if
        Gkey == 0 -> {false, 0};
        true ->
            case guild_ets:get_guild(Gkey) of
                false -> {false, 0};
                Guild ->
                    if
                        Guild#guild.last_hy_key =/= Player#player.key -> {false, 802};
                        true ->
                            Now = util:unixtime(),
                            case util:is_same_date(Guild#guild.hy_gift_time, Now) of
                                true -> {false, 803};
                                false -> {ok, Guild}
                            end
                    end
            end
    end.

%%点赞
like_player(Player) ->
    case check_like_player(Player) of
        {false, Res} ->
            {false, Res};
        {ok, Member, Guild} ->
            Now = util:unixtime(),
            NewMember = Member#g_member{
                like_time = Now
            },
            NewGuild = Guild#guild{
                like_times = Guild#guild.like_times + 1
            },
            guild_ets:set_guild(NewGuild),
            guild_ets:set_guild_member(NewMember),
            ok
    end.
check_like_player(Player) ->
    Member = guild_ets:get_guild_member(Player#player.key),
    Guild = guild_ets:get_guild(Player#player.guild#st_guild.guild_key),
    if
        Member == false -> {false, 0};
        Guild == false -> {false, 0};
        true ->
            Now = util:unixtime(),
            case util:is_same_date(Now, Member#g_member.like_time) of
                true -> {false, 810};
                false -> {ok, Member, Guild}
            end
    end.

%%更新成员剑池活跃度
update_member_jc_hy(Pkey, NewJcHy) ->
    case guild_ets:get_guild_member(Pkey) of
        false -> skip;
        Member ->
            Now = util:unixtime(),
            update_calc_member_hy(Member#g_member{jc_hy_val = NewJcHy, jc_hy_time = Now})
    end.
%%更新计算成员活跃度
update_calc_member_hy(Member) ->
    Now = util:unixtime(),
    NewDailyDedicate = ?IF_ELSE(util:is_same_date(Now, Member#g_member.dedicate_time), Member#g_member.daily_dedicate, 0),
    NewJcHy = ?IF_ELSE(util:is_same_date(Now, Member#g_member.jc_hy_time), Member#g_member.jc_hy_val, 0),
    SumVal = round(NewDailyDedicate / 10 + NewJcHy),
    NewMem = Member#g_member{
        daily_dedicate = NewDailyDedicate,
        jc_hy_val = NewJcHy,
        jc_hy_time = Now,
        sum_hy_val = SumVal
    },
    guild_ets:set_guild_member(NewMem),
    NewMem.

%%获取活跃度top 1
get_first_hy(Gkey) ->
    MemberList = guild_ets:get_guild_member_list(Gkey),
    InfoList = [{M#g_member.pkey, M#g_member.sum_hy_val} || M <- MemberList],
    case lists:reverse(lists:keysort(2, InfoList)) of
        [] -> {0, 0};
        L -> hd(L)
    end.

