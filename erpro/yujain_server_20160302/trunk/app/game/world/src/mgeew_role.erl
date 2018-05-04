%%%-------------------------------------------------------------------
%%% File        :mgeew_role.erl
%%% @doc
%%%     玩家进程
%%% @end
%%%-------------------------------------------------------------------
-module(mgeew_role).

-behavior(gen_server).

-include("mgeew.hrl").

-export([start_link/1, init/1]).

-export([handle_info/2, handle_cast/2, handle_call/3, terminate/2, code_change/3]).

-export([get_now2/0,
         get_now/0,
         get_role_world_state/0,
         send/2,
         persistent_now/1
         ]).

-export([set_online_info/1,
         get_online_info/0]).

-define(LOOP_MILLISECONDS_1000,1000).
-define(LOOP_MILLISECONDS_200,200).

-define(role_state_auth_key,1).         %% 等待auth key
-define(role_state_map_enter,2).        %% 等待map enter
-define(role_state_running,3).          %% 运行状态
-define(role_state_offline,4).          %% 玩家下线状态
-define(role_state_quick_key,5).        %% 快速验证KEY成功

-define(role_process_protect_time,600). %% 玩家下线状态保持

-record(state,{}).

start_link({GatewayPId, Gateway, ClientIP, RoleId, Info}) ->
    RolePName = common_misc:get_role_world_process_name(RoleId),
    case gen_server:start_link({local, RolePName},?MODULE, [{GatewayPId, Gateway, ClientIP, RoleId, Info}],[]) of
        {ok, PId} ->
            {ok, PId};
        {error,{already_started, PId}} ->
            {ok, PId};
        Other ->
            ?ERROR_MSG("~ts:~w", [?_LANG_ROLE_005, Other]),
            throw(Other)
    end.

