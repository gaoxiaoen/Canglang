%%%-------------------------------------------------------------------
%%% @author lzx
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 八月 2017 16:37
%%%-------------------------------------------------------------------
-module(baby_load).
-author("lzx").
-include("baby.hrl").
-include("server.hrl").

%% API
-export([
    load_baby/1,
    load_born_time/1,
    replace_baby/1
]).

%% 加载宝宝数据
load_baby(PKey) ->
    Sql = io_lib:format("select type_id,name,figure,figure_list,step,step_exp,lv,lv_exp,state,time,skill,equip_list from baby where pkey=~p limit 1", [PKey]),
    db:get_row(Sql).


load_born_time(Pkey) ->
    Sql = io_lib:format("select time from baby where pkey=~p", [Pkey]),
    case db:get_one(Sql) of
        null -> 0;
        Time -> Time
    end.

replace_baby(StBaby) ->
    Sql = io_lib:format("replace into baby set pkey=~p,type_id=~p,name='~s',figure=~p,figure_list = '~s',step=~p,step_exp=~p,lv=~p,lv_exp=~p,state=~p,skill='~s',equip_list = '~s',time = ~p,cbp = ~p,attribute='~s'",
        [
            StBaby#baby_st.pkey,
            StBaby#baby_st.type_id,
            StBaby#baby_st.name,
            StBaby#baby_st.figure_id,
            util:term_to_bitstring(StBaby#baby_st.figure_list),
            StBaby#baby_st.step,
            StBaby#baby_st.step_exp,
            StBaby#baby_st.lv,
            StBaby#baby_st.lv_exp,
            StBaby#baby_st.state,
            util:term_to_bitstring(StBaby#baby_st.skill_list),
            util:term_to_bitstring(StBaby#baby_st.equip_list),
            StBaby#baby_st.born_time,
            StBaby#baby_st.cbp,
            util:term_to_bitstring(attribute_util:make_attribute_to_key_val(StBaby#baby_st.attribute))
        ]
    ),
    db:execute(Sql).


