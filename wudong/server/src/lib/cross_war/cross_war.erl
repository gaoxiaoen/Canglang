%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 八月 2017 11:21
%%%-------------------------------------------------------------------
-module(cross_war).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("cross_war.hrl").
-include("guild.hrl").
-include("scene.hrl").
-include("goods.hrl").

-export([ %% 跨服节点函数
    get_act_state/7
    , get_act_info/5
    , get_my_contrib_info/3 %% 获取自身捐献信息
    , contrib_center/3 %% 贡献
    , get_meeting_guild_list/4 %% 获取议会公会防御列表
    , change_sign/2 %% 切换防守方
    , get_sign_born_x_y/1 %% 获取阵营方出生地点
    , get_cross_war_info/1 %% 获取主城面板信息
    , enter_cross_war/2 %% 进入战场
    , get_guild_data/1 %% 活动开启拿取数据
    , notice_all_client/1 %% 活动开启通知合格玩家
    , get_now_war_info/3
    , change_scene_enter/5 %% 进入场景
    , change_scene_back/1 %% 退出场景
    , change_sign_mail/4 %% 邮件通知
    , quit/3
    , quit_war/1 %% 退出战场
    , quit_war/0 %% 退出战场
    , sys_end_cacl/1 %% 活动借宿，系统结算奖励
    , to_client_result/1 %% 通知客户端结束，并显示结果
    , notice_client_quit/0 %% 通知玩家退出场景
    , to_client_reward/1
    , notice_client_update_score/1
    , get_revice_center/1
    , get_cross_war_guild/0
    , sys_back_center/1 %% 系统操作返还
    , get_king_guild_key/0 %% 读取城主仙盟公会key
    , get_king_pkey/0
    , exchange_bomb_center/3 %% 炸弹兑换
    , exchange_car_center/3 %% 攻城车兑换
    , put_down_king_gold/1 %% 放下宝珠
    , use_bomb/1 %% 使用炮弹
    , get_act_open_state_center/0 %% 远程拿取活动状态
    , get_king_pkey_gkey_center/0 %% 远程拿取王者key和王者仙盟key
    , get_is_apply/1
    , set_sign/2
    , get_act_43099_actid_143/2
    , get_act_43099_actid_149/6
    , get_main_key_center/0
    , update_couple_info_center/2
    , orz/1
]).

-export([%% 跨服节点进程调用
    get_act_state_cast/8
    , get_act_info_cast/2
    , update_war_cast/6
    , update_war_cast/2
    , get_cross_war_info_cast/2
    , enter_cross_war_cast/2
    , get_now_war_info_cast/4
    , sys_midnight_refresh_cast/1
    , change_sign_cast/3
    , get_revice_center_call/2
    , get_cross_war_guild_call/1
    , get_now_king_x_y_cast/5
    , put_down_king_gold_cast/2
    , update_cross_mon_hp_cast/2
    , is_apply_center/1
    , get_act_43099_actid_143_cast/3
    , get_act_43099_actid_149_cast/7
]).

-export([%% 协议接口及玩家内部函数
    get_act_state/1 %% 获取活动动态
    , get_act_open_state/0 %% 拿取活动状态
    , get_act_info/1 %% 读取面板信息
    , contrib/3 %% 贡献
    , sys_midnight_refresh/0
    , update_player_cross_war/0 %% 返还
    , midnight_refresh/1
    , logout/1
    , get_state/1
    , recv_king_reward/1 %%领取城主奖励
    , recv_member_reward/1 %%领取成员奖励
    , enter_cross_war_scene/3 %%进入场景
    , enter_cross_war/1 %% 进入战场
    , notice_to_guild/2 %% 活动开启通知玩家
    , send_to_client_mail/4
    , send_to_client_mail/5
    , get_revice/1
    , sys_back/1 %% 系统计算返还
    , exchange_bomb/3
    , exchange_car/3
    , get_now_king_x_y/4 %% 获取当前王者的坐标位置
    , judge_sign/1
    , add_buff/2 %% 加buff
    , delete_buff/2 %% 消除buff
    , delete_buff_list/2 %% 消除buff
    , update_cross_war_mon_klist/4
    , get_my_con_val/1
    , get_player_sign/1
    , get_notice_state/1
    , get_main_key/2
    , get_main_key/0
    , update_couple_info/2
    , update_cross_war_guild/1
    , log/4
]).

get_revice(Player) ->
    cross_area:war_apply_call(?MODULE, get_revice_center, [Player]).

get_revice_center(Player) ->
    ?CALL(cross_war_proc:get_server_pid(), {get_revice_center_call, Player}).

