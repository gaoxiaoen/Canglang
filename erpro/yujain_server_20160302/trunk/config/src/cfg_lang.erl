%% -*- coding: latin-1 -*-
%% Author: markycai<tomarky.cai@gmail.com>
%% Created: 2013-12-19
%% Description: TODO: Add description to cfg_lang
-module(cfg_lang).

-export([find/1]).

%% bc
find(1)->{"系统错误，请联系GM",[]};

find(501)->{"魏国",[]};
find(502)->{"蜀国",[]};
find(503)->{"吴国",[]};


%% 信件
find(100101)->{"系统",[]};
find(100102)->{"GM",[]};
find(100103)->{"退信",[]};


%% 防沉迷
find(100201)->{"请求平台验证防沉迷资料失败，请稍后重新尝试",[]};
find(100202)->{"请尽快更新您的防沉迷资料，未录入防沉迷资料的玩家，按照阵营有关规定，游戏时间累计到达3小时将强制下线",[]};

%% 后台消息广播
find(100301)->{"当SendStrategy=1,4时，start_date日期格式出错",[]};
find(100302)->{"当SendStrategy=1,4时，end_date日期格式出错",[]};
find(100303)->{"当SendStrategy=1,4时，start_date > end_date日期格式出错",[]};
find(100304)->{"当SendStrategy=2时，星期参数出错",[]};
find(100305)->{"当SendStrategy=3时，开服后天数参数出错",[]};
find(100306)->{"start_time 数参数出错",[]};
find(100307)->{"end_time 数参数出错",[]};
find(100308)->{"start_time > end_time 出错",[]};
find(100309)->{"start_day + start_time > end_day + end_time 出错",[]};
find(100310)->{"发送的时间段已经过期，不需要处理此消息",[]};
find(100311)->{"发送时间出错",[]};

%% 帮派
find(100401)->{"加入我帮派，美女世界，唯我独尊！",[]};

%% 任务
find(100600)->{"任务基本奖励信件",[]};
find(100601)->{"任务道具奖励信件",[]};

%% letter 
find(1800001)->{"亲爱的玩家，你的信件物品被退回",[]};


find(_)->[].
