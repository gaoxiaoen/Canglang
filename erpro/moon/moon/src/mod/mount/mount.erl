%%----------------------------------------------------
%% 坐骑系统 
%% @author lishen(105326073@qq.com)
%%----------------------------------------------------
-module(mount).
-export([
        feed/3
        ,put_mount/2
        ,takeoff_mount/1
        ,equip_mount/2
        ,add/3
        ,make/1
        ,get_skin/2
        ,change_skin/3
        ,put_skin/2
        ,make_skinlist/1
        ,add_skins/2
        ,upgrade/2
        ,del/2
        ,login/1
        ,refresh_growth/2
        ,get_rank_power/1
        ,recover_feed_item/2
        ,do_recover_feed_item/2
        ,batch_refresh_growth/3
        ,choose_growth_per/3
        ,is_both_mount/1
        ,get_now_mount_id/1
        ,calc_power/1
        ,add_buff_skin/2
        ,del_buff_skin/2
    ]).
-export([
        gm_upgrade/1
        ,gm_setlev/2
        ,gm_get_mount_grade/1
    ]).

-include("common.hrl").
-include("item.hrl").
-include("storage.hrl").
%%
-include("role.hrl").
-include("gain.hrl").
-include("assets.hrl").
-include("link.hrl").
-include("condition.hrl").
-include("looks.hrl").

-define(quality_addition(Q), Q * 2).
-define(grade_addition(G), G * 1).
-define(refresh_points, 2).

