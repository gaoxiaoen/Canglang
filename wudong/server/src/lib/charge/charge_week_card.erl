%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 四月 2017 11:06
%%%-------------------------------------------------------------------
-module(charge_week_card).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("charge.hrl").
-include("goods.hrl").

%% API
-export([
    init/1,
    update/3,
    use_week_card/1,
    send_reward/1
]).

init(Player) ->
    Sql = io_lib:format("select remain_day, use_time from player_week_card where pkey=~p", [Player#player.key]),
    StWeekCard =
        case db:get_row(Sql) of
            [] ->
                #st_week_card{};
            [RemainDay, UseTime] ->
                #st_week_card{remain_day = RemainDay, use_time = UseTime}
        end,
    lib_dict:put(?PROC_STATUS_WEEK_CARD, StWeekCard),
    Player.

update(Player, RemainDay, UseTime) ->
    Sql = io_lib:format("update player_week_card set remain_day=~p, use_time=~p where pkey=~p", [RemainDay, UseTime, Player#player.key]),
    db:execute(Sql),
    ok.

%% 调用此接口前，优先扣除了物品
use_week_card(Player) ->
    StWeekCard = lib_dict:get(?PROC_STATUS_WEEK_CARD),
    #st_week_card{
        remain_day = RemainDay,
        use_time = UseTime
    } = StWeekCard,
    Now = util:unixtime(),
    NewRemainDay =
        case check_condition(RemainDay, UseTime, Now) of
            false ->
                RemainDay + 7;
            true ->
                {Title, Content0} = t_mail:mail_content(74),
                Content = io_lib:format(Content0, [RemainDay + 6]),
                mail:sys_send_mail([Player#player.key], Title, Content, [{10106, 100}]),
                RemainDay + 6
        end,
    NewStWeekCard = StWeekCard#st_week_card{remain_day = NewRemainDay, use_time = Now},
    lib_dict:put(?PROC_STATUS_WEEK_CARD, NewStWeekCard),
    update(Player, NewRemainDay, Now).

check_condition(RemainDay, UseTime, Now) ->
    case util:is_same_date(UseTime, Now) of
        true ->
            false;
        false ->
            if
                RemainDay == 0 ->
                    false;
                true ->
                    true
            end
    end.

%% 登陆及凌晨调用
send_reward(Player) ->
    StWeekCard = lib_dict:get(?PROC_STATUS_WEEK_CARD),
    #st_week_card{
        remain_day = RemainDay,
        use_time = UseTime
    } = StWeekCard,
    Now = util:unixtime(),
    case check_condition(RemainDay, UseTime, Now) of
        false ->
            skip;
        true ->
            NewRemainDay = RemainDay - 1,
            {Title, Content0} = t_mail:mail_content(74),
            Content = io_lib:format(Content0, [NewRemainDay]),
            mail:sys_send_mail([Player#player.key], Title, Content, [{10106, 100}]),
            NewStWeekCard =
                StWeekCard#st_week_card{
                    remain_day = NewRemainDay,
                    use_time = Now
                },
            lib_dict:put(?PROC_STATUS_WEEK_CARD, NewStWeekCard),
            update(Player, NewRemainDay, Now)
    end.