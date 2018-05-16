%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 妖魔入侵
%%% @end
%%% Created : 06. 二月 2017 下午8:31
%%%-------------------------------------------------------------------
-module(guild_demon).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("guild.hrl").
-include("achieve.hrl").
-include("dungeon.hrl").
%% API
-compile(export_all).

-define(MAX_CHEER_TIMES, 5).  %%每日最大助威次数
-define(CHEER_BUFF_ID, 54001). %%助威buffid
-define(CHEER_BUFF_ID_END, 54005). %%助威buffid

check_enter(Player, Sid) ->
    case dungeon_util:is_dungeon_demon(Sid) of
        false -> true;
        true ->
            case guild_ets:get_guild_member(Player#player.key) of
                false -> {false, ?T("你还没加入仙盟")};
                Member ->
                    #g_member{
                        pass_floor = MinFloor
                    } = Member,
                    MaxFloor = data_dungeon_demon:get_max_floor(),
                    case MinFloor >= MaxFloor of
                        true -> {false, ?T("今日已通关")};
                        false ->
                            case data_dungeon_demon:get(MinFloor + 1) of
                                [] -> {false, ?T("关卡数据错误")};
                                Base ->
                                    case Base#base_dun_demon.need_lv > Player#player.lv of
                                        true -> {false, ?T("等级不足")};
                                        false -> true
                                    end
                            end
                    end
            end
    end.

