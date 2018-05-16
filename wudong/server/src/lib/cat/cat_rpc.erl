%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 六月 2017 17:06
%%%-------------------------------------------------------------------
-module(cat_rpc).
-author("hxming").


-include("common.hrl").
-include("server.hrl").
-include("cat.hrl").

%% API
-export([handle/3]).

handle(16101, Player, {}) ->
    Data = cat:get_cat_info(),
    {ok, Bin} = pt_161:write(16101, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%升阶
handle(16102, Player, {Auto}) ->
    case cat:upgrade_stage(Player, Auto) of
        {ok, Code, NewPlayer} ->
            {ok, Bin} = pt_161:write(16102, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, cat, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_161:write(16102, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%切换外观
handle(16103, Player, {Figure}) ->
    {Ret, NewPlayer} = cat:change_figure(Player, Figure),
    {ok, Bin} = pt_161:write(16103, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, cat, NewPlayer};

%%激活技能
handle(16104, Player, {Cell}) ->
    {Ret, NewPlayer} = cat_skill:activate_skill(Player, Cell),
    {ok, Bin} = pt_161:write(16104, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%升级技能
handle(16105, Player, {Cell}) ->
    {Ret, NewPlayer} = cat_skill:upgrade_skill(Player, Cell),
    {ok, Bin} = pt_161:write(16105, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%更新技能列表
handle(16106, Player, {}) ->
    Cat = lib_dict:get(?PROC_STATUS_CAT),
    Data = cat_skill:get_cat_skill_list(Cat#st_cat.skill_list),
    {ok, Bin} = pt_161:write(16106, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%装备物品
handle(16107, Player, {GoodsKey}) ->
    {Ret, NewPlayer} = cat:equip_goods(Player, GoodsKey),
    {ok, Bin} = pt_161:write(16107, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%% 使用神兵成长丹
handle(16108, Player, {}) ->
    case cat:use_cat_dan(Player) of
        {false, Ret} ->
            {ok, Bin} = pt_161:write(16108, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_161:write(16108, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%领取外观
handle(16109, Player, {}) ->
    NewPlayer = cat_init:activate(Player),
    {ok, Bin} = pt_161:write(16109, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};



handle(16110, Player, {}) ->
    Data = cat_spirit:spirit_info(),
    {ok, Bin} = pt_161:write(16110, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(16111, Player, {}) ->
    {Ret, NewPlayer} = cat_spirit:spirit_upgrade(Player),
    {ok, Bin} = pt_161:write(16111, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true -> ok
    end;


handle(_cmd, _player, _data) ->
    ok.
