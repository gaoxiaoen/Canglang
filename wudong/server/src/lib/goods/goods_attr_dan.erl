%%%-------------------------------------------------------------------
%%% @author and_me
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 五月 2016 10:25
%%%-------------------------------------------------------------------
-module(goods_attr_dan).
-author("and_me").
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("wing.hrl").
-include("mount.hrl").
-include("magic_weapon.hrl").
-include("light_weapon.hrl").
-include("pet_weapon.hrl").
-include("baby_wing.hrl").
-include("achieve.hrl").
-include("footprint_new.hrl").
-include("cat.hrl").
-include("golden_body.hrl").
-include("jade.hrl").
-include("baby_mount.hrl").
-include("baby_weapon.hrl").
-include("god_treasure.hrl").

-record(st_dan, {
    is_change = 0,
    dan_list = 0,
    attribute = #attribute{}
}).


%% API
%% API
-export([init/1,
    get_attr/0,
    use_goods_check/3,
    use_goods_add_attr/3,
    save/1,
    get_goods_num_info/1,
    get_dan_attr/1,
    calc_dan_attr_by_type/1,
    recalc_dan_attr/0
]).

-export([get_dan_list_by_type/2]).


save(Player) ->
    StDan = lib_dict:get(?PROC_STATUS_ATTR_DAN),
    if
        StDan#st_dan.is_change == 1 ->
            Sql = io_lib:format("replace into attr_dan set attr_dan = '~s',pkey =~p", [util:term_to_bitstring(StDan#st_dan.dan_list), Player#player.key]),
            db:execute(Sql);
        true ->
            skip
    end.

get_attr() ->
    StDan = lib_dict:get(?PROC_STATUS_ATTR_DAN),
    StDan#st_dan.attribute.

init(Player) ->
    case player_util:is_new_role(Player) of
        true ->
            StDan = #st_dan{dan_list = []};
        _ ->
            case load(Player#player.key) of
                [] ->
                    DanList = [];
                [DanListBin] ->
                    DanList = util:bitstring_to_term(DanListBin)
            end,
            StDan = #st_dan{dan_list = DanList}
    end,
    NewStDan = calc_dan_attr(StDan),
    lib_dict:put(?PROC_STATUS_ATTR_DAN, NewStDan),
    Player#player{attr_dan = NewStDan#st_dan.dan_list}.

load(Pkey) ->
    Sql = io_lib:format(<<"select attr_dan from attr_dan where pkey = ~p">>, [Pkey]),
    db:get_row(Sql).

get_dan_list_by_type(Pkey, Type) ->
    Key = {arrt_dan_view, Pkey},
    case cache:get(Key) of
        [] ->
            case load(Pkey) of
                [] ->
                    cache:set(Key, [], ?FIFTEEN_MIN_SECONDS),
                    [];
                [DanListBin] ->
                    DanList = util:bitstring_to_term(DanListBin),
                    cache:set(Key, DanList, ?FIFTEEN_MIN_SECONDS),
                    filter_attr_dan(DanList, Type)
            end;
        DanList ->
            filter_attr_dan(DanList, Type)
    end.

filter_attr_dan(DanList, Type) ->
    F = fun({GoodsId, Num}) ->
        case data_attr_dan:get(GoodsId) of
            [] -> [];
            Base ->
                if Base#base_attr_dan.type == Type ->
                    [[GoodsId, Num]];
                    true -> []
                end
        end
    end,
    lists:flatmap(F, DanList).

get_dan_attr(Type) ->
    StDan = lib_dict:get(?PROC_STATUS_ATTR_DAN),
    Fun = fun({GoodsId, Num}, AttrOut) ->
        case data_attr_dan:get(GoodsId) of
            BaseAttrDan when is_record(BaseAttrDan, base_attr_dan) andalso BaseAttrDan#base_attr_dan.type =:= Type ->
                List = [{K, V * Num} || {K, V} <- BaseAttrDan#base_attr_dan.attr_list],
                attribute_util:sum_attribute([AttrOut, attribute_util:make_attribute_by_key_val_list(List)]);
            _ ->
                AttrOut
        end
    end,
    lists:foldl(Fun, #attribute{}, StDan#st_dan.dan_list).

recalc_dan_attr() ->
    StDan = lib_dict:get(?PROC_STATUS_ATTR_DAN),
    NewStDan = calc_dan_attr(StDan),
    lib_dict:put(?PROC_STATUS_ATTR_DAN, NewStDan),
    ok.

calc_dan_attr(StDan) ->
    Fun = fun({GoodsId, Num}, AttrOut) ->
        case data_attr_dan:get(GoodsId) of
            [] ->
                AttrOut;
            BaseAttrDan ->
                List = [{K, V * Num} || {K, V} <- BaseAttrDan#base_attr_dan.attr_list],
                attribute_util:sum_attribute([AttrOut, attribute_util:make_attribute_by_key_val_list(List)])
        end
    end,
    SumAttr = lists:foldl(Fun, #attribute{}, StDan#st_dan.dan_list),
    StDan#st_dan{attribute = SumAttr}.

%%根据类型获取丹属性
calc_dan_attr_by_type(Type) ->
    StDan = lib_dict:get(?PROC_STATUS_ATTR_DAN),
    F = fun({GoodsId, Num}) ->
        case data_attr_dan:get(GoodsId) of
            [] -> [];
            BaseAttrDan ->
                if BaseAttrDan#base_attr_dan.type == Type ->
                    [{K, V * Num} || {K, V} <- BaseAttrDan#base_attr_dan.attr_list];
                    true -> []
                end
        end
    end,
    AttrList = lists:flatmap(F, StDan#st_dan.dan_list),
    attribute_util:make_attribute_by_key_val_list(AttrList).

use_goods_check(GoodsId, Add_Num, _Player) ->
    StDan = lib_dict:get(?PROC_STATUS_ATTR_DAN),
    BaseAttrDan = data_attr_dan:get(GoodsId),
    ?ASSERT(BaseAttrDan =/= [], {false, 0}),
    if
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_MOUNT ->
            Mount = mount_util:get_mount(),
            Step = Mount#st_mount.stage;
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_WING ->
            WingSt = lib_dict:get(?PROC_STATUS_WING),
            Step = WingSt#st_wing.stage;
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_MAGIC_WEAPON ->
            MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
            Step = MagicWeapon#st_magic_weapon.stage;
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_LIGHT_WEAPON ->
            LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
            Step = LightWeapon#st_light_weapon.stage;
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_PET_WEAPON ->
            PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
            Step = PetWeapon#st_pet_weapon.stage;
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_FOOTPRINT ->
            Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
            Step = Footprint#st_footprint.stage;
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_CAT ->
            Cat = lib_dict:get(?PROC_STATUS_CAT),
            Step = Cat#st_cat.stage;
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_GOLDEN_BODY ->
            GoldenBody = lib_dict:get(?PROC_STATUS_GOLDEN_BODY),
            Step = GoldenBody#st_golden_body.stage;
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_GOD_TREASURE ->
            GodsTreasure = lib_dict:get(?PROC_STATUS_GOD_TREASURE),
            Step = GodsTreasure#st_god_treasure.stage;
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_JADE ->
            GoldenBody = lib_dict:get(?PROC_STATUS_JADE),
            Step = GoldenBody#st_jade.stage;
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_BABY_WING ->
            Step = baby_wing:get_stage();
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_BABY_MOUNT ->
            BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
            Step = BabyMount#st_baby_mount.stage;
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_LIGHT_WEAPON ->
            BabyWeapon = lib_dict:get(?PROC_STATUS_BABY_WEAPON),
            Step = BabyWeapon#st_baby_weapon.stage;
        true ->
            ?DEBUG(" ~p~n", [BaseAttrDan#base_attr_dan.type]),
            Step = 0

    end,
    case lists:keyfind(GoodsId, 1, StDan#st_dan.dan_list) of
        {GoodsId, Num} ->
            HaveAdd = Num;
        _ ->
            HaveAdd = 0
    end,
    case lists:keyfind(Step, 1, BaseAttrDan#base_attr_dan.stage_max_num) of
        false ->
            MaxNum = 50;
        {_, N} ->
            MaxNum = N
    end,
    if
        BaseAttrDan#base_attr_dan.step_lim > Step ->
            throw({false, 30});
        HaveAdd < MaxNum ->
            ?IF_ELSE(MaxNum - HaveAdd > Add_Num, Add_Num, MaxNum - HaveAdd);
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_MAGIC_WEAPON ->
            throw({false, 26});
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_LIGHT_WEAPON ->
            throw({false, 26});
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_WING ->
            throw({false, 25});
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_MOUNT ->
            throw({false, 24});
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_PET_WEAPON ->
            throw({false, 26});
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_FOOTPRINT ->
            throw({false, 26});
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_CAT ->
            throw({false, 26});
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_GOLDEN_BODY ->
            throw({false, 26});
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_GOD_TREASURE ->
            throw({false, 26});
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_JADE ->
            throw({false, 26});
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_BABY_WING ->
            throw({false, 26});
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_BABY_MOUNT ->
            throw({false, 26});
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_BABY_WEAPON ->
            throw({false, 26});
        true ->
            throw({false, 0})
    end.


use_goods_add_attr(GoodsId, Add_Num, Player) ->
    StDan = lib_dict:get(?PROC_STATUS_ATTR_DAN),
    case lists:keytake(GoodsId, 1, StDan#st_dan.dan_list) of
        false ->
            NewDanList = [{GoodsId, Add_Num} | StDan#st_dan.dan_list];
        {value, {GoodsId, Num}, L} ->
            NewDanList = [{GoodsId, Add_Num + Num} | L]
    end,
    StDan1 = StDan#st_dan{is_change = 1, dan_list = NewDanList},
    NewStDan = calc_dan_attr(StDan1),
    lib_dict:put(?PROC_STATUS_ATTR_DAN, NewStDan),
    update_attr_dan(GoodsId, Player),
    NewPlayer = player_util:count_player_attribute(Player, true),
    pack_info_send(Player, NewDanList),

    BaseAttrDan = data_attr_dan:get(GoodsId),
    if
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_WING ->
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1015, 0, Add_Num);
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_LIGHT_WEAPON ->
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1018, 0, Add_Num);
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_MOUNT ->
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1021, 0, Add_Num);
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_MAGIC_WEAPON ->
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1024, 0, Add_Num);
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_PET_WEAPON ->
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1027, 0, Add_Num);
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_FOOTPRINT ->
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1030, 0, Add_Num);
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_CAT ->
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1033, 0, Add_Num);
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_GOLDEN_BODY ->
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1036, 0, Add_Num);
%%         BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_GOD_TREASURE ->
%%             achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1036, 0, Add_Num);
%%         BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_JADE ->
%%             achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1036, 0, Add_Num);
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_BABY_WING ->
            ok;
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_BABY_MOUNT ->
            ok;
        BaseAttrDan#base_attr_dan.type == ?GOODS_DAN_TYPE_BABY_WEAPON ->
            ok;
        true ->
            ok
    end,
    {ok, NewPlayer}.

pack_info_send(Player, DanList) ->
    List = [[K, V] || {K, V} <- DanList],
    {ok, Bin} = pt_130:write(13016, {List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

get_goods_num_info(Player) ->
    StDan = lib_dict:get(?PROC_STATUS_ATTR_DAN),
    pack_info_send(Player, StDan#st_dan.dan_list).

update_attr_dan(GoodsId, Player) ->
    Type = case data_attr_dan:get(GoodsId) of
               [] ->
                   false;
               BaseAttrDan ->
                   BaseAttrDan#base_attr_dan.type
           end,
    case Type of
        ?GOODS_DAN_TYPE_MOUNT ->
            Mount = mount_util:get_mount(),
            NewMount1 = mount_attr:calc_mount_attr(Mount),
            mount_util:put_mount(NewMount1),
            mount_pack:send_mount_info(NewMount1, Player);
        ?GOODS_DAN_TYPE_WING ->
            WingSt = lib_dict:get(?PROC_STATUS_WING),
            NewWing = wing_attr:calc_wing_attr(WingSt),
            lib_dict:put(?PROC_STATUS_WING, NewWing),
            wing_pack:send_wing_info(NewWing, Player);
        ?GOODS_DAN_TYPE_BABY_WING ->
            WingSt = lib_dict:get(?PROC_STATUS_BABY_WING),
            NewWing = baby_wing_attr:calc_wing_attr(WingSt),
            lib_dict:put(?PROC_STATUS_BABY_WING, NewWing),
            baby_wing_pack:send_wing_info(NewWing, Player);
        ?GOODS_DAN_TYPE_MAGIC_WEAPON ->
            MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
            NewMagicWeapon = magic_weapon_init:calc_attribute(MagicWeapon),
            lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, NewMagicWeapon),
            Data = magic_weapon:get_magic_weapon_info(),
            {ok, Bin} = pt_155:write(15501, Data),
            server_send:send_to_sid(Player#player.sid, Bin);
        ?GOODS_DAN_TYPE_LIGHT_WEAPON ->
            LightWepon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
            NewLightWepon = light_weapon_init:calc_attribute(LightWepon),
            lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWepon),
            Data = light_weapon:get_light_weapon_info(),
            {ok, Bin} = pt_350:write(35001, Data),
            server_send:send_to_sid(Player#player.sid, Bin);
        ?GOODS_DAN_TYPE_PET_WEAPON ->
            PetWepon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
            NewPetWepon = pet_weapon_init:calc_attribute(PetWepon),
            lib_dict:put(?PROC_STATUS_PET_WEAPON, NewPetWepon),
            Data = pet_weapon:get_pet_weapon_info(),
            {ok, Bin} = pt_158:write(15801, Data),
            server_send:send_to_sid(Player#player.sid, Bin);
        ?GOODS_DAN_TYPE_FOOTPRINT ->
            Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
            NewFootprint = footprint_init:calc_attribute(Footprint),
            lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint),
            Data = footprint:get_footprint_info(),
            {ok, Bin} = pt_331:write(33101, Data),
            server_send:send_to_sid(Player#player.sid, Bin);
        ?GOODS_DAN_TYPE_CAT ->
            Cat = lib_dict:get(?PROC_STATUS_CAT),
            NewCat = cat_init:calc_attribute(Cat),
            lib_dict:put(?PROC_STATUS_CAT, NewCat),
            Data = cat:get_cat_info(),
            {ok, Bin} = pt_161:write(16101, Data),
            server_send:send_to_sid(Player#player.sid, Bin);
        ?GOODS_DAN_TYPE_GOLDEN_BODY ->
            GoldenBody = lib_dict:get(?PROC_STATUS_GOLDEN_BODY),
            NewGoldenBody = golden_body_init:calc_attribute(GoldenBody),
            lib_dict:put(?PROC_STATUS_GOLDEN_BODY, NewGoldenBody),
            Data = golden_body:get_golden_body_info(),
            {ok, Bin} = pt_162:write(16201, Data),
            server_send:send_to_sid(Player#player.sid, Bin);
        ?GOODS_DAN_TYPE_GOD_TREASURE ->
            GodTreasure = lib_dict:get(?PROC_STATUS_GOD_TREASURE),
            NewGodTreasure = god_treasure_init:calc_attribute(GodTreasure),
            lib_dict:put(?PROC_STATUS_GOD_TREASURE, NewGodTreasure),
            Data = god_treasure:get_god_treasure_info(),
            {ok, Bin} = pt_653:write(65301, Data),
            server_send:send_to_sid(Player#player.sid, Bin);
        ?GOODS_DAN_TYPE_JADE ->
            GoldenBody = lib_dict:get(?PROC_STATUS_JADE),
            NewGoldenBody = jade_init:calc_attribute(GoldenBody),
            lib_dict:put(?PROC_STATUS_JADE, NewGoldenBody),
            Data = jade:get_jade_info(),
            {ok, Bin} = pt_652:write(65201, Data),
            server_send:send_to_sid(Player#player.sid, Bin);
        ?GOODS_DAN_TYPE_BABY_MOUNT ->
            BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
            NewBabyMount = baby_mount_init:calc_attribute(BabyMount),
            lib_dict:put(?PROC_STATUS_BABY_MOUNT, NewBabyMount),
            Data = baby_mount:get_baby_mount_info(),
            {ok, Bin} = pt_171:write(17101, Data),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        ?GOODS_DAN_TYPE_BABY_WEAPON ->
            BabyWeapon = lib_dict:get(?PROC_STATUS_BABY_WEAPON),
            NewBabyWeapon = baby_weapon_init:calc_attribute(BabyWeapon),
            lib_dict:put(?PROC_STATUS_BABY_WEAPON, NewBabyWeapon),
            Data = baby_weapon:get_baby_weapon_info(),
            {ok, Bin} = pt_351:write(35101, Data),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        _ ->
            ?ERR("Can't find the type : ~p~n", [Type])
    end,
    ok.
