%% --------------------------------------------------------------------
%% 处理副本类型相关的操作， 副本类型：组队副本、单人副本等
%% 相关的操作有：进入副本、退出副本、副本内离队的操作
%% @author abu@jieyou.cn mobin
%% --------------------------------------------------------------------
-module(dungeon_type).

%% 进出副本
-export([
        role_enter/3
        ,role_enter/4
        ,roles_enter/5
        ,role_leave/2
    ]).

%% 进、出副本的一些util方法
-export([
    add_enter_count/3          %% 增加已进入副本的次数
    ,get_left_count/2           %% 获取当前还可进入副本的次数
    ,get_left_count/4           %% 获取当前还可进入副本的次数
    ,get_paid_price/2           %% 获取购买价格，false表示已达购买上限
    ,send_score_and_rewards/2
    ,async_send_score_and_rewards/3
]).

-include("common.hrl").
-include("dungeon.hrl").
-include("role.hrl").
-include("pet.hrl").
-include("team.hrl").
-include("pos.hrl").
-include("map.hrl").
-include("hall.hrl").
%%
-include("condition.hrl").
-include("gain.hrl").
-include("task.hrl").
-include("activity.hrl").
-include("assets.hrl").
-include("link.hrl").
-include("misc.hrl").
-include("expedition.hrl").

-define(debug_log(P), ?DEBUG("type=~w, value=~w~n", P)).
%% 是否挂机
-define(HOOK_NO, 0).
% -define(HOOK_ING, 1).
%%-define(debug_log(P), ok).

%% --------------------------------------------------------------------
%% api funs
%% --------------------------------------------------------------------

%% @spec role_enter(Role, DungeonBase, Floor) -> {ok, NewRole} | {false, Reason}
%% Role = NewRole = #role{}
%% DungeonBase = #dungeon{}
%% Floor = integer()
%% Reason = bitstring()
%% 进入副本
%% 进入个人副本
role_enter(Role, DunBase, Floor) ->
    role_enter(Role, DunBase, Floor, []).
   
