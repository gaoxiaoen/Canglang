%% ***********************************
%% 结拜相关外部调用接口
%% @author lishen (105326073@qq.com)
%% ***********************************

-module(sworn_api).
-export([
        is_sworn/1
        ,is_sworn/2
        ,login/1
        ,refresh_buff/1
        ,remove_buff/1
        ,do_refresh_buff/2
        ,do_remove_buff/1
        ,switch/1
        ,disconnect/1
        ,logout/1
    ]).
        
-include("common.hrl").
-include("role.hrl").
-include("sworn.hrl").
%%
-include("link.hrl").
-include("pos.hrl").
-include("sns.hrl").
-include("buff.hrl").

%% @spec is_sworn(RoleId) -> true | false
%% @doc 是否已经结拜过
is_sworn(RoleId) when is_integer(RoleId) ->
    case ets:lookup(ets_role_sworn, RoleId) of
        [#sworn_info{num = Num}] when Num > 0 -> true;
        _ -> false
    end.

%% @spec is_sworn(RoleId1, RoleId2) -> true | false
%% @doc 是否有结拜关系
is_sworn(RoleId1, RoleId2) ->
    case ets:lookup(ets_role_sworn, RoleId1) of
        [#sworn_info{member = [#sworn_member{id = Id}]}] when Id =:= RoleId2 ->
            true;
        [#sworn_info{member = [#sworn_member{id = Id1}, #sworn_member{id = Id2}]}] when Id1 =:= RoleId2 orelse Id2 =:= RoleId2 ->
            true;
        _ ->
            false
    end.

%% @spec login(Role) -> NewRole
%% @doc 玩家登录处理
login(Role = #role{id = Id, pid = Pid, link = #link{conn_pid = ConnPid}, event = Event}) when Event =:= ?event_jiebai ->
    sworn_dao:load(Id),
    case ets:lookup(ets_role_sworn, Id) of
        [] ->
            sworn:role_online(Id, Pid, ConnPid),
            Role;
        [SwornInfo = #sworn_info{type = ?SWORN_COMMON, is_award = ?false, num = Num}] when Num > 0 ->
            Role1 = Role#role{event = ?event_no},
            sworn:handle_sworn_login(Role1, SwornInfo);
        [SwornInfo = #sworn_info{type = ?SWORN_LOD, title_h = Th, is_award = ?false, num = Num}] when Num > 0 andalso Th =/= <<>> ->
            Role1 = Role#role{event = ?event_no},
            sworn:handle_sworn_login(Role1, SwornInfo);
        [SwornInfo = #sworn_info{is_award = ?true}] ->
            do_login(Role#role{event = ?event_no}, SwornInfo);
        _ ->
            Role#role{event = ?event_no}
    end;
login(Role = #role{id = Id}) ->
    sworn_dao:load(Id),
    case ets:lookup(ets_role_sworn, Id) of
        [SwornInfo = #sworn_info{type = ?SWORN_COMMON, is_award = ?false, num = Num}] when Num > 0 ->
            sworn:handle_sworn_login(Role, SwornInfo);
        [SwornInfo = #sworn_info{type = ?SWORN_LOD, title_h = Th, is_award = ?false, num = Num}] when Num > 0 andalso Th =/= <<>> ->
            sworn:handle_sworn_login(Role, SwornInfo);
        [SwornInfo = #sworn_info{is_award = ?true}] ->
            do_login(Role, SwornInfo);
        _ ->
            Role
    end.

%% @spec logout(Role) -> any()
%% @doc 角色下线处理
logout(#role{id = Id}) ->
    ets:delete(ets_role_sworn, Id).

%% @spec switch(Role) -> any()
%% @doc 顶号登陆，切换连接
switch(#role{id = Id, pid = Pid, link = #link{conn_pid = ConnPid}, event = Event})
when Event =:= ?event_jiebai ->
    sworn:role_online(Id, Pid, ConnPid);
switch(_Role) ->
    ok.

%% @spec disconnect(Role) -> any()
%% @doc 断开连接
disconnect(Role) ->
    sworn:role_disconnect(Role).

%% @doc 玩家登录处理
do_login(Role, SwornInfo = #sworn_info{num = 1}) ->
    sworn:handle_divorce_login(Role, SwornInfo);
do_login(Role, SwornInfo = #sworn_info{num = 2, out_member_id = {Id, _SrvId}}) when Id =/= 0 ->
    sworn:handle_divorce_login(Role, SwornInfo);
do_login(Role, _SwornInfo) ->
    remove_buff_no_push(Role).

%% @doc 刷新所有成员的结拜buff
refresh_buff([]) -> ignore;
refresh_buff([{Pid, _id}]) ->
    role:c_apply(async, Pid, {fun do_remove_buff/1, []}),
    ok;
refresh_buff([{Pid1, Id1}, {Pid2, Id2}]) ->
    role:c_apply(async, Pid1, {fun do_refresh_buff/2, [[Id2]]}),
    role:c_apply(async, Pid2, {fun do_refresh_buff/2, [[Id1]]}),
    ok;
refresh_buff([{Pid1, Id1}, {Pid2, Id2}, {Pid3, Id3}]) ->
    role:c_apply(async, Pid1, {fun do_refresh_buff/2, [[Id2, Id3]]}),
    role:c_apply(async, Pid2, {fun do_refresh_buff/2, [[Id1, Id3]]}),
    role:c_apply(async, Pid3, {fun do_refresh_buff/2, [[Id1, Id2]]}),
    ok;
refresh_buff(_Data) -> ?DEBUG("~w", [_Data]).

%% @spec remove_buff(List) -> any()
%% @doc 移除结拜buff
remove_buff([]) -> ignore;
remove_buff([{Pid, _Id}]) ->
    role:c_apply(async, Pid, {fun do_remove_buff/1, []});
remove_buff([{Pid1, _Id1}, {Pid2, _Id2}]) ->
    role:c_apply(async, Pid1, {fun do_remove_buff/1, []}),
    role:c_apply(async, Pid2, {fun do_remove_buff/1, []});
remove_buff([{Pid1, _Id1}, {Pid2, _Id2}, {Pid3, _Id3}]) ->
    role:c_apply(async, Pid1, {fun do_remove_buff/1, []}),
    role:c_apply(async, Pid2, {fun do_remove_buff/1, []}),
    role:c_apply(async, Pid3, {fun do_remove_buff/1, []});
remove_buff(_) -> ignore.

%% 刷新队伍中的成员buff
do_refresh_buff(Role, []) ->
    do_remove_buff(Role);
do_refresh_buff(Role = #role{id = RoleId}, [Id]) ->
    case ets:lookup(ets_role_sworn, RoleId) of
        [] ->   %% 没有结拜
            {ok};
        [#sworn_info{member = [#sworn_member{id = Id}]}] ->
            handle_buff(Role, Id);
        [#sworn_info{member = [#sworn_member{id = Id}, _M]}] ->
            handle_buff(Role, Id);
        [#sworn_info{member = [_M, #sworn_member{id = Id}]}] ->
            handle_buff(Role, Id);
        [_] ->
            do_remove_buff(Role)
    end;
do_refresh_buff(Role = #role{id = RoleId}, [Id1, Id2]) ->
    case ets:lookup(ets_role_sworn, RoleId) of
        [] ->   %% 没有结拜
            {ok};
        [#sworn_info{member = [#sworn_member{id = Id1}]}] ->
            handle_buff(Role, Id1);
        [#sworn_info{member = [#sworn_member{id = Id2}]}] ->
            handle_buff(Role, Id2);
        [#sworn_info{member = [#sworn_member{id = Id1}, #sworn_member{id = Id2}]}] ->
            handle_buff(Role, Id1, Id2);
        [#sworn_info{member = [#sworn_member{id = Id2}, #sworn_member{id = Id1}]}] ->
            handle_buff(Role, Id1, Id2);
        [#sworn_info{member = [#sworn_member{id = Id1}, _M]}] ->
            handle_buff(Role, Id1);
        [#sworn_info{member = [#sworn_member{id = Id2}, _M]}] ->
            handle_buff(Role, Id2);
        [#sworn_info{member = [_M, #sworn_member{id = Id1}]}] ->
            handle_buff(Role, Id1);
        [#sworn_info{member = [_M, #sworn_member{id = Id2}]}] ->
            handle_buff(Role, Id2);
        [_] ->
            do_remove_buff(Role)
    end;
do_refresh_buff(_, _) -> {ok}.

add_buff(Role, Inti) ->
    case get_buff(Inti) of
        none -> {ok};
        BuffLabel ->
            case buff:add(Role, BuffLabel) of
                {ok, NewRole} -> %% 需要buff表设置好覆盖关系，内部处理
                    {ok, role_api:push_attr(NewRole)};
                _ ->
                    {ok}
            end
    end.

handle_buff(Role, Id) ->
    case friend:get_friend(cache, Id) of
        {ok, #friend{intimacy = Inti}} ->
            add_buff(Role, Inti);
        _ ->
            {ok}
    end.

handle_buff(Role, Id1, Id2) ->
    case {friend:get_friend(cache, Id1), friend:get_friend(cache, Id2)} of
        {{ok, #friend{intimacy = Inti1}}, {ok, #friend{intimacy = Inti2}}} when Inti1 >= Inti2 ->
            add_buff(Role, Inti1);
        {{ok, #friend{intimacy = Inti1}}, {ok, #friend{intimacy = Inti2}}} when Inti1 < Inti2 ->
            add_buff(Role, Inti2);
        {{ok, #friend{intimacy = Inti1}}, _} ->
            add_buff(Role, Inti1);
        {_, {ok, #friend{intimacy = Inti2}}} ->
            add_buff(Role, Inti2);
        _ ->
            {ok}
    end.


%% 清除所有结拜buff
do_remove_buff(Role) ->
    L = get_buff_list(),
    do_remove_buff(Role, L).
do_remove_buff(Role, []) ->
    {ok, role_api:push_attr(Role)};
do_remove_buff(Role, [Label | T]) ->
    case buff:del_buff_by_label_no_push(Role, Label) of
        {ok, NewRole} ->
            do_remove_buff(NewRole, T);
        _ ->
            do_remove_buff(Role, T)
    end.

%% 清除所有结拜buff（不推送信息）
remove_buff_no_push(Role) ->
    L = get_buff_list(),
    do_remove_buff_no_push(Role, L).
do_remove_buff_no_push(Role, []) ->
    Role;
do_remove_buff_no_push(Role = #role{buff = Rbuff = #rbuff{buff_list = BuffList}}, [Label | T]) ->
    NewBuffList = remove_buff_by_label(BuffList, Label, []),
    do_remove_buff_no_push(Role#role{buff = Rbuff#rbuff{buff_list = NewBuffList}}, T).

remove_buff_by_label([], _Label, NewBuffList) -> NewBuffList;
remove_buff_by_label([#buff{label = Label} | T], Label, NewBuffList) ->
    remove_buff_by_label(T, Label, NewBuffList);
remove_buff_by_label([Buff | T], Label, NewBuffList) ->
    remove_buff_by_label(T, Label, [Buff | NewBuffList]).

%% 获取结拜组队buff
get_buff(Inti) when Inti >= 1000 andalso Inti < 2000 -> brother_1;
get_buff(Inti) when Inti >= 2000 andalso Inti < 3000 -> brother_2;
get_buff(Inti) when Inti >= 3000 -> brother_3;
get_buff(_) -> none.

%% 获取结拜组队buff列表
get_buff_list() -> [brother_1, brother_2, brother_3].
