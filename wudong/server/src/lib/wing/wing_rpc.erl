%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 一月 2015 14:04
%%%-------------------------------------------------------------------
-module(wing_rpc).
-include("common.hrl").
-include("server.hrl").
-include("wing.hrl").
-include("goods.hrl").
-include("error_code.hrl").

%% API
-export([
    handle/3
]).

%%获取当前翅膀信息
handle(36001, Player, _) ->
    WingSt = lib_dict:get(?PROC_STATUS_WING),
    wing_pack:send_wing_info(WingSt, Player),
    ok;

%%翅膀升级
handle(36002, Player, {AutoBuy}) ->
    case wing_stage:upgrade_stage(Player, AutoBuy) of
        {ok, Code, NewPlayer} ->
            {ok, Bin} = pt_360:write(36002, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_360:write(36002, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%%图鉴列表
handle(36003, Player, {}) ->
    WingSt = lib_dict:get(?PROC_STATUS_WING),
    WingStarList = [[WingId, Star] || {WingId, Star} <- WingSt#st_wing.star_list],
    {ok, Bin} = pt_360:write(36003, WingStarList),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%选择外观
handle(36004, Player, {ImageId}) ->
    case catch wing:select_image(Player, ImageId) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_360:write(36004, {?ER_SUCCEED}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, Bin1} = pt_130:write(13001, player_pack:trans13001(NewPlayer)),
            server_send:send_to_sid(Player#player.sid, Bin1),
            {ok, wing, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_360:write(36004, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%%翅膀升星
handle(36009, Player, {WingId}) ->
    case catch wing:upgrade_star(Player, WingId) of
        {ok, NewPlayer} ->
            fashion_suit:active_icon_push(NewPlayer),
            {ok, Bin} = pt_360:write(36009, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        {false, Code} ->
            {ok, Bin} = pt_360:write(36009, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%激活技能
handle(36020, Player, {Cell}) ->
    {Ret, NewPlayer} = wing_skill:activate_skill(Player, Cell),
    {ok, Bin} = pt_360:write(36020, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%升级技能
handle(36021, Player, {Cell}) ->
    {Ret, NewPlayer} = wing_skill:upgrade_skill(Player, Cell),
    {ok, Bin} = pt_360:write(36021, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%更新技能列表
handle(36022, Player, {}) ->
    WingSt = lib_dict:get(?PROC_STATUS_WING),
    Data = wing_skill:get_wing_skill_list(WingSt#st_wing.skill_list),
    {ok, Bin} = pt_360:write(36022, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(36023, Player, {GoodsKey}) ->
    {Ret, NewPlayer} = wing:equip_goods(Player, GoodsKey),
    {ok, Bin} = pt_360:write(36023, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%% 使用仙羽成长丹
handle(36024, Player, {}) ->
    case wing:use_wing_dan(Player) of
        {false, Ret} ->
            {ok, Bin} = pt_360:write(36024, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_360:write(36024, {?ER_SUCCEED}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;


%%领取外观
handle(36025, Player, {}) ->
    NewPlayer = wing_init:activate_wing(Player),
    {ok, Bin} = pt_360:write(36025, {?ER_SUCCEED}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};



handle(36026, Player, {}) ->
    Data = wing_spirit:spirit_info(),
    {ok, Bin} = pt_360:write(36026, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(36027, Player, {}) ->
    {Ret, NewPlayer} = wing_spirit:spirit_upgrade(Player),
    {ok, Bin} = pt_360:write(36027, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attrs, NewPlayer};
        true -> ok
    end;

%% 限时翅膀状态
handle(36028, Player, {}) ->
    ?DEBUG("36028 read ~n"),
    time_limit_wing:get_state(Player),
    ok;

%% 限时翅膀续费
handle(36029, Player, {}) ->
    {Ret, NewPlayer} = time_limit_wing:renewal(Player),
    {ok, Bin} = pt_360:write(36029, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, attrs, NewPlayer};

%% 限时翅膀开启
handle(36030, Player, {}) ->
    NewPlayer = time_limit_wing:open_time_limit_wing(Player),
    {ok, Bin} = pt_360:write(36030, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, attrs, NewPlayer};


%%激活等级加成
handle(36031, Player, {WingId}) ->
    {Ret, NewPlayer} = wing:activation_stage_lv(Player, WingId),
    {ok, Bin} = pt_360:write(36031, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_Cmd, _Player, _Data) ->
    ok.
