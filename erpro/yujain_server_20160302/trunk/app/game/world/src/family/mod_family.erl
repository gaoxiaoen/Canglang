%% Author: caochuncheng2002@gmail.com
%% Created: 2013-8-22
%% Description: 帮派消息处理模块
-module(mod_family).

-include("mgeew.hrl").

-export([
         init_family/2,
         get_family/1,
         set_family/2,
         t_set_family/2,
         erase_family/1,
         
         get_dirty_family/1,
         
         init_family_member/2,
         get_family_member/1,
         set_family_member/2,
         t_set_family_member/2,
         erase_family_member/1,
         
         get_dirty_family_member/1,
         
         do_reset_family_member_office/0,
         do_family_impeach/0,
         
         broadcast/4,
         
         handle/1          
        ]).

%% 帮派信息
%% 此信息保存在帮派进程字典中
init_family(FamilyId,FamilyInfo) ->
    mod_role:init_dict({?DB_FAMILY,FamilyId}, FamilyInfo).
get_family(FamilyId) ->
    mod_role:get_dict({?DB_FAMILY,FamilyId}).
set_family(FamilyId,FamilyInfo) ->
    mod_role:set_dict({?DB_FAMILY,FamilyId}, FamilyInfo),
    db_api:dirty_write(?DB_FAMILY, FamilyInfo).
t_set_family(FamilyId,FamilyInfo) ->
    mod_role:t_set_dict({?DB_FAMILY,FamilyId}, FamilyInfo).
erase_family(FamilyId) ->
    mod_role:erase_dict({?DB_FAMILY,FamilyId}, ?DB_FAMILY).

%% 脏读帮派信息
get_dirty_family(FamilyId) ->
    case db_api:dirty_read(?DB_FAMILY,FamilyId) of
        [FamilyInfo] ->
            {ok,FamilyInfo};
        _ ->
            {error,not_found}
    end.


%% 帮派成员信息
%% 此信息保存在帮派进程字典中
%% 如果玩家没有加入帮派或退出帮派，即脏读信息就可以获得玩家帮派信息
init_family_member(RoleId,FamilyMember) ->
    mod_role:init_dict({?DB_FAMILY_MEMBER,RoleId}, FamilyMember).
get_family_member(RoleId) ->
    mod_role:get_dict({?DB_FAMILY_MEMBER,RoleId}).
set_family_member(RoleId,FamilyMember) ->
    mod_role:set_dict({?DB_FAMILY_MEMBER,RoleId}, FamilyMember),
    db_api:dirty_write(?DB_FAMILY_MEMBER, FamilyMember).
t_set_family_member(RoleId,FamilyMember) ->
    mod_role:t_set_dict({?DB_FAMILY_MEMBER,RoleId}, FamilyMember).
erase_family_member(RoleId) ->
    mod_role:erase_dict({?DB_FAMILY_MEMBER,RoleId}, ?DB_FAMILY_MEMBER).

%% 如果玩家没有加入帮派或退出帮派，即脏读信息就可以获得玩家帮派信息
get_dirty_family_member(RoleId) ->
    case db_api:dirty_read(?DB_FAMILY_MEMBER, RoleId) of
        [FamilyMemberInfo] ->
            {ok, FamilyMemberInfo};
        _ ->
            {error, not_found}
    end. 

%% 广播帮派成员消息
%% 注：必须在帮派进程中使用
broadcast([],_Module,_Method,_SendSelf) ->
    ignroe;
broadcast(RoleIdList,Module,Method,SendSelf) ->
    lists:foreach(
      fun(RoleId) -> 
              case get_family_member(RoleId) of
                  {ok,#r_family_member{is_online = ?FAMILY_MEMBER_NOLINE}} ->
                      common_misc:unicast({role,RoleId},Module,Method,SendSelf);
                  _ ->
                      next
              end
      end, RoleIdList).

%% 获取玩家帮派成员信息
get_r_family_member(RoleId,RoleBase,NowSeconds) ->
    case get_dirty_family_member(RoleId) of
        {ok,FamilyMember} ->
            FamilyMember#r_family_member{role_name=RoleBase#p_role_base.role_name,
                                         sex=RoleBase#p_role_base.sex, 
                                         level=RoleBase#p_role_base.level, 
                                         category=RoleBase#p_role_base.category,
                                         last_login_time=RoleBase#p_role_base.last_login_time, 
                                         is_online=?FAMILY_MEMBER_NOLINE, 
                                         join_time=NowSeconds, 
                                         office_code=?FAMILY_MEMBER_OFFICE_TUAN_YUAN
                                        };
        _ ->
            #r_family_member{role_id=RoleId, 
                             role_name=RoleBase#p_role_base.role_name, 
                             sex=RoleBase#p_role_base.sex,
                             level=RoleBase#p_role_base.level, 
                             category=RoleBase#p_role_base.category, 
                             vip_level=0, 
                             last_login_time=RoleBase#p_role_base.last_login_time, 
                             is_online=?FAMILY_MEMBER_NOLINE, 
                             join_time=NowSeconds, 
                             office_code=?FAMILY_MEMBER_OFFICE_TUAN_YUAN, 
                             cur_contribute=0, 
                             total_contribute=0, 
                             qq="" }
    end.
%% 获取玩家最后一次加入帮派的时间
%% 返回  JoinTime | 0
get_member_last_join_time(RoleId) ->
    case get_dirty_family_member(RoleId) of
        {ok,#r_family_member{join_time = JoinTime}} ->
            JoinTime;
        _ ->
            0
    end.
handle({Module,?FAMILY_GET,DataRecord,RoleId,PId}) ->
    do_family_get(Module,?FAMILY_GET,DataRecord,RoleId,PId);
handle({admin_get,Info}) ->
    do_admin_get(Info);

handle({Module,?FAMILY_CREATE,DataRecord,RoleId,PId,_Line}) ->
    do_family_create(Module,?FAMILY_CREATE,DataRecord,RoleId,PId);

handle({Module,?FAMILY_REQUEST,DataRecord,RoleId,PId,_Line}) ->
    do_family_request(Module,?FAMILY_REQUEST,DataRecord,RoleId,PId);
handle({admin_request,Info}) ->
    do_admin_request(Info);

handle({Module,?FAMILY_INVITE,DataRecord,RoleId,PId,_Line}) ->
    do_family_invite(Module,?FAMILY_INVITE,DataRecord,RoleId,PId);
handle({admin_invite_invite,Info}) ->
    do_admin_invite_invite(Info);
handle({admin_invite_accept,Info}) ->
    do_admin_invite_accept(Info);

handle({Module,?FAMILY_ACCEPT,DataRecord,RoleId,PId,_Line}) ->
    do_family_accept(Module,?FAMILY_ACCEPT,DataRecord,RoleId,PId);
handle({admin_accept,Info}) ->
    do_admin_accept(Info);
handle({family_join,{RoleIdList,FamilyId}}) ->
    do_family_join(RoleIdList,FamilyId);
handle({admin_family_join,Info}) ->
    do_admin_family_join(Info);
handle({admin_family_join_final,Info}) ->
    do_admin_family_join_final(Info);

handle({Module,?FAMILY_REFUSE,DataRecord,RoleId,PId,_Line}) ->
    do_family_refuse(Module,?FAMILY_REFUSE,DataRecord,RoleId,PId);
handle({admin_refuse,Info}) ->
    do_admin_refuse(Info);

handle({Module,?FAMILY_DISBAND,DataRecord,RoleId,PId,_Line}) ->
    do_family_disband(Module,?FAMILY_DISBAND,DataRecord,RoleId,PId);
handle({admin_disband,Info}) ->
    do_admin_disband(Info);

handle({family_out,{RoleIdList,FamilyId,OutType}}) ->
    do_family_out(RoleIdList,FamilyId,OutType);
handle({admin_family_out,Info}) ->
    do_admin_family_out(Info);
handle({admin_family_out_final,Info}) ->
    do_admin_family_out_final(Info);

handle({Module,?FAMILY_FIRE,DataRecord,RoleId,PId,_Line}) ->
    do_family_fire(Module,?FAMILY_FIRE,DataRecord,RoleId,PId);
handle({admin_fire,Info}) ->
    do_admin_fire(Info);

handle({Module,?FAMILY_LEAVE,DataRecord,RoleId,PId,_Line}) ->
    do_family_leave(Module,?FAMILY_LEAVE,DataRecord,RoleId,PId);
handle({admin_leave,Info}) ->
    do_admin_leave(Info);

handle({Module,?FAMILY_TURN,DataRecord,RoleId,PId,_Line}) ->
    do_family_turn(Module,?FAMILY_TURN,DataRecord,RoleId,PId);
handle({admin_turn,Info}) ->
    do_admin_turn(Info);

handle({admin_set,Info}) ->
    do_admin_set(Info);

handle(Info)->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).

-define(family_create_op_type_gold,1).     %% 元宝创建
-define(family_create_op_type_silver,2).   %% 银两创建
%% 创建帮派
do_family_create(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_family_create2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_family_create_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,RoleBase,NewFamilyName,OpFee} ->
            do_family_create3(Module,Method,DataRecord,RoleId,PId,
                              RoleBase,NewFamilyName,OpFee)
    end.
do_family_create2(RoleId,DataRecord) ->
    #m_family_create_tos{op_type=OpType,
                         family_name=FamilyName} = DataRecord,
    case OpType of
        ?family_create_op_type_gold ->
            next;
        ?family_create_op_type_silver ->
            erlang:throw({error,?_RC_FAMILY_CREATE_001});
        _ ->
            erlang:throw({error,?_RC_FAMILY_CREATE_001})
    end,
    case FamilyName =/= "" andalso FamilyName =/= [] of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_CREATE_005})
    end,
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase=undefined,
            erlang:throw({error,?_RC_FAMILY_CREATE_000})
    end,
    [MinRoleLevel] = cfg_family:find({create_family,min_role_level}),
    case RoleBase#p_role_base.level >= MinRoleLevel of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_CREATE_007})
    end,
    case RoleBase#p_role_base.family_id > 0 of
        true ->
            erlang:throw({error,?_RC_FAMILY_CREATE_004});
        _ ->
            next
    end,
    case OpType of
        ?family_create_op_type_gold ->
            [OpFee] = cfg_family:find({create_family_fee,gold}),
            case RoleBase#p_role_base.gold >= OpFee of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_FAMILY_CREATE_002})
            end;
        ?family_create_op_type_silver ->
            OpFee=0,
            erlang:throw({error,?_RC_FAMILY_CREATE_001})
    end,
    %% 构建帮派名称
    ServerId = common_misc:get_server_id_by_id(RoleId),
	NewFamilyName = common_misc:get_real_name(FamilyName, ServerId),
    FamilyNameLen = erlang:length(unicode:characters_to_list(erlang:list_to_binary(FamilyName),unicode)),
    case FamilyNameLen >= 2 andalso FamilyNameLen =< 6 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_CREATE_006})
    end,
    %% 每天创建帮派的次数限制
    case get_dirty_family_member(RoleId) of
        {ok,FamilyMemberInfo} ->
            #r_family_member{join_time=JoinTime} = FamilyMemberInfo,
            case JoinTime =/= 0 andalso common_misc:is_reset_times(JoinTime) =:= false of
                true ->
                    erlang:throw({error,?_RC_FAMILY_CREATE_008});
                _ ->
                    next
            end;
        _ ->
            next
    end,
    case db_api:dirty_read(?DB_FAMILY_NAME,FamilyName) of
        [] ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_CREATE_009})
    end,
    {ok,RoleBase,NewFamilyName,OpFee}.

