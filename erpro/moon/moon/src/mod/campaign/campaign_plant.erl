%% --------------------------------------------------------------------
%% 种植类活动
%% @author abu
%% --------------------------------------------------------------------
-module(campaign_plant).

-behaviour(gen_server).

%% export functions
-export([start_link/0
        ,make/1
        ,seed/2
        ,watering/2
        ,info/0
        ,flower_gain/2
        ,witch_exchange/1
        ,add_buff/3
        ,send_mail_130/1
        ,login/1
        ,set_witch_power/1
        ,center_flower_grow_up/3
    ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% record
-record(state, {plants = [], used_elem_id = [], witch_id = 0, witch_buff = 0, witch_buff_effect = {0, 0}}).

%% 种植的结构
-record(plant, {
        pos         %% 地点
        ,owner_rid  %% 播种的玩家
        ,assist_rid %% 辅助的玩家
        ,status     %% 状态
        ,timestamp  %% 上一次操作的时间
        ,elem_id    %% 元素的id
        ,elem_base_id 
    }).

%% include files
-include("common.hrl").
-include("item.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("team.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("map.hrl").
-include("chat_rpc.hrl").
-include("buff.hrl").
-include("npc.hrl").

%% macros
-define(start_elem_id, 70001).
-define(item_seed1, 33174).              %% 圣诞树 
-define(item_seed2, 33175).              %% 雪堆 
-define(item_seed3, 33191).              %% 小花花
-define(item_seed4, 33111).              %% 玫瑰花
-define(item_seed5, 33221).              %% 周年庆礼花

-define(plant_seed_elem, 1).                %% 播种，待浇水
-define(plant_seed_water_elem, 2).          %% 浇水，待施肥
-define(plant_seed_fertilize_elem, 3).      %% 施肥，待除草
-define(plant_seed_weeding_elem, 4).        %% 除草，待除虫
-define(plant_seed_disinsection_elem, 5).   %% 除虫，待成型
-define(plant_tree_elem, 6).                %% 成型

-define(plant_wait_time, 120).         %% 等待120秒
-define(plant_check, 5).               %% 5 秒检测一遍
-define(plant_valid_date1, {{2013, 3, 15}, {23, 59, 59}}).  %% 种子播种有效截止时间
-define(plant_lev_limit, 40).          %% 等级限制 40 级
-define(plant_end_date, {{2013, 3, 15}, {23, 59, 59}}).  %% 种子场景清除时间
%% 活动BOSS
-define(dragon_start_time, {{2013, 4, 13}, {0, 0, 1}}).
-define(dragon_end_time, {{2013, 4, 18}, {23, 59, 59}}).
%% 万圣节女巫
-define(witch_npc_base_id, 11235). %% 女巫npc1
-define(witch_npc_base_id_ex, 11228). %% 女巫npc2
-define(witch_start_time, {{2013, 2, 17}, {0, 0, 1}}).
-define(witch_end_time, {{2013, 2, 22}, {23, 59, 59}}).

%% for test debut
-define(debug_log(P), ?DEBUG("type=~w, value=~w", P)).
%%-define(debug_log(P), ok).

%% --------------------------------------------------------------------
%%  GM命令
%% --------------------------------------------------------------------
set_witch_power(Power) ->
    gen_server:cast(?MODULE, {set_witch_power, Power}).

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------
%% @spec login(Role) -> ok.
%% @doc 登录处理
login(#role{pid = _Pid}) ->
    case is_witch_time() of
        false -> skip;
        true -> skip %% 没有buff
            %% gen_server:cast(?MODULE, {login_witch_camp, Pid})
    end.   

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% @spec make(Item) -> NewItem  
%% Item = NewItem = #item{}
%% @doc 生成一个种子
make(Item = #item{base_id = BaseId, attr = Attr})
when BaseId =:= ?item_seed1 orelse BaseId =:= ?item_seed2 orelse BaseId =:= ?item_seed4 orelse BaseId =:= ?item_seed5 -> 
    Locate = make_locate(),
    Item#item{attr = Attr ++ Locate};
make(Item = #item{base_id = ?item_seed3, attr = Attr}) ->
    Locate = make_locate2(),
    Item#item{attr = Attr ++ Locate};
make(Item) ->
    Item.

%% 播种
seed(Role = #role{id = Rid, pos = #pos{}, team_pid = Tpid, link = #link{conn_pid = ConnPid}}, Item = #item{id = ItemId, base_id = BaseId}) when is_pid(Tpid) ->
    ?debug_log([seed, Rid]),
    case team:get_team_info(Tpid) of
        {ok, Team = #team{leader = #team_member{name = Oname, id = Orid}, member = [#team_member{name = Aname, id = Arid}]}} when Orid =:= Rid ->
            case is_valid_pos(Role, Item) of
                true ->
                    case role_gain:do([#loss{label = item_id, val = [{ItemId, 1}]}], Role) of
                        {ok, NewRole} ->
                            case is_valid_time(BaseId) of
                                true ->
                                    case is_valid_lev(Team) of
                                        true ->
                                            case is_valid_sex(Team) of
                                                true ->
                                                    case ?CALL(?MODULE, {seed, Item, Orid, Arid, Oname, Aname}) of
                                                        {ok} -> 
                                                            NewRole2 = role_listener:special_event(NewRole, {30033, 1}),
                                                            {ok, NewRole2};
                                                        {false, R} -> {false, R};
                                                        _ -> {false, ?L(<<"请稍后操作">>)}
                                                    end;
                                                boys -> {false, ?L(<<"请男女组队参与活动">>)};
                                                _ -> {false, ?L(<<"请男女组队参与活动">>)}
                                            end;
                                        false -> {false, util:fbin(?L(<<"燃放礼花要求两人等级都不低于 ~w 级">>), [?plant_lev_limit])}
                                    end;
                                false ->
                                    sys_conn:pack_send(ConnPid, 10931, {58, ?L(<<"活动已结束，该物品已失效！">>), []}),
                                    {ok, NewRole}
                            end;
                        _ -> {false, ?L(<<"请稍后再尝试">>)}
                    end;
                false -> {false, ?L(<<"请前往正确的地点种植礼花!">>)}
            end;
        {ok, #team{member = []}} ->
            {false, ?L(<<"请组队参与活动">>)};
        {ok, #team{member = Mems}} when length(Mems) >= 2 ->
            {false, ?L(<<"请组队参与活动">>)};
        {ok, #team{}} ->
            {false, ?L(<<"请由队长播种">>)};
        _ ->
            {false, ?L(<<"请稍候再试">>)}
    end;

seed(_, _) ->
    {false, ?L(<<"请组队参与活动">>)}.

%% 检测有效位置
is_valid_pos(#role{pos = #pos{map = RoleMapId, x = RoleX, y = RoleY}}, Item) ->
    {MapId, X, Y} = get_locate(Item),
    case MapId =:= RoleMapId of
        false -> false;
        true ->
            case erlang:abs(RoleX - X) < 500 of
                false -> false;
                true ->
                    case erlang:abs(RoleY - Y) < 500 of
                        false -> false;
                        true -> true
                    end
            end
    end.

%% 施肥、浇水
watering(#role{id = Rid}, ElemId) ->
    ?MODULE ! {watering, Rid, ElemId}.

%% 与女巫兑换物品
witch_exchange(Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case is_witch_time() of
        true ->
            LossList = [
                #loss{label = item, val = [33192, 0, 1], msg = ?L(<<"想要沾沾福气还是集齐四个字样再来吧">>)}
                ,#loss{label = item, val = [33193, 0, 1], msg = ?L(<<"想要沾沾福气还是集齐四个字样再来吧">>)}
                ,#loss{label = item, val = [33194, 0, 1], msg = ?L(<<"想要沾沾福气还是集齐四个字样再来吧">>)}
                ,#loss{label = item, val = [33195, 0, 1], msg = ?L(<<"想要沾沾福气还是集齐四个字样再来吧">>)}
            ],
            case role_gain:do(LossList, Role) of
                {false, #loss{msg = Msg}} -> {false, Msg};
                {ok, NewRole} ->
                    case item:make(29489, 1, 1) of
                        false -> {false, ?L(<<"物品数据异常">>)};
                        {ok, ItemList} ->
                            case storage:add(bag, NewRole, ItemList) of
                                false -> {false, ?L(<<"您的背包空间不足，无法兑换">>)};
                                {ok, NewBag} ->
                                    ?MODULE ! update_witch,
                                    sys_conn:pack_send(ConnPid, 10931, {57, ?L(<<"兑换成功，您获得了蛇年吉祥礼包*1">>), []}),
                                    notice:inform(util:fbin(?L(<<"获得{item3, ~w, ~w, ~w}">>), [29489, 1, 1])),
                                    log:log(log_handle_all, {15815, <<"篱儿活动兑换">>, util:fbin(<<"兑换物品[~s, ~w],消耗[~s,~w]">>, [<<"蛇年吉祥礼包">>, 1, <<"蛇年卡套">>, 1]), Role}),
                                    {ok, NewRole#role{bag = NewBag}}
                            end
                    end
            end;
        false ->
            {false, ?L(<<"现在不是活动时间">>)}
    end.

%% 打印进程信息
info() ->
    ?MODULE ! {info}.

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

%% @spec init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    self() ! flower_check,
    self() ! create_witch,
    self() ! create_dragon, %% 金甲雷光
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{}}.

%% @spec: handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
handle_call({seed, Item, Orid, Arid, Oname, Aname}, _From, State = #state{plants = Plants, used_elem_id = UsedIds}) ->
    {MapId, X, Y} = get_locate(Item),
    ?debug_log([seed_pos, {MapId, X, Y}]),
    case lists:keyfind({MapId, X, Y}, #plant.pos, Plants) of
        #plant{status = Status} when Status =/= ?plant_tree_elem ->
            {reply, {false, ?L(<<"此处有人在种植，请再等会!">>)}, State};
        FindFlower ->
            DeleteId = case FindFlower of
                #plant{elem_id = FlowerId} when MapId =:= 36031 -> 
                    center:cast(map, elem_leave, [MapId, FlowerId]),
                    FlowerId;
                #plant{elem_id = FlowerId} -> 
                    map:elem_leave(MapId, FlowerId),
                    FlowerId;
                _ -> 
                    0
            end,
            ElemId = get_valid_elem_id(UsedIds),
            ElemBaseId = item_to_elem(Item),
            Flower = #plant{pos = {MapId, X, Y}, owner_rid = Orid, assist_rid = Arid, timestamp = util:unixtime(), status = ?plant_seed_elem, elem_id = ElemId, elem_base_id = ElemBaseId},
            PlantFlower = map_data_elem:get(ElemBaseId),
            seed_flower(Flower, PlantFlower, Oname, Aname),    %% 种子进入场景
            inform_process(Arid, ElemId, ElemBaseId, ?plant_seed_elem),
            inform_hint(Orid, get_lang(1, own, ElemBaseId)),
            inform_hint(Arid, get_lang(1, other, ElemBaseId)),
            {reply, {ok}, State#state{plants = [Flower | lists:keydelete({MapId, X, Y}, #plant.pos, Plants)], used_elem_id = [ElemId | UsedIds] -- [DeleteId]}}
    end;

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%% @spec: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
handle_cast({login_witch_camp, Pid}, State = #state{witch_buff_effect = {Buff, EndTime}}) ->
    Now = util:unixtime(),
    case EndTime > Now of
        true ->
            role:apply(async, Pid, {campaign_plant, add_buff, [Buff, EndTime]});
        false ->
            skip
    end,
    {noreply, State};

handle_cast({set_witch_power, Power}, State = #state{witch_id = WitchId}) ->
    NpcList = map:npc_list(10003),
    case lists:keyfind(WitchId, #map_npc.id, NpcList) of
        false ->
            skip;
        MapNpc ->
            case Power < 50 of
                true ->
                    map:npc_update(10003, MapNpc#map_npc{base_id = ?witch_npc_base_id, speed = Power});
                false ->
                    map:npc_update(10003, MapNpc#map_npc{base_id = ?witch_npc_base_id_ex, speed = Power})
            end
    end,
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% @spec: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
handle_info(clear_point, State) ->
    map:elem_leave(10003, 656666),
    {noreply, State};

handle_info(create_dragon, State) ->
    Begin = util:datetime_to_seconds(?dragon_start_time),
    End = util:datetime_to_seconds(?dragon_end_time),
    Now = util:unixtime(),
    if
        Now < Begin ->
            erlang:send_after((Begin - Now + 2) * 1000, self(), create_dragon);
        Now >= Begin andalso Now =< End ->
           map:create_npc(10003, 25072, 1920, 1530),
           notice:send(53, ?L(<<"飞仙世界的守护神之一金甲雷光受到妖气侵袭，心智丧失，仙友们快前往洛水城唤醒雷光之神，保卫飞仙世界。">>)),
           erlang:send_after((End - Now) * 1000, self(), clear_dragon),
           erlang:send_after(3600 * 1000, self(), notice_dragon);
       true -> ignore
   end,
   {noreply, State};

handle_info(clear_dragon, State) ->
    npc:stop(by_base_id, 25072),
    notice:send(53, ?L(<<"金甲雷光经重仙友齐心协力驱除妖气后，元神复苏，飞回仙界，守护着一方安宁。">>)),
    {noreply, State};

handle_info(notice_dragon, State) ->
    Begin = util:datetime_to_seconds(?dragon_start_time),
    End = util:datetime_to_seconds(?dragon_end_time),
    Now = util:unixtime(),
    case Now >= Begin andalso Now =< End of
        true ->
           notice:send(53, ?L(<<"飞仙世界的守护神之一金甲雷光受到妖气侵袭，心智丧失，仙友们快前往洛水城唤醒雷光之神，保卫飞仙世界。">>)),
            erlang:send_after(3600 * 1000, self(), notice_dragon);
        false -> skip
    end,
    {noreply, State};

handle_info(create_witch, State) ->
    Begin = util:datetime_to_seconds(?witch_start_time),
    End = util:datetime_to_seconds(?witch_end_time),
    Now = util:unixtime(),
    if
        Now < Begin ->
            erlang:send_after((Begin - Now) * 1000, self(), create_witch),
            {noreply, State};
        Now >= Begin andalso Now =< End ->
            case npc_mgr:create(?witch_npc_base_id, 10003, 1920, 1530) of
                false ->
                    ?ERR("创建女巫NPC失败!"),
                    {noreply, State};
                {ok, NpcId} ->
                    NpcList = map:npc_list(10003),
                    case lists:keyfind(NpcId, #map_npc.id, NpcList) of
                        false ->
                            ?ERR("创建女巫NPC失败!"),
                            {noreply, State};
                        MapNpc ->
                            map:npc_update(10003, MapNpc#map_npc{speed = 0}),
                            erlang:send_after((util:unixtime({tomorrow, Now}) - Now) * 1000, self(), reset_witch),
                            erlang:send_after((End - Now) * 1000, self(), clear_witch),
                            notice:send(53, ?L(<<"在众仙友的共同努力下，遗失的金匾字样逐渐被找回，福气满满弥漫仙界，普天祥瑞指日可待！{handle, 58, 我要兑换, #FFFF66, 10003, 1800, 1500}">>)),
                            {noreply, State#state{witch_id = NpcId, witch_buff = intensify_luck}}
                    end
            end;
        true ->
            {noreply, State}
    end;

handle_info(clear_witch, State = #state{witch_id = WitchId}) ->
    npc_mgr:remove(WitchId),
    {noreply, State#state{witch_id = 0, witch_buff = 0}};

handle_info(reset_witch, State = #state{witch_id = WitchId, witch_buff = Buff}) ->
    NpcList = map:npc_list(10003),
    case lists:keyfind(WitchId, #map_npc.id, NpcList) of
        false ->
            ?ERR("重置女巫NPC失败!"),
            {noreply, State};
        _MapNpc ->
            npc_mgr:remove(WitchId),
            case npc_mgr:create(?witch_npc_base_id, 10003, 1920, 1530) of
                false ->
                    ?ERR("创建解封女巫NPC失败!"),
                    {noreply, State};
                {ok, NpcId} ->
                    NewNpcList = map:npc_list(10003),
                    case lists:keyfind(NpcId, #map_npc.id, NewNpcList) of
                        false ->
                            ?ERR("创建女巫NPC失败!"),
                            {noreply, State};
                        NewMapNpc ->
                            map:npc_update(10003, NewMapNpc#map_npc{base_id = ?witch_npc_base_id, speed = 0}),
                            End = util:datetime_to_seconds(?witch_end_time),
                            Now = util:unixtime(),
                            case End - Now > 24 * 3600 of
                                true ->
                                    erlang:send_after((util:unixtime({tomorrow, Now}) - Now) * 1000, self(), reset_witch);
                                false ->
                                    skip
                            end,
                            notice:send(53, ?L(<<"在众仙友的共同努力下，遗失的金匾字样逐渐被找回，福气满满弥漫仙界，普天祥瑞指日可待！{handle, 58, 我要兑换, #FFFF66, 10003, 1800, 1500}">>)),
                            {noreply, State#state{witch_id = NpcId, witch_buff = get_next_witch_buff(Buff)}}
                    end
            end
    end;

handle_info(update_witch, State = #state{witch_id = WitchId, witch_buff = _Buff}) ->
    NpcList = map:npc_list(10003),
    case lists:keyfind(WitchId, #map_npc.id, NpcList) of
        false ->
            ?ERR("女巫NPC获取失败!"),
            {noreply, State};
        MapNpc = #map_npc{speed = Power} ->
            NewPower = Power + 1,
            case NewPower rem 10 =:= 0 of
                true -> notice:send(53, ?L(<<"在众仙友的共同努力下，遗失的“蛇年吉祥”字样逐渐被找回，福气满满弥漫仙界，普天祥瑞指日可待！{handle, 58, 我要兑换, #FFFF66, 10003, 1800, 1500}">>));
                _ -> skip
            end,
            case NewPower =:= 120 of
                true ->
                    map:npc_update(10003, MapNpc#map_npc{speed = NewPower}),
                    add_buff_online_all(mail_reward),
                    %% notice:send(53, util:fbin(?L(<<"在仙友们的努力下，石化解除，女巫终于重现，万丈光芒，所有人获得了{str,【~s】,#FFD700}">>), [BuffName])),
                    {ok, [Item]} = item:make(29490, 1, 1),
                    ItemMsg = notice:item_to_msg(Item),
                    notice:send(53, util:fbin(?L(<<"遗失的金匾字样终于全部归位，福星挥手间祥光普照，众仙友都获得了~s！">>), [ItemMsg])),
                    {noreply, State};
                false ->
                    map:npc_update(10003, MapNpc#map_npc{speed = NewPower}),
                    {noreply, State}
            end
            %?DEBUG("witch Power = ~w ################", [NewPower]),
            %% {ok, #buff{name = BuffName}} = buff_data:get(Buff),
            %% if
            %%     NewPower =:= 50 ->
            %%         npc_mgr:remove(WitchId),
            %%         case npc_mgr:create(?witch_npc_base_id_ex, 10003, 1920, 15福星兑换：每兑换10次没有传闻，福字全亮了也没有传闻，没有全服邮件30) of
            %%             false ->
            %%                 ?ERR("创建解封女巫NPC失败!"),
            %%                 {noreply, State};
            %%             {ok, NpcId} ->
            %%                 NewNpcList = map:npc_list(10003),
            %%                 case lists:keyfind(NpcId, #map_npc.id, NewNpcList) of
            %%                     false ->
            %%                         ?ERR("创建女巫NPC失败!"),
            %%                         {noreply, State};
            %%                     NewMapNpc ->
            %%                         map:npc_update(10003, NewMapNpc#map_npc{base_id = ?witch_npc_base_id_ex, speed = NewPower}),
            %%                         add_buff_online_all(Buff),
            %%                         notice:send(53, util:fbin(?L(<<"在仙友们的努力下，石化解除，女巫终于重现，万丈光芒，所有人获得了{str,【~s】,#FFD700}">>), [BuffName])),
            %%                         {noreply, State#state{witch_id = NpcId, witch_buff_effect = {Buff, util:unixtime() + 3 * 3600}}}
            %%                 end
            %%         end;
            %%     NewPower rem 50 =:= 0 ->
            %%         map:npc_update(10003, MapNpc#map_npc{speed = NewPower}),
            %%         add_buff_online_all(Buff),
            %%         notice:send(53, util:fbin(?L(<<"魔力之源再次提升50，女巫魔法能量逐渐释放，再次为所有人赋予了{str,【~s】,#FFD700}">>), [BuffName])),
            %%         {noreply, State#state{witch_buff_effect = {Buff, util:unixtime() + 3 * 3600}}};
            %%     true ->
            %%         map:npc_update(10003, MapNpc#map_npc{speed = NewPower}),
            %%         {noreply, State}
            %% end
    end;

handle_info({watering, Rid, ElemId}, State = #state{plants = Plants}) ->
    ?debug_log([watering, {Rid, ElemId}]),
    case lists:keyfind(ElemId, #plant.elem_id, Plants) of
        false -> {noreply, State};
        Flower = #plant{owner_rid = Orid, assist_rid = Arid, elem_id = ElemId, elem_base_id = ElemBaseId} when Orid =:= Rid orelse Arid =:= Rid ->
            case do_handle(Rid, Flower) of
                {ok, NewFlower = #plant{status = Status}} ->
                    case Orid =:= Rid of
                        true -> inform_process(Arid, ElemId, ElemBaseId, Status);
                        _ -> inform_process(Orid, ElemId, ElemBaseId, Status)
                    end,
                    {noreply, State#state{plants = lists:keyreplace(ElemId, #plant.elem_id, Plants, NewFlower)}};
                {false, _Reason} ->
                    {noreply, State}
            end;
        #plant{elem_base_id = ElemBaseId} ->
            inform_hint(Rid, get_lang(0, own, ElemBaseId)),
            ?debug_log([watering, not_for_you]),
            {noreply, State}
    end;

handle_info(flower_check, State = #state{plants = Plants}) ->
    EndTime = util:datetime_to_seconds(?plant_end_date), 
    Now = util:unixtime(),
    NewPlants = case Now >= EndTime of
        true -> clear_all_plant(Plants);
        false ->
            erlang:send_after(?plant_check * 1000, self(), flower_check),
            flower_check(Plants)
    end,
    {noreply, State#state{plants = NewPlants}};

handle_info({info}, State) ->
    ?debug_log([state, State]),
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.

%% @spec: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
terminate(_Reason, _State) ->
    ok.

%% @spec: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------


%% 设置坐标
make_locate() ->
    case util:rand_list(flower_data:pos()) of
        {MapId, X, Y} ->
            [{?attr_treasure_map, 300, MapId}, {?attr_treasure_x, 300, X}, {?attr_treasure_y, 300, Y}];
        _ -> 
            []
    end.

make_locate2() ->
    L = [
        {9120,300},
        {9360,240},
        {9540,450},
        {9420,660},
        {9180,720},
        {9360,510},
        {9240,210},
        {9360,960},
        {1200,5640},
        {1140,5940},
        {900,5850},
        {480,5970},
        {660,5640},
        {720,5400},
        {960,6060}
    ],
    MapId = 36031,
    case util:rand_list(L) of
        {X, Y} ->
            [{?attr_treasure_map, 300, MapId}, {?attr_treasure_x, 300, X}, {?attr_treasure_y, 300, Y}];
        _ -> 
            []
    end.

%% 获取坐标
get_locate(#item{attr = Attr}) ->
    MapId = case lists:keyfind(?attr_treasure_map, 1, Attr) of
        {_, _, MapId1} ->
            MapId1;
        _ ->
            0
    end,
    X = case lists:keyfind(?attr_treasure_x, 1, Attr) of
        {_, _, X1} ->
            X1;
        _ ->
            0
    end,
    Y = case lists:keyfind(?attr_treasure_y, 1, Attr) of
        {_, _, Y1} ->
            Y1;
        _ ->
            0
    end,
    {MapId, X, Y}.

%% 获取地图元素id
get_valid_elem_id(UsedIds) ->
    do_get_valid_elem_id(UsedIds, ?start_elem_id).
do_get_valid_elem_id(UsedIds, Id) ->
    case lists:member(Id, UsedIds) of
        true ->
            do_get_valid_elem_id(UsedIds, Id + 1);
        false ->
            Id
    end.

%-define(plant_seed, 1).                %% 播种，待浇水
%-define(plant_seed_water, 2).          %% 浇水，待施肥
%-define(plant_seed_fertilize, 3).      %% 施肥，待除草
%-define(plant_seed_weeding, 4).        %% 除草，待除虫
%-define(plant_seed_disinsection, 5).   %% 除虫，待成型
%-define(plant_tree, 6).                %% 成型

%% 浇水
do_handle(Rid, Flower = #plant{status = ?plant_seed_elem, owner_rid = Orid, assist_rid = Arid, pos = {MapId, _, _}, elem_id = FlowerId, elem_base_id = ElemBaseId}) ->
    case Rid =:= Arid of
        false ->
            inform_hint(Rid, get_lang(2, own, ElemBaseId)),
            {false, get_lang(2, own, ElemBaseId)};
        true ->
            inform_hint(Orid, get_lang(3, own, ElemBaseId)),
            inform_hint(Arid, get_lang(3, other, ElemBaseId)),
            flower_grow_up(MapId, FlowerId, ?plant_seed_water_elem),
            {ok, Flower#plant{status = ?plant_seed_water_elem, timestamp = util:unixtime()}}
    end;
%% 施肥
do_handle(Rid, Flower = #plant{status = ?plant_seed_water_elem, owner_rid = Orid, assist_rid = Arid, pos = {MapId, _, _}, elem_id = FlowerId, elem_base_id = ElemBaseId}) ->
    case Rid =:= Orid of
        false ->
            inform_hint(Rid, get_lang(4, own, ElemBaseId)),
            {false, get_lang(4, own, ElemBaseId)};
        true ->
            inform_hint(Orid, get_lang(5, own, ElemBaseId)),
            inform_hint(Arid, get_lang(5, other, ElemBaseId)),
            flower_grow_up(MapId, FlowerId, ?plant_seed_fertilize_elem),
            {ok, Flower#plant{status = ?plant_seed_fertilize_elem, timestamp = util:unixtime()}}
    end;
%% 除草/授粉
do_handle(Rid, Flower = #plant{status = ?plant_seed_fertilize_elem, owner_rid = Orid, assist_rid = Arid, pos = {MapId, _, _}, elem_id = FlowerId, elem_base_id = ElemBaseId}) ->
    case Rid =:= Arid of
        false ->
            inform_hint(Rid, get_lang(6, own, ElemBaseId)),
            {false, get_lang(6, own, ElemBaseId)};
        true ->
            inform_hint(Orid, get_lang(7, own, ElemBaseId)),
            inform_hint(Arid, get_lang(7, other, ElemBaseId)),
            flower_grow_up(MapId, FlowerId, ?plant_seed_weeding_elem),
            {ok, Flower#plant{status = ?plant_seed_weeding_elem, timestamp = util:unixtime()}}
    end;
%% 幼苗/除虫
do_handle(Rid, Flower = #plant{status = ?plant_seed_weeding_elem, owner_rid = Orid, assist_rid = Arid, pos = {MapId, _, _}, elem_id = FlowerId, elem_base_id = ElemBaseId}) ->
    case Rid =:= Orid of
        false ->
            inform_hint(Rid, get_lang(8, own, ElemBaseId)),
            {false, get_lang(8, own, ElemBaseId)};
        true ->
            inform_hint(Orid, get_lang(9, own, ElemBaseId)),
            inform_hint(Arid, get_lang(9, other, ElemBaseId)),
            inform_success(Orid, Arid, ElemBaseId),
            inform_hint(Orid, get_lang(10, own, ElemBaseId)),
            inform_hint(Arid, get_lang(10, other, ElemBaseId)),
            flower_grow_up(MapId, FlowerId, ?plant_tree_elem),
            {ok, Flower#plant{status = ?plant_tree_elem, timestamp = util:unixtime()}}
    end;
do_handle(Rid, #plant{elem_base_id = ElemBaseId}) ->
    inform_hint(Rid, get_lang(11, own, ElemBaseId)),
    {false, get_lang(11, own, ElemBaseId)};
do_handle(_, _) ->
    {false, ?L(<<"不要乱采摘">>)}.

%% 小花花
get_lang(0, own, 60406) ->    ?L(<<"这是其他仙友精心种植的小花花哦！请不要采摘！">>);
get_lang(1, own, 60406) ->    ?L(<<"您已放下树苗，请不要离开，呵护幼苗直到它生长成一个大大的小花花哦">>);
get_lang(1, other, 60406) ->  ?L(<<"您同伴已放下树苗，请不要离开，小心呵护幼苗直到它生长成小花花吧！">>);
get_lang(2, own, 60406) ->    ?L(<<"小花花苗已种下，浇水后树苗就能发芽！">>);
get_lang(3, own, 60406) ->    ?L(<<"已经浇过水，施肥后芽苗就能成型！">>);
get_lang(3, other, 60406) ->  ?L(<<"已经浇过水，施肥后芽苗就能成型！">>);
get_lang(4, own, 60406) ->    ?L(<<"已经浇过水，请让你的同伴给花苗施肥！">>);
get_lang(5, own, 60406) ->    ?L(<<"已经施过肥，除虫后就能装饰喏！">>);
get_lang(5, other, 60406) ->  ?L(<<"已经施过肥，除虫后就能装饰喏！">>);
get_lang(6, own, 60406) ->    ?L(<<"快点让同伴除虫吧，不然花苗就快凋谢了！">>);
get_lang(7, own, 60406) ->    ?L(<<"已经除虫了，快快装饰小花花吧！">>);
get_lang(7, other, 60406) ->  ?L(<<"已经除虫了，快快装饰小花花吧！">>);
get_lang(8, own, 60406) ->    ?L(<<"请让你的同伴为幼瓜装饰。">>);
get_lang(9, own, 60406) ->    ?L(<<"装饰成功，小花花开始慢慢成长。">>);
get_lang(9, other, 60406) ->  ?L(<<"装饰成功，小花花开始慢慢成长。">>);
get_lang(10, own, 60406) ->   ?L(<<"恭喜！小花花苗在您们2人精心爱护下长成漂亮的小花花">>);
get_lang(10, other, 60406) -> ?L(<<"恭喜！小花花苗在您们2人精心爱护下长成漂亮的小花花">>);
get_lang(11, own, 60406) -> ?L(<<"这是您自己精心种植的小花花">>);
get_lang(12, own, 60406) -> ?L(<<"由于您对小花花苗疏于照顾，树苗枯萎了，种植小花花失败。">>);
get_lang(12, other, 60406) -> ?L(<<"由于您对小花花苗疏于照顾，树苗枯萎了，种植小花花失败。">>);
get_lang(13, own, 60406) -> ?L(<<"您未能精心呵护小花花，很遗憾小花花已经枯萎了！">>);
get_lang(13, other, 60406) -> ?L(<<"您未能精心呵护小花花，很遗憾小花花已经枯萎了！">>);

%% 玫瑰花
get_lang(0, own, 60517) ->    ?L(<<"这是其他仙友精心种植的小花花哦！请不要采摘！">>);
get_lang(1, own, 60517) ->    ?L(<<"您已放下树苗，请不要离开，呵护幼苗直到它生长成一个大大的小花花哦">>);
get_lang(1, other, 60517) ->  ?L(<<"您同伴已放下树苗，请不要离开，小心呵护幼苗直到它生长成小花花吧！">>);
get_lang(2, own, 60517) ->    ?L(<<"小花花苗已种下，浇水后树苗就能发芽！">>);
get_lang(3, own, 60517) ->    ?L(<<"已经浇过水，施肥后芽苗就能成型！">>);
get_lang(3, other, 60517) ->  ?L(<<"已经浇过水，施肥后芽苗就能成型！">>);
get_lang(4, own, 60517) ->    ?L(<<"已经浇过水，请让你的同伴给花苗施肥！">>);
get_lang(5, own, 60517) ->    ?L(<<"已经施过肥，除虫后就能装饰喏！">>);
get_lang(5, other, 60517) ->  ?L(<<"已经施过肥，除虫后就能装饰喏！">>);
get_lang(6, own, 60517) ->    ?L(<<"快点让同伴除虫吧，不然花苗就快凋谢了！">>);
get_lang(7, own, 60517) ->    ?L(<<"已经除虫了，快快装饰小花花吧！">>);
get_lang(7, other, 60517) ->  ?L(<<"已经除虫了，快快装饰小花花吧！">>);
get_lang(8, own, 60517) ->    ?L(<<"请让你的同伴为幼瓜装饰。">>);
get_lang(9, own, 60517) ->    ?L(<<"装饰成功，小花花开始慢慢成长。">>);
get_lang(9, other, 60517) ->  ?L(<<"装饰成功，小花花开始慢慢成长。">>);
get_lang(10, own, 60517) ->   ?L(<<"恭喜！小花花苗在您们2人精心爱护下长成漂亮的小花花">>);
get_lang(10, other, 60517) -> ?L(<<"恭喜！小花花苗在您们2人精心爱护下长成漂亮的小花花">>);
get_lang(11, own, 60517) -> ?L(<<"这是您自己精心种植的小花花">>);
get_lang(12, own, 60517) -> ?L(<<"由于您对小花花苗疏于照顾，树苗枯萎了，种植小花花失败。">>);
get_lang(12, other, 60517) -> ?L(<<"由于您对小花花苗疏于照顾，树苗枯萎了，种植小花花失败。">>);
get_lang(13, own, 60517) -> ?L(<<"您未能精心呵护小花花，很遗憾小花花已经枯萎了！">>);
get_lang(13, other, 60517) -> ?L(<<"您未能精心呵护小花花，很遗憾小花花已经枯萎了！">>);

%% 南瓜类
get_lang(0, own, 60449) ->    ?L(<<"这是其他仙友在万圣节活动中精心种植的大南瓜哦！请不要采摘！">>);
get_lang(1, own, 60449) ->    ?L(<<"您已放下种子，请不要离开，呵护幼苗直到它生长成一个大大的南瓜哦">>);
get_lang(1, other, 60449) ->  ?L(<<"您同伴已放下种子，请不要离开，小心呵护幼苗直到它生长成大南瓜吧！">>);
get_lang(2, own, 60449) ->    ?L(<<"南瓜种子已种下，浇水后南瓜种子就能发芽！">>);
get_lang(3, own, 60449) ->    ?L(<<"已经浇过水，施肥后芽苗就能开花！">>);
get_lang(3, other, 60449) ->  ?L(<<"已经浇过水，施肥后芽苗就能开花！">>);
get_lang(4, own, 60449) ->    ?L(<<"已经浇过水，请让你的同伴给花苗施肥！">>);
get_lang(5, own, 60449) ->    ?L(<<"已经施过肥，授粉后就能结瓜喏！">>);
get_lang(5, other, 60449) ->  ?L(<<"已经施过肥，授粉后就能结瓜喏！">>);
get_lang(6, own, 60449) ->    ?L(<<"快点让同伴授粉吧，不然花苗就快凋谢了！">>);
get_lang(7, own, 60449) ->    ?L(<<"已经受过粉，结出了幼瓜，快除去幼瓜上的虫子吧！">>);
get_lang(7, other, 60449) ->  ?L(<<"已经受过粉，结出了幼瓜，快除去幼瓜上的虫子吧！">>);
get_lang(8, own, 60449) ->    ?L(<<"请让你的同伴为幼瓜除虫。">>);
get_lang(9, own, 60449) ->    ?L(<<"除虫成功，幼瓜开始慢慢成长。">>);
get_lang(9, other, 60449) ->  ?L(<<"除虫成功，幼瓜开始慢慢成长。">>);
get_lang(10, own, 60449) ->   ?L(<<"恭喜！南瓜种子在您们2人精心种植下长成大南瓜">>);
get_lang(10, other, 60449) -> ?L(<<"恭喜！南瓜种子在您们2人精心种植下长成大南瓜">>);
get_lang(11, own, 60449) -> ?L(<<"这是您自己精心种植的南瓜">>);
get_lang(12, own, 60449) -> ?L(<<"由于您对南瓜疏于照顾，瓜藤枯萎了，种植南瓜失败。">>);
get_lang(12, other, 60449) -> ?L(<<"由于您对南瓜疏于照顾，瓜藤枯萎了，种植南瓜失败。">>);
get_lang(13, own, 60449) -> ?L(<<"您未能精心呵护南瓜藤，很遗憾瓜藤已经枯萎了！">>);
get_lang(13, other, 60449) -> ?L(<<"您未能精心呵护南瓜藤，很遗憾瓜藤已经枯萎了！">>);

%% 圣诞树
get_lang(0, own, 60501) ->    ?L(<<"这是其他仙友在圣诞节活动中精心种植的圣诞树哦！请不要采摘！">>);
get_lang(1, own, 60501) ->    ?L(<<"您已放下树苗，请不要离开，呵护幼苗直到它生长成一个大大的圣诞树哦">>);
get_lang(1, other, 60501) ->  ?L(<<"您同伴已放下树苗，请不要离开，小心呵护幼苗直到它生长成圣诞树吧！">>);
get_lang(2, own, 60501) ->    ?L(<<"圣诞树苗已种下，浇水后树苗就能发芽！">>);
get_lang(3, own, 60501) ->    ?L(<<"已经浇过水，施肥后芽苗就能成型！">>);
get_lang(3, other, 60501) ->  ?L(<<"已经浇过水，施肥后芽苗就能成型！">>);
get_lang(4, own, 60501) ->    ?L(<<"已经浇过水，请让你的同伴给花苗施肥！">>);
get_lang(5, own, 60501) ->    ?L(<<"已经施过肥，除虫后就能装饰喏！">>);
get_lang(5, other, 60501) ->  ?L(<<"已经施过肥，除虫后就能装饰喏！">>);
get_lang(6, own, 60501) ->    ?L(<<"快点让同伴除虫吧，不然花苗就快凋谢了！">>);
get_lang(7, own, 60501) ->    ?L(<<"已经除虫了，快快装饰圣诞树吧！">>);
get_lang(7, other, 60501) ->  ?L(<<"已经除虫了，快快装饰圣诞树吧！">>);
get_lang(8, own, 60501) ->    ?L(<<"请让你的同伴为幼瓜装饰。">>);
get_lang(9, own, 60501) ->    ?L(<<"装饰成功，圣诞树开始慢慢成长。">>);
get_lang(9, other, 60501) ->  ?L(<<"装饰成功，圣诞树开始慢慢成长。">>);
get_lang(10, own, 60501) ->   ?L(<<"恭喜！圣诞树苗在您们2人精心爱护下长成漂亮的圣诞树">>);
get_lang(10, other, 60501) -> ?L(<<"恭喜！圣诞树苗在您们2人精心爱护下长成漂亮的圣诞树">>);
get_lang(11, own, 60501) -> ?L(<<"这是您自己精心种植的圣诞树">>);
get_lang(12, own, 60501) -> ?L(<<"由于您对圣诞树苗疏于照顾，树苗枯萎了，种植圣诞树失败。">>);
get_lang(12, other, 60501) -> ?L(<<"由于您对圣诞树苗疏于照顾，树苗枯萎了，种植圣诞树失败。">>);
get_lang(13, own, 60501) -> ?L(<<"您未能精心呵护圣诞树，很遗憾圣诞树已经枯萎了！">>);
get_lang(13, other, 60501) -> ?L(<<"您未能精心呵护圣诞树，很遗憾圣诞树已经枯萎了！">>);

%% 圣诞雪人
get_lang(0, own, 60502) ->    ?L(<<"这是其他仙友在圣诞节活动中精心堆置的雪人哦！请不要破坏！">>);
get_lang(1, own, 60502) ->    ?L(<<"您已放下礼花，请不要离开，呵护幼苗直到它生长成一个大大的圣诞树哦！">>);
get_lang(1, other, 60502) ->  ?L(<<"您同伴已放下雪堆，请不要离开，精心堆好直到堆成一个大大的雪人哦！">>);
get_lang(2, own, 60502) ->    ?L(<<"雪堆已放下，继续堆雪至足够大就可以捏雪人了！">>);
get_lang(3, own, 60502) ->    ?L(<<"已经堆过雪了，捏雪后雪堆就能成形啦！">>);
get_lang(3, other, 60502) ->  ?L(<<"已经堆过雪了，捏雪后雪堆就能成形啦！">>);
get_lang(4, own, 60502) ->    ?L(<<"已经堆过雪了，请让你的同伴给雪堆捏形状吧！">>);
get_lang(5, own, 60502) ->    ?L(<<"已经捏好形状了，装饰后雪人就会更加好看了！">>);
get_lang(5, other, 60502) ->  ?L(<<"已经捏好形状了，装饰后雪人就会更加好看了！">>);
get_lang(6, own, 60502) ->    ?L(<<"快点让同伴装饰吧，不然雪人就快化了！">>);
get_lang(7, own, 60502) ->    ?L(<<"已经装饰好了，快美化雪人的装饰吧！">>);
get_lang(7, other, 60502) ->  ?L(<<"已经装饰好了，快美化雪人的装饰吧！">>);
get_lang(8, own, 60502) ->    ?L(<<"请让你的同伴为雪人美化。">>);
get_lang(9, own, 60502) ->    ?L(<<"美化成功，可爱的雪人已经成形啦。">>);
get_lang(9, other, 60502) ->  ?L(<<"美化成功，可爱的雪人已经成形啦。">>);
get_lang(10, own, 60502) ->   ?L(<<"恭喜！雪堆在您们2人精心捏制和装饰下成了可爱的雪人">>);
get_lang(10, other, 60502) -> ?L(<<"恭喜！雪堆在您们2人精心捏制和装饰下成了可爱的雪人">>);
get_lang(11, own, 60502) -> ?L(<<"这是您自己精心堆的雪人">>);
get_lang(12, own, 60502) -> ?L(<<"由于您对雪人疏于照顾，雪人化了，堆雪人失败。">>);
get_lang(12, other, 60502) -> ?L(<<"由于您对雪人疏于照顾，雪人化了，堆雪人失败。">>);
get_lang(13, own, 60502) -> ?L(<<"您未能精心堆置雪人，很遗憾雪人已经化掉了！">>);
get_lang(13, other, 60502) -> ?L(<<"您未能精心堆置雪人，很遗憾雪人已经化掉了！">>);

%% 周年庆礼花
get_lang(0, own, 60522) ->    ?L(<<"这是其他仙友在周年庆活动中精心燃放的礼花哦！请不要捣乱！">>);
get_lang(1, own, 60522) ->    ?L(<<"您已经放下礼花筒，请继续制作礼花将其点燃哦！">>);
get_lang(1, other, 60522) ->  ?L(<<"您同伴已经放下礼花筒，请不要离开，一同燃放礼花吧！">>);
get_lang(2, own, 60522) ->    ?L(<<"礼花已放下，开始制作礼花筒吧！">>);
get_lang(3, own, 60522) ->    ?L(<<"彩纸装饰完毕，快快装填火药吧！">>);
get_lang(3, other, 60522) ->  ?L(<<"彩纸装饰完毕，快快装填火药吧！">>);
get_lang(4, own, 60522) ->    ?L(<<"已经准备好礼花筒，请你的同伴贴上彩纸吧！">>);
get_lang(5, own, 60522) ->    ?L(<<"火药装填完毕，接着准备好导火线吧！">>);
get_lang(5, other, 60522) ->  ?L(<<"火药装填完毕，接着准备好导火线吧！">>);
get_lang(6, own, 60522) ->    ?L(<<"快点让同伴装火药吧！">>);
get_lang(7, own, 60522) ->    ?L(<<"导火线准备完毕，赶紧点燃礼花吧！">>);
get_lang(7, other, 60522) ->  ?L(<<"导火线准备完毕，赶紧点燃礼花吧！">>);
get_lang(8, own, 60522) ->    ?L(<<"请让你的同伴安装导火线！">>);
get_lang(9, own, 60522) ->    ?L(<<"成功点燃礼花！">>);
get_lang(9, other, 60522) ->  ?L(<<"成功点燃礼花！">>);
get_lang(10, own, 60522) ->   ?L(<<"恭喜！周年礼花在您们2人的共同努力下终于绚丽绽放了！">>);
get_lang(10, other, 60522) -> ?L(<<"恭喜！周年礼花在您们2人的共同努力下终于绚丽绽放了！">>);
get_lang(11, own, 60522) -> ?L(<<"这是您自己精心燃放的礼花">>);
get_lang(12, own, 60522) -> ?L(<<"由于您在制作礼花的过程中不专心，礼花燃放失败。">>);
get_lang(12, other, 60522) -> ?L(<<"由于您在制作礼花的过程中不专心，礼花燃放失败。">>);
get_lang(13, own, 60522) -> ?L(<<"很遗憾您未能成功燃放周年庆礼花。">>);
get_lang(13, other, 60522) -> ?L(<<"很遗憾您未能成功燃放周年庆礼花。">>).

get_plant_name(60449) -> ?L(<<"~s 和 ~s 的大南瓜">>);
get_plant_name(60501) -> ?L(<<"~s 和 ~s 的圣诞树">>);
get_plant_name(60502) -> ?L(<<"~s 和 ~s 的雪人">>);
get_plant_name(60406) -> ?L(<<"~s 和 ~s 的小花花">>);
get_plant_name(60517) -> ?L(<<"~s 和 ~s 的玫瑰花">>);
get_plant_name(60522) -> ?L(<<"~s 和 ~s 的礼花">>).

item_to_elem(#item{base_id = 33138}) -> 60449;
item_to_elem(#item{base_id = 33174}) -> 60501;
item_to_elem(#item{base_id = 33175}) -> 60502;
item_to_elem(#item{base_id = 33191}) -> 60406;
item_to_elem(#item{base_id = 33111}) -> 60517;
item_to_elem(#item{base_id = 33221}) -> 60522.

get_mail(content, 60449) -> ?L(<<"拜祭善灵，平安种瓜">>);
get_mail(content, 60501) -> ?L(<<"圣诞活动之欢乐种树">>);
get_mail(content, 60502) -> ?L(<<"圣诞活动之齐堆雪人">>);
get_mail(content, 60406) -> ?L(<<"种花得花">>);
get_mail(content, 60517) -> ?L(<<"情意绵绵，鲜花相伴">>);

get_mail(desc, 60449) -> ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。万圣节活动期间，您成功播种【南瓜种子】，获得了【杰克药水】*1，【杰克药水】可在洛水城石化女巫处兑换【万圣糖果】哦！">>);
get_mail(desc, 60501) -> ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。圣诞活动期间，您成功种下一棵漂亮的圣诞树，获得了【圣诞雪球】*1额外奖励哦！">>);
get_mail(desc, 60502) -> ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。圣诞活动期间，您成功堆好了一个可爱的雪人，获得了【雪人变身卡】*1额外奖励哦！">>);
get_mail(desc, 60406) -> ?L(<<"亲爱的玩家，您种的花收获了">>);
get_mail(desc, 60517) -> ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。活动期间，您成功播种鲜花，获得了以下额外奖励，请留意查收！祝您游戏愉快！">>);

get_mail(item, 60449) -> [{33139, 1, 1}];
get_mail(item, 60501) -> [{33176, 1, 1}];
get_mail(item, 60502) -> [{21844, 1, 1}];
get_mail(item, 60406) -> [{33032, 1, 3}];
get_mail(item, 60517) -> [{29495, 1, 1}].

%% 改变鲜花的状态
flower_grow_up(36031, FlowerId, Status) ->
    center:cast(?MODULE, center_flower_grow_up, [36031, FlowerId, Status]);
flower_grow_up(MapId, FlowerId, Status) ->
    case map_mgr:info(MapId) of
        false ->
            ok;
        {ok, #map{pid = MapPid}} ->
            map:elem_change(MapPid, FlowerId, Status)
    end.
%% 这个方法主要扔在中央服运行
center_flower_grow_up(MapId, FlowerId, Status) ->
    case map_mgr:info(MapId) of
        false ->
            ok;
        {ok, #map{pid = MapPid}} ->
            map:elem_change(MapPid, FlowerId, Status)
    end.

%% 创建一个花种
%% 跨服种花
seed_flower(#plant{pos = {36031, X, Y}, elem_id = ElemId, elem_base_id = ElemBaseId}, PlantFlower, Oname, Aname) ->
    center:cast(map, elem_enter, [36031, PlantFlower#map_elem{id = ElemId, x = X, y = Y, status = ?plant_seed_elem, name = util:fbin(get_plant_name(ElemBaseId), [Oname, Aname])}]);
seed_flower(#plant{pos = {MapId, X, Y}, elem_id = ElemId, elem_base_id = ElemBaseId}, PlantFlower, Oname, Aname) ->
    map:elem_enter(MapId, PlantFlower#map_elem{id = ElemId, x = X, y = Y, status = ?plant_seed_elem, name = util:fbin(get_plant_name(ElemBaseId), [Oname, Aname])}).

%% 移除花
clear_flower(#plant{pos = {MapId, _X, _Y}, owner_rid = {Orid, Osrvid}, assist_rid = {Arid, Asrvid}, elem_id = ElemId, elem_base_id = ElemBaseId}) ->
    case MapId of
        36031 ->
            center:cast(map, elem_leave, [MapId, ElemId]);
        _ ->
            map:elem_leave(MapId, ElemId)
    end,
    case global:whereis_name({role, Orid, Osrvid}) of
        OPid when is_pid(OPid) ->       %% 通知主人花死了
            notice:inform(OPid, get_lang(12, own, ElemBaseId)),
            role:pack_send(OPid, 10931, {58, get_lang(13, own, ElemBaseId), []});
        _ ->
            ok
    end,
    case global:whereis_name({role, Arid, Asrvid}) of
        APid when is_pid(APid) ->       %% 通知助手花死了
            notice:inform(APid, get_lang(12, other, ElemBaseId)),
            role:pack_send(APid, 10931, {58, get_lang(13, other, ElemBaseId), []});
        _ ->
            ok
    end.

%% 清除所有花
clear_all_plant([]) -> [];
clear_all_plant([#plant{pos = {MapId, _X, _Y}, elem_id = ElemId} | T]) ->
    case MapId of
        36031 ->
            center:cast(map, elem_leave, [MapId, ElemId]);
        _ ->
            map:elem_leave(MapId, ElemId)
    end,
    clear_all_plant(T).


%% 检测花状态
flower_check(Flowers) ->
    flower_check(Flowers, []).
flower_check([], NewFlowers) ->
    NewFlowers;
flower_check([Flower = #plant{status = ?plant_tree_elem} | Flowers], NewFlowers) ->
    flower_check(Flowers, [Flower | NewFlowers]);
flower_check([Flower = #plant{timestamp = Time} | Flowers], NewFlowers) ->
    case (util:unixtime() - Time) > (?plant_wait_time + 5) of  %% 预留五秒的浮动差值
        true ->
            clear_flower(Flower),
            flower_check(Flowers, NewFlowers);
        false ->
            flower_check(Flowers, [Flower | NewFlowers])
    end.
            
%% 
inform_process({Rid, Srvid}, FlowerId, BaseId, Status) ->
    case global:whereis_name({role, Rid, Srvid}) of
        Pid when is_pid(Pid) ->
            role:pack_send(Pid, 15805, {FlowerId, Status, BaseId});
        _ ->
            ok
    end.

%%
inform_hint({Rid, Srvid}, Msg) ->
    case global:whereis_name({role, Rid, Srvid}) of
        Pid when is_pid(Pid) ->
            role:pack_send(Pid, 10931, {55, Msg, []});
        _ ->
            ok
    end.

%% 鲜花种植成功
inform_success({Rid, Srvid}, {AstRid, AstSrvId}, ElemBaseId) ->
    case lists:member(ElemBaseId, [60449, 60501, 60502, 60517]) of
        true ->
            Content = get_mail(content, ElemBaseId),
            Desc = get_mail(desc, ElemBaseId),
            Items = get_mail(item, ElemBaseId),
            mail_mgr:deliver({Rid, Srvid}, {Content, Desc, [], Items});
        false -> skip
    end,
    case global:whereis_name({role, Rid, Srvid}) of
        Pid when is_pid(Pid) ->
            role:apply(async, Pid, {?MODULE, flower_gain, [ElemBaseId]});
        _ ->
            ok
    end,
    case global:whereis_name({role, AstRid, AstSrvId}) of
        Pid2 when is_pid(Pid2) ->
            role:apply(async, Pid2, {?MODULE, flower_gain, [ElemBaseId]});
        _ ->
            ok
    end.

%% 鲜花种植获得奖励
flower_gain(Role = #role{lev = _Lev, link = #link{conn_pid = _ConnPid}}, 60449) ->
    GL = [
        #gain{label = coin_bind, val = 20000}
        ,#gain{label = exp, val = 20000}
    ],
    case role_gain:do(GL, Role) of
        {ok, NewRole} ->
            notice:inform(?L(<<"南瓜变南瓜灯\n获得 20000经验 20000绑定金币">>)),
            {ok, NewRole};
        _ -> {ok}
    end;
flower_gain(Role = #role{lev = _Lev, link = #link{conn_pid = _ConnPid}}, 60501) ->
    GL = [
        #gain{label = coin_bind, val = 20000}
        ,#gain{label = exp, val = 50000}
    ],
    case role_gain:do(GL, Role) of
        {ok, NewRole} ->
            notice:inform(?L(<<"种植圣诞树\n获得 50000经验 20000绑定金币">>)),
            {ok, NewRole};
        _ -> {ok}
    end;
flower_gain(Role = #role{lev = _Lev, link = #link{conn_pid = _ConnPid}}, 60502) ->
    GL = [
        #gain{label = coin_bind, val = 20000}
        ,#gain{label = exp, val = 50000}
    ],
    case role_gain:do(GL, Role) of
        {ok, NewRole} ->
            notice:inform(?L(<<"堆雪人\n获得 50000经验 20000绑定金币">>)),
            {ok, NewRole};
        _ -> {ok}
    end;
flower_gain(Role = #role{lev = _Lev, link = #link{conn_pid = _ConnPid}}, 60522) ->
    GL = [
        #gain{label = coin_bind, val = 20000}
        ,#gain{label = exp, val = 50000}
    ],
    case role_gain:do(GL, Role) of
        {ok, NewRole} ->
            notice:inform(?L(<<"种礼花\n获得 50000经验 20000绑定金币">>)),
            {ok, NewRole};
        _ -> {ok}
    end;

flower_gain(_, _) ->
    {ok}.

%% 检测种子时间有效性
is_valid_time(?item_seed3) ->
    true;
is_valid_time(_) ->
    case util:datetime_to_seconds(?plant_valid_date1) of
        false ->
            false;
        Time ->
            util:unixtime() < Time
    end.

%% 检测等级限制
is_valid_lev(#team{leader = #team_member{lev = LeaderLev}, member = [#team_member{lev = MemberLev}]}) ->
    case LeaderLev >= ?plant_lev_limit of
        true -> MemberLev >= ?plant_lev_limit;
        false -> false
    end.

%% 获取下一个女巫buff
get_next_witch_buff(intensify_luck) -> mount_luck;
get_next_witch_buff(_) -> wing_luck.

%% 给在线玩家添加女巫活动BUFF
add_buff_online_all(mail_reward) ->
    case role_api:lookup_all_online(by_pid) of
        {error, Reason} -> ?ERR("查询ets_online_role出错:~w", [Reason]);
        {ok, L} -> 
            lists:foreach(
                fun([Pid])->
                        role:apply(async, Pid, {campaign_plant, send_mail_130, []});
                    (_Any) ->
                        skip
                end, L)
    end;

add_buff_online_all(BuffLabel) ->
    case role_api:lookup_all_online(by_pid) of
        {error, Reason} -> ?ERR("查询ets_online_role出错:~w", [Reason]);
        {ok, L} -> 
            Now = util:unixtime(),
            lists:foreach(
                fun([Pid])->
                        role:apply(async, Pid, {campaign_plant, add_buff, [BuffLabel, Now + 3 * 3600]});
                    (_) ->
                        skip
                end, L)
    end.

%% 发奖励
send_mail_130(Role = #role{lev = Lev}) when Lev >= 40 ->
    mail_mgr:deliver(Role, {?L(<<"解救璃儿，兑换吉祥">>), ?L(<<"亲爱的玩家，春节活动期间，您所在的服务器找回了全部的金匾字样，因此您获得了以下额外奖励！\n感谢您在过去的一年中对梦幻飞仙的鼎力支持，梦幻飞仙祝您在新的一年里大吉大利，战力快涨！">>), [], [{29490, 1, 1}]}),
    {ok};
send_mail_130(_Role) ->
    {ok}.


%% 添加女巫活动BUFF
add_buff(Role, BuffLabel, EndTime) ->
    case buff_data:get(BuffLabel) of
        {ok, Buff} ->
            case buff:add(Role, Buff#buff{type = 2, endtime = EndTime, duration = EndTime - util:unixtime()}) of
                {false, _Msg} -> {ok};
                {ok, NewRole} ->
                    {ok, role_api:push_attr(NewRole)}
            end;
        _Err ->
            ?ERR("添加角色Buff数据失败:~w",[_Err]),
            {ok}
    end.

%% 是否女巫活动时间
is_witch_time() ->
    Begin = util:datetime_to_seconds(?witch_start_time),
    End = util:datetime_to_seconds(?witch_end_time),
    Now = util:unixtime(),
    Now > Begin andalso Now < End.

%% 检测性别限制（男女组队）
is_valid_sex(#team{leader = #team_member{sex = 0}, member = [#team_member{sex = 0}]}) -> girls;
is_valid_sex(#team{leader = #team_member{sex = 1}, member = [#team_member{sex = 1}]}) -> boys;
is_valid_sex(_) -> true.
