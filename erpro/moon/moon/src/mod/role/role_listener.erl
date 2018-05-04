%%----------------------------------------------------
%% 事件监听接口
%% @author yeahoo2000@gmail.com, yqhuang(QQ:19123767)*
%%
%% 注:方法名与#trigger字段是一一对应关系，意为触发字段指定的事情类型事件
%%----------------------------------------------------
-module(role_listener).
-export([
        login/1
        ,switch/1
        ,connect/1
        ,disconnect/1
        ,logout/1
        ,lev_up/1
        ,sex/1
        ,coin/2
        ,get_item/2
        ,use_item/2
        ,vip/2
        ,kill_npc/3
        ,finish_task/2
        ,buy_item_shop/2
        ,special_event/2
        ,buy_item_store/2
        ,make_friend/2
        ,acc_event/2
        ,eqm_event/2
        ,sweep_dungeon/2
        ,ease_dungeon/2
        ,once_dungeon/2
        ,star_dungeon/2
        ,guild_wish/2
        ,guild_buy/2
        ,guild_kill_pirate/2
        ,guild_chleg/2
        ,guild_gc/2
        ,guild_dungeon/2
        ,guild_tree/2
        ,guild_activity/2
        ,guild_skill/2
        ,guild_multi_dun/2
    ]
).

-include("common.hrl").
-include("trigger.hrl").
-include("role.hrl").
-include("pos.hrl").

