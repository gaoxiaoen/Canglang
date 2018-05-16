%%%-------------------------------------------------------------------
%%% @author lzx
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(baby_log).
-author("lzx").
-include("common.hrl").
-include("baby.hrl").


%% API
-export([
    log_equip_goods/1,
    log_active_pic/1,
    log_change_figure/1,
    log_upgrade_skill/1,
    log_create_baby/1,
    log_change_sex/1,
    log_upgrade_lv/1,
    log_do_stage/1,
    log_change_name/1
]).



make_sql(StBaby,Opera) ->
    NowTime = util:unixtime(),
    io_lib:format("insert into log_baby_operator set pkey=~p,type_id=~p,name='~s',figure=~p,figure_list = '~s',step=~p,step_exp=~p,lv=~p,lv_exp=~p,skill='~s',equip = '~s',attribute='~s',cbp = ~p,oper = ~p,time = ~p",
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
            util:term_to_bitstring(StBaby#baby_st.skill_list),
            util:term_to_bitstring(StBaby#baby_st.equip_list),
            util:term_to_bitstring(attribute_util:make_attribute_to_key_val(StBaby#baby_st.attribute)),
            StBaby#baby_st.cbp,
            Opera,
            NowTime
        ]
    ).



%% @doc 装备物品日志
log_equip_goods(BabySts) ->
    Sql = make_sql(BabySts,6),
    log_proc:log(Sql).

%% @doc 幻化图鉴
log_change_figure(BabySts) ->
    Sql = make_sql(BabySts,7),
    log_proc:log(Sql).


%% @doc 激活图鉴
log_active_pic(BabySts) ->
    Sql = make_sql(BabySts,8),
    log_proc:log(Sql).


%% @doc 技能升级日志
log_upgrade_skill(BabySts) ->
    Sql = make_sql(BabySts,5),
    log_proc:log(Sql).


%% @doc
log_create_baby(BabySts) ->
    Sql = make_sql(BabySts,1),
    log_proc:log(Sql).



%% @doc
log_change_sex(BabySts) ->
    Sql = make_sql(BabySts,9),
    log_proc:log(Sql).



log_upgrade_lv(BabySts) ->
    Sql = make_sql(BabySts,4),
    log_proc:log(Sql).


log_do_stage(BabySts) ->
    Sql = make_sql(BabySts,3),
    log_proc:log(Sql).


log_change_name(BabySts) ->
    Sql = make_sql(BabySts,2),
    log_proc:log(Sql).

































