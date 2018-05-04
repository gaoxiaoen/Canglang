%%----------------------------------------------------
%% 翅膀技能处理
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(wing_skill).
-export([
        refresh_skill/3
        ,get_combat_skill_list/1
        ,move_to_bag/2
        ,add_bag_skill/2
        ,del_skill/2
        ,loss_skill/3
        ,study/4
    ]
).

-compile(export_all).

-include("common.hrl").
-include("role.hrl").
-include("wing.hrl").
-include("item.hrl").
-include("gain.hrl").
-include("link.hrl").

%% 获取翅膀技能数据 [{SkillId, SkillId} ....]
get_combat_skill_list(#role{eqm = Eqm}) -> 
    get_combat_skill_list(Eqm, []);
get_combat_skill_list(Eqm) -> 
    get_combat_skill_list(Eqm, []).
get_combat_skill_list([], SkillList) -> SkillList;
get_combat_skill_list([#item{attr = Attr, type = ?item_wing} | T], SkillList) ->
    SkillIds = [{SkillId, SkillId} || {CodeName, _Flag, SkillId} <- Attr, CodeName =:= ?attr_skill],
    get_combat_skill_list(T, SkillList ++ SkillIds);
get_combat_skill_list([_ | T], SkillList) ->
    get_combat_skill_list(T, SkillList).

%% 刷新技能
refresh_skill(Role, PriceType, BatchType) ->
    case refresh_skill_price(PriceType, BatchType) of
        false -> {false, ?L(<<"技能刷新类型不正确">>)};
        {N, GL} ->
            case role_gain:do(GL, Role) of
                {false, #loss{label = Label}} -> {false, Label};
                {ok, NRole = #role{wing = Wing = #wing{skill_coin = CoinLuckVal, skill_gold = GoldLuckVal}}} ->
                    NewWing = case PriceType of
                        1 -> 
                            {NewLuckVal, SkillList} = rand_skill(N, PriceType, CoinLuckVal, []),
                            Wing#wing{skill_coin = NewLuckVal, skill_tmp = SkillList};
                        _ ->
                            {NewLuckVal, SkillList} = rand_skill(N, PriceType, GoldLuckVal, []),
                            Wing#wing{skill_gold = NewLuckVal, skill_tmp = SkillList}
                    end,
                    NewRole = NRole#role{wing = NewWing},
                    Inform = notice_inform:gain_loss(GL, ?L(<<"刷新技能">>)),
                    notice:inform(Role#role.pid, Inform),
                    wing:push_info(skill_tmp, NewRole),
                    {ok, NewRole}
            end
    end.

%% 收取技能到背包
move_to_bag(Role = #role{wing = #wing{skill_tmp = SkillTmp}}, Id)  ->
    case lists:keyfind(Id, #eqm_skill.id, SkillTmp) of
        false -> {false, ?L(<<"技能不存在">>)};
        Skill ->
           case add_bag_skill(Role, Skill) of
               {false, Reason} -> {false, Reason};
               {ok, NRole = #role{wing = Wing}} ->
                   NewWing = Wing#wing{skill_tmp = [], skill_coin = 0, skill_gold = 0},
                   NewRole = NRole#role{wing = NewWing},
                   wing:push_info(skill_tmp, NewRole),
                   {ok, NewRole}
           end
   end.

%% 增加一个技能到背包
add_bag_skill(#role{wing = #wing{skill_bag = SkillBag}}, _Skill) when length(SkillBag) >= 15 ->
    {false, ?L(<<"技能背包已满">>)};
add_bag_skill(Role, SkillId) when is_integer(SkillId) ->
    add_bag_skill(Role, #eqm_skill{skill_id = SkillId});
add_bag_skill(Role = #role{wing = Wing = #wing{skill_bag = SkillBag}}, Skill) ->
    NextId = get_skill_next_id(SkillBag, 0),
    NewSkillBag = [Skill#eqm_skill{id = NextId} | SkillBag],
    NewRole = Role#role{wing = Wing#wing{skill_bag = NewSkillBag}},
    wing:push_info(skill_bag, NewRole),
    {ok, NewRole}.

%% 删除背包技能
del_skill(Role = #role{wing = Wing = #wing{skill_bag = SkillBag}}, Id) ->
    case lists:keyfind(Id, #eqm_skill.id, SkillBag) of
        false -> {false, ?L(<<"技能不存在">>)};
        #eqm_skill{skill_id = SkillId} ->
            NewSkillBag = lists:keydelete(Id, #eqm_skill.id, SkillBag),
            NRole = Role#role{wing = Wing#wing{skill_bag = NewSkillBag}},
            wing:push_info(skill_bag, NRole),
            log:log(log_handle_all, {16711, <<"翅膀技能删除">>, util:fbin("[技能背包]技能:~p", [SkillId]), Role}),
            {ok, NRole}
    end.

%% 遗忘技能
loss_skill(Role = #role{wing = #wing{items = Items}}, WingId, Pos) ->
    case lists:keyfind(WingId, #item.id, Items) of
        false -> {false, ?L(<<"翅膀不存在">>)};
        WingItem = #item{attr = Attr} ->
            SkillAttr = [{CodeName, Flag, Val} || {CodeName, Flag, Val} <- Attr, CodeName =:= ?attr_skill],
            SkillPos = 900 + Pos,
            case lists:keyfind(SkillPos, 2, SkillAttr) of
                false -> {false, ?L(<<"技能不存在">>)};
                {_, _, SkillId} ->
                    NewSkillAttr = lists:keydelete(SkillPos, 2, SkillAttr),
                    NewWingItem = replace_skill_attr(WingItem, NewSkillAttr),
                    NRole = wing:fresh_wing(Role, NewWingItem),
                    {ok, #item_base{name = WingName}} = item_data:get(WingItem#item.base_id),
                    log:log(log_handle_all, {16712, <<"翅膀技能遗忘">>, util:fbin("[~s]技能:~p", [WingName, SkillId]), [WingItem, NewWingItem], Role}),
                    {ok, NRole}
            end
    end.

%% 翅膀技能学习
study(Role = #role{wing = Wing = #wing{items = Items, skill_bag = SkillBag}}, Id, WingId, Pos) ->
    ?DEBUG("~p,~p-->items:~w", [WingId, Pos, Items]),
    case lists:keyfind(Id, #eqm_skill.id, SkillBag) of
        false -> {false, ?L(<<"技能不存在">>)};
        Skill ->
            case lists:keyfind(WingId, #item.id, Items) of
                false -> {false, ?L(<<"找不到翅膀">>)};
                WingItem ->
                    SkillNum = get_skill_num(WingItem),
                    case do_study(Role, WingItem, Pos, Skill, SkillNum) of
                        {false, Reason} -> {false, Reason};
                        {ok, Flag, NewSkillStep, NewWingItem} ->
                            NewSkillBag = lists:keydelete(Id, #eqm_skill.id, SkillBag),
                            NRole = wing:fresh_wing(Role#role{wing = Wing#wing{skill_bag = NewSkillBag}}, NewWingItem),
                            wing:push_info(skill_bag, NRole),
                            campaign_listener:handle(wing_skill, Role, NewSkillStep), %% 后台活动
                            {Flag, NRole}
                    end
            end
    end.
do_study(_Role, _WingItem, Pos, _Skill, SkillNum) when Pos < 1 orelse Pos > SkillNum ->
    {false, ?L(<<"技能格子非法">>)};
do_study(Role, WingItem = #item{attr = Attr}, Pos, #eqm_skill{skill_id = NewSkillId}, _SkillNum) ->
    SkillAttr = [{CodeName, Flag, Val} || {CodeName, Flag, Val} <- Attr, CodeName =:= ?attr_skill],
    SkillPos = 900 + Pos,
    NewSkillStep = NewSkillId rem 100,
    {ok, #item_base{name = WingName}} = item_data:get(WingItem#item.base_id),
    case lists:keyfind(SkillPos, 2, SkillAttr) of
        false -> %% 空位置 学习新技能
            case [SkillId || {_, _, SkillId} <- SkillAttr, check_skill_same(SkillId, NewSkillId)] of
                [] when NewSkillStep > 1 ->
                    {false, ?L(<<"学习新技能需要从低级技能学起">>)};
                [] -> %% 同类型技能不存在 可学习
                    NewWingItem = replace_skill_attr(WingItem, [{?attr_skill, SkillPos, NewSkillId} | SkillAttr]),
                    log:log(log_handle_all, {16710, <<"翅膀技能学习">>, util:fbin("[~s]技能:~p", [WingName, NewSkillId]), [WingItem, NewWingItem], Role}),
                    {ok, new, NewSkillStep, NewWingItem};
                _ ->
                    {false, ?L(<<"同一类型技能只能学习一个">>)}
            end;
        {_, _, OldSkillId} -> %% 技能升级
            OldSkillStep = OldSkillId rem 100,
            case check_skill_same(OldSkillId, NewSkillId) of
                false -> %% 
                    {false, ?L(<<"技能类型不相同，不能覆盖">>)};
                _ when NewSkillStep =< OldSkillStep ->
                    {false, ?L(<<"只能更高一级技能覆盖相对低级技能">>)};
                _ when NewSkillStep =:= 5 andalso OldSkillStep =/= 4 ->
                    {false, ?L(<<"需要先学习至尊技能，才能学习神级技能">>)};
                _ when NewSkillStep =:= 4 andalso OldSkillStep =/= 3 ->
                    {false, ?L(<<"需要先学习高级技能，才能学习至尊技能">>)};
                _ when NewSkillStep =:= 3 andalso OldSkillStep =/= 2 ->
                    {false, ?L(<<"需要先学习中级技能，才能学习高级技能">>)};
                true ->
                    NewSkillAttr = lists:keydelete(SkillPos, 2, SkillAttr),
                    NewWingItem = replace_skill_attr(WingItem, [{?attr_skill, SkillPos, NewSkillId} | NewSkillAttr]),
                    log:log(log_handle_all, {16710, <<"翅膀技能升阶">>, util:fbin("[~s]技能:~p=>~p", [WingName, OldSkillId, NewSkillId]), [WingItem, NewWingItem], Role}),
                    {ok, update, NewSkillStep, NewWingItem}
            end
    end.

%%---------------------------------------------
%% 内部方法
%%---------------------------------------------

%% 更换物品技能属性
replace_skill_attr(Item = #item{attr = Attr}, SkillAttr) ->
    NewSkillAttr = reset_skill_pos(SkillAttr),
    NewAttr = [{Name, Flag, Value} || {Name, Flag, Value} <- Attr, Name =/= ?attr_skill], %% 过滤旧技能属性数据
    Item#item{attr = NewAttr ++ NewSkillAttr}.

%% 重新整理技能位置
reset_skill_pos(SkillAttr) ->
    NewSkillAttr = lists:keysort(2, SkillAttr),
    reset_skill_pos(1, NewSkillAttr, []).
reset_skill_pos(_N, [], SkillAttr) -> 
    lists:reverse(SkillAttr);
reset_skill_pos(N, [{Type, _Flag, SkillId} | T], SkillAttr) ->
    reset_skill_pos(N + 1, T, [{Type, 900 + N, SkillId} | SkillAttr]).

%% 校验两技能是否同种
check_skill_same(SkillId1, SkillId2) ->
    SkillType1 = SkillId1 div 100,
    SkillType2 = SkillId2 div 100,
    SkillType1 =:= SkillType2.

%% 获取一个物品开放的技能格子数量
get_skill_num(WingItem) when is_record(WingItem, item) ->
    Step = wing:get_wing_step(WingItem),
    get_skill_num(Step);
get_skill_num(Step) when Step >= 10 -> 5;
get_skill_num(Step) when Step >= 9 -> 4;
get_skill_num(Step) when Step >= 7 -> 3;
get_skill_num(Step) when Step >= 5 -> 2;
get_skill_num(Step) when Step >= 3 -> 1;
get_skill_num(_Step) -> 0.
        

%% 获取下一个技能ID
get_skill_next_id([], MaxId) -> MaxId + 1;
get_skill_next_id([#eqm_skill{id = Id} | T], MaxId) ->
    case Id > MaxId of
        true -> get_skill_next_id(T, Id);
        false -> get_skill_next_id(T, MaxId)
    end.

%% 获取刷新技能价格
refresh_skill_price(1, 0) -> {1, [#loss{label = coin_all, val = 20000}]};
refresh_skill_price(1, 1) -> {8, [#loss{label = coin_all, val = 100000}]};
refresh_skill_price(2, 0) -> {1, [#loss{label = gold, val = pay:price(?MODULE, refresh_skill, 0)}]};
refresh_skill_price(2, 1) -> {8, [#loss{label = gold, val = pay:price(?MODULE, refresh_skill, 1)}]};
refresh_skill_price(_PriceType, _BatchType) -> false.

%%--------------------------------------------
%% 随机生成一个技能
%%--------------------------------------------

rand_skill(0, _RefType, LuckVal, SkillList) -> {LuckVal, SkillList};
rand_skill(N, RefType, LuckVal, SkillList) -> 
    Skill = rand_skill(RefType, LuckVal),
    NewLuckVal = lists:min([1000, LuckVal + 4]),
    rand_skill(N - 1, RefType, NewLuckVal, [Skill#eqm_skill{id = N} | SkillList]).

rand_skill(RefType, LuckVal) ->
    StepRandList = wing_data:get_skill_luck(RefType, LuckVal),
    RandSum = lists:sum(StepRandList),
    RandVal = util:rand(1, RandSum),
    Step = find_rand_skill_step(RandVal, StepRandList, 1),
    rand_skill_step(Step).
find_rand_skill_step(_RandVal, [_Rand], Step) -> Step;
find_rand_skill_step(RandVal, [Rand | T], Step) ->
    case RandVal =< Rand of
        true -> Step;
        false -> find_rand_skill_step(RandVal - Rand, T, Step + 1)
    end.

%% 随机生成一个指定阶数新技能
rand_skill_step(Step) ->
    SkillList = wing_data:get_skill_list(),
    RandList = [Rand || {_SkillType, Rand} <- SkillList],
    RandSum = lists:sum(RandList),
    RandVal = util:rand(1, RandSum),
    {SkillType, _Rand} = find_rand_skill(RandVal, SkillList),
    #eqm_skill{skill_id = SkillType * 100 + Step}.
find_rand_skill(_RandVal, [SkillInfo]) -> SkillInfo;
find_rand_skill(RandVal, [{SkillType, Rand} | T]) ->
    case RandVal =< Rand of 
        true -> {SkillType, Rand};
        false -> find_rand_skill(RandVal - Rand, T)
    end.
