%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 十二月 2017 15:15
%%%-------------------------------------------------------------------
-module(godness_load).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("godness.hrl").
-include("goods.hrl").

%% API
-export([
    load/1,
    update/1
]).

load(Pkey) ->
    Sql = io_lib:format("select `key`,godness_id,is_war,lv,star,exp,skill_list from godness where pkey=~p",
        [Pkey]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([Key,GodnessId,IsWar,Lv,Star,Exp,SkillListBin]) ->
                #godness{
                    key = Key,
                    pkey = Pkey,
                    godness_id = GodnessId,
                    is_war = IsWar,
                    lv = Lv,
                    star = Star,
                    exp = Exp,
                    skill_list = util:bitstring_to_term(SkillListBin)
                }
            end,
            lists:map(F, Rows);
        _ ->
            []
    end.

update(Godness) ->
    #godness{
        key = Key,
        pkey = Pkey,
        godness_id = GodnessId,
        is_war = IsWar,
        lv = Lv,
        star = Star,
        exp = Exp,
        skill_list = SkillList
    } = Godness,
    SkillListBin = util:term_to_bitstring(SkillList),
    Sql = io_lib:format("replace into godness set `key`=~p,pkey=~p,godness_id=~p,is_war=~p,lv=~p,star=~p,exp=~p,skill_list='~s'",
        [Key,Pkey,GodnessId,IsWar,Lv,Star,Exp,SkillListBin]),
    db:execute(Sql),
    ok.