%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 九月 2017 13:49
%%%-------------------------------------------------------------------
-module(baby_mount_load).
-author("hxming").

-include("common.hrl").
-include("baby_mount.hrl").


%% API
-compile(export_all).

load(Pkey) ->
    Sql = io_lib:format("select stage,exp,bless_cd,baby_mount_id,skill_list,equip_list,grow_num,spirit_list,last_spirit,spirit from baby_mount where pkey=~p", [Pkey]),
    db:get_row(Sql).

load_view(Pkey) ->
    Sql = io_lib:format("select stage,cbp,attribute,skill_list,equip_list,grow_num from baby_mount  where pkey =~p", [Pkey]),
    db:get_row(Sql).


replace(BabyMount) ->
    Sql = io_lib:format("replace into baby_mount set pkey=~p,stage=~p,exp=~p,bless_cd=~p,baby_mount_id=~p,skill_list='~s',equip_list='~s',grow_num=~p,cbp=~p,attribute='~s',spirit_list='~s',last_spirit=~p,spirit=~p",
        [BabyMount#st_baby_mount.pkey,
            BabyMount#st_baby_mount.stage,
            BabyMount#st_baby_mount.exp,
            BabyMount#st_baby_mount.bless_cd,
            BabyMount#st_baby_mount.baby_mount_id,
            util:term_to_bitstring(BabyMount#st_baby_mount.skill_list),
            util:term_to_bitstring(BabyMount#st_baby_mount.equip_list),
            BabyMount#st_baby_mount.grow_num,
            BabyMount#st_baby_mount.cbp,
            util:term_to_bitstring(attribute_util:make_attribute_to_key_val(BabyMount#st_baby_mount.attribute)),
            util:term_to_bitstring(BabyMount#st_baby_mount.spirit_list),
            BabyMount#st_baby_mount.last_spirit,
            BabyMount#st_baby_mount.spirit
        ]),
    db:execute(Sql).