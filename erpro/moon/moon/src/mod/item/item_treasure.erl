%% -----------------------------------------------
%% 挖宝系统相关逻辑
%% Author: abu(aminbu@gmail.com)
%% Created: 2011-10-18 
%% ----------------------------------------------

-module(item_treasure).

%%
%% Include files
%%
-include("common.hrl").
-include("item.hrl").
%%
-include("role.hrl").
-include("gain.hrl").
-include("npc.hrl").
-include("pos.hrl").
-include("map.hrl").
-include("combat.hrl").
-include("treasure.hrl").
-include("link.hrl").

%%
%% Exported Functions
%%
-export([
        make/1
        ,use/2
        ,create_monster/0
        ,test_data/0
        ,create_camp/0
        ,create_camp_adm/0
        ,use_treasure/2
        ,treasure/1
        ,create_camp1/0
        ,catch_npc/2
        ,is_catch_npc/1
    ]
).

%% 默认地点
-define(default_treasure_locate, {?attr_treasure_map, 300, 10002}, {?attr_treasure_x, 300, 6000}, {?attr_treasure_y, 300, 6000}).
-define(default_monster_locate, {10002, 6000, 6000}).

%% for test debut
%%-define(debug_log(P), ?DEBUG("type=~w, value=~w", P)).
-define(debug_log(P), ok).

-define(half_day, 43200).
-define(one_day, 86400).

-define(monsters, [[20090,20091,20092,20093,20094], [20095,20096,20097,20098,20099]]).

-define(status_off, 0). %% 无任务
-define(status_on, 1). %% 任务中

