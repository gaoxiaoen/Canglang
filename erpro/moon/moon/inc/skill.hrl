%% ***************************
%% 技能相关数据
%% ***************************

-define(VER_SKILL, 4).

%% 技能相关的所有信息结构
-record(skill_all, {
        ver = ?VER_SKILL
        ,skill_list = []     %% 所有技能和阵法的list：[#skill{}, ...]
        %% ,skilled = []       %% 各个技能编号熟练度[{IdType, Val} | ...]
        ,lineup             %% 阵法选择 0:表示无阵法
        ,shortcuts          %% 快捷方式
        ,break_out = []     %% 技能突破丹[{IdType, Num}]
    }).

%% 目前技能每个等级对应一个唯一ID，暂定ID的设计原则:
%% 职业...技能序号...技能等级
%% 1...01...01
%% 6...01...02
%% 通用阵法较特殊，无职业序号，其处理只根据技能序号，所以需要保证每种技能序号的唯一性

%% 技能类型
-define(type_passive, 0).   %% 被动
-define(type_active, 1).    %% 主动
-define(type_assist, 2).  %% 辅助
-define(type_lineup, 3).    %% 阵法
-define(type_nuqi, 4).      %% 怒气技能
-define(type_nuqi_passive, 5). %% 怒气被动技能
-define(type_married, 10). %% 夫妻技能

%% 所有可学习技能,策划按照0-N级填写
%% 角色创建时预存的技能列表在此处初始化，全部以0级形式;
%% 角色的技能还没有学习时，是保存为0级的；战斗时获取技能时，如果无已学习技能，则提供[]

%% 各职业普攻技能id
-define(normal_atk_skill_zhenwu,    110001).
-define(normal_atk_skill_cike,      210001).
-define(normal_atk_skill_xianzhe,   310001).
-define(normal_atk_skill_feiyu,     410001).
-define(normal_atk_skill_qishi,     510001).
-define(normal_atk_skill_xinshou,   610001).

%% 基础技能
-define(skill_defence, 720001).  %% 防御
-define(skill_item, 720101).    %% 使用物品
-define(skill_escape, 720201).      %% 逃跑
-define(skill_attack, 1000).      %% 一般近程攻击(宠物，怪物，反击，反弹)
-define(skill_remote, 1001).      %% 一般远程攻击(宠物，怪物)
-define(skill_common, 1000).      %% 通用动作技能
-define(skill_relive, 720301).      %% 复活

-define(skill_base, ?skill_defence, ?skill_item, ?skill_escape).

%% 获取初始可升级技能列表（主动、被动、阵法、怒气）
-define(skill_zhenwu, []).
-define(skill_cike, [?skill_base, 210001, 210100, 210200, 210300, 210400, 220500, 200600, 200700, 200800, 200900, 201000]).
-define(skill_xianzhe, [?skill_base, 310001, 310100, 310200, 310300, 310400, 320500, 300600, 300700, 300800, 300900, 301000]).
-define(skill_feiyu, []).
-define(skill_qishi, [?skill_base, 510001, 510100, 510200, 510300, 510400, 520500, 500600, 500700, 500800, 500900, 501000]).
-define(skill_xinshou, [?skill_base, 610001]).

%% 怒气技能
-define(nuqi_zhenwu, [18000, 18100, 18200, 18300, 18400, 18500, 18600]).
-define(nuqi_cike, [28000, 28100, 28200, 28300, 28400, 28500, 28600]).
-define(nuqi_xianzhe, [38000, 38100, 38200, 38300, 38400, 38500, 38600]).
-define(nuqi_feiyu, [48000, 48100, 48200, 48300, 48400, 48500, 48600]).
-define(nuqi_qishi, [58000, 58100, 58200, 58300, 58400, 58500, 58600]).
-define(nuqi_xinshou, []).
%% 怒气天赋
-define(nuqi_passive_zhenwu, [18700]).
-define(nuqi_passive_cike, [28700]).
-define(nuqi_passive_xianzhe, [38700]).
-define(nuqi_passive_feiyu, [48700]).
-define(nuqi_passive_qishi, [58700]).
-define(nuqi_passive_xinshou, []).
%% 夫妻技能
-define(married_skills, [88000, 88100, 88200]).

%% 某些被动技能需要加载进入战场
%% 数值填技能序号
%% 2012/12/07 添加职业进阶技能
-define(filter_type_zhenwu, []).
-define(filter_type_cike, [9, 52]).
-define(filter_type_xianzhe, [6, 51]).
-define(filter_type_feiyu, [5, 9, 61, 63]).
-define(filter_type_qishi, [2, 9, 52, 50]).
-define(filter_type_xinshou, []).

%% 学习方式
-define(FROM_DIRECT, 1).
-define(FROM_BOOK, 2).

%% 技能残卷道具id
-define(skill_book_frag, 131001).

%% 技能基础属性结构
-record(skill, {
        id = 0
        ,skilled = 0        %% 当前技能拥有的熟练度
        ,id_type = 0        %% 角色所属职业技能序号(仅作技能升级标志，作为数据表主键之一)
        ,name = <<>>        %% 技能名称
        ,next_id = 0        %% 下等级技能ID，0表示已到最高级
        ,lev = 0            %% 技能等级
        ,cond_lev = 0       %% 角色等级需求
        ,cond_skilled = 0   %% 技能熟练度要求
        ,book_id = 0        %% 技能书ID
        ,cost_att = 0       %% 修为消耗
        ,cost_coin = 0      %% 金币消耗
        ,cost_item = 0      %% 物品消耗
        ,item_id = 0        %% 物品ID
        ,type = 0           %% 0-主动 1-被动 2-阵法
        ,attr = []          %% 技能属性，一般被动技能和阵法有对角色属性的加成
    }).

%% %% 阵法数据保存
%% -record(lineup, {
%%         use = 0             %% 当前队伍使用的阵法ID, 0:无阵法
%%         ,select = 0         %% 默认选择的阵法ID
%%     }).

%% 技能快捷栏编号范围
-define(INDEX_MIN, 1).
-define(INDEX_MAX, 10).

%% 技能快捷栏
-record(skill_shortcuts, {
        index_1 = 0         %% 第一格存放的技能ID
        ,index_2 = 0        %% 第二格存放的技能ID
        ,index_3 = 0
        ,index_4 = 0
        ,index_5 = 0
        ,index_6 = 0
        ,index_7 = 0
        ,index_8 = 0
        ,index_9 = 0
        ,index_10 = 0
    }).

