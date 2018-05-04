%%%-------------------------------------------------------------------
%%% File        :common_broadcast.erl
%%% @doc
%%%     通用的消息广播接口
%%% @end
%%%-------------------------------------------------------------------
-module(common_broadcast).

-include("common.hrl").
-include("common_server.hrl").

-export([
         reset_admin_message/0,
         del_all_admin_message/0,
         del_all_game_message/0,
         reset_config_message/0,
         del_all_config_message/0
        ]).

%% 消息广播接口
-export([
         bc_send_msg_world/3,
         bc_send_msg_category/4,
         bc_send_msg_family/4,
         bc_send_msg_team/4,
         
         bc_send_msg_role/3,
         bc_send_msg_role/4,
         
         bc_send_cycle_msg_world/6,
         bc_send_cycle_msg_category/7,
         bc_send_cycle_msg_family/7,
         bc_send_cycle_msg_team/7,
         bc_send_cycle_msg_role/7,
         
         bc_send_msg_world_include_goods/7,
         bc_send_msg_category_include_goods/8,
         bc_send_msg_family_include_goods/8,
         bc_send_msg_team_include_goods/8,
         
         bc_send_admin_message/10
         ]).

%% 世界广播消息
-spec
bc_send_msg_world(Type,SubType,Msg) -> ok when
    Type :: bc_message_type(),
    SubType :: ?BC_MSG_SUB_TYPE_NONE | chat_channel_type(),
    Msg :: string().
bc_send_msg_world(Type,SubType,Msg) ->
    TOC = #m_broadcast_general_toc{type=Type, sub_type=SubType, msg=Msg},
    chat_misc:broadcast_to_world(?BROADCAST, ?BROADCAST_GENERAL, TOC).
%% 世界广播消息并附带物品信息
-spec 
bc_send_msg_world_include_goods(Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList) -> ok when
    Type :: bc_message_type(),
    SubType :: ?BC_MSG_SUB_TYPE_NONE | chat_channel_type(),
    Msg :: string(),
    RoleId :: integer(),
    RoleName :: binary(),
    Sex :: ?MALE | ?FEMALE,
    GoodsList :: #p_goods{} | [#p_goods{}].
bc_send_msg_world_include_goods(Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList) ->
    case erlang:whereis(chat_goods_cache_server) of
        undefined ->
            ?ERROR_MSG("mgeec goods cache server does not exist.", []);
        PID ->
            PID ! {bc_send_msg_world, Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList}
    end.
%% 广播门派成员消息
-spec 
bc_send_msg_category(Category,Type,SubType,Msg) -> ok when
    Category :: integer(),
    Type :: bc_message_type(),
    SubType :: ?BC_MSG_SUB_TYPE_NONE | chat_channel_type(),
    Msg :: string().
bc_send_msg_category(Category, Type, SubType, Msg) ->
    TOC = #m_broadcast_general_toc{type=Type, sub_type=SubType, msg=Msg},
    chat_misc:broadcast_to_category(Category, ?BROADCAST, ?BROADCAST_GENERAL, TOC).

%% 广播门派成员消息，并附带物品列表信息
-spec 
bc_send_msg_category_include_goods(Category, Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList) -> ok when
    Category :: integer(),
    Type :: bc_message_type(),
    SubType :: ?BC_MSG_SUB_TYPE_NONE | chat_channel_type(),
    Msg :: string(),
    RoleId :: integer(),
    RoleName :: binary(),
    Sex :: ?MALE | ?FEMALE,
    GoodsList :: #p_goods{} | [#p_goods{}].
bc_send_msg_category_include_goods(Category, Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList) ->
    case erlang:whereis(chat_goods_cache_server) of
        undefined ->
            ?ERROR_MSG("mgeec goods cache server does not exist.", []);
        PID ->
            PID ! {bc_send_msg_category, Category, Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList}
    end.

%% 广播帮派成员消息，并附带物品列表信息
-spec 
bc_send_msg_family_include_goods(FamilyId, Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList) -> ok when
    FamilyId :: integer(),
    Type :: bc_message_type(),
    SubType :: ?BC_MSG_SUB_TYPE_NONE | chat_channel_type(),
    Msg :: string(),
    RoleId :: integer(),
    RoleName :: binary(),
    Sex :: ?MALE | ?FEMALE,
    GoodsList :: #p_goods{} | [#p_goods{}].
bc_send_msg_family_include_goods(FamilyId, Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList) ->
    case erlang:whereis(chat_goods_cache_server) of
        undefined ->
            ?ERROR_MSG("mgeec goods cache server does not exist.", []);
        PID ->
            PID ! {bc_send_msg_family, FamilyId, Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList}
    end.