init([{GatewayPId, Gateway, ClientIP, RoleId, Info}]) ->
    erlang:process_flag(trap_exit, true),
    Now = common_tool:now(),
    Now2 = common_tool:now2(),
    erlang:put(milliseconds_1000, Now),
    erlang:put(milliseconds_200, Now2),
    {AccountName}=Info,
    QuickKey = common_misc:get_quick_key({AccountName,RoleId,Now}),
    common_role:init_role_dict(RoleId),
    set_role_world_state(#r_role_world_state{role_id = RoleId,
                                             gateway_pid = GatewayPId,
                                             gateway = Gateway,
                                             client_ip = ClientIP,
                                             state = ?role_state_auth_key,
                                             info = Info,
                                             quick_key=QuickKey}),
    erlang:send_after(?LOOP_MILLISECONDS_1000, erlang:self(), loop_milliseconds_1000),
    erlang:send_after(?LOOP_MILLISECONDS_200, erlang:self(), loop_milliseconds_200),
    {ok, #state{}}.

persistent_now(RoleId)->
    send(RoleId,{persistent_now,RoleId}).

send(RoleId,Info)->
    ?TRY_CATCH(erlang:send(common_misc:get_role_world_process_name(RoleId),Info),Err).

%% 进程结束
handle_info({'EXIT', _PId, _Reason}, State) ->
    {stop, normal, State};

handle_info(Info,State) ->
    ?DO_HANDLE_INFO(Info, State),
    {noreply, State}.
    
handle_cast(_Info, State) ->
    {noreply, State}.

%% 玩家m_auth_key_tos初始化数据
handle_call({init_role_info_auth,Info}, _From, State) ->
    Reply = init_role_info_auth(Info),
    {reply, Reply, State};
%% 重新登录时，玩家进程还存在，获取登录数据
handle_call({get_auth_key_data,Info}, _From, State) ->
    Reply = get_auth_key_data(Info),
    {reply, Reply, State};
%% 玩家m_map_enter_tos初始化数据
handle_call({init_role_info_first_enter,Info}, _From, State) ->
    Reply = init_role_info_first_enter(Info),
    {reply, Reply, State};
%% 快速登录quick_key验证
handle_call({auth_quick_key,Info}, _From, State) ->
    Reply = do_auth_quick_key(Info),
    {reply, Reply, State};

handle_call(_Info, _From, State) ->
    {reply, ok, State}.

terminate(Reason, _State) ->
    ?TRY_CATCH(do_terminate(Reason),ExitErr),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


-define(DO_HANDLE_MOD(Module,Mod),
        do_handle_info({Module, Method, DataRecord, RoleId, PId, Line}) ->
        Mod:handle({Module, Method, DataRecord, RoleId, PId, Line})).

do_handle_info(loop_milliseconds_200) ->
    erlang:send_after(?LOOP_MILLISECONDS_200, erlang:self(), loop_milliseconds_200),
    erlang:put(milliseconds_200, common_tool:now2()),
    loop_ms();

%%每秒大循环
do_handle_info(loop_milliseconds_1000) ->
    erlang:send_after(?LOOP_MILLISECONDS_1000, erlang:self(), loop_milliseconds_1000),
    erlang:put(milliseconds_1000, common_tool:now()),
    loop();

do_handle_info({mod,Module,Info}) ->
    Module:handle(Info);

do_handle_info({role_online}) ->
    do_role_online();

%% 服务器关服，玩家进程直接关闭
do_handle_info({role_offline,server_shutdown}) ->
    erlang:exit(erlang:self(), server_shutdown);
%% 玩家下线
do_handle_info({role_offline,Reason}) ->
    do_role_offline(Reason);
%% 立即关闭玩家进程
do_handle_info({now_close,Reason}) ->
    erlang:exit(erlang:self(), Reason);

%% 异步执行函数
do_handle_info({async_exec, Fun, Args}) ->
    ?ERROR_MSG("Fun=~w,Args=~w",[Fun,Args]),
    ?TRY_CATCH(apply(Fun,Args),ErrFun),
    ok;

%% 执行函数处理管理使用
do_handle_info({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("~w",[Ret]),
    ok;

do_handle_info({persistent_now,RoleId})->
    do_role_persistent(RoleId);

do_handle_info(Info) ->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).

%% 200毫秒循环
loop_ms() ->
    {ok,#r_role_world_state{role_id=RoleId,
                            state=State}}=get_role_world_state(),
    case State == ?role_state_running
         orelse State == ?role_state_offline of
        true ->
            ?TRY_CATCH(hook_role:hook_loop_ms(RoleId),ErrHook);
        _ ->
            next
    end,
    ok.
    
%% 每秒大循环
loop() ->
    {ok,#r_role_world_state{role_id=RoleId,
                            state=State,
                            offline_time=OfflineTime}}=get_role_world_state(),
    Now = get_now(),
    case State of
        ?role_state_offline ->
            case OfflineTime =/= 0 andalso Now - OfflineTime > ?role_process_protect_time of
                true ->
                    ?ERROR_MSG("role offline time > protect time kill role process.RoleId=~w,OfflineTime=~w",[RoleId,OfflineTime]),
                    erlang:exit(erlang:self(), role_offline);
                _ ->
                    next
            end;
        _ ->
            ignroe
    end,
    case State == ?role_state_running
         orelse State == ?role_state_offline of
        true ->
            ?TRY_CATCH(hook_role:hook_loop(RoleId),ErrHook);
        _ ->
            next
    end,
    ok.

