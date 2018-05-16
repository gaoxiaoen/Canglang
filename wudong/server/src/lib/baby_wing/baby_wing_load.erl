%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 8月 2017 10:00
%%%-------------------------------------------------------------------

-module(baby_wing_load).

-include("server.hrl").
-include("common.hrl").
-include("baby_wing.hrl").
%% ====================================================================
%% API functions
%% ====================================================================
-export([load_wing/1,
    load_view/1,
    replace_wing/1]).

load_wing(Pkey) ->
    SQL = io_lib:format("select stage,exp,bless_cd,current_image_id,own_special_image,star_list,skill_list,equip_list,grow_num ,spirit_list,last_spirit,spirit from baby_wing where pkey=~p ", [Pkey]),
    db:get_row(SQL).

load_view(Pkey) ->
    Sql = io_lib:format("select stage,cbp,attribute,skill_list,equip_list,grow_num from baby_wing  where pkey =~p", [Pkey]),
    db:get_row(Sql).

replace_wing(Wing) ->
    #st_baby_wing{
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
        spirit = Spirit
    } = Wing,
    StarListBin = util:term_to_bitstring(StarList),
    OwnSpecialImageBin = util:term_to_bitstring(OwnSpecialImage),
    SkillListBin = util:term_to_bitstring(SkillList),
    EquipListBin = util:term_to_bitstring(EquipList),
    AttributeBin = util:term_to_bitstring(attribute_util:make_attribute_to_key_val(Attribute)),
    SpiritListBin = util:term_to_bitstring(SpiritList),
    SQL = io_lib:format("replace into baby_wing (pkey ,stage,exp,bless_cd,current_image_id,own_special_image,star_list,skill_list,equip_list,grow_num,cbp,attribute,spirit_list,last_spirit,spirit) values
		(~p,~p,~p,~p,~p,'~s','~s','~s','~s',~p,~p,'~s','~s',~p,~p)",
        [Pkey, Stage, Exp, BlessCd, CurrentImageId, OwnSpecialImageBin, StarListBin, SkillListBin, EquipListBin, GrowNum, Cbp, AttributeBin, SpiritListBin, LastSpirit,Spirit]),
    db:execute(SQL).
