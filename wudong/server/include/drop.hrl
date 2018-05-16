%%掉落库
-record(drop_pool, {
    poolid = 0,         %掉落库id
    type = 0,            %掉落库类型 0放回 1不放回
    id = 0,              %掉落项id
    goodstype = 0,       %物品类型id
    num = 0,             %物品数量
    random_wash_num = 0, %随机洗练的属性
    fixed_wash_attr = [],%固定洗练的属性
    fix_attribute_color = [],%固定洗练的颜色
    ratio = 0,           %权重
    ratio_st = 0,        %权重开始位置
    ratio_et = 0,         %权重结束位置
    start_recv_time = 0   %物品开始领取时间，特殊功能加，跨服boss
}).


%%掉落规则
-record(drop_rule, {
    id = 0,                     %规则id
    career = [],                %职业条件
    lv = [],                    %等级条件
    hurtrank = [],              %伤害排行条件
    hurtorder = [],             %攻击顺序条件
    hurtperc = [],              %伤害百分比条件
    share = [],                 %%掉落场景共享
    task = [],                 %%任务物品
    desc = []                   %描述
}).

-record(drop_mon_info, {
    mon_id = 0,
    mon_boss = 0,
    mon_name = 0,
    mon_kind = 0,
    lv = 0,
    sid = 0,
    x = 0,
    y = 0,
    owner_key = 0
}).


%%掉落信息记录
-record(drop_info, {
    %%掉落规则信息
    career = 0,                 %职业
    lvdown = 0,                 %等级下限
    lvup = 0,                   %等级上限
    rank = 0,                   %伤害排名
    order = 0,                  %攻击顺序  -1忽略 0最后一刀
    perc = 0,                   %伤害百分比
    poolid = 0,                 %掉落包id
    num = 0,                    %掉落次数
    bind = 0,                   %0绑定1非绑2根据条件绑定
    where = 0,                  %0进包1掉地上
    share = 0,                  %是否共享可见0否1是
    is_hurt = 0,              %%是否需要伤害1是0否
    %%怪物掉落信息
    hurt = 0,                   %伤害
    total_hurt = 0,             %总伤害
    scene = 0,                  %掉落场景
    copy = 0,                   %副本id
    x = 0,                      %掉落坐标
    y = 0,                      %掉落坐标
    %%固定掉落
    drop_item = [],              %固定掉落列表
    mon = #drop_mon_info{}
}).


%%掉落物品
-record(drop_goods, {
    mid = 0,
    node = none,
    key = 0,                    %唯一key
    goodstype = 0,              %物品id
    num = 0,                    %物品数量
    args = [],                  %%特殊参数
    bindtype = 0,               %绑定条件
    droptime = 0,               %掉落时间
    expire = 0,                 %消失时间
    owner = 0,                  %所有者key
    from = 0,                   %产生来源
    hurt_share = [],             %%造成伤害获得捡取玩家key列表(无需则该列表为空)
    scene = 0, copy = 0, x = 0, y = 0
}).