%%获取进入副本参数
get_enter_dungeon_extra(Player) ->
    Guild = guild_ets:get_guild(Player#player.guild#st_guild.guild_key),
    Member = guild_ets:get_guild_member(Player#player.key),
    case Guild == false orelse Member == false of
        true -> [];
        false ->
            #guild{
                pass_floor_list = PassFloorList
            } = Guild,
            #g_member{
                pass_floor = MinFloor,
                be_cheer_times = BeCheerTimes
            } = Member,
            Floor = max(1, MinFloor + 1),
            Base = data_dungeon_demon:get(Floor),
            #base_dun_demon{
                add = Add
            } = Base,
            Add1 = round(Add * BeCheerTimes),
            MaxFloor = data_dungeon_demon:get_max_floor(),
            Reduce = guild_demon:get_dun_round_reduce(Player#player.key, Floor),
            [{dun_demon_round_min, Floor}, {dun_demon_round_max, MaxFloor}, {dun_demon_add, Add1}, {dun_demon_pass_list, PassFloorList}, {dun_demon_reduce, Reduce}]
    end.

%%获取进入副本的当前波数
get_demon_round_xy(Player) ->
    Member = guild_ets:get_guild_member(Player#player.key),
    case Member == false of
        true -> [];
        false ->
            #g_member{
                pass_floor = MinFloor
            } = Member,
            Floor = max(1, MinFloor + 1),
            Base = data_dungeon_demon:get(Floor),
            tuple_to_list(Base#base_dun_demon.position)
    end.

%%进入副本
enter_demon_dungeon(Player) ->
    Player#player.pid ! {apply_state, {guild_demon, enter_demon_dungeon, []}}.
enter_demon_dungeon([], Player) ->
    Member = guild_ets:get_guild_member(Player#player.key),
    if
        Member == false -> ok;
        true ->
            %%增加助威buff
            #g_member{
                be_cheer_times = BeCheerTimes
            } = Member,
            DelBuffList = lists:seq(?CHEER_BUFF_ID, ?CHEER_BUFF_ID_END),
            erlang:send_after(2000, self(), {apply_state, {guild_demon, demon_dungeon_buff, [DelBuffList, []]}}),
            case BeCheerTimes > 0 of
                true ->
                    AddBuffId = ?CHEER_BUFF_ID + BeCheerTimes - 1,
                    erlang:send_after(3000, self(), {apply_state, {guild_demon, demon_dungeon_buff, [[], [AddBuffId]]}}),
                    {ok, Player};
                false ->
                    {ok, Player}
            end
    end.

%%妖魔入侵buff处理
demon_dungeon_buff([DelBuffList, AddBuffList], Player) ->
    Player1 =
        case DelBuffList of
            [] -> Player;
            _ -> buff:del_buff_list(Player, DelBuffList, 0)
        end,
    Player2 =
        case AddBuffList of
            [] -> Player1;
            _ -> buff:add_buff_list_to_player(Player1, AddBuffList, 0)
        end,
    {ok, Player2}.

%%击杀波数更新
pass_dun_round(Player, Round) ->
    case guild_ets:get_guild_member(Player#player.key) of
        false -> [];
        Member ->
            NewMember = Member#g_member{
                pass_floor = Round,
                highest_pass_floor = max(Member#g_member.highest_pass_floor, Round)
            },
            guild_ets:set_guild_member(NewMember),

            update_guild_demon_pass(Member#g_member.gkey),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2012, 0, Round)
    end,
    ok.

%%更新妖魔入侵通关信息
update_guild_demon_pass(Gkey) ->
    case guild_ets:get_guild(Gkey) of
        [] -> skip;
        Guild ->
            #guild{
                max_pass_floor = MaxPassFloor,
                pass_pkey = Passkey
            } = Guild,
            AllMember = guild_ets:get_guild_member_list(Gkey),
            F = fun(M, AccList) ->
                #g_member{
                    pass_floor = PassFloor
                } = M,
                case PassFloor > 0 of
                    true ->
                        case lists:keyfind(PassFloor, 1, AccList) of
                            false -> [{PassFloor, 1} | AccList];
                            {_, Num} -> [{PassFloor, Num + 1} | lists:keydelete(PassFloor, 1, AccList)]
                        end;
                    false ->
                        AccList
                end
                end,
            PassList1 = lists:foldl(F, [], AllMember),
            F1 = fun(Floor) ->
                PassNum = lists:sum([N || {PFloor, N} <- PassList1, PFloor >= Floor]),
                case PassNum > 0 of
                    true -> [{Floor, PassNum}];
                    false -> []
                end
                 end,
            NewPassList = lists:flatmap(F1, lists:seq(1, data_dungeon_demon:get_max_floor())),
            {NewPkey, NewMaxPass} =
                case NewPassList of
                    [] -> {0, 0};
                    _ ->
                        {PFl, _} = lists:last(NewPassList),
                        case PFl > MaxPassFloor of
                            true ->
                                MaxM = hd([M || M <- AllMember, M#g_member.pass_floor == PFl]),
                                {MaxM#g_member.pkey, PFl};
                            false ->
                                {Passkey, MaxPassFloor}
                        end
                end,
            Now = util:unixtime(),
            NewGuild = Guild#guild{
                max_pass_floor = NewMaxPass
                , pass_pkey = NewPkey
                , pass_floor_list = NewPassList
                , pass_update_time = Now
            },
            guild_ets:set_guild(NewGuild)
    end.

%%获取妖魔入侵面板信息
get_guild_demon_info(Player) ->
    Member = guild_ets:get_guild_member(Player#player.key),
    Guild = guild_ets:get_guild(Player#player.guild#st_guild.guild_key),
    case Member == false orelse Guild == false of
        true -> skip;
        false ->
            #g_member{
                pass_floor = PassFloor
                , cheer_times = CheerTimes
                , be_cheer_times = BeCheerTimes
                , get_demon_gift_list = GetList
                , highest_pass_floor = HighestPassFloor
            } = Member,
            #guild{
                pass_floor_list = PassFloorList,
                pass_pkey = Passkey,
                max_pass_floor = MaxPassFloor
            } = Guild,
            CurFloor = min(data_dungeon_demon:get_max_floor(), PassFloor + 1),
            Base = data_dungeon_demon:get(CurFloor),
            #base_dun_demon{
                need_lv = NeedLv,
                reduce = Reduce,
                add = Add,
                dun_id = CurDunId
            } = Base,
            PassNum =
                case lists:keyfind(CurFloor, 1, PassFloorList) of
                    false -> 0;
                    {_, PassNum0} -> PassNum0
                end,
            Reduce1 = round(PassNum * Reduce),

            {Pname, Pcareer, Psex, Pavatar, PFloor} =
                case guild_ets:get_guild_member(Passkey) of
                    false -> {"", 0, 0, "", 0};
                    M -> {M#g_member.name, M#g_member.career, M#g_member.sex, M#g_member.avatar, MaxPassFloor}
                end,

            CheerAdd = round(BeCheerTimes * Add),
            LeaveCheerTimes = max(0, ?MAX_CHEER_TIMES - CheerTimes),

            All = data_dungeon_demon:get_gift_floor(),
            F = fun(Fl) ->
                B = data_dungeon_demon:get(Fl),
                #base_dun_demon{
                    gift_list = GiftList
                } = B,
                FlPassNum =
                    case lists:keyfind(Fl, 1, PassFloorList) of
                        false -> 0;
                        {_, Num0} -> Num0
                    end,
                F1 = fun({GiftId, NeedNum}) ->
                    S =
                        case lists:member({Fl, NeedNum}, GetList) of
                            false ->
                                ?IF_ELSE(FlPassNum >= NeedNum, 1, 0);
                            true ->
                                2
                        end,
                    [GiftId, NeedNum, S]
                     end,
                GetInfoList = lists:map(F1, GiftList),
                [Fl, FlPassNum, GetInfoList]
                end,
            GiftInfoList = lists:map(F, All),
            MaxFloor = data_dungeon_demon:get_max_floor(),
            CapNum = MaxFloor div 5,
            Fd = fun(Cap) ->
                St = (Cap - 1) * 5 + 1,
                Et = min(Cap * 5, MaxFloor),
                BaseCap = data_dungeon_demon:get(St),
                [BaseCap#base_dun_demon.dun_id, St, Et]
                 end,
            DunRoundList = lists:map(Fd, lists:seq(1, CapNum)),
            CanSweep =
                case HighestPassFloor > 0 andalso HighestPassFloor > CurFloor of
                    true -> 1;
                    false -> 0
                end,
            Data = {CurFloor, MaxFloor, NeedLv, Reduce1, Pname, Pcareer, Psex, Pavatar, PFloor, CheerAdd, LeaveCheerTimes, GiftInfoList, CurDunId, DunRoundList, CanSweep},
            {ok, Bin} = pt_400:write(40080, Data),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end.

%%领取通关波数奖励
get_demon_gift(Player, Floor) ->
    case check_get_demon_gift(Player, Floor) of
        {false, Res} ->
            {false, Res};
        {ok, Member, GetList} ->
            #g_member{
                get_demon_gift_list = OldGetList
            } = Member,
%%            ?PRINT("GetDemon Gift List  =========================== ~w",[GetList]),
            GiftList = [{GiftId, 1} || {_Floor, _PassNum, GiftId} <- GetList],
            GiveGoodsList = goods:make_give_goods_list(504, GiftList),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            NewGetList = [{Fl, PassNum} || {Fl, PassNum, _GiftId} <- GetList] ++ OldGetList,
            NewMember = Member#g_member{
                get_demon_gift_list = NewGetList
            },
            guild_ets:set_guild_member(NewMember),
            activity:get_notice(Player, [92], true),
            {ok, NewPlayer}
    end.
%%返回可领取列表 [{Floor, PassNum, GiftId}]
check_get_demon_gift(Player, GetFloor) ->
    Member = guild_ets:get_guild_member(Player#player.key),
    Guild = guild_ets:get_guild(Player#player.guild#st_guild.guild_key),
    if
        Member == false -> {false, 0};
        Guild == false -> {false, 0};
        true ->
            #guild{
                pass_floor_list = PassList
            } = Guild,
            #g_member{
                get_demon_gift_list = GetList
            } = Member,
            GetFloorList =
                case GetFloor == 0 of
                    true -> %%一键领取
                        data_dungeon_demon:get_gift_floor();
                    false ->
                        [GetFloor]
                end,
            F = fun(Floor) ->
                case lists:keyfind(Floor, 1, PassList) of
                    false -> [];
                    {_, NowPassNum} ->
                        BaseDemon = data_dungeon_demon:get(Floor),
                        #base_dun_demon{gift_list = GiftList} = BaseDemon,
                        [{Floor,PassNum,GiftId} || {GiftId, PassNum} <-GiftList,PassNum =< NowPassNum,not lists:member({Floor, PassNum}, GetList)]
                end
            end,
            CanGetList = lists:flatmap(F, GetFloorList),
            {ok, Member, CanGetList}
    end.

%%扫荡
sweep(Player) ->
    case check_sweep(Player) of
        {false, Res} ->
            {false, Res};
        {ok, StFloor, EnFloor, Member} ->
            F = fun(Floor) ->
                Base = data_dungeon_demon:get(Floor),
                #base_dun_demon{
                    exp = Exp
                } = Base,
                Exp
                end,
            SumExp = lists:sum(lists:map(F, lists:seq(StFloor, EnFloor))),
            NewMember = Member#g_member{
                pass_floor = EnFloor
            },
            guild_ets:set_guild_member(NewMember),
            pass_dun_round(Player, EnFloor),
            GoodsList = [[10108, SumExp]],
            NewPlayer = player_util:add_exp(Player, SumExp, 18),
            activity:get_notice(Player, [92], true),
            {ok, NewPlayer, EnFloor, GoodsList}
    end.
