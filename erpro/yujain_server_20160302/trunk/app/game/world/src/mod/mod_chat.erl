%% Author: markycai<tomarky.cai@gmail.com>
%% Created: 2013-12-10
%% Description: TODO: Add description to mod_chat
-module(mod_chat).

%%
%% Include files
%%
-include("mgeew.hrl").
%%
%% Exported Functions
%%
-export([role_online/1,
         role_offline/1,
         hook_level_up/3,
         handle/1,
         ban/3,
         unban/1]).


-export([set_ban/2,
         get_ban/1]).

%%
%% API Functions
%%

handle({RoleId,_Module,?CHAT_IN_CHANNEL,DataIn})->
    {ok,#r_role_world_state{gateway_pid=PId}} = mgeew_role:get_role_world_state(),
    do_chat_in_channel(DataIn,RoleId,PId);

handle({_Module,?CHAT_IN_CHANNEL,DataIn,RoleId,PId,_Line})->
    do_chat_in_channel(DataIn,RoleId,PId);

handle({broadcast_family,Module,Method,R})->
    do_broadcast_family(Module,Method,R);
handle({online_ban,RoleId,RoleBanInfo})->
    do_online_ban(RoleId,RoleBanInfo);
handle({online_unban,RoleId})->
    do_online_unban(RoleId).

    

%% 这是在玩家进程
do_chat_in_channel(DataIn,RoleId,PId)->
    #m_chat_in_channel_tos{channel_type=ChannelType,msg=Msg,msg_code=MsgCode} = DataIn,
    case catch do_chat_in_channel2(DataIn,RoleId) of
        {ok,RoleBase,SendToc,ConsumeEnergy}->
            do_chat_in_channel3(DataIn,RoleId,PId,RoleBase,SendToc,ConsumeEnergy);
        {error,ErrCode}->
            R = #m_chat_in_channel_toc{channel_type =ChannelType,msg = Msg,
                                       msg_code =MsgCode,err_code =ErrCode},
            common_misc:unicast(PId,?CHAT,?CHAT_IN_CHANNEL,R);
        {gm,MsgReturn,ChatRole}->
            R = #m_chat_in_channel_toc{role_info =ChatRole,
                                       channel_type =ChannelType,
                                       msg = MsgReturn,
                                       msg_type=?CHAT_MSG_TYPE_NORMAL},
            common_misc:unicast(PId,?CHAT,?CHAT_IN_CHANNEL,R)
    end.

do_chat_in_channel2(DataIn,RoleId)->
    #m_chat_in_channel_tos{channel_type=ChannelType,
                           msg=Msg,
                           msg_code=MsgCode,
                           msg_type=MsgType} = DataIn,
    case ChannelType of
        ?CHANNEL_TYPE_WORLD -> next;
        ?CHANNEL_TYPE_CATEGORY -> next;
        ?CHANNEL_TYPE_FAMILY -> next;
        ?CHANNEL_TYPE_TEAM -> next;
        ?CHANNEL_TYPE_MAP -> next;
        _ -> 
            ?THROW_ERR(?_RC_CHAT_IN_CHANNEL_003)
    end,
    {ok,RoleBase} = mod_role:get_role_base(RoleId),
    #p_role_base{level=Level,
                 role_name= RoleName,
                 category = Category,
                 family_id= FamilyId,
                 energy = Energy} = RoleBase,
    ChatRole = #p_chat_role{role_id=RoleId,
                            role_name =RoleName,
                            category=Category},
    Now = mgeew_role:get_now(),
    MessageInterval = cfg_chat:find({send_message_interval,ChannelType}),
    case get_last_chat_ts(RoleId) of
        undefined->
            next;
        TS->
            case Now > TS + MessageInterval of
                true->
                    next;
                false->
                    ?THROW_ERR(?_RC_CHAT_IN_CHANNEL_006)
            end
    end,
    case get_ban(RoleId) of
        {ok,RoleBan}->
            #r_ban_chat_user{time_end=TimeEnd} = RoleBan,
            case TimeEnd > Now of
                true->
                    ?THROW_ERR(?_RC_CHAT_IN_CHANNEL_001);
                false->
                    next
            end;
        _->
            next
    end,
    %%% 判断最小等级
    case cfg_chat:find({min_level,ChannelType}) of
        []->
            MinLevel = 0;
        MinLevel->
            next
    end,
    case MinLevel > Level of
        true->
            ?THROW_ERR(?_RC_CHAT_IN_CHANNEL_002);
        false->
            next
    end,
    %% 参数是否合法
    case Msg of
        ""->case cfg_chat:find({msg_code,MsgCode}) of
                true->
                    next;
                false->
                    ?THROW_ERR(?_RC_CHAT_IN_CHANNEL_003)
            end;
        _-> next
    end,
    case ChannelType of
        ?CHANNEL_TYPE_CATEGORY->
            case Category > 0 of
                true->ignore;
                false->?THROW_ERR(?_RC_CHAT_IN_CHANNEL_004)
            end;
        ?CHANNEL_TYPE_FAMILY->
            case FamilyId > 0 of
                true->
                    next;
                false-> 
                    ?THROW_ERR(?_RC_CHAT_IN_CHANNEL_005)
            end;
        _-> next
    end,
    %% 是否需要扣活力值
    case cfg_chat:find({consume_energy,ChannelType}) of
        [] ->
            ConsumeEnergy = 0;
        ConsumeEnergy ->
            next
    end,
    case Energy >= ConsumeEnergy of
        true ->
            next;
        _ ->
            ?THROW_ERR(?_RC_CHAT_IN_CHANNEL_008)
    end,
    SendToc = #m_chat_in_channel_toc{channel_type =ChannelType,
                                     msg = Msg,
                                     msg_code =MsgCode,
                                     role_info = ChatRole,
                                     msg_type =MsgType,
                                     ts = Now},
    {ok,RoleBase,SendToc,ConsumeEnergy}.

