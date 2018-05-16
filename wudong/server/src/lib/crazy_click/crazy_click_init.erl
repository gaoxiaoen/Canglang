%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 二月 2016 下午3:56
%%%-------------------------------------------------------------------
-module(crazy_click_init).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("crazy_click.hrl").

%% API
-export([
    init/1,
    logout/1,
    update/1
]).

init(Player) ->
    ClickSt = crazy_click_load:dbget_crazy_click(Player),
    lib_dict:put(?PROC_STATUS_CRAZY_CLICK, ClickSt),
    update(Player),
    Player.

update(Player) ->
    ClickSt = lib_dict:get(?PROC_STATUS_CRAZY_CLICK),
    #st_click{
        mon_hp = MonHp,
        update_time = UpdateTime,
        att_times = AttTimes
    } = ClickSt,
    %%隔天增加攻击次数
    Now = util:unixtime(),
    NewAttTimes =
        case util:is_same_date(Now, UpdateTime) of
            true -> AttTimes;
            false ->
                MaxAttTimes = crazy_click:get_max_att_times(Player),
                AddTimes = data_vip_args:get(27,Player#player.vip_lv),
                min(MaxAttTimes,AttTimes+AddTimes)
        end,
    NewClickSt = ClickSt#st_click{
        update_time = Now,
        att_times = NewAttTimes
    },
    lib_dict:put(?PROC_STATUS_CRAZY_CLICK, NewClickSt),

    case MonHp == 0 of
        true -> %%怪物已死亡，刷新怪物
            crazy_click:refresh_mon();
        false ->
            skip
    end,
    ok.

logout(Player) ->
    crazy_click:update_att_cd(Player),
    ClickSt = lib_dict:get(?PROC_STATUS_CRAZY_CLICK),
    crazy_click_load:dbup_crazy_click(ClickSt),
    ok.
