%%%-------------------------------------------------------------------
%%% @doc
%%% 仙盟神兽
%%% @end
%%%  Created : 18. 十二月 2017 15:04
%%%-------------------------------------------------------------------
-module(guild_boss).
-author("Administrator").

-include("server.hrl").
-include("guild.hrl").
-include("scene.hrl").
-include("common.hrl").
-include("battle.hrl").
-include("daily.hrl").

%% API
-export([
    get_guild_boss_info/1,
    guild_boss_feeding/2,
    is_feeding_time/0,
    is_activity_time/0,
    create_boss/0,
    delete_boss/0,
    kill_boss/4,
    sp_call/1,
    init_guild_boss/0,
    send_boss_state/1,
    get_boss_state/1,
    get_boss_reward/1,
    get_state/1,
    get_feeding_state/1,
    get_boss_hp/1,
    reset_state/0,
    get_leave_time/0,
    get_boss_damage/1,
    update_boss_klist/4
]).

-define(GUILD_BOSS_FOOD, 7750001).  %% 道具id

-define(BOSS_X, 31).  %% boss召唤x坐标
-define(BOSS_Y, 66).  %% boss召唤y坐标


init_guild_boss() ->
    case is_activity_time() of
        false -> skip;
        true ->
            create_boss()
    end.


