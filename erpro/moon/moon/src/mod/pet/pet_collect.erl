%%----------------------------------------------------
%% 星宠卡
%% @author weihua@jieyou.cn
%%----------------------------------------------------
-module(pet_collect).
-export([info/1
        ,collect/2
        ,history/2
        ,history/0
        ,calc_attr/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("pet_rb.hrl").
-include("link.hrl").
-include("pet.hrl").
-include("item.hrl").

-define(pet_collect_history_file, "../var/pet_collect.log").
-define(pet_collect_max_lev, 6).
-define(pet_collect_history_num, 20).
-define(pet_collect_lev(Num),
    if
        Num >= 12 -> 6;
        Num >= 10 -> 5;
        Num >= 8 -> 4;
        Num >= 6 -> 3;
        Num >= 4 -> 2;
        Num >= 2 -> 1;
        true -> 0
    end).
%% 这些数据不可以随便改动
-define(pet_collect_cards, [23540, 23541, 23542, 23543, 23544, 23545, 23546, 23547, 23548, 23549, 23550, 23551]).
-define(pet_collect_lev_to_reward(Lev),
    case Lev of
        6 -> 23507;
        _ -> 0
    end).

%% 日志
-record(pet_collect_log, {
        time = 0
        ,rid = 0
        ,srvid = <<>>
        ,name = <<>>
        ,item_id = 0
        ,item_name = <<>>
    }
).

calc_attr(#role{pet_cards_collect = Cards}) ->
    Collected = length(Cards) - length(Cards -- ?pet_collect_cards),
    Lev = ?pet_collect_lev(Collected),
    PetAttr = [{Label, 0, Val} || {Label, Val} <- lev_attr(Lev)],
    case Lev =:= ?pet_collect_max_lev of
        false -> PetAttr;
        true -> [{?attr_pet_skill_kill, 0, 3}, {?attr_pet_skill_protect, 0, 3}, {?attr_pet_skill_anima, 0, 3}| PetAttr]
    end;
calc_attr(_) ->
    [].

%% 获取星宠信息
info(#role{pet_cards_collect = CardIds}) ->
    PetId = case actived(CardIds) of
        [H | _] -> H;
        _ -> 0
    end,
    Cards = lists:map(fun(Elem) -> case lists:member(Elem, CardIds) of
                    true -> {Elem, ?true, card_to_img(Elem)};
                    false -> {Elem, ?false, card_to_img(Elem)}
                end
        end, ?pet_collect_cards),
    Collected = length(CardIds) - length(CardIds -- ?pet_collect_cards),
    Lev = ?pet_collect_lev(Collected),
    AttrCur = lev_attr(Lev),
    AttrNext = lev_attr(Lev + 1),
    AttrMax = lev_attr(?pet_collect_max_lev),
    PetImg = card_to_img(PetId),
    {PetId, PetImg, Cards, AttrCur, AttrNext, AttrMax}.

%% 查询星宠综述信息
history() ->
    case file:read_file(?pet_collect_history_file) of
        {ok, Bin} ->
            try
                Logs = lists:reverse(lists:keysort(#pet_collect_log.time, tuple_to_list(binary_to_term(Bin)))),
                [{Rid, Srvid, Name, ItemId, ItemName} || #pet_collect_log{rid = Rid, srvid = Srvid, name = Name, item_id = ItemId, item_name = ItemName} <- Logs]
            catch
                _:_ -> []
            end;
        _ -> []
    end.

%% 重试次数不超过30次
history(Msg, ConnPid) ->
    history(Msg, ConnPid, 1).
history(_Msg, _ConnPid, Index) when Index > 30 ->
    ?INFO("星宠日志尝试是次数超过30次，日志记录失败 ~w", [_Msg]),
    ok;
history(Msg, ConnPid, Index) ->
    case file:open(?pet_collect_history_file, [read, write, binary]) of
        {ok, IoDev} ->
            NewLogs = case file:read_line(IoDev) of
                {ok, Bin} ->
                    Logs = try
                        tuple_to_list(binary_to_term(Bin))
                    catch
                        _:_ -> []
                    end,
                    lists:reverse(lists:keysort(#pet_collect_log.time, [Msg | Logs]));
                _ ->
                    [Msg]
            end,
            NewMsg = lists:sublist(NewLogs, ?pet_collect_history_num),
            sys_conn:pack_send(ConnPid, 12687, {[{Rid, Srvid, Name, ItemId, ItemName} || #pet_collect_log{rid = Rid, srvid = Srvid, name = Name, item_id = ItemId, item_name = ItemName} <- NewMsg]}),
            file:write_file(?pet_collect_history_file, term_to_binary(list_to_tuple(NewMsg))),
            file:close(IoDev);
        _ ->
            timer:sleep(1000),
            history(Msg, ConnPid, Index+1)
    end.

%% @spec collect(Role, CardId) -> {false, Reason} | {ok, NewRole}
%% Role = NewRole = #role{}
%% CardId = integer()
%% Reason = Msg = binary()
%% @doc 收集一張星寵
collect(Role, #item{base_id = BaseId, type = ?item_pet_rb}) ->
    collect(Role, BaseId);
collect(Role = #role{id = {Rid, Srvid}, name = RoleName, link = #link{conn_pid = ConnPid}, pet_cards_collect = Cards}, CardId) ->
    case lists:member(CardId, Cards) of %% 是否收集过
        true -> Role;
        false ->
            case lists:member(CardId, ?pet_collect_cards) of    %% 是否是收集范畴
                false -> Role;
                true ->
                    case pet_rb_data:card_rb_mapping(CardId) of
                        false -> Role;
                        PrbId ->
                            case pet_rb_data:get(PrbId) of
                                {ok, #pet_rb{name = CardName}} ->
                                    Role1 = Role#role{pet_cards_collect = [CardId | Cards]},
                                    Role2 = active(Role1),
                                    NewRole = pet_api:reset_all(Role2),
                                    Data = info(NewRole),
                                    sys_conn:pack_send(ConnPid, 12686, Data),
                                    History = #pet_collect_log{time = util:unixtime(), rid = Rid, srvid = Srvid, name = RoleName, item_id = CardId, item_name = CardName},
                                    spawn(?MODULE, history, [History, ConnPid]),
                                    NewRole;
                                _ ->
                                    Role
                            end
                    end
            end
    end;
collect(Role, _) ->
    Role.

%% @doc 检测是否触发激活宠物
active(Role = #role{pet_cards_collect = Cards}) ->
    Collected = length(Cards) - length(Cards -- ?pet_collect_cards),
    Lev = ?pet_collect_lev(Collected),
    active_reward(Role, Lev, 1).

active_reward(Role, Lev, Index) when Index > Lev ->
    Role;
active_reward(Role = #role{pet_cards_collect = Cards}, Lev, Index) ->
    case ?pet_collect_lev_to_reward(Index) of
        0 -> active_reward(Role, Lev, Index + 1);
        Reward ->
            case lists:member(Reward, Cards) of
                true ->
                    active_reward(Role, Lev, Index + 1);
                false ->
                    Sub = ?L(<<"收集星宠，神秘奖励">>),
                    Text = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持，经过您的不懈努力，集齐了十二只星宠，获得十二星宠之首——雅典娜。请注意查收！谢谢您的支持，祝您游戏愉快。">>),
                    MailInfo = {Sub, Text, [], [{Reward, 1, 1}]},
                    mail_mgr:deliver(Role, MailInfo),
                    active_reward(Role#role{pet_cards_collect = [Reward | Cards]}, Lev, Index + 1)
            end
    end.

%% 激活的真身卡奖励
actived(Cards) ->
    Collected = length(Cards) - length(Cards -- ?pet_collect_cards),
    Lev = ?pet_collect_lev(Collected),
    actived(Cards, Lev, []).

actived(_Cards, Lev, AcitvedCards) when Lev < 1 ->
    lists:usort(AcitvedCards);
actived(Cards, Lev, AcitvedCards) ->
    Reward = ?pet_collect_lev_to_reward(Lev),
    case lists:member(Reward, Cards) of
        false -> actived(Cards, Lev - 1, AcitvedCards);
        true -> actived(Cards, Lev - 1, [Reward | AcitvedCards])
    end.

%% 气血 230
%% 攻击 232
%% 防御 234
%% 253	宠物金抗性
%% 254	宠物木抗性
%% 255	宠物水抗性
%% 256	宠物火抗性
%% 257	宠物土抗性

lev_attr(1) -> [{230, 1000},{232, 300},{234, 300},{253, 100},{254, 100},{255, 100},{256, 100},{257, 100}];
lev_attr(2) -> [{230, 2000},{232, 600},{234, 600},{253, 200},{254, 200},{255, 200},{256, 200},{257, 200}];
lev_attr(3) -> [{230, 3000},{232, 900},{234, 900},{253, 300},{254, 300},{255, 300},{256, 300},{257, 300}];
lev_attr(4) -> [{230, 4000},{232, 1200},{234, 1200},{253, 400},{254, 400},{255, 400},{256, 400},{257, 400}];
lev_attr(5) -> [{230, 5000},{232, 1500},{234, 1500},{253, 500},{254, 500},{255, 500},{256, 500},{257, 500}];
lev_attr(6) -> [{230, 6000},{232, 1800},{234, 1800},{253, 600},{254, 600},{255, 600},{256, 600},{257, 600}];
lev_attr(_) -> [].


%% 对应形象
card_to_img(CardId) ->
    case pet_rb_data:card_rb_mapping(CardId) of
        false -> 0;
        PrbId ->
            case pet_rb_data:get(PrbId) of
                false -> 0;
                {ok, #pet_rb{image = Image}} -> Image
            end
    end.
