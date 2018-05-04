%% **********************
%% 挂机系统数据结构
%% @author  wpf (wprehard@qq.com)
%% **********************
-module(hook).
-export([
        init/0
        ,login_check/1
        ,vip_use/1
        ,check_hook_map/1
        ,combat_update/1 %% 战斗结束扣除挂机次数
        ,combat_before/1 %% 战斗前检查是否挂机中及次数
        ,refresh/1
        ,gm_set_num/2
        ,gm_set_state/2
        ,get_hook_status/1
        ,calc_all_point/1
    ]).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("pos.hrl").
-include("item.hrl").
-include("demon.hrl").
-include("pet.hrl").
-include("manor.hrl").
-include("channel.hrl").
-include("achievement.hrl").
-include("skill.hrl").
%% 挂机系统：本机制依赖客户端，不具备防外挂能力

%% 默认挂机次数
-define(DEFAULT_CNT, 200).
%% 是否挂机
-define(HOOK_NO, 0).
-define(HOOK_ING, 1).
%% 时间
-define(ONE_DAY_SEC, 86401).

%% @spec init() -> integer()
%% @doc 初始化挂机数据
init() ->
    {?HOOK_NO, ?DEFAULT_CNT, 0, 0}.

%% @spec get_hook_status(Auto) -> ?false | ?true
%% @doc 获取挂机状态
get_hook_status({IsHook, _, _, _}) when IsHook =:= ?false orelse IsHook =:= ?true -> IsHook;
get_hook_status(_) -> ?false.