do_family_create3(Module,Method,DataRecord,RoleId,PId,
                  RoleBase,FamilyName,OpFee) ->
    case db_api:transaction(
           fun() ->
                   do_t_family_create(RoleId,DataRecord,RoleBase,FamilyName,OpFee)
           end) of
        {atomic,{ok,NewRoleBase,FamilyId,Family,FamilyMember}} ->
            do_family_create4(Module,Method,DataRecord,RoleId,PId,
                              NewRoleBase,FamilyId,Family,FamilyMember,OpFee);
        {aborted, Error} ->
            case Error of
                {error,OpCode} ->
                    next;
                _ ->
					?ERROR_MSG("~ts,Error=~w",[?_LANG_LOCAL_018,Error]),
                    OpCode = ?_RC_FAMILY_CREATE_000
            end,
            do_family_create_error(Module,Method,DataRecord,RoleId,PId,OpCode)
    end.
do_t_family_create(RoleId,DataRecord,RoleBase,FamilyName,OpFee) ->
    case db_api:read(?DB_FAMILY_NAME,FamilyName,write) of
        [] ->
            next;
        _ ->
            db_api:abort({error,?_RC_FAMILY_CREATE_009})
    end,
    NowSeconds = common_tool:now(),
	ServerId = common_misc:get_server_id_by_id(RoleId),
	case db_api:read(?DB_FAMILY_COUNTER,ServerId,write) of
		[#r_counter{last_id=LastFamilyId}] ->
			next;
		_ ->
			LastFamilyId = 0,
			db_api:abort({error,?_RC_FAMILY_CREATE_010})
	end,
    FamilyId = LastFamilyId + 1,
    FamilyNameRecord = #r_family_name{family_id = FamilyId,family_name = FamilyName},
    MaxPop = cfg_family:get_max_pop(1),
    Family = #r_family{family_id=FamilyId, 
                       family_name=FamilyName, 
                       create_role_id=RoleId, 
                       create_role_name=RoleBase#p_role_base.role_name, 
                       owner_role_id=RoleId, 
                       owner_role_name=RoleBase#p_role_base.role_name, 
                       faction_id=RoleBase#p_role_base.faction_id, 
                       level=1,
                       create_time=NowSeconds, 
                       cur_pop=1, 
                       max_pop=MaxPop, 
                       icon_level=1, 
                       total_contribute=0, 
                       public_notice=common_lang:get_lang(100401),
                       private_notice="", 
                       qq="", 
                       member_list=[RoleId], 
                       request_list=[]},
    FamilyMember = get_r_family_member(RoleId,RoleBase,NowSeconds),
	NewFamilyMember = FamilyMember#r_family_member{office_code=?FAMILY_MEMBER_OFFICE_TUAN_ZHANG},
    
    %% 帮派id信息
    db_api:write(?DB_FAMILY_COUNTER, #r_counter{key=ServerId, last_id=FamilyId}, write),
    %% 帮派名称 信息
    db_api:write(?DB_FAMILY_NAME, FamilyNameRecord, write),
    %% 帮派信息
    db_api:write(?DB_FAMILY, Family, write),
    %% 帮派成员信息
    db_api:write(?DB_FAMILY_MEMBER, NewFamilyMember, write),
    %% 扣费操作
    case DataRecord#m_family_create_tos.op_type of
        ?family_create_op_type_gold ->
            NewGold = RoleBase#p_role_base.gold - OpFee,
            NewSilver = RoleBase#p_role_base.silver;
        ?family_create_op_type_silver ->
            NewGold = RoleBase#p_role_base.gold,
            NewSilver = RoleBase#p_role_base.silver - OpFee
    end,
    NewRoleBase = RoleBase#p_role_base{gold = NewGold, silver = NewSilver,
                                       family_id=FamilyId,family_name=FamilyName},
    mod_role:t_set_role_base(RoleId, NewRoleBase),
    {ok,NewRoleBase,FamilyId,Family,NewFamilyMember}.
do_family_create4(Module,Method,DataRecord,RoleId,PId,
                  NewRoleBase,FamilyId,Family,FamilyMember,OpFee) ->
    %% 日志
    LogTime = common_tool:now(),
    case DataRecord#m_family_create_tos.op_type of
        ?family_create_op_type_gold ->
            common_log:log_gold({NewRoleBase,?LOG_CONSUME_GOLD_FAMILY_CREATE,LogTime,OpFee}),
			common_misc:send_role_attr_change_gold(PId, NewRoleBase);
        ?family_create_op_type_silver ->
            common_log:log_silver({NewRoleBase,?LOG_CONSUME_SILVER_FAMILY_CREATE,LogTime,OpFee}),
			common_misc:send_role_attr_change_silver(PId, NewRoleBase)
    end,
    
    PFamilyInfo = get_p_family(Family,[FamilyMember]),
	
    SendSelf = #m_family_create_toc{op_type=DataRecord#m_family_create_tos.op_type,
                                    is_friend_invite=DataRecord#m_family_create_tos.is_friend_invite,
                                    op_code=0,
                                    family_info = PFamilyInfo},
	?DEBUG("family create succ,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf),
    %% 帮派初始化
    ?TRY_CATCH(common_family:create_family_process(?FAMILY_PROCESS_OP_TYPE_CREATE,FamilyId),ErrCreateFamily),
    %% 新创建的帮派，需要加入帮派列表
    PFamily = #p_family_list{family_id=FamilyId,
                             family_name=Family#r_family.family_name,
                             owner_role_id=Family#r_family.owner_role_id,
                             owner_role_name=Family#r_family.owner_role_name,
                             faction_id=Family#r_family.faction_id,
                             level=Family#r_family.level,
                             cur_pop=Family#r_family.cur_pop,
                             max_pop=Family#r_family.max_pop,
                             total_contribute=Family#r_family.total_contribute,
                             public_notice=Family#r_family.public_notice},
    common_family:send_to_family_manager({hook_create_family,{PFamily}}),
    %% 帮派hook
    hook_family:create_family({RoleId,FamilyId,Family#r_family.family_name}),
    hook_family:join_family({RoleId,FamilyId,Family#r_family.family_name}),
    case DataRecord#m_family_create_tos.is_friend_invite of
        1 -> %%DOTO 邀请好友加入帮派
            next;
        _ ->
            ignore
    end,
	%% 帮派日志
	family_server:do_log({LogTime,"create_family"}),
    ok.
do_family_create_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_family_create_toc{op_type=DataRecord#m_family_create_tos.op_type,
                                    is_friend_invite=DataRecord#m_family_create_tos.is_friend_invite,
                                    op_code=OpCode},
    common_misc:unicast(PId,Module,Method,SendSelf),
    ok.
%% 返回 #p_family_member{}
get_p_family_member(FamilyMember) ->
	#p_family_member{role_id=FamilyMember#r_family_member.role_id,
                                    role_name=FamilyMember#r_family_member.role_name,
                                    sex=FamilyMember#r_family_member.sex,
                                    level=FamilyMember#r_family_member.level,
                                    last_login_time=FamilyMember#r_family_member.last_login_time,
                                    is_online=FamilyMember#r_family_member.is_online,
                                    office_code=FamilyMember#r_family_member.office_code,
                                    cur_contribute=FamilyMember#r_family_member.cur_contribute,
                                    total_contribute=FamilyMember#r_family_member.total_contribute,
                                    qq=FamilyMember#r_family_member.qq}.
%% 返回  #p_family{}
get_p_family(Family,FamilyMemberList) ->
    MemberList = [ get_p_family_member(FamilyMember) || FamilyMember <- FamilyMemberList],
    RequestList = [ #p_family_request{role_id=FamilyRequest#r_family_request.role_id,
                                      role_name=FamilyRequest#r_family_request.role_name,
                                      level=FamilyRequest#r_family_request.role_level,
                                      op_time=FamilyRequest#r_family_request.op_time} || FamilyRequest <- Family#r_family.request_list],
    #p_family{family_id=Family#r_family.family_id,
              family_name=Family#r_family.family_name,
              owner_role_id=Family#r_family.owner_role_id,
              owner_role_name=Family#r_family.owner_role_name,
              faction_id=Family#r_family.faction_id,
              level=Family#r_family.level,
              create_time=Family#r_family.create_time,
              cur_pop=Family#r_family.cur_pop,
              max_pop=Family#r_family.max_pop,
              icon_level=Family#r_family.icon_level,
              total_contribute=Family#r_family.total_contribute,
              public_notice=Family#r_family.public_notice,
              private_notice=Family#r_family.private_notice,
              qq=Family#r_family.qq,
              member_list = MemberList,
              request_list = RequestList}.

%% 申请加入帮派
do_family_request(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_family_request2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_family_request_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,RoleBase,FamilyPId} ->
            do_family_request3(Module,Method,DataRecord,RoleId,PId,
                               RoleBase,FamilyPId)
    end.
do_family_request2(RoleId,DataRecord) ->
    #m_family_request_tos{family_id = FamilyId} = DataRecord,
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,?_RC_FAMILY_REQUEST_000})
    end,
    case RoleBase#p_role_base.family_id of
        0 ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_REQUEST_001})
    end,
    [MinRoleLevel] = cfg_family:find({join_family,min_role_level}),
    case RoleBase#p_role_base.level >= MinRoleLevel of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_REQUEST_002})
    end,
    case get_dirty_family(FamilyId) of
        {ok,_} ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_REQUEST_003})
    end,
    case common_family:get_family_pid(FamilyId) of
        undefined ->
            FamilyPId = undefined,
            erlang:throw({error,?_RC_FAMILY_REQUEST_000});
        FamilyPId ->
            next
    end,
    {ok,RoleBase,FamilyPId}.
do_family_request3(_Module,_Method,DataRecord,RoleId,PId,
                   RoleBase,FamilyPId) ->
    #p_role_base{role_name=RoleName,faction_id=FactionId,level=RoleLevel} = RoleBase,
    #m_family_request_tos{family_id = FamilyId} = DataRecord,
    Param = {admin_request,{RoleId,PId,FamilyId,RoleName,FactionId,RoleLevel}},
    common_family:send_to_family(FamilyPId, {mod,mod_family,Param}),
    ok.
do_admin_request({RoleId,PId,FamilyId,RoleName,FactionId,RoleLevel}) ->
    case catch do_admin_request2(RoleId,FamilyId,FactionId) of
        {error,OpCode} ->
            DataRecord = #m_family_request_tos{family_id = FamilyId},
            do_family_request_error(?FAMILY,?FAMILY_REQUEST,DataRecord,RoleId,PId,OpCode);
        {ok,FamilyInfo} ->
            do_admin_request3(RoleId,PId,FamilyId,RoleName,RoleLevel,FamilyInfo)
    end.

do_admin_request2(RoleId,FamilyId,FactionId) ->
    case get_family(FamilyId) of
        {ok,FamilyInfo} ->
            next;
        _ ->
            FamilyInfo = undefined,
            erlang:throw({error,?_RC_FAMILY_REQUEST_000})
    end,
    case FactionId =:= FamilyInfo#r_family.faction_id of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_REQUEST_005})
    end,
    case lists:keyfind(RoleId, #r_family_request.role_id, FamilyInfo#r_family.request_list) of
        false ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_REQUEST_004})
    end,
    {ok,FamilyInfo}.
