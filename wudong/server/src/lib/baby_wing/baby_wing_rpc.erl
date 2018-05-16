%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 8月 2017 10:00
%%%-------------------------------------------------------------------
-module(baby_wing_rpc).
-include("common.hrl").
-include("server.hrl").
-include("baby_wing.hrl").
-include("goods.hrl").
-include("error_code.hrl").

%% API
-export([
    handle/3
]).

%%获取当前翅膀信息
handle(36201, Player, _) ->
    WingSt = lib_dict:get(?PROC_STATUS_BABY_WING),
    baby_wing_pack:send_wing_info(WingSt, Player),
    ok;

%%翅膀升级
handle(36202, Player, {AutoBuy}) ->
    case baby_wing_stage:upgrade_stage(Player, AutoBuy) of
        {ok, Code, NewPlayer} ->
            {ok, Bin} = pt_362:write(36202, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_362:write(36202, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%选择外观
handle(36204, Player, {ImageId}) ->
    case catch baby_wing:select_image(Player, ImageId) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_362:write(36204, {?ER_SUCCEED}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, Bin1} = pt_130:write(13001, player_pack:trans13001(NewPlayer)),
            server_send:send_to_sid(Player#player.sid, Bin1),
            {ok, baby_wing, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_362:write(36204, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%%翅膀升星
handle(36209, Player, {WingId}) ->
    case catch baby_wing:upgrade_star(Player, WingId) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_362:write(36209, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        {false, Code} ->
            {ok, Bin} = pt_362:write(36209, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%激活技能
handle(36220, Player, {Cell}) ->
    {Ret, NewPlayer} = baby_wing_skill:activate_skill(Player, Cell),
    {ok, Bin} = pt_362:write(36220, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%升级技能
handle(36221, Player, {Cell}) ->
    {Ret, NewPlayer} = baby_wing_skill:upgrade_skill(Player, Cell),
    {ok, Bin} = pt_362:write(36221, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%更新技能列表
handle(36222, Player, {}) ->
    WingSt = lib_dict:get(?PROC_STATUS_BABY_WING),
    Data = baby_wing_skill:get_wing_skill_list(WingSt#st_baby_wing.skill_list),
    {ok, Bin} = pt_362:write(36222, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(36223, Player, {GoodsKey}) ->
    {Ret, NewPlayer} = baby_wing:equip_goods(Player, GoodsKey),
    {ok, Bin} = pt_362:write(36223, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%% 使用仙羽成长丹
handle(36224, Player, {}) ->
    case baby_wing:use_wing_dan(Player) of
        {false, Ret} ->
            {ok, Bin} = pt_362:write(36224, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_362:write(36224, {?ER_SUCCEED}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%领取外观
handle(36225, Player, {}) ->
    NewPlayer = baby_wing_init:activate_wing(Player),
    {ok, Bin} = pt_362:write(36225, {?ER_SUCCEED}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(36226, Player, {}) ->
    Data = baby_wing_spirit:spirit_info(),
    {ok, Bin} = pt_362:write(36226, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(36227, Player, {}) ->
    {Ret, NewPlayer} = baby_wing_spirit:spirit_upgrade(Player),
    {ok, Bin} = pt_362:write(36227, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attrs, NewPlayer};
        true -> ok
    end;

handle(_Cmd, _Player, _Data) ->
    ok.