%% @spec login(Role) -> NewRole
%% Role = #role{}
%% NewRole = #role{}
%% @doc 登录事件回调
login(Role = #role{}) ->
    %% TODO: 各模块初始化应避免产生信息推送, 最好等待客户端主动请求同步; 且各个模块有无优先级顺序，也需要考虑
    NewRole = apply_chain(Role, [
        fun role_api:login/1,
        fun map_line:fix/1,
        fun item_parse:login/1,
        fun role_attr:calc_attr_registered/1,
        fun setting:dress_login_init/1, %% 初始化looks从这里开始
        fun buff:restart_buff/1,
        fun pet:login/1,
        fun medal:login/1,
        fun medal_compete:login/1,
        fun vip:login/1,
        fun sns:login/1,
        fun task:login/1,
        fun combat:role_login/1,
        fun channel:login/1,
        fun story_npc:login/1,
        % fun hook:login_check/1,
        fun guild_role:login/1,
        fun dungeon_auto:login/1,
        %fun arena_mgr:login/1,
        %fun offline_exp:login/1,
        fun activity2:login/1,
        fun signon:login/1,
        fun dungeon_mgr:role_login/1,
        %fun escort:login/1,
        fun award:login/1,       %% 这句要确保在charge:login()之前，否则会有问题
        fun setting:login/1,
        fun charge:login/1,
        % fun achievement:login/1,
        % fun lottery:login/1,
        %fun guild_war_mgr:login/1,
        fun super_boss_mgr:login/1,
        %%fun guild_td_mgr:role_login/1,
        fun wanted_mgr:login/1,
        %fun guild_practise:login/1,
        %fun guard_mgr:login/1,
        %fun npc_employ_mgr:login/1,
        %fun guild_arena_mgr:login/1,
        %fun guild_arena:login/1,
        fun arena_career:login/1,
        fun trial_combat:login/1,
        fun demon_challenge:login/1,
        %fun mount:login/1,
        %fun world_compete_mgr:login/1,  %% 仙道会
        %fun sworn_api:login/1,
        fun hall_mgr:login/1,
        %fun compete_mgr:login/1,
        fun campaign_listener:login/1,
        %fun lottery_tree:login/1, %% 摇钱树
        fun wing:login/1,
        fun activity:login/1,
        %fun cross_king_mgr:login/1,
        %fun lottery_secret:login/1,
        fun demon:login/1,
        fun adventure:login/1,
        %fun top_fight_center_mgr:login/1,  %% 巅峰对决
        fun looks:calc/1,
        %fun cross_ore:role_login/1, %% 跨服抢矿
        %fun soul_world:login/1, %% 灵戒洞天 
        %fun cross_trip:login/1,  %% 跨服旅行
        %fun cross_warlord:login/1,  %% 武神坛
        %fun ascend:login/1,
        %fun train_common:login/1,  %% 飞仙历练
        %fun campaign_daily_consume:login/1,
        %fun lottery_gold:login/1,
        fun beer:login/1,
        %fun campaign_suit:login/1,
        %fun campaign_accumulative:login/1,
        fun casino_refresh_items:login/1,
        fun manor:login/1,
        fun energy:login/1,     %% 要保证在  fun guild_role:login/1 之后
        fun offline_gain:login/1,
        fun notification:login/1,
        fun tree_mgr:login/1,
        %fun jail_mgr:login/1,
        fun expedition:login/1,
        %% fun seven_day_award:login/1,
        fun npc_store:login/1,
        fun platform_api:login/1,
        fun account_mgr:rename_fix/1,
        fun invitation:login/1,
        fun gm_adm:login/1
        ]),
    misc_mgr:login(NewRole),
    %wish:role_login(NewRole),
    rank:login_update(NewRole),
    % npc_store:login_update(NewRole),
    campaign:on_login(NewRole),
    npc_mgr:role_login(NewRole), %% 处理首席弟子登录
    task_wanted:login(NewRole),
    %campaign_model_worker:login(NewRole), %% 劳模活动
    notice:login(NewRole),
    mail:login(NewRole),
    %% ---------------------------------
    log:log(log_role_login, NewRole),
    NRole = role_attr:calc_attr(NewRole),
    %cross_pk:role_update(NRole),
    NRole.

%% @spec switch(Role) -> NewRole
%% Role = #role{}
%% NewRole = #role{}
%% @doc 角色顶号事件回调(两个客户端依次登录同一角色时就会产生顶号事件)
switch(Role) ->
    %team:member_switch(Role),
    %sworn_api:switch(Role),
    apply_chain(Role, [
        fun setting:login/1,
        fun combat:role_switch/1,
        fun super_boss_mgr:login/1,
        fun dungeon_mgr:role_switch/1,
        %fun compete_mgr:role_switch/1,
        fun tree_mgr:login/1,
        fun expedition:login/1,
        fun wanted_mgr:login/1,
        fun hall_mgr:login/1
        %fun world_compete_mgr:role_switch/1
        %fun cross_trip:role_switch/1
    ]).

%% @spec connect(Role) -> NewRole
%% Role = #role{}
%% NewRole = #role{}
%% @doc 客户端连接
connect(Role) ->
    Role.

%% @spec disconnect(Role) -> NewRole
%% Role = #role{}
%% NewRole = #role{}
%% @doc 角色断开连接
%% <div>注意:断开连接并不一定代表角色下线，比如当在战斗中时，断开连接角色不会立即下线</div>
disconnect(Role) ->
    combat:role_disconnect(Role),
    %sworn_api:disconnect(Role),
    Role.

%% @spec logout(Role) -> ok
%% Role = #role{} 角色属性
%% NewRole = #role{} 新角色属性
%% @doc 角色退出触发器(角色下线前调用)
%% <div>DEBUG模式如果发生错误下会抛出异常</div>
%% <div>发布模式下如果发生错则误忽略所有异常，必须要保证所有的退出调用能执行到</div>
logout(Role = #role{id = {Rid, SrvId}, pid = Pid, exchange_pid = ExPid, pos = #pos{map_pid = MapPid, x = X, y = Y, town_map_pid = TownMapPid}, task = _Task}) ->
    ?CATCH( log:log(log_role_logout, Role) ),
    ?CATCH( exchange:stop(ExPid, Pid) ),
    ?CATCH( role_group:leave(all, Role) ),
    ?CATCH( map:role_leave(MapPid, Pid, Rid, SrvId, X, Y) ),
    ?CATCH( map:role_leave(TownMapPid, Pid) ),
    %?CATCH( sit:sit_both_logout(Role) ),
    %?CATCH( team:member_offline(Role) ),
    ?CATCH( sns:logout(Role) ),
    %?CATCH( task:logoff(Role) ),
    ?CATCH( fcm_dao:save_online_info(Role) ),
    ?CATCH( guild_role:logout(Role) ),
    %?CATCH( arena_mgr:logout(Role) ),
    ?CATCH( dungeon_mgr:role_logout(Role) ),
    ?CATCH( tree_mgr:role_logout(Role) ),
    %?CATCH( jail_mgr:role_logout(Role) ),
    %?CATCH( guild_war_mgr:logout(Role) ),
    %?CATCH( guild_td_mgr:role_logout(Role) ),
    %?CATCH( guild_arena:logout(Role) ),
    ?CATCH( super_boss_mgr:logout(Role) ),
    %?CATCH( guild_practise:logout(Role) ),
    %?CATCH( sworn_api:logout(Role) ),
    ?CATCH( hall_mgr:logout(Role)),
    %?CATCH( cross_king_mgr:logout(Role) ),
    %?CATCH( top_fight_center_mgr:logout(Role) ),
    %?CATCH( both_ride:logout(Role) ),
    %?CATCH( fate:logout(Role) ),
    %?CATCH( fate_act:logout(Role) ),
    %?CATCH( cross_ore:role_logout(Role) ),
    %?CATCH( guard_mgr:logout(Role) ),
    %?CATCH( train_common:logout(Role) ),
    %?CATCH( energy:logout(Role) ),
    NewRole = do_logout(
        [
            {task, logoff}
            ,{energy, logout}
            ,{guaguale, logout}
            ,{buff, recalc_bufftime}
            %,{offline_exp, logout}
            ,{activity, logout}
            %,{arena, logout_update}
            ,{role_api, logout}
            %,{cross_pk, logout}
            %,{cross_warlord, logout}
            %,{seven_day_award, logout}
            %,{compete_mgr, logout}
            ,{dungeon_auto, logout}
            ,{expedition, logout}
        ]
        ,Role
    ),

    case get(test_pids) of 
        undefined -> ok;
        Pids ->
            [P ! {stop}||P <- Pids]
    end,


    %% 同步到DETS
    role_mgr:sync(NewRole).

%% 执行退出调用
do_logout([], Role) -> Role;
do_logout([{M, F} | T], Role) ->
    case catch apply(M, F, [Role]) of
        {ok, NewRole} when is_record(NewRole, role) ->
            do_logout(T, NewRole);
        Err ->
            ?ERR("角色进程[~s]执行退出调用时发生异常:~w", [Role#role.name, Err]),
            do_logout(T, Role)
    end;
do_logout([H | T], Role) ->
    ?ERR("角色进程[~s]退出调用格式错误:~w", [Role#role.name, H]),
    do_logout(T, Role).

%% @spec sex(Role) -> NewRole
%% @doc 变性时触发
sex(Role) ->
    friend:update_role_sex(Role),
    %% rank:listener(sex, Role),
    Role1 = vip:change_sex(Role),
    Role2 = storage_api:change_sex(Role1),
    Role2.


%% @spec lev_up(Role) -> NewRole
%% @doc 升级时触发：经脉、技能、任务成就等
lev_up(Role = #role{lev = Lev}) ->
    catch task:lev_up_fire(Role),
    friend:wish_lev_up(Role),
    guild_mem:update(lev, Role),                        %% 更新数据到帮会
    rank:listener(lev, Role),
    pet_ex:talk(role_lev, Role),
    wanted_mgr:is_can_play(Role),
    super_boss_mgr:push_activity_status(Role),
    %compete_mgr:push_status(Role),
    %jail_mgr:push_status(Role),
    invitation:level_up(Role),
    Role1 = medal:listener(level, Role),
    Role2 = energy:lev_up(Role1),
    Role4 = expedition:push_status(Role2),
    Role5 = tree_mgr:push_status(Role4),
    Role6 = activity2:lev_up(Role5),
    do_callback(lev, Role2#role.trigger#trigger.lev, Role6, Lev).

%% @spec coin(Role, Coin) -> NewRole
%% Role = #role{}
%% Coin = integer()
%% NewRole = #role{}
%% @doc 金币变化时触发
%% <div>Coin 涉及到的金额，负数表示金币减少</div>
coin(Role, Coin) ->
    do_callback(coin, Role#role.trigger#trigger.coin, Role, Coin).

%% @spec get_item(Role, Item) -> NewRole
%% Role = #role{}
%% Item = #item{}
%% NewRole = #role{}
%% @doc 调用获得物品触发器
get_item(Role, []) ->
    Role;
get_item(Role, [Item | T]) ->
    NewRole = get_item(Role, Item),
    get_item(NewRole, T);
get_item(Role, Item) ->
    do_callback(get_item, Role#role.trigger#trigger.get_item, Role, Item).

%% @spec use_item(Role, Item) -> NewRole
%% Role = #role{}
%% Item = #item{}
%% NewRole = #role{}
%% @doc 调用使用物品触发器
use_item(Role, Item) ->
    do_callback(use_item, Role#role.trigger#trigger.use_item, Role, Item).

%% @spec vip(Role, Vip) -> NewRole
%% Role = #role{}
%% Vip = #vip{}
%% NewRole = #role{}
%% @doc 调用VIP状态改变触发器
vip(Role, Vip) ->
    do_callback(vip, Role#role.trigger#trigger.vip, Role, Vip).

%% @spec kill_npc(Role, Npc, Num) -> NewRole
%% Role = #role{}
%% NpcBaseId = integer()
%% NewRole = #role{}
%% Num = integer()
%% @doc 调用杀怪触发器
%% <div>Npc Npc的基础ID</div>
%% <div>Num 被杀死的怪物数量</div>
kill_npc(Role, NpcBaseId, Num) ->
    campaign_adm:apply(async, {handle, kill_npc, Role, NpcBaseId}),
    NewRole2 = medal:listener(kill_npc, Role, {NpcBaseId,Num}),
    random_award:kill_npc(Role, NpcBaseId, Num),
    do_callback(kill_npc, NewRole2#role.trigger#trigger.kill_npc, NewRole2, {NpcBaseId, Num}).

%% @spec finish_task(Role, TaskId) -> NewRole
%% Role = #role{}
%% TaskId = integer{}
%% NewRole = #role{}
%% @doc 调用获取物品触发器(需要将这调用放在完成任务的模块中)
finish_task(Role, TaskId) ->
    do_callback(finish_task, Role#role.trigger#trigger.finish_task, Role, TaskId).

%% @spec buy_item_shop(Role, ItemList) -> NewRole
%% @doc
%% <pre>
%% Role = #role{} 角色记录
%% ItemList = #item() 物品记录
%% 触发事件:在商城购买物品
%% </pre>
buy_item_shop(Role, []) ->
    Role;
buy_item_shop(Role, [Item | T]) ->
    NewRole = buy_item_shop(Role, Item),
    buy_item_shop(NewRole, T);
buy_item_shop(Role, Item) ->
    do_callback(buy_item_shop, Role#role.trigger#trigger.buy_item_shop, Role, Item).

%% 特殊事件
special_event(Role, {Key, Args}) ->
    do_callback(special_event, Role#role.trigger#trigger.special_event, Role, {Key, Args}).

%% @spec buy_item_store(Role, ItemList) -> NewRole
%% @doc
%% <pre>
%% Role = #role{} 角色记录
%% ItemList = [#item{}] 物品记录
%% 触发事件:在商店购买物品
%% </pre>
buy_item_store(Role, []) ->
    Role;
buy_item_store(Role, [Item | T]) ->
    NewRole = buy_item_store(Role, Item),
    buy_item_store(NewRole, T);
buy_item_store(Role, Item) ->
    do_callback(buy_item_store, Role#role.trigger#trigger.buy_item_store, Role, Item).

%% @spec make_friend(Role, Friend) -> NewRole
%% @doc
%% <pre>
%% Role = #role{}
%% Friend = #friend{}
%% NewRole = #role{}
%% 添加好友
%% </pre>
make_friend(Role, Friend) ->
    do_callback(make_friend, Role#role.trigger#trigger.make_friend, Role, Friend).

%% 特殊事件
acc_event(Role, {Key, Args}) ->
    do_callback(acc_event, Role#role.trigger#trigger.acc_event, Role, {Key, Args}).

%% 装备变化事件 Args = {Pos, Enchant, Quality, Bind}
eqm_event(Role, Args) ->
    do_callback(eqm_event, Role#role.trigger#trigger.eqm_event, Role, Args).

%% 扫荡副本事件 Args = {DunId, Num}
sweep_dungeon(Role, Args) ->
    do_callback(sweep_dungeon, Role#role.trigger#trigger.sweep_dungeon, Role, Args).

%% 通关悠闲副本事件 Args = {DunId, Num}
ease_dungeon(Role, Args) ->
    do_callback(ease_dungeon, Role#role.trigger#trigger.ease_dungeon, Role, Args).

%% 通关副本事件 Args = {DunId, Num}
once_dungeon(Role, Args) ->
    do_callback(once_dungeon, Role#role.trigger#trigger.once_dungeon, Role, Args).

%% 通关副本事件 Args = {DunId, Star}
star_dungeon(Role, Args) ->
    do_callback(star_dungeon, Role#role.trigger#trigger.star_dungeon, Role, Args).

%% 军团许愿事件 Args = 暂时没用
guild_wish(Role, Args) ->
    do_callback(guild_wish, Role#role.trigger#trigger.guild_wish, Role, Args).

%% 军团商城购买事件 Args = 暂时没用
guild_buy(Role, Args) ->
    do_callback(guild_buy, Role#role.trigger#trigger.guild_buy, Role, Args).

%% 军团猎杀海盗事件 Args = 暂时没用
guild_kill_pirate(Role, Args) ->
    do_callback(guild_kill_pirate, Role#role.trigger#trigger.guild_kill_pirate, Role, Args).

%% 军团中庭战神挑战事件 Args = 暂时没用
guild_chleg(Role, Args) ->
    do_callback(guild_chleg, Role#role.trigger#trigger.guild_chleg, Role, Args).

%% 军团攻城伐龙事件 Args = 暂时没用
guild_gc(Role, Args) ->
    do_callback(guild_gc, Role#role.trigger#trigger.guild_gc, Role, Args).


%% 军团通关普通副本事件 Args = 暂时没用
guild_dungeon(Role, Args) ->
    do_callback(guild_dungeon, Role#role.trigger#trigger.guild_dungeon, Role, Args).

%% 军团参加世界树事件 Args = 暂时没用
guild_tree(Role, Args) ->
    do_callback(guild_tree, Role#role.trigger#trigger.guild_tree, Role, Args).

%% 军团 活跃度事件 Args = 暂时没用
guild_activity(Role, Args) ->
    do_callback(guild_activity, Role#role.trigger#trigger.guild_activity, Role, Args).

%% 军团 领用技能事件 Args = 暂时没用
guild_skill(Role, Args) ->
    do_callback(guild_skill, Role#role.trigger#trigger.guild_skill, Role, Args).

%% 军团 领用技能事件 Args = 暂时没用
guild_multi_dun(Role, Args) ->
    do_callback(guild_multi_dun, Role#role.trigger#trigger.guild_multi_dun, Role, Args).


%% @spec do_callback(Label, FunList, Role, Args) -> NewRole
%% Label = atom()
%% FunList = list()
%% Role = #role{}
%% Args = list()
%% @doc 执行相应类型触发器回调
do_callback(_Label, [], Role, _Args) -> Role;
do_callback(Label, [{_Id, {M, F, A}} | T], Role, Args) ->
    case catch erlang:apply(M, F, [Role, Args] ++ A) of %% A是注册回调函数的时候生成
        ok ->
            do_callback(Label, T, Role, Args);
        {ok, NewRole} when is_record(NewRole, role) ->
            do_callback(Label, T, NewRole, Args);
        Else ->
            ?ELOG("角色[~s]调用[~w]触发器中的{~w, ~w, ~w}时发生错误:~w", [Role#role.name, Label, M, F, A, Else]),
            do_callback(Label, T, Role, Args)
    end.

apply_chain(Role, []) ->
    Role;
apply_chain(Role = #role{}, [Fun|T]) ->
    %% ?DEBUG("当前Event ~w, 函数 ~w", [Event, Fun]),
    apply_chain(Fun(Role), T).

