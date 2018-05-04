%%----------------------------------------------------
%% 雪山地牢相关远程调用
%%
%% @author mobin
%%----------------------------------------------------
-module(jail_rpc).
-export([handle/3]).
-include("common.hrl").
-include("role.hrl").
-include("jail.hrl").


%% 请求进入
handle(14800, {}, Role = #role{event = Event}) when Event =/= ?event_jail ->
    Role2 = jail_api:enter(Role),
    {ok, Role2};

%% 请求退出
handle(14801, {}, Role = #role{event = ?event_jail}) ->
    Role2 = jail_api:exit_jail(Role),
    {ok, Role2};

%% 请求前进
handle(14802, {}, Role) ->
    Reply = jail_api:forward(Role),
    {reply, {Reply}};
    
%% 请求抽取Boss
handle(14803, {}, _Role) ->
    JailRole = #jail_role{status = Status} = get(jail_role),
    case Status =:= ?gamble of
        true ->
            put(jail_role, JailRole#jail_role{status = ?prepare}),
            {reply, {}};
        false ->
            {ok}
    end;

%% 请求进攻
handle(14804, {}, Role) ->
    jail_api:attack(Role),
    {ok};

handle(14805, {}, Role) ->
    {Reply, Role2} = jail_api:exit_combat(Role),
    {reply, Reply, Role2};

handle(14811, {}, _Role = #role{id = Rid}) ->
    #jail_role{floor = Floor} = jail_api:get_jail_role(Rid),
    %%已挑战成功层数
    {reply, {Floor - 1}};

handle(14812, {}, _Role = #role{id = Rid}) ->
    #jail_role{anti_stun = AntiStun, anti_taunt = AntiTaunt, anti_sleep = AntiSleep, anti_stone = AntiStone, best_floor = BestFloor} = jail_api:get_jail_role(Rid),
    AntiStatus = if
        AntiStun > 0 ->
            4;
        AntiTaunt > 0 ->
            3;
        AntiStone > 0 ->
            2;
        AntiSleep > 0 ->
            1;
        true ->
            0
    end,
    {reply, {BestFloor, AntiStatus}};

handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.
