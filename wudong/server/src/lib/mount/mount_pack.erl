%% @author and_me
%% @doc @todo Add description to mount_pack.


-module(mount_pack).
-include("common.hrl").
-include("server.hrl").
-include("mount.hrl").
-include("goods.hrl").
-include("error_code.hrl").
-include("daily.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([send_mount_info/2, view_other/1]).

send_mount_info(Mount, Player) ->
    Now = util:unixtime(),
    F = fun({Id, Time}) ->
        if Time == 0 -> [[Id, 0]];
            Now > Time -> [];
            true ->
                [[Id, Time - Now]]
        end
    end,
    ImageList = lists:flatmap(F, Mount#st_mount.own_special_image),
    StarList = [tuple_to_list(Star) || Star <- Mount#st_mount.star_list],
    Cd = max(0, Mount#st_mount.bless_cd - Now),
    SkillList = mount_skill:get_mount_skill_list(Mount#st_mount.skill_list),
    AttributeList = attribute_util:pack_attr(Mount#st_mount.mount_attribute),
    EquipList = [[SubType, EquipId] || {SubType, EquipId, _} <- Mount#st_mount.equip_list],
    SpiritState = mount_spirit:check_spirit_state(Mount),
    {ok, Bin} = pt_170:write(17001, {Mount#st_mount.stage, Mount#st_mount.exp, Cd, Mount#st_mount.current_image_id, Mount#st_mount.old_current_image_id, Mount#st_mount.cbp,
        Mount#st_mount.grow_num, AttributeList, ImageList, StarList, SkillList, EquipList, SpiritState}),
    server_send:send_to_sid(Player#player.sid, Bin).

%%查看其它玩家坐骑信息
view_other(Pkey) ->
    Key = {mount_view, Pkey},
    case cache:get(Key) of
        [] ->
            case mount_load:load_view(Pkey) of
                [] -> {0, 0, [], [], [], 0, []};
            %%stage,cbp,attribute,skill_list,equip_list,grow_num
                [Stage, Cbp, AttributeList, SkillList, EquipList, GrowNum] ->
                    NewAttributeList = attribute_util:pack_attr(util:bitstring_to_term(AttributeList)),
                    NewSkillList = mount_skill:get_mount_skill_list(util:bitstring_to_term(SkillList)),
                    NewEquipList = [[SubType, EquipId] || {SubType, EquipId, _} <- util:bitstring_to_term(EquipList)],
                    DanList = goods_attr_dan:get_dan_list_by_type(Pkey, ?GOODS_DAN_TYPE_MOUNT),
                    Data = {Stage, Cbp, NewAttributeList, NewSkillList, NewEquipList, GrowNum, DanList},
                    cache:set(Key, Data, ?FIFTEEN_MIN_SECONDS),
                    Data
            end;
        Data -> Data
    end.
