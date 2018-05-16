%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 七月 2017 17:07
%%%-------------------------------------------------------------------
-module(golden_body_rpc).
-author("hxming").



-include("common.hrl").
-include("server.hrl").
-include("golden_body.hrl").

%% API
-export([handle/3]).

handle(16201, Player, {}) ->
    Data = golden_body:get_golden_body_info(),
    {ok, Bin} = pt_162:write(16201, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%升阶
handle(16202, Player, {Auto}) ->
    case golden_body:upgrade_stage(Player, Auto) of
        {ok, Code, NewPlayer} ->
            {ok, Bin} = pt_162:write(16202, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, golden_body, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_162:write(16202, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%%%切换外观
handle(16203, Player, {Figure}) ->
    {Ret, NewPlayer} = golden_body:change_figure(Player, Figure),
    {ok, Bin} = pt_162:write(16203, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, golden_body, NewPlayer};

%%激活技能
handle(16204, Player, {Cell}) ->
    {Ret, NewPlayer} = golden_body_skill:activate_skill(Player, Cell),
    {ok, Bin} = pt_162:write(16204, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%升级技能
handle(16205, Player, {Cell}) ->
    {Ret, NewPlayer} = golden_body_skill:upgrade_skill(Player, Cell),
    {ok, Bin} = pt_162:write(16205, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%更新技能列表
handle(16206, Player, {}) ->
    GoldenBody = lib_dict:get(?PROC_STATUS_GOLDEN_BODY),
    Data = golden_body_skill:get_golden_body_skill_list(GoldenBody#st_golden_body.skill_list),
    {ok, Bin} = pt_162:write(16206, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%装备物品
handle(16207, Player, {GoodsKey}) ->
    {Ret, NewPlayer} = golden_body:equip_goods(Player, GoodsKey),
    {ok, Bin} = pt_162:write(16207, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%% 使用神兵成长丹
handle(16208, Player, {}) ->
    case golden_body:use_golden_body_dan(Player) of
        {false, Ret} ->
            {ok, Bin} = pt_162:write(16208, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_162:write(16208, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%领取外观
handle(16209, Player, {}) ->
    NewPlayer = golden_body_init:activate(Player),
    {ok, Bin} = pt_162:write(16209, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};



handle(16210, Player, {}) ->
    Data = golden_body_spirit:spirit_info(),
    {ok, Bin} = pt_162:write(16210, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(16211, Player, {}) ->
    {Ret, NewPlayer} = golden_body_spirit:spirit_upgrade(Player),
    {ok, Bin} = pt_162:write(16211, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attrs, NewPlayer};
        true -> ok
    end;


handle(_cmd, _player, _data) ->
    ok.
