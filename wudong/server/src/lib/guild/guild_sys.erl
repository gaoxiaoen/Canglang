%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%     系统仙盟处理
%%% @end
%%% Created : 25. 二月 2016 13:55
%%%-------------------------------------------------------------------
-module(guild_sys).
-author("hxming").

-include("guild.hrl").
-include("common.hrl").

-define(APPLY_TIMEOUT, 1200).

%% API
-compile(export_all).


guild_sys() ->
    Now = util:unixtime(),
    F = fun(Apply, L) ->
        if Apply#g_apply.from /= ?GUILD_TYPE_SYS -> L;
            Now - Apply#g_apply.timestamp < ?APPLY_TIMEOUT -> L;
            true ->
                case guild_ets:get_guild_member(Apply#g_apply.pkey) of
                    false ->
                        case lists:keyfind(Apply#g_apply.pkey, #g_apply.pkey, L) of
                            false ->
                                [Apply | L];
                            _ ->
                                L
                        end;
                    _ ->
                        guild_ets:del_guild_apply_by_pkey(Apply#g_apply.pkey),
                        guild_load:del_guild_apply_by_pkey(Apply#g_apply.pkey),
                        L
                end
        end
        end,
    ApplyList1 = lists:foldl(F, [], guild_ets:get_guild_apply_all()),
    GuildList = [Guild || Guild <- guild_ets:get_all_guild(), Guild#guild.type == ?GUILD_TYPE_SYS],
    join_sys(GuildList, ApplyList1, Now),
    ok.

join_sys(_, [], _Now) ->
    ok;
join_sys([], ApplyList, Now) ->
    join_sys([new_guild()], ApplyList, Now);
join_sys([Guild | T], ApplyList, Now) ->
    case data_guild:get(Guild#guild.lv) of
        [] ->
            ?ERR("udef gkey ~p,lv ~p~n", [Guild#guild.pkey, Guild#guild.lv]),
            join_sys(T, ApplyList, Now);
        Base ->
            if Base#base_guild.max_num > Guild#guild.num ->
                NewApplyList = join(Guild, ApplyList, Base#base_guild.max_num - Guild#guild.num, Now),
                join_sys(T, NewApplyList, Now);
                true ->
                    join_sys(T, ApplyList, Now)
            end
    end.

join(Guild, ApplyList, Num, Now) ->
    JoinList = lists:sublist(ApplyList, Num),
    join_loop(JoinList, Guild, Now),
    Len = length(ApplyList),
    if Len > Num ->
        lists:sublist(ApplyList, Num + 1, Len);
        true ->
            []
    end.

join_loop([], Guild, _Now) ->
    guild_ets:set_guild(Guild),
    ok;
join_loop([Apply | T], Guild, Now) ->
    Msg = io_lib:format(t_guild:log_msg(2), [Apply#g_apply.nickname]),
    Log = guild_log:add_log(Guild#guild.log, 2, Now, Msg),
    NewGuild = Guild#guild{num = Guild#guild.num + 1, log = Log},

    guild_create:make_apply_new_guild_member(Apply, Guild, ?GUILD_POSITION_NORMAL, Now),
    guild_ets:del_guild_apply_by_pkey(Apply#g_apply.pkey),
    guild_load:del_guild_apply_by_pkey(Apply#g_apply.pkey),
    join_loop(T, NewGuild, Now).


new_guild() ->
    _Id = sys_id(),
    %guild(Id).
    ok.


new_guild(_Id) ->
    %guild(Id).
    ok.

guild(Id) ->
    Pkey = misc:unique_key(),
    Pname = player_util:rand_name(),
    Pcareer = player_util:rand_career(),
    GName = case get_name() of
                false ->
                    io_lib:format("~s~p", [?T("新手仙盟"), Id]);
                N2 -> N2
            end,
    Guild = #guild{
        gkey = misc:unique_key(),
        name = GName,
        lv = 1,
        num = 0,
        pkey = Pkey,
        pname = Pname,
        pcareer = Pcareer,
        notice = t_guild:notice(),
        type = 1,
        sys_id = Id,
        condition = ?GUILD_DEFAULT_CONDITION,
        create_time = util:unixtime()
    },
    guild_ets:set_guild(Guild),
    guild_manor:new_guild_manor(Guild#guild.gkey),
    util:sleep(10),
    Guild.

sys_id() ->
    case [Guild#guild.sys_id || Guild <- guild_ets:get_all_guild(), Guild#guild.sys_id > 0] of
        [] -> 1;
        Ids ->
            lists:max(Ids) + 1
    end.

get_name() ->
    guild_name(data_guild_name:ids()).

guild_name([]) ->
    false;
guild_name([_Order | T]) ->
    [Id1, Id2] = util:get_random_list(data_guild_name:ids(), 2),
    Name = io_lib:format("~s~s", [hd(data_guild_name:get(Id1)), lists:last(data_guild_name:get(Id2))]),
    case guild_ets:get_guild_by_name(Name) of
        [] -> Name;
        _ ->
            guild_name(T)
    end.


cmd_name() ->
    [Id1, Id2] = util:get_random_list(data_guild_cmd_name:ids(), 2),
    io_lib:format("~s~s", [hd(data_guild_cmd_name:get(Id1)), lists:last(data_guild_cmd_name:get(Id2))]).