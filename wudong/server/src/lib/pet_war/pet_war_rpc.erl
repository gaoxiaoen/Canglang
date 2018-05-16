%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十一月 2017 17:15
%%%-------------------------------------------------------------------
-module(pet_war_rpc).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("pet_war.hrl").

%% API
-export([handle/3]).

%% 宠物上阵
handle(44302, Player, {Key, MapId, Pos}) ->
    Code = pet_map:put_on(Key, MapId, Pos),
    {ok, Bin} = pt_443:write(44302, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 宠物下阵
handle(44303, Player, {Key, MapId}) ->
    Code = pet_map:put_down(Key, MapId),
    {ok, Bin} = pt_443:write(44303, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 宠物位置交换
handle(44304, Player, {Key1, Key2, MapId}) ->
    Code = pet_map:swap(Key1, Key2, MapId),
    {ok, Bin} = pt_443:write(44304, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 获取宠物阵型
handle(44305, Player, _) ->
    {UseMapId, Data} = pet_map:get_map_info(),
    {ok, Bin} = pt_443:write(44305, {UseMapId, Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 宠物对战副本链
handle(44306, Player, _) ->
    {DunId, Chapter, IsChallenge} = pet_war_dun:get_dun_info(),
%%     ?DEBUG("DunId:~p, Chapter:~p, IsChallenge:~p", [DunId, Chapter, IsChallenge]),
    {ok, Bin} = pt_443:write(44306, {DunId, Chapter, IsChallenge}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 对战怪物，发起挑战
handle(44307, Player, {DunId, MapId}) ->
    {Code, FirstPassReward, DailyPassReward, NewPlayer} = pet_war_dun:challenge(Player, DunId, MapId),
    {ok, Bin} = pt_443:write(44307, {Code, FirstPassReward ++ DailyPassReward}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 领取星数奖励
handle(44308, Player, {Chapter, Star}) ->
    {Code, Reward, NewPlayer} = pet_war_dun:recv_star(Player, Chapter, Star),
    {ok, Bin} = pt_443:write(44308, {Code, Reward}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 副本扫荡
handle(44309, Player, {DunId}) ->
    {Code, RewardList, NewPlayer} = pet_war_dun:saodang(Player, DunId),
    {ok, Bin} = pt_443:write(44309, {Code, RewardList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 保存阵型
handle(44310, Player, {UseMapId}) ->
    Code = pet_map:save_map(UseMapId),
    {ok, Bin} = pt_443:write(44310, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 获取副本面板信息
handle(44311, Player, {DunId}) ->
    {Saodang, FirstPassReward, DailyPassReward} = pet_war_dun:get_dun_info(DunId),
    {ok, Bin} = pt_443:write(44311, {Saodang, FirstPassReward, DailyPassReward}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 领取副本通关奖励
handle(44312, Player, {DunId}) ->
    {Code, NewPlayer} = pet_war_dun:recv_dun_reward(Player, DunId),
    {ok, Bin} = pt_443:write(44312, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 读取章节星数奖励
handle(44313, Player, {Chapter}) ->
    Data = pet_war_dun:get_star_info(Chapter),
    {ok, Bin} = pt_443:write(44313, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 一键扫荡
handle(44314, Player, {Chapter}) ->
    ?DEBUG("44314 Chapter:~p", [Chapter]),
    {Code, Data, NewPlayer} = pet_war_dun:one_key_saodang(Player, Chapter),
    ?DEBUG("Code:~p Data:~p", [Code, Data]),
    {ok, Bin} = pt_443:write(44314, {Code, Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_Cmd, _Player, _Args) ->
    ok.
