%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 10:55
%%%-------------------------------------------------------------------
-module(lib_account).
-include("common.hrl").
-include("record.hrl").

-export([login_role/3, get_role_list/0]).

login_role(AccId, AccName, Socket) ->
  mod_login:login(start, [AccId, AccName], Socket).

get_role_list()->
  {ok, []}.