%% 玩家进入地图之后，推送给前端的游戏数据
%% 即玩家登录之后需要自动推送给前端的数据缓存
%% 通过不同功能的处理生成相应的数据，使用#m_role_online_info_toc{}发送到前端
init_online_info()->
    set_online_info(#m_role_online_info_toc{}).
set_online_info(RoleOnlineInfo)->
    erlang:put(online_info,RoleOnlineInfo).
get_online_info()->
    erlang:get(online_info).
send_online_info(GatewayPid)->
   RoleOnlineInfo = erlang:erase(online_info),
   common_misc:unicast(GatewayPid, ?ROLE,?ROLE_ONLINE_INFO,RoleOnlineInfo).

%% 玩家上线
do_role_online() ->
    init_online_info(),
    %% 上线初始化随机数种子
    random:seed(erlang:now()),
    {ok,#r_role_world_state{gateway_pid= GatewayPid,role_id = RoleId,client_ip = ClientIp}} = get_role_world_state(),
    ?TRY_CATCH(do_log_role_login(RoleId, ClientIp),ErrLog),
    ?TRY_CATCH(hook_role:hook_role_online(RoleId),ErrHook),
    send_online_info(GatewayPid),
    ok.
%% 玩家下线
do_role_offline(Reason) ->
    {ok,#r_role_world_state{state=State} = RoleState} = get_role_world_state(),
    ?ERROR_MSG("role offline RoleState=~w,Reason=~w",[RoleState,Reason]),
    case State of
        ?role_state_running ->
            Now = get_now(),
            NewRoleState = RoleState#r_role_world_state{state=?role_state_offline,
                                                        gateway_pid=undefined,
                                                        gateway=0,
                                                        offline_time=Now},
            set_role_world_state(NewRoleState);
        ?role_state_offline ->
            ignore;
        ?role_state_quick_key ->
            Now = get_now(),
            NewRoleState = RoleState#r_role_world_state{state=?role_state_offline,
                                                        gateway_pid=undefined,
                                                        gateway=0,
                                                        offline_time=Now},
            set_role_world_state(NewRoleState);
        _ ->
            erlang:exit(erlang:self(), Reason)
    end,
    ok.


get_now() ->
    erlang:get(milliseconds_1000).
get_now2() ->
    erlang:get(milliseconds_200).

%% --------------------------------------------------------------------
%% 进程字典函数定义
%% --------------------------------------------------------------------
%% 玩家逻辑进程数据
get_role_world_state() ->
   case erlang:get(role_world_state) of
       undefined ->
           {error,not_found};
       RoleState ->
           {ok,RoleState}
   end.
set_role_world_state(RoleState) ->
    erlang:put(role_world_state, RoleState).

%% 缓存玩家auth key时获取的用户数据
get_cache_role_data() ->
    erlang:get(auth_cache_role_data).
set_cache_role_data(RoleData) ->
    erlang:put(auth_cache_role_data,RoleData).
erase_cache_role_data() ->
    erlang:erase(auth_cache_role_data).

%% 是否是第一次进入游戏
get_role_first_enter_flag() ->
    case erlang:get(role_first_enter_flag) of
        undefined ->
            false;
        Flag ->
            Flag
    end.
set_role_first_enter_flag(Flag) ->
    erlang:put(role_first_enter_flag,Flag).

%% --------------------------------------------------------------------
%% 玩家上线和下线处理函
%% --------------------------------------------------------------------
%% 初始化玩家数据 m_auth_key_tos
init_role_info_auth({_AccountName,RoleId,IP,DeviceId}) ->
    NowSeconds = common_tool:now(),
    {ok,RoleBase} = common_misc:get_role_base(RoleId),
    {ok,RoleAttr} = common_misc:get_role_attr(RoleId),
    {ok,RolePos} = common_misc:get_role_pos(RoleId),
    {ok,_RoleExt} = common_misc:get_role_ext(RoleId),
    
    case RoleBase#p_role_base.level =:= 0 of
        true ->
            set_role_first_enter_flag(true),
            NewRoleBase = RoleBase#p_role_base{level = 1,
                                               last_login_time = NowSeconds,
                                               last_login_ip = common_tool:ip_to_str(IP),
											   last_device_id = DeviceId},
            db_api:transaction(fun() -> db_api:write(?DB_ROLE_BASE, NewRoleBase, write) end),
            %% 记录日志
            #p_role_base{account_name=LogAccountName,
                         account_via = LogAccountVia,
                         role_name = LogRoleName} = NewRoleBase,
            LogRoleFollow = #r_log_role_follow{account_name = LogAccountName,
                                               account_via = LogAccountVia,
                                               role_id = RoleId,
                                               role_name = LogRoleName,
                                               mtime = common_tool:now(),
                                               step = ?ROLE_FOLLOW_STEP_4,
                                               ip = common_tool:ip_to_str(IP)},
            common_log:insert_log(role_follow,LogRoleFollow),
            next;
        _ ->
            set_role_first_enter_flag(false),
            NewRoleBase = RoleBase#p_role_base{last_login_ip = common_tool:ip_to_str(IP),
                                               last_login_time = NowSeconds}
    end,
    #p_role_attr{attr=#p_fight_attr{max_hp=MaxHp,hp=Hp}=FightAttr} = RoleAttr,
    case Hp =< 0 of
        true ->
            NewHp = erlang:trunc(MaxHp * 0.5);
        _ ->
            NewHp = Hp
    end,
    NewFightAttr = FightAttr#p_fight_attr{hp=NewHp},
    NewRoleAttr = RoleAttr#p_role_attr{attr=NewFightAttr},
    
    #p_role_base{faction_id=FactionId,level=RoleLevel,last_offline_time=LastOffineTime}=NewRoleBase,
    NewRolePos = mod_role_bi:auth_role_pos(RoleId, FactionId, LastOffineTime, RolePos),
    #r_role_pos{group_id=GroupId} = NewRolePos,
    
    case db_api:dirty_read(?DB_ROLE_BUFF, RoleId) of
        [#r_role_buff{buff_list=BuffList}] ->
            NewBuffList = mod_buff:get_valid_buff(BuffList, get_now2(), []),
            TocBuffIdList = mod_buff:get_toc_buff_ids(NewBuffList);
        _ ->
            TocBuffIdList = []
    end,
    PRoleInfo = #p_role{base=NewRoleBase, attr=NewRoleAttr, group_id=GroupId,buffs=TocBuffIdList},
    
    set_cache_role_data({NewRoleBase,NewRoleAttr,NewRolePos}),
    {ok,#r_role_world_state{quick_key=QuickKey}=RoleState} = get_role_world_state(),
    set_role_world_state(RoleState#r_role_world_state{state=?role_state_map_enter}),
    #r_role_pos{map_id=MapId,map_process_name=MapProcessName} = NewRolePos,
    {ok,{PRoleInfo,MapId,MapProcessName,RoleLevel,NowSeconds,QuickKey}}.

%% 初始化玩家数据 m_map_enter_tos
init_role_info_first_enter({RoleId,RolePId,ClientIP,Gateway}) ->
    {ok,#r_role_world_state{state=State}} = get_role_world_state(),
    case State of
        ?role_state_quick_key ->
            init_role_info_first_enter3(RoleId,RolePId,ClientIP,Gateway);
        _ ->
            init_role_info_first_enter2(RoleId,RolePId,ClientIP,Gateway)
    end.
init_role_info_first_enter2(RoleId,_RolePId,ClientIP,Gateway) ->
    NowSeconds = common_tool:now(),
    %% 玩家基本数据
    {RoleBase,RoleAttr,RolePos} = get_cache_role_data(),
    {ok,RoleState} = common_misc:get_role_state(RoleId),
    {ok,RoleSkill} = common_misc:get_role_skill(RoleId),
    
    %% DICT 初始化操作
    mod_role:init_role_base(RoleId, RoleBase),
    mod_role:init_role_attr(RoleId, RoleAttr),
    mod_role:init_role_pos(RoleId, RolePos),
    mod_role:init_role_state(RoleId, RoleState),
    mod_role:init_role_skill(RoleId, RoleSkill),
    mod_role:init_role_buff(RoleId),
    mod_bag:init_role_bag_info(RoleId),
    mod_mission:init_role_mission(RoleId),
    mod_pet_data:init_role_pet(RoleId),
    mod_pet_data:init_pet_bag(RoleId),

    %% 重算属性
    NewRoleAttr = mod_attr:generate_fight_attr(RoleId, ?ACTOR_TYPE_ROLE, false),
    
    %% 地图跳转数据
    RoleMapInfo = gen_role_map_info(RoleBase,NewRoleAttr,RolePos,RoleState),
    
    lists:foreach(
      fun(#r_role_tab{table_name=Tab,store_type=StoreType,load_type=LoadType})->
              case LoadType of
                  auto->case db_api:dirty_read(Tab,RoleId) of
                            [Value]->
                                case StoreType of
                                    ets->mod_role:init_ets({Tab,RoleId}, Value);
                                    dict->mod_role:init_dict({Tab,RoleId}, Value)
                                end;
                            _->ignore
                        end;
                  _->ignore
              end
      end, cfg_mnesia:find(role_tab_list)),
    
    %% 清除缓存数据 第一次登录时，auth key验证时缓存的数据
    erase_cache_role_data(),
    
    %% 在线数据
    #p_role_base{role_name=RoleName,
                 account_name=AccountName,
                 account_via=AccountVia,
                 faction_id=FactionId,
                 family_id=FamilyId} = RoleBase,
    RoleOnlineInfo = #r_role_online{role_id=RoleId, 
                                    role_name=RoleName, 
                                    account_name=AccountName, 
                                    faction_id=FactionId, 
                                    family_id=FamilyId,
                                    login_time=NowSeconds,
                                    login_ip=common_tool:ip_to_str(ClientIP),
                                    port=Gateway},
    ExtInfo = [{change_map_type,?MAP_CHANGE_TYPE_NORMAL}],
    Actors = [#r_map_actor{actor_id = RoleId,
                           actor_type = ?ACTOR_TYPE_ROLE,
                           attr = NewRoleAttr#p_role_attr.attr,
                           skill = RoleSkill#r_role_skill.skill_list}
             ],
    RoleMapParam = #r_map_param{role_id = RoleId,
                                role_pid = erlang:self(),
                                faction_id = FactionId,
                                map_role = RoleMapInfo,
                                map_actors = Actors,
                                ext_info = ExtInfo
                               },
    
    case get_role_first_enter_flag() of
        true ->
            %% 记录日志
            LogRoleFollow = #r_log_role_follow{account_name = AccountName,
                                               account_via = AccountVia,
                                               role_id = RoleId,
                                               role_name = RoleName,
                                               mtime = common_tool:now(),
                                               step = ?ROLE_FOLLOW_STEP_5,
                                               ip = common_tool:ip_to_str(ClientIP)},
            common_log:insert_log(role_follow,LogRoleFollow),
            next;
        _ ->
            ignore
    end,
    {ok,RoleWroldState} = get_role_world_state(),
    set_role_world_state(RoleWroldState#r_role_world_state{state=?role_state_running}),
    {ok,RoleMapParam,RoleOnlineInfo}.

init_role_info_first_enter3(RoleId,_RolePId,ClientIP,Gateway) ->
    NowSeconds = get_now(),
    {ok,RoleBase} = mod_role:get_role_base(RoleId),
    {ok,RoleAttr} = mod_role:get_role_attr(RoleId),
    {ok,RolePos} = mod_role:get_role_pos(RoleId),
    {ok,RoleState} = mod_role:get_role_state(RoleId),
    {ok,RoleSkill} = mod_role:get_role_skill(RoleId),
    %% 地图跳转数据
    RoleMapInfo = gen_role_map_info(RoleBase,RoleAttr,RolePos,RoleState),
    #p_role_base{role_name=RoleName,
                 account_name=AccountName,
                 faction_id=FactionId,
                 family_id=FamilyId} = RoleBase,
    RoleOnlineInfo = #r_role_online{role_id=RoleId, 
                                    role_name=RoleName, 
                                    account_name=AccountName, 
                                    faction_id=FactionId, 
                                    family_id=FamilyId,
                                    login_time=NowSeconds,
                                    login_ip=common_tool:ip_to_str(ClientIP),
                                    port=Gateway},
    ExtInfo = [{change_map_type,?MAP_CHANGE_TYPE_NORMAL}],
    Actors = [#r_map_actor{actor_id = RoleId,
                           actor_type = ?ACTOR_TYPE_ROLE,
                           attr = RoleAttr#p_role_attr.attr,
                           skill = RoleSkill#r_role_skill.skill_list}
             ],
    RoleMapParam = #r_map_param{role_id = RoleId,
                                role_pid = erlang:self(),
                                faction_id = FactionId,
                                map_role = RoleMapInfo,
                                map_actors = Actors,
                                ext_info = ExtInfo
                               },
    {ok,RoleWroldState} = get_role_world_state(),
    set_role_world_state(RoleWroldState#r_role_world_state{state=?role_state_running}),
    {ok,RoleMapParam,RoleOnlineInfo}.


%% 角色重新登录时，玩家进程未关闭，获取验证数据
get_auth_key_data({AccountName,RoleId,GatewayPId,Gateway,ClientIP}) ->
    case catch get_auth_key_data2() of
        {error,Reason} ->
            erlang:exit(erlang:self(), get_auth_key_data_fail),
            {error,Reason};
        {ok,RoleWorldState} ->
            get_auth_data(AccountName,RoleId,GatewayPId,Gateway,ClientIP,RoleWorldState)
    end.
get_auth_key_data2() ->
    case get_role_world_state() of
        {ok,RoleWorldState} ->
            next;
        _ -> 
            RoleWorldState = undefined,
            erlang:throw({error,not_found_role_world_state})
    end,
    #r_role_world_state{state=State} = RoleWorldState,
     case State of
        ?role_state_offline ->
            next;
        _ ->
            erlang:throw({error,role_world_state_error})
    end,
    {ok,RoleWorldState}.
get_auth_data(AccountName,RoleId,GatewayPId,Gateway,ClientIP,RoleWorldState) ->
    #r_role_world_state{offline_time=OfflineTime} = RoleWorldState,
    NowSeconds = get_now(),
    {ok,RoleBase} = mod_role:get_role_base(RoleId),
    {ok,RoleAttr} = mod_role:get_role_attr(RoleId),
    {ok,RolePos} = mod_role:get_role_pos(RoleId),
    
    NewRoleBase = RoleBase#p_role_base{last_login_ip = common_tool:ip_to_str(ClientIP),
                                       last_login_time = NowSeconds},
    mod_role:set_role_base(RoleId, NewRoleBase),
    
    #p_role_attr{attr=#p_fight_attr{max_hp=MaxHp,hp=Hp}=FightAttr} = RoleAttr,
    case Hp =< 0 of
        true ->
            NewHp = erlang:trunc(MaxHp * 0.5);
        _ ->
            NewHp = Hp
    end,
    NewFightAttr = FightAttr#p_fight_attr{hp=NewHp},
    NewRoleAttr = RoleAttr#p_role_attr{attr=NewFightAttr},
    mod_role:set_role_attr(RoleId, NewRoleAttr),
   
    
    #p_role_base{faction_id=FactionId,level=RoleLevel}=NewRoleBase,
    NewRolePos = mod_role_bi:auth_role_pos(RoleId, FactionId, OfflineTime, RolePos),
    mod_role:set_role_pos(RoleId, NewRolePos),
    
    #r_role_pos{group_id=GroupId} = NewRolePos,
    TocBuffIdList = mod_buff:get_toc_buff_ids(RoleId,?ACTOR_TYPE_ROLE),
    PRoleInfo = #p_role{base=NewRoleBase, attr=NewRoleAttr, group_id=GroupId, buffs=TocBuffIdList},
    
    NewQuickKey = common_misc:get_quick_key({AccountName,RoleId,NowSeconds}),
    NewRoleWorldState = RoleWorldState#r_role_world_state{gateway_pid=GatewayPId,
                                                          gateway=Gateway,
                                                          state=?role_state_quick_key,
                                                          offline_time = 0,
                                                          client_ip = ClientIP,
                                                          quick_key=NewQuickKey},
    set_role_world_state(NewRoleWorldState),
    #r_role_pos{map_id=MapId,map_process_name=MapProcessName} = NewRolePos,
    {ok,{PRoleInfo,MapId,MapProcessName,RoleLevel,NowSeconds,NewQuickKey}}.