check_sweep(Player) ->
    Member = guild_ets:get_guild_member(Player#player.key),
    Guild = guild_ets:get_guild(Player#player.guild#st_guild.guild_key),
    if
        Member == false -> {false, 0};
        Guild == false -> {false, 0};
        true ->
            #g_member{
                pass_floor = PassFloor,
                highest_pass_floor = MaxPassFloor
            } = Member,
            if
                PassFloor >= MaxPassFloor -> {false, 813};
                MaxPassFloor < 1 -> {false, 813};
                true ->
                    {ok, max(1, PassFloor), MaxPassFloor, Member}
            end
    end.

%%获取今日助威列表
get_cheer_list(Player) ->
    Member = guild_ets:get_guild_member(Player#player.key),
    Guild = guild_ets:get_guild(Player#player.guild#st_guild.guild_key),
    if
        Member == false -> skip;
        Guild == false -> skip;
        true ->
            #g_member{
                cheer_times = MyCheerTimes
                , cheer_keys = MyCheerKeys
                , pass_floor = MyPassFloor
                , be_cheer_times = MyBeCheerTimes
                , help_cheer_time = HelpCheerTime
            } = Member,
            AllMember = guild_ets:get_guild_member_list(Guild#guild.gkey),
            Now = util:unixtime(),
            IsHelpCheer = ?IF_ELSE(util:is_same_date(Now, HelpCheerTime), 1, 0),
            F = fun(M) ->
                #g_member{
                    pkey = MKey,
                    name = Name,
                    cbp = Cbp,
                    lv = Lv,
                    last_login_time = LastLoginTime,
                    pass_floor = PassFloor,
                    be_cheer_times = BeCheerTimes
                } = M,
                IsOnline =
                    case player_util:get_player_online(MKey) of
                        [] -> false;
                        _ -> true
                    end,
                LastLoginTime1 = ?IF_ELSE(IsOnline, 0, max(0, Now - LastLoginTime)),
                Base = data_dungeon_demon:get(max(1, PassFloor)),
                #base_dun_demon{
                    add = Add
                } = Base,
                Add1 = round(BeCheerTimes * Add),
                CheerState =
                    case BeCheerTimes >= ?MAX_CHEER_TIMES of
                        true -> 4;
                        false ->
                            if
                                MyCheerTimes >= ?MAX_CHEER_TIMES -> 3;
                                true ->
                                    case lists:member(MKey, MyCheerKeys) of
                                        true -> 2;
                                        false -> 1
                                    end
                            end
                    end,
                [Name, MKey, Cbp, Lv, LastLoginTime1, BeCheerTimes, ?MAX_CHEER_TIMES, Add1, CheerState]
                end,
            List = lists:map(F, AllMember),
            Base = data_dungeon_demon:get(max(1, MyPassFloor)),
            #base_dun_demon{
                add = Add
            } = Base,
            MyAdd1 = round(Add * MyBeCheerTimes),
            LeaveCheerTimes = max(0, ?MAX_CHEER_TIMES - MyCheerTimes),
            {ok, Bin} = pt_400:write(40083, {MyAdd1, MyBeCheerTimes, ?MAX_CHEER_TIMES, LeaveCheerTimes, IsHelpCheer, List}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end.

%%获取我的助威
get_my_cheer(Player) ->
    Member = guild_ets:get_guild_member(Player#player.key),
    if
        Member == false -> skip;
        true ->
            #g_member{
                pass_floor = PassFloor
                , cheer_times = MyCheerTimes
                , cheer_me_keys = CheerKeyList
                , be_cheer_times = MyBeCheerTimes
                , help_cheer_time = HelpCheerTime
            } = Member,
            Now = util:unixtime(),
            IsHelpCheer = ?IF_ELSE(util:is_same_date(Now, HelpCheerTime), 1, 0),
            FriendList = relation:get_friend_list(),
            F = fun(Pkey) ->
                IsFriend =
                    case lists:member(Pkey, FriendList) of
                        true -> 1;
                        false -> 0
                    end,
                IsOnline =
                    case player_util:get_player_online(Pkey) of
                        [] -> false;
                        _ -> true
                    end,
                case guild_ets:get_guild_member(Pkey) of
                    false ->
                        P = shadow_proc:get_shadow(Pkey),
                        #player{
                            nickname = Name,
                            cbp = Cbp,
                            lv = Lv,
                            last_login_time = LastLoginTime
                        } = P,
                        LastLoginTime1 = ?IF_ELSE(IsOnline, 0, max(0, Now - LastLoginTime)),
                        [Pkey, Name, Cbp, Lv, LastLoginTime1, 0, IsFriend];
                    M ->
                        #g_member{
                            name = Name,
                            cbp = Cbp,
                            lv = Lv,
                            last_login_time = LastLoginTime,
                            cheer_times = CheerTimes
                        } = M,
                        LastLoginTime1 = ?IF_ELSE(IsOnline, 0, max(0, Now - LastLoginTime)),
                        [Pkey, Name, Cbp, Lv, LastLoginTime1, CheerTimes, IsFriend]
                end
                end,
            CheerList = lists:map(F, CheerKeyList),
            Base = data_dungeon_demon:get(max(1, PassFloor)),
            #base_dun_demon{
                add = Add
            } = Base,
            Add1 = round(Add * MyBeCheerTimes),
            LeaveCheerTimes = max(0, ?MAX_CHEER_TIMES - MyCheerTimes),
            Data = {Add1, MyBeCheerTimes, ?MAX_CHEER_TIMES, LeaveCheerTimes, IsHelpCheer, CheerList},
            {ok, Bin} = pt_400:write(40084, Data),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end.

