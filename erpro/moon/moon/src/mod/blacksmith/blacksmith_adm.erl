%%----------------------------------------------------
%%  锻造物品系统
%%
%% @author shawnoyc@163.com
%%----------------------------------------------------
-module(blacksmith_adm).
-export([
        fix_craft/4
        ,fix_enchant/3
        ,fix_role_gs/1
    ]
).

-include("item.hrl").
-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("storage.hrl").


%% to_pos("武器") -> 1;
%% to_pos("衣服") -> 2;
%% to_pos("裤子") -> 6;
%% to_pos("护手") -> 5;
%% to_pos("护腕") -> 4;
%% to_pos("鞋子") -> 7;
%% to_pos("腰带") -> 3;
%% to_pos("时装") -> 10;
%% to_pos("坐骑") -> 14;
%% to_pos("翅膀") -> 15;
%% to_pos("戒指1") -> 11;
%% to_pos("戒指2") -> 12;
%% to_pos("护符1") -> 8;
%% to_pos("护符2") -> 9;
%% to_pos(_) -> 0.

fix_craft({id, Id, SrvId}, eqm, Pos, Craft) ->
    case role_api:lookup(by_id, {Id, SrvId}, #role.pid) of
        {ok, _N, Pid} -> 
            role:apply(async, Pid, {fun craft/4, [eqm, Pos, Craft]}),
            ok;
        _ -> 
            ?INFO("角色不在线"),
            ok
    end;

fix_craft({id, Id, SrvId}, bag, Pos, Craft) ->
    case role_api:lookup(by_id, {Id, SrvId}, #role.pid) of
        {ok, _N, Pid} -> 
            role:apply(async, Pid, {fun craft/4, [bag, Pos, Craft]}),
            ok;
        _ -> 
            ?INFO("角色不在线"),
            ok
    end;
fix_craft({id, Id, SrvId}, store, Pos, Craft) ->
    case role_api:lookup(by_id, {Id, SrvId}, #role.pid) of
        {ok, _N, Pid} -> 
            role:apply(async, Pid, {fun craft/4, [store, Pos, Craft]}),
            ok;
        _ -> 
            ?INFO("角色不在线"),
            ok
    end.
fix_enchant({id, Id, SrvId}, weapon_dress, Enchant) -> 
    case role_api:lookup(by_id, {Id, SrvId}, #role.pid) of
        {ok, _N, Pid} -> 
            role:apply(async, Pid, {fun enchant/3, [weapon_dress, Enchant]}),
            ok;
        _ -> 
            ?INFO("角色不在线"),
            ok
    end;
fix_enchant({id, Id, SrvId}, jewelry_dress, Enchant) -> 
    case role_api:lookup(by_id, {Id, SrvId}, #role.pid) of
        {ok, _N, Pid} -> 
            role:apply(async, Pid, {fun enchant/3, [jewelry_dress, Enchant]}),
            ok;
        _ -> 
            ?INFO("角色不在线"),
            ok
    end;
fix_enchant({id, Id, SrvId}, mount, Enchant) -> 
    case role_api:lookup(by_id, {Id, SrvId}, #role.pid) of
        {ok, _N, Pid} -> 
            role:apply(async, Pid, {fun enchant/3, [mount, Enchant]}),
            ok;
        _ -> 
            ?INFO("角色不在线"),
            ok
    end.

enchant(Role = #role{name = Name, eqm = Eqm, link = #link{conn_pid = ConnPid}, dress = Dress}, weapon_dress, Enchant) ->
    case Enchant >= 0 andalso Enchant =< 12 of
        true ->
            case eqm:find_eqm_by_id(Eqm, eqm:type_to_pos(?item_weapon_dress)) of
                {ok, Item = #item{type = ?item_weapon_dress, special = Special}} ->
                    NewSpecial = case lists:keyfind(?special_eqm_wish, 1, Special) of
                        false when Enchant =:= 9 -> [{?special_eqm_wish, {10, 0}} | Special];
                        false when Enchant =:= 10 -> [{?special_eqm_wish, {11, 0}} | Special];
                        false when Enchant =:= 11 -> [{?special_eqm_wish, {12, 0}} | Special];
                        {_, _} ->
                            New = lists:keydelete(?special_eqm_wish, 1, Special),
                            case Enchant of
                                9 ->  [{?special_eqm_wish, {10, 0}} | New];
                                10 -> [{?special_eqm_wish, {11, 0}} | New];
                                11 -> [{?special_eqm_wish, {12, 0}} | New];
                                _ -> New
                            end;
                        _ -> Special
                    end,
                    NewItem = blacksmith:recalc_attr(Item#item{enchant = Enchant, special = NewSpecial}),
                    {ok, NewEqm, _NewItem} = storage_api:fresh_item(Item, NewItem, Eqm, ConnPid),
                    NewDress = storage_api:fresh_dress(NewItem, Dress, ConnPid),
                    NR = looks:calc(Role#role{eqm = NewEqm, dress = NewDress}),
                    NR1 = role_api:push_attr(NR),
                    map:role_update(NR1),
                    looks:refresh(Role, NR1),
                    ?INFO("[~s]执行强化修复Enchant:~w",[Name, Enchant]),
                    {ok, NR1};
                _ ->
                    ?INFO("武饰数据异常,无法修复"),
                    {ok}
            end;
        false ->
            ?INFO("不存在该强化等级"),
            {ok}
    end;

enchant(Role = #role{name = Name, eqm = Eqm, link = #link{conn_pid = ConnPid}, dress = Dress}, jewelry_dress, Enchant) ->
    case Enchant >= 0 andalso Enchant =< 12 of
        true ->
            case eqm:find_eqm_by_id(Eqm, eqm:type_to_pos(?item_jewelry_dress)) of
                {ok, Item = #item{type = ?item_jewelry_dress, special = Special}} ->
                    NewSpecial = case lists:keyfind(?special_eqm_wish, 1, Special) of
                        false when Enchant =:= 9 -> [{?special_eqm_wish, {10, 0}} | Special];
                        false when Enchant =:= 10 -> [{?special_eqm_wish, {11, 0}} | Special];
                        false when Enchant =:= 11 -> [{?special_eqm_wish, {12, 0}} | Special];
                        {_, _} ->
                            New = lists:keydelete(?special_eqm_wish, 1, Special),
                            case Enchant of
                                9 ->  [{?special_eqm_wish, {10, 0}} | New];
                                10 -> [{?special_eqm_wish, {11, 0}} | New];
                                11 -> [{?special_eqm_wish, {12, 0}} | New];
                                _ -> New
                            end;
                        _ -> Special
                    end,
                    NewItem = blacksmith:recalc_attr(Item#item{enchant = Enchant, special = NewSpecial}),
                    {ok, NewEqm, _NewItem} = storage_api:fresh_item(Item, NewItem, Eqm, ConnPid),
                    NewDress = storage_api:fresh_dress(NewItem, Dress, ConnPid),
                    NR = looks:calc(Role#role{eqm = NewEqm, dress = NewDress}),
                    NR1 = role_api:push_attr(NR),
                    map:role_update(NR1),
                    looks:refresh(Role, NR1),
                    ?INFO("[~s]执行强化修复Enchant:~w",[Name, Enchant]),
                    {ok, NR1};
                _ ->
                    ?INFO("挂饰数据异常,无法修复"),
                    {ok}
            end;
        false ->
            ?INFO("不存在该强化等级"),
            {ok}
    end;

enchant(Role = #role{name = Name, eqm = Eqm, link = #link{conn_pid = ConnPid}, dress = Dress}, footprint, Enchant) ->
    case Enchant >= 0 andalso Enchant =< 12 of
        true ->
            case eqm:find_eqm_by_id(Eqm, eqm:type_to_pos(?item_footprint)) of
                {ok, Item = #item{type = ?item_footprint, special = Special}} ->
                    NewSpecial = case lists:keyfind(?special_eqm_wish, 1, Special) of
                        false when Enchant =:= 9 -> [{?special_eqm_wish, {10, 0}} | Special];
                        false when Enchant =:= 10 -> [{?special_eqm_wish, {11, 0}} | Special];
                        false when Enchant =:= 11 -> [{?special_eqm_wish, {12, 0}} | Special];
                        {_, _} ->
                            New = lists:keydelete(?special_eqm_wish, 1, Special),
                            case Enchant of
                                9 ->  [{?special_eqm_wish, {10, 0}} | New];
                                10 -> [{?special_eqm_wish, {11, 0}} | New];
                                11 -> [{?special_eqm_wish, {12, 0}} | New];
                                _ -> New
                            end;
                        _ -> Special
                    end,
                    NewItem = blacksmith:recalc_attr(Item#item{enchant = Enchant, special = NewSpecial}),
                    {ok, NewEqm, _NewItem} = storage_api:fresh_item(Item, NewItem, Eqm, ConnPid),
                    NewDress = storage_api:fresh_dress(NewItem, Dress, ConnPid),
                    NR = looks:calc(Role#role{eqm = NewEqm, dress = NewDress}),
                    NR1 = role_api:push_attr(NR),
                    map:role_update(NR1),
                    looks:refresh(Role, NR1),
                    ?INFO("[~s]执行强化修复Enchant:~w",[Name, Enchant]),
                    {ok, NR1};
                _ ->
                    ?INFO("足迹数据异常,无法修复"),
                    {ok}
            end;
        false ->
            ?INFO("不存在该强化等级"),
            {ok}
    end;

enchant(Role = #role{name = Name, eqm = Eqm, link = #link{conn_pid = ConnPid}, dress = Dress}, chat_frame, Enchant) ->
    case Enchant >= 0 andalso Enchant =< 12 of
        true ->
            case eqm:find_eqm_by_id(Eqm, eqm:type_to_pos(?item_chat_frame)) of
                {ok, Item = #item{type = ?item_chat_frame, special = Special}} ->
                    NewSpecial = case lists:keyfind(?special_eqm_wish, 1, Special) of
                        false when Enchant =:= 9 -> [{?special_eqm_wish, {10, 0}} | Special];
                        false when Enchant =:= 10 -> [{?special_eqm_wish, {11, 0}} | Special];
                        false when Enchant =:= 11 -> [{?special_eqm_wish, {12, 0}} | Special];
                        {_, _} ->
                            New = lists:keydelete(?special_eqm_wish, 1, Special),
                            case Enchant of
                                9 ->  [{?special_eqm_wish, {10, 0}} | New];
                                10 -> [{?special_eqm_wish, {11, 0}} | New];
                                11 -> [{?special_eqm_wish, {12, 0}} | New];
                                _ -> New
                            end;
                        _ -> Special
                    end,
                    NewItem = blacksmith:recalc_attr(Item#item{enchant = Enchant, special = NewSpecial}),
                    {ok, NewEqm, _NewItem} = storage_api:fresh_item(Item, NewItem, Eqm, ConnPid),
                    NewDress = storage_api:fresh_dress(NewItem, Dress, ConnPid),
                    NR = looks:calc(Role#role{eqm = NewEqm, dress = NewDress}),
                    NR1 = role_api:push_attr(NR),
                    map:role_update(NR1),
                    looks:refresh(Role, NR1),
                    ?INFO("[~s]执行强化修复Enchant:~w",[Name, Enchant]),
                    {ok, NR1};
                _ ->
                    ?INFO("炫酷聊天框数据异常,无法修复"),
                    {ok}
            end;
        false ->
            ?INFO("不存在该强化等级"),
            {ok}
    end;

enchant(Role = #role{name = Name, eqm = Eqm, link = #link{conn_pid = ConnPid}, dress = Dress}, text_style, Enchant) ->
    case Enchant >= 0 andalso Enchant =< 12 of
        true ->
            case eqm:find_eqm_by_id(Eqm, eqm:type_to_pos(?item_text_style)) of
                {ok, Item = #item{type = ?item_text_style, special = Special}} ->
                    NewSpecial = case lists:keyfind(?special_eqm_wish, 1, Special) of
                        false when Enchant =:= 9 -> [{?special_eqm_wish, {10, 0}} | Special];
                        false when Enchant =:= 10 -> [{?special_eqm_wish, {11, 0}} | Special];
                        false when Enchant =:= 11 -> [{?special_eqm_wish, {12, 0}} | Special];
                        {_, _} ->
                            New = lists:keydelete(?special_eqm_wish, 1, Special),
                            case Enchant of
                                9 ->  [{?special_eqm_wish, {10, 0}} | New];
                                10 -> [{?special_eqm_wish, {11, 0}} | New];
                                11 -> [{?special_eqm_wish, {12, 0}} | New];
                                _ -> New
                            end;
                        _ -> Special
                    end,
                    NewItem = blacksmith:recalc_attr(Item#item{enchant = Enchant, special = NewSpecial}),
                    {ok, NewEqm, _NewItem} = storage_api:fresh_item(Item, NewItem, Eqm, ConnPid),
                    NewDress = storage_api:fresh_dress(NewItem, Dress, ConnPid),
                    NR = looks:calc(Role#role{eqm = NewEqm, dress = NewDress}),
                    NR1 = role_api:push_attr(NR),
                    map:role_update(NR1),
                    looks:refresh(Role, NR1),
                    ?INFO("[~s]执行强化修复Enchant:~w",[Name, Enchant]),
                    {ok, NR1};
                _ ->
                    ?INFO("个性文字数据异常,无法修复"),
                    {ok}
            end;
        false ->
            ?INFO("不存在该强化等级"),
            {ok}
    end;

enchant(Role = #role{name = Name, eqm = Eqm, link = #link{conn_pid = ConnPid}, mounts = Mounts}, mount, Enchant) ->
    case Enchant >= 0 andalso Enchant =< 12 of
        true ->
            case eqm:find_eqm_by_id(Eqm, eqm:type_to_pos(?item_zuo_qi)) of
                {ok, Item = #item{type = ?item_zuo_qi, special = Special}} ->
                    NewSpecial = case lists:keyfind(?special_eqm_wish, 1, Special) of
                        false when Enchant =:= 9 -> [{?special_eqm_wish, {10, 0}} | Special];
                        false when Enchant =:= 10 -> [{?special_eqm_wish, {11, 0}} | Special];
                        false when Enchant =:= 11 -> [{?special_eqm_wish, {12, 0}} | Special];
                        {_, _} ->
                            New = lists:keydelete(?special_eqm_wish, 1, Special),
                            case Enchant of
                                9 ->  [{?special_eqm_wish, {10, 0}} | New];
                                10 -> [{?special_eqm_wish, {11, 0}} | New];
                                11 -> [{?special_eqm_wish, {12, 0}} | New];
                                _ -> New
                            end;
                        _ -> Special
                    end,
                    NewItem = blacksmith:recalc_attr(Item#item{enchant = Enchant, special = NewSpecial}),
                    {ok, NewEqm, _NewItem} = storage_api:fresh_item(Item, NewItem, Eqm, ConnPid),
                    NewMounts = storage_api:fresh_mounts(Item, NewItem, Mounts, ConnPid),
                    NR = looks:calc(Role#role{eqm = NewEqm, mounts = NewMounts}),
                    NR1 = role_api:push_attr(NR),
                    map:role_update(NR1),
                    looks:refresh(Role, NR1),
                    ?INFO("[~s]执行强化修复Enchant:~w",[Name, Enchant]),
                    {ok, NR1};
                _ ->
                    ?INFO("坐骑数据异常,无法修复"),
                    {ok}
            end;
        false ->
            ?INFO("不存在该强化等级"),
            {ok}
    end.

craft(Role = #role{name = Name, eqm = Eqm, link = #link{conn_pid = ConnPid}}, eqm, Pos, Craft) ->
    case Craft >= ?craft_0 andalso Craft =< ?craft_4 of
        true ->
            case eqm:find_eqm_by_id(Eqm, Pos) of
                {ok, Item} ->
                    NewItem = blacksmith:recalc_attr(Item#item{craft = Craft}),
                    {ok, NewEqm, _NewItem} = storage_api:fresh_item(Item, NewItem, Eqm, ConnPid),
                    NR = looks:calc(Role#role{eqm = NewEqm}),
                    NR1 = role_api:push_attr(NR),
                    looks:refresh(Role, NR1),
                    ?INFO("[~s]执行精良修复Pos:~w,Craft:~w",[Name, Pos, Craft]),
                    {ok, NR1};
                _ ->
                    ?INFO("请先穿戴此装备,再进行提升"),
                    {ok}
            end;
        false ->
            ?INFO("请输入0-4品质等级"),
            {ok}
    end;

craft(Role = #role{name = Name, store = Store = #store{items = Items}, link = #link{conn_pid = ConnPid}}, store, Pos, Craft) ->
    case Craft >= ?craft_0 andalso Craft =< ?craft_4 of
        true ->
            case storage:find(Items, #item.pos, Pos) of
                {ok, Item} ->
                    NewItem = blacksmith:recalc_attr(Item#item{craft = Craft}),
                    {ok, NewStore, _NewItem} = storage_api:fresh_item(Item, NewItem, Store, ConnPid),
                    ?INFO("[~s]执行精良修复Pos:~w,Craft:~w",[Name, Pos, Craft]),
                    {ok, Role#role{store = NewStore}};
                _ ->
                    ?INFO("无法发现此装备"),
                    {ok}
            end;
        false ->
            ?INFO("请输入0-4品质等级"),
            {ok}
    end.

%% 修复60升70橙装，神佑等级问题
fix_role_gs({Rid, SrvId}) ->
    case role_api:lookup(by_id, {Rid, SrvId}, #role.pid) of
        {ok, _, Pid} ->
            role:apply(async, Pid, {fun fix_role_gs/1, []});
        _ -> ?INFO("玩家不在线，修复失败")
    end;
fix_role_gs(Role = #role{eqm = EqmList}) ->
    {ok, fix_role_gs(EqmList, Role)}.

fix_role_gs([], Role) -> Role;
fix_role_gs([EqmItem = #item{require_lev = ReqLev, extra = Extra} | T], Role = #role{eqm = EqmList, link = #link{conn_pid = ConnPid}})
when ReqLev >= 70 andalso ReqLev < 80 ->
    case item:check_is_gs(EqmItem) of
        false -> fix_role_gs(T, Role);
        true ->
            case blacksmith:get_gs_lev(EqmItem) of
                0 ->
                    NewExtra = case lists:keyfind(?extra_eqm_gs_lev, 1, Extra) of
                        false -> [{?extra_eqm_gs_lev, 1, <<>>} | Extra];
                        _ -> Extra
                    end,
                    ?DEBUG("BaseId:~w EXTRA:~w", [EqmItem#item.base_id, NewExtra]),
                    NewItem = blacksmith:recalc_gs_eqm(by_lev, 1, EqmItem#item{extra = NewExtra}),
                    {ok, NewEqmList, _} = storage_api:fresh_item(EqmItem, NewItem, EqmList, ConnPid),
                    fix_role_gs(T, Role#role{eqm = NewEqmList});
                _GsLv -> fix_role_gs(T, Role)
            end
    end;
fix_role_gs([_EqmItem | T], Role) ->
    fix_role_gs(T, Role). %% 只针对70级装备
