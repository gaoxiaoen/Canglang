%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 四月 2018 10:27
%%%-------------------------------------------------------------------
-module(log_cbp).
-author("hxming").
-include("common.hrl").
-include("server.hrl").

%% API
-export([init/1, log_cbp/4, logout/0]).


init(Player) ->
    Sql = io_lib:format("select cbp ,cbp_list from player_cbp where pkey = ~p", [Player#player.key]),
    case db:get_row(Sql) of
        [] -> skip;
        [Cbp, CbpList] ->
            EtsCbp = #ets_cbp{pkey = Player#player.key, cbp = Cbp, cbp_list = util:bitstring_to_term(CbpList)},
            put(?PROC_STATUS_CBP, EtsCbp)
    end,
    Player.

log_cbp(Pkey, Nickname, NewCbp, AttributeList) ->
    CbpList = [{Id, attribute_util:calc_combat_power(Attribute)} || {Id, Attribute} <- AttributeList],
    NewEtsCbp = #ets_cbp{pkey = Pkey, cbp = NewCbp, cbp_list = CbpList, is_change = 1},
    case get_dict() of
        false -> skip;
        OldEtsCbp ->
            if OldEtsCbp#ets_cbp.cbp =< NewCbp -> skip;
                true ->
                    diff(Pkey, Nickname, OldEtsCbp, NewEtsCbp),
                    ok
            end
    end,
    put(?PROC_STATUS_CBP, NewEtsCbp),
    ok.


get_dict() ->
    case get(?PROC_STATUS_CBP) of
        undefined ->
            false;
        EtsCbp ->
            EtsCbp
    end.

logout() ->
    EtsCbp = get_dict(),
    if EtsCbp#ets_cbp.is_change == 0 -> skip;
        true ->
            Sql = io_lib:format("replace into player_cbp set pkey=~p,cbp=~p,cbp_list = '~s'",
                [EtsCbp#ets_cbp.pkey, EtsCbp#ets_cbp.cbp, util:term_to_bitstring(EtsCbp#ets_cbp.cbp_list)]),
            db:execute(Sql)
    end.


diff(Pkey, Nickname, OldEtsCbp, NewEtsCbp) ->
    String = calc_diff(OldEtsCbp#ets_cbp.cbp_list, NewEtsCbp#ets_cbp.cbp_list, ""),
    Sql = io_lib:format("insert into log_cbp set pkey = '~p',nickname = '~s',old_cbp =~p,new_cbp =~p,log = '~s',time =~p",
        [Pkey, Nickname, OldEtsCbp#ets_cbp.cbp, NewEtsCbp#ets_cbp.cbp, String, util:unixtime()]),
%%    db:execute(Sql),
    log_proc:log(Sql),
    ok.



calc_diff([], _, String) -> String;
calc_diff([{Id, Val} | T], L, String) ->
    case lists:keyfind(Id, 1, L) of
        false ->
            ?WARNING("calc cbp diff id:~p undef", [Id]),
            calc_diff(T, L, String);
        {_, Val1} ->
            case Val1 - Val of
                0 ->
                    calc_diff(T, L, String);
                Diff ->
                    NewString =
                        case String of
                            "" ->
                                io_lib:format("~p~s:~p", [Id, id_to_name(Id), Diff]);
                            _ ->
                                io_lib:format("~s|~p~s:~p", [String, Id, id_to_name(Id), Diff])
                        end,
                    calc_diff(T, L, NewString)
            end
    end.


id_to_name(Id) ->
    NameList = [
        {1, ?T("等级属性")}, {2, ?T("基础属性")}, {3, ?T("装备属性")}, {4, ?T("坐骑属性")}, {5, ?T("宠物属性")}, {6, ?T("时装属性")}, {7, ?T("翅膀属性")},
        {8, ?T("灵猫属性")}, {9, ?T("法身属性")}, {10, ?T("灵佩属性")}, {11, ?T("仙宝属性")}, {12, ?T("装备强化镶嵌属性")}, {13, ?T("VIP属性")}, {14, ?T("经脉属性")}, {15, ?T("剑池属性")},
        {16, ?T("光武属性")}, {17, ?T("法宝属性")}, {18, ?T("十荒神器属性")}, {19, ?T("图鉴属性")}, {20, ?T("熔炼属性")}, {21, ?T("技能属性")}, {22, ?T("剑道属性")}, {23, ?T("元素属性")},
        {24, ?T("气泡属性")}, {25, ?T("称号属性")}, {26, ?T("符文属性")}, {27, ?T("仙装属性")}, {28, ?T("仙阶属性")}, {29, ?T("妖灵属性")}, {30, ?T("仙盟技能属性")}, {31, ?T("头饰属性")}, {32, ?T("足迹属性")},
        {33, ?T("羁绊属性")}, {34, ?T("仙术觉醒属性")}, {35, ?T("装备套装属性")}, {36, ?T("戒指属性")}, {37, ?T("姻缘树属性")}, {38, ?T("挂饰属性")},
        {39, ?T("仙魂属性")}, {40, ?T("宝宝属性")}, {41, ?T("宝宝翅膀属性")}, {42, ?T("转职属性")}, {43, ?T("宝宝坐骑属性")}, {44, ?T("宝宝武器属性")}, {45, ?T("时装套装属性")}, {46, ?T("属性丹属性")}, {47, ?T("神祗属性")},
        {48, ?T("限时VIP属性")}, {49, ?T("仙盟旗帜属性")}, {50, ?T("觉醒属性")}
    ],
    case lists:keyfind(Id, 1, NameList) of
        false -> undef;
        {_, Name} -> Name
    end.
