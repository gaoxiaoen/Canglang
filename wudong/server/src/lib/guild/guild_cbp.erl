%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 帮派战力处理
%%% @end
%%% Created : 24. 一月 2017 上午10:08
%%%-------------------------------------------------------------------
-module(guild_cbp).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("guild.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

%% API
-compile(export_all).


timer_update() ->
    update_all_guild_cbp(),
    ok.


%%计算仙盟总战力
mb_cbp(Gkey) ->
    MS=ets:fun2ms(fun(M) when M#g_member.gkey == Gkey -> M#g_member.cbp end),
    All = ets:select(?ETS_GUILD_MEMBER,MS),
    lists:sum(All).

%%更新帮派战力
update_all_guild_cbp() ->
    F = fun(Guild) ->
        NewCbp = mb_cbp(Guild#guild.gkey),
        case NewCbp =/= Guild#guild.cbp of
            true ->
                NewGuild = Guild#guild{cbp = NewCbp},
                guild_ets:set_guild(NewGuild);
            false ->
                skip
        end
    end,
    lists:foreach(F, guild_ets:get_all_guild()),
    ok.

%%更新指定帮派战力
update_guild_cbp(Gkey) ->
    Guild = guild_ets:get_guild(Gkey),
    NewCbp = mb_cbp(Guild#guild.gkey),
    NewGuild = Guild#guild{cbp = NewCbp},
    guild_ets:set_guild(NewGuild).

%%更新玩家战力
update_mb_cbp(Player) ->
    if Player#player.guild#st_guild.guild_key /= 0 ->
        case guild_ets:get_guild_member(Player#player.key) of
            false -> skip;
            Mb ->
                NewMb = Mb#g_member{cbp = Player#player.cbp, lv = Player#player.lv, h_cbp = Player#player.highest_cbp},
                case NewMb =/= Mb of
                    true -> guild_ets:set_guild_member(NewMb);
                    false -> skip
                end
        end;
        true -> skip
    end.
