%%----------------------------------------------------
%% @doc 全局性数据分析
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_analyse).

-export([
        do/1
        ,get/2
    ]
).

-include("common.hrl").
-include("merge.hrl").

%%----------------------------------------------------
%% API
%%----------------------------------------------------
do([]) -> ok;

%% 处理重复的角色名
do([role_name | T]) ->
    ok = do_role_name(),
    do(T);

%% 处理重复的角色名
do([guild_name | T]) ->
    do(T).

%% 获取新数据
%% 角色名称
get(role_name, {RoleId, SrvId, RoleName}) ->
    case ets:lookup(ets_merge_role_name, {RoleId, SrvId}) of
        [] -> RoleName;
        [#merge_role_name{name = NewRoleName}] -> NewRoleName
    end.

%%----------------------------------------------------
%% 内部函数
%%----------------------------------------------------
%% 处理重的角色名
do_role_name() ->
    SrvList = merge_util:all_server(),
    deal_role_name_srv(SrvList, 1, length(SrvList)),
    ok.

deal_role_name([], _DataSource, _Index, _Size) -> ok;
deal_role_name([[RoleId, SrvId, Name, Lev] | T], DataSource, 1, Size) ->
    ets:insert(ets_merge_role_name_temp, #merge_role_name{key = {RoleId, SrvId}, name = Name, lev = Lev, data_source = DataSource}),
    deal_role_name(T, DataSource, 1, Size);
deal_role_name([[RoleId, SrvId, Name, Lev] | T], DataSource, Index, Size) ->
    case ets:lookup(ets_merge_role_name_temp, Name) of
        [] -> 
            case Index =/= Size of
                true -> 
                    ets:insert(ets_merge_role_name_temp, #merge_role_name{key = {RoleId, SrvId}, name = Name, lev = Lev, data_source = DataSource});
                false -> ignore
            end,
            ignore;
        [#merge_role_name{key = {ORoleId, OSrvId}, name = OName, lev = OLev, data_source = ODataSource}] when OLev =:= Lev ->
            {ok, MasterExp} = merge_dao_role_assets:get_exp(ODataSource, ORoleId, OSrvId),
            {ok, SlaveExp} = merge_dao_role_assets:get_exp(DataSource, RoleId, SrvId),
            case MasterExp > SlaveExp of
                true -> 
                    ets:insert(ets_merge_role_name, #merge_role_name{key = {RoleId, SrvId}, name = convert_role_name2(RoleId, SrvId, Name, Lev, DataSource)});
                false -> 
                    ets:insert(ets_merge_role_name_temp, #merge_role_name{key = {RoleId, SrvId}, name = Name, lev = Lev, data_source = DataSource}),
                    ets:insert(ets_merge_role_name, #merge_role_name{key = {ORoleId, OSrvId}, name = convert_role_name2(ORoleId, OSrvId, OName, OLev, ODataSource)})
            end;
        [#merge_role_name{lev = OLev}] when OLev > Lev ->

            ets:insert(ets_merge_role_name, #merge_role_name{key = {RoleId, SrvId}, name = convert_role_name2(RoleId, SrvId, Name, Lev, DataSource), lev = Lev});
        [#merge_role_name{key = {ORoleId, OSrvId}, lev = OLev, name = OName, data_source = ODataSource}] when OLev < Lev ->
            ets:insert(ets_merge_role_name_temp, #merge_role_name{key = {RoleId, SrvId}, name = Name, lev = Lev, data_source = DataSource}),
            ets:insert(ets_merge_role_name, #merge_role_name{key = {ORoleId, OSrvId}, name = convert_role_name2(ORoleId, OSrvId, OName, OLev, ODataSource)})
    end,
    deal_role_name(T, DataSource, Index, Size).

deal_role_name_srv([], _Index, _Size) -> ok;
deal_role_name_srv([#merge_server{data_source = DataSource} | T], Index, Size) ->
    {ok, RoleNameList} = merge_dao_role:get_roles_name(DataSource),
    ok = deal_role_name(RoleNameList, DataSource, Index, Size),
    deal_role_name_srv(T, Index + 1, Size).

convert_role_name(SrvId, Name) ->
    [SrvSn | _T] = lists:reverse(re:split(bitstring_to_list(SrvId), "_", [{return, list}])),
    util:fbin(?L(<<"【~s服】~s">>), [SrvSn, Name]).
convert_role_name2(RoleId, SrvId, Name, Lev, DataSource) ->
    RoleName = convert_role_name(SrvId, Name),
    case ets:lookup(ets_merge_role_name_temp, RoleName) of
        [] -> 
            ets:insert(ets_merge_role_name_temp, #merge_role_name{key = {RoleId, SrvId}, name = RoleName, lev = Lev, data_source = DataSource}),
            RoleName;
        _ ->
            convert_role_name3(RoleId, SrvId, Name, Lev, DataSource, RoleName, 1)
    end.
convert_role_name3(RoleId, SrvId, Name, Lev, DataSource, RoleName, Num) ->
    NewRoleName = list_to_bitstring(util:to_list(RoleName) ++ util:to_list(Num)),
    case ets:lookup(ets_merge_role_name_temp, NewRoleName) of
        [] -> 
            ets:insert(ets_merge_role_name_temp, #merge_role_name{key = {RoleId, SrvId}, name = NewRoleName, lev = Lev, data_source = DataSource}),
            NewRoleName;
        _ ->
            convert_role_name3(RoleId, SrvId, Name, Lev, DataSource, RoleName, Num + 1)
    end.
