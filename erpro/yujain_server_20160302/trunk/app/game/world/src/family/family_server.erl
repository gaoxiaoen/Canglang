%%% -------------------------------------------------------------------
%%% Author  : caochuncheng2002@gmail.com
%%% Description : 帮派进程
%%%
%%% Created : 2013-8-22
%%% -------------------------------------------------------------------
-module(family_server).
-behaviour(gen_server).

-include("mgeew.hrl").

-export([
         start_link/1,
         get_now/0,
         get_family_state/0,
		 do_log/1
         ]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(loop_milliseconds_1000,1000).
-record(state, {}).

start_link({OpType,FamilyId,ProcessName}) ->
    gen_server:start_link({local, ProcessName}, ?MODULE, [OpType,FamilyId], []).

init([OpType,FamilyId]) ->
    case db_api:dirty_read(?DB_FAMILY,FamilyId) of
        [FamilyInfo] ->
            NowSeconds = common_tool:now(),
            init_family(OpType,FamilyId,FamilyInfo),
            erlang:process_flag(trap_exit, true),
            erlang:put(milliseconds_1000, NowSeconds),
            erlang:send_after(?loop_milliseconds_1000, erlang:self(), loop_milliseconds_1000),
            FamilyState = #r_family_state{family_id=FamilyId},
            set_family_state(FamilyState),
            set_member_office_interval(NowSeconds + cfg_family:gen_member_office_interval()),
            set_family_impeach_date(0),
			[ServerLogInterval] = cfg_family:find(server_log_interval),
			set_log_interval(NowSeconds + ServerLogInterval),
            {ok, #state{}};
        _ ->
            ?ERROR_MSG("~ts,FamilyId=~w",[?_LANG_LOCAL_013,FamilyId]),
            {stop, {not_found,FamilyId}}
    end.
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.
handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({kill_family_process,Reason},State) ->
    ?DEBUG("~ts,Reason=~w",[?_LANG_LOCAL_014,Reason]),
    {stop, normal, State};
handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info, State),
    {noreply, State}.
terminate(_Reason, _State) ->
    ok.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% 帮派进程初始化操作
init_family(OpType,FamilyId,FamilyInfo) ->
    mod_family:init_family(FamilyId, FamilyInfo),
    lists:foreach(
      fun(RoleId) -> 
              case db_api:dirty_read(?DB_FAMILY_MEMBER,RoleId) of
                  [FamilyMember] ->
                      mod_family:init_family_member(RoleId, FamilyMember);
                  _ ->
                      ?ERROR_MSG("~ts,FamilyId=~w,RoleId=~w",[?_LANG_LOCAL_015,FamilyId,RoleId])
              end
      end, FamilyInfo#r_family.member_list),
    case OpType of
        ?FAMILY_PROCESS_OP_TYPE_CREATE ->
			do_log({common_tool:now(),""}),
			next;
        _ ->
            next
    end,
    ok.

do_handle_info({role_online,Info}) ->
    do_role_online(Info);
do_handle_info({role_offline,Info}) ->
    do_role_offline(Info);

do_handle_info({mod,Module,Info}) ->
    Module:handle(Info);

%%每秒大循环
do_handle_info(loop_milliseconds_1000) ->
    erlang:send_after(?loop_milliseconds_1000, erlang:self(), loop_milliseconds_1000),
    erlang:put(milliseconds_1000, common_tool:now()),
    loop();

do_handle_info({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("~w",[Ret]),
    ok;
do_handle_info(Info) ->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).


get_family_state() ->
    erlang:get(family_state_dict).
set_family_state(FamilyState) ->
    erlang:put(family_state_dict, FamilyState).

%% 帮派服务器日志记录时间间隔
get_log_interval() ->
	erlang:get(server_log_dict).
set_log_interval(Interval) ->
    erlang:put(server_log_dict, Interval).

%% 帮派成员职位更新时间间隔
get_member_office_interval() ->
    erlang:get(member_office_dict).
set_member_office_interval(Interval) ->
    erlang:put(member_office_dict, Interval).

%% 帮派弹劾进程字典
get_family_impeach_date() ->
    erlang:get(family_impeach_dict).
set_family_impeach_date(Date) ->
    erlang:put(family_impeach_dict, Date).

get_now() ->
    erlang:get(milliseconds_1000).
%%每秒大循环
loop() ->
    NowSeconds = get_now(),
    {NowDate,_} = common_tool:seconds_to_datetime(NowSeconds),
    case NowSeconds > get_member_office_interval() of
        true ->
            set_member_office_interval(NowSeconds + cfg_family:gen_member_office_interval()),
            %% 重新分析帮派职位
            mod_family:do_reset_family_member_office();
        _ ->
            ignore
    end,
    case NowDate =/= get_family_impeach_date() of
        true ->
            set_family_impeach_date(NowDate),
            %% 执行帮派团长弹劾功能
            mod_family:do_family_impeach();
        _ ->
            ignore
    end,
	case NowSeconds > get_log_interval() of
		true ->
			[ServerLogInterval] = cfg_family:find(server_log_interval),
			set_log_interval(NowSeconds + ServerLogInterval),
			%% 记录帮派服务器日志
			do_log({NowSeconds,""});
		_ ->
			next
	end,
    ok.
%% 玩家上线处理
do_role_online({RoleId,RoleName,Sex,Level,Category,LastLoginTime}) ->
    case catch do_role_online2(RoleId) of
        {error,Error} ->
            ?ERROR_MSG("~ts,Error=~w",[?_LANG_LOCAL_016,Error]);
        {ok,FamilyInfo,FamilyMember} ->
            do_role_online3(RoleId,RoleName,Sex,Level,Category,LastLoginTime,
                            FamilyInfo,FamilyMember)
    end.
do_role_online2(RoleId) ->
    #r_family_state{family_id=FamilyId} = get_family_state(),
    case mod_family:get_family(FamilyId) of
        {ok,FamilyInfo} ->
            next;
        _ ->
            FamilyInfo = undefined,
            erlang:throw({error,not_family_info})
    end,
    case mod_family:get_family_member(RoleId) of
        {ok,FamilyMember} ->
            next;
        _ ->
            FamilyMember = undefined,
            erlang:throw({error,not_family_member})
    end,
    case lists:member(RoleId,FamilyInfo#r_family.member_list) of
        true ->
            next;
        _ ->
            erlang:throw({error,diff_family_id})
    end,
    {ok,FamilyInfo,FamilyMember}.
do_role_online3(RoleId,RoleName,Sex,Level,Category,LastLoginTime,
                FamilyInfo,FamilyMember) ->
    #r_family{family_id = FamilyId,member_list = MemberList} = FamilyInfo,
    NewFamilyMember = FamilyMember#r_family_member{role_name = RoleName,
                                                   sex = Sex,
                                                   level=Level, 
                                                   category=Category,
                                                   last_login_time=LastLoginTime, 
                                                   is_online=?FAMILY_MEMBER_NOLINE},
    mod_family:set_family_member(RoleId, NewFamilyMember),
    AttrList = [#p_attr{attr_code=?FAMILY_ROLE_ROLE_NAME,uid=RoleId,string_value=RoleName},
                #p_attr{attr_code=?FAMILY_ROLE_SEX,uid=RoleId,int_value=Sex},
                #p_attr{attr_code=?FAMILY_ROLE_LEVEL,uid=RoleId,int_value=Level},
                #p_attr{attr_code=?FAMILY_ROLE_CATEGORY,uid=RoleId,int_value=Category},
                #p_attr{attr_code=?FAMILY_ROLE_LAST_LOGIN_TIME,uid=RoleId,int_value=LastLoginTime},
                #p_attr{attr_code=?FAMILY_ROLE_IS_ONLINE,uid=RoleId,int_value=?FAMILY_MEMBER_NOLINE}],
    BCSelf = #m_family_attr_change_toc{op_type=0,family_id=FamilyId,role_id=RoleId,attr_list=AttrList},
    mod_family:broadcast(MemberList, ?FAMILY, ?FAMILY_ATTR_CHANGE, BCSelf),
    ok.
%% 玩家下线处理
do_role_offline({RoleId,Level}) ->
    case catch do_role_offline2(RoleId) of
         {error,Error} ->
            ?ERROR_MSG("~ts,Error=~w",[?_LANG_LOCAL_017,Error]);
        {ok,FamilyInfo,FamilyMember} ->
            do_role_offline3(RoleId,Level,FamilyInfo,FamilyMember)
    end.
do_role_offline2(RoleId) ->
    #r_family_state{family_id=FamilyId} = get_family_state(),
    case mod_family:get_family(FamilyId) of
        {ok,FamilyInfo} ->
            next;
        _ ->
            FamilyInfo = undefined,
            erlang:throw({error,not_family_info})
    end,
    case mod_family:get_family_member(RoleId) of
        {ok,FamilyMember} ->
            next;
        _ ->
            FamilyMember = undefined,
            erlang:throw({error,not_family_member})
    end,
    case lists:member(RoleId,FamilyInfo#r_family.member_list) of
        true ->
            next;
        _ ->
            erlang:throw({error,diff_family_id})
    end,
    {ok,FamilyInfo,FamilyMember}.

do_role_offline3(RoleId,Level,FamilyInfo,FamilyMember) ->
    #r_family{family_id = FamilyId,member_list = MemberList} = FamilyInfo,
    NewFamilyMember = FamilyMember#r_family_member{level=Level,
                                                   is_online=?FAMILY_MEMBER_OFFLINE},
    mod_family:set_family_member(RoleId, NewFamilyMember),
    AttrList = [#p_attr{attr_code=?FAMILY_ROLE_LEVEL,uid=RoleId,int_value=Level},
                #p_attr{attr_code=?FAMILY_ROLE_IS_ONLINE,uid=RoleId,int_value=?FAMILY_MEMBER_OFFLINE}],
    BCSelf = #m_family_attr_change_toc{op_type=0,family_id=FamilyId,role_id=RoleId,attr_list=AttrList},
    mod_family:broadcast(MemberList, ?FAMILY, ?FAMILY_ATTR_CHANGE, BCSelf),
    ok.


%% 记录帮派服务器日志
do_log({LogTime,LogDesc}) ->
	do_log({LogTime,LogDesc,""});
do_log({LogTime,LogDesc,Extra}) ->
	case catch do_log2(LogTime,LogDesc,Extra) of
		{error,_Error} ->
			next;
		{ok} ->
			next
	end.
do_log2(LogTime,LogDesc,Extra) ->
	case get_family_state() of
		#r_family_state{family_id=FamilyId} ->
			next;
		_ ->
			FamilyId = 0,
			erlang:throw({error,not_family_id})
	end,
	case mod_family:get_family(FamilyId) of
		{ok,FamilyInfo} ->
			next;
		_ ->
			FamilyInfo = undefined,
			erlang:throw({error,not_family_info})
	end,
	#r_family{member_list=MemberRoleIdList} = FamilyInfo,
	FamilyMemberJsonList = 
		lists:foldl(
		  fun(RoleId,AccFamilyMemberJsonList) -> 
				  case mod_family:get_family_member(RoleId) of
					  {ok,FamilyMember} ->
						  FamilyMemberJson = common_lang:get_format_lang_resources(
											   "{\"role_id\":~s,\"join_time\":~s,\"office_code\":~s,\"cur_contribute\":~s,\"total_contribute\":~s,\"day_total_donate\":~s,\"day_total_donate\":~s,\"donate_time\":~s}", 
											   [FamilyMember#r_family_member.role_id,
												FamilyMember#r_family_member.join_time,
												FamilyMember#r_family_member.office_code,
												FamilyMember#r_family_member.cur_contribute,
												FamilyMember#r_family_member.total_contribute,
												FamilyMember#r_family_member.day_total_donate,
												FamilyMember#r_family_member.total_donate,
												FamilyMember#r_family_member.donate_time]),
						  [FamilyMemberJson|AccFamilyMemberJsonList];
					  _ ->
						  AccFamilyMemberJsonList
				  end
		  end, [], MemberRoleIdList),
	%% 帮派日志
	LogFamily = #r_log_family{family_id=FamilyInfo#r_family.family_id,
							  family_name=FamilyInfo#r_family.family_name,
							  create_role_id=FamilyInfo#r_family.create_role_id,
							  create_role_name=FamilyInfo#r_family.create_role_name, 
							  owner_role_id=FamilyInfo#r_family.owner_role_id,
							  owner_role_name=FamilyInfo#r_family.owner_role_name,
							  faction_id=FamilyInfo#r_family.faction_id,
							  level=FamilyInfo#r_family.level, 
							  create_time=FamilyInfo#r_family.create_time,
							  cur_pop=FamilyInfo#r_family.cur_pop,
							  max_pop=FamilyInfo#r_family.max_pop,
							  icon_level=FamilyInfo#r_family.icon_level, 
							  total_contribute=FamilyInfo#r_family.total_contribute,
							  status=FamilyInfo#r_family.status, 
							  member_list="[" ++ string:join(FamilyMemberJsonList, ",") ++ "]",
							  extra=Extra,
							  log_time=LogTime,
							  log_desc=LogDesc},
	common_log:insert_log(family, LogFamily),
	{ok}.