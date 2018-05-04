%%----------------------------------------------------
%% 飞行 相关处理外部函数
%% @author wpf (wprehard@qq.com)
%%----------------------------------------------------

-module(fly_api).
-export([
        check_can_fly/1
        %% ,check_fly/1
        ,check_can_landing/1
        ,use_fly_sign/2
        ,fly_sign_over/1

        ,check_map/4
        ,convert_ride/1
    ]).

-include("common.hrl").
-include("role.hrl").
-include("item.hrl").
-include("team.hrl").
-include("gain.hrl").
-include("looks.hrl").
-include("pos.hrl").
-include("map.hrl").
-include("link.hrl").
-include("buff.hrl").

%% @spec convert_ride(Event, MapId, Ride) -> Ride::integer()
%% @doc 转换飞行状态
%% <div> 用于地图数据转换时 </div>
%% 跨服仙府地图要求保持飞行，这里只能保证客户端的效果
convert_ride(#role{event = ?event_cross_ore}) -> ?ride_fly;
convert_ride(#role{pos = #pos{map_base_id = 40002}}) -> ?ride_fly;
convert_ride(#role{ride = Ride}) -> Ride.

%% @spec check_map(Role, MapBaseId, X, Y) -> {Role, X, Y}
%% @doc 检测飞行状态是否合法；位置合法性，返回新的合法坐标
check_map(Role, MapBaseId, X, Y) ->
    NewRole = case check_can_fly(Role) of
        true -> Role;
        false -> Role#role{ride = ?ride_no}
    end,
    do_check_map(NewRole, MapBaseId, X, Y).
do_check_map(Role = #role{ride = ?ride_fly}, _MapBaseId, X, Y) ->
    {Role, X, Y};
do_check_map(Role, MapBaseId, X, Y) ->
    case map_mgr:is_blocked(MapBaseId, X, Y) of
        true -> %% 不可行走区域
            case map:get_revive(MapBaseId) of
                {ok, {Dx, Dy}} ->
                    {Role, Dx, Dy};
                _ ->
                    ?ERR("玩家[NAME:~s]上线检测，未找到复活点[MAP:~w]", [Role#role.name, MapBaseId]),
                    {Role, X, Y}
            end;
        false -> {Role, X, Y}
    end.

%% @spec check_can_fly(Role) -> true | false
%% @doc 检查装备/BUFF是否可以支持飞行
check_can_fly(#role{event = ?event_cross_ore}) ->
    true; %% 跨服仙府默认可以飞行
check_can_fly(#role{eqm = Eqm, buff = #rbuff{buff_list = Buffs}}) ->
    Ret1 = check_can_fly(mount, Eqm, false),
    Ret2 = check_can_fly(wing, Eqm, Ret1),
    check_can_fly(buff, Buffs, Ret2).

%% @spec use_fly_sign(Item, Role) -> {ok, NewRole} | {false, Msg}
%% @doc 使用飞行符
use_fly_sign(Item = #item{id = ItemId}, Role) ->
    case role_api:check_fly(Role) of
        true ->
            LossList = [#loss{label = item_id, val = [{ItemId, 1}], msg = ?L(<<"背包不存在光之翼">>)}],
            role:send_buff_begin(),
            case role_gain:do(LossList, Role) of
                {false, #loss{msg = Msg}} ->
                    role:send_buff_clean(),
                    {false, Msg};
                {ok, Role0} ->
                    BuffLabel = convert_to_buff(Item, Role),
                    case buff:add(Role0, BuffLabel) of
                        {false, Msg} ->
                            role:send_buff_clean(),
                            {false, Msg};
                        {ok, #role{team_pid = TeamPid, team = #role_team{is_leader = ?false, follow = ?true}}} when is_pid(TeamPid) ->
                            role:send_buff_clean(),
                            {false, ?L(<<"队伍跟随中不允许使用光之翼飞行">>)};
                        {ok, Role1} ->
                            role:send_buff_flush(),
                            NewRole = looks:add(Role1#role{ride = ?ride_fly}, ?LOOKS_TYPE_FLY_SIGN, 0, ?LOOKS_VAL_FLY_SIGN),
                            team:update_ride(NewRole),
                            map:role_update(NewRole),
                            {ok, NewRole}
                    end
            end;
        {false, Msg} -> {false, Msg}
    end.

%% @spec fly_sign_over(Role) -> NewRole
%% @doc 处理飞行符buff到期
fly_sign_over(Role = #role{ride = ?ride_no}) ->
    NewRole = looks:remove(Role, ?LOOKS_TYPE_FLY_SIGN),
    map:role_update(NewRole),
    NewRole;
fly_sign_over(Role = #role{event = ?event_cross_ore}) ->
    %% 跨服仙府保持飞行
    NewRole = looks:remove(Role, ?LOOKS_TYPE_FLY_SIGN),
    map:role_update(NewRole),
    NewRole;
fly_sign_over(Role = #role{team_pid = TeamPid, team = #role_team{is_leader = ?false, follow = ?true}})
when is_pid(TeamPid) -> %% 跟随队员，只取消外观
    NewRole = looks:remove(Role, ?LOOKS_TYPE_FLY_SIGN),
    map:role_update(NewRole),
    NewRole;
fly_sign_over(Role = #role{team_pid = TeamPid, team = #role_team{is_leader = ?true}, pos = Pos, link = #link{conn_pid = ConnPid}})
when is_pid(TeamPid) -> %% 队长，处理队员
    Role0 = looks:remove(Role#role{ride = ?ride_no}, ?LOOKS_TYPE_FLY_SIGN),
    case check_can_landing(Pos) of
        true ->
            team:update_ride(Role0),
            map:role_update(Role0),
            Role0;
        {false, MapId, _MapBaseId, Dx, Dy} ->
            case team_api:get_team_info(TeamPid) of
                {ok, #team{member = Members}} -> %% 让全部队员暂离
                    [team_api:force_tempout(TeamPid, Mid) || #team_member{id = Mid, mode = ?MODE_NORMAL} <- Members],
                    team:update_ride(Role0),
                    sys_conn:pack_send(ConnPid, 10015, {?false, ?L(<<"您的光之翼飞行时效已到，您从空中狼狈的跌了下来，摔得眼冒金星，回到了当前场景复活点。">>)}),
                    case map:role_enter(MapId, Dx, Dy, Role0) of
                        {ok, NewRole} ->
                            NewRole;
                        _ ->
                            map:role_update(Role0),
                            Role0
                    end;
                _ -> 
                    map:role_update(Role0),
                    Role0
            end
    end;
fly_sign_over(Role = #role{pos = Pos, link = #link{conn_pid = ConnPid}}) ->
    Role0 = looks:remove(Role#role{ride = ?ride_no}, ?LOOKS_TYPE_FLY_SIGN),
    case check_can_landing(Pos) of
        true ->
            map:role_update(Role0),
            Role0;
        {false, MapId, _MapBaseId, Dx, Dy} ->
            sys_conn:pack_send(ConnPid, 10015, {?false, ?L(<<"您的光之翼飞行时效已到，您从空中狼狈的跌了下来，摔得眼冒金星，回到了当前场景复活点。">>)}),
            case map:role_enter(MapId, Dx, Dy, Role0) of
                {ok, NewRole} ->
                    NewRole;
                _ ->
                    map:role_update(Role0),
                    Role0
            end
    end.

%% @spec check_can_landing(Pos) -> true | {false, Map, MapBase, Dx, Dy}
%% Pos = #pos{}
%% @doc 检查是否可以降落
check_can_landing(#pos{map = MapId, map_base_id = BaseId, x = X, y = Y}) -> 
    case ets:lookup(map_info, MapId) of
        [#map{id = MapId, base_id = MapBaseId}] ->
            case map_mgr:is_blocked(MapBaseId, X, Y) of
                true -> %% 不可以行走
                    case map:get_revive(MapBaseId) of
                        {ok, {Dx, Dy}} ->
                            {false, MapId, MapBaseId, Dx, Dy};
                        _ ->
                            {false, MapId, MapBaseId, X, Y}
                    end;
                false -> true
            end;
        _ -> {false, MapId, BaseId, X, Y}
    end.

%% =----------------------------------
%% 内部函数
%% -----------------------------------

%% 获取要加的飞行BUFF，返回buff label
convert_to_buff(#item{base_id = 33042}, _) ->
    fly_buff_3;
convert_to_buff(#item{}, #role{eqm = Eqm}) ->
    %% 判断翅膀位置是否有翅膀
    Pos = eqm:type_to_pos(?item_wing),
    case eqm:find_eqm_by_id(Eqm, Pos) of
        false -> fly_buff_1;
        _ -> fly_buff_2
    end;
convert_to_buff(_, _) -> fly_buff_1.

%% 判断是否可以飞行
check_can_fly(_Type, _Data, true) -> true;
check_can_fly(Type, Data, false) ->
    check_can_fly(Type, Data).
check_can_fly(mount, Eqm) ->
    Pos = eqm:type_to_pos(?item_zuo_qi),
    case eqm:find_eqm_by_id(Eqm, Pos) of %% 检测坐骑位置
        false -> false;
        {ok, #item{base_id = BaseId}} when BaseId >= 19060 andalso BaseId < 19100 -> true;
        _ -> false
    end;
check_can_fly(wing, Eqm) ->
    Pos = eqm:type_to_pos(?item_wing),
    case eqm:find_eqm_by_id(Eqm, Pos) of %% 检测翅膀位置
        false -> false;
        {ok, #item{base_id = 18800, enchant = E}} when E >= 10 -> true;
        {ok, #item{base_id = 18801, enchant = E}} when E >= 10 -> true;
        {ok, #item{base_id = 18802, enchant = E}} when E >= 10 -> true;
        {ok, #item{base_id = 18803, enchant = E}} when E >= 10 -> true;
        {ok, #item{base_id = 18804, enchant = E}} when E >= 10 -> true;
        {ok, #item{base_id = 18805, enchant = E}} when E >= 10 -> true;
        {ok, #item{base_id = 18806, enchant = E}} when E >= 10 -> true;
        {ok, #item{base_id = BaseId, enchant = E}} when (BaseId > 18800 andalso BaseId < 18899) andalso E >= 10 -> true;
        {ok, WingItem} ->
            WingStep = wing:get_wing_step(WingItem),
            WingStep >= 6;
        _ -> false
    end;
check_can_fly(buff, []) -> false;
check_can_fly(buff, [#buff{label = fly_buff_1} | _T]) -> true;
check_can_fly(buff, [#buff{label = fly_buff_2} | _T]) -> true;
check_can_fly(buff, [#buff{label = fly_buff_3} | _T]) -> true;
check_can_fly(buff, [#buff{label = fly_buff_task} | _T]) -> true;
check_can_fly(buff, [_ | T]) ->
    check_can_fly(buff, T);
check_can_fly(_, _) -> false.
