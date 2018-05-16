%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2018 15:26
%%%-------------------------------------------------------------------
-module(guild_fight).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("guild.hrl").
-include("guild_fight.hrl").
-include("rank.hrl").
-include("scene.hrl").
-include("dungeon.hrl").
-include("arena.hrl").
-include("goods.hrl").

%% API
-export([
    sys_midnight_refresh/0, %% 公共进程凌晨刷新
    midnight_refresh/0, %% 玩家数据凌晨刷新
    update/0, %% 玩家自身数据更新
    get_medal/1, %% 读取玩家勋章
    guild_fight_challenge_ret/6, %% 公共进程处理对战结果
    guild_fight_challenge_player_ret/5, %% 玩家进程处理对战结果
    add_flag_exp/1, %% 旗帜加经验
    get_attrs/1, %% 获取公会旗帜加的属性
    clean_log_data/0, %% 48小时清除日志
    gm_add_guild_medal/2,
    add_guild_medal/2, %% 增加仙盟勋章
    update_to_db/0, %% 晚上1点写数据入库
    add_fail_medal/4, %% 挑战失败加勋章
    clean_fail_reward/0, %% 重置每日挑战失败获得勋章上线
    gm_clean_cd_time/0,
    get_guild_medal/1, %% 读取仙盟勋章
    get_act/0, %%对战双倍活动
    create_flag_mon/0, %% 创建旗帜怪物
    get_state/1,
    get_act_state/1
]).

-export([
    get_guild_fight_info/1, %% 读取对战信息
    get_guild_fight_info_cast/7,
    get_my_log/1, %% 读取我的日志
    get_guild_list/2, %% 读取公会列表
    challenge_guild/2, %% 更改仙盟触发
    challenge_guild_cast/3,
    challenge_player/2,
    recv_guild_fight/2, %% 领取对战奖励
    get_shop_info/1, %% 读取兑换商城数据
    exchange/3, %% 兑换
    get_lv_exp/1, %% 读取旗帜等级经验
    flag_up_lv/1, %% 旗帜升级
    get_lidi_info/1 %% 获取领地信息
]).

