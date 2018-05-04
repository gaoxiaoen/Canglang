%%----------------------------------------------------
%% 仙境寻宝--开宝箱
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(super_boss_casino).
-behaviour(gen_server).
-export([
        apply/2
        ,start_link/0
        ,get_all_lucky_world/0
        ,update_lucky_world/2
        ,get_all_lucky_my/1
        ,update_lucky_my/2
        ,update_role_all_items/3
        ,get_role_all_items/2
        ,update_role_last_items/2
        ,update_role_last_time/1
        ,get_role_last_time/1
        ,get_role_last_items/1
        ,init_role_items/2
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {
        glo_do = []       %% 全局揭开变化情况 [#super_boss_casino_open{}...]
        ,logs = []        %% 揭开日志 #super_boss_casino_log{}
    }).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("casino.hrl").
%%
-include("gain.hrl").
-include("guild.hrl").

-define(TIME_TICK, 86000000).  %% 清除数据执行时间

apply(async, Args) ->
    gen_server:cast(?MODULE, Args);
apply(sync, {open, N, Role}) ->
    Loss = case N of
        1 -> [#loss{label = item, val = [33071, 0, 1]}];
        10 -> [#loss{label = item, val = [33071, 0, 10]}];
        _ -> [#loss{label = item, val = [33071, 0, 50]}]
    end,
    case role_gain:do(Loss, Role) of
        {false, _} -> %% 物品不足 失败返回
            {false, ?L(<<"龙血精魂不足，无法进行探宝，参加远古巨龙活动可获得龙血精魂">>)};
        {ok, NRole} ->
            gen_server:call(?MODULE, {open, N, NRole})
    end;
apply(sync, Args) ->
    gen_server:call(?MODULE, Args).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 查询ets表 好运榜
%% lookup(Type) -> #rank{}
get_all_lucky_world() ->
    Data = ets:tab2list(super_boss_store_rank_world),
    format(Data,[]).
get_all_lucky_my(Role_Name) ->
    case ets:select(super_boss_store_rank_my,ets:fun2ms(fun({_Key,Name,Item_Name}) when Name =:= Role_Name -> {_Key,Name,Item_Name} end)) of
        [] ->
            [];
        Data ->
            format(Data,[])
    end.
format([],L) -> L;
format([{_Key,Role_Name,Item_Name}|T],L) ->
    format(T,[{Role_Name,Item_Name}|L]).

%% 更新ets表 好运榜
%% update_ets(State) -> ok
update_lucky_world(Role_Name,Item_Name) ->
    Datas = get_all_lucky_world(),
    case erlang:length(Datas) >= 10 of 
        true -> 
            Key = ets:first(super_boss_store_rank_world),
            ets:delete(super_boss_store_rank_world,Key),
            ets:insert(super_boss_store_rank_world, {util:unixtime(),Role_Name,Item_Name});
        false ->
            ets:insert(super_boss_store_rank_world, {util:unixtime(),Role_Name,Item_Name})
    end.

update_lucky_my(Role_Name,Item_Name) ->
    Datas = get_all_lucky_my(Role_Name),
    case erlang:length(Datas) >= 5 of 
        true -> 
            % ?DEBUG("*super_boss_store*true**update_ets**:~w~n",["^_^"]),
            Key = lists:nth(1,get_all_lucky_my(Role_Name)),
            ets:delete(super_boss_store_rank_my,Key),
            ets:insert(super_boss_store_rank_my, {util:unixtime(),Role_Name,Item_Name});
        false ->
            % ?DEBUG("*super_boss_store*false*update_ets**:~w~s~s~n",[util:unixtime(),Role_Name,Item_Name]),

            ets:insert(super_boss_store_rank_my, {util:unixtime(),Role_Name,Item_Name})
    end.


%%更新角色在地下集市全部物品的数据    
update_role_all_items(RoleId, Type, Items) ->
    Ets = get_ets_by_type(Type),
    ets:delete(Ets, RoleId),
    ets:insert(Ets, {RoleId, Items}).
%%获取角色在地下集市全部物品的数据 
get_role_all_items(RoleId, Type) ->
    Ets = get_ets_by_type(Type),
    NItems = case ets:lookup(Ets, RoleId) of 
                [] ->
                    [];
                [{_,Items}] ->
                    {Items}
            end,
    case NItems of 
        [] -> [];
        _ ->
            [Items2] = tuple_to_list(NItems),
            format_to_record_list(Items2,[])
    end.

get_ets_by_type(Type) ->
    case Type of 
        1 -> super_boss_store_role_items1;
        2 -> super_boss_store_role_items2
    end.

get_role_last_time(RoleId) ->
    case ets:lookup(super_boss_store_last_time, RoleId) of 
        [] ->
            0;
        [{_,LastTime}] ->
            LastTime
    end.

%%更新最后地下集市最后交易的结果
update_role_last_items(RoleId, Items) ->

    case Items of
        [] ->
            ets:delete(super_boss_store_role_lastitems,RoleId),
            ets:insert(super_boss_store_role_lastitems,{RoleId,Items});
        _ ->
            ?DEBUG("-----------------~w~n",[RoleId]),
            Data = case ets:lookup(super_boss_store_role_lastitems,RoleId) of
                    [] -> [];
                    [{_,D}] -> D
                end,
            % ?DEBUG("-update_role_last_items--Data-:~w~n",[Data]),
            % ?DEBUG("-update_role_last_items--Items-:~w~n",[Items]),
            % ?DEBUG("-update_role_last_items--NNItems-:~w~n",[Items++Data]),
            ets:delete(super_boss_store_role_lastitems,RoleId),
            ets:insert(super_boss_store_role_lastitems,{RoleId,Items++Data})
    end,
    update_role_last_time(RoleId).

update_role_last_time(RoleId) ->
    ets:delete(super_boss_store_last_time, RoleId),
    ets:insert(super_boss_store_last_time, {RoleId, util:unixtime()}).

%%获取角色在地下集市上次交易的数据 
get_role_last_items(RoleId) ->
    case ets:lookup(super_boss_store_role_lastitems, RoleId) of 
        [] ->
            [];
        [{_,Items}] ->
            Items
    end.
 
init_role_items(RoleId, Type) ->
    Items = super_boss_store_item:get_all_item(Type), %%返回物品id与物品权重的列表
    update_role_all_items(RoleId, Type, Items). %%插入到ets表中

format_to_record_list([],L) -> L;
format_to_record_list([{_,ItemId,Weight,Weight_temp,Times_max,Times_max_undisplay,Times_limit_display,Times_limit,Times_terminate,Count,Notice}|T],L) ->
    format_to_record_list(T,[#casino_base_item{item_id = ItemId,weight = Weight,weight_temp = Weight_temp,times_max = Times_max,
                                                    times_max_undisplay = Times_max_undisplay,times_limit_display = Times_limit_display,
                                                    times_limit = Times_limit,times_terminate = Times_terminate,count = Count,is_notice = Notice}|L]).


init([]) ->
    ?INFO("正在启动..."),
    % Logs = casino_dao:get_super_boss_casino_logs(),
    % GloL = casino_dao:get_super_boss_casino(global),
    % {_, NewGloL} = reset_must_out_item(?casino_limit_type_global, GloL, role),
    % State = #state{glo_do = NewGloL, logs = Logs},
    % erlang:send_after(?TIME_TICK, self(), tick),
    ets:new(super_boss_store_rank_world,[public,ordered_set, named_table,{keypos, 1}]),
    ets:new(super_boss_store_rank_my,[public,ordered_set, named_table,{keypos, 2}]),

    ets:new(super_boss_store_role_items1, [public, set, named_table]), %% 赤焰矿洞
    ets:new(super_boss_store_role_items2, [public, set, named_table]), %%　星河矿洞

    ets:new(super_boss_store_role_lastitems, [public, set, named_table,{keypos, 1}]),
    ets:new(super_boss_store_last_time, [public, set, named_table,{keypos, 1}]),
    process_flag(trap_exit, true),
    ?INFO("启动完成..."),
    {ok, #state{}}.

%% 获取日志数据
handle_call(logs, _From, State = #state{logs = Logs}) ->
    {reply, Logs, State};
%% 揭开一次封印 {false, Reason} | {ok, NewRole, [{BaseId, Bind, Num}...]}
handle_call({open, N, Role = #role{super_boss_store = Store}}, _From, State = #state{logs = Logs}) ->
    {NewRoleL, OutBaseItems, NewState} = open(N, Role, State),
    SortOutBaseItems = lists:keysort(#super_boss_casino_base.sort, OutBaseItems),
    TotalItems = total_items(SortOutBaseItems, []),
    TotalItemsInfo = [{BaseId, Bind, Num} || #super_boss_casino_base{base_id = BaseId, bind = Bind, num = Num} <- TotalItems],
    case make_items(TotalItems, []) of
        {false, Reason} -> %% 存在不可生成物品 失败返回
            {reply, {false, Reason}, State};
        GetItems ->
            case storage:add_no_refresh(Store, GetItems) of
                {ok, NewStore, _AddItems} ->
                    AddLogs = add_log(Role, SortOutBaseItems, [], N),
                    casino_dao:save_super_boss_casino(Role#role.id, NewRoleL),
                    NewLogs = lists:sublist(AddLogs ++ Logs, 20),
                    %% GL = [#gain{label = item, val = [BaseId, Bind, Num]} || {BaseId, Bind, Num} <- TotalItems],
                    %% Inform = notice_inform:gain_loss(GL, ?lang_super_boss_casino_inform),
                    %% notice:inform(Role#role.pid, Inform),
                    case [BaseItem || BaseItem <- TotalItems, BaseItem#super_boss_casino_base.is_notice =:= 1] of
                        [] -> ok;
                        NoticeBaseItems ->
                            {ok, TmpItems} = item:make(33071, 0, 1),
                            NoticeItems = make_items(NoticeBaseItems, []),
                            GetItemMsg = notice:item_to_msg(NoticeItems),
                            RoleMsg = notice:role_to_msg(Role),
                            TmpItemsMsg = notice:item_to_msg(TmpItems),
                            Msg = util:fbin(?L(<<"~s在与巨龙激战后获得了~s，利用~s引路，在{open,24,盘龙窟探宝,#ffe500}获得~s">>), [RoleMsg, TmpItemsMsg, TmpItemsMsg, GetItemMsg]),
                            notice:send(62, Msg)
                    end,
                    {reply, {ok, Role#role{super_boss_store = NewStore}, TotalItemsInfo}, NewState#state{logs = NewLogs}};
                _ -> %% 仓库已满 失败返回
                    {reply, {false, ?L(<<"仓库空间不足">>)}, State}
            end
    end;

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(tick, State = #state{logs = Logs}) ->
    ?INFO("开始执行过时日志清除"),
    casino_dao:del_super_boss_casino_log(Logs),
    erlang:send_after(?TIME_TICK, self(), tick),
    ?INFO("结束执行过时日志清除"),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State = #state{glo_do = Glo}) ->
    casino_dao:save_super_boss_casino(global, Glo),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%---------------------------------------------------------------
%% 内部方法
%%---------------------------------------------------------------

%% 生成物品数据 [#item{}...]
make_items([], Items) -> Items;
make_items([#super_boss_casino_base{base_id = BaseId, bind = Bind, num = Num} | T], Items) ->
    case item:make(BaseId, Bind, Num) of
        false -> 
            {false, ?L(<<"未知物品不能产生">>)};
        {ok, Item} ->
            make_items(T, Items ++ Item)
    end. 

%% 对物殊物品产出作日志记录
add_log(_Role, [], [], _N) -> [];
add_log(Role, [], NLogs, N) -> 
    casino_dao:add_super_boss_casino_log(N, NLogs),
    case [Log || Log <- NLogs, Log#super_boss_casino_log.is_notice =:= 1] of
        [] -> [];
        NewLogs ->
            push_info(NewLogs, Role),
            NewLogs
    end;
add_log(Role = #role{id = {Rid, SrvId}, name = Name}, [#super_boss_casino_base{base_id = BaseId, is_notice = IsNotice, bind = Bind, num = Num} | T], NewLogs, N) -> %% 该物品需要公告日志
    Log = #super_boss_casino_log{
        rid = Rid, srv_id = SrvId, name = Name
        ,base_id = BaseId, bind = Bind, num = Num
        ,get_time = util:unixtime(), is_notice = IsNotice
    },
    add_log(Role, T, [Log | NewLogs], N);
add_log(Role, [_ | T], NewLogs, N) ->
    add_log(Role, T, NewLogs, N).

%% 查找各物品出现次数 [{BaseId, Bind, Num}...]
total_items([], L) -> L;
total_items([I = #super_boss_casino_base{base_id = BaseId, bind = Bind, num = N} | T], L) ->
    L0 = [Data || Data <- T, Data#super_boss_casino_base.base_id =:= BaseId, Data#super_boss_casino_base.bind =:= Bind],
    L1 = [Data || Data <- T, Data#super_boss_casino_base.base_id =/= BaseId orelse Data#super_boss_casino_base.bind =/= Bind],
    Num = N + N * length(L0),
    total_items(L1, [I#super_boss_casino_base{num = Num} | L]).

%% 揭开物品N次
open(N, Role, State = #state{glo_do = GloL}) ->
    RoleL = casino_dao:get_super_boss_casino(Role#role.id), %% 获取角色相关揭开类型的私有数据
    {BaseItems, NewRoleL} = reset_must_out_item(?casino_limit_type_role, RoleL, Role),
    DefaultBaseItems = base_item_list(default, 0, Role),
    {NewGloL, NewRL, OutBaseItems} = do_open(N, DefaultBaseItems, BaseItems, GloL, NewRoleL, []),
    {NewRL, OutBaseItems, State#state{glo_do = NewGloL}}.

%% 执行N次揭开操作
do_open(0, _DefaultBaseItems, _BaseItems, GloL, RoleL, OutBaseItems) ->
    {GloL, RoleL, OutBaseItems};
do_open(N, DefaultBaseItems, BaseItems, GloL, RoleL, OutBaseItems) ->
    Now = util:unixtime(),
    OutBaseItem = open_item(Now, DefaultBaseItems, BaseItems, GloL ++ RoleL),
    NewGloL = update_open(false, ?casino_limit_type_global, Now, OutBaseItem, GloL, []),
    NewRoleL = update_open(false, ?casino_limit_type_role, Now, OutBaseItem, RoleL, []),
    do_open(N - 1, DefaultBaseItems, BaseItems, NewGloL, NewRoleL, [OutBaseItem | OutBaseItems]).

%% 揭开一次物品
open_item(Now, DefaultBaseItems, BaseItems, OpenL) ->
    case [BaseItem || BaseItem <- BaseItems, check_item(must_out, OpenL, BaseItem)] of
        [] -> %% 不存在必出物品 从所有物品随机抽取
            RandBaseItem = rand_item(BaseItems),
            case check_item(Now, OpenL, RandBaseItem) of
                false -> %% 受限状态 从默认物品随机抽取一个
                    rand_item(DefaultBaseItems);
                true -> %% 非受限状态 直接出现此物品
                    RandBaseItem
            end;
        MustBaseItems -> %% 存在必出物品 直接从必出物品中抽取其中之一
            rand_item(MustBaseItems)
    end.

%% 随机从列表中抽取一个物品
rand_item([H | []]) -> %% 列表只有一个物品 直接出现
    H;
rand_item(L) ->
    RL = [Rand || #super_boss_casino_base{rand = Rand} <- L],
    Max = lists:sum(RL),
    Val = util:rand(1, Max),
    rand_item(Val, L).
rand_item(_Val, [H | []]) -> H;
rand_item(Val, [H = #super_boss_casino_base{rand = Rand} | _T]) when Val =< Rand ->
    H;
rand_item(Val, [#super_boss_casino_base{rand = Rand} | T]) ->
    rand_item(Val - Rand, T).

%% 判断物品是否可出现
check_item(must_out, L, #super_boss_casino_base{base_id = BaseId, must_out = MO}) -> %% 判断此物品此次揭开是否可以必出
    case lists:keyfind(BaseId, #super_boss_casino_open.base_id, L) of
        #super_boss_casino_open{open_num = ON} when MO =/= 0 andalso ON >= MO -> %% 落入必出范围
            true;
        _ -> %% 非必出物品
            false
    end;
check_item(Now, L, #super_boss_casino_base{base_id = BaseId, limit_time = {_T, Y}, limit_num = {N, X}, must_out = MO}) ->
    case lists:keyfind(BaseId, #super_boss_casino_open.base_id, L) of
        #super_boss_casino_open{open_num = ON} when MO =/= 0 andalso ON >= MO -> %% 落入必出范围
            true;
        #super_boss_casino_open{limit_time = {LT, TN}} when Y =/= 0 andalso Now =< LT andalso TN >= Y -> %% 限制时间范围内不能出现
            %% ?DEBUG("时间限制a1"),
            false;
        #super_boss_casino_open{limit_num = {LN, RN}} when X =/= 0 andalso LN >= N andalso RN =< X -> %% 限制次数范围内不能出现
            %% ?DEBUG("次数限制a2"),
            false;
        _ -> %% 本次可出现
            true
    end.

%% @spec reset_must_out_item(Mod, Type, L) -> {BaseItems, NewL}
%% Mod = integer()  限制类型 1:个人 2:全服
%% Type = integer() 揭开类型 1:封印类型一
%% L = NewL = list() 揭开记录信息列表 [#casino_open{}...]
%% BaseItems = list() 基础物品列表 [#casino_base_data{}...]
%% 重新更新必出的数据项
reset_must_out_item(Mod, OldL, Role) ->
    BaseItems = base_item_list(normal, 1, Role),
    NewL = [I || I <- OldL, lists:keyfind(I#super_boss_casino_open.base_id, #super_boss_casino_base.base_id, BaseItems) =/= false], %% 清除掉已删除物品数据
    {BaseItems, do_reset_must_out_item(Mod, BaseItems, NewL)}.
do_reset_must_out_item(_Mod, [], L) -> L;
do_reset_must_out_item(Mod, [#super_boss_casino_base{base_id = BaseId, limit_type = LType, must_out = MO} | T], L) -> %% 限制类型相同存在必出情况
    case lists:keyfind(BaseId, #super_boss_casino_open.base_id, L) of
        false when Mod =:= LType andalso MO > 0 -> %% 限制类型一致、存在必出可能性且还没初始化
            NewI = #super_boss_casino_open{base_id = BaseId},
            do_reset_must_out_item(Mod, T, [NewI | L]);
        #super_boss_casino_open{} when Mod =/= LType -> %% 限制类型不一致但存在 需删除防止数据累积
            NewL = lists:keydelete(BaseId, #super_boss_casino_open.base_id, L),
            do_reset_must_out_item(Mod, T, NewL);
        _ -> %% 已初始化过
            do_reset_must_out_item(Mod, T, L)
    end.

%% @spec base_item_list(Mod, Type) -> BaseItems;
%% Mod = default | normal  默认物品 正常随机物品
%% Type = integer()  类型: 0:默认物品 1:封印类型1物品
%% BaseItems = list()  基础物品列表 [#casino_base_data{}...]
%% 获取某类型的基础数据信息列表
base_item_list(Mod, Type, Role) ->
    BaseIds = super_boss_data_casino:list(Type),
    base_item_list(Mod, BaseIds, [], Role).
base_item_list(_Mod, [], BaseItems, _Role) -> BaseItems;
base_item_list(Mod, [BaseId | T], BaseItems, Role) ->
    case get_item(Mod, BaseId) of
        {ok, BaseItem} ->
            base_item_list(Mod, T, [BaseItem | BaseItems], Role);
        _ ->
            base_item_list(Mod, T, BaseItems, Role)
    end.

%% 更新揭开数据信息
update_open(false, Mod, Now, #super_boss_casino_base{is_default = 0, limit_type = Mod, base_id = BaseId, limit_time = {T, _}}, [], NewOpenL) -> %% 列表中不存在记录信息
    [#super_boss_casino_open{base_id = BaseId, limit_time = {Now + T, 1}, limit_num = {1, 0}} | NewOpenL];
update_open(_Find, _Mod, _Now, _BaseItem, [], NewOpenL) ->  %% 列表中存在记录信息
    NewOpenL;
update_open(Find, Mod, Now, BaseItem, [H | T], NewOpenL) -> 
    #super_boss_casino_base{base_id = BaseId1} = BaseItem,
    #super_boss_casino_open{base_id = BaseId2, limit_time = {T2, TN2}, limit_num = {L2, LN2}, open_num = ON} = H,
    {NewFind, NewON, Add} = case BaseId1 =:= BaseId2 of
        false -> %% 不相同物品 揭开次数累加1 物品出现次数加0
            {Find, ON + 1, 0};
        true -> %% 相同物品 标志修改为已出现 揭开次数清0 物品出现次数加1
            {true, 0, 1}
    end,
    {{T1, TN1}, {L1, LN1}} = case get_item(normal, BaseId2) of %% 查找当前揭开状态物品的相关需求规律
        {ok, #super_boss_casino_base{limit_time = {T0, TN0}, limit_num = {L0, LN0}}} ->
            {{T0, TN0}, {L0, LN0}};
        _ ->
            {{0, 0}, {0, 0}}
    end, 
    debug(BaseItem, H),
    H1 = case T2 < Now andalso TN1 =/= 0 of %% 更新时间限制条件
        true -> %% 时间限制过期 需重新初始化
            H#super_boss_casino_open{limit_time = {Now + T1, Add}};
        false -> %% 其它情况
            H#super_boss_casino_open{limit_time = {T2, TN2 + Add}}
    end,
    H2 = case L2 >= L1 andalso LN1 =/= 0 of %% 更新次数限制条件
        true when LN2 >= LN1 -> %% 次数限制过期 需重新初始化
            H1#super_boss_casino_open{limit_num = {Add, 0}};
        true -> %% 在受限范围
            H1#super_boss_casino_open{limit_num = {L2, LN2 + 1}};
        _ ->
            H1#super_boss_casino_open{limit_num = {L2 + Add, LN2}}
    end,
    NewH = H2#super_boss_casino_open{open_num = NewON},
    debug(BaseItem, NewH),
    update_open(NewFind, Mod, Now, BaseItem, T, [NewH | NewOpenL]).

%% 调试揭开物品规律变化数据
debug(_BaseItem, _Open = #super_boss_casino_open{base_id = id}) ->
    ?DEBUG("base_item:~w ~nopen:~w", [_BaseItem, _Open]);
debug(_, _) -> ok.

%% 推送新日志
push_info([], _Role) -> ok;
push_info(NewLogs, #role{link = #link{conn_pid = ConnPid}}) ->
    %% ?DEBUG("---------------[~w]", [NewLogs]),
    sys_conn:pack_send(ConnPid, 14275, {NewLogs}).

%% 获取物品
get_item(Mod, BaseId) ->
    do_get_item(Mod, BaseId, 0).
do_get_item(Mod, BaseId, LuckVal = 0) ->
    super_boss_data_casino:get(Mod, BaseId, LuckVal);
do_get_item(Mod, BaseId, LuckVal) ->
    case super_boss_data_casino:get(Mod, BaseId, LuckVal) of
        {ok, BaseItem} ->
            {ok, BaseItem};
        _ ->
            super_boss_data_casino:get(Mod, BaseId, 0)
    end.
