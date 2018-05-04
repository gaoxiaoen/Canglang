%%----------------------------------------------------
%% 锻造活动奖励
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(blacksmith_reward).
-export([listener/3]).

%% 奖励发放
-include("common.hrl").

%% 强化类奖励 
listener(enchant, Role, Enchant) when Enchant >= 7 ->
    campaign_listener:handle(eqm_enchant, Role, Enchant),
    Now = util:unixtime(),
    %% 活动类强化 
    StartTime = util:datetime_to_seconds({{2012, 8, 10}, {8, 0, 0}}),
    EndTime = util:datetime_to_seconds({{2012, 8, 12}, {23, 59, 59}}),
    case Now >= StartTime andalso Now =< EndTime of
        true -> do(enchant_camp, Role, Enchant);
        _ -> skip 
    end;

%%  橙装精炼活动
listener(refining, Role, Lev) when Lev >= 40 ->
    campaign_listener:handle(eqm_make, Role, {4, Lev}),
    Now = util:unixtime(),
    %% 活动类
    StartTime = util:datetime_to_seconds({{2012, 8, 22}, {0, 0, 0}}),
    EndTime = util:datetime_to_seconds({{2012, 8, 25}, {23, 59, 59}}),
    case Now >= StartTime andalso Now =< EndTime of
        true -> do(refining_camp, Role, Lev);
        _ -> ok
    end;

%% 紫装活动
listener(purple, Role, Lev) ->
    campaign_listener:handle(eqm_make, Role, {3, Lev}),
    ok;

%% 淬炼活动
listener(quech, Role, Lev) ->
    campaign_listener:handle(stone_quech, Role, Lev),
    Now = util:unixtime(),
    %% 活动类
    StartTime = util:datetime_to_seconds({{2012, 10, 5}, {0, 0, 0}}),
    EndTime = util:datetime_to_seconds({{2012, 10, 7}, {23, 59, 59}}),
    case Now >= StartTime andalso Now =< EndTime of
        true -> do(quech_camp, Role, Lev);
        _ -> ok
    end;

listener(_Handle, _Role, _Arg) -> ok.

%%--------------------
%% 内部方法
%%--------------------

%% 强化开服活动类
do(enchant_open, Role, 7) ->
    Subject = ?L(<<"开服活动奖励">>),
    Content = ?L(<<"恭喜您在新服装备强化活动中成功将装备强化至+7，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>),
    Items = [{21027, 1, 1}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do(enchant_open, Role, 8) ->
    Subject = ?L(<<"开服活动奖励">>),
    Content = ?L(<<"恭喜您在新服装备强化活动中成功将装备强化至+8，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>),
    Items = [{21028, 1, 1}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do(enchant_open, Role, 9) ->
    Subject = ?L(<<"开服活动奖励">>),
    Content = ?L(<<"恭喜您在新服装备强化活动中成功将装备强化至+9，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>),
    Items = [{21029, 1, 1}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});

%% 强化更新活动类
do(enchant_camp, Role, 9) ->
    Subject = ?L(<<"装备强化，幸运相伴">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。酷爽暑假活动期间，您成功将装备强化至+9，获得了下列额外超值大礼哦">>),
    Items = [{21020, 1, 2}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do(enchant_camp, Role, 10) ->
    Subject = ?L(<<"装备强化，幸运相伴">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。酷爽暑假活动期间，您成功将装备强化至+10，获得了下列额外超值大礼哦">>),
    Items = [{21021, 1, 2}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do(enchant_camp, Role, 11) ->
    Subject = ?L(<<"装备强化，幸运相伴">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。酷爽暑假活动期间，您成功将装备强化至+11，获得了下列额外超值大礼哦">>),
    Items = [{21022, 1, 2}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do(enchant_camp, Role, 12) ->
    Subject = ?L(<<"装备强化，幸运相伴">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。酷爽暑假活动期间，您成功将装备强化至+12，获得了下列额外超值大礼哦">>),
    Items = [{21023, 1, 2}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});

%% 橙装开服活动类
do(refining_open, Role, Lev) when Lev >= 40 andalso Lev < 50 ->
    Subject = ?L(<<"开服活动奖励">>),
    Content = ?L(<<"恭喜您在新服打造装备活动中成功打造出一件40级橙色套装，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>),
    Items = [{21027, 1, 2}, {21020, 1, 1}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});

%% 橙装更新活动类
do(refining_camp, Role, Lev) when Lev >= 40 andalso Lev < 50 ->
    Subject = ?L(<<"打造橙装，追求更强">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。您参与了“打造橙装，追求更强”活动，成功精炼40级橙色装备一件，恭喜您获得以下超值奖励！">>),
    Items = [{21020, 1, 2}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do(refining_camp, Role, Lev) when Lev >= 50 andalso Lev < 60 ->
    Subject = ?L(<<"打造橙装，追求更强">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。您参与了“打造橙装，追求更强”活动，成功精炼50级橙色装备一件，恭喜您获得以下超值奖励！">>),
    Items = [{21020, 1, 4}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do(refining_camp, Role, Lev) when Lev >= 60 andalso Lev < 70 ->
    Subject = ?L(<<"打造橙装，追求更强">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。您参与了“打造橙装，追求更强”活动，成功精炼60级橙色装备一件，恭喜您获得以下超值奖励！">>),
    Items = [{21021, 1, 2}, {25022, 1, 1}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do(refining_camp, Role, Lev) when Lev >= 70 ->
    Subject = ?L(<<"打造橙装，追求更强">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。您参与了“打造橙装，追求更强”活动，成功精炼70级橙色装备一件，恭喜您获得以下超值奖励！">>),
    Items = [{22243, 1, 4}, {25022, 1, 2}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});

%% 紫装开服活动类
do(purple_open, Role, Lev) when Lev >= 40 andalso Lev < 50 ->
    Subject = ?L(<<"开服活动奖励">>),
    Content = ?L(<<"恭喜您在新服打造装备活动中成功收集到一件40级紫色套装，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>),
    Items = [{22201, 1, 3}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});

%% 淬炼更新活动类
do(quech_camp, Role, 4) ->
    Subject = ?L(<<"国庆同乐之宝石淬炼">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。国庆活动期间，您成功淬炼出4级真·宝石，获得了下列额外超值大礼哦！">>),
    Items = [{22242, 1, 1}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do(quech_camp, Role, 5) ->
    Subject = ?L(<<"国庆同乐之宝石淬炼">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。国庆活动期间，您成功淬炼出5级真·宝石，获得了下列额外超值大礼哦！">>),
    Items = [{22243, 1, 1}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do(quech_camp, Role, 6) ->
    Subject = ?L(<<"国庆同乐之宝石淬炼">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。国庆活动期间，您成功淬炼出6级真·宝石，获得了下列额外超值大礼哦！">>),
    Items = [{22244, 1, 1}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do(quech_camp, Role, 7) ->
    Subject = ?L(<<"国庆同乐之宝石淬炼">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。国庆活动期间，您成功淬炼出7级真·宝石，获得了下列额外超值大礼哦！">>),
    Items = [{22245, 1, 1}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});
do(quech_camp, Role, 8) ->
    Subject = ?L(<<"国庆同乐之宝石淬炼">>),
    Content = ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。国庆活动期间，您成功淬炼出8级真·宝石，获得了下列额外超值大礼哦！">>),
    Items = [{22246, 1, 1}],
    mail_mgr:deliver(Role, {Subject, Content, [], Items});

do(_Handle, _Role, _Arg) -> ok.
