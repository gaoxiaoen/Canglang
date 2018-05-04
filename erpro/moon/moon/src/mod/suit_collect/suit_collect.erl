%%----------------------------------------------------
%% 套装收集
%% @author weihua@jieyou.cn
%%----------------------------------------------------

-module(suit_collect).
-export([
        calc_attrs/1
        ,collected/1
        ,info/1
        ,push_acc_attrs/1
    ]
).

-include("item.hrl").
-include("common.hrl").
-include("role.hrl").
-include("suit.hrl").
-include("link.hrl").

%% @spec calc_attrs(Role) -> NewRole
%% Role = NewRole = #role{}
%% @doc 计算套装属性
calc_attrs(Role) ->
    SuitData = collected(Role),
    AccAttrs = do_calc_attrs(SuitData),
    Role1 = handle_honor(Role, SuitData),
    push_acc_attrs(Role, AccAttrs),
    case role_attr:do_attr(role_attr:trans_atrrs(AccAttrs), Role1) of
        {false, Reason} ->
            ?ERR("计算角色套装属性加成失败 [reason:~s]", [Reason]),
            Role1;
        {ok, NewRole} ->
            NewRole
    end.

%% @spec collected(Role) -> List
%% Role = #role{}
%% List = [#suit_collect_data{} | ..]
%% @doc 获取套装情况
collected(Role) ->
    ItemIds = owned_eqms(Role),
    collected(Role, ItemIds, suit_collect_data:list()).

%% @spec info(Role) -> Data
%% @doc 套装信息
info(Role) ->
    SuitData = collected(Role),
    [{ID, Name, Components, Effects} || #suit_collect_data{id = ID, name = Name, components = Components, effects = Effects} <- SuitData].

%% @spec push_acc_attrs(Role) -> ok
%% @doc 推送属性加成
push_acc_attrs(Role) ->
    SuitData = collected(Role),
    Attrs = do_calc_attrs(SuitData),
    push_acc_attrs(Role, Attrs).
push_acc_attrs(#role{link = #link{conn_pid = ConnPid}}, Attrs) ->
    sys_conn:pack_send(ConnPid, 19451, {Attrs}).

%% -------------------------------------------------------------------------------------------
%% 私有函数
%% -------------------------------------------------------------------------------------------
%% 计算套装属性加成
do_calc_attrs(Suits) ->
    do_calc_attrs(Suits, []).
do_calc_attrs([], Attrs) ->
    Attrs;
do_calc_attrs([#suit_collect_data{attr = Attrs} | Suits], AccAttrs) ->
    Fun = fun
        ({Label, Value}, Acc) ->
            case lists:keyfind(Label, 1, Acc) of
                false -> [{Label, Value} | Acc];
                {_, OldValue} -> lists:keyreplace(Label, 1, Acc, {Label, OldValue+Value})
            end
    end,
    NewAccAttrs = lists:foldl(Fun, AccAttrs, Attrs),
    do_calc_attrs(Suits, NewAccAttrs).

%% 根据当前拥有的装备计算拥有的套装
collected(Role, Items, Suits) ->
    collected(Role, Items, Suits, []).

collected(_Role, _Items, [], CollectedSuitDatas) ->
    CollectedSuitDatas;
collected(Role, Items, [Suit | Suits], CollectedSuitDatas) ->
    case suit_collect_data:get(Suit) of
        false ->
            collected(Role, Items, Suits, CollectedSuitDatas);
        {ok, SuitData} ->
            NewSuitCollectedData = do_collected(Role, Items, SuitData),
            collected(Role, Items, Suits, [NewSuitCollectedData | CollectedSuitDatas])
    end.

%% 重新计算套装数据
do_collected(Role, Items, Scd = #suit_collect_data{components = Components, effects = Effects}) ->
    {NewComponents, CollectedComponents} = do_collected(Role, Items, Components, [], []),
    {Attr, NextAttr, NextNum} = suit_effect(Effects, length(CollectedComponents)),
    Scd#suit_collect_data{components = NewComponents, collected = CollectedComponents, attr = Attr, next_num = NextNum, next_attr = NextAttr}.

do_collected(_Role, _Items, [], NewComponents, CollectedComponents) ->
    {NewComponents, CollectedComponents};
%% 性别限制
do_collected(Role = #role{sex = Sex}, Items, [{sex, OptComponents} | Components], NewComponents, CollectedComponents) ->
    case lists:keyfind(Sex, 1, OptComponents) of
        false ->
            ?ERR("套装数据错误，找不到性别 ~w 的组件数据", [Sex]),
            do_collected(Role, Items, Components, NewComponents, CollectedComponents);
        {_, ComponentId} ->
            case lists:member(ComponentId, Items) of
                true -> do_collected(Role, Items, Components, [ComponentId | NewComponents], [ComponentId | CollectedComponents]);
                false -> do_collected(Role, Items, Components, [ComponentId | NewComponents], CollectedComponents)
            end
    end;
%% 职业
do_collected(Role = #role{career = Career}, Items, [{career, OptComponents} | Components], NewComponents, CollectedComponents) ->
    case lists:keyfind(Career, 1, OptComponents) of
        false when Career =:= ?career_xinshou ->
            do_collected(Role, Items, Components, NewComponents, CollectedComponents);
        false ->
            ?ERR("套装数据错误，找不到职业 ~w 的组件数据", [Career]),
            do_collected(Role, Items, Components, NewComponents, CollectedComponents);
        {_, ComponentId} ->
            case lists:member(ComponentId, Items) of
                true -> do_collected(Role, Items, Components, [ComponentId | NewComponents], [ComponentId | CollectedComponents]);
                false -> do_collected(Role, Items, Components, [ComponentId | NewComponents], CollectedComponents)
            end
    end;
%% 飞升职业
do_collected(Role = #role{career = Career}, Items, [{ascend, OptComponents} | Components], NewComponents, CollectedComponents) ->
    Ascend = ascend:get_ascend(Role),
    case Ascend =:= 0 of
        true ->
            do_collected(Role, Items, Components, NewComponents, CollectedComponents);
        false ->
            case lists:keyfind({Career, Ascend}, 1, OptComponents) of
                false ->
                    ?ERR("套装数据错误，找不到职业 ~w 的组件数据", [Career]),
                    do_collected(Role, Items, Components, NewComponents, CollectedComponents);
                {_, ComponentId} ->
                    case lists:member(ComponentId, Items) of
                        true -> do_collected(Role, Items, Components, [ComponentId | NewComponents], [ComponentId | CollectedComponents]);
                        false -> do_collected(Role, Items, Components, [ComponentId | NewComponents], CollectedComponents)
                    end
            end
    end;

%% 无限制单一物品
do_collected(Role, Items, [ComponentId | Components], NewComponents, CollectedComponents) when is_integer(ComponentId) ->
    case lists:member(ComponentId, Items) of
        true -> do_collected(Role, Items, Components, [ComponentId | NewComponents], [ComponentId | CollectedComponents]);
        false -> do_collected(Role, Items, Components, [ComponentId | NewComponents], CollectedComponents)
    end;
%% 错误
do_collected(Role, Items, [_ComponentId | Components], NewComponents, CollectedComponents) ->
    ?ERR("错误的套装组件数据 [~w]", [_ComponentId]),
    do_collected(Role, Items, Components, NewComponents, CollectedComponents).


%% 获取角色当前拥有的装备
owned_eqms(Role = #role{dress = Dress}) ->
    Wings = wing:skins(Role),
    DressIds = [BaseId || #item{base_id = BaseId} <- Dress],
    Wings ++ DressIds.

%% 套装拥有效果
suit_effect(Effects, Num) ->
    suit_effect(lists:reverse(lists:keysort(1, Effects)), Num, [], [], 0).
suit_effect([], _Num, Attrs, NextAttr, NextNum) ->
    {Attrs, NextAttr, NextNum};
suit_effect([{NumCond, Effect} | Effects], Num, Attrs, NextAttr, NextNum) when Num >= NumCond ->
    NewAttrs = acc_attrs(Effect, Attrs),
    suit_effect(Effects, Num, NewAttrs, NextAttr, NextNum);
suit_effect([{NextNo, NextEffect} | Effects], Num, Attrs, _NextAttr, _NextNum) ->
    suit_effect(Effects, Num, Attrs, NextEffect, NextNo).

%% 累加属性
acc_attrs([], Attrs) ->
    Attrs;
acc_attrs([{Label, Value} | Effect], Attrs) ->
    case lists:keyfind(Label, 1, Attrs) of
        {_, OldValue} -> acc_attrs(Effect, lists:keyreplace(Label, 1, Attrs, {Label, Value + OldValue}));
        _ -> acc_attrs(Effect, [{Label, Value} | Attrs])
    end.

%% 处理称号
handle_honor(Role, SuitData) ->
%%    Role1 = del_honor(Role, SuitData),
    NewRole = add_honor(Role, SuitData),
    achievement:push_info(refresh, honor, NewRole),
    NewRole.

%% 删除称号
%% del_honor(Role, []) -> Role;
%% del_honor(Role, [#suit_collect_data{honor = Id} | SuitData]) ->
%%     case achievement:del_honor_no_push(Role, Id) of
%%         {ok, NewRole} -> del_honor(NewRole, SuitData);
%%         _ -> del_honor(Role, SuitData)
%%     end.

%% 增加称号
add_honor(Role, []) -> Role;
add_honor(Role, [#suit_collect_data{honor = Honor, components = Coms, collected = Comsed} | SuitData]) ->
    case length(Coms) =:= length(Comsed) of
        true ->
            case achievement:add_honor_no_push(Role, Honor) of
                {ok, NewRole} -> add_honor(NewRole, SuitData);
                _ -> add_honor(Role, SuitData)
            end;
        _ ->
            add_honor(Role, SuitData)
    end.