do_admin_request3(RoleId,PId,FamilyId,RoleName,RoleLevel,FamilyInfo) ->
    [MaxRequestNumber] = cfg_family:find({max_family_request_number}),
    FamilyRequest = #r_family_request{role_id=RoleId,
                                      role_name=RoleName,
                                      role_level=RoleLevel,
                                      op_time=common_tool:now(),
                                      src_role_id=0},
    RequestList = [FamilyRequest|FamilyInfo#r_family.request_list],
    CurLen = erlang:length(RequestList),
    case CurLen > MaxRequestNumber of
        true ->
            NewRequestList = lists:sublist(RequestList, 1, MaxRequestNumber),
            DelRequestList = lists:sublist(RequestList, MaxRequestNumber, CurLen);
        _ ->
            NewRequestList = RequestList,
            DelRequestList = []
    end,
	PRequestList = #p_family_request{role_id=RoleId,
										role_name=RoleName,
										level=RoleLevel,
										op_time=FamilyRequest#r_family_request.op_time},
    
    NewFamilyInfo = FamilyInfo#r_family{request_list = NewRequestList},
    set_family(FamilyId, NewFamilyInfo),
    
    SendSelf = #m_family_request_toc{family_id=FamilyId,
                                     op_code=0,
                                     role_id=RoleId},
    common_misc:unicast(PId,?FAMILY,?FAMILY_REQUEST,SendSelf),
    
    BCSelf = #m_family_request_toc{family_id=FamilyId,
                                     op_code=0,
                                     role_id=RoleId,
                                     request_info=PRequestList,
                                     del_ids=[ DelId || #r_family_request{role_id=DelId} <- DelRequestList]},
    broadcast(NewFamilyInfo#r_family.member_list,?FAMILY,?FAMILY_REQUEST,BCSelf),
    ok.
do_family_request_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_family_request_toc{family_id=DataRecord#m_family_request_tos.family_id,
                                     op_code=OpCode},
    common_misc:unicast(PId,Module,Method,SendSelf),
    ok.

-define(family_invite_op_type_invite,1).        %% 1邀请玩家加入帮派
-define(family_invite_op_type_accept,2).        %% 2玩家同意邀请
-define(family_invite_op_type_refuse,3).        %% 3玩家拒绝邀请
%% 邀请进入帮派
do_family_invite(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_family_invite2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_family_invite_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,?family_invite_op_type_invite,RoleBase,InviteRolePId} ->
            do_family_invite_invite(Module,Method,DataRecord,RoleId,PId,
                                    RoleBase,InviteRolePId);
        {ok,?family_invite_op_type_accept,RoleBase,FamilyPId} ->
            do_family_invite_accept(Module,Method,DataRecord,RoleId,PId,
                                    RoleBase,FamilyPId);
        {ok,?family_invite_op_type_refuse} ->
            do_family_invite_refuse(Module,Method,DataRecord,RoleId,PId)
    end.
do_family_invite2(RoleId,DataRecord) ->
    #m_family_invite_tos{op_type = OpType,
                         invited_role_id=InvitedRoleId,
                         src_role_id = SrcRoleId,
                         family_id=FamilyId} = DataRecord,
    case OpType of
        ?family_invite_op_type_invite ->
            next;
        ?family_invite_op_type_accept ->
            case SrcRoleId =:= 0 of
                true ->
                    erlang:throw({error,?_RC_FAMILY_INVITE_001});
                _ ->
                    next
            end;
        ?family_invite_op_type_refuse ->
            case SrcRoleId =:= 0 of
                true ->
                    erlang:throw({error,?_RC_FAMILY_INVITE_001});
                _ ->
                    next
            end;
        _ ->
            erlang:throw({error,?_RC_FAMILY_INVITE_001})
    end,
    case mod_role:get_role_base(RoleId) of
        {ok, RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,?_RC_FAMILY_INVITE_000})
    end,
    case OpType of
        ?family_invite_op_type_invite ->
            case RoleBase#p_role_base.family_id > 0 of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_FAMILY_INVITE_002})
            end,
            case get_dirty_family(RoleBase#p_role_base.family_id) of
                {ok,FamilyInfo} ->
                    case lists:keyfind(InvitedRoleId, #r_family_request.role_id, FamilyInfo#r_family.request_list) of
                        false ->
                            next;
                        _ ->
                            erlang:throw({error,?_RC_FAMILY_INVITE_006})
                    end;
                _ ->
                    next
            end,
            case erlang:whereis(common_misc:get_role_world_process_name(InvitedRoleId)) of
                undefined ->
                    InviteRolePId = undefined,
                    erlang:throw({error,?_RC_FAMILY_INVITE_003});
                InviteRolePId ->
                    next
            end,
            case mod_role:get_role_base(InviteRolePId) of
                {ok,InviteRoleBase} ->
                    case InviteRoleBase#p_role_base.faction_id =:= RoleBase#p_role_base.faction_id of
                        true ->
                            next;
                        _ ->
                            erlang:throw({error,?_RC_FAMILY_INVITE_005})
                    end,
                    case InviteRoleBase#p_role_base.family_id > 0 of
                        true ->
                            erlang:throw({error,?_RC_FAMILY_INVITE_004});
                        _ ->
                            next
                    end;
                _ ->
                    next
            end,
            {ok,OpType,RoleBase,InviteRolePId};
        ?family_invite_op_type_accept ->
            case RoleBase#p_role_base.family_id > 0 of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_FAMILY_INVITE_007})
            end,
            [MinRoleLevel] = cfg_family:find({join_family,min_role_level}),
            case RoleBase#p_role_base.level >= MinRoleLevel of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_FAMILY_INVITE_009})
            end,
            case get_dirty_family(FamilyId) of
                {ok,_} ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_FAMILY_INVITE_010})
            end,
            case common_family:get_family_pid(FamilyId) of
                undefined ->
                    FamilyPId = undefined,
                    erlang:throw({error,?_RC_FAMILY_INVITE_010});
                FamilyPId ->
                    next
            end,
            {ok,?family_invite_op_type_accept,RoleBase,FamilyPId};
        ?family_invite_op_type_refuse ->
            {ok,?family_invite_op_type_refuse}
    end.

%% 邀请玩家处理
do_family_invite_invite(_Module,_Method,DataRecord,RoleId,PId,
                        RoleBase,InviteRolePId) ->
    InviteRoleId = DataRecord#m_family_invite_tos.invited_role_id,
    #p_role_base{role_name=RoleName,faction_id =FactionId,family_id=FamilyId,family_name=FamilyName} = RoleBase,
    Param = {admin_invite_invite,{InviteRoleId,InviteRolePId,DataRecord,
                                  RoleId,PId,RoleName,FactionId,FamilyId,FamilyName}},
    common_misc:send_to_role(InviteRolePId, {mod,mod_family,Param}),
    ok.
do_admin_invite_invite({InviteRoleId,InviteRolePId,DataRecord,
                        SrcRoleId,SrcPId,SrcRoleName,SrcFactionId,FamilyId,FamilyName}) ->
    case catch do_admin_invite_invite2(InviteRoleId,SrcFactionId) of
        {error,OpCode} ->
            do_family_invite_error(?FAMILY,?FAMILY_INVITE,DataRecord,SrcRoleId,SrcPId,OpCode);
        {ok} ->
            do_admin_invite_invite3(InviteRolePId,DataRecord,
                                    SrcRoleId,SrcPId,SrcRoleName,FamilyId,FamilyName)
    end.
do_admin_invite_invite2(InviteRoleId,SrcFactionId) ->
    case mod_role:get_role_base(InviteRoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,?_RC_FAMILY_INVITE_000})
    end,
    [MinRoleLevel] = cfg_family:find({join_family,min_role_level}),
    case RoleBase#p_role_base.level >= MinRoleLevel of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_INVITE_008})
    end,
    case RoleBase#p_role_base.family_id > 0 of
        true ->
            erlang:throw({error,?_RC_FAMILY_INVITE_004});
        _ ->
            next
    end,
    case RoleBase#p_role_base.faction_id =:= SrcFactionId of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_INVITE_005})
    end,
    {ok}.
do_admin_invite_invite3(InviteRolePId,DataRecord,
                        SrcRoleId,SrcPId,SrcRoleName,FamilyId,FamilyName) ->
    InviteToc = #m_family_invite_toc{op_type=DataRecord#m_family_invite_tos.op_type,
                                     invited_role_id=DataRecord#m_family_invite_tos.invited_role_id,
                                     family_id=FamilyId,
                                     family_name=FamilyName,
                                     src_role_id=SrcRoleId,
                                     src_role_name=SrcRoleName,
                                     op_code=0},
    common_misc:unicast(InviteRolePId,?FAMILY,?FAMILY_INVITE,InviteToc),
    SendSelf = #m_family_invite_toc{op_type=DataRecord#m_family_invite_tos.op_type,
                                    invited_role_id=DataRecord#m_family_invite_tos.invited_role_id,
                                    op_code=0},
    common_misc:unicast(SrcPId,?FAMILY,?FAMILY_INVITE,SendSelf),
    ok.

%% 同意邀请
do_family_invite_accept(_Module,_Method,DataRecord,RoleId,PId,
                        RoleBase,FamilyPId) ->
    #p_role_base{role_name=RoleName,faction_id=FactionId,level=RoleLevel} = RoleBase,
    Param = {admin_invite_accept,{DataRecord,RoleId,PId,RoleName,FactionId,RoleLevel}},
    common_family:send_to_family(FamilyPId, {mod,mod_family,Param}),
    ok.
do_admin_invite_accept({DataRecord,RoleId,PId,RoleName,FactionId,RoleLevel}) ->
    case catch do_admin_invite_accept2(RoleId,DataRecord,FactionId) of
        {error,OpCode} ->
            do_family_invite_error(?FAMILY,?FAMILY_INVITE,DataRecord,RoleId,PId,OpCode);
        {ok,FamilyInfo} ->
            do_admin_invite_accept3(DataRecord,RoleId,PId,RoleName,RoleLevel,FamilyInfo)
    end.
do_admin_invite_accept2(RoleId,DataRecord,FactionId) ->
    #m_family_invite_tos{family_id=FamilyId} = DataRecord,
    case get_family(FamilyId) of
        {ok,FamilyInfo} ->
            next;
        _ ->
            FamilyInfo = undefined,
            erlang:throw({error,?_RC_FAMILY_INVITE_011})
    end,
    case FactionId =:= FamilyInfo#r_family.faction_id of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_INVITE_012})
    end,
    case lists:keyfind(RoleId, #r_family_request.role_id, FamilyInfo#r_family.request_list) of
        false ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_INVITE_013})
    end,
    {ok,FamilyInfo}.
