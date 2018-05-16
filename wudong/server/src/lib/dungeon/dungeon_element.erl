%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 三月 2018 11:46
%%%-------------------------------------------------------------------
-module(dungeon_element).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("dungeon.hrl").
-include("element.hrl").

%% API
-export([
    init/1,
    check_enter/2,
    update_db/1,
    midnight_refresh/0,
    dungeon_element_ret/3,
    get_dun_list/1,
    saodang/1,
    get_state/1
]).

get_state(Player) ->
    OpenLv = data_menu_open:get(90),
    if
        Player#player.lv < OpenLv -> 0;
        true ->
            StDunElement = lib_dict:get(?PROC_STATUS_DUN_ELEMENT),
            #st_dun_element{
                log_list = LogList,
                saodang_list = SaodangList
            } = StDunElement,
            Code = ?IF_ELSE(LogList /= SaodangList, 1, 0),
            if
                Code == 1 -> 1;
                true ->
                    AllDunId = data_dun_element:get_all(),
                    F = fun(BaseDunId) ->
                        case lists:member(BaseDunId, SaodangList) of
                            true -> [];
                            false ->
                                case data_dun_element:get(BaseDunId) of
                                    [] -> [];
                                    #base_dun_element{lv_limit = LvLimit} ->
                                        ?IF_ELSE(Player#player.lv >= LvLimit, [1], [0])
                                end
                        end
                    end,
                    LL = lists:flatmap(F, AllDunId),
                    ?IF_ELSE(LL == [], 0, 1)
            end
    end.

saodang(Player) ->
    StDunElement = lib_dict:get(?PROC_STATUS_DUN_ELEMENT),
    #st_dun_element{
        log_list = LogList,
        saodang_list = SaodangList
    } = StDunElement,
    F = fun(DunId) ->
        case lists:member(DunId, SaodangList) of
            true -> [];
            false ->
                case data_dun_element:get(DunId) of
                    [] -> [];
                    #base_dun_element{reward = Reward} ->
                        Reward
                end
        end
    end,
    GetReward = lists:flatmap(F, LogList),
    GiveGoodsList = goods:make_give_goods_list(774, GetReward),
    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
    NewStDunElement = StDunElement#st_dun_element{saodang_list = LogList, op_time = util:unixtime()},
    lib_dict:put(?PROC_STATUS_DUN_ELEMENT, NewStDunElement),
    update_db(NewStDunElement),
    activity:get_notice(NewPlayer, [192], true),
    {util:list_tuple_to_list(GetReward), NewPlayer}.

get_dun_list(Player) ->
    StDunElement = lib_dict:get(?PROC_STATUS_DUN_ELEMENT),
    #st_dun_element{
        log_list = LogList,
        saodang_list = SaodangList
    } = StDunElement,
    AllDunId = data_dun_element:get_all(),
    F = fun(BaseDunId) ->
        case lists:member(BaseDunId, LogList) of
            true ->
                case lists:member(BaseDunId, SaodangList) of
                    true -> {BaseDunId, 3};
                    false -> {BaseDunId, 2}
                end;
            false ->
                case data_dun_element:get(BaseDunId) of
                    [] -> {BaseDunId, 0};
                    #base_dun_element{lv_limit = LvLimit} ->
                        ?IF_ELSE(Player#player.lv >= LvLimit, {BaseDunId, 1}, {BaseDunId, 0})
                end
        end
    end,
    List = lists:map(F, AllDunId),
    util:list_tuple_to_list(List).

dungeon_element_ret(0, Player, DungeonId) ->
    {ok, Bin} = pt_133:write(13302, {0, []}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Sql = io_lib:format("replace into log_dun_element set pkey=~p,dun_id=~p,result=~p,reward='~s',`time`=~p",
        [Player#player.key, DungeonId, 0, util:term_to_bitstring([]), util:unixtime()]),
    log_proc:log(Sql),
    Player;

dungeon_element_ret(1, Player, DungeonId) ->
    StDunElement = lib_dict:get(?PROC_STATUS_DUN_ELEMENT),
    Now = util:unixtime(),
    #st_dun_element{
        log_list = LogList,
        saodang_list = SaodangList
    } = StDunElement,
    NewStDunElement =
        StDunElement#st_dun_element{
            log_list = util:list_filter_repeat([DungeonId | LogList]),
            saodang_list = util:list_filter_repeat([DungeonId | SaodangList]),
            op_time = Now
        },
    lib_dict:put(?PROC_STATUS_DUN_ELEMENT, NewStDunElement),
    update_db(NewStDunElement),
    #base_dun_element{reward = Reward} = data_dun_element:get(DungeonId),
    GiveGoodsList = goods:make_give_goods_list(772, Reward),
    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
    {ok, Bin} = pt_133:write(13302, {1, util:list_tuple_to_list(Reward)}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Sql = io_lib:format("replace into log_dun_element set pkey=~p,dun_id=~p,result=~p,reward='~s',`time`=~p",
        [Player#player.key, DungeonId, 1, util:term_to_bitstring(Reward), Now]),
    log_proc:log(Sql),
    activity:get_notice(Player, [192], true),
    NewPlayer.

init(#player{key = Pkey}) ->
    Sql = io_lib:format("select log_list,saodang_list,op_time from player_dun_element where pkey=~p",
        [Pkey]),
    case db:get_row(Sql) of
        [LogList, SaodangList, OpTime] ->
            StDunElement =
                #st_dun_element{
                    pkey = Pkey,
                    log_list = util:bitstring_to_term(LogList),
                    saodang_list = util:bitstring_to_term(SaodangList),
                    op_time = OpTime
                };
        _ ->
            StDunElement = #st_dun_element{pkey = Pkey}
    end,
    lib_dict:put(?PROC_STATUS_DUN_ELEMENT, StDunElement),
    update().

update() ->
    StDunElement = lib_dict:get(?PROC_STATUS_DUN_ELEMENT),
    #st_dun_element{op_time = OpTime} = StDunElement,
    Now = util:unixtime(),
    case util:is_same_date(Now, OpTime) of
        true ->
            NewStDunElement = StDunElement;
        false ->
            NewStDunElement =
                StDunElement#st_dun_element{
                    op_time = OpTime,
                    saodang_list = []
                }
    end,
    lib_dict:put(?PROC_STATUS_DUN_ELEMENT, NewStDunElement).

check_enter(Player, DunId) ->
    case dungeon_util:is_dungeon_element(DunId) of
        false ->
            true;
        true ->
            case data_dun_element:get(DunId) of
                [] -> {false, ?T("副本ID错误")};
                #base_dun_element{lv_limit = LvLimit} ->
                    if
                        Player#player.lv < LvLimit -> {false, ?T("等级不足")};
                        true ->
                            StDunElement = lib_dict:get(?PROC_STATUS_DUN_ELEMENT),
                            #st_dun_element{
                                saodang_list = SaodangList
                            } = StDunElement,
                            case lists:member(DunId, SaodangList) of
                                true -> {false, ?T("今日已挑战")};
                                false -> true
                            end
                    end
            end
    end.

update_db(StDunElement) ->
    #st_dun_element{
        pkey = Pkey,
        log_list = LogList,
        saodang_list = SaodangList
    } = StDunElement,
    Sql = io_lib:format("replace into player_dun_element set pkey=~p, log_list='~s', saodang_list='~s',op_time=~p",
        [Pkey, util:term_to_bitstring(LogList), util:term_to_bitstring(SaodangList), util:unixtime()]),
    db:execute(Sql),
    ok.

midnight_refresh() ->
    update(),
    ok.