%%-------------------------------------------------------------------
%% File           :cfg_proto.erl
%% Author         :caochuncheng2002@gmail.com
%% Create Date    :2015-09-25
%% @doc
%%     配置协议是否正常开通，用于正常服出错模块功能出错，可以及时的关闭此功能服务
%% @end
%%-------------------------------------------------------------------


-module(cfg_proto).

-include("mm_define.hrl").
-include("reason_code.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([check/2]).


%% 禁止的模块返回false
check_module(_Module) -> true.


%% 禁止的协议返回false
check_method(_Method) -> true.


%% 检查系统模块功能是否正常开启
check(Module,Method)->
   case check_module(Module) of
       true ->
           case check_method(Method) of
               true ->
                   {?_RC_SUCC,""};
               false ->
                   {?_RC_GAME_001,""};
               _ ->
                   {?_RC_GAME_002,""}
           end;
       false ->
           {?_RC_GAME_001,""};
       _ ->
           {?_RC_GAME_002,""}
   end.

