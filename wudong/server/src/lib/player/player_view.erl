%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 五月 2016 14:39
%%%-------------------------------------------------------------------
-module(player_view).
-author("hxming").
-include("common.hrl").
-include("server.hrl").

%% API
-compile(export_all).

%%查看自己数据
view_attribute(Player, Sn, Pkey) when Player#player.key =:= Pkey ->
    Data = player_pack:trans13013(Player, Sn),
    {ok, Bin} = pt_130:write(13013, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%查看本服玩家数据
view_attribute(Player, Sn, Pkey) ->
    case player_util:get_player(Pkey) of
        [] ->
            case shadow_proc:get_shadow(Pkey) of
                Shadow when is_record(Shadow, player) ->
                    Data = player_pack:trans13013(Shadow, Sn),
                    {ok, Bin} = pt_130:write(13013, Data),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                Shadow ->
                    ?PRINT("13013 error Player ~p ~n", [Shadow]),
                    ok
            end;
        Role ->
            Data = player_pack:trans13013(Role, Sn),
            {ok, Bin} = pt_130:write(13013, Data),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end.


%%跨服查看玩家数据
cross_view_attribute(MyNode, Sid, Sn, Pkey) ->
    case center:get_node_by_sn(Sn) of
        false ->
            skip;
        Node ->
            case shadow_proc:get_shadow(Pkey, Node) of
                Shadow when is_record(Shadow, player) ->
                    Data = player_pack:trans13013(Shadow, Sn),
                    {ok, Bin} = pt_130:write(13013, Data),
                    center:apply(MyNode, server_send, send_to_sid, [Sid, Bin]),
                    ok;
                _Shadow ->
%%            ?PRINT("13013 error Player ~p ~n", [Shadow]),
                    ok
            end
    end.


%%查看自己子女数据
view_baby_attribute(Player, Sn, Pkey) when Player#player.key =:= Pkey ->
    Data = player_pack:trans13041(Player, Sn),
    {ok, Bin} = pt_130:write(13041, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%查看本服玩家子女数据
view_baby_attribute(Player, Sn, Pkey) ->
    case player_util:get_player(Pkey) of
        [] ->
            case shadow_proc:get_shadow(Pkey) of
                Shadow when is_record(Shadow, player) ->
                    Data = player_pack:trans13041(Shadow, Sn),
                    {ok, Bin} = pt_130:write(13041, Data),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                Shadow ->
                    ?PRINT("13041 error Player ~p ~n", [Shadow]),
                    ok
            end;
        Role ->
            Data = player_pack:trans13041(Role, Sn),
            {ok, Bin} = pt_130:write(13041, Data),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end.

%%跨服查看玩家子女数据
cross_view_baby_attribute(MyNode, Sid, Sn, Pkey) ->
    case center:get_node_by_sn(Sn) of
        false ->
            skip;
        Node ->
            case shadow_proc:get_shadow(Pkey, Node) of
                Shadow when is_record(Shadow, player) ->
                    Data = player_pack:trans13041(Shadow, Sn),
                    {ok, Bin} = pt_130:write(13041, Data),
                    center:apply(MyNode, server_send, send_to_sid, [Sid, Bin]),
                    ok;
                _Shadow ->
%%            ?PRINT("13041 error Player ~p ~n", [Shadow]),
                    ok
            end
    end.



%%查看自己数据
view_model(Player, Sn,Pkey) when Player#player.key =:= Pkey ->
    Data = player_pack:trans13014(Player,Sn),
    {ok, Bin} = pt_130:write(13014, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%查看本服玩家形象
view_model(Player,Sn, Pkey) ->
    case player_util:get_player(Pkey) of
        [] ->
            case shadow_proc:get_shadow(Pkey) of
                Shadow when is_record(Shadow, player) ->
                    Data = player_pack:trans13014(Shadow,Sn),
                    {ok, Bin} = pt_130:write(13014, Data),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                Shadow ->
                    ?PRINT("13014 error Player ~p ~n", [Shadow]),
                    ok
            end;
        Role ->
            Data = player_pack:trans13014(Role,Sn),
            {ok, Bin} = pt_130:write(13014, Data),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end.

%%查看跨服玩家形象
cross_view_model(MyNode, Sid, Sn, Pkey) ->
    case center:get_node_by_sn(Sn) of
        false ->
            skip;
        Node ->
            case shadow_proc:get_shadow(Pkey, Node) of
                Shadow when is_record(Shadow, player) ->
                    Data = player_pack:trans13014(Shadow,Sn),
                    {ok, Bin} = pt_130:write(13014, Data),
                    center:apply(MyNode, server_send, send_to_sid, [Sid, Bin]),
                    ok;
                _Shadow ->
%%            ?PRINT("13013 error Player ~p ~n", [Shadow]),
                    ok
            end
    end.
