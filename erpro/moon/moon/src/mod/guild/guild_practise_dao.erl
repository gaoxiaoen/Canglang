%%----------------------------------------------------
%% 帮会历练数据库操作 
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(guild_practise_dao).
-export([
        load/2
        ,load_all/0
        ,save/1
        ,save/3
        ,save_all/1
    ]
).

-include("common.hrl").
-include("guild_practise.hrl").

%% 加载帮会历练数据
load(Gid, Gsrvid) ->
    Sql = "select members from sys_guild_practise where gid = ~s and gsrv_id = ~s",
    case db:get_one(Sql, [Gid, Gsrvid]) of
        {ok, Info} ->
            case util:bitstring_to_term(Info) of
                {ok, L} -> do_ver(L, []);
                _ ->
                    ?ERR("[~w:~s]帮会试练数据转换失败", [Gid, Gsrvid]),
                    []
            end;
        _ ->
            []
    end.

%% 加载所有历练数据
load_all() ->
    Sql = "select gid, gsrv_id, members from sys_guild_practise",
    case db:get_all(Sql, []) of
        {ok, Data} ->
            {ok, format(Data, [])};
        {error, undefined} -> 
            {ok, []};
        _Reason ->
            ?DEBUG("===帮会试练数据加载失败:~w", [_Reason]),
            false
    end.

%% 保存所有帮会历练数据
save_all(List) when is_list(List) ->
    spawn(
        fun() ->
                [do_save(Gid, Gsrvid, Members) || #guild_practise_list{id = {Gid, Gsrvid}, list = Members} <- List]
        end
    );
save_all(_) -> ok.

%% 保存帮会历练数据
save(#guild_practise_list{id = {Gid, Gsrvid}, list = Members}) ->
    save(Gid, Gsrvid, Members).

save(Gid, Gsrvid, Members) ->
    spawn(
        fun() ->
                do_save(Gid, Gsrvid, Members)
        end
    ).

%%----------------------------------------
%% 内部方法
%%----------------------------------------

%% 执行数据保存
do_save(Gid, Gsrvid, Members) ->
    Sql = "replace into sys_guild_practise(gid, gsrv_id, members) values(~s,~s,~s)",
    db:execute(Sql, [Gid, Gsrvid, util:term_to_bitstring(Members)]).

%% 格式转换
format([], L) -> L;
format([[Gid, Gsrvid, M] | T], L) ->
    case util:bitstring_to_term(M) of
        {ok, Members} when length(Members) > 0 ->
            NewMembers = do_ver(Members, []),
            R = #guild_practise_list{id = {Gid, Gsrvid}, list = NewMembers},
            format(T, [R | L]);
        {ok, []} ->
            format(T, L);
        _ ->
            ?ERR("[~w:~s]帮会历练数据转换失败", [Gid, Gsrvid]),
            format(T, L)
    end.

%% 数据版本处理
do_ver([], L) -> L;
do_ver([I | T], L) ->
    NewL = do_update_ver(I, L),
    do_ver(T, NewL).
do_update_ver({guild_practise_role, Ver, Id, Rid, Srvid, Name, Luck, RTime, Status, Help, Self, Quality, RList, TaskId}, L) ->
    do_update_ver({guild_practise_role, Ver, Id, Rid, Srvid, Name, Luck, RTime, Status, Help, Self, Quality, RList, TaskId, util:unixtime(), 0}, L);
do_update_ver(Member, L) when is_record(Member, guild_practise_role) -> [Member#guild_practise_role{online = 0} | L];
do_update_ver(_, L) -> L.
