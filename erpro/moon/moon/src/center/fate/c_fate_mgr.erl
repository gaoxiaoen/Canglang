%%----------------------------------------------------
%%  缘分摇一摇中央管理进程
%% 
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(c_fate_mgr).
-behaviour(gen_server).
-export([
        cast/1
        ,call/1
        ,lookup/1
        ,check_ta/2
        ,print/0
        ,print/1
        ,is_ta/2
        ,get_panel_info/1
        ,get_self_info/1
        ,history_list/1
        ,start_link/0
        ,role_login/4
        ,role_logout/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {}).
-include("common.hrl").
-include("fate.hrl").
-include("role.hrl").
-include("assets.hrl").
-include("attr.hrl").
-include("vip.hrl").

%% 获取面板信息
get_panel_info(FateBaseInfo = #fate_role_base_info{id = RoleId, power = FC, ip = IP, other_info = OtherInfo}) ->
    L = ets:tab2list(c_fate_role_online),
    case lookup(RoleId) of
        false -> %% 未开通 先判断 减少对进程访问
            cast({insert_role, FateBaseInfo});
        OldFateBaseInfo -> 
            NewFateBaseInfo = OldFateBaseInfo#fate_role_base_info{power = FC, ip = IP, other_info = OtherInfo},
            update_ets(not_dets, NewFateBaseInfo)
    end,
    {Province, City} = case lookup(RoleId) of
        #fate_role_base_info{province = Province1, city = City1} -> {Province1, City1};
        _ -> {<<>>, <<>>}
    end,
    {ok, length(L), Province, City}.

%% 角色上线处理
role_login(RoleId, FC, IP, OtherInfo) ->
    case lookup(RoleId) of
        false -> %% 未注册过
            ok;
        FateBaseInfo -> %% 已注册过
            NewFateBaseInfo = FateBaseInfo#fate_role_base_info{power = FC, ip = IP, other_info = OtherInfo},
            update_ets(not_dets, NewFateBaseInfo)
    end.

%% 角色下线
role_logout(RoleId) ->
    ets:delete(c_fate_role_online, RoleId).

%% 获取自己缘分签信息
get_self_info(RoleId) ->
    case lookup(RoleId) of
        #fate_role_base_info{name = Name, sex = Sex, age = Age, star = Star, msg = Msg, province = Province, city = City} -> {ok, Name, Sex, Age, Star, Msg, Province, City};
        _ -> false
    end.

%% 获取历史有缘人列表信息
history_list(RoleId) ->
    case lookup(RoleId) of
        #fate_role_base_info{fate_list = L} -> 
            {ok, to_client_list(L, [])};
        _ -> 
            {ok, []}
    end.
to_client_list([], L) ->
    term_to_binary([ok, L], [compressed]);
to_client_list([#fate_role{id = {Rid, SrvId}, name = Name, sex = Sex, age = Age, vip = Vip, hi = Hi, charm = Charm, career = Career, lev = Lev, face = Face, power = Power, province = Province, city = City, msg = Msg, looks = Looks, eqm = Eqm} | T], L) ->
    to_client_list(T, [{Rid, SrvId, Name, Sex, Age, Vip, Hi, Charm, Career, Lev, Face, Power, Province, City, Msg, Looks, Eqm} | L]).

%% 获取指定角色缘分签
lookup(RoleId) ->
    case catch ets:lookup(c_fate_role_base_info, RoleId) of
        [H] when is_record(H, fate_role_base_info) -> %% 已注册过
            H;
        _ -> %% 未注册过
            false
    end.

%% 检查角色双方是否为TA关系
check_ta(RoleId1, RoleId2) ->
    is_ta(RoleId1, RoleId2) orelse is_ta(RoleId2, RoleId1).
is_ta(RoleId1, RoleId2) ->
    case lookup(RoleId1) of
        #fate_role_base_info{fate_list = FateList} ->
            case lists:keyfind(RoleId2, #fate_role.id, FateList) of
                #fate_role{} -> true;
                _ -> false
            end;
        _ ->
            false
    end.

%% 对外接口
cast(Args) ->
    gen_server:cast(?MODULE, Args).

%% 对外接口
call(Args) ->
    gen_server:call(?MODULE, Args).

%% 打印日志信息
print() ->
    print(c_fate_role_online).
print(Label) when is_atom(Label) ->
    L = ets:tab2list(Label),
    print(L);
print([]) -> ok;
print([#fate_role_base_info{province = Province, city = City} | T]) ->
    SameL = [I || I <- T, I#fate_role_base_info.city =:= City, I#fate_role_base_info.province =:= Province],
    OtherL = [I1 || I1 <- T, (I1#fate_role_base_info.city =/= City orelse I1#fate_role_base_info.province =/= Province)],
    ?INFO("~s:~s----------->[~p]", [Province, City, length(SameL) + 1]),
    print(OtherL).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    ets:new(c_fate_role_online, [set, named_table, public, {keypos, #fate_role_base_info.id}]),
    ets:new(c_fate_role_base_info, [set, named_table, public, {keypos, #fate_role_base_info.id}]),
    dets:open_file(c_fate_role_base_info, [{file, "../var/c_fate_role_base_info.dets"}, {keypos, #fate_role_base_info.id}, {type, set}]),
    load_data(),
    State = #state{},
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

%% 修改角色缘分签信息
handle_cast({update_info, RoleId, RolePid, Name, Sex, Age, Star, Msg, Province, City}, State) ->
    case lookup(RoleId) of
        false -> 
            role:pack_send(RolePid, 17703, {Province, City, 0, ?L(<<"玩家当前没有开通缘分摇一摇">>)});
        FateBaseInfo ->
            NewFateBaseInfo = FateBaseInfo#fate_role_base_info{
                name = Name, sex = Sex, age = Age, star = Star, msg = Msg, province = Province, city = City
            },
            update_ets(all, NewFateBaseInfo),
            role:pack_send(RolePid, 17703, {Province, City, 1, ?L(<<"修改成功">>)})
    end,
    {noreply, State};

%% 开通缘分摇一摇
handle_cast({insert_role, FateBaseInfo = #fate_role_base_info{id = RoleId}}, State) ->
    case lookup(RoleId) of
        false -> %% 未注册过
            update_ets(all, FateBaseInfo);
        _OldFateBaseInfo -> %% 已开通
            ok
    end,
    {noreply, State};

%% 摇一摇过程
handle_cast({shake, RoleId, RolePid, FC, FriendIds, OtherInfo}, State) ->
    case lookup(RoleId) of
        false -> 
            role:pack_send(RolePid, 17704, {0, ?L(<<"玩家当前没有开通缘分摇一摇">>)});
        MyFate = #fate_role_base_info{fate_list = FateList} ->
            OnlineRoles = ets:tab2list(c_fate_role_online),
            NewMyFate = MyFate#fate_role_base_info{power = FC, other_info = OtherInfo},
            case lists:keydelete(RoleId, #fate_role_base_info.id, OnlineRoles) of
                [] -> 
                    role:pack_send(RolePid, 17704, {0, ?L(<<"当前没有其它玩家在线，匹配不到玩家">>)});
                L ->
                    print_info(start_do, "开始匹配"),
                    case match(NewMyFate#fate_role_base_info{name = FriendIds}, L) of
                        #fate_role_base_info{
                            id = OtherRoleId, name = Name, sex = Sex, age = Age, star = Star, province = Province, city = City, power = FC1, msg = Msg,
                            other_info = {VipType, Face, Charm, Career, Lev, Looks, Eqm}
                        } ->
                            print_info(end_do, "结束匹配"),
                            FateRole = #fate_role{
                                id = OtherRoleId, name = Name, sex = Sex, age = Age, vip = VipType
                                ,star = Star, career = Career, lev = Lev, looks = Looks, eqm = Eqm
                                ,power = FC1, charm = Charm, face = Face, city = City, province = Province
                                ,msg = Msg
                            },
                            NewFateList0 = lists:keydelete(OtherRoleId, #fate_role.id, FateList),
                            NewFateList = lists:sublist([FateRole | NewFateList0], 6),
                            NewMyFate0 = NewMyFate#fate_role_base_info{fate_list = NewFateList},
                            update_ets(not_dets, NewMyFate0),
                            role:apply(async, RolePid, {fate, async_shake, [to_client_list(NewFateList, [])]}),
                            role:apply(async, RolePid, {fate, reward, [OtherRoleId, shake]}),
                            print_info(end_do, "结束广播"),
                            %% ?DEBUG("匹配成功------->[~s]", [Name]),
                            role:pack_send(RolePid, 17704, {1, ?L(<<"匹配成功">>)});
                        _ ->
                            role:pack_send(RolePid, 17704, {0, ?L(<<"匹配失败">>)})
                    end
            end
    end,
    {noreply, State};

%% 清空所有数据
handle_cast(clear_all, State) ->
    ?INFO("清空所有角色数据信息, 角色需要重新登记缘分信息"),
    ets:delete_all_objects(c_fate_role_online),
    ets:delete_all_objects(c_fate_role_base_info),
    dets:delete_all_objects(c_fate_role_base_info),
    {noreply, State};

%% 清空所有数据
handle_cast(clear_online, State) ->
    ?INFO("清空在线角色数据"),
    ets:delete_all_objects(c_fate_role_online),
    {noreply, State};

%% 清空DETS数据
handle_cast(clear_dets, State) ->
    ?INFO("清空DETS数据"),
    dets:delete_all_objects(c_fate_role_base_info),
    {noreply, State};

%% 更新匹配条件
handle_cast({update_match, List}, State) ->
    ?INFO("修改匹配条件:~w", [List]),
    put(fate_match_test_list, List),
    {noreply, State};

%% 打印开关
handle_cast(info_open, State) ->
    ?INFO("打开打印调试信息"),
    put(info_open, true),
    {noreply, State};
handle_cast(info_close, State) ->
    ?INFO("关闭打印调试信息"),
    put(info_open, false),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------
%% 内部方法
%%----------------------------------
load_data() ->
    case dets:first(c_fate_role_base_info) of
        '$end_of_table' -> ?INFO("没有缘分摇一摇角色信息数据");
        _ ->
            dets:traverse(c_fate_role_base_info,
                fun(R) when is_record(R, fate_role_base_info) ->
                        ets:insert(c_fate_role_base_info, R),
                        continue;
                    (_R) ->
                        continue
                end
            ),
            ?INFO("缘分摇一摇角色信息数据加载完毕")
    end.

%% 更新ETS
update_ets(not_dets, FateBaseInfo) ->
    ets:insert(c_fate_role_online, FateBaseInfo#fate_role_base_info{fate_list = []}),
    ets:insert(c_fate_role_base_info, FateBaseInfo#fate_role_base_info{other_info = 0});
update_ets(all, FateBaseInfo) ->
    ets:insert(c_fate_role_online, FateBaseInfo#fate_role_base_info{fate_list = []}),
    ets:insert(c_fate_role_base_info, FateBaseInfo#fate_role_base_info{other_info = 0}),
    dets:insert(c_fate_role_base_info, FateBaseInfo#fate_role_base_info{ %% 减少保存数据信息
            ip = 0, fate_list = [], other_info = 0
        }).

%%-------------------------------------------
%% 匹配处理
%%-------------------------------------------
match(MyFate, L) ->
    MatchList = case get(fate_match_test_list) of
        List when is_list(List) ->  %% 存在测试列表 控制台修改匹配条件
            List;
        _ ->
            [ %% 匹配优先级列表 越前面优先级越高 [{标志, 起作用概率}...]
                {del_history1, 90}, {del_history_all, 50}, {sex, 90}, {city, 85}, {age, 30}
                ,{power1, 80}, {power2, 70}, {power3, 60}, {star, 30}
            ]
    end,
    do_match(MatchList, MyFate, L).

%% 匹配过程处理
do_match(_MatchList, _MyFate, []) -> %% 匹配不上
    false; 
do_match(_MatchList, _MyFate, [I]) -> %% 只有一玩家 直接匹配
    ?DEBUG("只剩一个玩家可选择了:~w", [_MatchList]),
    I; 
do_match([], _MyFate, L) -> %% 条件筛选完成，有多个符合条件，随机一个
    ?DEBUG("从多个玩家中随机抽取一个:~p", [length(L)]),
    util:rand_list(L); 
do_match([{Label, Rand} | T], MyFate, L) -> %% 继续按条件要求筛选适合玩家数据
    RandVal = util:rand(1, 100),
    case RandVal =< Rand of
        true -> %% 使用此条件
            case get_match(Label, MyFate, L) of
                [] -> %% 全部不符合条件 本条件跳过 全部认为合法
                    do_match(T, MyFate, L);
                NewL -> %% 只有部分符合条件，本条件成功 过滤不符合玩家数据 被过滤玩家将不会被匹配到
                    do_match(T, MyFate, NewL)
            end;
        false -> %% 不使用此条件
            do_match(T, MyFate, L)
    end;
do_match([_ | T], MyFate, L) ->
    do_match(T, MyFate, L).

%% 获取符合规则数据
get_match(del_history1, #fate_role_base_info{fate_list = [#fate_role{id = RoleId1} | _]}, L) -> %% 去除历史上一次摇到的玩家
    [I || I = #fate_role_base_info{id = RoleId} <- L, RoleId =/= RoleId1];
get_match(del_history_all, #fate_role_base_info{fate_list = FateList}, L) when length(FateList) > 0 -> %% 去除个人历史所有玩家
    [I || I = #fate_role_base_info{id = RoleId} <- L, lists:keyfind(RoleId, #fate_role.id, FateList) =:= false];
get_match(sex, #fate_role_base_info{sex = MySex}, L) -> %% 异性优先
    [I || I = #fate_role_base_info{sex = Sex} <- L, Sex =/= MySex];
get_match(city, #fate_role_base_info{province = MyProvince, city = MyCity}, L) -> %% 同城优先
    [I || I = #fate_role_base_info{province = Province, city = City} <- L, Province =:= MyProvince, City =:= MyCity];
get_match(age, #fate_role_base_info{sex = 1, age = MyAge}, L) when MyAge > 0 -> %% 男性与自身年龄相差-5~3优先
    [I || I = #fate_role_base_info{age = Age} <- L, Age - MyAge >= -5 andalso Age - MyAge =< 3];
get_match(age, #fate_role_base_info{sex = 0, age = MyAge}, L) when MyAge > 0 -> %% 女性与自身年龄相差自身年龄-2~10岁优先
    [I || I = #fate_role_base_info{age = Age} <- L, Age - MyAge >= -2 andalso Age - MyAge =< 10];
get_match(star, #fate_role_base_info{star = MyStar}, L) -> %% 星座相同优先
    [I || I = #fate_role_base_info{star = Star} <- L, Star =:= MyStar];
get_match(power1, #fate_role_base_info{power = MyPower}, L) when MyPower > 0 -> %% 战斗力优先
    [I || I = #fate_role_base_info{power = Power} <- L, abs(MyPower - Power) / MyPower =< 0.05];
get_match(power2, #fate_role_base_info{power = MyPower}, L) when MyPower > 0 -> %% 战斗力优先
    [I || I = #fate_role_base_info{power = Power} <- L, abs(MyPower - Power) / MyPower =< 0.2];
get_match(power3, #fate_role_base_info{power = MyPower}, L) when MyPower > 0 -> %% 战斗力优先
    [I || I = #fate_role_base_info{power = Power} <- L, abs(MyPower - Power) / MyPower =< 0.3];
get_match(srv_id, #fate_role_base_info{id = {_, MySrvId}}, L) -> %% 同服优先
    [I || I = #fate_role_base_info{id = {_, SrvId}} <- L, SrvId =:= MySrvId];
get_match(not_friend, #fate_role_base_info{name = FriendIds}, L) when length(FriendIds) > 0 -> %% 非好友优先
    [I || I = #fate_role_base_info{id = RoleId} <- L, lists:member(RoleId, FriendIds) =:= false];
get_match(_Label, _MyFate, L) -> 
    L.

%%--------------------------------------
%% 数据版本转换
%%--------------------------------------


%% 打印信息
print_info(Label, Msg) ->
    case get(info_open) of
        true -> do_print_info(Label, Msg);
        _ ->
            ?DEBUG("==============================herer"),
            ok
    end.
do_print_info(start_do, Msg) ->
    erlang:statistics(wall_clock),
    ?INFO("~s", [Msg]);
do_print_info(end_do, Msg) ->
    {_, _Time1} = erlang:statistics(wall_clock),
    ?INFO("~s:~p", [Msg, _Time1]);
do_print_info(_, _) ->
    ?DEBUG("======================================adfasdfas"),
    ok.