do_admin_invite_accept3(DataRecord,RoleId,PId,RoleName,RoleLevel,FamilyInfo) ->
    #m_family_invite_tos{src_role_id=SrcRoleId,family_id=FamilyId} = DataRecord,
    [MaxRequestNumber] = cfg_family:find({max_family_request_number}),
    FamilyRequest = #r_family_request{role_id=RoleId,
                                      role_name=RoleName,
                                      role_level=RoleLevel,
                                      op_time=common_tool:now(),
                                      src_role_id=SrcRoleId},
    RequestList = [FamilyRequest|FamilyInfo#r_family.request_list],
    CurLen = erlang:length(RequestList),
    case CurLen > MaxRequestNumber of
        true ->
            NewRequestList = lists:sublist(RequestList, 1, MaxRequestNumber),
            DelRequestList = lists:sublist(RequestList, MaxRequestNumber, CurLen);
        _ ->
            NewRequestList = RequestList,
            DelRequestList = []
    end,
	PRequestList = #p_family_request{role_id=RoleId,
										role_name=RoleName,
										level=RoleLevel,
										op_time=FamilyRequest#r_family_request.op_time},
    
    NewFamilyInfo = FamilyInfo#r_family{request_list = NewRequestList},
    set_family(FamilyId, NewFamilyInfo),
    
    SrcToc = #m_family_invite_toc{op_type=DataRecord#m_family_invite_tos.op_type,
                                    invited_role_id=DataRecord#m_family_invite_tos.invited_role_id,
                                    family_id=DataRecord#m_family_invite_tos.family_id,
                                    src_role_id = DataRecord#m_family_invite_tos.src_role_id,
                                    op_code=0},
    common_misc:unicast({role,SrcRoleId},?FAMILY,?FAMILY_INVITE,SrcToc),
    
    SendSelf = #m_family_invite_toc{op_type=DataRecord#m_family_invite_tos.op_type,
                                    invited_role_id=DataRecord#m_family_invite_tos.invited_role_id,
                                    family_id=DataRecord#m_family_invite_tos.family_id,
                                    src_role_id = DataRecord#m_family_invite_tos.src_role_id,
                                    op_code=0},
    common_misc:unicast(PId,?FAMILY,?FAMILY_INVITE,SendSelf),
    
    BCSelf = #m_family_request_toc{family_id=FamilyId,
                                     op_code=0,
                                     role_id=RoleId,
                                     request_info=PRequestList,
                                     del_ids=[ DelId || #r_family_request{role_id=DelId} <- DelRequestList]},
    broadcast(NewFamilyInfo#r_family.member_list,?FAMILY,?FAMILY_REQUEST,BCSelf),
    ok.
    
%% 拒绝邀请
do_family_invite_refuse(Module,Method,DataRecord,_RoleId,PId) ->
    SrcRoleId = DataRecord#m_family_invite_tos.src_role_id,
    SrcToc = #m_family_invite_toc{op_type=DataRecord#m_family_invite_tos.op_type,
                                  invited_role_id=DataRecord#m_family_invite_tos.invited_role_id,
                                  family_id=DataRecord#m_family_invite_tos.family_id,
                                  src_role_id = DataRecord#m_family_invite_tos.src_role_id,
                                  op_code=0},
    common_misc:unicast({role,SrcRoleId},Module,Method,SrcToc),
    
    SendSelf = #m_family_invite_toc{op_type=DataRecord#m_family_invite_tos.op_type,
                                    invited_role_id=DataRecord#m_family_invite_tos.invited_role_id,
                                    family_id=DataRecord#m_family_invite_tos.family_id,
                                    src_role_id = DataRecord#m_family_invite_tos.src_role_id,
                                    op_code=0},
    common_misc:unicast(PId,Module,Method,SendSelf),
    ok.
do_family_invite_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_family_invite_toc{op_type=DataRecord#m_family_invite_tos.op_type,
                                    invited_role_id=DataRecord#m_family_invite_tos.invited_role_id,
                                    op_code=OpCode},
    common_misc:unicast(PId,Module,Method,SendSelf),
    ok.

-define(family_accept_op_type_one,1).      %% 1同意单个玩家
-define(family_accept_op_type_all,2).      %% 2同意全部申请列表
-define(family_accept_op_type_notice,3).   %% 3加入帮派通知
%% 同意玩家申请加入帮派
do_family_accept(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_family_accept2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_family_accept_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,FamilyPId} ->
            do_family_accept3(Module,Method,DataRecord,RoleId,PId,
                              FamilyPId)
    end.
do_family_accept2(RoleId,DataRecord) ->
    #m_family_accept_tos{op_type=OpType,role_id=AcceptRoleId} = DataRecord,
    case OpType of
        ?family_accept_op_type_one ->
            case AcceptRoleId > 0 of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_FAMILY_ACCEPT_001})
            end,
            JoinTime = get_member_last_join_time(AcceptRoleId),
            case JoinTime =/= 0 andalso common_misc:is_reset_times(JoinTime) =:= false of
                true ->
                    erlang:throw({error,?_RC_FAMILY_ACCEPT_005});
                _ ->
                    next
            end;
        ?family_accept_op_type_all ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_ACCEPT_001})
    end,
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,?_RC_FAMILY_ACCEPT_000})
    end,
    case RoleBase#p_role_base.family_id > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_ACCEPT_002})
    end,
    case common_family:get_family_pid(RoleBase#p_role_base.family_id) of
        undefined ->
            FamilyPId = undefined,
            erlang:throw({error,?_RC_FAMILY_ACCEPT_000});
        FamilyPId ->
            next
    end,
    {ok,FamilyPId}.
do_family_accept3(Module,Method,DataRecord,RoleId,PId,
                  FamilyPId) ->
    Param = {admin_accept,{Module,Method,DataRecord,RoleId,PId}},
    common_family:send_to_family(FamilyPId, {mod,mod_family,Param}),
    ok.
do_admin_accept({Module,Method,DataRecord,RoleId,PId}) ->
    case catch do_admin_accept2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_family_accept_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,FamilyInfo} ->
            do_admin_accept3(Module,Method,DataRecord,RoleId,PId,FamilyInfo)
    end.
do_admin_accept2(RoleId,DataRecord) ->
    #m_family_accept_tos{op_type=OpType,role_id=AcceptRoleId} = DataRecord,
    #r_family_state{family_id=FamilyId} = family_server:get_family_state(),
    case get_family_member(RoleId) of
        {ok,FamilyMember} ->
            next;
        _ ->
            FamilyMember = undefined,
            erlang:throw({error,?_RC_FAMILY_ACCEPT_002})
    end,
    case FamilyMember#r_family_member.office_code of
        ?FAMILY_MEMBER_OFFICE_TUAN_ZHANG ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_ACCEPT_002})
    end,
    case get_family(FamilyId) of
        {ok,FamilyInfo} ->
            next;
        _ ->
            FamilyInfo = undefined,
            erlang:throw({error,?_RC_FAMILY_ACCEPT_000})
    end,
    case FamilyInfo#r_family.owner_role_id =:= RoleId of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_ACCEPT_002})
    end,
    case OpType of
        ?family_accept_op_type_one ->
            case lists:keyfind(AcceptRoleId, #r_family_request.role_id, FamilyInfo#r_family.request_list) of
                false ->
                    erlang:throw({error,?_RC_FAMILY_ACCEPT_003});
                _ ->
                    next
            end;
        ?family_accept_op_type_all ->
            case FamilyInfo#r_family.request_list of
                [] ->
                    erlang:throw({error,?_RC_FAMILY_ACCEPT_004});
                _ ->
                    next
            end
    end,
    {ok,FamilyInfo}.
do_admin_accept3(Module,Method,DataRecord,_RoleId,PId,FamilyInfo) ->
    #m_family_accept_tos{op_type=OpType,role_id=AcceptRoleId} = DataRecord,
    case OpType of
        ?family_accept_op_type_one ->
            AcceptRoleIdList = [AcceptRoleId];
        ?family_accept_op_type_all ->
            AcceptRoleIdList = [ PAcceptRoleId || #r_family_request{role_id=PAcceptRoleId} <- FamilyInfo#r_family.request_list ]
    end,
    SendSelf = #m_family_accept_toc{op_type=DataRecord#m_family_accept_tos.op_type,
                                    role_id=DataRecord#m_family_accept_tos.role_id,
                                    op_code=0},
    common_misc:unicast(PId,Module,Method,SendSelf),
    %% 处理加入帮派操作
    #r_family{family_id=FamilyId} = FamilyInfo,
    do_family_join(AcceptRoleIdList,FamilyId),
    ok.
    
do_family_accept_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_family_accept_toc{op_type=DataRecord#m_family_accept_tos.op_type,
                                    role_id=DataRecord#m_family_accept_tos.role_id,
                                    op_code=OpCode},
    common_misc:unicast(PId,Module,Method,SendSelf),
    ok.

do_family_join([],FamilyId) ->
    do_reset_family_member_office(FamilyId);
do_family_join([RoleId|RoleIdList],FamilyId) ->
    case erlang:whereis(common_misc:get_role_world_process_name(RoleId)) of
        undefined -> %% 离线加帮派
            do_family_join_offline(FamilyId,RoleId);
        RolePId ->
            do_family_join_online(FamilyId,RoleId,RolePId)
    end,
    common_family:send_to_family(erlang:self(), {mod,mod_family,{family_join,{RoleIdList,FamilyId}}}).

%% 离线加帮派
do_family_join_offline(FamilyId,RoleId) ->
    case catch do_family_join_offline2(FamilyId,RoleId) of
        {error,Error} ->
            ?ERROR_MSG("~ts,FamilyId=~w,RoleId=~w,Error=~w",[?_LANG_LOCAL_019,FamilyId,RoleId,Error]);
        {ignore,_Reason} ->
            ignore;
        {ok,RoleBase,FamilyInfo} ->
            do_family_join_offline3(FamilyId,RoleId,RoleBase,FamilyInfo)
    end.
do_family_join_offline2(FamilyId,RoleId) ->
    case get_family(FamilyId) of
        {ok,FamilyInfo} ->
            next;
        _ ->
            FamilyInfo = undefined,
            erlang:throw({error,not_family_info})
    end,
    case common_misc:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,not_role_base})
    end,
    #r_family{faction_id = FactionId,
              cur_pop = CurPop, max_pop = MaxPop} = FamilyInfo,
    case CurPop >= MaxPop of
        true ->
            erlang:throw({ignore,max_family_pop});
        _ ->
            next
    end,
    case RoleBase#p_role_base.family_id of
        0 ->
            next;
        _ ->
            erlang:throw({ignore,role_has_family})
    end,
    [MinRoleLevel] = cfg_family:find({join_family,min_role_level}),
    case RoleBase#p_role_base.level >= MinRoleLevel of
        true ->
            next;
        _ ->
            erlang:throw({error,join_min_level})
    end,
    case RoleBase#p_role_base.faction_id =:= FactionId of
        true ->
            next;
        _ ->
            erlang:throw({error,diff_faction_id})
    end,
    JoinTime = get_member_last_join_time(RoleId),
    case JoinTime =/= 0 andalso common_misc:is_reset_times(JoinTime) =:= false of
        true ->
            erlang:throw({error,?_RC_FAMILY_ACCEPT_005});
        _ ->
            next
    end,
    {ok,RoleBase,FamilyInfo}.
