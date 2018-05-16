%%%-------------------------------------------------------------------
%%% @author luo
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 新招财猫
%%% @end
%%% Created : 22. 八月 2017 9:50
%%%-------------------------------------------------------------------
-module(act_new_wealth_cat).
-include("activity.hrl").
-include("daily.hrl").
-include("server.hrl").
-include("common.hrl").

%% API
-export([
    init/1
    , get_info/1
    , draw/1
    , init_ets/0
    , get_act/0
    , get_state/1
    , update/1
]).

init(Player) ->
    St = activity_load:dbget_new_wealth_cat(Player#player.key),
    lib_dict:put(?PROC_STATUS_NEW_WEALTH_CAT, St),
    update(Player),
    Player.

update(Player) ->
    St = lib_dict:get(?PROC_STATUS_NEW_WEALTH_CAT),
    #st_new_wealth_cat{
        act_id = ActId
    } = St,
    NewSt =
        case activity:get_work_list(data_act_new_wealth_cat) of
            [] -> St;
            [Base | _] ->
                case Base#base_new_wealth_cat.act_id == ActId of
                    true ->
                        ?DEBUG("st ~p~n", [St]),
                        St;
                    false ->
                        ?DEBUG("false ~n"),
                        St#st_new_wealth_cat{
                            act_id = Base#base_new_wealth_cat.act_id,
                            pkey = Player#player.key,
                            id = 1
                        }
                end
        end,
    lib_dict:put(?PROC_STATUS_NEW_WEALTH_CAT, NewSt),
    ok.

