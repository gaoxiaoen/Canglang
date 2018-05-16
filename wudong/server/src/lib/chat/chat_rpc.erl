%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 一月 2015 下午3:56
%%%-------------------------------------------------------------------
-module(chat_rpc).
-author("fancy").

%% API
-export([handle/3]).
-include("server.hrl").
-include("common.hrl").
-include("chat.hrl").
-include("scene.hrl").

%%聊天
handle(11000, Player, {Type, Content, Voice, Pkey, Name}) ->
    case chat:chat(Player, Type, Content, Voice, Pkey, Name,1) of
        {false, Reason} ->
            {ok, Bin} = pt_110:write(11099, {Reason}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        ok -> ok;
        {ok, NewPlayer} -> {ok, NewPlayer};
        {ok, R, NewPlayer} -> {ok, R, NewPlayer};
        _Err -> ?ERR("bad return in chat_rpc ~p ~n", [_Err]), ok
    end;

%%获取聊天记录
handle(11001, #player{sid = Sid} = Player, {Type}) ->
    chat_proc:get_chat_history(Player#player.key, Sid, Type, Player#player.guild#st_guild.guild_key),
    ok;

%%获取私聊记录
handle(11002, #player{sid = Sid} = Player, _) ->
    chat_proc:get_fir_chat_history(Player#player.key, Sid),
    ok;

%%私聊
handle(11003, Player, {Content, Voice, Pkey, Name}) ->
    case chat:chat(Player, ?CHAT_TYPE_FRIEND, Content, Voice, Pkey, Name,1) of
        {false, Reason} ->
            {ok, Bin} = pt_110:write(11099, {Reason}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        ok -> ok;
        {ok, NewPlayer} -> {ok, NewPlayer};
        {ok, R, NewPlayer} -> {ok, R, NewPlayer};
        _Err -> ?ERR("bad return in chat_rpc ~p ~n", [_Err]), ok
    end;

%%获取场景队伍信息
handle(11004, #player{sid = Sid, scene = Scene, copy = Copy} = Player, _) ->
    scene_agent:get_player_scene_group(node(), Sid, Scene, Copy, Player#player.group),
    ok;


%%发送场景表情
handle(11010, Player, {FaceStr}) ->
    {ok, NewPlayer} = chat:send_scene_face(Player, FaceStr),
    {ok, scene_face, NewPlayer};

%% 真心话获取题目
handle(11013, Player, _) ->
    chat:guild_sincere_word(Player),
    ok;

%% 丢骰子
handle(11012, Player, {Type}) ->
    chat:shaizi(Player, Type),
    ok;

handle(_cmd, _Player, _Data) ->
    ok.

