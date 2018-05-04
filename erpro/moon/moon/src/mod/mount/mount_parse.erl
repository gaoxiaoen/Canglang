%%----------------------------------------------------
%% 坐骑数据版本控制
%% @author lishen(105326073@qq.com
%%----------------------------------------------------
-module(mount_parse).
-export([do/2]).

-include("item.hrl").
-include("storage.hrl").
-include("common.hrl").

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
do(Eqms, Mounts) ->
    case mounts_parse(Eqms, Mounts) of
        {false, Reason} ->
            {false, Reason};
        {ok, NewMounts} ->
            recalc(Eqms, NewMounts)
    end.

%%----------------------------------------------------
%% 私有函数
%%----------------------------------------------------
recalc(Eqms, Mounts = #mounts{items = []}) ->
    EqmPos = eqm:type_to_pos(?item_zuo_qi),
    case lists:keyfind(EqmPos, #item.pos, Eqms) of
        false -> Mounts;
        Item ->
            Mount = mount:make(Item),
            {NewMounts, _NewMount} = mount:add(Mounts, Mount, EqmPos),
            NewMounts
    end;
recalc(Eqms, Mounts = #mounts{items = Items}) ->
    EqmPos = eqm:type_to_pos(?item_zuo_qi),
    NewMounts = case lists:keyfind(EqmPos, #item.pos, Eqms) of
        false -> Mounts;
        Item ->
            case lists:keyfind(EqmPos, #item.pos, Items) of
                false ->
                    {NMs, _NM} = mount:add(Mounts, Item, EqmPos),
                    NMs;
                _ ->
                    Mounts
            end
    end,
    do_recalc(NewMounts).

do_recalc(Mounts = #mounts{items = Items}) ->
    {Num, NewItems} = do_recalc(Items, 0, []),
    Mounts#mounts{next_id = Num + 1, num = Num, items = NewItems}.

do_recalc([], Num, NewItems) -> {Num, NewItems};
do_recalc([H | T], Num, NewItems) ->
    do_recalc(T, Num + 1, [mount:make(H#item{id = Num + 1}) | NewItems]).

mounts_parse(Eqms, {mounts, NextId, Num, []}) ->
    {SkinId, Skins} = case lists:keyfind(eqm:type_to_pos(?item_zuo_qi), #item.pos, Eqms) of
        false -> {0, []};
        #item{base_id = BaseId} -> {BaseId, [BaseId]}
    end,
    mounts_parse(Eqms, {mounts, NextId, Num, [], SkinId, 1, Skins});

mounts_parse(Eqms, {mounts, NextId, Num, Items}) ->
    Skins = [BaseId || #item{base_id = BaseId} <- Items],
    NewSkins = mount:add_skins(Skins, []),
    SkinId = case lists:keyfind(eqm:type_to_pos(?item_zuo_qi), #item.pos, Eqms) of
        false -> 0;
        #item{base_id = BaseId} -> BaseId
    end,
    mounts_parse(Eqms, {mounts, NextId, Num, Items, SkinId, 1, NewSkins});

mounts_parse(Eqms, {mounts, NextId, Num, Items, SkinId, SkinGrade, NewSkins}) ->
    mounts_parse(Eqms, {mounts, NextId, Num, Items, SkinId, SkinGrade, NewSkins, 0, 0});

mounts_parse(_Eqms, Mounts) ->
    case is_record(Mounts, mounts) of
        true ->
            case item_parse(Mounts) of
                {ok, NewMounts} ->
                    {ok, NewMounts};
                {false, Reason} ->
                    {false, Reason}
            end;
        false ->
            {false, ?L(<<"坐骑数据转换时发生异常">>)}
    end.

item_parse(Mounts = #mounts{items = Items}) ->
    case item_parse:do(Items) of
        {ok, NewItems} ->
            {ok, Mounts#mounts{items = NewItems}};
        {false, Reason} ->
            ?ERR("坐骑列表物品数据转换失败"),
            {false, Reason}
    end.
