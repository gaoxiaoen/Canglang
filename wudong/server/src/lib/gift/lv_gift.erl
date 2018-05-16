%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 下午8:25
%%%-------------------------------------------------------------------
-module(lv_gift).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("lv_gift.hrl").

%% API
-export([
    init/1,
    get_lv_gift_info/1,
    get_gift/2,
    check_lv_gift_state/1,
    get_state/1
]).

init(Player) ->
    LvGiftSt = dbget_lv_gift(Player),
    lib_dict:put(?PROC_STATUS_LVGIFT, LvGiftSt),
    Player.

%%检查是否有等级礼包可领取
check_lv_gift_state(Plv) ->
    LvGiftSt = lib_dict:get(?PROC_STATUS_LVGIFT),
    All = data_lv_gift:get_all(),
    F = fun(Lv) ->
        %%1已领取2可领取3不可领取
            case lists:member(Lv, LvGiftSt#st_lv_gift.get_list) of
                true -> false;
                false ->
                    Plv >= Lv
            end
        end,
    case lists:any(F, All) of
        true -> 1;
        false -> 0
    end.

%%获取等级礼包信息
get_lv_gift_info(Player) ->
    LvGiftSt = lib_dict:get(?PROC_STATUS_LVGIFT),
    All = data_lv_gift:get_all(),
    F = fun(Lv) ->
        %%1已领取2可领取3不可领取
        State =
            case lists:member(Lv, LvGiftSt#st_lv_gift.get_list) of
                true -> 1;
                false ->
                    case Player#player.lv >= Lv of
                        true -> 2;
                        false -> 3
                    end
            end,
        GiftId = data_lv_gift:get(Lv),
        [Lv, State, GiftId]
        end,
    InfoList = lists:map(F, All),
    {ok, Bin} = pt_530:write(53000, {InfoList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%领取礼包
get_gift(Player, Lv) ->
    case check_get_gift(Player, Lv) of
        {false, Res} ->
            {false, Res};
        {ok, GiftId} ->
            GiveGoodsList = goods:make_give_goods_list(109,[{GiftId,1}]),
            case goods:give_goods(Player, GiveGoodsList) of
                {ok, NewPlayer} ->
                    LvGiftSt = lib_dict:get(?PROC_STATUS_LVGIFT),
                    NewLvGiftSt = LvGiftSt#st_lv_gift{
                        get_list = LvGiftSt#st_lv_gift.get_list ++ [Lv],
                        time = util:unixtime()
                    },
                    lib_dict:put(?PROC_STATUS_LVGIFT, NewLvGiftSt),
                    dbup_lv_gift(NewLvGiftSt),
                    activity_log:log_get_gift(Player#player.key, Player#player.nickname, GiftId, 1, 109),
                    ?IF_ELSE(Lv > 10, activity:get_notice(Player,[53],true), ok),
                    {ok, NewPlayer, 1};
                {false, _} ->
                    {false, 0}
            end
    end.
check_get_gift(Player, Lv) ->
    LvGiftSt = lib_dict:get(?PROC_STATUS_LVGIFT),
    if
        LvGiftSt == [] -> {false, 0};
        Player#player.lv < Lv -> {false, 3};
        true ->
            case lists:member(Lv, LvGiftSt#st_lv_gift.get_list) of
                true -> {false, 2};
                false ->
                    GiftId = data_lv_gift:get(Lv),
                    if
                        GiftId == [] -> {false, 0};
                        true ->
                            {ok, GiftId}
                    end
            end
    end.

dbget_lv_gift(Player) ->
    Now = util:unixtime(),
    NewSt = #st_lv_gift{
        pkey = Player#player.key,
        get_list = [],
        time = Now
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select get_list,`time` from player_lv_gift where pkey = ~p", [Player#player.key]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [GetListBin, Time] ->
                    #st_lv_gift{
                        pkey = Player#player.key,
                        get_list = util:bitstring_to_term(GetListBin),
                        time = Time
                    }
            end
    end.

dbup_lv_gift(LvGiftSt) ->
    #st_lv_gift{
        pkey = Pkey,
        get_list = GetList,
        time = Time
    } = LvGiftSt,
    Sql = io_lib:format("replace into player_lv_gift set get_list='~s',`time`=~p, pkey = ~p",
        [util:term_to_bitstring(GetList), Time, Pkey]),
    db:execute(Sql),
    ok.

%%可领取状态通知
get_state(Player) ->
    check_lv_gift_state(Player#player.lv).
