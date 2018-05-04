
%% 帮战阵型
-define(guild_war_union_attack, 1).
-define(guild_war_union_defend, 2).

%% 帮战进度
-define(guild_war_status_sign, 1).      %% 报名阶段
-define(guild_war_status_prepare, 2).   %% 准备阶段
-define(guild_war_status_war1, 3).      %% 帮战的第一阶段
-define(guild_war_status_war2, 4).      %% 帮战的第二阶段
-define(guild_war_status_round_over, 5).%% 回合结束，攻守互换
-define(guild_war_status_over, 6).      %% 帮战结束
-define(guild_war_status_idel, 7).      %% 非帮战时间

%% 积分规则
-define(guild_war_credit_combat, 10).
-define(guild_war_credit_combat_lost, 3).
-define(guild_war_credit_combat_union, 1).
-define(guild_war_credit_stone, 30).
-define(guild_war_credit_sword, 50).
-define(guild_war_credit_hold, 2).
-define(guild_war_credit_guild_rate, 1).
-define(guild_war_credit_role_rate, 1).
-define(guild_war_credit_compete_0, 200).
-define(guild_war_credit_compete_1, 170).
-define(guild_war_credit_compete_2, 150).
-define(guild_war_credit_compete_3, 130).
-define(guild_war_credit_compete_4, 120).
-define(guild_war_credit_compete_lose_0, 100).
-define(guild_war_credit_compete_lose_1, 85).
-define(guild_war_credit_compete_lose_2, 75).
-define(guild_war_credit_compete_lose_3, 65).
-define(guild_war_credit_compete_lose_4, 60).
-define(guild_war_credit_compete_union_0, 800).
-define(guild_war_credit_compete_union_1, 600).
-define(guild_war_credit_compete_union_2, 500).
-define(guild_war_credit_compete_union_3, 300).
-define(guild_war_credit_compete_union_4, 200).

%% 晶石相关
-define(guild_war_elem_stone_hp, 1000).
-define(guild_war_elem_stone_hurt, 50).
-define(guild_war_elem_wait, 20).

%% 其它
-define(guild_war_sign_fund, 200). %% 报名资金
-define(guild_war_enter_fightlimit, 1800). %% 进入帮战战斗力限制
-define(guild_war_sign_guildlevellimit, 5). %% 帮会报名帮战等级限制
-define(guild_war_winner_buffer, guild_war_winer). %% 帮战胜利帮会的buff

%% 奖励
-define(guild_war_reward_winRole, [{29118, 1, 1}]).
-define(guild_war_reward_lostRole, [{29119, 1, 1}]).
-define(guild_war_reward_winGuild, [{29114, 1, 3}, {25021, 1, 5}]).
-define(guild_war_reward_lostGuild, [{29115, 1, 3}, {25021, 1, 3}]).

-define(record_to_list(Name, R), lists:zip(record_info(fields, Name), tl(tuple_to_list(R)))).

-define(is_attacker(Union, Flag), 
            case {Union, Flag} of
                    {?guild_war_union_attack, ?false} ->
                        true;
                    {?guild_war_union_defend, ?true} ->
                        true;
                    _ ->
                        false
            end
).

%% 联盟名称
-define(guild_war_union_name(Union), 
    case Union of 
        ?guild_war_union_attack -> language:get(<<"白盟">>);
        _ -> language:get(<<"红盟">>)
    end
).

%% 主将赛各队的名称
-define(guild_war_compete_name(TeamNo),
    case TeamNo of
        0 ->
            language:get(<<"主将队">>);
        1 ->
            language:get(<<"副将队">>);
        2 ->
            language:get(<<"三将队">>);
        3 ->
            language:get(<<"四将队">>);
        _ ->
            language:get(<<"五将队">>)
    end
).

%% 对方联盟
-define(guild_war_opp_union(Union), 
    case Union of
        ?guild_war_union_attack ->
            ?guild_war_union_defend;
        _ ->
            ?guild_war_union_attack
    end
).

%% for test debut
-define(debug_log(P), ?DEBUG("type=~w, value=~w", P)).
%%-define(debug_log(P), ok).

%% 联盟
-record(guild_war_union, {
            hold_time = 0,          %% 占领圣地的时间
            credit_combat = 0,      %% 战斗积分
            credit_compete = 0,     %% 主将赛积分
            credit = 0,             %% 总积分
            guild_count = 0,        %% 参战的帮会数
            realm = 0               %% 阵营
}).

%% 帮战进程的状态数据
%% 由于在帮战中，进攻与防守是会对调的，所以注释提到的进攻方、防守方针对开战时的
-record(guild_war, {
            guilds = []            %% 参加帮战的帮会 [#guild_war_guild{} | ...]
            ,owner = undefined      %% 圣地所属的帮会
            ,roles = []             %% 参加帮战的玩家 [#guild_war_role{} | ...]
            ,dead_roles = []        %% 记录被击杀的用户，用于计算进入正式区的cd
            ,opp_flag = 0           %% 进攻与防守是否对调了
            ,status                 %% 目前帮战的进度
            ,start_time             %% 帮战回合开启的时间
            ,defend_union = #guild_war_union{}          %% 防守联盟
            ,attack_union = #guild_war_union{}          %% 进攻联盟
            ,defend_prepare_map     %% 防守方的准备区
            ,attack_prepare_map     %% 进攻方的准备区
            ,war_map                %% 帮战地图
            ,elem_pid = 0           %% 帮战地图元素进程
            ,compete_pid = 0        %% 主将赛进程
            ,compete_teams = []     %% 参加主将赛的队伍
            ,is_first = false       %% 是否为首次帮战
            ,winner_union           %% 胜利联盟，1为进攻方，2为防守方
            ,winner_guild           %% 胜利帮会
    }).

%% 参加帮战的帮会
-record(guild_war_guild, {
        pid = 0                     %% 帮会进程id
        ,id                         %% 帮会id
        ,name                       %% 帮会名称
        ,realm                      %% 阵营
        ,union                      %% 联盟
        ,roles_count = 0            %% 在帮战中的人数
        ,credit = 0                 %% 帮会积分
        ,credit_compete = 0         %% 主将赛积分
        ,credit_combat = 0          %% 杀敌数积分
        ,credit_stone = 0           %% 破坏晶石的积分
        ,credit_sword = 0           %% 封印神剑的积分
        ,is_union_chief             %% 是否为联盟首领
        ,last_credit = 0            %% 上一场的积分
    }).

%% 参加帮战的玩家
-record(guild_war_role, {
        pid = 0         %% 玩家进程id
        ,id             %% 玩家id
        ,name           %% 玩家名称
        ,guild_id       %% 所在帮会
        ,guild_name     %% 所在帮会的名称
        ,position       %% 帮会职位
        ,union          %% 联盟
        ,credit = 0     %% 总积分
        ,lev = 0        %% 玩家等级
        ,credit_compete = 0 %% 主将赛积分
        ,credit_combat = 0  %% 杀敌数
        ,credit_stone = 0   %% 破坏晶石的积分
        ,credit_sword = 0   %% 封印神剑的积分
        ,credit_dead = 0    %% 被杀死的次数, 暂时不使用
        ,is_online      %% 是否在线
        ,is_inwar       %% 是否在帮战中，退出帮战为 ?false
        ,is_compete = ?false     %% 是否参加了主将赛
        ,realm = 0              %% 阵营
    }).

