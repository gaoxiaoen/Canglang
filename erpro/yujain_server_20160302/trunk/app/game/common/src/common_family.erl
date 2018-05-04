%%%-------------------------------------------------------------------
%%% File        :common_family.erl
%%% Author      :caochuncheng2002@gmail.com
%%% Create Date :2013-8-23
%%% @doc
%%%     帮派模块
%%% @end
%%%-------------------------------------------------------------------
-module(common_family).

-include("common.hrl").
-include("common_server.hrl").

%% API
-export([
         get_family_process_name/1,
         create_family_process/2,
         destroy_family_process/2,
         
         send_to_family/2,
         send_to_family_manager/1,
         
         get_family_pid/1,
         
         send_family_attr_change/3,
         send_family_attr_change/4
        ]).

%% 帮派属性变化通知
send_family_attr_change(RoleId,FamilyId,AttrList) when erlang:is_integer(RoleId)->
    case erlang:whereis(common_misc:get_role_gateway_process_name(RoleId)) of
        undefined ->
            ignore;
        PId ->
            send_family_attr_change(PId,RoleId,FamilyId,AttrList)
    end.
send_family_attr_change(PId,RoleId,FamilyId,AttrList) ->
    SendSelf = #m_family_attr_change_toc{op_type=0,family_id=FamilyId,role_id=RoleId,attr_list=AttrList},
    common_misc:unicast(PId, ?FAMILY, ?FAMILY_ATTR_CHANGE, SendSelf).



%% 帮派进程名称
get_family_process_name(FamilyId) ->
    erlang:list_to_atom(lists:concat(["family_", FamilyId])).

%% 发消息到帮派进程
send_to_family(FamilyPId,Msg) when erlang:is_pid(FamilyPId)->
    FamilyPId ! Msg;
send_to_family(FamilyId,Msg) ->
    case erlang:whereis(common_family:get_family_process_name(FamilyId)) of
        undefined ->
            ?ERROR_MSG("family process does not exist ,FamilyId=~w,Msg=~w",[FamilyId,Msg]),
            ignore;
        FamilyPId ->
            FamilyPId ! Msg
    end.
%% 发送消息到帮派管理进程
send_to_family_manager(Msg) ->
    case erlang:whereis(family_manager_server) of
        undefined ->
            ?ERROR_MSG("family manager server does not exist,Msg=~w",[Msg]),
            ignore;
        FamilyManagerPId ->
            FamilyManagerPId ! Msg
    end.
%% 返回 PId|undefined
get_family_pid(FamilyId) ->
    case erlang:whereis(common_family:get_family_process_name(FamilyId)) of
        undefined ->
            case common_family:create_family_process(?FAMILY_PROCESS_OP_TYPE_INIT,FamilyId) of
                {ok,FamilyPId} ->
                    FamilyPId;
                _ ->
                    FamilyPId = undefined
            end;
        FamilyPId ->
            next
    end,
    FamilyPId.

%% 创建帮派进程
%% OpType 创建帮派类型,1初始化,2新创建
create_family_process(OpType,FamilyId) ->
    ProcessName = common_family:get_family_process_name(FamilyId),
    FamilyState = {OpType,FamilyId,ProcessName},
    ChildSpec = {FamilyId, {family_server,start_link,[FamilyState]},
                 temporary, 60000,worker,[family_server]},
    ?DEBUG("create_family_process FamilyState=~w",[FamilyState]),
    case supervisor:start_child(family_sup, ChildSpec) of
        {ok, FamilyPId} ->
            {ok,FamilyPId};
        {already_started,FamilyPId} ->
            {ok,FamilyPId};
        Error ->
            ?ERROR_MSG("create_family_process error:~w",[Error]),
            Error
    end.
%% 销毁帮派进程
destroy_family_process(FamilyId,Reason) ->
    ProcessName = common_family:get_family_process_name(FamilyId),
    case erlang:whereis(ProcessName) of
        undefined ->
            ok;
        FamilyPId ->
            erlang:monitor(process, FamilyPId),
            FamilyPId ! {destroy,Reason},
            receive
                {'DOWN', _, process, _, _} ->
                    ok
                after 
                    20000 ->
                    ?ERROR_MSG("destroy family process error,ProcessInfo=~w,Reason=~w", [erlang:process_info(FamilyPId),Reason])
            end,
            ok
    end.