%%----------------------------------------------------
%% GM命令
%%----------------------------------------------------
gm_upgrade(Role = #role{eqm = EqmList, mounts = Mounts = #mounts{items = Items}, link = #link{conn_pid = ConnPid}}) ->
    EqmPos = eqm:type_to_pos(?item_zuo_qi),
    case lists:keyfind(EqmPos, #item.pos, Items) of
        false -> 
            {false, ?L(<<"没有装备中的坐骑">>)};
        Mount = #item{id = Id, extra = Extra} ->
            EqmMount = lists:keyfind(EqmPos, #item.pos, EqmList),
            NewEqmMount = EqmMount#item{extra = update_extra([{22, 1}], Extra)},
            {ok, NewEqmList, _} = storage_api:fresh_item(EqmMount, NewEqmMount, EqmList, ConnPid),
            NewMount = NewEqmMount#item{id = Id},
            NewMounts = storage_api:fresh_mounts(Mount, NewMount, Mounts, ConnPid),
            {ok, Role#role{eqm = NewEqmList, mounts = NewMounts}}
    end.

gm_setlev(Lev, Role = #role{eqm = EqmList, mounts = Mounts = #mounts{items = Items}, link = #link{conn_pid = ConnPid}}) ->
    EqmPos = eqm:type_to_pos(?item_zuo_qi),
    case lists:keyfind(EqmPos, #item.pos, Items) of
        false -> 
            {false, ?L(<<"没有装备中的坐骑">>)};
        Mount = #item{id = Id, extra = Extra, attr = Attr} ->
            EqmMount = lists:keyfind(EqmPos, #item.pos, EqmList),
            NewExtra = update_extra([{3, Lev}], Extra),
            NewAttr = update_mount_attr(Attr, NewExtra),
            NewEqmMount = calc_skin_attr(EqmMount#item{extra = NewExtra, attr = NewAttr}),
            {ok, NewEqmList, _} = storage_api:fresh_item(EqmMount, NewEqmMount, EqmList, ConnPid),
            NewMount = NewEqmMount#item{id = Id},
            NewMounts = storage_api:fresh_mounts(Mount, NewMount, Mounts, ConnPid),
            Nr = role_api:push_attr(Role#role{mounts = NewMounts, eqm = NewEqmList}),
            map:role_update(Nr),
            {ok, Nr}
    end.

%% @spec gm_get_mount_grade()
%% @doc 后台获取玩家坐骑等级
gm_get_mount_grade(#role{eqm = EqmList}) ->
    gm_get_mount_grade(EqmList);
gm_get_mount_grade(EqmList) ->
    EqmPos = eqm:type_to_pos(?item_zuo_qi),
    case lists:keyfind(EqmPos, #item.pos, EqmList) of
        false -> 0;
        #item{extra = Extra} ->
            case get_extra_data([?extra_mount_grade], Extra, []) of
                {ok, [Grade]} -> Grade;
                _ -> 0
            end
    end.

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
%% @spec login(Role) -> NewRole.
%% @doc 登录处理(第二天早上6点幸运值少于200清零)
%login(Role) -> Role.
login(Role) -> Role.
    
%% @spec is_both_mount(Role) -> true | false
%% @doc 判断是否双人坐骑
is_both_mount(#role{mounts = Mounts}) ->
    is_both_mount(Mounts);
is_both_mount(#mounts{skin_id = SkinId}) when SkinId >= 19100 andalso SkinId =< 19200 ->
    true;
is_both_mount(_) -> false.

%% @spec get_now_mount_id(Role) -> true | false
%% @doc 判断是否双人坐骑
get_now_mount_id(#role{mounts = Mounts}) ->
    get_now_mount_id(Mounts);
get_now_mount_id(#mounts{skin_id = SkinId}) ->
    SkinId;
get_now_mount_id(_) -> 0.

%% @spec feed(Mount, Role) -> {ok, NewRole} | {false, Reason}
%% Mount = #item{}
%% Role = NewRole = #role{}
%% Reason = <<>>
%% @doc 坐骑喂养
feed(Mount, FeedItems, Role = #role{bag = #bag{items = Items}}) ->
    {BaseIdQList, IdQList} = check_items_in_bag(FeedItems, Items, [], []),
    case role_gain:do([#loss{label = item_id, val = IdQList}], Role) of
        {false, L} ->
            {false, L#loss.msg};
        {ok, NewRole} ->
            log:log(log_item_del_loss, {<<"坐骑喂养">>, NewRole}), 
            case do_feed_mount(Mount, NewRole, BaseIdQList) of
                {ok, AddExp, Flag, Nr} ->
                    {ok, AddExp, Flag, Nr};
                {false, Reason} ->
                    log:log_rollback(log_item_del_loss),
                    {false, Reason}
            end
    end.

%% @doc 处理喂养物品恢复后，减除喂养经验逻辑
recover_feed_item(RoleId, Items) ->
    case role_api:lookup(by_id, RoleId) of
        {ok, _, #role{pid = Pid}} ->
            role:apply(async, Pid, {fun do_recover_feed_item/2, [Items]});
        _ ->
            ignore
    end.

%% @doc 处理喂养物品恢复后，减除喂养经验逻辑              
do_recover_feed_item(Role = #role{eqm = Eqms, mounts = Mounts = #mounts{items = Items}, link = #link{conn_pid = ConnPid}}, [#item{base_id = ItemId, quantity = Num}]) ->
    EqmPos = eqm:type_to_pos(?item_zuo_qi),
    case lists:keyfind(EqmPos, #item.pos, Eqms) of
        false ->
            {ok, Role};
        EqmMount ->
            case lists:keyfind(EqmPos, #item.pos, Items) of
                false ->
                    {ok, Role};
                Mount = #item{extra = Extra, attr = Attr} ->
                    case get_extra_data([?extra_mount_exp, ?extra_mount_lev], Extra, []) of
                        {ok, [Exp, Lev]} ->
                            case item_data:get(ItemId) of
                                {ok, #item_base{feed_exp = FeedExp}} ->
                                    ReduceExp = FeedExp * Num,
                                    {NewExp, NewLev} = case Exp >= ReduceExp of
                                        true ->
                                            {Exp - ReduceExp, Lev};
                                        false ->
                                            reduce_feed_exp(Lev - 1, ReduceExp - Exp)
                                    end,
                                    NewExtra = update_extra([{?extra_mount_exp, NewExp}, {?extra_mount_lev, NewLev}], Extra),
                                    NewAttr = update_mount_attr(Attr, NewExtra),
                                    {ok, NewEqmList, _} = storage_api:fresh_item(EqmMount, calc_skin_attr(EqmMount#item{extra = NewExtra, attr = NewAttr}), Eqms, ConnPid),
                                    NewMounts = storage_api:fresh_mounts(Mount, calc_skin_attr(Mount#item{extra = NewExtra, attr = NewAttr}, Mounts), ConnPid),
                                    NewRole = role_api:push_attr(Role#role{eqm = NewEqmList, mounts = NewMounts}),
                                    map:role_update(NewRole),
                                    {ok, NewRole};
                                {false, _Reason} ->
                                    {ok, Role}
                            end;
                        _ ->
                            {ok, Role}
                    end
            end
    end.

%% @spec put_mount(Mount, Role) -> {ok, NewRole} | {false, Reason}.
%% Mount = #item{}
%% Role = NewRole = #role{}
%% Reason = <<>>
%% @doc 装备坐骑(从背包上)
put_mount(Mount = #item{type = ?item_zuo_qi}, Role = #role{mounts = Mounts = #mounts{items = Items}, bag = Bag, eqm = Eqms, link = #link{conn_pid = ConnPid}}) ->
    case item_data:get(Mount#item.base_id) of
        {ok, #item_base{condition = []}} -> {false, ?L(<<"坐骑数据错误">>)};
        {ok, #item_base{condition = Cond}} ->
            case role_cond:check(Cond, Role) of
                {false, RCond} -> {false, RCond#condition.msg};
                true ->
                    case storage:del_item_by_id(Bag, [{Mount#item.id, 1}], true) of  % 删除背包坐骑
                        {false, R} -> {false, R};
                        {ok, NewBag, _, _} ->
                            EqmPos = eqm:type_to_pos(?item_zuo_qi),
                            case lists:keyfind(EqmPos, #item.pos, Eqms) of   % 查找身上坐骑
                                false ->
                                    {NewMounts, NewMount = #item{extra = Extra}} = add(Mounts, Mount, EqmPos),
                                    PutItem = NewMount#item{id = EqmPos},
                                    storage_api:del_item_info(ConnPid, [{?storage_bag, Mount}]),
                                    storage_api:add_item_info(ConnPid, [{?storage_eqm, PutItem}, {?storage_mount, NewMount}]),
                                    Nm = add_skin(Mount#item.base_id, NewMounts),
                                    New = looks:calc(Role#role{bag = NewBag, eqm = [PutItem | Eqms], mounts = Nm}),
                                    Nr = role_api:push_attr(New),
                                    looks:refresh(Role, Nr),
                                    send_skinlist(ConnPid, Nm),
                                    rank:listener(mount, Nr, NewMount),
                                    {ok, [Grade]} = get_extra_data([19], Extra, []),
                                    rank_celebrity:listener(mount_step, Nr, Grade),
                                    {ok, Nr};
                                In ->
                                    case lists:keyfind(In#item.pos, #item.pos, Items) of    % 查找身上坐骑对应坐骑列表里的坐骑
                                        false -> {false, ?L(<<"坐骑数据错误">>)};
                                        #item{id = Id, extra = Extra} ->
                                            ChMounts = change_pos(Mounts, In#item{id = Id, extra = Extra}, 0),
                                            {NewMounts, NewMount = #item{extra = NewExtra}} = add(ChMounts, Mount, EqmPos),
                                            PutItem = NewMount#item{id = EqmPos},
                                            storage_api:del_item_info(ConnPid, [{?storage_bag, Mount}, {?storage_eqm, In}]),
                                            storage_api:add_item_info(ConnPid, [{?storage_eqm, PutItem}, {?storage_mount, NewMount}]),
                                            sys_conn:pack_send(ConnPid, 12505, {1, Id, <<>>}),
                                            Nm = add_skin(Mount#item.base_id, NewMounts),
                                            New = looks:calc(Role#role{bag = NewBag, eqm = [PutItem | (Eqms -- [In])], mounts = Nm}),
                                            Nr = role_api:push_attr(New),
                                            send_skinlist(ConnPid, Nm),
                                            looks:refresh(Role, Nr),
                                            rank:listener(mount, Nr, NewMount),
                                            {ok, [Grade]} = get_extra_data([19], NewExtra, []),
                                            rank_celebrity:listener(mount_step, Nr, Grade),
                                            {ok, Nr}
                                    end
                            end
                    end
            end;
        {false, Reason} ->
            {false, Reason}
    end;
put_mount(_Mount, _Role) -> {false, ?L(<<"坐骑数据错误">>)}.

%% @spec equip_mount(Mount, Role) -> {ok, Nr}.
%% Mount = #item{}
%% Role = Nr = #role{}
%% @doc 装备坐骑(从坐骑列表)
equip_mount(MountId, Role = #role{eqm = Eqms, link = #link{conn_pid = ConnPid}, mounts = Mounts = #mounts{items = Items}}) ->
    case storage:find(Items, #item.id, MountId) of
        {false, _Reason} -> {false, ?L(<<"坐骑不存在">>)};
        {ok, #item{pos = Pos}} when Pos > 0 -> {false, ?L(<<"坐骑已装备">>)};
        {ok, Mount} ->
            EqmPos = eqm:type_to_pos(?item_zuo_qi),
            PutItem = #item{extra = PutExtra} = Mount#item{id = EqmPos, pos = EqmPos},
            case lists:keyfind(EqmPos, #item.pos, Eqms) of    % 查找身上坐骑
                false ->
                    storage_api:add_item_info(ConnPid, [{?storage_eqm, PutItem}]),
                    Nm = add_skin(Mount#item.base_id, change_pos(Mounts, Mount, EqmPos)),
                    New = looks:calc(Role#role{eqm = [PutItem | Eqms], mounts = Nm}),
                    Nr = role_api:push_attr(New),
                    looks:refresh(Role, Nr),
                    send_skinlist(ConnPid, Nm),
                    rank:listener(mount, Nr, PutItem),
                    {ok, [Grade]} = get_extra_data([19], PutExtra, []),
                    rank_celebrity:listener(mount_step, Nr, Grade),
                    {ok, Nr};
                In ->
                    case lists:keyfind(EqmPos, #item.pos, Items) of    % 查找身上坐骑对应坐骑列表里的坐骑
                        false -> {false, ?L(<<"坐骑数据错误">>)};
                        #item{id = Id, extra = Extra} ->
                            storage_api:del_item_info(ConnPid, [{?storage_eqm, In}]),
                            storage_api:add_item_info(ConnPid, [{?storage_eqm, PutItem}]),
                            sys_conn:pack_send(ConnPid, 12505, {1, Id, <<>>}),
                            NewMounts = change_pos(Mounts, In#item{id = Id, extra = Extra}, 0),
                            Nm = add_skin(Mount#item.base_id, change_pos(NewMounts, Mount, EqmPos)),
                            New = looks:calc(Role#role{eqm = [PutItem | (Eqms -- [In])], mounts = Nm}),
                            Nr = role_api:push_attr(New),
                            looks:refresh(Role, Nr),
                            send_skinlist(ConnPid, Nm),
                            rank:listener(mount, Nr, PutItem),
                            {ok, [Grade]} = get_extra_data([19], PutExtra, []),
                            rank_celebrity:listener(mount_step, Nr, Grade),
                            {ok, Nr}
                    end
            end
    end.

%% @spec takeoff_mount(Role) -> {ok, MountId, Nr} | {false, <<>>}
%% Role = Nr = #role{}
%% MountId = integer()
%% @doc 卸下坐骑
takeoff_mount(Role = #role{link = #link{conn_pid = ConnPid}, eqm = Eqms, mounts = Mounts = #mounts{items = Items}}) ->
    EqmPos = eqm:type_to_pos(?item_zuo_qi),
    case lists:keyfind(EqmPos, #item.pos, Eqms) of
        false -> {false, ?L(<<"坐骑不存在">>)};
        In ->
            case lists:keyfind(EqmPos, #item.pos, Items) of
                false -> {false, ?L(<<"坐骑数据错误">>)};
                #item{id = Id, extra = Extra} ->
                    storage_api:del_item_info(ConnPid, [{?storage_eqm, In}]),
                    NewItems = clean_pos(Items, []),
                    NewMounts = change_pos(Mounts#mounts{items = NewItems}, In#item{id = Id, extra = Extra}, 0),
                    sys_conn:pack_send(ConnPid, 12503, {NewItems}),
                    Nm = takeoff_skin(NewMounts),
                    New = looks:calc(Role#role{eqm = Eqms -- [In], mounts = Nm}),
                    Nr = role_api:push_attr(New),
                    looks:refresh(Role, Nr),
                    send_skinlist(ConnPid, Nm),
                    rank:listener(mount, Nr, In),
                    {ok, 0, Nr}
            end
    end.

%% @spec add(Mounts, Item, Pos) -> NewMounts
%% Mounts = NewMounts = #mounts{}
%% Item = #item{}
%% Pos = integer()
%% @doc 往坐骑列表添加坐骑
%add(#mounts{num = 20}, _Item) -> {false, ?L(<<"坐骑数量超出上限">>)}; %% 坐骑数不能超过20 
add(Mounts = #mounts{next_id = Id, num = Num, items = Items}, Item, Pos) ->
    NewItem = Item#item{bind = 1, id = Id, pos = Pos},
    {Mounts#mounts{next_id = Id + 1, num = Num + 1, items = [NewItem | Items]}, NewItem}.

%% @spec make(Item) -> NewItems
%% Item = NewItem = #item{}
%% @doc 生成坐骑等级、经验、饱食度数据
make(Item = #item{base_id = Id, type = Type, attr = Attr, extra = []}) when Type =:= ?item_zuo_qi ->
    NewExtra = make_extra(Id, []),
    NewAttr = make_attr(Attr, NewExtra),
    Item#item{attr = NewAttr, extra = NewExtra};
make(Item = #item{base_id = Id, type = Type, attr = Attr, extra = Extra}) when Type =:= ?item_zuo_qi ->
    NewExtra = make_extra(Id, Extra),
    NewAttr = update_mount_attr(Attr, NewExtra),
    blacksmith:recalc_attr(calc_skin_attr(Item#item{attr = NewAttr, extra = NewExtra}));
make(Item) -> Item.

%% @spec get_skin(Mounts) -> [{?LOOKS_TYPE_RIDE, SkinId, Grade}].
%% Mounts = #mounts{}
%% @doc 获取当前坐骑外观
get_skin(#mounts{skin_id = 0}, _Eqms) -> [];
get_skin(#mounts{skin_id = SkinId, skin_grade = 1, buff_skin_id = BuffSkinId, is_buff_skin = IsBuffSkin}, Eqms) when is_integer(SkinId) ->
    case lists:keyfind(eqm:type_to_pos(?item_zuo_qi), #item.id, Eqms) of
        false ->
            [];
        #item{enchant = Enchant} ->
            calc_looks(SkinId, BuffSkinId, IsBuffSkin, Enchant);
        _ ->
            []
    end;
get_skin(#mounts{skin_id = SkinId, skin_grade = 0, buff_skin_id = BuffSkinId, is_buff_skin = IsBuffSkin}, Eqms) when is_integer(SkinId) ->
    case lists:keyfind(eqm:type_to_pos(?item_zuo_qi), #item.id, Eqms) of
        false ->
            [];
        _Mount ->
            calc_looks(SkinId, BuffSkinId, IsBuffSkin, 0)
    end;
get_skin(_, _) -> [].

%% @spec change_skin(SkinId, Grade, Role) -> {ok, OldSkinId, OldGrade, NewRole} | {false, Reason}
%% @doc 更换坐骑外观
change_skin(SkinId, Grade, Role = #role{eqm = Eqms, mounts = Mounts = #mounts{skins = Skins, skin_id = OldSkinId, skin_grade = OldGrade, buff_skin_id = BuffSkinId, is_buff_skin = IsBuffSkin}}) ->
    case lists:keyfind(eqm:type_to_pos(?item_zuo_qi), #item.pos, Eqms) of
        false -> {false, ?L(<<"你还没骑上坐骑">>)};
        #item{enchant = Enchant} when Enchant < 12 andalso Grade =:= 1 ->
            {false, ?L(<<"当前坐骑没有强化到+12，不能使用+12形象。">>)};
        _Item ->
            ReplaceSkinId = case IsBuffSkin of
                0 -> OldSkinId;
                1 -> BuffSkinId
            end,
            case lists:member(SkinId, Skins) of
                true ->
                    NewRole = looks:calc(Role#role{mounts = Mounts#mounts{skin_id = SkinId, skin_grade = Grade, is_buff_skin = 0}}),
                    looks:refresh(Role, NewRole),
                    {ok, ReplaceSkinId, OldGrade, NewRole};
                false when SkinId =:= BuffSkinId ->
                    NewRole = looks:calc(Role#role{mounts = Mounts#mounts{skin_id = SkinId, skin_grade = Grade, is_buff_skin = 1}}),
                    looks:refresh(Role, NewRole),
                    {ok, ReplaceSkinId, OldGrade, NewRole};
                false ->
                    {false, ?L(<<"你还没有这个坐骑外观">>)}
            end
    end.

%% @spec add_buff_skin(BuffLabel, Role) -> {ok, NewRole} | {false, Reason}.
%% @doc 增加buff外观
add_buff_skin(BuffLabel, Role = #role{eqm = Eqms, mounts = Mounts, link = #link{conn_pid = ConnPid}}) ->
    case lists:keyfind(eqm:type_to_pos(?item_zuo_qi), #item.pos, Eqms) of
        false -> {false, ?L(<<"你还没骑上坐骑">>)};
        _Item ->
            case buff_data:get_mount_look_id(BuffLabel) of
                null -> {false, ?L(<<"找不到相应的buff数据">>)};
                BuffSkinId -> 
                    NewMounts = Mounts#mounts{skin_grade = 1, buff_skin_id = BuffSkinId, is_buff_skin = 1},
                    NewRole = looks:calc(Role#role{mounts = NewMounts}),
                    looks:refresh(Role, NewRole),
                    send_skinlist(ConnPid, NewMounts),
                    {ok, NewRole}
            end            
    end.

del_buff_skin(BuffSkinId, Role = #role{mounts = Mounts = #mounts{buff_skin_id = BuffSkinId}, link = #link{conn_pid = ConnPid}}) ->
    NewMounts = Mounts#mounts{buff_skin_id = 0, is_buff_skin = 0},
    send_skinlist(ConnPid, NewMounts),
    Role#role{mounts = NewMounts};
del_buff_skin(_, Role) -> Role.

%% @spec put_skin(Item, Role) -> {ok, NewRole} | {false, Reason}
%% @doc 使用坐骑外观道具
put_skin(Item = #item{base_id = BaseId}, Role = #role{eqm = EqmList, bag = Bag, mounts = Mounts, link = #link{conn_pid = ConnPid}}) ->
    case item_data:get(Item#item.base_id) of
        {ok, #item_base{condition = Cond, effect = Effect}} ->
            case role_cond:check(Cond, Role) of
                {false, RCond} -> {false, RCond#condition.msg};
                true -> 
                    case lists:keyfind(eqm:type_to_pos(?item_zuo_qi), #item.pos, EqmList) of
                        false -> {false, ?L(<<"你还没骑上坐骑">>)};
                        EqmMount = #item{special = Special} ->
                            ThisSkinList = case lists:keyfind(mount_skin, 1, Special) of
                                {_, L} -> L;
                                _ -> []
                            end,
                            UseNum = case lists:keyfind(BaseId, 1, ThisSkinList) of 
                                {_, Num} -> Num;
                                _ -> 0
                            end,
                            case UseNum < 1 of 
                                false -> %% 之前使用过 不给再使用
                                    {false, ?L(<<"此坐骑已使用过该变身卡">>)};
                                _ ->
                                    case storage:del_item_by_id(Bag, [{Item#item.id, 1}], true) of  % 删除背包坐骑时装
                                        {false, R} -> {false, R};
                                        {ok, NewBag, _, _} ->
                                            storage_api:del_item_info(ConnPid, [{?storage_bag, Item}]),
                                            case Effect of
                                                [Msg | _] when is_binary(Msg) ->
                                                    role:pack_send(Role#role.pid, 10931, {57, Msg, []});
                                                _ ->
                                                    skip
                                            end,
                                            NewThisSkinList = case [true || {_, _} <- Effect] of
                                                [] -> ThisSkinList;
                                                _ -> [{BaseId, UseNum + 1} | lists:keydelete(BaseId, 1, ThisSkinList)]
                                            end,
                                            NewSpecial = [{mount_skin, NewThisSkinList} | lists:keydelete(mount_skin, 1, Special)],
                                            NewEqmMount = calc_mount_attr(EqmMount#item{special = NewSpecial}),
                                            NewMount = NewEqmMount,
                                            {ok, NewEqmList, _} = storage_api:fresh_item(EqmMount, NewEqmMount, EqmList, ConnPid),
                                            NewMounts = storage_api:fresh_mounts(EqmMount, NewMount, Mounts, ConnPid),
                                            Nm = add_skin(Item#item.base_id, NewMounts),
                                            NewRole0 = looks:calc(Role#role{bag = NewBag, eqm = NewEqmList, mounts = Nm}),
                                            NewRole = role_api:push_attr(NewRole0),
                                            looks:refresh(Role, NewRole),
                                            send_skinlist(ConnPid, Nm),
                                            {ok, NewRole}
                                    end
                            end
                    end
            end;
        _ ->
            {false, ?L(<<"坐骑数据错误">>)}
    end.    

%% @spec add_skins(SkinList, Skins) -> Skins.
%% @doc 生成玩家坐骑外观列表
add_skins([], Skins) -> Skins;
add_skins([H | T], Skins)->
    case lists:member(H, Skins) of
        true ->
            add_skins(T, Skins);
        false ->
            add_skins(T, [H | Skins])
    end.

%% @spec make_skinlist(Mounts) -> SkinList.
%% Mounts = #mounts{}
%% @doc 生成客户端需要的坐骑外观列表
make_skinlist(#mounts{skins = Skins, skin_id = SkinId, buff_skin_id = 0}) ->
    make_skinlist(Skins, SkinId, []);
make_skinlist(#mounts{skins = Skins, skin_id = SkinId, buff_skin_id = BuffSkinId, is_buff_skin = 0}) ->
    case lists:member(BuffSkinId, Skins) of
        true ->
            make_skinlist(Skins, SkinId, []);
        false ->
            make_skinlist([BuffSkinId | Skins], SkinId, [])
    end;
make_skinlist(#mounts{skins = Skins, buff_skin_id = BuffSkinId, is_buff_skin = 1}) ->
    case lists:member(BuffSkinId, Skins) of
        true ->
            make_skinlist(Skins, BuffSkinId, []);
        false ->
            make_skinlist([BuffSkinId | Skins], BuffSkinId, [])
    end.

make_skinlist([], _SkinId, SkinList) -> SkinList;
make_skinlist([H | T], SkinId, SkinList) when H =:= SkinId ->
    make_skinlist(T, SkinId, [{H, 1} | SkinList]);
make_skinlist([H | T], SkinId, SkinList) ->
    make_skinlist(T, SkinId, [{H, 0} | SkinList]).

%% @spec upgrade(Mount, Role) -> {ok, NewMount, NewRole} | {false, Reason}
%% Mount = NewMount = #item{}
%% Role = NewRole = #role{}
%% @doc 坐骑进阶
upgrade(Mount = #item{extra = Extra}, Role) ->
    case get_extra_data([19,22], Extra, []) of
        {ok, [Grade, _CanUp]} when Grade >= 8 ->
            {false, ?L(<<"坐骑阶数已满，不能再进阶">>)};
        {ok, [_Grade, CanUp]} when CanUp =:= 1 ->
            upgrade_mount(Mount, Role, normal);
        {ok, [Grade, _CanUp]} ->
            {ItemId, Num, NeedCoin} = mount_upgrade_data:get_cost(Grade),
            {ok, #item_base{name = Name}} = item_data:get(ItemId),
            case role_gain:do([#loss{label = item, val = [ItemId, 1, Num], msg = util:fbin(?L(<<"提升失败，~s不足~w">>), [Name, Num])}, #loss{label = coin_all, val = NeedCoin, msg = ?L(<<"金币不足， 无法进阶">>)}], Role) of
                {false, L = #loss{label = coin_all}} ->
                    {?coin_less, L#loss.msg};
                {false, L} ->
                    {false, L#loss.msg};
                {ok, NewRole} ->
                    upgrade_mount(Mount, NewRole, normal)
            end;
        {false, Reason} ->
            {false, Reason}
    end.

%% @spec del(MountId, Role) -> {ok, NewRole} | {false, Reason}
%% @doc 坐骑放生
del(MountId, Role = #role{mounts = Mounts = #mounts{num = Num, items = Items}, link = #link{conn_pid = ConnPid}}) ->
    case lists:keyfind(MountId, #item.id, Items) of
        false ->
            {false, ?L(<<"坐骑不存在">>)};
        #item{pos = Pos} when Pos > 0 ->
            {false, ?L(<<"装备中的坐骑不能放生">>)};
        Mount ->
            storage_api:del_item_info(ConnPid, [{?storage_mount, Mount}]),
            {ok, Role#role{mounts = Mounts#mounts{num = Num - 1, items = Items -- [Mount]}}}
    end.

%% @spec refresh_growth(Mount, Role) -> {ok, NewRole} | {false, Reason}
%% @doc 坐骑洗髓
refresh_growth(Mount = #item{extra = Extra}, Role) ->
    {ok, [Grade]} = get_extra_data([19], Extra, []),
    {ItemId, Num, NeedCoin} = mount_upgrade_data:get_refresh_cost(Grade),
    {ok, #item_base{name = Name}} = item_data:get(ItemId),
    case role_gain:do([#loss{label = item, val = [ItemId, 1, Num], msg = util:fbin(?L(<<"你的背包里没有~s">>), [Name])}, #loss{label = coin_all, val = NeedCoin, msg = ?L(<<"金币不足">>)}], Role) of
        {false, L = #loss{label = coin_all}} ->
            {?coin_less, L#loss.msg};
        {false, L} ->
            {false, L#loss.msg};
        {ok, NewRole} ->
            do_refresh_growth(Mount, NewRole)
    end.

%% @spec get_rank_power(Role) -> {Name, Grade, Lev, Quantity, Power, Mount}.
%% @doc 获取坐骑战斗力等数值
get_rank_power(#role{eqm = Eqms}) ->
    case lists:keyfind(eqm:type_to_pos(?item_zuo_qi), #item.pos, Eqms) of
        false -> false;
        Mount = #item{base_id = BaseId, attr = Attr, extra = Extra} ->
            {ok, #item_base{name = Name}} = item_data:get(BaseId),
            {ok, [Grade, Lev, Quantity]} = get_extra_data([19, 3, 20], Extra, []),
            Power = calc_power(Attr),
            {Name, Grade, Lev, Quantity, Power, Mount}
    end.

%% @spec batch_refresh_growth(Mount, Role) -> {false, Reason} | {ok, NewRole}
%% @doc 批量洗髓
batch_refresh_growth(Mount = #item{extra = Extra}, UnBind, Role) ->
    {ok, [Grade]} = get_extra_data([19], Extra, []),
    {ItemId, Num, NeedCoin} = mount_upgrade_data:get_refresh_cost(Grade),
    {ok, #item_base{name = Name}} = item_data:get(ItemId),
    Label = case UnBind =:= 0 of
        true ->
            items_bind_fst;
        false ->
            items_ubind_fst
    end,
    case role_gain:do([#loss{label = Label, val = [{ItemId, Num * 6}], msg = util:fbin(?L(<<"你的背包里没有~s">>), [Name])}, #loss{label = coin_all, val = NeedCoin * 6, msg = ?L(<<"金币不足">>)}], Role) of
        {false, L = #loss{label = coin_all}} ->
            {?coin_less, L#loss.msg};
        {false, L} ->
            {false, L#loss.msg};
        {ok, NewRole} ->
            do_batch_refresh_growth(Mount, NewRole)
    end.

%% @spec choose_growth_per(Mount, Index, Role) -> {false, Reason} | {ok, NewRole}
%% @doc 选择洗髓属性
choose_growth_per(Mount = #item{extra = Extra, attr = Attr, xisui_list = List}, Index, Role) ->
    case lists:keyfind(Index, 1, List) of
        false ->
            {false, ?L(<<"坐骑数据错误">>)};
        {_, Quality, GrowList, PerList} ->
            {ok, [Grade]} = get_extra_data([19], Extra, []),
            Addition = calc_addition(Grade, Quality),
            NewExtra = update_extra([{20, Quality}, {21, Addition}] ++ GrowList ++ PerList, Extra),
            NewAttr = update_mount_attr(Attr, NewExtra),
            NewMount = calc_skin_attr(Mount#item{attr = NewAttr, extra = NewExtra, xisui_list = []}),
            do_choose_growth_per(Mount, NewMount, Quality, role_listener:special_event(Role, {20024, calc_power(NewMount)}))
    end.

%%----------------------------------------------------
%% 私有函数
%%----------------------------------------------------
%% @spec check_items_in_bag(ItemList, Items, BaseIdQList, IdQList) -> IdQList
%% ItemList = Items = BaseIdQList = IdQList = list()
%% @doc 检查喂养物品
check_items_in_bag([], _Items, BaseIdQList, IdQList) -> {BaseIdQList, IdQList};
check_items_in_bag([[Id, Num] | T], Items, BaseIdQList, IdQList) ->
    case storage:find(Items, #item.id, Id) of
        {ok, Item = #item{id = Id, base_id = BaseId, quantity = Q}} when Q > Num ->
            NewItems = lists:keyreplace(Item#item.id, #item.id, Items, Item#item{quantity = Q - Num}),
            check_items_in_bag(T, NewItems, [{BaseId, Num} | BaseIdQList], [{Id, Num} | IdQList]);
        {ok, Item = #item{id = Id, base_id = BaseId, quantity = Q}} when Q =:= Num ->
            NewItems = Items -- [Item],
            check_items_in_bag(T, NewItems, [{BaseId, Q} | BaseIdQList], [{Id, Q} | IdQList]);
        _ ->
            check_items_in_bag(T, Items, BaseIdQList, IdQList)
    end.

%% @spec do_feed_mount(Mount, Role, BaseIdQList) -> NewRole
%% Mount = #item{}
%% Role = NewRole = #role{}
%% BaseIdQList = list()
%% @doc 喂养坐骑，改变坐骑数值和人物数值(坐骑在身上)
do_feed_mount(Mount = #item{id = Id, extra = Extra, pos = Pos}, Role = #role{id = {Rid, Rsrvid}, name = Rname, mounts = Mounts, eqm = EqmList, lev = RoleLev, link = #link{conn_pid = ConnPid}}, BaseIdQList) when Pos > 0 ->
    case storage:find(EqmList, #item.pos, Pos) of
        {ok, EqmMount = #item{attr = Attr}} ->
            case {lists:keyfind(?extra_mount_lev, 1, Extra), lists:keyfind(?extra_mount_exp, 1, Extra)} of
                {{_, Lev, _}, {_, Exp, _}} ->
                    Times = 1,
                    case handle_feed_mount(BaseIdQList, Lev, Exp, 0, RoleLev, Times) of
                        {false, Reason} ->
                            {false, Reason};
                        {ok, NewLev, NewExp, AddExp} when NewLev > Lev ->
                            NewExtra = update_extra([{3, NewLev}, {4, NewExp}], Extra),
                            NewAttr = update_mount_attr(Attr, NewExtra),
                            NewEqmMount = calc_skin_attr(EqmMount#item{attr = NewAttr, extra = NewExtra}),
                            NewMount = NewEqmMount#item{id = Id},
                            {ok, NewEqmList, _} = storage_api:fresh_item(EqmMount, NewEqmMount, EqmList, ConnPid),
                            NewMounts = storage_api:fresh_mounts(Mount, NewMount, Mounts, ConnPid),
                            Nr = role_api:push_attr(Role#role{mounts = NewMounts, eqm = NewEqmList}),
                            map:role_update(Nr),
                            log:log(log_mount_feed, {Rid, Rsrvid, Rname, item_to_desc(BaseIdQList, <<>>), AddExp, mount_to_desc(Mount), Lev, NewLev, Exp, NewExp, 0, 0}),
                            rank:listener(mount, Nr, NewMount),
                            campaign_listener:handle(mount_lev, Role, Lev, NewLev),
                            NewRole = role_listener:acc_event(Nr, {127, calc_power(NewMount) - calc_power(Mount)}), %%坐骑战力提升, N当次提升数值
                            NewRole1 = role_listener:special_event(NewRole, {20024, calc_power(NewEqmMount)}),
                            {ok, AddExp, true, NewRole1};
                        {ok, NewLev, NewExp, AddExp} ->
                            NewEqmMount = EqmMount#item{extra = update_extra([{4, NewExp}], Extra)},
                            NewMount = NewEqmMount#item{id = Id},
                            {ok, NewEqmList, _} = storage_api:fresh_item(EqmMount, NewEqmMount, EqmList, ConnPid),
                            NewMounts = storage_api:fresh_mounts(Mount, NewMount, Mounts, ConnPid),
                            log:log(log_mount_feed, {Rid, Rsrvid, Rname, item_to_desc(BaseIdQList, <<>>), AddExp, mount_to_desc(Mount), Lev, NewLev, Exp, NewExp, 0, 0}),
                            {ok, AddExp, false, Role#role{mounts = NewMounts, eqm = NewEqmList}}
                    end;
                _ ->
                    {false, ?L(<<"坐骑数据错误">>)}
            end;
        _ ->
            {false, ?L(<<"坐骑数据错误">>)}
    end;

%% @doc 喂养坐骑，改变坐骑数值和人物数值(坐骑不在身上)
do_feed_mount(Mount = #item{attr = Attr, extra = Extra}, Role = #role{id = {Rid, Rsrvid}, name = Rname, mounts = Mounts, lev = RoleLev, link = #link{conn_pid = ConnPid}}, BaseIdQList) -> % 坐骑不在身上
    case {lists:keyfind(?extra_mount_lev, 1, Extra), lists:keyfind(?extra_mount_exp, 1, Extra)} of
        {{_, Lev, _}, {_, Exp, _}} ->
            Times = 1,
            case handle_feed_mount(BaseIdQList, Lev, Exp, 0, RoleLev, Times) of
                {false, Reason} ->
                    {false, Reason};
                {ok, NewLev, NewExp, AddExp} when NewLev > Lev ->
                    NewExtra = update_extra([{3, NewLev}, {4, NewExp}], Extra),
                    NewAttr = update_mount_attr(Attr, NewExtra),
                    NewMount = calc_skin_attr(Mount#item{attr = NewAttr, extra = NewExtra}),
                    NewMounts = storage_api:fresh_mounts(Mount, NewMount, Mounts, ConnPid),
                    log:log(log_mount_feed, {Rid, Rsrvid, Rname, item_to_desc(BaseIdQList, <<>>), AddExp, mount_to_desc(Mount), Lev, NewLev, Exp, NewExp, 0, 0}),
                    Nr = Role#role{mounts = NewMounts},
                    campaign_listener:handle(mount_lev, Role, Lev, NewLev),
                    NewRole = role_listener:acc_event(Nr, {127, calc_power(NewMount) - calc_power(Mount)}), %%坐骑战力提升, N当次提升数值
                    NewRole1 = role_listener:special_event(NewRole, {20024, calc_power(NewAttr)}),
                    {ok, AddExp, true, NewRole1};
                {ok, NewLev, NewExp, AddExp} ->
                    NewMount = Mount#item{extra = update_extra([{4, NewExp}], Extra)},
                    NewMounts = storage_api:fresh_mounts(Mount, NewMount, Mounts, ConnPid),
                    log:log(log_mount_feed, {Rid, Rsrvid, Rname, item_to_desc(BaseIdQList, <<>>), AddExp, mount_to_desc(Mount), Lev, NewLev, Exp, NewExp, 0, 0}),
                    Nr = Role#role{mounts = NewMounts},
                    {ok, AddExp, false, Nr}
            end;
        _ ->
            {false, ?L(<<"坐骑数据错误">>)}
    end.

%% @spec handle_feed_mount(IdQList, Lev, Exp, Feed, AddExp) -> {Lev, Exp, Feed, AddExp}
%% IdQList = list()
%% Lev = Exp = Feed = AddExp = integer()
%% @doc 喂养骑宠计算逻辑
handle_feed_mount(_BL, Lev, _Exp, _AddExp, RoleLev, _Times) when Lev > RoleLev -> {false, ?L(<<"喂养失败，坐骑等级不能超过人物等级!">>)};
handle_feed_mount([], Lev, Exp, AddExp, RoleLev, _Times) ->
    handle_feed_mount(Lev, Exp, AddExp, RoleLev);
handle_feed_mount([{BaseId, Q} | T], Lev, Exp, AddExp, RoleLev, Times) when Q > 0 ->
    case item_data:get(BaseId) of
        {ok, #item_base{feed_exp = FeedExp0}} when is_integer(FeedExp0) andalso FeedExp0 > 0 ->
            FeedExp = FeedExp0 * Times,
            SumExp = Exp + FeedExp,
            UpgradeExp = mount_feed_data:get_upgrade_exp(Lev),
            case SumExp < UpgradeExp of
                true ->
                    handle_feed_mount([{BaseId, Q - 1} | T], Lev, SumExp, AddExp + FeedExp, RoleLev, Times);
                false ->
                    handle_feed_mount([{BaseId, Q - 1} | T], Lev + 1, SumExp - UpgradeExp, AddExp + FeedExp, RoleLev, Times)
            end;
        _ ->
            ?ERR("未知物品BaseId:~w,无法计算喂养经验",[BaseId]),
            handle_feed_mount(T, Lev, Exp, AddExp, RoleLev, Times)
    end;
handle_feed_mount([_H | T], Lev, Exp, AddExp, RoleLev, Times) ->
    handle_feed_mount(T, Lev, Exp, AddExp, RoleLev, Times).

handle_feed_mount(Lev, _Exp, _AddExp, RoleLev) when Lev > RoleLev -> {false, ?L(<<"喂养失败，坐骑等级不能超过人物等级!">>)};
handle_feed_mount(Lev, Exp, AddExp, RoleLev) ->
    UpgradeExp = mount_feed_data:get_upgrade_exp(Lev),
    case Exp < UpgradeExp of
        true ->
            {ok, Lev, erlang:trunc(Exp), erlang:trunc(AddExp)};
        false ->
            handle_feed_mount(Lev + 1, Exp - UpgradeExp, AddExp, RoleLev)
    end.

%% @spec update_mount_attr(NewLev, OldLev, Attr) -> NewAttr
%% NewLev = OldLev = integer()
%% Attr = NewAttr = list()
%% @doc 坐骑属性更新
update_mount_attr(Attr, Extra) ->
    {_, Lev, _} = lists:keyfind(3, 1, Extra),
    Speed = case lists:keyfind(?attr_speed, 1, Attr) of
        false -> {?attr_speed, 100, 0};
        S -> S
    end,
    {ok, GrowthList} = get_extra_data([6,7,8,9,10,11], Extra, []),
    NewAttr = calc_grow_attr(mount_feed_data:get_attr(Lev), GrowthList, []),
    {ok, [Quantity, Addition]} = get_extra_data([20,21], Extra, []),
    NewAttr2 = calc_qa_attr(NewAttr, Quantity, Addition, []),
    HoleAttr = [{AttrName, Flag, Val} || {AttrName, Flag, Val} <- Attr, lists:member(AttrName, [?attr_hole1, ?attr_hole2, ?attr_hole3, ?attr_hole4, ?attr_hole5]) =:= true],
    [Speed | NewAttr2] ++ HoleAttr.

%% 计算坐骑属性数据
calc_mount_attr(Mount = #item{attr = Attr, extra = Extra}) ->
    NewAttr = update_mount_attr(Attr, Extra),
    calc_skin_attr(Mount#item{attr = NewAttr}).

%% 计算坐骑外观属性
calc_skin_attr(Mount = #item{special = Special, attr = Attr}) ->
    case lists:keyfind(mount_skin, 1, Special) of
        {_, L} -> %% 存在外观使用
            NewAttr = calc_skin_attr(L, Attr),
            Mount#item{attr = NewAttr};
        _ -> 
            Mount 
    end.
calc_skin_attr([], Attr) ->
    Attr;
calc_skin_attr([{BaseId, Num} | T], Attr) ->
    case item_data:get(BaseId) of
        {ok, #item_base{effect = Effect}} ->
            NewAttr = do_calc_skin_attr(Effect, Num, Attr),
            calc_skin_attr(T, NewAttr);
        _ ->
            calc_skin_attr(T, Attr)
    end.
do_calc_skin_attr([], _Num, Attr) ->
    Attr;
do_calc_skin_attr([{AttrName, Val} | T], Num, Attr) when is_integer(Val) ->
    AttrCode = attr_name_to_code(AttrName),
    case lists:keyfind(AttrCode, 1, Attr) of
        {_, Flag = 100, OldVal} -> %% Flag 为100 确保是基础属性 
            NewAttr = lists:keyreplace(AttrCode, 1, Attr, {AttrCode, Flag, round(OldVal + Val * Num)}),
            do_calc_skin_attr(T, Num, NewAttr);
        _ ->
            do_calc_skin_attr(T, Num, Attr)
    end;
do_calc_skin_attr([_ | T], Num, Attr) ->
    do_calc_skin_attr(T, Num, Attr).
attr_name_to_code(attr_dmg) -> ?attr_dmg;
attr_name_to_code(attr_defence) -> ?attr_defence;
attr_name_to_code(attr_critrate) -> ?attr_critrate;
attr_name_to_code(attr_tenacity) -> ?attr_tenacity;
attr_name_to_code(attr_hp_max) -> ?attr_hp_max;
attr_name_to_code(attr_js) -> ?attr_js;
attr_name_to_code(_Label) -> false.

%% @doc 计算成长属性
calc_grow_attr([], _, AttrList) -> AttrList;
calc_grow_attr([{Name, Flag, Attr} | T1], [Growth | T2], AttrList) ->
    calc_grow_attr(T1, T2, [{Name, Flag, erlang:round(Attr * Growth/50)} | AttrList]).

%% @doc 计算品质、灵犀值额外属性
calc_qa_attr([], _Quantity, _Addition, AttrList) -> AttrList;
calc_qa_attr([{Name, Flag, Attr} | T], Quantity, Addition, AttrList) ->
    NewAttr = erlang:round(Attr * (100 + mount_upgrade_data:get_refresh_addition(Quantity) + Addition * 0.5) / 100),
    calc_qa_attr(T, Quantity, Addition, [{Name, Flag, NewAttr} | AttrList]).

%% @spec change_pos(Mounts, Item, Pos) -> NewMounts
%% Mounts = NewMounts = #mounts{}
%% Item = #item{}
%% Pos = integer()
%% @doc 变更坐骑列表中坐骑的pos值
change_pos(Mounts = #mounts{items = Items}, Item, Pos) ->
    Mounts#mounts{items = lists:keyreplace(Item#item.id, #item.id, Items, Item#item{pos = Pos})}.

%% @spec item_to_desc(ItemList, Str) -> Str.
%% @doc 生成物品列表描述
item_to_desc([], Str) -> Str;
item_to_desc([{BaseId, Num} | T], Str) ->
    {ok, #item_base{name = Name}} = item_data:get(BaseId),
    NewS = util:fbin("[~sx~w]", [Name, Num]),
    item_to_desc(T, <<Str/binary, NewS/binary>>).

%% @spec mount_to_desc(Item) -> Str.
%% @doc 生成坐骑描述
mount_to_desc(#item{base_id = BaseId}) ->
    {ok, #item_base{name = Name}} = item_data:get(BaseId),
    Name.

%% @spec add_skin(BaseId, Mounts) -> NewMounts
%% @doc 添加坐骑外观
add_skin(BaseId, Mounts = #mounts{skins = Skins}) ->
    case lists:member(BaseId, Skins) of
        true ->
            Mounts#mounts{skin_id = BaseId, skin_grade = 1};
        false ->
            Mounts#mounts{skin_id = BaseId, skin_grade = 1, skins = [BaseId | Skins]}
    end.

add_skin_only(BaseId, Mounts = #mounts{skins = Skins}) ->
    case lists:member(BaseId, Skins) of
        true ->
            Mounts;
        false ->
            Mounts#mounts{skins = [BaseId | Skins]}
    end.

%% @spec takeoff_skin(Mounts) -> NewMounts.
%% @doc 卸下坐骑外观
takeoff_skin(Mounts) -> Mounts#mounts{skin_id = 0, skin_grade = 0}.

%% @doc 向客户端发送坐骑外观列表
send_skinlist(ConnPid, Mounts) ->
    sys_conn:pack_send(ConnPid, 12507, {make_skinlist(Mounts)}).

%% @doc 进阶公告
broad_upgrade_msg(Role, Mount, Grade) ->
    RoleMsg = notice:role_to_msg(Role),
    MountMsg = notice:item_to_msg(Mount),
    Msg = util:fbin(?L(<<"高阶神兽降临！经过~s的精心培养，成功将自己的坐骑进阶成为~s（~w阶）！">>), [RoleMsg, MountMsg, Grade]),
    notice:send(53, Msg).
 
%% @doc 坐骑进阶(坐骑在身上)
upgrade_mount(Mount = #item{id = Id, pos = Pos}, Role0 = #role{eqm = EqmList, mounts = Mounts, link = #link{conn_pid = ConnPid}}, Flag) when Pos > 0 ->
    case storage:find(EqmList, #item.pos, Pos) of
        {ok, EqmMount} ->
            case handle_upgrade_mount(EqmMount, Flag, Role0) of
                {false, Reason} ->
                    {false, Reason};
                {ok, suc, NewEqmMount, Grade, Role} ->
                    {NewEqmList, NewMounts, NewEqmMount2} = refresh_mount(Grade, EqmMount, NewEqmMount, Id, Mounts, EqmList, ConnPid),
                    Nr = role_api:push_attr(Role#role{mounts = NewMounts, eqm = NewEqmList}),
                    NewRole = looks:calc(Nr),
                    looks:refresh(Role, NewRole),
                    send_skinlist(ConnPid, NewMounts),
                    map:role_update(NewRole),
                    broad_upgrade_msg(NewRole, NewEqmMount2, Grade),
                    log:log(log_mount_handle, {<<"进阶[装备栏]">>, [], EqmMount, NewEqmMount2, Role}),
                    mount_reward:listener(upgrade, Role, {Grade - 1, Grade}), 
                    campaign_listener:handle(mount_step, Role, Grade),
                    rank:listener(mount, NewRole, NewEqmMount2),
                    NewRole1 = role_listener:special_event(NewRole, {20003, Grade}),
                    rank_celebrity:listener(mount_step, NewRole1, Grade),
                    NewRole2 = role_listener:acc_event(NewRole1, {127, calc_power(NewEqmMount) - calc_power(EqmMount)}), %%坐骑战力提升, N当次提升数值
                    {ok, suc, NewRole2};
                {ok, ready, NewEqmMount} ->
                    {ok, NewEqmList, _} = storage_api:fresh_item(EqmMount, NewEqmMount, EqmList, ConnPid),
                    NewMount = NewEqmMount#item{id = Id},
                    NewMounts = storage_api:fresh_mounts(Mount, NewMount, Mounts, ConnPid),
                    log:log(log_mount_handle, {<<"进阶[装备栏]">>, [], EqmMount, NewMount, Role0}),
                    {ok, ready, Role0#role{mounts = NewMounts, eqm = NewEqmList}};
                {ok, fal, AddLuck, NewEqmMount} ->
                    {ok, NewEqmList, _} = storage_api:fresh_item(EqmMount, NewEqmMount, EqmList, ConnPid),
                    NewMount = NewEqmMount#item{id = Id},
                    NewMounts = storage_api:fresh_mounts(Mount, NewMount, Mounts, ConnPid),
                    log:log(log_mount_handle, {<<"进阶[装备栏]">>, [], EqmMount, NewMount, Role0}),
                    {ok, fal, AddLuck, Role0#role{mounts = NewMounts, eqm = NewEqmList}}
            end;
        _ ->
            {false, ?L(<<"坐骑数据错误">>)}
    end;

%% @doc 坐骑进阶(坐骑不在身上)
upgrade_mount(Mount, Role0 = #role{mounts = Mounts, link = #link{conn_pid = ConnPid}}, Flag) ->
    case handle_upgrade_mount(Mount, Flag, Role0) of
        {false, Reason} ->
            {false, Reason};
        {ok, suc, NewMount, Grade, Role} ->
            {NewMounts, NewMount2} = refresh_mount(Grade, Mount, NewMount, Mounts, ConnPid),
            send_skinlist(ConnPid, NewMounts),
            broad_upgrade_msg(Role, NewMount2, Grade),
            log:log(log_mount_handle, {<<"进阶[坐骑栏]">>, [], Mount, NewMount2, Role}),
            mount_reward:listener(upgrade, Role, {Grade - 1, Grade}), 
            campaign_listener:handle(mount_step, Role, Grade),
            rank_celebrity:listener(mount_step, Role, Grade),
            NewRole = role_listener:acc_event(Role, {127, calc_power(NewMount) - calc_power(Mount)}), %%坐骑战力提升, N当次提升数值
            {ok, suc, NewRole#role{mounts = NewMounts}};
        {ok, ready, NewMount} ->
            NewMounts = storage_api:fresh_mounts(Mount, NewMount, Mounts, ConnPid),
            log:log(log_mount_handle, {<<"进阶[坐骑栏]">>, [], Mount, NewMount, Role0}),
            {ok, ready, Role0#role{mounts = NewMounts}};
        {ok, fal, AddLuck, NewMount} ->
            NewMounts = storage_api:fresh_mounts(Mount, NewMount, Mounts, ConnPid),
            log:log(log_mount_handle, {<<"进阶[坐骑栏]">>, [], Mount, NewMount, Role0}),
            {ok, fal, AddLuck, Role0#role{mounts = NewMounts}}
    end.

%% @doc 进阶成功刷新坐骑(坐骑在身上)
refresh_mount(Grade, OldEqmMount, EqmMount = #item{id = EqmId, attr = Attr}, MountId, Mounts = #mounts{items = Items}, Eqms, ConnPid) ->
    OldMount = OldEqmMount#item{id = MountId},
    Mount = EqmMount#item{id = MountId},
    case mount_upgrade_data:get_new_mount(Grade) of
        none ->
            {ok, NewEqmList, _} = storage_api:fresh_item(OldEqmMount, EqmMount, Eqms, ConnPid),
            NewMounts = storage_api:fresh_mounts(OldMount, Mount, Mounts, ConnPid),
            {NewEqmList, NewMounts, Mount};
        NewBaseId ->
            NewAttr = case item_data:get(NewBaseId) of
                {ok, #item_base{attr = BaseAttr}} ->
                    case lists:keyfind(?attr_speed, 1, BaseAttr) of
                        false -> Attr;
                        Speed ->
                            lists:keyreplace(?attr_speed, 1, Attr, Speed)
                    end;
                _ ->
                    Attr
            end,
            NewEqmMount = blacksmith:recalc_attr(EqmMount#item{base_id = NewBaseId, attr = NewAttr}),
            NewMount = NewEqmMount#item{id = MountId},
            storage_api:del_item_info(ConnPid, [{?storage_mount, OldMount}, {?storage_eqm, OldEqmMount}]),
            storage_api:add_item_info(ConnPid, [{?storage_mount, NewMount}, {?storage_eqm, NewEqmMount}]),
            NewItems = lists:keyreplace(MountId, #item.id, Items, NewMount),
            NewEqms = lists:keyreplace(EqmId, #item.id, Eqms, NewEqmMount),
            {NewEqms, add_skin(NewBaseId, Mounts#mounts{items = NewItems}), NewMount}
    end.

%% @doc 进阶成功刷新坐骑(坐骑不在身上)
refresh_mount(Grade, OldMount, Mount = #item{id = Id, attr = Attr}, Mounts = #mounts{items = Items}, ConnPid) ->
    case mount_upgrade_data:get_new_mount(Grade) of
        none ->
            {storage_api:fresh_mounts(OldMount, Mount, Mounts, ConnPid), Mount};
        NewBaseId ->
            NewAttr = case item_data:get(NewBaseId) of
                {ok, #item_base{attr = BaseAttr}} ->
                    case lists:keyfind(?attr_speed, 1, BaseAttr) of
                        false -> Attr;
                        Speed ->
                            lists:keyreplace(?attr_speed, 1, Attr, Speed)
                    end;
                _ ->
                    Attr
            end,
            NewMount = blacksmith:recalc_attr(Mount#item{base_id = NewBaseId, attr = NewAttr}),
            storage_api:del_item_info(ConnPid, [{?storage_mount, OldMount}]),
            storage_api:add_item_info(ConnPid, [{?storage_mount, NewMount}]),
            NewItems = lists:keyreplace(Id, #item.id, Items, NewMount),
            {add_skin_only(NewBaseId, Mounts#mounts{items = NewItems}), NewMount}
    end.

%% @doc 处理坐骑进阶
handle_upgrade_mount(Mount = #item{attr = Attr, extra = Extra, xisui_list = List}, normal, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case get_extra_data([22], Extra, []) of
        {ok, [CanUp]} when CanUp =:= 1 ->
            {ok, [Lev, Grade]} = get_extra_data([3, 19], Extra, []),
            GrowKeys = [6,7,8,9,10,11],
            {ok, OldGrows} = get_extra_data(GrowKeys, Extra, []),
            NextGrade = Grade + 1,
            AddGrow = (mount_upgrade_data:get_growth(NextGrade) - mount_upgrade_data:get_growth(Grade)) / 6,
            NewGrows = [erlang:round(Grow + AddGrow) || Grow <- OldGrows],
            ExtraGrows = pair_extra(GrowKeys, NewGrows, []),
            NewExtra = update_extra([{18, 0}, {19, NextGrade}, {22, 0}] ++ ExtraGrows, Extra),
            HoleAttr = [{AttrName, Flag, Val} || {AttrName, Flag, Val} <- Attr, lists:member(AttrName, [?attr_hole1, ?attr_hole2, ?attr_hole3, ?attr_hole4, ?attr_hole5]) =:= true],
            NewAttr = update_mount_attr(mount_feed_data:get_attr(Lev) ++ HoleAttr, NewExtra),
            NewList = case List of
                [] ->
                    [];
                List ->
                    List2 = update_xisui(List, AddGrow, []),
                    DataList = [{Id, Quality, Grows} || {Id, Quality, Grows, _} <- List2],
                    sys_conn:pack_send(ConnPid, 12512, {NextGrade, DataList}),
                    List2
            end,
            NewMount = calc_skin_attr(Mount#item{attr = NewAttr, extra = NewExtra, xisui_list = NewList}),
            {ok, suc, NewMount, NextGrade, role_listener:special_event(Role, {20024, calc_power(NewMount)})};
        {ok, [_CanUp]} ->
            {ok, [Lev, Luck, Grade]} = get_extra_data([3, 18, 19], Extra, []),
            NeedLev = mount_upgrade_data:upgrade_lev(Grade),
            case Lev >= NeedLev of
                true ->
                    SucRate = mount_upgrade_data:get_luck_rate(Grade, Luck),
                    case util:rand(1, 1000) =< SucRate of
                        true ->
                            NewExtra = update_extra([{22, 1}], Extra),
                            {ok, ready, Mount#item{extra = NewExtra}};
                        false ->
                            Max = mount_upgrade_data:get_luck_max(Grade),
                            Times = 1,
                            NewLuck = case util:rand(1, 3) * Times + Luck of
                                Val when Val > Max -> Max;
                                Val -> Val
                            end,
                            NewExtra = update_extra([{18, NewLuck}], Extra),
                            {ok, fal, NewLuck - Luck, Mount#item{extra = NewExtra}}
                    end;
                false ->
                    {false, util:fbin(?L(<<"坐骑需达到~w等级，才能继续进阶。">>), [NeedLev])}
            end;
        {false, Reason} ->
            {false, Reason}
    end.

%% @doc 处理进阶后批量洗髓属性
update_xisui([], _AddGrow, List) -> List;
update_xisui([{Index, Quality, Grows, PerList} | T], AddGrow, List) ->
    NewGrows = [{Key, erlang:round(Grow + AddGrow)} || {Key, Grow} <- Grows],
    update_xisui(T, AddGrow, [{Index, Quality, NewGrows, PerList} | List]).

%% @doc 配对Key
pair_extra([], _, List) -> List;
pair_extra([Key | T1], [Data | T2], List) ->
    pair_extra(T1, T2, [{Key, Data} | List]).

%% @doc 获取extra数据
get_extra_data([], _Extra, DataList) -> {ok, lists:reverse(DataList)};
get_extra_data([H | T], Extra, DataList) ->
    case lists:keyfind(H, 1, Extra) of
        false ->
            {false, ?L(<<"坐骑数据错误">>)};
        {_, Data, _} ->
            get_extra_data(T, Extra, [Data | DataList])
    end.

%% @doc 替换extra数据
update_extra([], Extra) -> Extra;
update_extra([{Key, Val} | T], Extra) ->
    NewExtra = lists:keyreplace(Key, 1, Extra, {Key, Val, <<>>}),
    update_extra(T, NewExtra).

%% @doc 生成extra数据
make_extra(BaseId, Extra) when is_integer(BaseId) ->
    Extra1 = make_extra(BaseId, [{?extra_mount_lev, 1}], Extra),
    Extra2 = clean_old_extra(Extra1),
    make_extra([{4, 0}, {6, 50}, {7, 50}, {8, 50}, {9, 50}, {10, 50}, {11, 50}, {12, 100}, {13, 100}, {14, 100}, {15, 100}, {16, 100}, {17, 100}, {18, 0}, {19, 0}, {20, 0}, {21, 0}, {22, 0}], Extra2);
make_extra([], Extra) -> Extra;
make_extra([{Key, Val} | T], Extra) ->
    case lists:keyfind(Key, 1, Extra) of
        false ->
            make_extra(T, [{Key, Val, <<>>} | Extra]);
        _ ->
            make_extra(T, Extra)
    end.
make_extra(BaseId, [{?extra_mount_lev, Val}], Extra) ->
    case lists:keyfind(3, 1, Extra) of
        false ->            
            Lev = case item_data:get(BaseId) of
                {ok, #item_base{condition = Conds}} ->
                    case lists:keyfind(lev, #condition.label, Conds) of
                        false -> Val;
                        #condition{target_value = InitLev} ->
                            InitLev
                    end;
                _ ->
                    Val
            end,
            [{3, Lev, <<>>} | Extra];
        _ ->
            Extra
    end.

%% 清除旧数据
clean_old_extra(Extra) ->
    case lists:keyfind(21, 1, Extra) of
        false ->
            clean_old_extra([6,7,8,9,10,11,12,13,14,15,16,17,18,19,20], Extra);
        _ ->
            Extra
    end.

clean_old_extra([], Extra) -> Extra;
clean_old_extra([Key | T], Extra) ->
    clean_old_extra(T, lists:keydelete(Key, 1, Extra)).

%% @doc 生成坐骑属性
make_attr(Attr, Extra) ->
    {_, Lev, _} = lists:keyfind(3, 1, Extra),
    Speed = case lists:keyfind(?attr_speed, 1, Attr) of
        false -> {?attr_speed, 100, 0};
        S -> S
    end,
    HoleAttr = [{AttrName, Flag, Val} || {AttrName, Flag, Val} <- Attr, lists:member(AttrName, [?attr_hole1, ?attr_hole2, ?attr_hole3, ?attr_hole4, ?attr_hole5]) =:= true],
    [Speed | mount_feed_data:get_attr(Lev)] ++ HoleAttr.
                                                                                                          
%% @spec do_refresh_growth(Mount, Role) -> {ok, NewRole} | {false, Reason}                                
%% @doc 坐骑洗髓(坐骑不在身上)                                                                            
do_refresh_growth(Mount = #item{pos = 0}, Role0 = #role{mounts = Mounts, link = #link{conn_pid = ConnPid}}) ->
    {Quality, NewMount, Role} = handle_refresh_growth(Mount, Role0),
    NewMounts = storage_api:fresh_mounts(Mount, NewMount, Mounts, ConnPid),
    log:log(log_mount_handle, {<<"洗髓[坐骑栏]">>, [], Mount, NewMount, Role}),
    NewRole = role_listener:acc_event(Role, {127, calc_power(NewMount) - calc_power(Mount)}), %%坐骑战力提升, N当次提升数值
    {ok, Quality, NewRole#role{mounts = NewMounts}};
%% @doc 坐骑洗髓(坐骑在身上)
do_refresh_growth(Mount = #item{id = Id, pos = Pos}, Role0 = #role{mounts = Mounts, eqm = Eqms, link = #link{conn_pid = ConnPid}}) ->
    case lists:keyfind(Pos, #item.pos, Eqms) of
        false ->
            {false, ?L(<<"坐骑数据错误">>)};
        EqmMount ->
            {Quality, NewEqmMount, Role} = handle_refresh_growth(EqmMount, Role0),
            {ok, NewEqms, _} = storage_api:fresh_item(EqmMount, NewEqmMount, Eqms, ConnPid),
            NewMount = NewEqmMount#item{id = Id},
            NewMounts = storage_api:fresh_mounts(Mount, NewMount, Mounts, ConnPid),
            Nr = role_api:push_attr(Role#role{mounts = NewMounts, eqm = NewEqms}),
            map:role_update(Nr),
            log:log(log_mount_handle, {<<"洗髓[装备栏]">>, [], EqmMount, NewMount, Role}),
            rank:listener(mount, Nr, NewMount),
            NewRole = role_listener:acc_event(Nr, {127, calc_power(NewMount) - calc_power(Mount)}), %%坐骑战力提升, N当次提升数值
            {ok, Quality, NewRole}
    end.

%% @doc 选择洗髓属性（坐骑不在身上）
do_choose_growth_per(Mount = #item{pos = 0}, NewMount, Quality, Role = #role{mounts = Mounts, link = #link{conn_pid = ConnPid}}) ->
    NewMounts = storage_api:fresh_mounts(Mount, NewMount, Mounts, ConnPid),
    log:log(log_mount_handle, {<<"选择洗髓属性[坐骑栏]">>, [], Mount, NewMount, Role}),
    NewRole = role_listener:acc_event(Role, {127, calc_power(NewMount) - calc_power(Mount)}), %%坐骑战力提升, N当次提升数值
    {ok, Quality, NewRole#role{mounts = NewMounts}};
%% @doc 选择洗髓属性(坐骑在身上)
do_choose_growth_per(Mount = #item{pos = Pos}, NewMount, Quality, Role = #role{mounts = Mounts, eqm = Eqms, link = #link{conn_pid = ConnPid}}) ->
    case lists:keyfind(Pos, #item.pos, Eqms) of
        false ->
            {false, ?L(<<"坐骑数据错误">>)};
        EqmMount = #item{id = EqmId} ->
            NewEqmMount = NewMount#item{id = EqmId},
            {ok, NewEqms, _} = storage_api:fresh_item(EqmMount, NewEqmMount, Eqms, ConnPid),
            NewMounts = storage_api:fresh_mounts(Mount, NewMount, Mounts, ConnPid),
            Nr = role_api:push_attr(Role#role{mounts = NewMounts, eqm = NewEqms}),
            map:role_update(Nr),
            log:log(log_mount_handle, {<<"选择洗髓属性[装备栏]">>, [], EqmMount, NewMount, Role}),
            rank:listener(mount, Nr, NewMount),
            NewRole = role_listener:acc_event(Nr, {127, calc_power(NewMount) - calc_power(Mount)}), %%坐骑战力提升, N当次提升数值
            {ok, Quality, NewRole}
    end.

%% @doc 处理洗髓
handle_refresh_growth(Mount = #item{attr = Attr, extra = Extra}, Role) ->
    PerList = calc_refresh_per(),
    {ok, [Grade]} = get_extra_data([19], Extra, []),
    GrowSum = mount_upgrade_data:get_growth(Grade),
    NewGrowList = calc_refresh_grow(GrowSum, PerList, []),
    Quality = refresh_quality(Grade),
    Addition = calc_addition(Grade, Quality),
    NewExtra = update_extra([{20, Quality}, {21, Addition}] ++ NewGrowList ++ PerList, Extra),
    NewAttr = update_mount_attr(Attr, NewExtra),
    NewMount = calc_skin_attr(Mount#item{attr = NewAttr, extra = NewExtra}),
    {Quality, NewMount, role_listener:special_event(Role, {20024, calc_power(NewMount)})}.
   
%% @doc 计算洗髓
calc_refresh_grow(_GrowSum, [], GrowList) -> GrowList;
calc_refresh_grow(GrowSum, [{Key, Per} | T], GrowList) ->
    calc_refresh_grow(GrowSum, T, [{Key - 6, erlang:round(GrowSum * Per / 600)} | GrowList]).
    
%% @doc 计算洗髓各项成长百分比
calc_refresh_per() ->
    PerList = [{Key, 0} || Key <- [12,13,14,15,16,17]],
    calc_refresh_per(600, PerList, []).
calc_refresh_per(0, PerList, FullPerList) -> lists:keysort(1, FullPerList ++ PerList);
calc_refresh_per(PerSum, PerList, FullPerList) ->
    N = util:rand(1, erlang:length(PerList)),
    {Key, Val} = lists:nth(N, PerList),
    AddVal = Val + ?refresh_points,
    case AddVal < 150 of
        true -> 
            NewPerList = lists:keyreplace(Key, 1, PerList, {Key, AddVal}),
            calc_refresh_per(PerSum - ?refresh_points, NewPerList, FullPerList);
        false ->
            NewPerList = lists:keydelete(Key, 1, PerList),
            calc_refresh_per(PerSum - ?refresh_points, NewPerList, [{Key, AddVal} | FullPerList])
    end.

%% @doc 刷新品质
refresh_quality(Grade) ->
    Per = util:rand(1, 100),
    mount_upgrade_data:get_refresh_quality(Grade, Per).

%% @doc 计算灵犀值加成
calc_addition(Grade, Quantity) ->
    ?grade_addition(Grade) + ?quality_addition(Quantity).

%% @doc 批量洗髓
do_batch_refresh_growth(Mount = #item{pos = 0}, Role = #role{mounts = Mounts, link = #link{conn_pid = ConnPid}}) ->
    {List, Grade, NewMount} = handle_batch_refresh_growth(Mount),
    NewMounts = storage_api:fresh_mounts(Mount, NewMount, Mounts, ConnPid),
    log:log(log_mount_handle, {<<"批量洗髓[坐骑栏]">>, [], Mount, NewMount, Role}),
    {ok, List, Grade, Role#role{mounts = NewMounts}};
%% @doc 批量洗髓(坐骑在身上)
do_batch_refresh_growth(Mount = #item{id = Id, pos = Pos}, Role = #role{mounts = Mounts, eqm = Eqms, link = #link{conn_pid = ConnPid}}) ->
    case lists:keyfind(Pos, #item.pos, Eqms) of
        false ->
            {false, ?L(<<"坐骑数据错误">>)};
        EqmMount ->
            {List, Grade, NewEqmMount} = handle_batch_refresh_growth(EqmMount),
            {ok, NewEqms, _} = storage_api:fresh_item(EqmMount, NewEqmMount, Eqms, ConnPid),
            NewMount = NewEqmMount#item{id = Id},
            NewMounts = storage_api:fresh_mounts(Mount, NewMount, Mounts, ConnPid),
            log:log(log_mount_handle, {<<"批量洗髓[装备栏]">>, [], EqmMount, NewMount, Role}),
            {ok, List, Grade, Role#role{mounts = NewMounts, eqm = NewEqms}}
    end.

%% @doc 处理批量洗髓
handle_batch_refresh_growth(Mount = #item{extra = Extra}) ->
    {ok, [Grade]} = get_extra_data([19], Extra, []),
    List = handle_batch_refresh_growth(Grade, 6, []),
    {List, Grade, Mount#item{xisui_list = List}}.

handle_batch_refresh_growth(_Grade, Num, List) when Num =< 0 -> List;
handle_batch_refresh_growth(Grade, Num, List) ->
    PerList = calc_refresh_per(),
    GrowSum = mount_upgrade_data:get_growth(Grade),
    GrowList = calc_refresh_grow(GrowSum, PerList, []),
    Quality = refresh_quality(Grade),
    handle_batch_refresh_growth(Grade, Num - 1, [{Num, Quality, GrowList, PerList} | List]).

%% @doc 坐骑列表pos清零
clean_pos([], NewItems) -> NewItems;
clean_pos([Item = #item{pos = 0} | T], NewItems) ->
    clean_pos(T, [Item | NewItems]);
clean_pos([Item | T], NewItems) ->
    clean_pos(T, [Item#item{pos = 0} | NewItems]).

%% @doc 获取属性数据
get_attr_data(Key, Attr) ->
    case lists:keyfind(Key, 1, Attr) of
        false -> 0;
        {_, _, Data} -> Data
    end.

%% @doc 减除喂养经验
reduce_feed_exp(Lev, _Exp) when Lev =< 0 -> {0, 1};
reduce_feed_exp(Lev, Exp) ->
    GradeExp = mount_feed_data:get_upgrade_exp(Lev),
    case GradeExp >= Exp of
        true ->
            {GradeExp - Exp, Lev};
        false ->
            reduce_feed_exp(Lev - 1, Exp - GradeExp)
    end.

%% @doc 计算坐骑战斗力
calc_power(#item{attr = Attr}) ->
    calc_power(Attr);
calc_power(Attr) ->
    Js = get_attr_data(?attr_js, Attr),
    Dmg = get_attr_data(?attr_dmg, Attr),
    Def = get_attr_data(?attr_defence, Attr),
    Hp = get_attr_data(?attr_hp_max, Attr),
    Ten = get_attr_data(?attr_tenacity, Attr),
    Cri = get_attr_data(?attr_critrate, Attr),
    erlang:trunc((Js * 5 + Dmg * 7.7 + Def * 3 + 1 * Hp + Ten * 10 + Cri * 10) / 4).

%% @doc 计算坐骑looks
calc_looks(SkinId, BuffSkinId, IsBuffSkin, Enchant) ->
    LooksVal = if
        Enchant < 9 -> ?LOOKS_VAL_ENCHANT_NORMAL;
        Enchant >= 9 andalso Enchant =< 11 -> ?LOOKS_VAL_ENCHANT_NINE;
        Enchant =:= 12 -> ?LOOKS_VAL_ENCHANT_TWELVE
    end,
    UseSkinId = case IsBuffSkin of
        0 -> SkinId;
        1 -> BuffSkinId
    end,
    [{?LOOKS_TYPE_RIDE, UseSkinId, LooksVal}].


%%% @doc 找出等级最高坐骑
%find_top_mount([], _TopLev, Mount) -> Mount;
%find_top_mount([H = #item{extra = Extra} | T], TopLev, Mount) ->
%    case get_extra_data([?extra_mount_lev], Extra, []) of
%        {ok, [Lev]} ->
%            case Lev > TopLev of
%                true ->
%                    find_top_mount(T, Lev, H);
%                false ->
%                    find_top_mount(T, TopLev, Mount)
%            end;
%        {false, _Reason} ->
%            []
%    end.
