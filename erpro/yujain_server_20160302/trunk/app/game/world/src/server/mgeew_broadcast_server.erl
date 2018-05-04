%%%-------------------------------------------------------------------
%%% File        :mgeew_broadcast_server.erl
%%% Author      :caochuncheng2002@gmail.com
%%% Create Date :2012-04-05
%%% @doc
%%%     广播服务
%%% @end
%%%-------------------------------------------------------------------
-module(mgeew_broadcast_server).
-behaviour(gen_server).
-record(state,{}).


-export([start/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("mgeew.hrl").
-define(LOOP_INTERVAL,1000).

%% 发送策略
%% send_strategy 发送策略 0:立即,1:特定日期时间范围, 2:星期 3:开服后,4:持续一段时间内间隔发送
-define(BC_MSG_SEND_STRATEGY_ONCE,0).
-define(BC_MSG_SEND_STRATEGY_RANGE,1).
-define(BC_MSG_SEND_STRATEGY_WEEK,2).
-define(BC_MSG_SEND_STRATEGY_OPEN_SERVICE,3).
-define(BC_MSG_SEND_STRATEGY_KEEP,4).


%% 发送消息key定义
-define(BC_MSG_KEY_ADMIN,admin). %% 后台循环消息
-define(BC_MSG_KEY_GAME,game). %% 游戏循环消息
-define(BC_MSG_KEY_CONFIG,config). %% 配置文件循环消息
-define(GEN_BC_MSG_KEY(Type,Id),{Type,Id}).

%% ====================================================================
%% External functions
%% ====================================================================
%% 消息广播进程字典记录
%% key 唯一消息记录 {admin,id},....
%% msg_record 消息记录
%% next_send_time 下次广播时间 0示初始化
%% args 其它参数
-record(r_broadcast_message_dict,{key = undefined,msg_record = undefined,next_send_time = 0,args = undefined}).
start()  ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [],[]).

init([]) ->
    init_games_open_date(),
    set_now(common_tool:now()),
    erlang:send_after(?LOOP_INTERVAL, self(), loop),
    init_broadcast_message(),
    init_admin_message(),
    init_config_message(),
    State = #state{},
    {ok, State}.
 
get_now() ->
    erlang:get(broadcast_server_now).
set_now(NowSeconds) ->
    erlang:put(broadcast_server_now, NowSeconds).
%% ====================================================================
%% Server functions
%%      gen_server callbacks
%% ====================================================================
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info,State),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
 

do_handle_info(loop)->
    erlang:send_after(?LOOP_INTERVAL, self(), loop),
    NowSeconds = common_tool:now(),
    set_now(NowSeconds),
    loop();

do_handle_info({admin_send_message,Msg})->
    do_admin_send_message(Msg);

do_handle_info({admin_del_message,Msg})->
    do_admin_del_message(Msg);

do_handle_info({admin_reset_message,Info})->
    do_admin_reset_message(Info);

do_handle_info({admin_del_all_message})->
    do_admin_del_all_message();

do_handle_info({game_send_message,Msg})->
    do_game_send_message(Msg);
do_handle_info({game_del_all_message})->
    do_game_del_all_message();

do_handle_info({config_reset_message})->
    do_config_reset_message();
do_handle_info({config_del_all_message})->
    do_config_del_all_message();

do_handle_info({init_games_open_date})->
    init_games_open_date();

do_handle_info({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("~w",[Ret]),
    ok;

do_handle_info(Info)->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]),
    ignore.

%%每秒循环执行
loop() ->
    do_loop_send_message(),
    ok.

get_broadcast_message() ->
    erlang:get(broadcast_message).
set_broadcast_message(SendMsgList) ->
    erlang:put(broadcast_message, SendMsgList).
init_broadcast_message() ->
    erlang:put(broadcast_message, []).

%% 初始化开服日期
init_games_open_date() ->
    {{Year,Month,Day}, _} = common_config:get_open_day(),
    case Month < 10 of
        true ->
            NewMonth = lists:concat(["0",erlang:integer_to_list(Month)]);
        _ ->
            NewMonth = lists:concat(["",erlang:integer_to_list(Month)])
    end,
    case  Day < 10 of
        true ->
            NewDay = lists:concat(["0",erlang:integer_to_list(Day)]);
        _ ->
            NewDay = lists:concat(["",erlang:integer_to_list(Day)])
    end,
    OpenDate = lists:concat(["" , erlang:integer_to_list(Year),"-",NewMonth,"-",NewDay]),
    %% OpenDate = "2010-11-10",
    ?ERROR_MSG("~ts,OpenDate=~w",[?_LANG_LOCAL_004,OpenDate]),
    erlang:put(games_open_date, OpenDate).
get_games_open_date() ->
    erlang:get(games_open_date).

