%%----------------------------------------------------
%% 后台活动 手工配置隐藏类型后台活动 
%% 注意：此模块热更需要执行 campaign_adm:reload() 才能生效
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(campaign_adm_data).
-export([
        list/0
        ,spring_festive_time/0
        ,spring_festive_loss_gold_base/0
    ]).
-include("common.hrl").
-include("campaign.hrl").

-define(camp_adm_count, 101).   %% 第几次活动 每次活动累加1 如上次活动用100 则这次活动用101 用来生成唯一ID

%% 活动时间控制
camp_time() ->
    {util:datetime_to_seconds({{2013, 4, 13}, {0, 0, 1}}), util:datetime_to_seconds({{2013, 4, 18}, {23, 59, 59}})}.

%% 春节活动时间控制
spring_festive_time() ->
    {util:datetime_to_seconds({{2013, 2, 7}, {0, 0, 0}}), util:datetime_to_seconds({{2013, 2, 25}, {23, 59, 59}})}.

%% 春节活动每天消耗多少晶钻可以获得奖励
spring_festive_loss_gold_base() ->
    1888.

%% 手工配置后台活动
list() ->
    {StartTime, EndTime} = camp_time(),
    Now = util:unixtime(),
    case Now >= StartTime andalso Now < EndTime of 
        true -> %% 活动没开始 或 活动没结束
            [
                #campaign_total{
                    id = ?camp_adm_count
                    ,name = <<"手工配置后台总活动">>
                    ,ico = <<"hide">>
                    ,start_time = StartTime
                    ,end_time = EndTime
                    ,camp_list = [
                        #campaign_adm{
                            id = ?camp_adm_count
                            ,title = <<"手工配置后台活动">>
                            ,start_time = StartTime
                            ,end_time = EndTime
                            ,conds = list_conds()
                        }
                    ]
                }
            ];
        _ ->
            []
    end.

%% 所有活动类型
%% 充值类型需要 type = ?camp_type_pay
%% 其他类型可只设置 sec_type = ??
%% conds 配置方式可参考 campaign_cond 模块 确保结果为list()
list_conds() ->
    Id = ?camp_adm_count * 1000, %% 每批次活动默认不会超过1000个活动需求
    [
        %%#campaign_cond{id = Id + 1, sec_type = ?camp_type_play_task_xx_double, settlement_type = ?camp_settlement_type_all, reward_num = 0, items = [], msg = <<"紫色修行任务双倍奖励">>, conds = [{task_xx, 3}]}
        %%,#campaign_cond{id = Id + 2, sec_type = ?camp_type_play_task_xx_double, settlement_type = ?camp_settlement_type_all, reward_num = 0, items = [], msg = <<"橙色修行任务双倍奖励">>, conds = [{task_xx, 4}]}
        
        #campaign_cond{id = Id + 5, type = ?camp_type_gold, sec_type = ?camp_type_gold_pet_egg_each, button = ?camp_button_type_mail, settlement_type = ?camp_settlement_type_all, reward_num = 0, items = [{33249, 1, 1}], msg = <<"刷宠物蛋每消耗200晶钻">>, conds = [{loss_gold_each, 200}], mail_subject = <<"收集富贵，超级兑换">>, mail_content = <<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持，四月回馈活动期间您刷新宠物蛋消费200晶钻，获得【富贵金叶】*1，请注意查收！收集一定数量【富贵金叶】还能在活动面板兑换超级奖励哦！谢谢您的支持，祝您游戏愉快！">>}
        %% ,#campaign_cond{id = Id + 3, type = ?camp_type_pay, sec_type = ?camp_type_pay_acc, settlement_type = ?camp_settlement_type_all, reward_num = 0, items = [], msg = <<"累计充值1000晶钻">>, conds = [{pay_acc, 1000, 0}], mail_subject = <<"累计充值，奖励多多">>, mail_content = <<"你累计充值已达1000晶钻，获得下列奖励，请查收！">>}
    ].