%% 广播队伍成员消息，并附带物品列表信息
-spec 
bc_send_msg_team_include_goods(TeamId, Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList) -> ok when
    TeamId :: integer(),
    Type :: bc_message_type(),
    SubType :: ?BC_MSG_SUB_TYPE_NONE | chat_channel_type(),
    Msg :: string(),
    RoleId :: integer(),
    RoleName :: binary(),
    Sex :: ?MALE | ?FEMALE,
    GoodsList :: #p_goods{} | [#p_goods{}].
bc_send_msg_team_include_goods(TeamId, Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList) ->
    case erlang:whereis(chat_goods_cache_server) of
        undefined ->
            ?ERROR_MSG("mgeec goods cache server does not exist.", []);
        PID ->
            PID ! {bc_send_msg_team, TeamId, Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList}
    end.

%% 广播给帮派成员消息
-spec 
bc_send_msg_family(FamilyId,Type,SubType,Msg) -> ok when
    FamilyId :: integer(),
    Type :: bc_message_type(),
    SubType :: ?BC_MSG_SUB_TYPE_NONE | chat_channel_type(),
    Msg :: string().
bc_send_msg_family(FamilyId, Type, SubType, Msg) ->
    TOC = #m_broadcast_general_toc{type=Type, sub_type=SubType, msg=Msg},
    chat_misc:broadcast_to_family(FamilyId, ?BROADCAST, ?BROADCAST_GENERAL, TOC).

%% 广播给队伍成员消息
-spec 
bc_send_msg_team(TeamId,Type,SubType,Msg) -> ok when
    TeamId :: integer(),
    Type :: bc_message_type(),
    SubType :: ?BC_MSG_SUB_TYPE_NONE | chat_channel_type(),
    Msg :: string().
bc_send_msg_team(TeamId,Type,SubType,Msg) ->
    TOC = #m_broadcast_general_toc{type=Type, sub_type=SubType, msg=Msg},
    chat_misc:broadcast_to_team(TeamId, ?BROADCAST, ?BROADCAST_GENERAL, TOC).

%% 广播消息给一个玩家，或多个玩家
-spec
bc_send_msg_role(RoleId,Type,Msg) -> ok when
    RoleId ::integer(),
    Type :: bc_message_type(),
    Msg :: string().
bc_send_msg_role(RoleId,Type,Msg) when erlang:is_integer(RoleId)->
    bc_send_msg_role([RoleId],Type,?BC_MSG_SUB_TYPE_NONE,Msg);
bc_send_msg_role(RoleIdList,Type,Msg) ->
    bc_send_msg_role(RoleIdList,Type,?BC_MSG_SUB_TYPE_NONE,Msg).

%% 广播消息给一个玩家，或多个玩家
-spec
bc_send_msg_role(RoleId,Type,SubType,Msg) -> ok when
    RoleId ::integer(),
    Type :: bc_message_type(),
    SubType :: ?BC_MSG_SUB_TYPE_NONE | chat_channel_type(),
    Msg :: string().
bc_send_msg_role(RoleId,Type,SubType,Msg) when erlang:is_integer(RoleId) ->
    bc_send_msg_role([RoleId],Type,SubType,Msg);
bc_send_msg_role(RoleIdList,Type,SubType,Msg) ->
    TOC = #m_broadcast_general_toc{type=Type, sub_type=SubType, msg=Msg},
    case RoleIdList of
        [] ->
            next;
        _ ->
            [begin 
                 common_misc:unicast({role,RoleId}, ?BROADCAST, ?BROADCAST_GENERAL, TOC),
                 ok
             end || RoleId <- RoleIdList]
    end,
    ok.

%% Type 消息类型
%% SubType 消息子类型 
%% Msg消息内容 ,
%% StartTime开始时间,格式为：common_tool:now()
%% EndTime结束时间,格式为：common_tool:now()
%% IntervalTime间隔时间 单位：秒
bc_send_cycle_msg_world(Type,SubType,Msg,StartTime,EndTime,IntervalTime) ->
    Record = #r_broadcast_message_param{msg_type = Type,msg_sub_type = SubType,msg = Msg,
                                        start_time = StartTime,end_time = EndTime,interval = IntervalTime,
                                        role_id_list = [],is_world = true,category = 0,
                                        famliy_id = 0,team_id = 0},
    bc_send_game_message(Record).