%%助威
cheer_player(Player, Pkey) ->
    case check_cheer_player(Player, Pkey) of
        {false, Res} ->
            {false, Res};
        {ok, MyMember, Member} ->
            NewMyMember = MyMember#g_member{
                cheer_keys = MyMember#g_member.cheer_keys ++ [Pkey],
                cheer_times = MyMember#g_member.cheer_times + 1,
                demon_update_time = util:unixtime()
            },
            NewMember = Member#g_member{
                be_cheer_times = Member#g_member.be_cheer_times + 1,
                cheer_me_keys = Member#g_member.cheer_me_keys ++ [Player#player.key]
            },
            guild_ets:set_guild_member(NewMyMember),
            guild_ets:set_guild_member(NewMember),
            ok
    end.
check_cheer_player(Player, Pkey) ->
    MyMember = guild_ets:get_guild_member(Player#player.key),
    Member = guild_ets:get_guild_member(Pkey),
    if
        Member == false -> {false, 0};
        MyMember == false -> {false, 0};
        Member#g_member.gkey =/= MyMember#g_member.gkey -> {false, 0};
        MyMember#g_member.pkey == Pkey -> {false, 812};
        true ->
            #g_member{
                cheer_times = CheerTimes,
                cheer_keys = CheerKeys
            } = MyMember,
            #g_member{
                be_cheer_times = BeCheerTimes
            } = Member,
            if
                CheerTimes >= ?MAX_CHEER_TIMES -> {false, 807};
                BeCheerTimes >= ?MAX_CHEER_TIMES -> {false, 808};
                true ->
                    case lists:member(Pkey, CheerKeys) of
                        true -> {false, 809};
                        false -> {ok, MyMember, Member}
                    end
            end
    end.

