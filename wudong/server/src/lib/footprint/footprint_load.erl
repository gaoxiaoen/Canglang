%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 15:15
%%%-------------------------------------------------------------------
-module(footprint_load).
-author("hxming").


-include("footprint_new.hrl").
%% API
-compile(export_all).

load(Pkey) ->
        Sql = io_lib:format("select stage,exp,bless_cd,footprint_id,skill_list,equip_list,grow_num ,spirit_list,last_spirit,spirit from footprint where pkey=~p", [Pkey]),
    db:get_row(Sql).

load_view(Pkey) ->
    Sql = io_lib:format("select stage,cbp,attribute,skill_list,equip_list,grow_num from footprint  where pkey =~p", [Pkey]),
    db:get_row(Sql).

replace(Footprint) ->
    Sql = io_lib:format("replace into footprint set pkey=~p,stage=~p,exp=~p,bless_cd=~p,footprint_id=~p,skill_list='~s',equip_list='~s',grow_num=~p,cbp=~p,attribute='~s',spirit_list='~s',last_spirit=~p,spirit=~p",
        [Footprint#st_footprint.pkey,
            Footprint#st_footprint.stage,
            Footprint#st_footprint.exp,
            Footprint#st_footprint.bless_cd,
            Footprint#st_footprint.footprint_id,
            util:term_to_bitstring(Footprint#st_footprint.skill_list),
            util:term_to_bitstring(Footprint#st_footprint.equip_list),
            Footprint#st_footprint.grow_num,
            Footprint#st_footprint.cbp,
            util:term_to_bitstring(attribute_util:make_attribute_to_key_val(Footprint#st_footprint.attribute)),
            util:term_to_bitstring(Footprint#st_footprint.spirit_list),
            Footprint#st_footprint.last_spirit,
            Footprint#st_footprint.spirit
        ]),
    db:execute(Sql).