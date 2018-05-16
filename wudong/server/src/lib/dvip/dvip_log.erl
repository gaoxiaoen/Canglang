%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%             dvip 日志
%%% @end
%%% Created : 09. 十月 2017 9:50
%%%-------------------------------------------------------------------
-module(dvip_log).
-author("lzx").

%% API
-export([
    log_dvip/2,
    log_dvip_ex_gold/4,
    log_dvip_ex_market/6,
    log_dvip_ex_step/6
]).


log_dvip(Pkey,VipType) ->
    Time = util:unixtime(),
    Sql = io_lib:format("insert into log_dvip_player set pkey = ~w,vip_type = ~w,time = ~w",[Pkey,VipType,Time]),
    log_proc:log(Sql),
    ok.



log_dvip_ex_gold(Pkey,Bgold,Gold,Cnt) ->
    Time = util:unixtime(),
    Sql = io_lib:format("insert into log_dvip_ex_gold set pkey = ~w,bgold = ~w,gold = ~w,cnt = ~w,time = ~w",[Pkey,Bgold,Gold,Cnt,Time]),
    log_proc:log(Sql),
    ok.



log_dvip_ex_market(Pkey,Index,Cnt,CostType,Cost,GoodsList) ->
    Time = util:unixtime(),
    Sql = io_lib:format("insert into log_dvip_ex_market set pkey = ~w,`index` = ~w,cnt = ~w,costtype = ~w,cost = ~w,goods_list = '~s',time = ~w",
        [Pkey,Index,Cnt,CostType,Cost,util:term_to_bitstring(GoodsList),Time]),
    log_proc:log(Sql),
    ok.


log_dvip_ex_step(Pkey,Index,Cnt,Cost_Gold,Del_Goods,Give_Goods) ->
    Time = util:unixtime(),
    Sql = io_lib:format("insert into log_dvip_ex_step set pkey = ~w,`index` = ~w,cnt = ~w,cost_gold = ~w,del_goods = '~s',give_goods = '~s',time = ~w",
        [Pkey,Index,Cnt,Cost_Gold,util:term_to_bitstring(Del_Goods),util:term_to_bitstring(Give_Goods),Time]),
    log_proc:log(Sql),
    ok.













