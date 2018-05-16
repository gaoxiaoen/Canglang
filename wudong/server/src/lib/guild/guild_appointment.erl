%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 仙盟任命
%%% @end
%%% Created : 23. 一月 2017 下午5:43
%%%-------------------------------------------------------------------
-module(guild_appointment).
-author("fengzhenlin").
-include("guild.hrl").
-include("common.hrl").
-include("server.hrl").

%% API
-compile(export_all).

%%仙盟职位任命
guild_position_appointment(Player, PKey, Position) ->
    GuildKey = Player#player.guild#st_guild.guild_key,
    MyPosition = Player#player.guild#st_guild.guild_position,
    if
        GuildKey == 0 -> 3;
        Position < ?GUILD_POSITION_CHAIRMAN orelse Position > ?GUILD_POSITION_NORMAL -> 141;
        MyPosition >= Position andalso MyPosition =/= ?GUILD_POSITION_CHAIRMAN -> 142;
        Player#player.key == PKey -> 145;
        true ->
            case guild_ets:get_guild(GuildKey) of
                false -> 4;
                Guild ->
                    case guild_ets:get_guild_member(PKey) of
                        false -> 5;
                        Member ->
                            if Member#g_member.gkey /= GuildKey -> 143;
                                MyPosition >= Member#g_member.position -> 142;
                                true ->
                                    R = appointment(Position, Guild, Member),
                                    cross_war:update_cross_war_guild(Player),
                                    if
                                        Position == 1 ->
                                            Sql = io_lib:format("insert into log_guild_change_main set gkey=~p,pkey=~p,old_pkey=~p,time=~p",
                                                [Guild#guild.gkey, PKey, Player#player.key, util:unixtime()]),
                                            log_proc:log(Sql);
                                        true -> skip
                                    end,
                                    R
                            end
                    end
            end
    end.

%%仙盟任命
%%会长
appointment(?GUILD_POSITION_CHAIRMAN, Guild, Member) ->
    OldChairman = guild_ets:get_guild_member(Guild#guild.pkey),
    case OldChairman of
        false -> skip;
        _ ->
            OldChairman1 = OldChairman#g_member{position = ?GUILD_POSITION_NORMAL},
            guild_ets:set_guild_member(OldChairman1),
            if
                OldChairman1#g_member.is_online == 1 ->
                    OldChairman1#g_member.pid ! {update_guild, [Guild#guild.gkey, Guild#guild.name, ?GUILD_POSITION_NORMAL]};
                true -> skip
            end
    end,
    Msg = io_lib:format(t_guild:log_msg(9), [Member#g_member.name]),
    Log = guild_log:add_log(Guild#guild.log, 9, util:unixtime(), Msg),
    NewGuild = Guild#guild{log = Log, pkey = Member#g_member.pkey, pname = Member#g_member.name, pcareer = Member#g_member.career},
    guild_ets:set_guild(NewGuild),
    NewMember = Member#g_member{position = ?GUILD_POSITION_CHAIRMAN},
    guild_ets:set_guild_member(NewMember),
    if Member#g_member.is_online == 1 ->
        Member#g_member.pid ! {update_guild, [Guild#guild.gkey, Guild#guild.name, ?GUILD_POSITION_CHAIRMAN]};
        true -> skip
    end,
    Title = ?T("仙盟管理处"),
    Content = io_lib:format(?T("您的职位由~s调整为~s!"), [t_guild:get_guild_pos_name(Member#g_member.position), t_guild:get_guild_pos_name(NewMember#g_member.position)]),
    mail:sys_send_mail([Member#g_member.pkey], Title, Content),
    1;

%%仙盟任命
%%副会长
appointment(?GUILD_POSITION_VICE_CHAIRMAN, Guild, Member) ->
    NowCount = guild_ets:get_guild_position_count(Member#g_member.gkey, ?GUILD_POSITION_VICE_CHAIRMAN),
    if NowCount >= ?GUILD_POSITION_VICE_CHAIRMAN_COUNt -> 144;
        true ->
            Msg = io_lib:format(t_guild:log_msg(7), [Member#g_member.name]),
            Log = guild_log:add_log(Guild#guild.log, 7, util:unixtime(), Msg),
            NewGuild = Guild#guild{log = Log},
            guild_ets:set_guild(NewGuild),
            NewMember = Member#g_member{position = ?GUILD_POSITION_VICE_CHAIRMAN},
            guild_ets:set_guild_member(NewMember),
            if Member#g_member.is_online == 1 ->
                Member#g_member.pid ! {update_guild, [Guild#guild.gkey, Guild#guild.name, ?GUILD_POSITION_VICE_CHAIRMAN]};
                true -> skip
            end,
            Title = ?T("仙盟管理处"),
            Content = io_lib:format(?T("您的职位由~s调整为~s!"), [t_guild:get_guild_pos_name(Member#g_member.position), t_guild:get_guild_pos_name(NewMember#g_member.position)]),
            mail:sys_send_mail([Member#g_member.pkey], Title, Content),
            1
    end;
%%长老
appointment(?GUILD_POSITION_ELDER, Guild, Member) ->
    NowCount = guild_ets:get_guild_position_count(Member#g_member.gkey, ?GUILD_POSITION_ELDER),
    if NowCount >= ?GUILD_POSITION_ELDER_COUNT -> 144;
        true ->
            Msg = io_lib:format(t_guild:log_msg(8), [Member#g_member.name]),
            Log = guild_log:add_log(Guild#guild.log, 8, util:unixtime(), Msg),
            NewGuild = Guild#guild{log = Log},
            guild_ets:set_guild(NewGuild),
            NewMember = Member#g_member{position = ?GUILD_POSITION_ELDER},
            guild_ets:set_guild_member(NewMember),
            if Member#g_member.is_online == 1 ->
                Member#g_member.pid ! {update_guild, [Guild#guild.gkey, Guild#guild.name, ?GUILD_POSITION_ELDER]};
                true -> skip
            end,
            1
    end;
%%管事
appointment(?GUILD_POSITION_GS, Guild, Member) ->
    NowCount = guild_ets:get_guild_position_count(Member#g_member.gkey, ?GUILD_POSITION_GS),
    if NowCount >= ?GUILD_POSITION_GS_COUNT -> 144;
        true ->
            Msg = io_lib:format(t_guild:log_msg(8), [Member#g_member.name]),
            Log = guild_log:add_log(Guild#guild.log, 8, util:unixtime(), Msg),
            NewGuild = Guild#guild{log = Log},
            guild_ets:set_guild(NewGuild),
            NewMember = Member#g_member{position = ?GUILD_POSITION_GS},
            guild_ets:set_guild_member(NewMember),
            if Member#g_member.is_online == 1 ->
                Member#g_member.pid ! {update_guild, [Guild#guild.gkey, Guild#guild.name, ?GUILD_POSITION_GS]};
                true -> skip
            end,
            1
    end;
%%成员
appointment(?GUILD_POSITION_NORMAL, Guild, Member) ->
    NewMember = Member#g_member{position = ?GUILD_POSITION_NORMAL},
    guild_ets:set_guild_member(NewMember),
    if Member#g_member.is_online == 1 ->
        Member#g_member.pid ! {update_guild, [Guild#guild.gkey, Guild#guild.name, ?GUILD_POSITION_NORMAL]};
        true -> skip
    end,
    1;
appointment(_, _, _) ->
    2.

%%转让会长
guild_position_transfer(Player, PKey) ->
    if
        Player#player.guild#st_guild.guild_key == 0 -> {3, Player};
        Player#player.guild#st_guild.guild_position /= 1 -> {131, Player};
        true ->
            case guild_ets:get_guild(Player#player.guild#st_guild.guild_key) of
                false -> {4, Player};
                Guild ->
                    case guild_ets:get_guild_member(Player#player.key) of
                        false -> {5, Player};
                        M1 ->
                            case guild_ets:get_guild_member(PKey) of
                                false -> {132, Player};
                                M2 ->
                                    if M2#g_member.gkey /= Guild#guild.gkey -> {133, Player};
                                        true ->
                                            Msg = io_lib:format(t_guild:log_msg(6), [Player#player.nickname, M2#g_member.name]),
                                            Log = guild_log:add_log(Guild#guild.log, 6, util:unixtime(), Msg),
                                            NewGuild = Guild#guild{pkey = PKey, pname = M2#g_member.name, pcareer = M2#g_member.career, log = Log},
                                            guild_ets:set_guild(NewGuild),
                                            NewM1 = M1#g_member{position = ?GUILD_POSITION_NORMAL},
                                            guild_ets:set_guild_member(NewM1),
                                            NewPlayer = Player#player{guild = Player#player.guild#st_guild{guild_position = ?GUILD_POSITION_NORMAL}},
                                            NewM2 = M2#g_member{position = ?GUILD_POSITION_CHAIRMAN},
                                            guild_ets:set_guild_member(NewM2),
                                            if M2#g_member.is_online == 1 ->
                                                M2#g_member.pid ! {update_guild, [Guild#guild.gkey, Guild#guild.name, ?GUILD_POSITION_CHAIRMAN]};
                                                true -> skip
                                            end,
                                            guild_load:log_guild_mb(Guild#guild.gkey, Guild#guild.name, PKey, M2#g_member.name, 4, util:unixtime(), M2#g_member.position, NewM2#g_member.position),
                                            guild_load:log_guild_mb(Guild#guild.gkey, Guild#guild.name, Player#player.key, Player#player.nickname, 4, util:unixtime(), M1#g_member.position, NewM1#g_member.position),
                                            cross_war:update_cross_war_guild(NewPlayer),
                                            Sql = io_lib:format("insert into log_guild_change_main set gkey=~p,pkey=~p,old_pkey=~p,time=~p",
                                                [Guild#guild.gkey, PKey, Player#player.key, util:unixtime()]),
                                            ?DEBUG("Sql:~p", [Sql]),
                                            db_fix:execute(Sql),
                                            {1, NewPlayer}
                                    end
                            end
                    end
            end
    end.