do_chat_in_channel3(DataIn,RoleId,_PId,RoleBase,SendToc,ConsumeEnergy) ->
    #p_role_base{category=Category,
                 family_id=FamilyId,
                 energy=Energy} = RoleBase,
    case ConsumeEnergy > 0 of
        true ->
            NewEnergy = Energy - ConsumeEnergy,
            mod_role:set_role_base(RoleId, RoleBase#p_role_base{energy=NewEnergy}),
            %% 记录活力值消耗日志
            LogTime = mgeew_role:get_now(),
            common_log:log_common({RoleId,?LOG_CONSUME_COMMON_CHAT_ENERGY,LogTime,Energy,ConsumeEnergy,""}),
            ok;
        _ ->
            next
    end,
    set_last_chat_ts(RoleId,mgeew_role:get_now()),
    #m_chat_in_channel_tos{channel_type=ChannelType} = DataIn,
    case ChannelType of
        ?CHANNEL_TYPE_WORLD->
            chat_misc:broadcast_to_world(?CHAT,?CHAT_IN_CHANNEL,SendToc);
        ?CHANNEL_TYPE_CATEGORY->
            chat_misc:broadcast_to_category(Category,?CHAT,?CHAT_IN_CHANNEL,SendToc);
        ?CHANNEL_TYPE_FAMILY->
            chat_misc:broadcast_to_family(FamilyId,?CHAT,?CHAT_IN_CHANNEL,SendToc);
        ?CHANNEL_TYPE_MAP->
            common_misc:send_to_role_map(RoleId, {mod,mod_map_chat,{send_message,{?CHAT,?CHAT_IN_CHANNEL,SendToc}}});
        _ ->
            ignore
    end,
    ok.
            
%% 注意！！这是在帮派进程
do_broadcast_family(Module,Method,R)->
    #r_family_state{family_id=FamilyId} = family_server:get_family_state(),
    {ok,#r_family{member_list=MemberList}} = mod_family:get_family(FamilyId),
    lists:foreach(
      fun(RoleId)->
              common_misc:unicast({role, RoleId},Module,Method,R)
      end, MemberList).

%% 玩家下线离开频道
role_offline(RoleId)->
    {ok,RoleBase} = mod_role:get_role_base(RoleId),
    #p_role_base{level=Level,category=Category} = RoleBase,
    %% 离开系统频道
    chat_misc:leave_channel(chat_misc:get_channel_system_name(),RoleId),
    
    case cfg_chat:find({min_level,?CHANNEL_TYPE_WORLD}) of
        []->WorldMinLevel = 0;
        WorldMinLevel ->next
    end,
    %% 离开世界频道
    case Level >= WorldMinLevel of
        true->
            chat_misc:leave_channel(chat_misc:get_channel_world_name(),RoleId);
        false->
            ignore
    end,
    %% 离开门派频道
    case Category > 0 of
        true->
            chat_misc:leave_channel(chat_misc:get_channel_category_name(Category),RoleId);
        false->ignore
    end.

%% 上线加入频道
role_online(RoleId)->
    {ok,RoleBase} = mod_role:get_role_base(RoleId),
    #p_role_base{level=Level,
                 category=Category,
                 family_id= FamilyId} = RoleBase,
    {ok,#r_role_world_state{gateway_pid=GatewayPId}} = mgeew_role:get_role_world_state(),
    %% 加入系统频道
    chat_misc:join_channel(chat_misc:get_channel_system_name(),RoleId,GatewayPId),
    ChannelList = [?CHANNEL_TYPE_SYSTEM,?CHANNEL_TYPE_MAP],
    
    case cfg_chat:find({min_level,?CHANNEL_TYPE_WORLD}) of
        []->WorldMinLevel = 0;
        WorldMinLevel ->next
    end,
    %% 加入世界频道
    case Level >= WorldMinLevel of
        true->
            chat_misc:join_channel(chat_misc:get_channel_world_name(),RoleId,GatewayPId),
            ChannelList1 = [?CHANNEL_TYPE_WORLD|ChannelList];
        false->ChannelList1 = ChannelList
    end,
    %% 加入门派频道
    case Category > 0 of
        true->
            chat_misc:join_channel(chat_misc:get_channel_category_name(Category),RoleId,GatewayPId),
            ChannelList2 = [?CHANNEL_TYPE_CATEGORY|ChannelList1];
        false->ChannelList2 = ChannelList1
    end,
    %% 加入帮派频道
    case FamilyId >  0 of
        true->ChannelList3 = [?CHANNEL_TYPE_FAMILY|ChannelList2];
        false->ChannelList3 = ChannelList2
    end,
    OnlineInfo = mgeew_role:get_online_info(),
    mgeew_role:set_online_info(OnlineInfo#m_role_online_info_toc{channel_list=ChannelList3}).


%% 升级加入世界频道
hook_level_up(RoleId,OldLevel,NewLevel)->
    MinLevel = cfg_chat:find({min_level,?CHANNEL_TYPE_WORLD}),
    case OldLevel < MinLevel 
        andalso NewLevel >= MinLevel of
        true->
            case erlang:whereis(common_misc:get_role_gateway_process_name(RoleId)) of
                undefined ->
                    next;
                PId ->
                    chat_misc:notice_join_channel(RoleId, ?CHANNEL_TYPE_WORLD),
                    chat_misc:join_channel(chat_misc:get_channel_world_name(),RoleId,PId)
            end;
        false->
            ignore
    end.
            
%% 禁言
ban(RoleId,Duration,Reason)->
    TimeStart = common_tool:now(),
    TimeEnd = TimeStart+Duration*60,
    RoleBanInfo = #r_ban_chat_user{role_id=RoleId,
                                   time_start=TimeStart,
                                   time_end=TimeEnd,
                                   duration=Duration, 
                                   reason=Reason},
    case erlang:whereis(common_misc:get_role_world_process_name(RoleId)) of
        undefined->
            db_api:dirty_write(?DB_BAN_CHAT_USER,RoleBanInfo);
        Pid->
            erlang:send(Pid, {mod,mod_chat,{online_ban,RoleId,RoleBanInfo}})
    end,
    common_broadcast:bc_send_msg_world(?BC_MSG_TYPE_CHAT, ?CHANNEL_TYPE_WORLD, Reason).
        
do_online_ban(RoleId,RoleBan)->
    set_ban(RoleId,RoleBan).

%% 解禁
unban(RoleId)->
    case erlang:whereis(common_misc:get_role_world_process_name(RoleId)) of
        undefined->
            db_api:dirty_delete(?DB_BAN_CHAT_USER,RoleId);
        Pid->
            erlang:send(Pid, {mod,mod_chat,{online_unban,RoleId}})
    end.

do_online_unban(RoleId)->
    erase({?DB_BAN_CHAT_USER,RoleId}),
    db_api:dirty_delete(?DB_BAN_CHAT_USER,RoleId).

get_ban(RoleId)->
    mod_role:get_dict({?DB_BAN_CHAT_USER,RoleId}).

set_ban(RoleId,RoleBan)->
    mod_role:set_dict({?DB_BAN_CHAT_USER,RoleId}, RoleBan).

%%
%% Local Functions
%%
get_last_chat_ts(RoleId)->
    erlang:get({last_chat_ts,RoleId}).

set_last_chat_ts(RoleId,TS)->
    erlang:put({last_chat_ts,RoleId},TS).
