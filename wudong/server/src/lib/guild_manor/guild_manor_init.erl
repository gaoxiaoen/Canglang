%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 二月 2017 17:01
%%%-------------------------------------------------------------------
-module(guild_manor_init).
-author("hxming").

-include("guild_manor.hrl").
%% API
-compile(export_all).


init() ->
    Data = guild_manor_load:load_guild_manor(),
    F = fun([Gkey, Lv, Exp, Building, Retinue, Time]) ->
        case guild_ets:get_guild(Gkey) of
            [] ->
                guild_manor_load:del_guild_manor(Gkey);
            _ ->
                BuildingList = building2list(Building),
                RetinueList = retinue2list(Retinue),
                Manor = #g_manor{
                    gkey = Gkey,
                    lv = Lv,
                    exp = Exp,
                    building_list = BuildingList,
                    retinue_list = RetinueList,
                    time = Time
                },
                guild_manor_ets:set_guild_manor(Manor)
        end
        end,
    lists:foreach(F, Data).

%%随从转换
retinue2string(List) ->
    F = fun(Retinue) ->
        {Retinue#manor_retinue.key,
            Retinue#manor_retinue.id,
            Retinue#manor_retinue.color,
            Retinue#manor_retinue.quality,
            Retinue#manor_retinue.talent,
            Retinue#manor_retinue.exp,
            Retinue#manor_retinue.time,
            Retinue#manor_retinue.state,
            Retinue#manor_retinue.state_cd,
            Retinue#manor_retinue.state_log
        }
        end,
    util:term_to_bitstring(lists:map(F, List)).
retinue2list(String) ->
    F = fun({Key, Id, Color, Quality, Talent, Exp, Time, State, Cd, Log}) ->
        #manor_retinue{key = Key, id = Id, color = Color, quality = Quality, exp = Exp, talent = Talent, time = Time, state = State, state_cd = Cd, state_log = Log}
        end,
    lists:map(F, util:bitstring_to_term(String)).

%%建筑转换
building2string(List) ->
    F = fun(Building) ->
        {Building#manor_building.type,
            Building#manor_building.lv,
            Building#manor_building.exp,
            util:term_to_bitstring(Building#manor_building.talent),
            Building#manor_building.refresh_time,
            Building#manor_building.special_task_cd,
            task2list(Building#manor_building.task),
            box2list(Building#manor_building.box_list)
        }
        end,
    util:term_to_bitstring(lists:map(F, List)).
building2list(String) ->
    F = fun({Type, Lv, Exp, Talent, RefreshTime, SpecialTaskCd, Task, Box}) ->
        #manor_building{
            type = Type,
            lv = Lv,
            exp = Exp,
            talent = util:bitstring_to_term(Talent),
            refresh_time = RefreshTime,
            special_task_cd = SpecialTaskCd,
            task = task2record(Task),
            box_list = box2record(Box)
        }
        end,
    lists:map(F, util:bitstring_to_term(String)).


task2list(List) ->
    F = fun(Task) ->
        RetinueList = [{Retinue#manor_retinue.key, Retinue#manor_retinue.id, Retinue#manor_retinue.color, Retinue#manor_retinue.quality, Retinue#manor_retinue.talent} || Retinue <- Task#manor_building_task.retinue],
        {Task#manor_building_task.task_id,
            Task#manor_building_task.type,
            Task#manor_building_task.time,
            Task#manor_building_task.pkey,
            util:term_to_bitstring(RetinueList),
            Task#manor_building_task.ratio,
            Task#manor_building_task.team_ratio,
            util:term_to_bitstring(Task#manor_building_task.team_talent)
        }
        end,
    lists:map(F, List).
task2record(List) ->
    F = fun({Tid, Type, Time, Pkey, Retinue, Ratio, TeamRatio, TeamTalent}) ->
        RetinueList = [#manor_retinue{key = Key, id = Id, color = Color, quality = Quality, talent = Talent} || {Key, Id, Color, Quality, Talent} <- util:bitstring_to_term(Retinue)],
        #manor_building_task{
            task_id = Tid,
            type = Type,
            time = Time,
            pkey = Pkey,
            retinue = RetinueList,
            ratio = Ratio,
            team_ratio = TeamRatio,
            team_talent = util:bitstring_to_term(TeamTalent)
        }
        end,
    lists:map(F, List).

box2record(List) ->
    F = fun({Key, BoxId, Times, Log}) ->
        #manor_building_box{
            key = Key,
            box_id = BoxId,
            open_times = Times,
            log = util:bitstring_to_term(Log)
        }
        end,
    lists:map(F, List).
box2list(List) ->
    F = fun(Box) ->
        {Box#manor_building_box.key,
            Box#manor_building_box.box_id,
            Box#manor_building_box.open_times,
            util:term_to_bitstring(Box#manor_building_box.log)
        }
        end,
    lists:map(F, List).
