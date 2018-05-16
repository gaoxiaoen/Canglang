%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 四月 2018 上午10:24
%%%-------------------------------------------------------------------
-module(cross_mining_rpc).
-author("luobaqun").
-include("server.hrl").
-include("common.hrl").
-include("daily.hrl").
-include("cross_mining.hrl").
-include("guild.hrl").

-export([handle/3]).

%% 获取矿洞信息
handle(60401, Player, {Type, Page}) ->
    cross_all:apply(cross_mining, get_mine_info, [node(), Player#player.sid, Type, Page, Player#player.pid, Player#player.key]),
    ok;

%% 获取我的矿洞
handle(60402, Player, {}) ->
    {_Index, FreeEndTime} = daily:get_count(?DAILY_CROSS_MINE_ATT, {0, 0}),
    cross_all:apply(cross_mining, get_my_mine_info, [node(), Player#player.sid, Player#player.key, max(0, FreeEndTime - util:unixtime())]),
    ok;

%% 进攻矿洞
handle(60403, Player, {Type, Page, Id, Ids}) ->
    ?DEBUG("Ids ~p~n",[Ids]),
    case cross_mining:att_mine_help(Player,Type, Page, Id, Ids) of
         ok ->ok;
        Other ->
            {ok, Bin} = pt_604:write(60403,Other),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%% 进攻小偷
handle(60404, Player, {Type, Page, Id}) ->
    Count = daily:get_count(?DAILY_CROSS_MINE_THIEF),
    Base = data_mining_event:get(?EVENT_TYPE_2),
    if
        Count > Base#base_mining_event.daily_limit ->
            {ok, Bin} = pt_604:write(60404, {15, []}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            daily:increment(?DAILY_CROSS_MINE_THIEF, 1),
            cross_all:apply(cross_mining, att_thief, [node(), Player#player.sid, Type, Page, Id, Player#player.key, Player#player.nickname, Player#player.cbp, config:get_server_num(), Player#player.vip_lv, Player#player.d_vip#dvip.vip_type])
    end,
    ok;

%% 领取奖励
handle(60405, Player, {Type, Page, Id}) ->
    cross_all:apply(cross_mining, get_mine_reward, [node(), Player#player.sid, Type, Page, Id, Player#player.key, Player#player.pid]),
    ok;

%% 离开矿洞
handle(60407, Player, {Type, Page}) ->
    cross_all:apply(cross_mining, exit_mine, [node(), Player#player.sid, Type, Page, Player#player.key]),
    ok;

%% 获取攻击信息
handle(60408, Player, {Type, Page, Id}) ->
    cross_all:apply(cross_mining, get_att_info, [node(), Player#player.sid, Type, Page, Id, Player#player.key, Player#player.cbp]),
    ok;

%% 获取单个矿点信息
handle(60409, Player, {Type, Page, Id}) ->
    cross_all:apply(cross_mining, get_one_mine_info, [node(), Player#player.sid, Type, Page, Id]),
    ok;

%% 获取个人日志
handle(60410, Player, {}) ->
    Count = daily:get_count(?DAILY_CROSS_MINE_THIEF),

    cross_all:apply(cross_mining, get_mine_log, [node(), Player#player.sid, Player#player.key, Count]),
    ok;

%% 获取其他玩家矿点
handle(60413, Player, {Pkey}) ->
    cross_all:apply(cross_mining, get_other_mine, [node(), Player#player.sid, Pkey]),
    ok;

%% 获取全服日志
handle(60414, Player, {}) ->
    cross_all:apply(cross_mining, get_all_log, [node(), Player#player.sid, Player#player.key]),
    ok;


%% 获取排名
handle(60417, Player, {}) ->
    cross_all:apply(cross_mining, get_rank_info, [node(), Player#player.sid, Player#player.key]),
    ok;


%% 获取进攻援助信息
handle(60418, Player, {}) ->
    Data = cross_mining_init:get_info(Player),
%%     ?DEBUG("Data ~p~n", [Data]),
    {ok, Bin} = pt_604:write(60418, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 购买镜像
handle(60419, Player, {Id, Type}) ->
    {Res, NewPlayer} = cross_mining_init:buy_help(Player, Id, Type),
    ?DEBUG("res ~p~n", [Res]),
    {ok, Bin} = pt_604:write(60419, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 援助矿点
handle(60420, Player, {Type, Page, Id, Pkey}) ->
    Res = cross_mining:help_friend(Player, Type, Page, Id, Pkey),
    if
        Res == 1 -> skip;
        true ->
            {ok, Bin} = pt_604:write(60420, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end,
    ok;

%% 获取排行版数据
handle(60421, Player, _) ->
    Data = cross_mining:get_rank_info(Player),
    ?DEBUG("Data ~p~n",[Data]),
    {ok, Bin} = pt_604:write(60421, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 刷新援助列表
handle(60422, Player, _) ->
    {Res,NewPlayer} = cross_mining_init:reser_help(Player),
    {ok, Bin} = pt_604:write(60422, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok,NewPlayer};


handle(_Cmd, _Player, Msg) ->
    ?ERR("cmd ~p msg ~p undef~n", [_Cmd, Msg]),
    ok.

