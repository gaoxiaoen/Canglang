%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 六月 2017 17:06
%%%-------------------------------------------------------------------
-module(cat_load).
-author("hxming").

-include("common.hrl").
-include("cat.hrl").


%% API
-compile(export_all).

load(Pkey) ->
    Sql = io_lib:format("select stage,exp,bless_cd,cat_id,skill_list,equip_list,grow_num,spirit_list,last_spirit,spirit from cat where pkey=~p", [Pkey]),
    db:get_row(Sql).

load_view(Pkey) ->
    Sql = io_lib:format("select stage,cbp,attribute,skill_list,equip_list,grow_num from cat  where pkey =~p", [Pkey]),
    db:get_row(Sql).


replace(Cat) ->
    Sql = io_lib:format("replace into cat set pkey=~p,stage=~p,exp=~p,bless_cd=~p,cat_id=~p,skill_list='~s',equip_list='~s',grow_num=~p,cbp=~p,attribute='~s',spirit_list='~s',last_spirit=~p,spirit=~p",
        [Cat#st_cat.pkey,
            Cat#st_cat.stage,
            Cat#st_cat.exp,
            Cat#st_cat.bless_cd,
            Cat#st_cat.cat_id,
            util:term_to_bitstring(Cat#st_cat.skill_list),
            util:term_to_bitstring(Cat#st_cat.equip_list),
            Cat#st_cat.grow_num,
            Cat#st_cat.cbp,
            util:term_to_bitstring(attribute_util:make_attribute_to_key_val(Cat#st_cat.attribute)),
            util:term_to_bitstring(Cat#st_cat.spirit_list),
            Cat#st_cat.last_spirit,
            Cat#st_cat.spirit
        ]),
    db:execute(Sql).