%%----------------------------------------------------
%% 角色后台管理接口
%%
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(role_adm).
-export([
        dump_role_online/0
        ,print/1
        ,adm_set_assets/6
        ,adm_set_realm/2
        ,fix_online_status/1
        ,change_code/0
        ,local_change_code/0
        ,socket_state/1
    ]
).

-export([
        get_roles_id_online/0           %% 获取各个节点所有在线角色的ID
        ,get_roles_online_local/1           %% 获取本地节点在线角色ID
        ,roles_online_background_mail/0
        ,online_roles/1
        ,sync_to_db/1
        ,sync_role_to_db/1
        ,update_lev/2
    ]
).

-include("common.hrl").
-include("role_online.hrl").
-include("node.hrl").
-include("role.hrl").
-include("link.hrl").
-include("assets.hrl").
-include("guild.hrl").


%% @spec update_lev({Rid, SrvId}, NLev) -> ok 
update_lev(Name, NLev) ->
    ets:update_element(role_online, Name, {7, NLev}).

%% @spec adm_set_assets(Id, SrvId, AdmName, Type, Val, Label) -> ok | {false, Reason}
%% Id = integer()
%% SrvId = bitstring()
%% Admname = bitstring() 后台管理员名称
%% Type = gold | gold_bind | coin | coin_bind
%% Type = 1 | 2 | 3 | 4
%% Label = 1 | 0  1表示增加 0表示减去
%% @doc 后台设置玩家的资产信息
adm_set_assets(Rid, SrvId, AdmName, Type, Val, Label) ->
    case check_online({Rid, SrvId}) of
        false ->
            do_set_assets(Rid, SrvId, AdmName, Type, Val, Label);
        {ok, Role} ->
            do_set_assets_online(Role, AdmName, Type, Val, Label)
    end.