%% 快速登录quick_key验证
do_auth_quick_key({AccountName,RoleId,GatewayPId,Gateway,QuickKey,ClientIP}) ->
    case catch do_auth_quick_key2(QuickKey) of
        {error,Reason} ->
            erlang:exit(erlang:self(), auth_quick_key_fail),
            {error,Reason};
        {ok,RoleWorldState} ->
            get_auth_data(AccountName,RoleId,GatewayPId,Gateway,ClientIP,RoleWorldState)
    end.
do_auth_quick_key2(QuickKey) ->
    case get_role_world_state() of
        {ok,RoleWorldState} ->
            next;
        _ -> 
            RoleWorldState = undefined,
            erlang:throw({error,not_found_role_world_state})
    end,
    #r_role_world_state{state=State,
                        quick_key=CheckQuickKey} = RoleWorldState,
    case State of
        ?role_state_offline ->
            case CheckQuickKey =:= QuickKey of
                true ->
                    next;
                _ ->
                    erlang:throw({error,quick_key_error})
            end;
        _ ->
            erlang:throw({error,role_world_state_error})
    end,
    {ok,RoleWorldState}.
    

%% 获取p_map_role数据
gen_role_map_info(RoleBase,RoleAttr,RolePos,RoleState) ->
    #p_role_base{role_id=RoleId,
                 role_name=RoleName,
                 skin=Skin,
                 faction_id=FactionId,
                 level=RoleLevel,
                 sex=Sex,
                 category=Category,
                 family_id=FamilyId,
                 family_name=FamilyName,
                 team_id=TeamId} = RoleBase,
    #r_role_pos{pos=Pos,group_id=GroupId} = RolePos,
    #r_role_state{status=Status} = RoleState,
    #p_role_attr{attr=#p_fight_attr{move_speed=MoveSpeed,max_hp=MaxHp,hp=Hp}} = RoleAttr,
    #p_map_role{
                role_id=RoleId,
                role_name=RoleName,
                skin=Skin,
                faction_id=FactionId,
                level=RoleLevel,
                sex=Sex,
                category=Category,
                family_id=FamilyId,
                family_name=FamilyName,
                team_id=TeamId,
                pos = Pos,
                walk_pos = undefined,
                status=Status,
                move_speed=MoveSpeed,
                max_hp=MaxHp,
                hp=Hp,
                group_id=GroupId,
                buffs=mod_buff:get_toc_buff_ids(RoleId, ?ACTOR_TYPE_PET)
               }.