%% @doc GM命令
%% 设挂机次数
gm_set_num(Role = #role{auto = {IsHook, _Cnt, _BuyCnt, Time}, link = #link{conn_pid = ConnPid}}, Num) ->
    sys_conn:pack_send(ConnPid, 13200, {IsHook, Num}),
    Role#role{auto = {IsHook, Num, 0, Time}}.
%% 设挂机状态 
gm_set_state(Role = #role{auto = {_IsHook, Cnt, BuyCnt, Time}, link = #link{conn_pid = ConnPid}}, State) when State=:=?HOOK_NO orelse State=:=?HOOK_ING ->
    sys_conn:pack_send(ConnPid, 13200, {State, Cnt+BuyCnt}),
    Role#role{auto = {State, Cnt, BuyCnt, Time}};
gm_set_state(Role, _) -> Role.

%% @spec login() -> integer()
%% @doc 登陆时检测并更新挂机次数
login_check(R = #role{auto = {_, Cnt, BuyCnt, Time}}) ->
    Today = util:unixtime({today, util:unixtime()}),
    NewRole = case Time < Today of
        true ->
            R#role{auto = {?HOOK_NO, get_hook_cnt(R), BuyCnt, Time}};
        false -> 
            R#role{auto = {?HOOK_NO, Cnt, BuyCnt, Time}}
    end,
    Dt = Today + ?ONE_DAY_SEC - util:unixtime(),
    role_timer:set_timer(hook, Dt * 1000, {hook, refresh, []}, day_check, NewRole);
login_check(R) ->
    R.

%% @spec check_hook_map(Role) -> ok | {false, Msg}
%% @doc 检查挂机地图
check_hook_map(#role{pos = #pos{map_base_id = 20001}}) -> {false, ?L(<<"水洞天内不能挂机">>)};
check_hook_map(#role{pos = #pos{map_base_id = 20100}}) -> {false, ?L(<<"镇妖塔内不能挂机">>)};
check_hook_map(#role{pos = #pos{map_base_id = 20101}}) -> {false, ?L(<<"镇妖塔内不能挂机">>)};
check_hook_map(#role{pos = #pos{map_base_id = 20102}}) -> {false, ?L(<<"镇妖塔内不能挂机">>)};
check_hook_map(#role{pos = #pos{map_base_id = 20103}}) -> {false, ?L(<<"镇妖塔内不能挂机">>)};
check_hook_map(#role{pos = #pos{map_base_id = 20104}}) -> {false, ?L(<<"镇妖塔内不能挂机">>)};
check_hook_map(#role{pos = #pos{map_base_id = 20105}}) -> {false, ?L(<<"镇妖塔内不能挂机">>)};
check_hook_map(#role{pos = #pos{map_base_id = 20106}}) -> {false, ?L(<<"镇妖塔内不能挂机">>)};
check_hook_map(#role{pos = #pos{map_base_id = 20107}}) -> {false, ?L(<<"镇妖塔内不能挂机">>)};
check_hook_map(#role{pos = #pos{map_base_id = 20108}}) -> {false, ?L(<<"镇妖塔内不能挂机">>)};
check_hook_map(#role{pos = #pos{map_base_id = 20109}}) -> {false, ?L(<<"镇妖塔内不能挂机">>)};
check_hook_map(#role{pos = #pos{map_base_id = 20110}}) -> {false, ?L(<<"镇妖塔内不能挂机">>)};
check_hook_map(#role{pos = #pos{map_base_id = 20111}}) -> {false, ?L(<<"镇妖塔内不能挂机">>)};
check_hook_map(_) -> ok.

%% @spec vip_use(Role) -> NewRole
%% @doc vip使用时调用
vip_use(R = #role{auto = {IsHook, Cnt, BuyCnt, Time}, link = #link{conn_pid = ConnPid}}) ->
    Num = Cnt + vip:effect(hook, R),
    sys_conn:pack_send(ConnPid, 13200, {IsHook, Num + BuyCnt}),
    R#role{auto = {IsHook, Num, BuyCnt, Time}};
vip_use(R) -> R.

%% @spec refresh(Role) -> {ok, NewRole} | {ok}
%% @doc 凌晨刷新挂机次数
refresh(Role = #role{auto = {IsHook, _, BuyCnt, Time}}) ->
    {ok, Role#role{auto = {IsHook, get_hook_cnt(Role), BuyCnt, Time}}};
refresh(_) -> {ok}.

%% @spec combat_update(Role) -> NewRole
%% @doc 战斗结束更新挂机次数
combat_update(R = #role{auto = {?HOOK_NO, _, _, _}}) ->
    R;
combat_update(R = #role{auto = {?HOOK_ING, 0, 0, Time}, link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 13200, {?HOOK_NO, 0}), %% 挂机次数用完主动取消挂机
    R#role{auto = {?HOOK_NO, 0, 0, Time}};
combat_update(R = #role{auto = {?HOOK_ING, 0, BuyCnt, Time}, link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 13200, {?HOOK_ING, BuyCnt - 1}),
    NewRole = role_listener:acc_event(R, {115, 1}), %% 帮会历练
    NewRole#role{auto = {?HOOK_ING, 0, BuyCnt - 1, Time}};
combat_update(R = #role{auto = {?HOOK_ING, Cnt, BuyCnt, Time}, link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 13200, {?HOOK_ING, BuyCnt + Cnt - 1}),
    NewRole = role_listener:acc_event(R, {115, 1}), %% 帮会历练
    NewRole#role{auto = {?HOOK_ING, Cnt - 1, BuyCnt, Time}};
combat_update(R) -> R.

%% @spec combat_before(Role) -> ok | {false, Msg}
%% @doc 战斗前检查挂机状态及次数
%% 2012/03/26 取消战斗前判断
%% combat_before(#role{auto = {?HOOK_NO, _, _, _}}) -> ok;
%% combat_before(#role{auto = {_, Cnt, BuyCnt, _}}) when Cnt > 0 orelse BuyCnt > 0 -> ok;
%% combat_before(_) -> {false, <<"您的挂机次数已用完">>}.
combat_before(_) -> ok.

%% -------------------------------
%% 战力天平
%% -------------------------------
%% 计算所有的评分
calc_all_point(_Role = #role{career = Career, lev = Lev, skill = #skill_all{skill_list = Skills}, 
    pet = #pet_bag{active = Pet}, eqm = Eqm, demon = #role_demon{active = ActiveDemon, 
    attr = DemonAttr}, medal = Medal, channels = #channels{list = Channels}, 
    manor_moyao=#manor_moyao{has_eat_yao = MoYao}}
    ) ->

    Points = [],
    Points1 = calc_skill_point(Points, 1, Skills),                       %% 人物技能
    Points2 = calc_pet_skill_point(Points1, 2, Pet),                     %% 伙伴技能
    Points3 = calc_pet_lev_point(Points2, 3, Pet),                       %% 伙伴等级
    Points4 = calc_demon_lev_point(Points3, 4, ActiveDemon),             %% 妖精等级
    % Points5 = calc_demon_skill_point(Points4, 5, ActiveDemon),           %% 妖精技能
    Points6 = calc_demon_grow_point(Points4, 6, Career, ActiveDemon),    %% 妖精成长
    Points7 = calc_demon_grahp_point(Points6, 7, Career, DemonAttr),     %% 妖精图鉴
    Points8 = calc_medal_point(Points7, 8, Career, Medal),               %% 神圣勋章
    Points9 = calc_channel_qh_point(Points8, 9, Channels),               %% 神觉强化
    Points10 = calc_eqm_point(Points9, 10, Eqm),                         %% 装备强化
    
    Points11 = calc_moyao_point(Points10, 11, Career, MoYao),            %% 魔药
    Points12 = calc_channel_jx_point(Points11, 12, Career, Channels),    %% 神觉觉醒
    Points13 = calc_eqm_make_point(Points12, 13, Career, Eqm),           %% 装备制作
    Points14 = calc_eqm_mount_point(Points13, 14, Career, Eqm),          %% 装备镶嵌
    Points15 = calc_eqm_refine_point(Points14, 15, Career, Eqm),         %% 装备精炼
    Points16 = calc_eqm_wash_point(Points15, 16, Career, Eqm),           %% 装备鉴定
    % Points17 = calc_looks_point(Points16, 17, Career, Dress),            %% 时装
    Points18 = calc_pet_potential_point(Points16, 18, Pet),              %% 宠物潜能
    % Points19 = calc_pet_eqm_point(Points18, 19, Pet),                    %% 宠物装备
    % Points20 = calc_compete_honor_point(Points19, 20, Career, Medal),    %% 竞技称号
    % Points21 = calc_compete_medal_point(Points20, 21, Career, Medal),    %% 竞技勋章

    Points22 = [{98, Lev}|Points18],                                     %% 人物等级
    Sum = lists:sum([Val||{_, Val} <- Points18]),
    [{99, Sum}|Points22].

%% -------------------------------
%% 内部函数
%% -------------------------------
%% 计算技能带来的战力
calc_skill_point(Points, 1, Skills) ->                                          %% 人物技能
    SkillAll = [Skill||Skill <- Skills, is_record(Skill, skill) =:= true],
    All = [skill_factor_data:get_factor(Id div 100, Lev)||#skill{id = Id, lev = Lev} <- SkillAll, Lev > 0],
    [{1, lists:sum(All)}|Points].

calc_pet_skill_point(Points1, 2, undefined) ->                                  %% 伙伴技能
    [{2, 0}|Points1];
calc_pet_skill_point(Points1, 2, _Pet = #pet{skill = Skills}) ->                %% 伙伴技能
    SkillFight = pet_api:do_calc_skill_fighting(Skills, 0),
    SkillFight1 = erlang:round(SkillFight * 0.4),
    [{2, SkillFight1}|Points1].

calc_pet_lev_point(Points2, 3, undefined) ->                                    %% 伙伴等级
    [{3, 0}|Points2];
calc_pet_lev_point(Points2, 3, _Pet = #pet{lev = Lev}) ->                       %% 伙伴等级
    Point = fight_data:get_pet_lev_weight() * Lev,
    [{3, Point}|Points2].

calc_demon_lev_point(Points3, 4, 0) ->                                          %% 妖精等级
    [{4, 0}|Points3];
calc_demon_lev_point(Points3, 4, _ActiveDemon = #demon2{lev = Lev}) ->          %% 妖精等级
    Point = fight_data:get_demon_lev_weight() * Lev,
    [{4, Point}|Points3].    

% calc_demon_skill_point(Points4, 5, 0) ->                                        %% 妖精技能
%     [{5, 0}|Points4];
% calc_demon_skill_point(Points4, 5, _ActiveDemon = #demon2{skills = Skills}) ->  %% 妖精技能
%     All = [skill_factor_data:get_factor(Id div 100, 1)||Id <- Skills, is_integer(Id) == true],
%     [{5, lists:sum(All)}|Points4].
calc_demon_grow_point(Points5, 6, _Career, 0) ->                                         %% 妖精献祭
    [{6, 0}|Points5];
calc_demon_grow_point(Points5, 6, Career, _ActiveDemon = #demon2{ext_attr = ExtAttr}) ->  %% 妖精献祭
    Point = erlang:round(calc_attr_value(ExtAttr, Career, 0)),
    [{6, Point}|Points5].        

calc_demon_grahp_point(Points6, 7, _Career, []) ->                              %% 妖精图鉴
    [{7, 0}|Points6];
calc_demon_grahp_point(Points6, 7, Career, DemonAttr) ->                        %% 妖精图鉴
    Point = erlang:round(calc_attr_value(DemonAttr, Career, 0)),
    [{7, Point}|Points6].

calc_medal_point(Points7, 8, Career, #medal{gain = Gain}) ->         %% 神圣勋章
    AllAttr = calc_medal_attr(Gain),
    Point = erlang:round(calc_attr_value(AllAttr, Career, 0)),
    [{8, Point}|Points7].

calc_channel_qh_point(Points8, 9, Channels) ->                                  %% 神觉强化                      
    All = [fight_data:get_channel_lev_weight(Id, Lev) * Lev || #role_channel{id = Id, state = Lev} <- Channels, Lev > 0],
    Point = lists:sum(All),
    [{9, Point}|Points8].

calc_eqm_point(Points9, 10, Eqm) ->                                             %% 装备强化
    All = [fight_data:get_eqm_lev_weight(eqm:eqm_type(Base_Id), Enchant)||#item{base_id = Base_Id, enchant = Enchant} <- Eqm,
            Enchant =/= -1],
    Point = erlang:round(lists:sum(All)),
    [{10, Point}|Points9].

calc_moyao_point(Points10, 11, Career, MoYao) ->                                %% 魔药
    YaoId = [{Id, Num}||#has_eat_yao{id = Id, num = Num} <- MoYao],
    Attr = manor:all_attr(YaoId, []),
    Attr2 = [{Label, Val}||{Label, _, Val} <- Attr],
    Point = erlang:round(calc_attr_value(Attr2, Career, 0)),
    [{11, Point}|Points10].

calc_channel_jx_point(Points11, 12, Career, Channels) ->                        %% 神觉觉醒
    Fun = fun(Id, Lev) ->
            case channel_data:get(Id, Lev) of
                error -> {0, 0};
                #channel{attr = {Type, Value}} ->
                    % Attr
                    % 属性*300/（200+（强化等级*10)*4/5）
                    {Type, Value * 300/(200 + Lev * 10 * 0.8)}
            end
    end,
    AttrList1 = [Fun(Id, Lev) || #role_channel{id = Id, lev = Lev} <- Channels, Lev > 0],

    AttrList2 = trans_atrrs(AttrList1),
    Point = erlang:round(calc_attr_value(AttrList2, Career, 0)),
    [{12, Point}|Points11].


calc_eqm_make_point(Points12, 13, _Career, []) ->                                %% 装备制作 计算当前等级最低品质
    [{13, 0}|Points12];
calc_eqm_make_point(Points12, 13, Career, Eqm) ->                                %% 装备制作 计算当前等级最低品质
    Point = calc_lowest_quality(Eqm, Career),
    [{13, Point}|Points12].

calc_lowest_quality(Eqm, Career) ->
    NEqm = get_lowest_quality(Eqm, []),
    AllAttr = [Attr||#item_base{attr = Attr} <- NEqm],
    AllAttr1 = lists:flatten(AllAttr),
    MakeAttr = [{Label, Val}||{Label, Flag, Val} <- AllAttr1, Flag =:= 100],
    Point = erlang:round(calc_attr_value(MakeAttr, Career, 0)),
    Point.

get_lowest_quality([], Return)->  Return;
get_lowest_quality([#item{base_id = BaseId}|T], Return)->
    NBaseId = BaseId - BaseId rem 10 + 1,
    case item_data:get(NBaseId) of
        {ok, Item} ->
            get_lowest_quality(T, [Item|Return]);
        _ ->
            get_lowest_quality(T, Return)
    end.

calc_eqm_mount_point(Points13, 14, Career, Eqm) ->                               %% 装备镶嵌
    AllAttr = [Attr||#item{attr = Attr} <- Eqm],
    AllAttr1 = lists:flatten(AllAttr),
    StoneIds = [Val||{_, Flag, Val} <- AllAttr1, Flag =:= 101, Val =/= 0],
    Point = erlang:round(calc_stone_value(StoneIds, Career, 0)),
    [{14, Point}|Points13].

    calc_stone_value([], _Career, Value) -> Value;
    calc_stone_value([BaseId|T], Career, Value) ->
        case item_data:get(BaseId) of 
            {ok, #item_base{attr = Attr}} ->
                Attr1 = [{Label, Val}||{Label, _, Val} <- Attr],
                Value1 = calc_attr_value(Attr1, Career, 0),
                calc_stone_value(T, Career, Value + Value1);
            _ ->
                calc_stone_value(T, Career, Value)
        end.

calc_eqm_refine_point(Points14, 15, _Career, []) ->                              %% 装备精炼 当前等级 - 当前等级最低品质
    [{15, 0}|Points14];
calc_eqm_refine_point(Points14, 15, Career, Eqm) ->                              %% 装备精炼 当前等级 - 当前等级最低品质
    NEqm = get_law_eqm(Eqm, []),
    AllAttr = [Attr||#item_base{attr = Attr} <- NEqm],
    AllAttr1 = lists:flatten(AllAttr),
    RefineAttr = [{Label, Val}||{Label, Flag, Val} <- AllAttr1, Flag =:= 100],
    Point1 = erlang:round(calc_attr_value(RefineAttr, Career, 0)),
    Point2 = calc_lowest_quality(Eqm, Career),
    [{15, Point1 - Point2}|Points14].

get_law_eqm([], Return) -> Return;
get_law_eqm([#item{base_id = BaseId}|T], Return) ->
    case item_data:get(BaseId) of 
        {ok, Item} ->
            get_law_eqm(T, [Item|Return]);
        _ ->
            get_law_eqm(T, Return)
    end.
    
calc_eqm_wash_point(Points15, 16, _Career, []) ->                                %% 装备鉴定
    [{16, 0}|Points15];
calc_eqm_wash_point(Points15, 16, Career, Eqm) ->                                %% 装备鉴定
    AllAttr = [Attr||#item{attr = Attr} <-Eqm],
    AllAttr1 = lists:flatten(AllAttr),
    WashAttr = [{Label, Val}||{Label, Flag, Val}<-AllAttr1, Flag >= 1000],
    Point = erlang:round(calc_attr_value(WashAttr, Career, 0)),
    [{16, Point}|Points15].

% calc_looks_point(Points16, 17, _Career, []) ->                                   %% 时装
%     [{17, 0}|Points16];
% calc_looks_point(Points16, 17, Career, Dress) ->                                 %% 时装
%     AttrAll = [Attr||{_, 1, #item{attr = Attr}} <- Dress],
%     AttrAll1 = lists:flatten(AttrAll),
%     FormatAttr = [{Label, Val}||{Label, _, Val} <- AttrAll1],
%     Point = erlang:round(calc_attr_value(FormatAttr, Career, 0)),
%     [{17, Point}|Points16].

calc_pet_potential_point(Points17, 18, undefined) ->                             %% 宠物潜能
    [{18, 0}|Points17];
calc_pet_potential_point(Points17, 18, Pet = #pet{}) ->                          %% 宠物潜能
    Point = pet_api:calc_potential_fight(Pet),
    [{18, Point}|Points17].

% calc_pet_eqm_point(Points18, 19, undefined) ->                                   %% 宠物装备
%     [{19, 0}|Points18];
% calc_pet_eqm_point(Points18, 19, _Pet = #pet{eqm = Eqm}) ->                      %% 宠物装备
%     F = fun(Item = #item{}, Return) ->
%             Fight = pet_api:calc_eqm_fight_capacity(Item),
%             Fight + Return
%         end,
%     All = lists:foldl(F, 0, Eqm),
%     [{19, All}|Points18].
                                                                                 %% 竞技称号        
% calc_compete_honor_point(Points19, 20, Career, #medal{compete = #medal_compete{wearid = Wearid}}) ->
%     case Wearid =:= 0 of
%         false ->
%             Attr = medal_compete_data:get_honor_puton_attr(Wearid),
%             Point = erlang:round(calc_attr_value(Attr, Career, 0)),
%             [{20, Point}|Points19];
%         true -> [{20, 0}|Points19]
%     end.
                                                                                 %% 竞技勋章
% calc_compete_medal_point(Points20, 21, Career, #medal{compete = #medal_compete{medals = Medals}}) ->
%         AllAttr = get_all_compete_medal_attr(Medals, []),
%         Point = erlang:round(calc_attr_value(AllAttr, Career, 0)),
%         [{21, Point}|Points20].

% get_all_compete_medal_attr([], Return) -> Return;
% get_all_compete_medal_attr([Medal_id|T], Return) ->
%     case medal_compete_data:get_medal(Medal_id) of
%         {ok, #compete_medal{attr = Attr}} ->
%             get_all_compete_medal_attr(T, Attr ++ Return);
%         _ -> get_all_compete_medal_attr(T, Return)
%     end.

%% 根据vip卡类型获取挂机次数
get_hook_cnt(R) ->
    ?DEFAULT_CNT + vip:effect(hook, R).

%%计算属性带来的战斗力
calc_attr_value([], _Career, Value) -> Value / 18;
calc_attr_value([{Label, Val}|T], Career, Value) -> 
    case lists:keyfind(Label, 1, attr_parm(Career)) of 
        {_, Parm} ->
            calc_attr_value(T, Career, Val * Parm + Value);
        _ ->
            calc_attr_value(T, Career, Value)
    end.

%% 根据属性计算战力 -- 人物
attr_parm(Career) ->
    case Career of
        2 ->
            [{?attr_aspd, 200}, {?attr_js, 3}, {?attr_dmg, 8.00}, {?attr_defence, 2}, {?attr_rst_all, 5.00}, {?attr_hp_max, 1}, {?attr_mp_max, 0.1}, 
            {?attr_hitrate, 25.00}, {?attr_evasion,25.00}, {?attr_critrate, 10.00}, {?attr_tenacity,10.00}, {?attr_dmg_magic, 8.00}, {?attr_dmg_max, 8.00}];
        3 ->
            [{?attr_aspd, 200}, {?attr_js, 10}, {?attr_dmg, 8.00}, {?attr_defence, 2}, {?attr_rst_all, 5.00}, {?attr_hp_max, 1}, {?attr_mp_max, 0.3}, 
            {?attr_hitrate, 27.00}, {?attr_evasion,27.00}, {?attr_critrate, 12.00}, {?attr_tenacity,12.00}, {?attr_dmg_magic, 8.00}, {?attr_dmg_max, 8.00}];
        5 ->
            [{?attr_aspd, 200}, {?attr_js, 3}, {?attr_dmg, 8.00}, {?attr_defence, 1.5}, {?attr_rst_all, 4.5}, {?attr_hp_max, 0.9}, {?attr_mp_max, 0.1}, 
            {?attr_hitrate, 23.00}, {?attr_evasion,25.00}, {?attr_critrate, 10.00}, {?attr_tenacity,10.00}, {?attr_dmg_magic, 8.00}, {?attr_dmg_max, 8.00}]
    end.


%% 转换 原子 label 对应的 数字  在 item.hrl 有定义
trans_atrrs(DigitalLabelsTuples) ->
    trans_atrrs(DigitalLabelsTuples, []).

trans_atrrs([], LT) ->
    LT;
trans_atrrs([H | T], LT) ->
    trans_atrrs(T, [trans_attr(H) | LT]).

trans_attr({js, Val}) -> {14, Val};
trans_attr({hp_max, Val}) -> {15, Val};
trans_attr({mp_max, Val}) -> {16, Val};
trans_attr({aspd, Val}) -> {17, Val};
trans_attr({dmg, Val}) -> {18, Val};
trans_attr({defence, Val}) -> {21, Val};
trans_attr({hitrate, Val}) -> {22, Val};
trans_attr({evasion, Val}) -> {23, Val};
trans_attr({critrate, Val}) -> {24, Val};
trans_attr({tenacity, Val}) -> {25, Val};
trans_attr({dmg_magic, Val}) -> {29, Val};
trans_attr({resist_all, Val}) -> {30, Val};
trans_attr({resist_metal, Val}) -> {31, Val};
trans_attr({resist_wood, Val}) -> {32, Val};
trans_attr({resist_water, Val}) -> {33, Val};
trans_attr({resist_fire, Val}) -> {34, Val};
trans_attr({resist_earth, Val}) -> {35, Val};
trans_attr({anti_stun, Val}) -> {60, Val};
trans_attr({anti_sleep, Val}) -> {61, Val};
trans_attr({anti_taunt, Val}) -> {62, Val};
trans_attr({anti_silent, Val}) -> {63, Val};
trans_attr({anti_stone, Val}) -> {64, Val};
trans_attr({anti_poison, Val}) -> {65, Val};
trans_attr({anti_seal, Val}) -> {66, Val};
trans_attr(DLT) -> DLT.

calc_medal_attr(Gain) ->
    Fun = fun(Medal_id) ->
        case medal_data:get_medal_special(Medal_id) of 
            {false, _} ->
                [];
            {ok, #medal_special{attr = Attr}} ->
                Attr
        end
    end,
    AllAttr = [Fun(Id)||Id <- Gain],
    trans_atrrs(lists:flatten(AllAttr)).


