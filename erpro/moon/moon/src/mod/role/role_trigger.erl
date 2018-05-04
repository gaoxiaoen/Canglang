%%----------------------------------------------------
%% 触发器相关接口
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(role_trigger).
-export([
        add/3
        ,del/3
        ,del/2
        ,clear_guild_trg/1
    ]
).
-include("common.hrl").
-include("trigger.hrl").
-define(KEY_POS, 1).
-define(A(L), [{Id, {M, F, [Id | A]}} | L]).
-define(MFA(Mfa), {M, F, A}).
-define(D, lists:keydelete(Id, ?KEY_POS, L)).

%% @spec add(Type, T, Mfa) -> {ok, Id, NewTrigger}
%% Type = atom()
%% T = #trigger{}
%% NewTrigger = #trigger{}
%% Mfa = mfa()
%% Id = integer()
%% @doc 添加触发器
%% <pre>
%% Type = atom() 触发器类型
%% Trigger = NewTrigger = #trigger{} 触发器数据
%% Mfa = {Module, Function, Arguments} 回调函数
%% Id = integer() 添加成功的触发器Id
%% </pre>
add(coin, T = #trigger{next_id = Id, coin = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, coin = ?A(L)}};
add(vip, T = #trigger{next_id = Id, vip = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, vip = ?A(L)}};
add(get_coin, T = #trigger{next_id = Id, get_coin = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, get_coin = ?A(L)}};
add(kill_npc, T = #trigger{next_id = Id, kill_npc = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, kill_npc = ?A(L)}};
add(get_item, T = #trigger{next_id = Id, get_item = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, get_item = ?A(L)}};
add(use_item, T = #trigger{next_id = Id, use_item = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, use_item = ?A(L)}};
add(finish_task, T = #trigger{next_id = Id, finish_task = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, finish_task = ?A(L)}};
add(buy_item_store, T = #trigger{next_id = Id, buy_item_store = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, buy_item_store = ?A(L)}};
add(buy_item_shop, T = #trigger{next_id = Id, buy_item_shop = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, buy_item_shop = ?A(L)}};
add(special_event, T = #trigger{next_id = Id, special_event = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, special_event = ?A(L)}};
add(make_friend, T = #trigger{next_id = Id, make_friend= L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, make_friend= ?A(L)}};
add(acc_event, T = #trigger{next_id = Id, acc_event= L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, acc_event= ?A(L)}};
add(lev, T = #trigger{next_id = Id, lev = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, lev = ?A(L)}};
add(eqm_event, T = #trigger{next_id = Id, eqm_event = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, eqm_event = ?A(L)}};
add(sweep_dungeon, T = #trigger{next_id = Id, sweep_dungeon = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, sweep_dungeon = ?A(L)}};
add(ease_dungeon, T = #trigger{next_id = Id, ease_dungeon = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, ease_dungeon = ?A(L)}};
add(once_dungeon, T = #trigger{next_id = Id, once_dungeon = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, once_dungeon = ?A(L)}};
add(star_dungeon, T = #trigger{next_id = Id, star_dungeon = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, star_dungeon = ?A(L)}};


%% 军团目标
add(guild_wish, T = #trigger{next_id = Id, guild_wish = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, guild_wish = ?A(L)}};
add(guild_buy, T = #trigger{next_id = Id, guild_buy = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, guild_buy = ?A(L)}};
add(guild_kill_pirate, T = #trigger{next_id = Id, guild_kill_pirate = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, guild_kill_pirate = ?A(L)}};
add(guild_chleg, T = #trigger{next_id = Id, guild_chleg = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, guild_chleg = ?A(L)}};
add(guild_gc, T = #trigger{next_id = Id, guild_gc = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, guild_gc = ?A(L)}};
add(guild_dungeon, T = #trigger{next_id = Id, guild_dungeon = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, guild_dungeon = ?A(L)}};
add(guild_tree, T = #trigger{next_id = Id, guild_tree = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, guild_tree = ?A(L)}};
add(guild_activity, T = #trigger{next_id = Id, guild_activity = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, guild_activity = ?A(L)}};
add(guild_skill, T = #trigger{next_id = Id, guild_skill = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, guild_skill = ?A(L)}};
add(guild_multi_dun, T = #trigger{next_id = Id, guild_multi_dun = L}, ?MFA(Mfa)) ->
    {ok, Id, T#trigger{next_id = Id + 1, guild_multi_dun= ?A(L)}};



add(Type, T, _Mfa) ->
    ?ELOG("不存在的触发器分类:~w Trigger:~w", [Type, T]),
    false.

%% @spec del(Type, Trigger, Id) -> {ok, NewTrigger}
%% Type = atom()
%% trigger = #trigger{}
%% NewTrigger = #trigger{}
%% Id = integer()
%% @doc 删除触发器
%% <div>Type = atom() 触发器类型</div>
%% <div>Trigger = NewTrigger = #trigger{} 触发器数据</div>
%% <div>Id = integer() 添加成功的触发器Id</div>
del(coin, T = #trigger{coin = L}, Id) ->
    {ok, T#trigger{coin = ?D}};
del(vip, T = #trigger{vip = L}, Id) ->
    {ok, T#trigger{vip = ?D}};
del(get_coin, T = #trigger{get_coin = L}, Id) ->
    {ok, T#trigger{get_coin = ?D}};
del(kill_npc, T = #trigger{kill_npc = L}, Id) ->
    {ok, T#trigger{kill_npc = ?D}};
del(get_item, T = #trigger{get_item = L}, Id) ->
    {ok, T#trigger{get_item = ?D}};
del(use_item, T = #trigger{use_item = L}, Id) ->
    {ok, T#trigger{use_item = ?D}};
del(finish_task, T = #trigger{finish_task = L}, Id) ->
    {ok, T#trigger{finish_task = ?D}};
del(buy_item_store, T = #trigger{buy_item_store = L}, Id) ->
    {ok, T#trigger{buy_item_store = ?D}};
del(buy_item_shop, T = #trigger{buy_item_shop = L}, Id) ->
    {ok, T#trigger{buy_item_shop = ?D}};
del(special_event, T = #trigger{special_event = L}, Id) ->
    {ok, T#trigger{special_event = ?D}};
del(make_friend, T = #trigger{make_friend= L}, Id) ->
    {ok, T#trigger{make_friend= ?D}};
del(acc_event, T = #trigger{acc_event = L}, Id) ->
    {ok, T#trigger{acc_event = ?D}};
del(lev, T = #trigger{lev = L}, Id) ->
    {ok, T#trigger{lev = ?D}};
del(eqm_event, T = #trigger{eqm_event = L}, Id) ->
    {ok, T#trigger{eqm_event = ?D}};
del(sweep_dungeon, T = #trigger{sweep_dungeon = L}, Id) ->
    {ok, T#trigger{sweep_dungeon = ?D}};
del(ease_dungeon, T = #trigger{ease_dungeon = L}, Id) ->
    {ok, T#trigger{ease_dungeon = ?D}};
del(star_dungeon, T = #trigger{star_dungeon = L}, Id) ->
    {ok, T#trigger{star_dungeon = ?D}};

del(_Type, _Trigger, _Id) ->
    ?ELOG("不存在的触发器分类:~w", [_Type]),
    false.

%% 军团目标触发器 注意：是全部删除的
del(guild_wish, T) ->
    {ok, T#trigger{guild_wish = []}};
del(guild_buy, T) ->
    {ok, T#trigger{guild_buy = []}};
del(guild_kill_pirate, T) ->
    {ok, T#trigger{guild_kill_pirate = []}};
del(guild_chleg, T) ->
    {ok, T#trigger{guild_chleg = []}};
del(guild_gc, T) ->
    {ok, T#trigger{guild_gc = []}};
del(guild_dungeon, T) ->
    {ok, T#trigger{guild_dungeon= []}};
del(guild_tree, T) ->
    {ok, T#trigger{guild_tree = []}};
del(guild_activity, T) ->
    {ok, T#trigger{guild_activity = []}};
del(guild_skill, T) ->
    {ok, T#trigger{guild_skill = []}};
del(guild_multi_dun, T) ->
    {ok, T#trigger{guild_multi_dun = []}};

del(_Type, _Trigger) ->
    ?ELOG("不存在的触发器分类:~w", [_Type]),
    false.

%% 清除所有军团触发器
clear_guild_trg(T) ->
    GuildTrgLabel = [guild_wish, guild_buy, guild_kill_pirate, guild_chleg, guild_gc, guild_dungeon, guild_tree, guild_activity,
                    guild_skill, guild_multi_dun],
    do_clear_guild_trg(GuildTrgLabel, T).

do_clear_guild_trg([],Trg) -> Trg;
do_clear_guild_trg([Label|T],Trg) ->
    case del(Label, Trg) of
        false -> Trg;
        {ok, NewTrg} -> do_clear_guild_trg(T,NewTrg)
    end.
