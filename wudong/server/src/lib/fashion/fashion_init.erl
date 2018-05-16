%% @author and_me
%% @doc @todo Add description to equip_fashion.


-module(fashion_init).
-include("server.hrl").
-include("common.hrl").
-include("fashion.hrl").


%% ====================================================================
%% API functions
%% ====================================================================
-export([init/1, fashion2string/1, timer_update/0, logout/0, check_fashion_timeout/2, get_attribute/0, calc_attribute/1, calc_single_attribute/1]).

-export([test/1]).
test(Pkey) ->
    Now = util:unixtime(),
    StFashion =
        case fashion_load:load_fashion(Pkey) of
            [] ->
                #st_fashion{pkey = Pkey};
            [FashionList] ->
                NewFashionList = fashion2list(FashionList, Now),
                FashionId = fetch_used_fashion(NewFashionList),
                #st_fashion{pkey = Pkey, fashion_list = NewFashionList, fashion_id = FashionId}
        end,
    NewStFashion = calc_attribute(StFashion),
    ?ERR("fashion list ~p  cbp ~p attr ~p~n", [NewStFashion#st_fashion.fashion_list, NewStFashion#st_fashion.cbp, attribute_util:make_attribute_to_key_val(NewStFashion#st_fashion.attribute)]),
    ok.


init(Player) ->
    Now = util:unixtime(),
    StFashion =
        case player_util:is_new_role(Player) of
            true ->
                #st_fashion{pkey = Player#player.key};
            false ->
                case fashion_load:load_fashion(Player#player.key) of
                    [] ->
                        #st_fashion{pkey = Player#player.key};
                    [FashionList] ->
                        NewFashionList = fashion2list(FashionList, Now),
                        FashionId = fetch_used_fashion(NewFashionList),
                        #st_fashion{pkey = Player#player.key, fashion_list = NewFashionList, fashion_id = FashionId}
                end
        end,
    NewStFashion = calc_attribute(StFashion),
    lib_dict:put(?PROC_STATUS_FASHION, NewStFashion),
    Player#player{fashion = Player#player.fashion#fashion_figure{fashion_cloth_id = StFashion#st_fashion.fashion_id}}.


fashion2list(FashionList, Now) ->
    F = fun(FashionInfo) ->
        ?DEBUG("FashionInfo ~p~n",[FashionInfo]),
        {FashionId, Time, Stage, IsUse, ActivationList} =
            case FashionInfo of
                {FashionId0, Time0, Stage0, IsUse0} -> {FashionId0, Time0, Stage0, IsUse0, []};
                {FashionId0, Time0, Stage0, IsUse0, ActivationList0} ->{FashionId0, Time0, Stage0, IsUse0, ActivationList0}
            end,
        NewIsUse =
            if IsUse == 1 ->
                if Time > 0 andalso Time < Now -> 0;
                    true -> IsUse
                end;
                true -> IsUse
            end,
        IsEnable = ?IF_ELSE(Time == 0 orelse Time > Now, true, false),
        #fashion{fashion_id = FashionId, time = Time, stage = Stage, is_use = NewIsUse, is_enable = IsEnable, activation_list = ActivationList}
    end,
    lists:map(F, util:bitstring_to_term(FashionList)).
fashion2string(FashionList) ->
    F = fun(Fashion) ->
        {Fashion#fashion.fashion_id, Fashion#fashion.time, Fashion#fashion.stage, Fashion#fashion.is_use, Fashion#fashion.activation_list}
    end,
    util:term_to_bitstring(lists:map(F, FashionList)).

%%计算属性
calc_attribute(StFashion) ->
    F = fun(Fashion) ->
        if Fashion#fashion.is_enable ->
            calc_single_attribute(Fashion);
            true -> Fashion
        end
    end,
    FashionList = lists:map(F, StFashion#st_fashion.fashion_list),
    AttributeList = [Fashion#fashion.attribute || Fashion <- FashionList],
    Attribute = attribute_util:sum_attribute(AttributeList),
    Cbp = attribute_util:calc_combat_power(Attribute),
    StFashion#st_fashion{fashion_list = FashionList, attribute = Attribute, cbp = Cbp}.

%%计算单时装属性
calc_single_attribute(Fashion) ->
    AttrList1 =
        case data_fashion:get(Fashion#fashion.fashion_id) of
            [] ->
                [];
            Base -> Base#base_fashion.attrs
        end,
    AttrList2 =
        case data_fashion_upgrade:get(Fashion#fashion.fashion_id, Fashion#fashion.stage) of
            [] -> [];
            Base1 -> Base1#base_fashion_upgrade.attrs
        end,
    F = fun(Stage) ->
        case data_fashion_upgrade:get(Fashion#fashion.fashion_id, Stage) of
            [] -> [];
            Base2 -> Base2#base_fashion_upgrade.lv_attr
        end
    end,
    AttrList3 = lists:flatmap(F, Fashion#fashion.activation_list), %% 等级额外属性

    AttrList = AttrList1 ++ AttrList2 ++ AttrList3,
    Attribute = attribute_util:make_attribute_by_key_val_list(AttrList),
    Cbp = attribute_util:calc_combat_power(Attribute),
    Fashion#fashion{attribute = Attribute, cbp = Cbp}.

get_attribute() ->
    StFashion = lib_dict:get(?PROC_STATUS_FASHION),
    StFashion#st_fashion.attribute.

%%检查时装过期
check_fashion_timeout(Player, Now) ->
    StFashion = lib_dict:get(?PROC_STATUS_FASHION),
    case [Fashion || Fashion <- StFashion#st_fashion.fashion_list, Fashion#fashion.time > 0, Fashion#fashion.time < Now, Fashion#fashion.is_enable] of
        [] -> Player;
        L ->
            F = fun(Fashion, T) ->
                fashion_load:log_fashion(Player#player.key, Player#player.nickname, 3, Fashion#fashion.fashion_id, Fashion#fashion.stage),
                [Fashion#fashion{attribute = #attribute{}, cbp = 0, is_enable = false, is_use = 0} |
                    lists:keydelete(Fashion#fashion.fashion_id, #fashion.fashion_id, T)]
            end,
            FashionList = lists:foldl(F, StFashion#st_fashion.fashion_list, L),
            StFashion1 = StFashion#st_fashion{fashion_list = FashionList, is_change = 1},
            NewStFashion = calc_attribute(StFashion1),
            lib_dict:put(?PROC_STATUS_FASHION, NewStFashion),
            Player1 = player_util:count_player_attribute(Player, true),
            case lists:keymember(Player#player.fashion#fashion_figure.fashion_cloth_id, #fashion.fashion_id, L) of
                false -> Player1;
                true ->
                    NewPlayer = Player1#player{fashion = Player#player.fashion#fashion_figure{fashion_cloth_id = 0}},
                    scene_agent_dispatch:fashion_update(NewPlayer),
                    NewPlayer
            end
    end.

%%获取当前使用中的时装
fetch_used_fashion(FashionList) ->
    case lists:keyfind(1, #fashion.is_use, FashionList) of
        false -> 0;
        Fashion -> Fashion#fashion.fashion_id
    end.

%%定时更新
timer_update() ->
    StFashion = lib_dict:get(?PROC_STATUS_FASHION),
    if StFashion#st_fashion.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_FASHION, StFashion#st_fashion{is_change = 0}),
        fashion_load:replace_fashion(StFashion);
        true ->
            ok
    end.

%%玩家离线
logout() ->
    StFashion = lib_dict:get(?PROC_STATUS_FASHION),
    if StFashion#st_fashion.is_change == 1 ->
        fashion_load:replace_fashion(StFashion);
        true ->
            ok
    end.
