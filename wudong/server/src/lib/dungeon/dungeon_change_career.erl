%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 八月 2017 15:32
%%%-------------------------------------------------------------------
-module(dungeon_change_career).
-author("Administrator").
-include("dungeon.hrl").

%% API
-export([
    update_change_career_dungeon_target/1,
    dungeon_change_career_ret/3
]).

%%更新转职副本目标信息
update_change_career_dungeon_target(StDun) ->
    Now = util:unixtime(),
    LeftTime = max(0, StDun#st_dungeon.end_time - Now),
    KillList = [[mon_util:get_mon_name(Mid), Cur, Need] || {Mid, Need, Cur} <- StDun#st_dungeon.kill_list],
    {ok, Bin} = pt_121:write(12198, {LeftTime, KillList}),
    [server_send:send_to_key(Mb#dungeon_mb.pkey, Bin) || Mb <- StDun#st_dungeon.player_list].


%%副本挑战结果
dungeon_change_career_ret(1, Player, DunId) ->
    {ok, Bin} = pt_121:write(12197, {1, DunId, []}),
    server_send:send_to_sid(Player#player.sid, Bin),
    activity:get_notice(Player, [148], true),
    Player;

dungeon_change_career_ret(0, Player, DunId) ->
    {ok, Bin} = pt_121:write(12197, {0, DunId, []}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Player.


