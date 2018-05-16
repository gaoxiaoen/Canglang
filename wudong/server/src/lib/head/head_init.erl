%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 10:17
%%%-------------------------------------------------------------------
-module(head_init).
-author("hxming").

-include("server.hrl").
-include("common.hrl").
-include("head.hrl").


%% ====================================================================
%% API functions
%% ====================================================================
-export([init/1, head2string/1, timer_update/0, logout/0, check_head_timeout/2, get_attribute/0, calc_attribute/1, calc_single_attribute/1]).

init(Player) ->
    Now = util:unixtime(),
    StHead =
        case player_util:is_new_role(Player) of
            true ->
                #st_head{pkey = Player#player.key};
            false ->
                case head_load:load_head(Player#player.key) of
                    [] ->
                        #st_head{pkey = Player#player.key};
                    [HeadList] ->
                        NewHeadList = head2list(HeadList, Now),
                        HeadId = fetch_used_head(NewHeadList),
                        #st_head{pkey = Player#player.key, head_list = NewHeadList, head_id = HeadId}
                end
        end,
    NewStHead = calc_attribute(StHead),
    lib_dict:put(?PROC_STATUS_HEAD, NewStHead),
    Player#player{fashion = Player#player.fashion#fashion_figure{fashion_head_id = StHead#st_head.head_id}}.


head2list(HeadList, Now) ->
    F = fun(Info) ->
        {HeadId, Time, Stage, IsUse, ActivationList} =
            case Info of
                {Head0, Time0, Stage0, IsUse0} -> {Head0, Time0, Stage0, IsUse0, []};
                {Head0, Time0, Stage0, IsUse0, ActivationList0} -> {Head0, Time0, Stage0, IsUse0, ActivationList0}
            end,
        NewIsUse =
            if IsUse == 1 ->
                if Time > 0 andalso Time < Now -> 0;
                    true -> IsUse
                end;
                true -> IsUse
            end,
        IsEnable = ?IF_ELSE(Time == 0 orelse Time > Now, true, false),
        #head{head_id = HeadId, time = Time, stage = Stage, is_use = NewIsUse, is_enable = IsEnable, activation_list = ActivationList}
    end,
    lists:map(F, util:bitstring_to_term(HeadList)).

head2string(HeadList) ->
    F = fun(Head) ->
        {Head#head.head_id, Head#head.time, Head#head.stage, Head#head.is_use,Head#head.activation_list}
    end,
    util:term_to_bitstring(lists:map(F, HeadList)).

%%计算属性
calc_attribute(StHead) ->
    F = fun(Head) ->
        if Head#head.is_enable ->
            calc_single_attribute(Head);
            true -> Head
        end
    end,
    HeadList = lists:map(F, StHead#st_head.head_list),
    AttributeList = [Head#head.attribute || Head <- HeadList],
    Attribute = attribute_util:sum_attribute(AttributeList),
    Cbp = attribute_util:calc_combat_power(Attribute),
    StHead#st_head{head_list = HeadList, attribute = Attribute, cbp = Cbp}.

%%计算单时装属性
calc_single_attribute(Head) ->
    AttrList1 =
        case data_head:get(Head#head.head_id) of
            [] ->
                [];
            Base -> Base#base_head.attrs
        end,
    AttrList2 =
        case data_head_upgrade:get(Head#head.head_id, Head#head.stage) of
            [] -> [];
            Base1 -> Base1#base_head_upgrade.attrs
        end,
    F = fun(Stage) ->
        case data_head_upgrade:get(Head#head.head_id, Stage) of
            [] -> [];
            Base2 -> Base2#base_head_upgrade.lv_attr
        end
    end,
    AttrList3 = lists:flatmap(F, Head#head.activation_list), %% 等级额外属性

    AttrList = AttrList1 ++ AttrList2 ++ AttrList3,
    Attribute = attribute_util:make_attribute_by_key_val_list(AttrList),
    Cbp = attribute_util:calc_combat_power(Attribute),
    Head#head{attribute = Attribute, cbp = Cbp}.

get_attribute() ->
    StHead = lib_dict:get(?PROC_STATUS_HEAD),
    StHead#st_head.attribute.

%%检查过期
check_head_timeout(Player, Now) ->
    StHead = lib_dict:get(?PROC_STATUS_HEAD),
    NewPlayer =
        case [Head || Head <- StHead#st_head.head_list, Head#head.time > 0, Head#head.time < Now, Head#head.is_enable] of
            [] -> Player;
            L ->
                F = fun(Head, T) ->
                    head_load:log_head(Player#player.key, Player#player.nickname, 2, Head#head.head_id, Head#head.stage),
                    [Head#head{attribute = #attribute{}, cbp = 0, is_enable = false, is_use = 0} | lists:keydelete(Head#head.head_id, #head.head_id, T)]
                    end,
                HeadList = lists:foldl(F, StHead#st_head.head_list, L),
                StHead1 = StHead#st_head{head_list = HeadList, is_change = 1},
                NewStHead = calc_attribute(StHead1),
                lib_dict:put(?PROC_STATUS_HEAD, NewStHead),
                Player1 = player_util:count_player_attribute(Player, true),
                case lists:keymember(Player#player.fashion#fashion_figure.fashion_head_id, #head.head_id, L) of
                    false -> Player1;
                    true ->
                        Player2 = Player1#player{fashion = Player#player.fashion#fashion_figure{fashion_cloth_id = 0}},
                        scene_agent_dispatch:fashion_update(Player2),
                        Player2
                end
        end,
    fix_xmas_head(NewPlayer).


fix_xmas_head(Player) ->
    case fashion:is_activate(10022) of
        false -> Player;
        true ->
            HeadId = 10022,
            case head:is_activate(HeadId) of
                false ->
                    head:activate_by_goods(Player, HeadId);
                true ->
                    Player
            end
    end.

%%获取当前使用中的时装
fetch_used_head(HeadList) ->
    case lists:keyfind(1, #head.is_use, HeadList) of
        false -> 0;
        Head -> Head#head.head_id
    end.

%%定时更新
timer_update() ->
    StHead = lib_dict:get(?PROC_STATUS_HEAD),
    if StHead#st_head.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_HEAD, StHead#st_head{is_change = 0}),
        head_load:replace_head(StHead);
        true ->
            ok
    end.

%%玩家离线
logout() ->
    StHead = lib_dict:get(?PROC_STATUS_HEAD),
    if StHead#st_head.is_change == 1 ->
        head_load:replace_head(StHead);
        true ->
            ok
    end.
