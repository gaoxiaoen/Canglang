%% Author: chixiaosheng
%% Created: 2011-4-5
%% Description: 对话模型
%%      model_status: 允许多个
%%      listener：纯对话，没有侦听器
-module(mission_model_1).

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
                %% 第一个任务
                [FristMissIdList] = common_config_dyn:find(mission_etc,first_mission_id),
                case lists:member(MissionId, FristMissIdList) of
                    true-> %% 写日志
                        Func = 
                            fun() ->
                                    {ok,RoleBase} = mod_role:get_role_base(RoleId),
                                    LogRoleFollow=#r_log_role_follow{account_name = RoleBase#p_role_base.account_name,
                                                                     account_via = RoleBase#p_role_base.account_via, 
                                                                     role_id = RoleId,
                                                                     role_name = RoleBase#p_role_base.role_name,
                                                                     mtime = common_tool:now(),
                                                                     step = ?ROLE_FOLLOW_STEP_6,
                                                                     ip = RoleBase#p_role_base.last_login_ip},
                                    common_log:insert_log(role_follow, LogRoleFollow)
                            end,
                        mod_mission:add_mission_func(RoleId, Func);
                    _ ->
                        ignore
                end,
                mission_model_common:common_do(RoleId,PId,MissionId,MissionBaseInfo,DataRecord,PInfo)
        end,
    ?DO_TRANS_FUN(TransFun).

%% 侦听器触发
%% ListenerInfo 结构 #r_mission_listener
%% PInfo 结构 #p_mission_info
%% 返回 {ok,NewListenerInfo,NewPInfo} | erlang:throw({error,OpCode,OpReason})
listener_trigger({_RoleId,_PId,_MissionId,_MissionBaseInfo,[_ListenerInfo,_PInfo]}) -> 
    {ok,ignore}.