%% 初始后台循环消息
init_admin_message() ->
    %% 从数据库表中获取消息广播记录
    MsgInfoList = db_api:dirty_select(?DB_BROADCAST_MESSAGE, [{#r_broadcast_message{_='_'}, [], ['$_']}]),
    init_admin_message(MsgInfoList).

init_admin_message(MsgInfoList) ->
    OldSendMsgList = get_broadcast_message(),
    SendMsgList = 
        lists:foldr(
          fun(MsgInfo,AccSendMsgList) ->
                  #r_broadcast_message{id = MsgId} = MsgInfo,
                  [#r_broadcast_message_dict{key = ?GEN_BC_MSG_KEY(?BC_MSG_KEY_ADMIN,MsgId),msg_record = MsgInfo}|AccSendMsgList]
          end,OldSendMsgList,MsgInfoList),
    set_broadcast_message(SendMsgList).

%% 初始化配置循环广播消失
init_config_message() ->
    OldSendMsgDictList = get_broadcast_message(),
    SendMsgDictList = 
        lists:foldl(
          fun(#r_broadcast_message_config{id = MsgId} = SendMsg,AccSendMsgDictList) -> 
                  [#r_broadcast_message_dict{key = ?GEN_BC_MSG_KEY(?BC_MSG_KEY_CONFIG,MsgId),msg_record = SendMsg}|AccSendMsgDictList]
          end, OldSendMsgDictList, cfg_broadcast_loop:list()),
    set_broadcast_message(SendMsgDictList).
    
%% 发送消息
do_loop_send_message() ->
    case get_broadcast_message() of
        [] ->
            ok;
        SendMsgDictList ->
            NowSeconds = get_now(),
            {NowDate,NowTime} = common_tool:seconds_to_datetime(NowSeconds),
            TodayDays = calendar:date_to_gregorian_days(NowDate),
            TodaySeconds = calendar:time_to_seconds(NowTime),
            OpenServiceDays = get_open_service_days(get_games_open_date()),
            NewSendMsgDictList = 
                lists:foldl(
                  fun(SendMsgDict,AccSendMsgDictList) -> 
                          case SendMsgDict#r_broadcast_message_dict.next_send_time =:= 0 
                               orelse NowSeconds >= SendMsgDict#r_broadcast_message_dict.next_send_time of
                              true ->
                                  case SendMsgDict#r_broadcast_message_dict.key of
                                      {?BC_MSG_KEY_ADMIN,_MsgId} ->
                                          case catch do_loop_send_admin_msg(NowSeconds,TodayDays,TodaySeconds,OpenServiceDays,SendMsgDict) of
                                              {ok,NewSendMsgDict} ->
                                                  [NewSendMsgDict|AccSendMsgDictList];
                                              {error,_} ->
                                                  AccSendMsgDictList
                                          end;
                                      {?BC_MSG_KEY_GAME,_MsgId} ->
                                          case catch do_loop_send_game_msg(NowSeconds,SendMsgDict) of
                                              {ok,NewSendMsgDict} ->
                                                  [NewSendMsgDict|AccSendMsgDictList];
                                              {error,_} ->
                                                  AccSendMsgDictList
                                          end;
                                      {?BC_MSG_KEY_CONFIG,_MsgId} ->
                                          case catch do_loop_send_config_msg(NowSeconds,TodayDays,SendMsgDict) of
                                              {ok,NewSendMsgDict} ->
                                                   [NewSendMsgDict|AccSendMsgDictList];
                                              {error,_} ->
                                                  AccSendMsgDictList
                                          end
                                  end;
                              _ ->
                                  [SendMsgDict|AccSendMsgDictList]
                          end
                  end, [], SendMsgDictList),
            set_broadcast_message(NewSendMsgDictList)
    end.
do_loop_send_config_msg(NowSeconds,TodayDays,SendMsgDict) ->
    #r_broadcast_message_dict{msg_record = SendMsg,next_send_time = OldNextSendTime, args = Args} = SendMsgDict,
    case OldNextSendTime =:= 0 of
        true ->
            BcTodaySeconds = calendar:time_to_seconds(SendMsg#r_broadcast_message_config.bc_time),
            BcSeconds = gen_seconds(TodayDays, BcTodaySeconds),
            case NowSeconds >= BcSeconds  andalso NowSeconds - BcSeconds > 3 of
                true -> %% 发送
                    do_send_message(SendMsgDict),
                    NextSendTime = gen_seconds(TodayDays + 1,BcTodaySeconds);
                _ ->
                    NextSendTime = BcSeconds
            end,
            erlang:throw({ok,SendMsgDict#r_broadcast_message_dict{next_send_time = NextSendTime, args = {BcSeconds,BcTodaySeconds}}});
        _ ->
            {BcSeconds,BcTodaySeconds} = Args,
            case NowSeconds >= BcSeconds of
                true ->
                    do_send_message(SendMsgDict),
                    NextSendTime = gen_seconds(TodayDays + 1,BcTodaySeconds),
                    erlang:throw({ok,SendMsgDict#r_broadcast_message_dict{next_send_time = NextSendTime}});
                _ ->
                    erlang:throw({ok,SendMsgDict})
            end
    end.
            
do_loop_send_game_msg(NowSeconds,SendMsgDict) ->
    #r_broadcast_message_dict{msg_record = SendMsg,next_send_time = OldNextSendTime} = SendMsgDict,
    #r_broadcast_message_param{start_time = StartSeconds,end_time = EndSeconds, interval = Interval} = SendMsg,
    case OldNextSendTime =:= 0 of
        true ->
            case NowSeconds >= StartSeconds andalso EndSeconds >= NowSeconds of
                true ->
                    do_send_message(SendMsgDict),
                    case EndSeconds >= NowSeconds + Interval of
                        true ->
                            NextSendTime = NowSeconds + Interval;
                        _ ->
                            NextSendTime = 0,
                            erlang:throw({error,not_need_send})
                    end;
                _ ->
                    NextSendTime = StartSeconds
            end,
            erlang:throw({ok,SendMsgDict#r_broadcast_message_dict{next_send_time = NextSendTime}});
        _ ->
            case NowSeconds >= OldNextSendTime of
                true -> %% 发送消息
                    do_send_message(SendMsgDict),
                    case EndSeconds >= OldNextSendTime + Interval of
                        true ->
                            NextSendTime = OldNextSendTime + Interval;
                        _ ->
                            NextSendTime = 0,
                            erlang:throw({error,not_need_send})
                    end,
                    erlang:throw({ok,SendMsgDict#r_broadcast_message_dict{next_send_time = NextSendTime}});
                _ ->
                    erlang:throw({ok,SendMsgDict})
            end
    end.
do_loop_send_admin_msg(NowSeconds,TodayDays,TodaySeconds,OpenServiceDays,SendMsgDict) ->
    #r_broadcast_message_dict{msg_record = SendMsg,next_send_time = NextSendTime,args = Args} = SendMsgDict,
    case SendMsg#r_broadcast_message.send_strategy of
        ?BC_MSG_SEND_STRATEGY_ONCE ->
            do_send_message(SendMsgDict),
            erlang:throw({error,send_strategy_once});
        _ ->
            next
    end,
    case NextSendTime =:= 0 orelse Args =:= undefined of
        true ->
            case SendMsg#r_broadcast_message.send_strategy of
                ?BC_MSG_SEND_STRATEGY_RANGE ->
                    StartDays = get_date_for_string(SendMsg#r_broadcast_message.start_date),
                    EndDays = get_date_for_string(SendMsg#r_broadcast_message.end_date),
                    StartSeconds = get_time_for_string(SendMsg#r_broadcast_message.start_time),
                    EndSeconds = get_time_for_string(SendMsg#r_broadcast_message.end_time),
                    next;
                ?BC_MSG_SEND_STRATEGY_WEEK ->
                    StartDays = erlang:list_to_integer(SendMsg#r_broadcast_message.start_date,10),
                    EndDays = erlang:list_to_integer(SendMsg#r_broadcast_message.end_date,10),
                    StartSeconds = get_time_for_string(SendMsg#r_broadcast_message.start_time),
                    EndSeconds = get_time_for_string(SendMsg#r_broadcast_message.end_time),
                    next;
                ?BC_MSG_SEND_STRATEGY_OPEN_SERVICE ->
                    StartDays = OpenServiceDays +  erlang:list_to_integer(SendMsg#r_broadcast_message.start_date,10),
                    EndDays = OpenServiceDays + erlang:list_to_integer(SendMsg#r_broadcast_message.end_date,10),
                    StartSeconds = get_time_for_string(SendMsg#r_broadcast_message.start_time),
                    EndSeconds = get_time_for_string(SendMsg#r_broadcast_message.end_time),
                    next;
                ?BC_MSG_SEND_STRATEGY_KEEP ->
                    StartDays = get_date_for_string(SendMsg#r_broadcast_message.start_date),
                    EndDays = get_date_for_string(SendMsg#r_broadcast_message.end_date),
                    StartSeconds = get_time_for_string(SendMsg#r_broadcast_message.start_time),
                    EndSeconds = get_time_for_string(SendMsg#r_broadcast_message.end_time),
                    next
            end,
            NewSendMsgDict = calc_admin_msg_next_send_time(NowSeconds,TodayDays,TodaySeconds,StartDays,EndDays,
                                                       StartSeconds,EndSeconds,SendMsgDict),
            {ok,NewSendMsgDict};
        _ ->
            case NowSeconds >= NextSendTime of
                true ->
                    do_send_message(SendMsgDict),
                    {StartDays,EndDays,StartSeconds,EndSeconds} = Args,
                    NewSendMsgDict = calc_admin_msg_next_send_time(NowSeconds,TodayDays,TodaySeconds,StartDays,EndDays,
                                                               StartSeconds,EndSeconds,SendMsgDict),
                    {ok,NewSendMsgDict};
                _ ->%% 时间未到，不需要发送消失
                    erlang:throw({ok,SendMsgDict})
            end
    end.
%% 计算下一次消息广播时间
calc_admin_msg_next_send_time(NowSeconds,TodayDays,TodaySeconds,StartDays,EndDays,
                              StartSeconds,EndSeconds,SendMsgDict) ->
    #r_broadcast_message_dict{msg_record = SendMsg,next_send_time = OldNextSendTime} = SendMsgDict,
    case SendMsg#r_broadcast_message.send_strategy of
        ?BC_MSG_SEND_STRATEGY_RANGE ->
            case TodayDays >= StartDays andalso EndDays >= TodayDays of
                true ->
                    case TodaySeconds >= StartSeconds andalso EndSeconds >= TodaySeconds of
                        true ->
                            case OldNextSendTime =:= 0 of
                                true ->
                                    NextSendTime = NowSeconds + SendMsg#r_broadcast_message.interval;
                                _ ->
                                    NextSendTime = OldNextSendTime + SendMsg#r_broadcast_message.interval
                            end;
                        _ -> %% 下一次的广播时间
                            NextSendTime = gen_seconds(TodayDays + 1,StartSeconds + SendMsg#r_broadcast_message.interval)
                    end;
                _ ->
                    case TodayDays > EndDays of
                        true ->
                            NextSendTime = 0,
                            erlang:throw({error,not_need_send});
                       _ ->
                           NextSendTime = gen_seconds(StartDays,StartSeconds + SendMsg#r_broadcast_message.interval)
                    end
            end;
        ?BC_MSG_SEND_STRATEGY_WEEK ->
            NowWeek = calendar:day_of_the_week(calendar:gregorian_days_to_date(TodayDays)),
            case NowWeek >= StartDays andalso EndDays >= NowWeek of
                true ->
                    case TodaySeconds >= StartSeconds andalso EndSeconds >= TodaySeconds of
                        true ->
                            case OldNextSendTime =:= 0 of
                                true ->
                                    NextSendTime = NowSeconds + SendMsg#r_broadcast_message.interval;
                                _ ->
                                    NextSendTime = OldNextSendTime + SendMsg#r_broadcast_message.interval
                            end;
                        _ ->
                            NextSendTime = gen_seconds(TodayDays + 1,StartSeconds + SendMsg#r_broadcast_message.interval)
                    end;
                _ ->
                    case NowWeek > EndDays of
                        true ->
                            NextSendTime = gen_seconds(TodayDays + (7 - NowWeek + StartDays),StartSeconds + SendMsg#r_broadcast_message.interval);
                        _ ->
                            NextSendTime = gen_seconds(TodayDays + (StartDays - NowWeek),StartSeconds + SendMsg#r_broadcast_message.interval)
                    end
            end;
        ?BC_MSG_SEND_STRATEGY_OPEN_SERVICE ->
            case TodayDays >= StartDays andalso EndDays >= TodayDays of
                true ->
                    case TodaySeconds >= StartSeconds andalso EndSeconds >= TodaySeconds of
                        true ->
                            case OldNextSendTime =:= 0 of
                                true ->
                                    NextSendTime = NowSeconds + SendMsg#r_broadcast_message.interval;
                                _ ->
                                    NextSendTime = OldNextSendTime + SendMsg#r_broadcast_message.interval
                            end;
                        _ -> 
                            NextSendTime = gen_seconds(TodayDays + 1,StartSeconds + SendMsg#r_broadcast_message.interval)
                    end;
                _ ->
                    case TodayDays > EndDays of
                        true ->
                            NextSendTime = 0,
                            erlang:throw({error,not_need_send});
                       _ ->
                           NextSendTime = gen_seconds(StartDays,StartSeconds + SendMsg#r_broadcast_message.interval)
                    end
            end;
        ?BC_MSG_SEND_STRATEGY_KEEP ->
            KeepStartSeconds = gen_seconds(StartDays,StartSeconds),
            KeepEndSeconds = gen_seconds(EndDays,EndSeconds),
            case NowSeconds >= KeepStartSeconds andalso KeepEndSeconds >= NowSeconds of
                true ->
                    case OldNextSendTime =:= 0 of
                        true ->
                            NextSendTime = NowSeconds + SendMsg#r_broadcast_message.interval;
                        _ ->
                            NextSendTime = OldNextSendTime + SendMsg#r_broadcast_message.interval
                    end;
                _ ->
                    case NowSeconds > KeepEndSeconds of
                        true ->
                            NextSendTime = 0,
                            erlang:throw({error,not_need_send});
                        _ ->
                            NextSendTime = KeepStartSeconds + SendMsg#r_broadcast_message.interval
                    end
            end
    end,
    SendMsgDict#r_broadcast_message_dict{next_send_time = NextSendTime,
                                         args = {StartDays,EndDays,StartSeconds,EndSeconds}}.
        
                                       
%% 发送消息处理
do_send_message(SendMsgDict) ->
    #r_broadcast_message_dict{key = Key,msg_record = SendMsg} = SendMsgDict,
    case Key of
        {?BC_MSG_KEY_ADMIN,_MsgId} ->
            do_send_message_admin(SendMsg);
        {?BC_MSG_KEY_GAME,_MsgId} ->
            do_send_message_game(SendMsg);
        {?BC_MSG_KEY_CONFIG,_MsgId} ->
            do_send_message_config(SendMsg)
    end.
do_send_message_admin(SendMsg) ->
    #r_broadcast_message{msg_type = MsgType,msg_sub_type=MsgSubType,msg = Msg} = SendMsg,
    Message = #m_broadcast_general_toc{type = MsgType,sub_type = MsgSubType,msg = Msg},
    ?DEBUG("send message,Message=~w",[Message]),
    chat_misc:broadcast_to_world(?BROADCAST, ?BROADCAST_GENERAL, Message).
do_send_message_game(SendMsg) ->
    #r_broadcast_message_param{msg_type = MsgType,msg_sub_type = MsgSubType,msg = Msg,
                               is_world = IsWorld, category = Category,famliy_id = FamliyId, 
                               team_id = TeamId,role_id_list = RoleIdList} = SendMsg,
    Message = #m_broadcast_general_toc{type = MsgType,sub_type = MsgSubType,msg = Msg},
    if IsWorld =:= true ->
           chat_misc:broadcast_to_world(?BROADCAST, ?BROADCAST_GENERAL, Message);
       Category =/= 0 ->
           chat_misc:broadcast_to_category(Category, ?BROADCAST, ?BROADCAST_GENERAL, Message);
       FamliyId =/= 0 ->
           chat_misc:broadcast_to_family(FamliyId,?BROADCAST, ?BROADCAST_GENERAL, Message);
       TeamId =/= 0 ->
           chat_misc:broadcast_to_team(TeamId, ?BROADCAST, ?BROADCAST_GENERAL, Message);
       RoleIdList =/= [] ->
           lists:foreach(
             fun(RoleId) -> 
                     common_misc:unicast({role, RoleId}, ?BROADCAST, ?BROADCAST_GENERAL, Message)
             end, RoleIdList);
       true ->
           ignore
    end.
do_send_message_config(SendMsg) ->
    #r_broadcast_message_config{msg_type = MsgType, msg_sub_type=MsgSubType,msg = Msg} = SendMsg,
    Message = #m_broadcast_general_toc{type = MsgType,sub_type = MsgSubType,msg = Msg},
    ?DEBUG("send message,Message=~w",[Message]),
    chat_misc:broadcast_to_world(?BROADCAST, ?BROADCAST_GENERAL, Message).

%% 后台发送消息处理
do_admin_send_message(SendMsg) ->
    case erlang:is_record(SendMsg, r_broadcast_message) of
        true ->
            SendMsgDict = #r_broadcast_message_dict{key = ?GEN_BC_MSG_KEY(?BC_MSG_KEY_ADMIN,SendMsg#r_broadcast_message.id),
                                                    msg_record = SendMsg}, 
            case catch check_admin_message(SendMsg) of
                {error,Reason} -> 
                    ?ERROR_MSG("~ts,Reason=~w",[?_LANG_LOCAL_005,Reason]);
                _ ->
                    case SendMsg#r_broadcast_message.send_strategy  of
                        ?BC_MSG_SEND_STRATEGY_ONCE -> %% 立即发送处理
                            do_send_message(SendMsgDict);
                        _ ->
                            SendMsgDictList = lists:keydelete(SendMsgDict#r_broadcast_message_dict.key, #r_broadcast_message_dict.key, get_broadcast_message()),
                            NewSendMsgDictList = [SendMsgDict|SendMsgDictList],
                            set_broadcast_message(NewSendMsgDictList),
                            db_api:dirty_write(?DB_BROADCAST_MESSAGE,SendMsg)
                    end
            end;
        _ ->
            ?ERROR_MSG("~ts,SendMsg=~w",[?_LANG_LOCAL_005,SendMsg])
    end.

%% 后台删除消息处理
do_admin_del_message(DelMsgIdList) ->
    case DelMsgIdList of
        [] ->
            ignore;
        _ ->
            SendMsgDictList = 
                lists:foldl(
                  fun(DelMsgId,AccSendMsgDictList) -> 
                          Key = ?GEN_BC_MSG_KEY(?BC_MSG_KEY_ADMIN,DelMsgId),
                          lists:keydelete(Key,#r_broadcast_message_dict.key, AccSendMsgDictList)
                  end, get_broadcast_message(), DelMsgIdList),
            set_broadcast_message(SendMsgDictList)
    end.

%% 重置消息
do_admin_reset_message({MsgInfoList}) ->
    do_admin_del_all_message(),
    
    lists:foreach(
      fun(MsgInfo) -> 
              db_api:dirty_write(?DB_BROADCAST_MESSAGE,MsgInfo)
      end, MsgInfoList),
    
    init_admin_message(MsgInfoList).
%% 删除所有后台广播消息 
do_admin_del_all_message() ->
    MsgInfoList = db_api:dirty_select(?DB_BROADCAST_MESSAGE, [{#r_broadcast_message{_='_'}, [], ['$_']}]),
    lists:foreach(
      fun(#r_broadcast_message{id = DelId}) -> 
              db_api:dirty_delete(?DB_BROADCAST_MESSAGE,DelId)
      end, MsgInfoList),
    
    SendMsgDictList = get_broadcast_message(),
    NewSendMsgDictList = 
        lists:foldl(
          fun(SendMsgDict,AccSendMsgDictList) -> 
                  case SendMsgDict#r_broadcast_message_dict.key of
                      {?BC_MSG_KEY_ADMIN,_MsgId} ->
                          AccSendMsgDictList;
                      _ ->
                          [SendMsgDict|AccSendMsgDictList]
                  end
          end, [], SendMsgDictList),
    set_broadcast_message(NewSendMsgDictList).
%% 检查后台消息是否合法              
check_admin_message(SendMsg) ->
    #r_broadcast_message{msg_type = MsgType,
                         msg_sub_type = MsgSubType,
                         send_strategy = SendStrategy,
                         start_date = StartDate,
                         end_date = EndDate,
                         start_time = StartTime,
                         end_time = EndTime,
                         msg = Msg} = SendMsg,
    %% 检查消息类型
    case MsgType =:= ?BC_MSG_TYPE_WORLD
         orelse MsgType =:= ?BC_MSG_TYPE_CHAT of
        true ->
            next;
        _ ->
            erlang:throw({error,msg_type_error})
    end,
    case MsgType =:= ?BC_MSG_TYPE_CHAT of
        true ->
            case MsgSubType of
                ?CHANNEL_TYPE_SYSTEM -> next;
                ?CHANNEL_TYPE_WORLD -> next;
                ?CHANNEL_TYPE_CATEGORY -> next;
                ?CHANNEL_TYPE_FAMILY -> next;
                ?CHANNEL_TYPE_TEAM -> next;
                _ -> erlang:throw({error,msg_sub_type_error})
            end;
        _ ->
            next
    end,
    
    case SendStrategy  =:= ?BC_MSG_SEND_STRATEGY_ONCE
         orelse SendStrategy  =:= ?BC_MSG_SEND_STRATEGY_RANGE
         orelse SendStrategy  =:= ?BC_MSG_SEND_STRATEGY_WEEK
         orelse SendStrategy  =:= ?BC_MSG_SEND_STRATEGY_OPEN_SERVICE
         orelse SendStrategy  =:= ?BC_MSG_SEND_STRATEGY_KEEP of
        true ->
            next;
        _ ->
            erlang:throw({error,send_strategy_error})
    end,
    case Msg =:= "" of
        true ->
            erlang:throw({error,msg_content_null});
        _ ->
            next
    end,
    case SendStrategy =:= ?BC_MSG_SEND_STRATEGY_ONCE of
        true ->
            erlang:throw({ok});
        _ ->
            next
    end,
    case SendStrategy =:= ?BC_MSG_SEND_STRATEGY_RANGE orelse SendStrategy =:= ?BC_MSG_SEND_STRATEGY_KEEP of
        true ->
            case check_date_string(StartDate) of 
                true ->
                    next;
                false ->
                    erlang:throw({error,common_lang:get_lang(100301)})
            end,
            case check_date_string(EndDate) of
                true ->
                    next;
                false ->
                     erlang:throw({error,common_lang:get_lang(100302)})
            end,
            case get_date_for_string(StartDate) =< get_date_for_string(EndDate) of
                true ->
                    next;
                _ ->
                    erlang:throw({error,common_lang:get_lang(100303)})
            end;
       _ ->
            next
    end,
    case SendStrategy =:= ?BC_MSG_SEND_STRATEGY_WEEK of
        true ->
            TStartDate = erlang:list_to_integer(StartDate),
            TEndDate = erlang:list_to_integer(EndDate),
            if TStartDate =< TEndDate andalso TEndDate >= 1 andalso TEndDate =< 7
                   andalso TStartDate >= 1 andalso TStartDate =< 7 ->
                   next;
               true ->
                   erlang:throw({error,common_lang:get_lang(100304)})
            end;
        _ ->
            next
    end,
    case SendStrategy =:= ?BC_MSG_SEND_STRATEGY_OPEN_SERVICE of
        true ->
            PStartDate = erlang:list_to_integer(StartDate),
            PEndDate = erlang:list_to_integer(EndDate),
            if PStartDate =< PEndDate ->
                   next;
               true ->
                   erlang:throw({error,common_lang:get_lang(100305)})
            end;
        _ ->
            next
    end,
    case SendStrategy =/= ?BC_MSG_SEND_STRATEGY_ONCE of
        true ->
            case check_time_string(StartTime) of
                false ->
                    erlang:throw({error,common_lang:get_lang(100306)});
                true ->
                    next
            end,
            case check_time_string(EndTime) of
                false ->
                    erlang:throw({error,common_lang:get_lang(100307)});
                true ->
                    next
            end;
        _ ->
            next
    end,
    if SendStrategy =:= ?BC_MSG_SEND_STRATEGY_RANGE 
         orelse SendStrategy =:= ?BC_MSG_SEND_STRATEGY_WEEK 
         orelse SendStrategy =:= ?BC_MSG_SEND_STRATEGY_OPEN_SERVICE  ->
           case get_time_for_string(StartTime) =< get_time_for_string(EndTime) of
               true ->
                   next;
               _ ->
                   erlang:throw({error,common_lang:get_lang(100308)})
           end;
       SendStrategy =:= ?BC_MSG_SEND_STRATEGY_KEEP ->
            StartDays4 = get_date_for_string(StartDate),
            EndDays4 = get_date_for_string(EndDate),
            StartSeconds4 = get_time_for_string(StartTime),
            EndSeconds4 = get_time_for_string(EndTime),
            case calc_diff_seconds(StartDays4,StartSeconds4,EndDays4,EndSeconds4) < 0 of
                true ->
                    erlang:throw({error,common_lang:get_lang(100309)});
                _ ->
                    next
            end;
       true ->
            next
    end,
    NowDays = calendar:date_to_gregorian_days(date()),
    NowSeconds = get_now(),
    if SendStrategy =:= ?BC_MSG_SEND_STRATEGY_RANGE 
       orelse SendStrategy =:= ?BC_MSG_SEND_STRATEGY_KEEP ->
            EndDays = get_date_for_string(EndDate),
            EndSeconds2 = get_time_for_string(EndTime),
            case calc_diff_seconds(NowDays,NowSeconds,EndDays,EndSeconds2) < 0 of
                true ->
                    erlang:throw({error,common_lang:get_lang(100310)});
                _ ->
                    next
            end;
       SendStrategy =:= 3 ->
            EndDateNumber = erlang:list_to_integer(EndDate,10),
            OpenServiceDays = get_open_service_days(get_games_open_date()),
            EndSeconds3 = get_time_for_string(EndTime),
            CheckInterval = calc_diff_seconds(NowDays,NowSeconds,OpenServiceDays + EndDateNumber,EndSeconds3),
            if CheckInterval < 0 ->
                    ?DEBUG("~ts,CheckInterval=~w,OpenServiceDays=~w",["open game server and check message time invalid",CheckInterval,OpenServiceDays]);
               true ->
                    next
            end;
       true ->
            next
    end,
    {ok}.


%% 游戏循环消息发送处理
do_game_send_message(SendMsg) ->
    case erlang:is_record(SendMsg, r_broadcast_message_param) =:= true of
        true ->
            {MegaSecs, Secs, MicroSecs} = erlang:now(),
            MsgId = (MegaSecs * 1000000 + Secs) * 1000000 + MicroSecs,
            SendMsgDict = #r_broadcast_message_dict{key = ?GEN_BC_MSG_KEY(?BC_MSG_KEY_GAME,MsgId),
                                                    msg_record = SendMsg}, 
            case catch check_game_message(SendMsg) of
                {error,Reason} -> 
                    ?ERROR_MSG("~ts,Reason=~w",[?_LANG_LOCAL_032,Reason]);
                _ ->
                    SendMsgDictList = lists:keydelete(SendMsgDict#r_broadcast_message_dict.key, #r_broadcast_message_dict.key, get_broadcast_message()),
                    NewSendMsgDictList = [SendMsgDict|SendMsgDictList],
                    set_broadcast_message(NewSendMsgDictList)
            end;
        _ ->
            ?ERROR_MSG("~ts,Info=~w",[?_LANG_LOCAL_031,SendMsg])
    end.
%% 删除所有游戏循环消息
do_game_del_all_message() ->
    SendMsgDictList = get_broadcast_message(),
    NewSendMsgDictList = 
        lists:foldl(
          fun(SendMsgDict,AccSendMsgDictList) -> 
                  case SendMsgDict#r_broadcast_message_dict.key of
                      {?BC_MSG_KEY_GAME,_MsgId} ->
                          AccSendMsgDictList;
                      _ ->
                          [SendMsgDict|AccSendMsgDictList]
                  end
          end, [], SendMsgDictList),
    set_broadcast_message(NewSendMsgDictList).

%% 检查游戏消息是否合法
check_game_message(SendMsg) ->
    #r_broadcast_message_param{msg_type = MsgType,
                               msg_sub_type  = MsgSubType,
                               start_time = StartTime,
                               end_time = EndTime,
                               interval  = Interval,
                               msg = Msg} = SendMsg,
    %% 检查消息类型
    case MsgType =:= ?BC_MSG_TYPE_WORLD
         orelse MsgType =:= ?BC_MSG_TYPE_CHAT of
        true ->
            next;
        _ ->
            erlang:throw({error,msg_type_error})
    end,
    case MsgType =:= ?BC_MSG_TYPE_CHAT of
        true ->
            case MsgSubType =:= ?CHANNEL_TYPE_SYSTEM 
                 orelse MsgSubType =:= ?CHANNEL_TYPE_WORLD
                 orelse MsgSubType =:= ?CHANNEL_TYPE_CATEGORY
                 orelse MsgSubType =:= ?CHANNEL_TYPE_FAMILY
                 orelse MsgSubType =:= ?CHANNEL_TYPE_TEAM of
                true ->
                    next;
                _ ->
                    erlang:throw({error,msg_sub_type_error})
            end;
        _ ->
            case MsgSubType =/= ?BC_MSG_SUB_TYPE_NONE of
                true ->
                    erlang:throw({error,msg_sub_type_error});
                _ ->
                    next
            end
    end,
    case Msg =:= "" of
        true ->
            erlang:throw({error,msg_content_null});
        _ ->
            next
    end,
    case Interval > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,interval_error})
    end,
    NowSeconds = get_now(),
    case EndTime >= StartTime andalso EndTime >= NowSeconds of
        true ->
            next;
        _ ->
            erlang:throw({error,common_lang:get_lang(100311)})
    end,
    {ok}.
%% 重置配置消息广播
do_config_reset_message() ->
    do_config_del_all_message(),
    init_config_message(),
    ok.
%% 删除配置消息广播
do_config_del_all_message() ->
    SendMsgDictList = get_broadcast_message(),
    NewSendMsgDictList = 
        lists:foldl(
          fun(SendMsgDict,AccSendMsgDictList) -> 
                  case SendMsgDict#r_broadcast_message_dict.key of
                      {?BC_MSG_KEY_CONFIG,_MsgId} ->
                          AccSendMsgDictList;
                      _ ->
                          [SendMsgDict|AccSendMsgDictList]
                  end
          end, [], SendMsgDictList),
    set_broadcast_message(NewSendMsgDictList).

%% 获取游戏开服日期
get_open_service_days(GamesOpenDate) ->
%%     ?DEBUG("~ts,GamesOpenDate=~w",["game server open date",GamesOpenDate]),
    case GamesOpenDate of
        error ->
            calendar:date_to_gregorian_days(date());
        _ ->
            case check_date_string(GamesOpenDate) of
                false ->
                    calendar:date_to_gregorian_days(date());
                true ->
                    get_date_for_string(GamesOpenDate)
            end
    end.

gen_seconds(DateDays,DaySeconds) ->
    Date = calendar:gregorian_days_to_date(DateDays),
    Time = calendar:seconds_to_time(DaySeconds),
    common_tool:datetime_to_seconds({Date,Time}).

%% 计算两个时间相差多少秒
calc_diff_seconds(DateDays1,TimeSeconds1,DateDays2,TimeSeconds2) ->
    Date1 = calendar:gregorian_days_to_date(DateDays1),
    Time1 = calendar:seconds_to_time(TimeSeconds1),
    Date2 = calendar:gregorian_days_to_date(DateDays2),
    Time2 = calendar:seconds_to_time(TimeSeconds2),
    Seconds1 = calendar:datetime_to_gregorian_seconds({Date1, Time1}),
    Seconds2 = calendar:datetime_to_gregorian_seconds({Date2, Time2}),
    Seconds2 - Seconds1.

%% 将 yyyy-MM-dd的日期格式转换成erlang date days类型
get_date_for_string(DateStr) ->
    DateList = string:tokens(DateStr, "-"),
%%     ?DEBUG("~ts,DataStr=~w,DateList=~w",["tokens date",DateStr,DateList]),
    NewDateList = [erlang:list_to_integer(Key,10) || Key <- DateList],
    calendar:date_to_gregorian_days(lists:nth(1,NewDateList), 
                                    lists:nth(2,NewDateList), 
                                    lists:nth(3,NewDateList)).
%% 获取时间
get_time_for_string(TimeStr) ->
    TimeList = string:tokens(TimeStr, ":"),
%%     ?DEBUG("~ts,TimeStr=~w,TimeList=~w",["tokens time",TimeStr,TimeList]),
    NewTimeList = [erlang:list_to_integer(Key,10) || Key <- TimeList],
    H = lists:nth(1,NewTimeList),
    M = lists:nth(2,NewTimeList),
    S = lists:nth(3,NewTimeList),
    calendar:time_to_seconds({H,M,S}).
%% 检查日期是否合法
check_date_string(DateStr) ->
    DateList = string:tokens(DateStr, "-"),
%%     ?DEBUG("~ts,DataStr=~w,DateList=~w",["tokens date",DateStr,DateList]),
    NewDateList = [erlang:list_to_integer(Key,10) || Key <- DateList],
    calendar:valid_date(lists:nth(1,NewDateList),
                        lists:nth(2,NewDateList), lists:nth(3,NewDateList)).
%% 检查时间是否合法
check_time_string(TimeStr) ->
    TimeList = string:tokens(TimeStr, ":"),
%%     ?DEBUG("~ts,TimeStr=~w,TimeList=~w",["tokens time",TimeStr,TimeList]),
    NewTimeList = [erlang:list_to_integer(Key,10) || Key <- TimeList],
    HH = lists:nth(1,NewTimeList),
    MM = lists:nth(2,NewTimeList),
    SS = lists:nth(3,NewTimeList),
    if HH >= 0 andalso HH < 24 
       andalso MM >= 0 andalso MM < 60
       andalso SS >= 0 andalso SS < 60 ->
            true;
       true ->
            false
    end.
    