get_info(_Player) ->
    LeaveTime = activity:get_leave_time(data_act_new_wealth_cat),
    St0 = lib_dict:get(?PROC_STATUS_NEW_WEALTH_CAT),
    {ActId, Val, Ratio} =
        case get_act() of
            [] -> {0, 0, []};
            Base ->
                if
                    St0#st_new_wealth_cat.act_id == Base#base_new_wealth_cat.act_id ->
                        Vals0 = Base#base_new_wealth_cat.vals,
                        case lists:keyfind(St0#st_new_wealth_cat.id, #base_new_wealth_cat_help.id, Vals0) of
                            false ->
                                BaseHelp = hd(Vals0),
                                {Base#base_new_wealth_cat.act_id,
                                    0,
                                    [[Id0, Val] || {Id0, Val, _Ratio0} <- BaseHelp#base_new_wealth_cat_help.ratio_list]};
                            BaseHelp ->
                                {Base#base_new_wealth_cat.act_id,
                                    BaseHelp#base_new_wealth_cat_help.val,
                                    [[Id0, Val] || {Id0, Val, _Ratio0} <- BaseHelp#base_new_wealth_cat_help.ratio_list]}
                        end;
                    true ->
                        update(_Player),
                        St1 = lib_dict:get(?PROC_STATUS_NEW_WEALTH_CAT),
                        Vals0 = Base#base_new_wealth_cat.vals,
                        case lists:keyfind(St1#st_new_wealth_cat.id, #base_new_wealth_cat_help.id, Vals0) of
                            false ->
                                BaseHelp = hd(Vals0),
                                {Base#base_new_wealth_cat.act_id,
                                    0,
                                    [[Id0, Val] || {Id0, Val, _Ratio0} <- BaseHelp#base_new_wealth_cat_help.ratio_list]};
                            BaseHelp ->
                                {Base#base_new_wealth_cat.act_id,
                                    BaseHelp#base_new_wealth_cat_help.val,
                                    [[Id0, Val] || {Id0, Val, _Ratio0} <- BaseHelp#base_new_wealth_cat_help.ratio_list]}
                        end
                end
        end,
    LogList = get_log(),
    {LeaveTime, ActId, Val, Ratio, LogList}.

draw(Player) ->
    case get_act() of
        [] -> {false, 0};
        Base ->
            St1 = lib_dict:get(?PROC_STATUS_NEW_WEALTH_CAT),
            if
                St1#st_new_wealth_cat.act_id /= Base#base_new_wealth_cat.act_id ->
                    update(Player);
                true -> skip
            end,
            St = lib_dict:get(?PROC_STATUS_NEW_WEALTH_CAT),
            Vals = Base#base_new_wealth_cat.vals,
            case lists:keyfind(St#st_new_wealth_cat.id, #base_new_wealth_cat_help.id, Vals) of
                false -> {false, 17};
                BaseHelp ->
                    Val = BaseHelp#base_new_wealth_cat_help.val,
                    case money:is_enough(Player, Val, gold) of
                        false -> {false, 5}; %% 元宝不足
                        true ->
%%                             Content = io_lib:format(t_tv:get(255), [t_tv:pn(Player), 1, 1, 1]),
                            RatioList = BaseHelp#base_new_wealth_cat_help.ratio_list,
                            RatioList0 = [{Mul, Ratio0} || {_, Mul, Ratio0} <- RatioList],
                            Ratio = util:list_rand_ratio(RatioList0),
                            {Id, _, _} = lists:keyfind(Ratio, 2, RatioList),
                            NewPlayer = money:add_no_bind_gold(Player, -Val, 537, 0, 0),
                            NewPlayer1 = money:add_no_bind_gold(NewPlayer, util:ceil(Val * (Ratio / 100)), 537, 0, 0),
                            insert(Base#base_new_wealth_cat.act_id, Player#player.nickname, Val, Ratio),
                            activity:get_notice(Player, [148], true),
                            NewSt = St#st_new_wealth_cat{id = St#st_new_wealth_cat.id + 1},
                            lib_dict:put(?PROC_STATUS_NEW_WEALTH_CAT, NewSt),
                            activity_load:dbup_new_wealth_cat(NewSt),
                            log_act_new_wealth(Player#player.key, Player#player.nickname, Player#player.lv, Val, util:ceil(Val * (Ratio / 100))),
                            Content = io_lib:format(t_tv:get(255), [t_tv:pn(Player),
                                t_tv:cl(io_lib:format("~p~s", [Val, util:to_list(?T("元宝"))]), 4),
                                t_tv:cl(io_lib:format("~p~s", [Ratio / 100, util:to_list(?T("倍"))]), 4),
                                t_tv:cl(io_lib:format("~p~s", [util:ceil(Val * (Ratio / 100)), util:to_list(?T("元宝"))]), 4)]),
                            notice:add_sys_notice(Content, 255),
                            {ok, Id, util:ceil(Val * (Ratio / 100)), NewPlayer1}
                    end
            end
    end.

init_ets() ->
    ets:new(?ETS_ACT_NEW_WEALTH_CAT_LOG, [{keypos, #act_new_wealth_cat_log.act_id} | ?ETS_OPTIONS]),
    ok.

get_log() ->
    case get_act() of
        [] ->
            [];
        #base_new_wealth_cat{act_id = BaseActId} ->
            Ets = look_up(BaseActId),
            LogList = Ets#act_new_wealth_cat_log.log,
            lists:sublist(LogList, 15)
    end.

look_up(ActId) ->
    case ets:lookup(?ETS_ACT_NEW_WEALTH_CAT_LOG, ActId) of
        [] ->
            ets:insert(?ETS_ACT_NEW_WEALTH_CAT_LOG, #act_new_wealth_cat_log{act_id = ActId}),
            #act_new_wealth_cat_log{act_id = ActId};
        [Ets] ->
            Ets
    end.

insert(ActId, Nickname, Cost, Ratio) ->
    Ets = look_up(ActId),
    NewLog = [[Nickname, Cost, Ratio] | Ets#act_new_wealth_cat_log.log],
    NewEts = Ets#act_new_wealth_cat_log{log = NewLog},
    ets:insert(?ETS_ACT_NEW_WEALTH_CAT_LOG, NewEts),
    ok.

get_state(_Player) ->
    case get_act() of
        [] -> -1;
        #base_new_wealth_cat{act_info = ActInfo} ->
            Args = activity:get_base_state(ActInfo),
            {0, Args}
    end.

get_act() ->
    case activity:get_work_list(data_act_new_wealth_cat) of
        [] -> [];
        [Base | _] -> Base
    end.

log_act_new_wealth(Pkey, Nickname, Lv, CostGold, AddGold) ->
    Sql = io_lib:format("insert into  log_act_new_wealth_cat (pkey, nickname,lv,cost_gold,add_gold,time) VALUES(~p,'~s',~p,~p,~p,~p)",
        [Pkey, Nickname, Lv, CostGold, AddGold, util:unixtime()]),
    log_proc:log(Sql),
    ok.

