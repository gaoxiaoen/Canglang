%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 十二月 2016 13:54
%%%-------------------------------------------------------------------
-module(manor_war_init).
-author("hxming").

-include("manor_war.hrl").
-include("common.hrl").
-include("guild.hrl").
-include("scene.hrl").
-include("achieve.hrl").
%% API
-export([init/0, mb2list/1, list2mb/1, partymb2list/1, list2partymb/1]).

-export([clean_manor/0, clean_manor_war/0, get_manor_war/2, upgrade_manor_final/0, timer_update/0, logout/0]).


init() ->
    init_manor(),
    init_manor_war(),
    ok.

init_manor() ->
    Data = manor_war_load:load_manor(),
    F = fun([SceneId, Gkey, Time, Name]) ->
        Manor = #manor{scene_id = SceneId, gkey = Gkey, name = Name, time = Time},
        ets:insert(?ETS_MANOR, Manor)
        end,
    lists:foreach(F, Data),
    ok.

init_manor_war() ->
    Data = manor_war_load:load_manor_war(),
    F = fun([Gkey, Time, SceneList, MbList, PartyTime, PartyLv, PartyExp, PartyScene, PartyFull, PartyMbs, Name]) ->
        ManorWar = #manor_war{
            gkey = Gkey,
            time = Time,
            scene_list = util:bitstring_to_term(SceneList),
            mb_list = list2mb(MbList),
            party_time = PartyTime,
            party_lv = PartyLv,
            party_exp = PartyExp,
            party_scene = PartyScene,
            party_full = PartyFull,
            party_mbs = list2partymb(PartyMbs),
            name = Name
        },
        ets:insert(?ETS_MANOR_WAR, ManorWar)
        end,
    lists:foreach(F, Data),
    ok.



mb2list(MbList) ->
    F = fun(Mb) ->
        {Mb#manor_war_mb.pkey, Mb#manor_war_mb.nickname, Mb#manor_war_mb.score, Mb#manor_war_mb.target_list}
        end,
    util:term_to_bitstring(lists:map(F, MbList)).

list2mb(List) ->
    F = fun({Key, Nickname, Score, TargetList}) ->
        #manor_war_mb{
            pkey = Key,
            nickname = Nickname,
            score = Score,
            target_list = TargetList
        }
        end,
    lists:map(F, util:bitstring_to_term(List)).

partymb2list(MbList) ->
    F = fun(Mb) ->
        {Mb#manor_party_mb.pkey, Mb#manor_party_mb.nickname, Mb#manor_party_mb.gold, Mb#manor_party_mb.collect_times}
        end,
    util:term_to_bitstring(lists:map(F, MbList)).
list2partymb(List) ->
    F = fun({Key, Nickname, Gold, Times}) ->
        #manor_party_mb{
            pkey = Key,
            nickname = Nickname,
            gold = Gold,
            collect_times = Times
        }
        end,
    lists:map(F, util:bitstring_to_term(List)).

clean_manor_war() ->
    ets:delete_all_objects(?ETS_MANOR_WAR),
    manor_war_load:clean_manor_war(),
    ok.

clean_manor() ->
    ets:delete_all_objects(?ETS_MANOR),
    manor_war_load:clean_manor(),
    ok.

get_manor_war(Gkey, Gname) ->
    case ets:lookup(?ETS_MANOR_WAR, Gkey) of
        [] ->
            ManorWar = #manor_war{gkey = Gkey, name = Gname, time = util:unixtime(), is_change = 1},
            ets:insert(?ETS_MANOR_WAR, ManorWar),
            ManorWar;
        [ManorWar] -> ManorWar
    end.

%%更新状态
%%upgrade_manor_war(State) ->
%%    F = fun(ManorWar) ->
%%        NewManorWar = #manor_war{gkey = ManorWar#manor_war.gkey, name = ManorWar#manor_war.name, time = ManorWar#manor_war.time, state = State, is_change = 1},
%%        ets:insert(?ETS_MANOR_WAR, NewManorWar)
%%        end,
%%    lists:foreach(F, ets:tab2list(?ETS_MANOR_WAR)).

