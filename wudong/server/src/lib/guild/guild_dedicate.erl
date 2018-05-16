%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 帮派奉献
%%% @end
%%% Created : 27. 十月 2015 16:27
%%%-------------------------------------------------------------------
-module(guild_dedicate).
-author("hxming").

-include("guild.hrl").
-include("server.hrl").
-include("common.hrl").
-include("money.hrl").
-include("goods.hrl").
-include("daily.hrl").
-include("achieve.hrl").
%% API
-compile(export_all).

-define(XM_GOODS_ID,  1014000).   %%仙盟令物品id

-define(DAILY_GUILD_MAX_DEDICATE,  99999000).  %%仙盟每日奉献上限

%%获取奉献信息
get_guild_dedicate_info(Player) ->
    case guild_ets:get_guild(Player#player.guild#st_guild.guild_key) of
        false -> {0,0,0,[],10,1,0,0};
        Guild ->
            case guild_ets:get_guild_member(Player#player.key) of
                false ->
                    {0,0,0,[],10,1,0,0};
                Member ->
                    #g_member{
                        acc_dedicate = AccDed
                    } = Member,
                    #guild{
                        lv = Lv,
                        dedicate = GDed
                    } = Guild,
                    MaxLv = data_guild:max_lv(),
                    NextLv = min(MaxLv, Lv + 1),
                    Base = data_guild:get(NextLv),
                    #base_guild{
                        dedicate = NeedDed
                    } = Base,
                    %%获取每日奉献排行
                    DedRankList = get_daily_dedicate_rank(Guild),
                    BaseDed1 = data_guild_dedicate:get(1),
                    BaseDed2 = data_guild_dedicate:get(2),
                    DailyDedCount = daily:get_count(?DAILY_GUILD_GOLD_DEDICATE),
                    {AccDed, GDed, NeedDed, DedRankList,
                        BaseDed1#base_guild_dedicate.dedicate, BaseDed2#base_guild_dedicate.dedicate,
                        ?DAILY_GUILD_MAX_DEDICATE, DailyDedCount
                    }
            end
    end.

