%% ---------------------  宝石系统  ------------------------

-record(hole, {
        pos         %% 孔位置
        ,item_id    %% 孔上的物品
        ,have_cd    %% 此孔是否有CD中，?false-不有，?true-有
    }
).

-record(hole_col, {
        last_time = 0   %% 
        ,cd_time = 0    %% CD 时间
        ,holes = [
                    #hole{pos=1,item_id=0, have_cd=0},
                    #hole{pos=2,item_id=0, have_cd=0}, 
                    #hole{pos=3,item_id=0, have_cd=0},
                    #hole{pos=4,item_id=0, have_cd=0}, 
                    #hole{pos=5,item_id=0, have_cd=0}
                ]     %% 孔信息  [{#hole}]
    }
).

-record(manor_npc, {
        id = 0          %% npc ID
        ,is_new = 1     %% 1-新的， 0-旧的
    }
).

%% --------------------  宝石 ----------------------------------
-record(manor_baoshi, {
        baoshi_npc = [
                        #manor_npc{id=1001,is_new=1}
                    ]                 %% [ #baoshi_npc{} | ]
        ,hole_col = #hole_col{}         %% 宝石栏
    }
).

%% ------------------------ 魔药炼制 ----------------------------
-record(material,
    {
        id          %% 原材料ID
        ,num        %% 原材料数量
    }
).

-record(has_eat_yao, { %% 已喝药
        id          %% 药ID
        ,num        %% 已喝数量
    }).

-record(manor_moyao, {
        material_npc = [
                        #manor_npc{id=1007,is_new=1}
                    ]
        ,hole_col = #hole_col{}         %% 生成材料栏
        ,material = []                  %% 生成的原材料 [#material{} | #material{}]
        ,has_eat_yao = []               %% 已喝药 [#has_eat_yao{} | #has_eat_yao{}]
    }
).

%% -------------------------- 庄园行商 ---------------------------
-record(manor_trade, {
         has_npc = [
                        #manor_npc{id=1012,is_new=1}
                    ]
        ,trade_time = 0     %% 跑商时间
        ,has_cd = 0         %% 是否有CD
        ,has_gain = 0       %% 已经领了的份数
        ,trade_npc = 0      %% 0-代表当前没有进行跑商，否则为一个有效的NPC ID,以这个为标志玩家是否在行商
    }
).

%% ----------------  训龙精灵  -----------------------
-record(manor_train, {
          has_npc = [
                        #manor_npc{id=1018,is_new=1}
                    ]
            ,train_time = 0     %% 开始时间
            ,train_npc = 0      %% 训龙NPC
            ,has_gain = 0       %% 已经领的经验, NOTE：这个是份数来的,可以用来计算时间
    }
).

%% ----------------  庄园强化  -----------------------
-record(manor_enchant, {
          has_npc = [
                        #manor_npc{id=1021,is_new=1}
                    ]
    }
).

