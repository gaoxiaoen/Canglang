%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 一月 2015 下午10:04
%%%-------------------------------------------------------------------
-module(server_send).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
%% API
-export([send_to_sid/2,
    send_to_sid/3,
    do_broadcast/2,
    send_one/2,
    send_to_all/1,
    send_to_pid/2,
    send_to_key/2,
    send_node_pkey/2,
    send_node_pid/3,
    send_to_scene/2,
    send_to_scene/3,
    send_to_scene/5,
    send_to_scene/6,
    send_to_scene_group/4,
    send_to_team/2,
    send_to_lv/3,
    rpc_node_apply/4,
    send_to_guild/2,
    send_priority_to_sid/2
]).

-export([rand_test/1]).
%%发送信息到消息发送进程组
%%sid:发送进程组
%%Bin:二进制数据.
send_to_sid(none, _) -> skip;
send_to_sid(Sid, Bin) ->
    rand_to_process_by_sid(Sid) ! {send, Bin}.
send_to_sid(_Node, none, _Bin) -> skip;
send_to_sid(_Node, Sid, Bin) ->
    rand_to_process_by_sid(Sid) ! {send, Bin}.
%%    case Node == none orelse Node == node() of
%%        true ->
%%            send_to_sid(Sid, Bin);
%%        false ->
%%            rpc:cast(Node, ?MODULE, send_to_sid, [Sid, Bin])
%%    end.

%%优先发送 信息到消息发送进程组
%% sid:发送进程组 proto 协议号,bin二进制数据
send_priority_to_sid(Sid, Bin) ->
    rand_to_process_by_sid(Sid) ! {send_priority, Bin}.


%%发送信息到玩家进程发送数据
%% Pid 玩家进程
%% Bin 二进制数据
send_to_pid(Pid, Bin) ->
    Pid ! {send, Bin}.


%%发送到玩家进程
%%Bin：二进制数据.
send_to_key(PKey, Bin) ->
    case misc:get_player_process(PKey) of
        undefined ->
            skip;
        Pid ->
                catch Pid ! {send, Bin}
    end.

%%跨节点发送消息到进程
send_node_pid(_Node, Pid, Msg) ->
    Pid ! Msg.


%%跨节点发送消息到进程
send_node_pkey(PKey, Msg) ->
    case misc:get_player_process(PKey) of
        undefined ->
            skip;
        Pid ->
                catch Pid ! Msg
    end.

%%    case Node =:= none orelse Node == node() of
%%        true ->
%%            Pid ! Msg;
%%        false ->
%%            spawn(fun()->rpc:cast(Node, erlang, send, [Pid, Msg])end)
%%    end.


%%发送信息给指定socket玩家.
%%Socket:socket
%%Bin:二进制数据.
%% TODO 注意跨节点不能直接调用,
send_one(Socket, Bin) ->
    gen_tcp:send(Socket, Bin).

%%给全部玩家发信息
send_to_all(Bin) ->
    case config:is_center_node() of
        false ->
            do_send_to_all(Bin);
        true ->
            [center:apply(Node, server_send, send_to_all, [Bin]) || Node <- center:get_nodes()]
    end.
%%给当前节点的玩家发信息
do_send_to_all(Bin) ->
    Sids = ets:match(?ETS_ONLINE, #ets_online{sid = '$1', _ = '_'}),
    F = fun([Sid]) ->
        send_to_sid(Sid, Bin)
        end,
    [F(Sid) || Sid <- Sids].

%%发送到队伍
send_to_team(TeamKey, Bin) ->
    Pids = team_util:get_team_mb_pids(TeamKey),
    F = fun([Pid]) ->
        send_to_pid(Pid, Bin)
        end,
    [F(Pid) || Pid <- Pids].

%%发送到指定等级段
send_to_lv(MinLv, MaxLv, Bin) ->
    MS = ets:fun2ms(fun(Online) when Online#ets_online.lv >= MinLv andalso Online#ets_online.lv =< MaxLv ->
        Online#ets_online.sid end),
    Sids = ets:select(?ETS_ONLINE, MS),
    [send_to_sid(Sid, Bin) || Sid <- Sids].

do_broadcast(SidList, Bin) ->
    F = fun([S]) ->
        send_to_sid(S, Bin)
        end,
    [F(D) || D <- SidList].

%% 随机发送到发送进程组
rand_to_process_by_sid(SidTuple) ->
    {Sid} = SidTuple,
    Sid.
%%    element(random:uniform(?SERVER_SEND_MSG), Sid).

%%发送到场景
send_to_scene(Scene, Bin) ->
    scene_agent:send_to_scene(Scene, Bin).

send_to_scene(Scene, Copy, Bin) ->
    scene_agent:send_to_scene(Scene, Copy, Bin).

send_to_scene(Scene, Copy, X, Y, Bin) ->
    scene_agent:send_to_area_scene(Scene, Copy, X, Y, Bin).

%%ABin 区域发送 DBin 全场景发送
send_to_scene(Scene, Copy, X, Y, ABin, DBin) ->
    scene_agent:send_to_area_scene(Scene, Copy, X, Y, ABin, DBin).

%%发送到场景分组
send_to_scene_group(Scene, Copy, Group, Bin) ->
    scene_agent:send_to_scene_group(Scene, Copy, Group, Bin).

%%发送到仙盟成员
send_to_guild(GuildKey, Bin) ->
    [send_to_pid(Pid, Bin) || Pid <- guild_util:get_guild_member_pids_online(GuildKey)].


% 跨节点执行
rpc_node_apply(Node, M, F, A) ->
    case Node == none orelse Node == node() of
        true ->
            erlang:apply(M, F, A);
        false ->
            rpc:cast(Node, M, F, A)
    end.


rand_test(Type) ->
    Start = util:longunixtime(),
    SidList = lists:map(fun(Id) -> {Id} end, lists:seq(1, 1000000)),
    case Type of
        1 ->
            lists:map(fun(SidTuple) ->
                {Sid} = SidTuple,
                Sid
                      end, SidList);
        2 ->
            lists:map(fun(SidTuple) ->
                element(random:uniform(?SERVER_SEND_MSG), SidTuple)
                      end, SidList)
    end,
    End = util:longunixtime(),
    End - Start.


