%%----------------------------------------------------
%% 后台控制系统
%% @author shawn 
%%----------------------------------------------------
-module(platform_cfg).

%% 后台接口
-export([
        modify/2
        ,get_cfg/0
        ,get_cfg/1
        ,save/1
        ,push_cfg/0
        ,clean/0
        ,adm_reload/1
        ,adm_get/0
    ]
).

-ifndef(zh_cn).
-ifndef(zh_tw).
-define(zh_cn, 0).
-else.
-endif.
-endif.

-include("common.hrl").

%% 获取全部状态
get_cfg() -> 
    Flag = case sys_env:get(platform) of
        "taiwan" -> true;
        "taiwanxmfx" -> true;
        "koramgame" -> true;
        _ -> false
    end,
    case catch sys_env:get(platform_cfg) of
        State when is_list(State) -> State;
        _ when Flag =:= true -> [{market_price_tax, 1}]; %% 海外平台默认关闭税率
        _ -> [{market_price_tax, 0}]
    end.

adm_reload(State) ->
    ?DEBUG("State~p~n", [State]),
    OldState = get_cfg(),
    adm_reload(State, OldState).
adm_reload([], NewState) ->
    save(NewState),
    pack_to_all(NewState), 
    ok;
adm_reload([{_Key, -1} | T], NewState) ->
    adm_reload(T, NewState);
adm_reload([{Key, Value} | T], NewState) ->
    GetKey = adm_to_atom(Key),
    New = case lists:keyfind(GetKey, 1, NewState) of
        false -> [{GetKey, Value} | NewState];
        {_, _} -> lists:keyreplace(GetKey, 1, NewState, {GetKey, Value})
    end,
    adm_reload(T, New).

adm_get() ->
    State = get_cfg(),
    adm_get(State, []).
adm_get([], NewState) -> NewState;
adm_get([{Key, Val} | T], NewState) ->
    GetKey = atom_to_adm(Key),
    adm_get(T, [{GetKey, Val} | NewState]).

pack_to_all(State)->
    ?DEBUG("pack_to_all:~p~n", [State]),
    PackInfo = to_client(State, []),
    ?DEBUG("pack_to_all,PackInfo:~p~n", [PackInfo]),
    role_group:pack_cast(world, 14112, {PackInfo}).

%% @spec modify(Option, Value) -> ok.
%% Option = hp_ratio | drop_ratio
%% Value = int(), 默认为1
modify(Option, Value) ->
    State = get_cfg(),
    NewState = case lists:keyfind(Option, 1, State) of
        false -> [{Option, Value} | State];
        {_, _} -> lists:keyreplace(Option, 1, State, {Option, Value})
    end,
    save(NewState).

%% 获取某个标签的值
get_cfg(Label) ->
    State = get_cfg(),
    case lists:keyfind(Label, 1, State) of
        {_, Value} -> Value;
        _ -> false
    end.

%% 清除设置
clean() ->
    save([]).

%% 推送全部状态
push_cfg() ->
    State = get_cfg(),
    to_client(State, []).

%% 保存新的状态
save(State) ->
    case sys_env:save(platform_cfg, State) of
        ok -> ?DEBUG("后台控制信息保存成功");
        _E -> ?ERR("后台控制信息保存失败:~w", [_E])
    end.

%%-----------------
to_client([], New) -> New;
to_client([{Key, Value} | T], New) ->
    case to_info(Key) of
        0 -> to_client(T, New);
        N -> to_client(T, [{N, Value} | New])
    end.

%% 返回对应的设置类型
to_info(double_drop) -> 1;
to_info(lottery_open) -> 2;
to_info(casino_open) -> 3;
to_info(market_price_tax) -> 4;
to_info(_) -> 0.

adm_to_atom(1) -> hp_ratio;
adm_to_atom(2) -> drop_ratio;
adm_to_atom(3) -> double_drop;
adm_to_atom(4) -> dungeon_count;
adm_to_atom(5) -> double_card;
adm_to_atom(6) -> market_price_tax;
adm_to_atom(7) -> casino_open;
adm_to_atom(8) -> lottery_open;
adm_to_atom(9) -> impression_up_ratio.

atom_to_adm(hp_ratio) -> 1;    
atom_to_adm(drop_ratio) -> 2;
atom_to_adm(double_drop) -> 3;
atom_to_adm(dungeon_count) -> 4;
atom_to_adm(double_card) -> 5;
atom_to_adm(market_price_tax) -> 6;
atom_to_adm(casino_open) -> 7;
atom_to_adm(lottery_open) -> 8;
atom_to_adm(impression_up_ratio) -> 9.