do_family_join_offline3(FamilyId,RoleId,RoleBase,FamilyInfo) ->
    #r_family{family_name = FamilyName,
              cur_pop = CurPop,
              member_list = MemberList,
              request_list = RequestList} = FamilyInfo,
    NowSeconds = common_tool:now(),
    FamilyMember = get_r_family_member(RoleId,RoleBase,NowSeconds),
	NewFamilyMember = FamilyMember#r_family_member{is_online=?FAMILY_MEMBER_OFFLINE},
    NewMemberList = [RoleId|MemberList],
    NewRequestList = lists:keydelete(RoleId, #r_family_request.role_id, RequestList),
    NewFamilyInfo = FamilyInfo#r_family{cur_pop = CurPop + 1,
                                        member_list=NewMemberList,
                                        request_list=NewRequestList},
    set_family(FamilyId,NewFamilyInfo),
    set_family_member(RoleId, NewFamilyMember),
    NewRoleBase = RoleBase#p_role_base{family_id=FamilyId,family_name=FamilyName},
    db_api:dirty_write(?DB_ROLE_BASE, NewRoleBase),
    %% 加入帮派
    hook_family:join_family({RoleId,FamilyId,FamilyName}),
    %% 通知广播
    BCSelf = #m_family_accept_toc{op_type=?family_accept_op_type_notice,
                                  role_id=RoleId,
                                  op_code=0,
								  family_id=FamilyId,
                                  member_list = [get_p_family_member(NewFamilyMember)],
                                  attr_list=[#p_attr{attr_code=?FAMILY_CUR_POP,int_value=CurPop + 1}],
                                  del_ids=[RoleId]},
    broadcast(NewFamilyInfo#r_family.member_list,?FAMILY,?FAMILY_ACCEPT,BCSelf),
    ok.
%% 在线加帮派
do_family_join_online(FamilyId,RoleId,RolePId) ->
    case catch do_family_join_online2(FamilyId) of
        {error,Error} ->
            ?ERROR_MSG("~ts,FamilyId=~w,RoleId=~w,Error=~w",[?_LANG_LOCAL_020,FamilyId,RoleId,Error]);
        {ignore,_Reason} ->
            ignore;
        {ok,FamilyInfo} ->
            #r_family{family_name = FamilyName,faction_id=FactionId} = FamilyInfo,
            Param = {admin_family_join,{RoleId,FamilyId,FamilyName,erlang:self(),FactionId}},
            common_misc:send_to_role(RolePId, {mod,mod_family,Param})
    end.
do_family_join_online2(FamilyId) ->
    case get_family(FamilyId) of
        {ok,FamilyInfo} ->
            next;
        _ ->
            FamilyInfo = undefined,
            erlang:throw({error,not_family_info})
    end,
    #r_family{cur_pop = CurPop, max_pop = MaxPop} = FamilyInfo,
    case CurPop >= MaxPop of
        true ->
            erlang:throw({ignore,max_family_pop});
        _ ->
            next
    end,
    {ok,FamilyInfo}.
    

do_admin_family_join({RoleId,FamilyId,FamilyName,FamilyPId,FactionId}) ->
    case catch do_admin_family_join2(RoleId,FactionId) of
        {error,Error} ->
            ?ERROR_MSG("~ts,FamilyId=~w,RoleId=~w,Error=~w",[?_LANG_LOCAL_020,FamilyId,RoleId,Error]);
        {ignore,_Reason} ->
            ignore;
        {ok,RoleBase} ->
            do_admin_family_join3(RoleId,FamilyId,FamilyName,FamilyPId,RoleBase)
    end.
do_admin_family_join2(RoleId,FactionId) ->
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,not_role_base})
    end,
     case RoleBase#p_role_base.family_id of
        0 ->
            next;
        _ ->
            erlang:throw({ignore,role_has_family})
    end,
    [MinRoleLevel] = cfg_family:find({join_family,min_role_level}),
    case RoleBase#p_role_base.level >= MinRoleLevel of
        true ->
            next;
        _ ->
            erlang:throw({error,join_min_level})
    end,
    case RoleBase#p_role_base.faction_id =:= FactionId of
        true ->
            next;
        _ ->
            erlang:throw({error,diff_faction_id})
    end,
    JoinTime = get_member_last_join_time(RoleId),
    case JoinTime =/= 0 andalso common_misc:is_reset_times(JoinTime) =:= false of
        true ->
            erlang:throw({error,?_RC_FAMILY_ACCEPT_005});
        _ ->
            next
    end,
    {ok,RoleBase}.
do_admin_family_join3(RoleId,FamilyId,FamilyName,FamilyPId,RoleBase) ->
    NewRoleBase = RoleBase#p_role_base{family_id=FamilyId,family_name=FamilyName},
    case common_transaction:transaction(
           fun() ->
                   mod_role:t_set_role_base(RoleId, NewRoleBase),
                   {ok}
           end) of
        {atomic,{ok}} -> 
            NowSeconds = common_tool:now(),
            FamilyMember = get_r_family_member(RoleId,RoleBase,NowSeconds),
            Param = {admin_family_join_final,{FamilyId,RoleId,FamilyMember}},
            common_family:send_to_family(FamilyPId, {mod,mod_family,Param}),
            ok;
        {aborted, Error} ->
            ?ERROR_MSG("~ts,FamilyId=~w,RoleId=~w,Error=~w",[?_LANG_LOCAL_020,FamilyId,RoleId,Error])
    end.
do_admin_family_join_final({FamilyId,RoleId,FamilyMember}) ->
    {ok,FamilyInfo} = get_family(FamilyId),
    #r_family{family_name=FamilyName,
			  cur_pop = CurPop,
              member_list = MemberList,
              request_list = RequestList} = FamilyInfo,
    NewMemberList = [RoleId|MemberList],
    NewRequestList = lists:keydelete(RoleId, #r_family_request.role_id, RequestList),
    NewFamilyInfo = FamilyInfo#r_family{cur_pop = CurPop + 1,
                                        member_list=NewMemberList,
                                        request_list=NewRequestList},
    set_family(FamilyId,NewFamilyInfo),
    set_family_member(RoleId, FamilyMember),
    %% 加入帮派
    hook_family:join_family({RoleId,FamilyId,FamilyName}),
    %% 通知广播
    BCSelf = #m_family_accept_toc{op_type=?family_accept_op_type_notice,
                                  role_id=RoleId,
                                  op_code=0,
								  family_id=FamilyId,
                                  member_list = [get_p_family_member(FamilyMember)],
                                  attr_list=[#p_attr{attr_code=?FAMILY_CUR_POP,int_value=CurPop + 1}],
                                  del_ids=[RoleId]},
    broadcast(NewFamilyInfo#r_family.member_list,?FAMILY,?FAMILY_ACCEPT,BCSelf),
    ok.

-define(family_refuse_op_type_one,1).       %% 1拒绝单个玩家
-define(family_refuse_op_type_all,2).       %% 2拒绝全部申请列表
-define(family_refuse_op_type_notice,3).    %% 3拒绝帮派通知
%% 拒绝玩家申请加入帮派
do_family_refuse(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_family_refuse2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_family_refuse_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,FamilyPId} ->
            do_family_refuse3(Module,Method,DataRecord,RoleId,PId,FamilyPId)
    end.
do_family_refuse2(RoleId,DataRecord) ->
    #m_family_refuse_tos{op_type=OpType,role_id=DelRoleId} = DataRecord,
    case OpType of
        ?family_refuse_op_type_one ->
            case DelRoleId > 0 andalso erlang:is_integer(DelRoleId) of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_FAMILY_REFUSE_001})
            end;
        ?family_refuse_op_type_all ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_REFUSE_001})
    end,
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,?_RC_FAMILY_REFUSE_000})
    end,
    case RoleBase#p_role_base.family_id > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_REFUSE_002})
    end,
    case common_family:get_family_pid(RoleBase#p_role_base.family_id) of
        undefined ->
            FamilyPId = undefined,
            erlang:throw({error,?_RC_FAMILY_REFUSE_000});
        FamilyPId ->
            next
    end,
    {ok,FamilyPId}.
do_family_refuse3(Module,Method,DataRecord,RoleId,PId,FamilyPId) ->
    Param = {admin_refuse,{Module,Method,DataRecord,RoleId,PId}},
    common_family:send_to_family(FamilyPId, {mod,mod_family,Param}),
    ok.
do_admin_refuse({Module,Method,DataRecord,RoleId,PId}) ->
    case catch do_admin_refuse2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_family_refuse_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,FamilyInfo} ->
            do_admin_refuse3(Module,Method,DataRecord,RoleId,PId,FamilyInfo)
    end.
do_admin_refuse2(RoleId,DataRecord) ->
    #m_family_refuse_tos{op_type=OpType,role_id=DelRoleId} = DataRecord,
    #r_family_state{family_id=FamilyId} = family_server:get_family_state(),
    case get_family_member(RoleId) of
        {ok,FamilyMember} ->
            next;
        _ ->
            FamilyMember = undefined,
            erlang:throw({error,?_RC_FAMILY_REFUSE_002})
    end,
    case FamilyMember#r_family_member.office_code of
        ?FAMILY_MEMBER_OFFICE_TUAN_ZHANG ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_REFUSE_002})
    end,
    case get_family(FamilyId) of
        {ok,FamilyInfo} ->
            next;
        _ ->
            FamilyInfo = undefined,
            erlang:throw({error,?_RC_FAMILY_REFUSE_000})
    end,
    case FamilyInfo#r_family.owner_role_id =:= RoleId of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_REFUSE_002})
    end,
    case OpType of
        ?family_refuse_op_type_one ->
            case lists:keyfind(DelRoleId, #r_family_request.role_id, FamilyInfo#r_family.request_list) of
                false ->
                    erlang:throw({error,?_RC_FAMILY_REFUSE_003});
                _ ->
                    next
            end;
        ?family_refuse_op_type_all ->
            case FamilyInfo#r_family.request_list of
                [] ->
                    erlang:throw({error,?_RC_FAMILY_REFUSE_004});
                _ ->
                    next
            end
    end,
    {ok,FamilyInfo}.
do_admin_refuse3(Module,Method,DataRecord,_RoleId,PId,FamilyInfo) ->
    #m_family_refuse_tos{op_type=OpType,role_id=DelRoleId} = DataRecord,
    #r_family{family_id = FamilyId,request_list = RequestList,member_list=MemberList} = FamilyInfo,
    
    case OpType of
        ?family_refuse_op_type_one ->
            DelRoleIdList = [DelRoleId],
            NewRequestList = lists:keydelete(DelRoleId, #r_family_request.role_id, RequestList);
        ?family_refuse_op_type_all ->
            DelRoleIdList = [PDelRoleId || #r_family_request{role_id=PDelRoleId} <- RequestList],
            NewRequestList = []
    end,
    NewFamilyInfo = FamilyInfo#r_family{request_list = NewRequestList},
    set_family(FamilyId, NewFamilyInfo),
    SendSelf = #m_family_refuse_toc{op_type=DataRecord#m_family_refuse_tos.op_type,
                                    role_id=DataRecord#m_family_refuse_tos.role_id,
                                    op_code=0,
                                    del_ids=DelRoleIdList},
    common_misc:unicast(PId,Module,Method,SendSelf),
    %% 广播
    BCSelf = #m_family_refuse_toc{op_type=?family_refuse_op_type_notice,
                                    role_id=DataRecord#m_family_refuse_tos.role_id,
                                    op_code=0,
                                    del_ids=DelRoleIdList},
    broadcast(MemberList, Module, Method, BCSelf),
    ok.
do_family_refuse_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_family_refuse_toc{op_type=DataRecord#m_family_refuse_tos.op_type,
                                    role_id=DataRecord#m_family_refuse_tos.role_id,
                                    op_code=OpCode},
    common_misc:unicast(PId,Module,Method,SendSelf),
    ok.
%% 解散帮派
do_family_disband(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_family_disband2(RoleId) of
        {error,OpCode} ->
            do_family_disband_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,FamilyPId} ->
            do_family_disband3(Module,Method,DataRecord,RoleId,PId,FamilyPId)
    end.
do_family_disband2(RoleId) ->
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,?_RC_FAMILY_DISBAND_000})
    end,
    case RoleBase#p_role_base.family_id > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_DISBAND_001})
    end,
    case common_family:get_family_pid(RoleBase#p_role_base.family_id) of
        undefined ->
            FamilyPId = undefined,
            erlang:throw({error,?_RC_FAMILY_DISBAND_000});
        FamilyPId ->
            next
    end,
    {ok,FamilyPId}.
do_family_disband3(Module,Method,DataRecord,RoleId,PId,FamilyPId) ->
    Param = {admin_disband,{Module,Method,DataRecord,RoleId,PId}},
    common_family:send_to_family(FamilyPId, {mod,mod_family,Param}),
    ok.
do_admin_disband({Module,Method,DataRecord,RoleId,PId}) ->
    case catch do_admin_disband2(RoleId) of
        {error,OpCode} ->
            do_family_disband_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,FamilyInfo} ->
            do_admin_disband3(Module,Method,DataRecord,RoleId,PId,FamilyInfo)
    end.
