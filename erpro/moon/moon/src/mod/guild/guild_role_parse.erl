%%----------------------------------------------------
%% @doc 个人帮会数据转换
%% @author lishen@jieyou.cn
%%----------------------------------------------------
-module(guild_role_parse).
-export([
        do/1
    ]).
-include("common.hrl").
%%
-include("guild.hrl").

do({role_guild, Pid, Gid, SrvId, Name, Pos, Auth, Dev, Don, Sal, ClaimExp, ClaimTea, Skill, Quit, Join, Read}) ->
    do({role_guild, Pid, Gid, SrvId, Name, Pos, Auth, Dev, Don, Sal, ClaimExp, ClaimTea, Skill, Quit, Join, Read, 0, []});
do({role_guild, Pid, Gid, SrvId, Name, Pos, Auth, Dev, Don, Sal, ClaimExp, ClaimTea, Skill, Quit, Join, Read, WelTimes, WelList}) ->
    do({role_guild, Pid, Gid, SrvId, Name, Pos, Auth, Dev, Don, Sal, ClaimExp, ClaimTea, Skill, Quit, Join, Read, WelTimes, WelList, 0});
do(RoleGuild = #role_guild{}) ->
    {ok, RoleGuild};
do(_) ->
    {false, ?L(<<"role_guild数据转换失败">>)}.