get_revice_center_call(State, Player) ->
    #sys_cross_war{
        kill_banner_sign = KillBannerSign
    } = State,
    GuildKey = Player#player.guild#st_guild.guild_key,
    case cross_war_util:get_by_g_key(GuildKey) of
        [] ->
            ?ERR("###GuildKey:~p", [GuildKey]),
            {Player#player.x, Player#player.y};
        CrossWarGuild ->
            case CrossWarGuild#cross_war_guild.sign == ?CROSS_WAR_TYPE_DEF of
                true ->
                    {_, X, Y} = get_sign_born_x_y(GuildKey);
                false ->
                    if
                        KillBannerSign /= ?CROSS_WAR_TYPE_ATT ->
                            {_, X, Y} = get_sign_born_x_y(GuildKey);
                        true ->
                            XYList = data_cross_war_player_born:get(5),
                            {X, Y} = util:list_rand(XYList)
                    end
            end,
            {X, Y}
    end.

%% 切换阵营
change_sign(Player, Type) ->
    ?CAST(cross_war_proc:get_server_pid(), {change_sign, Player, Type}).

change_sign_cast(State, Player, Type) ->
    GuildKey = Player#player.guild#st_guild.guild_key,
    OpenState = State#sys_cross_war.open_state,
    Position = Player#player.guild#st_guild.guild_position,
    if
        GuildKey == 0 ->
            {ok, Bin} = pt_601:write(60110, {3, Type});
        OpenState == ?CROSS_WAR_STATE_START ->
            {ok, Bin} = pt_601:write(60110, {9, Type}); %% 已经开始，不可以再切换阵营
        Position > 3 ->
            {ok, Bin} = pt_601:write(60110, {10, Type}); %% 掌门和掌教才能切换阵营
        true ->
            CrossWarGuild = cross_war_util:get_by_g_key(GuildKey),
            ChangeSignTime = CrossWarGuild#cross_war_guild.change_sign_time,
            OldSign = CrossWarGuild#cross_war_guild.sign,
            Now = util:unixtime(),
            if
                Now - ChangeSignTime < ?CROSS_WAR_CHANGE_SIGN_CD ->
                    {ok, Bin} = pt_601:write(60110, {11, Type}); %% 时间限制
                true ->
                    NewCrossWarGuild =
                        CrossWarGuild#cross_war_guild{
                            sign = Type,
                            change_sign_time = Now
                        },
                    cross_war_util:update_war_guild(NewCrossWarGuild),
                    center:apply(Player#player.node, ?MODULE, change_sign_mail, [Player#player.nickname, GuildKey, Type, OldSign]),
                    spawn(fun() -> cross_war_util:change_sign_player(GuildKey, Type) end),
                    {ok, Bin} = pt_601:write(60110, {1, Type}),
                    center:apply(Player#player.node, cross_war_load, dbup_guild_sign, [GuildKey, Type, Now])
            end
    end,
    server_send:send_to_sid(Player#player.node, Player#player.sid, Bin),
    ok.

change_sign_mail(NickName, GuildKey, Sign, OldSign) ->
    {Title, Content0} =
        case Sign == ?CROSS_WAR_TYPE_DEF of
            true ->
                if
                    OldSign == 0 ->
                        t_mail:mail_content(117);
                    true ->
                        t_mail:mail_content(130)
                end;
            false ->
                if
                    OldSign == 0 ->
                        t_mail:mail_content(118);
                    true ->
                        t_mail:mail_content(131)
                end
        end,
    Content = io_lib:format(Content0, [NickName]),
    MemberList = guild_ets:get_guild_member_list(GuildKey),
    F = fun(#g_member{pkey = Pkey}) -> Pkey end,
    MemberKeyList = lists:map(F, MemberList),
    mail:sys_send_mail(MemberKeyList, Title, Content),
    ok.

get_meeting_guild_list(Gkey, Node, Sid, Type) ->
    case cross_war_util:get_by_g_key(Gkey) of
        #cross_war_guild{contrib_rank = ConRank} when ConRank =< ?CROSS_WAR_SIGN_GUILD_MAX_NUM ->
            GuildList = cross_war_util:get_type_all_guild(Type),
            F = fun(CrossWarGuild) ->
                #cross_war_guild{
                    contrib_rank = ContribRank,
                    sn = DefSn,
                    sn_name = SnName,
                    g_name = GuildName,
                    is_main = IsMain
                } = CrossWarGuild,
                [ContribRank, GuildName, DefSn, SnName, IsMain]
            end,
            ProList = lists:map(F, GuildList),
            {ok, Bin} = pt_601:write(60109, {1, ProList}),
            server_send:send_to_sid(Node, Sid, Bin),
            ok;
        _ ->
            {ok, Bin} = pt_601:write(60109, {28, []}),
            server_send:send_to_sid(Node, Sid, Bin),
            ok
    end.


get_main_key(_Node, _Sid) ->
    GuildList = cross_war_util:get_all_guild(),
    F = fun(CrossWarGuild) ->
        #cross_war_guild{
            sign = Sign,
            is_main = IsMain,
            g_pkey = Pkey
        } = CrossWarGuild,
        if
            IsMain == 1 orelse IsMain == 2 -> {Pkey, Sign};
            true -> {0, 0}
        end
    end,
    lists:map(F, GuildList).


contrib_center(Gkey, Pkey, AddContrib) ->
    CrossWarGuild = cross_war_util:get_by_g_key(Gkey),
    ConMult = data_cross_war_other_reward:get_king_con_mult(),
    IsKingGuild = cross_war_util:is_king_guild(Gkey),
    NewAddContrib = ?IF_ELSE(IsKingGuild > 0, round(AddContrib*ConMult), AddContrib),
    NewCrossWarGuild =
        CrossWarGuild#cross_war_guild{
            contrib_time = util:unixtime(),
            contrib_val = NewAddContrib + CrossWarGuild#cross_war_guild.contrib_val
        },
    cross_war_util:update_war_guild(NewCrossWarGuild),
    cross_war_util:get_guild_contrib_sort(CrossWarGuild#cross_war_guild.sign),
    CrossWarPlayer = cross_war_util:get_by_pkey(Pkey),
    NewCrossWarPlayer =
        CrossWarPlayer#cross_war_player{
            contrib_time = util:unixtime(),
            contrib_val = AddContrib + CrossWarPlayer#cross_war_player.contrib_val
        },
    cross_war_util:update_war_player(NewCrossWarPlayer),
    ok.

%% 贡献
contrib(Player, GoodsId, GoodsNum) ->
    StCrossWar = lib_dict:get(?PROC_STATUS_CROSS_WAR),
    case check_contrib(Player, GoodsId, GoodsNum) of
        {fail, Code} ->
            {Code, 0, Player};
        {true, NewPlayer} ->
            #st_cross_war{
                contrib = Contrib,
                contrib_list = ContribList
            } = StCrossWar,
            AddContribVal = data_cross_war_exchange:get(GoodsId) * GoodsNum,
            NewStCrossWar =
                StCrossWar#st_cross_war{
                    contrib = Contrib + AddContribVal,
                    contrib_list = cross_war_util:add_to_list(GoodsId, GoodsNum, ContribList),
                    guild_key = Player#player.guild#st_guild.guild_key,
                    op_time = util:unixtime()
                },
            lib_dict:put(?PROC_STATUS_CROSS_WAR, NewStCrossWar),
            cross_war_load:update(NewStCrossWar),
            #player{key = Pkey, guild = StGuild} = Player,
            cross_area:war_apply(?MODULE, contrib_center, [StGuild#st_guild.guild_key, Pkey, AddContribVal]),
            {1, AddContribVal, NewPlayer}
    end.

check_contrib(Player, GoodsId, GoodsNum) ->
    ActState = get_act_open_state(),
    if
        ActState == ?CROSS_WAR_STATE_START ->
            {fail, 22}; %% 非报名时间段 活动已开启
        ActState == ?CROSS_WAR_STATE_CLOSE ->
            {fail, 21}; %% 非报名时间段 活动已结束
        Player#player.guild#st_guild.guild_key == 0 ->
            {fail, 3}; %% 当前没有加入帮派
        GoodsId == 10101 ->
            case money:is_enough(Player, GoodsNum, coin) of
                false -> {fail, 6}; %% 银币不足
                true ->
                    NewPlayer = money:add_coin(Player, -GoodsNum, 675, 0, 0),
                    {true, NewPlayer}
            end;
        GoodsId == 10199 ->
            case money:is_enough(Player, GoodsNum, gold) of
                false -> {fail, 5}; %% 元宝不足
                true ->
                    NewPlayer = money:add_no_bind_gold(Player, -GoodsNum, 676, 0, 0),
                    {true, NewPlayer}
            end;
        true ->
            %% 暂时不扣除
            HasGoodsNum = goods_util:get_goods_count(GoodsId),
            if
                HasGoodsNum < GoodsNum -> {fail, 4}; %%材料不足
                true ->
                    case goods:subtract_good(Player, [{GoodsId, GoodsNum}], 677) of
                        {false, _} -> {fail, 4};
                        {ok, _} ->
                            {true, Player}
                    end
            end
    end.

get_my_contrib_info(GuildKey, Node, Sid) ->
    Data =
        if
            GuildKey == 0 ->
                {0, 0, 0};
            true ->
                CrossWarGuild = cross_war_util:get_by_g_key(GuildKey),
                #cross_war_guild{
                    contrib_val = ConVal, %% 捐献值
                    contrib_rank = ConRank, %% 捐献值排名
                    change_sign_time = ChangeSignTime
                } = CrossWarGuild,
                RemainTime = max(0, ChangeSignTime + ?CROSS_WAR_CHANGE_SIGN_CD - util:unixtime()),
                {ConVal, ConRank, RemainTime}
        end,
    {ok, Bin} = pt_601:write(60103, Data),
    server_send:send_to_sid(Node, Sid, Bin),
    ok.

get_act_info(Player) ->
    GuildMainShadow =
        if
            Player#player.guild#st_guild.guild_key == 0 -> #player{};
            true ->
                Guild = guild_ets:get_guild(Player#player.guild#st_guild.guild_key),
                shadow_proc:get_shadow(Guild#guild.pkey)
        end,
    PlayerCouple =
        if
            Player#player.marry#marry.couple_key == 0 -> #player{};
            true ->
                shadow_proc:get_shadow(Player#player.marry#marry.couple_key)
        end,
    GuildMainCoupleShadow =
        if
            GuildMainShadow#player.marry#marry.couple_key == 0 -> #player{};
            true ->
                shadow_proc:get_shadow(GuildMainShadow#player.marry#marry.couple_key)
        end,
    PlayerCon = get_my_con_val(Player),
    cross_area:war_apply(?MODULE, get_act_info, [Player, PlayerCouple, GuildMainShadow, GuildMainCoupleShadow, PlayerCon]),
    ok.

get_act_info(Player, PlayerCouple, GuildMainShadow, GuildMainCoupleShadow, PlayerCon) ->
    ?CAST(cross_war_proc:get_server_pid(), {get_act_info, Player, PlayerCouple, GuildMainShadow, GuildMainCoupleShadow, PlayerCon}).

get_act_info_cast(State, Player) ->
    #sys_cross_war{king_info = KingInfo0} = State,
    Week = util:get_day_of_week(),
    PassSec = util:get_seconds_from_midnight(),
    if
        Week == 6 -> KingInfo = #cross_war_king{};
        Week == 7 andalso PassSec < 21*?ONE_HOUR_SECONDS -> KingInfo = #cross_war_king{};
        true -> KingInfo = KingInfo0
    end,
    #cross_war_king{
        nickname = KingNickName,
        sn = KingSn,
        sn_name = KingSnName,
        sex = KingSex,
        wing_id = KingWingId,
        wepon_id = KingWeponId,
        clothing_id = KingClothingId,
        light_wepon_id = KingLightWeponId,
        fashion_cloth_id = KingFashionClothId,
        fashion_head_id = KingFashionHeadId,
        g_name = GuildName,
        couple_nickname = CoupleName,
        couple_sex = CoupleSex,
        couple_wing_id = CoupleWingId,
        couple_wepon_id = CoupleWeponId,
        couple_clothing_id = CoupleClothingId,
        couple_light_wepon_id = CoupleLightWeponId,
        couple_fashion_cloth_id = CoupleFashionClothId,
        couple_fashion_head_id = CoupleFashionHeadId,
        acc_win = AccWin,
        war_info = WarInfo
    } = KingInfo,
    MemberDailyReward = util:list_tuple_to_list(data_cross_war_daily_reward:get_member_reward()),
    KingDailyReward = util:list_tuple_to_list(data_cross_war_daily_reward:get_king_reward()),
    WarReward = util:list_tuple_to_list(data_cross_war_other_reward:get_war_reward()),
    NewWarInfo = get_war_info_list(WarInfo),
    {ok, Bin} = pt_601:write(60102,
        {KingNickName, KingSn, KingSnName, KingSex,
            KingWingId, KingWeponId, KingClothingId, KingLightWeponId, KingFashionClothId, KingFashionHeadId,
            GuildName, CoupleName, CoupleSex, CoupleWingId, CoupleWeponId, CoupleClothingId, CoupleLightWeponId,
            CoupleFashionClothId, CoupleFashionHeadId,
            AccWin, MemberDailyReward, KingDailyReward, WarReward, NewWarInfo}),
    server_send:send_to_sid(Player#player.node, Player#player.sid, Bin),
%%    center:apply(Player#player.node, server_send, send_to_sid, [Player#player.sid, Bin]),
    ok.

get_war_info_list(WarInfo) ->
    F = fun(#cross_war_log{
        rank = Rank,
        nickname = Name,
        sex = Sex,
        sn = Sn,
        g_name = GuildName,
        sn_name = SnName,
        wing_id = WingId,
        wepon_id = WeponId,
        clothing_id = ClothingId,
        light_wepon_id = LightWeponId,
        fashion_cloth_id = FashionClothId,
        fashion_head_id = FashionHeadId
    }) ->
        [Name, Sex, Rank, GuildName, Sn, SnName, WingId, WeponId, ClothingId, LightWeponId, FashionClothId, FashionHeadId]
    end,
    lists:map(F, WarInfo).

get_act_state(Player) ->
    CrossWar = lib_dict:get(?PROC_STATUS_CROSS_WAR),
    #st_cross_war{
        is_member_reward = IsRecvMember,
        is_king_reward = IsRecvKing,
        is_orz = IsOrz
    } = CrossWar,
    GuildKey = Player#player.guild#st_guild.guild_key,
    cross_area:war_apply(?MODULE, get_act_state, [node(), GuildKey, Player#player.key, Player#player.sid, IsRecvMember, IsRecvKing, IsOrz]),
    ok.

get_act_state(Node, GuildKey, Pkey, Sid, IsRecvMember, IsRecvKing, IsOrz) ->
    ?CAST(cross_war_proc:get_server_pid(), {get_act_state, Node, GuildKey, Pkey, Sid, IsRecvMember, IsRecvKing, IsOrz}).

get_act_state_cast(State, Node, GuildKey, Pkey, Sid, IsRecvMember, IsRecvKing, IsOrz) ->
    #sys_cross_war{
        king_info = KingInfo,
        open_state = OpenState,
        time = EndTime
    } = State,
    NewIsRecvKing =
        if
            KingInfo#cross_war_king.pkey == 0 -> 0;
            Pkey == KingInfo#cross_war_king.pkey ->
                ?IF_ELSE(IsRecvKing == 0, 1, 2);
            true ->
                0
        end,
    NewIsRecvMember =
        if
            KingInfo#cross_war_king.g_key == 0 -> 0;
            GuildKey == KingInfo#cross_war_king.g_key ->
                ?IF_ELSE(IsRecvMember == 0, 1, 2);
            true ->
                0
        end,
    RemainTime = max(0, EndTime - util:unixtime()),
    MySign =
        case cross_war_util:get_by_g_key(GuildKey) of
            [] ->
                0;
            #cross_war_guild{sign = Sign} ->
                Sign
        end,
    WeekDay = util:get_day_of_week(),
    if
        WeekDay < 6 -> NewOpenState = 4;
        true -> NewOpenState = OpenState
    end,
    {ok, Bin} = pt_601:write(60101, {NewOpenState, RemainTime, NewIsRecvMember, NewIsRecvKing, MySign, IsOrz}),
    server_send:send_to_sid(Node, Sid, Bin).
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]).

get_act_open_state() ->
    case cross_area:war_apply_call(?MODULE, get_act_open_state_center, []) of
        OpenState when is_integer(OpenState) ->
            OpenState;
        _ -> 0
    end.

get_act_open_state_center() ->
    ?CALL(cross_war_proc:get_server_pid(), get_act_open_state).

%% 系统清除跨服进程数据
sys_midnight_refresh() ->
    case config:is_center_node() of
        true ->
            cross_war_proc:get_server_pid() ! sys_midnight_refresh;
        false ->
            case util:get_day_of_week() of
                1 -> %% 周6清库
                    Rand = util:rand(2000, 10000),
                    case config:is_debug() of
                        true -> skip;
                        false -> timer:sleep(Rand)
                    end,
                    Sql = io_lib:format("update guild_cross_war_sign set change_time=0", []),
                    db:execute(Sql),
                    Sql2 = io_lib:format("update player_cross_war set contrib=0,contrib_list='[]',is_recv_king=0,is_recv_member=0,is_orz=0", []),
                    db:execute(Sql2);
                _ ->
                    skip
            end
    end.

sys_midnight_refresh_cast(State) ->
    WeekDay = util:get_day_of_week(),
    if
        WeekDay /= 1 -> State;
        true ->
            #sys_cross_war{king_info = KingInfo, last_king_info = LastKingInfo} = State,
            if
                KingInfo#cross_war_king.g_key /= 0 ->
                    set_sign(KingInfo#cross_war_king.g_key, ?CROSS_WAR_TYPE_DEF);
                true -> skip
            end,
            if
                KingInfo#cross_war_king.g_key == LastKingInfo#cross_war_king.g_key ->
                    skip;
                LastKingInfo#cross_war_king.g_key /= 0 ->
                    set_sign(LastKingInfo#cross_war_king.g_key, ?CROSS_WAR_TYPE_ATT);
                true -> skip
            end,
            spawn(fun() ->
                cross_war_util:delete_war_guild_all_week_1(),
                cross_war_util:delete_war_player_all_week_1()
            end),
            State#sys_cross_war{
                def_guild_list = [],
                att_guild_list = [],
                def_player_list = [],
                att_player_list = [],
                mon_list = [],
                collect_num = 0
            }
    end.

%% 重置调用
update_player_cross_war() ->
    StCrossWar = lib_dict:get(?PROC_STATUS_CROSS_WAR),
    #st_cross_war{op_time = OpTime} = StCrossWar,
    Now = util:unixtime(),
    case util:is_same_date(Now, OpTime) of
        true -> skip;
        false ->
            NewStCrossWar =
                StCrossWar#st_cross_war{
                    is_member_reward = 0,
                    is_king_reward = 0,
                    op_time = Now,
                    is_orz = 0
                },
            lib_dict:put(?PROC_STATUS_CROSS_WAR, NewStCrossWar)
    end,
    ok.

%% 系统计算返还贡献
midnight_refresh(Now) ->
    Week = util:get_day_of_week(Now),
    if %% 平时凌晨重置，不删除贡献数据
        Week /= 1 ->
            update_player_cross_war();
        true ->
            StCrossWar = lib_dict:get(?PROC_STATUS_CROSS_WAR),
            lib_dict:put(?PROC_STATUS_CROSS_WAR, #st_cross_war{pkey = StCrossWar#st_cross_war.pkey, op_time = util:unixdate()})
    end.

get_state(Player) ->
    case Player#player.lv < ?CROSS_WAR_LIMIT_LV of
        true -> cross_war_close;
        false ->
            LimitOpenDay = data_cross_war_time:get_limit_open_day(),
            OpenDay = config:get_open_days(),
            RR =
                if
                    OpenDay =< LimitOpenDay -> cross_war_close;
                    true ->
                        Week = util:get_day_of_week(),
                        case config:is_debug() of
                            true ->
                                get_act_remain_time(Player#player.node, Player#player.sid);
                            false ->
                                if
                                    Week == 6 orelse Week == 7 ->
                                        get_act_remain_time(Player#player.node, Player#player.sid);
                                    true -> cross_war_close
                                end
                        end
                end,
            RR
    end.

get_act_remain_time(Node, Sid) ->
    cross_area:war_apply(cross_war, get_act_43099_actid_143, [Node, Sid]),
    ok.

get_act_43099_actid_143(Node, Sid) ->
    ?CAST(cross_war_proc:get_server_pid(), {get_act_43099_actid_143, Node, Sid}).

get_act_43099_actid_143_cast(State, _Node, Sid) ->
    #sys_cross_war{open_state = OpenState, time = LastTime} = State,
    {ActState, Args} =
        case OpenState of
            ?CROSS_WAR_STATE_CLOSE -> {-1, [{time, 0}]};
            _ -> {OpenState, [{time, max(0, LastTime - util:unixtime())}]}
        end,
    ActStateList = {[[143, ActState] ++ activity:pack_act_state(Args)]},
    {ok, Bin} = pt_430:write(43099, ActStateList),
    server_send:send_to_sid(Sid, Bin),
    ok.


is_apply_center(GuildKey) ->
    case cross_war_util:get_by_g_key(GuildKey) of
        [] -> 0;
        _ -> 1
    end.

logout(Player) ->
    case Player#player.scene == ?SCENE_ID_CROSS_WAR of
        true ->
            StCrossWar = lib_dict:get(?PROC_STATUS_CROSS_WAR),
            #st_cross_war{pkey = Pkey} = StCrossWar,
            cross_area:war_apply(?MODULE, quit, [Pkey, Player#player.x, Player#player.y]);
        false ->
            skip
    end.

quit(Pkey, X, Y) ->
    case cross_war_util:get_by_pkey(Pkey) of
        [] -> skip;
        Ets ->
            if
                Ets#cross_war_player.crown == 1 ->
                    ?CAST(cross_war_proc:get_server_pid(), {create_crown, X, Y}),
                    center:apply(Ets#cross_war_player.node, cross_war_battle, set_crown, [Pkey, 0]),
                    cross_war_util:update_war_player(Ets#cross_war_player{is_online = 0, sid = null, crown = 0});
                true ->
                    skip
            end
    end.

update_war_cast(_State, Player, PlayerCouple, GuildMainShadow, GuildMainCoupleShadow, PlayerCon) ->
    if
        Player#player.guild#st_guild.guild_key == 0 -> skip;
        true ->
            GuildKey = Player#player.guild#st_guild.guild_key,
            GuildName = Player#player.guild#st_guild.guild_name,
            case cross_war_util:get_by_g_key(GuildKey) of
                [] ->
                    CrossWarGuild =
                        #cross_war_guild{
                            g_key = GuildKey,
                            g_name = GuildName,
                            sn = Player#player.sn,
                            sn_name = ?IF_ELSE(Player#player.sn_name == null, ?T("1服"), Player#player.sn_name),
                            node = Player#player.node,
                            g_pkey = GuildMainShadow#player.key,
                            g_main_name = GuildMainShadow#player.nickname,
                            g_main_sex = GuildMainShadow#player.sex,
                            g_main_wing_id = GuildMainShadow#player.wing_id,
                            g_main_wepon_id = GuildMainShadow#player.equip_figure#equip_figure.weapon_id,
                            g_main_clothing_id = GuildMainShadow#player.equip_figure#equip_figure.clothing_id,
                            g_main_light_wepon_id = GuildMainShadow#player.light_weaponid,
                            g_main_fashion_cloth_id = GuildMainShadow#player.fashion#fashion_figure.fashion_cloth_id,
                            g_main_fashion_head_id = GuildMainShadow#player.fashion#fashion_figure.fashion_head_id,
                            contrib_val = PlayerCon
                        },
                    cross_war_util:update_war_guild(CrossWarGuild),
                    CrossWarPlayer =
                        #cross_war_player{
                            pkey = Player#player.key,
                            sn = Player#player.sn,
                            sn_name = ?IF_ELSE(Player#player.sn_name == null, ?T("1服"), Player#player.sn_name),
                            career = Player#player.career,
                            sex = Player#player.sex,
                            nickname = Player#player.nickname,
                            wing_id = Player#player.wing_id,
                            wepon_id = Player#player.equip_figure#equip_figure.weapon_id,
                            clothing_id = Player#player.equip_figure#equip_figure.clothing_id,
                            light_wepon_id = Player#player.light_weaponid,
                            fashion_cloth_id = Player#player.fashion#fashion_figure.fashion_cloth_id,
                            fashion_head_id = Player#player.fashion#fashion_figure.fashion_head_id,
                            couple_pkey = Player#player.marry#marry.couple_key,
                            couple_sex = Player#player.marry#marry.couple_sex,
                            couple_nickname = Player#player.marry#marry.couple_name,
                            couple_wing_id = PlayerCouple#player.wing_id,
                            couple_wepon_id = PlayerCouple#player.equip_figure#equip_figure.weapon_id,
                            couple_clothing_id = PlayerCouple#player.equip_figure#equip_figure.clothing_id,
                            couple_light_wepon_id = PlayerCouple#player.light_weaponid,
                            couple_fashion_cloth_id = PlayerCouple#player.fashion#fashion_figure.fashion_cloth_id,
                            couple_fashion_head_id = PlayerCouple#player.fashion#fashion_figure.fashion_head_id,
                            node = Player#player.node,
                            position = Player#player.guild#st_guild.guild_position, %% 帮派职位
                            g_key = Player#player.guild#st_guild.guild_key,
                            g_name = Player#player.guild#st_guild.guild_name,
                            contrib_val = PlayerCon
                        },
                    CrossWarMainPlayer =
                        #cross_war_player{
                            pkey = GuildMainShadow#player.key,
                            sn = Player#player.sn,
                            sn_name = ?IF_ELSE(Player#player.sn_name == null, ?T("1服"), Player#player.sn_name),
                            career = GuildMainShadow#player.career,
                            sex = GuildMainShadow#player.sex,
                            nickname = GuildMainShadow#player.nickname,
                            wing_id = GuildMainShadow#player.wing_id,
                            wepon_id = GuildMainShadow#player.equip_figure#equip_figure.weapon_id,
                            clothing_id = GuildMainShadow#player.equip_figure#equip_figure.clothing_id,
                            light_wepon_id = GuildMainShadow#player.light_weaponid,
                            fashion_cloth_id = GuildMainShadow#player.fashion#fashion_figure.fashion_cloth_id,
                            fashion_head_id = GuildMainShadow#player.fashion#fashion_figure.fashion_head_id,
                            couple_pkey = GuildMainShadow#player.marry#marry.couple_key,
                            couple_sex = GuildMainShadow#player.marry#marry.couple_sex,
                            couple_nickname = GuildMainShadow#player.marry#marry.couple_name,
                            couple_wing_id = GuildMainCoupleShadow#player.wing_id,
                            couple_wepon_id = GuildMainCoupleShadow#player.equip_figure#equip_figure.weapon_id,
                            couple_clothing_id = GuildMainCoupleShadow#player.equip_figure#equip_figure.clothing_id,
                            couple_light_wepon_id = GuildMainCoupleShadow#player.light_weaponid,
                            couple_fashion_cloth_id = GuildMainCoupleShadow#player.fashion#fashion_figure.fashion_cloth_id,
                            couple_fashion_head_id = GuildMainCoupleShadow#player.fashion#fashion_figure.fashion_head_id,
                            node = Player#player.node,
                            position = GuildMainShadow#player.guild#st_guild.guild_position, %% 帮派职位
                            g_key = Player#player.guild#st_guild.guild_key,
                            g_name = Player#player.guild#st_guild.guild_name
                        },
                    cross_war_util:update_war_player(CrossWarMainPlayer),
                    cross_war_util:update_war_player(CrossWarPlayer);
                CrossWarGuild ->
                    NewCrossWarGuild =
                        CrossWarGuild#cross_war_guild{
                            g_key = GuildKey,
                            g_name = GuildName,
                            sn = Player#player.sn,
                            sn_name = ?IF_ELSE(Player#player.sn_name == null, ?T("1服"), Player#player.sn_name),
                            node = Player#player.node,
                            g_pkey = GuildMainShadow#player.key,
                            g_main_name = GuildMainShadow#player.nickname,
                            g_main_sex = GuildMainShadow#player.sex,
                            g_main_wing_id = GuildMainShadow#player.wing_id,
                            g_main_wepon_id = GuildMainShadow#player.equip_figure#equip_figure.weapon_id,
                            g_main_clothing_id = GuildMainShadow#player.equip_figure#equip_figure.clothing_id,
                            g_main_light_wepon_id = GuildMainShadow#player.light_weaponid,
                            g_main_fashion_cloth_id = GuildMainShadow#player.fashion#fashion_figure.fashion_cloth_id,
                            g_main_fashion_head_id = GuildMainShadow#player.fashion#fashion_figure.fashion_head_id
                        },
                    cross_war_util:update_war_guild(NewCrossWarGuild),
                    update_war_cast(Player, PlayerCouple)
            end,
            cross_war_repair:repair_player_con_center(Player, PlayerCon),
            cross_war_repair:repair_guild_con(Player#player.guild#st_guild.guild_key)
    end.

update_war_cast(Player, PlayerCouple) ->
    CrossWarGuild = cross_war_util:get_by_g_key(Player#player.guild#st_guild.guild_key),
    case cross_war_util:get_by_pkey(Player#player.key) of
        [] ->
            CrossWarPlayer =
                #cross_war_player{
                    pkey = Player#player.key,
                    sn = Player#player.sn,
                    sn_name = ?IF_ELSE(Player#player.sn_name == null, ?T("测试服"), Player#player.sn_name),
                    career = Player#player.career,
                    sex = Player#player.sex,
                    nickname = Player#player.nickname,
                    wing_id = Player#player.wing_id,
                    wepon_id = Player#player.equip_figure#equip_figure.weapon_id,
                    clothing_id = Player#player.equip_figure#equip_figure.clothing_id,
                    light_wepon_id = Player#player.light_weaponid,
                    fashion_cloth_id = Player#player.fashion#fashion_figure.fashion_cloth_id,
                    fashion_head_id = Player#player.fashion#fashion_figure.fashion_head_id,
                    couple_pkey = Player#player.marry#marry.couple_key,
                    couple_sex = Player#player.marry#marry.couple_sex,
                    couple_nickname = Player#player.marry#marry.couple_name,
                    couple_wing_id = PlayerCouple#player.wing_id,
                    couple_wepon_id = PlayerCouple#player.equip_figure#equip_figure.weapon_id,
                    couple_clothing_id = PlayerCouple#player.equip_figure#equip_figure.clothing_id,
                    couple_light_wepon_id = PlayerCouple#player.light_weaponid,
                    couple_fashion_cloth_id = PlayerCouple#player.fashion#fashion_figure.fashion_cloth_id,
                    couple_fashion_head_id = PlayerCouple#player.fashion#fashion_figure.fashion_head_id,
                    node = Player#player.node,
                    position = Player#player.guild#st_guild.guild_position, %% 帮派职位
                    g_key = Player#player.guild#st_guild.guild_key,
                    g_name = Player#player.guild#st_guild.guild_name,
                    is_online = 1,
                    sid = Player#player.sid,
                    sign = CrossWarGuild#cross_war_guild.sign
                },
            cross_war_util:update_war_player(CrossWarPlayer);
        CrossWarPlayer ->
            NewCrossWarPlayer =
                CrossWarPlayer#cross_war_player{
                    nickname = Player#player.nickname,
                    wing_id = Player#player.wing_id,
                    wepon_id = Player#player.equip_figure#equip_figure.weapon_id,
                    clothing_id = Player#player.equip_figure#equip_figure.clothing_id,
                    light_wepon_id = Player#player.light_weaponid,
                    fashion_cloth_id = Player#player.fashion#fashion_figure.fashion_cloth_id,
                    fashion_head_id = Player#player.fashion#fashion_figure.fashion_head_id,
                    couple_pkey = Player#player.marry#marry.couple_key,
                    couple_sex = Player#player.marry#marry.couple_sex,
                    couple_nickname = Player#player.marry#marry.couple_name,
                    couple_wing_id = PlayerCouple#player.wing_id,
                    couple_wepon_id = PlayerCouple#player.equip_figure#equip_figure.weapon_id,
                    couple_clothing_id = PlayerCouple#player.equip_figure#equip_figure.clothing_id,
                    couple_light_wepon_id = PlayerCouple#player.light_weaponid,
                    couple_fashion_cloth_id = PlayerCouple#player.fashion#fashion_figure.fashion_cloth_id,
                    couple_fashion_head_id = PlayerCouple#player.fashion#fashion_figure.fashion_head_id,
                    node = Player#player.node,
                    position = Player#player.guild#st_guild.guild_position, %% 帮派职位
                    g_key = Player#player.guild#st_guild.guild_key,
                    g_name = Player#player.guild#st_guild.guild_name,
                    is_online = 1,
                    sid = Player#player.sid,
                    sign = CrossWarGuild#cross_war_guild.sign
                },
            cross_war_util:update_war_player(NewCrossWarPlayer)
    end.

%% 领取王者奖励
recv_king_reward(Player) ->
    StCrossWar = lib_dict:get(?PROC_STATUS_CROSS_WAR),
    #st_cross_war{
        is_king_reward = IsRecv
    } = StCrossWar,
    KingPkey = cross_area:war_apply_call(?MODULE, get_king_pkey, []),
    if
        IsRecv == 1 -> {7, Player};
        KingPkey /= Player#player.key -> {12, Player};
        true ->
            RewardList = data_cross_war_daily_reward:get_king_reward(),
            GiveGoodsList = goods:make_give_goods_list(683, RewardList),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            ?DEBUG("RewardList:~p", [RewardList]),
            NewStCrossWar = StCrossWar#st_cross_war{is_king_reward = 1, op_time = util:unixtime()},
            lib_dict:put(?PROC_STATUS_CROSS_WAR, NewStCrossWar),
            cross_war_load:update(NewStCrossWar),
            log(Player#player.key, ?CROSS_WAR_TYPE_KING_REWARD, RewardList),
            {1, NewPlayer}
    end.

%% 领取成员奖励
recv_member_reward(Player) ->
    StCrossWar = lib_dict:get(?PROC_STATUS_CROSS_WAR),
    #st_cross_war{
        is_member_reward = IsRecv
    } = StCrossWar,
    KingGuildKey = cross_area:war_apply_call(?MODULE, get_king_guild_key, []),
    if
        KingGuildKey /= Player#player.guild#st_guild.guild_key ->
            {13, Player}; %% 非城主仙盟
        KingGuildKey == 0 ->
            {13, Player}; %% 非城主仙盟
        IsRecv == 1 -> {7, Player};
        true ->
            RewardList = data_cross_war_daily_reward:get_member_reward(),
            ?DEBUG("RewardList:~p", [RewardList]),
            GiveGoodsList = goods:make_give_goods_list(684, RewardList),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            NewStCrossWar = StCrossWar#st_cross_war{is_member_reward = 1, op_time = util:unixtime()},
            lib_dict:put(?PROC_STATUS_CROSS_WAR, NewStCrossWar),
            cross_war_load:update(NewStCrossWar),
            log(Player#player.key, ?CROSS_WAR_TYPE_MEMBER_REWARD, RewardList),
            {1, NewPlayer}
    end.

log(Pkey, Type, RecvList) ->
    Sql = io_lib:format("insert into log_cross_war_daily set pkey=~p,type=~p,recv_list='~s',time=~p",
        [Pkey, Type, util:term_to_bitstring(RecvList), util:unixtime()]),
    log_proc:log(Sql),
    ok.

get_king_guild_key() ->
    ?CALL(cross_war_proc:get_server_pid(), get_king_guild_key).

get_king_pkey() ->
    ?CALL(cross_war_proc:get_server_pid(), get_king_pkey).

enter_cross_war_scene(Player, TargetScene, Copy) ->
    {MySign, X, Y} = cross_area:war_apply_call(?MODULE, get_sign_born_x_y, [Player#player.guild#st_guild.guild_key]),
    if
        MySign == 0 -> {false, ?T("还未加入阵营")};
        true ->
            {true, Player, TargetScene#scene.id, Copy, X, Y, TargetScene#scene.name, TargetScene#scene.sid}
    end.

get_sign_born_x_y(GuildKey) ->
    case cross_war_util:get_by_g_key(GuildKey) of
        [] -> {0, 0, 0};
        #cross_war_guild{sign = Sign, contrib_rank = Rank} ->
            if
                Sign == 0 -> {0, 0, 0};
                Sign == ?CROSS_WAR_TYPE_DEF ->
                    BornList = ?IF_ELSE(Rank =< 3, data_cross_war_player_born:get(1), data_cross_war_player_born:get(2)),
                    {X, Y} = util:list_rand(BornList),
                    {Sign, X, Y};
                true ->
                    BornList = ?IF_ELSE(Rank =< 3, data_cross_war_player_born:get(3), data_cross_war_player_born:get(4)),
                    {X, Y} = util:list_rand(BornList),
                    {Sign, X, Y}
            end
    end.

get_cross_war_info(Player) ->
    ?CAST(cross_war_proc:get_server_pid(), {get_cross_war_info, Player}).

get_cross_war_info_cast(State, Player) ->
    #sys_cross_war{
        king_info = KingInfo0,
        kill_king_door_list = KillKingDoorList0,
        kill_war_door_list = KillWarDoorList0,
        def_guild_list = DefGuildList,
        att_guild_list = AttGuildList
    } = State,
    Week = util:get_day_of_week(),
    PassSec = util:get_seconds_from_midnight(),
    if
        Week == 6 ->
            KillKingDoorList = [],
            KillWarDoorList = [],
            KingInfo = #cross_war_king{};
        Week == 7 andalso PassSec < 21*?ONE_HOUR_SECONDS ->
            KillKingDoorList = [],
            KillWarDoorList = [],
            KingInfo = #cross_war_king{};
        true ->
            KillKingDoorList = KillKingDoorList0,
            KillWarDoorList = KillWarDoorList0,
            KingInfo = KingInfo0
    end,
    #cross_war_king{
        g_name = KingGuildName,
        sn = KingSn,
        sn_name = KingSnName,
        acc_win = KingAccWin
    } = KingInfo,
    GuildKey = Player#player.guild#st_guild.guild_key,
    MySign =
        case lists:keyfind(GuildKey, #cross_war_guild.g_key, DefGuildList ++ AttGuildList) of
            false ->
                case cross_war_util:get_by_g_key(Player#player.guild#st_guild.guild_key) of
                    [] -> 0; %% 游客
                    #cross_war_guild{sign = Sign0} -> Sign0
                end;
            #cross_war_guild{sign = Sign0} ->
                Sign0
        end,
    F = fun(CrossWarLog) ->
        #cross_war_log{
            sn = MemberSn,
            sn_name = MemberSnName,
            nickname = MemberNickName
        } = CrossWarLog,
        [MemberSn, MemberSnName, MemberNickName]
    end,
    ProList1 = lists:map(F, KillKingDoorList),
    ProList2 = lists:map(F, KillWarDoorList),

    F1 = fun(CrossWarGuild) ->
        #cross_war_guild{
            sn = GuildSn,
            sn_name = GuildSnName,
            g_name = GuildName
        } = CrossWarGuild,
        [GuildSn, GuildSnName, GuildName]
    end,
    AllDefGuildList = cross_war_util:get_guild_contrib_sort(?CROSS_WAR_TYPE_DEF),
    AllAttGuildList = cross_war_util:get_guild_contrib_sort(?CROSS_WAR_TYPE_ATT),
    NewDefGuildList =
        if
            DefGuildList == [] -> lists:sublist(AllDefGuildList, ?CROSS_WAR_SIGN_GUILD_MAX_NUM);
            true -> DefGuildList
        end,
    NewAttGuildList =
        if
            AttGuildList == [] -> lists:sublist(AllAttGuildList, ?CROSS_WAR_SIGN_GUILD_MAX_NUM);
            true -> AttGuildList
        end,
    ProDefGuildList = lists:map(F1, NewDefGuildList),
    ProAttGuildList = lists:map(F1, NewAttGuildList),
    Pro = {
        KingSn, KingSnName, KingGuildName, KingAccWin, MySign,
        ProList1, ProList2, ProDefGuildList, ProAttGuildList
    },
    {ok, Bin} = pt_601:write(60116, Pro),
    server_send:send_to_sid(Player#player.node, Player#player.sid, Bin).
%%    center:apply(Player#player.node, server_send, send_to_sid, [Player#player.sid, Bin]).

enter_cross_war(Player) ->
    PlayerCouple =
        if
            Player#player.marry#marry.couple_key == 0 -> #player{};
            true ->
                shadow_proc:get_shadow(Player#player.marry#marry.couple_key)
        end,
    cross_area:war_apply(cross_war, enter_cross_war, [Player, PlayerCouple]).

enter_cross_war(Player, PlayerCouple) ->
    ?CAST(cross_war_proc:get_server_pid(), {enter_cross_war, Player, PlayerCouple}).

enter_cross_war_cast(State, Player) ->
    #sys_cross_war{
        king_info = KingInfo,
        open_state = OpenState,
        def_guild_list = DefGuildList,
        att_guild_list = AttGuildList,
        def_player_list = DefPlayerList,
        att_player_list = AttPlayerList
    } = State,
    GuildKey = Player#player.guild#st_guild.guild_key,
    AccWin = KingInfo#cross_war_king.acc_win,
    Res =
        if
            OpenState == ?CROSS_WAR_STATE_CLOSE -> {fail, 27};
            GuildKey == 0 -> {fail, 3};
            OpenState /= ?CROSS_WAR_STATE_START -> {fail, 2};
            Player#player.lv < ?CROSS_WAR_LIMIT_LV -> {fail, 16};
            true ->
                case lists:keyfind(GuildKey, #cross_war_guild.g_key, DefGuildList ++ AttGuildList) of
                    false -> {fail, 8};
                    #cross_war_guild{sign = Sign, player_born_xy_list = BornList} -> {true, Sign, BornList}
                end
        end,
    case Res of
        {fail, Code} ->
            {ok, Bin} = pt_601:write(60117, {Code}),
            server_send:send_to_sid(Player#player.node, Player#player.sid, Bin),
            {fail, State};
        {true, WarSign, WarBornList} ->
            {ok, Bin} = pt_601:write(60117, {1}),
            server_send:send_to_sid(Player#player.node, Player#player.sid, Bin),
            if
                WarSign == ?CROSS_WAR_TYPE_DEF ->
                    NewState = State#sys_cross_war{def_player_list = util:list_filter_repeat([Player#player.key | DefPlayerList])};
                true ->
                    case data_cross_war_buff:get(AccWin) of
                        [] ->
                            skip;
                        BuffId -> %% 增加buff
                            center:apply(Player#player.node, ?MODULE, add_buff, [Player#player.pid, BuffId])
                    end,
                    NewState = State#sys_cross_war{att_player_list = util:list_filter_repeat([Player#player.key | AttPlayerList])}
            end,
            {X, Y} = util:list_rand(WarBornList),
            center:apply(Player#player.node, ?MODULE, change_scene_enter, [Player#player.key, Player#player.pid, X, Y, WarSign]),
            {true, NewState}
    end.

add_buff(Pkey, BuffId) when is_integer(Pkey) ->
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [#ets_online{pid = Pid}] ->
            Pid ! {buff, BuffId};
        _ -> ok
    end;

add_buff(Pid, BuffId) ->
    Pid ! {buff, BuffId}.

delete_buff(Pid, BuffId) ->
    Pid ! {del_buff, [BuffId]}.

delete_buff_list(Pid, BuffIdList) ->
    Pid ! {del_buff, BuffIdList}.

change_scene_enter(Pkey, Pid, X, Y, WarSign) ->
    Sql = io_lib:format("insert into log_cross_war_enter set pkey=~p, sign=~p, time=~p",
        [Pkey, WarSign, util:unixtime()]),
    log_proc:log(Sql),
    Pid ! {enter_cross_war, 0, X, Y, WarSign}.

change_scene_back(Pid) ->
    Pid ! quit_cross_war.

quit_war() ->
    OnlineList = ets:tab2list(?ETS_ONLINE),
    lists:map(fun(#ets_online{pid = Pid}) -> change_scene_back(Pid) end, OnlineList).

quit_war(Player) ->
    quit(Player#player.key, Player#player.x, Player#player.y),
    AccWin = ?CALL(cross_war_proc:get_server_pid(), get_acc_win),
    case data_cross_war_buff:get(AccWin) of
        [] -> skip;
        BuffId ->
            BuffId2 = data_cross_war_buff:get(AccWin - 1),
            center:apply(Player#player.node, ?MODULE, delete_buff, [Player#player.pid, [BuffId, BuffId2]])
    end,
    {ok, Bin} = pt_601:write(60120, {1}),
    server_send:send_to_sid(Player#player.node, Player#player.sid, Bin),
    center:apply(Player#player.node, ?MODULE, change_scene_back, [Player#player.pid]),
    ok.

%% 确定防御方 及 攻击方
get_guild_data(State) ->
    DefGuildList0 = cross_war_util:get_guild_contrib_sort(?CROSS_WAR_TYPE_DEF),
    AttGuildList0 = cross_war_util:get_guild_contrib_sort(?CROSS_WAR_TYPE_ATT),
    DefF = fun(#cross_war_guild{contrib_val = DefVal, is_main = IsMain}) ->
        DefVal > 0 orelse IsMain > 0
    end,
    DefGuildList = lists:filter(DefF, DefGuildList0),
    AttF = fun(#cross_war_guild{contrib_val = AttVal, is_main = IsMain}) ->
        AttVal > 0 orelse IsMain > 0
    end,
    AttGuildList = lists:filter(AttF, AttGuildList0),
    NewState =
        State#sys_cross_war{
            def_guild_list = def_guild_born(lists:sublist(DefGuildList, ?CROSS_WAR_SIGN_GUILD_MAX_NUM)),
            att_guild_list = att_guild_born(lists:sublist(AttGuildList, ?CROSS_WAR_SIGN_GUILD_MAX_NUM))
        },
    NewState.

def_guild_born(DefGuildList) ->
    F = fun(CrossWarGuild) ->
        #cross_war_guild{contrib_rank = DefRank} = CrossWarGuild,
        if
            DefRank =< ?CROSS_WAR_SIGN_GUILD_MAX_NUM div 2 ->
                BornList = data_cross_war_player_born:get(1),
                CrossWarGuild#cross_war_guild{player_born_xy_list = BornList};
            true ->
                BornList = data_cross_war_player_born:get(2),
                CrossWarGuild#cross_war_guild{player_born_xy_list = BornList}
        end
    end,
    lists:map(F, DefGuildList).

att_guild_born(AttGuildList) ->
    F = fun(CrossWarGuild) ->
        #cross_war_guild{contrib_rank = AttRank} = CrossWarGuild,
        if
            AttRank =< ?CROSS_WAR_SIGN_GUILD_MAX_NUM div 2 ->
                BornList = data_cross_war_player_born:get(3),
                CrossWarGuild#cross_war_guild{player_born_xy_list = BornList};
            true ->
                BornList = data_cross_war_player_born:get(4),
                CrossWarGuild#cross_war_guild{player_born_xy_list = BornList}
        end
    end,
    lists:map(F, AttGuildList).

notice_all_client(State) ->
    #sys_cross_war{
        def_guild_list = DefGuildList,
        att_guild_list = AttGuildList
    } = State,
    {ok, Bin} = pt_601:write(60118, {1}),
    F = fun(#cross_war_guild{g_key = GuildKey, node = Node}) ->
        center:apply(Node, ?MODULE, notice_to_guild, [GuildKey, Bin])
    end,
    lists:map(F, DefGuildList ++ AttGuildList),
    ok.

notice_to_guild(GuildKey, Bin) ->
    AllMember = guild_ets:get_guild_member_list(GuildKey),
    F = fun(#g_member{pkey = Pkey, lv = Lv, is_online = IsOnline}) ->
        ?IF_ELSE(IsOnline == 1 andalso Lv >= ?CROSS_WAR_LIMIT_LV, server_send:send_to_key(Pkey, Bin), ok)
    end,
    lists:map(F, AllMember),
    ok.

get_now_war_info(Node, Pkey, Sid) ->
    ?CAST(cross_war_proc:get_server_pid(), {get_now_war_info, Node, Pkey, Sid}).

get_now_war_info_cast(State, Node, Playerkey, Sid) ->
    #sys_cross_war{
        king_gold = {_GKey, Pkey},
        mon_list = MonList,
        collect_num = CollectNum
    } = State,
    CrossWarPlayer = cross_war_util:get_by_pkey(Playerkey),
    #cross_war_player{
        score = TotalScore,
        has_materis = HasMateris,
        has_bomb = HasBomb,
        has_car = HasCar
    } = CrossWarPlayer,
    case cross_war_util:get_by_pkey(Pkey) of
        [] -> Sn = 0, SName = <<>>, NickName = <<>>, AccKillNum = 0;
        #cross_war_player{sn = Sn0, sn_name = SnName0, nickname = NickName0, acc_kill_num = AccKillNum0} ->
            Sn = Sn0, SName = SnName0, NickName = NickName0, AccKillNum = AccKillNum0
    end,
    ProMonList = get_pro_mon_list(MonList),
    KingGoldState =
        if
            Pkey > 0 -> 1;
            CollectNum > 0 -> 2;
            true -> 0
        end,
    {ok, Bin} = pt_601:write(60119, {TotalScore, HasMateris, HasBomb, HasCar, NickName, Sn, SName, AccKillNum, KingGoldState, ProMonList}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Player#player.node, server_send, send_to_sid, [Player#player.sid, Bin]),
    ok.

%% 活动结束结算
sys_end_cacl(State) ->
    #sys_cross_war{king_info = KingInfo, king_gold = {Gkey, Pkey}} = State,
    if
        Gkey == 0 ->
            sys_end_cacl1(State#sys_cross_war{king_gold = {KingInfo#cross_war_king.g_key, KingInfo#cross_war_king.pkey}});
        true ->
            %% 处理最后携带王珠奖励
            CollectReward = data_cross_war_other_reward:get_king_gold_reward(),
            CrossWarGuild = cross_war_util:get_by_g_key(Gkey),
            spawn(fun() ->
                center:apply(CrossWarGuild#cross_war_guild.node, cross_war_battle, send_to_client_reward, [Pkey, CollectReward, 685]) end),
            sys_end_cacl1(State)
    end.

sys_end_cacl1(State) ->
    #sys_cross_war{
        king_gold = {GKey, _PKey}
    } = State,
    if
        GKey /= 0 ->
            sys_end_cacl2(State);
        true ->
            LL = cross_war_util:get_guild_score_sort(?CROSS_WAR_TYPE_DEF) ++ cross_war_util:get_guild_score_sort(?CROSS_WAR_TYPE_ATT),
            if
                LL == [] -> State;
                true ->
                    CrossWarGuild = hd(LL),
                    NewState = State#sys_cross_war{king_gold = {CrossWarGuild#cross_war_guild.g_key, CrossWarGuild#cross_war_guild.g_pkey}},
                    sys_end_cacl2(NewState)
            end
    end.

sys_end_cacl2(State) ->
    #sys_cross_war{
        king_gold = {GKey, PKey},
        king_info = KingInfo,
        last_king_info = LastKingInfo,
        def_guild_list = DefGuildList,
        att_guild_list = AttGuildList
    } = State,
    CrossWarGuild = cross_war_util:get_by_g_key(GKey),
    CrossWarPlayer =
        case cross_war_util:get_by_pkey(PKey) of
            [] -> #cross_war_player{};
            RR ->
                RR
        end,
    #cross_war_player{
        pkey = Pkey, %% 城主key
        nickname = NickName,
        sex = Sex,
        wing_id = WingId,
        wepon_id = WeponId,
        clothing_id = ClothingId,
        light_wepon_id = LightWeponId,
        fashion_cloth_id = FashionClothId,
        fashion_head_id = FashionHeadId,
        couple_pkey = CouplePkey, %% 城主夫人key
        couple_nickname = CoupleNickname,
        couple_sex = CoupleSex,
        couple_wing_id = CoupleWingId,
        couple_wepon_id = CoupleWeponId,
        couple_clothing_id = CoupleClothingId,
        couple_light_wepon_id = CoupleLightWeponId,
        couple_fashion_cloth_id = CoupleFashionClothId,
        couple_fashion_head_id = CouleFashionHeadId,
        node = Node,
        sn = Sn,
        sn_name = SnName,
        g_key = GuildKey,
        g_name = GuildName
    } = CrossWarPlayer,
    CrossWarKing =
        #cross_war_king{
            pkey = Pkey, %% 城主key
            nickname = NickName,
            sex = Sex,
            wing_id = WingId,
            wepon_id = WeponId,
            clothing_id = ClothingId,
            light_wepon_id = LightWeponId,
            fashion_cloth_id = FashionClothId,
            fashion_head_id = FashionHeadId,
            couple_key = CouplePkey, %% 城主夫人key
            couple_nickname = CoupleNickname,
            couple_sex = CoupleSex,
            couple_wing_id = CoupleWingId,
            couple_wepon_id = CoupleWeponId,
            couple_clothing_id = CoupleClothingId,
            couple_light_wepon_id = CoupleLightWeponId,
            couple_fashion_cloth_id = CoupleFashionClothId,
            couple_fashion_head_id = CouleFashionHeadId,
            node = Node,
            sn = Sn,
            sn_name = SnName,
            g_key = GuildKey,
            g_name = GuildName,
            acc_win = ?IF_ELSE(KingInfo#cross_war_king.g_key == GKey, KingInfo#cross_war_king.acc_win + 1, 1),
            war_info = ?IF_ELSE(CrossWarGuild#cross_war_guild.sign == ?CROSS_WAR_TYPE_DEF, cross_war_util:make_war_info(DefGuildList, GKey), cross_war_util:make_war_info(AttGuildList, GKey))
        },
    NewState =
        State#sys_cross_war{
            king_info = CrossWarKing,
            last_king_info = KingInfo,
            win_sign = CrossWarGuild#cross_war_guild.sign
        },
    spawn(fun() -> send_king_guild_mail(CrossWarKing) end),
    if
        KingInfo#cross_war_king.pkey == Pkey -> %% 守护成功公告
            spawn(fun() -> cross_war_util:sys_cross_notice(cross_war_guard_success, [SnName, GuildName]) end);
        true -> %% 新的城主
            spawn(fun() -> send_old_king_guild_mail(KingInfo) end),
            spawn(fun() -> cross_war_util:sys_notice(cross_war_new_king, [SnName, GuildName]) end),
            spawn(fun() -> cross_war_util:sys_cross_notice(cross_war_new_king_2, [SnName, GuildName]) end)
    end,
    cross_war_util:update_war_guild(CrossWarGuild#cross_war_guild{is_main = 1}),
    case cross_war_util:get_by_g_key(KingInfo#cross_war_king.g_key) of
        [] ->
            skip;
        OldCrossWarGuild ->
            if
                OldCrossWarGuild#cross_war_guild.g_key == CrossWarGuild#cross_war_guild.g_key -> skip;
                true -> cross_war_util:update_war_guild(OldCrossWarGuild#cross_war_guild{is_main = 2})
            end
    end,

    case cross_war_util:get_by_g_key(LastKingInfo#cross_war_king.g_key) of
        [] ->
            skip;
        LastCrossWarGuild ->
            if
                LastCrossWarGuild#cross_war_guild.g_key == CrossWarGuild#cross_war_guild.g_key -> skip;
                true -> cross_war_util:update_war_guild(LastCrossWarGuild#cross_war_guild{is_main = 0})
            end
    end,
    NewState.

%% 战斗结束后将其设置为防守或者复仇攻击
set_sign(0, _Sign) -> ok;
set_sign(KingGkey, Sign) ->
    case cross_war_util:get_by_g_key(KingGkey) of
        [] -> ok;
        CrossWarGuild ->
            cross_war_util:update_war_guild(CrossWarGuild#cross_war_guild{sign = Sign}),
            spawn(fun() ->
                timer:sleep(25000),
                center:apply(CrossWarGuild#cross_war_guild.node, cross_war_load, dbup_guild_sign, [KingGkey, Sign, util:unixtime()])
            end)
    end,
    ok.

send_old_king_guild_mail(CrossWarKing) ->
    #cross_war_king{g_key = GKey, node = Node} = CrossWarKing,
    {Title, Content} = t_mail:mail_content(124),
    if
        GKey == 0 -> skip;
        Node == null -> skip;
        true -> center:apply(Node, ?MODULE, send_to_client_mail, [Title, Content, [], GKey])
    end.

send_king_guild_mail(CrossWarKing) ->
    #cross_war_king{g_key = GKey, node = Node} = CrossWarKing,
    {Title, Content} = t_mail:mail_content(123),
    if
        Node == null -> skip;
        true ->
            center:apply(Node, ?MODULE, send_to_client_mail, [Title, Content, [], GKey])
    end,
    ok.

to_client_result(State) ->
    #sys_cross_war{
        king_info = KingInfo,
        win_sign = WinSign
    } = State,
    #cross_war_king{
        sn = Sn,
        sn_name = SnName,
        g_name = GuildName
    } = KingInfo,
    {ok, Bin} = pt_601:write(60122, {WinSign, Sn, SnName, GuildName}),
    server_send:send_to_scene(?SCENE_ID_CROSS_WAR, Bin),
    ok.

notice_client_quit() ->
    Nodes = center:get_war_nodes(),
    F = fun(Node) ->
        center:apply(Node, ?MODULE, quit_war, [])
    end,
    lists:map(F, Nodes),
    ok.

to_client_reward(State) ->
    #sys_cross_war{
        win_sign = WinSign,
        king_info = KingInfo,
        def_guild_list = DefGuildList,
        att_guild_list = AttGuildList
    } = State,
    DefRankList = get_type_mail_rank_list(DefGuildList, ?CROSS_WAR_TYPE_DEF),
    AttRankList = get_type_mail_rank_list(AttGuildList, ?CROSS_WAR_TYPE_ATT),
    ?DEBUG("AttRankList:~p", [AttRankList]),
    if
        WinSign == ?CROSS_WAR_TYPE_DEF -> %% 防守成功奖励
            DefRewardList = data_cross_war_other_reward:get_def_success_reward(),
            {DefTitle, DefContent} = t_mail:mail_content(119),
            to_client_mail(DefTitle, DefContent, DefRewardList, DefGuildList, DefRankList),
            AttRewardList = data_cross_war_other_reward:get_att_fail_reward(),
            {AttTitle, AttContent} = t_mail:mail_content(122),
            to_client_mail(AttTitle, AttContent, AttRewardList, AttGuildList, AttRankList),
            ok;
        true ->
            DefRewardList = data_cross_war_other_reward:get_def_fail_reward(),
            {DefTitle, DefContent} = t_mail:mail_content(120),
            to_client_mail(DefTitle, DefContent, DefRewardList, DefGuildList, DefRankList),
            AttRewardList = data_cross_war_other_reward:get_att_success_reward(),
            ?DEBUG("AttRewardList:~p", [AttRewardList]),
            {AttTitle, AttContent} = t_mail:mail_content(121),
            to_client_mail(AttTitle, AttContent, AttRewardList, AttGuildList, AttRankList),
            ok
    end,
    to_king_reward_mail(KingInfo).

get_type_mail_rank_list(CrossWarGuildList, Type) ->
    CrossWarPlayerList = cross_war_util:get_player_score_sort(Type),
    F = fun(#cross_war_player{g_key = Gkey, pkey = Pkey, score_rank = ScoreRank}) ->
        case lists:keyfind(Gkey, #cross_war_guild.g_key, CrossWarGuildList) of
            false -> [];
            _ ->
                [{Pkey, ScoreRank}]
        end
    end,
    lists:flatmap(F, CrossWarPlayerList).

to_client_mail(Title, Content, RewardList, CrossWarGuildList, RankInfoList) ->
    F = fun(#cross_war_guild{g_key = GuildKey, node = Node, score_rank = _ScoreRank}) ->
        CrossWarGuild = cross_war_util:get_by_g_key(GuildKey),
        ScoreRank = ?IF_ELSE(CrossWarGuild#cross_war_guild.score_rank == 0, 10, CrossWarGuild#cross_war_guild.score_rank),
        NewAddGuildRewardList = data_cross_war_guild_score_reward:get_by_rank(ScoreRank),
        ?DEBUG("CrossWarGuild#cross_war_guild.score_rank:~p", [CrossWarGuild#cross_war_guild.score_rank]),
        if
            Node == null -> skip;
            true ->
                center:apply(Node, ?MODULE, send_to_client_mail, [Title, Content, RewardList ++ NewAddGuildRewardList, GuildKey, RankInfoList])
        end
    end,
    lists:map(F, CrossWarGuildList).

send_to_client_mail(Title, Content, RewardList, GuildKey, RankInfoList) ->
    MemberList = guild_ets:get_guild_member_list(GuildKey),
    F = fun(#g_member{pkey = Pkey}) ->
        AddRewardList =
            case lists:keyfind(Pkey, 1, RankInfoList) of
                false -> %% 没有参赛给的保底仙盟成员奖励
                    data_cross_war_member_score_reward:get_by_rank(99999);
                {Pkey, Rank} ->
                    data_cross_war_member_score_reward:get_by_rank(Rank)
            end,
        mail:sys_send_mail([Pkey], Title, Content, RewardList ++ AddRewardList),
        Sql = io_lib:format("insert into log_cross_war_reward set pkey=~p, title='~s', content='~s', reward='~s',time=~p",
            [Pkey, Title, Content, util:term_to_bitstring(RewardList ++ AddRewardList), util:unixtime()]),
        log_proc:log(Sql)
    end,
    lists:map(F, MemberList),
    ok.

send_to_client_mail(Title, Content, RewardList, GuildKey) ->
    MemberList = guild_ets:get_guild_member_list(GuildKey),
    F = fun(#g_member{pkey = Pkey}) ->
        Sql = io_lib:format("insert into log_cross_war_reward set pkey=~p, title='~s', content='~s', reward='~s',time=~p",
            [Pkey, Title, Content, util:term_to_bitstring(RewardList), util:unixtime()]),
        log_proc:log(Sql),
        Pkey
    end,
    KeyList = lists:map(F, MemberList),
    mail:sys_send_mail(KeyList, Title, Content, RewardList),
    ok.

log(Pkey, Title, Content, RewardList) ->
    Sql = io_lib:format("insert into log_cross_war_reward set pkey=~p, title='~s', content='~s', reward='~s',time=~p",
        [Pkey, Title, Content, util:term_to_bitstring(RewardList), util:unixtime()]),
    log_proc:log(Sql).

to_king_reward_mail(KingInfo) ->
    %% 城主奖励
    #cross_war_king{pkey = Pkey} = KingInfo,
    case cross_war_util:get_by_pkey(Pkey) of
        [] -> skip;
        #cross_war_player{couple_pkey = CoupleKey, g_key = GuildKey, node = Node} ->
            KingRewardList = data_cross_war_other_reward:get_king_reward(),
            {KingTitle, KingContent} = t_mail:mail_content(125),
            center:apply(Node, mail, sys_send_mail, [[Pkey], KingTitle, KingContent, KingRewardList]),
            center:apply(Node, ?MODULE, log, [Pkey, KingTitle, KingContent, KingRewardList]),
            %% 城主夫人奖励
            KingCoupleRewardList = data_cross_war_other_reward:get_king_couple_reward(),
            {KingCoupleTitle, KingCoupleContent} = t_mail:mail_content(126),
            if
                CoupleKey == 0 ->
                    skip;
                true ->
                    center:apply(Node, mail, sys_send_mail, [[CoupleKey], KingCoupleTitle, KingCoupleContent, KingCoupleRewardList]),
                    center:apply(Node, ?MODULE, log, [CoupleKey, KingCoupleTitle, KingCoupleContent, KingRewardList])
            end,
            %% 城主仙盟奖励
            KingGuildReward = data_cross_war_other_reward:get_king_guild_reward(),
            {KingGuildTitle, KingGuildContent} = t_mail:mail_content(127),
            center:apply(Node, ?MODULE, send_to_client_mail, [KingGuildTitle, KingGuildContent, KingGuildReward, GuildKey]),
            ok
    end.

get_pro_mon_list(MonList) ->
    F = fun({MonKey, _MonPid, Mon}) ->
        #mon{mid = Mid, kind = MonKind, hp = Hp, hp_lim = HpLim} = Mon,
        case MonKind == ?MON_KIND_CROSS_WAR_DOOR orelse MonKind == ?MON_KIND_CROSS_WAR_KING_DOOR of
            true -> [[MonKey, Mid, Hp, HpLim]];
            false -> []
        end
    end,
    lists:flatmap(F, MonList).

notice_client_update_score(State) when State#sys_cross_war.open_state == ?CROSS_WAR_STATE_START ->
    #sys_cross_war{
        king_gold = {_, Pkey},
        def_player_list = DefPlayerList,
        att_player_list = AttPlayerList,
        mon_list = MonList,
        collect_num = CollectNum
    } = State,
    {Sn, SnName, NickName} =
        case cross_war_util:get_by_pkey(Pkey) of
            [] -> {0, <<>>, <<>>};
            #cross_war_player{sn = Sn0, sn_name = SnName0, nickname = NickName0} ->
                {Sn0, SnName0, NickName0}
        end,
    ProMonList = get_pro_mon_list(MonList),
    KingGoldState =
        if
            Pkey > 0 -> 1;
            CollectNum > 0 -> 2;
            true -> 0
        end,
    F = fun(ProPkey) ->
        case cross_war_util:get_by_pkey(ProPkey) of
            #cross_war_player{node = Node, acc_kill_num = AccKillNum, sid = Sid, is_online = IsOnline, score = Score, has_materis = HasMateris, has_bomb = HasBomb, has_car = HasCar} when IsOnline == 1 ->
                {ok, Bin} = pt_601:write(60119, {Score, HasMateris, HasBomb, HasCar, NickName, Sn, SnName, AccKillNum, KingGoldState, ProMonList}),
                server_send:send_to_sid(Node, Sid, Bin);
%%                center:apply(Node, server_send, send_to_sid, [Sid, Bin]);
            _ -> skip
        end
    end,
    lists:map(F, DefPlayerList ++ AttPlayerList),
    ok;

notice_client_update_score(_State) -> ok.

%% 活动开始，做返还
sys_back_center(NewState) ->
    #sys_cross_war{
        def_guild_list = DefGuildList,
        att_guild_list = AttGuildList
    } = NewState,
    F0 = fun(#cross_war_guild{g_key = Gkey}) ->
        Gkey
    end,
    GkeyList = lists:map(F0, DefGuildList ++ AttGuildList),
    Nodes = center:get_war_nodes(),
    F = fun(Node) ->
        center:apply(Node, ?MODULE, sys_back, [GkeyList])
    end,
    lists:map(F, Nodes),
    ok.

sys_back(GuildKeyList) ->
    AllPkeyList = cross_war_load:get_all_pkey_list(),
    F = fun([Pkey, GuildKey, DefListBin]) ->
        case lists:member(GuildKey, GuildKeyList) of
            true ->
                ok;
            false ->
                BackList = util:bitstring_to_term(DefListBin),
                {Title, Content} = t_mail:mail_content(114),
                if
                    Pkey == 0 -> skip;
                    BackList == [] -> skip;
                    true ->
                        mail:sys_send_mail([Pkey], Title, Content, cacl_back_list(BackList)),
                        log(Pkey, Title, Content, cacl_back_list(BackList))
                end
        end
    end,
    lists:map(F, AllPkeyList),
    ok.

get_cross_war_guild() ->
    ?CALL(cross_war_proc:get_server_pid(), get_all_guild_key_list).

cacl_back_list(L) ->
    F = fun({Id, Num}, AccList) ->
        case lists:keyfind(Id, 1, AccList) of
            false -> [{Id, Num} | AccList];
            {Id, OldNum} ->
                NAccList = AccList -- [{Id, OldNum}],
                [{Id, Num + OldNum} | NAccList]
        end
    end,
    lists:foldl(F, [], L).

%% 获取参战的公会key
get_cross_war_guild_call(State) ->
    #sys_cross_war{def_guild_list = DefGuildList, att_guild_list = AttGuildList} = State,
    F = fun(#cross_war_guild{g_key = GuildKey}) -> GuildKey end,
    lists:map(F, DefGuildList ++ AttGuildList).

exchange_bomb(Pkey, Node, Sid) ->
    cross_area:war_apply_call(?MODULE, exchange_bomb_center, [Pkey, Node, Sid]).

%% 兑换炸弹
exchange_bomb_center(Pkey, Node, Sid) ->
    case cross_war_util:get_by_pkey(Pkey) of
        [] -> 0;
        CrossWarPlayer ->
            NeedMarteris = data_cross_war_materia_exchange:get(1),
            if
                CrossWarPlayer#cross_war_player.has_materis < NeedMarteris -> 14; %% 资源不足
                CrossWarPlayer#cross_war_player.has_bomb > 0 -> 17; %% 已经有了炸弹
                true ->
                    cross_war_util:update_war_player(CrossWarPlayer#cross_war_player{has_bomb = CrossWarPlayer#cross_war_player.has_bomb + 1}),
                    cross_war_util:add_materis_player(Pkey, -NeedMarteris),
                    ?CAST(cross_war_proc:get_server_pid(), {get_now_war_info, Node, Pkey, Sid}),
                    1
            end
    end.

exchange_car(Pkey, Node, Sid) ->
    cross_area:war_apply_call(?MODULE, exchange_car_center, [Pkey, Node, Sid]).

%% 兑换战车
exchange_car_center(Pkey, Node, Sid) ->
    case cross_war_util:get_by_pkey(Pkey) of
        [] -> 0;
        CrossWarPlayer ->
            NeedMarteris = data_cross_war_materia_exchange:get(2),
            if
                CrossWarPlayer#cross_war_player.has_materis < NeedMarteris -> 14; %% 资源不足
                true ->
                    cross_war_util:update_war_player(CrossWarPlayer#cross_war_player{has_car = CrossWarPlayer#cross_war_player.has_car + 1}),
                    cross_war_util:add_materis_player(Pkey, -NeedMarteris),
                    ?CAST(cross_war_proc:get_server_pid(), {get_now_war_info, Node, Pkey, Sid}),
                    center:apply(Node, ?MODULE, add_buff, [Pkey, 154]),
                    1
            end
    end.

get_now_king_x_y(XX, YY, Node, Sid) ->
    ?CAST(cross_war_proc:get_server_pid(), {get_now_king_x_y, XX, YY, Node, Sid}).

get_now_king_x_y_cast(State, _XX, _YY, Node, Sid) ->
    #sys_cross_war{king_gold = {_GKey, Pkey}, map = Map} = State,
    {XX, YY} =
        case scene_agent:get_scene_player(?SCENE_ID_CROSS_WAR, 0, Pkey) of
            [] -> {Map#cross_war_map.king_gold_x, Map#cross_war_map.king_gold_y};
            #scene_player{x = X, y = Y} -> {X, Y}
        end,
    {ok, Bin} = pt_601:write(60124, {XX, YY}),
    server_send:send_to_sid(Node, Sid, Bin),
    ok.

put_down_king_gold(Player) ->
    ?CAST(cross_war_proc:get_server_pid(), {put_down_king_gold, Player}).

put_down_king_gold_cast(State, Player) ->
    #sys_cross_war{king_gold = {_KingGuildKey, KingPkey}} = State,
    if
        Player#player.crown == 0 -> State;
        Player#player.key /= KingPkey -> State;
        true ->
            {ok, Bin} = pt_601:write(60125, {1}),
            server_send:send_to_sid(Player#player.node, Player#player.sid, Bin),
            center:apply(Player#player.node, cross_war_battle, set_crown, [Player#player.key, 0]),
            cross_war_util:set_player_crown(Player#player.key, 0),
            {MonKey, MonPid} = mon_agent:create_mon([?CROSS_WAR_MON_ID_KING_GOLD, ?SCENE_ID_CROSS_WAR, Player#player.x, Player#player.y, 0, 1, [{return_id_pid, true}]]),
            NewMap = cross_war_map:update_king_gold(State#sys_cross_war.map, Player#player.x, Player#player.y, 0),
            self() ! update_score_data,
            State#sys_cross_war{
                map = NewMap,
                king_gold = {0, 0},
                mon_list = [{MonKey, MonPid, #mon{}} | State#sys_cross_war.mon_list]
            }
    end.

judge_sign(GuildKey) ->
    case cross_war_util:get_by_g_key(GuildKey) of
        [] -> 0;
        #cross_war_guild{contrib_rank = Rank} ->
            ?IF_ELSE(Rank =< ?CROSS_WAR_SIGN_GUILD_MAX_NUM, 1, 0)
    end.

use_bomb(Player) ->
    case cross_war_util:get_by_pkey(Player#player.key) of
        [] -> ok;
        CrossWarPlayer ->
            if
                CrossWarPlayer#cross_war_player.has_bomb < 1 ->
                    {ok, Bin} = pt_601:write(60126, {15}),
                    server_send:send_to_sid(Player#player.node, Player#player.sid, Bin);
%%                    center:apply(Player#player.node, server_send, send_to_sid, [Player#player.sid, Bin]);
                true ->
                    {ok, Bin} = pt_601:write(60126, {1}),
                    server_send:send_to_sid(Player#player.node, Player#player.sid, Bin),
%%                    center:apply(Player#player.node, server_send, send_to_sid, [Player#player.sid, Bin]),
                    cross_war_util:update_war_player(CrossWarPlayer#cross_war_player{has_bomb = CrossWarPlayer#cross_war_player.has_bomb - 1}),
                    CrossWarGuild = cross_war_util:get_by_g_key(Player#player.guild#st_guild.guild_key),
                    mon_agent:create_mon([?CROSS_WAR_MON_ID_BOMB2, ?SCENE_ID_CROSS_WAR, Player#player.x, Player#player.y, 0, 1, [{group, CrossWarGuild#cross_war_guild.sign}]]),
                    cross_war_proc:get_server_pid() ! update_score_data
            end
    end.

update_cross_mon_hp_cast(State, Mon) ->
    case Mon#mon.kind == ?MON_KIND_CROSS_WAR_DOOR orelse Mon#mon.kind == ?MON_KIND_CROSS_WAR_KING_DOOR of
        false ->
            cross_war_map:update(State, Mon);
        true ->
            OldMonList = State#sys_cross_war.mon_list,
            NewMonList =
                case lists:keytake(Mon#mon.key, 1, OldMonList) of
                    false -> OldMonList;
                    {value, {MonKey, MonPid, _OldMon}, Rest} ->
                        [{MonKey, MonPid, Mon} | Rest]
                end,
            State#sys_cross_war{mon_list = NewMonList}
    end.

update_cross_war_mon_klist(Mon, _KList, _AttKey, _AttNode) ->
    IsCrossWarScene = scene:is_cross_war_scene(Mon#mon.scene),
    if
        IsCrossWarScene == false ->
            skip;
        Mon#mon.kind /= ?MON_KIND_CROSS_WAR_DOOR andalso Mon#mon.kind /= ?MON_KIND_CROSS_WAR_KING_DOOR andalso Mon#mon.kind /= ?MON_KIND_CROSS_WAR_KING_GOLD andalso Mon#mon.kind /= ?MON_KIND_CROSS_WAR_BANNER andalso Mon#mon.kind /= ?MON_KIND_CROSS_WAR_TOWER ->
            skip;
        Mon#mon.hp =< 0 ->
            ?CAST(cross_war_proc:get_server_pid(), {update_cross_mon_hp, Mon});
        true ->
            Now = util:unixtime(),
            Key = update_cross_war_klist,
            case get(Key) of
                undefined ->
                    put(Key, Now),
                    ?CAST(cross_war_proc:get_server_pid(), {update_cross_mon_hp, Mon});
                Time ->
                    case Now - Time >= 2 of
                        true ->
                            put(Key, Now),
                            ?CAST(cross_war_proc:get_server_pid(), {update_cross_mon_hp, Mon});
                        false -> false
                    end
            end
    end.

get_my_con_val(_Player) ->
    #st_cross_war{contrib = Con} = lib_dict:get(?PROC_STATUS_CROSS_WAR),
    Con.

get_player_sign(Player) ->
    CrossWarPlayer = cross_war_util:get_by_g_key(Player#player.guild#st_guild.guild_key),
    if
        CrossWarPlayer#cross_war_guild.sign == ?CROSS_WAR_TYPE_ATT -> ?CROSS_WAR_TYPE_ATT;
        true -> ?CROSS_WAR_TYPE_DEF
    end.

get_king_pkey_gkey_center() ->
    ?CALL(cross_war_proc:get_server_pid(), get_king_pkey_gkey).

get_is_apply(Gkey) ->
    case cross_war_util:get_by_g_key(Gkey) of
        [] -> 1;
        _ -> 0
    end.

get_notice_state(Player) ->
    if
        Player#player.lv < ?CROSS_WAR_LIMIT_LV -> ok;
        true ->
            Week = util:get_day_of_week(),
            PassSec = util:get_seconds_from_midnight(),
            if
                Week == 6 -> ok;
                Week == 7 andalso PassSec < 21 * ?ONE_HOUR_SECONDS -> ok;
                true ->
                    St = lib_dict:get(?PROC_STATUS_CROSS_WAR),
                    #st_cross_war{is_king_reward = IsRecvReward, is_member_reward = IsMemberReward} = St,
                    cross_area:war_apply(?MODULE, get_act_43099_actid_149, [Player#player.key, Player#player.guild, Player#player.node, Player#player.sid, IsRecvReward, IsMemberReward]),
                    ok
            end
    end.

get_act_43099_actid_149(Key, StGuild, Node, Sid, IsRecvReward, IsMemberReward) ->
    ?CAST(cross_war_proc:get_server_pid(), {get_act_43099_actid_149, Key, StGuild, Node, Sid, IsRecvReward, IsMemberReward}).

get_act_43099_actid_149_cast(State, Key, StGuild, _Node, Sid, IsRecvReward, IsMemberReward) ->
    #sys_cross_war{king_info = KingInfo} = State,
    ActState =
        if
            IsMemberReward == 1 orelse IsRecvReward == 1 -> 0;
            Key == KingInfo#cross_war_king.pkey -> 1;
            StGuild#st_guild.guild_key == 0 -> 0;
            StGuild#st_guild.guild_position > 2 -> 0;
            StGuild#st_guild.guild_key == KingInfo#cross_war_king.g_key -> 1;
            true ->
                get_is_apply(StGuild#st_guild.guild_key)
        end,
    ActStateList = {[[149, ActState] ++ activity:pack_act_state([])]},
    {ok, Bin} = pt_430:write(43099, ActStateList),
    server_send:send_to_sid(Sid, Bin),
    ok.

get_main_key() ->
    cross_area:war_apply_call(?MODULE, get_main_key_center, []).

get_main_key_center() ->
    ?CALL(cross_war_proc:get_server_pid(), get_main_key).

update_couple_info(Player, PlayerCouple) ->
    cross_area:war_apply(?MODULE, update_couple_info_center, [Player, PlayerCouple]).

update_couple_info_center(Player, PlayerCouple) ->
    ?CAST(cross_war_proc:get_server_pid(), {update_couple_info, Player, PlayerCouple}),
    ok.

update_cross_war_guild(Player) ->
    if
        Player#player.lv < ?CROSS_WAR_LIMIT_LV ->
            skip;
        true ->
            get_act_info(Player)
    end,
    ok.

orz(Player) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_WAR),
    #st_cross_war{is_orz = IsOrz} = St,
    if
        IsOrz == 1 -> {32, Player};
        true ->
            OrzReward = data_cross_war_daily_reward:get_orz_reward(),
            GiveGoodsList = goods:make_give_goods_list(751, OrzReward),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            NewSt = St#st_cross_war{is_orz = 1, op_time = util:unixtime()},
            lib_dict:put(?PROC_STATUS_CROSS_WAR, NewSt),
            cross_war_load:update(NewSt),
            {1, NewPlayer}
    end.