get_daily_dedicate_rank(Guild) ->
    MemberList = guild_ets:get_guild_member_list(Guild#guild.gkey),
    List = [{M#g_member.pkey,M#g_member.name, M#g_member.daily_dedicate}||M<-MemberList],
    List1 = lists:reverse(lists:keysort(3, List)),
    F = fun({K,N,D}, Order) ->
            {[Order,K,N,D], Order+1}
        end,
    {List2, _} = lists:mapfoldl(F, 1, List1),
    List2.

%%仙盟奉献
guild_dedicate(Player, GoodsNum, GoldNum) ->
    case check_guild_dedicate(Player, GoodsNum, GoldNum) of
        {false, Res} ->
            {Res, Player};
        {ok, Guild, Member} ->
            NewPlayer = ?IF_ELSE(GoldNum>0, money:add_no_bind_gold(Player, -GoldNum, 501, 0, 0), Player),
            ?DO_IF(GoodsNum>0, goods:subtract_good(Player, [{?XM_GOODS_ID, GoodsNum}], 501)),

            %%成员增加累加奉献值
            Base1 = data_guild_dedicate:get(1),
            Base2 = data_guild_dedicate:get(2),
            Add1 = round(Base1#base_guild_dedicate.dedicate*GoodsNum/10),
            Add2 = round(Base2#base_guild_dedicate.dedicate*GoldNum/10),
            SumAdd = Add1 + Add2,
            AccDedicate = Member#g_member.acc_dedicate + SumAdd,

            %%成员增加今日奉献值
            #g_member{
                daily_dedicate = DailyDedicate,
                dedicate_time = DedicateTime,
                leave_dedicate = LeaveDedicate
            } = Member,
            Now = util:unixtime(),
            Old = ?IF_ELSE(util:is_same_date(Now, DedicateTime), DailyDedicate, 0),
            NewDailyDedicate = Old + SumAdd,
            NewMember = Member#g_member{
                acc_dedicate = AccDedicate,
                leave_dedicate = LeaveDedicate + SumAdd,
                dedicate_time = Now,
                daily_dedicate = NewDailyDedicate
            },
            %%仙盟奉献值增加
            guild_add_dedicate(Guild, SumAdd),
            guild_ets:set_guild_member(NewMember),

            %%元宝每日奉献
            ?DO_IF(GoldNum > 0, daily:increment(?DAILY_GUILD_GOLD_DEDICATE, GoldNum)),
            %%更新成员每日活跃度
            guild_hy:update_calc_member_hy(NewMember),

            guild_load:log_guild_dedicate(Player#player.key, Player#player.nickname, Player#player.guild#st_guild.guild_key, GoodsNum, GoldNum, Now, SumAdd, AccDedicate, NewMember#g_member.leave_dedicate, ?T("物品/元宝奉献")),
            Player#player.pid ! {d_v_trigger, 10, 1},
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4010, 0, SumAdd),
            {1, NewPlayer};
        Err -> Err
    end.
check_guild_dedicate(Player, GoodsNum, GoldNum) ->
    case guild_ets:get_guild(Player#player.guild#st_guild.guild_key) of
        false -> {false, 3};
        Guild ->
            case guild_ets:get_guild_member(Player#player.key) of
                false -> {false, 5};
                Member ->
                    HaveGoodsNum = ?IF_ELSE(GoodsNum>0, goods_util:get_goods_count(?XM_GOODS_ID),0),
                    IsEnough = ?IF_ELSE(GoldNum >0, money:is_enough(Player, GoldNum, gold), true),
                    Count = daily:get_count(?DAILY_GUILD_GOLD_DEDICATE),
                    if
                        GoodsNum > HaveGoodsNum -> {false, 800};
                        not IsEnough -> {false, 801};
                        Count >= ?DAILY_GUILD_MAX_DEDICATE andalso GoldNum > 0 -> {false, 805};
                        Count + GoldNum > ?DAILY_GUILD_MAX_DEDICATE andalso GoldNum > 0 -> {false, 806};
                        true -> {ok, Guild, Member}
                    end
            end
    end.

%%帮派增加奉献经验
guild_add_dedicate(Guild, AddDed) ->
    NewGuild = guild_add_dedicate_helper(Guild, AddDed),
    guild_ets:set_guild(NewGuild),
    NewGuild.

guild_add_dedicate_helper(Guild, 0) -> Guild;
guild_add_dedicate_helper(Guild, AddDed) ->
    MaxLv = data_guild:max_lv(),
    #guild{
        lv = Lv,
        dedicate = Dedicate
    } = Guild,
    if
        Lv >= MaxLv -> Guild;
        true ->
            Base = data_guild:get(Lv + 1),
            #base_guild{
                dedicate = MaxDedicate
            } = Base,
            NewDed = AddDed + Dedicate,
            case NewDed >= MaxDedicate of
                true -> %%升级
                    NewGuild = Guild#guild{
                        lv = Lv + 1,
                        dedicate = 0
                    },
                    guild_add_dedicate_helper(NewGuild, NewDed - MaxDedicate);
                false ->
                    NewGuild = Guild#guild{
                        dedicate = NewDed
                    },
                    guild_add_dedicate_helper(NewGuild, 0)
            end
    end.

%%系统直接加帮派贡献
sys_add_guild_dedicate(Player, AddNum) ->
    if
        Player#player.guild#st_guild.guild_key == 0 -> {false, 0};
        true ->
            Guild = guild_ets:get_guild(Player#player.guild#st_guild.guild_key),
            Member = guild_ets:get_guild_member(Player#player.key),
            if
                Guild == false -> {false, 0};
                Member == false -> {false, 0};
                true ->
                    SumAdd = AddNum,
                    %%成员增加累加奉献值
                    AccDedicate = Member#g_member.acc_dedicate + SumAdd,

                    %%成员增加今日奉献值
                    #g_member{
                        daily_dedicate = DailyDedicate,
                        dedicate_time = DedicateTime,
                        leave_dedicate = LeaveDedicate
                    } = Member,
                    Now = util:unixtime(),
                    Old = ?IF_ELSE(util:is_same_date(Now, DedicateTime), DailyDedicate, 0),
                    NewDailyDedicate = Old + SumAdd,
                    NewMember = Member#g_member{
                        acc_dedicate = AccDedicate,
                        leave_dedicate = LeaveDedicate + SumAdd,
                        dedicate_time = Now,
                        daily_dedicate = NewDailyDedicate
                    },
                    %%仙盟奉献值增加
                    guild_add_dedicate(Guild, SumAdd),
                    guild_ets:set_guild_member(NewMember),
                    guild_load:log_guild_dedicate(Player#player.key, Player#player.nickname, Player#player.guild#st_guild.guild_key, 0, 0, Now, SumAdd, AccDedicate, NewMember#g_member.leave_dedicate, ?T("直接使用奉献物品"))
            end
    end.