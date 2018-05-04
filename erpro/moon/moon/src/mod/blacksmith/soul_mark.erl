%% ----------------------------------
%% 灵魂水晶模块
%% @author lishen(105326073@qq.com)
%% ----------------------------------
-module(soul_mark).
-export([
        use_item/2
    ]).

-include("role.hrl").
-include("soul_mark.hrl").
-include("gain.hrl").

%% @doc 使用灵魂水晶
use_item(Num, Role = #role{soul_mark = SoulMark = #soul_mark{lev = Lev, exp = Exp}}) ->
    {NewLev, NewExp, LeftNum} = do_upgrade(Lev, Exp, Num),
    UseNum = Num - LeftNum,
    case role_gain:do([#loss{label = items_bind_fst, val = [{33114, UseNum}]}], Role) of
        {false, #loss{msg = Msg}} -> {false, Msg};
        {ok, NewRole} ->
            {ok, role_api:push_attr(NewRole#role{soul_mark = SoulMark#soul_mark{lev = NewLev, exp = NewExp}}), UseNum}
    end.

%% 处理灵魂刻印升级
do_upgrade(50, _Exp, AddExp) -> {50, 0, AddExp};
do_upgrade(Lev, Exp, AddExp) ->
    UpExp = soul_mark_data:get_exp(Lev),
    SumExp = Exp + AddExp,
    case SumExp < UpExp of
        true ->
            {Lev, SumExp, 0};
        false ->
            do_upgrade(Lev + 1, 0, SumExp - UpExp)
    end.
