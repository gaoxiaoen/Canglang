%%--------------------------------------------------------
%% 采集系统远程调用
%% @author 252563398@qq.com
%%--------------------------------------------------------
-module(collect_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("storage.hrl").
-include("link.hrl").
-include("item.hrl").
-include("pos.hrl").
-include("npc.hrl").
%%

%% 获取采集背包列表
handle(12300, {}, _Role = #role{collect = #collect{volume = Volume, items = Items}}) ->
    %% ?DEBUG("Items = ~w~n",[Items]),
    {reply, {Volume, Items}};

%% 删除所有采集背包物品
handle(12303, {}, Role = #role{pid = _Pid, collect = Collect, link = #link{conn_pid = ConnPid}}) ->
    case collect:del_all_item(ConnPid, Collect) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NewCollect} -> {reply, {1, <<>>}, Role#role{collect = NewCollect}}
    end;

%% 删除采集背包指定格子物品
handle(12304, {Pos}, Role = #role{collect = Collect = #collect{items = Items}, link = #link{conn_pid = ConnPid}}) ->
    case storage:find(Items, #item.pos, Pos) of
        {ok, Item} -> 
            case collect:del_item(Collect, Pos) of
                {false, Reason} -> {reply, {0, Reason}};
                {ok, NewCollect} -> 
                    storage_api:del_item_info(ConnPid, [{?storage_collect, Item}]),
                    {reply, {1, <<>>}, Role#role{collect = NewCollect}}
            end;
        {false, Reason} -> {reply, {0, Reason}}
    end;

%% 整理采集背包物品
handle(12305, {}, Role = #role{collect = Collect}) ->
    case check_time(last_collect_refresh, 4) of
        false -> {reply, {0, ?L(<<"整理操作过频繁">>)}};
        true ->
            NewCollect = collect:refresh_bag(Collect, Role),
            role:put_dict(last_collect_refresh, util:unixtime()),
            {reply, {1, <<>>}, Role#role{collect = NewCollect}}
    end;

%% 移动采集背包某个格子物品到背包
handle(12306, {CPos}, Role = #role{collect = Collect, bag = Bag}) ->
    case collect:collect_to_bag(Collect, CPos, Bag, Role) of
        {ok, NewCollect, NewBag} -> 
            {reply, {1, <<>>}, Role#role{collect = NewCollect, bag = NewBag}};
        {false, Reason} -> {reply, {0, Reason}}
    end;

%% 移动采集背包中所有物品到背包
handle(12307, {}, Role = #role{collect = Collect}) ->
    case collect:all_to_bag(Collect, Role) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NewCollect, NewBag} -> {reply, {1, <<>>}, Role#role{collect = NewCollect, bag = NewBag}}
    end;

handle(_Cmd, _Data, _Role) -> %% 容错处理
    {error, unknow_command}.

%% 采集时间校验
%% 采集时间间隔最小为: 2秒
check_time(Type, N) -> 
    LastTime = case role:get_dict(Type) of
        {ok, undefined} -> 0;
        {ok, T} -> T
    end,
    (LastTime + N) < util:unixtime().

