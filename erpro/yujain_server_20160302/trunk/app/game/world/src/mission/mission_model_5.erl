%% Author: caochuncheng2002@gmail.com
%% Created: 2013-7-4
%% Description: 指定接下来连接的任务id
%% 配置说明：
%% 需要二个 model_status 状态
%% 不需要任务侦听配置
%% 第二个 model_status 需要特殊配置
-module(mission_model_5).

%%
%% Include files
%%
-include("mgeew.hrl").  
%%
%% Exported Functions
%%
-export([
         auth_accept/1,
         do/1,
         cancel/1,
         listener_trigger/1,
         init_pinfo/1]).

%%
%% API Functions
%%
%%@doc 验证是否可接
auth_accept({RoleId,_PId,_MissionId,MissionBaseInfo,[_PInfo]}) -> 
    mod_mission_auth:auth_accept(RoleId,MissionBaseInfo).

%% 初始化任务pinfo
%% 返回#p_mission_info{} | false
init_pinfo({RoleId,_PId,MissionId,MissionBaseInfo,[OldPInfo]}) -> 
    case catch mod_mission_auth:auth_show(RoleId, MissionBaseInfo) of
        {error,OpCode,OpReason} ->
            ?ERROR_MSG("~ts,RoleId=~w,MissionId=~w,OpCode=~w,OpReason=~w",[?_LANG_LOCAL_008,RoleId,MissionId,OpCode,OpReason]),
            false;
        _ ->
            mission_model_common:init_pinfo(RoleId, OldPInfo, MissionBaseInfo)
    end.

%%@doc 取消任务
cancel({RoleId,PId,MissionId,MissionBaseInfo,[PInfo,DataRecord]}) ->
    TransFun = 
        fun() ->
                mission_model_common:common_cancel(RoleId,PId,MissionId,MissionBaseInfo,DataRecord,PInfo)
        end,
    ?DO_TRANS_FUN(TransFun).
    

%%@doc 执行任务 接-做-交
do({RoleId,PId,MissionId,MissionBaseInfo,[PInfo,DataRecord]}) ->
    TransFun = 
        fun() ->
                mission_model_common:common_do(RoleId,PId,MissionId,MissionBaseInfo,DataRecord,PInfo)
        end,
    ?DO_TRANS_FUN(TransFun).

%% 侦听器触发
%% ListenerInfo 结构 #r_mission_listener
%% PInfo 结构 #p_mission_info
%% 返回 {ok,NewListenerInfo,NewPInfo} | erlang:throw({error,OpCode,OpReason})
listener_trigger({_RoleId,_PId,_MissionId,_MissionBaseInfo,[_ListenerInfo,_PInfo]}) -> 
    {ok,ignore}.