role_enter(Role = #role{auto = {Hook, _, _, _}}, DunBase = #dungeon_base{cond_enter = CondEnter, type = Type}, _, Extra)
when (Type =:= ?dungeon_type_clear) orelse
(Type =:= ?dungeon_type_expedition) orelse %%
(Type =:= ?dungeon_type_survive) orelse
(Type =:= ?dungeon_type_time) orelse
(Type =:= ?dungeon_type_leisure)
->
    case Hook of 
        ?HOOK_NO ->
            case role_enter_check(Role, [Role], [Cond || Cond = #condition{} <- CondEnter], DunBase) of
                true ->
                    start_dungeon(Role, DunBase, Extra);
                Result ->
                    Result
            end;
        _ ->
            {false, ?L(<<"扫荡中不能进入单人副本">>)}
    end;

role_enter(Role = #role{}, DunBase = #dungeon_base{type = ?dungeon_type_story}, _, Extra) ->
    start_dungeon(Role, DunBase, Extra);

%% 进入隐藏副本
role_enter(Role = #role{dungeon_map = DungeonMap}, DunBase = #dungeon_base{type = ?dungeon_type_hide,
    id = DungeonId}, _, Extra) ->
    MapId = dungeon_api:get_map_id(DungeonId),
    IsOpened = case lists:keyfind(MapId, 1, DungeonMap) of
        {_MapId, _Blue, _Purple, _BlueIsTaken, _PurpleIsTaken, _IsOpened} ->
            _IsOpened;
        _ ->
            []
    end,

    start_dungeon(Role, DunBase, [{is_opened, IsOpened}] ++ Extra);

role_enter(_Role, _DunBase, _, _) ->
    {false, ?L(<<"不存在此副本">>)}.

%% 多人副本
roles_enter(Role, DungeonBase = #dungeon_base{type = ?dungeon_type_expedition}, MemberPids, Extra, Cooperation) ->
    case start_dungeon(Role, DungeonBase, Extra) of
        {ok, Role2 = #role{event_pid = EventPid}} ->
            lists:foreach(fun(RolePid) ->
                        role:apply(async, RolePid, {fun async_enter_dungeon/4, [EventPid, DungeonBase, Cooperation]})
                end, MemberPids),
            {ok, Role2};
        {false, Reason} ->
            {false, Reason}
    end.

%% 退出个人副本:远征王军
role_leave(Role = #role{event_pid = Dpid}, #dungeon{type = ?dungeon_type_expedition}) ->
    case leave_dungeon(Role, Dpid) of
        {ok, NewRole} ->
            NewRole2 = NewRole#role{
                expedition = NewRole#role.expedition#expedition{partners = []} 
            },
            {ok, NewRole2};
        Other ->
            Other
    end;

%% 退出个人副本:其它
role_leave(Role = #role{event_pid = Dpid}, #dungeon{type = Type})
when (Type =:= ?dungeon_type_clear) orelse
(Type =:= ?dungeon_type_expedition) orelse %%
(Type =:= ?dungeon_type_survive) orelse
(Type =:= ?dungeon_type_time) orelse
(Type =:= ?dungeon_type_story) orelse
(Type =:= ?dungeon_type_leisure)
->
    case leave_dungeon(Role, Dpid) of
        {ok, NewRole} ->
            {ok, NewRole};
        Other ->
            Other
    end;

role_leave(Role = #role{event_pid = Dpid}, #dungeon{type = ?dungeon_type_hide}) ->
    case leave_dungeon(Role, Dpid) of
        {ok, NewRole} ->
            {ok, NewRole};
        Other ->
            Other
    end;


%% 退出多人副本
role_leave(Role = #role{event_pid = Dpid, hall = #role_hall{id = HallId}}, #dungeon{type = ?dungeon_type_expedition,
    extra = Extra}) ->
    case leave_dungeon(Role, Dpid) of
        {ok, Role2} ->
            hall:add_friends(HallId, Role2),
            Role3 = case lists:keyfind(clear, 1, Extra) of
                false ->
                    hall:leave(HallId, Role2),
                    Role2;
                _ ->
                    case expedition:get_left_count(Role) of
                        0 ->
                            hall:leave(HallId, Role2),
                            Role2;
                        _ ->
                            hall:back_to_hall(Role2)
                    end
            end,
            {ok, Role3};
        Other ->
            Other
    end;

role_leave(_Role, _DunBase) ->
    {false, ?L(<<"退出副本时发生异常">>)}.

%% 获取可进入的次数
get_left_count(DungeonId, RoleDungeons) ->
    case lists:keyfind(DungeonId, #role_dungeon.id, RoleDungeons) of
        false ->
            0;
        #role_dungeon{enter_count = EnterCount, paid_count = PaidCount, last = Last} ->
            get_left_count(DungeonId, EnterCount, PaidCount, Last)
    end.
get_left_count(DungeonId, EnterCount, PaidCount, Last) ->
    case dungeon_data:get(DungeonId) of
        #dungeon_base{cond_enter = Conditions} ->
            [Limit] = [Limit || #condition{label = dun_count, target_value = Limit} <- Conditions],
            case Last >= util:unixtime({today, util:unixtime()}) of
                true ->
                    PaidCount + Limit - EnterCount;
                false ->
                    Limit
            end;
        _ ->
            0
    end.

%% 增加进入副本的次数. 
add_enter_count(RoleDungeons, DungeonId, Count) ->
    case lists:keyfind(DungeonId, #role_dungeon.id, RoleDungeons) of
        false ->
            RoleDungeons;
        RoleDungeon = #role_dungeon{enter_count = EnterCount, last = Last} ->
            case Last >= util:unixtime({today, util:unixtime()}) of
                true ->
                    lists:keyreplace(DungeonId, #role_dungeon.id, RoleDungeons, 
                        RoleDungeon#role_dungeon{enter_count = EnterCount + Count, last = util:unixtime()});
                false ->
                    lists:keyreplace(DungeonId, #role_dungeon.id, RoleDungeons, 
                        RoleDungeon#role_dungeon{enter_count = Count, paid_count = 0, last = util:unixtime()})
            end
    end.

%% 获取购买价格，false表示已达购买上限
get_paid_price(DungeonId, Role = #role{dungeon = RoleDungeons}) ->
    case lists:keyfind(DungeonId, #role_dungeon.id, RoleDungeons) of
        #role_dungeon{paid_count = PaidCount, last = Last} ->
            #dungeon_base{pay_limit = PayLimit} = dungeon_data:get(DungeonId),
            VipPayLimit = vip:dungeon_reset(Role),
            PaidCount2 = case Last >= util:unixtime({today, util:unixtime()}) of
                true ->
                    PaidCount;
                false ->
                    0
            end,

            case PaidCount2 >= (PayLimit + VipPayLimit) of
                true ->
                    false;
                false ->
                    if
                        PaidCount2 =:= 0 ->
                            #loss{label = coin, val = 10000, msg = ?MSGID(<<"金币不足">>)};
                        PaidCount2 =:= 1 ->
                            #loss{label = gold, val = 10, msg = ?MSGID(<<"晶钻不足">>)};
                        PaidCount2 =:= 2 ->
                            #loss{label = gold, val = 20, msg = ?MSGID(<<"晶钻不足">>)};
                        true ->
                            #loss{label = gold, val = 50, msg = ?MSGID(<<"晶钻不足">>)}
                    end
            end;
        %%不可能出现的情况
        false ->
            false
    end.
 
%% 推送评分奖励
send_score_and_rewards(DungeonRole = #dungeon_role{pid = Pid}, DungeonId) ->
    role:apply(async, Pid, {fun async_send_score_and_rewards/3, [DungeonRole, DungeonId]}).

async_send_score_and_rewards(Role = #role{id = Rid, name = Name, pid = Pid, career = Career, dungeon = RoleDungeons}, #dungeon_role{
        star = Star, goals = Goals, clear_count = ClearCount}, DungeonId) ->
    #dungeon_base{clear_rewards = ClearRewards, type = Type, pet_exp = PetExp} = dungeon_data:get(DungeonId),

    DungeonDrop = dungeon_api:get_dungeon_drop(DungeonId, ClearCount, Career),
    dungeon_api:notify_to_the_world(Name, DungeonDrop),
    log:log(log_dungeon_drop, {<<"副本掉落">>, DungeonId, util:fbin("~w", [DungeonDrop]), Role}),

    ?DEBUG("---DungeonDrop---~w~n~n", [DungeonDrop]),
    role:pack_send(Pid, 13514, {Star, Goals, [{A, B}||{_, A, B, _} <- DungeonDrop]}),
    Role2 = pet_api:asc_pet_exp(Role, PetExp),
    ClearRewards2 = dungeon_api:get_vip_rewards(ClearRewards, Role2),
    DungeonReward = dungeon_api:make_gain_info(DungeonDrop),
    Rewards = DungeonReward ++ ClearRewards2,
    {AttrGains, ItemGains} = role_gain:separate_items(Rewards),

    %%获得属性奖励
    Role3 = case role_gain:do(AttrGains, Role2) of
        {ok, _Role2} -> _Role2;
        _ -> Role2
    end,

    %%获得物品奖励
    Role4 = case role_gain:do(ItemGains, Role3) of
        {ok, _Role3} ->
            _Role3;
        _ ->
            AwardId = case Type of
                ?dungeon_type_expedition ->
                    108001;
                _ ->
                    104000
            end,
            award:send(Rid, AwardId, ItemGains),
            Role3
    end,

    %% 日志
    log:log(log_coin, {<<"副本奖励">>, <<"副本奖励">>, Role2, Role4}),
    log:log(log_stone, {<<"副本奖励">>, <<"副本奖励">>, Role2, Role4}),

    Role5 = story_npc:clear(Role4),

    case Type of
        ?dungeon_type_expedition ->
            Role6 = expedition:add_enter_times(Role5),
            {ok, Role6};
        _ ->
            case dungeon_api:is_hard(DungeonId) of
                true ->
                    %%通关后扣进入次数
                    RoleDungeons2 = add_enter_count(RoleDungeons, DungeonId, 1),
                    {ok, Role5#role{dungeon = RoleDungeons2}};
                false ->
                    {ok, Role5}
            end
    end.

%% --------------------------------------------------------------------
%% 内部函数
%% --------------------------------------------------------------------

%% 退出副本
leave_dungeon(Role = #role{pos = #pos{last = {LmapId, Lx, Ly}}}, Dpid) ->
    case map:role_enter(LmapId, Lx, Ly, Role#role{event = ?event_no, dungeon_ext = #dungeon_ext{}}) of
        {false, _Reason} ->
            ?ERR("进入地图失败[~w], [~w]: [~w, ~w]", [_Reason, LmapId, Lx, Ly]),
            {false, ?MSGID(<<"进入地图失败">>)};
        {ok, NewRole} ->
            dungeon:leave(Dpid, Role),
            {ok, NewRole#role{event = ?event_no, event_pid = 0}}
    end.

%% 进入副本
enter_dungeon(Role, Dpid, DunBase) ->
    enter_dungeon(Role, Dpid, DunBase, []).

enter_dungeon(Role = #role{pos = #pos{map = LMapId, x = Lx, y = Ly}, event = Levent}, Dpid, #dungeon_base{type = Type, id = DungeonId}, Extra) ->
    {MapId, X, Y} = dungeon:get_enter_point(Dpid),
    %% 临时处理
    case Type of
        ?dungeon_type_expedition ->
            case lists:keyfind(followers, 1, Extra) of
                {followers, Followers} ->
                    map:followers_enter(MapId, Followers); %% 在map:role_enter前执行
                _ ->
                    ignore
            end;
        _ ->
            ignore
    end,
    case map:role_enter(MapId, X, Y, Role#role{event = ?event_dungeon, dungeon_ext = #dungeon_ext{id = DungeonId, type = Type}}) of
        {false, _Reason} ->
            {false, ?MSGID(<<"进入地图失败">>)};
        {ok, Role2 = #role{pos = Pos}}->
            dungeon:enter(Dpid, DungeonId, Role2),
            case Levent of
                ?event_dungeon ->
                    {ok, Role2#role{event = ?event_dungeon, event_pid = Dpid}};
                _ ->
                    {ok, Role2#role{event = ?event_dungeon, event_pid = Dpid, pos = Pos#pos{last = {LMapId, Lx, Ly}}}}
            end
    end.

%% 开启新的副本
%start_dungeon(Role, DungeonBase) ->
%    start_dungeon(Role, DungeonBase, []).
start_dungeon(Role = #role{cross_srv_id = _CrossSrvId}, DungeonBase = #dungeon_base{}, Extra) ->
    Dungeon = to_dungeon(DungeonBase),
    Dungeon2 = Dungeon#dungeon{extra = Extra}, 
    StartResult = dungeon:start(Dungeon2, 1),
    case StartResult of
        {false, Reason} -> {false, Reason};
        {ok, Dpid} ->
            %% 副本创建成功，尝试进入地图
            case enter_dungeon(Role, Dpid, DungeonBase, Extra) of
                {false, Reason} ->
                    dungeon:stop(Dpid), %% 关闭副本
                    {false, Reason};
                {ok, NewRole} ->
                    {ok, NewRole}
            end
    end.

%% 判断用户是否可以进入副本
role_enter_check(_Role, [], _CondEnter, _DunBase) ->
    true;
role_enter_check(Role = #role{id = Rid}, _Roles = [H = #role{id = Hid, name = Name} | T], CondEnter, DunBase = #dungeon_base{}) ->
    case role_cond:check(CondEnter, H) of
        {false, #condition{msg = Msg, label = ConLabel}} ->
            case Rid == Hid of
                false ->
                    {false, util:fbin(<<"~s~s">>, [Name, Msg])};
                true when ConLabel =:= dun_count ->
                    case send_paid_board(H, DunBase) of
                        false ->
                            {false, util:fbin(?L(<<"您~s">>), [Msg])};
                        true ->
                            false
                    end;
                true ->
                    {false, util:fbin(?L(<<"您~s">>), [Msg])}
            end;
        true ->
            role_enter_check(Role, T, CondEnter, DunBase)
    end.

%% 将副本基础数据转换为 副本数据 
to_dungeon(#dungeon_base{id = Id, type = Type, args = Args, name = Name, cond_enter = CondEnter, maps = Maps, enter_point = EnterPoint}) ->
    #dungeon{id = Id, type = Type, args = Args, name = Name, cond_enter = CondEnter, maps = Maps, enter_point = EnterPoint}.

%% 次数满后的处理： 是否推送购买面板
send_paid_board(Role = #role{pid = Pid}, #dungeon_base{id = DungeonId}) ->
    case get_paid_price(DungeonId, Role) of
        false ->
            false;
        _ ->
            role:pack_send(Pid, 13504, {DungeonId}),
            true
    end.

%% 异步进入副本,目前用于多人副本
async_enter_dungeon(Role, DungeonPid, DungeonBase = #dungeon_base{type = Type}, Cooperation) ->
    case enter_dungeon(Role, DungeonPid, DungeonBase) of
        {false, _Reason} ->
            {ok};
        {ok, Role2} ->
            case Type of
                ?dungeon_type_expedition ->
                    expedition:add_enter_count(Role2, Cooperation);
                _ ->
                    {ok, Role2}
            end
    end.