%%更新最终占领状态
upgrade_manor_final() ->
    Now = util:unixtime(),
    F = fun(ManorWar) ->
        Glv = guild_util:get_guild_lv(ManorWar#manor_war.gkey),
        Amount = data_manor_amount:get(Glv),
        Len = length(ManorWar#manor_war.scene_list),
        if Len > Amount ->
            SceneList =
                case lists:keytake(?SCENE_ID_MAIN, 1, lists:reverse(lists:keysort(2, ManorWar#manor_war.scene_list))) of
                    false ->
                        lists:sublist(ManorWar#manor_war.scene_list, Amount);
                    {value, {Sid, Time}, T} ->
                        lists:sublist([{Sid, Time} | T], Amount)

                end,
            release_manor(ManorWar#manor_war.scene_list, SceneList),
            NewManorWar = ManorWar#manor_war{scene_list = SceneList, state = 0, party_time = Now + ?ONE_HOUR_SECONDS, is_change = 1},
            ets:insert(?ETS_MANOR_WAR, NewManorWar);
            Len > 0 ->
                NewManorWar = ManorWar#manor_war{state = 0, party_time = Now + ?ONE_HOUR_SECONDS, is_change = 1},
                ets:insert(?ETS_MANOR_WAR, NewManorWar);
            true ->
                NewManorWar = ManorWar#manor_war{state = 0, is_change = 1},
                ets:insert(?ETS_MANOR_WAR, NewManorWar)
        end
        end,
    lists:foreach(F, ets:tab2list(?ETS_MANOR_WAR)),
    manor_msg(),
    ok.


release_manor(SceneList, LeaveList) ->
    F = fun({SceneId, _}) ->
        case lists:keymember(SceneId, 1, LeaveList) of
            true -> ok;
            false ->
                ets:delete(?ETS_MANOR, SceneId),
                manor_war_load:delete_manor(SceneId)
        end
        end,
    lists:foreach(F, SceneList),
    ok.

%%notice_sys:add_notice(manor_war_start, []),
manor_msg() ->
    ManorList = ets:tab2list(?ETS_MANOR),
    ManorList1 =
        case lists:keytake(?SCENE_ID_MAIN, #manor.scene_id, ManorList) of
            false -> ManorList;
            {value, Manor, T} ->
                spawn(fun() -> achieve(Manor#manor.gkey) end),
                T ++ [Manor]
        end,
    F = fun(M) ->
        notice_sys:add_notice(manor_war_finish, [M#manor.gkey, M#manor.name, M#manor.scene_id])
        end,
    lists:foreach(F, ManorList1),
    ok.

achieve(Gkey) ->
    F = fun(Mb) ->
        achieve:trigger_achieve(Mb#g_member.pkey, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3009, 0, 1)
        end,
    lists:foreach(F, guild_ets:get_guild_member_list(Gkey)),
    ok.


%%定时回写
timer_update() ->
    F = fun(ManorWar) ->
        manor_war_load:replace_manor_war(ManorWar),
        ets:insert(?ETS_MANOR_WAR, ManorWar#manor_war{is_change = 0})
        end,
    lists:foreach(F, ets:match_object(?ETS_MANOR_WAR, #manor_war{is_change = 1, _ = '_'})),

    F1 = fun(Manor) ->
        manor_war_load:replace_manor(Manor),
        ets:insert(?ETS_MANOR, Manor#manor{is_change = 0})
         end,
    lists:foreach(F1, ets:match_object(?ETS_MANOR, #manor{is_change = 1, _ = '_'})),
    ok.

%%系统关闭
logout() ->
    F = fun(ManorWar) ->
        manor_war_load:replace_manor_war(ManorWar)
        end,
    lists:foreach(F, ets:match_object(?ETS_MANOR_WAR, #manor_war{is_change = 1, _ = '_'})),
    F1 = fun(Manor) ->
        manor_war_load:replace_manor(Manor)
         end,
    lists:foreach(F1, ets:match_object(?ETS_MANOR, #manor{is_change = 1, _ = '_'})),

    ok.

