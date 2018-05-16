%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 五月 2018 下午8:38
%%%-------------------------------------------------------------------
-module(cross_mining_init).
-author("luobaqun").

-include("common.hrl").
-include("server.hrl").
-include("cross_mining.hrl").
-include("daily.hrl").

-define(COST_GOODS, 1027019).

%% API
-export([
    init/1,
    get_info/1,
    buy_help/3,
    reser_help/1,
    reset_help_list/1
]).


init(Player) ->
    St = cross_mining_load:dbget_player_cross_mining_help(Player#player.key),
    lib_dict:put(?PROC_STATUS_CROSS_MINE_HELP, St),
    Player.

get_info(Player) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_MINE_HELP),
    {Flag, ResetList} =
        if
            St#st_cross_mine_help.reset_list == [] ->
                {true, reset_help_list(Player)};
            true ->
                {false, St#st_cross_mine_help.reset_list}
        end,

    F = fun(HelpInfo) ->
        [
            HelpInfo#help_info.id,
            HelpInfo#help_info.pkey,
            HelpInfo#help_info.nickname,
            HelpInfo#help_info.sex,
            HelpInfo#help_info.vip,
            HelpInfo#help_info.dvip,
            HelpInfo#help_info.avatar,
            HelpInfo#help_info.cbp
        ]
        end,
    MyHelpList = lists:map(F, St#st_cross_mine_help.my_help_list),


    F1 = fun(HelpInfo) ->
        {FairyCrystal, GoodsCost} =
            case data_cross_mining_help_cost:get(HelpInfo#help_info.cbp) of
                [] -> {0, 0};
                {FairyCrystal0, GoodsCost0} ->
                    {FairyCrystal0, GoodsCost0}
            end,
        [
            HelpInfo#help_info.id,
            HelpInfo#help_info.pkey,
            HelpInfo#help_info.nickname,
            HelpInfo#help_info.sex,
            HelpInfo#help_info.vip,
            HelpInfo#help_info.dvip,
            HelpInfo#help_info.avatar,
            HelpInfo#help_info.cbp,
            GoodsCost,
            FairyCrystal]
         end,
    HelpList = lists:map(F1, ResetList),

    if
        Flag ->
            NewSt = St#st_cross_mine_help{reset_list = ResetList},
            lib_dict:put(?PROC_STATUS_CROSS_MINE_HELP, NewSt),
            cross_mining_load:dbup_player_cross_mining_help(NewSt);
        true -> skip
    end,
    {Att, _HelpCount, ResetCount} = daily:get_count(?DAILY_CROSS_MINE_HELP, {0, 0, 0}),
    {AttNum, AttLimit, ResetCost, HelpCount, HelpCountAll,Ratio} =
        case data_mineral_vip_help:get(Player#player.vip_lv) of
            [] ->
                {0, 0, 0, 0, 0,0};
            VipHelpBase ->
                ResetCost0 =
                    case [Cost || {Top, Down, Cost} <- VipHelpBase#base_cross_mine_vip_help.reset_list, ResetCount+1 >= Top, ResetCount+1 =< Down] of
                        [] -> 0;
                        Other -> hd(Other)
                    end,

                {
                    VipHelpBase#base_cross_mine_vip_help.att_num,
                    VipHelpBase#base_cross_mine_vip_help.att_len,
                    ResetCost0,
                    max(0, VipHelpBase#base_cross_mine_vip_help.att - Att),
                    VipHelpBase#base_cross_mine_vip_help.att,
                    VipHelpBase#base_cross_mine_vip_help.ratio
                }
        end,
    {AttNum, AttLimit, ResetCost, HelpCount, HelpCountAll,Ratio, MyHelpList, HelpList}.


buy_help(Player, Id, Type) ->
    case check_buy_help(Player, Id, Type) of
        {false, Res} ->
            {Res, Player};
        {true, HelpInfo, _BaseVipHelp, Cost} ->
            St = lib_dict:get(?PROC_STATUS_CROSS_MINE_HELP),
            Ids = lists:seq(1, length(St#st_cross_mine_help.my_help_list)+1) --[X#help_info.id || X <- St#st_cross_mine_help.my_help_list],
            case Ids of
                [] -> { 0,Player};
                _ ->
                    NewPlayer =
                        case Type of
                            1 -> %% 仙晶
                                money:fairy_crystal(Player, -Cost);
                            2 -> %% 物品
                                goods:subtract_good(Player, [{?COST_GOODS, Cost}], 357),
                                Player
                        end,
                    Id0 = hd(Ids),
                    NewHelpInfo = HelpInfo#help_info{id = Id0,time = util:unixtime()},
                    NewResetList =
                        case lists:keydelete(Id, #help_info.id, St#st_cross_mine_help.reset_list) of
                            [] ->
                                reset_help_list(NewPlayer);
                            Other ->
                                Other
                        end,
                    {Att, _HelpCount, _ResetCount} = daily:get_count(?DAILY_CROSS_MINE_HELP, {0, 0, 0}),
                    daily:set_count(?DAILY_CROSS_MINE_HELP,{Att+1, _HelpCount, _ResetCount}),
                    NewSt = St#st_cross_mine_help{my_help_list = [NewHelpInfo | St#st_cross_mine_help.my_help_list], reset_list = NewResetList},
                    lib_dict:put(?PROC_STATUS_CROSS_MINE_HELP, NewSt),
                    cross_mining_load:dbup_player_cross_mining_help(NewSt),
                    {1, NewPlayer}
            end
    end.

check_buy_help(Player, Id, Type) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_MINE_HELP),
    case lists:keyfind(Id, #help_info.id, St#st_cross_mine_help.reset_list) of
        false ->
            {false, 0};
        HelpInfo ->
            case data_mineral_vip_help:get(Player#player.vip_lv) of
                [] ->  {false, 0};
                BaseVipHelp ->
                    {Att, _HelpCount, _ResetCount} = daily:get_count(?DAILY_CROSS_MINE_HELP, {0, 0, 0}),
                    HelpLen = length( St#st_cross_mine_help.my_help_list),
                    if
                        Att >= BaseVipHelp#base_cross_mine_vip_help.att -> {false, 22};
                        HelpLen >= 5 ->{false, 23};
                        true ->
                            case data_cross_mining_help_cost:get(HelpInfo#help_info.cbp) of
                                [] ->
                                   {false, 0};
                                {FairyCrystal, GoodsCost} ->
                                    case Type of
                                        1 -> %% 仙晶
                                            ?IF_ELSE(Player#player.fairy_crystal >= FairyCrystal, {true, HelpInfo, BaseVipHelp, FairyCrystal}, {false, 16});
                                        2 -> %% 物品
                                            Count = goods_util:get_goods_count(?COST_GOODS),
                                            ?IF_ELSE(Count >= GoodsCost, {true, HelpInfo, BaseVipHelp, GoodsCost}, {false, 17});
                                        _ ->
                                            {false, 0}
                                    end
                            end
                    end
            end
    end.


reset_help_list(Player) ->
    Random = util:random(80,120),
    ShadowList = shadow_proc:match_shadow_by_cbp(round(Player#player.cbp *Random div 100 ), 10, [Player#player.key], 0),
    VipHelp = data_mineral_vip_help:get(Player#player.vip_lv),
    F = fun(Shadow, {Id, List0}) ->
        {Id+1, [#help_info{
            id = Id,
            pkey = Shadow#player.key,
            nickname = Shadow#player.nickname,
            cbp = Shadow#player.cbp *VipHelp#base_cross_mine_vip_help.ratio div 100,
            sex = Shadow#player.sex,
            vip = Shadow#player.vip_lv,
            dvip  = Shadow#player.d_vip#dvip.vip_type,
            avatar = Shadow#player.avatar
        } | List0]}
        end,
    {_, List} = lists:foldl(F, {1, []}, ShadowList),
    ?DEBUG("List ~p~n",[List]),
    List.


reser_help(Player)->
    {_Att, _HelpCount, ResetCount} = daily:get_count(?DAILY_CROSS_MINE_HELP, {0, 0, 0}),
        case data_mineral_vip_help:get(Player#player.vip_lv) of
            [] ->
                {0,Player};
            VipHelpBase ->
                ResetCost0 =
                    case [Cost || {Top, Down, Cost} <- VipHelpBase#base_cross_mine_vip_help.reset_list, ResetCount+1 >= Top, ResetCount+1 =< Down] of
                        [] -> 0;
                        Other -> hd(Other)
                    end,

                if
                    ResetCost0 < 0 -> {0,Player};
                    true ->
                        case money:is_enough(Player,ResetCost0,gold) of
                             false ->{25,Player};
                            true ->
                                NewPlayer = money:add_no_bind_gold(Player,-ResetCost0,358,0,0),
                                St = lib_dict:get(?PROC_STATUS_CROSS_MINE_HELP),
                                NewList = reset_help_list(Player),
                                NewSt = St#st_cross_mine_help{reset_list = NewList},
                                lib_dict:put(?PROC_STATUS_CROSS_MINE_HELP,NewSt),
                                cross_mining_load:dbup_player_cross_mining_help(NewSt),
                                {1,NewPlayer}
                        end
                end
        end.



