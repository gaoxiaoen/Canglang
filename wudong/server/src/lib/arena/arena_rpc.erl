%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 十一月 2015 17:34
%%%-------------------------------------------------------------------
-module(arena_rpc).
-author("hxming").
-include("server.hrl").
-include("common.hrl").

%% API
-export([handle/3]).

%%获取竞技场信息
handle(23001, Player, _) ->
    IsScoreReward = arena_score:check_score_reward(),
    ?CAST(arena_proc:get_server_pid(), {arena_info, Player,IsScoreReward}),
    ok;

%%刷新我的可挑战对手
handle(23002, Player, _) ->
    ?CAST(arena_proc:get_server_pid(), {arena_refresh, Player}),
    ok;

%%购买竞技场次数
handle(23003, Player, _) ->
    {Ret, Times, HadBuy, Gold} = ?CALL(arena_proc:get_server_pid(), {arena_buy_times, Player}),
    {ok, Bin} = pt_230:write(23003, {Ret, Times, HadBuy}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        NewPlayer = money:add_no_bind_gold(Player, -Gold, 13, 0, 0),
        {ok, NewPlayer};
        true -> ok
    end;

%%竞技场挑战
handle(23004, Player, {Pkey}) ->
    ?CAST(arena_proc:get_server_pid(), {arena_challenge, Player, Pkey}),
    ok;

%%清除竞技场CD
handle(23006, Player, _) ->
    {Ret, Gold} = ?CALL(arena_proc:get_server_pid(), {clean_cd, Player}),
    {ok, Bin} = pt_230:write(23006, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    activity:get_notice(Player, [105], true),
    if Ret == 1 ->
        NewPlayer = money:add_no_bind_gold(Player, -Gold, 28, 0, 0),
        {ok, NewPlayer};
        true -> ok
    end;

%%获取历史最高排名
handle(23007, Player, _) ->
    ?CAST(arena_proc:get_server_pid(), {arena_log, Player#player.key, Player#player.sid}),
    ok;

%%获取积分奖励列表
handle(23008, Player, _) ->
    Data = arena_score:get_score_reward_list(),
    {ok, Bin} = pt_230:write(23008, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%领取奖励
handle(23009, Player, {Score}) ->
    {Ret, GoodsList, IsReward} = arena_score:score_reward(Score),
    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(78, GoodsList)),
    activity:get_notice(NewPlayer, [106], true),
    {ok, Bin} = pt_230:write(23009, {Ret, IsReward, [tuple_to_list(Item) || Item <- GoodsList]}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%排行榜
handle(23010, Player, {Page}) ->
    ?CAST(arena_proc:get_server_pid(), {get_rank_list, Player#player.key, Player#player.sid, Page}),
    ok;

%%排行榜挑战
handle(23011, Player, {Pkey}) ->
    ?CAST(arena_proc:get_server_pid(), {arena_rank_challenge, Player, Pkey}),
    ok;


%%获取目标
handle(23012, Player, _) ->
    case scene:is_dungeon_scene(Player#player.scene) of
        false -> ok;
        true ->
            Player#player.copy ! {dungeon_target, Player#player.sid},
            ok
    end;



handle(_cmd, _Player, _Data) ->
    ok.

