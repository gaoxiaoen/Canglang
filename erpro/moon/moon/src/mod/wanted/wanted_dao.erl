%%----------------------------------------------------
%% @doc 悬赏boss数据库操作模块
%%
%% @author mobin
%%----------------------------------------------------
-module(wanted_dao).

-export([
        load_last_wanted/0,
        delete_last_wanted/0,
        save_wanted/1,
        save_wanted_npc/1,
        load_all_wanted_npc/0,
        delete_old_wanted_npc/0
    ]).

-include("common.hrl").
-include("wanted.hrl").

load_last_wanted() ->
    Sql = "select boss_count, killed_count from sys_wanted order by boss_count desc limit 1",
    case db:get_row(Sql, []) of
        {ok, [BossCount, KilledCount]} ->
            {BossCount, KilledCount};
        _ ->
            {1, 0}
    end.

delete_last_wanted() ->
    Sql = "delete from sys_wanted",
    case db:execute(Sql, []) of
        {ok, _} -> 
            ok;
        _Err ->
            ?ERR("删除旧的wanted信息失败:~w", [_Err]),
            _Err
    end.

save_wanted({BossCount, KilledCount}) ->
    Sql = "delete from sys_wanted",
    case db:execute(Sql, []) of
        {ok, _} -> 
            InsertSql = "insert into sys_wanted(boss_count, killed_count) values(~s,~s)",
            db:execute(InsertSql, [BossCount, KilledCount]);
        _Err ->
            ?ERR("删除旧的Wanted信息失败:~w", [_Err]),
            _Err
    end.

save_wanted_npc(#wanted_npc{id = Id, base_id = BaseId, origin_coin = OriginCoin, origin_stone = OriginStone, 
        kill_count = KillCount}) ->
    Sql = "insert into sys_wanted_npc values(~s, ~s, ~s, ~s, ~s)",
    case db:execute(Sql, [Id, BaseId, OriginCoin, OriginStone, KillCount]) of
        {error, Why} ->
            ?ERR("save_wanted_npc时发生异常: ~s", [Why]),
            false;
        {ok, _X} ->
            ok
    end.

load_all_wanted_npc() ->
    Sql = "select * from sys_wanted_npc",
    case db:get_all(Sql, []) of
        {ok, Data} when is_list(Data) ->
            convert(Data, []);
        _ ->
            ?ERR("读取wanted_npc出错", []),
            []
    end.

delete_old_wanted_npc() ->
    Sql = "delete from sys_wanted_npc",
    case db:execute(Sql, []) of
        {ok, _} -> 
            ok;
        _Err ->
            ?ERR("删除旧的wanted_npc信息失败:~w", [_Err]),
            _Err
    end.

convert([], L) -> L;
convert([[Id, BaseId, OriginCoin, OriginStone, KillCount] | T], L) ->
    WantedNpc = #wanted_npc{id = Id, base_id = BaseId, origin_coin = OriginCoin, origin_stone = OriginStone,
        kill_count = KillCount},
    convert(T, [WantedNpc | L]).

