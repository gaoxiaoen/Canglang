%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2018 15:27
%%%-------------------------------------------------------------------
-module(guild_fight_rpc).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("guild.hrl").
-include("guild_fight.hrl").
-include("goods.hrl").

%% API
-export([handle/3]).

%% 仙盟对战信息
handle(44701, Player, _) ->
    guild_fight:get_guild_fight_info(Player),
    ok;

%% 获取个人挑战日志
handle(44702, Player, _) ->
    {MyBaseMemdal, LogList} = guild_fight:get_my_log(Player),
    {ok, Bin} = pt_447:write(44702, {MyBaseMemdal, LogList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 获取仙盟列表
handle(44703, Player, {GuildLv}) ->
    {GuildMaxLv, GuildList} = guild_fight:get_guild_list(Player, GuildLv),
    {ok, Bin} = pt_447:write(44703, {GuildMaxLv, GuildList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 挑战仙盟
handle(44704, Player, {GuildKey}) ->
    {{_Y, _M, _D}, {H, _Min, _S}} = erlang:localtime(),
    OpenDay = config:get_open_days(),
    if
        OpenDay == 1 ->
            {ok, Bin} = pt_447:write(44704, {23}),
            server_send:send_to_sid(Player#player.sid, Bin);
        Player#player.guild#st_guild.guild_key == GuildKey ->
            {ok, Bin} = pt_447:write(44704, {7}),
            server_send:send_to_sid(Player#player.sid, Bin);
        H >= 12 ->
            guild_fight:challenge_guild(Player, GuildKey);
        Player#player.guild#st_guild.guild_position /= ?GUILD_POSITION_CHAIRMAN andalso Player#player.guild#st_guild.guild_position /= ?GUILD_POSITION_VICE_CHAIRMAN  ->
            {ok, Bin} = pt_447:write(44704, {16}),
            server_send:send_to_sid(Player#player.sid, Bin);
        true ->
            guild_fight:challenge_guild(Player, GuildKey)
    end,
    ok;

%% 挑战玩家
handle(44705, Player, {Pkey}) ->
    guild_fight:challenge_player(Player, Pkey),
    activity:get_notice(Player, [186], true),
    ok;

%%获取目标
handle(44706, Player, _) ->
    case scene:is_dungeon_scene(Player#player.scene) of
        false -> ok;
        true ->
            Player#player.copy ! {dungeon_target, Player#player.sid},
            ok
    end;

%% 领取奖励
handle(44707, Player, {GuildNum}) ->
    {Code, NewPlayer} = guild_fight:recv_guild_fight(Player, GuildNum),
    {ok, Bin} = pt_447:write(44707, {Code}),
    server_send:send_to_sid(NewPlayer#player.sid, Bin),
    activity:get_notice(NewPlayer, [186], true),
    {ok, NewPlayer};

%% 获取兑换商城信息
handle(44709, Player, _) ->
    ShopData = guild_fight:get_shop_info(Player),
    HasNum = goods_util:get_goods_count(?GOODS_ID_MEDAL),
    {ok, Bin} = pt_447:write(44709, {HasNum, ShopData}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 兑换
handle(44710, Player, {Id, BuyTime}) ->
    {Code, NewPlayer} = guild_fight:exchange(Id, Player, BuyTime),
    {ok, Bin} = pt_447:write(44710, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取旗帜信息
handle(44711, Player, _) ->
    {Lv, Exp, AddExp} = guild_fight:get_lv_exp(Player),
    {ok, Bin} = pt_447:write(44711, {Lv, Exp, AddExp}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 旗帜升级
handle(44712, Player, _) ->
    {Code, NewPlayer} = guild_fight:flag_up_lv(Player),
    {ok, Bin} = pt_447:write(44712, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取领地信息
handle(44713, Player, _) ->
    {GuildLv, GuildFlagLv, GuildName, GuildNum, GuildMaxNum, Nickname, Career, Sex, Avatar} = guild_fight:get_lidi_info(Player),
    {ok, Bin} = pt_447:write(44713, {GuildLv, GuildFlagLv, GuildName, GuildNum, GuildMaxNum, Nickname, Career, Sex, Avatar}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};

handle(Cmd, _Player, _Args) ->
    ?ERR("Cmd:~p Args:~p", [Cmd, _Args]),
    ok.

