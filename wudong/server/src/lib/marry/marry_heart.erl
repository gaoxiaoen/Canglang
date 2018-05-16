%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 七月 2017 10:17
%%%-------------------------------------------------------------------
-module(marry_heart).
-author("luobq").
-include("server.hrl").
-include("common.hrl").
-include("marry.hrl").
-include("team.hrl").
-include("scene.hrl").

%% API
-export([
    init/1
    , calc_heart_stage/1
    , calc_heart_attribute/1
    , calc_heart_attribute/2
    , marry_heart_info/1
    , heart_upgrade/1
    , get_attribute/1
    , db_get_heart_lv/2
    , get_my_heart_lv/0
    , get_marry_heart_lv/1
    , get_marry_heart_info/1
    , get_state/1
]).

init(Player) ->
    case load_marry_heart(Player#player.key) of
        [] ->
            St = #st_marry_heart{pkey = Player#player.key},
            lib_dict:put(?PROC_STATUS_MARRY_HEART, St);
        [HeareListBin, Lastheart] ->
            HeareList = util:bitstring_to_term(HeareListBin),
            St = #st_marry_heart{
                pkey = Player#player.key,
                is_change = 0,
                heart_list = HeareList,
                last_heart = Lastheart
            },
            lib_dict:put(?PROC_STATUS_MARRY_HEART, St)
    end,
    Player.

%% 计算羁绊阶数
calc_heart_stage(HeartList) ->
    case lists:keyfind(data_marry_heart:max_type(), 1, HeartList) of
        false -> 1;
        {_, Lv} -> Lv + 1
    end.

