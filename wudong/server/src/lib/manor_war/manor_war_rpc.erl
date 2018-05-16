%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 十二月 2016 10:09
%%%-------------------------------------------------------------------
-module(manor_war_rpc).
-author("hxming").
-include("common.hrl").
-include("server.hrl").
-include("guild.hrl").
%% API
-export([handle/3]).

%%获取领地占领信息
handle(40202, Player, {}) ->
    ?CAST(manor_war_proc:get_server_pid(), {manor_state, Player#player.sid, Player#player.guild#st_guild.guild_key}),
    ok;

%%报名
%%handle(40203, Player, {}) ->
%%    if Player#player.guild#st_guild.guild_key == 0 ->
%%        {ok, Bin} = pt_402:write(40203, {2}),
%%        server_send:send_to_sid(Player#player.sid, Bin);
%%        Player#player.guild#st_guild.guild_position >= ?GUILD_POSITION_NORMAL ->
%%            {ok, Bin} = pt_402:write(40203, {3}),
%%            server_send:send_to_sid(Player#player.sid, Bin);
%%        true ->
%%            ?CAST(manor_war_proc:get_server_pid(), {manor_apply, Player#player.sid, Player#player.guild#st_guild.guild_key, Player#player.guild#st_guild.guild_name})
%%    end,
%%    ok;


%%积分排行榜
handle(40204, Player, {}) ->
    Data = manor_war:check_top_ten(Player#player.key),
    {ok, Bin} = pt_402:write(40204, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%获取我的目标
handle(40205, Player, {}) ->
    Data = manor_war:target(Player),
    {ok, Bin} = pt_402:write(40205, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%领取目标奖励
handle(40207, Player, {TargetId, Stage}) ->
    {Ret, NewPlayer} = manor_war:target_reward(Player, TargetId, Stage),
    {ok, Bin} = pt_402:write(40207, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%查询晚宴信息
handle(40210, Player, {}) ->
    Data = manor_war_party:party_info(Player),
    {ok, Bin} = pt_402:write(40210, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%开启晚宴
handle(40211, Player, {SceneId}) ->
    Ret = manor_war_party:open_party(Player, SceneId),
    {ok, Bin} = pt_402:write(40211, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%贡献
handle(40213, Player, {Gold}) ->
    {Ret, NewPlayer} = manor_war_party:party_contrib(Player, Gold),
    {ok, Bin} = pt_402:write(40213, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%敬酒
handle(40214, Player, {Pkey}) ->
    {Ret, NewPlayer} = manor_war_party:toast(Player, Pkey),
    {ok, Bin} = pt_402:write(40214, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%摇塞子
handle(40215, Player, {}) ->
    Ret = manor_war_party:ratio_points(Player),
    {ok, Bin} = pt_402:write(40215, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(_cmd, _Player, _Data) ->
    ok.
