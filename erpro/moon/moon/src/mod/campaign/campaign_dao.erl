%%----------------------------------------------------
%% @doc 活动日志模块
%% 
%% @author shawn 
%% @end
%%----------------------------------------------------
-module(campaign_dao).

-export([
        insert/5
       ,has_record/3
       ,has_record/4
       ,calc_charge/4
       ,load_all/0
       ,add_camp_log/4
       ,has_camp_record/4
       ,reward_camp_num/4
       ,check_camp_card/3
       ,update_camp_card/3
       ,insert_role_reward/7
       ,get_role_reward/4
       ,mark_reward_fetched/4
       ,log_campaign_reward/6
    ]
).

-include("common.hrl").
-include("campaign.hrl").
-include("role.hrl").

%% 插入一条记录
insert(RoleId, SrvId, Name, Time, CampId) ->
    Sql = <<"insert into log_campaign (rid, srv_id, name, time, camp_id) values (~s, ~s, ~s, ~s, ~s)">>,
    case db:execute(Sql, [RoleId, SrvId, Name, Time, CampId]) of
        {ok, _Rows} -> ok;
        _X ->
            ?ERR("插入活动日志出错:~w, Rid:~w, SrvId:~s, CardNum:~s", [_X, RoleId, SrvId, CampId]),
            false
    end.

%% 判断角色是否参加过活动
%% 每天都可以参加一次
has_record(Rid, SrvId, CampId, Time) ->
    Sql = "select count(*) from log_campaign where rid = ~s and srv_id = ~s and camp_id = ~s and Time = ~s",
    Num = case db:get_one(Sql, [Rid, SrvId, CampId, Time]) of
        {ok, Count} -> Count;
        _Else -> 1 
    end,
    Num > 0.

%% 判断角色是否参加过活动
%% 活动期间 仅可以参加一次
has_record(Rid, SrvId, CampId) ->
    Sql = "select count(*) from log_campaign where rid = ~s and srv_id = ~s and camp_id = ~s",
    Num = case db:get_one(Sql, [Rid, SrvId, CampId]) of
        {ok, Count} -> Count;
        _Else -> 1 
    end,
    Num > 0.

calc_charge(Rid, SrvId, begin_time, BeginTime) ->
    Sql = <<"select sum(gold) from sys_charge where rid = ~s and srv_id = ~s and ts >= ~s">>,
    Num = case db:get_one(Sql, [Rid, SrvId, BeginTime]) of
        {ok, N} when is_integer(N)-> N;
        _ -> 0
    end,
    Num;

calc_charge(Rid, SrvId, end_time, EndTime) ->
    Sql = <<"select sum(gold) from sys_charge where rid = ~s and srv_id = ~s and ts <= ~s">>,
    Num = case db:get_one(Sql, [Rid, SrvId, EndTime]) of
        {ok, N} when is_integer(N)-> N;
        _ -> 0
    end,
    Num;

calc_charge(Rid, SrvId, Begin, EndTime) ->
    ?DEBUG("Rid:~w, SrvId:~s, Begin:~w, EndTime:~w",[Rid, SrvId, Begin, EndTime]),
    Sql = <<"select sum(gold) from sys_charge where rid = ~s and srv_id = ~s and ts >= ~s and ts <= ~s">>,
    Num = case db:get_one(Sql, [Rid, SrvId, Begin, EndTime]) of
        {ok, N} when is_integer(N) -> N;
        _ -> 0
    end,
    Num.

%%----------------------------------------------
%% 后台配置活动
%%----------------------------------------------

%% 加载所有总活动数据
load_all() -> 
    Sql = "select total_id, name, title, ico, alert, gif, start_time, end_time, open_day, merge_day, is_open from sys_campaign_total where status = 2 and (end_time = 0 or end_time > ~s)",
    Now = util:unixtime(),
    case db:get_all(Sql, [Now]) of
        {ok, Data} ->
            do_format(campaign_total, Data, []);
        _ -> 
            ?ERR("加载总活动数据失败"),
            []
    end.

%% 判断角色是否参加过活动
%% 每天都可以参加一次
has_camp_record(Rid, SrvId, CondId, Time) ->
    Sql = "select count(*) from log_campaign_adm where rid = ~s and srv_id = ~s and cond_id = ~s and ctime >= ~s",
    Num = case db:get_one(Sql, [Rid, SrvId, CondId, Time]) of
        {ok, Count} -> Count;
        _Else -> 1 
    end,
    Num > 0.

%% 获取指定活动奖励领取次数
reward_camp_num(Rid, SrvId, CondId, Time) ->
    Sql = "select count(*) from log_campaign_adm where rid = ~s and srv_id = ~s and cond_id = ~s and ctime >= ~s",
    case db:get_one(Sql, [Rid, SrvId, CondId, Time]) of
        {ok, Count} -> Count;
        _Else -> -1 
    end.

