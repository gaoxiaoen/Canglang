%%----------------------------------------------------
%% 成就系统RPC 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(achievement_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("achievement.hrl").
-include("attr.hrl").
-include("assets.hrl").
-include("gain.hrl").
-include("trial.hrl").

-define(TASKID, 10320).

%% 成就系统:获取列表
handle(13000, {}, Role) ->
    {reply, achievement:list(?achievement_system_type, Role)};

%% 成就系统:称号列表
handle(13001, {}, Role) ->
    {reply, achievement:honors(Role)};

%% 成就系统:称号更换
handle(13002, {Id}, Role) ->
    case achievement:use_honor(Id, Role) of
        {false, <<>>} -> {ok};
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> {reply, {1, ?L(<<"使用称号成功">>)}, NRole}
    end;

%% 成就系统:取消使用此称号
handle(13003, {Id}, Role) ->
    case achievement:cancel_honor(Id, Role) of
        {false, <<>>} -> {ok};
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> {reply, {1, ?L(<<"取消称号成功">>)}, NRole}
    end;

%% 成就系统:奖励领取
handle(13004, {Id}, Role) ->
    case achievement:reward(?achievement_system_type, Id, Role) of
        {false, Reason} -> {reply, {Id, 0, Reason}};
        {ok, NRole} -> {reply, {Id, 1, ?L(<<"领取奖励成功">>)}, NRole}
    end;

%% 成就系统:称号修改
handle(13005, {_HonorId, <<>>}, _Role) ->
    {ok};
%% handle(13005, {_HonorId, Name}, _Role) when byte_size(Name) > 30 ->
%%    {reply, {0, ?L(<<"称号字符太长">>)}};
handle(13005, {HonorId, Name}, Role) ->
    Len = length(util:to_list(Name)), 
    case Len > 12 of
        true -> {reply, {0, ?L(<<"称号字符太长">>)}};
        false ->
            case util:text_banned(Name) of
                true -> {reply, {0, ?L(<<"称号中包含非法字符">>)}};
                _ ->
                    case achievement:modify_honor(Role, HonorId, Name) of
                        {false, Reason} -> {reply, {0, Reason}};
                        {ok, NRole} -> {reply, {1, ?L(<<"称号修改成功">>)}, NRole}
                    end
            end
    end;

%% 目标系统:获取列表
handle(13020, {}, Role) ->
    {reply, {achievement:list(?target_system_type, Role)}};

%% 目标系统:奖励领取
handle(13021, {Id}, Role = #role{link = #link{conn_pid = _ConnPid}}) ->
    case achievement:reward(?target_system_type, Id, Role) of
        {false, Reason} -> {reply, {Id, 0, Reason}};
        {ok, NRole} -> 
            %% 在这里通知下前端刷新开服活动列表 Jange 2012/4/17
            case achievement:is_finish_all(NRole) of
                true -> 
                    ok;
                    %% award:notice_action_close(ConnPid, target_reward);
                _ -> ok
            end,
            {reply, {Id, 1, ?L(<<"领取奖励成功">>)}, NRole}
    end;

%% 日常目标系统
handle(13050, {}, #role{achievement = #role_achievement{day_reward = DayReward, day_list = DayList}}) ->
    L = [{Id, Status} || #achievement{id = Id, status = Status} <- DayList],
    ?DEBUG("==========================[~p ~p ~p]", [DayReward, length(L), length(DayList)]),
    {reply, {DayReward, L}};

%% 日常目标奖励领取
handle(13051, {}, Role) ->
    case achievement_everyday:reward(Role) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> {reply, {1, <<>>}, NRole}
    end;

%% ----- 7日目标相关
%% 7日目标列表
handle(13053, {}, Role) ->
    Data = achievement_7day:list(Role),
    {reply, Data};

%% 领取其中一个7日目标奖励
handle(13054, {Id}, Role) ->
    case achievement_7day:reward(Role, Id) of
        {ok, NewRole} ->
            {reply, {?true, ?L(<<"成功领取奖励">>)}, NewRole};
        not_finish ->
            {reply, {?false, ?L(<<"该目标还没完成">>)}};
        rewarded ->
            {reply, {?false, ?L(<<"该目标的奖励您已经领取了">>)}};
        day_over ->
            {reply, {?false, ?L(<<"该目标已过期">>)}};
        no_rewards ->
            {reply, {?false, ?L(<<"找不到奖励信息">>)}};
        _R ->
            ?DEBUG("7日目标领取失败 ~w", [_R]),
            {reply, {?false, ?L(<<"领取失败">>)}}
    end;

% %% 角色勋章信息存储
% -record(medal, {
%         wearid = 0             %% 当前佩戴的勋章 ::{id,medal_id}
%         ,cur_id = 1            %% 当前正在完成的勋章的 id :: int
%         ,cur_medal_id = 1000   %% 当前正在完成的勋章 cur_medal_id :: int 
%         ,cur_rep = 0           %% 当前声望值
%         ,need_rep = 300          %% 扔需要的声望值
%         ,gain = []             %% 已获得的勋章列表 ::[{id,medal_id}]
%         ,condition = [3,3,3,3,3,3,3,3,3,3,3,3]        %% 勋章的条件列表 [{id, status}}] :: id 1 ~ N ,status:: 1:finished, 2:unclaimed, 3:unfinished        
%         % ,unfinish_list = []     %% 当前勋章待完成条件 ::[case_id]
%         % ,unclaimed_list = []    %% 可领取的条件，领取后放入已完成条件列表 ::[case_id]
%     }).


%% 进入勋章面板
handle(13060,{}, _Role = #role{medal = #medal{cur_medal_id = Cur_medal_id, cur_rep = Cur_rep,
        need_rep = Need_rep, gain = Gain, condition = Condition}}) ->
    Loc = medal:get_first(Condition, ?status_unclaimed),
    PageIndex = case  Loc > ?condition_num of 
                            true ->
                                Loc2 = medal:get_first(Condition, ?status_unfinish),
                                case  Loc2 > ?condition_num of 
                                    true ->
                                        1;
                                    false ->
                                        PageIndex2 = util:ceil(Loc2 / ?page_num),
                                        PageIndex2
                                end;
                            false ->
                                PageIndex1 = util:ceil(Loc / ?page_num),
                                PageIndex1
                        end,
    {reply, {Cur_medal_id, Cur_rep, Need_rep, Gain, PageIndex, Condition}};    

%% 查看加成属性
handle(13061, {}, _Role = #role{link = #link{conn_pid = _ConnPid}, medal = #medal{gain = Gain}}) ->
    ?DEBUG("-----~w~n",[Gain]),
    Data = case Gain of 
                [] ->
                    [];
                _ ->
                    D = medal:get_attr_all(Gain),
                    lists:map(fun({Label, Value})->{get_key(Label), Value} end, D)
            end,
    ?DEBUG("------~p~n",[Data]),
     % sys_conn:pack_send(ConnPid, 13061, {Data}),
    {reply,{Data}};

%% 查看勋章完成条件
handle(13062,{Medal_id, PageIndex}, _Role = #role{medal = #medal{gain = Gain, cur_medal_id = Cur_medal_id, condition = Condition}}) ->
    Data = case lists:member(Medal_id, Gain) of 
                true ->
                    {2, []};
                _ ->
                    case Medal_id == Cur_medal_id of 
                        true ->
                            {1, get_certain_page_data(PageIndex, Condition)};
                        false ->
                            {0, []}
                    end
            end,
    {reply,Data};


%%查看已获得的勋章
handle(13063, {Nth}, #role{medal = #medal{gain = Gain}}) ->
    case (Nth > erlang:length(Gain)) orelse (Nth == 0)  of 
        true ->
            {reply, {0}};
        false ->
            {reply, {lists:nth(Nth, Gain)}}
    end;

% %% 勋章基础信息存储
% -record(medal_base, {
%         medal_id = 0            %% 当前正在完成的勋章 medal_id :: int 
%         ,need_rep = 0           %% 需要的声望值
%         ,condition = []         %% 勋章的条件列表 [#medal_cond{label,target,target_value,rep}] 
%         ,dungeon = 0            %% 开启试炼场id
%         ,next_id = 0            %% 下一个勋章id
%         % ,special                %% 勋章开启的特权 ::[case_id]
%     }).

%% 领取
handle(13064, {Nth}, Role = #role{id = {Rid, _}, career = Career, link = #link{conn_pid = ConnPid}, special = Special,
    medal = Medal = #medal{cur_medal_id = Cur_medal_id, condition = Condition, cur_rep = Cur_rep, need_rep = Need_rep, gain = Gain}}) when Nth =/= 0 ->
    case check_special(Cur_medal_id, Nth) of 
        ok ->
            case lists:nth(Nth, Condition) of 
                {?status_unclaimed, Progress} ->
                    {ok, #medal_base{next_id = Next, condition = Cond}} = medal_data:get_medal_base(Cur_medal_id),
                    #medal_cond{rep = Rep, stone = Stone} = lists:nth(Nth, Cond),
                    case Rep >= Need_rep of 
                        true ->
                            NSpecial = 
                                case lists:keyfind(?special_medal, 1, Special) of
                                    false -> [{?special_medal, Cur_medal_id, <<"">>}] ++ Special;
                                    _ ->
                                        lists:keyreplace(?special_medal, 1, Special, {?special_medal, Cur_medal_id, <<"">>})
                                end,
                            sys_conn:pack_send(ConnPid, 13064, {Nth}),    
                            {ok, Role0} = role_gain:do([#gain{label = gold, val = Stone}], Role),
                            Role1 = role_listener:special_event(Role0, {1062, Cur_medal_id}), %% 获得一块勋章
                            Role2 = manor:fire(Cur_medal_id, Role1),
                            log:log(log_medal, {<<"获得勋章">>, Cur_medal_id, Role2}),

                            case medal_data:get_medal_base(Next) of %%获得勋章
                                {ok, #medal_base{need_rep = Need2, condition = NCondition}}-> 
                                    NMedal = Medal#medal{wearid = Cur_medal_id, cur_medal_id = Next, cur_rep = 0, need_rep = Need2, gain = Gain ++ [Cur_medal_id], condition = medal:get_init_cond()},
                                    NCondition1 = medal:make_cond(Career, NCondition),
                                    medal_mgr:update_cur_medal_cond(Rid, NCondition1),
                                    NRole0 = Role2#role{medal = NMedal, special = NSpecial},
                                    NR = add_attr_role(NRole0, Cur_medal_id), %% 获取加成属性,更新Role
                                    medal_mgr:update_top_n_medal(NR, Cur_medal_id),
                                    map:role_update(NR),
                                    NR3 = medal:check_next(NR),
                                    {ok, NR3};
                                    
                                {false, _} ->
                                    NMedal = Medal#medal{wearid = Cur_medal_id, cur_medal_id = 0, cur_rep = 0, need_rep = 0, gain = Gain ++ [Cur_medal_id], condition = medal:get_init_cond()},
                                    NRole0 = Role2#role{medal = NMedal, special = NSpecial},
                                    NR = add_attr_role(NRole0, Cur_medal_id), %% 获取加成属性,更新Role
                                    medal_mgr:update_top_n_medal(NR, Cur_medal_id),
                                    map:role_update(NR),
                                    notice:alert(succ, ConnPid, ?MSGID(<<"太棒了，你已经获得最高级勋章啦！">>)),
                                    {ok, NR}
                            end;
                        false ->
                            {L1, L2} = lists:split(Nth, Condition),
                            NL1 = lists:sublist(L1, Nth - 1),
                            NCond = NL1 ++ [{?status_finish, Progress}] ++ L2,
                            NRole0 = Role#role{medal = Medal#medal{need_rep = Need_rep - Rep, cur_rep = Cur_rep + Rep, condition = NCond}},
                            {ok, NRole} = role_gain:do([#gain{label = gold, val = Stone}], NRole0),
                            NRole1 = check_last_is_skill(NRole),
                            log:log(log_medal, {<<"勋章条件领取">>, Nth, NRole1}),
                            {reply, {Nth}, NRole1}
                    end;
                _ ->
                    notice:alert(error, ConnPid, ?MSGID(<<"该条件已领取">>)),
                    {ok}
            end;
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            {ok}
    end;

%%进入试炼场面板，推送已获得的试炼场id以及试炼场简介信息
handle(13066,{}, #role{medal = #medal{gain = Gain, pass = Pass}}) ->
    DungeonIds = [10000] ++ get_dungeon(Gain),
    Trial_Info = trial_mgr:get_all(),
    {reply, {DungeonIds, Pass, lists:keysort(1, Trial_Info)}};

%%进入荣耀学院面板,推送前5个勋章
handle(13067, {}, _Role) ->
    Data = medal_mgr:get_top_n_medal(),
    {reply, {Data}};

handle(13070, {TrialId}, Role = #role{id = Id, link = #link{conn_pid = ConnPid}, medal = Medal = #medal{pass = Pass}}) ->
    case lists:keyfind(TrialId, 1, Pass) of 
        false ->
            notice:alert(error, ConnPid, ?MSGID(<<"未通关该试炼场，不能领取礼包！">>)),
            {ok};
        {_, IsGain, Time} ->
            case IsGain of 
                1 ->
                    notice:alert(error, ConnPid, ?MSGID(<<"已领取礼包，不能再领取！">>)),
                    {ok};
                _ ->
                    case trial_data:get(TrialId) of 
                        Trial_base when is_record(Trial_base, trial_base) ->
                            #trial_base{award = Award} = Trial_base,
                            role:send_buff_begin(),
                            {NRole, Rest} = deal_award(Award, Role, []),
                            role:send_buff_flush(),
                            case erlang:length(Rest) > 0 of
                                true ->
                                    notice:alert(succ, ConnPid, ?MSGID(<<"背包已满，部分物品已发送至奖励大厅">>)),
                                    award:send(Id, 203000, Rest),
                                    ok;
                                false ->
                                    ok
                            end,
                            NPass = lists:keyreplace(TrialId, 1, Pass, {TrialId, 1, Time}),
                            {reply, {}, NRole#role{medal = Medal#medal{pass = NPass}}};
                        _ ->
                           ?DEBUG("--找不到试炼场基础信息--"),
                            {ok}
                    end
            end
    end;


%% 试炼场:挑战
handle(13071, {TrialId}, Role = #role{medal = #medal{pass = Pass}}) ->
    %% TODO 加一些验证
    CheckResult = 
        case TrialId of 
            10000 ->
                case lists:keyfind(10000, 1, Pass) of 
                    false ->
                        case task:is_accepted(Role, ?TASKID) of 
                            true -> ok;
                            false ->
                                {false, ?MSGID(<<"未接受任务">>)}
                        end;
                    _ ->
                        ok
                end;
            _ -> ok
        end,
    case CheckResult of 
        ok ->
            case trial_data:get(TrialId) of
                undefined ->
                    notice:alert(error, Role, ?MSGID(<<"该试炼场不存在">>)),
                    {reply, {?false}};
                Trial ->
                    case trial_combat:start(Trial, Role) of
                        {ok, NewRole} ->
                            {reply, {?true}, NewRole};
                        {error, ErrMsg, NewRole} ->
                            notice:alert(error, NewRole, ErrMsg),
                            {reply, {?false}, NewRole}
                    end
            end;
        {false, Reason} ->
            notice:alert(error, Role, Reason),
            {reply, {?false}}
    end;


%% 试炼场: 离开场景
handle(13072, _, Role) ->
    NewRole = trial_combat:leave(Role),
    {reply, {}, NewRole};

%% 竞技勋章: 获取竞技勋章信息
handle(13080, {}, Role) ->
    medal_compete:push_compete_medal_info(Role, true),
    {ok};

%% 竞技勋章: 佩戴勋章
handle(13081, {Id}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case medal_compete:puton(Role, Id) of
        {ok, NewRole} ->
            {reply, {Id}, NewRole};
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            % {reply, {?false}}
            ok
    end;

%% 竞技勋章: 兑换称号
handle(13082, {HonorId}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case medal_compete:exchange(HonorId, Role) of
        {ok, NewRole} ->
            {reply, {HonorId}, NewRole};
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            % {reply, {?false}}
            ok
    end;

%% 竞技勋章: 取消佩戴勋章
handle(13084, {Id}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case medal_compete:takeoff(Role, Id) of
        {ok, NewRole} ->
            {reply, {Id}, NewRole};
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            % {reply, {?false}}
            ok
    end;

handle(_Cmd, _Data, _Role) -> %% 容错处理
    {error, unknow_command}.

check_special(Cur_medal_id, Nth) -> 
    case Cur_medal_id =:= 10001 andalso Nth =:= 12 of  %% 第一块勋章的最后一个条件需要加限制
        true ->
            case task:is_zhux_finish(?TASKID) of 
                true -> ok;
                false ->
                    {false, ?MSGID(<<"请先找王国将领提交任务">>)}
            end;
        false -> ok
    end.


check_last_is_skill(Role = #role{medal = #medal{condition = Condition}}) ->
    case task:is_zhux_finish(?TASKID) of
        false ->
            Role;
        true ->
            Finish = [Label||{Label, _} <- Condition, ?status_unfinish =:= Label],
            Claim = [Label||{Label, _} <- Condition, ?status_unclaimed =:= Label],
            case erlang:length(Finish) =:= 1 andalso erlang:length(Claim) =:= 0 of
                false -> Role;
                true ->
                    CondProgress = medal_mgr:get_cur_medal_cond(Role),
                    case lists:keyfind(skill, #medal_cond.label, CondProgress) of
                        #medal_cond{} ->
                            vip:set_discount_mail(juan_zou, Role);
                        _ -> Role
                    end
            end
    end.
 
%%二次封测期间使用，删档后不使用
% get_pass(0) ->
%     lists:seq(10000, 10013);
% get_pass(Cur_medal_id) ->
%     lists:seq(10000, Cur_medal_id - 1).

% send_refresh(ConnPid, {Next, Cur_rep, Need2, Gain}) ->
%     case Next == 0 of 
%         true -> 
%             sys_conn:pack_send(ConnPid, 13060, {Next, Cur_rep, Need2, Gain, 1,  medal:get_finish_cond()});
%         false ->
%             sys_conn:pack_send(ConnPid, 13060, {Next, Cur_rep, Need2, Gain, 1, medal:get_init_cond()})
%     end.

add_attr_role(Role, Medal_id) ->
    case medal_data:get_medal_special(Medal_id) of 
        {false, _} ->
            Role;
        {ok, #medal_special{attr = Attr}} ->
            {ok, NRole} = role_attr:do_attr(Attr, Role),
            role_api:push_attr(NRole),
            NRole
    end.



%% 获取勋章开启的试炼场id
get_dungeon(Gain) ->
    do_get_dungeon(Gain, []).
do_get_dungeon([], L) ->L;
do_get_dungeon([H|Gain], L)->
    {ok, #medal_base{dungeon = Dun}} = medal_data:get_medal_base(H),
    do_get_dungeon(Gain, [Dun|L]).


%% 获取某一页的数据
get_certain_page_data(PageIndex,Data) ->
    OffsetStart = (PageIndex - 1) * ?page_num + 1, %% 从1开始
    OffsetEnd = OffsetStart + ?page_num,
    PageData = do_page(Data, OffsetStart, OffsetEnd, 1, []),
    lists:reverse(PageData).


%% 获取某一页数据
do_page([], _OffsetStart, _OffsetEnd, _Index,T) -> T;
do_page(_, _OffsetStart, OffsetEnd, OffsetEnd,T) -> T;
do_page([Data | T], OffsetStart, OffsetEnd, Index, Temp) ->
    case OffsetStart =< Index of
        true ->
            do_page(T, OffsetStart, OffsetEnd, (Index + 1),[Data|Temp]);    
        false ->
            do_page(T, OffsetStart, OffsetEnd, (Index + 1),Temp)
    end.


get_key(hp_max) ->1;
get_key(mp_max) ->2;
get_key(dmg) ->3;
get_key(defence) ->4;
get_key(critrate) ->5;
get_key(tenacity) ->6;
get_key(hitrate) ->7;
get_key(evasion) ->8;
get_key(js) ->9;
get_key(aspd) ->10;
get_key(dmg_magic) ->10;
get_key(resist) ->11;
get_key(_) -> 0.

deal_award([], Role, Rest) -> 
    {Role, Rest};
deal_award([{stone, Num}|T], Role, Rest) ->
    {ok, NRole} = role_gain:do([#gain{label = stone, val = Num}], Role),
    log:log(log_stone, {<<"试炼场礼包">>, <<"试炼场礼包">>, Role, NRole}),
    deal_award(T, NRole, Rest);
deal_award([{coin, Num}|T], Role, Rest) ->
    {ok, NRole} = role_gain:do([#gain{label = coin, val = Num}], Role),
    log:log(log_coin, {<<"试炼场礼包">>, <<"试炼场礼包">>, Role, NRole}),
    deal_award(T, NRole, Rest);
deal_award([{gold_bind, Num}|T], Role, Rest) ->
    {ok, NRole} = role_gain:do([#gain{label = gold_bind, val = Num}], Role),
    deal_award(T, NRole, Rest);
deal_award([{item, [BaseId, Bind, Num]}|T], Role, Rest) ->
    Gain = [#gain{label = item, val = [BaseId, Bind, Num]}],
    case role_gain:do(Gain, Role) of 
        {ok, NRole} ->
            deal_award(T, NRole, Rest);
        _ ->
            deal_award(T, Role, Gain ++ Rest)
    end.


    