get_guild_boss_info(Player) ->
    GuildKey = Player#player.guild#st_guild.guild_key,
    Default = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, <<>>, []},
    if GuildKey == 0 -> Default;
        true ->
            case guild_ets:get_guild(GuildKey) of
                false ->
                    Default;
                Guild ->
                    case data_guild_boss:get(Guild#guild.boss_star, Guild#guild.lv) of
                        [] -> Default;
                        Base ->
                            #guild_boss_feeding{goods_exp = GoodsExp, gold_exp = GoldExp, gold_cost = GoldCost} = data_guild_boss_feed:get(),

                            case data_guild_boss:get(Guild#guild.boss_star + 1, Guild#guild.lv) of
                                [] ->
                                    {Guild#guild.boss_star,
                                        Guild#guild.boss_exp,
                                        Base#guild_boss.exp,
                                        GoodsExp,
                                        Base#guild_boss.mon_id,
                                        GoldCost,
                                        GoldExp,
                                        Base#guild_boss.sp_call_cost,
                                        Guild#guild.boss_star,
                                        Base#guild_boss.mon_id,
                                        Guild#guild.last_name,
                                        goods:pack_goods(Base#guild_boss.sp_call_reward)};
                                Base1 ->
                                    {Guild#guild.boss_star,
                                        Guild#guild.boss_exp,
                                        Base#guild_boss.exp,
                                        GoodsExp,
                                        Base#guild_boss.mon_id,
                                        GoldCost,
                                        GoldExp,
                                        Base1#guild_boss.sp_call_cost,
                                        Base1#guild_boss.star,
                                        Base1#guild_boss.mon_id,
                                        Guild#guild.last_name,
                                        goods:pack_goods(Base1#guild_boss.sp_call_reward)
                                    }
                            end
                    end
            end
    end.

guild_boss_feeding(Player, Type) ->
    GuildKey = Player#player.guild#st_guild.guild_key,
    if GuildKey == 0 -> {0, Player};
        true ->
            case guild_ets:get_guild(GuildKey) of
                false ->
                    {0, Player};
                Guild ->
                    case data_guild_boss:get(Guild#guild.boss_star, Guild#guild.lv) of
                        [] -> {0, Player};
                        _Base ->
                            MaxStar = data_guild_boss:get_max(),
                            ?DEBUG("Guild#guild.boss_state ~p~n", [Guild#guild.boss_state]),
                            if
                                MaxStar =< Guild#guild.boss_star ->
                                    {79, Player};
                                Guild#guild.boss_state =/= 0 ->
                                    {85, Player};
                                true ->
                                    IsFeedingTime = is_feeding_time(),
                                    if
                                        not IsFeedingTime -> {80, Player};
                                        true ->
                                            #guild_boss_feeding{goods_exp = GoodsExp, gold_exp = GoldExp, gold_cost = GoldCost, goods_lim = GooldsLim, gold_lim = GoldLim} = data_guild_boss_feed:get(),

                                            case Type of
                                                0 ->
                                                    DailyCount = daily:get_count(?DAILY_GUILD_BOSS_GOODS_FEEDING),
                                                    if
                                                        DailyCount >= GooldsLim -> {83, Player};
                                                        true ->
                                                            Count = goods_util:get_goods_count(?GUILD_BOSS_FOOD),
                                                            if
                                                                Count =< 0 -> {78, Player};
                                                                true ->
                                                                    goods:subtract_good(Player, [{?GUILD_BOSS_FOOD, 1}], 349),
                                                                    add_exp(Player#player.key, 1, Type, Guild, GoodsExp),
                                                                    daily:increment(?DAILY_GUILD_BOSS_GOODS_FEEDING, 1),
                                                                    {1, Player}
                                                            end
                                                    end;
                                                1 ->
                                                    DailyCount = daily:get_count(?DAILY_GUILD_BOSS_GOLD_FEEDING),
                                                    if
                                                        DailyCount >= GoldLim -> {84, Player};
                                                        true ->
                                                            case money:is_enough(Player, GoldCost, gold) of
                                                                false -> {801, Player};
                                                                true ->
                                                                    Newlayer = money:add_no_bind_gold(Player, -GoldCost, 349, 0, 0),
                                                                    add_exp(Player#player.key, GoldCost, Type, Guild, GoldExp),
                                                                    daily:increment(?DAILY_GUILD_BOSS_GOLD_FEEDING, 1),
                                                                    {1, Newlayer}
                                                            end
                                                    end;
                                                _ ->
                                                    {0, Player}
                                            end
                                    end
                            end
                    end
            end
    end.


add_exp(Pkey, Cost, Type, Guild, Exp) ->
    NewGuild = add_exp_help(Guild, Exp),
    guild_ets:set_guild_new(NewGuild#guild{is_change = 0}),
    guild_load:replace_guild(NewGuild),
    log_guild_boss_feeding(Pkey, Guild#guild.gkey, Cost, Type, Guild#guild.boss_star, Guild#guild.boss_exp, NewGuild#guild.boss_star, NewGuild#guild.boss_exp, Exp),
    ok.

add_exp_help(Guild, Exp) ->
    MaxStar = data_guild_boss:get_max(),
    if
        Guild#guild.boss_star >= MaxStar -> Guild;
        true ->
            case data_guild_boss:get(Guild#guild.boss_star, Guild#guild.lv) of
                [] ->
                    Guild;
                Base ->
                    if
                        Base#guild_boss.exp > Guild#guild.boss_exp + Exp ->
                            Guild#guild{boss_exp = Guild#guild.boss_exp + Exp};
                        true ->
                            NewExp = Guild#guild.boss_exp + Exp - Base#guild_boss.exp,
                            add_exp_help(Guild#guild{boss_star = Guild#guild.boss_star + 1, boss_exp = 0}, NewExp)
                    end
            end
    end.

is_feeding_time() ->
    {{_Year, _Month, _Day}, {Hour, Minute, _Second}} = calendar:now_to_local_time({util:unixtime() div 1000000, util:unixtime() rem 1000000, 0}),
    if
        Hour > ?GUILD_BOSS_OPEN_HOUR -> false;
        Hour == ?GUILD_BOSS_OPEN_HOUR andalso Minute >= ?GUILD_BOSS_OPEN_MINUTE -> false;
        true -> true
    end.

is_activity_time() ->
    {{_Year, _Month, _Day}, {Hour, Minute, _Second}} = calendar:now_to_local_time({util:unixtime() div 1000000, util:unixtime() rem 1000000, 0}),
    if
        Hour == ?GUILD_BOSS_OPEN_HOUR andalso Minute >= ?GUILD_BOSS_OPEN_MINUTE -> true;
        true -> false
    end.

get_leave_time() ->
    {{_Year, _Month, _Day}, {Hour, Minute, _Second}} = calendar:now_to_local_time({util:unixtime() div 1000000, util:unixtime() rem 1000000, 0}),
    if
        Hour == ?GUILD_BOSS_OPEN_HOUR andalso Minute >= ?GUILD_BOSS_OPEN_MINUTE ->
            (Minute - ?GUILD_BOSS_OPEN_MINUTE) * 60;
        true -> 0
    end.

get_state(_Player) ->
    case is_activity_time() of
        true -> 1;
        false -> 0
    end.

create_boss() ->
    GuildList = guild_ets:get_all_guild(),
    F = fun(Guild) ->
        {Star, Lv} =
            if Guild#guild.boss_state == 3 ->
                {Guild#guild.boss_star + 1, Guild#guild.lv};
                true ->
                    {Guild#guild.boss_star, Guild#guild.lv}
            end,
        case data_guild_boss:get(Star, Lv) of
            [] -> skip;
            Base ->
                case data_mon:get(Base#guild_boss.mon_id) of
                    [] -> skip;
                    BaseMon ->
                        if
                            Guild#guild.boss_state == 0 orelse Guild#guild.boss_state == 1 orelse Guild#guild.boss_state == 3 ->
                                Content = io_lib:format(t_tv:get(298), [BaseMon#mon.name]),
                                notice:add_sys_notice_guild(Content, 298, Guild#guild.gkey),%% 活动开始公告
                                mon_agent:create_mon_cast([Base#guild_boss.mon_id, ?SCENE_ID_GUILD, ?BOSS_X, ?BOSS_Y, Guild#guild.gkey, 1, [{guild_key, Guild#guild.gkey}]]),
                                NewGuild = Guild#guild{boss_state = max(1, Guild#guild.boss_state)},
                                ets:insert(?ETS_GUILD_BOSS_DAMAGE, #ets_g_boss{gkey = Guild#guild.gkey, mid = Base#guild_boss.mon_id}),
                                guild_ets:set_guild(NewGuild);
                            true -> skip
                        end
                end
        end
    end,
    lists:foreach(F, GuildList),
    ok.


kill_boss(Mon, Attacker, _Klist, _TotalHurt) ->
    case Mon#mon.scene == ?SCENE_ID_GUILD of
        false -> skip;
        true ->
            update_boss_klist(Mon, _Klist, Attacker#attacker.key, _TotalHurt),
            #mon{guild_key = Gkey, mid = Mid, name = Name} = Mon,
            if
                Gkey == 0 -> skip;
                true ->
                    case guild_ets:get_guild(Gkey) of
                        false ->
                            skip;
                        #guild{last_name = LastName} = Guild ->
                            case ets:lookup(?ETS_GUILD_BOSS_DAMAGE, Gkey) of
                                [] ->
                                    skip;
                                [Ets] ->
                                    DamageList = Ets#ets_g_boss.damage_list,
                                    case data_guild_boss:get(Mid) of
                                        [] ->
                                            skip;
                                        Base ->
                                            if
                                                Guild#guild.boss_state == 1 ->
                                                    {Title, Content0} = t_mail:mail_content(167),
                                                    Content = io_lib:format(Content0, [Name]);
                                                true ->
                                                    {Title, Content0} = t_mail:mail_content(171),
                                                    Content = io_lib:format(Content0, [LastName, Name])
                                            end,
                                            mail:sys_send_mail([Attacker#attacker.key], Title, Content, Base#guild_boss.kill_reward),

                                            F = fun(DamageInfo) ->
                                                if
                                                    Guild#guild.boss_state == 1 ->
                                                        {Title1, Content1} = t_mail:mail_content(168),
                                                        NewContent = io_lib:format(Content1, [Name, DamageInfo#g_boss_damage.rank]);
                                                    true ->
                                                        {Title1, Content1} = t_mail:mail_content(172),
                                                        NewContent = io_lib:format(Content1, [LastName, Name, DamageInfo#g_boss_damage.rank])
                                                end,
                                                log_guild_boss(DamageInfo#g_boss_damage.pkey, Gkey, Mid, DamageInfo#g_boss_damage.rank),
                                                RewardList = [Reward0 || {Up, Down, Reward0} <- Base#guild_boss.rank_list, Up =< DamageInfo#g_boss_damage.rank, Down >= DamageInfo#g_boss_damage.rank],
                                                if
                                                    RewardList == [] -> skip;
                                                    true ->
                                                        mail:sys_send_mail([DamageInfo#g_boss_damage.pkey], Title1, NewContent, hd(RewardList))
                                                end
                                            end,
                                            lists:foreach(F, DamageList),

                                            ?DEBUG("Guild#guild.boss_state ~p~n", [Guild#guild.boss_state]),
                                            if
                                                Guild#guild.boss_state == 1 ->
                                                    KillContent = io_lib:format(t_tv:get(299), [Attacker#attacker.name, Name]),
                                                    notice:add_sys_notice_guild(KillContent, 299, Guild#guild.gkey); %% 神兽击杀公告
                                                true ->
                                                    KillContent = io_lib:format(t_tv:get(301), [Attacker#attacker.name, LastName, Name]),
                                                    notice:add_sys_notice_guild(KillContent, 301, Guild#guild.gkey) %% 超级召唤击杀公告
                                            end,
                                            NewGuild = Guild#guild{boss_state = Guild#guild.boss_state + 1},
                                            guild_ets:set_guild_new(NewGuild#guild{is_change = 0}),
                                            guild_load:replace_guild(NewGuild),
                                            send_boss_state(Gkey)
                                    end
                            end
                    end
            end
    end.



delete_boss() ->
    DamageList = ets:tab2list(?ETS_GUILD_BOSS_DAMAGE),
    F = fun(DamageInfo) ->
        ?DEBUG("DamageInfo ~p~n", [DamageInfo]),
        case data_guild_boss:get(DamageInfo#ets_g_boss.mid) of
            [] -> skip;
            Base ->
                case data_mon:get(DamageInfo#ets_g_boss.mid) of
                    [] -> skip;
                    #mon{name = Name} ->
                        F0 = fun(GbossDamage) ->
                            {_, _, Reward} = lists:max(Base#guild_boss.rank_list),
                            case guild_ets:get_guild(DamageInfo#ets_g_boss.gkey) of
                                false ->
                                    skip;
                                Guild ->
                                    ?DEBUG("Guild#guild.boss_state ~p~n", [Guild#guild.boss_state]),
                                    if
                                        Guild#guild.boss_state == 1 ->
                                            RunContent = io_lib:format(t_tv:get(302), [Name]),
                                            notice:add_sys_notice_guild(RunContent, 302, Guild#guild.gkey),
                                            {Title, Content0} = t_mail:mail_content(170),
                                            Content = io_lib:format(Content0, [Name]),
                                            mail:sys_send_mail([GbossDamage#g_boss_damage.pkey], Title, Content, Reward);
                                        Guild#guild.boss_state == 3 ->
                                            RunContent = io_lib:format(t_tv:get(302), [Name]),
                                            notice:add_sys_notice_guild(RunContent, 302, Guild#guild.gkey),
                                            {Title, Content0} = t_mail:mail_content(173),
                                            Content = io_lib:format(Content0, [Guild#guild.last_name, Name]),
                                            mail:sys_send_mail([GbossDamage#g_boss_damage.pkey], Title, Content, Reward);
                                        true ->
                                            skip
                                    end
                            end
                        end,

                        lists:foreach(F0, DamageInfo#ets_g_boss.damage_list)
                end
        end
    end,
    lists:foreach(F, DamageList),
    ets:delete_all_objects(?ETS_GUILD_BOSS_DAMAGE),
    Ids = scene_copy_proc:get_scene_copy_ids(?SCENE_ID_GUILD),
%% 清除所有boss怪
    lists:foreach(fun(Copy) ->
        MonList = mon_agent:get_scene_mon_by_kind(?SCENE_ID_GUILD, Copy, ?MON_KIND_GUILD_BOSS),
        [monster:stop_broadcast(Mon#mon.pid) || Mon <- MonList]
    end, Ids),
    ok.

update_boss_klist(Mon, KList, _AttKey, _AttNode) ->
    if
        Mon#mon.scene =/= ?SCENE_ID_GUILD -> skip;
        Mon#mon.guild_key == 0 -> skip;
        true ->
            if
                Mon#mon.hp =< 0 ->
                    update_elite_boss_help(Mon, KList);
                true ->
                    Now = util:unixtime(),
                    Key = {update_elite_boss_klist, Mon#mon.guild_key},
                    case get(Key) of
                        undefined ->
                            put(Key, Now),
                            update_elite_boss_help(Mon, KList);
                        Time ->
                            case Now - Time >= 3 of
                                true ->
                                    put(Key, Now),
                                    update_elite_boss_help(Mon, KList);
                                false -> false
                            end
                    end
            end
    end.

update_elite_boss_help(Mon, KList) ->
    #mon{guild_key = GKey, mid = Mid} = Mon,
    case ets:lookup(?ETS_GUILD_BOSS_DAMAGE, GKey) of
        [] ->
            F = fun(StHatred) ->
                [#g_boss_damage{
                    pkey = StHatred#st_hatred.key,
                    name = StHatred#st_hatred.nickname,
                    damage = StHatred#st_hatred.hurt}]
            end,
            NewDamageList = lists:flatmap(F, KList),
            NewDamageList1 = sort_damage_list(NewDamageList),
            ets:insert(?ETS_GUILD_BOSS_DAMAGE, #ets_g_boss{gkey = GKey, mid = Mid, damage_list = NewDamageList1});
        [Ets] ->
            DamageList = Ets#ets_g_boss.damage_list,
%%             ?DEBUG("KList ~p~n", [KList]),
%%             ?DEBUG("DamageList ~p~n", [DamageList]),
            F = fun(#st_hatred{key = Pkey} = StHatred) ->
                case lists:keyfind(Pkey, #g_boss_damage.pkey, DamageList) of
                    false ->
                        [#g_boss_damage{
                            pkey = StHatred#st_hatred.key,
                            name = StHatred#st_hatred.nickname,
                            damage = StHatred#st_hatred.hurt}];
                    FDamage ->
                        [FDamage#g_boss_damage{damage = StHatred#st_hatred.hurt}]
                end
            end,
            NewDamageList = lists:flatmap(F, KList),
            NewDamageList1 = sort_damage_list(NewDamageList),
            ets:insert(?ETS_GUILD_BOSS_DAMAGE, Ets#ets_g_boss{damage_list = NewDamageList1, mid = Mid})
    end.

sort_damage_list(DamageList) ->
    NewDamageList0 = lists:reverse(lists:keysort(#g_boss_damage.damage, DamageList)),
    F = fun(DamageInfo, {Rank, List}) ->
        {Rank + 1, [DamageInfo#g_boss_damage{rank = Rank} | List]}
    end,
    {_, NewDamageList} = lists:foldl(F, {1, []}, NewDamageList0),
    NewDamageList.

sp_call(Player) ->
    GuildKey = Player#player.guild#st_guild.guild_key,
    case guild_ets:get_guild(GuildKey) of
        false ->
            {0, Player};
        Guild ->
            IsActicityTime = is_activity_time(),
            if
                Guild#guild.boss_state =/= 2 ->
                    {81, Player};
                not IsActicityTime -> %% 不在活动时间
                    {82, Player};
                true ->
                    Base =
                        case data_guild_boss:get(Guild#guild.boss_star + 1, Guild#guild.lv) of
                            [] ->
                                case data_guild_boss:get(Guild#guild.boss_star, Guild#guild.lv) of
                                    [] -> [];
                                    Base0 -> Base0
                                end;
                            Base1 -> Base1
                        end,
                    if
                        Base == [] -> {0, Player};
                        true ->
                            case money:is_enough(Player, Base#guild_boss.sp_call_cost, gold) of
                                false ->
                                    {801, Player};
                                true ->
                                    case data_mon:get(Base#guild_boss.mon_id) of
                                        [] -> {0, Player};
                                        BaseMon ->
                                            mon_agent:create_mon_cast([Base#guild_boss.mon_id, ?SCENE_ID_GUILD, ?BOSS_X, ?BOSS_Y, Guild#guild.gkey, 1, [{guild_key, Guild#guild.gkey}]]),
                                            NewGuild = Guild#guild{boss_state = 3, last_name = Player#player.nickname},
                                            guild_ets:set_guild(NewGuild),
                                            guild_load:replace_guild(NewGuild),
                                            NewPlayer = money:add_no_bind_gold(Player, - Base#guild_boss.sp_call_cost, 350, 0, 0),
%%                                          reset_ets(GuildKey),
                                            ets:insert(?ETS_GUILD_BOSS_DAMAGE, #ets_g_boss{gkey = Guild#guild.gkey, mid = Base#guild_boss.mon_id}),
                                            Content = io_lib:format(t_tv:get(300), [Player#player.nickname, BaseMon#mon.name]),
                                            notice:add_sys_notice_guild(Content, 300, Guild#guild.gkey),
                                            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(350, Base#guild_boss.sp_call_reward)),
                                            send_boss_state(GuildKey),
                                            {1, NewPlayer1}
                                    end
                            end
                    end
            end
    end.

reset_ets(GuildKey) ->
    ets:delete(?ETS_GUILD_BOSS_DAMAGE, GuildKey).
%%     case ets:lookup(?ETS_GUILD_BOSS_DAMAGE, GuildKey) of
%%         [] ->
%%             {false, 0};
%%         [Ets] ->
%%             ets:insert(?ETS_GUILD_BOSS_DAMAGE, Ets#ets_g_boss{damage_list = []})
%%     end.


get_boss_damage(Player) ->
    GuildKey = Player#player.guild#st_guild.guild_key,
    case ets:lookup(?ETS_GUILD_BOSS_DAMAGE, GuildKey) of
        [] ->
            {0, 0, []};
        [Ets] ->
            DamageList = Ets#ets_g_boss.damage_list,
            case lists:keyfind(Player#player.key, #g_boss_damage.pkey, DamageList) of
                false ->
                    MyRank = 0, MyDamage = 0;
                #g_boss_damage{rank = MyRank0, damage = MyDamage0} ->
                    MyRank = MyRank0, MyDamage = MyDamage0
            end,
            F = fun(#g_boss_damage{rank = Rank, name = Name, damage = Damage}) ->
                if
                    Rank /= 0 -> [[Rank, Name, Damage]];
                    true -> []
                end
            end,
            Prodata = lists:flatmap(F, DamageList),
            {MyRank, MyDamage, Prodata}
    end.


reset_state() ->
    GuildList = guild_ets:get_all_guild(),
    lists:foreach(fun(Guild) ->
        guild_ets:set_guild(Guild#guild{boss_star = 1, boss_exp = 0, boss_state = 0})
    end, GuildList),
    ok.

get_boss_reward(Player) ->
    GuildKey = Player#player.guild#st_guild.guild_key,
    LeaveTime = get_leave_time(),
    Default = {LeaveTime, [], []},
    if GuildKey == 0 -> Default;
        true ->
            case guild_ets:get_guild(GuildKey) of
                false ->
                    Default;
                Guild ->
                    case ets:lookup(?ETS_GUILD_BOSS_DAMAGE, GuildKey) of
                        [] ->
                            case data_guild_boss:get(Guild#guild.boss_star, Guild#guild.lv) of
                                [] -> Default;
                                Base ->
                                    {
                                        LeaveTime,
                                        goods:pack_goods(Base#guild_boss.kill_reward),
                                        [[Up, Down, goods:pack_goods(Reward)] || {Up, Down, Reward} <- Base#guild_boss.rank_list]
                                    }
                            end;
                        [Ets] ->
                            case data_guild_boss:get(Ets#ets_g_boss.mid) of
                                [] -> Default;
                                Base ->
                                    {
                                        LeaveTime,
                                        goods:pack_goods(Base#guild_boss.kill_reward),
                                        [[Up, Down, goods:pack_goods(Reward)] || {Up, Down, Reward} <- Base#guild_boss.rank_list]
                                    }
                            end
                    end
            end
    end.

get_boss_state(GuildKey) ->
    if
        GuildKey == 0 -> 0;
        true ->
            case guild_ets:get_guild(GuildKey) of
                false ->
                    0;
                Guild ->
                    Guild#guild.boss_state
            end
    end.

send_boss_state(Gkey) ->
    AllMember = guild_ets:get_guild_member_list(Gkey),
    Data = guild_boss:get_boss_state(Gkey),
    {ok, Bin} = pt_400:write(40056, {Data}),
    F = fun(#g_member{pkey = Pkey, is_online = IsOnline}) ->
        ?DO_IF(IsOnline == 1, server_send:send_to_key(Pkey, Bin))
    end,
    lists:map(F, AllMember),
    ok.

get_boss_hp(GuildKey) ->
    Default = {0, 0},
    IsActicityTime = is_activity_time(),
    if
        GuildKey == 0 -> Default;
        not IsActicityTime -> Default;
        true ->
            case guild_ets:get_guild(GuildKey) of
                false ->
                    Default;
                _Guild ->
                    case mon_agent:get_scene_mon_by_kind(?SCENE_ID_GUILD, GuildKey, ?MON_KIND_GUILD_BOSS) of
                        [] -> Default;
                        [Mon | _] ->
                            {Mon#mon.hp, Mon#mon.hp_lim}
                    end
            end
    end.


get_feeding_state(_Player) ->
    Count = goods_util:get_goods_count(?GUILD_BOSS_FOOD),
    if
        Count =< 0 -> 0;
        true ->

            1

    end.

log_guild_boss(Pkey, Gkey, Mid, Rank) ->
    Sql = io_lib:format("insert into log_guild_boss set  pkey=~p, gkey=~p, rank=~p, mid=~p,time=~p",
        [Pkey, Gkey, Rank, Mid, util:unixtime()]),
    log_proc:log(Sql).


log_guild_boss_feeding(Pkey, Gkey, Cost, Type, OldStar, OldExp, NewStar, NewExp, Exp) ->
    Sql = io_lib:format("insert into log_guild_boss_feeding set  pkey=~p,gkey=~p, cost=~p, type=~p, old_star=~p, old_exp=~p, new_star=~p, new_exp=~p,exp = ~p,time=~p",
        [Pkey, Gkey, Cost, Type, OldStar, OldExp, NewStar, NewExp, Exp, util:unixtime()]),
    log_proc:log(Sql).