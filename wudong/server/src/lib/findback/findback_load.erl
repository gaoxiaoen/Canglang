%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 四月 2016 上午10:41
%%%-------------------------------------------------------------------
-module(findback_load).
-author("fengzhenlin").
-include("server.hrl").
-include("findback.hrl").

%% API
-export([
    dbget_findback_exp/1,
    dbup_findback_exp/1,
    dbget_findback_src/1,
    dbup_findback_src/1
]).

dbget_findback_exp(Player) ->
    #player{
        key = Pkey
    } = Player,
    NewSt = #st_findback_exp{
        pkey = Pkey,
        outline_time = 0
    },
    case player_util:is_new_role(Player) of
        true -> NewSt#st_findback_exp{is_get = 0};
        false ->
            Sql = io_lib:format("select outline_time from player_findback_exp where pkey = ~p",[Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [OutlineTime] ->
                    #st_findback_exp{
                        pkey = Pkey,
                        outline_time = OutlineTime
                    }
            end
    end.

dbup_findback_exp(FindBackExpSt) ->
    #st_findback_exp{
        pkey = Pkey,
        outline_time = OutlineTime
    } = FindBackExpSt,
    Sql = io_lib:format("replace into player_findback_exp set outline_time=~p, pkey = ~p",[OutlineTime,Pkey]),
    db:execute(Sql),
    ok.

dbget_findback_src(Player) ->
    St = #st_findback_src{
        pkey = Player#player.key
    },
    case player_util:is_new_role(Player) of
        true -> St;
        false ->
            Sql = io_lib:format("select type_list from player_findback_src where pkey = ~p", [Player#player.key]),
            case db:get_row(Sql) of
                [] -> St;
                [TypeListBin] ->
                    F = fun({Type, FbLeaveTimes, TodayUseTimes, FbExpRound, ExpRound,
                        FbDunIds, PassDunIds, FbDailyTaskGift, GetDailyTaskGiftTime, FbGuildTaskGift,
                        GetGuildTaskGiftTime, LastUpdateTime, LastFindbackTime}) ->
                            #fb_src{
                                type = Type,

                                fb_leave_times = FbLeaveTimes,
                                today_use_times = TodayUseTimes,

                                fb_exp_round = FbExpRound,
                                exp_round = ExpRound,

                                fb_dun_ids = FbDunIds,
                                pass_dun_ids = PassDunIds,

                                fb_daily_task_gift = FbDailyTaskGift,
                                get_daily_task_gift_time = GetDailyTaskGiftTime,

                                fb_guild_task_gift = FbGuildTaskGift,
                                get_guild_task_gift_time = GetGuildTaskGiftTime,

                                last_update_time = LastUpdateTime,
                                last_findback_time = LastFindbackTime
                            }
                        end,
                    TypeList = lists:map(F, util:bitstring_to_term(TypeListBin)),
                    St#st_findback_src{
                        type_list = TypeList
                    }
            end
    end.

dbup_findback_src(St) ->
    #st_findback_src{
        pkey = Pkey,
        type_list = TypeList
    } = St,
    TypeList1 = [parse_src_record(FbSrc)||FbSrc<-TypeList],
    Sql = io_lib:format("replace into player_findback_src set pkey=~p,type_list='~s'",
        [Pkey, util:term_to_bitstring(TypeList1)]),
    db:execute(Sql),
    ok.

parse_src_record(FbSrc) ->
    #fb_src{
        type = Type,

        fb_leave_times = FbLeaveTimes,
        today_use_times = TodayUseTimes,

        fb_exp_round = FbExpRound,
        exp_round = ExpRound,

        fb_dun_ids = FbDunIds,
        pass_dun_ids = PassDunIds,

        fb_daily_task_gift = FbDailyTaskGift,
        get_daily_task_gift_time = GetDailyTaskGiftTime,

        fb_guild_task_gift = FbGuildTaskGift,
        get_guild_task_gift_time = GetGuildTaskGiftTime,

        last_update_time = LastUpdateTime,
        last_findback_time = LastFindbackTime
    } = FbSrc,
    {Type, FbLeaveTimes, TodayUseTimes, FbExpRound, ExpRound,
        FbDunIds, PassDunIds, FbDailyTaskGift, GetDailyTaskGiftTime, FbGuildTaskGift,
        GetGuildTaskGiftTime, LastUpdateTime, LastFindbackTime}.