do_admin_disband2(RoleId) ->
    #r_family_state{family_id=FamilyId} = family_server:get_family_state(),
    case get_family_member(RoleId) of
        {ok,FamilyMember} ->
            next;
        _ ->
            FamilyMember = undefined,
            erlang:throw({error,?_RC_FAMILY_DISBAND_000})
    end,
    case FamilyMember#r_family_member.office_code of
        ?FAMILY_MEMBER_OFFICE_TUAN_ZHANG ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_DISBAND_002})
    end,
    case get_family(FamilyId) of
        {ok,FamilyInfo} ->
            next;
        _ ->
            FamilyInfo = undefined,
            erlang:throw({error,?_RC_FAMILY_DISBAND_000})
    end,
    case FamilyInfo#r_family.owner_role_id =:= RoleId of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_DISBAND_002})
    end,
    case FamilyInfo#r_family.cur_pop of
        1 ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_DISBAND_003})
    end,
    case FamilyInfo#r_family.member_list =:= [RoleId] of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_DISBAND_003})
    end,
    {ok,FamilyInfo}.
do_admin_disband3(Module,Method,_DataRecord,_RoleId,PId,FamilyInfo) ->
    SendSelf = #m_family_disband_toc{op_code=0},
    common_misc:unicast(PId,Module,Method,SendSelf),
    #r_family{family_id = FamilyId,member_list = MemberList} = FamilyInfo,
    BCSelf = #m_family_disband_toc{op_code=0},
    broadcast(MemberList,?FAMILY,?FAMILY_DISBAND,BCSelf),
    do_family_out(MemberList,FamilyId,?FAMILY_OUT_TYPE_DISBAND),
    ok.

do_family_disband_error(Module,Method,_DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_family_disband_toc{op_code=OpCode},
    common_misc:unicast(PId,Module,Method,SendSelf),
    ok.


%% 开除帮派成员
do_family_out([],FamilyId,_OutType) ->
    do_reset_family_member_office(FamilyId);
do_family_out([RoleId|RoleIdList],FamilyId,OutType) ->
    case erlang:whereis(common_misc:get_role_world_process_name(RoleId)) of
        undefined -> %% 离线退出帮派
            do_family_out_offline(FamilyId,RoleId,OutType);
        RolePId ->
            do_family_out_online(FamilyId,RoleId,OutType,RolePId)
    end,
    common_family:send_to_family(erlang:self(), {mod,mod_family,{family_out,{RoleIdList,FamilyId}}}).
%% 离线退出帮派
do_family_out_offline(FamilyId,RoleId,OutType) ->
    case catch do_family_out_offline2(RoleId,FamilyId) of
        {error,Error} ->
             ?ERROR_MSG("~ts,FamilyId=~w,RoleId=~w,Error=~w",[?_LANG_LOCAL_021,FamilyId,RoleId,Error]);
        {ignore,_Reason} ->
            next;
        {ok,RoleBase,FamilyInfo} ->
            do_family_out_offline3(FamilyId,RoleId,OutType,RoleBase,FamilyInfo)
    end.
do_family_out_offline2(RoleId,FamilyId) ->
    case get_family(FamilyId) of
        {ok,FamilyInfo} ->
            next;
        _ ->
            FamilyInfo = undefined,
            erlang:throw({error,not_family_info})
    end,
    case common_misc:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,not_role_base})
    end,
    case RoleBase#p_role_base.family_id =:= FamilyId of
        true ->
            next;
        _ ->
            erlang:throw({error,diff_family_id})
    end,
    {ok,RoleBase,FamilyInfo}.
do_family_out_offline3(FamilyId,RoleId,OutType,RoleBase,FamilyInfo) ->
    #r_family{cur_pop = CurPop,
              member_list = MemberList} = FamilyInfo,
    NewMemberList = lists:delete(RoleId, MemberList),
    NewFamilyInfo = FamilyInfo#r_family{cur_pop = CurPop - 1,
                                        member_list=NewMemberList},
    set_family(FamilyId,NewFamilyInfo),
    erase_family_member(RoleId),
    NewRoleBase = RoleBase#p_role_base{family_id=0,family_name=""},
    db_api:dirty_write(?DB_ROLE_BASE, NewRoleBase),
    %% 离开帮派
    hook_family:leave_family({RoleId,FamilyId}),
    %% 通知广播
    case OutType of
        ?FAMILY_OUT_TYPE_DISBAND -> 
            ignore;
        ?FAMILY_OUT_TYPE_LEAVE ->
            SendSelf = #m_family_leave_toc{role_id=RoleId,
                                           op_code=0,
                                           role_name = NewRoleBase#p_role_base.role_name,
                                           attr_list=[#p_attr{attr_code=?FAMILY_CUR_POP,int_value=CurPop - 1}]},
            broadcast(NewMemberList,?FAMILY,?FAMILY_LEAVE,SendSelf);
        ?FAMILY_OUT_TYPE_FIRE ->
            SendSelf = #m_family_fire_toc{role_id=RoleId,
                                          op_code=0,
                                          role_name = NewRoleBase#p_role_base.role_name,
                                          attr_list=[#p_attr{attr_code=?FAMILY_CUR_POP,int_value=CurPop - 1}]},
            broadcast(NewMemberList,?FAMILY,?FAMILY_FIRE,SendSelf);
        _ ->
            ignore
    end,
    %% 如果帮派没有人员即解散帮派
    case NewMemberList of
        [] ->
            case OutType of
                ?FAMILY_OUT_TYPE_DISBAND ->  
                    do_destroy_family(family_king_disband);
                ?FAMILY_OUT_TYPE_LEAVE ->
                    do_destroy_family(family_member_leave);
                ?FAMILY_OUT_TYPE_FIRE ->
                    do_destroy_family(family_member_fire)
            end;
        _ ->
            next
    end,
    ok.
%% 在线退出帮派
do_family_out_online(FamilyId,RoleId,OutType,RolePId) ->
    Param = {mod,mod_family,{admin_family_out,{FamilyId,RoleId,OutType,erlang:self()}}},
    common_misc:send_to_role(RolePId, Param).
%% 玩家进程处理
do_admin_family_out({FamilyId,RoleId,OutType,FamilyPId}) ->
    case catch do_admin_family_out2(RoleId) of
        {error,Error} ->
             ?ERROR_MSG("~ts,FamilyId=~w,RoleId=~w,Error=~w",[?_LANG_LOCAL_021,FamilyId,RoleId,Error]);
        {ok,RoleBase} ->
            do_admin_family_out3(FamilyId,RoleId,OutType,FamilyPId,RoleBase)
    end.
do_admin_family_out2(RoleId) ->
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,not_role_base})
    end,
    {ok,RoleBase}.
do_admin_family_out3(FamilyId,RoleId,OutType,FamilyPId,RoleBase) ->
    case RoleBase#p_role_base.family_id =:= FamilyId of
        true ->
            NewRoleBase = RoleBase#p_role_base{family_id=0,family_name=""},
            case common_transaction:transaction(
                   fun() ->
                           mod_role:t_set_role_base(RoleId, NewRoleBase),
                           {ok}
                   end) of
                {atomic,{ok}} -> 
                    next;
                {aborted, Error} ->
                    ?ERROR_MSG("~ts,FamilyId=~w,RoleId=~w,Error=~w",[?_LANG_LOCAL_022,FamilyId,RoleId,Error])
            end;
        _ ->
            next
    end,
    RoleName = RoleBase#p_role_base.role_name,
    Param = {admin_family_out_final,{FamilyId,RoleId,OutType,RoleName}},
    common_family:send_to_family(FamilyPId, {mod,mod_family,Param}),
    ok.
do_admin_family_out_final({FamilyId,RoleId,OutType,RoleName}) ->
    {ok,FamilyInfo} = get_family(FamilyId),
    #r_family{cur_pop = CurPop,
              member_list = MemberList} = FamilyInfo,
    NewMemberList = lists:delete(RoleId, MemberList),
    NewFamilyInfo = FamilyInfo#r_family{cur_pop = CurPop - 1,
                                        member_list=NewMemberList},
    set_family(FamilyId,NewFamilyInfo),
    erase_family_member(RoleId),
    %% 离开帮派
    hook_family:leave_family({RoleId,FamilyId}),
    %% 通知广播
    case OutType of
        ?FAMILY_OUT_TYPE_DISBAND -> 
            ignore;
        ?FAMILY_OUT_TYPE_LEAVE ->
            SendSelf = #m_family_leave_toc{role_id=RoleId,
                                           op_code=0,
                                           role_name = RoleName,
                                           attr_list=[#p_attr{attr_code=?FAMILY_CUR_POP,int_value=CurPop - 1}]},
            broadcast(NewMemberList,?FAMILY,?FAMILY_LEAVE,SendSelf);
        ?FAMILY_OUT_TYPE_FIRE ->
            SendSelf = #m_family_fire_toc{role_id=RoleId,
                                          op_code=0,
                                          role_name = RoleName,
                                          attr_list=[#p_attr{attr_code=?FAMILY_CUR_POP,int_value=CurPop - 1}]},
            broadcast(NewMemberList,?FAMILY,?FAMILY_FIRE,SendSelf);
        _ ->
            ignore
    end,
    %% 如果帮派没有人员即解散帮派
    case NewMemberList of
        [] ->
            case OutType of
                ?FAMILY_OUT_TYPE_DISBAND ->  
                    do_destroy_family(family_king_disband);
                ?FAMILY_OUT_TYPE_LEAVE ->
                    do_destroy_family(family_member_leave);
                ?FAMILY_OUT_TYPE_FIRE ->
                    do_destroy_family(family_member_fire)
            end;
        _ ->
            next
    end,
    ok.
%% 开除帮派
do_family_fire(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_family_fire2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_family_fire_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,FamilyPId} ->
            do_family_fire3(Module,Method,DataRecord,RoleId,PId,FamilyPId)
    end.
do_family_fire2(RoleId,DataRecord) ->
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,?_RC_FAMILY_FIRE_000})
    end,
    case RoleId =:= DataRecord#m_family_fire_tos.role_id of
        true ->
            erlang:throw({error,?_RC_FAMILY_FIRE_003});
        _ ->
            next
    end,
    case RoleBase#p_role_base.family_id > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_FIRE_001})
    end,
    case common_family:get_family_pid(RoleBase#p_role_base.family_id) of
        undefined ->
            FamilyPId = undefined,
            erlang:throw({error,?_RC_FAMILY_FIRE_000});
        FamilyPId ->
            next
    end,
    {ok,FamilyPId}.
do_family_fire3(Module,Method,DataRecord,RoleId,PId,FamilyPId) ->
    Param = {admin_fire,{Module,Method,DataRecord,RoleId,PId}},
    common_family:send_to_family(FamilyPId, {mod,mod_family,Param}),
    ok.
do_admin_fire({Module,Method,DataRecord,RoleId,PId}) ->
    case catch do_admin_fire2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_family_fire_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,FamilyInfo} ->
            do_admin_fire3(Module,Method,DataRecord,RoleId,PId,FamilyInfo)
    end.
