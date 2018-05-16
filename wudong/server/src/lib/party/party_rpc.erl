%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 七月 2017 15:33
%%%-------------------------------------------------------------------
-module(party_rpc).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("daily.hrl").
-include("party.hrl").
%% API
-export([handle/3]).

handle(28701, Player, {}) ->
    ?CAST(party_proc:get_server_pid(), {check_party_state, Player#player.sid}),
    ok;

handle(28702, Player, {}) ->
    DailyTimes = daily:get_count(?DAILY_PARTY_TIMES),
    ?CAST(party_proc:get_server_pid(), {party_list, Player#player.key, Player#player.sid, DailyTimes}),
    ok;

%%获取可预约时间列表
handle(28703, Player, {Type, DayType}) ->
    ?CAST(party_proc:get_server_pid(), {date_list, Type, DayType, Player#player.key, Player#player.sid}),
    ok;


%%预约
handle(28704, Player, {Type, DayType, Id, InviteGuild, InviteFriend}) ->
    GuildKeyList = ?IF_ELSE(InviteGuild == 1, guild_util:get_guild_member_key_list(Player#player.guild#st_guild.guild_key), []),
    FriendKeyList = ?IF_ELSE(InviteFriend == 1, relation:get_friend_list(), []),
    InviteKeyList = util:list_filter_repeat(GuildKeyList ++ FriendKeyList ++ [Player#player.key]),
    {Ret, NewPlayer} =
        if Player#player.lv < 60 -> {7, Player};
            true ->
                case ?CALL(party_proc:get_server_pid(), {party_app, Type, DayType, Id, Player}) of
                    [] -> 0;
                    {ok, PriceType, Price, Time, Base} ->
                        Player1 =
                            if PriceType == bgold ->
                                money:add_gold(Player, -Price, 287, 0, 0);
                                true ->
                                    money:add_no_bind_gold(Player, -Price, 287, 0, 0)
                            end,
                        TimeString =
                        case version:get_lan_config() of
                            vietnam ->
                                util:unixtime_to_time_string4(Time);
                            _ ->
                                util:unixtime_to_time_string3(Time)
                        end,
                        party_load:log_party(Player#player.key, Player#player.nickname, Player#player.lv, Base#base_party.desc, TimeString,Time,PriceType,Price),
                        party:invite_msg(Player, InviteKeyList, Base, TimeString),
                        {1, Player1};
                    Err ->
                        {Err, Player}
                end
        end,
    {ok, Bin} = pt_287:write(28704, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%查看当场宴席信息
handle(28705, Player, {Akey}) ->
    ?CAST(party_proc:get_server_pid(), {party_into, Player#player.sid, Player#player.lv, Akey}),
    ok;

handle(_Cmd, _Player, {}) ->
    ok.
