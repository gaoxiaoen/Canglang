%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 七月 2017 17:07
%%%-------------------------------------------------------------------
-module(jade_load).
-author("hxming").


-include("common.hrl").
-include("jade.hrl").


%% API
-compile(export_all).

load(Pkey) ->
    Sql = io_lib:format("select stage,exp,bless_cd,jade_id,skill_list,equip_list,grow_num,spirit_list,last_spirit,spirit from jade where pkey=~p", [Pkey]),
    db:get_row(Sql).

load_view(Pkey) ->
    Sql = io_lib:format("select stage,cbp,attribute,skill_list,equip_list,grow_num from jade  where pkey =~p", [Pkey]),
    db:get_row(Sql).


replace(GoldenBody) ->
    Sql = io_lib:format("replace into jade set pkey=~p,stage=~p,exp=~p,bless_cd=~p,jade_id=~p,skill_list='~s',equip_list='~s',grow_num=~p,cbp=~p,attribute='~s',spirit_list='~s',last_spirit=~p,spirit=~p",
        [GoldenBody#st_jade.pkey,
            GoldenBody#st_jade.stage,
            GoldenBody#st_jade.exp,
            GoldenBody#st_jade.bless_cd,
            GoldenBody#st_jade.jade_id,
            util:term_to_bitstring(GoldenBody#st_jade.skill_list),
            util:term_to_bitstring(GoldenBody#st_jade.equip_list),
            GoldenBody#st_jade.grow_num,
            GoldenBody#st_jade.cbp,
            util:term_to_bitstring(attribute_util:make_attribute_to_key_val(GoldenBody#st_jade.attribute)),
            util:term_to_bitstring(GoldenBody#st_jade.spirit_list),
            GoldenBody#st_jade.last_spirit,
            GoldenBody#st_jade.spirit
        ]),
    db:execute(Sql).