%% 增加日志
add_camp_log(TotalCamp, Camp, Cond, #role{id = {Rid, SrvId}, name = Name}) ->
    add_camp_log(TotalCamp, Camp, Cond, {Rid, SrvId, Name});
add_camp_log(_TotalCamp = #campaign_total{id = TotalId, name = TotalName}, #campaign_adm{id = CampId, title = CampTitle}, #campaign_cond{id = CondId, msg = CondMsg}, {Rid, SrvId, Name}) ->
    spawn(
        fun() ->
                Now = util:unixtime(),
                Sql = "insert into log_campaign_adm (rid, srv_id, name, total_id, total_name, camp_id, camp_title, cond_id, cond_msg, ctime) values(~s,~s,~s,~s,~s,~s,~s,~s,~s,~s)",
                db:execute(Sql, [Rid, SrvId, Name, TotalId, TotalName, CampId, CampTitle, CondId, CondMsg, Now])
        end 
    ).

%% 判断活动卡号存在情况
check_camp_card(_Role, #campaign_cond{id = CondId}, Card) ->
    Sql = "select count(*) num from sys_campaign_card where cond_id = ~s and card_num = ~s and role_id = 0 and enabled = 1",
    case db:get_one(Sql, [CondId, Card]) of
        {ok, Count} when Count > 0 -> true;
        _Else -> false
    end.

%% 更新活动卡号领取情况
update_camp_card(#role{id = {Rid, SrvId}}, #campaign_cond{id = CondId}, Card) ->
    spawn(
        fun() ->
                Now = util:unixtime(),
                Sql = "update sys_campaign_card set role_id = ~s, srv_id = ~s, use_time = ~s where cond_id = ~s and card_num = ~s",
                db:execute(Sql, [Rid, SrvId, Now, CondId, Card])
        end 
    ).

insert_role_reward(RoleId, SrvId, CampId, CondId, Gains, AddNum, Time) ->
    case db:execute("INSERT INTO `role_campaign_reward` (`role_id`, `srv_id`, `camp_id`, `cond_id`, `num`, `last_time`, `gains`) VALUES (~s, ~s, ~s, ~s, ~s, ~s, ~s) ON DUPLICATE KEY UPDATE `num`=`num`+~s, `last_time`=~s", [RoleId, SrvId, CampId, CondId, AddNum, Time, util:term_to_bitstring(Gains), AddNum, Time]) of
        {ok, Affected} when is_integer(Affected) andalso Affected > 0 ->
            true;
        _ ->
            false
    end.

%% -> error | undefined | #campaign_role_reward{}
get_role_reward(RoleId, SrvId, CampId, CondId) ->
    case db:get_row("SELECT `num`, `last_time`, `gains` FROM role_campaign_reward WHERE `role_id`=~s AND `srv_id`=~s AND `cond_id`=~s", [RoleId, SrvId, CondId]) of
        {ok, [Num, LastTime, GainsStr]} -> 
            Gains = case util:bitstring_to_term(GainsStr) of
                {ok, G} when is_list(G) -> G;
                _ -> []
            end, 
            #campaign_role_reward{
                key = {{RoleId, SrvId}, CondId}
                ,camp_id = CampId
                ,cond_id = CondId
                ,num = Num
                ,gains = Gains
                ,last_time = LastTime
            };
        {error, undefined} -> 
            undefined;
        _ ->
            error
    end.

%% 标记奖励为已领完 
%% ->any()
mark_reward_fetched(RoleId, SrvId, CampId, 0) ->
    db:execute("UPDATE role_campaign_reward SET num=0 WHERE `role_id`=~s AND `srv_id`=~s AND `camp_id`=~s", [RoleId, SrvId, CampId]);
mark_reward_fetched(RoleId, SrvId, _CampId, CondId) ->
    db:execute("UPDATE role_campaign_reward SET num=0 WHERE `role_id`=~s AND `srv_id`=~s AND `cond_id`=~s", [RoleId, SrvId, CondId]).


%%-------------------------------------------
%% 活动后台配置数据校验+转换
%%-------------------------------------------

do_format(_Mod, [], L) -> L;
do_format(Mod = campaign_total, [[Id, Name, _Title, Ico, Alert, Gif, StartTime, EndTime, OpenDay, MergeDay, IsOpen] | T], L) ->
    CanOpenTime1 = case sys_env:get(srv_open_time) of
        T1 when is_integer(T1) andalso OpenDay > 0 -> 
            util:unixtime({today, T1}) + OpenDay * 86400;
        _ -> 0
    end,
    CanOpenTime2 = case sys_env:get(merge_time) of
        T2 when is_integer(T2) andalso MergeDay > 0 -> 
            util:unixtime({today, T2}) + MergeDay * 86400;
        _ -> 0
    end,
    case CanOpenTime1 >= EndTime orelse CanOpenTime2 >= EndTime of
        true -> %% 受开服或全服时间限制
            ?INFO("总活动[~p]不符合开启条件:开(合)服时间限制 CanOpenTime:~p(~p) > EndTime:~p", [Id, CanOpenTime1, CanOpenTime2, EndTime]),
            do_format(Mod, T, L);
        false ->
            NewStartTime0 = case CanOpenTime1 > StartTime of %% 修正开始时间
                true -> CanOpenTime1;
                false -> StartTime
            end,
            NewStartTime = case CanOpenTime2 > NewStartTime0 of
                true -> CanOpenTime2;
                _ -> NewStartTime0
            end,
            case load_camp_child(Id) of
                [] -> 
                    ?INFO("总活动[~p]没有配置子活动", [Id]),
                    do_format(Mod, T, L);
                CampL -> 
                    ?INFO("加载总活动[~p] 子活动数量[~p]", [Id, length(CampL)]),
                    SortCampL0 = lists:keysort(#campaign_adm.id, CampL),
                    SortCampL = lists:keysort(#campaign_adm.sort_val, SortCampL0),
                    A = #campaign_total{
                        id = Id, name = Name, title = <<>>, ico = Ico, alert = Alert, gif = Gif
                        ,start_time = NewStartTime, end_time = EndTime
                        ,camp_list = SortCampL, is_open = IsOpen
                    },
                    do_format(Mod, T, [A | L])
            end
    end;
do_format(Mod = campaign_adm, [[Id, Title, Ico, Star, Alert, Publicity, Content, StartTime, EndTime, IsShowTime, Msg, SortVal] | T], L) ->
    case load_conds(Id) of
        Conds when is_list(Conds) ->
            SortConds0 = lists:keysort(#campaign_cond.id, Conds),
            SortConds = lists:keysort(#campaign_cond.sort_val, SortConds0),
            A = #campaign_adm{
                id = Id, title = Title, ico = Ico, star = Star, alert = Alert, publicity = Publicity
                ,content = Content, start_time = StartTime, end_time = EndTime, msg = Msg 
                ,conds = SortConds, is_show_time = IsShowTime, sort_val = SortVal
            },
            do_format(Mod, T, [A | L]);
        _ ->
            ?INFO("子活动[~p]读取配置条件出错", [Id]),
            do_format(Mod, T, L)
    end;
do_format(Mod = campaign_cond, [[Id, Type, SecType, Button, MinLev, MaxLev, SettlementType, RewardNum, Coin, CoinBind, Gold, GoldBind, Items, MailSubject, MailContent, ButtonContent, ButtonBind, IsButton, Msg, SortVal, Conds, Sex, Career, RewardMsg, HF, SkinType, SkinId, AttrMsg, SayMsg, FlashItems] | T], L) ->
    case util:bitstring_to_term(Items) of
        {ok, NewItems} when is_list(NewItems) ->
            case util:bitstring_to_term(Conds) of
                {ok, NewConds} when is_list(NewConds) ->
                    case check_cond(Button, SecType, NewConds) of
                        false ->
                            ?ERR("特殊规则条件配置非法[~p][~w]", [Id, Conds]),
                            do_format(Mod, T, L);
                        true ->
                            NewSecType = case Type of
                                ?camp_type_rank -> SecType - 1;
                                _ -> SecType
                            end,
                            NewIsButton = case Button of
                                ?camp_button_type_mail -> 0;
                                _ -> IsButton
                            end,
                            NewRewardMsg = case is_binary(RewardMsg) of
                                true -> RewardMsg;
                                false -> <<>>
                            end,
                            NewFlashItems = case util:bitstring_to_term(FlashItems) of
                                {ok, FlashItems1} when is_list(FlashItems1) -> FlashItems1;
                                _ -> []
                            end,
                            NItems = [{BaseId, Bind, Num} || {BaseId, Num, Bind} <- NewItems],
                            A = #campaign_cond{
                                id = Id, type = Type, sec_type = NewSecType, button = Button 
                                ,min_lev = MinLev, max_lev = MaxLev, settlement_type = SettlementType
                                ,reward_num = RewardNum, coin = Coin, coin_bind = CoinBind
                                ,gold = Gold, gold_bind = GoldBind, items = NItems, mail_subject = MailSubject, mail_content = MailContent
                                ,button_content = ButtonContent, button_bind = ButtonBind, is_button = NewIsButton, msg = Msg, conds = NewConds
                                ,sort_val = SortVal, sex = Sex, career = Career, reward_msg = NewRewardMsg
                                ,hf = HF, skin_type = SkinType, skin_id = SkinId, attr_msg = AttrMsg, say_msg = SayMsg
                                ,flash_items = NewFlashItems
                            },
                            do_format(Mod, T, [A | L])
                    end;
                _ ->
                    ?ERR("转换特殊规则条件失败:~p [~w]", [Id, Conds]),
                    do_format(Mod, T, L)
            end;
        _ ->
            ?ERR("转换规则奖励物品失败:~p [~w]", [Id, Items]),
            do_format(Mod, T, L)
    end.

%% 加载指定总活动的子活动
load_camp_child(TotalId) ->
    Now = util:unixtime(),
    Sql = "select camp_id, title, ico, star, alert, publicity, content, start_time, end_time, is_show_time, msg, sort_val from sys_campaign where (end_time > ~p or end_time = 0) and total_id = ~p",
    case db:get_all(Sql, [Now, TotalId]) of
        {ok, Data} -> 
            do_format(campaign_adm, Data, []);
        _ ->
            ?ERR("加载总活动[~p]的具体活动数据失败", [TotalId]),
            []
    end.

%% 加载指定活动规则条件
load_conds(CampId) ->
    Sql = "select cond_id, type, sec_type, button, min_lev, max_lev, settlement_type, reward_num, coin, coin_bind, gold, gold_bind, items, mail_subject, mail_content, button_content, button_bind, is_button, msg, sort_val, conds, sex, career, reward_msg, hf, skin_type, skin_id, attr_msg, say_msg, flash_items from sys_campaign_conds where camp_id = ~s",
    case db:get_all(Sql, [CampId]) of
        {ok, Data} ->
            do_format(campaign_cond, Data, []);
        _ ->
            ?ERR("加载活动[~p]的规则条件数据失败", [CampId]),
            []
    end.

log_campaign_reward(RoleId, SrvId, CampId, CondId, AnyData, Status) ->
    Time = util:unixtime(),
    Memo = 
        if is_integer(AnyData) ->
                integer_to_list(AnyData);
            true ->
                util:term_to_bitstring(AnyData) 
        end,
    db:execute("INSERT INTO `log_campaign_reward` (`role_id`, `srv_id`, `camp_id`, `cond_id`, `time`, `memo`, `status`) VALUES (~s, ~s, ~s, ~s, ~s, ~s, ~s)", [RoleId, SrvId, CampId, CondId, Time, Memo, Status]).

%%------------------------------------
%% 防止后台配置失误 对特殊条件作判断 
%%------------------------------------

check_cond(_Button, ?camp_type_play_card, []) -> true;
check_cond(?camp_button_type_exchange, _SecType, []) -> false;                             %% 非激活卡兑换应该附带条件
check_cond(?camp_button_type_buy, _SecType, []) -> false;                                  %% 购买应该附带条件
%% check_cond(?camp_button_type_mail, _SecType, []) -> false;                              %% 信件自动发放应该附带条件
check_cond(_Button, _SecType, [{pay_acc, Min, _} | _]) when Min < 1 -> false;              %% 累计冲值
check_cond(_Button, _SecType, [{casino_acc, Min, _} | _]) when Min < 1 -> false;           %% 仙境寻宝总消耗
check_cond(_Button, _SecType, [{casino_acc_each, Min} | _]) when Min < 1 -> false;         %% 仙境寻宝每消耗
check_cond(_Button, _SecType, [{npc_store_sm_acc, Min, _} | _]) when Min < 1 -> false;     %% 神秘商店总消耗
check_cond(_Button, _SecType, [{npc_store_sm_acc_each, Min} | _]) when Min < 1 -> false;   %% 神秘商店每消耗
check_cond(_Button, _SecType, [{casino_sm_acc, Min, _} | _]) when Min < 1 -> false;        %% 仙境寻宝、神秘商店总消耗
check_cond(_Button, _SecType, [{casino_sm_acc_each, Min} | _]) when Min < 1 -> false;      %% 仙境寻宝、神秘商店每消耗
check_cond(_Button, _SecType, [{shop_acc, Min, _} | _]) when Min < 1 -> false;             %% 商城总消耗
check_cond(_Button, _SecType, [{shop_acc_each, Min} | _]) when Min < 1 -> false;           %% 商城每消耗
check_cond(_Button, _SecType, [{pay_gold_each, Min} | _]) when Min < 1 -> false;           %% 单笔冲值每X晶钻
check_cond(_Button, _SecType, [{pay_acc_each, Min} | _]) when Min < 1 -> false;            %% 单笔冲值每X晶钻
check_cond(_Button, _SecType, _) -> true.
