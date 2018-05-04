%% *******************************
%% 结拜数据操作
%% @author lishen (105326073@qq.com)
%% *******************************

-module(sworn_dao).
-export([
        load/1
        ,save/1
        ,delete/1
        ,save_title/3
        ,log/2
        ,save_del_member/4
    ]).

-include("common.hrl").
-include("sworn.hrl").

%% ----------------------------------------------------
%% 结拜成员信息，各成员各保留一条记录，角色ID做索引
%% ----------------------------------------------------

%% @doc 导入结拜成员数据
%% load() -> {ok, Num} | {false, Reason}
load({Id, SrvId}) ->
    Sql = <<"select rid, srv_id, name, rank, member1_rid, member1_srv_id, member1_name, member1_rank, member2_rid, member2_srv_id, member2_name, member2_rank, out_member_rid, out_member_srv_id, num, type, is_award, title_id, title_h, title_t, title, ctime from sys_role_sworn where rid = ~s and srv_id = ~s;">>,
    case db:get_row(Sql, [Id, SrvId]) of
        {ok, List} ->
            do_load_cache(List);
        _E ->
            {false, _E}
    end.

do_load_cache([]) -> ok;
do_load_cache([Id, SrvId, Name, Rank, Member1Id, Member1SrvId, Member1Name, Member1Rank, 0, _Member2SrvId, _Member2Name, _Member2Rank, OutMemberId, OutMemberSrvId, Num, Type, IsAward, TitleID, TitleH, TitleT, Title, Time]) ->
    Data = #sworn_info{id = {Id, SrvId}, name = Name, rank = Rank, member = [#sworn_member{id = {Member1Id, Member1SrvId}, name = Member1Name, rank = Member1Rank}], out_member_id = {OutMemberId, OutMemberSrvId}, num = Num, type = Type, is_award = IsAward, title_id = TitleID, title_h = TitleH, title_t = TitleT, title = Title, time = Time},
    ets:insert(ets_role_sworn, Data),
    ok;
do_load_cache([Id, SrvId, Name, Rank, Member1Id, Member1SrvId, Member1Name, Member1Rank, Member2Id, Member2SrvId, Member2Name, Member2Rank, OutMemberId, OutMemberSrvId, Num, Type, IsAward, TitleID, TitleH, TitleT, Title, Time]) ->
    Data = #sworn_info{id = {Id, SrvId}, name = Name, rank = Rank, member = [#sworn_member{id = {Member1Id, Member1SrvId}, name = Member1Name, rank = Member1Rank}, #sworn_member{id = {Member2Id, Member2SrvId}, name = Member2Name, rank = Member2Rank}], out_member_id = {OutMemberId, OutMemberSrvId}, num = Num, type = Type, is_award = IsAward, title_id = TitleID, title_h = TitleH, title_t = TitleT, title = Title, time = Time},
    ets:insert(ets_role_sworn, Data),
    ok;
do_load_cache(_E) ->
    ?ERR("读取结拜数据出错: ~w", [_E]).

%% @doc 保存数据
%% save(List) -> {ok, Num}
save(List) ->
    Sql = <<"replace into sys_role_sworn(rid, srv_id, name, rank, member1_rid, member1_srv_id, member1_name, member1_rank, member2_rid, member2_srv_id, member2_name, member2_rank, out_member_rid, out_member_srv_id, num, type, is_award, title_id, title_h, title_t, title, ctime) values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    save(List, Sql, 0).

