%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 三月 2016 14:21
%%%-------------------------------------------------------------------
-module(guild_history).
-author("hxming").

-include("server.hrl").
-include("guild.hrl").
-include("common.hrl").
%% API
-compile(export_all).


del_history(Pkey) ->
    guild_ets:del_guild_history(Pkey),
    guild_load:del_guild_history(Pkey).

update_history(Member, Now) ->
    #g_member{
        pkey = Pkey
    } = Member,
    History1 =
        case guild_ets:get_guild_history(Pkey) of
            false ->
                #g_history{pkey = Pkey, time = Now, q_times = 1, q_time = Now};
            History ->
                case util:is_same_date(History#g_history.time, Now) of
                    true ->
                        QTimes = History#g_history.q_times + 1,
                        History#g_history{time = Now, q_times = QTimes, q_time = Now};
                    false ->
                        History#g_history{time = Now, q_times = 1, q_time = Now}
                end
        end,
    History2 = member_to_history(Member, History1),
    guild_ets:set_guild_history(History2),
    guild_load:replace_guild_history(History2).

member_to_history(Member, Histroy) ->
    #g_member{
        daily_gift_get_time = DailyGiftGetTime
        , pass_floor = PassFloor
        , cheer_times = CheerTimes
        , cheer_keys = CheerKeys
        , be_cheer_times = BeCheerTimes
        , demon_update_time = DemonUpdateTime
        , get_demon_gift_list = GetDemonGiftList
    } = Member,
    Histroy#g_history{
        daily_gift_get_time = DailyGiftGetTime
        , pass_floor = PassFloor
        , cheer_times = CheerTimes
        , cheer_keys = CheerKeys
        , be_cheer_times = BeCheerTimes
        , demon_update_time = DemonUpdateTime
        , get_demon_gift_list = GetDemonGiftList
    }.

 history_to_member(Member) ->
    case guild_ets:get_guild_history(Member#g_member.pkey) of
        false ->
            Member;
        History ->
            #g_history{
                daily_gift_get_time = DailyGiftGetTime
                , pass_floor = PassFloor
                , cheer_times = CheerTimes
                , cheer_keys = CheerKeys
                , be_cheer_times = BeCheerTimes
                , demon_update_time = DemonUpdateTime
                , get_demon_gift_list = GetDemonGiftList
            } = History,
            Member#g_member{
                daily_gift_get_time = DailyGiftGetTime
                , pass_floor = PassFloor
                , cheer_times = CheerTimes
                , cheer_keys = CheerKeys
                , be_cheer_times = BeCheerTimes
                , demon_update_time = DemonUpdateTime
                , get_demon_gift_list = GetDemonGiftList
            }
    end.

%%经常是否有时间限制 true 是false否
check_quit_cd(Pkey, Now) ->
    case guild_ets:get_guild_history(Pkey) of
        false -> false;
        History ->
            case util:is_same_date(Now, History#g_history.q_time) of
                true ->
                    Cd = get_cd(History#g_history.q_times),
                    if History#g_history.q_time + Cd > Now ->
                        {true, History#g_history.q_time + Cd - Now};
                        true -> false
                    end;
                false ->
                    false
            end

    end.

get_cd(Times) ->
    case data_guild_quit:get(Times) of
        [] ->
            MaxTimes = hd(data_guild_quit:ids()),
            data_guild_quit:get(MaxTimes);
        Cd -> Cd
    end.