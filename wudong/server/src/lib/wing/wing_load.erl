%% @author and_me
%% @doc @todo Add description to wing_load.


-module(wing_load).

-include("server.hrl").
-include("common.hrl").
-include("wing.hrl").
%% ====================================================================
%% API functions
%% ====================================================================
-export([load_wing/1,
    load_view/1,
    replace_wing/1]).

load_wing(Pkey) ->
    SQL = io_lib:format("select stage,exp,bless_cd,current_image_id,own_special_image,star_list,skill_list,equip_list,grow_num ,spirit_list,last_spirit,spirit,activation_list from wing where pkey=~p ", [Pkey]),
    db:get_row(SQL).

load_view(Pkey) ->
    Sql = io_lib:format("select stage,cbp,attribute,skill_list,equip_list,grow_num from wing  where pkey =~p", [Pkey]),
    db:get_row(Sql).

replace_wing(Wing) ->
    #st_wing{
        pkey = Pkey,
        stage = Stage,
        exp = Exp,
        bless_cd = BlessCd,
        current_image_id = CurrentImageId,
        own_special_image = OwnSpecialImage,
        star_list = StarList,
        skill_list = SkillList,
        equip_list = EquipList,
        grow_num = GrowNum,
        wing_attribute = Attribute,
        cbp = Cbp,
        spirit_list = SpiritList,
        last_spirit = LastSpirit,
        activation_list = ActivationList,
        spirit = Spirit
    } = Wing,
    StarListBin = util:term_to_bitstring(StarList),
    OwnSpecialImageBin = util:term_to_bitstring(OwnSpecialImage),
    SkillListBin = util:term_to_bitstring(SkillList),
    EquipListBin = util:term_to_bitstring(EquipList),
    ActivationListBin = util:term_to_bitstring(ActivationList),
    AttributeBin = util:term_to_bitstring(attribute_util:make_attribute_to_key_val(Attribute)),
    SpiritListBin = util:term_to_bitstring(SpiritList),
    SQL = io_lib:format("replace into wing (pkey ,stage,exp,bless_cd,current_image_id,own_special_image,star_list,skill_list,equip_list,grow_num,cbp,attribute,spirit_list,last_spirit,spirit,activation_list) values
		(~p,~p,~p,~p,~p,'~s','~s','~s','~s',~p,~p,'~s','~s',~p,~p,'~s')",
        [Pkey, Stage, Exp, BlessCd, CurrentImageId, OwnSpecialImageBin, StarListBin, SkillListBin, EquipListBin, GrowNum, Cbp, AttributeBin, SpiritListBin, LastSpirit, Spirit, ActivationListBin]),
    db:execute(SQL).
