-module(echatServer).

%%  
%% Include files  
%%  

%%  
%% Exported Functions  
%%  
-export([start/0]).

%%  
%% API Functions  
%%  
start()->
    chat_room:start_link(),
    chat_acceptor:start(3377),
    ok.  