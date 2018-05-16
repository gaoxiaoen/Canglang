%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 19:30
%%%-------------------------------------------------------------------
-module(mount_spirit).
-author("hxming").

-include("mount.hrl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
%% API
-export([calc_spirit_stage/1, spirit_info/0, spirit_upgrade/1, check_spirit_state/1, add_spirit/3]).

add_spirit(Player, GoodsId, Spirit) ->
    Mount = lib_dict:get(?PROC_STATUS_MOUNT),
    NewMount = Mount#st_mount{spirit = Mount#st_mount.spirit + Spirit, is_change = 1},
    lib_dict:put(?PROC_STATUS_MOUNT, NewMount),
    {ok, Bin} = pt_150:write(15030, {GoodsId, Spirit}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.


%% 计算灵脉阶数
calc_spirit_stage(SpiritList) ->
    case lists:keyfind(data_mount_spirit:max_type(), 1, SpiritList) of
        false -> 0;
        {_, Lv} -> Lv
    end.

%%灵脉信息
spirit_info() ->
    Mount = lib_dict:get(?PROC_STATUS_MOUNT),
    Stage = calc_spirit_stage(Mount#st_mount.spirit_list),
    TypeList = data_mount_spirit:type_list(),
    F = fun(Type) ->
        case lists:keyfind(Type, 1, Mount#st_mount.spirit_list) of
            false -> [Type, 0];
            {_, Lv} -> [Type, Lv]
        end
        end,
    SpiritList = lists:map(F, TypeList),
    CurType = get_upgrade_type(Mount#st_mount.last_spirit, TypeList),
    Attribute = mount_attr:calc_spirit_attribute(Mount#st_mount.spirit_list),
    AttributeList = attribute_util:pack_attr(Attribute),
    Cbp = attribute_util:calc_combat_power(Attribute),
    Spirit = default_spirit(CurType, Mount#st_mount.spirit_list, Mount#st_mount.spirit),
    {Stage, CurType, SpiritList, Cbp, AttributeList, Spirit}.

default_spirit(CurType, SpiritList, Spirit) ->
    NextLv =
        case lists:keyfind(CurType, 1, SpiritList) of
            false -> 1;
            {_, LvOld} -> LvOld + 1
        end,
    case data_mount_spirit:get(CurType, NextLv) of
        [] -> 0;
        Base ->
            {_, Count} = get_count(Base#base_mount_spirit.goods_id, Spirit),
            Count
    end.

get_upgrade_type(LastType, TypeList) ->
    MaxType = lists:max(TypeList),
    MinType = lists:min(TypeList),
    if LastType == 0 orelse LastType == MaxType -> MinType;
        true ->
            LastType + 1
    end.

%%灵脉升级
spirit_upgrade(Player) ->
    Mount = lib_dict:get(?PROC_STATUS_MOUNT),
    TypeList = data_mount_spirit:type_list(),
    CurType = get_upgrade_type(Mount#st_mount.last_spirit, TypeList),
    Lv = case lists:keyfind(CurType, 1, Mount#st_mount.spirit_list) of
             false -> 1;
             {_, LvOld} -> LvOld + 1
         end,
    case data_mount_spirit:get(CurType, Lv) of
        [] -> {47, Player};
        Base ->
            {Subtype, Count} = get_count(Base#base_mount_spirit.goods_id, Mount#st_mount.spirit),
            if Count < Base#base_mount_spirit.goods_num -> {40, Player};
                Base#base_mount_spirit.stage > Mount#st_mount.stage -> {37, Player};
                true ->
                    Spirit =
                        case Subtype of
                            ?GOODS_SUBTYPE_MOUNT_SPIRIT ->
                                Mount#st_mount.spirit - Base#base_mount_spirit.goods_num;
                            _ ->
                                goods:subtract_good(Player, [{Base#base_mount_spirit.goods_id, Base#base_mount_spirit.goods_num}], 247),
                                Mount#st_mount.spirit
                        end,
                    SpiritList = [{CurType, Lv} | lists:keydelete(CurType, 1, Mount#st_mount.spirit_list)],
                    Mount1 = Mount#st_mount{spirit_list = SpiritList, last_spirit = CurType, spirit = Spirit, is_change = 1},
                    NewMount = mount_attr:calc_mount_attr(Mount1),
                    mount_util:put_mount(NewMount),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    log_mount_spirit(Player#player.key, Player#player.nickname, CurType, Lv),
                    {1, NewPlayer}
            end
    end.

%%经常是否有可升级
check_spirit_state(Mount) ->
    TypeList = data_mount_spirit:type_list(),
    CurType = get_upgrade_type(Mount#st_mount.last_spirit, TypeList),
    Lv = case lists:keyfind(CurType, 1, Mount#st_mount.spirit_list) of
             false -> 1;
             {_, LvOld} -> LvOld + 1
         end,
    case data_mount_spirit:get(CurType, Lv) of
        [] -> 0;
        Base ->
            {_, Count} = get_count(Base#base_mount_spirit.goods_id, Mount#st_mount.spirit),
            if Count < Base#base_mount_spirit.goods_num -> 0;
                Base#base_mount_spirit.stage > Mount#st_mount.stage -> 0;
                true -> 1
            end
    end.

get_count(GoodsId, Default) ->
    Goods = data_goods:get(GoodsId),
    case Goods#goods_type.subtype of
        ?GOODS_SUBTYPE_MOUNT_SPIRIT ->
            {Goods#goods_type.subtype, Default};
        _ ->
            {Goods#goods_type.subtype, goods_util:get_goods_count(GoodsId)}
    end.

log_mount_spirit(Pkey, Nickname, Type, Lv) ->
    Sql = io_lib:format("insert into log_mount_spirit set pkey=~p,nickname='~s',`type`=~p,lv=~p,time=~p", [Pkey, Nickname, Type, Lv, util:unixtime()]),
    log_proc:log(Sql).