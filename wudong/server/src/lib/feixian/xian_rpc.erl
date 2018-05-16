%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 十月 2017 15:47
%%%-------------------------------------------------------------------
-module(xian_rpc).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("xian.hrl").

%% API
-export([handle/3]).

%% 穿戴
handle(44201, Player, {GoodsKey, Type}) ->
    {Code, NewPlayer} = xian:put_on(Player, GoodsKey, Type),
    {ok, Bin} = pt_442:write(44201, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 分解仙装列表
handle(44202, Player, {GoodsKeyList}) ->
    {Code, NewPlayer} = xian:resolved_xian(Player, GoodsKeyList),
    {ok, Bin} = pt_442:write(44202, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 进阶仙装
handle(44203, Player, {GoodsKey, IsAuto, XianYuCost}) ->
    {Code, NewPlayer} = xian:upgrade(Player, GoodsKey, IsAuto, XianYuCost),
    {ok, Bin} = pt_442:write(44203, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取寻宝面板信息
handle(44204, Player, _) ->
    Data = xian_map:get_act_info(Player),
    {ok, Bin} = pt_442:write(44204, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 寻宝
handle(44205, Player, {Type, Num}) ->
    {Code, List1, List2, NewPlayer} = xian_map:go_map(Player, Type, Num),
    {ok, Bin} = pt_442:write(44205, {Code, List1, List2}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 一键升级
handle(44206, Player, {GoodsKey, Type}) ->
    {Code, NewPlayer} =
        case Type of
            _ ->
                xian:one_key_upgrade(Player, GoodsKey)
        end,
    {ok, Bin} = pt_442:write(44206, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取当前阶数任务数据
handle(44207, Player, _) ->
    {Stage, Data} = xian_upgrade:get_task_info(Player),
    {ok, Bin} = pt_442:write(44207, {Stage, Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 提交任务数据
handle(44208, Player, {TaskId}) ->
    Code = xian_upgrade:commit_task(Player, TaskId),
    {ok, Bin} = pt_442:write(44208, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 仙阶升阶
handle(44209, Player, _) ->
    {Code, NewPlayer} = xian_upgrade:upgrage(Player),
    {ok, Bin} = pt_442:write(44209, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%获取兑换信息
handle(44211, Player, _) ->
    ExchangeList = xian_exchange:get_info(Player),
    {ok, Bin} = pt_442:write(44211, {ExchangeList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%兑换
handle(44212, Player, {Id}) ->
    {Code, NewPlayer} = xian_exchange:exchange(Player, Id),
    {ok, Bin} = pt_442:write(44212, {Code}),
    server_send:send_to_sid(NewPlayer#player.sid, Bin),
    {ok, NewPlayer};

%% 获取觉醒信息
handle(44213, Player, _) ->
    Data = xian_skill:get_info(Player),
    {ok, Bin} = pt_442:write(44213, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};

%% 觉醒升级
handle(44214, Player, {SubType}) ->
    {Code, NewPlayer} = xian_skill:upgrade(SubType, Player),
    {ok, Bin} = pt_442:write(44214, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取技能列表
handle(44215, Player, _) ->
    SkillIdList = xian_skill:get_skill_list(),
    {ok, Bin} = pt_442:write(44215, {SkillIdList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 仙练属性兑换
%% @44216_10000000002882_10000000002884_1_2
handle(44216, Player, {GoodsKey1, GoodsKey2, AttrPos1, AttrPos2}) ->
    {Code, NewPlayer} = xian:swap_attr(Player, GoodsKey1, GoodsKey2, AttrPos1, AttrPos2),
    {ok, Bin} = pt_442:write(44216, {Code}),
    server_send:send_to_sid(NewPlayer#player.sid, Bin),
    {ok, NewPlayer};

handle(_Cmd, _Player, _Args) ->
    ?ERR("Cmd:~p _Args:~p", [_Cmd, _Args]),
    ok.
