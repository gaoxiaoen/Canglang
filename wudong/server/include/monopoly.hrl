%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 七月 2016 上午11:04
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-define(DEFAULT_DICE_NUM, 10).  %%默认掷骰子次数
-define(CELL_NUM, 22).  %%格子数

-record(st_monopoly,{
    pkey = 0,
    act_id = 0,
    finish_times = 0,  %%完成圈数
    cell_list = [],  %%这一圈格子事件id列表
    step_history = [],  %%这一圈踩过的步数列表
    cur_step = 0,  %%当前步数
    cur_step_state = 0,  %%当前步数状态 1踩过 2已完成
    dice_num = 0,  %%总骰子次数
    use_dice_num = 0,  %%已使用骰子次数
    buy_dice_times = 0,  %%购买骰子次数
    update_time = 0,  %%更新时间
    gift_get_list = [],  %%圈数礼包领取列表
    task_list = []  %%任务状态列表 [#m_task{}]
}).

-record(m_task,{
    id = 0,
    do_times = 0,
    state = 0  %%0未完成 1已完成 2已领取
}).

%%大富翁格子事件
-record(base_monopoly,{
    id = 0,  %%格子事件id
    type = 0,  %%事件类型 1获得绑定银币 2再抛一次 3损失绑定银币 4获得绑定元宝 5位置转移 6猜拳 7招财卡 8起点
    args = [],  %%参数
    times = 0,
    msg = ""  %%获奖说明
}).

%%掷骰子点数概率
-record(base_monopoly_pro,{
    num = 0,  %%点数
    pro = 0   %%概率
}).


%%获取骰子任务
-record(base_monopoly_task,{
    id = 0,  %%任务id
    times = 0,  %%完成次数
    get_num = 0,  %%获得骰子数量
    msg = ""   %%任务描述
}).