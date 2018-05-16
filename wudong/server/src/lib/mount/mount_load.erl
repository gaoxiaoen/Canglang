%% @author and_me
%% @doc @todo Add description to mount_load.


-module(mount_load).

-include("server.hrl").
-include("common.hrl").
-include("mount.hrl").
%% ====================================================================
%% API functions
%% ====================================================================
-export([load_mount/1, load_view/1, replace_mount/1]).


load_mount(Pkey) ->
    Sql = io_lib:format("select stage,exp,bless_cd,current_image_id,current_sword_id,own_special_image,star_list,skill_list,equip_list,grow_num,spirit_list,last_spirit,old_current_image_id,spirit,activation_list from mount  where pkey =~p", [Pkey]),
    db:get_row(Sql).

load_view(Pkey) ->
    Sql = io_lib:format("select stage,cbp,attribute,skill_list,equip_list,grow_num from mount  where pkey =~p", [Pkey]),
    db:get_row(Sql).

replace_mount(Mount) ->
    #st_mount{
        pkey = Pkey,
        stage = Stage,
        exp = Exp,
        bless_cd = BlessCd,
        star_list = StarList,
        current_image_id = CurrentImageId,
        current_sword_id = CurrentSwordId,
        own_special_image = OwnSpecialImage,
        skill_list = SkillList,
        equip_list = EquipList,
        grow_num = GrowNum,
        mount_attribute = Attribute,
        cbp = Cbp,
        spirit_list = SpiritList,
        last_spirit = LastSpirit,
        activation_list  = ActivationList,
        old_current_image_id = OldCurrentImageId,
        spirit = Spirit
    } = Mount,
    OwnSpecialImageBin = util:term_to_bitstring(OwnSpecialImage),
    StarListBin = util:term_to_bitstring(StarList),
    ActivationListBin = util:term_to_bitstring(ActivationList),
    SkillListBin = util:term_to_bitstring(SkillList),
    EquipListBin = util:term_to_bitstring(EquipList),
    AttributeBin = util:term_to_bitstring(attribute_util:make_attribute_to_key_val(Attribute)),
    SpiritListBin = util:term_to_bitstring(SpiritList),
    SQL = io_lib:format("replace into mount (pkey, stage,exp,bless_cd,current_image_id,current_sword_id,own_special_image,star_list,skill_list,equip_list,grow_num,cbp,attribute,spirit_list,last_spirit,old_current_image_id,spirit,activation_list) values
    (~p,~p,~p,~p,~p,~p,'~s','~s','~s','~s',~p,~p,'~s','~s',~p,~p,~p,'~s')",
        [Pkey, Stage, Exp, BlessCd, CurrentImageId, CurrentSwordId, OwnSpecialImageBin, StarListBin, SkillListBin, EquipListBin, GrowNum, Cbp, AttributeBin, SpiritListBin, LastSpirit, OldCurrentImageId,Spirit,ActivationListBin]),
    db:execute(SQL).

