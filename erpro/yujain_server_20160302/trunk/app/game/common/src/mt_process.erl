%%%-------------------------------------------------------------------
%%%
%%%
%%% @doc
%%%     运维瑞士军刀，for process
%%% @end
%%% Created : 2010-10-25
%%%-------------------------------------------------------------------
-module(mt_process).

%%
%% Include files
%%
-include("common.hrl").

-compile(export_all).
-define( DEBUG(F,D),io:format(F, D) ).

%%
%% Exported Functions
%%
-export([]).

%%
%% API Functions
%%
info(PID) ->
    info(PID,all).

%% @doc process_info
info(PID,Key) when erlang:is_pid(PID)->
    StrPID = pid_to_list(PID),
    case string:substr(StrPID, 1,3) of
        [60,48,46]->
            case Key of
                all->
                    erlang:process_info( PID );
                _ ->
                    erlang:process_info( PID,Key )
            end;
        _ ->
            io:format("~s is global pid",[PID])
    end;
info(RegName,Key) when is_list(RegName) andalso length(RegName)>3 ->
    case string:substr(RegName, 1,3) of
        [60,48,46]->
            info( list_to_pid(RegName),Key );
        _ ->
            info_name(RegName,Key)
    end;
info(RegName,Key) when is_list(RegName)  ->
    info_name(RegName,Key);
info(RegName,Key) when is_atom(RegName)->
    info_name(RegName,Key).

info_name(RegName,Key)->
    case pid(RegName) of
        undefined->
            undefined;
        PID ->
            info(PID,Key)
    end.

%%发送调试方法信息给进程
debug(RegName,F,A)->
    Msg = {debug,{F,A}},
    erlang:send( mt_process:pid(RegName), Msg).
   
%%杀死某进程
kill(RegName)->
    kill(RegName,kill).

%%杀死某进程
kill(RegName,Reason)->
    exit( mt_process:pid(RegName),Reason). 

%% @doc get pid
pid(RegName)->
    case global:whereis_name(RegName) of
        undefined->
            case erlang:whereis(RegName) of
                undefined->
                    undefined;
                LPID -> 
                    LPID
            end;    
        GPID->
            GPID
    end.

%% @doc messages
m(ProcessName)->
    info(ProcessName,messages).

%% @doc length of messages
mlength(ProcessName)->
    info(ProcessName,message_queue_len).


%% @doc dictionary
d(ProcessName)->
    info(ProcessName,dictionary).

%% @doc length of dictionary
dlength(ProcessName)->
    case d(ProcessName) of
        false-> 
            false;
        {_K,Val}->
            length( Val )
    end.

%% @doc key in dictionary
d(ProcessName,Key)->
    DictVal = erlang:element(2, d(ProcessName) ) ,
    case lists:keyfind(Key, 1, DictVal) of
        false->
            false;
        Val->
            Val
    end.

%% @doc length of key in dictionary
dlength(ProcessName,Key)->
    case d(ProcessName,Key) of
        false->
            false;
        {_K,Val} ->
            length(Val)
    end.
