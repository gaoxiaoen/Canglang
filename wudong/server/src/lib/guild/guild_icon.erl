%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02.
%%%-------------------------------------------------------------------
-module(guild_icon).
-author("Administrator").
-include("server.hrl").
-include("common.hrl").
-include("guild.hrl").

%% API
-export([
    set_guid_icon/2,
    get_guid_icon_list/1
]).

set_guid_icon(Player, Id) ->
    GuildKey = Player#player.guild#st_guild.guild_key,
    if GuildKey == 0 -> 0;
        true ->
            case guild_ets:get_guild(GuildKey) of
                false ->
                    0;
                Guild ->
                    case data_guild_icon:get(Id) of
                        [] -> 0;
                        Base ->
                            if
                                Guild#guild.lv < Base#base_guild_icon.limit ->
                                    90;
                                true ->
                                    guild_ets:set_guild(Guild#guild{icon = Base#base_guild_icon.icon}),
                                    guild_load:replace_guild(Guild#guild{icon = Base#base_guild_icon.icon}),
                                    1
                            end
                    end
            end
    end.

get_guid_icon_list(_Player) ->
    Ids = data_guild_icon:get_all(),
    F = fun(Id) ->
        case data_guild_icon:get(Id) of
            [] -> [];
            Base ->
                [[
                    Base#base_guild_icon.id,
                    Base#base_guild_icon.icon,
                    Base#base_guild_icon.limit
                ]]
        end
    end,
    lists:flatmap(F, Ids).

