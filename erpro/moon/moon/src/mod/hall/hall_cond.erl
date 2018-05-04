%% --------------------------------------------------------------------
%% 大厅规则
%% @author abu
%% @end
%% --------------------------------------------------------------------

-module(hall_cond).

-export([
        check/3
    ]).


%% @spec check(Action, Type, Role) -> {ok} | {false, Reason}
%% Action = atom()
%% Type = integer()
%% Role = #role{}
%% 检测用户的大厅操作是否可行
check(_Action, _Type, _Role) ->
    {ok}.

