%%----------------------------------------------------
%% @doc
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(guild_boss_dao).
-export([
        load_all/0
        ,save_one/1
        ,delete_one/1
        ,sync_all/0
    ]).

-include("common.hrl").
-include("guild_boss.hrl").

%% @spec load_all() -> [#guild_boss_guild{}..]
%% 载入所有数据
load_all() ->
    Sql = "select `id`, `srv_id`, `name`, `bosses`, `kill_log` from `sys_guild_boss`",
    case db:get_all(Sql) of
        {ok, Rdata} when is_list(Rdata) ->
            F = fun([Id, SrvId, Name, Bosses, KillLog]) ->
                    #guild_boss_guild{
                        id = {Id, SrvId}, 
                        name = Name, 
                        bosses = to_term(Bosses),
                        kill_log = to_term(KillLog)
                    }
            end,
            [F(R) || R <- Rdata];
        {error, _Msg} ->
            ?ERR("帮战获取参战帮派信息出错: ~s", [_Msg]),
            [];
        _ ->
            []
    end.

%% 把一个帮派的数据放到持久化缓冲区（进程字典）
save_one(G = #guild_boss_guild{id = Id}) ->
    case get(wait_for_sync) of
        List = [_H | _T] ->
            case lists:keyfind(Id, #guild_boss_guild.id, List) of
                #guild_boss_guild{} ->
                    put(wait_for_sync, lists:keyreplace(Id, #guild_boss_guild.id, List, G));
                _ ->
                    put(wait_for_sync, [G | List])
            end;
        _ ->
            put(wait_for_sync, [G])
    end;
save_one(_T) ->
    ?DEBUG("无效数据 ~w", [_T]),
    ok.

%% 删除一个帮派boss的信息
delete_one(Gid = {Id, SrvId}) ->
    case get(wait_for_sync) of
        List = [_H | _T] ->
            put(wait_for_sync, lists:keydelete(Gid, #guild_boss_guild.id, List));
        _ ->
            put(wait_for_sync, [])
    end,
    db:execute("delete from `sys_guild_boss` where `id`=~s and `srv_id`=~s",[Id, SrvId]);
delete_one(_) ->
    ok.

%% 把缓冲区（进程字典）的数据同步到数据库
sync_all() ->
    Sql = "replace into `sys_guild_boss`(`id`, `srv_id`, `name`, `bosses`, `kill_log`) values ",
    case get(wait_for_sync) of
        [H | T] ->
            F = fun(#guild_boss_guild{id = {Id, SrvId}, name = Name, bosses = Bosses, kill_log = KillLog}) ->
                    erlang:bitstring_to_list(db:format_sql("(~s, ~s, ~s, ~s, ~s)", [Id, SrvId, Name, util:term_to_bitstring(Bosses), util:term_to_bitstring(KillLog)]))
            end,
            FullSql = Sql ++ string:join([F(G) || G <- [H | T]], ","),
            db:execute(FullSql);
        _ ->
            ok
    end,
    put(wait_for_sync, []).


%% 将数据库存储的数据转换为erlang数据
to_term(GuildsData) ->
    case util:bitstring_to_term(GuildsData) of
        {ok, R} ->
            R;
        _ ->
            []
    end.