save([], _Sql, N) -> {ok, N};
save([#sworn_info{id = {Id, SrvId}, name = Name, rank = Rank, member = [#sworn_member{id = {Member1Id, Member1SrvId}, name = Member1Name, rank = Member1Rank}], out_member_id = {OutMemberId, OutMemberSrvId}, num = Num, type = Type, is_award = IsAward, title_id = TitleID, title_h = TitleH, title_t = TitleT, title = Title, time = Time} | T], Sql, N) ->
    Data = [Id, SrvId, Name, Rank, Member1Id, Member1SrvId, Member1Name, Member1Rank, 0, 0, <<>>, 0, OutMemberId, OutMemberSrvId, Num, Type, IsAward, TitleID, TitleH, TitleT, Title, Time],
    case db:execute(Sql, Data) of
        {error, _Why} ->
            ?ERR("保存数据出错[Data:~w~n Why:~w", [Data, _Why]),
            save(T, Sql, N);
        {ok, X} when is_integer(X) ->
            save(T, Sql, N + X);
        _E ->
            save(T, Sql, N)
    end;
save([#sworn_info{id = {Id, SrvId}, name = Name, rank = Rank, member = [#sworn_member{id = {Member1Id, Member1SrvId}, name = Member1Name, rank = Member1Rank}, #sworn_member{id = {Member2Id, Member2SrvId}, name = Member2Name, rank = Member2Rank}], out_member_id = {OutMemberId, OutMemberSrvId}, num = Num, type = Type, is_award = IsAward, title_id = TitleID, title_h = TitleH, title_t = TitleT, title = Title, time = Time} | T], Sql, N) ->
    Data = [Id, SrvId, Name, Rank, Member1Id, Member1SrvId, Member1Name, Member1Rank, Member2Id, Member2SrvId, Member2Name, Member2Rank, OutMemberId, OutMemberSrvId, Num, Type, IsAward, TitleID, TitleH, TitleT, Title, Time],
    case db:execute(Sql, Data) of
        {error, _Why} ->
            ?ERR("保存数据出错[Data:~w~n Why:~w", [Data, _Why]),
            save(T, Sql, N);
        {ok, X} when is_integer(X) ->
            save(T, Sql, N + X);
        _E ->
            save(T, Sql, N)
    end.

%% @doc 删除结拜信息
%% delete(IdList) -> ok | {false, Reason}
delete([]) -> ok;
delete([RoleId | T]) ->
    case delete(RoleId) of
        {false, Why} -> {false, Why};
        ok ->
            delete(T)
    end;
delete({Id, SrvId}) ->
    Sql = <<"delete from sys_role_sworn where rid = ~s and srv_id = ~s">>,
    case db:execute(Sql, [Id, SrvId]) of
        {error, Why} ->
            ?ERR("删除玩家结拜信息出错[ID: ~w~n原因: ~w]", [{Id, SrvId}, Why]),
            {false, Why};
        {ok, _} -> ok
    end.

%% @doc 掉线称号保存
save_title(Head, Tail, {Id, SrvId}) ->
    Sql = <<"update sys_role_sworn set title_h = ~s, title_t = ~s where rid = ~s and srv_id = ~s;">>,
    case db:execute(Sql, [Head, Tail, Id, SrvId]) of
        {error, _Why} ->
            ?ERR("保存数据出错[Data:~w~n Why:~w", [[Head, Tail, Id, SrvId], _Why]);
        {ok, _} ->
            ok
    end.

%% @doc 割袍断义，其他下线成员记录
save_del_member({OutId, OutSrvId}, Num, Rank, {Id, SrvId}) ->
    Sql = <<"update sys_role_sworn set out_member_rid = ~s, out_member_srv_id = ~s, num = ~s, rank = ~s where rid = ~s and srv_id = ~s;">>,
    case db:execute(Sql, [OutId, OutSrvId, Num, Rank, Id, SrvId]) of
        {error, _Why} ->
            ?ERR("保存数据出错[Data:~w~n Why:~w", [[OutId, OutSrvId, Num, Id, SrvId], _Why]);
        {ok, _} ->
            ok
    end.

%% 日志记录
log(Atom, #sworn_info{id = {Id, SrvId}, name = Name, rank = Rank, member = [#sworn_member{id = {Id1, SrvId1}, name = Name1, rank = Rank1}], num = Num, type = Type, is_award = IsAward, title_id = TitleID, title = Title, time = Time}) ->
    Sql = <<"insert into log_role_sworn(ret, rid, srv_id, name, rank, member1_rid, member1_srv_id, member1_name, member1_rank, member2_rid, member2_srv_id, member2_name, member2_rank, num, type, is_award, title_id, title, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    Ret = case Atom of
        sworn -> 0;
        edit_title -> 1;
        add_member -> 2;
        break -> 3;
        _ -> 10
    end,
    Data = [Ret, Id, SrvId, Name, Rank, Id1, SrvId1, Name1, Rank1, 0, 0, <<>>, 0,  Num, Type, IsAward, TitleID, Title, Time],
    case db:execute(Sql, Data) of
        {error, _Why} ->
            ?ERR("结拜相关记录日志出错[Data:~w, Why:~w]", [Data, _Why]);
        {ok, _} -> ok
    end;
log(Atom, #sworn_info{id = {Id, SrvId}, name = Name, rank = Rank, member = [#sworn_member{id = {Id1, SrvId1}, name = Name1, rank = Rank1}, #sworn_member{id = {Id2, SrvId2}, name = Name2, rank = Rank2}], num = Num, type = Type, is_award = IsAward, title_id = TitleID, title = Title, time = Time}) ->
    Sql = <<"insert into log_role_sworn(ret, rid, srv_id, name, rank, member1_rid, member1_srv_id, member1_name, member1_rank, member2_rid, member2_srv_id, member2_name, member2_rank, num, type, is_award, title_id, title, ctime) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    Ret = case Atom of
        sworn -> 0;
        edit_title -> 1;
        add_member -> 2;
        break -> 3;
        _ -> 10
    end,
    Data = [Ret, Id, SrvId, Name, Rank, Id1, SrvId1, Name1, Rank1, Id2, SrvId2, Name2, Rank2,  Num, Type, IsAward, TitleID, Title, Time],
    case db:execute(Sql, Data) of
        {error, _Why} ->
            ?ERR("结拜相关记录日志出错[Data:~w, Why:~w]", [Data, _Why]);
        {ok, _} -> ok
    end.
