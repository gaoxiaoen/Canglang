%%----------------------------------------------------
%% 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(vip).
-export([
        init/2
        ,lev_up/1
        ,gm/2
        ,login/1 
        ,combat_over/1
        ,kill_boss_combat_over/1
        ,get_info/1 %% 获取VIP信息
        ,set_face/2 %% 更新VIP头像
        ,set_face_push/2 %% 更新VIP头像
        ,update/2 %%更新VIP类型
        ,reward/2 %% 领取指定类型奖励
        ,get_bless/1 %%领取VIP祝福
        ,check_update/1 %%检测VIP更新
        ,check/1 %%判断角色是否是VIP(包括体验卡用户)
        ,check2/1 %% 判断角色是否VIP(不包括体验卡用户)
        ,get_face_id/2 %%获取vip头像
        ,get_face_id/1 %%获取vip头像
        ,calc_ratio/1
        ,effect/2
        ,use/2
        ,buy/2
        ,push_assets/1
        ,reward_flower/1
        ,check_reward/2
        ,change_sex/1
        ,add_face/3
        ,listener/2
        ,buy_energy/1
        ,arena_buy/1
        ,arena_loss/1 
        ,expedition_buy/1
        ,enchant_ratio/1
        ,dungeon_reset/1
        ,dungeon_exp/1
        ,npc_store/1
        ,turn_over/1
        ,send_risk_gift/1
        ,get_role_vip_info/1
        ,channel_up/1
        ,push_charge_flag/1     %% 推送首次充值标志
        ,set_discount_mail/2 %% 增加一封折扣信
        ,check_npcmail_expire/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("vip.hrl").
%%
-include("gain.hrl").
-include("link.hrl").
-include("looks.hrl").
-include("ratio.hrl").
-include("pos.hrl").
-include("team.hrl").
-include("combat.hrl").
-include("task.hrl").
-include("shop.hrl").
-include("mail.hrl").

-define(VIP_LEV, 10).

%% @doc VIP初始化
%% @spec init(Career, Sex) -> #vip{}
%% Career = integer()
%% Sex = integer()
init(Career, Sex) ->
    #vip{
        type = ?vip_no
        ,portrait_id = get_face_id(Career, Sex)
    }.

%% 角色等级变化 TODO 此方法已关闭 不使用
lev_up(Role = #role{lev = close, vip = #vip{type = ?vip_no}}) ->
    push_info({open_win, 0}, Role);
lev_up(_Role) -> ok.

%% VIP GM命令
gm({set_vip_lev, NLev}, Role = #role{link = #link{conn_pid = ConnPid}, vip = Vip = #vip{type = Lev, effect = Effect}}) ->
    case NLev > Lev of
        false ->
            Role;
        true -> %%更新特权
            Eff = get_all_eff(NLev, Lev),
            NEffect = merge(Eff, Effect),
            NRole = Role#role{vip = Vip#vip{type = NLev, effect = NEffect}},
            sys_conn:pack_send(ConnPid, 10006, {[{?asset_vip, NLev}]}),
            energy:fire(NRole),
            NRole
    end;
gm(clear, Role = #role{career = Career, sex = Sex}) ->
    NewR = Role#role{vip = init(Career, Sex)},
    % NRole = push_info(all_update, NewR),
    push_vip_info(NewR),
    {ok, NewR};
gm(time, {Time, Role = #role{vip = Vip}}) ->
    NewR = Role#role{vip = Vip#vip{expire = util:unixtime() + Time}},
    NRole = push_info(all_update, NewR),
    {ok, add_vip_timer(NRole)}.

%%获取角色vip信息
get_role_vip_info(#role{vip = #vip{all_gold = All, type = Lev, reward_times = Reward_times}}) ->
    Rewarded = [ID || {ID, _} <- Reward_times, is_number(ID) == true],
    {Had_gain, Expire} = 
        case lists:keyfind(risk_gift, 1, Reward_times) of 
            false -> 
                {0, 0};
            {_, ContractId, _, ExpTime} ->
                Now = util:unixtime(),
                LeftTime = util:day_diff(Now, ExpTime),
                case ExpTime > Now andalso LeftTime =/= 0 of 
                    true -> {ContractId, LeftTime};
                    false -> {0, 0}
                end
        end,
    Reply = {Lev, All, Rewarded, Had_gain, Expire},
    Reply.

%%vip等级监听
listener(Gold, Role = #role{link = #link{conn_pid = _ConnPid}, vip = Vip = #vip{type = Lev, all_gold = All_gold, effect = Effect, charge_cnt = Cnt}}) ->
    NAll = Gold + All_gold,
    NLev = get_lev(NAll),
    Cnt1 = Cnt + 1,

    Role1 =
    case NLev > Lev of
        false ->
            Role#role{vip = Vip#vip{all_gold = NAll, charge_cnt = Cnt1}};
        true -> %%更新特权

            update_npc_store_freetimes(NLev, Effect, Role), %% 更新npc神秘商店免费刷新的次数

            Eff = get_all_eff(NLev, Lev),

            send_clear_item_when_change(Role, Eff),

            NEffect = merge(Eff, Effect),
            NRole1 = Role#role{vip = Vip#vip{all_gold = NAll, type = NLev, effect = NEffect, charge_cnt = Cnt1}},
            energy:fire(NRole1),
            map:role_update(NRole1),
            NRole1
    end,
    push_charge_flag(Role1),
    push_vip_info(Role1),
    signon:push_sign_info(Role1),
    charage_gift(Role1).    %% 赠送充值礼包

push_vip_info(Role = #role{link = #link{conn_pid = ConnPid}}) ->
    Reply = get_role_vip_info(Role),
    sys_conn:pack_send(ConnPid, 12411, Reply).

update_npc_store_freetimes(NLev, Effect, Role = #role{id = {Rid, _}}) ->
    AddTimes = get_add_times(npc_store, NLev, Effect),
    {Last_Time, Free_Times, Last_Items} = npc_store_sm:get_role_last_items(Role),
    npc_store_sm:update_role_last_items(Rid, Last_Time, Free_Times + AddTimes, Last_Items).

get_add_times(Lable, NLev, Effect) ->
    case vip_data2:get_vip_base(NLev) of 
        {ok, #vip_base{effect = Eff}} ->
            case lists:keyfind(Lable, 1, Eff) of 
                {_, Val} when Val =/= 0 ->
                    case lists:keyfind(Lable, 1, Effect) of 
                        {_, OldVal} ->
                            case Val =< OldVal of
                                true -> 0;
                                false -> Val - OldVal
                            end;
                        _ -> Val
                    end;
                _ -> 0
            end;
        _ -> 0
    end.

%%检查是否具有每日额外购买体力的特权
% buy_energy(Role) -> {Value :: number}
%返回0表示没有，其他表示次数
buy_energy(#role{vip = #vip{effect = Effect}}) ->
    case lists:keyfind(buy_energy, 1, Effect) of 
        {_, Value} -> Value;
        false -> 0
    end.

%%检查是否具有获得副本额外经验的特权
% dungeon_exp(Role) -> Value | 0, Value :: number()
%返回0表示没有，其他表示百分值
dungeon_exp(#role{vip = #vip{effect = Effect}}) ->
    case lists:keyfind(dungeon_exp, 1, Effect) of 
        {_, Value} -> Value;
        false -> 0
    end.

%%检查是否具有每日副本重置次数的特权
% dungeon_reset(Role) -> Value | 0, Value :: number()
%返回0表示没有，其他表示次数
dungeon_reset(#role{vip = #vip{effect = Effect}}) ->
    case lists:keyfind(dungeon_reset, 1, Effect) of 
        {_, Value} -> Value;
        false -> 0
    end.
    % check_reward2(dungeon_reset, Role).

%%检查是否具有每次单人困难副本增加一次额外的翻牌机会的特权
% turn_over(Role) -> Value | 0, Value:有 0:没有
turn_over(#role{vip = #vip{effect = Effect}}) ->
    case lists:keyfind(turn_over, 1, Effect) of 
        {_, Value} -> Value;
        false -> 0
    end.

%%检查是否具有每日增加竞技场挑战购买次数的特权
% arena_buy(Role) -> Value | 0, Value :: number()
%返回0表示没有，其他表示次数
arena_buy(#role{vip = #vip{effect = Effect}}) ->
    case lists:keyfind(arena_buy, 1, Effect) of 
        {_, Value} -> Value;
        false -> 0
    end.

%%检查是否具有每日增加远征王军挑战购买次数的特权
% expedition_buy(Role) -> Value | 0, Value :: number()
%返回0表示没有，其他表示次数
expedition_buy(#role{vip = #vip{effect = Effect}}) ->
    case lists:keyfind(expedition_buy, 1, Effect) of 
        {_, Value} -> Value;
        false -> 0
    end.

% %%检查是否具有竞技场失败免冷却时间的特权
% % arena_loss(Role) -> 1 | 0, 1:有 0:没有
% arena_loss(#role{vip = #vip{effect = Effect}}) ->
%     case lists:keyfind(arena_loss, 1, Effect) of 
%         {_, _Value} -> ?true;
%         false -> ?false
%     end.

%%检查是否具有强化额外成功率的特权
% enchant_ratio(Role) -> 1 | 0, 1:有 0:没有
enchant_ratio(#role{vip = #vip{effect = Effect}}) ->
    case lists:keyfind(enchant_ratio, 1, Effect) of 
        {_, Value} -> Value;
        false -> 0
    end.

%%检查是否具有增加神秘商店免费刷新上限的特权
% npc_store(Role) -> Value | 0, Value:有 0:没有
npc_store(#role{vip = #vip{effect = Effect}}) ->
    case lists:keyfind(npc_store, 1, Effect) of 
        {_, Value} -> Value;
        false -> 0
    end.

%%检查是否具有免去神觉强化CD时间
% vip:channel_up(Role) -> true | false, true:有 false:没有
channel_up(#role{vip = #vip{effect = Effect}}) ->
    case lists:keyfind(channle_up, 1, Effect) of 
        {_, _Value} -> 
            ?DEBUG("--channel_up---~n~n"),
            true;
        false -> false
    end.

%%检查是否具有免去神觉强化CD时间
% arena_loss(Role) -> true | false, true:有 false:没有
arena_loss(#role{vip = #vip{effect = Effect}}) ->
    case lists:keyfind(arena_loss, 1, Effect) of 
        {_, _Value} -> true;
        false -> false
    end.

%% 战斗结束回调 如果是杀VIP挂机地图BOSS 异步更新角色数据
combat_over(#combat{type = ?combat_type_npc, winner = Winner, loser = Loser}) ->
    case [F || F <- Loser, F#fighter.type =:= ?fighter_type_npc, lists:member(F#fighter.rid, ?vip_boss_list)] of
        [] -> ok; %% 杀死的NPC中不存在VIP挂机地图BOSS
        _ ->
            [role:apply(async, Pid, {fun kill_boss_combat_over/1, []}) 
                || #fighter{type = Type, pid = Pid} <- Winner, Type =:= ?fighter_type_role],
            ok
    end;
combat_over(_Combat) ->
    ok.

%% 杀死VIP挂机BOSS回调 更新角色数据
kill_boss_combat_over(Role = #role{vip = Vip = #vip{reward_times = Ts}}) ->
    Now = util:unixtime(),
    Type = ?vip_reward_in_map,
    NewTs = case lists:keyfind(Type, 1, Ts) of
        false -> [{Type, Now} | Ts]; %% 不存在数据
        {Type, _T} -> lists:keyreplace(Type, 1, Ts, {Type, Now})
    end,
    {ok, Role#role{vip = Vip#vip{reward_times = NewTs}}}.

%% @doc登录VIP处理
%% @spec login(Role) -> NewRole
%% Role = NewRole = #role{}
login(Role = #role{special = Special, login_info = #login_info{last_logout = 
    LastLogout}, vip = Vip = #vip{type = Lev, reward_times = Reward_times}}) ->

%%    MailList1 = check_npcmail_expire(MailList),
%%  sys_conn:pack_send(ConnPid, 13811, {MailList1}), %% 同步所有神秘来信到客户端
    Now = util:unixtime(),
    NRole1 = 
        case util:is_same_day2(LastLogout, Now) of 
            false ->
                send_clear_item(Role),
                check_and_send(Role, Now);
            true -> Role
        end,
    ?DEBUG("---Reward_times---~p~n~n", [Reward_times]),
    N = lists:sum([1||{GiftLev, Time}<-Reward_times, is_integer(GiftLev), is_integer(Time)]),
    NRole2 = NRole1#role{special = [{?special_vip_gift, to_positive(Lev - N), <<>>}] ++ Special},
    role_timer:set_timer(send_risk_gift, util:unixtime({nexttime, 86407}) * 1000, {vip, send_risk_gift, []}, 1, NRole2#role{vip = Vip#vip{}}).
    % role_timer:set_timer(send_risk_gift2, 30*1000, {vip, send_risk_gift, []}, 1, NRole1).

to_positive(Num) when is_integer(Num) andalso Num >= 0 -> Num;
to_positive(_) -> 0.

check_npcmail_expire([]) -> [];
check_npcmail_expire(MailList = [A | _T]) when is_tuple(A) ->
    lists:foldl(fun({Id, Time}, Acc) -> case util:unixtime() - Time >= 24 * 3600 * 3 of true -> Acc; false -> [{Id, Time}|Acc] end end, [], MailList);
check_npcmail_expire(_) -> [].

send_risk_gift(Role = #role{vip = #vip{reward_times = Reward_times}}) ->
    send_clear_item(Role),
    case Reward_times of 
        [] -> {ok, Role};
        _ ->
            Now = util:unixtime(),
            NRole = check_and_send(Role, Now),
            Time0 = util:unixtime(today),
            _Tomorrow0 = (Time0 + 86407) - util:unixtime(),
            {ok, role_timer:set_timer(send_risk_gift2, _Tomorrow0 * 1000, {vip, send_risk_gift, []}, day_check, NRole)}
            % {ok, role_timer:set_timer(send_risk_gift2, 10*1000, {vip, send_risk_gift, []}, 1, NRole)}     
    end.     

check_and_send(Role = #role{id = {Rid, Srvid}, vip = Vip = #vip{reward_times = Reward_times}}, Now) ->  
    Deleted = [R||R = {LABEL, _, _RewardId, Expire} <- Reward_times, LABEL == risk_gift, util:day_diff(Now, Expire) =:= 0],

    NReward_times = Reward_times -- Deleted,
    Risk_gifts = [RewardId ||{LABEL1,  _, RewardId, Expire} <- NReward_times, LABEL1 == risk_gift, util:day_diff(Now, Expire) >= 1],

    [award:send({Rid, Srvid}, Reward) || Reward <- Risk_gifts],
    Role#role{vip = Vip#vip{reward_times = NReward_times}}.

send_clear_item(#role{id = {Rid, Srvid}, vip = #vip{effect = Effect}}) ->
    AwardId = 
        case lists:keyfind(clear_item, 1, Effect) of 
            {_, Id} -> Id;
            false -> 0
        end,
    case AwardId =/= 0 of
        true ->
            award:send({Rid, Srvid}, AwardId);
        false -> ignore
    end.


send_clear_item_when_change(#role{id = RoleId}, Eff) ->
    IDs = [ID||{Label, ID} <- Eff, clear_item == Label, ID =/= 0],
    [award:send(RoleId, Reward)||Reward<-IDs].

%% VIP卡购买使用
buy(?vip_try, #role{vip = #vip{is_try = Try}}) when Try =/= 0 -> %% 使用VIP体验卡
    {false, ?L(<<"已体验过VIP,不能再使用">>)};
buy(?vip_try, #role{vip = #vip{type = Type}}) when Type =/= ?vip_no ->
    {false, ?L(<<"当前已是VIP">>)};
buy(Type = ?vip_try, Role = #role{vip = Vip}) ->
    case vip_data:get(Type) of
        {false, Reason} -> {false, Reason};
        {ok, #vip_base{time = Time}} ->
            NTime = util:unixtime(),
            NR = Role#role{vip = Vip#vip{type = Type, expire = NTime + Time, is_try = 1, buff_time = 0, special_time = 0}},
            NewRole = hook:vip_use(NR),%% 更新挂机次数
            NewR = auto_reward(NewRole),
            NRole = push_info(all_update, NewR),
            NRole1 = activity:update_act_limit(NRole),
            RoleMsg = notice:role_to_msg(NR),
            notice:send(53, util:fbin(?L(<<"至尊地位，无上荣光。~s使用了{str, VIP体验卡, #3ad6f0}，被授予钻石VIP.{open, 3, 成为VIP, #00ff00}">>), [RoleMsg])),
            guild_mem:update(vip, NRole1), %% 帮会成员VIP监听
            NRole2 = role_api:push_attr(NRole1),
            {ok, add_vip_timer(NRole2)}
    end;
buy(Type, Role) ->
    case base_id(Type) of
        false -> {false, ?L(<<"类型不正确">>)};
        {Price, BaseId} ->
            case role_gain:do(#loss{label = gold, val = Price, msg = ?L(<<"晶钻不足">>)}, Role) of
                {false, #loss{msg = Msg}} -> {gold, Msg};
                {ok, NR} ->
                    case update(NR, Type) of
                        {ok, NRole} -> 
                            {ok, role_api:push_assets(Role, NRole)};
                        {false, _Reason} ->
                            case role_gain:do([#gain{label = item, val = [BaseId, 0, 1]}], NR) of
                                {false, #gain{msg = <<>>}} ->
                                    {false, ?L(<<"物品不存在">>)};
                                {false, #gain{msg = Msg}} ->
                                    {false, Msg};
                                {ok, NewRole} ->
                                    {false, ?L(<<"使用VIP卡失败，物品已发送到背包">>), NewRole}
                            end
                    end
            end
    end.

%% @doc生成VIP 更换VIP
%% @spec update(Role) -> {ok, NewRole} | {false, Reason}
%% Role = NewRole = #role{}
update(_Role = #role{vip = #vip{type = Type}}, BaseId) when Type =/= ?vip_try andalso Type > BaseId ->
    {false, ?L(<<"低级VIP卡不能覆盖高级VIP卡">>)};
update(Role = #role{vip = Vip = #vip{is_try = Try}}, BaseId) ->
    case vip_data:get(BaseId) of
        {false, Reason} -> {false, Reason};
        {ok, #vip_base{time = Time, name = VName, title = Title}} ->
            NTime = util:unixtime(),
            NewTry = case Try =:= 3 of
                true -> 3;  %% 半年卡领取第一次送花
                false -> 2  %% 其它情况 
            end,
            NR = Role#role{vip = Vip#vip{
                    type = BaseId, expire = NTime + Time, 
                    is_try = NewTry, buff_time = 0, special_time = 0, reward_times = []} 
            }, 
            task:refresh_acceptable_task(ref_and_send, NR, ?task_type_rc),
            RoleMsg = notice:role_to_msg(NR),
            Color = case BaseId of
                ?vip_week -> <<"#00ff00">>;
                ?vip_month -> <<"#3ad6f0">>;
                ?vip_half_year -> <<"#ca57ff">>
            end,
            notice:send(53, util:fbin(?L(<<"至尊地位，无上荣光。~s使用了{str, ~s, ~s}，被授予~s.{open, 3, 成为VIP, #00ff00}">>), [RoleMsg, VName, Color, Title])),
            NewRole = hook:vip_use(NR),%% 更新挂机次数
            NewR = auto_reward(NewRole),
            NRole = push_info(all_update, NewR),
            NRole1 = activity:update_act_limit(NRole),
            guild_mem:update(vip, NRole1), %% 帮会成员VIP监听
            NRole2 = role_api:push_attr(NRole1),
            NRole3 = reward_flower(NRole2),
            {ok, add_vip_timer(NRole3)}
    end.

%% 奖励花
reward_flower(Role = #role{vip = Vip = #vip{type = ?vip_half_year, is_try = 2}, link = #link{conn_pid = _ConnPid}}) -> %% 第一次生成半年VIP卡
    NR = case role_gain:do([#gain{label = item, val = [33004, 1, 1]}], Role) of
        {ok, NRole} -> 
            NRole;
        _ ->
            mail:send_system(Role, {?L(<<"背包已满">>), ?L(<<"您的背包已满，物品转以邮件发送.请查收！">>), [], {33004, 1, 1}}),
            Role
    end,
    NR#role{vip = Vip#vip{is_try = 3}};
reward_flower(Role = #role{vip = #vip{type = ?vip_half_year, is_try = 3}}) -> %% 再次使用半年卡返还188晶钻 
    Gold = 188,
    Subject = ?L(<<"vip半年卡再次消费返还">>),
    Content = ?L(<<"恭喜！您再次成为vip半年卡会员，同时获得系统免费赠送的188非绑定晶钻返还，谢谢您对飞仙的支持，祝您游戏快乐！">>),
    MailGold = [{?mail_gold, Gold}],
    mail_mgr:deliver(Role, {Subject, Content, MailGold, []}),
    Role;
reward_flower(Role) ->
    Role.

%% 获取角色VIP信息情况
%% 角色第一次打开VIP面板时作用
get_info(_Role = #role{vip = Vip = #vip{type = ?vip_no}}) ->
    info_to_client(Vip);
get_info(Role = #role{career = Career, sex = Sex, vip = Vip = #vip{type = OldType}}) ->
    case check(Role) of 
        false -> %% VIP已过期
            NewVip = Vip#vip{type = ?vip_no, portrait_id = get_face_id(Career, Sex)},
            NRole = activity:update_act_limit(Role#role{vip = NewVip}),
            guild_mem:update(vip, NRole), %% 帮会成员VIP监听
            case OldType =:= ?vip_try of
                true -> push_info({open_win, 1}, NRole);
                false -> push_info({open_win, 2}, NRole)
            end,
            {ok, NRole, info_to_client(NewVip)};
        true ->
            info_to_client(Vip)
    end.

%% @doc 更新VIP头像
%% @spec set_face(Role) -> {false, Reason} | {ok, NewRole}
%% Role | NewRole = #role{}
set_face(Role = #role{vip = Vip}, FaceId) ->
    case check_face_id(FaceId, Role) of
        {false, Reason} -> {false, Reason};
        false -> {false, ?L(<<"非法头像">>)};
        true ->
            NRole = Role#role{vip = Vip#vip{portrait_id = FaceId}},
            guild_mem:update(icon, NRole),
            {ok, NRole}
    end.
%% @doc 更新VIP头像
set_face_push(Role = #role{vip = Vip, link = #link{conn_pid = ConnPid}}, FaceId) ->
    case check_face_id(FaceId, Role) of
        {false, Reason} -> {false, Reason};
        false -> {false, ?L(<<"非法头像">>)};
        true ->
            NRole = Role#role{vip = Vip#vip{portrait_id = FaceId}},
            guild_mem:update(icon, NRole),
            sys_conn:pack_send(ConnPid, 12402, {FaceId, 1, ?L(<<"设置头像成功">>)}),
            {ok, NRole}
    end.

%% 增加头像
add_face(Role = #role{sex = Sex, vip = Vip = #vip{face_list = FaceList}}, Faces, Msg) ->
    [_FaceId | _] = Newfaces = [FaceId1 || {NeedSex, FaceId1} <- Faces, (NeedSex =:= -1 orelse NeedSex =:= Sex)],
    AddFaces = [FaceId2 || FaceId2 <- Newfaces, lists:member(FaceId2, FaceList) =:= false],
    NewRole = Role#role{vip = Vip#vip{face_list = FaceList ++ AddFaces}},
    role:pack_send(Role#role.pid, 10931, {57, Msg, []}),
    push_info(face_list, NewRole),
    {ok, NewRole}.

%% 领取奖励 每天每种类型奖励只能领取一次
reward(?vip_reward_out_map, #role{pos = #pos{map = MapId}}) when MapId < 35001 orelse MapId > 35005 ->
    {false, ?L(<<"当前不在VIP挂机地图">>)};
reward(?vip_reward_out_map, Role = #role{pos = #pos{last = {LastMapId, X, Y}}}) ->
    {MapId, X1, Y1} = case LastMapId > 35000 andalso LastMapId =< 35005 of
        true -> {10003, 5940, 2970}; %% 上一次地图位置也在VIP地图 置为洛水城
        false -> {LastMapId, X, Y}
    end,
    case map:role_enter(MapId, X1, Y1, Role) of
        {ok, NewRole} -> {map, NewRole};
        {false, Why} -> {false, Why}
    end;
reward(_Type, #role{vip = #vip{type = ?vip_no}}) ->
    {false, ?L(<<"当前不是VIP">>)};
reward(_Type, #role{vip = #vip{type = ?vip_try}}) ->
    {false, ?L(<<"体验卡用户不能进入VIP挂机地图">>)};
reward(?vip_reward_in_map, #role{pos = #pos{map = MapId}}) when MapId > 35000 andalso MapId =< 35005 ->
    {false, <<>>};
reward(?vip_reward_in_map, #role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {false, ?L(<<"组队状态不能进入VIP挂机地图">>)};
reward(?vip_reward_in_map, Role = #role{lev = Lev, pos= #pos{map = LastMapId, x = X, y = Y}}) ->
    case in_map_check(Role) of
        {false, Reason} -> {false, Reason};
        true ->
            GetMap = if
                Lev < 40 -> {false, ?L(<<"需要40级以上才能进入VIP挂机地图">>)};
                Lev < 50 -> 35001;
                Lev < 60 -> 35002;
                Lev < 70 -> 35003;
                Lev < 80 -> 35004;
                true -> 35005
            end,
            case GetMap of
                {false, Reason} -> {false, Reason};
                MapId ->
                    case map:role_enter(MapId, 900, 2010, Role) of
                        {ok, NewRole = #role{pos = Pos}} -> 
                            {map, NewRole#role{pos = Pos#pos{last = {LastMapId, X, Y}}}};
                        {false, Why} -> {false, Why}
                    end
            end
    end;
reward(Type, Role = #role{vip = Vip}) ->
    case check_status(Role) of
        {ok, NR} -> %% VIP已过期
            {false, ?L(<<"VIP已过期">>), NR};
        ok ->
            case get_reward(Role, Type) of
                {false, Reason} -> {false, Reason};
                {ok, G} ->
                    case check_reward(Type, Role) of
                        {false, Reason} -> {false, Reason};
                        {ok, NTs} ->
                            case role_gain:do(G, Role) of
                                {false, _} -> 
                                    {false, ?L(<<"领取奖励失败">>)};
                                {ok, NRole = #role{vip = Vip}} ->
                                    Msg = notice_inform:gain_loss(G, ?L(<<"领取VIP奖励">>)),
                                    notice:inform(NRole#role.pid, Msg),
                                    NewRole = push_info(update, NRole#role{vip = Vip#vip{reward_times = NTs}}),
                                    case Type =:= ?vip_reward_gold_bind of
                                        false -> ok;
                                        true -> 
                                            RoleMsg = notice:role_to_msg(NewRole),
                                            case Vip of
                                                #vip{type = ?vip_week} ->
                                                    notice:send(52, util:fbin(?L(<<"~s领取了{open, 3, 黄金VIP, #00ff00}每日福利：2个绑定晶钻！">>), [RoleMsg]));
                                                #vip{type = ?vip_month} ->
                                                    notice:send(52, util:fbin(?L(<<"~s领取了{open, 3, 钻石VIP, #3ad6f0}每日福利：5个绑定晶钻！">>), [RoleMsg]));
                                                #vip{type = ?vip_half_year} ->
                                                    notice:send(52, util:fbin(?L(<<"~s领取了{open, 3, 至尊VIP, #ca57ff}每日福利：10个绑定晶钻！">>), [RoleMsg]));
                                                _ ->
                                                    ok
                                            end
                                    end,
                                    {ok, NewRole}
                            end
                    end
            end
    end.

%% 进入地图状态判断
in_map_check(#role{event = ?event_dungeon}) ->
    {false, ?L(<<"普通副本中, 不可进入VIP挂机地图">>)};
in_map_check(#role{event = ?event_arena_match}) ->
    {false, ?L(<<"参加竞技比赛中, 不可进入VIP挂机地图">>)};
in_map_check(#role{event = ?event_arena_prepare}) ->
    {false, ?L(<<"竞技准备中, 不可进入VIP挂机地图">>)};
in_map_check(#role{event = ?event_escort}) ->
    {false, ?L(<<"护送美女中, 不可进入VIP挂机地图">>)};
in_map_check(#role{event = ?event_guild}) ->
    {false, ?L(<<"帮会领地中 , 不可进入VIP挂机地图">>)};
in_map_check(#role{event = ?event_guild_war}) ->
    {false, ?L(<<"帮战中, 不可进入VIP挂机地图">>)};
in_map_check(#role{cross_srv_id = <<"center">>}) ->
    {false, ?L(<<"跨服场境中,不支持传送">>)};
in_map_check(#role{event = ?event_no}) ->
    true;
in_map_check(_) ->
    {false, ?L(<<"当前活动状态,不可进入VIP挂机地图">>)}.

%% 检查奖励是否已领取
check_reward(Type, #role{vip = #vip{reward_times = Ts}}) ->
    Now = util:unixtime(),
    case lists:keyfind(Type, 1, Ts) of
        false -> %% 未领取过
            {ok, [{Type, Now} | Ts]};
        {Type, T} ->
            case check_day(T, Now) of
                1 -> %% 同一天 已领取
                    {false, ?L(<<"同类型奖励每天只可领取一次">>)};
                0 ->
                    {ok, lists:keyreplace(Type, 1, Ts, {Type, Now})}
            end
    end.

% check_reward2(Type, Role = #role{vip = Vip =  #vip{reward_times = Ts,effect = Effect}}) ->
%     Now = util:unixtime(),
%     case lists:keyfind(Type, 1, Effect) of 
%         false ->
%             {0, Role};
%         {_, Value} ->   
%             case lists:keyfind(Type, 1, Ts) of
%                 false -> %% 未领取过
%                     NTs = [{Type, Now} | Ts],
%                     {Value, Role#role{vip = Vip#vip{reward_times = NTs}}};
%                 {Type, T} ->
%                     case check_day(T, Now) of
%                         1 -> %% 同一天 已领取
%                             {0, Role};
%                         0 ->
%                             NTs1 = lists:keyreplace(Type, 1, Ts, {Type, Now}),
%                             {Value, Role#role{vip = Vip#vip{reward_times = NTs1}}}
%                     end
%             end
%     end.




%% 领取VIP祝福 每天只能领取一次 
get_bless(#role{vip = #vip{type = ?vip_no}}) ->
    {false, ?L(<<"非VIP不能领取祝福">>)};
get_bless(Role=#role{vip = Vip = #vip{type = Type, buff_time = BuffTime}}) -> 
    case check_status(Role) of     
        {ok, NR} -> %% VIP已过期
            {false, ?L(<<"VIP已过期">>), NR};
        ok ->
            NTime = util:unixtime(),
            case check_day(BuffTime, NTime) of
                1 -> {false, ?L(<<"每天只能领取一次祝福">>)};
                0 ->
                    case vip_data:get(Type) of
                        {false, Reason} -> {false, Reason};
                        {ok, #vip_base{buff = Buff}} ->
                            case buff:add(Role, Buff) of
                                {false, Reason} -> {false, Reason};
                                {ok, NRole} ->
                                    push_assets(NRole),
                                    NewRole = role_api:push_attr(NRole),
                                    {ok, NewRole#role{vip = Vip#vip{buff_time = NTime}}}
                            end
                    end
            end
    end.

%% @doc 判断角色是否为vip (包括体验卡用户)
%% @spec check(Role) -> false | true
%% Role = #role{}
check(#role{vip = #vip{type = ?vip_no}}) ->
    false;
check(_Role = #role{vip = #vip{expire = Expire}}) ->
    NTime = util:unixtime(),
    NTime =< Expire.

%% @doc 判断角色是否为vip (不包括检验卡用户)
%% @spec check2(Role) -> false | true
%% Role = #role{}
check2(#role{vip = #vip{type = ?vip_no}}) -> false;
check2(#role{vip = #vip{type = ?vip_try}}) -> false;
check2(Role) -> check(Role).

%% @doc 获取头像
%% @spec get_face_id(Id, Sex) -> FaceId
%% Id = integer() 
%% Sex = integer()
%% FaceId = integer()
% get_face_id(?career_zhenwu, 1) -> 2100;
% get_face_id(?career_zhenwu, 0) -> 2000;
get_face_id(?career_cike, 1) -> 2100;
get_face_id(?career_cike, 0) -> 2000;
get_face_id(?career_xianzhe, 1) -> 3100;
get_face_id(?career_xianzhe, 0) -> 3000;
% get_face_id(?career_feiyu, 1) -> 5100;
% get_face_id(?career_feiyu, 0) -> 5000;
get_face_id(?career_qishi, 1) -> 5100;
get_face_id(?career_qishi, 0) -> 5000;
% get_face_id(?career_xinshou, 1) -> 2100;
% get_face_id(?career_xinshou, 0) -> 2000;
get_face_id(_, _) -> 0.




%% @doc 获取头像
%% @spec get_face_id(#role{}) -> FaceId
get_face_id(#role{career = Career, sex = Sex, ascend = Ascend}) ->
    ascend:get_face_id(Career, Sex, Ascend).

%% 定时检测VIP更新 每隔一段时间自动检测一次
check_update(#role{vip = #vip{type = ?vip_no}}) ->
    {ok};
check_update(Role) ->
    case check_status(Role) of
        {ok, NR} -> %% VIP已过期
            {ok, NR};
        ok ->
            NRole = auto_reward(Role),
            NewRole = push_info(all_update, NRole),
            {ok, add_vip_timer(NewRole)}
    end.

%% 计算VIP属性加成
calc_ratio(Role = #role{vip = #vip{type = ?vip_no}}) ->
    Role;
calc_ratio(Role = #role{ratio = Ratio = #ratio{exp = Exp, psychic = Psychic}}) ->
    NewExp = Exp + effect(exp, Role),
    NewPsychic = Psychic + effect(psychic, Role),
    Role#role{ratio = Ratio#ratio{exp = NewExp, psychic = NewPsychic}}.

%% 扣除VIP飞天次数
use(fly_sign, Role = #role{vip = Vip = #vip{fly_sign = Fly}}) when is_integer(Fly) ->
    case Fly of
        -1 -> {ok, Role};
        F when F < 1 -> false;
        _ ->
            {ok, Role#role{vip = Vip#vip{fly_sign = Fly - 1}}}
    end;
%% 扣除VIP传音次数
use(hearsay, Role = #role{vip = Vip = #vip{hearsay = Hearsay}}) when is_integer(Hearsay) ->
    case Hearsay > 0 of
        false -> false;
        true ->
            {ok, Role#role{vip = Vip#vip{hearsay = Hearsay - 1}}}
    end;
use(_, _Role) -> false. %% 容错处理

%% VIP效果数据
%% 强化加成
effect(enchant, #role{vip = #vip{type = ?vip_week}}) -> 2;
effect(enchant, #role{vip = #vip{type = ?vip_month}}) -> 3;
effect(enchant, #role{vip = #vip{type = ?vip_half_year}}) -> 5;
effect(enchant, #role{vip = #vip{type = ?vip_try}}) -> 5;
%% 打坐经验加成
effect(sit_exp, #role{vip = #vip{type = ?vip_week}}) -> 5;
effect(sit_exp, #role{vip = #vip{type = ?vip_month}}) -> 6;
effect(sit_exp, #role{vip = #vip{type = ?vip_half_year}}) -> 10;
%% 最大好友数量加成
effect(max_friend, #role{vip = #vip{type = ?vip_week}}) -> 10;
effect(max_friend, #role{vip = #vip{type = ?vip_month}}) -> 15;
effect(max_friend, #role{vip = #vip{type = ?vip_half_year}}) -> 30;
%% 经验加成
effect(exp, #role{vip = #vip{type = ?vip_week}}) -> 10;
effect(exp, #role{vip = #vip{type = ?vip_month}}) -> 20;
effect(exp, #role{vip = #vip{type = ?vip_half_year}}) -> 50;
effect(exp, #role{vip = #vip{type = ?vip_try}}) -> 50;
%% 灵力加成
effect(psychic, #role{vip = #vip{type = ?vip_week}}) -> 10;
effect(psychic, #role{vip = #vip{type = ?vip_month}}) -> 20;
effect(psychic, #role{vip = #vip{type = ?vip_half_year}}) ->50;
effect(psychic, #role{vip = #vip{type = ?vip_try}}) ->50;
%% 挂机次数
effect(hook, #role{vip = #vip{type = ?vip_week}}) -> 50;
effect(hook, #role{vip = #vip{type = ?vip_month}}) -> 50;
effect(hook, #role{vip = #vip{type = ?vip_half_year}}) ->50;
%% 错误处理
effect(_Mod, _Role) -> 0.

%% 推送VIP财产
push_assets(#role{link = #link{conn_pid = ConnPid}, vip = #vip{hearsay = Hearsay, fly_sign = FlySign}}) ->
    sys_conn:pack_send(ConnPid, 12403, {Hearsay, FlySign}).

%%-------------------------------------------------------
%% 内部方法
%%-------------------------------------------------------

%% 获取奖励
get_reward(#role{vip = #vip{type = ?vip_no}}, _) -> {false, ?L(<<"当前不是VIP">>)};
get_reward(#role{vip = #vip{type = ?vip_week}}, ?vip_reward_gold_bind) -> 
    {ok, [#gain{label = gold_bind, val = 2}]};
get_reward(#role{vip = #vip{type = ?vip_month}}, ?vip_reward_gold_bind) -> 
    {ok, [#gain{label = gold_bind, val = 5}]};
get_reward(#role{vip = #vip{type = ?vip_half_year}}, ?vip_reward_gold_bind) -> 
    {ok, [#gain{label = gold_bind, val = 10}]};
get_reward(_, _) -> {false, ?L(<<"当前不是VIP">>)}.

%% 获取VIP卡基础ID
base_id(?vip_week) -> {pay:price(?MODULE, vip_week, null), 32400};
base_id(?vip_month) -> {pay:price(?MODULE, vip_month, null), 32401};
base_id(?vip_half_year) -> 
    case shop:list(special) of
        {_T1, #shop_item{base_id = 32403, price = Price}, _T2, _Item2, _T3, _Item3, _T4, _Item4} -> {Price, 32403};
        {_T1, _Item1, _T2, #shop_item{base_id = 32403, price = Price}, _T3, _Item3, _T4, _Item4} -> {Price, 32403};
        {_T1, _Item1, _T2, _Item2, _T3, #shop_item{base_id = 32403, price = Price}, _T4, _Item4} -> {Price, 32403};
        {_T1, _Item1, _T2, _Item2, _T3, _Item3, _T4, #shop_item{base_id = 32403, price = Price}} -> {Price, 32403};
        _ -> {pay:price(?MODULE, vip_half_year, null), 32403}
    end;
base_id(_) -> false.

%% 检测VIP状态
check_status(Role = #role{career = Career, sex = Sex, vip = Vip = #vip{type = OldType, expire = Expire}}) ->
    NTime = util:unixtime(),
    case NTime =< Expire of
        false -> %% VIP已过期
            NewVip = Vip#vip{type = ?vip_no, portrait_id = get_face_id(Career, Sex)},
            NR = Role#role{vip = NewVip},
            NR1 = activity:update_act_limit(NR),
            NR2 = role_api:push_attr(NR1),
            guild_mem:update(vip, NR2), %% 帮会成员VIP监听
            task:refresh_acceptable_task(ref_and_send, NR, ?task_type_rc),
            case OldType =:= ?vip_try of
                true -> push_info({open_win, 1}, NR2);
                false -> push_info({open_win, 2}, NR2)
            end,
            send_mail_expire(Role),
            {ok, push_info(all_update, NR2)};
        true ->
            ok
    end.

%% 增加VIP检测时间(下一天0点或过期时间)
add_vip_timer(Role = #role{vip = #vip{expire = Expire}}) ->
    NRole = case role_timer:del_timer(check_vip, Role) of
        {ok, _, NR} -> NR;
        false -> Role
    end,
    NextCheckTime = next_check_time(Expire) + 2,
    role_timer:set_timer(check_vip, NextCheckTime * 1000, {vip, check_update, []}, 1, NRole).

%% 获取下一次检测时间 秒
next_check_time(Expire) ->
    Now = util:unixtime(),
    TodayStartTime = util:unixtime({today, Now}),
    TomorrowStartTime = TodayStartTime + 86400,
    if
        Expire > TomorrowStartTime -> %% 今天内VIP不会过期
            TomorrowStartTime - Now;
        Expire < Now -> %% 现在已经过期
            0;
        true -> %% 今天内VIP会过期
            Expire - Now
    end.

%% @doc 每天登录领取奖励
%% @spec get_reward(Role) -> NewRole
%% Role | NewRole = #role{}
auto_reward(Role = #role{name = _Name, vip = #vip{type = Type, special_time = SpecialTime}}) ->
    NTime = util:unixtime(),
    case check_day(SpecialTime, NTime) of
        1 -> %%每天只能领取一次奖励
            Role;
        0 ->
            case vip_data:get(Type) of
                {ok, #vip_base{effect = Effect}} ->
                    case vip_effect:do(Effect, Role) of
                        {ok, NRole = #role{vip = Vip}} ->
                            NRole#role{vip = Vip#vip{special_time = NTime}};
                        _ -> 
                            ?ERR("VIP发放奖励失败:[~s]", _Name),
                            Role
                    end;
                _ -> Role
            end
    end.

%% 角色头像ID值校验
check_face_id(FaceId, #role{sex = Sex}) when FaceId > 0 andalso FaceId < 13 ->
    (FaceId rem 2) =:= Sex;
check_face_id(FaceId, Role = #role{sex = Sex}) when FaceId > 12 andalso FaceId < 32 -> 
    case ascend:check_is_ascend(Role) of
        true -> 
            (FaceId rem 2) =:= Sex; %% 没验证职业进阶方向对应
        false -> false
    end;
check_face_id(FaceId, #role{vip = #vip{type = VipType}}) when FaceId >= 100 andalso FaceId < 300 andalso (VipType =:= ?vip_no orelse VipType =:= ?vip_try) ->
    {false, ?L(<<"非VIP不能使用VIP头像">>)};
check_face_id(FaceId, #role{sex = 1}) when FaceId >= 100 andalso FaceId < 200 -> true;
check_face_id(FaceId, #role{sex = 0}) when FaceId >= 200 andalso FaceId < 300 -> true;
check_face_id(FaceId, #role{vip = #vip{face_list = FaceList}}) -> 
    lists:member(FaceId, FaceList).

%% 判断两个时间是否在同一天
check_day(0, _) -> 0;
check_day(_, 0) -> 0;
check_day(Time1, Time2) ->
    Day1 = util:unixtime({today, Time1}),
    Day2 = util:unixtime({today, Time2}),
    case Day1 =:= Day2 of
        true -> 1;
        false -> 0
    end.

%% 推送VIP信息 包括场境推送
push_info(all_update, Role = #role{looks = Looks, link = #link{conn_pid = ConnPid}, vip = Vip = #vip{type = Type}}) ->
    sys_conn:pack_send(ConnPid, 12400, info_to_client(Vip)),
    NewLooks = lists:keyreplace(?LOOKS_TYPE_VIP, 1, Looks, {?LOOKS_TYPE_VIP, Type, 0}),
    NRole = Role#role{looks = NewLooks},
    map:role_update(NRole),
    NRole;
push_info(update, Role = #role{link = #link{conn_pid = ConnPid}, vip = Vip}) ->
    sys_conn:pack_send(ConnPid, 12400, info_to_client(Vip)),
    Role;
push_info(face_list, Role = #role{link = #link{conn_pid = ConnPid}, vip = #vip{face_list = FaceList}}) ->
    sys_conn:pack_send(ConnPid, 12406, {FaceList}),
    Role;
push_info({open_win, Type}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 12410, {Type}),
    Role.

%% VIP信息转化为客户端信息
info_to_client(#vip{type = Type, expire = Expire, portrait_id = PortraitId, special_time = SpecialTime, buff_time = BuffTime, hearsay = Hearsay, fly_sign = FlySign, reward_times = Ts, is_try = IsTry}) ->
    Now = util:unixtime(),
    RL = [{RType, check_day(T, Now), T} || {RType, T} <- Ts],
    {Type, Expire, PortraitId, SpecialTime, BuffTime, check_day(BuffTime, Now), check_day(SpecialTime, Now), Hearsay, FlySign, RL, IsTry}.

%% @spec change_sex(Role) -> NewRole 
%% @doc 变性混头像l
change_sex(Role = #role{sex = Sex, career = Career, vip = Vip = #vip{face_list = FaceList}}) ->
    NewFaceList = update_sex(Sex, FaceList, []),
    Role#role{vip = Vip#vip{portrait_id = get_face_id(Career, Sex), face_list = NewFaceList}}.
update_sex(_, [], FaceList) -> 
    lists:reverse(FaceList);
update_sex(Sex = 0, [FaceId | T], FaceList) when FaceId >= 10000 andalso FaceId < 20000 -> %% 男头像变女头像
    NewFaceId = FaceId + 10000,
    update_sex(Sex, T, [NewFaceId | FaceList]);
update_sex(Sex = 1, [FaceId | T], FaceList) when FaceId >= 20000 andalso FaceId < 30000 -> %% 女头像变男头像
    NewFaceId = FaceId - 10000,
    update_sex(Sex, T, [NewFaceId | FaceList]);
update_sex(Sex, [FaceId | T], FaceList) ->
    update_sex(Sex, T, [FaceId | FaceList]).

%% 发送角色VIP过期信件
send_mail_expire(Role = #role{vip = #vip{type = Type}}) when Type =:= ?vip_week orelse Type =:= ?vip_month orelse ?vip_half_year ->
    mail_mgr:deliver(Role, {?L(<<"VIP到期通知">>), ?L(<<"\r尊敬的VIP会员。您的VIP已经到期。\n将不能继续享用VIP免费领取晶钻、无限飞行等特权。\n继续成为VIP.将能继续享用VIP特权。\n飞仙团队敬上！">>)});
send_mail_expire(_Role) -> ok.


%%获取等级差之间的所有特权
get_all_eff(NLev, Lev)->
    do_get_all_eff(NLev+1, Lev+1, []).

do_get_all_eff(_Lev, _Lev, L) -> L;
do_get_all_eff(NLev, Lev, L) ->
    case vip_data2:get_vip_base(Lev) of 
        {ok, #vip_base{effect = Eff}} ->
            do_get_all_eff(NLev, Lev+1, Eff ++ L);
        _ -> do_get_all_eff(NLev, Lev+1, L)
    end.
%%合并特权，相同类型取值比较大的
merge([], Effect) -> Effect;
merge([{Key, Value}|T], Effect) ->
    case lists:keyfind(Key, 1, Effect) of 
        {Key, Value1} ->
            NEffect =  
                case Value1 < Value of 
                    true ->
                        lists:keyreplace(Key, 1, Effect, {Key, Value});
                    false -> Effect
                end,
            merge(T, NEffect);
        _ -> merge(T, Effect ++ [{Key, Value}])
    end.

%%获取配置文件等级所对应的特权
get_lev(Value) ->
    F = fun(E,Nth)->
            case  Value >= E of 
                true -> Nth + 1;
                false -> Nth
            end
        end,
    Lev = lists:foldl(F,0,vip_data2:get_all_lev()),
    case Lev > 10 of 
        true -> 10;
        false -> Lev 
    end. 

push_charge_flag(#role{link = #link{conn_pid = ConnPid}, vip = #vip{charge_cnt = Cnt}, max_map_id = MapId}) ->
    ChargeFlag = case Cnt =:= 0 of true -> 0; false -> 1 end,
    MapFlag = case MapId >= 1405 of true -> ?true; false -> ?false end, %% 是否到过中庭之国
    sys_conn:pack_send(ConnPid, 12414, {ChargeFlag, MapFlag}).

%% 增加一封神秘来信
%%set_discount_mail(make_30_eqm, Role = #role{link = #link{conn_pid = ConnPid}, vip = Vip = #vip{mail_list = MailList}}) ->
%%    Now = util:unixtime(),
%%    sys_conn:pack_send(ConnPid, 13809, {1, Now}),
%%    Role1 = Role#role{vip = Vip#vip{mail_list = [{1, Now} | MailList]}},
%%    Role1;
%%
%%set_discount_mail(refine_30_blue_eqm, Role = #role{link = #link{conn_pid = ConnPid}, vip = Vip = #vip{mail_list = MailList}}) ->
%%    Now = util:unixtime(),
%%    sys_conn:pack_send(ConnPid, 13809, {2, Now}),
%%    Role1 = Role#role{vip = Vip#vip{mail_list = [{2, Now} | MailList]}},
%%    Role1;
%%
%%set_discount_mail(weapon_enchant_5, Role = #role{link = #link{conn_pid = ConnPid}, vip = Vip = #vip{mail_list = MailList}}) ->
%%    Now = util:unixtime(),
%%    sys_conn:pack_send(ConnPid, 13809, {3, Now}),
%%    Role1 = Role#role{vip = Vip#vip{mail_list = [{3, Now} | MailList]}},
%%    Role1;
%%
%%set_discount_mail(cloth_enchant_5, Role = #role{link = #link{conn_pid = ConnPid}, vip = Vip = #vip{mail_list = MailList}}) ->
%%    Now = util:unixtime(),
%%    sys_conn:pack_send(ConnPid, 13809, {4, Now}),
%%    Role1 = Role#role{vip = Vip#vip{mail_list = [{4, Now} | MailList]}},
%%    Role1;
%%
%%set_discount_mail(juan_zou, Role = #role{link = #link{conn_pid = ConnPid}, vip = Vip = #vip{mail_list = MailList, item_flag = 0}}) ->
%%    Now = util:unixtime(),
%%    sys_conn:pack_send(ConnPid, 13809, {5, Now}),
%%    Role1 = Role#role{vip = Vip#vip{mail_list = [{5, Now} | MailList], item_flag = 1}},
%%    Role1;
%%
%%set_discount_mail(kill_npc, Role = #role{link = #link{conn_pid = ConnPid}, vip = Vip = #vip{mail_list = MailList}}) ->
%%    Now = util:unixtime(),
%%    sys_conn:pack_send(ConnPid, 13809, {6, Now}),
%%    Role1 = Role#role{vip = Vip#vip{mail_list = [{6, Now} | MailList]}},
%%    Role1;

set_discount_mail(_Label, Role) ->
    Role.

%% 充值礼包
charage_gift(Role = #role{id = Rid, vip = #vip{charge_cnt = Cnt}}) ->
    case Cnt of
        1 ->
            %case item:make(532516, 1, 1) of
            %    {ok, ItemL} ->
                    %case storage:add(bag, Role, ItemL) of
                    %    {ok, Bag} ->
                    %        Role#role{bag = Bag};
                    %    false ->
                            Gains = [#gain{label = item, val = [532516, 1, 1]}],
                            award:send(Rid, 303000, Gains),
                            Role;
                    %end;
             %   false ->
             %       ?ERR(" 创建充值礼包失败  "),
             %       Role
            %end;
        _ ->
            Role
    end.
            

% update_npc_store_freetimes(NLev, Effect, Role = #role{id = {Rid, _}}) ->
%     case vip_data2:get_vip_base(NLev) of 
%         {ok, #vip_base{effect = Eff}} ->
%             case lists:keyfind(npc_store, 1, Eff) of 
%                 {_, Val} when Val =/= 0 ->
%                     Do = 
%                         case lists:keyfind(npc_store, 1, Effect) of 
%                             {_, OldVal} ->
%                                 case Val =< OldVal of
%                                     true -> notdeal;
%                                     false -> OldVal
%                                 end;
%                             _ -> 0
%                         end,
%                     case Do of 
%                         notdeal -> ok;
%                         N ->
%                             {Last_Time, Free_Times, Last_Items} = npc_store_sm:get_role_last_items(Role),
%                             npc_store_sm:update_role_last_items(Rid, Last_Time, Free_Times + Val - N, Last_Items)
%                     end;
%                 _ -> ok
%             end;
%         _ -> ok
%     end.
