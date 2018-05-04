%% ********************************
%% 队伍外部监听接口
%% @author wpf (wprehard@qq.com)
%% ********************************

-module(team_listener).
-export([
        break_up/1
        ,leave/1
    ]).

-include("team.hrl").

%% @spec break_up(Team) -> any()
%% Team = #team{}
%% @doc 队伍解散，处理相关事件
%% <div> Team数据中可能只包含一个队员，因为目前队伍解散的情况比较多
%% </div>
break_up(Team) ->
    %% team_dungeon:cancel_register(Team), %% 取消副本大厅的注册
    world_compete_mgr:on_team_break_up(Team),  %% 取消仙道会报名
    ok.

%% @spec leave(TeamMember) -> any()
%% Team = #team_member{}
%% @doc 队员离开队伍，处理相关事件
%% TODO:
leave(#team_member{mode = ?MODE_OFFLINE}) ->
    ok;
leave(_TeamMember) ->
    ok.
