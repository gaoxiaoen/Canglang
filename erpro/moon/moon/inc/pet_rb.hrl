%%---------------------------------------------
%% 宠物真身数据结构
%% @author weihua@jieyou.cn
%%---------------------------------------------
-record(pet_rb, {
        id = 0                  %% 真身ID
        ,name = <<>>            %% 真身名字
        ,type = 0               %% 真身品质 (0:普通 1:精良 2:优秀 3:完美)
        ,value = 0              %% 真身值
        ,status = 0             %% 激活状态
        ,card = 0               %% 对应真身卡ID
        ,image = 0              %% 形象ID
        ,desc = <<>>            %% 真身描述
        ,material = []          %% 需要材料 [{ItemId, ItemNum} | ..]
        ,attr = []              %% 属性加成 [{LabelId, Value} | ..]
    }
).
