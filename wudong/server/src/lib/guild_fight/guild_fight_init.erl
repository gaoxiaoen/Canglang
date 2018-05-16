%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2018 15:27
%%%-------------------------------------------------------------------
-module(guild_fight_init).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("guild.hrl").
-include("guild_fight.hrl").

%% API
-export([
    init_ets/0,
    init_data/1,
    init/1
]).

init_ets() ->
    ets:new(?ETS_GUILD_FIGHT, [{keypos, #guild_fight.gkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_GUILD_FIGHT_SHADOW, [{keypos, #guild_fight_shadow.gkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_GUILD_FIGHT_LOG, [{keypos, #ets_guild_fight_log.count} | ?ETS_OPTIONS]).

init_data(_State) ->
    case guild_fight_load:load_guild_shadow() of
        [] ->
            AllGuild = guild_ets:get_all_guild(),
            Sn = config:get_server_num(),
            F = fun(#guild{gkey = Gkey, cbp = Cbp, lv = Lv, name = Name, num = Num}) ->
                AllMember = guild_ets:get_guild_member_list(Gkey),
                F99 = fun(#g_member{pkey = Pkey}) -> Pkey end,
                AllKey = lists:map(F99, AllMember),
                NewR =
                    #guild_fight_shadow{
                        gkey = Gkey
                        , g_sn = Sn
                        , g_name = Name
                        , g_lv = Lv
                        , g_cbp = Cbp
                        , g_num = Num
                        , member_list = AllKey
                    },
                ets:insert(?ETS_GUILD_FIGHT_SHADOW, NewR)
            end,
            lists:map(F, AllGuild);
        AllGuildFightShadow ->
            F = fun(NewR) -> ets:insert(?ETS_GUILD_FIGHT_SHADOW, NewR) end,
            lists:map(F, AllGuildFightShadow)
    end,
    guild_fight_load:load(),
    F99 = fun(#guild_fight_shadow{gkey = Gkey, member_list = MemberKist}) ->
        lists:map(fun(Pkey) -> {Pkey, Gkey} end, MemberKist)
    end,
    ShadowPlayerPkeyList = lists:flatmap(F99, ets:tab2list(?ETS_GUILD_FIGHT_SHADOW)),
    #sys_guild_fight{shadow_player_key_list = ShadowPlayerPkeyList}.

init(#player{key = Pkey} = Player) ->
    StGuildFight = guild_fight_load:load_p(Pkey),
    lib_dict:put(?PROC_STATUS_GUILD_FIGHT, StGuildFight),
    guild_fight:update(),
    Player.