%%羁绊信息
marry_heart_info(Player) ->
    StMarry = lib_dict:get(?PROC_STATUS_MARRY_HEART),
    Stage = calc_heart_stage(StMarry#st_marry_heart.heart_list),
    TypeList = data_marry_heart:type_list(),
    F = fun(Type) ->
        case lists:keyfind(Type, 1, StMarry#st_marry_heart.heart_list) of
            false -> [Type, 1];
            {_, Lv} -> [Type, Lv]
        end
    end,
    MarryHeartList = lists:map(F, TypeList),
    CurType = get_upgrade_type(StMarry#st_marry_heart.last_heart, TypeList),

    Attribute = calc_heart_attribute(Player, StMarry#st_marry_heart.heart_list),

    AttributeList = attribute_util:pack_attr(Attribute),
    Cbp = attribute_util:calc_combat_power(Attribute),
    HeartLv = get_marry_heart_info(Player),
    CoupleLv = hd([Lv || {Key, Lv} <- HeartLv, Key =/= Player#player.key]),
%%     ?DEBUG("~p/~p/~p/~p/~p~n", [Stage, CurType, MarryHeartList, Cbp, AttributeList]),
    {Stage, CurType, Stage, CoupleLv, MarryHeartList, Cbp, AttributeList}.

get_upgrade_type(LastType, TypeList) ->
    MaxType = lists:max(TypeList),
    MinType = lists:min(TypeList),
    if LastType == 0 orelse LastType == MaxType -> MinType;
        true ->
            LastType + 1
    end.

%%羁绊升级
heart_upgrade(Player) ->
    case check_heart_upgrade(Player) of
        {false, Res} -> {Res, Player};
        {ok, Base, CurType, Lv} ->
            StMarryHeart = lib_dict:get(?PROC_STATUS_MARRY_HEART),
            NewPlayer0 = money:add_sweet(Player, -Base#base_marry_heart.goods_num),
            HeartList = [{CurType, Lv} | lists:keydelete(CurType, 1, StMarryHeart#st_marry_heart.heart_list)],
            NewMarryHeart = StMarryHeart#st_marry_heart{heart_list = HeartList, last_heart = CurType, is_change = 1},
            lib_dict:put(?PROC_STATUS_MARRY_HEART, NewMarryHeart),
            dbup_marry_heart(NewMarryHeart),
            Mul = data_marry_heart_stage:get(Lv + 1),
            Flag = ?IF_ELSE(Mul == [], false, true),
            ?IF_ELSE(CurType == 8 andalso Flag, up_marry_heart_lv(Player, Lv + 1), up_marry_heart_lv(Player, Lv)),
            NewPlayer = player_util:count_player_attribute(NewPlayer0, true),
            log_marry_heart(Player#player.key, Player#player.nickname, CurType, Lv),
            activity:get_notice(NewPlayer, [137], true),
            {1, NewPlayer}
    end.

check_heart_upgrade(Player) ->
    StMarryHeart = lib_dict:get(?PROC_STATUS_MARRY_HEART),
    TypeList = data_marry_heart:type_list(),
    CurType = get_upgrade_type(StMarryHeart#st_marry_heart.last_heart, TypeList),
    Lv = case lists:keyfind(CurType, 1, StMarryHeart#st_marry_heart.heart_list) of
             false -> 1;
             {_, LvOld} -> LvOld + 1
         end,

    if
        Player#player.marry#marry.mkey == 0 ->
            {false, 39}; %% 未婚
        true ->
            case data_marry_heart:get(CurType, Lv) of
                [] -> {false, 47};
                Base ->
                    Count = Player#player.sweet,
                    if Count < Base#base_marry_heart.goods_num -> {false, 36};
                        true ->
                            {ok, Base, CurType, Lv}
                    end
            end
    end.

get_attribute(Player) ->
    calc_heart_attribute(Player).

calc_heart_attribute(Player) ->
    StMarry = lib_dict:get(?PROC_STATUS_MARRY_HEART),
    calc_heart_attribute(Player, StMarry#st_marry_heart.heart_list).

calc_heart_attribute(Player, MarryHeart) ->
    HeartLv0 = get_marry_heart_info(Player),
    Lv = lists:min([Lv || {_, Lv} <- HeartLv0]),
    Mul = data_marry_heart_stage:get(Lv),
    L1 = lists:flatmap(
        fun({HeartId, HeartLv}) ->
            case data_marry_heart:get(HeartId, HeartLv) of
                [] -> [];
                BaseHeart -> BaseHeart#base_marry_heart.attrs
            end
        end, MarryHeart),
    L2 = [{Att, util:ceil(Val * (1 + Mul / 100))} || {Att, Val} <- L1],
    attribute_util:make_attribute_by_key_val_list(L2).

%% 获取羁绊等级
get_marry_heart_lv(Player) ->
    HeartLv = get_marry_heart_info(Player),
    Lv = lists:min([Lv || {_, Lv} <- HeartLv]),
    Lv.

%% 获取双方羁绊信息
get_marry_heart_info(Player) ->
    StMarryHeart = lib_dict:get(?PROC_STATUS_MARRY_HEART),
    Stage = calc_heart_stage(StMarryHeart#st_marry_heart.heart_list),
    case ets:lookup(?ETS_MARRY, Player#player.marry#marry.mkey) of
        [] ->
            [{Player#player.key, Stage}, {0, 1}];
        [StMarry] ->
            MarryHeard = StMarry#st_marry.heart_lv,
            MarryHeard
    end.

get_my_heart_lv() ->
    StMarryHeart = lib_dict:get(?PROC_STATUS_MARRY_HEART),
    Stage = calc_heart_stage(StMarryHeart#st_marry_heart.heart_list),
    Stage.

%%更新双方羁绊等级
up_marry_heart_lv(Player, Lv) ->
    case ets:lookup(?ETS_MARRY, Player#player.marry#marry.mkey) of
        [] ->
            skip;
        [StMarry] ->
            MarryHeard = StMarry#st_marry.heart_lv,
            case lists:keytake(Player#player.key, 1, MarryHeard) of
                false -> skip;
                {value, {Key, _Lv1}, [{Key1, Lv2}]} ->
                    NewStMarry = StMarry#st_marry{heart_lv = [{Key, Lv} | [{Key1, Lv2}]]},
                    ets:insert(?ETS_MARRY, NewStMarry),
                    marry_load:replace_marry(NewStMarry),
                    case player_util:get_player_pid(Key1) of
                        false -> skip;
                        TargetPid ->
                            TargetPid ! refresh_marry_heart
                    end
            end
    end.

log_marry_heart(Pkey, Nickname, Type, Lv) ->
    Sql = io_lib:format("insert into log_marry_heart set pkey=~p,nickname='~s',cur_type=~p,lv=~p,change_time=~p", [Pkey, Nickname, Type, Lv, util:unixtime()]),
    log_proc:log(Sql).


load_marry_heart(Pkey) ->
    Sql = io_lib:format("select heart_list,last_heart from player_marry_heart  where pkey =~p", [Pkey]),
    db:get_row(Sql).

dbup_marry_heart(St) ->
    #st_marry_heart{
        pkey = Pkey,
        is_change = IsChange,
        heart_list = HeartList, %%羁绊[{id,lv}]
        last_heart = LastHeart   %%上一次提升的羁绊
    } = St,
    case IsChange of
        0 -> skip;
        1 ->
            Sql = io_lib:format("replace into player_marry_heart set heart_list='~s',last_heart=~p,pkey = ~p",
                [util:term_to_bitstring(HeartList), LastHeart, Pkey]),
            db:execute(Sql)
    end,
    ok.

db_get_heart_lv(Key1, Key2) ->
    Tmp1 =
        case load_marry_heart(Key1) of
            [] ->
                {Key1, 0};
            [HeareListBin0, _] ->
                HeareList0 = util:bitstring_to_term(HeareListBin0),
                {Key1, calc_heart_stage(HeareList0)}
        end,
    Tmp2 =
        case load_marry_heart(Key2) of
            [] ->
                {Key2, 0};
            [HeareListBin, _] ->
                HeareList = util:bitstring_to_term(HeareListBin),
                {Key2, calc_heart_stage(HeareList)}
        end,
    [Tmp1, Tmp2].

get_state(Player) ->
    case check_heart_upgrade(Player) of
        {false, _Res} ->
            0;
        _ -> 1
    end.