bc_send_cycle_msg_category(Category,Type,SubType,Msg,StartTime,EndTime,IntervalTime) ->
    Record = #r_broadcast_message_param{msg_type = Type,msg_sub_type = SubType,msg = Msg,
                                        start_time = StartTime,end_time = EndTime,interval = IntervalTime,
                                        role_id_list = [],is_world = false,category = Category,
                                        famliy_id = 0,team_id = 0},
    bc_send_game_message(Record).
bc_send_cycle_msg_family(FamilyId,Type,SubType,Msg,StartTime,EndTime,IntervalTime) ->
    Record = #r_broadcast_message_param{msg_type = Type,msg_sub_type = SubType,msg = Msg,
                                        start_time = StartTime,end_time = EndTime,interval = IntervalTime,
                                        role_id_list = [],is_world = false,category = 0,
                                        famliy_id = FamilyId,team_id = 0},
    bc_send_game_message(Record).
bc_send_cycle_msg_team(TeamId,Type,SubType,Msg,StartTime,EndTime,IntervalTime) ->
    Record = #r_broadcast_message_param{msg_type = Type,msg_sub_type = SubType,msg = Msg,
                                        start_time = StartTime,end_time = EndTime,interval = IntervalTime,
                                        role_id_list = [],is_world = false,category = 0,
                                        famliy_id = 0,team_id = TeamId},
    bc_send_game_message(Record).
bc_send_cycle_msg_role(RoleId,Type,SubType,Msg,StartTime,EndTime,IntervalTime) when erlang:is_integer(RoleId) ->
    bc_send_cycle_msg_role([RoleId],Type,SubType,Msg,StartTime,EndTime,IntervalTime);
bc_send_cycle_msg_role(RoleIdList,Type,SubType,Msg,StartTime,EndTime,IntervalTime) ->
    case RoleIdList of
        [] ->
            ignore;
        _ ->
            Record = #r_broadcast_message_param{msg_type = Type,msg_sub_type = SubType,msg = Msg,
                                                start_time = StartTime,end_time = EndTime,interval = IntervalTime,
                                                role_id_list = RoleIdList,is_world = false,category = 0,
                                                famliy_id = 0,team_id = 0},
            bc_send_game_message(Record)
    end.
bc_send_game_message(Msg) ->
    case erlang:is_record(Msg, r_broadcast_message_param) of
        true ->
            catch erlang:send(mgeew_broadcast_server,{game_send_message,Msg});
        _ ->
            ignore
    end.

%% 后台消息广播记录定义
%% id 消息唯一标记
%% msg_type 消息类型 1:广播消息，在底部显示 2:聊天频道
%% msg_sub_type 消息子类型 msg_type=2 时 msg_sub_type 对应聊天频道的频道类型
%% send_strategy 发送策略 0:立即,1:特定日期时间范围, 2:星期 3:开服后,4:持续一段时间内间隔发送
%% start_date 如果是日期，即格式为：yyyy-MM-dd  开服后发送策略表示开始天数 星期发送策略即表示开始星期几
%% end_date 如果是日期，即格式为：yyyy-MM-dd 开服后发送策略表示结束天数 星期发送策略即表示结束星期几
%% start_time 如果为时间，即格式为：HH:mm:ss
%% end_time 如果为时间，即格式为：HH:mm:ss
%% interval 间隔时间 单位：秒
%% msg 消息内容
bc_send_admin_message(Id,MsgType,MsgSubType,SendStrategy,StartDate,EndDate,StartTime,EndTime,Interval,Msg) ->
    SendMsg = #r_broadcast_message{id = Id,
                                   msg_type = MsgType,
                                   msg_sub_type = MsgSubType,
                                   send_strategy = SendStrategy,
                                   start_date = StartDate,
                                   end_date = EndDate,
                                   start_time = StartTime,
                                   end_time = EndTime,
                                   interval = Interval,
                                   msg = Msg},
    erlang:send(mgeew_broadcast_server,{admin_send_message,SendMsg}).

%% 手动操作方法
reset_admin_message() ->
    erlang:send(mgeew_broadcast_server,{admin_reset_message}).
del_all_admin_message() ->
    erlang:send(mgeew_broadcast_server,{admin_del_all_message}).

del_all_game_message() ->
    erlang:send(mgeew_broadcast_server,{game_del_all_message}).

reset_config_message() ->
    erlang:send(mgeew_broadcast_server,{config_reset_message}).
del_all_config_message() ->
    erlang:send(mgeew_broadcast_server,{config_del_all_message}).
