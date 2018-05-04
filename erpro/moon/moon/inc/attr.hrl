%%----------------------------------------------------
%% 角色属性数据结构定义
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-define(attr_ver, 1).

%% 角色属性
-record(attr, {
        ver = ?attr_ver             %% 版本号
        %% ------战斗中
        ,dmg_magic = 0      %% 附加法术攻击
        ,dmg_ratio = 100    %% 攻击比率，单位：百分率
        ,def_magic = 0      %% 法术防御
        ,escape_rate = 100  %% 逃跑几率
        ,anti_escape = 70   %% 逃跑阻止几率(默认为70)
        ,hit_ratio = 1000   %% 命中修正，单位：千分率
        ,injure_ratio = 100 %% 伤害比率，被人攻击时受到伤害增加或减少，百分率
        %% ------显示属性
        ,fight_capacity = 1     %% 战斗力
        ,js = 1              %% 精神
        ,aspd = 1           %% 攻击速度
        ,dmg_min = 1        %% 最小攻击
        ,dmg_max = 1        %% 最大攻击
        ,defence = 0        %% 防御值
        ,hitrate = 950      %% 攻击命中率，单位:千分率
        ,evasion = 0        %% 闪躲率，单位:千分率
        ,critrate = 0       %% 暴击率，单位:千分率
        ,tenacity = 0       %% 坚韧，单位:千分率
        ,anti_attack = 0    %% 反击率
        ,anti_stun = 0      %% 抗眩晕
        ,anti_taunt = 0     %% 抗嘲讽
        ,anti_silent = 0    %% 抗沉默/遗忘
        ,anti_sleep = 0     %% 抗睡眠
        ,anti_stone = 0     %% 抗石化
        ,anti_poison = 0    %% 抗中毒
        ,anti_seal = 0      %% 抗封印

        ,resist_metal = 0   %% 金抗性
        ,resist_wood = 0    %% 木抗性
        ,resist_water = 0   %% 水抗性
        ,resist_fire = 0    %% 火抗性
        ,resist_earth = 0   %% 土抗性

        ,dmg_wuxing = 0      %% 金攻 %% 木攻 %% 水攻 %% 火攻 %% 土攻

        ,asb_metal = 0      %% 金吸收
        ,asb_wood = 0       %% 木吸收
        ,asb_water = 0      %% 水吸收
        ,asb_fire = 0       %% 火吸收
        ,asb_earth = 0      %% 土吸收

        ,enhance_stun = 0      %% 眩晕加强
        ,enhance_taunt = 0     %% 嘲讽加强
        ,enhance_silent = 0    %% 沉默/遗忘加强
        ,enhance_sleep = 0     %% 睡眠加强
        ,enhance_stone = 0     %% 石化加强
        ,enhance_poison = 0    %% 中毒加强
        ,enhance_seal = 0      %% 封印加强
    }
).

%% 职业初始属性值结构
-record(attr_base, {
        js = 0
        ,hp_max = 0
        ,mp_max = 0
        ,dmg_max = 0
        ,dmg_min = 0
        ,aspd = 0
        ,defence = 0
        ,critrate = 0
        ,evasion = 0
        ,hitrate = 0
        ,resist_metal = 0
        ,resist_wood = 0
        ,resist_water = 0
        ,resist_fire = 0
        ,resist_earth = 0
        ,anti_stun = 0
        ,anti_silent = 0
        ,anti_poison = 0
        ,anti_sleep = 0
        ,anti_stone = 0
        ,anti_taunt = 0
    }).

%% 职业成长属性结构
-record(attr_grow, {
        js = 0
        ,hp_max = 0
        ,mp_max = 0
        ,dmg = 0
        ,defence = 0
        ,critrate = 0
        ,evasion = 0
        ,hitrate = 0
        ,resist_all = 0 %% 新加的全坑，升级时，直接加到五个抗性中
    }).

%% 职业属性转换
-record(attr_convert, {
        js_mp = 0
    }).


