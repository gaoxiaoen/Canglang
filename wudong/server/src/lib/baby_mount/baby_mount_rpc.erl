%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 九月 2017 13:49
%%%-------------------------------------------------------------------
-module(baby_mount_rpc).

-author("hxming").


-include("common.hrl").
-include("server.hrl").
-include("baby_mount.hrl").

%% API
-export([handle/3]).

handle(17101, Player, {}) ->
    Data = baby_mount:get_baby_mount_info(),
    {ok, Bin} = pt_171:write(17101, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%升阶
handle(17102, Player, {Auto}) ->
    case baby_mount:upgrade_stage(Player, Auto) of
        {ok, Code, NewPlayer} ->
            {ok, Bin} = pt_171:write(17102, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, baby_mount, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_171:write(17102, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%切换外观
handle(17103, Player, {Figure}) ->
    {Ret, NewPlayer} = baby_mount:change_figure(Player, Figure),
    {ok, Bin} = pt_171:write(17103, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, baby_mount, NewPlayer};

%%激活技能
handle(17104, Player, {Cell}) ->
    {Ret, NewPlayer} = baby_mount_skill:activate_skill(Player, Cell),
    {ok, Bin} = pt_171:write(17104, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%升级技能
handle(17105, Player, {Cell}) ->
    {Ret, NewPlayer} = baby_mount_skill:upgrade_skill(Player, Cell),
    {ok, Bin} = pt_171:write(17105, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%更新技能列表
handle(17106, Player, {}) ->
    BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
    Data = baby_mount_skill:get_baby_mount_skill_list(BabyMount#st_baby_mount.skill_list),
    {ok, Bin} = pt_171:write(17106, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%装备物品
handle(17107, Player, {GoodsKey}) ->
    {Ret, NewPlayer} = baby_mount:equip_goods(Player, GoodsKey),
    {ok, Bin} = pt_171:write(17107, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%% 使用神兵成长丹
handle(17108, Player, {}) ->
    case baby_mount:use_baby_mount_dan(Player) of
        {false, Ret} ->
            {ok, Bin} = pt_171:write(17108, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_171:write(17108, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%领取外观
handle(17109, Player, {}) ->
    NewPlayer = baby_mount_init:activate(Player),
    {ok, Bin} = pt_171:write(17109, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};



handle(17110, Player, {}) ->
    Data = baby_mount_spirit:spirit_info(),
    {ok, Bin} = pt_171:write(17110, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(17111, Player, {}) ->
    {Ret, NewPlayer} = baby_mount_spirit:spirit_upgrade(Player),
    {ok, Bin} = pt_171:write(17111, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true -> ok
    end;


handle(_cmd, _player, _data) ->
    ok.
