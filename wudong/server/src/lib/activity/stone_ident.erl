%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 原石鉴定
%%% @end
%%% Created : 10. 五月 2017 11:43
%%%-------------------------------------------------------------------
-module(stone_ident).
-author("Administrator").
-include("activity.hrl").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    get_stone_ident_info/1
    , stone_ident/2
    , get_state/0
]).

%%获取原石鉴定活动信息
get_stone_ident_info(Player) ->
    BaseList =
        case get_act() of
            [] -> [];
            Base ->
                Base#base_act_stone_ident.exchange_list
        end,
    F = fun(BaseEG, List) ->
        #base_stone_ident{
            id = Id,
            get_goods = GetGoodsList,
            cost_goods = CostGoodsList
        } = BaseEG,
        Fg = fun({GId, Num}, AccState) ->
            case AccState of
                false -> false;
                true ->
                    GC = goods_util:get_goods_count(GId),
                    GC >= Num
            end
        end,
        State0 = lists:foldl(Fg, true, CostGoodsList),
        GetList = [[GoodsId, GoodsNum] || {GoodsId, GoodsNum, _} <- GetGoodsList],
        State = ?IF_ELSE(State0, 1, 0),
        CostGoodsList1 = [tuple_to_list(Info) || Info <- CostGoodsList],
        [[Id, State, CostGoodsList1, GetList] | List]
    end,
    Data = lists:foldl(F, [], BaseList),
    {ok, Bin} = pt_432:write(43276, list_to_tuple([Data])),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%% 原石鉴定
stone_ident(Player, Id) ->
    case get_act() of
        [] -> {false, 0};
        Base0 ->
            case check_stone_ident(Base0, Id) of
                false ->
                    {false, 14};
                {ok, Base} ->
                    #base_stone_ident{
                        get_goods = GetGoodsList,
                        cost_goods = CostGoods
                    } = Base,
                    case goods:subtract_good(Player, CostGoods, 262) of
                        {false, _} ->
                            {false, 0};
                        {ok, _NewGoodsStatus} ->
                            GetRatioList = [{GoodsId0, Ratio0} || {GoodsId0, _GoodsNum0, Ratio0} <- GetGoodsList],
                            GoodsId = util:list_rand_ratio(GetRatioList),
                            case lists:keyfind(GoodsId, 1, GetGoodsList) of
                                false ->
                                    {false, 0};
                                {GoodsId, GoodsNum, _Ratio} ->
                                    NewGoodsList = goods:make_give_goods_list(262, [{GoodsId, GoodsNum}]),
                                    {ok, NewPlayer} = goods:give_goods(Player, NewGoodsList),
%%                             log_stone_ident(Player#player.key, Player#player.nickname, Player#player.lv,  GoodsId,GoodsNum),
                                    activity:get_notice(NewPlayer, [116], true),
                                    {ok, NewPlayer, GoodsId, GoodsNum}
                            end
                    end
            end
    end.

check_stone_ident(BaseAct, Id) ->
    case lists:keyfind(Id, #base_stone_ident.id, BaseAct#base_act_stone_ident.exchange_list) of
        false -> false;
        Base ->
            Fg = fun({GId, Num}, AccState) ->
                case AccState of
                    false -> false;
                    true ->
                        GC = goods_util:get_goods_count(GId),
                        GC >= Num
                end
            end,
            State0 = lists:foldl(Fg, true, Base#base_stone_ident.cost_goods),
            case State0 of
                false ->
                    false;
                true ->
                    {ok, Base}
            end
    end.

get_state() ->
    BaseAct = get_act(),
    if
        BaseAct == [] -> -1;
        true ->
            Len = length(BaseAct#base_act_stone_ident.exchange_list),
            F = fun(Id) ->
                case check_stone_ident(BaseAct, Id) of
                    false -> false;
                    _ -> true
                end
            end,
            Flag = lists:any(F, lists:seq(1, Len)),
            Args = activity:get_base_state(BaseAct#base_act_stone_ident.act_info),
            ?IF_ELSE(Flag == true, {1, Args}, {0, Args})
    end.


get_act() ->
    case activity:get_work_list(data_stone_ident) of
        [] -> [];
        [Base | _] ->
            Base
    end.

log_stone_ident(Pkey, Nickname, Lv, GoodsId, GoodsNum) ->
    Sql = io_lib:format("insert into  log_stone_ident (pkey, nickname,lv,goods_id,goods_num,time) VALUES(~p,'~s',~p,~p,~p,~p)",
        [Pkey, Nickname, Lv, GoodsId, GoodsNum, util:unixtime()]),
    log_proc:log(Sql),
    ok.
