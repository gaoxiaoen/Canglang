
-define(LETTER_NOT_OPEN,1). %%信件没有打开
-define(LETTER_HAS_OPEN,2). %%信件打开了
-define(LETTER_HAS_ACCEPT_GOODS, 3). %%信件已收取物品
-define(LETTER_REPLY, 4).  %% gm回复的信件（用于给gm回复的信件评分）

-define(TYPE_LETTER_PRIVATE,0). %% 私人信件
-define(TYPE_LETTER_FAMILY,1). %% 帮派信件
-define(TYPE_LETTER_SYSTEM,2). %% 系统信件
-define(TYPE_LETTER_RETURN,3). %% 退信
-define(TYPE_LETTER_GM,4).  %% GM信件

-define(LETTER_DEFAULT_SAVE_DAYS, 14).
-define(LETTER_SEND_COST,100).
-define(LIMIT_SEND_LETTER_COUNT,50).
-define(LIMIT_LETTER_LENGTH,400).

%% 计数器
-define(COMMON_LETTER_COUNTER_KEY,common_letter_counter_key).

%% 信件类型
-define(LETTER_CONTENT_CHAR,1).  %% 信件内容为字符串
-define(LETTER_CONTENT_TEMPLATE,2). %% 信件内容来自模板
-define(LETTER_CONTENT_COMMON,3).   %% 数据库保存内容


%% 存在数据库中的公共信件
-define(DATABASE_LETTER,0).
%% 放在模板中的公共信件
-define(TEMPLATE_LETTER,1).

%% 获取物品请求队列
-define(ACCEPT_GOODS_REQUEST_QUEUE,accept_goods_request_queue).
%% 请求获取物品队列
-record(r_accept_goods_request,{time,letter_id,table}).

%% 信件属性 用于表示信件存储在哪个表中
-define(LETTER_PERSONAL,0).
-define(LETTER_PUBLIC,1).

%% 信件删除状态
-define(LETTER_DELETE_BY_SENDER,-1).
-define(LETTER_DELETE_BY_RECEIVER,1).
-define(LETTER_NOBODY_DELETE,0).

%% 获取物品超时时间
-define(REQUEST_OVER_TIME,10). %%秒

%% 每次发送信件条数上限
-define(ONE_TIME_SEND_MAX,3000).
-define(SEND_SPLIT_TIME,15000).  %%毫秒

