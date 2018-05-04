%%-------------------------------------------------------------------
%% File              :mod_fb.erl
%% Author            :caochuncheng2002@gmail.com
%% Create Date       :2015-11-04
%% @doc
%%     玩家副本模块，管理管理副本数据
%% @end
%%-------------------------------------------------------------------


-module(mod_fb).

-include("mgeew.hrl").


-export([
         handle/1
        ]).

handle({Module,?FB_ENTER,DataRecord,RoleId,PId,_Line}) ->
    do_fb_enter(Module,?FB_ENTER,DataRecord,RoleId,PId);

handle({fb_enter_reply,Info}) ->
    do_fb_enter_reply(Info);

handle({fb_role_online,Info}) ->
    do_fb_role_online(Info);

handle({Module,?FB_QUIT,DataRecord,RoleId,PId,_Line}) ->
    do_fb_quit(Module,?FB_QUIT,DataRecord,RoleId,PId);

handle({Module,?FB_QUERY,DataRecord,RoleId,PId,_Line}) ->
    do_fb_query(Module,?FB_QUERY,DataRecord,RoleId,PId);

handle({unlock_enter_fb}) ->
    do_unlock_enter_fb();

handle(Info)->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).

do_unlock_enter_fb() ->
    {ok,#r_role_world_state{role_id=RoleId}} = mgeew_role:get_role_world_state(),
    erase_role_fb_lock(RoleId).

do_fb_role_online({ok,RoleId,FbId}) ->
    FbInfo = cfg_fb:find(FbId),
    #r_fb_info{times_type=TimesType} = FbInfo,
    {ok,RoleFb} = get_role_fb(RoleId),
    case lists:keyfind(FbId, #r_role_fb_item.fb_id, RoleFb#r_role_fb.fbs) of
        false ->
            FbItem = #r_role_fb_item{fb_id=FbId};
        FbItem ->
            next
    end,
     #r_role_fb_item{fb_times=FbTimes,fb_time=FbTime} = FbItem,
    NowSeconds = mgeew_role:get_now(),
    CurFbTimes = calc_fb_times(TimesType,NowSeconds,FbTime,FbTimes),
    SendSelf = #m_fb_enter_toc{op_code=0,
                               fb_id=FbId,
                               fb_times=CurFbTimes},
    ?DEBUG("do fb role online succ,SendSelf=~w",[SendSelf]),
    {ok,#r_role_world_state{gateway_pid=RoleGatewayPId}} = mgeew_role:get_role_world_state(),
    common_misc:unicast(RoleGatewayPId,?FB,?FB_ENTER,SendSelf),
    ok.

%% 进入副本
do_fb_enter(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_fb_enter2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_fb_enter_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,RoleFb,NewFbItem} ->
            do_fb_enter3(Module,Method,DataRecord,RoleId,PId,
                         RoleFb,NewFbItem)
    end.
do_fb_enter2(RoleId,DataRecord) ->
    case get_role_fb_lock(RoleId) of
        undefined ->
            next;
        _ ->
            erlang:throw({error,?_RC_FB_ENTER_004})
    end,
    #m_fb_enter_tos{fb_id=FbId} = DataRecord,
    case cfg_fb:find(FbId) of
        undefined ->
            FbInfo = undefined,
            erlang:throw({error,?_RC_FB_ENTER_002});
        FbInfo ->
            next
    end,
    #r_fb_info{times_type=TimesType,min_level=MinLevel,enter_times=EnterTimes} = FbInfo,
    case mod_role:get_role_base(RoleId) of
        {ok,#p_role_base{level=RoleLevel}} ->
            next;
        _ ->
            RoleLevel = 0,
            erlang:throw({error,?_RC_FB_000})
    end,
    case RoleLevel >= MinLevel of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FB_ENTER_005})
    end,
    {ok,RoleFb} = get_role_fb(RoleId),
    case lists:keyfind(FbId, #r_role_fb_item.fb_id, RoleFb#r_role_fb.fbs) of
        false ->
            FbItem = #r_role_fb_item{fb_id=FbId};
        FbItem ->
            next
    end,
    #r_role_fb_item{fb_times=FbTimes,fb_time=FbTime,count=FbCount} = FbItem,
    NowSeconds = mgeew_role:get_now(),
    CurFbTimes = calc_fb_times(TimesType,NowSeconds,FbTime,FbTimes),
    case EnterTimes =/= 0 andalso CurFbTimes >= EnterTimes of
        true ->
            erlang:throw({error,?_RC_FB_ENTER_003});
        _ ->
            next
    end,
    NewFbItem = FbItem#r_role_fb_item{fb_times=CurFbTimes + 1,
                                      fb_time=NowSeconds,
                                      count=FbCount + 1},
    {ok,RoleFb,NewFbItem}.

calc_fb_times(?FB_TIMES_TYPE_NONE,_NowSeconds,_FbTime,FbTimes) ->
    FbTimes;
calc_fb_times(?FB_TIMES_TYPE_WEEK,_NowSeconds,0,FbTimes) ->
    FbTimes;
calc_fb_times(?FB_TIMES_TYPE_WEEK,NowSeconds,FbTime,FbTimes) ->
    {NowDate,_} = common_tool:seconds_to_datetime_string(NowSeconds),
    {NowYear,NowWeekNum}=calendar:iso_week_number(NowDate),
    {FbDate,_} = common_tool:seconds_to_datetime_string(FbTime),
    {FbYear,FbWeekNum}=calendar:iso_week_number(FbDate),
    case FbYear == NowYear of
        true ->
            case FbWeekNum == NowWeekNum of
                true ->
                    FbTimes;
                _ ->
                    0
            end;
        _ ->
            0
    end;
calc_fb_times(?FB_TIMES_TYPE_DAY,_NowSeconds,0,FbTimes) ->
    FbTimes;
calc_fb_times(?FB_TIMES_TYPE_DAY,NowSeconds,FbTime,FbTimes) ->
    {NowDate,_} = common_tool:seconds_to_datetime(NowSeconds),
    NowToday = common_tool:datetime_to_seconds({NowDate,{0,0,0}}),
    case NowToday > FbTime of
        true ->
            0;
        _ ->
            FbTimes
    end.
do_fb_enter3(_Module,_Method,_DataRecord,RoleId,_PId,
             _RoleFb,NewFbItem) ->
    %% 设计标记，消息转到地图进程处理，再地图进程没有返回处理结果时，再次请求的进入副本消息不处理
    set_role_fb_lock(RoleId, {fb_enter,NewFbItem}),
    #r_role_fb_item{fb_id=FbId} = NewFbItem,
    Info = {mod,mod_common_fb,{role_fb_enter,{RoleId,FbId}}},
    common_misc:send_to_role_map(RoleId, Info),
    ok.

%% 地图进程消息返回处理
do_fb_enter_reply({error,RoleId,_FbId,OpCode}) ->
    erase_role_fb_lock(RoleId),
    {ok,#r_role_world_state{gateway_pid=PId}} = mgeew_role:get_role_world_state(),
    PId ! enter_fb_map_fail,
    SendSelf = #m_fb_enter_toc{op_code=OpCode},
    ?DEBUG("do fb enter info fail,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,?FB,?FB_ENTER,SendSelf);
do_fb_enter_reply({ok,RoleId,FbId}) ->
    {fb_enter,NewFbItem} = get_role_fb_lock(RoleId),
    erase_role_fb_lock(RoleId),
    {ok,RoleFb} = get_role_fb(RoleId),
    NewRoleFb = RoleFb#r_role_fb{fbs=[NewFbItem | lists:keydelete(FbId, #r_role_fb_item.fb_id, RoleFb#r_role_fb.fbs)]},
    set_role_fb(RoleId, NewRoleFb),
    SendSelf = #m_fb_enter_toc{op_code=0,
                               fb_id=FbId,
                               fb_times=NewFbItem#r_role_fb_item.fb_times},
    ?DEBUG("do fb enter info succ,SendSelf=~w",[SendSelf]),
    common_misc:unicast({role,RoleId},?FB,?FB_ENTER,SendSelf),
    mgeew_packet_logger:set_statistic_action(RoleId, dump),
    ok.


do_fb_enter_error(Module,Method,_DataRecord,_RoleId,PId,OpCode) ->
    %% 去掉网关切换地图时过滤
    PId ! enter_fb_map_fail,
    SendSelf = #m_fb_enter_toc{op_code=OpCode},
    ?DEBUG("do fb enter info fail,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).

%% 角色退出副本
do_fb_quit(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_fb_quit2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_fb_quit_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok} ->
            do_fb_quit3(Module,Method,DataRecord,RoleId,PId)
    end.
do_fb_quit2(_RoleId,DataRecord) ->
    #m_fb_quit_tos{fb_id=FbId} = DataRecord,
    case cfg_fb:find(FbId) of
        undefined ->
            erlang:throw({error,?_RC_FB_QUIT_001});
        _ ->
            next
    end,
    {ok}.
do_fb_quit3(Module,Method,DataRecord,RoleId,PId) ->
    Info = {mod,mod_common_fb,{role_fb_quit,{Module,Method,DataRecord,RoleId,PId}}},
    common_misc:send_to_role_map(RoleId, Info),
    ok.
do_fb_quit_error(Module,Method,_DataRecord,_RoleId,PId,OpCode) ->
    PId ! enter_fb_map_fail,
    SendSelf = #m_fb_quit_toc{op_code=OpCode},
    ?DEBUG("do fb quit info fail,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).

%% 查询副本信息
do_fb_query(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_fb_query2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_fb_query_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,PFbList} ->
            do_fb_query3(Module,Method,DataRecord,RoleId,PId,PFbList)
    end.
do_fb_query2(RoleId,DataRecord) ->
    #m_fb_query_tos{fb_id=FbId} = DataRecord,
    case FbId of
        0 ->
            FbIdList = cfg_fb:list();
        _ ->
            FbIdList = [FbId]
    end,
    case get_role_fb(RoleId) of
        {ok,RoleFb} ->
            next;
        _ ->
            RoleFb = undefined,
            erlang:throw({error,?_RC_FB_QUERY_000})
    end,
    #r_role_fb{fbs=FbItems} = RoleFb,
    NowSeconds = mgeew_role:get_now(),
    PFbList = 
        [begin
             #r_fb_info{times_type=TimesType} = cfg_fb:find(PFbId),
             CurFbTimes = calc_fb_times(TimesType,NowSeconds,FbTime,FbTimes),
             #p_fb{fb_id=PFbId,fb_times=CurFbTimes}
         end || #r_role_fb_item{fb_id=PFbId,fb_times=FbTimes,fb_time=FbTime} <- FbItems,
                lists:member(PFbId, FbIdList) == true],
    {ok,PFbList}.
do_fb_query3(Module,Method,_DataRecord,_RoleId,PId,PFbList) ->
    SendSelf = #m_fb_query_toc{op_code=0,fbs=PFbList},
    ?DEBUG("do fb query info succ,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf),
    ok.

do_fb_query_error(Module,Method,_DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_fb_query_toc{op_code=OpCode},
    ?DEBUG("do fb query info fail,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).


%%-------------------------------------------------------------------
%%
%% dict function
%%
%%-------------------------------------------------------------------
get_role_fb(RoleId) ->
    case mod_role:get_dict({?DB_ROLE_FB,RoleId}) of
        {ok,RoleFb} ->
            {ok,RoleFb};
        _ ->
            {ok,#r_role_fb{role_id=RoleId,fbs=[]}}
    end.
set_role_fb(RoleId,RoleFb) ->
    mod_role:set_dict({?DB_ROLE_FB,RoleId}, RoleFb).

%% 进入副本消息锁
get_role_fb_lock(RoleId) ->
    erlang:get({role_fb_lock,RoleId}).
set_role_fb_lock(RoleId,Info) ->
    erlang:put({role_fb_lock,RoleId}, Info).
erase_role_fb_lock(RoleId) ->
    erlang:erase({role_fb_lock,RoleId}).
    
