%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 二月 2017 19:41
%%%-------------------------------------------------------------------
-module(bubble_init).

-include("server.hrl").
-include("common.hrl").
-include("bubble.hrl").


%% ====================================================================
%% API functions
%% ====================================================================
-export([init/1, bubble2string/1, timer_update/0, logout/0, check_bubble_timeout/2, get_attribute/0, calc_attribute/1, calc_single_attribute/1]).

init(Player) ->
    Now = util:unixtime(),
    StBubble =
        case player_util:is_new_role(Player) of
            true ->
                #st_bubble{pkey = Player#player.key};
            false ->
                case bubble_load:load_bubble(Player#player.key) of
                    [] ->
                        #st_bubble{pkey = Player#player.key};
                    [BubbleList] ->
                        NewBubbleList = bubble2list(BubbleList, Now),
                        BubbleId = fetch_used_bubble(NewBubbleList),
                        #st_bubble{pkey = Player#player.key, bubble_list = NewBubbleList, bubble_id = BubbleId}
                end
        end,
    NewStBubble = calc_attribute(StBubble),
    lib_dict:put(?PROC_STATUS_BUBBLE, NewStBubble),
    Player#player{fashion = Player#player.fashion#fashion_figure{fashion_bubble_id = StBubble#st_bubble.bubble_id}}.


bubble2list(BubbleList, Now) ->
    F = fun(Info) ->
        {BubbleId, Time, Stage, IsUse, ActivationList} =
            case Info of
                {Bubble0, Time0, Stage0, IsUse0} -> {Bubble0, Time0, Stage0, IsUse0, []};
                {Bubble0, Time0, Stage0, IsUse0, ActivationList0} -> {Bubble0, Time0, Stage0, IsUse0, ActivationList0}
            end,
        NewIsUse =
            if IsUse == 1 ->
                if Time > 0 andalso Time < Now -> 0;
                    true -> IsUse
                end;
                true -> IsUse
            end,
        IsEnable = ?IF_ELSE(Time == 0 orelse Time > Now, true, false),
        #bubble{bubble_id = BubbleId, time = Time, stage = Stage, is_use = NewIsUse, is_enable = IsEnable, activation_list = ActivationList}
    end,
    lists:map(F, util:bitstring_to_term(BubbleList)).
bubble2string(BubbleList) ->
    F = fun(Bubble) ->
        {Bubble#bubble.bubble_id, Bubble#bubble.time, Bubble#bubble.stage, Bubble#bubble.is_use, Bubble#bubble.activation_list}
    end,
    util:term_to_bitstring(lists:map(F, BubbleList)).

%%计算属性
calc_attribute(StBubble) ->
    F = fun(Bubble) ->
        if Bubble#bubble.is_enable ->
            calc_single_attribute(Bubble);
            true -> Bubble
        end
    end,
    BubbleList = lists:map(F, StBubble#st_bubble.bubble_list),
    AttributeList = [Bubble#bubble.attribute || Bubble <- BubbleList],
    Attribute = attribute_util:sum_attribute(AttributeList),
    Cbp = attribute_util:calc_combat_power(Attribute),
    StBubble#st_bubble{bubble_list = BubbleList, attribute = Attribute, cbp = Cbp}.

%%计算单泡泡属性
calc_single_attribute(Bubble) ->
    AttrList1 =
        case data_bubble:get(Bubble#bubble.bubble_id) of
            [] ->
                [];
            Base -> Base#base_bubble.attrs
        end,
    AttrList2 =
        case data_bubble_upgrade:get(Bubble#bubble.bubble_id, Bubble#bubble.stage) of
            [] -> [];
            Base1 -> Base1#base_bubble_upgrade.attrs
        end,
    F = fun(Stage) ->
        case data_bubble_upgrade:get(Bubble#bubble.bubble_id, Stage) of
            [] -> [];
            Base2 ->
                Base2#base_bubble_upgrade.lv_attr
        end
    end,
    AttrList3 = lists:flatmap(F, Bubble#bubble.activation_list), %% 等级额外属性
    AttrList = AttrList1 ++ AttrList2 ++ AttrList3,
    Attribute = attribute_util:make_attribute_by_key_val_list(AttrList),
    Cbp = attribute_util:calc_combat_power(Attribute),
    Bubble#bubble{attribute = Attribute, cbp = Cbp}.

get_attribute() ->
    StBubble = lib_dict:get(?PROC_STATUS_BUBBLE),
    StBubble#st_bubble.attribute.

%%检查泡泡过期
check_bubble_timeout(Player, Now) ->
    StBubble = lib_dict:get(?PROC_STATUS_BUBBLE),
    case [Bubble || Bubble <- StBubble#st_bubble.bubble_list, Bubble#bubble.time > 0, Bubble#bubble.time < Now, Bubble#bubble.is_enable] of
        [] -> Player;
        L ->
            F = fun(Bubble, T) ->
                bubble_load:log_bubble(Player#player.key, Player#player.nickname, 3, Bubble#bubble.bubble_id, Bubble#bubble.stage),
                [Bubble#bubble{attribute = #attribute{}, cbp = 0, is_enable = false, is_use = 0} | lists:keydelete(Bubble#bubble.bubble_id, #bubble.bubble_id, T)]
            end,
            BubbleList = lists:foldl(F, StBubble#st_bubble.bubble_list, L),
            StBubble1 = StBubble#st_bubble{bubble_list = BubbleList, is_change = 1},
            NewStBubble = calc_attribute(StBubble1),
            lib_dict:put(?PROC_STATUS_BUBBLE, NewStBubble),
            Player1 = player_util:count_player_attribute(Player, true),
            case lists:keymember(Player#player.fashion#fashion_figure.fashion_bubble_id, #bubble.bubble_id, L) of
                false -> Player1;
                true ->
                    NewPlayer = Player1#player{fashion = Player#player.fashion#fashion_figure{fashion_bubble_id = 0}},
                    NewPlayer
            end
    end.

%%获取当前使用中的泡泡
fetch_used_bubble(BubbleList) ->
    case lists:keyfind(1, #bubble.is_use, BubbleList) of
        false -> 0;
        Bubble -> Bubble#bubble.bubble_id
    end.

%%定时更新
timer_update() ->
    StBubble = lib_dict:get(?PROC_STATUS_BUBBLE),
    if StBubble#st_bubble.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_BUBBLE, StBubble#st_bubble{is_change = 0}),
        bubble_load:replace_bubble(StBubble);
        true ->
            ok
    end.

%%玩家离线
logout() ->
    StBubble = lib_dict:get(?PROC_STATUS_BUBBLE),
    if StBubble#st_bubble.is_change == 1 ->
        bubble_load:replace_bubble(StBubble);
        true ->
            ok
    end.
