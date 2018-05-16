%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 七月 2017 15:33
%%%-------------------------------------------------------------------
-module(party).
-author("hxming").

-include("party.hrl").
-include("common.hrl").
-include("server.hrl").
%% API
-compile(export_all).


get_party_type_times(Type, Pkey, DateList, DailyTimes) ->
    case [Party || Party <- DateList, Party#party.pkey == Pkey, Party#party.type == Type] of
        [] -> DailyTimes;
        L ->
            max(0, DailyTimes - length(L))
    end.


check_app_state(Type, DateList, PKey, PartyTime, Now) ->
    if
        PartyTime < Now -> 0;
        true ->
            case [P || P <- DateList, P#party.time == PartyTime, P#party.type == Type] of
                [] -> 1;
                [Party | _] ->
                    ?IF_ELSE(Party#party.pkey == PKey, 3, 2)
            end
    end.


party_app(Type, Midnight, Id, Player, DateList) ->
    case data_party:get(Type) of
        [] -> 2;
        BaseData ->
            case data_party_time:get(Id) of
                [] -> 3;
                {Hour, Min} ->
                    Time = Midnight + Hour * ?ONE_HOUR_SECONDS + Min * 60,
                    %%已被预约
                    case [P || P <- DateList, P#party.time == Time, P#party.type == Type] of
                        [] ->
                            %%同类型今日已约
                            case [P || P <- DateList, P#party.pkey == Player#player.key, P#party.type == Type, P#party.date == Midnight] of
                                [] ->
                                    PriceType = ?IF_ELSE(BaseData#base_party.price_type == 1, bgold, gold),
                                    case money:is_enough(Player, BaseData#base_party.price, PriceType) of
                                        false ->
                                            6;
                                        true ->
                                            Party =
                                                #party{
                                                    akey = misc:unique_key(),
                                                    date = Midnight,
                                                    time = Time,
                                                    pkey = Player#player.key,
                                                    type = Type,
                                                    status = 0,
                                                    price_type = BaseData#base_party.price_type,
                                                    price = BaseData#base_party.price
                                                },
                                            party_load:replace_party(Party),
                                            {true, PriceType, BaseData#base_party.price, Time, BaseData, [Party | DateList],Party}
                                    end;

                                _ ->
                                    5
                            end;
                        _ ->
                            4
                    end
            end
    end.


invite_msg(Player, KeyList, BaseData, TimeString) ->
    {Title, Content} = t_mail:mail_content(110),
    {_, X, Y} = hd(BaseData#base_party.table_list),
    Content1 = io_lib:format(Content, [TimeString, BaseData#base_party.desc, X, Y, Player#player.nickname]),
    mail:sys_send_mail(KeyList, Title, Content1, [{7205002, 3}]),
    ok.

party_exp(Lv, ExpMult) ->
    round((math:sqrt(max(0, Lv - 39)) * 50 + 40000) * 6 / 3600 * 1800 * ExpMult).