%%请求助威
help_cheer(Player) ->
    Member = guild_ets:get_guild_member(Player#player.key),
    Guild = guild_ets:get_guild(Player#player.guild#st_guild.guild_key),
    if
        Member == false orelse Guild == false -> {false, 0};
        true ->
            Now = util:unixtime(),
            case util:is_same_date(Now, Member#g_member.help_cheer_time) of
                true -> {false, 811};
                false ->
                    AllMember = guild_ets:get_guild_member_list(Guild#guild.gkey),
                    F = fun(M) ->
                        #g_member{
                            pkey = Pkey
                        } = M,
                        case Pkey == Player#player.key of
                            true -> skip;
                            false ->
                                case player_util:get_player_online(Pkey) of
                                    [] ->
                                        NewM = M#g_member{
                                            help_cheer_list = lists:delete(Player#player.key, M#g_member.help_cheer_list) ++ [Player#player.key]
                                        },
                                        guild_ets:set_guild_member(NewM);
                                    Online ->
                                        Online#ets_online.pid ! {apply_state, {guild_demon, help_cheer_1, [Player#player.key]}}
                                end
                        end
                        end,
                    lists:foreach(F, AllMember),
                    NewMember = Member#g_member{
                        help_cheer_time = Now
                    },
                    guild_ets:set_guild_member(NewMember),
                    ok
            end
    end.
help_cheer_1(PkeyList, Player) ->
    F = fun(Pkey) ->
        case guild_ets:get_guild_member(Pkey) of
            false -> [];
            M -> [[Pkey, M#g_member.name, M#g_member.career, M#g_member.sex, M#g_member.avatar]]
        end
        end,
    L = lists:flatmap(F, PkeyList),
    {ok, Bin} = pt_400:write(40087, {L}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%助威通知
help_cheer_notice(Player) ->
    Member = guild_ets:get_guild_member(Player#player.key),
    case Member == false of
        true -> skip;
        false ->
            case Member#g_member.help_cheer_list == [] of
                true -> skip;
                false ->
                    help_cheer_1(Member#g_member.help_cheer_list, Player),
                    NewMember = Member#g_member{
                        help_cheer_list = []
                    },
                    guild_ets:set_guild_member(NewMember)
            end
    end.

%%获取波数降低属性百分比
get_dun_round_reduce(Pkey, Round) ->
    Member = guild_ets:get_guild_member(Pkey),
    if
        Member == false -> 0;
        true ->
            Guild = guild_ets:get_guild(Member#g_member.gkey),
            if
                Guild == false -> 0;
                true ->
                    Base = data_dungeon_demon:get(Round),
                    case Base == [] of
                        true -> 0;
                        false ->
                            #base_dun_demon{
                                reduce = Reduce
                            } = Base,
                            #guild{
                                pass_floor_list = PassFloorList
                            } = Guild,
                            case lists:keyfind(Round, 1, PassFloorList) of
                                false -> 0;
                                {_, Num} -> round(Num * Reduce)
                            end
                    end
            end
    end.

%%通关结算
dungeon_ret(Player, Ret, GoodsList, Round) ->
    GoodsList1 = [tuple_to_list(G) || G <- GoodsList],
    {ok, Bin} = pt_122:write(12231, {Ret, GoodsList1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    DelBuffList = lists:seq(?CHEER_BUFF_ID, ?CHEER_BUFF_ID_END),
    erlang:send_after(3000, self(), {apply_state, {guild_demon, demon_dungeon_buff, [DelBuffList, []]}}),
    LogDungeon =
        #log_dungeon{
            pkey = Player#player.key,
            nickname = Player#player.nickname,
            cbp = Player#player.cbp,
            dungeon_id = ?DUNGEON_ID_GUARD,
            dungeon_type = ?DUNGEON_TYPE_GUILD_DEMON,
            dungeon_desc = ?T("妖魔入侵"),
            layer = Round,
            layer_desc = ?T("妖魔入侵" ++ io_lib:format("第~p波", [Round])),
            sub_layer = 0,
            time = util:unixtime()
        },
    ?IF_ELSE(GoodsList /= [], dungeon_log:log(LogDungeon), skip),
    Player.

%%更新跨天信息
update_guild_demon(Member) ->
    Now = util:unixtime(),
    case util:is_same_date(Now, Member#g_member.demon_update_time) of
        true -> Member;
        false ->
            Member#g_member{
                pass_floor = 0
                , cheer_times = 0
                , cheer_keys = []
                , be_cheer_times = 0
                , cheer_me_keys = []
                , demon_update_time = Now
                , get_demon_gift_list = []
            }
    end.

%%获取最高可通关波数
get_max_can_pass_floor(Pid) ->
    MaxFloor = data_dungeon_demon:get_max_floor(),
    case ?CALL(Pid, {get_player_info, lv}) of
        [] -> MaxFloor;
        Lv ->
            get_max_can_pass_floor_1(lists:seq(1, MaxFloor), Lv, 0)
    end.
get_max_can_pass_floor_1([], _Lv, AccFloor) -> AccFloor;
get_max_can_pass_floor_1([Floor | Tail], Lv, AccFloor) ->
    Base = data_dungeon_demon:get(Floor),
    case Lv >= Base#base_dun_demon.need_lv of
        true -> get_max_can_pass_floor_1(Tail, Lv, Floor);
        false -> AccFloor
    end.