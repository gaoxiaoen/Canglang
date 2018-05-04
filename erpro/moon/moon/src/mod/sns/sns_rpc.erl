%%----------------------------------------------------
%% Author: yqhuang(QQ:19123767)
%% Created: 2011-8-24
%% Description: 好友相关远程调用 s
%%----------------------------------------------------
-module(sns_rpc).

-export([
        handle/3
    ]
).

-include("common.hrl").
-include("sns.hrl").
-include("role.hrl").
-include("role_online.hrl").
-include("link.hrl").
-include("pos.hrl").
-include("assets.hrl").
-include("storage.hrl").
-include("item.hrl").
-include("vip.hrl").
%%
-include("attr.hrl").
-include("max_fc.hrl").
-include("map.hrl").
-include("energy.hrl"). %% for use ?max_energy
-include("invitation.hrl").
-include("award.hrl").
-include("gain.hrl").

-define(GIVE_COST_COIN, 2500).  %% 赠送花的金币数
-define(GIVE_COST_GOLD, 5).     %% 赠送花的晶钻数

%% 获取好友列表
% handle(12100, {}, _Role) ->
%     Friends = friend:get_friend_list(),
%     List = [F || F = #friend{type = Type} <- Friends, Type =/= ?sns_friend_type_kuafu],
%     ?DEBUG("=好友列表====:~w", [List]),
%     {reply, {List}};

% 获取好友列表
% @spec Type :: int 表示请求的好友类型  0:好友 2:黑名单 3:陌生人
% @spec index :: int 表示请求的页数
% handle(12100, {Type, Index}, _Role = #role{sns = #sns{recv_cnt = RecvCnt}}) when Type =:= ?sns_friend_type_hy orelse Type =:= ?sns_friend_type_hmd orelse Type =:= ?sns_friend_type_msr->
handle(12100, {}, _Role = #role{sns = #sns{give_cnt = GiveCnt, recv_cnt = RecvCnt}}) ->
    Num = friend:count_can_give_num(),
    Friends = friend:get_friend_list(),
    List = [F || F = #friend{type = T} <- Friends, T =/= ?sns_friend_type_kuafu],
    List1 = order_by_online(List),
    % {Total_Page, FriendList} = friend:get_certain_page_data(Index, List1),
    Total = erlang:length(List),
    % Reply = {Num, RecvCnt, Total_Page, Total, List1},
    Reply = {Num,  GiveCnt, RecvCnt, Total, List1},
    ?DEBUG("=好友列表====:~w", [Reply]),
    {reply, Reply};

handle(12100, {_Type, _Index}, _Role = #role{link = #link{conn_pid = ConnPid}}) ->
    notice:alert(error, ConnPid, ?L(<<"请求的好友类型不存在">>)),
    {ok};

%% 获取跨服好友列表
handle(12102, {}, _Role) ->
    Friends = friend:get_friend_list(),
    List = [F || F = #friend{type = Type} <- Friends, Type =:= ?sns_friend_type_kuafu],
    ?DEBUG("=跨服好友列表====:~w", [List]),
    {reply, {List}};

%% 获取玩家信息
handle(12105, {FrRoleId, FrSrvId}, Role) ->
    case friend:get_friend_info(rpc, Role, FrRoleId, FrSrvId) of
        {ok, Reply} ->
            {reply, Reply};
        {false, _Reason} ->
            ?DEBUG("玩家信息不存在[FrRoleId:~w, FrSrvId:~w], Reason:~w", [FrRoleId, FrSrvId, _Reason]),
            {ok}
    end;

%% 获取跨服好友tips信息(不做实时查找)
handle(12106, {_FrRoleId, FrSrvId}, #role{id = {_, FrSrvId}}) ->
    {ok};
handle(12106, {FrRoleId, FrSrvId}, _Role) ->
    case friend:get_friend(cache, {FrRoleId, FrSrvId}) of
        %% {ok, Friend = #friend{type = ?sns_friend_type_kuafu}} ->
        %%     case role_api:c_lookup(by_id, {FrRoleId, FrSrvId}, #role.attr) of
        %%         {ok, _N, #attr{fight_capacity = Fight}} ->
        %%             {reply, friend:pack_send_msg(12106, Friend#friend{fight = Fight})};
        %%         _ ->
        %%             {ok}
        %%     end;
        {ok, Friend} ->
            {reply, friend:pack_send_msg(12106, Friend)};
        _Reason ->
            ?DEBUG("玩家信息不存在[FrRoleId:~w, FrSrvId:~w], Reason:~w", [FrRoleId, FrSrvId, _Reason]),
            {ok}
    end;

%% 请求是否可以开启跨服好友页面
handle(12109, {}, #role{lev = Lev, max_fc = #max_fc{max = FightCapacity}}) when FightCapacity < 6500 orelse Lev < 52 ->
    {reply, {?false}};
handle(12109, {}, _Role) ->
    {reply, {?true}};
    %% case ets:lookup(ets_kuafu_friend_roles, {Rid, SrvId}) of
    %%     [{_, ?true, _, _}] ->
    %%         {reply, {?true}};
    %%     _ ->
    %%         {reply, {?false}}
    %% end;

%% 添加好友(添加自己时异常)
handle(12110, {_Type, FriRoleId, FriSrvId}, Role = #role{id = {RoleId, SrvId}}) when (FriRoleId =:= RoleId) and (FriSrvId =:= SrvId) ->
    notice:alert(error, Role, ?MSGID(<<"不可以加自己">>)),
    {ok};

%% 通过玩家Id添加好友
handle(12110, {Type, FrRoleId, FrSrvId}, Role) ->
    case friend:add_friend(Role, Type, FrRoleId, FrSrvId) of
        {ok, send} ->
            case catch role_listener:make_friend(Role, #friend{type = ?sns_friend_type_hy}) of
                NewRole when is_record(NewRole, role) ->
                    notice:alert(succ, Role, ?MSGID(<<"增加好友信息已发送!">>)),
                    {reply, {FrRoleId, FrSrvId, Type}, NewRole};
                _ ->
                    notice:alert(succ, Role, ?MSGID(<<"增加好友信息已发送!">>)),
                    {reply, {FrRoleId, FrSrvId, Type}}
            end;
        {ok, add} ->
            case Type of
                ?sns_friend_type_cr ->
                    notice:alert(succ, Role, ?MSGID(<<"增加仇人成功!">>)),
                    {reply, {FrRoleId, FrSrvId, Type}};
                ?sns_friend_type_hmd ->
                    notice:alert(succ, Role, ?MSGID(<<"增加黑名单成功!">>)),
                    {reply, {FrRoleId, FrSrvId, Type}}
            end;
        {false, Reason} ->
            notice:alert(error, Role, Reason),
            {ok}
    end;

%% 通过玩家名称添加好友
handle(12115, {_Type, FrName}, Role = #role{name = Name}) when FrName =:= Name ->
    notice:alert(succ, Role, ?MSGID(<<"不能添加自己!">>)),
    {ok};
%% 通过玩家名称添加好友
handle(12115, {Type, FrName}, Role) ->
    case sns_dao:get_role_by_name(FrName) of        %%查询数据库
        {true, [FrRoleId, FrSrvId, _Name]} ->
            case friend:add_friend(Role, Type, FrRoleId, FrSrvId) of %%通过玩家RoleId添加好友
                {ok, send} ->
                    notice:alert(succ, Role, ?MSGID(<<"增加好友信息已发送!">>)),
                    {reply, {?sns_op_succ, FrRoleId, FrSrvId, Type}};
                {ok, add} ->
                    case Type of
                        ?sns_friend_type_cr ->
                            notice:alert(succ, Role, ?MSGID(<<"增加仇人成功!">>)),
                            {reply, {?sns_op_succ, FrRoleId, FrSrvId, Type}};
                        ?sns_friend_type_hmd ->
                            notice:alert(succ, Role, ?MSGID(<<"增加黑名单成功!">>)),
                            {reply, {?sns_op_succ, FrRoleId, FrSrvId, Type}}
                    end;
                {ok, NRole} -> %%对方已经向自己申请，直接同意加为好友了
                    case catch role_listener:make_friend(NRole, #friend{type = ?sns_friend_type_hy}) of
                        NewRole when is_record(NewRole, role) ->
                            notice:alert(succ, Role, ?MSGID(<<"添加好友成功!">>)),
                            {reply, {2, FrRoleId, FrSrvId, Type}, NewRole}; %%2表示直接加为好友成功
                        _ ->
                            notice:alert(succ, Role, ?MSGID(<<"添加好友成功!">>)),
                            {reply, {2, FrRoleId, FrSrvId, Type}, NRole}
                    end;
                {false, Reason} ->
                    notice:alert(error, Role, Reason),
                    {reply, {?sns_op_fail, FrRoleId, FrSrvId, Type}} 
            end;
        {false, _} ->
            notice:alert(error, Role, ?MSGID(<<"该玩家不存在!">>)),
            {ok}
    end;

%% 删除好友
handle(12120, {FrRoleId, FrSrvId}, Role) ->
    case friend:rpc_delete_friend(Role, FrRoleId, FrSrvId) of
        {ok} ->
            ?DEBUG("====删除好友====:~w", [FrRoleId]),
            ?DEBUG("====删除好友====:~w", [FrRoleId]),
            % friend:send_del_friend(ConnPid, {FrRoleId, FrSrvId}), %%发送成功确认的消息
            {reply, {FrRoleId}};
        {false, Reason} ->
            notice:alert(error, Role, Reason),
            {ok}
    end;

%% 变更好友类型 
handle(12125, {?sns_friend_type_kuafu, _FrRoleId, _FrSrvId}, _Role) ->
    {reply, {?false, ?L(<<"跨服好友不支持设置分组设置">>)}};
handle(12125, {Type, FrRoleId, FrSrvId}, Role) ->
    case friend:update_friend_type(Role, FrRoleId, FrSrvId, Type) of
        {false, Reason} ->
            {reply, {0, Reason, Type, FrRoleId, FrSrvId}};
        {ok, ?sns_friend_type_hy} ->
            {reply, {2, ?L(<<"增加好友信息已发送!">>), Type, FrRoleId, FrSrvId}};
        {ok, _Other} ->
            {reply, {1, ?L(<<"变更类型成功">>), Type, FrRoleId, FrSrvId}}
    end;

%% 确认添加好友请求
handle(12130, {Agree, FrRoleId, FrSrvId}, Role = #role{id = {RoleId, _},link = #link{conn_pid = ConnPid}}) ->
    case Agree of
        1 ->
            case friend:agree_add_friend(Role, FrRoleId, FrSrvId) of
                {false, Reason} ->
                    notice:alert(error,ConnPid,Reason),
                    {reply, {?sns_op_fail, Reason, FrRoleId, FrSrvId}};
                {ok, NRole} ->
                    case catch role_listener:make_friend(NRole, #friend{type = ?sns_friend_type_hy}) of
                        NewRole when is_record(NewRole, role) ->
                            notice:alert(succ, Role, ?MSGID(<<"添加好友成功">>)),
                            {reply, {FrRoleId}, NewRole};
                        _ ->
                            notice:alert(succ, Role, ?MSGID(<<"添加好友成功">>)),
                            {reply, {FrRoleId}, NRole}
                    end
            end;
        0 ->
            friend_dao:delete_friend_apply(RoleId,FrRoleId),
            % friend:send_decline_friend({FrRoleId, FrSrvId}, {RoleId, SrvId, RoleName, 0}),
            friend:delete_friend_apply(RoleId, {FrRoleId, FrSrvId}),
            {ok}
    end;

%%同意所有添加请求
handle(12131, {}, Role = #role{id = {RoleId,_}}) ->
    % Apply_List = friend_dao:get_friend_apply2(RoleId),
    case friend_dao:get_friend_apply2(RoleId) of 
        {true, Data} ->
            {NRole, Left_List} = agree_add_friend_all(Role, Data, []),
            case erlang:length(Left_List) > 0 of 
                true -> 
                    {reply, {0, Left_List}, NRole};
                false ->    
                    {reply, {1, []}, NRole}
            end;
        {false, _} ->
            {reply, {1, []}, Role}
    end;

%%获取好友申请数据    
handle(12135, {}, _Role = #role{id = {RoleId, _}}) ->
    Data = friend:get_friend_apply(RoleId),
    ?DEBUG("---Data---~p~n", [Data]),
    % Reply = friend:get_certain_page_data(Index, Data),
    % ?DEBUG("=好友申请列表====:~w", [Reply]),
    {reply, {Data}};

% handle(12135, {Index}, _Role = #role{id = {RoleId, _}}) ->
%     Data = friend:get_friend_apply(RoleId),
%     ?DEBUG("---Data---~p~n", [Data]),
%     Reply = friend:get_certain_page_data(Index, Data),
%     ?DEBUG("=好友申请列表====:~w", [Reply]),
%     {reply, Reply};



%%忽略一个添加请求
handle(12136, {Apply_Id}, _Role = #role{id = {RoleId,_}}) ->
    friend_dao:delete_friend_apply(RoleId,Apply_Id),

    {reply, {Apply_Id}};

%%一键忽略所有添加请求
handle(12137, {}, _Role = #role{id = {RoleId,_}}) ->
    friend_dao:delete_friend_apply_all(RoleId),
    role:put_dict(friend_apply, []),
    {reply, {?sns_op_succ}};

%%一键删除陌生人
handle(12138, {}, _Role = #role{id = {RoleId,SrvId}}) ->
    Friends = friend:get_friend_list(),
    List = [F || F = #friend{type = Type1} <- Friends, Type1 == ?sns_friend_type_msr],
    NewFriends = Friends -- List,
    case role:put_dict(sns_role_friends, NewFriends) of 
        {ok, _} ->
            friend_dao:delete_friend_type(RoleId,SrvId,?sns_friend_type_msr),
            {reply, {?sns_op_succ}};
        _ ->
           {reply, {?sns_op_fail}}
    end; 

%%取消拉黑
handle(12139, {FrRoleId,FrSrvId}, _Role = #role{id = {RoleId,SrvId}}) ->
    case sns_dao:get_role_by_id(FrRoleId,FrSrvId) of 
        {true,_} ->
            friend:delete_friend(cache, {FrRoleId, FrSrvId}),
            friend_dao:delete_friend(RoleId, SrvId, FrRoleId, FrSrvId),
            {reply, {FrRoleId}};
        {false,_} ->
            {reply, {?sns_op_fail}}
    end;


%% 添加好友分组
handle(12152, {FrGroupName}, Role = #role{sns = Sns = #sns{fr_group = FrGroup}}) ->
    Rs = [{_Id, _Name} || {_Id, _Name} <- FrGroup, _Name =:= FrGroupName],
    case length(Rs) > 0 of
        true ->
            {reply, {?sns_op_fail, ?L(<<"分组名称已经存在">>), -1, <<>>}};
        false ->
            NewGroupId = util:unixtime(),
            Rs2 = [{_Id2, _Name2} || {_Id2, _Name2} <- FrGroup, _Id2 =:= NewGroupId],
            case length(Rs2) > 0 of
                true ->
                    {reply, {?sns_op_fail, ?L(<<"大哥，你是不是按得太快了">>), -1, <<>>}};
                false ->
                    NewSns = Sns#sns{fr_group = [{NewGroupId, FrGroupName} | FrGroup]},
                    {reply, {?sns_op_succ, ?L(<<"操作成功">>), NewGroupId, FrGroupName}, Role#role{sns = NewSns}}
            end
    end;

%% 删除好友分组
handle(12153, {FrGroupId}, Role = #role{sns = Sns = #sns{fr_group = FrGroup}}) ->
    case lists:keyfind(FrGroupId, 1, FrGroup) of
        false ->
            {reply, {?sns_op_fail, ?L(<<"分组不存在">>), FrGroupId}};
        ?sns_fr_group_id_kuafu ->
            {reply, {?sns_op_fail, ?L(<<"分组不存在">>), FrGroupId}};
        _ ->
            case friend:delete_friend_group(Role, FrGroupId) of
                {ok, _FrGroupList} ->
                    NewFrGroup = lists:keydelete(FrGroupId, 1, FrGroup),
                    {reply, {?sns_op_succ, ?L(<<"操作成功">>), FrGroupId}, Role#role{sns = Sns#sns{fr_group = NewFrGroup}}};
                {false, Reason} ->
                    {reply, {?sns_op_fail, Reason, FrGroupId}}
            end
    end;

%% 重命名好友信息
handle(12154, {FrGroupId, FrGroupName}, Role = #role{sns = Sns = #sns{fr_group = FrGroup}}) ->
    case lists:keyfind(FrGroupId, 1, FrGroup) of
        false ->
            {reply, {?sns_op_fail, ?L(<<"分组不存在">>), 0, <<>>}};
        {_FrGroupId, _FrGroupName} ->
            NewFrGroup = lists:keyreplace(FrGroupId, 1, FrGroup, {FrGroupId, FrGroupName}),
            {reply, {?sns_op_succ, ?L(<<"操作成功">>), FrGroupId, FrGroupName}, Role#role{sns = Sns#sns{fr_group = NewFrGroup}}}
    end;

%% 获取好友分组列表
handle(12155, {}, _Role = #role{sns = #sns{fr_group = FrGroup}}) ->
    {reply, {FrGroup}};

%% 转移好友分组
handle(12156, {?sns_fr_group_id_kuafu, _Friends}, _Role) ->
    {reply, {?sns_op_fail, ?L(<<"跨服好友不支持分组操作">>)}};
handle(12156, {GroupId, Friends}, Role) ->
    case friend:update_friend_group(Role, GroupId, Friends) of
        {ok} ->
            {reply, {?sns_op_succ, ?L(<<"操作成功">>)}};
        {false, Reason} ->
            {reply, {?sns_op_fail, Reason}}
    end;

%% 批量删除好友
handle(12157, {Friends}, Role) ->
    case friend:check_friends_exist(Role, Friends) of
        {ok} ->
            case batch_delete_friend(Role, Friends) of
                {ok} ->
                    {reply, {?sns_op_succ, ?L(<<"操作成功">>)}};
                {false, Reason} ->
                    {reply, {?sns_op_fail, Reason}}
            end;
        {false, Reason} ->
            {reply, {?sns_op_fail, Reason}}
    end; 

%% 修改个性签名
handle(12159, {Signature}, Role) ->
    case friend:update_signature(Role, Signature) of
        {ok, NewRole} ->
            {reply, {?sns_op_succ, ?L(<<"操作成功">>)}, NewRole};
        {false, Reason} ->
            {reply, {?sns_op_fail, Reason}}
    end;

%% 赠送鲜花给一个玩家
handle(12160, {RecvName, NameCode, Type}, Role = #role{bag = Bag})
when Type >= 1 andalso Type =< 12 ->
    BaseId = case Type of
        1 -> 33002;
        2 -> 33003;
        3 -> 33004;
        4 -> 33045;
        5 -> 33048;
        6 -> 33079;
        7 -> 33117;
        8 -> 33176;
        9 -> 33198;
        10 -> 33200;
        11 -> 33201;
        12 -> 33203;
        _ -> 33002
    end,
    case storage:find(Bag#bag.items, #item.base_id, BaseId) of
        {false, _R} -> {reply, {0, ?L(<<"包包里木有发现可以送的东西">>)}};
        {ok, _Num, _ItemList, _, _} ->
            case RecvName =:= Role#role.name of
                true when BaseId =/= 33203 -> {reply, {0, ?L(<<"不能赠送钻戒给自己">>)}};
                true -> {reply, {0, ?L(<<"自己不能给自己送花,^.^">>)}};
                false ->
                    case role_api:lookup(by_name, RecvName, [#role.pid, #role.id]) of
                        {ok, Node, [RecvPid, RecvId]} when Node =:= node() ->
                            role:send_buff_begin(),
                            case friend:send_flower(NameCode, Type, BaseId, RecvName, RecvPid, RecvId, Role) of
                                {false, Reason} -> 
                                    role:send_buff_clean(),
                                    {reply, {0, Reason}};
                                {ok, Msg, NewRole} ->
                                    role:send_buff_flush(),
                                    log:log(log_item_del_loss, {<<"送花">>, Role}),
                                    Nr = role_listener:special_event(NewRole, {1037, finish}),
                                    listener(flowertype_to_val(Type), Role),
                                    {reply, {1, Msg}, Nr}
                            end;
                        {ok, _, _} ->
                            {reply, {0, ?L(<<"暂时不支持向跨服好友赠送鲜花哦">>)}};
                        _ -> {reply, {0, ?L(<<"对方不存在或者不在线">>)}}
                    end
            end
    end;
handle(12160, _, _) ->
    {reply, {?false, <<>>}};

%% 赠送鲜花给一个玩家
handle(12165, {Rid, SrvId, _NameCode, 12}, #role{id = {Rid, SrvId}}) ->
    {reply, {?false, ?L(<<"自己就不要给自己送钻戒啦">>)}};
handle(12165, {Rid, SrvId, _NameCode, _Type}, #role{id = {Rid, SrvId}}) ->
    {reply, {?false, ?L(<<"自己就不要给自己送花啦">>)}};
handle(12165, {Rid, SrvId, NameCode, Type}, Role = #role{bag = Bag})
when Type >= 1 andalso Type =< 12 ->
    BaseId = case Type of
        1 -> 33002;
        2 -> 33003;
        3 -> 33004;
        4 -> 33045;
        5 -> 33048;
        6 -> 33079;
        7 -> 33117;
        8 -> 33176;
        9 -> 33198;
        10 -> 33200;
        11 -> 33201;
        12 -> 33203;
        _ -> 33002
    end,
    case storage:find(Bag#bag.items, #item.base_id, BaseId) of
        {false, _R} -> {reply, {0, ?L(<<"包包里木有发现可以送的东西">>)}};
        {ok, _Num, _ItemList, _, _} ->
            case role_api:c_lookup(by_id, {Rid, SrvId}, [#role.name, #role.pid]) of
                {ok, Node, [RecvName, RecvPid]} when Node =:= node() ->
                    role:send_buff_begin(),
                    case friend:send_flower(NameCode, Type, BaseId, RecvName, RecvPid, {Rid, SrvId}, Role) of
                        {false, Reason} -> 
                            role:send_buff_clean(),
                            {reply, {0, Reason}};
                        {ok, Msg, NewRole} ->
                            role:send_buff_flush(),
                            log:log(log_item_del_loss, {<<"送花">>, Role}),
                            Nr = role_listener:special_event(NewRole, {1037, finish}),
                            listener(flowertype_to_val(Type), Role),
                            {reply, {1, Msg}, Nr}
                    end;
                {ok, _, [RecvName, RecvPid]} ->
                    case friend:cross_send_flower(NameCode, Type, BaseId, RecvName, RecvPid, {Rid, SrvId}, Role) of
                        {false, Reason} ->
                            {reply, {0, Reason}};
                        {ok, Msg, NewRole} ->
                            log:log(log_item_del_loss, {<<"送花">>, Role}),
                            Nr = role_listener:special_event(NewRole, {1037, finish}),
                            listener(flowertype_to_val(Type), Role),
                            {reply, {1, Msg}, Nr}
                    end;
                _ -> {reply, {0, ?L(<<"对方不存在或者不在线">>)}}
            end
    end;

%% 搜索用户
handle(12164, {RoleName}, _Role = #role{id = {RoleId, SrvId}, name = Name, lev = Lev, career = Career, sex = Sex, vip = #vip{portrait_id = FaceId}}) when RoleName =:= Name ->
        {reply, {RoleId, SrvId, RoleName, Lev, Career, Sex, FaceId}};

% handle(12164, {RoleName}, _Role) ->
%     case role_api:lookup(by_name, RoleName) of
%         {ok, _N, _R = #role{id = {RoleId, SrvId}, lev = Lev, career = Career, sex = Sex, vip = #vip{portrait_id = FaceId}}} ->
%             {reply, {RoleId, SrvId, RoleName, Lev, Career, Sex, FaceId}};
%         {error, not_found} -> %% 角色不在线
%             {reply, {-1, <<"">>, <<"">>, 0, 0, 0, 0}}
%     end;
handle(12164, {RoleName}, _Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case role_api:lookup(by_name, RoleName) of
        {ok, _N, _R = #role{id = {RoleId, SrvId}, lev = Lev, career = Career, sex = Sex, vip = #vip{portrait_id = _FaceId}}} ->
            {reply, {RoleId, SrvId, RoleName, Lev, Career, Sex, _FaceId}};
        {error, not_found} -> %% 角色不在线
            case sns_dao:get_role_by_name2(RoleName) of 
                {true, [SrvId,Lev,Career,Sex,FaceId]} ->
                    {reply, {-1, SrvId, RoleName, Lev, Career, Sex, FaceId}};
                {false,[]} ->
                    notice:alert(error,ConnPid,<<"玩家信息不存在">>),
                    {ok}
            end
    end;


%% 好友祝福送达
handle(12171, {Type, FrRoleId, FrSrvId, Lev}, Role) ->
    case friend:friend_wish(Role, FrRoleId, FrSrvId, Type, Lev) of
        {ok, NewRole, Result, FrName, Exp, WishNum} ->
            case Result of
                2 -> {reply, {Result, ?L(<<"你好友已经下线">>), FrName, Exp, WishNum}, NewRole};
                3 -> {reply, {Result, ?L(<<"你好友这次已经达到祝福上限了">>), FrName, Exp, WishNum}, NewRole};
                5 -> {reply, {4, ?L(<<"你今天的祝福次数已经达到上限了">>), FrName, Exp, WishNum}, NewRole}; %% 这里应该是5的
                _Other -> {reply, {Result, <<>>, FrName, Exp, WishNum}, NewRole}
            end;
        {false, Reason} ->
            {reply, {4, Reason, <<>>, 0, 0}}
    end;

%% 获取角色列表加为好友
handle(12173, {}, Role) ->
    friend:select_friend_list(Role),
    {ok};

%% 祝福回赠
handle(12174, {Friends, Type}, #role{name = Name}) when is_list(Friends) andalso Type >= 1 andalso Type =< 3 ->
    ?DEBUG("12174 Friends = ~w", [Friends]),
    case friend:return_gift(Name, Friends, Type) of
        {ok} ->
            {reply, {1, ?L(<<"您的回赠好友已收到">>)}};
        {false, Reason} ->
            {reply, {0, Reason}}
    end;

%% 获取周围的玩家
handle(12179, {Index}, Role = #role{id = {Rid, _}}) ->
    MapPid = Role#role.pos#pos.map_pid, 
    MapRoles = 
        case is_pid(MapPid) of 
            true ->
                map:role_list(MapPid);
            false ->
                []
        end,
    Data = [{MR#map_role.rid, MR#map_role.srv_id, MR#map_role.name, MR#map_role.lev, MR#map_role.career, MR#map_role.sex, friend:get_face_id(MR#map_role.career, MR#map_role.sex), MR#map_role.fight_capacity}||MR<-MapRoles],
    NData = lists:keydelete(Rid, 1, Data),
    Reply = friend:get_certain_page_data(Index, NData),
    {reply, Reply};

handle(12180, {Type}, _Role) ->
    Friends = friend:get_friend_list(),
    List = [F || F = #friend{type = T} <- Friends, T =/= ?sns_friend_type_kuafu andalso T =:= Type],
    ?DEBUG("=好友列表====:~w", [List]),
    {reply, {List}};

handle(12181, {_FrRoleId, _FrSrvId, _Type}, #role{sns = #sns{give_cnt = Cnt}}) when Cnt =< 0 ->
    {reply, {0, ?MSGID(<<"赠送次数不足">>)}};
handle(12181, {_FrRoleId, _FrSrvId, 1}, Role = #role{assets = #assets{coin = Coin}, sns = Sns = #sns{give_cnt = Cnt}}) ->
    case Coin >= ?GIVE_COST_COIN of
        true ->
            FrdId = {_FrRoleId, _FrSrvId},
            case friend:give_energy(FrdId, Role) of
                {ok, _MsgId} ->
                    {ok, Role1} = role_gain:do([#loss{label = coin, val = ?GIVE_COST_COIN}], Role),
                    {ok, Role2} = role_gain:do([#gain{label = energy, val = 5}], Role1),
                    {reply, {1, ?MSGID(<<"把酒言欢，您获得了5点体力">>)}, Role2#role{sns = Sns#sns{give_cnt = Cnt-1}}};
                {false, MsgId} ->
                    ?DEBUG("============= 赠送体力错误码 ~w", [MsgId]),
                    {reply, {0, MsgId}}
            end;
        false ->
            {reply, {0, ?MSGID(<<"金币不足">>)}}
    end;

handle(12181, {_FrRoleId, _FrSrvId, 2}, Role = #role{assets = #assets{gold = Gold}, sns = Sns = #sns{give_cnt = Cnt}}) ->
    case Gold >= ?GIVE_COST_GOLD of
        true ->
            FrdId = {_FrRoleId, _FrSrvId},
            case friend:give_energy(FrdId, Role) of
                {ok, _MsgId} ->
                    {ok, Role1} = role_gain:do([#loss{label = gold, val = ?GIVE_COST_GOLD}], Role),
                    {ok, Role2} = role_gain:do([#gain{label = energy, val = 10}], Role1),
                    {reply, {1, ?MSGID(<<"饱餐一顿，您获得了10点体力">>)}, Role2#role{sns = Sns#sns{give_cnt = Cnt-1}}};
                {false, MsgId} ->
                    ?DEBUG("============= 赠送体力错误码 ~w", [MsgId]),
                    {reply, {0, MsgId}}
            end;
        false ->
            {reply, {0, ?MSGID(<<"晶钻不足">>)}}
    end;

 % handle(12182, {_FrRoleId, _FrSrvId}, #role{assets = #assets{energy = E}, sns = #sns{recv_cnt = Cnt}}) when E >= ?max_energy ->
 %     {reply, {Cnt, 0, ?MSGID(<<"您当前体力充沛，不需要收获体力哦">>)}};
handle(12182, {_FrRoleId, _FrSrvId}, #role{sns = #sns{recv_cnt = Cnt}}) when Cnt =< 0 ->
    {reply, {0, 0, ?MSGID(<<"收获次数已满，明天再来哦">>)}};
handle(12182, FrdId = {_FrRoleId, _FrSrvId}, Role = #role{sns = #sns{recv_cnt = OldCnt}}) ->
    case friend:recv_energy(FrdId, Role) of
        {ok, _MsgId, Role1} ->
        %%    {reply, {Cnt, 1, MsgId}, Role1};
            {ok, Role1};
        {false, MsgId} ->
            ?DEBUG("=========== 收获体力错误码 ~w", [MsgId]),
            {reply, {OldCnt, 0, MsgId}}
    end;

handle(12185, {}, Role) ->
    case friend:batch_give_energy(Role) of
        {ok, MsgId} ->
            {reply, {1, MsgId}};
        {false, MsgId} ->
            ?DEBUG("============= 全部赠送体力错误码 ~w", [MsgId]),
            {reply, {0, MsgId}}
    end;

handle(12190, {}, _Role = #role{invitation = Invitation, award = AwardList}) ->
    {Code, Num} = case Invitation of
        #invitation{code = <<>>} ->
            {<<>>, 0};
        #invitation{code = Code0} ->
            Num0 = invitation:invitee_num(Code0),
            {Code0, Num0};
        _ ->
            {<<>>, 0}
    end,
    Awards = lists:map(fun({AwardBaseId, Need})->
        #base_award{gains = [#gain{val = [GiftId, _, _]}]} = award_data:get(AwardBaseId),
        case [ A || A = #award{base_id = AwardBaseId0} <- AwardList, AwardBaseId =:= AwardBaseId0 ] of
            [] -> 
                {0, GiftId, 0, Need};
            [#award{id = AwardId}] ->
                {AwardId, GiftId, 1, Need}
        end
    end, ?inviter_awards),
    {reply, {Code, Num, Awards}};

handle(12191, {_AwardId}, _Role) ->
    {reply, {0}};

%% 容错函数
handle(_Cmd, _Data, _Role) ->
    {error, friend_unknow_command}.

order_by_online(Friends) ->
    L1 = lists:keysort(#friend.online, Friends),
    lists:reverse(L1).

%%-------------------------
%% 内部函数
%% -----------------------
flowertype_to_val(1) -> 1;
flowertype_to_val(2) -> 99;
flowertype_to_val(3) -> 999;
flowertype_to_val(4) -> 999;
flowertype_to_val(5) -> 99;
flowertype_to_val(6) -> 99;
flowertype_to_val(7) -> 99;
flowertype_to_val(9) -> 99;
flowertype_to_val(10) -> 99;
flowertype_to_val(11) -> 999;
flowertype_to_val(12) -> 999;
flowertype_to_val(_) -> 1.

%% 批量删除好友
batch_delete_friend(Role = #role{id = {RoleId, SrvId}}, [[FrRoleId, FrSrvId] | T]) ->
    case sworn_api:is_sworn({RoleId, SrvId}, {FrRoleId, FrSrvId}) of
        false ->
            case friend:rpc_delete_friend(Role, FrRoleId, FrSrvId) of
                {ok} ->
                    %% sys_conn:pack_send(ConnPid, 12120, {?sns_op_succ, <<"">>, FrRoleId, FrSrvId}),
                    batch_delete_friend(Role, T);
                {false, Reason} ->
                    {false, Reason}
            end; 
        true ->
            batch_delete_friend(Role, T)
    end;
batch_delete_friend(_Role, []) ->
    {ok}.

listener(Num, _Role) when Num < 99 -> ok;
listener(Num, Role) ->
    StartTime = util:datetime_to_seconds({{2013, 3, 12}, {0, 0, 1}}),
    EndTime = util:datetime_to_seconds({{2013, 3, 15}, {23, 59, 59}}),
    case util:unixtime() of
        Now when Now >= StartTime andalso Now =< EndTime -> %% 在活动时间段内
            reward_send_flower(Num, Role);
        _ -> ok
    end.
reward_send_flower(Num, Role) when Num >= 99 andalso Num < 999 ->
    Subject = ?L(<<"赠人玫瑰，手留余香">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。活动期间，您成功赠送喜庆的鲜花，获得了下列额外超值大礼哦！">>),
    Items = [{30011, 1, 2}, {24120, 1, 1}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
reward_send_flower(Num, Role) when Num >= 999 ->
    Subject = ?L(<<"赠人玫瑰，手留余香">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。活动期间，您成功赠送喜庆的鲜花，获得了下列额外超值大礼哦！">>),
    Items = [{30011, 1, 10}, {24123, 1, 1}, {33001, 1, 3}, {33010, 1, 10}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items}).

%同意添加好友
agree_add_friend_all(Role, [], L) -> {Role, L};
agree_add_friend_all(Role= #role{id = {RoleId, _}}, [[FrRoleId, FrSrvId]|T], L) ->
    case agree(Role, FrRoleId, FrSrvId) of 
        {ok, NRole} ->
            friend_dao:delete_friend_apply(RoleId, FrRoleId),
            agree_add_friend_all(NRole, T, L);
        false ->
            agree_add_friend_all(Role, T, [FrRoleId|L])
    end.
    % agree_add_friend_all(Role,T,L1).


agree(Role, FrRoleId, FrSrvId) ->
    case friend:agree_add_friend(Role, FrRoleId, FrSrvId) of
        {false, _} ->
             false;
        {ok, NRole} ->
            {ok, NRole}
    end.