do_admin_fire2(RoleId,DataRecord) ->
    #m_family_fire_tos{role_id = FireRoleId} = DataRecord,
    #r_family_state{family_id=FamilyId} = family_server:get_family_state(),
    case get_family_member(RoleId) of
        {ok,FamilyMember} ->
            next;
        _ ->
            FamilyMember = undefined,
            erlang:throw({error,?_RC_FAMILY_FIRE_000})
    end,
    case FamilyMember#r_family_member.office_code of
        ?FAMILY_MEMBER_OFFICE_TUAN_ZHANG ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_FIRE_002})
    end,
    case get_family(FamilyId) of
        {ok,FamilyInfo} ->
            next;
        _ ->
            FamilyInfo = undefined,
            erlang:throw({error,?_RC_FAMILY_FIRE_000})
    end,
    case FamilyInfo#r_family.owner_role_id =:= RoleId of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_FIRE_002})
    end,
    case lists:member(FireRoleId, FamilyInfo#r_family.member_list) of
        false ->
            erlang:throw({error,?_RC_FAMILY_FIRE_004});
        _ ->
            next
    end,
    {ok,FamilyInfo}.
do_admin_fire3(Module,Method,DataRecord,_RoleId,PId,FamilyInfo) ->
    #m_family_fire_tos{role_id = FireRoleId} = DataRecord,
    SendSelf = #m_family_fire_toc{role_id=FireRoleId,op_code=0},
    common_misc:unicast(PId,Module,Method,SendSelf),
    
    case erlang:whereis(common_misc:get_role_world_process_name(FireRoleId)) of
        undefined ->
            next;
        _ ->
            FireSelf = #m_family_fire_toc{role_id=FireRoleId,op_code=0},
            common_misc:unicast({role,FireRoleId},Module,Method,FireSelf)
    end,
    #r_family{family_id=FamilyId} = FamilyInfo,
    do_family_out([FireRoleId],FamilyId,?FAMILY_OUT_TYPE_FIRE),
    ok.

do_family_fire_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_family_fire_toc{role_id=DataRecord#m_family_fire_tos.role_id,
                                  op_code=OpCode},
    common_misc:unicast(PId,Module,Method,SendSelf),
    ok.
%% 离开帮派
do_family_leave(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_family_leave2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_family_leave_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,FamilyPId} ->
            do_family_leave3(Module,Method,DataRecord,RoleId,PId,FamilyPId)
    end.
do_family_leave2(RoleId,_DataRecord) ->
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,?_RC_FAMILY_LEAVE_000})
    end,
    case RoleBase#p_role_base.family_id > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_LEAVE_001})
    end,
    case common_family:get_family_pid(RoleBase#p_role_base.family_id) of
        undefined ->
            FamilyPId = undefined,
            erlang:throw({error,?_RC_FAMILY_LEAVE_000});
        FamilyPId ->
            next
    end,
    {ok,FamilyPId}.
do_family_leave3(Module,Method,DataRecord,RoleId,PId,FamilyPId) ->
    Param = {admin_leave,{Module,Method,DataRecord,RoleId,PId}},
    common_family:send_to_family(FamilyPId, {mod,mod_family,Param}),
    ok.
do_admin_leave({Module,Method,DataRecord,RoleId,PId}) ->
    case catch do_admin_leave2(RoleId) of
        {error,OpCode} ->
            do_family_leave_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,FamilyInfo} ->
            do_admin_leave3(Module,Method,DataRecord,RoleId,PId,FamilyInfo)
    end.
do_admin_leave2(_RoleId) ->
    #r_family_state{family_id=FamilyId} = family_server:get_family_state(),
    case get_family(FamilyId) of
        {ok,FamilyInfo} ->
            next;
        _ ->
            FamilyInfo = undefined,
            erlang:throw({error,?_RC_FAMILY_LEAVE_000})
    end,
    {ok,FamilyInfo}.
do_admin_leave3(Module,Method,_DataRecord,RoleId,PId,FamilyInfo) ->
    SendSelf = #m_family_leave_toc{op_code=0},
    common_misc:unicast(PId,Module,Method,SendSelf),

    #r_family{family_id=FamilyId} = FamilyInfo,
    do_family_out([RoleId],FamilyId,?FAMILY_OUT_TYPE_LEAVE),
    ok.
do_family_leave_error(Module,Method,_DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_family_leave_toc{op_code=OpCode},
    common_misc:unicast(PId,Module,Method,SendSelf),
    ok.

do_family_turn(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_family_turn2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_family_turn_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,FamilyPId} ->
            do_family_turn3(Module,Method,DataRecord,RoleId,PId,FamilyPId)
    end.
do_family_turn2(RoleId,DataRecord) ->
    #m_family_turn_tos{role_id = NewLeaderRoleId} = DataRecord,
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,?_RC_FAMILY_TURN_000})
    end,
    case RoleId =:= NewLeaderRoleId of
        true ->
            erlang:throw({error,?_RC_FAMILY_TURN_003});
        _ ->
            next
    end,
    case RoleBase#p_role_base.family_id > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_TURN_001})
    end,
    case common_family:get_family_pid(RoleBase#p_role_base.family_id) of
        undefined ->
            FamilyPId = undefined,
            erlang:throw({error,?_RC_FAMILY_TURN_000});
        FamilyPId ->
            next
    end,
    {ok,FamilyPId}.

do_family_turn3(Module,Method,DataRecord,RoleId,PId,FamilyPId) ->
    Param = {admin_turn,{Module,Method,DataRecord,RoleId,PId}},
    common_family:send_to_family(FamilyPId, {mod,mod_family,Param}),
    ok.
do_admin_turn({Module,Method,DataRecord,RoleId,PId}) ->
    case catch do_admin_turn2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_family_turn_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,FamilyInfo,FamilyMember,NewFamilyMember} ->
            do_admin_turn3(Module,Method,DataRecord,RoleId,PId,
                           FamilyInfo,FamilyMember,NewFamilyMember)
    end.
do_admin_turn2(RoleId,DataRecord) ->
    #m_family_turn_tos{role_id = NewLeaderRoleId} = DataRecord,
    #r_family_state{family_id=FamilyId} = family_server:get_family_state(),
    case get_family(FamilyId) of
        {ok,FamilyInfo} ->
            next;
        _ ->
            FamilyInfo = undefined,
            erlang:throw({error,?_RC_FAMILY_TURN_000})
    end,
    case get_family_member(RoleId) of
        {ok,FamilyMember} ->
            next;
        _ ->
            FamilyMember = undefined,
            erlang:throw({error,?_RC_FAMILY_TURN_000})
    end,
    case FamilyInfo#r_family.owner_role_id =:= RoleId of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_TURN_002})
    end,
    case FamilyMember#r_family_member.office_code of
        ?FAMILY_MEMBER_OFFICE_TUAN_ZHANG ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_TURN_002})
    end,
    case lists:member(NewLeaderRoleId, FamilyInfo#r_family.member_list) of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_TURN_004})
    end,
    case get_family_member(NewLeaderRoleId) of
        {ok,NewFamilyMember} ->
            next;
        _ ->
            NewFamilyMember = undefined,
            erlang:throw({error,?_RC_FAMILY_TURN_000})
    end,
    {ok,FamilyInfo,FamilyMember,NewFamilyMember}.
do_admin_turn3(Module,Method,DataRecord,RoleId,PId,
               FamilyInfo,FamilyMember,NewFamilyMember) ->
    #r_family{family_id=FamilyId} = FamilyInfo,
    FamilyMember2=FamilyMember#r_family_member{office_code=?FAMILY_MEMBER_OFFICE_TUAN_YUAN},
    set_family_member(RoleId, FamilyMember2),
    #m_family_turn_tos{role_id = NewLeaderRoleId} = DataRecord,
    NewFamilyMember2=NewFamilyMember#r_family_member{office_code=?FAMILY_MEMBER_OFFICE_TUAN_ZHANG},
    set_family_member(NewLeaderRoleId, NewFamilyMember2),
    
    NewLeaderRoleName = NewFamilyMember2#r_family_member.role_name,
    NewFamilyInfo = FamilyInfo#r_family{owner_role_id=NewLeaderRoleId,
                                        owner_role_name=NewLeaderRoleName},
    set_family(FamilyId, NewFamilyInfo),
    
    
    AttrList = [#p_attr{attr_code=?FAMILY_OWNER_ROLE_ID,int_value=NewLeaderRoleId},
                #p_attr{attr_code=?FAMILY_OWNER_ROLE_NAME,string_value=NewLeaderRoleName}],
    SendSelf = #m_family_turn_toc{role_id=DataRecord#m_family_turn_tos.role_id,
                                         op_code=0,role_name=NewLeaderRoleName,
                                         attr_list=AttrList},
    common_misc:unicast(PId,Module,Method,SendSelf),
    
    BCSelf = #m_family_turn_toc{role_id=DataRecord#m_family_turn_tos.role_id,
                                op_code=0,role_name=NewLeaderRoleName,
                                attr_list=AttrList},
    BCRoleIdList = lists:delete(RoleId, NewFamilyInfo#r_family.member_list),
    broadcast(BCRoleIdList,Module,Method,BCSelf),
    
    do_reset_family_member_office(FamilyId),
    ok.
do_family_turn_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_family_turn_toc{role_id=DataRecord#m_family_turn_tos.role_id,
                                  op_code=OpCode},
    common_misc:unicast(PId,Module,Method,SendSelf),
    ok.

%% 设置帮派信息
do_admin_set({Module,Method,DataRecord,RoleId,PId}) ->
    case catch do_admin_set2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_admin_set_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,FamilyInfo,FamilyMember} ->
            do_admin_set3(Module,Method,DataRecord,RoleId,PId,
                          FamilyInfo,FamilyMember)
    end.
do_admin_set2(RoleId,_DataRecord) ->
    #r_family_state{family_id=FamilyId} = family_server:get_family_state(),
    case get_family(FamilyId) of
        {ok,FamilyInfo} ->
            next;
        _ ->
            FamilyInfo = undefined,
            erlang:throw({error,?_RC_FAMILY_SET_000})
    end,
    case get_family_member(RoleId) of
        {ok,FamilyMember} ->
            next;
        _ ->
            FamilyMember = undefined,
            erlang:throw({error,?_RC_FAMILY_SET_000})
    end,
    case FamilyInfo#r_family.owner_role_id =:= RoleId of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_SET_002})
    end,
    case FamilyMember#r_family_member.office_code of
        ?FAMILY_MEMBER_OFFICE_TUAN_ZHANG ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_SET_002})
    end,
    {ok,FamilyInfo,FamilyMember}.
