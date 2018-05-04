%%%-------------------------------------------------------------------
%%% File        :mgeeg_unicast.erl
%%%-------------------------------------------------------------------
-module(mgeeg_unicast).

-behaviour(gen_server).
-include("mgeeg.hrl").
-export([
         start/1,
         start_link/1
        ]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {}).

start(Port) ->
    {ok, _} = supervisor:start_child(mgeeg_sup, {Port, 
                                                 {?MODULE, start_link, [Port]}, 
                                                 permanent, 10000, worker, 
                                                 [?MODULE]}).

start_link(Port) ->
    ProcessName = common_misc:get_unicast_server_name(Port),
    gen_server:start_link({local, ProcessName}, ?MODULE, [], []).
%% --------------------------------------------------------------------
    

%% --------------------------------------------------------------------
init([]) ->
    erlang:process_flag(trap_exit, true),
    {ok, #state{}}.


%% --------------------------------------------------------------------

handle_call(Request, From, State) ->
    ?ERROR_MSG("unexpected call ~w from ~w", [Request, From]),
    Reply = ok,
    {reply, Reply, State}.


handle_cast(Msg, State) ->
    ?INFO_MSG("unexpected cast ~w", [Msg]),
    {noreply, State}.


handle_info({role,RoleId,PId}, State) ->
    put(RoleId, PId),
    {noreply, State};


handle_info({erase,RoleId,_PId}, State) ->
    erase(RoleId),
    {noreply, State};


%%@natsuki 
%%{admin_send_single,32323,{kick,he_is_guilty}}
handle_info({admin_send_single,RoleId,Message},State)->
    Pid = get(RoleId),
    case Message of
	{kick,Reason} ->
	    catch Pid ! {admin_message,{kick,Reason}},
	    {noreply,State};
        _->
	    {noreply,State}
    end;

handle_info({message, RoleID, Module, Method, DataRecord}, State) ->
    Pid = get(RoleID),
    catch Pid ! {message, Module, Method, DataRecord},
    {noreply, State};

handle_info({send_single, RoleID, Module, Method, DataRecord}, State) ->
    Pid = get(RoleID),
    catch Pid ! {message, Module, Method, DataRecord},
    {noreply, State};

handle_info({kick_role, RoleID, Reason}, State) ->
    case get(RoleID) of
        undefined ->
            ignore;
        Pid ->
            catch erlang:exit(Pid, Reason)
    end,
    {noreply, State};


handle_info({send_multi, UnicastList}, State) when is_list(UnicastList) ->
    lists:foreach(
        fun(Record) ->
            #r_unicast{module=Module, method=Method, role_id=RoleID, record=DataRecord} = Record,
                Pid = get(RoleID),
                catch Pid ! {message, Module, Method, DataRecord}
        end,
        UnicastList
    ),
    {noreply, State};


handle_info({inet_reply, _Sock, _Result}, State) ->
    {noreply, State};


%% -- 原broadcast的功能
handle_info({send, RoleIDList, Module, Method, DataRecord}, State) ->
    broadcast(RoleIDList, Module, Method, DataRecord),
    {noreply, State};


handle_info({send, RoleIDListPrior, RoleIDList2, Module, Method, DataRecord}, State) ->
    broadcast(RoleIDListPrior, Module, Method, DataRecord),
    broadcast(RoleIDList2, Module, Method, DataRecord),
    {noreply, State};


handle_info(Info, State) ->
    ?INFO_MSG("unexpected info ~w", [Info]),
    {noreply, State}.


terminate(Reason, State) ->
    ?INFO_MSG("~w terminate : ~w, ~w", [self(), Reason, State]),
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
broadcast(List, _Module, Method, DataRecord) 
  when is_list(List) andalso erlang:length(List) > 0 ->
    List2 = lists:foldl(
              fun(RoleID, Acc) ->
                      case erlang:get(RoleID) of
                          PID when erlang:is_pid(PID) ->
                              [PID | Acc];
                          _ ->
                              Acc
                      end
              end, [], List),
    case erlang:length(List2) > 0 of
        true ->
            case catch mgeeg_packet:packet(Method, DataRecord) of
                <<>> ->
                    ?ERROR_MSG("data packet encode error:~w", [{Method,DataRecord}]);
                Binary ->
                    lists:foreach(
                      fun(PID) ->
                              PID ! {binary, Binary}
                      end, List2)
            end;
        false ->
            ignore
    end;

broadcast(List, Module, Method, DataRecord) ->
    ?DEBUG("!!!Ignore broadcast message: ~w ~w ~w ~w ~w", [ List, Module, Method, DataRecord]),
    ignore.
