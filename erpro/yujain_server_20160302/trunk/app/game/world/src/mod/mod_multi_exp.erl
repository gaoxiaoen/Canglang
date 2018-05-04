%% Author: caochuncheng2002@gmail.com
%% Created: 2013-9-3
%% Description: 多倍经验处理
-module(mod_multi_exp).

-include("mgeew.hrl").

-export([
         role_online/2,
         get_exp_add/1,
         handle/1
        ]).

handle(Info)->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).


%% get_multi_exp(Key) ->
%%     case erlang:get({multi_exp_dict,Key}) of
%%         undefined ->
%%             0;
%%         Value ->
%%             Value
%%     end.
%% set_multi_exp(Key,Value) ->
%%     erlang:put({multi_exp_dict,Key},Value).


%% 玩家上线
role_online(RoleId,RoleBase) ->
    catch role_online2(RoleId,RoleBase).
role_online2(_RoleId,_RoleBase) ->
    ok.

    
get_exp_add(_) ->
    0.
