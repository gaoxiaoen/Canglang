%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 离线经验找回
%%% @end
%%% Created : 20. 四月 2016 上午10:39
%%%-------------------------------------------------------------------
-module(findback_exp).
-author("fengzhenlin").
-include("server.hrl").
-include("findback.hrl").
-include("common.hrl").
-include("tips.hrl").

%% API
-export([
    init/1,
    get_findback_exp_info/1,
    get_findback_exp/2,
    check_find_state/0,
    get_state/0
]).

-define(MAX_OUTLINE_TIME, 12*3600).


init(Player) ->
    FindBackExpSt = findback_load:dbget_findback_exp(Player),
    put_dict(FindBackExpSt),
    update(Player),
    Player.
update(Player) ->
    #player{
        logout_time = LogoutTime
    } = Player,
    Now = util:unixtime(),
    OutlineTime = ?IF_ELSE(LogoutTime == 0, 0, max(0, Now - LogoutTime)),
    St = get_dict(),
    #st_findback_exp{
        outline_time = Time
    } = St,
    NewTime = min(?MAX_OUTLINE_TIME, Time+OutlineTime),
    NewSt = St#st_findback_exp{
        outline_time = NewTime
    },
    put_dict(NewSt),
    findback_load:dbup_findback_exp(NewSt),
    ok.

get_dict() ->
    lib_dict:get(?PROC_STATUS_FINDBACK_EXP).

put_dict(St) ->
    lib_dict:put(?PROC_STATUS_FINDBACK_EXP, St).

%%获取经验找回信息
get_findback_exp_info(Player) ->
    FindBackExpSt = get_dict(),
    #st_findback_exp{
        outline_time = OutlineTime,
        is_get = IsGet
    } = FindBackExpSt,
    case data_findback_exp:get(Player#player.lv) of
        [] -> ?ERR("get findback_exp data err : ~p~n", [Player#player.lv]), skip;
        Base ->
            #base_findback_exp{
                exp = Exp0,
                need_vip1 = NeedVip1,
                need_vip2 = NeedVip2
            } = Base,
            Exp = Exp0 + round(Player#player.world_lv_add*Exp0),
            Exp1 = round(Exp * OutlineTime),
            L = [[1, 0, Exp1, IsGet], [2, NeedVip1, Exp1 * 2, IsGet], [3, NeedVip2, Exp1 * 3, IsGet]],
            {ok, Bin} = pt_381:write(38100, {OutlineTime, L}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end.

%%领取经验
get_findback_exp(Player, Mul) ->
    case check_get_findback_exp(Player, Mul) of
        {false, Res} ->
            {false, Res};
        {ok, GetExp} ->
            NewPlayer1 = player_util:add_exp(Player, GetExp, 15),
            FindBackExpSt = get_dict(),
            NewFindBackExpSt = FindBackExpSt#st_findback_exp{
                outline_time = 0
            },
            put_dict(NewFindBackExpSt),
            findback_load:dbup_findback_exp(NewFindBackExpSt),
            activity:get_notice(Player, [89], true),
            {ok, NewPlayer1}
    end.

check_get_findback_exp(Player, Mul) ->
    FindBackExpSt = get_dict(),
    #st_findback_exp{
        outline_time = OutlineTime
    } = FindBackExpSt,
    Base = data_findback_exp:get(Player#player.lv),
    if
        Base == [] -> {false, 0};
        OutlineTime =< 0 -> {false, 5};
        Mul =< 0 orelse Mul >= 4 -> {false, 6};
        true ->
            #base_findback_exp{
                exp = Exp0,
                need_vip1 = NeedVip1,
                need_vip2 = NeedVip2
            } = Base,
            Exp = Exp0 + round(Player#player.world_lv_add*Exp0),
            {GetExp, NeedVip} =
                case Mul of
                    2 -> {Exp * OutlineTime * 2, NeedVip1};
                    3 -> {Exp * OutlineTime * 3, NeedVip2};
                    _ -> {Exp * OutlineTime, 0}
                end,
            if
                NeedVip > Player#player.vip_lv -> {false, 4};
                true ->
                    {ok, GetExp}
            end
    end.

%%离线找回状态
check_find_state() ->
    FindBackExpSt = lib_dict:get(?PROC_STATUS_FINDBACK_EXP),
    #st_findback_exp{
        outline_time = OutlineTime
    } = FindBackExpSt,
    case OutlineTime >= ?ONE_HOUR_SECONDS * 3 of
        true -> #tips{state = 1};
        false -> #tips{}
    end.

%%离线找回红点提示
get_state() ->
    FindBackExpSt = get_dict(),
    #st_findback_exp{
        outline_time = OutlineTime
    } = FindBackExpSt,
    case OutlineTime > 0 of
        true -> 1;
        false -> 0
    end.