create_flag_mon() ->
    AllGuild = guild_ets:get_all_guild(),
    F = fun(#guild{gkey = Gkey}) ->
        FlagLv =
            case ets:lookup(?ETS_GUILD_FIGHT, Gkey) of
                [] -> 1;
                [#guild_fight{guild_flag_lv = Lv}] -> Lv
            end,
        {X, Y} = data_guild_fight_args:get_mon_xy(),
        #base_guild_flag{mon_id = MonId} = data_guild_flag:get(FlagLv),
        {Key, Pid} = mon_agent:create_mon([MonId, ?SCENE_ID_GUILD, X, Y, Gkey, 1, [{return_id_pid, true}]]),
        {Gkey, Key, Pid}
        end,
    lists:map(F, AllGuild).

get_act() ->
    case activity:get_work_list(data_act_guild_fight) of
        [] -> [];
        [Base | _] -> Base
    end.

get_guild_medal(GuildKey) ->
    case ets:lookup(?ETS_GUILD_FIGHT, GuildKey) of
        [] -> 0;
        [#guild_fight{medal = N}] -> N
    end.

gm_clean_cd_time() ->
    St = lib_dict:get(?PROC_STATUS_GUILD_FIGHT),
    lib_dict:put(?PROC_STATUS_GUILD_FIGHT, St#st_guild_fight{cd_time = 0}),
    ok.

clean_fail_reward() ->
    guild_fight_load:clean_fail_reward().

add_fail_medal(Player, AttName, AttPkey, AddMedal) ->
    St = lib_dict:get(?PROC_STATUS_GUILD_FIGHT),
    BaseFailReward = data_guild_fight_args:get_def_max_reward(),
    NewSt = St#st_guild_fight{fail_reward = min(BaseFailReward, St#st_guild_fight.fail_reward + AddMedal)},
    lib_dict:put(?PROC_STATUS_GUILD_FIGHT, NewSt),
    guild_fight_load:update_p(NewSt),
    if
        St#st_guild_fight.fail_reward >= BaseFailReward -> skip;
        true ->
            {Title, Content0} = t_mail:mail_content(174),
            Content = io_lib:format(Content0, [AttName]),
            mail:sys_send_mail([Player#player.key], Title, Content, [{?GOODS_ID_MEDAL, get_medal(AttPkey)}])
    end.

update_to_db() ->
    {{_Y, _M, _D}, {H, _Min, _S}} = erlang:localtime(),
    IsBug = config:is_debug(),
    if
        H /= 1 andalso IsBug == false -> skip;
        true ->
            RandSec = util:rand(10000, 1800000),
            timer:sleep(RandSec),
            AllList = ets:tab2list(?ETS_GUILD_FIGHT),
            F = fun(GuildFight) ->
                timer:sleep(50),
                guild_fight_load:update(GuildFight)
                end,
            lists:map(F, AllList)
    end,
    update_to_db2().

update_to_db2() ->
    {{_Y, _M, _D}, {H, _Min, _S}} = erlang:localtime(),
    IsBug = config:is_debug(),
    if
        H /= 2 andalso IsBug == false -> skip;
        true ->
            RandSec = util:rand(10000, 1800000),
            timer:sleep(RandSec),
            guild_fight_load:clean_guild_shadow(),
            AllList = ets:tab2list(?ETS_GUILD_FIGHT_SHADOW),
            F = fun(GuildFightShadow) ->
                timer:sleep(50),
                guild_fight_load:update_guild_shadow(GuildFightShadow)
                end,
            lists:map(F, AllList)
    end,
    ok.

add_guild_medal(Gkey, Num) ->
    case ets:lookup(?ETS_GUILD_FIGHT, Gkey) of
        [] -> ok;
        [R] ->
            NewR = R#guild_fight{medal = Num + R#guild_fight.medal},
            ets:insert(?ETS_GUILD_FIGHT, NewR),
            guild_fight_load:update(NewR)
    end.

gm_add_guild_medal(Gkey, Num) ->
    case ets:lookup(?ETS_GUILD_FIGHT, Gkey) of
        [] -> ok;
        [R] ->
            ets:insert(?ETS_GUILD_FIGHT, R#guild_fight{medal = Num})
    end.

get_lidi_info(Player) ->
    Guild = guild_ets:get_guild(Player#player.guild#st_guild.guild_key),
    #guild{
        gkey = Gkey,
        name = GName,
        lv = GuildLv,
        num = GuildNum,
        pkey = Pkey
    } = Guild,
    Shadow = shadow_proc:get_shadow(Pkey),
    case ets:lookup(?ETS_GUILD_FIGHT, Gkey) of
        [] -> FlagLv = 1;
        [#guild_fight{guild_flag_lv = FlagLv0}] -> FlagLv = FlagLv0
    end,
    #base_guild{max_num = GuildMaxNum} = data_guild:get(GuildLv),
    {GuildLv, FlagLv, GName, GuildNum, GuildMaxNum,
        Shadow#player.nickname, Shadow#player.career, Shadow#player.sex, Shadow#player.avatar}.

get_attrs(Player) ->
    case ets:lookup(?ETS_GUILD_FIGHT, Player#player.guild#st_guild.guild_key) of
        [] -> #attribute{};
        [#guild_fight{guild_flag_lv = FlagLv}] ->
            #base_guild_flag{attrs_list = AttrsList, z_attrs_list = ZAttrsList} = data_guild_flag:get(FlagLv),
            Attrs1 = attribute_util:make_attribute_by_key_val_list(AttrsList),
            Attrs2 = attribute_util:make_attribute_by_key_val_list(ZAttrsList),
            if
                Player#player.guild#st_guild.guild_position == ?GUILD_POSITION_CHAIRMAN ->
                    attribute_util:sum_attribute([Attrs1, Attrs2]);
                true ->
                    Attrs1
            end
    end.

clean_log_data() ->
    Now = util:unixtime(),
    EtsLogList = ets:tab2list(?ETS_GUILD_FIGHT_LOG),
    F = fun(#ets_guild_fight_log{challenge_time = Time} = Log) ->
        if
            Now - Time > 48 * 3600 -> ets:delete_object(?ETS_GUILD_FIGHT_LOG, Log);
            true -> skip
        end
        end,
    lists:map(F, EtsLogList),
    ok.

add_flag_exp(Player) ->
    if
        Player#player.scene /= ?SCENE_ID_GUILD -> Player;
        true ->
            {XMin, XMax, YMin, YMax} = data_guild_fight_args:get_x_y(),
            if
                Player#player.x >= XMin andalso Player#player.x =< XMax andalso Player#player.y >= YMin andalso Player#player.y =< YMax ->
                    AddExp = round(0.0273 * Player#player.lv * Player#player.lv - 1.9484 * Player#player.lv + 41.232) * 20,
                    player_util:add_exp(Player, AddExp, 26);
                true -> Player
            end
    end.

flag_up_lv(Player) ->
    if
        Player#player.guild#st_guild.guild_position /= ?GUILD_POSITION_CHAIRMAN -> {14, Player};
        true ->
            Guild = guild_ets:get_guild(Player#player.guild#st_guild.guild_key),
            case ets:lookup(?ETS_GUILD_FIGHT, Player#player.guild#st_guild.guild_key) of
                [] -> {15, Player};
                [#guild_fight{guild_flag_lv = Lv, guild_flag_exp = Exp, medal = Medal} = GuildFight] ->
                    GuildMaxLv = data_guild_flag:get_max_guild_lv(),
                    #base_guild_flag{guild_lv = GuildLvLimit} =
                        data_guild_flag:get(min(Lv + 1, GuildMaxLv)),
                    if
                        Lv == GuildMaxLv -> {21, Player};
                        Medal == 0 -> {15, Player};
                        GuildLvLimit > Guild#guild.lv -> {19, Player};
                        true ->
                            {NewLv, NewExp, RemainMedal} = cacl_lv(Lv, Exp, Medal),
                            NewGuildFight = GuildFight#guild_fight{guild_flag_exp = NewExp, guild_flag_lv = NewLv, medal = RemainMedal},
                            ets:insert(?ETS_GUILD_FIGHT, NewGuildFight),
                            if
                                NewLv == Lv -> skip;
                                true ->
                                    MemberList = guild_ets:get_guild_member_list(Player#player.guild#st_guild.guild_key),
                                    F = fun(#g_member{pid = Pid, is_online = IsOnline}) ->
                                        ?IF_ELSE(IsOnline == 1, Pid ! cacl_attr_guild_fight, skip)
                                        end,
                                    lists:map(F, MemberList),
                                    ?CAST(guild_fight_proc:get_server_pid(), {update_mon, Player#player.guild#st_guild.guild_key, NewLv})
                            end,
                            guild_fight_load:update(NewGuildFight),
                            {1, Player}
                    end
            end
    end.

cacl_lv(Lv, Exp, 0) -> {Lv, Exp, 0};

cacl_lv(Lv, Exp, Medal) ->
    #base_guild_flag{need_medal = NeedMedal} = data_guild_flag:get(Lv),
    if
        Medal + Exp >= NeedMedal ->
            {Lv + 1, 0, Medal + Exp - NeedMedal};
        true ->
            {Lv, Medal + Exp, 0}
    end.

get_lv_exp(Player) ->
    case ets:lookup(?ETS_GUILD_FIGHT, Player#player.guild#st_guild.guild_key) of
        [] ->
            AddExp = round(0.0273 * Player#player.lv * Player#player.lv - 1.9484 * Player#player.lv + 41.232) * 20,
            {1, 0, AddExp};
        [#guild_fight{guild_flag_lv = Lv, guild_flag_exp = Exp}] ->
            AddExp = round(0.0273 * Player#player.lv * Player#player.lv - 1.9484 * Player#player.lv + 41.232) * 20,
            {Lv, Exp, AddExp}
    end.

recv_guild_fight(Player, 0) -> {0, Player};

recv_guild_fight(Player, GuildNum) ->
    StGuildFight = lib_dict:get(?PROC_STATUS_GUILD_FIGHT),
    #st_guild_fight{
        recv_list = RecvList
    } = StGuildFight,
    case lists:member(GuildNum, RecvList) of
        true -> {8, Player};
        false ->
            case ets:lookup(?ETS_GUILD_FIGHT, Player#player.guild#st_guild.guild_key) of
                [] -> GuildSumLv = 0, AttGuildNum = 0, GuildKey = 0;
                [#guild_fight{guild_sum_lv = GuildSumLv0, guild_num = AttGuildNum0, gkey = GuildKey0}] ->
                    GuildSumLv = GuildSumLv0, AttGuildNum = AttGuildNum0, GuildKey = GuildKey0
            end,
            Reward = data_guild_fight_reward:get(GuildNum, GuildNum),
            if
                AttGuildNum < GuildNum -> {22, Player};
                true ->
                    Now = util:unixtime(),
                    GiveGoodsList = goods:make_give_goods_list(762, Reward),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    NewStGuildFight = StGuildFight#st_guild_fight{recv_list = [GuildNum | RecvList], op_time = Now},
                    lib_dict:put(?PROC_STATUS_GUILD_FIGHT, NewStGuildFight),
                    guild_fight_load:update_p(NewStGuildFight),
                    case guild_ets:get_guild(GuildKey) of
                        false -> GuildName = ?T("name");
                        #guild{name = GuildName0} -> GuildName = GuildName0
                    end,
                    Sql = io_lib:format("replace into log_guild_fight_box set pkey=~p, gkey=~p, guild_num=~p, guild_sum_lv=~p, gname='~s', time=~p, Reward='~s'",
                        [Player#player.key, GuildKey, GuildNum, GuildSumLv, GuildName, Now, util:term_to_bitstring(Reward)]),
                    log_proc:log(Sql),
                    {1, NewPlayer}
            end
    end.

challenge_guild_cast(MyGkey, Sid, GuildKey) ->
    case ets:lookup(?ETS_GUILD_FIGHT, MyGkey) of
        [] ->
            FightList = [{1, GuildKey, []}],
            NewGuildFight = #guild_fight{gkey = MyGkey, fight_list = FightList},
            guild_fight_load:update(NewGuildFight),
            ets:insert(?ETS_GUILD_FIGHT, NewGuildFight),
            {ok, Bin} = pt_447:write(44704, {1}),
            case guild_ets:get_guild(GuildKey) of
                false -> skip;
                DefGuild -> notice_sys:add_notice(att_guild_fight, [DefGuild#guild.name, MyGkey])
            end,
            server_send:send_to_sid(Sid, Bin);
        [#guild_fight{fight_list = FightList} = GuildFight] ->
            Code =
                case lists:keyfind(GuildKey, 2, FightList) of
                    false ->
                        BaseGuildNum = data_guild_fight_args:get_guild_max_num(),
                        if
                            length(FightList) >= BaseGuildNum -> 9;
                            true ->
                                NewFightList = [{length(FightList) + 1, GuildKey, []} | FightList],
                                NewGuildFight = GuildFight#guild_fight{fight_list = NewFightList},
                                guild_fight_load:update(NewGuildFight),
                                ets:insert(?ETS_GUILD_FIGHT, NewGuildFight),
                                case guild_ets:get_guild(GuildKey) of
                                    false -> skip;
                                    DefGuild -> notice_sys:add_notice(att_guild_fight, [DefGuild#guild.name, MyGkey])
                                end,
                                1
                        end;
                    _ -> 10
                end,
            {ok, Bin} = pt_447:write(44704, {Code}),
            server_send:send_to_sid(Sid, Bin)
    end.

challenge_guild(Player, GuildKey) ->
    ?CAST(guild_fight_proc:get_server_pid(), {challenge_guild, Player#player.guild#st_guild.guild_key, Player#player.sid, GuildKey}).

get_guild_list(_Player, ClientGuildLv) ->
    AllGuildList0 = ets:tab2list(?ETS_GUILD_FIGHT_SHADOW),
    Fsort = fun(#guild_fight_shadow{g_cbp = Cbp1}, #guild_fight_shadow{g_cbp = Cbp2}) -> Cbp1 > Cbp2 end,
    AllGuildList = lists:sort(Fsort, AllGuildList0),

    F0 = fun(#guild_fight_shadow{g_lv = Lv}, AccLv) -> max(Lv, AccLv) end,
    GuildMaxLv = lists:foldl(F0, 1, AllGuildList),
    F = fun(#guild_fight_shadow{gkey = Gkey, g_lv = GuildLv, g_name = GuildName, g_num = GuildNum}) ->
        BaseGuild = data_guild:get(GuildLv),
        if
            ClientGuildLv == GuildLv -> [[Gkey, GuildLv, GuildName, GuildNum, BaseGuild#base_guild.max_num]];
            GuildNum == 0 -> [];
            true -> []
        end
        end,
    List = lists:flatmap(F, AllGuildList),
    {GuildMaxLv, lists:sublist(List, 60)}.

get_my_log(Player) ->
    MyBaseMedal = get_medal(Player#player.key),
    EtsList = ets:tab2list(?ETS_GUILD_FIGHT_LOG),
    Now = util:unixtime(),
    F = fun(Log) ->
        #ets_guild_fight_log{
            att_pkey = AttKey,
            def_pkey = DefPkey,
            result = Result,
            challenge_time = ChallengeTime
        } = Log,
        if
            AttKey == Player#player.key ->
                Shadow = shadow_proc:get_shadow(DefPkey),
                [[
                    Shadow#player.key,
                    Shadow#player.nickname,
                    Shadow#player.career,
                    Shadow#player.sex,
                    Shadow#player.avatar,
                    Shadow#player.cbp,
                    Result,
                    get_medal(Shadow#player.key),
                    max(0, Now - ChallengeTime)
                ]];
            DefPkey == Player#player.key ->
                [[
                    Player#player.key,
                    Player#player.nickname,
                    Player#player.career,
                    Player#player.sex,
                    Player#player.avatar,
                    Player#player.cbp,
                    ?IF_ELSE(Result == 0, 3, 2),
                    get_medal(Player#player.key),
                    max(0, Now - ChallengeTime)
                ]];
            true -> []
        end
        end,
    NewLogList = lists:flatmap(F, EtsList),
    {MyBaseMedal, NewLogList}.

get_guild_fight_info(Player) ->
    St = lib_dict:get(?PROC_STATUS_GUILD_FIGHT),
    #st_guild_fight{recv_list = RecvList, cd_time = CdTime, challenge_num = ChallengeNum} = St,
    HasMedalNum = goods_util:get_goods_count(?GOODS_ID_MEDAL),
    Now = util:unixtime(),
    BaseCdTime = data_guild_fight_args:get_challenge_cd_time(),
    BaseChallengeNum = data_guild_fight_args:get_fight_max_win_num(),
    ?CAST(guild_fight_proc:get_server_pid(), {get_guild_fight_info, HasMedalNum, RecvList, Player#player.sid, Player#player.guild#st_guild.guild_key, max(0, CdTime + BaseCdTime - Now), max(0, BaseChallengeNum - ChallengeNum)}),
    ok.

get_guild_fight_info_cast(HasMedalNum, RecvList, Sid, MyGkey, CdTime, RemainChallengeNum, _State) ->
    case ets:lookup(?ETS_GUILD_FIGHT, MyGkey) of
        [] ->
            ProGuildList = [],
            ProGuildMedal = 0,
            ProGuildSumLv = 0,
            ProGuildFightNum = 0,
            F99 = fun(GuildNum) ->
                case lists:member(GuildNum, RecvList) of
                    true -> [GuildNum, 2];
                    false -> [GuildNum, 0]
                end
                  end,
            BaseGuildNum = data_guild_fight_args:get_guild_max_num(),
            ProRecvList = lists:map(F99, lists:seq(1, BaseGuildNum)),
            ProData = {HasMedalNum, ProGuildMedal, ProGuildSumLv, ProGuildFightNum, CdTime, RemainChallengeNum, ProRecvList, ProGuildList};
        [#guild_fight{fight_list = FightList, medal = Medal, guild_sum_lv = GuildSumLv, guild_num = GuildFightNum}] ->
            F = fun({Index, Gkey, FightMemberList}) ->
                case ets:lookup(?ETS_GUILD_FIGHT_SHADOW, Gkey) of
                    [] -> [];
                    [#guild_fight_shadow{g_sn = GSn, gkey = Gkey, g_name = GName, g_lv = GLv, member_list = ShadowMemberList}] ->
                        MaxChallengeNum = length(ShadowMemberList),
                        ChallengeNum = min(length(FightMemberList), MaxChallengeNum),
                        F99 = fun(Pkey) ->
                            PlayerShadow = shadow_proc:get_shadow(Pkey),
                            IsChallenge =
                                case lists:member(Pkey, FightMemberList) of
                                    true -> 0;
                                    false -> 1
                                end,
                            [Pkey,
                                PlayerShadow#player.nickname,
                                PlayerShadow#player.career,
                                PlayerShadow#player.sex,
                                PlayerShadow#player.avatar,
                                PlayerShadow#player.cbp,
                                get_medal(Pkey),
                                IsChallenge
                            ]
                              end,
                        PlayerList = lists:map(F99, ShadowMemberList),

                        GuildIcon =
                            case guild_ets:get_guild(Gkey) of
                                false -> 0;
                                Guild -> Guild#guild.icon
                            end,
                        [[ChallengeNum, MaxChallengeNum, Gkey, GSn, GName, GLv, GuildIcon, Index, PlayerList]]
                end
                end,
            ProGuildList = lists:flatmap(F, FightList),
            F99 = fun(GuildNum) ->
                case lists:member(GuildNum, RecvList) of
                    true -> [GuildNum, 2];
                    false ->
                        ?IF_ELSE(GuildFightNum < GuildNum, [GuildNum, 0], [GuildNum, 1])
                end
                  end,
            BaseGuildNum = data_guild_fight_args:get_guild_max_num(),
            ProRecvList = lists:map(F99, lists:seq(1, BaseGuildNum)),
            ProData = {HasMedalNum, Medal, GuildSumLv, GuildFightNum, CdTime, RemainChallengeNum, ProRecvList, ProGuildList}
    end,
    {ok, Bin} = pt_447:write(44701, ProData),
    server_send:send_to_sid(Sid, Bin).

sys_midnight_refresh() ->
    ?CAST(guild_fight_proc:get_server_pid(), midnight_refresh),
    ok.

midnight_refresh() ->
    midnight_refresh_update().

midnight_refresh_update() ->
    StGuildFight = lib_dict:get(?PROC_STATUS_GUILD_FIGHT),
    #st_guild_fight{op_time = OpTime, shop = Shop} = StGuildFight,
    Now = util:unixtime(),
    case util:is_same_date(Now, OpTime) of
        true ->
            NewStGuildFight = StGuildFight;
        false ->
            NewStGuildFight =
                StGuildFight#st_guild_fight{
                    challenge_num = 0,
                    op_time = Now,
                    recv_list = [],
                    shop = refresh_shop(Shop),
                    fail_reward = 0
                }
    end,
    lib_dict:put(?PROC_STATUS_GUILD_FIGHT, NewStGuildFight).

update() ->
    StGuildFight = lib_dict:get(?PROC_STATUS_GUILD_FIGHT),
    #st_guild_fight{op_time = OpTime, shop = Shop} = StGuildFight,
    Now = util:unixtime(),
    case util:is_same_date(Now, OpTime) of
        true ->
            NewStGuildFight = StGuildFight;
        false ->
            NewStGuildFight =
                StGuildFight#st_guild_fight{
                    challenge_num = 0,
                    op_time = Now,
                    recv_list = [],
                    shop = refresh_shop(Shop)
                }
    end,
    lib_dict:put(?PROC_STATUS_GUILD_FIGHT, NewStGuildFight).

refresh_shop(Shop) ->
    Week = util:get_day_of_week(),
    {{_Y, _M, Day}, {_H, _Min, _S}} = erlang:localtime(),
    F = fun({GoodsId, _BuyTime} = R) ->
        case data_guild_fight_exchange:get_refresh_type(GoodsId) of
            [] -> [R];
            1 -> []; %% 每日重置
            2 -> ?IF_ELSE(Week == 1, [R], []); %% 每周1重置
            3 -> ?IF_ELSE(Day == 1, [R], []); %% 每月1号重置
            4 -> [R]; %% 永久不重置
            5 -> [R] %% 永久不重置
        end
        end,
    lists:flatmap(F, Shop).

get_medal(Pkey) ->
    Rank = rank:get_my_rank(Pkey, ?RANK_TYPE_CBP),
    if
        Rank == 0 -> get_medal2(Pkey);
        true ->
            case data_guild_medal_reward:get(Rank) of
                0 -> get_medal2(Pkey);
                Medal -> Medal
            end
    end.

get_medal2(Pkey) ->
    Now = util:unixtime(),
    case get({guild_fight, get_medal2}) of
        {Cbp100, Time} when Now - Time < 3600 ->
            Cbp100;
        _ ->
            List = rank:get_rank_top_N(?RANK_TYPE_CBP, 100),
            Member = hd(lists:reverse(List)),
            Cbp100 = Member#a_rank.rp#rp.cbp,
            put({guild_fight, get_medal2}, {Cbp100, Now})
    end,
    ShadowPlayer = shadow_proc:get_shadow(Pkey),
    Cbp = ShadowPlayer#player.cbp,
    Percent = Cbp * 100 div Cbp100,
    max(data_guild_medal_reward100:get(Percent), 1).



challenge_player(Player, Pkey) ->
    case ets:lookup(?ETS_GUILD_FIGHT, Player#player.guild#st_guild.guild_key) of
        [] ->
            {ok, Bin} = pt_447:write(44705, {0, 0}),
            server_send:send_to_sid(Player#player.sid, Bin);
        [#guild_fight{fight_list = FightList, challenge_pkey_cache = ChallengePkeyList} = GuildFight] ->
            F = fun({_Index, _Gkey, MemberKeyList}) ->
                case lists:member(Pkey, MemberKeyList) of
                    false -> [];
                    true -> [1]
                end
                end,
            LL = lists:flatmap(F, FightList),
            if
                LL /= [] ->
                    {ok, Bin} = pt_447:write(44705, {11, 0}),
                    server_send:send_to_sid(Player#player.sid, Bin);
                true ->
                    Now = util:unixtime(),
                    case lists:keytake(Pkey, 1, ChallengePkeyList) of
                        false ->
                            challenge_player2(Player, Pkey, GuildFight, ChallengePkeyList);
                        {value, {Pkey, T0}, Rest} when Now - T0 > 30 ->
                            challenge_player2(Player, Pkey, GuildFight, Rest);
                        _Other ->
                            {ok, Bin} = pt_447:write(44705, {20, 0}),
                            server_send:send_to_sid(Player#player.sid, Bin)
                    end
            end
    end.

challenge_player2(Player, Pkey, GuildFight, ChallengePkeyList) ->
    St = lib_dict:get(?PROC_STATUS_GUILD_FIGHT),
    #st_guild_fight{cd_time = CdTime, challenge_num = ChallengeNum} = St,
    IsNormalScene = scene:is_normal_scene(Player#player.scene),
    IsGuildScene = scene:is_guild_scene(Player#player.scene),
    Now = util:unixtime(),
    BaseCdTime = data_guild_fight_args:get_challenge_cd_time(),
    BaseChallengeNum = data_guild_fight_args:get_fight_max_win_num(),
    Ret =
        if
            Player#player.key == Pkey -> 2;
            Player#player.convoy_state > 0 -> 3;
            Player#player.marry#marry.cruise_state > 0 -> 6;
            IsNormalScene == false andalso IsGuildScene == false -> 4;
            Now - CdTime < BaseCdTime -> 13;
            ChallengeNum >= BaseChallengeNum -> 12;
            true ->
                PlayerList = [dungeon_util:make_dungeon_mb(Player, Now)],
                %%创建对手
                Shadow = shadow_proc:get_shadow(Pkey),
                %%创建竞技场挑战副本
                MbInfo1 = #dun_arena{type = 1, pkey = Player#player.key, nickname = Player#player.nickname, career = Player#player.career, sex = Player#player.sex, avatar = Player#player.avatar, hp_lim = Player#player.attribute#attribute.hp_lim, cbp = Player#player.cbp},
                MbInfo2 = #dun_arena{type = 0, pkey = Shadow#player.key, nickname = Shadow#player.nickname, career = Shadow#player.career, sex = Shadow#player.sex, avatar = Shadow#player.avatar, hp_lim = Shadow#player.attribute#attribute.hp_lim, cbp = Shadow#player.cbp},
                Pid = dungeon:start(PlayerList, ?SCENE_ID_GUILD_FIGHT, Now, [{arena, [MbInfo1, MbInfo2]}]),
                [{X1, Y1}, {X2, Y2}, {X3, Y3}] = ?ARENA_POS_LIST,
                shadow:create_shadow_for_arena(Player#player{attribute = Player#player.attribute#attribute{att_area = 99}}, ?SCENE_ID_GUILD_FIGHT, Pid, X1, Y1, 0),
                shadow:create_shadow_for_arena(Shadow#player{attribute = Shadow#player.attribute#attribute{att_area = 99}}, ?SCENE_ID_GUILD_FIGHT, Pid, X2, Y2, 1),
                Player#player.pid ! {change_scene, ?SCENE_ID_GUILD_FIGHT, Pid, X3, Y3, false},
                NewGuildFight = GuildFight#guild_fight{challenge_pkey_cache = [{Pkey, Now} | ChallengePkeyList]},
                ets:insert(?ETS_GUILD_FIGHT, NewGuildFight),
                1
        end,
    DungeonTime = dungeon_util:get_dungeon_time(?SCENE_ID_GUILD_FIGHT),
    {ok, Bin} = pt_447:write(44705, {Ret, DungeonTime}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

guild_fight_challenge_ret(AttPkey, _AttName, DefPkey, _DefName, Ret, State) ->
    #sys_guild_fight{shadow_player_key_list = ShadowPlayerList} = State,
    AttMember = guild_ets:get_guild_member(AttPkey),
    #g_member{gkey = AttGkey} = AttMember,
    DefGkey =
        case lists:keyfind(DefPkey, 1, ShadowPlayerList) of
            false ->
                DefMember = guild_ets:get_guild_member(DefPkey),
                #g_member{gkey = DefGkey0} = DefMember,
                DefGkey0;
            {_Pkey, DefGkey0} -> DefGkey0
        end,
    DefGuildName =
        case ets:lookup(?ETS_GUILD_FIGHT_SHADOW, DefGkey) of
            [] -> <<>>;
            [#guild_fight_shadow{g_name = DefGuildName0}] -> DefGuildName0
        end,
    case ets:lookup(?ETS_ONLINE, AttPkey) of
        [] -> skip;
        [#ets_online{pid = Pid}] ->
            Pid ! {guild_fight_challenge_ret, AttPkey, _AttName, DefPkey, _DefName, Ret}
    end,
    %% 处理挑战失败的情况
    spawn(fun() -> fail_op(AttPkey, _AttName, DefPkey, Ret) end),
    if
        Ret == 0 ->
            case ets:lookup(?ETS_GUILD_FIGHT, AttGkey) of
                [] -> skip;
                [GuildFight] ->
                    #guild_fight{
                        challenge_pkey_cache = ChallengePkeyCache
                    } = GuildFight,
                    NewChallengePkeyCache =
                        case lists:keytake(DefPkey, 1, ChallengePkeyCache) of
                            false -> ChallengePkeyCache;
                            {value, _, Rest0} -> Rest0
                        end,
                    NewGuildFight =
                        GuildFight#guild_fight{
                            challenge_pkey_cache = NewChallengePkeyCache
                        },
                    guild_fight_load:update(NewGuildFight),
                    ets:insert(?ETS_GUILD_FIGHT, NewGuildFight)
            end;
        true ->
            case ets:lookup(?ETS_GUILD_FIGHT, AttGkey) of
                [] -> skip;
                [GuildFight] ->
                    #guild_fight{
                        medal = Medal,
                        guild_sum_lv = GuildSumLv,
                        guild_num = GuildNum,
                        fight_list = FightList,
                        challenge_pkey_cache = ChallengePkeyCache
                    } = GuildFight,
                    case lists:keytake(DefGkey, 2, FightList) of
                        false ->
                            NewFightList = FightList,
                            NewGuildSumLv = GuildSumLv,
                            NewGuildNum = GuildNum;
                        {value, {Index, DefGkey, FightMemberList}, Rest1} ->
                            NewFightMemberList = util:list_filter_repeat([DefPkey | FightMemberList]),
                            NewFightList = [{Index, DefGkey, NewFightMemberList} | Rest1],
                            {NewGuildSumLv, NewGuildNum} = cacl_guild_sum_lv(NewFightList)
                    end,
                    NewChallengePkeyCache =
                        case lists:keytake(DefPkey, 1, ChallengePkeyCache) of
                            false -> ChallengePkeyCache;
                            {value, _, Rest0} -> Rest0
                        end,
                    AddGuildMedal =
                        case get_act() of
                            [] -> get_medal(DefPkey);
                            _ -> get_medal(DefPkey) * 2
                        end,
                    NewGuildFight =
                        GuildFight#guild_fight{
                            fight_list = NewFightList,
                            medal = Medal + AddGuildMedal,
                            guild_sum_lv = NewGuildSumLv,
                            guild_num = NewGuildNum,
                            challenge_pkey_cache = NewChallengePkeyCache
                        },
                    guild_fight_load:update(NewGuildFight),
                    ets:insert(?ETS_GUILD_FIGHT, NewGuildFight),
                    ?IF_ELSE(NewGuildNum /= GuildNum, notice_sys:add_notice(def_guild_fight, [DefGuildName, AttGkey]), skip)
            end
    end.

fail_op(_AttPkey, _AttName, _DefPkey, 1) ->
    ok;
fail_op(AttPkey, _AttName, DefPkey, 0) ->
    case ets:lookup(?ETS_ONLINE, DefPkey) of
        [] ->
            BaseFailReward = data_guild_fight_args:get_def_max_reward(),
            StGuildFight = guild_fight_load:load_p(DefPkey),
            NewStGuildFight = StGuildFight#st_guild_fight{fail_reward = min(BaseFailReward, StGuildFight#st_guild_fight.fail_reward + get_medal(AttPkey))},
            guild_fight_load:update_p(NewStGuildFight),
            if
                StGuildFight#st_guild_fight.fail_reward >= BaseFailReward -> skip;
                true ->
                    {Title, Content0} = t_mail:mail_content(174),
                    Content = io_lib:format(Content0, [_AttName]),
                    mail:sys_send_mail([DefPkey], Title, Content, [{?GOODS_ID_MEDAL, get_medal(AttPkey)}])
            end;
        [#ets_online{pid = Pid}] -> Pid ! {add_fail_medal, _AttName, get_medal(AttPkey), AttPkey}
    end.

cacl_guild_sum_lv(FightList) ->
    F = fun({_Index, Gkey, FightMemberList}) ->
        case ets:lookup(?ETS_GUILD_FIGHT_SHADOW, Gkey) of
            [] ->
                [];
            [#guild_fight_shadow{member_list = MemberList, g_lv = GuildLv}] ->
                if
                    MemberList == [] -> [];
                    true ->
                        Flag = length(FightMemberList) * 100 div length(MemberList),
                        Percent = data_guild_fight_args:get_win_percent(),
                        if
                            Flag >= Percent -> [GuildLv];
                            true -> []
                        end
                end
        end
        end,
    L = lists:flatmap(F, FightList),
    {lists:sum(L), length(L)}.

guild_fight_challenge_player_ret(Player, _AttName, DefPkey, _DefName, Ret) ->
    StGuildFight = lib_dict:get(?PROC_STATUS_GUILD_FIGHT),
    #st_guild_fight{
        challenge_num = ChallengeNum
    } = StGuildFight,
    NewStGuildFight =
        StGuildFight#st_guild_fight{
            challenge_num = ?IF_ELSE(Ret == 1, ChallengeNum + 1, ChallengeNum),
            cd_time = util:unixtime()
        },
    lib_dict:put(?PROC_STATUS_GUILD_FIGHT, NewStGuildFight),
    guild_fight_load:update_p(NewStGuildFight),
    case Ret == 0 of
        true ->
            ProReward = [], NewRewardList = [];
        false ->
            case data_guild_fight_player_reward:get(Player#player.lv) of
                {_RanNum, []} ->
                    NewRewardList =
                        case guild_fight:get_act() of
                            [] -> [{?GOODS_ID_MEDAL, get_medal(DefPkey)}];
                            _ -> [{?GOODS_ID_MEDAL, get_medal(DefPkey) * 2}]
                        end,
                    ProReward = util:list_tuple_to_list(NewRewardList);
                {RandNum, RandRewardList} ->
                    RandRewardList99 =
                        lists:map(fun({Gid, GNum, Power}) -> {{Gid, GNum}, Power} end, RandRewardList),
                    F = fun(_N) ->
                        util:list_rand_ratio(RandRewardList99)
                        end,
                    RewardList = lists:map(F, lists:seq(1, RandNum)),
                    NewRewardList =
                        case guild_fight:get_act() of
                            [] -> [{?GOODS_ID_MEDAL, get_medal(DefPkey)} | RewardList];
                            _ -> [{?GOODS_ID_MEDAL, get_medal(DefPkey) * 2} | RewardList]
                        end,
                    ProReward = util:list_tuple_to_list(NewRewardList)
            end
    end,
    {ok, Bin} = pt_447:write(44708, {Ret, ProReward}),
    server_send:send_to_sid(Player#player.sid, Bin),
    GiveGoodsList = goods:make_give_goods_list(763, NewRewardList),
    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
    {ok, NewPlayer}.

count_goods_buy_times(TargetGoodsId, Shop) ->
    F = fun({Id, BuyNum}) ->
        {GoodsId, _GoodsNum} = data_guild_fight_exchange:get(Id),
        if
            GoodsId == TargetGoodsId -> [BuyNum];
            true -> []
        end
        end,
    lists:sum(lists:flatmap(F, Shop)).

get_shop_info(Player) ->
    St = lib_dict:get(?PROC_STATUS_GUILD_FIGHT),
    #st_guild_fight{shop = Shop} = St,
    ?DEBUG("Shop:~p", [Shop]),
    AllIds = data_guild_fight_exchange:get_all(),
    Guild = guild_ets:get_guild(Player#player.guild#st_guild.guild_key),
    F = fun(Id) ->
        {GoodsId, GoodsNum} = data_guild_fight_exchange:get(Id),
        BuyTime0 = data_guild_fight_exchange:get_buy_time(Id),
        BuyTime =
            case check_gold(Id, Shop) of
                true ->
                    BuyTime0;
                false ->
                    0
            end,
        Cost = data_guild_fight_exchange:get_cost(Id),
        BaseGuildLv = data_guild_fight_exchange:get_guild_lv_limit(Id),
        if
            GoodsId == 7501100 ->
                SumBuyTime = count_goods_buy_times(GoodsId, Shop),
                RemainBuyTime = max(0, BuyTime - SumBuyTime);
            true ->
                case lists:keyfind(Id, 1, Shop) of
                    false -> RemainBuyTime = BuyTime;
                    {Id, OldBuyTime} ->
                        RefreshType = data_guild_fight_exchange:get_refresh_type(Id),
                        if
                            RefreshType == 5 -> RemainBuyTime = BuyTime;
                            true -> RemainBuyTime = max(0, BuyTime - OldBuyTime)
                        end
                end
        end,
        ?IF_ELSE(Guild#guild.lv == BaseGuildLv, [[Id, GoodsId, GoodsNum, Cost, RemainBuyTime]], [])
        end,
    lists:flatmap(F, AllIds).

check_exchange(Player) ->
    Now = util:unixtime(),
    if
        Now < 1524585599 -> true;
        true ->
            case cache:get({guild_quit, Player#player.key}) of
                QuitTime when is_integer(QuitTime) ->
                    ?IF_ELSE(Now - QuitTime > ?ONE_DAY_SECONDS, true, false);
                _ -> true
            end
    end.

exchange(_Id, Player, 0) ->
    {0, Player};

exchange(Id, Player, BuyTime) ->
    StGuildFight = lib_dict:get(?PROC_STATUS_GUILD_FIGHT),
    #st_guild_fight{
        shop = Shop
    } = StGuildFight,
    Cost = data_guild_fight_exchange:get_cost(Id),
    HasMedalNum = goods_util:get_goods_count(?GOODS_ID_MEDAL),
    BaseBuyTime = data_guild_fight_exchange:get_buy_time(Id),
    RefreshType = data_guild_fight_exchange:get_refresh_type(Id),
    Now = util:unixtime(),
    Guild = guild_ets:get_guild(Player#player.guild#st_guild.guild_key),
    BaseGuildLv = data_guild_fight_exchange:get_guild_lv_limit(Id),
    if
        Guild#guild.lv < BaseGuildLv -> {0, Player};
        Cost == 0 orelse Cost == [] -> {0, Player};
        Cost > HasMedalNum -> {18, Player};
        BuyTime > BaseBuyTime -> {17, Player};
        true ->
            case check_exchange(Player) of
                false -> {24, Player};
                true ->
                    case check_gold(Id, Shop) of
                        false -> {0, Player};
                        true ->
                            case lists:keytake(Id, 1, Shop) of
                                false ->
                                    {GoodsId, GoodsNum} = data_guild_fight_exchange:get(Id),
                                    {ok, _} = goods:subtract_good(Player, [{?GOODS_ID_MEDAL, Cost}], 764),
                                    GiveGoodsList = goods:make_give_goods_list(765, [{GoodsId, GoodsNum}]),
                                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                                    NewStGuildFight =
                                        StGuildFight#st_guild_fight{
                                            shop = [{Id, BuyTime} | Shop],
                                            op_time = Now
                                        },
                                    lib_dict:put(?PROC_STATUS_GUILD_FIGHT, NewStGuildFight),
                                    guild_fight_load:update_p(NewStGuildFight),
                                    Sql = io_lib:format("replace into log_guild_fight_exchange set pkey=~p, goods_id=~p, goods_num=~p, cost='~s', time=~p",
                                        [Player#player.key, GoodsId, GoodsNum, util:term_to_bitstring([{?GOODS_ID_MEDAL, Cost}]), Now]),
                                    log_proc:log(Sql),
                                    {1, NewPlayer};
                                {value, {Id, OldBuyTime}, Rest} ->
                                    if
                                        BuyTime + OldBuyTime > BaseBuyTime andalso RefreshType /= 5 -> {17, Player};
                                        true ->
                                            {GoodsId, GoodsNum} = data_guild_fight_exchange:get(Id),
                                            {ok, _} = goods:subtract_good(Player, [{?GOODS_ID_MEDAL, Cost}], 764),
                                            GiveGoodsList = goods:make_give_goods_list(765, [{GoodsId, GoodsNum}]),
                                            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                                            NewStGuildFight =
                                                StGuildFight#st_guild_fight{
                                                    shop = [{Id, BuyTime + OldBuyTime} | Rest],
                                                    op_time = Now
                                                },
                                            lib_dict:put(?PROC_STATUS_GUILD_FIGHT, NewStGuildFight),
                                            guild_fight_load:update_p(NewStGuildFight),
                                            Sql = io_lib:format("replace into log_guild_fight_exchange set pkey=~p, goods_id=~p, goods_num=~p, cost='~s', time=~p",
                                                [Player#player.key, GoodsId, GoodsNum, util:term_to_bitstring([{?GOODS_ID_MEDAL, Cost}]), Now]),
                                            log_proc:log(Sql),
                                            {1, NewPlayer}
                                    end
                            end
                    end
            end
    end.

check_gold(Id, Shop) ->
    {GoodsId, _GoodsNum} = data_guild_fight_exchange:get(Id),
    BaseBuyTime = data_guild_fight_exchange:get_buy_time(Id),
    SumBuyTime = count_goods_buy_times(GoodsId, Shop),
    Bool = lists:member(GoodsId, [7501100]),
    if
        Bool andalso BaseBuyTime =< SumBuyTime -> false;
        true ->
            F = fun({OldId, _BuyTime}) ->
                {GoodsId99, _GoodsNum99} = data_guild_fight_exchange:get(OldId),
                if
                    GoodsId == 10199 andalso GoodsId99 == 10199 -> [1];
                    true -> []
                end
                end,
            LL = lists:flatmap(F, Shop),
            ?IF_ELSE(LL == [], true, false)
    end.

get_state(Player) ->
    OpenDay = config:get_open_days(),
    if
        OpenDay == 1 -> -1;
        true ->
            St = lib_dict:get(?PROC_STATUS_GUILD_FIGHT),
            #st_guild_fight{challenge_num = ChallengeNum, cd_time = CdTime, recv_list = RecvList} = St,
            BaseChallengeNum = data_guild_fight_args:get_fight_max_win_num(),
            BaseCdTime = data_guild_fight_args:get_challenge_cd_time(),
            Now = util:unixtime(),
            case ChallengeNum < BaseChallengeNum andalso Now - CdTime > BaseCdTime of
                true -> 1;
                false ->
                    case ets:lookup(?ETS_GUILD_FIGHT, Player#player.guild#st_guild.guild_key) of
                        [] -> 0;
                        [#guild_fight{guild_num = GuildNum}] ->
                            case lists:member(GuildNum, RecvList) of
                                true -> 0;
                                false -> 1
                            end
                    end
            end
    end.

get_act_state(_Player) ->
    case get_act() of
        [] -> 0;
        _ -> 1
    end.