%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, junhai
%%% @doc
%%%
%%% @end
%%% Created : 13. 二月 2015 11:43
%%%-------------------------------------------------------------------
-module(t_mail).
-author("fzl").
-include("common.hrl").

%% API
-export([
    get/1,
    mail_content/1
]).

get(Type) ->
    case Type of
        _ ->
            ?ERR("get mail text err ~p~n", [Type]),
            ""
    end.

mail_content(Type) ->
    case Type of
        1 ->
            Title = ?T("竞技场每日奖励"),
            Content = ?T("您今日竞技场排名第~p，获得排名奖励，请及时查收！"),
            {Title, Content};
        2 ->
            Title = ?T("世界boss击杀"),
            Content = ?T("您参与了世界boss击杀，获得奖励，请及时查收！"),
            {Title, Content};
        3 ->
            Title = ?T("仙盟战报名"),
            Content = ?T("您所在的仙盟可报名今天的仙盟战，为了仙盟！"),
            {Title, Content};
        4 ->
            Title = ?T("仙盟战奖励"),
            Content = ?T("您本次支持的势力排名是第~p名，您在本势力中排名第~p名;根据奖励规则您获得以下奖励:"),
            {Title, Content};
        5 ->
            Title = ?T("竞技场挑战"),
            Content = ?T("玩家~s在竞技场取代了你的位置，您的排名下落至~p"),
            {Title, Content};
        6 ->
            Title = ?T("背包空间不足"),
            Content = ?T("背包空间不足，奖励改由邮件发放，请及时查收！"),
            {Title, Content};
        7 ->
            Title = ?T("交易所物品超时"),
            Content = ?T("你在交易所上架的物品已经超时，请及时查收！"),
            {Title, Content};
        8 ->
            Title = ?T("交易所物品已经卖出"),
            Content = ?T("交易所物品已经卖出，请及时查收元宝！"),
            {Title, Content};
        9 ->
            Title = ?T("开服冲榜活动奖励"),
            Content = ?T("开服冲榜活动[~s]奖励，请及时查收！"),
            {Title, Content};
        10 ->
            Title = ?T("游戏充值"),
            Content = ?T("您充值~p元，获得月卡，另外获得~p元宝，赠送~p绑定元宝。"),
            {Title, Content};
        11 ->
            Title = ?T("游戏充值"),
            Content = ?T("您充值~p元，获得~p元宝，赠送~p绑定元宝。"),
            {Title, Content};
        12 ->
            Title = ?T("月卡福利"),
            Content = ?T("尊敬的月卡会员，恭喜你获得月卡每日福利200元宝，月卡剩余时间~p天。"),
            {Title, Content};
        13 ->
            Title = ?T("传说副本抢楼"),
            Content = ?T("玩家~s抢夺了您在传说副本第~p章节的楼层"),
            {Title, Content};
        14 ->
            Title = ?T("护送被劫"),
            Content = ?T("真是太可恶了！你在护送水晶的过程中被[~s]杀死了。你丢失了[~p]经验值，[~p]银币，下次记得买保险避免丢失喔！"),
            {Title, Content};
        15 ->
            Title = ?T("护送被劫"),
            Content = ?T("真是太可恶！你在护送水晶的过程中被[~s]杀死了。幸亏你买了保险，避免[~p]经验值，[~p]银币的丢失。下次也记得买保险喔！"),
            {Title, Content};
        16 ->
            Title = ?T("护送被劫"),
            Content = ?T("真是太可恶！你在护送水晶的过程中被[~s]杀死了。你已经在护送过程中被杀死超过两次，所以本次没有丢失经验和银币。你已累计丢失[~p]经验值，[~p]银币，下次记得买保险避免丢失喔！"),
            {Title, Content};
        17 ->
            Title = ?T("组队副本翻牌"),
            Content = ?T("恭喜你通关组队副本，翻牌奖励如下"),
            {Title, Content};
        18 ->
            Title = ?T("组队副本"),
            Content = ?T("恭喜你通关组队副本，奖励如下"),
            {Title, Content};
        19 ->
            Title = ?T("仙盟战"),
            Content = ?T("你所在的仙盟已经报名参加本次仙盟战,请到仙盟战界面查看相关信息。"),
            {Title, Content};
        20 ->
            Title = ?T("仙盟战称号"),
            Content = ?T("恭喜成为本次仙盟战杀人第一名，您已获得”疯狂杀戮“限时称号奖励，此称号将在24小时后消失，请在称号界面查看。"),
            {Title, Content};
        21 ->
            Title = ?T("仙盟战称号"),
            Content = ?T("恭喜成为本次仙盟战采集积分第一名，您已获得”挖掘机砖家“限时称号奖励，此称号将在24小时后消失，请在称号界面查看。"),
            {Title, Content};
        22 ->
            Title = ?T("仙盟战称号"),
            Content = ?T("恭喜成为本次仙盟战总积分第一名，您已获得”圣域英雄“限时称号奖励，此称号将在24小时后消失，请在称号界面查看。"),
            {Title, Content};
        23 ->
            Title = ?T("您已加入仙盟"),
            Content = ?T("~s已经同意您的仙盟申请,赶紧去仙盟贡献吧! ps:为了仙盟和谐,请不要频繁更换仙盟,否则有惩罚哦！"),
            {Title, Content};
        24 ->
            Title = ?T("仙盟被踢出"),
            Content = ?T("非常遗憾,您已经被~s踢出仙盟"),
            {Title, Content};
        25 ->
            Title = ?T("猎场奖励"),
            Content = ?T("您完成了猎场任务,获得奖励,请查收"),
            {Title, Content};
        26 ->
            Title = ?T("猎场boss击杀"),
            Content = ?T("您参与了猎场boss击杀，获得奖励，请及时查收！"),
            {Title, Content};
        27 ->
            Title = ?T("仙盟会长"),
            Content = ?T("恭喜您成为此仙盟的会长,仙盟战功能已开启，欢迎您的仙盟能参加仙盟战!参加仙盟战可获得功勋和珍稀道具哦!"),
            {Title, Content};
        28 ->
            Title = ?T("战场奖励"),
            Content = ?T("您本次战场排名第~p名;根据奖励规则您获得以下奖励:"),
            {Title, Content};
        29 ->
            Title = ?T("仙盟任务排行奖励"),
            Content = ?T("您今日完成了~p个仙盟任务,排行~p;根据奖励规则您获得以下奖励:"),
            {Title, Content};
        30 ->
            Title = ?T("你被玩家击杀了"),
            Content = ?T("你在~s被~s的~s击杀了。赶快提升战力，约个地方和TA再干一架！"),
            {Title, Content};
        31 ->
            Title = ?T("你被玩家击杀了"),
            Content = ?T("你在~s被~s击杀了。赶快提升战力，约个地方和TA再干一架！"),
            {Title, Content};
        32 ->
            Title = ?T("仙盟副本"),
            Content = ?T("您挑战了仙盟副本,获得挑战奖励,请查收"),
            {Title, Content};
        33 ->
            Title = ?T("仙盟副本"),
            Content = ?T("恭喜您通过仙盟副本第~p关，您本次仙盟排名为第~p名，获得以下奖励，请及时查收；伤害排名获奖规则详见仙盟副本《规则》"),
            {Title, Content};
        34 ->
            Title = ?T("仙盟副本"),
            Content = ?T("您有未领取的仙盟副本通关奖励，请及时查收；"),
            {Title, Content};
        35 ->
            Title = ?T("趣味答题"),
            Content = ?T("恭喜您在本次答题中取得第~p名，获得以下奖励，请及时查收"),
            {Title, Content};
        36 ->
            Title = ?T("副本掉落"),
            Content = ?T("你通关了副本,有未捡取的掉落物品,请及时查收!"),
            {Title, Content};
        37 ->
            Title = ?T("竞技场挑战"),
            Content = ?T("玩家~s在竞技场取代了你的位置,您的排名下落"),
            {Title, Content};
        38 ->
            Title = ?T("跨服巅峰争霸赛"),
            Content = ?T("您参加了本期争霸赛,获得~p积分,排名~p,获得奖励,请查收"),
            {Title, Content};
        39 ->
            Title = ?T("仙盟boss参与奖励"),
            Content = ?T("您参与了击杀仙盟boss,获得奖励,请查收!"),
            {Title, Content};
        40 ->
            Title = ?T("野外boss击杀"),
            Content = ?T("您参与了野外boss击杀，获得奖励，请及时查收！"),
            {Title, Content};
        41 ->
            Title = ?T("世界boss奖励"),
            Content = ?T("您参与了世界boss击杀，伤害输出~p,排名~p;获得奖励，请及时查收！"),
            {Title, Content};
        42 ->
            Title = ?T("跨服pk奖励"),
            Content = ?T("恭喜你所在的阵营在跨服对决活动中获得胜利,你的积分~p,排名~p，这是你的奖励，请查收，祝游戏愉快！"),
            {Title, Content};
        43 ->
            Title = ?T("跨服pk奖励"),
            Content = ?T("很遗憾！你所在的阵营在跨服对决活动中失败了,你的积分~p,排名~p，这是你的奖励，请查收，祝游戏愉快！！"),
            {Title, Content};
        44 ->
            Title = ?T("跨服竞技场每日奖励"),
            Content = ?T("您今日跨服竞技场排名第~p,获得排名奖励，请及时查收！"),
            {Title, Content};
        45 ->
            Title = ?T("跨服消消乐奖励"),
            Content = ?T("您参加了消消乐,赢得胜利!获得奖励，请及时查收！"),
            {Title, Content};
        46 ->
            Title = ?T("跨服消消乐周奖励"),
            Content = ?T("您本周消消乐排名~p,获得奖励，请及时查收！"),
            {Title, Content};
        47 ->
            Title = ?T("跨服消消乐奖励"),
            Content = ?T("您参加了消消乐,失败了!获得奖励，请及时查收！"),
            {Title, Content};
        48 ->
            Title = ?T("攻城战竞价"),
            Content = ?T("您所在的仙盟竞价攻城战获得防守权,请留意攻城战活动开启时间,期待您的参与!"),
            {Title, Content};
        49 ->
            Title = ?T("攻城战竞价"),
            Content = ?T("您所在的仙盟竞价攻城战获得进攻权,请留意攻城战活动开启时间,期待您的参与!"),
            {Title, Content};
        50 ->
            Title = ?T("攻城战竞价"),
            Content = ?T("您所在的仙盟竞价攻城战失败,您所在的仙盟可以报名支援!竞价资金退还,期待您的参与!"),
            {Title, Content};
        51 ->
            Title = ?T("攻城战奖励"),
            Content = ?T("您所在的仙盟获得攻城战胜利,获得奖励,请查收!"),
            {Title, Content};
        52 ->
            Title = ?T("攻城战奖励"),
            Content = ?T("您所在的仙盟获得攻城战失败,获得奖励,请查收"),
            {Title, Content};
        53 ->
            Title = ?T("天天任务奖励"),
            Content = ?T("勇者，你昨天漏领的天天任务奖励，奴家给你送过来啦,请查收"),
            {Title, Content};
        54 ->
            Title = ?T("仙盟弹劾取消"),
            Content = ?T("你发起了弹劾仙盟会长,由于24小时内会长上线,弹劾取消,费用退还,请查收!"),
            {Title, Content};
        55 ->
            Title = ?T("弹劾申请"),
            Content = ?T("由于你三天都不在线，你的仙盟成员~s发起了弹劾会长申请!"),
            {Title, Content};
        56 ->
            Title = ?T("仙盟弹劾取消"),
            Content = ?T("你发起了弹劾仙盟会长,由于你退出了工会,费用退还,请查收!"),
            {Title, Content};
        57 ->
            Title = ?T("弹劾申请"),
            Content = ?T("由于你一直不在线，你的仙盟成员~s发起了弹劾会长申请成为新会长，你降至为普通会员!"),
            {Title, Content};
        58 ->
            Title = ?T("攻城战奖励"),
            Content = ?T("您参与了攻城战获得胜利,获得勋章奖励,请查收"),
            {Title, Content};
        59 ->
            Title = ?T("仙盟签到奖励"),
            Content = ?T("你今日仙盟签到获得奖励,请查收"),
            {Title, Content};
        60 ->
            Title = ?T("全民夺宝"),
            Content = ?T("您购买了全民夺宝~p第~p期,该期的中奖号码为~p,很遗憾您的号码没有中奖,获得安慰奖励(温馨提示购买次数越多,中奖概率越高的哦)"),
            {Title, Content};
        61 ->
            Title = ?T("全民夺宝"),
            Content = ?T("您购买了全民夺宝~p第~p期,该期的中奖号码为~p,恭喜你中奖啦,祝您游戏愉快!"),
            {Title, Content};
        62 ->
            Title = ?T("藏宝阁奖励"),
            Content = ?T("您未领取的第~p天藏宝阁奖励已发放到邮件，请注意查收!"),
            {Title, Content};
        63 ->
            Title = ?T("跨服巅峰目标奖励"),
            Content = ?T("你巅峰塔积分达到~p,获得奖励,请查收"),
            {Title, Content};
        64 ->
            Title = ?T("跨服巅峰目标奖励"),
            Content = ?T("你巅峰塔进入~p层,获得奖励,请查收"),
            {Title, Content};
        65 ->
            Title = ?T("跨服巅峰秘宝"),
            Content = ?T("你占领了巅峰宝藏,获得奖励,请查收"),
            {Title, Content};
        66 ->
            Title = ?T("跨服巅峰战场"),
            Content = ?T("恭喜你成为首位登顶的玩家,获得奖励,请查收"),
            {Title, Content};
        67 ->
            Title = ?T("第~s名帮主奖励"),
            Content =
                case version:get_lan_config() of
                    vietnam ->
                        ?T("恭喜您，带领您的仙盟 ~s 在~s获得了第 ~s 名，您获得的盟主奖励如下：");
                    _ ->
                        ?T("恭喜您，带领您的仙盟 ~s 在~p年~p月~p日获得了第 ~s 名，您获得的盟主奖励如下：")
                end,
            {Title, Content};
        68 ->
            Title = ?T("第~s名帮派成员"),
            Content =
                case version:get_lan_config() of
                    vietnam ->
                        ?T("恭喜您，您的仙盟 ~s 在~s获得了第 ~s 名，您获得参与奖励如下：");
                    _ ->
                        ?T("恭喜您，您的仙盟 ~s 在~p年~p月~p日获得了第 ~s 名，您获得参与奖励如下：")
                end,
            {Title, Content};
        69 ->
            Title = ?T("~s榜奖励"),
            Content = ?T("恭喜您获得 ~s 榜第 ~p 名,获得奖励如下："),
            {Title, Content};
        70 ->
            Title = ?T("系统邮件"),
            Content = ?T("很遗憾，~s帮派拒绝了您的申请"),
            {Title, Content};
        71 ->
            Title = ?T("整点福利"),
            Content = ?T("为解上仙修炼的劳累，开发组特意准备了天材地宝汇聚而成的成长礼包，每日定时发送，望上仙早日恢复修为，重回九重天~"),
            {Title, Content};
        72 ->
            Title = ?T("每日登陆奖励"),
            Content = ?T("欢迎来到修仙世界~特奉上开服礼包一份，以助上仙更快提升修为。祝上仙在修仙世界里万事皆如意，朋友遍天下，所遇皆良缘~"),
            {Title, Content};
        73 ->
            Title = ?T("在线福利"),
            Content = ?T("修仙之路漫漫其修远，为慰解诸位上仙除魔卫道的辛劳，特奉上在线~p分钟奖励一份，以助上仙修炼，祝上仙武运昌隆！"),
            {Title, Content};
        74 ->
            Title = ?T("周卡福利"),
            Content = ?T("邮件：少侠，绑元礼包今日赠送100绑元。你的剩余领取天数：~p天"),
            {Title, Content};
        75 ->
            Title = ?T("跨服送花榜奖励"),
            Content = ?T("您在跨服送花榜排名~p,获得奖励, 请及时查收！<br/><br/>本次花榜前三名为:<br/><br/>"),
            {Title, Content};
        76 ->
            Title = ?T("跨服收花榜奖励"),
            Content = ?T("您在跨服收花榜排名~p,获得奖励, 请及时查收！<br/><br/>本次花榜前三名为:<br/><br/>"),
            {Title, Content};
        77 ->
            Title = ?T("游戏充值"),
            Content = ?T("您充值~p元的绑元礼包已经生效!"),
            {Title, Content};
        78 ->
            Title = ?T("符文塔每日奖励"),
            Content = ?T("亲，你挑战至 ~s ~p层，获得符文塔每日奖励："),
            {Title, Content};
        79 ->
            Title = ?T("每日充值奖励"),
            Content = ?T("您未领取的前1天每日首充奖励已发放到邮件，请注意查收！"),
            {Title, Content};
        80 ->
            Title = ?T("击杀信息"),
            Content = ?T("来自~s仙盟的~s刚刚击败了你，[#$a type=52 color=1]我要变强![#$/a]"),
            {Title, Content};
        81 ->
            Title = ?T("击杀信息"),
            Content = ?T("~s刚刚击败了你，[#$a type=52 color=1]我要变强![#$/a]"),
            {Title, Content};
        82 ->
            Title = ?T("跨服送花榜奖励"),
            Content = ?T("您在跨服送花榜未达到 ~p 名最低要求 ~p 朵, 获得第 ~p 名奖励, 请及时查收！"),
            {Title, Content};
        83 ->
            Title = ?T("跨服收花榜奖励"),
            Content = ?T("您在跨服收花榜未达到 ~p 名最低要求 ~p 朵, 获得第 ~p 名奖励, 请及时查收！"),
            {Title, Content};
        84 ->
            Title = ?T("消费排行榜奖励"),
            Content = ?T("恭喜您在 ~s 结束的消费排行榜中获得第 ~p，请及时查收！"),
            {Title, Content};
        85 ->
            Title = ?T("充值排行榜奖励"),
            Content = ?T("恭喜您在 ~s 结束的充值排行榜中获得第 ~p，请及时查收！"),
            {Title, Content};
        86 ->
            Title = ?T("跨服消费排行榜奖励"),
            Content = ?T("恭喜您在 ~s 结束的跨服消费排行榜中获得第 ~p，请及时查收！"),
            {Title, Content};
        87 ->
            Title = ?T("游戏充值"),
            Content = ?T("您充值~p元，获得~p元宝。"),
            {Title, Content};
        88 ->
            Title = ?T("返利邮件"),
            case version:get_lan_config() of
                fanti ->
                    Content = ?T("恭喜您獲得儲值返利優惠: ~p元寶返利 ~p%（~p元寶）"),
                    {Title, Content};
                _ ->
                    Content = ?T("恭喜您获得充值返利优惠: ~p元返利 ~p%（~p元宝）"),
                    {Title, Content}
            end;
        89 ->
            Title = ?T("跨服充值排行榜奖励"),
            Content = ?T("恭喜您在 ~s 结束的跨服充值排行榜中获得第 ~p，请及时查收！"),
            {Title, Content};
        90 ->
            Title = ?T("消费排行榜奖励"),
            Content = ?T("恭喜您在 ~s 结束的消费排行榜中获得参与奖，请及时查收！"),
            {Title, Content};
        91 ->
            Title = ?T("充值排行榜奖励"),
            Content = ?T("恭喜您在 ~s 结束的充值排行榜中获得参与奖，请及时查收！"),
            {Title, Content};
        92 ->
            Title = ?T("跨服消费排行榜奖励"),
            Content = ?T("恭喜您在 ~s 结束的跨服消费排行榜中获得参与奖，请及时查收！"),
            {Title, Content};
        93 ->
            Title = ?T("跨服充值排行榜奖励"),
            Content = ?T("恭喜您在 ~s 结束的跨服充值排行榜中获得参与奖，请及时查收！"),
            {Title, Content};
        94 ->
            Title = ?T("送花榜奖励"),
            Content = ?T("您在本次送花榜排名为第~p名，这是您的排名奖励，请查收。<br/><br/>本次花榜前三名为:<br/><br/>"),
            {Title, Content};
        95 ->
            Title = ?T("收花榜奖励"),
            Content = ?T("您在本次收花榜排名为第~p名，这是您的排名奖励，请查收。<br/><br/>本次花榜前三名为:<br/><br/>"),
            {Title, Content};

        98 ->
            Title = ?T("守护副本奖励"),
            Content = ?T("上仙首次成功守护蜀山剑像第~p波，蜀山上下铭感大恩。特意奉上大礼。"),
            {Title, Content};
        99 ->
            Title = ?T("跨服世界boss战"),
            Content = ?T("恭喜您带领你的仙盟获得跨服首领活动第~p名，这是您的盟主奖励："),
            {Title, Content};
        100 ->
            Title = ?T("跨服世界boss战"),
            Content = ?T("恭喜您的仙盟在跨服首领活动中获得第~p名，这是您的奖励："),
            {Title, Content};
        101 ->
            Title = ?T("符文背包空间不足"),
            Content = ?T("符文背包空间不足，奖励改由邮件发放，请及时查收！"),
            {Title, Content};
        102 ->
            Title = ?T("斗破天穹"),
            Content = ?T("       欢迎来到《斗破天穹》纯真武侠世界！紧凑的剧情，绝美的场景，既有惬人心脾的真挚爱情，也有激烈震撼上千人级别的大规模PK对抗，引领你进入一个拥有无限遐想的诗意武侠大江湖。领取独家新手礼包，尊享千元贵宾福利：加入斗破天穹玩家唠嗑群：569902113
    客服联系方式:
        邮箱:KF@ijunhai.com
电话:021-61542494
        QQ公众号:800810855"),
            {Title, Content};
        103 ->
            Title = ?T("巡游预约"),
            Content = ?T("你与玩家~s已预约在~s于长安城举办婚礼巡游。"),
            {Title, Content};
        104 ->
            Title = ?T("喜帖"),
            Content = ?T("敬邀:沉浸在幸福中的我们将于~s举行结婚巡游.地点：长安城 新郎：~s 新娘：~s 届时恭候，希望你来见证我们的幸福"),
            {Title, Content};
        105 ->
            Title = ?T("绣球奖励"),
            Content = ?T("恭喜你获得了~s玩家抛出的绣球的归属,请查收!"),
            {Title, Content};
        106 ->
            Title = ?T("酒壶奖励"),
            Content = ?T("恭喜你获得了~s玩家抛出的酒壶的归属,请查收!"),
            {Title, Content};
        107 ->
            Title = ?T("贺礼"),
            Content = ?T("~s为您送上贺礼,祝贺喜结连理,请查收!"),
            {Title, Content};
        108 ->
            Title = ?T("离婚通知"),
            Content = ?T("~s主动提出离婚，你与~s夫妻关系结束。离婚后你的羁绊将不能继续提升，部分属性加成消失!"),
            {Title, Content};
        109 ->
            Title = ?T("离婚通知"),
            Content = ?T("您主动提出离婚，你与~s夫妻关系结束。离婚后你的羁绊将不能继续提升，部分属性加成消失!"),
            {Title, Content};
        110 ->
            Title = ?T("宴席邀请函"),
            Content = ?T("敬邀:~s举办~s酒宴,地点:长安城(~p,~p),邀请人:~s,届时恭候,共谋一醉!"),
            {Title, Content};
        111 ->
            Title = ?T("长安城大饭店"),
            Content = ?T("您预定的~s,前来赴宴人数~p,获得奖励,请查收!"),
            {Title, Content};
        112 ->
            Title = ?T("长安城大饭店"),
            Content = ?T("您预定的~s摆设的~s即将开始,获得奖励,请查收!"),
            {Title, Content};
        113 ->
            Title = ?T("深渊魔宫"),
            Content = ?T("昨日深渊魔宫个人奖励未领取,请查收!"),
            {Title, Content};
        114 ->
            Title = ?T("跨服攻城战捐献返还"),
            Content = ?T("由于您的仙盟未选入跨服攻城战，特此将您的个人贡献进行返还"),
            {Title, Content};
        115 ->
            Title = ?T("评价奖励"),
            Content = ?T("感谢您的评价，希望我们能够陪伴你度过一段愉快的时光,这是感谢您评价的谢礼!"),
            {Title, Content};
        116 ->
            Title = ?T("斗破天穹"),
            Content = ?T("       欢迎来到《斗破天穹》纯真武侠世界！紧凑的剧情，绝美的场景，既有惬人心脾的真挚爱情，也有激烈震撼上千人级别的大规模PK对抗，引领你进入一个拥有无限遐想的诗意武侠大江湖。领取独家新手礼包，尊享千元贵宾福利：加入斗破天穹玩家唠嗑群：654021211
    客服联系方式:
        邮箱:KF@ijunhai.com
电话:021-61542494
        QQ公众号:800810855"),
            {Title, Content};
        117 ->
            Title = ?T("跨服攻城战阵营选择"),
            Content = ?T("~s代表仙盟报名了跨服攻城战防守方阵营，守卫王城，不得有失！"),
            {Title, Content};
        118 ->
            Title = ?T("跨服攻城战阵营选择"),
            Content = ?T("~s代表仙盟报名了跨服攻城战进攻方阵营，攻占王城，抢夺宝珠！"),
            {Title, Content};
        119 ->
            Title = ?T("跨服攻城战防守成功奖励"),
            Content = ?T("这是你在跨服攻城战防守成功所获得的奖励，请查收"),
            {Title, Content};
        120 ->
            Title = ?T("跨服攻城战防守失败奖励"),
            Content = ?T("这是你在跨服攻城战防守失败所获得的奖励，请查收"),
            {Title, Content};
        121 ->
            Title = ?T("跨服攻城战进攻成功奖励"),
            Content = ?T("这是你在跨服攻城战进攻成功所获得的奖励，请查收"),
            {Title, Content};
        122 ->
            Title = ?T("跨服攻城战进攻失败奖励"),
            Content = ?T("这是你在跨服攻城战进攻失败所获得的奖励，请查收"),
            {Title, Content};
        123 ->
            Title = ?T("跨服攻城战阵营选择"),
            Content = ?T("恭喜您的仙盟为城主仙盟，下次攻城战为防守方，守卫王城，不得有失！"),
            {Title, Content};
        124 ->
            Title = ?T("跨服攻城战阵营选择"),
            Content = ?T("您的王城被~s.~s攻占，下轮攻城战为进攻方，请将失去的王城及荣耀重新夺取回来！"),
            {Title, Content};
        125 ->
            Title = ?T("跨服攻城战城主奖励"),
            Content = ?T("本次跨服攻城战完满结束，恭喜您成为城主，请您收下城主奖励。"),
            {Title, Content};
        126 ->
            Title = ?T("跨服攻城战城主伴侣奖励"),
            Content = ?T("本次跨服攻城战完满结束，恭喜您的伴侣成为城主，请您收下城主伴侣奖励。"),
            {Title, Content};
        127 ->
            Title = ?T("跨服攻城战城主仙盟奖励"),
            Content = ?T("本次跨服攻城战完满结束，恭喜您的仙盟成为城主仙盟，请收下您攻占王城后获得的战利品。"),
            {Title, Content};
        130 ->
            Title = ?T("跨服攻城战阵营选择"),
            Content = ?T("~s代表仙盟重新报名了跨服攻城战防守方阵营，守卫王城，不得有失！"),
            {Title, Content};
        131 ->
            Title = ?T("跨服攻城战阵营选择"),
            Content = ?T("~s代表仙盟重新报名了跨服攻城战进攻方阵营，攻占王城，抢夺宝珠！"),
            {Title, Content};
        132 ->
            Title = ?T("神秘商店购买返利"),
            Content = ?T("您在神秘商店的全购额外奖励已发送到邮件，请注意查收！"),
            {Title, Content};
        133 ->
            Title = ?T("1元购活动返还"),
            Content =
                case version:get_lan_config() of
                    vietnam ->
                        ?T("抱歉你在~s的第~p轮1元购中购买的~s没有满足最高次数，返还元宝。");
                    _ ->
                        ?T("抱歉你在~p年~p月~p日的第~p轮1元购中购买的~s没有满足最高次数，返还元宝。")
                end,
            {Title, Content};
        134 ->
            Title = ?T("1元购大奖"),
            Content =
                case version:get_lan_config() of
                    vietnam ->
                        ?T("恭喜你在~s第~p轮的1元购中成为被抽中的幸运者，获得奖励");
                    _ ->
                        ?T("恭喜你在~p年~p月~p日第~p轮的1元购中成为被抽中的幸运者，获得奖励")
                end,
            {Title, Content};
        135 ->
            Title = ?T("仙装背包空间不足"),
            Content = ?T("仙装背包空间不足，奖励改由邮件发放，请及时查收！"),
            {Title, Content};
        136 ->
            Title = ?T("精英赛参赛奖励"),
            Content = ?T("这是您在本届乱斗精英赛的参赛奖励，请查收"),
            {Title, Content};
        137 ->
            Title = ?T("精英赛晋级奖励"),
            Content = ?T("恭喜您的战队在乱斗精英赛初赛中获得 ~p 积分，成功晋级十六强，这是您应获得的奖励，请查收。请今晚20:30准备参加十六强争夺战。"),
            {Title, Content};
        138 ->
            Title = ?T("精英赛十六强奖励"),
            Content = ?T("您的战队在十六强比赛中落败，很遗憾未能继续前进，这是您的十六强战队奖励，请查收。请您再接再厉下届取得一个理想的成绩。"),
            {Title, Content};
        139 ->
            Title = ?T("精英赛八强资格"),
            Content = ?T("恭喜您的战队在十六强比赛中获胜，成功晋级八强，您的战队奖励已经升级为八强奖励，望您下一场继续取得一个好成绩"),
            {Title, Content};
        140 ->
            Title = ?T("精英赛八强奖励"),
            Content = ?T("您的战队在八强比赛中落败，很遗憾未能继续前进，这是您的八强战队奖励，请查收。请您再接再厉下届取得一个理想的成绩。"),
            {Title, Content};
        141 ->
            Title = ?T("精英赛四强资格"),
            Content = ?T("恭喜您的战队在八强比赛中获胜，成功晋级四强，您的战队奖励已经升级为四强奖励，望您下一场继续取得一个好成绩。"),
            {Title, Content};
        142 ->
            Title = ?T("精英赛四强奖励"),
            Content = ?T("您的战队在四强比赛中落败，很遗憾未能继续前进，这是您的四强战队奖励，请查收。请您再接再厉下届取得一个理想的成绩。"),
            {Title, Content};
        143 ->
            Title = ?T("精英赛决赛资格"),
            Content = ?T("恭喜您的战队在四强比赛中获胜，成功进入决赛，您的战队奖励已经升级为冠亚军奖励，望您力拔头筹成为乱斗王者！"),
            {Title, Content};
        144 ->
            Title = ?T("精英赛亚军战队"),
            Content = ?T("您的战队在精英赛决赛中落败，恭喜您最终成为乱斗精英赛亚军战队，这是您的亚军战队奖励，请查收。乱斗王者，指日可待！"),
            {Title, Content};
        145 ->
            Title = ?T("精英赛冠军战队"),
            Content = ?T("恭喜您的战队在精英赛决赛中获胜，您的战队 ~s 成为了乱斗精英赛最终的乱斗王者！这是您的战队乱斗王者奖励，希望能的战队下一届成功卫冕。"),
            {Title, Content};
        146 ->
            Title = ?T("财神天降奖励领取"),
            Content = ?T("【财神天降】充值奖励已发送，上仙不要忘了领取附件哦"),
            {Title, Content};
        147 ->
            Title = ?T("聚宝盆返还元宝"),
            Content = ?T("【聚宝盆】您充值~p元宝档次的第~p天奖励还未领取，现以邮件发送，上仙不要忘了领取附件哦"),
            {Title, Content};
        148 ->
            Title = ?T("仙装觉醒活动奖励"),
            Content = ?T("限时仙装觉醒活动中，恭喜上仙夺得排行榜第~p名，不要忘记查收附件奖励哦"),
            {Title, Content};
        149 ->
            Title = ?T("乱斗精英赛~s投注"),
            Content = ?T("您在乱斗精英赛~s投注了~s战队，该战队大获全胜，这是您的投注奖励请查收。"),
            {Title, Content};
        150 ->
            Title = ?T("游戏充值"),
            Content = ?T("您充值~p元，获得~p元宝，赠送~p元宝。"),
            {Title, Content};
        151 ->
            Title = ?T("单笔充值"),
            Content = ?T("您参与~p元宝档次的单笔充值，这是您未领取的奖励，不要忘了查收附件哦"),
            {Title, Content};
        152 ->
            Title = ?T("宠物对战"),
            Content = ?T("亲爱的宠物指挥官，你在宠物对战中，遗失了一份奖励，请查收："),
            {Title, Content};
        153 ->
            Title = ?T("限时仙宠成长活动奖励"),
            Content = ?T("限时仙宠成长活动中，恭喜上仙夺得排行榜第~p名，不要忘记查收附件奖励哦"),
            {Title, Content};
        154 ->
            Title = ?T("跨服1vN资格赛奖励"),
            Content = ?T("您在跨服1vN资格赛中获得第 ~p 名, 请及时查收奖励"),
            {Title, Content};
        155 ->
            Title = ?T("跨服1vN守擂赛奖励"),
            Content = ?T("您在跨服1vN守擂赛中获得第 ~p 名, 请及时查收奖励"),
            {Title, Content};
        156 ->
            Title = ?T("跨服1vN守擂赛奖励"),
            Content = ?T("您在跨服1vN守擂赛 第 ~p 轮中 ~s, 请及时查收奖励 "),
            {Title, Content};
        157 ->
            Title = ?T("跨服1vN资格赛奖励"),
            Content = ?T("您在跨服1vN资格赛 第 ~p 轮中 ~s, 请及时查收奖励"),
            {Title, Content};
        158 ->
            Title = ?T("神魂背包空间不足"),
            Content = ?T("神魂背包空间不足，奖励改由邮件发放，请及时查收！"),
            {Title, Content};
        159 ->
            Title = ?T("1VN中场竞猜"),
            Content = ?T("你在1VN中场竞猜投注的擂主玩家~s ~s，神机妙算。以下是你的奖金"),
            {Title, Content};
        160 ->
            Title = ?T("1VN中场竞猜"),
            Content = ?T("你在1VN中场竞猜，投注擂主玩家~s ~s，没有预测中最终结果。"),
            {Title, Content};
        161 ->
            Title = ?T("1VN冠军竞猜"),
            Content = ?T("你在1VN中投注的玩家~s赢得冠军，可喜可贺。以下是你的奖金"),
            {Title, Content};
        162 ->
            Title = ?T("1VN冠军竞猜"),
            Content = ?T("你在1VN中投注的玩家~s没有赢得冠军。"),
            {Title, Content};
        163 ->
            Title = ?T("精英boss参战返还"),
            Content = ?T("钦天监夜观星宿发现天降异象，为防止仙友受影响特返还物品如下："),
            {Title, Content};
        164 ->
            Title = ?T("精英boss击杀排名"),
            Content = ?T("玩家~s代天行罚参与击杀怪物~s，排第~p名 获得天道眷顾，排名奖励如下："),
            {Title, Content};
        165 ->
            Title = ?T("许愿池"),
            Content = ?T("恭喜上仙在本次许愿池活动中获得第~p名，奖励如下："),
            {Title, Content};
        166 ->
            Title = ?T("跨服许愿池"),
            Content = ?T("恭喜上仙在本次跨服许愿池活动中获得第~p名，奖励如下："),
            {Title, Content};
        167 ->
            Title = ?T("击杀奖励"),
            Content = ?T("你最终击杀仙盟神兽~s ，获得以下奖励"),
            {Title, Content};
        168 ->
            Title = ?T("伤害排名"),
            Content = ?T("你在参与仙盟神兽~s狩猎中，伤害排名~p，获得以下奖励"),
            {Title, Content};
        169 ->
            Title = ?T("Vip表情卡失效提示"),
            Content = ?T("亲爱的上仙，您的VIP~p表情体验特权已到期，只要激活对应VIP等级，即可再次体验喔"),
            {Title, Content};
        170 ->
            Title = ?T("未击杀"),
            Content = ?T("很遗憾仙盟神兽~s逃跑了，你只能获得以下奖励"),
            {Title, Content};
        171 ->
            Title = ?T("超级召唤击杀奖励"),
            Content = ?T("你最终击杀~s 超级召唤的仙盟神兽~s，获得以下奖励"),
            {Title, Content};
        172 ->
            Title = ?T("超级召唤伤害排名"),
            Content = ?T("你在参与 ~s 超级召唤的仙盟神兽 ~s 狩猎中，伤害排名~p，获得以下奖励"),
            {Title, Content};
        173 ->
            Title = ?T("超级召唤未击杀"),
            Content = ?T("很遗憾 ~s 超级召唤的仙盟神兽 ~s 逃跑了，你只能获得以下奖励"),
            {Title, Content};
        174 ->
            Title = ?T("防守成功"),
            Content = ?T("你战胜了向你发起仙盟挑战的玩家~s，获得以下奖励"),
            {Title, Content};
        175 ->
            Title = ?T("亲友聚集"),
            Content = ?T("使用邀请码 100% 返利"),
            {Title, Content};
        176 ->
            Title = ?T("亲友聚集"),
            Content = ?T("type=1 返利"),
            {Title, Content};
        177 ->
            Title = ?T("亲友聚集"),
            Content = ?T("type=2 返利"),
            {Title, Content};
        178 ->
            Title = ?T("亲友聚集"),
            Content = ?T("type=2 返利"),
            {Title, Content};
        179 ->
            Title = ?T("每日奖励"),
            Content = ?T("亲爱的上仙，你在本次跃升冲榜中一举夺得第~p名，获得每日豪礼，请查收附件哦"),
            {Title, Content};
        180 ->
            Title = ?T("最终结算"),
            Content = ?T("亲爱的上仙，你在本次跃升冲榜中一举夺得第~p名，为你送上跃升豪礼一份，请查收附件哦"),
            {Title, Content};
        181 ->
            Title = ?T("奇遇礼包"),
            Content = ?T("恭喜上仙获得价值X元宝的限时奇遇礼包，不要忘了查收附件哦"),
            {Title, Content};
        182 ->
            Title = ?T("仙晶矿域"),
            Content = ?T("特大奇遇花落你家，请查收附件奖励哦"),
            {Title, Content};
        183 ->
            Title = ?T("仙晶矿域"),
            Content = ?T("恭喜上仙获得100%占领奖励，请查收附件奖励"),
            {Title, Content};
        184 ->
            Title = ?T("仙晶矿域"),
            Content = ?T("由于矿点被劫，只获得50%占领奖励"),
            {Title, Content};
        185 ->
            Title = ?T("仙晶矿域"),
            Content = ?T("您成功抢夺了对方的收获奖励！"),
            {Title, Content};
        186 ->
            Title = ?T("仙晶矿域"),
            Content = ?T("您成功抢夺了对方的占领奖励！"),
            {Title, Content};
        187 ->
            Title = ?T("仙晶矿域"),
            Content = ?T("您的矿点被~s抢夺成功，损失~p仙晶！"),
            {Title, Content};
        188 ->
            Title = ?T("仙晶矿域"),
            Content = ?T("您的矿点于收获期被~s抢夺成功，损失~p仙晶，气煞人也！"),
            {Title, Content};
        189 ->
            Title = ?T("仙晶矿域"),
            Content = ?T("成功击杀小偷，独得宝贝一件，请注意查收"),
            {Title, Content};
        190 ->
            Title = ?T("仙晶矿域"),
            Content = ?T("恭喜您在仙晶榜单获得~p名,请注意查收奖励"),
            {Title, Content};
        _ ->
            {<<>>, <<>>}
    end.