%% ----------------------------------------------
%%
%% API Functions
%%
%% ----------------------------------------------
%% 使用宝图
use_treasure(_Item, #role{treasure = #treasure{status = ?status_on}}) ->
    {false, ?L(<<"你还在挖宝任务中, 一个一个挖嘛">>)};
use_treasure(#item{id = Id, base_id = BaseId, attr = Attr}, Role = #role{link = #link{conn_pid = ConnPid}, treasure = Treasure = #treasure{status = ?status_off}}) ->
    case role_gain:do([#loss{label = item_id, val = [{Id, 1}], msg = ?L(<<"该宝图不存在,无法使用">>)}], Role) of
        {false, L} -> {false, L#loss.msg};
        {ok, NewRole} ->
            case item_data:get(BaseId) of
                {ok, #item_base{effect = [{treasure, Type}]}} ->
                    [{_, _, MapId}] = [{Name, Flag, Val} || {Name, Flag, Val} <- Attr, Name =:= ?attr_treasure_map, Flag =:= 300],
                    [{_, _, X}] = [{Name, Flag, Val} || {Name, Flag, Val} <- Attr, Name =:= ?attr_treasure_x, Flag =:= 300],
                    [{_, _, Y}] = [{Name, Flag, Val} || {Name, Flag, Val} <- Attr, Name =:= ?attr_treasure_y, Flag =:= 300],
                    NewTreasure = Treasure#treasure{status = ?status_on, type = atom_to_type(Type), map = {MapId, X, Y}},
                    Msg = {1, atom_to_type(Type), MapId, X, Y},
                    sys_conn:pack_send(ConnPid, 10348, Msg),
                    {ok, NewRole#role{treasure = NewTreasure}};
                _ ->
                    {false, ?L(<<"这是一张有问题的宝图">>)}
            end
    end;
use_treasure(_, _) ->
    {false, ?L(<<"这是一张有问题的宝图">>)}.

%% 正式挖宝
treasure(#role{treasure = #treasure{status = ?status_off}}) ->
    {false, ?L(<<"你没有宝图任务,怎么挖啊!">>)};
treasure(Role = #role{pos = #pos{map = MapId1, x = X1, y = Y1}, treasure = Treasure = #treasure{type = Type, status = ?status_on, map = {MapId2, X2, Y2}}}) ->
    case MapId1 =:= MapId2 andalso (abs(X1 - X2) =< 1000) andalso (abs(Y1 - Y2) =< 1000) of
        true ->
            case use(Role, type_to_atom(Type)) of
                {false, Reason} -> {false, Reason};
                {ok, NewRole} ->
                    NewTreasure = Treasure#treasure{status = ?status_off, map = {0, 0, 0}},
                    {ok, NewRole#role{treasure = NewTreasure}}
            end;
        false ->
            {false, ?L(<<"你离挖宝点还比较远, 再走过去一点吧">>)}
    end;
treasure(_) ->
    {false, ?L(<<"你的宝图已经作废了,挖不了">>)}.

%% @spec make(Item) -> NewItem  
%% Item = NewItem = #item{}
%% @doc 生成一个藏宝图
make(Item = #item{base_id = 31014, attr = Attr}) -> %% 新手引导藏宝地图
    Locate = [{?attr_treasure_map, 300, 10002}, {?attr_treasure_x, 300, 3000}, {?attr_treasure_y, 300, 360}],
    Item#item{attr = Attr ++ Locate};
make(Item = #item{base_id = BaseId, attr = Attr})  when BaseId >= 31009 andalso BaseId =< 31014 -> 
    Locate = make_locate(),
    Item#item{attr = Attr ++ Locate};
make(Item) ->
    Item.

%% @spec use(Role, Type) -> {false, Reason} | {ok, NewRole}
%% Role = #role{}
%% Type = interger()
%% Reason = binary()
%% NewRole = #role{}
%% @doc 使用藏宝图
%% <ul>
%% <li>Type = 藏宝图的类型</li>
%% <li>Reason = 失败原因</li>
%% <li>NewRole = 新的角色数据</li>
%% <ul>
use(Role, Type) ->
    RandNum = util:rand(1,100),
    case handle_rand(item_treasure_data:get_dig_prob(Type), 1, RandNum) of 
        {false, Reason} ->
            {false, Reason};
        Event ->
            case handle(Event, Role) of
                {ok, NewRole} ->
                    NewRole2 = role_listener:acc_event(NewRole, {103, 1}),      %% 目标成就
                    NewRole3 = role_listener:special_event(NewRole2, {1038, finish}), %% 使用一张藏宝图                    
                    {ok, NewRole3};
                Other ->
                    Other
            end
    end.

%% @spec create_monster()
%% 产生狂暴怪
create_monster() ->
    case util:rand_list(?monsters) of
        Ids when is_list(Ids) ->
            {MapBaseId, Npcs} = do_create_monster(Ids, {0, <<"">>}),
            case Npcs of
                [] ->
                    ok;
                _ ->
                    notice:send(52, util:fbin(?L(<<"一群狂暴妖魔破解了上古封印，降临在{map, ~w, #ffff00}一带为非作歹，请仙友们速速前去降服！">>), [MapBaseId])),
                    ok
            end;

        _ ->
            ok
    end.

%% @spec create_camp()
%% 产生活动怪
create_camp() ->
    case util:rand(0, 1) of
        0 ->
            Locates1 = [L || L = {M, _, _} <- item_treasure_data:get_locates(2), M =:= 10002],
            for_create(10002, [20609], Locates1, 5, 5),
            notice:send(52, util:fbin(?L(<<"喜迎新年，驱赶瑞兽！{map, ~w, #ffff00}出现了一批瑞兽，妄图窃取大家的钱财，仙友们赶快前往击败瑞兽，守卫飞仙世界的安宁！">>), [10002]));
        _ ->
            Locates2 = [L || L = {M, _, _} <- item_treasure_data:get_locates(2), M =:= 10004],
            for_create(10004, [20609], Locates2, 5, 5),
            notice:send(52, util:fbin(?L(<<"喜迎新年，驱赶瑞兽！{map, ~w, #ffff00}出现了一批瑞兽，妄图窃取大家的钱财，仙友们赶快前往击败瑞兽，守卫飞仙世界的安宁！">>), [10004]))
    end.

%% 产生后台活动怪
create_camp_adm() ->
    Locates1 = [L || L = {M, _, _} <- item_treasure_data:get_locates(2), M =:= 10002],
    Locates2 = [L || L = {M, _, _} <- item_treasure_data:get_locates(2), M =:= 10004],
    OnlineNum = length(ets:tab2list(role_online)),
    NpcNum = if
        OnlineNum >= 51 -> 48;
        OnlineNum >= 30 -> 36;
        true -> 24 
    end,
    MapNpcNum1 = NpcNum div 2,
    MapNpcNum2 = NpcNum - MapNpcNum1,
    N1 = MapNpcNum1 div 3,
    N2 = MapNpcNum1 - N1 * 2,
    N3 = MapNpcNum2 div 3,
    N4 = MapNpcNum2 - N3 * 2,
    for_create(10002, [20149, 20150], Locates1, N1, N1),
    for_create(10002, [20151], Locates1, N2, N2),
    for_create(10004, [20149, 20150], Locates2, N3, N3),
    for_create(10004, [20151], Locates2, N4, N4),
    notice:send(52, util:fbin(?L(<<"抓鬼度亡灵！{map, ~w, #ffff00}、{map, ~w, #ffff00}突然出现了一批无主孤魂，众仙友速速前去击杀，会有意外收获哦！">>), [10002, 10004])).   

%% 产生活动怪1
create_camp1() ->
    Locates = item_treasure_data:get_locates(4),
    {MapId, X, Y} = util:rand_list(Locates),
    case npc_mgr:create(20609, MapId, X, Y) of
        {ok, NpcId} ->
            notice:send(52, util:fbin(?L(<<"驱赶瑞兽，抢夺好礼。{location,~w,~w,~w,ffff00}出现了一批{str, ~s, #ffff00}，妄图潜入城内破坏热飞仙世界的安宁，仙友们速去将其击败，守卫飞仙世界的安宁！">>), [MapId,X,Y,?L(<<"【瑞兽】">>)])),
            {ok, NpcId};
        false ->
            false
    end.

%% 抓取活动Npc
catch_npc(Role, NpcBaseId) ->
    case is_catch_npc(NpcBaseId) of
        true ->
            ItemBaseId = get_npc_item(NpcBaseId),
            case role_gain:do([#gain{label = item, val = [ItemBaseId, 1, 1]}], Role) of
                {ok, NewRole} ->
                    ?DEBUG("抓取活动NPC，获取物品"),
                    notice:inform(util:fbin(?L(<<"获得{item3, ~w, ~w, ~w}">>),[ItemBaseId, 1, 1])),
                    log:log(log_handle_all, {10730, <<"狂暴雪人活动">>, util:fbin("获得宝盒[~w]", [ItemBaseId]), Role}),
                    {ok, NewRole};
                {false, #gain{msg = Msg}} ->
                    ?DEBUG("获取物品失败, ~s", [Msg]),
                    {false, Msg}
            end;
        false ->
            no_camp_npc
    end.

%% 是否可抓取Npc
is_catch_npc(NpcBaseId) ->
    lists:member(NpcBaseId, [20601, 20602, 20603, 20604]).

%% ----------------------------------------------
%% Local Functions
%% ----------------------------------------------
atom_to_type(white) -> 0;
atom_to_type(green) -> 1;
atom_to_type(blue) -> 2;
atom_to_type(purple) -> 3;
atom_to_type(orange) -> 4;
atom_to_type(newtask) -> 5;
atom_to_type(_X) ->
    ?DEBUG("~w",[_X]),
    0.

type_to_atom(0) -> white;
type_to_atom(1) -> green;
type_to_atom(2) -> blue;
type_to_atom(3) -> purple;
type_to_atom(4) -> orange;
type_to_atom(5) -> newtask;
type_to_atom(_X) ->
    ?DEBUG("~w",[_X]),
    white.

for_create(_MapId, [], _Locates, _BaseNum, _MaxNum) -> ok;
for_create(MapId, [BaseId | T], Locates, BaseNum, MaxNum) ->
    case do_create(MapId, BaseId, Locates, BaseNum, MaxNum) of
        ok -> ok;
        false ->
            ?DEBUG("BaseId:~w创建已达上限",[BaseId]),
            false
    end,
    for_create(MapId, T, Locates, BaseNum, MaxNum).

do_create(MapId, NpcBaseId, Locates, BaseNum, MaxNum) ->
    case npc_mgr:lookup(by_base_id, NpcBaseId) of
        false ->
            create(MapId, NpcBaseId, Locates, BaseNum);
        Npcs ->
            case [BaseId || #npc{base_id = BaseId, pos = #pos{map = Mid}} <- Npcs, Mid =:= MapId] of
                [] ->
                    create(MapId, NpcBaseId, Locates, BaseNum);
                Exists when is_list(Exists) andalso length(Exists) < MaxNum ->
                    create(MapId, NpcBaseId, Locates, min(BaseNum, MaxNum - length(Exists)));
                _X ->
                    false
            end
    end.

create(_MapId, _NpcBaseId, _, 0) -> ok;
create(MapId, NpcBaseId, Locates, Num) ->
    {MapId, X, Y} = util:rand_list(Locates),
    map:create_npc(MapId, NpcBaseId, X, Y),
    create(MapId, NpcBaseId, Locates, Num - 1).

%% 设置坐标
make_locate() ->
    case util:rand_list(item_treasure_data:get_locates(1)) of
        {MapId, X, Y} ->
            [{?attr_treasure_map, 300, MapId}, {?attr_treasure_x, 300, X}, {?attr_treasure_y, 300, Y}];
        _ -> 
            [?default_treasure_locate]
    end.

%% 处理机率, 返回命中的事件
handle_rand([], _Start, _Rand) ->
    {nothing, 10, {}};
handle_rand([H={_FunId, Odds, _Params} | T], Start, Rand) ->
    if 
        Odds + Start > Rand ->
            H;
        true ->
            handle_rand(T, Odds+Start, Rand)
    end.

%% 处理buff事件
handle({buff, _Odds, _params={BuffLabel}}, Role = #role{pid = Rpid}) ->
    case item_effect:do({buff, BuffLabel}, Role) of
        {ok, NewRole} ->
            notice:send(52, util:fbin(?L(<<"~s 在挖宝的时候，突然眼前金光一闪，一股上古神魔之力灌注体内，能力获得大幅提高。">>), [notice:role_to_msg(Role)])),
            role:pack_send(Rpid, 10931, {55, ?L(<<"一股上古神魔之力灌注体内，您的能力获得大幅提高。">>), []}),
            {ok, NewRole};
        {false, Reason} ->
            {false, Reason}
    end;

%% 处理出现怪物
handle({monster, _Odds, [H | NpcBaseIds]}, Role = #role{pid = Rpid, id = Rid, name = Rname}) ->
    role:apply(async, Rpid, {fun fight_monster/2, [H]}), %% 与怪物直接进入战斗
    {MapBaseId, Npcs} = do_create_monster(NpcBaseIds, {Rid, Rname}),
    case Npcs of
        [] ->
            %%handle({nothing, {}, {}}, Role);
            {ok, Role};
        _ ->
            case util:rand_list(Npcs) of
                {_, {MapId, X, Y}} ->
                    role:pack_send(Rpid, 12812, {15, MapId, X, Y}),
                    ok;
                _ ->
                    ok
            end,
            notice:send(52, util:fbin(?L(<<"~s 在挖宝时，不慎破开了上古封印，使得一群被封印的妖魔重现人间，在{map, ~w, #ffff00}的某处寻机为非作歹，请各位仙友立刻前去击杀。">>), [notice:role_to_msg(Role), MapBaseId])),
            %role:pack_send(Rpid, 10931, {55, ?treasure_monster_personal_msg, []}),
            {ok, Role}
    end;

%% 处理物品掉落
handle({item, _Odds, {ConId}}, Role = #role{pid = Rpid}) ->
    case item_gift_data:get_box(ConId) of
        {false, Reason} -> {false, Reason};
        {Bind, Type, Num, L} -> 
            GetL = item:get_gift_list(Type, Num, Bind, L, Role),
            case item:make_gift_list(GetL) of
                {false, Reason} -> {false, Reason};
                {ok, GainList, _CastItems} ->
                    case role_gain:do(GainList, Role) of
                        {false, G} -> {false, G#gain.msg};
                        {ok, NewRole} ->
                            case lists:nth(1, GainList) of
                                #gain{label = item, val = [BaseId, _, Quantity]} ->
                                    Msg = util:fbin(?L(<<"恭喜你获得了~s！神秘宝图，下一次将有更大的惊喜。">>), [util:fbin("{item2, ~w, ~w}", [BaseId, Quantity])]),
                                    Msg2 = util:fbin(?L(<<"恭喜你获得了~s！神秘宝图，下一次将有更大的惊喜。">>), [util:fbin("{item3, ~w, ~w, ~w}", [BaseId, Quantity, Bind])]),
                                    role:pack_send(Rpid, 10931, {55, Msg, []}),
                                    notice:inform(Msg2);
                                _ ->
                                    ok
                            end,
                            {ok, NewRole}
                    end
            end
    end;

%% 挖到铜币
handle({coin, _Odds, _Params={Quantity}}, Role = #role{pid = Rpid} ) ->
    case role_gain:do([#gain{label = coin_bind, val = Quantity}], Role) of
        {ok, NewRole} ->
            role:pack_send(Rpid, 10931, {55, util:fbin(?L(<<"恭喜你获得了{str, ~w, #ff0000}绑定铜币！神秘宝图，下一次将有更大的惊喜。">>), [Quantity]), []}),
            notice:inform(util:fbin(?L(<<"恭喜你获得了{str, ~w, #ff0000}绑定铜币！神秘宝图，下一次将有更大的惊喜。">>), [Quantity])),
            log:log(log_coin, {<<"挖宝铜币">>, <<"">>, Role, NewRole}),
            {ok, NewRole};
        _ ->
            {false, <<>>}
    end;

%% 什么也没有得到
handle({nothing, _Odds, _Params}, Role = #role{pid = Rpid}) ->
    role:pack_send(Rpid, 10931, {55, ?L(<<"可惜啊，你像蒙牛那样耕耘了半天，结果一无所获，一定是昨天没有扶老奶奶过马路了!">>), []}),
    %notice:inform(?L(<<"可惜啊，你像蒙牛那样耕耘了半天，结果一无所获，一定是昨天没有扶老奶奶过马路了!">>)),
    {ok, Role};

%% 容错
handle(_A, Role) ->
    ?ERR("treasure config error: ~w~n", [_A]),
    {ok, Role}.

%% 处理产生怪物
do_handle_monster(NpcBaseId, Locates, MaxNum, {_Rid, _Rname}) ->
    {MapId, X, Y} = util:rand_list(Locates),
    case npc_mgr:lookup(by_base_id, NpcBaseId) of
        false ->
            {NpcBaseId, {MapId, X, Y}};
        Npcs ->
            case [BaseId || #npc{base_id = BaseId, pos = #pos{map = Mid}} <- Npcs, Mid =:= MapId] of
                [] ->
                    {NpcBaseId, {MapId, X, Y}};
                Exists when is_list(Exists) andalso length(Exists) < MaxNum ->
                    {NpcBaseId, {MapId, X, Y}};
                _ ->
                    false
            end
    end.

%% 根据开服时间计算可产生的怪物数量
can_create_monster_num() ->
    Now = util:unixtime(),
    case sys_env:get(srv_open_time) of
        OpenTime when is_integer(OpenTime) ->
            case Now - OpenTime of
                T1 when T1 < ?half_day ->
                    1;
                T2 when T2 < ?one_day ->
                    2;
                _ ->
                    3
            end;
        _ ->
            1
    end.

%% 产生怪物
do_create_monster(NpcBaseIds, {Rid, Rname}) ->
    Locates = case util:rand_list(item_treasure_data:get_locates(2)) of
        {Mid, _, _} ->
            [L || L = {M, _, _} <- item_treasure_data:get_locates(2), M =:= Mid];
        _ ->
            [?default_monster_locate]
    end,
    MaxNum = can_create_monster_num(),
    ?debug_log([monster_max_num, MaxNum]),
    Result = [do_handle_monster(NpcBaseId, Locates, MaxNum, {Rid, Rname}) || NpcBaseId <- NpcBaseIds],
    Npcs = [R || R <- Result, R =/= false],
    ?debug_log([create_monster, Npcs]),
    {MapBaseId, _, _} = lists:nth(1, Locates),
    {MapBaseId, Npcs}.

%% 发起怪物战斗
fight_monster(Role = #role{pos = #pos{map = MapId}, pid = Pid}, NpcId) ->
    role:pack_send(Pid, 10931, {55, ?L(<<"您挖宝时无意中解开了上古封印，妖魔破印而出，身上似乎携带着宝物！">>), []}),
    case npc_data:get(NpcId) of
        false -> 
            ?ERR("Npc不存在: ~w", [NpcId]),
            {ok};
        {ok, BaseNpc} ->
            Npc = npc_convert:base_to_npc(0, BaseNpc, #pos{map = MapId}),
            DfdList = npc:fighter_group(Npc, Role),
            case NpcId of
                20800 ->
                    case npc_data:get(20805) of
                        false ->
                            combat:start(kill_npc, MapId, role_api:fighter_group(Role), DfdList);
                        {ok, BaseRela} ->
                            NpcRela = npc_convert:base_to_npc(0, BaseRela, #pos{map = MapId}),
                            {ok, FighterRela} = npc_convert:do(to_fighter, NpcRela, Role, ?ms_rela_story),
                            combat:start(kill_npc, MapId, [FighterRela | role_api:fighter_group(Role)], DfdList)
                    end,
                    ok;
                _ ->
                    combat:start(kill_npc, MapId, role_api:fighter_group(Role), DfdList)
            end,
            {ok}
    end.


%% 测试配置数据
test_data() ->
    lists:foreach(fun do_test_data/1, item_treasure_data:get_locates(1) ++ item_treasure_data:get_locates(2)).

do_test_data({MapId, X, Y}) ->
    case map_mgr:is_blocked(MapId, X, Y) of
        true ->
            ?ERR("error locate: ~w", [{MapId, X, Y}]);
        false ->
            ok
    end.

%% 获取捕捉NPC对应获得物品
get_npc_item(20601) -> 29433;
get_npc_item(20602) -> 29434;
get_npc_item(20603) -> 29435;
get_npc_item(20604) -> 29436.