%% @spec adm_set_realm({Id, SrvId}, Realm) -> ok | {false, Reason}
%% Id = integer()
%% SrvId = bitstring()
%% Realm = integer()
%% @doc 后台设置玩家的阵营信息
adm_set_realm({Rid, SrvId}, Realm)
when Realm =:= ?role_realm_a orelse Realm =:= ?role_realm_b ->
    case role_api:lookup(by_id, {Rid, SrvId}, #role.pid) of
        {ok, _N, RolePid} ->
            role:apply(async, RolePid, {fun do_adm_set_realm/2, [Realm]});
        _ ->
            {false, not_online}
    end;
adm_set_realm(_, _) -> {false, error_args}.

%% 将当前在线的角色信息快照保存到磁盘中
%% 路径:var/role_online.dump
dump_role_online() ->
    ok.

%% @spec print({Rid, SrvId}) -> ok
%% Rid = integer()
%% SrvId = bitstring()
%% @doc 将指定角色的信息打印到控制台
print({Rid, SrvId}) ->
    case role_api:lookup(by_id, {Rid, SrvId}) of
        {ok, N, R} ->
            Title = ["所在节点", "角色ID", "进程PID", "帐号名", "角色名", "状态", "性别", "阵营", "职业", "等级", "移动速度", "收益属性", "位置信息", "连接属性", "战斗属性", "Buff数据", "背包数据", "任务数据"],
            [_ | T] = tuple_to_list(R),
            util:cn("---角色[{~w:~w}]的当前状态-------------------------~n", [Rid, SrvId]),
            do_print(Title, [N | T]),
            util:cn("----------------------------------------------");
        Other -> Other
    end.

%% @spec fix_online_status(Id) -> ok
%% Id = all | {Rid, SrvId}
%%      Rid = integer()
%%      SrvId = bitstring()
%% @doc 修复指定角色在数据库中的在线状态
fix_online_status(all) ->
    db:execute(<<"update role set is_online = 0">>),
    util:cn("所有角色的在线状态重置为离线状态~n");
fix_online_status({Rid, SrvId}) ->
    Val = case role_api:lookup(by_id, {Rid, SrvId}) of
        {ok, _N, _R} -> 1;
        {error, not_found} -> 0
    end,
    db:execute(<<"update role set is_online = ~s where id = ~s and srv_id = ~s">>, [Val, Rid, SrvId]),
    ok.

%% @spec socket_state({Rid, SrvId}) -> {ok, Stat} | {false, Reason}
%% Rid = integer()
%% SrvId = bitstring()
%% Stat = list()
%% Reason = term()
%% @doc 查看指定角色的socket状态
socket_state({Rid, SrvId}) ->
    case role_api:lookup(by_id, {Rid, SrvId}, #role.link) of
        {ok, _N, #link{socket = Socket}} ->
            inet:getstat(Socket);
        _E ->
            {false, _E}
    end.

%% @spec online_roles(Type) -> RoleDataList
%% @doc 获取在线角色数据
online_roles(pid) ->
    [Pid || #role_online{pid = Pid} <- ets:tab2list(role_online)];
online_roles(id) ->
    [{ID, Srvid} || #role_online{id = {ID, Srvid}} <- ets:tab2list(role_online)];
online_roles(_Type) -> [].

%% 后台管理获取在线角色名单     自定义接口
get_roles_id_online() -> %%roles_online_background_manage()
    get_roles_online(background_manage).

%% 后台邮件获取在线角色名单     自定义接口
roles_online_background_mail() ->
    get_roles_online(background_mail).

%% 获取在线角色，后台管理需求   回调函数
get_roles_online_local(background_manage) ->
    {ok, [{ID, Srvid} || #role_online{id = {ID, Srvid}} <- ets:tab2list(role_online)]};
%% 获取在线角色，后台邮件需求   回调函数
get_roles_online_local(background_mail) ->
    {ok, [{ID, Srvid, Name, Lev, Platform} || #role_online{id = {ID, Srvid}, name = Name, lev = Lev, platform = Platform} <- ets:tab2list(role_online)]};
get_roles_online_local(_Type) -> error.

%% @spec get_roles_online() -> error | [NodeRoles |...]
%% NodeRoles = {NodeName, IDList}
%% IDList = [ID | ...]
%% ID = term()
%% @doc 获取各个节点所有在线角色的id, 需根据自己需求自定义接口和回调函数 get_roles_online_local/1
get_roles_online(Type) ->
    Fun = fun(Node) -> 
            case rpc:call(Node, ?MODULE, get_roles_online_local, [Type]) of
                {ok, Re} -> {Node, Re};
                error -> {Node, [error]}
            end 
    end,
    [Fun(NodeName) ||#node{name = NodeName} <- sys_node_mgr:list()].

%% @spec sync_to_db(Rids) -> ok
%% @doc 同步指定角色数据到数据库中
sync_to_db(Rids) ->
    Now = util:unixtime(),
    case erlang:get(adm_role_op) of
        Time when is_integer(Time) andalso (Now - Time) =< 5 ->
            <<"请不要频繁操作">>;
        _ ->
            erlang:put(adm_role_op, Now),
            Fun = fun({Rid, Srvid}) -> is_integer(Rid) andalso is_binary(Srvid) end,
            case catch lists:all(Fun, Rids) of
                true ->
                    catch lists:foreach(fun({Rid, Srvid}) -> 
                                role:apply(async, global:whereis_name({role, Rid, Srvid}), {role_adm, sync_role_to_db, []}) end, Rids),
                    <<"同步完毕">>;
                _ ->
                    ?ERR("同步指定角色数据到数据库时，传入错误的参数"),
                    <<"传入角色ID参数有误">>
            end
    end.

%% @spec sync_to_db(Role) -> {ok}
%% @doc 同步角色数据到数据库，异步调用
sync_role_to_db(Role = #role{id = {Rid, Srvid}, name = Name}) ->
    case role_data:save_role(Role) of
        true ->
            ?INFO("指定角色{~s}的角色数据已经同步到数据库中", [Name]),
            {ok};
        {false, Why} ->
            ?ERR("同步角色{~w,~s}数据到数据库发生错误:~w", [Rid, Srvid, Why]),
            {ok}
    end.

%% 热更新role模块的代码
change_code() ->
    do_change_code_to_nodes(sys_node_mgr:list(all)).

local_change_code() ->
    L = ets:tab2list(role_group_world),
    do_change_code(L),
    do_resume(L),
    do_suspend(L).

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------

do_print([], _) -> ok;
do_print([H | T], [HH | TT]) ->
    util:cn("~s: ~s~n", [H, util:to_list(HH)]),
    do_print(T, TT).

do_change_code_to_nodes([]) -> ok;
do_change_code_to_nodes([H | T]) ->
    rpc:call(H#node.name, ?MODULE, local_change_code, []),
    do_change_code_to_nodes(T).

do_suspend([]) -> ok;
do_suspend([{Pid, _} | T]) ->
    sys:suspend(Pid),
    do_suspend(T).

do_change_code([]) -> ok;
do_change_code([{Pid, _} | T]) ->
    sys:change_code(Pid, undefined, role, undefined),
    do_change_code(T).

do_resume([]) -> ok;
do_resume([{Pid, _} | T]) ->
    sys:resume(Pid),
    do_resume(T).

%% 检查玩家是否在线
check_online(RoleId) ->
    case role_api:lookup(by_id, RoleId) of
        {ok, _, Role} -> {ok, Role};
        _ -> false
    end.

type_to_atom(1) -> gold;
type_to_atom(2) -> gold_bind;
type_to_atom(3) -> coin;
type_to_atom(4) -> coin_bind;
type_to_atom(_) -> error.

label2str(1) -> <<"增加">>;
label2str(0) -> <<"减少">>.

type2str(1) -> <<"晶钻">>;
type2str(2) -> <<"绑定晶钻">>;
type2str(3) -> <<"金币">>;
type2str(4) -> <<"绑定金币">>;
type2str(_) -> <<"未知">>.

%% 设置玩家资产
do_set_assets(_Rid, _SrvId, _AdmName, Type, _Val, Label)
when Type < 1 andalso Type > 4
orelse (Label =/= 0 andalso Label =/= 1) ->
    {false, <<"后台管理参数错误">>};
do_set_assets(Rid, SrvId, AdmName, Type, Val, Label) ->
    Sql = "select A.rid, A.srv_id, A.gold, A.coin, A.gold_bind, A.coin_bind, B.account, B.name from role_assets as A left join role as B on A.rid = B.id and A.srv_id = B.srv_id where A.rid = ~s and A.srv_id = ~s",
    case db:get_row(Sql, [Rid, SrvId]) of
        {error, undefined} -> {false, not_exists};
        {error, Err} ->
            ?ERR("后台获取资产信息时发生异常: ~s", [Err]),
            {false, fetch_failure};
        {ok, A = [_Rid, _SrvId, Gold, Coin, GoldBind, CoinBind, Acc, Name]} ->
            {NewGold, NewCoin, NewGoldBind, NewCoinBind} = do_set(type_to_atom(Type), {Gold, Coin, GoldBind, CoinBind}, Val, Label),
            Sql1 = "update role_assets set gold = ~s, coin = ~s, gold_bind = ~s, coin_bind = ~s where rid = ~s and srv_id = ~s",
            case  db:execute(Sql1, [NewGold, NewCoin, NewGoldBind, NewCoinBind, Rid, SrvId]) of
                {error, Err} ->
                    ?ERR("后台保存资产信息发生异常: ~s", [Err]),
                    {false, save_failure};
                {ok, _Affected} ->
                    Desc = util:fbin(<<"管理员~s 给玩家[~s]~s~w~s">>, [AdmName, Name, label2str(Label), Val, type2str(Type)]),
                    Remark = util:term_to_bitstring(A),
                    LogSql = "insert into log_edit_assets (adm_name, rid, srv_id, name, acc, desc_msg, remark, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
                    case  db:execute(LogSql, [AdmName, Rid, SrvId, Name, Acc, Desc, Remark, util:unixtime()]) of
                        {error, Err} ->
                            ?ERR("后台日志记录管理员[~s]操作信息发生异常: ~s", [AdmName, Err]),
                            {false, save_failure};
                        {ok, _Affected} ->
                            ok
                    end
            end
    end.

%% 设置在线玩家资产
do_set_assets_online(_, _AdmName, Type, _Val, Label)
when Type < 1 andalso Type > 4
orelse (Label =/= 0 andalso Label =/= 1) ->
    {false, <<"后台管理参数错误">>};
do_set_assets_online(#role{id = {Rid, SrvId}, name = Name, account = Acc, pid = Pid, assets = Assets}, AdmName, Type, Val, Label) ->
    case role:apply(sync, Pid, {fun do_set_role_assets/2, [{Type, Val, Label}]}) of
        {error, _E} ->
            ?ERR("管理员~s同步设置玩家信息失败:~w", [AdmName, _E]),
            {false, <<"玩家在线，但是同步设置失败">>};
        ok ->
            %% 记录日志
            Desc = util:fbin(<<"管理员~s给玩家[~s]~s~w~s">>, [AdmName, Name, label2str(Label), Val, type2str(Type)]),
            Remark = util:term_to_bitstring(Assets),
            LogSql = "insert into log_edit_assets (adm_name, rid, srv_id, name, acc, desc_msg, remark, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
            case  db:execute(LogSql, [AdmName, Rid, SrvId, Name, Acc, Desc, Remark, util:unixtime()]) of
                {error, Err} ->
                    ?ERR("后台日志记录管理员[~s]操作信息发生异常: ~s", [AdmName, Err]),
                    {false, save_failure};
                {ok, _Affected} ->
                    ok
            end
    end;
do_set_assets_online(_, AdmName, _, _, _) ->
    ?ERR("管理员~s同步设置玩家信息失败参数错误", [AdmName]),
    error.

%% 异步回调函数，设置玩家资产信息
do_set_role_assets(Role = #role{assets = Assets =
        #assets{gold = Gold, coin = Coin, gold_bind = GoldBind, coin_bind = CoinBind}}, {Type, Val, Label}) ->
    {NewGold, NewCoin, NewGoldBind, NewCoinBind} = do_set(type_to_atom(Type), {Gold, Coin, GoldBind, CoinBind}, Val, Label),
    NewRole = role_api:push_assets(Role, Role#role{assets = Assets#assets{gold = NewGold, coin = NewCoin, gold_bind = NewGoldBind, coin_bind = NewCoinBind}}),
    {ok, ok, NewRole};
do_set_role_assets(_, _) ->
    {ok, ok}.

%% 异步回调：设置玩家阵营
do_adm_set_realm(#role{status = Status, event = Event}, _Realm)
when Status =/= ?status_normal orelse Event =/= ?event_no ->
    {ok};
do_adm_set_realm(#role{realm = Realm}, Realm) ->
    ?INFO("角色阵营=当前要求转换的阵营"),
    {ok};
do_adm_set_realm(#role{guild = #role_guild{gid = Gid}}, _Realm) when Gid =/= 0 ->
    ?INFO("角色有帮会，不能转换"),
    {ok};
do_adm_set_realm(Role = #role{link = #link{conn_pid = ConnPid}}, Realm) ->
    NewRole = Role#role{realm = Realm},
    map:role_update(NewRole),
    sys_conn:pack_send(ConnPid, 10025, {?true, Realm, <<"转换阵营成功，现在可以选择加入本阵营的帮会">>}),
    ?INFO("角色转换成功"),
    {ok, NewRole}.

%% 操作资产
do_set(coin, {Gold, Coin, GoldBind, CoinBind}, Val, 1) -> %% 增
    trunc_val({Gold, Coin + Val, GoldBind, CoinBind});
do_set(coin, {Gold, Coin, GoldBind, CoinBind}, Val, 0) ->
    trunc_val({Gold, Coin - Val, GoldBind, CoinBind});

do_set(gold, {Gold, Coin, GoldBind, CoinBind}, Val, 1) ->
    trunc_val({Gold + Val, Coin, GoldBind, CoinBind});
do_set(gold, {Gold, Coin, GoldBind, CoinBind}, Val, 0) ->
    trunc_val({Gold - Val, Coin, GoldBind, CoinBind});

do_set(coin_bind, {Gold, Coin, GoldBind, CoinBind}, Val, 1) ->
    trunc_val({Gold, Coin, GoldBind, CoinBind + Val});
do_set(coin_bind, {Gold, Coin, GoldBind, CoinBind}, Val, 0) ->
    trunc_val({Gold, Coin, GoldBind, CoinBind - Val});

do_set(gold_bind, {Gold, Coin, GoldBind, CoinBind}, Val, 1) ->
    trunc_val({Gold, Coin, GoldBind + Val, CoinBind});
do_set(gold_bind, {Gold, Coin, GoldBind, CoinBind}, Val, 0) ->
    trunc_val({Gold, Coin, GoldBind - Val, CoinBind});

do_set(_, {Gold, Coin, GoldBind, CoinBind}, _Val, 0) ->
    trunc_val({Gold, Coin, GoldBind, CoinBind}).

%% 检查0值
trunc_val({Gold, Coin, GoldBind, CoinBind}) when Gold < 0 ->
    {0, Coin, GoldBind, CoinBind};
trunc_val({Gold, Coin, GoldBind, CoinBind}) when Coin < 0 ->
    {Gold, 0, GoldBind, CoinBind};
trunc_val({Gold, Coin, GoldBind, CoinBind}) when GoldBind < 0 ->
    {Gold, Coin, 0, CoinBind};
trunc_val({Gold, Coin, GoldBind, CoinBind}) when CoinBind < 0 ->
    {Gold, Coin, GoldBind, 0};
trunc_val(D) -> D.
