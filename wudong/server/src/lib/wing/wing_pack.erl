%% @author and_me
%% @doc @todo Add description to wing_pack.


-module(wing_pack).
-include("common.hrl").
-include("server.hrl").
-include("wing.hrl").
-include("goods.hrl").
-include("error_code.hrl").
-include("daily.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([send_wing_info/2, view_other/1]).


send_wing_info(Wing, Player) ->
    StageAttributeList =
        case data_wing_stage:get(Wing#st_wing.stage) of
            [] -> [];
            BaseData ->
                [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- BaseData#base_wing_stage.attrs]
        end,
    Now = util:unixtime(),
    F = fun({Id, Time}) ->
        if Time > Now -> [[Id, Time - Now]];
            Time == 0 -> [[Id, 0]];
            true -> []
        end
        end,
    WingList = lists:flatmap(F, Wing#st_wing.own_special_image),
    WingStarList = [[WingId, Star] || {WingId, Star} <- Wing#st_wing.star_list],
    Cd = max(0, Wing#st_wing.bless_cd - Now),
    SkillList = wing_skill:get_wing_skill_list(Wing#st_wing.skill_list),
    EquipList = [[SubType, EquipId] || {SubType, EquipId, _} <- Wing#st_wing.equip_list],
    AttributeList = attribute_util:pack_attr(Wing#st_wing.wing_attribute),
    SpiritState = wing_spirit:check_spirit_state(Wing),
    {ok, Bin} = pt_360:write(36001, {Wing#st_wing.stage, Wing#st_wing.exp, Cd, Wing#st_wing.current_image_id,
        Wing#st_wing.grow_num,
        StageAttributeList, WingList,
        WingStarList,
        AttributeList,
        [], Wing#st_wing.cbp, SkillList, EquipList,SpiritState}),
    server_send:send_to_sid(Player#player.sid, Bin).

view_other(Pkey) ->
    Key = {wing_view, Pkey},
    case cache:get(Key) of
        [] ->
            case wing_load:load_view(Pkey) of
                [] -> {0, 0, [], [], [], 0, []};
                %%stage,cbp,attribute,skill_list,equip_list,grow_num,spirit_list
                [Stage, Cbp, AttributeList, SkillList, EquipList, GrowNum] ->
                    NewAttributeList = attribute_util:pack_attr(util:bitstring_to_term(AttributeList)),
                    NewSkillList = wing_skill:get_wing_skill_list(util:bitstring_to_term(SkillList)),
                    NewEquipList = [[SubType, EquipId] || {SubType, EquipId, _} <- util:bitstring_to_term(EquipList)],
                    DanList = goods_attr_dan:get_dan_list_by_type(Pkey, ?GOODS_DAN_TYPE_WING),
                    Data = {Stage, Cbp, NewAttributeList, NewSkillList, NewEquipList, GrowNum, DanList},
                    cache:set(Key, Data, ?FIFTEEN_MIN_SECONDS),
                    Data
            end;
        Data -> Data
    end.
