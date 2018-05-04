%%----------------------------------------------------
%% %% 翅膀系统RPC 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(wing_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("wing.hrl").

%% 获取翅膀列表信息
handle(16700, {}, #role{wing = #wing{items = Items}}) ->
    {reply, {Items}};

%% 装备翅膀
handle(16701, {_WingId}, #role{event = Event}) when ?EventCantPutItem ->
    {reply, {0, ?L(<<"竞技比赛时，不能随便穿装备的啦">>)}};
handle(16701, {_WingId}, #role{ride = ?ride_fly}) ->
    {reply, {0, ?L(<<"飞行中不能更换翅膀">>)}};
handle(16701, {WingId}, Role) ->
    case wing:put_wing(Role, WingId) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> 
            NewRole = role_listener:eqm_event(NRole, update),            
            {reply, {1, <<>>}, NewRole}
    end;

%% 脱下翅膀
handle(16702, {}, #role{event = Event}) when ?EventCantPutItem ->
    {reply, {0, ?L(<<"唉哟，竞技比赛的时候就不要脱装备啦">>)}};
handle(16702, {}, #role{ride = ?ride_fly}) ->
    {reply, {0, ?L(<<"飞行中不能卸下翅膀">>)}};
handle(16702, {}, Role) ->
    case wing:takeoff_wing(Role) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> {reply, {1, <<>>}, NRole}
    end;

%% 获取当前拥有外观列表
handle(16703, {}, #role{wing = #wing{skin_id = SkinId, skin_grade = SkinGrade, skin_list = SkinList}}) ->
    {reply, {SkinId, SkinGrade, SkinList}};

%% 更换翅膀场境外观
handle(16704, {SkinId, Grade}, Role) ->
    case wing:change_skin(Role, SkinId, Grade) of
        {false, Reason} -> {reply, {0, SkinId, Grade, Reason}};
        {ok, NRole} -> {reply, {1, SkinId, Grade, <<>>}, NRole}
    end;

%% 翅膀进阶
handle(16705, {WingId}, Role) ->
    case wing:raise_step(Role, WingId) of 
        {false, gold} -> {reply, {?gold_less, ?L(<<"金币不足">>)}};
        {false, coin_all} -> {reply, {?coin_all_less, ?L(<<"所有金币不足">>)}};
        {false, Reason} -> {reply, {0, Reason}};
        {fail, Step, NewLuckVal, OldLuckVal, NRole} ->
            AddLuck = NewLuckVal - OldLuckVal,
            LogMsg = util:fbin(?L(<<"翅膀进阶[~p]，增加幸运值:~p [~p=>~p]">>), [Step, AddLuck, OldLuckVal, NewLuckVal]),
            log:log(log_coin, {<<"翅膀进阶">>, LogMsg, Role, NRole}),
            log:log(log_item_del_loss, {util:fbin(<<"翅膀进阶[~p]">>, [Step]), Role}),
            {reply, {1, util:fbin(?L(<<"翅膀增加~p点幸运值，幸运值越高，进阶成功率越高">>), [AddLuck])}, NRole};
        {suc, Step, NewLuckVal, OldLuckVal, NRole} ->
            LogMsg = util:fbin(?L(<<"翅膀进阶[~p]，幸运值爆满[~p=>~p]">>), [Step, OldLuckVal, NewLuckVal]),
            log:log(log_coin, {<<"翅膀进阶">>, LogMsg, Role, NRole}),
            log:log(log_item_del_loss, {util:fbin(<<"翅膀进阶[~p]">>, [Step]), Role}),
            {reply, {3, ?L(<<"恭喜你非常幸运得到了幸运暴击。幸运值瞬间爆满，你的翅膀可以进阶了！！">>)}, NRole};
        {ok, NRole} ->
            NRole1 = role_listener:acc_event(NRole, {128, 1}), %% 翅膀进阶一级            
            NewRole = role_listener:eqm_event(NRole1, update),            
            {reply, {2, ?L(<<"进阶成功，翅膀属性得到增强，并获得的新翅膀外形！">>)}, NewRole}
    end;

%% 获取技能背包
handle(16706, {}, #role{wing = #wing{skill_bag = SkillBag}}) ->
    {reply, {SkillBag}};

%% 获取刷新技能数据
handle(16707, {}, #role{wing = #wing{skill_coin = CoinLuckVal, skill_gold = GoldLuckVal, skill_tmp = SkillTmp}}) ->
    {reply, {CoinLuckVal, GoldLuckVal, SkillTmp}};

%% 技能刷新
handle(16708, {PriceType, BatchType}, Role) ->
    case wing_skill:refresh_skill(Role, PriceType, BatchType) of
        {false, gold} -> {reply, {?gold_less, ?L(<<"晶钻不足">>)}};
        {false, coin_all} -> {reply, {?coin_all_less, ?L(<<"金币不足">>)}};
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> 
            log:log(log_coin, {<<"刷新翅膀技能">>, util:fbin("刷新技能，是否批量:~p", [BatchType]), Role, NRole}),
            {reply, {1, <<>>}, NRole}
    end;

%% 技能收入技能背包
handle(16709, {Id}, Role) ->
    case wing_skill:move_to_bag(Role, Id) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> {reply, {1, <<>>}, NRole}
    end;

%% 技能装备到翅膀
handle(16710, {Id, WingId, Pos}, Role) ->
    case wing_skill:study(Role, Id, WingId, Pos) of
        {false, Reason} -> {reply, {0, Reason}};
        {new, NRole} -> 
            NewRole = role_listener:acc_event(NRole, {129, 1}),%%翅膀技能升级/学习            
            {reply, {1, ?L(<<"学习新技能成功">>)}, NewRole};
        {update, NRole} -> 
            NewRole = role_listener:acc_event(NRole, {129, 1}),%%翅膀技能升级/学习            
            {reply, {1, ?L(<<"技能升级成功">>)}, NewRole}
    end;

%% 删除背包技能
handle(16711, {Id}, Role) ->
    case wing_skill:del_skill(Role, Id) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> {reply, {1, <<>>}, NRole}
    end;

%% %% 遗忘翅膀技能
handle(16712, {WingId, Pos}, Role) ->
    case wing_skill:loss_skill(Role, WingId, Pos) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> {reply, {1, <<>>}, NRole}
    end;

%% 翅膀属性转移
handle(16713, {_WingId1, _wingId2}, #role{event = Event}) when ?EventCantPutItem ->
    {reply, {0, ?L(<<"活动比赛时，不能随便转移属性">>)}};
handle(16713, {WingId1, WingId2}, Role) ->
    case wing:move_attr(Role, WingId1, WingId2) of
        {false, coin_all} -> {reply, {?coin_all_less, <<>>}};
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> 
            log:log(log_coin, {<<"翅膀属性转移">>, <<"属性转换成功">>, Role, NRole}),
            {reply, {1, ?L(<<"属性转移成功">>)}, NRole}
    end;

handle(_Cmd, _Data, _Role) -> %% 容错处理
    {error, unknow_command}.
