%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 十一月 2016 13:43
%%%-------------------------------------------------------------------
-module(meridian).
-author("hxming").

-include("server.hrl").
-include("meridian.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("tips.hrl").
-include("achieve.hrl").
%% API
-export([
    check_meridian_state/1
    , get_meridian_list/2
    , upgrade/2
    , activate/2
    , break/3
    , clean_cd/2
    , calc_meridian_attribute/1
    , get_meridian_attribute/0
    , get_notice_state/1
    , check_activate_state/2
    , check_upgrade_state/2
    , check_break_state/2
]).

check_meridian_state(_Player) ->
    0.

get_notice_state(Player) ->
    StMeridian = lib_dict:get(?PROC_STATUS_MERIDIAN),
    Now = util:unixtime(),
    F = fun(Type) ->
        case lists:keyfind(Type, #meridian.type, StMeridian#st_meridian.meridian_list) of
            false ->
                case check_activate(Type, StMeridian) of
                    true -> true;
                    _Other -> false
                end;
            Meridian ->
                case check_upgrade(Meridian, Player, Now, false) of
                    {false, 7} -> %% 检查是否满足突破条件
                        Tips = check_break_state(Player, #tips{}),
                        Tips#tips.state == 1;
                    {false, _Other} -> false;
                    _ -> true
                end
        end
        end,
    case lists:any(F, data_meridian_activate:type_list()) of
        true -> 1;
        false -> 0
    end.

%%获取经脉列表
get_meridian_list(Player, TypeGet) ->
    TypeList = ?IF_ELSE(TypeGet == 0, data_meridian_activate:type_list(), [TypeGet]),
    StMeridian = lib_dict:get(?PROC_STATUS_MERIDIAN),
    Now = util:unixtime(),
    F = fun(Type, L) ->
        BaseActivate = data_meridian_activate:get(Type),
        case lists:keyfind(Type, #meridian.type, StMeridian#st_meridian.meridian_list) of
            false ->
                case lists:keyfind(Type - 1, #meridian_info.type, L) of
                    false ->
                        if Type == 1 ->
                            BaseUp = data_meridian_upgrade:get(Type, 1, 1),
                            IsActivate = ?IF_ELSE(BaseUp#base_meridian_upgrade.plv =< Player#player.lv, ?MERIDIAN_STATE_ACTIVATE, ?MERIDIAN_STATE_CLOSE),
                            Info = #meridian_info{type = Type, is_activate = IsActivate},
                            [Info | L];
                            true ->
                                Info = #meridian_info{type = Type, is_activate = ?MERIDIAN_STATE_CLOSE},
                                [Info | L]
                        end;
                    FindInfo ->
                        BaseUp = data_meridian_upgrade:get(Type, 1, 1),
                        IsActivate = ?IF_ELSE(FindInfo#meridian_info.lv_total >= BaseActivate#base_meridian_activate.lv_need andalso BaseUp#base_meridian_upgrade.plv =< Player#player.lv, ?MERIDIAN_STATE_ACTIVATE, ?MERIDIAN_STATE_CLOSE),
                        Info = #meridian_info{type = Type, is_activate = IsActivate},
                        [Info | L]
                end;
            Meridian ->
                ?DEBUG("Meridian ~p~n",[Meridian]),
                SubtypeList = subtype_list(Meridian, Player#player.lv) ++ break_list(Meridian),
                LvCalc = calc_lv(Meridian#meridian.subtype, Meridian#meridian.lv, Meridian#meridian.break_lv),
                AttributeList = attribute_util:pack_attr(get_single_attribute_list(Meridian)),
                Cd = max(0, Meridian#meridian.cd - Now),
                CdPrice = cd_price(Cd),
                InCd = ?IF_ELSE(Cd > 0 andalso Meridian#meridian.in_cd == 1, 1, 0),
                IsActivate = case lists:any(fun([_, _, SubtypeState]) -> SubtypeState > 0 end, SubtypeList) of
                                 true -> ?MERIDIAN_STATE_UP;
                                 false -> ?MERIDIAN_STATE_HAD_ACTIVATE
                             end,
                Info = #meridian_info{type = Type, is_activate = IsActivate, lv_total = LvCalc, break_lv = Meridian#meridian.break_lv, in_cd = InCd, cd = Cd, cd_price = CdPrice, subtype_list = SubtypeList, attrs = AttributeList},
                [Info | L]
        end
        end,
    InfoList = lists:foldl(F, [], TypeList),
    F1 = fun(Info1) ->
        [Info1#meridian_info.type,
            Info1#meridian_info.is_activate,
            Info1#meridian_info.lv_total,
            Info1#meridian_info.break_lv,
            Info1#meridian_info.in_cd,
            Info1#meridian_info.cd,
            Info1#meridian_info.cd_price,
            Info1#meridian_info.subtype_list,
            Info1#meridian_info.attrs]
         end,
    NewInfoList = lists:map(F1, lists:keysort(#meridian_info.type, InfoList)),
    {Player#player.xinghun, NewInfoList}.

%%经络列表
subtype_list(Meridian, Plv) ->
    #meridian{type = Type, subtype = NowSubtype, lv = NowLv, break_lv = Blv} = Meridian,
    F = fun(Subtype) ->
        Lv = subtype_lv(Subtype, NowSubtype, NowLv),
        UpState = subtype_up_state(Type, Subtype, Lv, NowSubtype, Blv, Plv),
        [Subtype, Lv, UpState]
        end,
    lists:map(F, lists:seq(1, data_meridian_upgrade:get_max_subtype())).

%%经络等级
subtype_lv(SubType, NowSubtype, Lv) ->
    if SubType > NowSubtype -> max(0, Lv - 1);
        true ->
            Lv
    end.

%%下一可修炼的经络类型
next_subtype(SubType) ->
    MaxSubType = data_meridian_upgrade:get_max_subtype(),
    if SubType == 0 orelse SubType >= MaxSubType -> 1;
        true ->
            SubType + 1
    end.

subtype_up_state(Type, Subtype, Lv, NowSubtype, Blv, Plv) ->
    case data_meridian_upgrade:get(Type, Subtype, Lv + 1) of
        [] -> 0;
        Base ->
            MaxLv = data_meridian_upgrade:get_max_lv(),
            if Base#base_meridian_upgrade.break_lv > Blv -> 0;
                Lv >= MaxLv -> 0;
                Base#base_meridian_upgrade.plv > Plv -> 0;
                true ->
                    NextSubType = next_subtype(NowSubtype),
                    ?IF_ELSE(Subtype == NextSubType, 1, 0)
            end
    end.

break_list(Meridian) ->
    #meridian{type = Type, subtype = NowSubtype, lv = NowLv, break_lv = Blv} = Meridian,
    NextSubtype = next_subtype(NowSubtype),
    Lv = subtype_lv(NextSubtype, NowSubtype, NowLv),
    State =
        case data_meridian_upgrade:get(Type, NextSubtype, Lv + 1) of
            [] ->
                MaxSubtype = data_meridian_upgrade:get_max_subtype(),
                MaxLv = data_meridian_upgrade:get_max_lv(),
                %%经络满级
                if NowSubtype == MaxSubtype andalso NowLv == MaxLv ->
                    case data_meridian_break:get(Type, Blv + 1) of
                        [] -> 0;
                        _ ->
                            1
                    end;
                    true -> 0
                end;
            Base ->
                if Base#base_meridian_upgrade.break_lv =< Blv -> 0;
                    true ->
                        case data_meridian_break:get(Type, Blv + 1) of
                            [] -> 0;
                            _ ->
                                1
                        end
                end
        end,
    [[data_meridian_upgrade:get_max_subtype() + 1, Blv, State]].

%%经脉等级总和
calc_lv(NowSubtype, NowLv, BreakLv) ->
    F = fun(SubType) ->
        subtype_lv(SubType, NowSubtype, NowLv)
        end,
    LvList = lists:map(F, lists:seq(1, data_meridian_upgrade:get_max_subtype())),
    lists:sum(LvList) + BreakLv.

%%获取单个经脉的属性
get_single_attribute_list(Meridian) ->
    #meridian{type = Type, subtype = NowSubtype, lv = NowLv, break_lv = Blv} = Meridian,
    F = fun(Subtype) ->
        Lv = subtype_lv(Subtype, NowSubtype, NowLv),
        case data_meridian_upgrade:get(Type, Subtype, Lv) of
            [] -> [];
            BaseUp -> BaseUp#base_meridian_upgrade.attrs
        end
        end,
    AttrList1 = lists:flatmap(F, lists:seq(1, data_meridian_upgrade:get_max_subtype())),
    BaseActivate = data_meridian_activate:get(Type),
    AttrList2 = BaseActivate#base_meridian_activate.attrs,
    AttrPer =
        case data_meridian_break:get(Type, Blv) of
            [] -> 0;
            BaseBreak -> BaseBreak#base_meridian_break.attr_per
        end,
    AttrList = util:merge_kv(AttrList1 ++ AttrList2),
    FN = fun({Key, Val}) -> {Key, util:floor(Val * (1 + AttrPer / 100))} end,
    lists:map(FN, AttrList).

%%计算经脉属性
calc_meridian_attribute(MeridianList) ->
    F = fun(Meridian) ->
        get_single_attribute_list(Meridian)
        end,
    AttrList = lists:flatmap(F, MeridianList),
    attribute_util:make_attribute_by_key_val_list(AttrList).

%%经脉属性
get_meridian_attribute() ->
    StMeridian = lib_dict:get(?PROC_STATUS_MERIDIAN),
    StMeridian#st_meridian.attribute.

vip_cd(Vip, Cd) ->
    case data_vip_args:get(30, Vip) of
        [] -> Cd;
        1 -> 0;
        _0 -> Cd
    end.

%%激活经脉
activate(Player, Type) ->
    case lists:member(Type, data_meridian_activate:type_list()) of
        false -> {2, Player};
        true ->
            StMeridian = lib_dict:get(?PROC_STATUS_MERIDIAN),
            case lists:keyfind(Type, #meridian.type, StMeridian#st_meridian.meridian_list) of
                false ->
                    case check_activate(Type, StMeridian) of
                        {false, Err} -> {Err, Player};
                        true ->
                            MeridianList = [#meridian{type = Type} | StMeridian#st_meridian.meridian_list],
                            Attribute = calc_meridian_attribute(MeridianList),
                            NewStMeridian = StMeridian#st_meridian{meridian_list = MeridianList, attribute = Attribute, is_change = 1},
                            lib_dict:put(?PROC_STATUS_MERIDIAN, NewStMeridian),
                            NewPlayer = player_util:count_player_attribute(Player, true),
%%                             activity:get_notice(Player, [87], true),
%%                             player:apply_state(async, self(), {activity, sys_notice, [87]}),
                            meridian_load:log_meridian(Player#player.key, Player#player.nickname, Type, 0, 0),
                            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1049, 0, length(MeridianList)),
                            {1, NewPlayer}
                    end;
                _ -> {3, Player}
            end
    end.

%%激活经脉
check_activate_state(_Player, Tips) ->
    StMeridian = lib_dict:get(?PROC_STATUS_MERIDIAN),
    F = fun(Type) ->
        case lists:keyfind(Type, #meridian.type, StMeridian#st_meridian.meridian_list) of
            false ->
                case check_activate(Type, StMeridian) of
                    {false, _Err} -> [];
                    true -> [1]
                end;
            _ ->
                []
        end
        end,
    List = lists:flatmap(F, data_meridian_activate:type_list()),
    if
        List == [] -> Tips;
        true -> Tips#tips{state = 1}
    end.

check_activate(Type, StMeridian) ->
    if Type == 1 -> true;
        true ->
            case lists:keyfind(Type - 1, #meridian.type, StMeridian#st_meridian.meridian_list) of
                false -> {false, 4};
                Meridian ->
                    Lv = calc_lv(Meridian#meridian.subtype, Meridian#meridian.lv, Meridian#meridian.break_lv),
                    BaseActivate = data_meridian_activate:get(Type),
                    if Lv < BaseActivate#base_meridian_activate.lv_need ->
                        {false, 4};
                        true ->
                            true
                    end
            end
    end.

%%提升经脉等级
upgrade(Player, Type) ->
    case lists:member(Type, data_meridian_activate:type_list()) of
        false -> {2, Player};
        true ->
            StMeridian = lib_dict:get(?PROC_STATUS_MERIDIAN),
            case lists:keytake(Type, #meridian.type, StMeridian#st_meridian.meridian_list) of
                false ->
                    {5, Player};
                {value, Meridian, L} ->
                    Now = util:unixtime(),
                    case check_upgrade(Meridian, Player, Now, true) of
                        {false, Err} -> {Err, Player};
                        {true, SubType, Lv, Ratio, Cd, Cost} ->
                            Player1 = money:add_xinghun(Player, -Cost),
                            case util:odds(Ratio, 100) of
                                false ->
                                    {0, Player1};
                                true ->
                                    NewCd = ?IF_ELSE(Meridian#meridian.cd > Now, Meridian#meridian.cd + Cd, Now + Cd),
                                    InCd = ?IF_ELSE(Meridian#meridian.in_cd == 1 orelse NewCd - Now >= ?MERIDIAN_IN_CD_TIME, 1, 0),
                                    MeridianList = [Meridian#meridian{subtype = SubType, lv = Lv, in_cd = InCd, cd = NewCd} | L],
                                    Attribute = calc_meridian_attribute(MeridianList),
                                    NewStMeridian = StMeridian#st_meridian{meridian_list = MeridianList, attribute = Attribute, is_change = 1},
                                    lib_dict:put(?PROC_STATUS_MERIDIAN, NewStMeridian),
                                    NewPlayer = player_util:count_player_attribute(Player1, true),
                                    meridian_load:log_meridian(Player#player.key, Player#player.nickname, Type, SubType, Lv),
                                    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1048, 0, 1),
                                    F = fun(Mer, T) ->
                                        case lists:keytake(Mer#meridian.lv, 1, T) of
                                            false -> [{Mer#meridian.lv, 1} | T];
                                            {value, {_, Num}, T1} ->
                                                [{Mer#meridian.lv, Num + 1} | T1]
                                        end
                                        end,
                                    CountList = lists:foldl(F, [], MeridianList),
                                    F1 = fun({Lv0, Count}) ->
                                        achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1050, Lv0, Count)
                                         end,
                                    lists:foreach(F1, CountList),
%%                                     activity:get_notice(Player, [87], true),
%%                                     player:apply_state(async, self(), {activity, sys_notice, [87]}),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

%%检查提升经脉等级
check_upgrade_state(Player, Tips) ->
    StMeridian = lib_dict:get(?PROC_STATUS_MERIDIAN),
    F = fun(Type) ->
        case lists:keytake(Type, #meridian.type, StMeridian#st_meridian.meridian_list) of
            false ->
                [];
            {value, Meridian, _L} ->
                Now = util:unixtime(),
                case check_upgrade(Meridian, Player, Now, false) of
                    {false, _Err} -> [];
                    {true, _SubType, _Lv, _Ratio, _Cd, _Cost} -> [1]
                end
        end
        end,
    List = lists:flatmap(F, data_meridian_activate:type_list()),
    if
        List == [] -> Tips;
        true -> Tips#tips{state = 1}
    end.

check_upgrade(Meridian, Player, Now, IsNotice) ->
    #meridian{type = Type, subtype = Subtype, lv = Lv, break_lv = Blv, in_cd = InCd, cd = NowCd} = Meridian,
    NewSubtype = next_subtype(Subtype),
    NewLv = subtype_lv(NewSubtype, Subtype, Lv),
    case data_meridian_upgrade:get(Type, NewSubtype, NewLv + 1) of
        [] -> {false, 6};
        BaseUpgrade ->
            if BaseUpgrade#base_meridian_upgrade.break_lv > Blv -> {false, 7};
                BaseUpgrade#base_meridian_upgrade.cost_num > Player#player.xinghun ->
                    ?DEBUG("cost_num ~p~n",[BaseUpgrade#base_meridian_upgrade.cost_num]),
                    ?DEBUG("xinghun ~p~n",[Player#player.xinghun]),
                    ?DO_IF(IsNotice, goods_util:client_popup_goods_not_enough(Player, 10400, BaseUpgrade#base_meridian_upgrade.cost_num, 194)),
                    {false, 8};
                InCd == 1 andalso NowCd > Now -> {false, 10};
                BaseUpgrade#base_meridian_upgrade.plv > Player#player.lv -> {false, 15};
                true ->
                    Cd = vip_cd(Player#player.vip_lv, BaseUpgrade#base_meridian_upgrade.cd),
                    {true, NewSubtype, NewLv + 1, BaseUpgrade#base_meridian_upgrade.ratio, Cd, BaseUpgrade#base_meridian_upgrade.cost_num}
            end
    end.

%%经脉突破
break(Player, Type, IsAuto) ->
    case lists:member(Type, data_meridian_activate:type_list()) of
        false -> {2, Player};
        true ->
            StMeridian = lib_dict:get(?PROC_STATUS_MERIDIAN),
            case lists:keytake(Type, #meridian.type, StMeridian#st_meridian.meridian_list) of
                false ->
                    {5, Player};
                {value, Meridian, L} ->
                    Now = util:unixtime(),
                    case check_break(Player, Meridian, Now, IsAuto) of
                        {false, Err} -> {Err, Player};
                        {true, Player1, Ratio, Cd} ->
                            case util:odds(Ratio, 100) of
                                false ->
                                    {0, Player1};
                                true ->
                                    NewCd = ?IF_ELSE(Meridian#meridian.cd > Now, Meridian#meridian.cd + Cd, Now + Cd),
                                    InCd = ?IF_ELSE(Meridian#meridian.in_cd == 1 orelse NewCd - Now >= ?MERIDIAN_IN_CD_TIME, 1, 0),
                                    MeridianList = [Meridian#meridian{break_lv = Meridian#meridian.break_lv + 1, in_cd = InCd, cd = NewCd} | L],
                                    Attribute = calc_meridian_attribute(MeridianList),
                                    NewStMeridian = StMeridian#st_meridian{meridian_list = MeridianList, attribute = Attribute, is_change = 1},
                                    lib_dict:put(?PROC_STATUS_MERIDIAN, NewStMeridian),
                                    NewPlayer = player_util:count_player_attribute(Player1, true),
%%                                     activity:get_notice(Player, [87], true),
%%                                     player:apply_state(async, self(), {activity, sys_notice, [87]}),
                                    meridian_load:log_meridian(Player#player.key, Player#player.nickname, Type, 0, Meridian#meridian.break_lv + 1),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

%%检查经脉突破
check_break_state(Player, Tips) ->
    StMeridian = lib_dict:get(?PROC_STATUS_MERIDIAN),
    F = fun(Type) ->
        case lists:keytake(Type, #meridian.type, StMeridian#st_meridian.meridian_list) of
            false ->
                [];
            {value, Meridian, _L} ->
                Now = util:unixtime(),
                case check_break(Player, Meridian, Now, 0, false) of
                    {false, _Err} -> [];
                    {true, _Player1, _Ratio, _Cd} -> [1]
                end
        end
        end,
    List = lists:flatmap(F, data_meridian_activate:type_list()),
    if
        List == [] -> Tips;
        true -> Tips#tips{state = 1}
    end.

check_break(Player, Meridian, Now, IsAuto) ->
    check_break(Player, Meridian, Now, IsAuto, true).

check_break(Player, Meridian, Now, IsAuto, IsNotice) ->
    #meridian{type = Type, subtype = NowSubtype, lv = NowLv, break_lv = Blv, in_cd = InCd, cd = NowCd} = Meridian,
    case check_break_lv(Type, NowSubtype, NowLv, Blv) of
        {false, Err} -> {false, Err};
        true ->
            if
                InCd == 1 andalso NowCd > Now -> {false, 10};
                true ->
                    case data_meridian_break:get(Type, Blv + 1) of
                        [] -> {false, 12};
                        BaseBreak ->
                            {GoodsId, Num} = BaseBreak#base_meridian_break.goods,
                            Count = goods_util:get_goods_count(GoodsId),
                            if
                                BaseBreak#base_meridian_break.plv > Player#player.lv -> {false, 15};
                                Count >= Num ->
                                    ?IF_ELSE(IsNotice == true, goods:subtract_good(Player, [{GoodsId, Num}], 194), ok),
                                    Cd = vip_cd(Player#player.vip_lv, BaseBreak#base_meridian_break.cd),
                                    {true, Player, BaseBreak#base_meridian_break.ratio, Cd};
                                IsAuto == 1 ->
                                    case new_shop:auto_buy(Player, GoodsId, Num, 194) of
                                        {false, 1} -> {false, 16};
                                        {false, 2} -> {false, 13};
                                        {false, 3} -> {false, 14};
                                        {ok, NewPlayer, _} ->
                                            Cd = vip_cd(Player#player.vip_lv, BaseBreak#base_meridian_break.cd),
                                            {true, NewPlayer, BaseBreak#base_meridian_break.ratio, Cd}
                                    end;
                                true ->
                                    if
                                        IsNotice == true ->
                                            goods_util:client_popup_goods_not_enough(Player, GoodsId, Num, 194);
                                        true -> skip
                                    end,
                                    {false, 9}
                            end
                    end
            end
    end.

check_break_lv(Type, NowSubtype, NowLv, Blv) ->
    NextSubtype = next_subtype(NowSubtype),
    Lv = subtype_lv(NextSubtype, NowSubtype, NowLv),
    case data_meridian_upgrade:get(Type, NextSubtype, Lv + 1) of
        [] ->
            MaxSubtype = data_meridian_upgrade:get_max_subtype(),
            MaxLv = data_meridian_upgrade:get_max_lv(),
            %%经络满级
            if NowSubtype == MaxSubtype andalso NowLv == MaxLv -> true;
                true ->
                    {false, 11}
            end;
        Base ->
            if Base#base_meridian_upgrade.break_lv =< Blv -> {false, 11};
                true -> true
            end
    end.

%%CD价格
cd_price(Cd) ->
    util:ceil(Cd / 60 * 3).

%%清CD
clean_cd(Player, Type) ->
    StMeridian = lib_dict:get(?PROC_STATUS_MERIDIAN),
    case lists:keytake(Type, #meridian.type, StMeridian#st_meridian.meridian_list) of
        false -> {2, Player};
        {value, Meridian, T} ->
            Now = util:unixtime(),
            if Meridian#meridian.in_cd == 1 andalso Meridian#meridian.cd > Now ->
                Cd = Meridian#meridian.cd - Now,
                Price = cd_price(Cd),
                case money:is_enough(Player, Price, bgold) of
                    false -> {14, Player};
                    true ->
                        NewPlayer = money:add_gold(Player, -Price, 195, 0, 0),
                        MeridianList = [Meridian#meridian{in_cd = 0, cd = 0} | T],
                        NewStMeridian = StMeridian#st_meridian{meridian_list = MeridianList, is_change = 1},
                        lib_dict:put(?PROC_STATUS_MERIDIAN, NewStMeridian),
%%                         player:apply_state(async, self(), {activity, sys_notice, [87]}),
                        {1, NewPlayer}
                end;
                true ->
                    {17, Player}
            end
    end.

