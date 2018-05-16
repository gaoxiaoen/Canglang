%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 三月 2017 10:34
%%%-------------------------------------------------------------------
-module(pet_rpc).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("task.hrl").

%% API
-export([handle/3]).

%%宠物列表
handle(50101, Player, {}) ->
    Data = pet:pet_list(),
    {ok, Bin} = pt_501:write(50101, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%单个宠物信息
handle(50102, Player, {Key}) ->
    Data = pet:pet_info(Key),
    {ok, Bin} = pt_501:write(50102, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%宠物出战
handle(50103, Player, {Key}) ->
    {Ret, NewPlayer} = pet:fight_pet(Player, Key),
    {ok, Bin} = pt_501:write(50103, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    activity:get_notice(Player, [110], true),
    if Ret == 1 ->
        {ok, pet, NewPlayer};
        true -> ok
    end;

%%技能升级
handle(50104, Player, {Key, Cell}) ->
    case pet:upgrade_skill(Player, Key, Cell) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_501:write(50104, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            activity:get_notice(Player, [110], true),
            {ok, pet, NewPlayer};
        {Err, _} ->
            {ok, Bin} = pt_501:write(50104, {Err}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%宠物进阶
handle(50105, Player, {Type, Auto}) ->
    {Ret, NewPlayer} = pet_stage:upgrade_stage(Player, Type, Auto),
    {ok, Bin} = pt_501:write(50105, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    activity:get_notice(Player, [110], true),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true -> ok
    end;

%宠物升星
handle(50106, Player, {PetKey, GoodsList, KeyList}) ->
    NewGoodsList = goods:merge_goods([list_to_tuple(T) || T <- GoodsList]),
    case pet_star:star_up(Player, PetKey, NewGoodsList, KeyList) of
        {false, Res} ->
            {ok, Bin} = pt_501:write(50106, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            task_event:event(?TASK_ACT_PET_STAR, {1}),
            {ok, Bin} = pt_501:write(50106, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            handle(50102, Player, {PetKey}),
            activity:get_notice(Player, [110], true),
            {ok, attr, NewPlayer}
    end;


%%获取宠物助战信息
handle(50107, Player, {}) ->
    Data = pet_assist:assist_info(),
    {ok, Bin} = pt_501:write(50107, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%宠物助战
handle(50108, Player, {Cell, PetKey}) ->
    case pet_assist:pet_assist_put_on(Player, Cell, PetKey) of
        {false, Res} ->
            {ok, Bin} = pt_501:write(50108, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_501:write(50108, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, attr, NewPlayer}
    end;

%%宠物助战卸下
handle(50109, Player, {Key}) ->
    case pet_assist:pet_assist_put_off(Player, Key) of
        {false, Res} ->
            {ok, Bin} = pt_501:write(50109, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_501:write(50109, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, attr, NewPlayer}
    end;

%%助战互换位置
handle(50110, Player, {Cell1, Cell2}) ->
    case pet_assist:pet_change_cell(Player, Cell1, Cell2) of
        {false, Res} ->
            {ok, Bin} = pt_501:write(50110, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_501:write(50110, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, attr, NewPlayer}
    end;

%%获取宠物图鉴信息
handle(50111, Player, _) ->
    Data = pet_pic:pic_list(),
    {ok, Bin} = pt_501:write(50111, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%激活图鉴
handle(50112, Player, {FigureId}) ->
    case pet_pic:upgrade_pic(Player, FigureId) of
        {1, NewPlayer} ->
            {ok, Bin} = pt_501:write(50112, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            activity:get_notice(Player, [110], true),
            fashion_suit:active_icon_push(NewPlayer),
            {ok, attr, NewPlayer};
        {Res, _} ->
            {ok, Bin} = pt_501:write(50112, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%幻化
handle(50113, Player, {FigureId}) ->
    case pet_pic:use_pic(Player, FigureId) of
        {1, NewPlayer} ->
            {ok, Bin} = pt_501:write(50113, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, pet, NewPlayer};
        {Res, _} ->
            {ok, Bin} = pt_501:write(50113, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

handle(50115, Player, {}) ->
    Data = pet_stage:stage_info(),
    {ok, Bin} = pt_501:write(50115, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%宠物蛋预览
handle(50116, Player, {GoodsKey}) ->
    Data = pet_egg:egg_info(GoodsKey),
    {ok, Bin} = pt_501:write(50116, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%开宠物蛋
handle(50117, Player, {GoodsKey}) ->
    {Ret, NewPlayer} = pet_egg:open_egg(Player, GoodsKey),
    {ok, Bin} = pt_501:write(50117, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%丢弃
handle(50118, Player, {GoodsKey}) ->
    Ret = pet_egg:drop_egg(GoodsKey),
    {ok, Bin} = pt_501:write(50118, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%领取新手宠物蛋宠物
handle(50119, Player, {GoodsKey, PetId}) ->
    {Data, NewPlayer} = pet_egg:open_egg(Player, GoodsKey, PetId),
    {ok, Bin} = pt_501:write(50119, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(50120, Player, {GoodsKey}) ->
    {Ret, PetList, NewPlayer} = pet_egg:open_pet_all(Player, GoodsKey),
    {ok, Bin} = pt_501:write(50120, {Ret, PetList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_Cmd, _, _) ->
    ?DEBUG("cmd undef ~p~n", [_Cmd]),
    ok.

