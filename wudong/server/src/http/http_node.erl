%% @author zj
%% @doc http 登陆节点请求返回

-module(http_node).

%% ====================================================================
%% API functions
%% ====================================================================
-export([login/1]).

%%返回登陆节点
login(_QueryParam) ->
    {ok,1}.

%% ====================================================================
%% Internal functions
%% ====================================================================


