%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% %%机器人动作
%%% @end
%%% Created : 23. 十二月 2015 下午5:16
%%%-------------------------------------------------------------------
-module(robot_act).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("chat.hrl").
%% API
-export([act/3,robotname/1]).
%% 说话
act(Player,1,Val) ->
    chat:chat(Player, ?CHAT_TYPE_PUBLIC, Val, ""),
    Player;
%% 升级
act(Player,2,_Val) ->
    ToLv = min(99,Player#player.lv + 1),
    {ok,Player2} = chat_gm:gm(Player,["lv",util:term_to_string(ToLv)]),
    Player2;
%% 打怪
act(Player,3,_Val) ->
    Attr = Player#player.attribute,
    TargetList = mon_agent:get_scene_mon_for_battle(Player#player.scene,Player#player.copy, Player#player.x, Player#player.y,Attr#attribute.att_area,[], Player#player.group,?SIGN_PLAYER),
    case TargetList of
        [] ->
            skip;
        [Mon|_] ->
            SkillID = case util:list_rand(Player#player.skill) of
                          null -> 0;
                          {Sid,_Lv,_state} ->
                              Sid
                      end,
            {ok,Bin} = pt_130:write(13099,{3,Mon#mon.key,util:term_to_string(SkillID),util:term_to_string(Mon#mon.x),util:term_to_string(Mon#mon.y)}),
            server_send:send_to_sid(Player#player.sid,Bin)
    end,
    Player;
%% 完成任务
act(Player,4,_Val) ->
    task:cmd_finish_task(Player),
    Player;

%% 切换场景
act(Player,5,Val) ->
    case chat_gm:gm(Player,["goto",Val]) of
         ok ->
             Player;
        {ok,Player2} ->
            Player2
    end;


act(Player,_Type,_Val) ->
    Player.

robotname(Career) ->
    List1 = [?T("亚当斯"),?T("奥尔德里奇"),?T("阿利克"),?T("安德鲁"),?T("阿诺德")],
    List2 = [?T("艾咪"),?T("阿西娜"),?T("贝拉"),?T("艾琳娜"),?T("卡米拉")],
    if
        Career == ?CAREER1 orelse Career == ?CAREER3 ->
            util:list_rand(List1);
        true ->
            util:list_rand(List2)
    end.



