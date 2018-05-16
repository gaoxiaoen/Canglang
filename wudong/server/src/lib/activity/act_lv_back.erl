%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%            等级返利
%%% @end
%%% Created : 11. 十月 2017 17:46
%%%-------------------------------------------------------------------
-module(act_lv_back).
-author("lzx").
-include("activity.hrl").
-include("server.hrl").


-define(ACT_PLAYER_LV_BACK(Pkey,ActId),{act_player_lv_back,Pkey,ActId}).



%% API
-export([
    get_info/1,
    active/2,
    get_award/3,
    get_state/1,
    fanti_active/2
]).


get_act() ->
    case activity:get_work_list(data_act_lv_back) of
        [Base | _] -> Base;
        _ ->
            []
    end.


get_player_info(#player{key = Pkey}) ->
    #base_act_lv_back{act_id = ActId} = get_act(),
    case ?GLOBAL_DATA_RAM:get(?ACT_PLAYER_LV_BACK(Pkey,ActId), false) of
        false ->
            PlayerInfo = activity_load:dbget_act_lv_back(Pkey,ActId),
            ?GLOBAL_DATA_RAM:set(?ACT_PLAYER_LV_BACK(Pkey,ActId), PlayerInfo),
            PlayerInfo;
        PlayerInfo -> PlayerInfo
    end.

set_player_info(Pkey,#st_lv_back{act_id = ActId} = LuckySt) ->
    ?GLOBAL_DATA_RAM:set(?ACT_PLAYER_LV_BACK(Pkey,ActId),LuckySt),
    activity_load:dbup_act_lv_back(LuckySt).




%% @doc 获取活动奖励信息
get_info(_Player) ->
    case get_act() of
        #base_act_lv_back{award_list = AwardList} ->
            _LeaveTime = activity:get_leave_time(data_act_lv_back),
            #st_lv_back{buy_id = BuyId,get_award_id = GetIds} = get_player_info(_Player),
            SendList =
            lists:map(fun({ID,NeedGold,LvList}) ->
                IsBuy = ?IF_ELSE(BuyId == ID,1,0),
                {PackBackList,_} =
                    lists:mapfoldl(fun({Lv, BackGold}, Acc) ->
                        GetState =
                            case IsBuy > 0 of
                                true ->
                                    case lists:member(Acc, GetIds) of
                                        true -> 2;
                                        _ ->
                                            case _Player#player.lv >= Lv of
                                                true -> 1;
                                                _ ->
                                                    0
                                            end
                                    end;
                                _ ->
                                    0
                            end,
                    {[Acc,Lv,BackGold,GetState],Acc+1}
                                end,1,LvList),
                [ID,NeedGold,IsBuy,PackBackList]
                      end,AwardList),
            ?PRINT("SendList ============ 43842 ~w ",[SendList]),
            {ok,BinData} = pt_438:write(43842,{SendList}),
            server_send:send_to_sid(_Player#player.sid,BinData);
        _ ->
            skip
    end.


%% @doc 激活
active(_Player, _ID) ->
    case get_act() of
        #base_act_lv_back{award_list = AwardList, act_id = ActId} ->
%%            case version:get_lan_config() of
%%                fanti ->
%%                    %% 繁体不能通过这里激活
%%                    throw({fail, 4});
%%                _ ->
%%                    ok
%%            end,
            case lists:keyfind(_ID, 1, AwardList) of
                false -> {fail, 14};
                {_, NeedGold, _} ->
                    ?ASSERT(money:is_enough(_Player, NeedGold, gold), {fail, 5}),
                    #st_lv_back{buy_id = BuyId} = StBackLv = get_player_info(_Player),
                    ?ASSERT_TRUE(BuyId > 0, {fail, 15}),
                    NewPlayer = money:cost_money(_Player, gold, -NeedGold, 309, 0, 0),
                    NewBackLv = StBackLv#st_lv_back{buy_id = _ID},
                    set_player_info(_Player#player.key, NewBackLv),
                    log_act_lv_back(_Player#player.key, ActId, 1, _ID, NeedGold, 0, 0),
                    {ok, NewPlayer}
            end;
        _ ->
            {fail, 4}
    end.


%% 繁体激活
fanti_active(_Player,AddGold) ->
    case version:get_lan_config() of
        fanti ->
            case get_act() of
                #base_act_lv_back{award_list = AwardList, act_id = ActId} ->
                    IdList =  [ID||{ID, NeedGold, _} <- AwardList,NeedGold == AddGold],
                    case IdList of
                        [ActiveID|_] ->
                            #st_lv_back{buy_id = BuyId} = StBackLv = get_player_info(_Player),
                            case BuyId =< 0 of
                                true ->
                                    NewBackLv = StBackLv#st_lv_back{buy_id = ActiveID},
                                    set_player_info(_Player#player.key, NewBackLv),
                                    activity:get_notice(_Player, [34], true),
                                    log_act_lv_back(_Player#player.key, ActId, 1, ActiveID, AddGold, 0, 0);
                                false ->
                                    ok
                            end;
                        _ ->
                            ok
                    end;
                _ ->
                    ok
            end;
        _ ->
            ok
    end.



%% @doc 获取档数奖励
get_award(_Player,_ID,_SubId) ->
    case get_act() of
        #base_act_lv_back{award_list = AwardList,act_id = ActId} ->
            #st_lv_back{buy_id = BuyId,get_award_id = GetList} = StBackLv= get_player_info(_Player),
            ?ASSERT_TRUE(_ID /= BuyId,{fail,16}),
            case lists:keyfind(_ID,1,AwardList) of
                false -> {fail,14};
                {_,_,LvIds} ->
                    LenNum = length(LvIds),
                    ?ASSERT_TRUE(_SubId > LenNum orelse _SubId =< 0,{fail,16}),
                    ?ASSERT_TRUE(lists:member(_SubId,GetList),{fail,10}),
                    {NeedLv,GiveGold} = lists:nth(_SubId,LvIds),
                    ?ASSERT_TRUE(NeedLv > _Player#player.lv,{fail,17}),
                    NewPlayer2 = money:add_bind_gold(_Player, GiveGold, 310, 0, 0),
                    NewBackLv = StBackLv#st_lv_back{get_award_id = [_SubId|GetList]},
                    set_player_info(_Player#player.key,NewBackLv),
                    log_act_lv_back(_Player#player.key,ActId,2,BuyId,0,_SubId,GiveGold),
                    {ok,NewPlayer2}
            end;
        _ ->
            {fail,4}
    end.


%% 红圈判断
get_state(_Player) ->
    case get_act() of
        #base_act_lv_back{award_list = AwardList} ->
            #st_lv_back{buy_id = BuyId,get_award_id = GetIds} = get_player_info(_Player),
            case BuyId > 0 of
                true ->
                    case lists:keyfind(BuyId, 1, AwardList) of
                        false -> 0;
                        {_, _, LvIds} ->
                            {NewIds, _} = lists:mapfoldl(fun({NeedLv, BackGold}, Acc) ->
                                {[Acc, NeedLv, BackGold], Acc + 1}
                                                         end, 1, LvIds),
                            Ret =
                                lists:any(fun([SubId, NeedLv, _]) ->
                                    case lists:member(SubId, GetIds) of
                                        true -> false;
                                        _ ->
                                            _Player#player.lv >= NeedLv
                                    end
                                          end, NewIds),
                            ?IF_ELSE(Ret, 1, 0)
                    end;
                false ->
                    0
            end;
        _ ->
            -1
    end.



log_act_lv_back(Pkey,ActId,Opera,BuyId,Cost,GetSubId,GetBGold) ->
    NowTime = util:unixtime(),
    Sql = io_lib:format("insert into log_act_lv_back set pkey = ~p,act_id = ~p,opera = ~p,buy_id = ~p,cost = ~p,get_sub_id = ~p,get_b_gold = ~p,time = ~p",
        [Pkey,ActId,Opera,BuyId,Cost,GetSubId,GetBGold,NowTime]),
    log_proc:log(Sql).



