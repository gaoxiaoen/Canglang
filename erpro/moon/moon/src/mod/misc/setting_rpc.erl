%% ------------------------------
%% 玩家个人设置模块处理
%% @author wpf (wprehard@qq.com)
%% ------------------------------
-module(setting_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("setting.hrl").
-include("npc_store.hrl").
-include("vip.hrl").
-include("lottery.hrl").
-include("guild.hrl").
-include("pet.hrl").
-include("arena_career.hrl").
-include("skill.hrl").
-include("lottery_secret.hrl").
-include("link.hrl").
%%
-include("assets.hrl").

%% 获取个人配置数据%%
handle(14100, {}, Role = #role{setting = #setting{plock = #plock{is_lock = IsLock, has_lock = HasLocked, q1 = Q1, q2 = Q2}}}) ->
    {reply, {looks:set_info(Role), IsLock, HasLocked, Q1, Q2}};

%% 外观显示开启
%%-------------------------------------

handle(14101, {[[8, Lock8], [7, Lock7], [6, Lock6], [5, Lock5], [4, Lock4], [2, Lock2], [1, Lock1]]}, Role = #role{setting = Setting = #setting{dress_looks = DressLooks}})
when (Lock1 =:= 1 orelse Lock1 =:= 0)
andalso (Lock2 =:= 1 orelse Lock2 =:= 0) 
andalso (Lock4 =:= 1 orelse Lock4 =:= 0)
andalso (Lock5 =:= 1 orelse Lock5 =:= 0)
andalso (Lock6 =:= 1 orelse Lock6 =:= 0) 
andalso (Lock7 =:= 1 orelse Lock7 =:= 0)
andalso (Lock8 =:= 1 orelse Lock8 =:= 0) ->
    case looks:open_cloth_look(Role, {Lock1, Lock2, Lock4, Lock5, Lock6, Lock7, Lock8}) of
        {skip, Role} ->
            NewDressLooks = DressLooks#dress_looks{dress = Lock1, weapon_dress = Lock2, all_looks = Lock4, mount_dress = Lock5, footprint = Lock6, chat_frame = Lock7, wing = Lock8},
            NewRole = Role#role{setting = Setting#setting{dress_looks = NewDressLooks}},
            {reply, {looks:set_info(NewRole), <<>>}, NewRole};
        {ok, NRole} ->
            map:role_update(NRole),
            NewDressLooks = DressLooks#dress_looks{dress = Lock1, weapon_dress = Lock2, all_looks = Lock4, mount_dress = Lock5, footprint = Lock6, chat_frame = Lock7, wing = Lock8},
            NewRole = NRole#role{setting = Setting#setting{dress_looks = NewDressLooks}},
            {reply, {looks:set_info(NewRole), ?L(<<"保存显示效果成功">>)}, NewRole}
    end;

%% 密码、保护锁相关
%%-------------------------------------
%% 生成锁
handle(14105, _, #role{setting = #setting{plock = #plock{has_lock = ?true}}}) -> {ok}; %% 已经有锁
handle(14105, _, #role{setting = #setting{plock = #plock{is_lock = ?true}}}) -> {ok}; %% 已经有锁
handle(14105, {P, Q1, Q2, A1, A2}, R = #role{setting = S = #setting{plock = #plock{log = Log}}}) ->
    case setting:check_lock_length(P, Q1, Q2, A1, A2) of
        {false, Msg} -> {reply, {?false, Msg, <<>>, <<>>}};
        true ->
            NewLog = [{14105, util:unixtime()} | lists:keydelete(14105, 1, Log)],
            {reply, {?true, ?L(<<"成功开启密码锁">>), Q1, Q2},
                R#role{setting = S#setting{plock = #plock{is_lock = ?true, has_lock = ?true, password = P, q1 = Q1, q2 = Q2, a1 = A1, a2 = A2, log = NewLog}}}}
    end;

%% 销毁锁
handle(14106, {_P, _A1, _A2}, #role{setting = #setting{plock = #plock{has_lock = ?false}}}) -> {ok};
handle(14106, {P, A1, A2}, R = #role{setting = S = #setting{plock = #plock{password = P, a1 = A1, a2 = A2, log = Log}}}) ->
    NewLog = [{14106, util:unixtime()} | lists:keydelete(14106, 1, Log)],
    NewR = R#role{setting = S#setting{plock = #plock{log = NewLog}}},
    {reply, {?true, ?L(<<"密码锁已删除">>)}, NewR};
handle(14106, {P, _A1, _A2}, #role{setting = #setting{plock = #plock{password = P}}}) ->
    {reply, {?false, ?L(<<"您输入的密保答案错误">>)}};
handle(14106, {_P, A1, A2}, #role{setting = #setting{plock = #plock{a1 = A1, a2 = A2}}}) ->
    {reply, {?false, ?L(<<"您输入的密码错误">>)}};
handle(14106, {_P, _A1, _A2}, _) ->
    {reply, {?false, ?L(<<"您输入的密码错误">>)}};

%% 开启锁
handle(14108, {}, R = #role{setting = S = #setting{plock = Plock = #plock{is_lock = ?false, has_lock = ?true, log = Log}}}) ->
    NewLog = [{14108, util:unixtime()} | lists:keydelete(14108, 1, Log)],
    {reply, {?true, ?L(<<"密码锁已开启">>)}, R#role{setting = S#setting{plock = Plock#plock{is_lock = ?true, log = NewLog}}}};
handle(14108, {}, #role{setting = #setting{plock = #plock{has_lock = ?false}}}) ->
    {reply, {?false, ?L(<<"您还没有设置锁">>)}}; %% 无锁
handle(14108, {}, #role{setting = #setting{plock = #plock{is_lock = ?true}}}) ->
    {reply, {?false, ?L(<<"您已经开启过锁了">>)}}; %% 已开

%% 解除锁
handle(14109, {P}, R = #role{setting = S = #setting{plock = Plock = #plock{is_lock = ?true, has_lock = ?true, password = P, log = Log}}}) ->
    NewLog = [{14109, util:unixtime()} | lists:keydelete(14109, 1, Log)],
    {reply, {?true, ?L(<<"密码锁已解除">>)}, R#role{setting = S#setting{plock = Plock#plock{is_lock = ?false, log = NewLog}}}};
handle(14109, {_P}, #role{setting = #setting{plock = #plock{is_lock = ?true, has_lock = ?true}}}) ->
    {reply, {?false, ?L(<<"您输入的密码错误">>)}};
handle(14109, {_P}, #role{setting = #setting{plock = #plock{has_lock = ?false}}}) ->
    {reply, {?false, ?L(<<"您还没有设置锁">>)}}; %% 无锁
handle(14109, {_P}, #role{setting = #setting{plock = #plock{is_lock = ?false}}}) ->
    {reply, {?false, ?L(<<"您已经解除锁了">>)}}; %% 已解
handle(14109, {_P}, _) ->
    {reply, {?false, ?L(<<"操作错误">>)}};

%% 修改密码
handle(14110, {P, Np}, R = #role{setting = S = #setting{plock = Plock = #plock{has_lock = ?true, password = P, log = Log}}}) ->
    case setting:check_password(Np) of
        {false, Msg} ->
            ?DEBUG("角色玩家修改密码检测出错：~s", [Msg]),
            {reply, {?false, Msg}};
        true ->
            NewLog = [{14110, util:unixtime()} | lists:keydelete(14110, 1, Log)],
            {reply, {?true, ?L(<<"修改成功">>)}, R#role{setting = S#setting{plock = Plock#plock{password = Np, log = NewLog}}}}
    end;
handle(14110, {_P, _Np}, #role{setting = #setting{plock = #plock{has_lock = ?true}}}) ->
    {reply, {?false, ?L(<<"您输入的密码错误">>)}};
handle(14110, {_P, _Np}, #role{setting = #setting{plock = #plock{has_lock = ?false}}}) ->
    {reply, {?false, ?L(<<"您还没有设置锁">>)}}; %% 无锁
handle(14110, {_P, _Np}, _) ->
    {reply, {?false, ?L(<<"您的操作错误">>)}};

%% 忘记密码
handle(14111, {A1, A2, Np}, R = #role{setting = S = #setting{plock = Plock = #plock{has_lock = ?true, a1 = A1, a2 = A2, log = Log}}}) ->
    case setting:check_password(Np) of
        true ->
            NewLog = [{14111, util:unixtime()} | lists:keydelete(14111, 1, Log)],
            {reply, {?true, ?L(<<"修改成功">>)}, R#role{setting = S#setting{plock = Plock#plock{password = Np, log = NewLog}}}};
        {false, Msg} -> {reply, {?false, Msg}}
    end;
handle(14111, {_A1, _A2, _Np}, #role{setting = #setting{plock = #plock{has_lock = ?true}}}) ->
    {reply, {?false, ?L(<<"您输入的密保答案错误">>)}};
handle(14111, {_, _, _}, #role{setting = #setting{plock = #plock{has_lock = ?false}}}) ->
    {reply, {?false, ?L(<<"您还没有设置锁">>)}}; %% 无锁
handle(14111, {_, _, _Np}, _) ->
    {reply, {?false, ?L(<<"您的操作错误">>)}};

%% 全局平台设置
handle(14112, {}, #role{}) ->
    State = platform_cfg:push_cfg(),
    ?DEBUG("~w",[State]),
    {reply, {State}};

%% 角色次数
handle(14113, {}, Role = #role{guild = #role_guild{claim_exp = GuildExpSwitch, salary = Salary}, lottery = #lottery{free = LotCount}, arena_career = #arena_career{free_count = ArenaCareer1, pay_count = ArenaCareer2}, money_tree = MoneyTree, secret = #secret{num = Num}, vip = Vip}) ->
    {{_, _, PetCount}, _} = pet:everyday_limit_log(?pet_log_type_free_egg, Role),
    {{_, UseTimes, TotalTimes}, _} = npc_store:find_today_log(?npc_store_refresh_sm, Role),
    StoreCount = TotalTimes - UseTimes,
    VipCount = case vip:check_reward(?vip_reward_gold_bind, Role) of
        {false, _} -> 0;
        {ok, _} -> 1
    end,
    {AlReadyBossCount, AllBossCount} = {0, 0},
    GuildExpCount = Salary, 
    XXTaskCount =  0,
    SLTaskCount = case guild_practise:get_count(Role) of
        SLCount when is_integer(SLCount) -> SLCount;
        _ -> 0
    end,
    {LevDunFinCount, LevDunCount} = {0, 0},
    MoneyTreeCount = lottery_tree:get_free_time(MoneyTree, Vip),
    SecretFree = lottery_secret:get_free_time(Num),
    Activity2Rewarded = 0,
    Activity2TotalReward = 0,
    List = {LotCount, PetCount, StoreCount, VipCount, 0, AlReadyBossCount, AllBossCount, GuildExpSwitch, GuildExpCount, XXTaskCount, SLTaskCount, LevDunFinCount, LevDunCount, ArenaCareer1+ArenaCareer2, MoneyTreeCount, Activity2Rewarded, Activity2TotalReward, SecretFree},
    ?DEBUG("List:~w",[List]),
    {reply, List};

%% 挂机技能栏
%%-------------------------------------
handle(14115, {}, #role{setting = #setting{skill = SkillShortcuts, hook_status = S11}}) ->
    {S1, S2, S3, S4, S5, S6, S7, S8, S9, S10}  = skill:record2tuple(SkillShortcuts),
    {reply, {S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11}};
%% 设置挂机技能列表
handle(14116, {0, Id2, Id3, Id4, Id5, Id6, Id7, Id8, Id9, Id10, S11}, Role = #role{setting = Setting}) when S11 =:= ?false orelse S11 =:= ?true ->
    Data = {0, Id2, Id3, Id4, Id5, Id6, Id7, Id8, Id9, Id10},
    {reply, {?true}, Role#role{setting = Setting#setting{skill = skill:tuple2record(Data), hook_status = S11}}};
handle(14116, {Id1, Id2, Id3, Id4, Id5, Id6, Id7, Id8, Id9, Id10, S11}, Role = #role{skill = #skill_all{skill_list = SkillList}, setting = Setting}) when S11 =:= ?false orelse S11 =:= ?true  ->
    Data = {Id1, Id2, Id3, Id4, Id5, Id6, Id7, Id8, Id9, Id10},
    case skill:has_skill(Id1, SkillList) of
        true ->
            {reply, {?true}, Role#role{setting = Setting#setting{skill = skill:tuple2record(Data), hook_status = S11}}};
        false ->
            {reply, {?false}}
    end;

%% 经验封印
handle(14117, _, #role{lev = Lev}) when Lev < 69 ->
    {reply, {0, ?L(<<"还没到69级，不能使用该功能">>), 0, 0, 0, 0, 0}};
handle(14117, {?exp_seal_opt_read}, #role{setting = #setting{exp_seal = #exp_seal{status = Status, top = Top}}, assets = #assets{seal_exp = Exp}}) ->
    {reply, {1, <<>>, Status, Top, Exp, exp_seal_data:get_exp_seal_top(Top), exp_seal_data:get_exp_seal_cost(Top)}};
handle(14117, {Opt}, Role) when Opt > ?exp_seal_opt_read andalso Opt =< ?exp_seal_opt_release ->
    case setting:exp_seal(Opt, Role) of
        {false, Reply} ->
            {reply, Reply};
        {ok, Reply, NewRole} ->
            {reply, Reply, NewRole}
    end;

%%屏蔽
handle(14120, {Type}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case setting:set_shield(Type, Role) of
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            ok;
        {ok, NewRole} ->
            {reply, {1}, NewRole}
    end;

%%取消屏蔽
handle(14121, {Type}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case setting:cancel_shield(Type, Role) of
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            ok;
        {ok, NewRole} ->
            {reply, {1}, NewRole}
    end;

%% 容错匹配
handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.
