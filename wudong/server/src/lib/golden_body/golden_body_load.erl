%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 七月 2017 17:07
%%%-------------------------------------------------------------------
-module(golden_body_load).
-author("hxming").


-include("common.hrl").
-include("golden_body.hrl").


%% API
-compile(export_all).

load(Pkey) ->
    Sql = io_lib:format("select stage,exp,bless_cd,golden_body_id,skill_list,equip_list,grow_num,spirit_list,last_spirit,spirit from golden_body where pkey=~p", [Pkey]),
    db:get_row(Sql).

load_view(Pkey) ->
    Sql = io_lib:format("select stage,cbp,attribute,skill_list,equip_list,grow_num from golden_body  where pkey =~p", [Pkey]),
    db:get_row(Sql).


replace(GoldenBody) ->
    Sql = io_lib:format("replace into golden_body set pkey=~p,stage=~p,exp=~p,bless_cd=~p,golden_body_id=~p,skill_list='~s',equip_list='~s',grow_num=~p,cbp=~p,attribute='~s',spirit_list='~s',last_spirit=~p,spirit=~p",
        [GoldenBody#st_golden_body.pkey,
            GoldenBody#st_golden_body.stage,
            GoldenBody#st_golden_body.exp,
            GoldenBody#st_golden_body.bless_cd,
            GoldenBody#st_golden_body.golden_body_id,
            util:term_to_bitstring(GoldenBody#st_golden_body.skill_list),
            util:term_to_bitstring(GoldenBody#st_golden_body.equip_list),
            GoldenBody#st_golden_body.grow_num,
            GoldenBody#st_golden_body.cbp,
            util:term_to_bitstring(attribute_util:make_attribute_to_key_val(GoldenBody#st_golden_body.attribute)),
            util:term_to_bitstring(GoldenBody#st_golden_body.spirit_list),
            GoldenBody#st_golden_body.last_spirit,
            GoldenBody#st_golden_body.spirit
        ]),
    db:execute(Sql).