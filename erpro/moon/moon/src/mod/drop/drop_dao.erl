%%----------------------------------------------------
%% Author: yqhuang(QQ:19123767)
%% Created: 2011-8-18
%% Description: 掉落系统数据库访问
%%----------------------------------------------------
-module(drop_dao).

-export([
        get/2
        ,save/1
        ,get_all/0
    ]
).

-include("common.hrl").
-include("drop.hrl").

%% 获取指定NPC及物品ID的掉落进度
%% @spec get(NpcId, ItemId) -
get(NpcId, ItemId) ->
    Sql = "select npc_id, item_id, time_start, drop_num, kill_num from sys_drop where npc_id = ~s and item_id = ~s",
    case db:get_row(Sql, [NpcId, ItemId]) of
        {error, undefined} ->
            {false, []};
        {ok, [NpcId, ItemId, TimeStart, DropNum, KillNum]} ->
            {true, [NpcId, ItemId, TimeStart, DropNum, KillNum]}
    end.

save(#drop_rule_superb_prog{npc_id = NpcId, item_id = ItemId, time_start = TimeStart, drop_num = DropNum, kill_num = KillNum}) ->
    Sql = "replace into sys_drop(npc_id, item_id, time_start, drop_num, kill_num) values (~s, ~s, ~s, ~s, ~s)",
    db:execute(Sql, [NpcId, ItemId, TimeStart, DropNum, KillNum]).

get_all() ->
    Sql = "select npc_id, item_id, time_start, drop_num, kill_num from sys_drop",
    case db:get_all(Sql) of
        {ok, []} ->
            {false, []};
        {ok, Data} ->
            {true, Data};
        {error, Msg} ->
            ?ERR("执行数据库出错了[Msg:~w]", [Msg]),
            {false, []}
    end.
