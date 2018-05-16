%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 三月 2018 11:36
%%%-------------------------------------------------------------------
-module(element_load).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("element.hrl").

%% API
-export([
    load_jiandao/1,
    load_element/1,
    update_jiandao/1,
    update_element/1
]).

load_jiandao(Pkey) ->
    Sql = io_lib:format("select stage, lv, point_id from player_jiandao where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [Stage, Lv, PointId] ->
            #st_jiandao{
                pkey = Pkey,
                stage = Stage,
                lv = Lv,
                point_id = PointId
            };
        _ ->
            #st_jiandao{
                pkey = Pkey
            }
    end.

update_jiandao(StJianDao) ->
    #st_jiandao{
        pkey = Pkey,
        stage = Stage,
        lv = Lv,
        point_id = PointId
    } = StJianDao,
    Sql = io_lib:format("replace into player_jiandao set pkey=~p, stage=~p, lv=~p, point_id=~p", [Pkey, Stage, Lv, PointId]),
    db:execute(Sql).

load_element(Pkey) ->
    Sql = io_lib:format("select race, lv, e_lv, stage, pos, is_wear from player_element where pkey=~p", [Pkey]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([Race, Lv, ELv, Stage, Pos, IsWear]) ->
                #element{
                    pkey = Pkey,
                    race = Race,
                    lv = Lv,
                    e_lv = ELv,
                    stage = Stage,
                    pos = Pos,
                    is_wear = IsWear
                }
            end,
            lists:map(F, Rows);
        _ ->
            []
    end.

update_element(Element) ->
    #element{
        pkey = Pkey,
        race = Race,
        lv = Lv,
        e_lv = ELv,
        stage = Stage,
        is_wear = IsWear,
        pos = Pos
    } = Element,
    Sql = io_lib:format("replace into player_element set pkey=~p,race=~p,lv=~p,e_lv=~p,stage=~p,pos=~p,is_wear=~p",
        [Pkey, Race, Lv, ELv, Stage, Pos, IsWear]),
    db:execute(Sql).