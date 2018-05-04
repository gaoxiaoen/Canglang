%%----------------------------------------------------
%% 仙境寻宝--开宝箱
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(casino).
-behaviour(gen_server).
-export([
        apply/2
        ,start_link/0
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {
        glo_do = []       %% 全局揭开变化情况 [{Type, [#casino_open{}...]}...]
        ,logs = []        %% 揭开日志 [{Type, [#casino_log{}]}....]
    }).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("casino.hrl").
-include("gain.hrl").
-include("guild.hrl").
-include("storage.hrl").
-include("item.hrl").

-define(TIME_TICK, 86000000).  %% 清除数据执行时间

apply(async, Args) ->
    gen_server:cast(?MODULE, Args);
apply(sync, {open, Type, N, Role}) ->
    case check_open(Type) of
        {false, Reason} -> 
            {false, Reason};
        true ->
            case price(Role, Type, N) of %% 根据揭开类型和次数获取价格
                false -> %% 查找不到价格 失败返回
                    {false, ?L(<<"非法揭开类型">>)};
                {BindItemNum, Price, GL, Msg} ->
                    case role_gain:do(GL, Role) of
                        {false, _} -> %% 晶钻不足 失败返回
                            {gold, ?L(<<"晶钻不足">>)};
                        {ok, NRole} ->
                            notice:inform(Role#role.pid, notice_inform:gain_loss(GL, Msg)),
                            gen_server:call(?MODULE, {open, Type, N, BindItemNum, Price, NRole})
                    end
            end
    end;
apply(sync, Args) ->
    gen_server:call(?MODULE, Args).

%% 寻宝活动时间校验 天官赐福
check_open(?casino_type_three) ->
    Now = util:unixtime(),
    StartT = util:datetime_to_seconds({{2013, 2, 18}, {0, 0, 1}}),
    EndT = util:datetime_to_seconds({{2013, 2, 24}, {23, 59, 59}}),
    case Now >= StartT andalso Now < EndT of
        true -> true;
        false -> 
            case campaign_adm:is_camp_time(casino3) of
                true -> true;
                false ->
                    {false, ?L(<<"不在活动时间内，祈福无效">>)}
            end
    end;
check_open(?casino_type_four) ->
    Now = util:unixtime(),
    StartT = util:datetime_to_seconds({{2013, 4, 24}, {0, 0, 1}}),
    EndT = util:datetime_to_seconds({{2013, 4, 26}, {23, 59, 59}}),
    case Now >= StartT andalso Now < EndT of
        true -> true;
        false -> 
            case campaign_adm:is_camp_time(casino4) of
                true -> true;
                false -> {false, ?L(<<"不在活动时间内，祈福无效">>)}
            end
    end;
check_open(_Type) -> true.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("正在启动..."),
    Logs = casino_dao:select_logs(),
    GloL = casino_dao:select(global, all),
    GloL1 = [{Type, reset_must_out_item(all, ?casino_limit_type_global, Type, L)} || {Type, L} <- GloL],
    NewGloL = [{Type, L} || {Type, {_, L}} <- GloL1],
    State = #state{glo_do = NewGloL, logs = Logs},
    erlang:send_after(?TIME_TICK, self(), tick),
    process_flag(trap_exit, true),
    ?INFO("启动完成..."),
    {ok, State}.

%% 获取日志数据
handle_call(logs, _From, State = #state{logs = Logs}) ->
    {reply, Logs, State};

%% 测试揭开
handle_call({test, N}, _From, State) ->
    Reply = open(?casino_type_one, N, 0, #role{}, State),
    {reply, Reply, State};

%% 开封印状态
handle_call({state, Role}, _From, State) ->
    RoleL = casino_dao:select(Role#role.id, ?casino_type_one),
    {reply, {RoleL, State#state.glo_do}, State};

%% 揭开一次封印 {false, Reason} | {ok, NewRole, [{BaseId, Bind, Num}...]}
handle_call({open, Type, N, BindItemNum, Price, Role = #role{account = Account, id = {_Id, SrvId}, name = Name, casino = Casino, link = #link{conn_pid = ConnPid}}}, _From, State = #state{logs = AllLogs}) ->
    {NewRoleL, OutBaseItems, NewState} = open(Type, N, BindItemNum, Role, State),
    SortOutBaseItems = lists:keysort(#casino_base_data.sort, OutBaseItems),
    TotalItems = total_items(SortOutBaseItems, []),
    TotalItemsInfo = [{BaseId, Bind, Num} || #casino_base_data{base_id = BaseId, bind = Bind, num = Num} <- TotalItems],
    case make_items(TotalItems, []) of
        {false, Reason} -> %% 存在不可生成物品 失败返回
            {reply, {false, Reason}, State};
        GetItems ->
            case storage:add_no_refresh(Casino, GetItems) of
                {ok, NewCasino, _AddItems} ->
                    AddLogs = add_log(Role, SortOutBaseItems, [], {Type, N, Price}, NewRoleL),
                    {_, Logs} = lists:keyfind(Type, 1, AllLogs),
                    NewLogs = lists:sublist(AddLogs ++ Logs, ?casino_max_log_num),
                    NewAllLogs = lists:keyreplace(Type, 1, AllLogs, {Type, NewLogs}),
                    %% NewRole2 = role_listener:get_item(NRole, AddItems),
                    %% role_api:push_assets(Role),  %% 这里需要吗
                    case [BaseItem || BaseItem <- TotalItems, BaseItem#casino_base_data.is_notice =:= 1] of
                        [] -> ok;
                        NoticeBaseItems ->
                            NoticeItems = make_items(NoticeBaseItems, []),
                            NameList = notice:items_to_name(NoticeItems),
                            ItemMsg = notice:item_to_msg(NoticeItems),
                            RoleMsg = notice:role_to_msg(Role),
                            Msg = case Type of
                                ?casino_type_one -> util:fbin(?L(<<"~s仙缘泽厚,因缘际会之下在{open,6,龙宫仙境,#ffe500}内探险获得了~s。{open,6,我要探险,#00ff00}">>), [RoleMsg, ItemMsg]);
                                ?casino_type_two -> util:fbin(?L(<<"~s仙缘泽厚,因缘际会之下在{open,6,仙府秘境,#ffe500}内探险获得了~s。{open,6,我要探险,#00ff00}">>), [RoleMsg, ItemMsg]);
                                ?casino_type_three -> util:fbin(?L(<<"~s仙缘泽厚,因缘际会之下在{open,32,天官赐福,#ffe500}内探险获得了~s。{open,32,我要祈福,#00ff00}">>), [RoleMsg, ItemMsg]);
                                ?casino_type_four -> util:fbin(?L(<<"~s仙缘泽厚,因缘际会之下在{open,64,仙魂探宝,#ffe500}内探险获得了~s。{open,64,我要探宝,#00ff00}">>), [RoleMsg, ItemMsg])
                            end,
                            notice:send(62, Msg),
                            case Type of
                                ?casino_type_one ->
                                    notice:send_interface({connpid, ConnPid}, 1, Account, SrvId, Name, <<"">>, NameList);
                                ?casino_type_two ->
                                    notice:send_interface({connpid, ConnPid}, 2, Account, SrvId, Name, <<"">>, NameList);
                                _ ->
                                    ok
                            end
                            %% guild:sys_msg(right_unable, {Gid, Gsrvid}, Msg)            
                            %% guild:guild_chat({Gid, Gsrvid}, Msg)
                    end,
                    log:log(log_item_output, {TotalItemsInfo, <<"寻宝">>}),
                    {reply, {ok, Role#role{casino = NewCasino}, TotalItemsInfo}, NewState#state{logs = NewAllLogs}};
                _ -> %% 仓库已满 失败返回
                    {reply, {false, ?L(<<"仓库空间不足">>)}, State}
            end
    end;

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(tick, State) ->
    ?INFO("开始执行过时日志清除"),
    casino_dao:del_log(),
    erlang:send_after(?TIME_TICK, self(), tick),
    ?INFO("结束执行过时日志清除"),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State = #state{glo_do = Glo}) ->
    casino_dao:update(global, all, Glo),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%---------------------------------------------------------------
%% 内部方法
%%---------------------------------------------------------------

%% 对物殊物品产出作日志记录
add_log(_Role, [], [], _OpenInfo, _NewRoleL) -> [];
add_log(Role, [], NLogs, OpenInfo, NewRoleL) -> 
    casino_dao:add_log_open(Role, OpenInfo, NLogs, NewRoleL),
    case [Log || Log <- NLogs, Log#casino_log.is_notice =:= 1] of
        [] -> [];
        NewLogs = [#casino_log{type = Type} | _] ->
            push_info({Type, NewLogs}, Role), 
            NewLogs
    end;
add_log(Role = #role{id = {Rid, SrvId}, name = Name}, [#casino_base_data{num = Num, base_id = BaseId, type = Type, is_notice = IsNotice, bind = Bind} | T], NewLogs, OpenInfo, NewRoleL) -> %% 该物品需要公告日志
    Log = #casino_log{
        rid = Rid, srv_id = SrvId, name = Name
        ,base_id = BaseId, type = Type, bind = Bind
        ,get_time = util:unixtime(), is_notice = IsNotice
        ,num = Num
    },
    add_log(Role, T, [Log | NewLogs], OpenInfo, NewRoleL);
add_log(Role, [_ | T], NewLogs, OpenInfo, NewRoleL) ->
    add_log(Role, T, NewLogs, OpenInfo, NewRoleL).

%% 生成物品数据 [#item{}...]
make_items([], Items) -> Items;
make_items([#casino_base_data{base_id = BaseId, bind = Bind, num = Num} | T], Items) ->
    case item:make(BaseId, Bind, Num) of
        false -> 
            {false, ?L(<<"未知物品不能产生">>)};
        {ok, Item} ->
            make_items(T, Items ++ Item)
    end. 

%% 查找各物品出现次数 [{BaseId, Bind, Num}...]
total_items([], L) -> 
    L;
total_items([I = #casino_base_data{base_id = BaseId, bind = Bind, num = N} | T], L) ->
    L0 = [Data || Data <- T, Data#casino_base_data.base_id =:= BaseId, Data#casino_base_data.bind =:= Bind],
    L1 = [Data || Data <- T, Data#casino_base_data.base_id =/= BaseId orelse Data#casino_base_data.bind =/= Bind],
    Num = N + N * length(L0),
    total_items(L1, [I#casino_base_data{num = Num} | L]).

%% 揭开物品N次
open(Type, N, BindItemNum, Role, State = #state{glo_do = GloLs}) ->
    {NGloLs, {_, GloL}} = case lists:keyfind(Type, 1, GloLs) of
        {A, B} -> {GloLs, {A, B}};
        _ -> 
            L = reset_must_out_item(all, ?casino_limit_type_global, Type, []),
            {[{Type, L} | GloLs], {Type, L}}
    end, %% 获取相关揭开类型的全局数据[如大极封印]
    RoleL = casino_dao:select(Role#role.id, Type), %% 获取角色相关揭开类型的私有数据
    {BaseItems, NewRoleL} = reset_must_out_item(Role, ?casino_limit_type_role, Type, RoleL),
    %% ?DEBUG("==============[~w][~w]", [RoleL, NewRoleL]),
    DefaultBaseItems = base_item_list(default, Type, Role),
    {NewGloL, NewRL, OutBaseItems} = do_open(N, BindItemNum, Type, DefaultBaseItems, BaseItems, GloL, NewRoleL, []),
    NewGloLs = lists:keyreplace(Type, 1, NGloLs, {Type, NewGloL}),
    {NewRL, OutBaseItems, State#state{glo_do = NewGloLs}}.

%% 执行N次揭开操作
do_open(0, _BindItemNum, _Type, _DefaultBaseItems, _BaseItems, GloL, RoleL, OutBaseItems) ->
    {GloL, RoleL, OutBaseItems};
do_open(N, BindItemNum, Type, DefaultBaseItems, BaseItems, GloL, RoleL, OutBaseItems) ->
    Now = util:unixtime(),
    OutBaseItem = open_item(Now, DefaultBaseItems, BaseItems, GloL ++ RoleL),
    NewGloL = update_open(false, ?casino_limit_type_global, Type, Now, OutBaseItem, GloL, []),
    NewRoleL = update_open(false, ?casino_limit_type_role, Type, Now, OutBaseItem, RoleL, []),
    case BindItemNum > 0 of
        false -> do_open(N - 1, BindItemNum, Type, DefaultBaseItems, BaseItems, NewGloL, NewRoleL, [OutBaseItem | OutBaseItems]);
        true -> do_open(N - 1, BindItemNum - 1, Type, DefaultBaseItems, BaseItems, NewGloL, NewRoleL, [OutBaseItem#casino_base_data{bind = 1} | OutBaseItems])
    end.

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
    RL = [Rand || #casino_base_data{rand = Rand} <- L],
    Max = lists:sum(RL),
    Val = util:rand(1, Max),
    rand_item(Val, L).
rand_item(_Val, [H | []]) -> H;
rand_item(Val, [H = #casino_base_data{rand = Rand} | _T]) when Val =< Rand ->
    H;
rand_item(Val, [#casino_base_data{rand = Rand} | T]) ->
    rand_item(Val - Rand, T).

%% 判断物品是否可出现
check_item(must_out, L, #casino_base_data{base_id = BaseId, must_out = MO}) -> %% 判断此物品此次揭开是否可以必出
    case lists:keyfind(BaseId, #casino_open.base_id, L) of
        #casino_open{open_num = ON} when MO =/= 0 andalso ON >= MO -> %% 落入必出范围
            true;
        _ -> %% 非必出物品
            false
    end;
check_item(Now, L, #casino_base_data{base_id = BaseId, limit_time = {_T, Y}, limit_num = {N, X}, must_out = MO, can_out = CO}) ->
    case lists:keyfind(BaseId, #casino_open.base_id, L) of
        #casino_open{acc_open = AccOpen} when AccOpen < CO ->
            false;
        #casino_open{open_num = ON} when MO =/= 0 andalso ON >= MO -> %% 落入必出范围
            true;
        #casino_open{limit_time = {LT, TN}} when Y =/= 0 andalso Now =< LT andalso TN >= Y -> %% 限制时间范围内不能出现
            %% ?DEBUG("时间限制a1"),
            false;
        #casino_open{limit_num = {LN, RN}} when X =/= 0 andalso LN >= N andalso RN =< X -> %% 限制次数范围内不能出现
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
reset_must_out_item(Role, Mod, Type, OldL) when is_integer(Type) ->
    BaseItems = base_item_list(normal, Type, Role),
    NewL = [I || I <- OldL, lists:keyfind(I#casino_open.base_id, #casino_base_data.base_id, BaseItems) =/= false], %% 清除掉已删除物品数据
    {BaseItems, reset_must_out_item(Mod, BaseItems, NewL)}.
reset_must_out_item(_Mod, [], L) -> L;
reset_must_out_item(Mod, [#casino_base_data{base_id = BaseId, limit_type = LType, must_out = MO, can_out = CO} | T], L) -> %% 限制类型相同存在必出情况
    case lists:keyfind(BaseId, #casino_open.base_id, L) of
        false when Mod =:= LType andalso (MO > 0 orelse CO > 0) -> %% 限制类型一致、存在必出可能性且还没初始化
            NewI = #casino_open{base_id = BaseId},
            reset_must_out_item(Mod, T, [NewI | L]);
        #casino_open{} when Mod =/= LType -> %% 限制类型不一致但存在 需删除防止数据累积
            NewL = lists:keydelete(BaseId, #casino_open.base_id, L),
            reset_must_out_item(Mod, T, NewL);
        _ -> %% 已初始化过
            reset_must_out_item(Mod, T, L)
    end.

%% @spec base_item_list(Mod, Type) -> BaseItems;
%% Mod = default | normal  默认物品 正常随机物品
%% Type = integer()  类型: 0:默认物品 1:封印类型1物品
%% BaseItems = list()  基础物品列表 [#casino_base_data{}...]
%% 获取某类型的基础数据信息列表
base_item_list(Mod = default, Type, Role) ->
    BaseIds = casino_data:list(0),
    base_item_list(Mod, Type, BaseIds, [], Role);
base_item_list(Mod, Type, Role) ->
    BaseIds = casino_data:list(Type),
    base_item_list(Mod, Type, BaseIds, [], Role).
base_item_list(_Mod, _Type, [], BaseItems, _Role) -> BaseItems;
base_item_list(Mod, Type, [BaseId | T], BaseItems, Role = #role{sex = RoleSex, career = RoleCareer}) ->
    case get_item(Mod, Type, BaseId) of
        {ok, BaseItem = #casino_base_data{sex = NeedSex, career = NeedCareer}} when (RoleSex =:= NeedSex orelse NeedSex =:= -1) andalso (RoleCareer =:= NeedCareer orelse NeedCareer =:= -1) ->
            base_item_list(Mod, Type, T, [BaseItem | BaseItems], Role);
        _ ->
            base_item_list(Mod, Type, T, BaseItems, Role)
    end;
base_item_list(Mod, Type, [BaseId | T], BaseItems, Role) ->
    case get_item(Mod, Type, BaseId) of
        {ok, BaseItem} ->
            base_item_list(Mod, Type, T, [BaseItem | BaseItems], Role);
        _ ->
            base_item_list(Mod, Type, T, BaseItems, Role)
    end.

%% 更新揭开数据信息
update_open(false, Mod, Type, Now, #casino_base_data{is_default = 0, type = Type, limit_type = Mod, base_id = BaseId, limit_time = {T, _}}, [], NewOpenL) -> %% 列表中不存在记录信息
    [#casino_open{base_id = BaseId, limit_time = {Now + T, 1}, limit_num = {1, 0}} | NewOpenL];
update_open(_Find, _Mod, _Type, _Now, _BaseItem, [], NewOpenL) ->  %% 列表中存在记录信息
    NewOpenL;
update_open(Find, Mod, Type, Now, BaseItem, [H | T], NewOpenL) -> 
    #casino_base_data{base_id = BaseId1} = BaseItem,
    #casino_open{base_id = BaseId2, limit_time = {T2, TN2}, limit_num = {L2, LN2}, open_num = ON, acc_open = AccOpen} = H,
    {NewFind, NewON, Add} = case BaseId1 =:= BaseId2 of
        false -> %% 不相同物品 揭开次数累加1 物品出现次数加0
            {Find, ON + 1, 0};
        true -> %% 相同物品 标志修改为已出现 揭开次数清0 物品出现次数加1
            {true, 0, 1}
    end,
    {{T1, TN1}, {L1, LN1}} = case get_item(normal, Type, BaseId2) of %% 查找当前揭开状态物品的相关需求规律
        {ok, #casino_base_data{limit_time = {T0, TN0}, limit_num = {L0, LN0}}} ->
            {{T0, TN0}, {L0, LN0}};
        _ ->
            {{0, 0}, {0, 0}}
    end, 
    debug(BaseItem, H),
    H1 = case T2 < Now andalso TN1 =/= 0 of %% 更新时间限制条件
        true -> %% 时间限制过期 需重新初始化
            H#casino_open{limit_time = {Now + T1, Add}};
        false -> %% 其它情况
            H#casino_open{limit_time = {T2, TN2 + Add}}
    end,
    H2 = case L2 >= L1 andalso LN1 =/= 0 of %% 更新次数限制条件
        true when LN2 >= LN1 -> %% 次数限制过期 需重新初始化
            H1#casino_open{limit_num = {Add, 0}};
        true -> %% 在受限范围
            H1#casino_open{limit_num = {L2, LN2 + 1}};
        _ ->
            H1#casino_open{limit_num = {L2 + Add, LN2}}
    end,
    NewH = H2#casino_open{open_num = NewON, acc_open = AccOpen + 1},
    debug(BaseItem, NewH),
    update_open(NewFind, Mod, Type, Now, BaseItem, T, [NewH | NewOpenL]).

%% 调试揭开物品规律变化数据
debug(_BaseItem, _Open = #casino_open{base_id = close_23115}) ->
    ?DEBUG("base_item:~w ~nopen:~w", [_BaseItem, _Open]);
debug(_, _) -> ok.

%% 揭开价格定义
price(_Role, ?casino_type_one, N) when N =:= 1 orelse N =:= 10 orelse N =:= 50 -> 
    Gold = pay:price(?MODULE, casino_type_one, N),
    {0, Gold, [#loss{label = gold, val = Gold}], ?L(<<"龙宫仙境">>)};
price(_Role, ?casino_type_two, N) when N =:= 1 orelse N =:= 10 orelse N =:= 50 -> 
    Gold = pay:price(?MODULE, casino_type_two, N),
    {0, Gold, [#loss{label = gold, val = Gold}], ?L(<<"仙府秘境">>)};
price(Role, ?casino_type_three, N) when N =:= 1 orelse N =:= 10 orelse N =:= 50 -> 
    Gold = pay:price(?MODULE, casino_type_three, N),
    {BindNum, UbindNum, DelInfo} = calc_del_item_info(Role, 33160, N),
    ItemNum = BindNum + UbindNum,
    if
        ItemNum =:= 0 -> {0, Gold, [#loss{label = gold, val = Gold}], ?L(<<"天官赐福">>)};
        ItemNum >= N -> {BindNum, 0, [#loss{label = item_id, val = DelInfo}], ?L(<<"天官赐福">>)};
        true ->
            NeedGold = Gold - round(ItemNum * Gold / N),
            {BindNum, NeedGold, [#loss{label = item_id, val = DelInfo}, #loss{label = gold, val = NeedGold}], ?L(<<"天官赐福">>)}
    end;
price(Role, ?casino_type_four, N) when N =:= 1 orelse N =:= 10 orelse N =:= 50 -> 
    Gold = pay:price(?MODULE, casino_type_four, N),
    {BindNum, UbindNum, DelInfo} = calc_del_item_info(Role, 33160, N),
    ItemNum = BindNum + UbindNum,
    if
        ItemNum =:= 0 -> {0, Gold, [#loss{label = gold, val = Gold}], ?L(<<"仙魂探宝">>)};
        ItemNum >= N -> {BindNum, 0, [#loss{label = item_id, val = DelInfo}], ?L(<<"仙魂探宝">>)};
        true ->
            NeedGold = Gold - round(ItemNum * Gold / N),
            {BindNum, NeedGold, [#loss{label = item_id, val = DelInfo}, #loss{label = gold, val = NeedGold}], ?L(<<"仙魂探宝">>)}
    end;
    %%Gold = pay:price(?MODULE, casino_type_four, N),
    %%{0, Gold, [#loss{label = gold, val = Gold}], ?L(<<"吉祥道场">>)};
price(_Role, _Type, _N) -> false.

%% 计算删除物品信息
calc_del_item_info(Role, BaseId, Num) ->
    case storage:find(Role#role.bag#bag.items, #item.base_id, BaseId) of
        {false, _R} -> {0, 0, []};
        {ok, _Num2, _, Bindlist, Ubindlist} -> calc_del_item_info(Num, Bindlist, Ubindlist, 0, 0, [])
    end.
calc_del_item_info(_Num, [], [], BindNum, UbindNum, DelInfo) ->
    {BindNum, UbindNum, DelInfo};
calc_del_item_info(0, _, _, BindNum, UbindNum, DelInfo) ->
    {BindNum, UbindNum, DelInfo};
calc_del_item_info(Num, [#item{id = Id, quantity = Q} | T], Ubindlist, BindNum, UbindNum, DelInfo) when Num > Q -> 
    calc_del_item_info(Num - Q, T, Ubindlist, BindNum + Q, UbindNum, [{Id, Q} | DelInfo]);
calc_del_item_info(Num, [#item{id = Id} | T], Ubindlist, BindNum, UbindNum, DelInfo) ->
    calc_del_item_info(0, T, Ubindlist, BindNum + Num, UbindNum, [{Id, Num} | DelInfo]);
calc_del_item_info(Num, [], [#item{id = Id, quantity = Q} | T], BindNum, UbindNum, DelInfo) when Num > Q -> 
    calc_del_item_info(Num - Q, [], T, BindNum, UbindNum + Q, [{Id, Q} | DelInfo]);
calc_del_item_info(Num, [], [#item{id = Id} | T], BindNum, UbindNum, DelInfo) ->
    calc_del_item_info(0, [], T, BindNum, UbindNum + Num, [{Id, Num} | DelInfo]).

%% 推送新日志
push_info({_Type, []}, _Role) -> ok;
push_info(LogInfo, #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 14210, LogInfo).

%% 获取物品配置数据
get_item(Mod, Type, BaseId) ->
    do_get_item(Mod, Type, BaseId, 0).
do_get_item(Mod, Type, BaseId, LuckVal = 0) ->
    casino_data:get(Mod, Type, BaseId, LuckVal);
do_get_item(Mod, Type, BaseId, LuckVal) ->
    case casino_data:get(Mod, Type, BaseId, LuckVal) of
        {ok, BaseItem} -> 
            {ok, BaseItem};
        _ ->
            casino_data:get(Mod, Type, BaseId, 0)
    end.

