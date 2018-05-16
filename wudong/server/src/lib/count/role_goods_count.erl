%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 个人当天物品获得统计
%%% @end
%%% Created : 04. 三月 2016 下午2:46
%%%-------------------------------------------------------------------
-module(role_goods_count).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").

%% API
-export([
    init/1,
    logout/1,
    night_refresh/0,
    add_count/1,
    player_night_refresh/0,
    http_post/4
]).

-record(role_gcount, {
    pkey = 0,
    goods_list = []  %%物品列表[{goodsid,iswarn,accfromlist}]
}).

init(Player) ->
    #player{key = Pkey} = Player,
    NewSt = #role_gcount{
        pkey = Pkey
    },
    RoleGCount =
        case player_util:is_new_role(Player) of
            true -> NewSt;
            false ->
                Sql = io_lib:format("select goods_list from cron_player_goods_count where pkey=~p",
                    [Pkey]),
                case db:get_row(Sql) of
                    [] -> NewSt;
                    [GoodsList] ->
                        #role_gcount{
                            pkey = Pkey,
                            goods_list = ts_goods_list(GoodsList)
                        }
                end
        end,
    lib_dict:put(?PROC_STATUS_ROLE_GOODS_COUNT, RoleGCount),
    Player.

ts_goods_list(GoodsListBin) ->
    F = fun(Item) ->
        case Item of
            {GoodsId, Num} ->
                {GoodsId, 0, [{0, Num}]};
            _ ->
                Item
        end
        end,
    lists:map(F, util:bitstring_to_term(GoodsListBin)).


logout(_Player) ->
    RoleGCount = lib_dict:get(?PROC_STATUS_ROLE_GOODS_COUNT),
    #role_gcount{
        pkey = Pkey,
        goods_list = GoodsList
    } = RoleGCount,
    Sql = io_lib:format("replace into cron_player_goods_count set pkey=~p,goods_list='~s'", [Pkey, util:term_to_bitstring(GoodsList)]),
    spawn(fun() -> db:execute(Sql) end),
    ok.

%%晚上清数据
night_refresh() ->
    Sql = io_lib:format("truncate cron_player_goods_count", []),
    db:execute(Sql),
    ok.

%%晚上清数据 个人
player_night_refresh() ->
    RoleGCount = lib_dict:get(?PROC_STATUS_ROLE_GOODS_COUNT),
    NewRoleGCount = RoleGCount#role_gcount{
        goods_list = []
    },
    lib_dict:put(?PROC_STATUS_ROLE_GOODS_COUNT, NewRoleGCount),
    ok.

%%增加物品
add_count(AddGoodsList) ->
    RoleGCount = lib_dict:get(?PROC_STATUS_ROLE_GOODS_COUNT),
    NewRoleGCount = add_goods_helper(AddGoodsList, RoleGCount),
    lib_dict:put(?PROC_STATUS_ROLE_GOODS_COUNT, NewRoleGCount),
    ok.
add_goods_helper([], NewRoleGCount) -> NewRoleGCount;
add_goods_helper([{GoodsId, GoodsNum, From, GoodsTypeInfo} | Tail], RoleGCount) ->
    #role_gcount{pkey = Pkey, goods_list = GoodsList} = RoleGCount,
    NewGoodsList =
        case lists:keytake(GoodsId, 1, GoodsList) of
            {value, {_, IsWarn, AccList}, L} ->
                NewAccList =
                    case lists:keytake(From, 1, AccList) of
                        false -> [{From, GoodsNum} | AccList];
                        {value, {_, Acc}, T} ->
                            [{From, GoodsNum + Acc} | T]
                    end,
                NewIsWarn = check_warn(Pkey, GoodsTypeInfo, NewAccList, IsWarn),
                [{GoodsId, NewIsWarn, NewAccList} | L];
            _ ->
                AccList = [{From, GoodsNum}],
                NewIsWarn = check_warn(Pkey, GoodsTypeInfo, AccList, 0),
                [{GoodsId, NewIsWarn, AccList} | GoodsList]
        end,
    NewRoleGCount = RoleGCount#role_gcount{goods_list = NewGoodsList},
    add_goods_helper(Tail, NewRoleGCount).

check_warn(_Pkey, GoodsTypeInfo, AccList, IsWarn) ->
    Num = lists:sum([Acc || {_, Acc} <- AccList]),
    if
        IsWarn == 1 -> IsWarn;
        GoodsTypeInfo#goods_type.role_warning_num =< 0 -> IsWarn;
        GoodsTypeInfo#goods_type.role_warning_num > Num -> IsWarn;
        true ->
%%            spawn(fun() -> http_post(Pkey, GoodsTypeInfo, Num, 1) end),
            1
    end.

http_post(Pkey, GoodsTypeInfo, GoodsNum, State) ->
    #goods_type{
        goods_id = GoodsId,
        role_warning_num = RoleWarningNum,
        server_warning_num = ServerWargingNum,
        goods_name = GoodsName
    } = GoodsTypeInfo,
%%    Url = "http://localhost/api/rpc/rpc_count_warning.php",
    Url = lists:concat([config:get_api_url(), "/rpc_count_warning.php"]),
    ServerId = config:get_server_num(),
    Now = util:unixtime(),
    Key = "bGmMkBOChg5C37qQ",
    Sign = util:md5(io_lib:format("~p~p~p~p~p~s", [Pkey, ServerId, GoodsId, GoodsNum, Now, Key])),
    U0 = io_lib:format("?pkey=~p&server_id=~p&goods_id=~p&goods_name=~s&goods_num=~p&time=~p&lim1=~p&lim2=~p&state=~p&sign=~s", [Pkey, ServerId, GoodsId, GoodsName, GoodsNum, Now, RoleWarningNum, ServerWargingNum, State, Sign]),
    U = lists:concat([Url, U0]),
    _Ret = httpc:request(get, {U, []}, [{timeout, 2000}], []),

    ok.