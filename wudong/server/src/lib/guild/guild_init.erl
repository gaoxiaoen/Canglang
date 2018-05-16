%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十月 2015 15:23
%%%-------------------------------------------------------------------
-module(guild_init).
-author("hxming").

-include("guild.hrl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("guild_manor.hrl").

%% API
-export([init_guild_data/0, init/1, logout/2, timer_update/0, close_update/0]).


%%玩家登陆初始化仙盟信息
init(Player) ->
    case guild_ets:get_guild_member(Player#player.key) of
        false -> Player;
        Member ->
            case guild_ets:get_guild(Member#g_member.gkey) of
                false ->
                    guild_ets:del_guild_member(Player#player.key),
                    guild_load:del_guild_member(Player#player.key),
                    Player;
                Guild ->
                    Now = util:unixtime(),
                    GuildName = guild_util:get_guild_name(Member#g_member.gkey),
                    NewMember1 = Member#g_member{is_online = 1, pid = Player#player.pid, lv = Player#player.lv, vip = Player#player.vip_lv, avatar = Player#player.avatar, last_login_time = Now},
                    %%登录更新
                    NewMember2 = guild_hy:update_calc_member_hy(NewMember1),
                    NewMember = guild_demon:update_guild_demon(NewMember2),
                    guild_ets:set_guild_member(NewMember),
                    StGuild = #st_guild{
                        guild_key = Member#g_member.gkey,
                        guild_name = GuildName,
                        guild_position = Member#g_member.position
                    },
                    case Player#player.key == Guild#guild.pkey of
                        true ->
                            guild_util:guild_apply_notice(Guild#guild.gkey);
                        false ->
                            skip
                    end,
                    case Member#g_member.position == ?GUILD_POSITION_CHAIRMAN of
                        true -> guild_util:change_mb_attr(Player#player.key, [{vip, Player#player.vip_lv}]);
                        false -> skp
                    end,
                    Player#player{guild = StGuild}
            end
    end.

%%玩家离线，更新离线状态
logout(Player, _NowTime) ->
    case guild_ets:get_guild_member(Player#player.key) of
        false -> skip;
        Member ->
            NewMember = Member#g_member{is_online = 0, pid = undefined, cbp = Player#player.cbp, h_cbp = Player#player.highest_cbp},
            guild_ets:set_guild_member(NewMember)
    end.


%%初始化仙盟系统数据
init_guild_data() ->
    init_guild(),
    init_guild_member(),
    init_guild_apply(),
    init_guild_history(),
    init_guild_manor(),
    guild_scene:init_scene(),
%%     guild_boss:init_guild_boss(),
    ok.

%%初始化仙盟数据
init_guild() ->
    Data = guild_load:select_guild(),
    F = fun([Key, Name, CNTime, Icon, IconList, Realm, Lv, Num, PKey, PName, PCareer, PVip, Notice, Log,
        Dedicate, AccTask, Type, SysId, Condition, CreateTime,
        LastHyKey, LastHyVal, LikeTimes, HyGiftTime, MaxPassFloor, PassPkey, PassFloorListBin, PassUpdateTime,
        BossStar, BossExp, BossState, LastName
    ]) ->
        Guild = #guild{
            gkey = Key,
            name = util:make_sure_list(Name),
            cn_time = CNTime,
            icon = Icon,
            icon_list = util:bitstring_to_term(IconList),
            realm = Realm,
            lv = Lv,
            num = Num,
            pkey = PKey,
            pname = PName,
            pcareer = PCareer,
            pvip = PVip,
            notice = Notice,
            log = util:bitstring_to_term(Log),
            dedicate = Dedicate,
            acc_task = AccTask,
            type = Type,
            sys_id = SysId,
            condition = util:bitstring_to_term(Condition),
            create_time = CreateTime,

            last_hy_key = LastHyKey,
            last_hy_val = LastHyVal,
            like_times = LikeTimes,
            hy_gift_time = HyGiftTime,
            max_pass_floor = MaxPassFloor,
            pass_pkey = PassPkey,
            pass_floor_list = util:bitstring_to_term(PassFloorListBin),
            pass_update_time = PassUpdateTime,

            boss_star = BossStar,
            boss_exp = BossExp,
            boss_state = BossState,
            last_name = util:bitstring_to_term(LastName)
        },
        guild_ets:set_guild_new(Guild)
        end,
    lists:foreach(F, Data),
    ok.

%%初始化仙盟成员数据
init_guild_member() ->
    Data = guild_load:select_guild_member(),
    F = fun([PKey, GKey, Position,
        AccDedicate, LeaveDedicate, DailyDedicate, DedicateTime,
        JcHyVal, JcHyTime, SumHyal, LikeTime,
        DailyGiftGetTime,
        HighestPassFloor, PassFloor, CheerTimes, CheerKeysBin, BeCheerTimes, CheerMeKeysBin, DemonUpdateTime, GetDemonGiftListBin, HelpCheerListBin, HelpCheerTime,
        AccTask, TaskLog, TaskTime, Timestamp, WarP, HWarP, Nickname, Career, Sex, Lv, Realm, Cbp, HPower, VipLv, LastLoginTime, Avatar]) ->
        NewCbp = ?IF_ELSE(is_integer(Cbp), Cbp, 0),
        GMember = #g_member{
            pkey = PKey,
            gkey = GKey,
            position = Position,
            timestamp = Timestamp,
            acc_dedicate = AccDedicate,
            leave_dedicate = LeaveDedicate,
            daily_dedicate = DailyDedicate,
            dedicate_time = DedicateTime,

            jc_hy_val = JcHyVal,
            jc_hy_time = JcHyTime,
            sum_hy_val = SumHyal,
            like_time = LikeTime,

            daily_gift_get_time = DailyGiftGetTime,

            highest_pass_floor = HighestPassFloor,
            pass_floor = PassFloor,
            cheer_times = CheerTimes,
            cheer_keys = util:bitstring_to_term(CheerKeysBin),
            be_cheer_times = BeCheerTimes,
            cheer_me_keys = util:bitstring_to_term(CheerMeKeysBin),
            demon_update_time = DemonUpdateTime,
            get_demon_gift_list = util:bitstring_to_term(GetDemonGiftListBin),
            help_cheer_list = util:bitstring_to_term(HelpCheerListBin),
            help_cheer_time = HelpCheerTime,

            acc_task = AccTask,
            task_log = util:bitstring_to_term(TaskLog),
            task_time = TaskTime,
            war_p = WarP,
            h_war_p = HWarP,
            name = Nickname,
            career = Career,
            sex = Sex,
            lv = Lv,
            realm = Realm,
            cbp = NewCbp,
            h_cbp = HPower,
            last_login_time = LastLoginTime,
            avatar = Avatar,
            vip = VipLv

        },
        ?DO_IF(GMember#g_member.last_login_time /= null, guild_ets:set_guild_member_new(GMember))
        end,
    lists:foreach(F, Data),
    ok.

%%初始化仙盟申请列表
init_guild_apply() ->
    Data = guild_load:select_guild_apply(),
    F = fun([Key, PKey, GKey, From, Timestamp, Name, Career, Lv, Cbp]) ->
        Apply = #g_apply{
            akey = Key,
            pkey = PKey,
            gkey = GKey,
            from = From,
            timestamp = Timestamp,
            nickname = Name,
            career = Career,
            lv = Lv,
            cbp = Cbp
        },
        guild_ets:set_guild_apply(Apply)
        end,
    lists:foreach(F, Data),
    ok.

%%初始化仙盟历史记录
init_guild_history() ->
    Data = guild_load:load_guild_history(),
    F = fun([Pkey, Time, QTime, QTimes, DailyGiftGetTime, PassFloor, CheerTimes, CheerKeysBin,
        BeCheerTimes, DemonUpdateTime, GetDemonGiftListBin]) ->
        History = #g_history{
            pkey = Pkey,
            time = Time,
            q_times = QTimes,
            q_time = QTime
            , daily_gift_get_time = DailyGiftGetTime

            , pass_floor = PassFloor
            , cheer_times = CheerTimes
            , cheer_keys = util:bitstring_to_term(CheerKeysBin)
            , be_cheer_times = BeCheerTimes
            , demon_update_time = DemonUpdateTime
            , get_demon_gift_list = util:bitstring_to_term(GetDemonGiftListBin)
        },
        ets:insert(?ETS_GUILD_HISTORY, History)
        end,
    lists:foreach(F, Data).


%%初始化帮派家园
init_guild_manor() ->
    guild_manor_init:init(),
    ok.

timer_update() ->
    F = fun(Guild) ->
        if Guild#guild.is_change == 1 ->
            guild_ets:set_guild_new(Guild#guild{is_change = 0}),
            guild_load:replace_guild(Guild);
            true -> ok
        end
        end,
    lists:foreach(F, guild_ets:get_update_guild_list()),


    F1 = fun(Member) ->
        if Member#g_member.is_change == 1 ->
            guild_ets:set_guild_member_new(Member#g_member{is_change = 0}),
            guild_load:replace_guild_member(Member);
            true -> ok
        end
         end,
    lists:foreach(F1, guild_ets:get_update_guild_member_list()),


    F2 = fun(Manor) ->
        guild_manor_ets:set_guild_manor(Manor#g_manor{is_change = 0}),
        guild_manor_load:replace_guild_manor(Manor)
         end,
    lists:foreach(F2, guild_manor_ets:get_update_guild_manor_list()),

    ok.


close_update() ->
    F = fun(Guild) ->
        ?IF_ELSE(Guild#guild.is_change == 1, guild_load:replace_guild(Guild), ok)
        end,
    lists:foreach(F, guild_ets:get_update_guild_list()),

    F1 = fun(Member) ->
        ?IF_ELSE(Member#g_member.is_change == 1, guild_load:replace_guild_member(Member), ok)
         end,
    lists:foreach(F1, guild_ets:get_update_guild_member_list()),

    F2 = fun(Manor) ->
        guild_manor_ets:set_guild_manor(Manor#g_manor{is_change = 0}),
        guild_manor_load:replace_guild_manor(Manor)
         end,
    lists:foreach(F2, guild_manor_ets:get_update_guild_manor_list()),

    ok.
