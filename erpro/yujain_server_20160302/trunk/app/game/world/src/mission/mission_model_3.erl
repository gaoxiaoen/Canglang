%% Author: chixiaosheng
%% Created: 2011-4-8
%% Description: 打怪道具掉落模型
%%      model_status: 必须是3个Status
%%      listener：必须是两个Listener，一个怪物/一个道具
-module(mission_model_3).

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

%%打怪模型的第二个状态，该状态表示正在侦听怪物/道具
-define(MISSION_MODEL_3_STATUS_DOING, 1).

%%
%% API Functions
%%
%% 验证是否可接
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

%% 取消任务
cancel({RoleId,PId,MissionId,MissionBaseInfo,[PInfo,DataRecord]}) ->
    TransFun = 
        fun() ->
                Result = mission_model_common:common_cancel(RoleId,PId,MissionId,MissionBaseInfo,DataRecord,PInfo),
                %% 删除此任务侦听器
                {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
                NewRoleMission = mod_mission_tool:del_mission_listener(RoleMission, MissionBaseInfo),
                mod_mission:t_set_role_mission(RoleId, NewRoleMission),
                Result
        end,
    ?DO_TRANS_FUN(TransFun).


%% 执行任务 接-做-交
do({RoleId,PId,MissionId,MissionBaseInfo,[PInfo,DataRecord]}) ->
    TransFun = 
        fun() ->
                case PInfo#p_mission_info.current_model_status =:= ?MISSION_MODEL_3_STATUS_DOING of
                    true ->
                        erlang:throw({error,?_RC_MISSION_DO_011,""});
                    _ ->
                        ignore
                end,
                NewPInfo = init_mission_listener(PInfo,RoleId,MissionBaseInfo),
                mission_model_common:common_do(RoleId,PId,MissionId,MissionBaseInfo,DataRecord,NewPInfo)
        end,
    ?DO_TRANS_FUN(TransFun).


%% 初始化任务侦听器
%% 返回 #p_mission_info
init_mission_listener(PInfo,RoleId,MissionBaseInfo) ->
    #p_mission_info{current_model_status = CurrentModelStatus} = PInfo,
    #r_mission_base_info{max_model_status = MaxModelStatus,
                         listener_list = PListenerList} = MissionBaseInfo,
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    if CurrentModelStatus =:= ?MISSION_MODEL_STATUS_FIRST ->
           ListenerList = 
               lists:foldl(
                 fun(PListenerInfo,AccListenerList) -> 
                         case PListenerInfo#r_mission_base_listener.type of
                             ?MISSION_LISTENER_TYPE_MONSTER -> %% 只添加怪物侦听
                                 ListenerInfo = #p_mission_listener{type=PListenerInfo#r_mission_base_listener.type,
                                                                    sub_type=PListenerInfo#r_mission_base_listener.sub_type,
                                                                    value=PListenerInfo#r_mission_base_listener.value,
                                                                    need_num=PListenerInfo#r_mission_base_listener.need_num,
                                                                    current_num=0},
                                 [ListenerInfo|AccListenerList];
                             _ ->
                                 AccListenerList
                         end
                 end, [], PListenerList),
           NewRoleMission = mod_mission_tool:add_mission_listener(RoleMission, MissionBaseInfo),
           mod_mission:t_set_role_mission(RoleId, NewRoleMission),
           PInfo#p_mission_info{listener_list = ListenerList};
       CurrentModelStatus =:= MaxModelStatus -> %% 任务完成，删除侦听器
           NewRoleMission = mod_mission_tool:del_mission_listener(RoleMission, MissionBaseInfo),
           mod_mission:t_set_role_mission(RoleId, NewRoleMission),
           PInfo;
       true ->
           PInfo
    end.

%% 侦听器触发
%% ListenerInfo 结构 #r_mission_listener
%% PInfo 结构 #p_mission_info
%% 返回 {ok,NewListenerInfo,NewPInfo} | erlang:throw({error,OpCode,OpReason})
listener_trigger({RoleId,PId,MissionId,MissionBaseInfo,[ListenerInfo,PInfo]}) ->
    #p_mission_info{current_model_status = CurrentModelStatus,listener_list = ListenerList} = PInfo,
    #r_mission_base_info{max_model_status = MaxModelStatus} = MissionBaseInfo,
    case CurrentModelStatus =:= MaxModelStatus of
        true ->
            {ok,ignore};
        _ ->
            TransFun = 
                fun() ->
                        do_listener_trigger(RoleId,PId,MissionId,MissionBaseInfo,ListenerInfo,PInfo,ListenerList)
                end,
            ?DO_TRANS_FUN(TransFun)
    end.

