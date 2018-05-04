%% --------------------------------------------------------------------
%% @doc 飞仙历练管理进程
%% @author weihua@jieyou.cn
%% --------------------------------------------------------------------
-module(train_parse).
-export([ver/1, ver_parse/1]).

-include("common.hrl").
-include("train.hrl").

%% -------------------------------------------
%% 角色历练数据转换
%% -------------------------------------------
ver_parse({role_train, TrainId, TrainTime, TrainRob, TrainArrest, Fight, Stamp}) ->
    ver_parse({role_train, TrainId, TrainTime, TrainRob, TrainArrest, Fight, Stamp, 0});
ver_parse(Train) -> Train.

%% ===============================================================================
%% 飞仙历练
%% ===============================================================================
%% TODO 增加物品数据结构转换
ver(TrainField) ->
    Ver = erlang:element(5, TrainField),
    do(Ver, TrainField).

%% 历练数据升级，增加历练位置集
do(Ver = 0, {train_field, Id, Lid, Pid, Ver, Num, Roles, Robs, Visitors}) ->
    NextVer = Ver + 1,
    do(NextVer, {train_field, Id, Lid, Pid, NextVer, Num, Roles, Robs, Visitors, []});

do(?train_ver, TrainField = #train_field{roles = Roles}) ->
    case ver_other(Roles) of
        false -> false;
        NewRoles -> TrainField#train_field{roles = NewRoles}
    end;
do(_Ver, _Field) ->
    ?DEBUG("ver is ~w, field is ~w", [_Ver, _Field]),
    ?ERR("飞仙历练数据转换失败"),
    false.

%% -------------------------------------------------------------
%% 转换其他数据
%% -------------------------------------------------------------
ver_other(Roles) ->
    ver_other(Roles, []).
ver_other([], Roles) ->
    Roles;
ver_other([Role | Roles], NewRoles) ->
    case do_ver_other(Role) of
        false -> false;
        NewRole -> ver_other(Roles, [NewRole | NewRoles])
    end.

do_ver_other(Role = #train_role{eqm = Eqm}) ->
    case item_parse:do(Eqm) of
        {ok, NewEqm} ->
            Role#train_role{eqm = NewEqm};
        _ ->
            ?ERR("飞仙历练装备数据转换失败"),
            false
    end.
