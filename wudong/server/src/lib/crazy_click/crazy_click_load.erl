%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 二月 2016 下午3:56
%%%-------------------------------------------------------------------
-module(crazy_click_load).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("crazy_click.hrl").

%% API
-export([
    dbget_crazy_click/1,
    dbup_crazy_click/1
]).

dbget_crazy_click(Player) ->
    #player{
        key = Pkey
    } = Player,
    Now = util:unixtime(),
    InitAttTimes = 20,
    NewSt = #st_click{
        pkey = Pkey,
        att_times = InitAttTimes,
        cd_time = Now,
        mon_id = 0,
        mon_hp = 0,
        update_time = Now
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select att_times,cd_times,mon_id,mon_hp,update_time from player_crazy_click where pkey =~p",[Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [AttTimes,CdTimes,MonId,MonHp,UpdateTime] ->
                    #st_click{
                        pkey = Pkey,
                        att_times = AttTimes,
                        cd_time = CdTimes,
                        mon_id = MonId,
                        mon_hp = MonHp,
                        update_time = UpdateTime
                    }
            end
    end.

dbup_crazy_click(ClickSt) ->
    #st_click{
        pkey = Pkey,
        att_times = AttTimes,
        cd_time = CdTimes,
        mon_id = MonId,
        mon_hp = MonHp,
        update_time = UpdateTime
    } = ClickSt,
    Sql = io_lib:format("replace into player_crazy_click set att_times =~p,cd_times=~p,mon_id=~p,mon_hp=~p,update_time=~p, pkey=~p",[AttTimes,CdTimes,MonId,MonHp,UpdateTime,Pkey]),
    db:execute(Sql),
    ok.