%% 玩家下线关闭进程处理
%% 需要持久化玩家数据，退出进程
do_terminate(Reason)->
    NowSeconds = common_tool:now(),
    {ok,#r_role_world_state{role_id=RoleId,client_ip=ClientIp,state=State}} = get_role_world_state(),
    case State of
        ?role_state_auth_key -> %% 等待auth key
            ?ERROR_MSG("~ts,RoleId=~w,NowSeconds=~w,Reason=~w",[?_LANG_ROLE_006,RoleId,NowSeconds,Reason]);
        ?role_state_map_enter -> %% 等待map enter
            ?ERROR_MSG("~ts,RoleId=~w,NowSeconds=~w,Reason=~w",[?_LANG_ROLE_007,RoleId,NowSeconds,Reason]);
        _ -> %% 运行状态
            ?ERROR_MSG("~ts,RoleId=~w,NowSeconds=~w,Reason=~w",[?_LANG_ROLE_008,RoleId,NowSeconds,Reason]),
            ?TRY_CATCH(do_log_role_logout(RoleId,Reason,ClientIp),LogRoleLogoutErr),
            ?TRY_CATCH(hook_role:hook_role_offline(RoleId,NowSeconds),HookRoleOfflineErr),
            ?TRY_CATCH(do_role_persistent(RoleId),PersistentErr)
    end.
do_role_persistent(RoleId) ->
    %% 基本模块持久化操作
    mod_bag:dump_role_bag_info(RoleId),
    mod_role:dump_role_buff(RoleId),
    mod_pet_data:dump_pet_bag(RoleId),
    lists:foreach(
      fun(#r_role_tab{table_name=Tab,store_type=StoreType,dump_type=DumpType})->
              case DumpType of
                  auto->
                      case StoreType of
                          dict->?TRY_CATCH(mod_role:dump_dict({Tab,RoleId},Tab),Err1);
                          ets->?TRY_CATCH(mod_role:dump_ets({Tab,RoleId},Tab),Err2)
                      end;
                  _->ignore
              end
      end, cfg_mnesia:find(role_tab_list)),
    
    ?TRY_CATCH(do_log_role_snapshot(RoleId),RoleSnapshotErr),
    ?TRY_CATCH(erlang:send(mgeeg_global_server, {set_role_status,RoleId,role_logout_game}),RoleLogoutGameError),
    ok.
do_log_role_login(RoleId,ClientIp) ->
    {ok,RoleBase} = mod_role:get_role_base(RoleId),
    LogRoleLogin = #r_log_role_login{role_id = RoleBase#p_role_base.role_id, 
                                     role_name = RoleBase#p_role_base.role_name, 
                                     level = RoleBase#p_role_base.level, 
                                     account_name = RoleBase#p_role_base.account_name,
                                     mtime = common_tool:now(),
                                     ip = common_tool:ip_to_str(ClientIp)},
    common_log:insert_log(role_login, LogRoleLogin),
    ok.
%% 记录下线日志
do_log_role_logout(RoleId,Reason,ClientIp) ->
    {ok,RoleBase} = mod_role:get_role_base(RoleId),
    {ok,RolePos} = mod_role:get_role_pos(RoleId),
    case common_line:get_exit_info(Reason) of
        {_, {_ErrorNo, ErrorInfo}} ->
            next;
        _ ->
            ErrorInfo = Reason
    end,
    #p_role_base{role_name = RoleName,
                 level = RoleLevel,
                 account_name = AcctountName,
                 last_login_time = LastLoginTime} = RoleBase,
    #r_role_pos{map_id=MapId,pos=#p_pos{x = X,y=Y}} = RolePos,
    LogRoleLogout = #r_log_role_logout{role_id = RoleId, 
                                       role_name = RoleName, 
                                       level = RoleLevel, 
                                       account_name = AcctountName,
                                       ip = common_tool:ip_to_str(ClientIp), 
                                       map_id = MapId,
                                       tx = X, 
                                       ty = Y, 
                                       online_time = LastLoginTime,
                                       mtime = common_tool:now(), 
                                       reason = ErrorInfo},
    common_log:insert_log(role_logout, LogRoleLogout),
    ok.
%% 玩家信息快照日志
do_log_role_snapshot(RoleId) ->
    {ok,RoleBase} = mod_role:get_role_base(RoleId),
    {ok,RolePos} = mod_role:get_role_pos(RoleId),
    LogRoleSnapshot = common_log:get_log_role_snapshot(RoleBase,RolePos),
    common_log:insert_log(role_snapshot, LogRoleSnapshot),
    ok.