%% 打死怪物掉落道具
do_listener_trigger(RoleId,PId,MissionId,MissionBaseInfo,ListenerInfo,PInfo,PListenerList) ->
    #r_mission_base_info{listener_list = ListenerBaseInfoList} = MissionBaseInfo,
    ItemListenerBaseInfo = lists:keyfind(?MISSION_LISTENER_TYPE_PROP, #r_mission_base_listener.type, ListenerBaseInfoList),
    ItemPListenerInfo = lists:keyfind(?MISSION_LISTENER_TYPE_PROP, #p_mission_listener.type, PListenerList),
    #r_mission_base_listener{sub_type = ItemTypeId,value = Value} = ItemListenerBaseInfo,
    %% 打怪掉落只能是掉落 道具
    case cfg_item:find(ItemTypeId) of
        [_R] ->
            next;
        _ ->
            erlang:throw({error,?_RC_MISSION_DO_012,""})
    end,
    random:seed(erlang:now()),
    case Value > common_tool:random(1, 10000) of
        true -> %% 需要掉落道具
            CreateInfo = #r_goods_create_info{via=?GOODS_VIA_MISSION_MONSTER,
                                              type_id = ItemTypeId,item_type = ?TYPE_ITEM,
                                              item_num = 1},
            {ok,GoodsList,LogGoodsList} = mod_bag:t_create_goods(RoleId, CreateInfo),
            %% 记录日志
            LogFunc = 
                fun() ->
                        {ok,RoleBase} = mod_role:get_role_base(RoleId),
                        LogTime = common_tool:now(),
                        common_log:log_goods_list({RoleBase,?LOG_GAIN_GOODS_DO_MISSION,LogTime,LogGoodsList,""}),
                        common_misc:send_role_goods_change(PId, GoodsList, [])
                end,
            mod_mission:add_mission_func(RoleId, LogFunc),
             case ItemPListenerInfo#p_mission_listener.current_num + 1 > ItemPListenerInfo#p_mission_listener.need_num of
                 true ->
                     CurrentNum = ItemPListenerInfo#p_mission_listener.need_num;
                 _ ->
                     CurrentNum = ItemPListenerInfo#p_mission_listener.current_num + 1
            end,
            NewItemPListenerInfo = ItemPListenerInfo#p_mission_listener{current_num = CurrentNum};
        _ ->
            NewItemPListenerInfo = ItemPListenerInfo
    end,
    
    NewPListenerList = [NewItemPListenerInfo|lists:keydelete(ItemPListenerInfo#p_mission_listener.type,#p_mission_listener.type,PListenerList)],
    NewPInfo = PInfo#p_mission_info{listener_list = NewPListenerList},
    
    case NewItemPListenerInfo#p_mission_listener.current_num >= NewItemPListenerInfo#p_mission_listener.need_num of
        true -> %% 任务状态完成
            NewPInfo2 = mission_model_common:change_model_status(RoleId, PId, MissionId, MissionBaseInfo, NewPInfo, +1),
            NewIdList = lists:delete(MissionId,ListenerInfo#r_mission_listener.mission_id_list),
            NewListenerInfo = ListenerInfo#r_mission_listener{mission_id_list = NewIdList};
        _ ->
            NewPInfo2 = NewPInfo,
            NewListenerInfo = ListenerInfo
    end,
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    case NewListenerInfo#r_mission_listener.mission_id_list of
        [] ->
            NewListenerList = lists:keydelete(ListenerInfo#r_mission_listener.key, #r_mission_listener.key, RoleMission#r_role_mission.listener_list);
        _ ->
            NewListenerList = [NewListenerInfo|lists:keydelete(ListenerInfo#r_mission_listener.key, #r_mission_listener.key, RoleMission#r_role_mission.listener_list)]
    end,
    MissionList = [NewPInfo2|lists:keydelete(PInfo#p_mission_info.id, #p_mission_info.id, RoleMission#r_role_mission.mission_list)],
    NewRoleMission = RoleMission#r_role_mission{listener_list = NewListenerList,mission_list = MissionList},
    mod_mission:t_set_role_mission(RoleId, NewRoleMission),
    {ok,NewListenerInfo,NewPInfo2}.
                                                                         


