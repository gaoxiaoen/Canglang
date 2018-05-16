%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 帮派每日福利
%%% @end
%%% Created : 23. 一月 2017 下午2:48
%%%-------------------------------------------------------------------
-module(guild_daily_gift).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("guild.hrl").

%% API
-compile(export_all).

%%获取每日福利奖励信息
get_daily_gift_info(Player) ->
    if
        Player#player.guild#st_guild.guild_key == 0 -> skip;
        true ->
            case guild_ets:get_guild(Player#player.guild#st_guild.guild_key) of
                false -> skip;
                Guild ->
                    Member = guild_ets:get_guild_member(Player#player.key),
                    #g_member{
                        daily_gift_get_time = GetTime
                    } = Member,
                    Now = util:unixtime(),
                    GetState = ?IF_ELSE(util:is_same_date(Now, GetTime), 2, 1),
                    BaseDG = data_guild_daily_gift:get(Guild#guild.lv),
                    #base_guild_daily_gift{
                        goods_list = GoodsList
                    } = BaseDG,
                    MaxLv = data_guild:max_lv(),
                    NextLv = min(MaxLv, Guild#guild.lv+1),
                    NextBaseDG = data_guild_daily_gift:get(NextLv),
                    #base_guild_daily_gift{
                        goods_list = NextGoodsList
                    } = NextBaseDG,
                    GoodsList1 = [tuple_to_list(Info) || Info<-GoodsList],
                    NextGoodsList1 = [tuple_to_list(Info) || Info<-NextGoodsList],
                    Data = {GetState, Guild#guild.lv, GoodsList1, NextLv, NextGoodsList1},
                    {ok, Bin} = pt_400:write(40075, Data),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok
            end
    end.

%%领取每日福利
get_daily_gift(Player) ->
    case check_get_daily_gift(Player) of
        {false, Res} ->
            {false, Res};
        {ok, BaseDG, Member} ->
            #base_guild_daily_gift{
                goods_list = GoodsList
            } = BaseDG,
            GiveGoodsList = goods:make_give_goods_list(503,GoodsList),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            NewMember = Member#g_member{
                daily_gift_get_time = util:unixtime()
            },
            guild_ets:set_guild_member(NewMember),
            activity:get_notice(Player, [92], true),
            {ok, NewPlayer}
    end.
check_get_daily_gift(Player) ->
    if
        Player#player.guild#st_guild.guild_key == 0 -> {false, 3};
        true ->
            case guild_ets:get_guild(Player#player.guild#st_guild.guild_key) of
                false -> {false, 3};
                Guild ->
                    case guild_ets:get_guild_member(Player#player.key) of
                        false -> {false, 3};
                        Member ->
                            Now = util:unixtime(),
                            case util:is_same_date(Now, Member#g_member.daily_gift_get_time) of
                                true -> {false, 803};
                                false ->
                                    BaseDG = data_guild_daily_gift:get(Guild#guild.lv),
                                    {ok, BaseDG, Member}
                            end
                    end
            end
    end.