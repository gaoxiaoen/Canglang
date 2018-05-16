%% @author and_me
%% @doc @todo Add description to mount_attr.


-module(mount_attr).
-include("common.hrl").
-include("mount.hrl").
-include("goods.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([calc_mount_attr/1, get_mount_attr/0, get_speed/1]).

-export([calc_spirit_attribute/1]).

calc_mount_attr(Mount) ->
    ?DEBUG("Mount ~n"),
    if
        Mount#st_mount.stage == 0 -> Mount;
        true ->
            StageAttr =
                case data_mount_stage:get(Mount#st_mount.stage) of
                    [] -> #attribute{};
                    BaseData ->
                        Percent = get_grow_dan(Mount),
                        ExpAttrs = player_util:calc_exp_attrs(Mount#st_mount.exp, BaseData#base_mount_stage.exp, BaseData#base_mount_stage.bless_attrs),
                        KevValList = [{Key, round(Val * (1 + Percent))} || {Key, Val} <- util:merge_kv(BaseData#base_mount_stage.attrs ++ ExpAttrs)],
                        attribute_util:make_attribute_by_key_val_list(KevValList)
                end,
            Now = util:unixtime(),
            StarAttr = lists:foldr(fun({MountId, Star}, AttrStar) ->
                case data_mount_star:get(MountId, Star) of
                    [] ->
                        AttrStar;
                    WingStar ->
                        SAttr = attribute_util:make_attribute_by_key_val_list(WingStar#base_mount_star.attr_list),
                        attribute_util:sum_attribute([AttrStar, SAttr])
                end end,
                #attribute{}, Mount#st_mount.star_list),
            Attr2 =
                lists:foldr(fun({MountId, Times}, AttrOut) ->
                    case data_mount:get(MountId) of
                        MountImage when (Times == 0 orelse Times > Now) andalso is_record(MountImage, base_mount) ->
                            Attr = attribute_util:make_attribute_by_key_val_list(MountImage#base_mount.add_attr),
                            attribute_util:sum_attribute([AttrOut, Attr]);
                        _ -> AttrOut
                    end
                end,
                    #attribute{}, Mount#st_mount.own_special_image),
            DanAttr = goods_attr_dan:calc_dan_attr_by_type(?GOODS_DAN_TYPE_MOUNT),
            EquipAttrList = lists:flatmap(
                fun({_, EquipId, _}) ->
                    case data_goods:get(EquipId) of
                        [] ->
                            [];
                        GoodsType ->
                            GoodsType#goods_type.attr_list
                    end
                end, Mount#st_mount.equip_list),
            EquipAttribute = attribute_util:make_attribute_by_key_val_list(EquipAttrList),
            SkillAttribute = mount_skill:calc_mount_skill_attribute(Mount#st_mount.skill_list),
            %%灵脉属性
            SpiritAttribute = calc_spirit_attribute(Mount#st_mount.spirit_list),
            %% 图鉴等级属性
            F = fun({MountId0, ActList}) ->
                F0 = fun(Lv) ->
                    case data_mount_star:get(MountId0, Lv) of
                        [] -> [];
                        #base_mount_star{lv_attr = LvAttr} ->
                            LvAttr
                    end
                end,
                lists:flatmap(F0, ActList)
            end,
            Attr3 = attribute_util:make_attribute_by_key_val_list( lists:flatmap(F, Mount#st_mount.activation_list)),
            SumAttribute = attribute_util:sum_attribute([StarAttr, StageAttr, Attr2, SkillAttribute, EquipAttribute, DanAttr, SpiritAttribute, Attr3]),
            Mount#st_mount{
                cbp = attribute_util:calc_combat_power(SumAttribute),
                mount_attribute = SumAttribute
            }
    end.

%%计算灵脉属性
calc_spirit_attribute(SpiritList) ->
    %%灵脉属性
    L1 = lists:flatmap(
        fun({SpiritId, SpiritLv}) ->
            case data_mount_spirit:get(SpiritId, SpiritLv) of
                [] -> [];
                BaseSpirit -> BaseSpirit#base_mount_spirit.attrs
            end
        end, SpiritList),
    L2 =
        case mount_spirit:calc_spirit_stage(SpiritList) of
            0 -> [];
            SpiritStage ->
                case [Val || Val <- data_mount_spirit_stage:stage_list(), SpiritStage >= Val] of
                    [] -> [];
                    SpiritStageList ->
                        data_mount_spirit_stage:get(lists:max(SpiritStageList))
                end
        end,
    attribute_util:make_attribute_by_key_val_list(L1 ++ L2).


get_grow_dan(Mount) ->
    case data_grow_dan:get(?GOODS_GROW_ID_MOUNT) of
        [] -> 0;
        Base ->
            Mount#st_mount.grow_num * Base#base_grow_dan.attr_percent
    end.

get_mount_attr() ->
    MountSt = lib_dict:get(?PROC_STATUS_MOUNT),
    MountSt#st_mount.mount_attribute.

get_speed(MoundId) ->
    data_mount:get_speed(MoundId).


%% ====================================================================
%% Internal functions
%% ====================================================================


