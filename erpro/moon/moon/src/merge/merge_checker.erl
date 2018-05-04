%%----------------------------------------------------
%% @doc 检测
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_checker).

-export([
        check_all/0
    ]
).

-include("common.hrl").
-include("merge.hrl").

%%----------------------------------------------------
%% 检测全部
%%----------------------------------------------------
check_all() ->
    SrvList = merge_util:all_server(),
    List = [{realm_val, SrvList}, target_db],
    case check_all(List) of
        ok -> ok;
        {false, Reason} -> {false, Reason}
    end.

check_all([]) -> ok;
check_all([H | T]) ->
    case check(H) of
        ok -> check_all(T);
        {false, Reason} -> {false, Reason}
    end.

check({realm_val, []}) -> ok;
check({realm_val, [#merge_server{platform = Platform, update_realm = true, realm = 0}]}) ->
    {false, util:fbin(?L(<<"~w库阵营没有设置">>), [Platform])};
check({realm_val, [#merge_server{platform = Platform, data_source = DataSource, update_realm = true} | T]}) ->
    Sql = "select count(*) from sys_env where name = 'merge_time'",
    case merge_db:get_one(DataSource, Sql) of
        {error, undefined} -> {false, util:fbin(?L(<<"~w库查询合服时间有误">>), [Platform])};
        {ok, 0} -> check({realm_val, T});
        {ok, Count} when Count > 0 ->
            {false, util:fbin(?L(<<"~w库已经合过服，存在阵营信息了">>), [Platform])};
        _ErrMsg ->
            {false, _ErrMsg}
    end;
check({realm_val, [#merge_server{platform = Platform, data_source = DataSource, update_realm = false} | T]}) ->
    Sql = "select count(*) from sys_env where name = 'merge_time'",
    case merge_db:get_one(DataSource, Sql) of
        {error, undefined} ->
            {false, util:fbin(?L(<<"~w库没有阵营信息，需要指定">>), [Platform])};
        {ok, 0} ->
            {false, util:fbin(?L(<<"~w库没有阵营信息，需要指定">>), [Platform])};
        {ok, Count} when Count > 0 ->
            check({realm_val, T});
        {error, Reason}->
            {false, Reason};
        _ErrMsg ->
            {false, _ErrMsg}
    end;
check({realm_val, [_Server | T]}) ->
    check({realm_val, T});

check(target_db) ->
    Sql = "select count(*) from role",
    case merge_db:get_one(?merge_target, Sql) of
        {ok, undefined} -> ok;
        {ok, 0} -> ok;
        {ok, _} ->
            {false, ?L(<<"目标库非空库，请清档后继续">>)};
        {error, Reason}->
            {false, Reason};
        _ErrMsg -> {false, _ErrMsg}
    end.
