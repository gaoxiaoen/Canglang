%%----------------------------------------------------
%% @doc 世界boss模块 
%%
%% <pre>
%% 世界boss模块 
%% </pre>
%% @author yqhuang(QQ:19123767)
%% @doc
%%----------------------------------------------------
-module(boss_rpc).
-export([
        handle/3
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("boss.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("assets.hrl").

handle(12800, {}, _Role) ->
    BossList = boss_unlock:boss_list_info(),
    %% ?DEBUG("世界boss信息:~w", [BossList]),
    {reply, {BossList}};

%% 进入战斗区域
handle(12850, {NpcBaseId}, Role = #role{event = ?event_no}) ->
    super_boss_mgr:enter_combat_area(Role, NpcBaseId);
handle(12850, {_}, Role) ->
    notice:alert(error, Role, ?MSGID(<<"当前状态下不能进入世界Boss战斗区域">>)),
    {ok};

%% 离开战斗区域
handle(12851, {_}, Role = #role{event = ?event_super_boss, combat_pid = CombatPid}) when is_pid(CombatPid) ->
    notice:alert(error, Role, ?MSGID(<<"战斗中不能离开世界Boss战斗区域">>)),
    {ok};
handle(12851, {}, Role = #role{event = ?event_super_boss, event_pid = SuperBossPid}) when is_pid(SuperBossPid) ->
    super_boss_mgr:exit_combat_area(Role),
    {ok};

%% 获取挑战排行榜数据：个人总伤害
handle(12870, {PageIndex}, #role{link = #link{conn_pid = ConnPid}}) ->
    super_boss_mgr:get_rank_data(PageIndex, ConnPid),
    {ok};

%% 昨日战况
handle(12871, {}, #role{id = Rid, link = #link{conn_pid = ConnPid}}) ->
    super_boss_mgr:get_summary_data(Rid, ConnPid),
    {ok};

handle(12872, {}, #role{id = Rid, pid = RolePid, link = #link{conn_pid = ConnPid}}) ->
    super_boss_mgr:get_reward(Rid, RolePid, ConnPid),
    {ok};

handle(12875, {}, _Role = #role{id = Rid, assets = #assets{scale = Scale}}) ->
    Items = super_boss_change:list(Rid),
    {reply, {Scale, Items}};

handle(12876, {Id, Num}, Role) when Num >= 1 ->
    case super_boss_change:buy(Id, Num, Role) of
        {false, ReasonId} ->
            notice:alert(error, Role, ReasonId),
            {ok};
        {ok, NewAssets, NewBag} ->
            Role2 = Role#role{assets = NewAssets, bag = NewBag},
            notice:alert(succ, Role, ?MSGID(<<"兑换成功，物品已经发送到你的背包">>)),
            {reply, {}, Role2}
    end;

%% 获取世界boss活动状态
handle(12859, {}, Role) ->
    super_boss_mgr:get_activity_status(Role),
    {ok};

%% 处理复活
handle(12863, {Type}, Role = #role{event = ?event_super_boss, event_pid = SuperBossPid}) ->
    super_boss:revive(SuperBossPid, Type, Role),
    {ok};
handle(12863, _, _) ->
    {ok};

%% 购买buff
handle(12864, {Type, Count}, #role{id = Rid, event = ?event_super_boss, pid = Pid, status = ?status_normal}) ->
    super_boss_mgr:purchase_buff(Type, Count, Rid, Pid),
    {ok};
handle(12864, _, _) ->
    {ok};

handle(12865, {}, #role{}) ->
    Bosses = super_boss_mgr:get_all_boss_status(),
    {reply, {Bosses}};

handle(12866, {NpcBaseId}, #role{link = #link{conn_pid = ConnPid}}) ->
    super_boss:get_boss_info(ConnPid, NpcBaseId),
    {ok};

handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.
