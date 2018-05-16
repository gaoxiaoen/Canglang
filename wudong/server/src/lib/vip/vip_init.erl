%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2015 下午1:57
%%%-------------------------------------------------------------------
-module(vip_init).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("vip.hrl").

%% API
-export([
    init/1,
    update/1,
    update_week/0
]).

init(Player) ->
    VipSt = vip_load:dbget_player_vip(Player),
    NewLv = vip:calc_vip_lv(VipSt#st_vip.sum_val),
    NewVipSt = VipSt#st_vip{
        lv = NewLv
    },
    lib_dict:put(?PROC_STATUS_VIP, NewVipSt),
    update_week(),
    update(Player).

update(Player) ->
    VipSt = lib_dict:get(?PROC_STATUS_VIP),
    #st_vip{
        lv = VipLv,
        free_time = FreeTime,
        free_lv = FreeLv
    } = VipSt,
    {NewVipSt,NewPlayer} =
        case FreeLv > 0 of
            true -> %%有体验vip
                Now = util:unixtime(),
                case Now >= FreeTime orelse VipLv >= FreeLv of
                    true -> %%体验到期
                        ChangeLv = ?IF_ELSE(Now >= FreeTime, FreeLv, 0),
                        {ok, Bin} = pt_470:write(47003, {2, ChangeLv}),
                        server_send:send_to_sid(Player#player.sid, Bin),
                        {VipSt#st_vip{
                            free_lv = 0,
                            free_time = 0
                        },limit_vip:close_time_limit_vip(Player)};
                    false -> %% 还没到期
                        {VipSt,Player}
                end;
            false ->
                {VipSt,Player}
        end,
    case NewVipSt =/= VipSt of
        true -> %%vip有改变
            lib_dict:put(?PROC_STATUS_VIP, NewVipSt),
            vip:get_player_vip(NewPlayer),
            vip_load:dbup_vip_info(NewVipSt);
        false ->
            skip
    end,
    vip:calc_player_vip_lv(NewPlayer).


%%更新每周领取  每日晚12点更新，不写库
update_week() ->
    Now = util:unixdate(),
    VipSt = lib_dict:get(?PROC_STATUS_VIP),
    #st_vip{
        week_get_time = WeekGetTime
    } = VipSt,
    NewVipSt =
        case util:is_same_week(WeekGetTime, Now) of
            true -> VipSt;
            false ->
                VipSt#st_vip{
                    week_get_time = Now,
                    week_num = 0
                }
        end,
    ?IF_ELSE(VipSt == NewVipSt, skip, vip_load:dbup_vip_info(NewVipSt)),
    lib_dict:put(?PROC_STATUS_VIP, NewVipSt).


%%更新每日领取  每天晚上12点更新，不写库
%%update1() ->
%%    Now = util:unixtime(),
%%    VipSt = lib_dict:get(?PROC_STATUS_VIP),
%%    #st_vip{
%%        daily_get_time = DailyGetTime
%%   } = VipSt,
%%    NewVipSt =
%%        case util:is_same_date(DailyGetTime, Now) of
%%            true -> VipSt;
%%            false ->
%%                VipSt#st_vip{
%%                    daily_get_time = Now,
%%                    daily_list = []
%%                }
%%        end,
%%    lib_dict:put(?PROC_STATUS_VIP, NewVipSt),
%%    update_week().


