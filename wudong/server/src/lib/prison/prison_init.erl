%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 三月 2017 下午2:44
%%%-------------------------------------------------------------------
-module(prison_init).
-author("fengzhenlin").
-include("server.hrl").

%% API
-export([
    init/1,
    logout/1
]).

init(Player) ->
    Pk = dbget_prison_info(Player),
    Pk.

logout(Player) ->
    dbup_prison_info(Player),
    ok.

dbget_prison_info(Player) ->
    Init = #pk{},
    case player_util:is_new_role(Player) of
        true -> Init;
        false ->
            Sql = io_lib:format("select pk,pk_val,pk_change_time,pk_old,chivalry,kill_count,protect_time,online_time from player_pk where pkey=~p",[Player#player.key]),
            case db:get_row(Sql) of
                [] -> Init;
                [Pk,PkVal,PkChangeTime,PkOld,Chivalry,KillCount,ProtectTme,OnlineTime] ->
                    Init#pk{
                        pk = Pk,
                        value = PkVal,
                        pk_old = PkOld,
                        change_time = PkChangeTime,
                        chivalry = Chivalry,
                        kill_count = KillCount,
                        protect_time = ProtectTme,
                        online_time = OnlineTime,
                        calc_time = util:unixtime()
                    }
            end
    end.

dbup_prison_info(Player) ->
    #pk{
        pk = Pk,
        value = PkVal,
        pk_old = PkOld,
        change_time = PkChangeTime,
        chivalry = Chivalry,
        kill_count = KillCount,
        protect_time = ProtectTime,
        online_time = OnlineTime
    } = Player#player.pk,
    Sql = io_lib:format("replace into player_pk set pkey=~p,pk=~p,pk_val=~p,pk_change_time=~p,pk_old=~p,chivalry=~p,kill_count=~p,protect_time=~p,online_time=~p",
        [Player#player.key,Pk,PkVal,PkChangeTime,PkOld,Chivalry,KillCount,ProtectTime,OnlineTime]),
    db:execute(Sql),
    ok.

