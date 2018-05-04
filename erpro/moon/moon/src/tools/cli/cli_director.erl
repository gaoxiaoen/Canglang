%%----------------------------------------------------
%% cli_director
%% 
%% @author Qingxuan
%%----------------------------------------------------
-module(cli_director).
-compile(export_all).
-include("cli.hrl").
-include("tutorial.hrl").
-include("map.hrl").

steps() ->
    [
        {10111, finish_login}
        ,{10790, finish_first_fight}
        ,{10111, enter_town}
        ,{10207, accept_task_10000_succ}
        ,{10207, accept_task_10010_succ}
        ,{10207, accept_task_10020_succ}
        ,{10207, accept_task_10030_succ}
    ] ++ lists:concat(lists:duplicate(100, [
        {10111, enter_dungeon_10011}
        ,{10790, dungeon_10011_1th_npc_combat_over}
        ,{10790, dungeon_10011_2nd_npc_combat_over}
        ,{10111, leave_dungeon_10011}
    ])).

%% ------------------
%% -> false | true | {true, Cmd, Data} 

finish_login(Client) ->
    case put(login_enter_map, false) of
        undefined -> %% 登录进入地图
            %% 设满体力
            cli:send(Client, 9910, {<<"设体力 250">>}),
            %% 行走
            Paths = [{220,530}, {1191,530}, {1221,500}], %%
            cli_handle:move(Paths, fun(Cli)->
                NpcId = 1,
                cli:send(Cli, 10705, {NpcId}), %% 发起战斗
                put(first_fight, true)
            end),
            true;
        _ -> %% 一般进入地图
            false
    end.

finish_first_fight(_Client) ->
    case put(first_fight, false) of
        true ->
            put(first_enter_town, true),
            {true, 10101, {_MapId = ?capital_map_id}};  %% 进入主城
        _ ->
            false
    end.

enter_town(_Client) ->
    case put(first_enter_town, false) of
        true ->
            Paths = [{902, 463}, {869, 467}, {902, 463}], %%
            cli_handle:move(Paths, fun(Cli)->
                cli:send(Cli, 10207, {10000, 3}),  %% 接受第一个任务
                ok
            end),
            true;
        _ ->
            false
    end.

accept_task_10000_succ(_Client) ->
    Paths = [{1680, 425}, {1238, 447}, {1574, 430}, {1680, 425}],
    cli_handle:move(Paths, fun(Cli)->
        cli:send(Cli, 10208, {10000, 5}),  %% 完成第一个任务
        cli:send(Cli, 10207, {10010, 5}),  %% 接受第二个任务
        ok
    end),
    true.

accept_task_10010_succ(_Client) ->
    Paths = [{1139, 445}, {1344, 437}, {1139,445}],
    cli_handle:move(Paths, fun(Cli)->
        cli:send(Cli, 10208, {10010, 3}),  %% 完成任务
        cli:send(Cli, 10207, {10020, 3}),  %% 接受下一个任务
        ok
    end),
    true.

accept_task_10020_succ(_Client) ->
    Paths = [{2400, 423}, {1305, 457}, {1641, 447}, {1977, 436}, {2313, 426}, {2400, 423}],
    cli_handle:move(Paths, fun(Cli)->
        cli:send(Cli, 10208, {10020, 4}),  %% 完成任务
        cli:send(Cli, 10207, {10030, 4}),  %% 接受下一个任务
        ok
    end),
    true.

accept_task_10030_succ(_Client) ->
    Paths0 = [{902, 463}, {869, 467}, {902, 463}, {1139, 445}, {1344, 437}, {1139,445}, {2400, 423}, {1305, 457}, {1641, 447}, {1977, 436}, {2313, 426}, {2400, 423}, {2880, 444}, {2736, 438}, {3000, 450}, {3000, 450}],
    {_, Paths} = lists:foldl(fun(_, {P, Acc})->
        R = lists:reverse(P),
        {R, Acc++R}
    end, {Paths0, []}, lists:seq(1, 1000)),
    cli_handle:move(Paths, fun(_Cli)->
        % cli:send(Cli, 13500, {10011}),  %% 进入副本
        ok
    end),
    true.

% accept_task_10030_succ(_Client) ->
%     Paths = [{2880, 444}, {2736, 438}, {3000, 450}, {3000, 450}],
%     cli_handle:move(Paths, fun(Cli)->
%         cli:send(Cli, 13500, {10011}),  %% 进入副本
%         ok
%     end),
%     true.

enter_dungeon_10011(_Client = #client{npcs = Npcs}) ->
    % 10600 <<0,0,0,52,0,1,0,0,5,78,0,0,40,42,0,0,14,22>> 召唤剧情Npc
    Paths = [{420, 433}, {750, 433}, {780, 420}, {780, 416}, {780, 420}],
    cli_handle:move(Paths, fun(Cli)->
        #cli_map_npc{id = NpcId} = lists:nth(1, Npcs),
        cli:send(Cli, 10705, {NpcId}), %% 发起战斗 
        ok
    end),
    true.

dungeon_10011_1th_npc_combat_over(_Client = #client{npcs = Npcs}) ->
    Paths = [{1350, 416}, {1116, 418}, {1380, 420}, {1380, 416}, {1380, 420}],
    cli_handle:move(Paths, fun(Cli)->
        #cli_map_npc{id = NpcId} = lists:nth(2, Npcs),
        cli:send(Cli, 10705, {NpcId}), %% 发起战斗 
        ok
    end),
    true.

dungeon_10011_2nd_npc_combat_over(_Client) ->
    Paths = [{1380, 416},{2060, 450},{1716, 433},{2052, 450},{2060, 450}],
    cli_handle:move(Paths, fun(Cli)->
        cli:send(Cli, 13515, {}),  %% 请求翻牌
        % 退出副本到1400 
        ok
    end),
    true.

leave_dungeon_10011(_Client) ->
    ?I("to town!"),
    Paths = [{2672, 447},{2451, 447},{2664, 448},{2153, 464},{2328, 459},{1902, 492},{1993, 485},{2168, 486},{2168, 486},{2362, 487},{2636, 483},{2504, 484},{2911, 482},{2840, 482},{2911, 482},{2992, 482},{2992, 482}],
    cli_handle:move(Paths, fun(Cli) ->
        cli:send(Cli, 13500, {10011}),  %% 重新进入副本
        ok
    end),
    true.





