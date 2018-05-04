%% 种植鲜花活动
%% (飞仙使用，已废除 by qingxuan)
%% @author abu
%% --------------------------------------------------------------------
-module(campaign_rpc2).
-export([
        handle/3
        ,check_camp/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("campaign.hrl").
-include("npc_store.hrl").
-include("link.hrl").

%% 活动兑换物品
handle(15800, {Type}, Role = #role{career = Career, lev = Lev, sex = Sex}) when Lev >= 30 ->
    Now = util:unixtime(),
    case util:datetime_to_seconds({{2013, 4, 18}, {23, 59, 59}}) of
        false -> {reply, {?false, ?L(<<"该物品只能在活动期间兑换">>)}};
        Time ->
            case Now > Time of
                true -> {reply, {?false, ?L(<<"该物品只能在活动期间兑换">>)}};
                false -> 
                    case type_to_item(Type, Career, Sex) of
                        false -> {reply, {?false, ?L(<<"没有该类物品可以兑换">>)}};
                        {Gain, DelList} ->
                            role:send_buff_begin(),
                            case role_gain:do([#loss{label = items, val = DelList, msg = ?L(<<"您尚未集齐足够的材料，获取方式请查看活动面板">>)}], Role) of
                                {false, L} ->
                                    role:send_buff_clean(),
                                    {reply, {?false, L#loss.msg}};
                                {ok, NewRole} ->
                                    GainList = [#gain{label = item, val = [BaseId, Bind, Num], msg = ?L(<<"背包已满,增加物品失败">>)} || {BaseId, Bind, Num} <- Gain],
                                    case role_gain:do(GainList, NewRole) of
                                        {false, G} when is_record(G, loss) ->
                                            role:send_buff_clean(),
                                            {reply, {?false, G#loss.msg}};
                                        {false, _G} ->
                                            role:send_buff_clean(),
                                            {reply, {?false, <<"操作失败">>}};
                                        {ok, Nr} ->
                                            [notice:inform(util:fbin(?L(<<"兑换成功\n获得{item3, ~w, ~w, ~w}">>),[GBaseId, GBind, GNum])) || {GBaseId, GBind, GNum} <- Gain],
                                            [log:log(log_handle_all, {15800, <<"活动兑换">>, util:fbin(<<"兑换类型:~w[~w]">>,[Type, LBaseId]), Nr}) || {LBaseId, _, _} <- Gain],
                                            role:send_buff_flush(),
                                            {reply, {?true, ?L(<<"恭喜您，兑换成功">>)}, Nr}
                                    end
                            end
                    end
            end
    end;
handle(15800, _, _) ->
    {reply, {?false, ?L(<<"亲，你还太小不能兑换物品，等30级以后再来兑换吧！">>)}};

handle(15801, {}, _Role) ->
    Now = util:unixtime(),
    case sys_env:get(merge_time) of
        Time when is_integer(Time) ->
            EndTime = util:unixtime({today, Time}) + 86400 * 3,
            case Now >= EndTime of
                true -> {ok};
                false -> {reply, {EndTime - Now}}
            end;
        _ -> {ok}
    end;

handle(15802, {}, Role) ->
    campaign:prompt(Role, 0),
    {ok};

%% 获取当前活动列表
handle(15804, {}, #role{}) ->
    Now = util:unixtime(),
    {reply, {check_camp(Now)}}; 

%% 获取当前消耗情况 
handle(15806, {}, Role) ->
    {reply, {campaign_reward:get_loss_gold(Role)}}; 

%% 获取当前消耗奖励领取情况 
handle(15807, {}, Role) ->
    {reply, campaign_reward:get_reward_list(Role)}; 

%% 领取总消耗奖励
handle(15808, {Id}, Role) ->
    case campaign_reward:handle_loss(Role, Id) of
        {false, Reason} -> {reply, {Id, 0, Reason}};
        {ok, NRole} -> {reply, {Id, 1, <<>>}, NRole}
    end;

%% 获取活动任务列表
handle(15810, {}, Role) ->
    {reply, {campaign_task:task_list(Role)}};

%% 领取活动奖励
handle(15812, {Id}, Role) ->
    case campaign_task:reward(Role, Id) of
        {false, Reason} -> {reply, {Id, 0, Reason}};
        {ok, NRole} -> {reply, {Id, 1, <<>>}, NRole}
    end;

%% 获取特殊活动列表
handle(15813, {}, Role) ->
    {NewRole, SpecialList} = campaign_special:special_list(Role),
    Flag = campaign_special:check_special_list(SpecialList),
    Status = case lists:keyfind(1, #campaign_special.id, SpecialList) of
        #campaign_special{status = 1} -> 1;
        _ -> 0
    end,
    {reply, {Flag, Status}, NewRole};

%% 领取特殊活动奖励
handle(15814, {}, Role) ->
    {NewRole, _} = campaign_special:special_list(Role),
    case campaign_special:reward(NewRole) of
        {false, Reason} -> {reply, {?false, Reason}};
        {ok, Nr} -> {reply, {?true, ?L(<<"领取奖励成功">>)}, Nr}
    end;

%% 获取当前更新公告列表
handle(15820, {}, _Role) ->
    Now = util:unixtime(),
    {reply, {camp_update_notice:list_all(Now)}};

%% 获取当前后台活动
handle(15850, {}, _Role) ->
    Now = util:unixtime(),
    L = campaign_adm:list_all(Now),
    NewL = [CampTotal || CampTotal <- L, CampTotal#campaign_total.ico =/= <<"hide">>],
    ?DEBUG("获取总活动列表---------------------[~p][~s]", [length(NewL), _Role#role.name]),
    {reply, {NewL}};

%% 获取指定总活动下的分活动
handle(15851, {_TotalId}, Role) -> %% TotaolId暂去掉，改为同时有一个活动, by qingxuan, 2014/2/12
    L = campaign_adm:list_all(util:unixtime()),
    CamL = [CampTotal || CampTotal <- L, CampTotal#campaign_total.ico =/= <<"hide">>],
    ?DEBUG("获取总活动列表---------------------[~p]", [length(CamL)]),
    case CamL of
        [#campaign_total{id = TotalId}|_] ->
            case campaign_adm:lookup_open(Role, TotalId, rpc) of
                #campaign_total{name = Name, title = Title, ico = Ico, alert = Alert, gif = Gif, start_time = StartTime, end_time = EndTime, camp_list = CampList} ->
                    %% ?DEBUG("==============[~w]", [CampList]),
                    {reply, {TotalId, Name, Title, Ico, Alert, Gif, StartTime, EndTime, CampList}};
                _ ->
                    {reply, {TotalId, <<>>, <<>>, <<>>, <<>>, <<>>, 0, 0, []}}
            end;
        _ ->
            {reply, {0, <<>>, <<>>, <<>>, <<>>, <<>>, 0, 0, []}}
    end;

%% 后台活动奖励领取、兑换、购买
handle(15852, {TotalId, CampId, CondId, Card}, Role) ->
    ?DEBUG("================================>[~p, ~p, ~p, ~s]", [TotalId, CampId, CondId, Card]),
    role:send_buff_begin(),
    case campaign_adm_reward:exchange(Role, TotalId, CampId, CondId, Card) of
        {false, coin} ->
            role:send_buff_clean(),
            {reply, {?coin_less, ?L(<<"金币不足">>)}};
        {false, coin_bind} ->
            role:send_buff_clean(),
            {reply, {?coin_bind_less, ?L(<<"绑定金币不足">>)}};
        {false, gold} ->
            role:send_buff_clean(),
            {reply, {?gold_less, ?L(<<"晶钻不足">>)}};
        {false, gold_bind} ->
            role:send_buff_clean(),
            {reply, {?gold_bind_less, ?L(<<"绑定晶钻不足">>)}};
        {false, coin_all} ->
            role:send_buff_clean(),
            {reply, {?coin_all_less, ?L(<<"所有金币不足">>)}};
        {false, Reason} ->
            role:send_buff_clean(),
            {reply, {0, Reason}};
        {ok, NewRole} ->
            role:send_buff_flush(),
            {reply, {1, <<>>}, NewRole}
    end;

%% 获取后台活动任务
handle(15854, {}, Role) ->
    {reply, campaign_adm:get_camp_task(Role)};

%% 获取后台充值活动 日常充值图标显示
handle(15855, {}, Role) ->
    {reply, campaign_adm:get_camp_pay_ico(Role)};

%% 获取后台充值活动 消费图标显示
handle(15856, {}, Role) ->
    {reply, campaign_adm:get_camp_loss_ico(Role)};

%% 获取后台充值活动 活动充值图标显示
handle(15857, {}, Role) ->
    {reply, campaign_adm:get_camp_pay_ico2(Role)};

%% 获取后台新版福利活动 日常福利图标显示
handle(15858, {}, Role) ->
    {reply, campaign_adm:get_camp_pay_new_ico(Role)};

%% 与女巫兑换物品
handle(15815, {}, Role) ->
    case campaign_plant:witch_exchange(Role) of
        {ok, NewRole} ->
            {reply, {1, <<>>}, NewRole};
        {false, Reason} ->
            {reply, {0, Reason}}
    end;

%% 请求是否有可领取特权活动
handle(15816, {}, Role) ->
    case campaign_card:get_role_info(Role) of
        {true, Time, Type, ItemList} ->
            ?DEBUG("Type:~w",[Type]),
            {reply, {1, Time, Type, ItemList}};
        {not_ready, Time} ->
            ?DEBUG("Time:~w",[Time]),
            {reply, {2, Time, 0, []}}; 
        _Err ->
            ?DEBUG("_Err:~w",[_Err]),
            {ok}
    end;

%% 抽取至尊白金特权
handle(15817, {}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case campaign_card:random_card(Role) of
        {ok, NewRole} ->
            case campaign_card:get_role_info(NewRole) of
                {true, Time, Type, ItemList} ->
                    sys_conn:pack_send(ConnPid, 15816, {1, Time, Type, ItemList});
                _ -> skip
            end,
            {reply, {?true, <<"抽取至尊白金特权成功">>}, NewRole};
        {false, Reason} ->
            ?DEBUG("~s",[Reason]),
            {reply, {?false, Reason}}
    end;

%% 春节在线30分钟日期表
handle(15859, {}, Role) ->
    campaign_reward:push_spring_campaign(online_days, Role),
    {ok};

%% 领取春节每天在线30分钟奖励
handle(15860, {}, Role) ->
    Day = erlang:date(),
    case campaign_reward:spring_festive_reward(online_days, Role, Day) of
        {ok, NewRole} ->
            {reply, {?true, ?L(<<"领取成功">>)}, NewRole};
        {false, Msg} when is_bitstring(Msg) ->
            {reply, {?false, Msg}};
        _ ->
            {reply, {?false, ?L(<<"领取失败">>)}}
    end;

%% 领取春节在线30分钟天数总奖励
handle(15861, {}, Role) ->
    Day = erlang:date(),
    case campaign_reward:spring_festive_reward(all_online_days, Role, Day) of
        {ok, NewRole} ->
            {reply, {?true, ?L(<<"领取成功">>)}, NewRole};
        {false, Msg} when is_bitstring(Msg) ->
            {reply, {?false, Msg}};
        _ ->
            {reply, {?false, ?L(<<"领取失败">>)}}
    end;

%% 获取春节期间每日消费晶钻数
handle(15862, {}, Role) ->
    campaign_reward:push_spring_campaign(loss_gold, Role),
    {ok};

%% 周年庆Tshirt获奖者信息添加
handle(15863, Data = {_BaseId, RealName, Addr, _PostCode, Phone, _Picture, _Sex, _Sizes}, Role)
when byte_size(RealName) < 30 
andalso byte_size(Addr) < 120
andalso byte_size(Phone) < 60
->
    case campaign_tshirt:add(Role, Data) of
        {false, Msg} ->
            {reply, {?false, Msg}};
        {ok, NewRole} ->
            {reply, {?true, ?L(<<"保存成功">>)}, NewRole}
    end;
handle(15863, _Data, _Role) ->
    {reply, {?false, ?L(<<"你填写的信息非法">>)}};

%% 获取周年庆红包状态
handle(15864, {}, Role) ->
    campaign_daily_consume:push(15864, Role),
    {ok};

%% 领取周年庆红包
handle(15865, {Y, M, D}, Role) ->
    case campaign_daily_consume:reward(Role, {Y, M, D}) of
        {ok, NewRole} ->
            {reply, {?true, ?L(<<"领取成功">>)}, NewRole};
        {false, Reason} when is_bitstring(Reason) ->
            {reply, {?false, Reason}};
        _ ->
            {reply, {?false, ?L(<<"领取失败">>)}}
    end;

%% 散财树浇水
handle(15867, {ElemId}, Role) ->
    case campaign_tree:watering(Role, ElemId) of
        {ok, NewRole} ->
            {reply, {?true, ?L(<<"浇水成功，您获得了相应的惊喜礼包">>)}, NewRole};
        {false, Reason} when is_bitstring(Reason) ->
            {reply, {?false, Reason}};
        _ -> {reply, {?false, ?L(<<"浇水失败">>)}}
    end;

%% 点击散财树
handle(15868, {ElemId}, Role) ->
    case campaign_tree:get_tree_info(ElemId, Role) of
        {ok, TreeData} ->
            {reply, TreeData};
        {false, ETreeData} ->
            {reply, ETreeData};
        _Err ->
            ?ERR("获取散财树信息错误:~w", [_Err]),
            {ok}
    end;
%% 邀请全部在线好友
handle(15869, {0, _, ElemID}, _Role = #role{name = IName}) ->
    case campaign_tree:invite_all(ElemID, IName) of
        ok ->
            {reply, {?true, ?L(<<"已向您的好友发送邀请">>)}};
        {false, Reason} when is_bitstring(Reason) ->
            {reply, {?false, Reason}};
        _Err ->
            ?ERR("发送浇水邀请失败:~w", [_Err]),
            {ok}
    end;
%% 发送散财树浇水邀请
handle(15869, {IRid, ISrvId, ElemId}, _Role = #role{id = Rid, name = IName}) ->
    case Rid of
        {IRid, ISrvId} -> {reply, {?false, ?L(<<"不能邀请自己浇水">>)}};
        _ ->
            case campaign_tree:invite(IRid, ISrvId, ElemId, IName) of
                {ok} ->
                    {reply, {?true, ?L(<<"已发送浇水邀请">>)}};
                {false, Reason} when is_bitstring(Reason) ->
                    {reply, {?false, Reason}};
                _Err ->
                    ?ERR("发送浇水邀请失败:~w", [_Err]),
                    {ok}
            end
    end;

%% 请求至尊特权信息
handle(15872, {}, Role) ->
    {NewRole, StatusInfo} = campaign_repay_consume:get_info(Role),
    {reply, StatusInfo, NewRole};

%% 领取至尊特权奖励
handle(15873, {}, Role) ->
    case campaign_repay_consume:reward(Role) of
        {ok, NewRole} ->
            {reply, {?true, <<"领取奖励成功">>}, NewRole};
        {false, Reason} ->
            {reply, {?false, Reason}}
    end;

%% 获取套装活动界面信息
handle(15874, {}, _Role = #role{campaign = #campaign_role{suit = #campaign_suit{target_list = TargetList, fill_list = FillList}}}) ->
    {ok, SuitData} = campaign_suit:get_suit_info(TargetList, FillList),
    {reply, SuitData};

%% 领取礼包(套装活动)
handle(15875, {Step, Index}, Role) ->
    case campaign_suit:reward(Role, Step, Index) of
        {ok, NewRole} ->
            {reply, {?true, <<"成功领取奖励">>}, NewRole};
        {false, Reason} ->
            {reply, {?false, Reason}}
    end;

%% （淘宝10年活动）获取状态
handle(15876, {}, _Role = #role{id = {Rid, SrvId}}) ->
    Status = campaign_taobao:get_status(Rid, SrvId),
    {reply, {Status}};

%%（淘宝10年活动）领取奖励
handle(15877, {}, Role = #role{id = {Rid, SrvId}}) ->
    case campaign_taobao:reward(Rid, SrvId) of
        ok ->
            NewRole = case role_gain:do([#gain{label = gold_bind, val =  100}], Role) of
                {ok, NRole} -> NRole;
                _ -> Role
            end,
            {reply, {?true, <<>>}, NewRole};
        {false, Reason} ->
            {reply, {?false, Reason}}
    end;

%% 获取劳模排行榜信息
handle(15878, {}, Role) ->
    case campaign_model_worker:info(Role, panel) of
        idle -> {ok};
        Data  ->
            {reply, Data}
    end;

%% 报名参加劳模活动
handle(15879, {Team}, Role) ->
    case campaign_model_worker:sign_up(Role, Team) of
        {ok, NewRole} ->
            {reply, {?true, ?L(<<"成功参加劳模活动">>)}, NewRole};
        {false, Msg} when is_bitstring(Msg) ->
            {reply, {?false, Msg}};
        _R ->
            ?DEBUG("未知的返回 ~w", [_R]),
            {reply, {?false, ?L(<<"报名失败">>)}}
    end;

handle(_Cmd, _Data, _Role) ->
    ?ERR("campaign, 错误的协议请求, ~w, ~w", [_Cmd, _Data]),
    {error, unknow_command}.

%% ------------------------
%% 1    为开服活动
%% 2    为合服活动
%% 3    为各种活动的充值情况，
%% 4,5  为节日活动
%% 6    为劲爆活动
%% 11   为天官赐福图标
%% 12   为吉祥道场图标
%% 13   为奇宝转盘图标
%% 14   为秘境大富翁
%% 15   古诗大乱斗
camp_data() ->
    L1 = case util:platform(undefined) of
        "koramgame" -> 
            [
                %% {3,  {{2013, 4, 11}, {8, 0, 1}}, {{2013, 4, 18},{23, 59, 59}}} %% 充值活动
                {4,  {{2013, 4, 13}, {7, 0, 1}}, {{2013, 4, 18},{23, 59, 59}}} %% 总活动
                %% ,{12, {{2013, 4, 24}, {8, 0, 1}}, {{2013, 4, 27},{23, 59, 59}}}
                %%,{14, {{2013, 3, 7}, {0, 0, 1}}, {{2013, 3, 11},{23, 59, 59}}} %% 大富翁
                %%,{23, {{2013, 3, 29}, {8, 0, 1}}, {{2013, 4, 2},{23, 59, 59}}} %% 晶钻转盘
            ];
        _ ->
            case sys_env:get(srv_id) of
                "4399_mhfx_1" ->
                    [
                        %% {3,  {{2013, 4, 11}, {0, 0, 1}}, {{2013, 4, 18},{23, 59, 59}}} %% 总活动
                        {4,  {{2013, 4, 13}, {0, 0, 1}}, {{2013, 4, 18},{23, 59, 59}}} %% 充值活动
                        %% ,{12, {{2013, 4, 24}, {0, 0, 1}}, {{2013, 4, 27},{23, 59, 59}}}
                        %%,{14, {{2013, 3, 7}, {0, 0, 1}}, {{2013, 3, 11},{23, 59, 59}}} %% 大富翁
                        %%,{23, {{2013, 3, 29}, {0, 0, 1}}, {{2013, 4, 2},{23, 59, 59}}} %% 晶钻转盘
                    ];
                _ ->
                    %% change_time
                    [
                        %% {3,  {{2013, 4, 11}, {8, 0, 1}}, {{2013, 4, 18},{23, 59, 59}}} %% 总活动
                        {4,  {{2013, 4, 13}, {7, 0, 1}}, {{2013, 4, 18},{23, 59, 59}}} %% 充值活动
                        %% ,{12, {{2013, 4, 24}, {8, 0, 1}}, {{2013, 4, 27},{23, 59, 59}}}
                        %%,{14, {{2013, 3, 7}, {0, 0, 1}}, {{2013, 3, 11},{23, 59, 59}}} %% 大富翁
                        %%,{23, {{2013, 3, 29}, {8, 0, 1}}, {{2013, 4, 2},{23, 59, 59}}} %% 晶钻转盘
                    ]
            end
    end,
    {ST1, ET1} = campaign_adm:get_camp_time(casino3),
    {ST2, ET2} = campaign_adm:get_camp_time(casino4),
    {ST3, ET3} = campaign_adm:get_camp_time(lottery_camp),
    {ST5, ET5} = campaign_adm:get_camp_time(dungeon_poetry),
    {ST6, ET6} = campaign_adm:get_camp_time(lottery_gold),
    [{11, ST1, ET1}, {12, ST2, ET2}, {13, ST3, ET3}, {15, ST5, ET5}, {23, ST6, ET6} | L1].
%do_get_camp_data() ->
%    Now = util:unixtime(),
%    case sys_env:get(srv_open_time) of
%        T when is_integer(T) ->
%            case Now > util:unixtime({today, T}) + 86400 * 3 of
%                true ->
%                    [{4, {{2012, 7, 3},{8,0,0}}, {{2012, 7, 7},{23, 59, 59}}}];
%                false -> 
%                    [{4, {{2012, 7, 3},{8,0,0}}, {{2012, 7, 7},{23, 59, 59}}}]
%            end;
%        _ ->
%            [{4, {{2012, 7, 3},{8,0,0}}, {{2012, 7, 7},{23, 59, 59}}}]
%    end.

check_camp(Now) ->
    check_camp(Now, camp_data(), []).
check_camp(_, [], IdList) -> IdList;
check_camp(Now, [{Id, Begin, End} | T], IdList) ->
    BeginTime = case is_integer(Begin) of
        true -> Begin;
        false -> util:datetime_to_seconds(Begin)
    end,
    EndTime = case is_integer(End) of
        true -> End;
        false -> util:datetime_to_seconds(End)
    end,
    case Now < BeginTime of
        true ->
            check_camp(Now, T, [{Id, 1, BeginTime - Now} | IdList]);
        false ->
            case Now >= BeginTime andalso Now =< EndTime of
                true ->
                    check_camp(Now, T, [{Id, 2, EndTime - Now} | IdList]);
                false ->
                    check_camp(Now, T, IdList)
            end
    end.

%% 兑换
%% 1:火凤羽 2:五彩风车 3:寒冰之翼 4:灵戒 5:灵符 

%% 端午节兑换
%% 1:梦霓羽翼 2:武器时装 3:夏日时装 4:灵符 5:灵戒 

%% 奥运会兑换
%% 1:坐骑进阶*3 2:灵符 3:灵戒 4:挂饰 5:时装 6:羽翼

%% 奥运会
%% 1:寒冰之翼 2:时装 3:玲珑鼎 4:灵符 5:灵戒 6:护神丹 7:翅膀仙羽 8 灵羽换仙羽 9:中国加油 

%% 1：约会时装·女 2：约会时装·男 3：玲珑鼎 4：火凤羽 5：神器之魄 6：八门保护符 7：八门金丹 8：灵符碎片宝盒 9：灵戒碎片宝盒

%% 9月活动
%% 1：时装（追梦少年时装/小魔女时装） 2：五彩风车 3：火凤羽 4：神器之魄 5：护神丹 6：八门保护符 7：翅膀仙羽 8：灵符碎片宝盒 9：灵阶碎片宝盒

%% Type, Career, Sex
type_to_item(1, _, 1) -> {[{16084, 1, 1}], [{33248, 1, 10}]};
type_to_item(1, _, 0) -> {[{16085, 1, 1}], [{33248, 1, 10}]};
type_to_item(2, _, 0) -> {[{16052, 1, 1}], [{33248, 1, 10}]};
type_to_item(2, _, 1) -> {[{16053, 1, 1}], [{33248, 1, 10}]};
type_to_item(3, _, 0) -> {[{16079, 1, 1}], [{33248, 1, 10}]};
type_to_item(3, _, 1) -> {[{16078, 1, 1}], [{33248, 1, 10}]};
type_to_item(4, _, _) -> {[{25024, 1, 1}], [{33248, 1, 1}]};
type_to_item(5, _, _) -> {[{25025, 1, 1}], [{33248, 1, 1}]};
type_to_item(6, _, _) -> {[{32001, 1, 1}], [{33248, 1, 1}]};
type_to_item(7, _, _) -> {[{33109, 1, 2}], [{33248, 1, 1}]};

type_to_item(8, _, _) ->  {[{19024, 1, 1}], [{33249, 1, 120}]};
type_to_item(9, _, _) ->  {[{29247, 1, 1}], [{33249, 1, 120}]};
type_to_item(10, _, _) -> {[{29578, 1, 1}], [{33249, 1, 120}]};
type_to_item(11, _, _) -> {[{32235, 1, 1}], [{33249, 1, 100}]};
type_to_item(12, _, _) -> {[{21700, 1, 3}, {21701, 1, 5}], [{33249, 1, 25}]};
type_to_item(13, _, _) -> {[{29282, 1, 1}, {22243, 1, 2}], [{33249, 1, 20}]};
type_to_item(14, _, _) -> {[{32701, 1, 10}, {32703, 1, 1}], [{33249, 1, 18}]};
type_to_item(15, _, _) -> {[{23019, 1, 3}, {33085, 1, 5}], [{33249, 1, 18}]};
type_to_item(16, _, _) -> {[{21021, 1, 1}, {21029, 1, 1}, {30011, 1, 20}], [{33249, 1, 15}]};
type_to_item(17, _, _) -> {[{25022, 1, 1}, {25023, 1, 1}, {22203, 1, 1}, {30011, 1, 20}], [{33249, 1, 15}]};
type_to_item(18, _, _) -> {[{33127, 1, 8}, {33151, 1, 10}], [{33249, 1, 15}]};
type_to_item(19, _, _) -> {[{32203, 1, 8}], [{33249, 1, 15}]};
type_to_item(20, _, _) -> {[{32301, 1, 8}], [{33249, 1, 15}]};
type_to_item(21, _, _) -> {[{33120, 1, 15}], [{33249, 1, 15}]};
type_to_item(22, _, _) -> {[{33118, 1, 30}], [{33249, 1, 15}]};
type_to_item(23, _, _) -> {[{21720, 1, 1}, {27003, 1, 1}, {23001, 1, 1}], [{33249, 1, 5}]};
type_to_item(24, _, _) -> {[{21720, 1, 1}, {27003, 1, 1}], [{33249, 1, 2}]};
type_to_item(25, _, _) -> {[{24121, 1, 1}, {24123, 1, 1}], [{33249, 1, 1}]};
type_to_item(_, _, _) -> false.
