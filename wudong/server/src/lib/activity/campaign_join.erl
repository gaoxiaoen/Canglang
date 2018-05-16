%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         %% lzx 玩家活动参与数据
%%% @end
%%% Created : 23. 十月 2017 11:45
%%%-------------------------------------------------------------------
-module(campaign_join).
-author("lzx").
-include("activity.hrl").


%% API
-export([
    init_ets/0,
    load_join_log/0,
    lookup_join_log/1,
    update_join_log/2,
    update_join_log/1,
    save_join_log/1
]).


init_ets() ->
    ets:new(?ETS_CAMPAIGN_JOIN_LOG, [{keypos, #campaign_join_log.id} | ?ETS_OPTIONS]),
    ok.



%% 把参加活动日志读入ets
load_join_log() ->
    Sql = "select camp_id, act_id, pkey, info_list from sys_campaign_join_log",
    Data = db:get_all(Sql),
    List = format_join_log(Data, []),
    ets:insert(?ETS_CAMPAIGN_JOIN_LOG, List).

format_join_log([], List) -> List;
format_join_log([[CampId, ActId,RoleId,ItemList] | T], List) ->
    NewItemList =
        case util:bitstring_to_term(ItemList) of
            undefined -> [];
            ItemL -> ItemL
        end,
    format_join_log(T, [#campaign_join_log{id = {CampId, ActId,RoleId}, info = NewItemList} | List]).


%% 查找玩家的购买记录
lookup_join_log(Key = {_CampId,_ActId,_PlayerId}) ->
    case ets:lookup(?ETS_CAMPAIGN_JOIN_LOG, Key) of
        [] -> none;
        [R | _] ->
            R
    end.


%% 更新玩家的购买记录
update_join_log(Key = {_CampId,_ActId,_PlayerId}, Value) ->
    case lookup_join_log(Key) of
        none ->
            Record = #campaign_join_log{id = Key, info = Value},
            update_join_log(Record);
        R = #campaign_join_log{info = OldV} ->
            Record = R#campaign_join_log{info = Value ++ OldV},
            update_join_log(Record)
    end.


update_join_log(#campaign_join_log{} = Record) ->
    ets:insert(?ETS_CAMPAIGN_JOIN_LOG, Record),
    save_join_log(Record).


%% 保存活动信息
save_join_log(#campaign_join_log{id = {CampId, ActId,RoleId}, info = InfoList}) ->
    Sql = io_lib:format("replace into sys_campaign_join_log (camp_id, act_id,pkey, info_list) value (~p, ~p, ~p, ~s)", [CampId, ActId, RoleId, util:term_to_bitstring(InfoList)]),
    db:execute(Sql).











