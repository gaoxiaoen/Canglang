%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 七月 2017 17:07
%%%-------------------------------------------------------------------
-module(god_treasure_load).
-author("hxming").


-include("common.hrl").
-include("god_treasure.hrl").


%% API
-compile(export_all).

load(Pkey) ->
    Sql = io_lib:format("select stage,exp,bless_cd,god_treasure_id,skill_list,equip_list,grow_num,spirit_list,last_spirit,spirit from god_treasure where pkey=~p", [Pkey]),
    db:get_row(Sql).

load_view(Pkey) ->
    Sql = io_lib:format("select stage,cbp,attribute,skill_list,equip_list,grow_num from god_treasure  where pkey =~p", [Pkey]),
    db:get_row(Sql).


replace(GoldenBody) ->
    Sql = io_lib:format("replace into god_treasure set pkey=~p,stage=~p,exp=~p,bless_cd=~p,god_treasure_id=~p,skill_list='~s',equip_list='~s',grow_num=~p,cbp=~p,attribute='~s',spirit_list='~s',last_spirit=~p,spirit=~p",
        [GoldenBody#st_god_treasure.pkey,
            GoldenBody#st_god_treasure.stage,
            GoldenBody#st_god_treasure.exp,
            GoldenBody#st_god_treasure.bless_cd,
            GoldenBody#st_god_treasure.god_treasure_id,
            util:term_to_bitstring(GoldenBody#st_god_treasure.skill_list),
            util:term_to_bitstring(GoldenBody#st_god_treasure.equip_list),
            GoldenBody#st_god_treasure.grow_num,
            GoldenBody#st_god_treasure.cbp,
            util:term_to_bitstring(attribute_util:make_attribute_to_key_val(GoldenBody#st_god_treasure.attribute)),
            util:term_to_bitstring(GoldenBody#st_god_treasure.spirit_list),
            GoldenBody#st_god_treasure.last_spirit,
            GoldenBody#st_god_treasure.spirit
        ]),
    db:execute(Sql).