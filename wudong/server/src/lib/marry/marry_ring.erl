%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 七月 2017 17:25
%%%-------------------------------------------------------------------
-module(marry_ring).
-author("luobq").
-include("server.hrl").
-include("common.hrl").
-include("marry.hrl").

%% API
-export([
    init/1
    , ring_info/1
    , get_attribute/0
    , ring_up/1
    , db_get_ring_lv/2
    , marry_trigger/1
    , get_my_ring_lv/0
    , timer_add_sweet/1
    , notice_couple/1
    , get_my_ring_type/0
    , logout/1
    , get_couple_lv/1
    , get_state/1
    , get_my_ring_type/1
]).

-define(MAX_LIMIT, 800).

init(Player) ->
    StRing =
        case player_util:is_new_role(Player) of
            true ->
                #st_ring{pkey = Player#player.key};
            false ->
                case marry_load:load_player_ring(Player#player.key) of
                    [] ->
                        #st_ring{pkey = Player#player.key, stage = 0, is_change = 1};
                    [Stage, Exp, Type] ->
                        #st_ring{pkey = Player#player.key, stage = Stage, exp = Exp, type = Type}
                end
        end,
    NewStRing = calc_attribute(StRing),
    lib_dict:put(?PROC_STATUS_MARRY_RING, NewStRing),
    Player#player{marry_ring_lv = StRing#st_ring.stage, marry_ring_type = StRing#st_ring.type}.

calc_attribute(StRing) ->
    case data_ring:get(StRing#st_ring.stage, StRing#st_ring.type) of
        [] -> StRing;
        Base ->
            Attribute = attribute_util:make_attribute_by_key_val_list(Base#base_marry_ring.attrs),
            Cbp = attribute_util:calc_combat_power(Attribute),
            StRing#st_ring{attribute = Attribute, cbp = Cbp}
    end.

ring_info(Player) ->
    StRing = lib_dict:get(?PROC_STATUS_MARRY_RING),
    case data_ring:get(StRing#st_ring.stage, StRing#st_ring.type) of
        [] ->
            [];
        Base ->
            AttributeList = attribute_util:pack_attr(StRing#st_ring.attribute),
            HeartLv = get_marry_ring_lv(Player),
            CoupleLv = hd([Lv || {Key, Lv} <- HeartLv, Key =/= Player#player.key]),
            Type = ?IF_ELSE(StRing#st_ring.type == 1 andalso Player#player.marry#marry.mkey == 0, 2, StRing#st_ring.type),
            {StRing#st_ring.stage, CoupleLv, Type, StRing#st_ring.exp, Base#base_marry_ring.exp, StRing#st_ring.cbp,
                Base#base_marry_ring.buff_id,
                Player#player.marry#marry.couple_name,
                Player#player.career,
                Player#player.sex,
                Player#player.wing_id,
                Player#player.equip_figure#equip_figure.weapon_id,
                Player#player.equip_figure#equip_figure.clothing_id,
                Player#player.light_weaponid,
                Player#player.fashion#fashion_figure.fashion_cloth_id,
                Player#player.fashion#fashion_figure.fashion_head_id,
                AttributeList}
    end.

get_attribute() ->
    St = lib_dict:get(?PROC_STATUS_MARRY_RING),
    St#st_ring.attribute.

%%戒指升级
ring_up(Player) ->
    StRing = lib_dict:get(?PROC_STATUS_MARRY_RING),
    case calc_exp() of
        {[], _} ->
            {38, Player};
        {CostList, Exp} ->
            if
                StRing#st_ring.stage >= ?MAX_LIMIT ->
                    {44, Player};
                true ->
                    goods:subtract_good(Player, CostList, 289),
                    StRing1 = add_exp(Exp, StRing),
                    NewStRing = ?IF_ELSE(StRing1#st_ring.is_upgrade, calc_attribute(StRing1), StRing1),
%%             marry_load:log_smelt(Player#player.key, Player#player.nickname, NewStRing#st_ring.stage, NewStRing#st_ring.exp),
                    lib_dict:put(?PROC_STATUS_MARRY_RING, NewStRing#st_ring{is_change = 1, is_upgrade = false}),
                    marry_load:replace_player_ring(NewStRing),
                    up_marry_ring_lv(Player, StRing1#st_ring.stage),
                    NewPlayer = ?IF_ELSE(NewStRing#st_ring.is_upgrade, player_util:count_player_attribute(Player, true), Player),
                    NewPlayer1 = NewPlayer#player{marry_ring_lv = StRing1#st_ring.stage},
                    scene_agent_dispatch:marry_ring_update(NewPlayer1),
                    activity:get_notice(NewPlayer, [138], true),
                    log_marry_ring(Player#player.key, Player#player.nickname, StRing1#st_ring.stage),
                    {1, NewPlayer1}
            end
    end.

calc_exp() ->
    List = data_ring_material:get_all(),
    F = fun({GoodsId, Val}, {L, Exp}) ->
        Count = goods_util:get_goods_count(GoodsId),
        if
            Count > 0 -> {[{GoodsId, Count} | L], Exp + Val * Count};
            true -> {L, Exp}
        end
    end,
    lists:foldl(F, {[], 0}, List).

add_exp(0, StRing) -> StRing;
add_exp(Exp, StRing) ->
    case data_ring:get(StRing#st_ring.stage, StRing#st_ring.type) of
        [] ->
            StRing#st_ring{stage = StRing#st_ring.stage - 1, exp = 0};
        Base ->
            if Base#base_marry_ring.exp == 0 ->
                StRing#st_ring{exp = 0};
                Exp + StRing#st_ring.exp >= Base#base_marry_ring.exp ->
                    NewStRing = StRing#st_ring{exp = 0, stage = StRing#st_ring.stage + 1, is_upgrade = true},
                    add_exp(Exp + StRing#st_ring.exp - Base#base_marry_ring.exp, NewStRing);
                true ->
                    StRing#st_ring{exp = StRing#st_ring.exp + Exp}
            end
    end.

get_couple_lv(Player) ->
    HeartLv = get_marry_ring_lv(Player),
    CoupleLv = hd([Lv || {Key, Lv} <- HeartLv, Key =/= Player#player.key]),
    CoupleLv.

%% 获取双方戒指等级
get_marry_ring_lv(Player) ->
    StRing = lib_dict:get(?PROC_STATUS_MARRY_RING),
    Stage = StRing#st_ring.stage,
    case ets:lookup(?ETS_MARRY, Player#player.marry#marry.mkey) of
        [] ->
            [{Player#player.key, Stage}, {0, 0}];
        [StMarry] ->
            MarryRing = StMarry#st_marry.ring_lv,
            MarryRing
    end.

%% 更新双方戒指等级
up_marry_ring_lv(Player, Lv) ->
    case ets:lookup(?ETS_MARRY, Player#player.marry#marry.mkey) of
        [] ->
            skip;
        [StMarry] ->
            MarryRing = StMarry#st_marry.ring_lv,
            case lists:keytake(Player#player.key, 1, MarryRing) of
                false ->
                    List = [{Key0, Lv0} || {Key0, Lv0} <- MarryRing, Key0 =/= Player#player.key, Key0 =/= 0],
                    if
                        length(List) == 0 -> NewRingLv = [{Player#player.key, Lv}, {0, 0}];
                        length(List) == 1 -> NewRingLv = [{Player#player.key, Lv} | List];
                        true ->
                            ?ERR(" marry_ring ets err ~p~n", [List]),
                            NewRingLv = MarryRing
                    end,
                    NewStMarry = StMarry#st_marry{ring_lv = NewRingLv},
                    ets:insert(?ETS_MARRY, NewStMarry),
                    marry_load:replace_marry(NewStMarry);
                {value, {Key, _Lv1}, [{Key1, Lv2}]} ->
                    NewStMarry = StMarry#st_marry{ring_lv = [{Key, Lv} | [{Key1, Lv2}]]},
                    ets:insert(?ETS_MARRY, NewStMarry),
                    marry_load:replace_marry(NewStMarry),
                    case player_util:get_player_pid(Key1) of
                        false -> skip;
                        TargetPid ->
                            TargetPid ! refresh_marry_ring
                    end
            end
    end.

%% 获取自身戒指等级
get_my_ring_lv() ->
    StRing = lib_dict:get(?PROC_STATUS_MARRY_RING),
    StRing#st_ring.stage.

%% 获取自身戒指类型
get_my_ring_type() ->
    StRing = lib_dict:get(?PROC_STATUS_MARRY_RING),
    StRing#st_ring.type.

get_my_ring_type(Player) ->
    Type = marry_ring:get_my_ring_type(),
    Type1 =
        if
            Type == 0 -> 0;
            Type == 2 -> 2;
            Type == 1 andalso Player#player.marry#marry.couple_key == 0 -> 2;
            true -> 1
        end,
    Type1.

db_get_ring_lv(Key1, Key2) ->
    Tmp1 =
        case marry_load:load_player_ring(Key1) of
            [] ->
                {Key1, 0};
            [Stage1, _Exp1, _Type1] ->
                {Key1, Stage1}
        end,
    Tmp2 =
        case marry_load:load_player_ring(Key2) of
            [] ->
                {Key2, 0};
            [Stage2, _Exp2, _Type2] ->
                {Key2, Stage2}
        end,
    [Tmp1, Tmp2].

marry_trigger(Player) ->
    StRing = lib_dict:get(?PROC_STATUS_MARRY_RING),
    lib_dict:put(?PROC_STATUS_MARRY_RING, StRing#st_ring{type = 1}),
    marry_load:replace_player_ring(StRing#st_ring{type = 1}),
    Type = ?IF_ELSE(Player#player.marry#marry.mkey == 0, 2, StRing#st_ring.type),
    Type.

%% 定时检查配偶是否在线
timer_add_sweet(Player) ->
    Pkey = Player#player.marry#marry.couple_key,
    if
        Player#player.marry#marry.couple_sex == 1 -> Player;
        true ->
            case player_util:get_player(Pkey) of
                [] ->
                    Player;
                OtherPlayer ->
                    OtherPlayer#player.pid ! {add_sweet, 1},
                    money:add_sweet(Player, 1)
            end
    end.

notice_couple(Player) ->
    Pkey = Player#player.marry#marry.couple_key,
    case player_util:get_player(Pkey) of
        [] ->
            skip;
        OtherPlayer ->
            OtherPlayer#player.pid ! add_ring_buff,
            {ok, Bin} = pt_288:write(28861, {Player#player.nickname}),
            server_send:send_to_sid(OtherPlayer#player.sid, Bin),
            Player#player.pid ! add_ring_buff
    end,
    ok.

logout(Player) ->
    Pkey = Player#player.marry#marry.couple_key,
    case player_util:get_player(Pkey) of
        [] ->
            skip;
        OtherPlayer ->
            OtherPlayer#player.pid ! del_ring_buff
    end,
    ok.

get_state(_Player) ->
    StRing = lib_dict:get(?PROC_STATUS_MARRY_RING),
    case calc_exp() of
        {[], _} ->
            0;
        _ ->
            if
                StRing#st_ring.stage >= ?MAX_LIMIT -> 0;
                true -> 1
            end
    end.

log_marry_ring(Pkey, Nickname, Lv) ->
    Sql = io_lib:format("insert into log_marry_ring set pkey=~p,nickname='~s',lv=~p,time=~p", [Pkey, Nickname, Lv, util:unixtime()]),
    log_proc:log(Sql).