do_admin_set3(Module,Method,DataRecord,_RoleId,PId,
              FamilyInfo,_FamilyMember) ->
    #m_family_set_tos{op_type = OpType,value=Value} = DataRecord,
    #r_family{family_id=FamilyId,member_list=MemberList} = FamilyInfo,
    case OpType of
        ?FAMILY_SET_OP_TYPE_PUBLIC_NOTICE ->
            NewFamilyInfo = FamilyInfo#r_family{public_notice=Value},
            set_family(FamilyId, NewFamilyInfo),
            
            SendSelf = #m_family_set_toc{op_type=DataRecord#m_family_set_tos.op_type,
                                         family_id=DataRecord#m_family_set_tos.family_id,
                                         role_id=DataRecord#m_family_set_tos.role_id,
                                         op_code= 0},
            common_misc:unicast(PId,Module,Method,SendSelf),
            
            AttrList = [#p_attr{attr_code=?FAMILY_PUBLIC_NOTICE,string_value=Value}],
            BCSelf=#m_family_attr_change_toc{op_type=0,family_id=FamilyId,role_id=0,attr_list=AttrList},
            broadcast(MemberList, ?FAMILY, ?FAMILY_ATTR_CHANGE, BCSelf),
            ok;
        _ ->
            ignroe
    end.

do_admin_set_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_family_set_toc{op_type=DataRecord#m_family_set_tos.op_type,
                                 family_id=DataRecord#m_family_set_tos.family_id,
                                 role_id=DataRecord#m_family_set_tos.role_id,
                                 op_code= OpCode},
    common_misc:unicast(PId,Module,Method,SendSelf),
    ok.

    


%% 销毁帮派进程
do_destroy_family(Reason) ->
    #r_family_state{family_id=FamilyId} = family_server:get_family_state(),
    %% 帮派信息
    db_api:dirty_delete(?DB_FAMILY, FamilyId),
    erlang:send(erlang:self(),{kill_family_process,Reason}).

do_reset_family_member_office() ->
     #r_family_state{family_id=FamilyId} = family_server:get_family_state(),
     do_reset_family_member_office(FamilyId).
     
%% 需要重新排序一下成员职位
do_reset_family_member_office(FamilyId) ->
    catch do_reset_family_member_office2(FamilyId).
do_reset_family_member_office2(FamilyId) ->
    case get_family(FamilyId) of
        {ok,FamilyInfo} ->
            next;
        _ ->
            FamilyInfo = undefind,
            erlang:throw({error,not_family_info})
    end,
    #r_family{owner_role_id=OwnerRoleId,member_list=MemberList} = FamilyInfo,
    FamilyMemberList = 
        lists:foldl(
          fun(RoleId,AccFamilyMemberList) ->
                  case RoleId =/= OwnerRoleId andalso get_family_member(RoleId) of
                      {ok,FamilyMember} ->
                          [FamilyMember|AccFamilyMemberList];
                      _ ->
                          AccFamilyMemberList
                  end
          end, [], MemberList),
    case lists:keyfind(?FAMILY_MEMBER_OFFICE_DU_JUN, #r_family_member.office_code, FamilyMemberList) of
        false ->
            OldDuJunRoleId = 0;
        #r_family_member{role_id = OldDuJunRoleId} ->
            next
    end,
    SortFamilyMemberList = 
        lists:sort(
          fun(#r_family_member{total_contribute=A},#r_family_member{total_contribute=B}) -> 
                  A > B
          end, FamilyMemberList),
    _LogTime = common_tool:now(),
    {AttrList,_} = 
        lists:foldl(
          fun(FamilyMember,{AccAttrList,AccIndex}) -> 
                  case FamilyMember#r_family_member.total_contribute of
                      0 ->
                          OfficeCode = ?FAMILY_MEMBER_OFFICE_TUAN_YUAN;
                      _ ->
                          OfficeCode = cfg_family:get_office_code(AccIndex)
                  end,
                  case OfficeCode of
                      ?FAMILY_MEMBER_OFFICE_DU_JUN ->
                          case FamilyMember#r_family_member.role_id =:= OldDuJunRoleId of
                              true ->
                                  next;
                              _ -> %% 产生新督军
								  ok
                          end;
                      _ ->
                          next
                  end,
                  #r_family_member{role_id=RoleId} = FamilyMember,
                  set_family_member(RoleId, FamilyMember#r_family_member{office_code=OfficeCode}),
                  NewAttrList = [#p_attr{uid = RoleId,attr_code=?FAMILY_ROLE_OFFICE_CODE,int_value=OfficeCode}|AccAttrList],
                  {NewAttrList,AccIndex + 1}
          end, {[],1}, SortFamilyMemberList),
    %% 广播
	OwnerAttr = #p_attr{uid = OwnerRoleId,attr_code=?FAMILY_ROLE_OFFICE_CODE,int_value=?FAMILY_MEMBER_OFFICE_TUAN_ZHANG},
    SendSelf = #m_family_attr_change_toc{op_type=0,family_id=FamilyId,role_id=0,attr_list=[OwnerAttr|AttrList]},
    broadcast(MemberList,?FAMILY,?FAMILY_ATTR_CHANGE,SendSelf),
    ok.

%% 帮派弹劾功能
do_family_impeach() ->
    #r_family_state{family_id=FamilyId} = family_server:get_family_state(),
    case catch do_family_impeach2(FamilyId) of
        {ok,FamilyInfo,FamilyMember,NowDays} ->
            do_family_impeach3(FamilyInfo,FamilyMember,NowDays);
        _ ->
            ignore
    end.
do_family_impeach2(FamilyId) ->
    case get_family(FamilyId) of
        {ok,FamilyInfo} ->
            next;
        _ ->
            FamilyInfo = undefind,
            erlang:throw({error,not_family_info})
    end,
    #r_family{owner_role_id=OwnerRoleId} = FamilyInfo,
    case get_family_member(OwnerRoleId) of
        {ok,FamilyMember} ->
            next;
        _ ->
            FamilyMember = undefined,
            erlang:throw({error,not_family_member_info})
    end,
    #r_family_member{last_login_time = LastLoginTime} = FamilyMember,
    
    NowSeconds = family_server:get_now(),
    {NowDate,_} = common_tool:seconds_to_datetime(NowSeconds),
    NowDays = calendar:date_to_gregorian_days(NowDate),
    {LastLoginDate,_} = common_tool:seconds_to_datetime(LastLoginTime),
    LastLoginDays = calendar:date_to_gregorian_days(LastLoginDate),
    case NowDays -  LastLoginDays > cfg_family:get_family_impeach_days() of
        true -> %% 需要弹劾
            erlang:throw({ok,FamilyInfo,FamilyMember,NowDays});
        _ ->
            next
    end,
    {ok}.
do_family_impeach3(FamilyInfo,OwnerFamilyMember,NowDays) ->
    #r_family{family_id=FamilyId,owner_role_id=OwnerRoleId,member_list=MemberList} = FamilyInfo,
    MinContribute = cfg_family:get_min_inherit_contribute(),
    MinLevel = cfg_family:get_min_inherit_level(),
    %% 帮派活跃玩家列表
    FamilyMemberList = 
        lists:foldl(
          fun(RoleId,AccFamilyMemberList) ->
                  case RoleId =/= OwnerRoleId andalso get_family_member(RoleId) of
                      {ok,#r_family_member{level=RoleLevel,
                                           last_login_time = LastLoginTime,
                                           total_contribute = TotalContribute}=FamilyMember} ->
                          {LastLoginDate,_} = common_tool:seconds_to_datetime(LastLoginTime),
                          LastLoginDays = calendar:date_to_gregorian_days(LastLoginDate),
                          case RoleLevel >= MinLevel 
                              andalso TotalContribute >= MinContribute
                              andalso (NowDays -  LastLoginDays =< cfg_family:get_family_impeach_days()) of 
                              true ->
                                  [FamilyMember|AccFamilyMemberList];
                              _ ->
                                  AccFamilyMemberList
                          end;
                      _ ->
                          AccFamilyMemberList
                  end
          end, [], MemberList),
    case FamilyMemberList of
        [] ->
            ok;
        _ ->
            SortFamilyMemberList = 
                lists:sort(
                  fun(#r_family_member{total_contribute=A},#r_family_member{total_contribute=B}) -> 
                          A > B
                  end, FamilyMemberList),
            [NewLeaderFamilyMember|_] = SortFamilyMemberList,
            OwnerFamilyMember2=OwnerFamilyMember#r_family_member{office_code=?FAMILY_MEMBER_OFFICE_TUAN_YUAN},
            set_family_member(OwnerRoleId, OwnerFamilyMember2),
            
            #r_family_member{role_id = NewLeaderRoleId,
                             role_name = NewLeaderRoleName} = NewLeaderFamilyMember,
            NewLeaderFamilyMember2=NewLeaderFamilyMember#r_family_member{office_code=?FAMILY_MEMBER_OFFICE_TUAN_ZHANG},
            set_family_member(NewLeaderRoleId, NewLeaderFamilyMember2),
            
            NewFamilyInfo = FamilyInfo#r_family{owner_role_id=NewLeaderRoleId,
                                                owner_role_name=NewLeaderRoleName},
            set_family(FamilyId, NewFamilyInfo),
            
            
            AttrList = [#p_attr{attr_code=?FAMILY_OWNER_ROLE_ID,int_value=NewLeaderRoleId},
                        #p_attr{attr_code=?FAMILY_OWNER_ROLE_NAME,string_value=NewLeaderRoleName},
                        #p_attr{attr_code=?FAMILY_ROLE_OFFICE_CODE,uid=OwnerRoleId,int_value=?FAMILY_MEMBER_OFFICE_TUAN_YUAN},
                        #p_attr{attr_code=?FAMILY_ROLE_OFFICE_CODE,uid=NewLeaderRoleId,int_value=?FAMILY_MEMBER_OFFICE_TUAN_ZHANG}],
            BCSelf = #m_family_attr_change_toc{op_type=?FAMILY_ATTR_CHANGE_OP_TYPE_IMPEACH,
                                               family_id=FamilyId,
                                               role_id=0,
                                               attr_list=AttrList},
            broadcast(NewFamilyInfo#r_family.member_list,?FAMILY,?FAMILY_ATTR_CHANGE,BCSelf),
            
            do_reset_family_member_office(FamilyId),
            ok
    end.
-define(family_get_op_type_family_info,1).   %% 查询帮派信息
%% 获取帮派信息
do_family_get(Module,Method,DataRecord,RoleId,PId) ->
	case catch do_family_get2(RoleId,DataRecord) of
		{error,OpCode} ->
			do_family_get_error(Module,Method,DataRecord,RoleId,PId,OpCode);
		{ok,FamilyPId} ->
			do_family_get3(Module,Method,DataRecord,RoleId,PId,FamilyPId)
	end.
do_family_get2(_RoleId,DataRecord) ->
	#m_family_get_tos{op_type=OpType,
					  family_id=FamilyId} = DataRecord,
	case OpType of
		?family_get_op_type_family_info ->
			next;
		_ ->
			erlang:throw({error,?_RC_FAMILY_GET_001})
	end,
	case FamilyId > 0 andalso erlang:is_integer(FamilyId) of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_GET_001})
    end,
    case common_family:get_family_pid(FamilyId) of
        undefined ->
            FamilyPId = undefined,
            erlang:throw({error,?_RC_FAMILY_GET_000});
        FamilyPId ->
            next
    end,
    {ok,FamilyPId}.
do_family_get3(Module,Method,DataRecord,RoleId,PId,FamilyPId) ->
    Param = {admin_get,{Module,Method,DataRecord,RoleId,PId}},
    common_family:send_to_family(FamilyPId, {mod,mod_family,Param}),
    ok.
do_admin_get({Module,Method,DataRecord,RoleId,PId}) ->
	case catch do_admin_get2(RoleId,DataRecord) of
		{error,OpCode} ->
			do_family_get_error(Module,Method,DataRecord,RoleId,PId,OpCode);
		{ok,Family,FamilyMemberList} ->
			do_admin_get3(Module,Method,DataRecord,RoleId,PId,
						  Family,FamilyMemberList)
	end.
do_admin_get2(RoleId,DataRecord) ->
	#m_family_get_tos{op_type=_OpType,
					  family_id=FamilyId} = DataRecord,
	case mod_family:get_family(FamilyId) of
        {ok,Family} ->
            next;
        _ ->
            Family = undefined,
            erlang:throw({error,?_RC_FAMILY_GET_000})
    end,
    case lists:member(RoleId, Family#r_family.member_list) of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_GET_002})
    end,
	FamilyMemberList = 
		lists:foldl(
		  fun(MemberRoleId,AccFamilyMemberList) -> 
				  case get_family_member(MemberRoleId) of
					  {ok,FamilyMember} ->
						  [FamilyMember|AccFamilyMemberList];
					  _ ->
						  AccFamilyMemberList
				  end
		  end,[],Family#r_family.member_list),
	{ok,Family,FamilyMemberList}.
do_admin_get3(Module,Method,DataRecord,_RoleId,PId,
			  Family,FamilyMemberList) ->
	PFamilyInfo = get_p_family(Family, FamilyMemberList),
	SendSelf = #m_family_get_toc{op_type=DataRecord#m_family_get_tos.op_type,
								 family_id=DataRecord#m_family_get_tos.family_id,
								 op_code=0,
								 family_info=PFamilyInfo},
	common_misc:unicast(PId,Module,Method,SendSelf).

do_family_get_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
	SendSelf = #m_family_get_toc{op_type=DataRecord#m_family_get_tos.op_type,
								 family_id=DataRecord#m_family_get_tos.family_id,
								 op_code=OpCode},
	common_misc:unicast(PId,Module,Method,SendSelf),
	ok.