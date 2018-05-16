%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 十一月 2015 11:19
%%%-------------------------------------------------------------------
-module(treasure_load).
-author("hxming").

-include("treasure.hrl").
%% API
-compile(export_all).


select_treasure(Pkey)->
    Sql = io_lib:format(<<"select map_id,scene,x,y,shadow_kill,pet_kill,time,times from player_treasure where pkey = ~p " >>,[Pkey]),
    db:get_row(Sql).

replace_treasure(Treasure)->
    Sql = io_lib:format(<<"replace into player_treasure set pkey = ~p,map_id = ~p,scene = ~p,x=~p,y=~p,shadow_kill=~p,pet_kill=~p,time=~p,times=~p ">>,
        [Treasure#treasure.pkey,
            Treasure#treasure.map_id,
            Treasure#treasure.scene,
            Treasure#treasure.x,
            Treasure#treasure.y,
            Treasure#treasure.shadow_kill,
            Treasure#treasure.pet_kill,
            Treasure#treasure.time,
            Treasure#treasure.times]),
    db:execute(Sql).


log_treasure(Pkey, Nickname, MapId, Act, Time) ->
    Sql = io_lib:format(<<"insert into log_treasure set pkey = ~p,nickname = ~p,,map_id=~p,act=~p,time=~p">>, [Pkey, Nickname, MapId, Act, Time]),
    log_proc:log(Sql),
    ok.