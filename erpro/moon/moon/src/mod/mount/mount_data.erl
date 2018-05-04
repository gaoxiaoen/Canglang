%% **************************
%% 坐骑进阶相关数据
%% @author wprehard@qq.com
%% **************************

-module(mount_data).
-export([
        get_next_mount/1
        ,get_mount_lev/1
        ,get_gain_loss/1
        ,get_bless/1
        ,get_need_enchant/1 %% 所需强化等级
        ,get_need_item/1    %% 所需材料{Id1，Id2, Num1, Num2}
        ,get_base_rate/1    %% 基础成功率
        ,get_fail_bless/3   %% 失败后的祝福值
        ,get_fail_prompt/1  %% 失败提示:强化等级
    ]).
-include("common.hrl").
-include("gain.hrl").
%%

%% @spec get_mount_lev(BaseId) -> Lev::integer()
%% @doc 获取进阶后的坐骑ID(是物品的base_id),新坐骑不绑定
get_mount_lev(19000) -> 1;
get_mount_lev(19001) -> 2;
get_mount_lev(19002) -> 3;
get_mount_lev(19003) -> 4;
get_mount_lev(19004) -> 5;
get_mount_lev(19005) -> 6;
get_mount_lev(_) -> 0.

%% @spec get_next_mount(BaseId) -> NewId::integer()
%% @doc 获取进阶后的坐骑ID(是物品的base_id),新坐骑不绑定
get_next_mount(19000) -> 19001;
get_next_mount(19001) -> 19002;
get_next_mount(19002) -> 19003;
get_next_mount(19003) -> 19004;
get_next_mount(19004) -> 19005;
get_next_mount(19005) -> 19006;
get_next_mount(_) -> 0.

%% @spec get_gain_loss(BaseId) -> list()
%% @doc 获取进阶后的坐骑ID(是物品的base_id), 新坐骑不绑定
get_gain_loss(19000) ->
    [
        #loss{label = item, val = [32300, 0, 1], msg = ?L(<<"材料不足">>)},
        #loss{label = coin_all, val = 5000, msg = ?L(<<"铜币不足">>)}
    ];
get_gain_loss(19001) ->
    [
        #loss{label = item, val = [32300, 0, 4], msg = ?L(<<"材料不足">>)},
        #loss{label = coin_all, val = 5000, msg = ?L(<<"铜币不足">>)}
    ];
get_gain_loss(19002) ->
    [
        #loss{label = item, val = [32301, 0, 2], msg = ?L(<<"材料不足">>)},
        #loss{label = coin_all, val = 5000, msg = ?L(<<"铜币不足">>)}
    ];
get_gain_loss(19003) ->
    [
        #loss{label = item, val = [32301, 0, 4], msg = ?L(<<"材料不足">>)},
        #loss{label = coin_all, val = 5000, msg = ?L(<<"铜币不足">>)}
    ];
get_gain_loss(19004) ->
    [
        #loss{label = item, val = [32301, 0, 8], msg = ?L(<<"材料不足">>)},
        #loss{label = coin_all, val = 5000, msg = ?L(<<"铜币不足">>)}
    ];
get_gain_loss(19005) ->
    [
        #loss{label = item, val = [32301, 0, 10], msg = ?L(<<"材料不足">>)},
        #loss{label = coin_all, val = 5000, msg = ?L(<<"铜币不足">>)}
    ];
get_gain_loss(_) -> [].

%% @spec get_min_bless(BaseId) -> {Max, Min}
%% @doc 获取当前坐骑的升阶所需最低祝福值
get_bless(19000) -> {100, 30};
get_bless(19001) -> {200, 60};
get_bless(19002) -> {300, 120};
get_bless(19003) -> {500, 200};
get_bless(19004) -> {700, 280};
get_bless(19005) -> {1000, 400};
get_bless(_) -> {1000, 1000}.

%% @spec get_need_enchant(BaseId) -> Strength:integer()
%% @doc 获取当前坐骑的升阶所需强化等级
get_need_enchant(19000) -> 6;
get_need_enchant(19001) -> 7;
get_need_enchant(19002) -> 8;
get_need_enchant(19003) -> 9;
get_need_enchant(19004) -> 10;
get_need_enchant(19005) -> 12;
get_need_enchant(_) -> 12.

%% @spec get_need_enchant(BaseId) -> Strength:integer()
%% @doc 获取当前坐骑的升阶所需强化等级
get_need_item(19000) -> {32300, 0, 1, 0};
get_need_item(19001) -> {32300, 0, 4, 0};
get_need_item(19002) -> {32301, 0, 2, 0};
get_need_item(19003) -> {32301, 0, 4, 0};
get_need_item(19004) -> {32301, 0, 8, 0};
get_need_item(19005) -> {32301, 0, 10, 0};
get_need_item(_) -> {32300, 0, 1, 0}.

%% @spec get_base_rate(BaseId) -> ()
%% @doc 获取当前坐骑的升阶基础成功率
get_base_rate(19000) -> 300;
get_base_rate(19001) -> 200;
get_base_rate(19002) -> 150;
get_base_rate(19003) -> 100;
get_base_rate(19004) -> 80;
get_base_rate(19005) -> 50;
get_base_rate(_) -> 0. %% 异常不可能成功?

%% @spec get_fail_bless(Rate) -> inteter()
%% @doc 随机获取失败后的祝福值
get_fail_bless(Max, NowVal, Rate) when Rate >= 1 andalso Rate =< 1000 ->
    N = Rate rem 3,
    Rand = case N =:= 0 of
        true -> 1;
        false -> N
    end,
    case NowVal + Rand > Max of
        true -> Max;
        false -> NowVal
    end.

%% @spec get_fail_prompt(MountId) -> integer()
%% @doc 获取强化等级失败的的提示
get_fail_prompt(19000) -> ?L(<<"强化等级不足6级，无法进阶">>);
get_fail_prompt(19001) -> ?L(<<"强化等级不足7级，无法进阶">>);
get_fail_prompt(19002) -> ?L(<<"强化等级不足8级，无法进阶">>);
get_fail_prompt(19003) -> ?L(<<"强化等级不足9级，无法进阶">>);
get_fail_prompt(19004) -> ?L(<<"强化等级不足10级，无法进阶">>);
get_fail_prompt(19005) -> ?L(<<"强化等级不足11级，无法进阶">>);
get_fail_prompt(_) -> ?L(<<"强化等级不足，无法进阶">>).
