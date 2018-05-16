%%%----------------------------------------------------------------------
%%% @desc   : 永久掩码
%%%----------------------------------------------------------------------

-module(player_mask).
-author('lzx').

-include("common.hrl").
-include("server.hrl").

-export([init/1,save/0]).

-export([get/1,get/2,set/2,delete/1,list/0,get_by_player_id/3,set_by_player_id/3]).

init(#player{key = PlayerId} = Player) ->
    case player_util:is_new_role(Player) of
        true ->
            lib_dict:put(?PROC_STATUS_PLAYER_MASK, #player_mask{player_id = PlayerId});
        _ ->
            PlayerMask =
                case get_from_db(PlayerId) of
                    #player_mask{} = _PlayerMask -> _PlayerMask;
                    _ -> #player_mask{player_id = PlayerId}
                end,

            Dict = lists:foldl(fun({Id,Val},AccInDict) ->
                dict:store(Id,Val,AccInDict)
                               end,PlayerMask#player_mask.mask_dict,PlayerMask#player_mask.list),
            lib_dict:put(?PROC_STATUS_PLAYER_MASK,PlayerMask#player_mask{mask_dict = Dict})
    end,
    Player.

get_from_db(PlayerId)->
    Sql = io_lib:format("SELECT `list` FROM `player_mask` WHERE player_id = ~p",[PlayerId]),
    case db:get_row(Sql) of
        [List] ->
            #player_mask{player_id=PlayerId, list=util:bitstring_to_term(List)};
        [] -> false
    end.

save() ->
    #player_mask{player_id = PlayerId,
        mask_dict = Dict,
        is_change = IsChange
    } = PlayerMask = lib_dict:get(?PROC_STATUS_PLAYER_MASK),
    case IsChange of
        1 ->
            List = [{K, V} || {K, V} <- dict:to_list(Dict)],
            Sql = io_lib:format("REPLACE INTO player_mask SET `player_id`=~p,`list`='~s'",[PlayerId,util:term_to_bitstring(List)]),
            db:execute(Sql),
            lib_dict:put(?PROC_STATUS_PLAYER_MASK, PlayerMask#player_mask{is_change = 0,list = List});
        _ ->
            ok
    end.


%% 获取掩码
get(Key) ->
    get(Key,undefined).
get(Key,Default) ->
    #player_mask{mask_dict = Dict} = lib_dict:get(?PROC_STATUS_PLAYER_MASK),
    case dict:find(Key,Dict) of
        {ok,Val} -> Val;
        error -> Default
    end.


%% 玩家不在线 获取
get_by_player_id(PlayerId,Key,Default) ->
    case get_from_db(PlayerId) of
        #player_mask{list = MaskList} -> ok;
        _ -> MaskList = []
    end,
    case lists:keyfind(Key, 1, MaskList) of
        false ->
            Default;
        {Key,Val} ->
            Val
    end.

%% 改变离线数据
set_by_player_id(PlayerId,Key,Value) ->
    case get_from_db(PlayerId) of
        #player_mask{list = MaskList} -> ok;
        _ -> MaskList = []
    end,
    NewMaskList =
    case lists:keytake(Key,1,MaskList) of
        {value,_,MaskList2} ->
            [{Key,Value}|MaskList2];
        _ ->
            [{Key,Value}|MaskList]
    end,
    Sql = io_lib:format("REPLACE INTO player_mask SET `player_id`=~p,`list`='~s'",[PlayerId,util:term_to_bitstring(NewMaskList)]),
    db:execute(Sql).


%% 设置掩码
set(Key,Val) ->
    #player_mask{mask_dict = Dict} = PlayerMask = lib_dict:get(?PROC_STATUS_PLAYER_MASK),
    NewDict = dict:store(Key,Val,Dict),
    lib_dict:put(?PROC_STATUS_PLAYER_MASK,PlayerMask#player_mask{mask_dict = NewDict,is_change = 1}),
    ok.

%% 删除掩码
delete(Key) ->
    #player_mask{mask_dict = Dict} = PlayerMask = lib_dict:get(?PROC_STATUS_PLAYER_MASK),
    NewDict = dict:erase(Key,Dict),
    lib_dict:put(?PROC_STATUS_PLAYER_MASK,PlayerMask#player_mask{mask_dict = NewDict,is_change = 1}),
    ok.

%% 列出所有掩码
list() ->
    #player_mask{mask_dict = Dict} = lib_dict:get(?PROC_STATUS_PLAYER_MASK),
    [{K,V} || {K,V} <- dict:to_list(Dict)].
