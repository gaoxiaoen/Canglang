%% --------------------------------------
%% @doc 飞仙历练后台管理
%% @author weihua@jieyou.cn
%% -------------------------------------
-module(train_adm).
-export([restart/1]).

%% @spec restart(Type) -> ok
%% @doc 重启飞仙历练进程
restart(local) ->
    supervisor:terminate_child(sup_master, train_mgr),
    timer:sleep(1000),
    supervisor:restart_child(sup_master, train_mgr);
restart(center) ->
    case center:is_cross_center() of
        true ->
            supervisor:terminate_child(sup_center, train_mgr_center),
            timer:sleep(1000),
            supervisor:restart_child(sup_center, train_mgr_center);
        false ->
            center:cast(?MODULE, restart, [center])
    end.
