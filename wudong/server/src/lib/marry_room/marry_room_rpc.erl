%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 七月 2017 20:24
%%%-------------------------------------------------------------------
-module(marry_room_rpc).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("marry_room.hrl").

%% API
-export([handle/3]).

%% 获取大厅玩家自己信息
handle(43601, Player, _) ->
    {RpVal, QmVal, Page, IsFirstPhoto} = marry_room:get_my_info(),
    {ok, Bin} = pt_436:write(43601, {RpVal, QmVal, Page, IsFirstPhoto}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 获取大厅排行信息
handle(43602, Player, {Page}) ->
    ?CAST(marry_room_proc:get_server_pid(), {get_marry_room_list, Player#player.pid, Page}),
    ok;

%% 获取我的关注玩家信息
handle(43603, Player, _) ->
    ProList = marry_room:get_my_look(Player),
    {ok, Bin} = pt_436:write(43603, {ProList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 获取我的粉丝信息
handle(43604, Player, _) ->
    ProList = marry_room:get_my_face(Player),
    {ok, Bin} = pt_436:write(43604, {ProList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 点击关注玩家
handle(43605, Player, {Pkey}) ->
    Code = marry_room:looup_player(Player, Pkey),
    {ok, Bin} = pt_436:write(43605, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 发布爱情宣言
handle(43606, Player, {LoveDescType, LoveDesc0}) ->
    LoveDesc = util:filter_utf8(LoveDesc0),
    case chat:check_content(LoveDesc) of
        {fail, RRRR} ->
            ?DEBUG("RRRR:~p", [RRRR]),
            {ok, Bin} = pt_436:write(43606, {9}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok; %% 有铭感字
        true ->
            {Code, NewPlayer} = marry_room:love_desc(Player, LoveDescType, LoveDesc),
            {ok, Bin} = pt_436:write(43606, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 取消关注玩家
handle(43607, Player, {Pkey}) ->
    Code = marry_room:cancel_looup_player(Player, Pkey),
    {ok, Bin} = pt_436:write(43607, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 求送花 求关注 发布
handle(43608, Player, {Type, Desc}) ->
    case chat:check_content(Desc) of
        {fail, _} ->
            Code = 9; %% 有铭感字
        true ->
            Code = marry_room:notice(Player, Type, Desc)
    end,
    {ok, Bin} = pt_436:write(43608, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 发起表白
handle(43609, Player, {Pkey}) ->
    QmVal = relation:get_friend_qmd(Pkey),
    if
        QmVal < ?MARRY_LOVE_QMDVAL ->
            {ok, Bin} = pt_436:write(43609, {7}),
            server_send:send_to_sid(Player#player.sid, Bin);
        true ->
            case ets:lookup(?ETS_ONLINE, Pkey) of
                [] ->
                    {ok, Bin} = pt_436:write(43609, {6}),
                    server_send:send_to_sid(Player#player.sid, Bin);
                [#ets_online{sid = Sid}] ->
                    {ok, Bin} = pt_436:write(43610, {Player#player.key, Player#player.nickname, Player#player.career, Player#player.sex, Player#player.vip_lv, Player#player.avatar}),
                    server_send:send_to_sid(Sid, Bin),

                    {ok, Bin2} = pt_436:write(43609, {1}),
                    server_send:send_to_sid(Player#player.sid, Bin2)
            end
    end,
    ok;

%% 回应表白
handle(43611, Player, {Pkey, Code}) ->
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] ->
            {ok, Bin} = pt_436:write(43611, {6}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        [#ets_online{sid = Sid, pid = Pid}] ->
            {ok, Bin} = pt_436:write(43612, {Code}),
            server_send:send_to_sid(Sid, Bin),
            ?IF_ELSE(Code == 1, player:apply_state(async, Pid,{marry_room, create_trem, [Player#player.key]}), skip),
            {ok, Bin2} = pt_436:write(43611, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin2),
            {ok, Player}
    end;

handle(_Cmd, _Player, _) ->
    ok.