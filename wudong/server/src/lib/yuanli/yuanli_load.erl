%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 二月 2016 下午2:26
%%%-------------------------------------------------------------------
-module(yuanli_load).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("yuanli.hrl").

%% API
-export([
    dbget_yuanli_info/1,
    dbup_yuanli_info/1
]).

dbget_yuanli_info(Player) ->
    #player{key = Pkey} = Player,
    NewSt = #st_yuanli{
        pkey = Pkey,
        dict = dict:new(),
        tupo_lv = 0,
        spec_times = 0,
        spec_update_time = 0,
        dirty = 0
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select data_list,tupo_lv,cd_time,spec_times,spec_update_time from player_yuanli where pkey = ~p",[Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [DataBin,TupoLv,CdTime,SpecTimes,SpecUpdateTime] ->
                    F = fun({Id,Lv},AccDict) ->
                            dict:store(Id,#yuanli{id=Id,lv=Lv},AccDict)
                        end,
                    Dict = lists:foldl(F,dict:new(),util:bitstring_to_term(DataBin)),
                    #st_yuanli{
                        pkey = Pkey,
                        dict = Dict,
                        tupo_lv = TupoLv,
                        cd_time = CdTime,
                        spec_times = SpecTimes,
                        spec_update_time = SpecUpdateTime,
                        dirty = 0
                    }
            end
    end.

dbup_yuanli_info(YuanliSt) ->
    #st_yuanli{
        pkey = Pkey,
        dict = Dict,
        tupo_lv = TupoLv,
        cd_time = CdTime,
        spec_times = SpecTimes,
        spec_update_time = SpecUpdateTime
    } = YuanliSt,
    F = fun({_Key,Yuanli}) ->
            #yuanli{
                id = Id,
                lv = Lv
            } = Yuanli,
            {Id,Lv}
        end,
    DataList = lists:map(F,dict:to_list(Dict)),
    Sql = io_lib:format("replace into player_yuanli set data_list = '~s', tupo_lv=~p, cd_time=~p, spec_times=~p, spec_update_time=~p, pkey = ~p",
        [util:term_to_bitstring(DataList),TupoLv,CdTime,SpecTimes,SpecUpdateTime,Pkey]),
    db:execute(Sql),
    ok.