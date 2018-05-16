%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 十月 2017 21:28
%%%-------------------------------------------------------------------
-module(xian_load).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("xian.hrl").

%% API
-export([
    dbget_xian_map/1,
    dbup_xian_map/1,
    dbget_xian_upgrade/1,
    dbup_xian_upgrade/1,
    dbget_xian_exchange/1,
    dbup_xian_exchange/1,
    dbget_xian_skill/1,
    dbup_xian_skill/1
]).

dbget_xian_upgrade(Pkey) ->
    Sql = io_lib:format("select xian_stage, task_info, op_time from player_xian_stage where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [XianStage, TaskInfoBin, OpTime] ->
            #st_xian_stage{
                pkey = Pkey,
                stage = XianStage,
                task_info = util:bitstring_to_term(TaskInfoBin),
                op_time = OpTime
            };
        _ ->
            #st_xian_stage{
                pkey = Pkey
            }
    end.

dbup_xian_upgrade(StXianStage) ->
    #st_xian_stage{
        pkey = Pkey,
        stage = XianStage,
        task_info = TaskInfo,
        op_time = OpTime
    } = StXianStage,
    TaskInfoBin = util:term_to_bitstring(TaskInfo),
    Sql = io_lib:format("replace into player_xian_stage set pkey=~p, xian_stage=~p, task_info='~s', op_time=~p",
        [Pkey, XianStage, TaskInfoBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_xian_map(Pkey) ->
    Sql = io_lib:format("select time1,num1,time2,num2,op_time from player_xian_map where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [Time1, Num1, Time2, Num2, OpTime] ->
            #st_xian_map{
                pkey = Pkey,
                time1 = Time1,
                num1 = Num1,
                time2 = Time2,
                num2 = Num2,
                op_time = OpTime
            };
        _ ->
            #st_xian_map{pkey = Pkey}
    end.

dbup_xian_map(StXianMap) ->
    #st_xian_map{
        pkey = Pkey,
        time1 = Time1,
        num1 = Num1,
        time2 = Time2,
        num2 = Num2,
        op_time = OpTime
    } = StXianMap,
    Sql = io_lib:format("replace into player_xian_map set pkey=~p, time1=~p,num1=~p,time2=~p,num2=~p,op_time=~p",
        [Pkey, Time1, Num1, Time2, Num2, OpTime]),
    db:execute(Sql).

dbget_xian_exchange(Pkey) ->
    Sql = io_lib:format("select exchange_list, op_time from player_xian_exchange where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [ExchangeListBin, OpTime] ->
            ExchangeList = util:bitstring_to_term(ExchangeListBin),
            #st_xian_exchange{
                pkey = Pkey,
                exchange_list = ExchangeList,
                op_time = OpTime
            };
        _ ->
            #st_xian_exchange{pkey = Pkey}
    end.

dbup_xian_exchange(#st_xian_exchange{pkey = Pkey, exchange_list = ExchangeList, op_time = OpTime}) ->
    ExchangeListBin = util:term_to_bitstring(ExchangeList),
    Sql = io_lib:format("replace into player_xian_exchange set pkey=~p, exchange_list='~s', op_time=~p",
        [Pkey, ExchangeListBin, OpTime]),
    db:execute(Sql),
    ok.

dbget_xian_skill(Pkey) ->
    Sql = io_lib:format("select skill_lv_list from player_xian_skill where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [SkillLvListBin] ->
            SkillLvList = util:bitstring_to_term(SkillLvListBin),
            #st_xian_skill{
                pkey = Pkey,
                skill_lv_list = SkillLvList
            };
        _ ->
            #st_xian_skill{pkey = Pkey}
    end.

dbup_xian_skill(#st_xian_skill{pkey = Pkey, skill_lv_list = SkillLvList}) ->
    SkillLvListBin = util:term_to_bitstring(SkillLvList),
    Sql = io_lib:format("replace into player_xian_skill set pkey=~p, skill_lv_list='~s'",
        [Pkey, SkillLvListBin]),
    db:execute(Sql),
    ok.