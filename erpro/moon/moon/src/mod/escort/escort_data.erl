%%----------------------------------------------------
%% @doc 运镖系统数据模块
%%
%% <pre>
%% 运镖系统数据模块
%% </pre> 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(escort_data).

-export([
        prob/0
        ,escort_award/1
        ,multiple/2
        ,double_award/0
    ]
).

-include("common.hrl").
-include("escort.hrl").

%% @spec prob() -> {GreenProb, BlueProb, PurpleProb, OrangeProb}
%% @doc
%% GreenProb = BlueProb = PurpleProb = OrangeProb = integer()
%% 获取刷新镖车概率
prob() ->
    {50, 30, 15, 5}.

%% 镖车奖励{经验，金币，押金}
escort_award(Lev) ->
    if
        Lev < 39 ->
            {0, 0, 0};
        Lev =< 48 ->
            {4000, 10000, 200};
        Lev =< 58 ->
            {6000, 14000, 300};
        Lev =< 68 ->
            {10000, 18000, 400};
        Lev =< 78 ->
            {14000, 22000, 600};
        true ->
            {20000, 26000, 1000}
    end.

%% 镖车品质总数
multiple(exp, ?escort_quality_white) ->  1;
multiple(exp, ?escort_quality_green) ->  1.2;
multiple(exp, ?escort_quality_blue) ->   1.5;
multiple(exp, ?escort_quality_purple) -> 2;
multiple(exp, ?escort_quality_orange) -> 3;

multiple(coin, ?escort_quality_white) ->  1;
multiple(coin, ?escort_quality_green) ->  1.5;
multiple(coin, ?escort_quality_blue) ->   2.5;
multiple(coin, ?escort_quality_purple) -> 4;
multiple(coin, ?escort_quality_orange) -> 8.

%% @spec double_award() -> {Hour, Minute, Sec, Long}
%% @doc
%% <pre>
%% Hour = integer() 24小时
%% Minute = integer() 分钟
%% Sec = integer() 秒
%% Long = integer() 时长, 单位秒
%% 双倍运镖时间
%% </pre>
double_award() ->
    {15, 0, 0, 3600}.
