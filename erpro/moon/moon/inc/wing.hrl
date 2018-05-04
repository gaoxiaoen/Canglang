%%----------------------------------------------------
%% 翅膀相关系统数据结构
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-define(WING_VER, 1).

%% 角色翅膀数据
-record(wing, {
        ver = ?WING_VER
        ,skin_id = 0        %% 当前正在使用外观 物品基础ID
        ,skin_grade = 0     %% 当前正在使用外观等级
        ,skin_list = []     %% 当前拥有外观 [BaseId,...]
        ,items = []         %% 当前翅膀列表
        ,skill_coin = 0     %% 技能刷新幸运值(金币)
        ,skill_gold = 0     %% 技能刷新幸运值(晶钻)
        ,skill_tmp = []     %% 技能刷新列表 [#eqm_skill{},...]
        ,skill_bag = []     %% 技能背包列表 [#eqm_skill{},...]
        ,lingxidan = 0      %% 使用过的灵犀丹数量
    }
).

%% 装备技能数据
-record(eqm_skill, {
        id = 0              %% 唯一ID
        ,skill_id           %% 技能ID
    }
).

