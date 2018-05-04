%%----------------------------------------------------
%% 缘分摇一摇 远程调用RPC
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(fate_rpc).
-export([handle/3]).
-include("common.hrl").
-include("role.hrl").
-include("fate.hrl").
-include("assets.hrl").
-include("link.hrl").
-include("vip.hrl").
-include("sns.hrl").
-include("guild.hrl").

handle(_Cmd, _Data, #role{lev = Lev}) when Lev < ?FATE_MIN_LEV ->
    {ok};

%% 角色登录信息记录
handle(17700, {City}, Role) ->
    case get(fate_role_login) of
        1 -> ok;
        _ ->
            put(fate_role_login, 1),
            fate:reg_city(Role, City)
    end,
    {ok};

%% 面板信息获取
handle(17701, {City}, Role) ->
     case check_time(fate_get_panel_info, 5) of
         false ->
             {ok};
         _ ->
             role:put_dict(fate_get_panel_info, util:unixtime()),
             {reply, fate:get_panel_info(Role, City)}
     end;

%% 获取自己缘分签信息
handle(17702, {}, Role) ->
    case center:call(c_fate_mgr, get_self_info, [Role#role.id]) of 
        {ok, Name, Sex, Age, Star, Msg, Province, City} ->
            {reply, {Name, Sex, Age, Star, Msg, Province, City}};
        _ ->
            {ok}
    end;

%% 修改自己缘分签信息
handle(17703, {Name, Sex, Age, Star, Msg, Province, City}, Role) ->
     case check_time(fate_update_info, 5) of
        false -> 
            {reply, {Province, City, 0, ?L(<<"操作太频繁">>)}};
        true ->
            case fate:update_info(Role, Name, Sex, Age, Star, Msg, Province, City) of
                {false, Reason} -> {reply, {Province, City, 0, Reason}};
                ok ->
                    role:put_dict(fate_update_info, util:unixtime()),
                    {ok}
            end
    end;

%% 缘分摇一摇
handle(17704, {}, Role) ->
    case check_time(fate_shake_time, 4) of
        false -> 
            {reply, {0, ?L(<<"操作过频繁">>)}};
        true ->
            NewRole = role_listener:special_event(Role, {1058, 1}), %%缘分摇一摇
            case fate:shake(Role) of
                {false, Reason} -> 
                    {reply, {0, Reason}, NewRole};
                ok -> 
                    role:put_dict(fate_shake_time, util:unixtime()),
                    {ok, NewRole}
            end
    end;

%% 获取历史有缘人列表信息
handle(17706, {}, Role) ->
    case center:call(c_fate_mgr, history_list, [Role#role.id]) of
        {ok, CompressedData} -> 
            case catch binary_to_term(CompressedData) of
                [ok, L] ->
                    {reply, {L}};
                _ ->
                    {reply, {[]}}
            end;
        _ -> 
            {reply, {[]}}
    end;

%% 向TA发起聊天申请
handle(17707, {Rid, Srvid, _Msg}, #role{id = {Rid, Srvid}, name = _Name}) ->
    ?DEBUG("自己不能向自己发起聊天申请[~s]", [_Name]),
    {ok};
handle(17707, {_Rid, _Srvid, Msg}, _Role) when byte_size(Msg) > 210 ->
    {reply, {0, ?L(<<"信息内容太长">>)}};
handle(17707, {Rid, Srvid, Msg}, #role{id = {MyRid, MySrvId}, name = MyName}) ->
    case role_api:c_lookup(by_id, {Rid, Srvid}, #role.pid) of
        {ok, _Node, Pid} ->
            role:c_pack_send(Pid, 17708, {MyRid, MySrvId, MyName, Msg}),
            {reply, {1, ?L(<<"请求已发送，请耐心等待TA回复！">>)}};
        _ ->
            {reply, {0, ?L(<<"对方不在线">>)}}
    end;

%% 答复TA发起的聊天申请
handle(17709, {Rid, Srvid, 1}, #role{id = {Rid, Srvid}}) -> %% 同意 
    {ok};
handle(17709, {Rid, Srvid, 1}, #role{id = {MyRid, MySrvId}, pid = MyPid, link = #link{conn_pid = ConnPid}}) -> %% 同意 
    case center:call(c_fate_mgr, check_ta, [{Rid, Srvid}, {MyRid, MySrvId}]) of
        true ->
            case role_api:c_lookup(by_id, {Rid, Srvid}, #role.pid) of
                {ok, _Node, Pid} ->
                    %% center:cast(c_fate_mgr, cast, [{hi, {Rid, Srvid}, {MyRid, MySrvId}}]),
                    sys_conn:pack_send(ConnPid, 17710, {Rid, Srvid}),
                    role:apply(async, MyPid, {fate, reward, [{Rid, Srvid}, agree_chat]}),
                    spawn(
                        fun() ->
                                util:sleep(3000),
                                role:apply(async, Pid, {fate, reward, [{MyRid, MySrvId}, chat]}),
                                role:c_pack_send(Pid, 17710, {MyRid, MySrvId})
                        end
                    ),
                    {ok};
                _ ->
                    {reply, {0, ?L(<<"对方不在线">>)}}
            end;
        _ ->
            {ok}
    end;
handle(17709, {_Rid, _Srvid, _AgreeType}, _Role) -> %% 拒绝
    {ok};

%% 获取TA聊天窗口信息
handle(17711, {Rid, Srvid}, Role) ->
    {Age, Star, Msg, Province, City} = case center:call(c_fate_mgr, get_self_info, [{Rid, Srvid}]) of 
        {ok, _Name1, _Sex1, Age1, Star1, Msg1, Province1, City1} ->
            {Age1, Star1, Msg1, Province1, City1};
        _ ->
            {0, 0, <<>>, <<>>, <<>>}
    end,
    {MyProvince, MyCity} = case center:call(c_fate_mgr, get_self_info, [Role#role.id]) of 
        {ok, _Name2, _Sex2, _Age2, _Star2, _Msg2, Province2, City2} ->
            {Province2, City2};
        _ ->
            {<<>>, <<>>}
    end,
    {Max1, N1, L1} = fate:get_log_info(Role, praise),
    {Max2, N2, L2} = fate:get_log_info(Role, flower),
    Praise = case lists:member({Rid, Srvid}, L1) orelse N1 >= Max1 of
        true -> 1;
        false -> 0
    end,
    Flower = case lists:member({Rid, Srvid}, L2) orelse N2 >= Max2 of
        true -> 1;
        false -> 0
    end,
    case role_api:c_lookup(by_id, {Rid, Srvid}) of
        {ok, _Node, #role{name = Name, lev = Lev, vip = #vip{type = Vip, portrait_id = Icon}, guild = #role_guild{name = Gname}, sns = #sns{signature = Sign}, assets = #assets{charm = Charm}, sex = Sex, career = Career}} ->
            {reply, {1, Praise, Flower, Charm, Rid, Srvid, Name, Sex, Career, Lev, Gname, Icon, Vip, Sign, MyProvince, MyCity, Age, Star, Msg, Province, City}};
        _Res ->
            {reply, {0, Praise, Flower, 0, Rid, Srvid, <<>>, 0, 0, 0, <<>>, 0, 0, <<>>, MyProvince, MyCity, Age, Star, Msg, Province, City}}
    end;

%% 私聊信息
handle(17712, {Rid, Srvid, _Msg}, #role{id = {Rid, Srvid}}) ->
    {ok};
handle(17712, {_Rid, _Srvid, Msg}, _Role) when byte_size(Msg) > 900 ->
    {ok};
handle(17712, {Rid, Srvid, Msg}, #role{link = #link{conn_pid = ConnPid}, id = {MyRid, MySrvId}, name = MyName, sex = Sex, vip = #vip{type = Vip}, realm = Realm}) ->
    case role_api:c_lookup(by_id, {Rid, Srvid}, #role.pid) of
        {ok, _Note, Pid} ->
            role:c_pack_send(Pid, 17712, {MyRid, MySrvId, MyName, Sex, Vip, Realm, [], Msg});
        _ ->
            sys_conn:pack_send(ConnPid, 17711, {0, 0, 0, 0, Rid, Srvid, <<>>, 0, 0, 0, <<>>, 0, 0, <<>>, <<>>, <<>>, 0, 0, <<>>, <<>>, <<>>})
    end,
    {ok};

%% 给TA送礼 [1:爱心 2:99玫瑰]
handle(17713, {Rid, Srvid, Type}, #role{id = {Rid, Srvid}}) ->
    {reply, {Type, 0, ?L(<<"自己送花给自己不太好吧">>)}};
handle(17713, {Rid, Srvid, Type}, Role) ->
    case fate:send_gift(Role, {Rid, Srvid}, Type) of
        {false, Reason} ->
            {reply, {Type, 0, Reason}};
        {ok, NRole} ->
            {reply, {Type, 1, <<>>}, NRole}
    end;

%% 向TA发互动申请
handle(17714, {Rid, Srvid, _Type}, #role{id = {Rid, Srvid}}) -> 
    {ok};
handle(17714, {ToRid, ToSrvid, Type}, Role = #role{pid = MyPid, id = {MyRid, MySrvId}, name = MyName}) -> 
    case role_api:c_lookup(by_id, {ToRid, ToSrvid}, [#role.pid, #role.fate_pid]) of
        {ok, _, [_Pid, FatePid]} when is_pid(FatePid) ->
            {reply, {0, ?L(<<"对方正在互动中">>)}};
        {ok, _, [ToPid, _]} -> %% 摇骰子
            case center:call(c_fate_mgr, check_ta, [{ToRid, ToSrvid}, {MyRid, MySrvId}]) of
                true ->
                    %% role:c_pack_send(Pid, 17715, {MyRid, MySrvId, MyName, Type}),
                    role:c_apply(async, ToPid, {fate_act, act_call_for, [{MyRid, MySrvId, MyName}, Type]}),
                    {N1, N2} = fate_act:get_free_num(Role),
                    ChatMsg = case Type of
                        ?fate_type_dice -> util:fbin(?L(<<"已成功向对方发出抛骰子邀请，剩余邀请机会{str,~p,#fcff02}次">>), [N2]);
                        _ -> util:fbin(?L(<<"已成功向对方发出猜拳邀请，剩余邀请机会{str,~p,#fcff02}次">>), [N1])
                    end,
                    role:pack_send(MyPid, 17712, {ToRid, ToSrvid, <<>>, 0, 0, 0, [], ChatMsg}),
                    {ok};
                _ ->
                    {reply, {0, ?L(<<"您们不是TA关系，不能进行互动的哦">>)}}
            end;
        _ ->
            {reply, {0, ?L(<<"对方不在线">>)}}
    end;

%% 同意TA互动申请
handle(17716, {Rid, Srvid, _Type, _AgreeType}, #role{id = {Rid, Srvid}}) ->
    {ok};
handle(17716, {_Rid, _Srvid, Type, _AgreeType}, _Role) when Type =/= ?fate_type_dice andalso Type =/= ?fate_type_finger_guess ->
    {ok};
handle(17716, {FromRid, FromSrvid, Type, AgreeType}, #role{status = ?status_fight}) when AgreeType =/= 2 -> %% 战斗状态不能参与互动
    {reply, {FromRid, FromSrvid, Type, 0, 0, ?L(<<"战斗状态不能参与互动">>)}};
handle(17716, {FromRid, FromSrvid, Type, AgreeType}, #role{fate_pid = FatePid}) when is_pid(FatePid) andalso AgreeType =/= 2 -> %% 战斗状态不能参与互动
    {reply, {FromRid, FromSrvid, Type, 0, 0, ?L(<<"当前正在互动">>)}};
handle(17716, {FromRid, FromSrvid, Type, AgreeType}, Role = #role{id = {ToRid, ToSrvId}, name = ToName, pid = ToPid}) -> %%
    Now = util:unixtime(),
    case get({fate_act_call_for, FromRid, FromSrvid}) of
        done ->
            {reply, {FromRid, FromSrvid, Type, 0, 0, ?L(<<"该请求已处理过，请勿重复操作！">>)}};
        {Type, T} when Now - T > 60 ->
            {reply, {FromRid, FromSrvid, Type, 0, 0, ?L(<<"操作超时">>)}};
        {Type, _T} ->
            put({fate_act_call_for, FromRid, FromSrvid}, done),
            case role_api:c_lookup(by_id, {FromRid, FromSrvid}, [#role.pid, #role.name, #role.fate_pid]) of
                {ok, _, [_FromPid, _FromName, FatePid]} when is_pid(FatePid) ->
                    {reply, {FromRid, FromSrvid, Type, 0, 0, ?L(<<"对方已开始互动了">>)}};
                {ok, _, [FromPid, _FromName, _FatePid]} when AgreeType =:= 2 ->
                    RoleMsg = notice:role_to_msg(Role),
                    ChatMsg = case Type of
                        ?fate_type_dice -> util:fbin(?L(<<"貌似对方现在不想跟你玩哦，~s拒绝了你的抛骰子请求">>), [RoleMsg]);
                        _ -> util:fbin(?L(<<"貌似对方现在不想跟你玩哦，~s拒绝了你的猜拳请求">>), [RoleMsg])
                    end,
                    role:c_pack_send(FromPid, 17712, {ToRid, ToSrvId, <<>>, 0, 0, 0, [], ChatMsg}),
                    role:pack_send(ToPid, 17712, {FromRid, FromSrvid, <<>>, 0, 0, 0, [], ?L(<<"已拒绝对方请求">>)}),
                    {ok};
                {ok, Node, [FromPid, FromName, _FatePid]} -> %% 
                    role:pack_send(ToPid, 17712, {FromRid, FromSrvid, <<>>, 0, 0, 0, [], ?L(<<"已同意对方请求">>)}),
                    case fate_act:start({ToPid, ToRid, ToSrvId, ToName}, {FromPid, FromRid, FromSrvid, FromName}, Type, node() =:= Node) of
                        {ok, Pid} ->
                            {ok, Role#role{fate_pid = Pid}};
                        {false, Reason} ->
                            {reply, {FromRid, FromSrvid, Type, 0, 0, Reason}};
                        _ ->
                            {reply, {FromRid, FromSrvid, Type, 0, 0, ?L(<<"对方当前状态不能发起互动">>)}}
                    end;
                _ ->
                    {reply, {FromRid, FromSrvid, Type, 0, 0, ?L(<<"对方不在线">>)}}
            end;
        _ ->
            {reply, {FromRid, FromSrvid, Type, 0, 0, ?L(<<"对方没有邀请你互动哦">>)}}
    end;

%% 互动开始
handle(17717, {Type, Val}, Role) ->
    case fate_act:select_val(Role, Type, Val) of
        {false, Reason} -> {reply, {0, Reason}};
        _ -> {ok}
    end;

%% 通知可发放奖励
handle(17719, {}, Role) ->
    fate_act:reward(Role),
    {ok};

%% 获取剩余免费数据
handle(17720, {}, Role) ->
    {reply, fate_act:get_free_num(Role)};

%% 容错处理
handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.

%%----------------------------------------
%% 内部方法
%%----------------------------------------

%% 时间间隔最小为: 秒
check_time(Type, N) -> 
    LastTime = case role:get_dict(Type) of
        {ok, undefined} -> 0;
        {ok, T} -> T
    end,
    (LastTime + N) < util:unixtime().

