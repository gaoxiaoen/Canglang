%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 七月 2017 17:07
%%%-------------------------------------------------------------------
-module(jade_rpc).
-author("hxming").



-include("common.hrl").
-include("server.hrl").
-include("jade.hrl").

%% API
-export([handle/3]).

handle(65201, Player, {}) ->
    Data = jade:get_jade_info(),
    {ok, Bin} = pt_652:write(65201, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%升阶
handle(65202, Player, {Auto}) ->
    case jade:upgrade_stage(Player, Auto) of
        {ok, Code, NewPlayer} ->
            {ok, Bin} = pt_652:write(65202, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, jade, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_652:write(65202, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%%%切换外观
handle(65203, Player, {Figure}) ->
    {Ret, NewPlayer} = jade:change_figure(Player, Figure),
    {ok, Bin} = pt_652:write(65203, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, jade, NewPlayer};

%%激活技能
handle(65204, Player, {Cell}) ->
    {Ret, NewPlayer} = jade_skill:activate_skill(Player, Cell),
    {ok, Bin} = pt_652:write(65204, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%升级技能
handle(65205, Player, {Cell}) ->
    {Ret, NewPlayer} = jade_skill:upgrade_skill(Player, Cell),
    {ok, Bin} = pt_652:write(65205, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%更新技能列表
handle(65206, Player, {}) ->
    GoldenBody = lib_dict:get(?PROC_STATUS_JADE),
    Data = jade_skill:get_jade_skill_list(GoldenBody#st_jade.skill_list),
    {ok, Bin} = pt_652:write(65206, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%装备物品
handle(65207, Player, {GoodsKey}) ->
    {Ret, NewPlayer} = jade:equip_goods(Player, GoodsKey),
    {ok, Bin} = pt_652:write(65207, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%% 使用神兵成长丹
handle(65208, Player, {}) ->
    case jade:use_jade_dan(Player) of
        {false, Ret} ->
            {ok, Bin} = pt_652:write(65208, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_652:write(65208, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%领取外观
handle(65209, Player, {}) ->
    NewPlayer = jade_init:activate(Player),
    {ok, Bin} = pt_652:write(65209, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};



handle(65210, Player, {}) ->
    Data = jade_spirit:spirit_info(),
    {ok, Bin} = pt_652:write(65210, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(65211, Player, {}) ->
    {Ret, NewPlayer} = jade_spirit:spirit_upgrade(Player),
    {ok, Bin} = pt_652:write(65211, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attrs, NewPlayer};
        true -> ok
    end;


handle(_cmd, _player, _data) ->
    ok.
