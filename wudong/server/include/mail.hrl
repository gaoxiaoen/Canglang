-define(MAIL_TYPE_SYSTEM, 0).
-define(MAIL_TYPE_SYSTEM1, 1).
-define(MAIL_TYPE_CHARGE, 3).
-define(MAIL_TYPE_USER, 2).

%%邮件状态,未读
-define(MAIL_STATE_UNREAD, 0).
%%邮件状态 已读
-define(MAIL_STATE_READ, 1).
%%邮件状态 已提取
-define(MAIL_STATE_FETCH, 2).

-record(mail, {
    mkey = 0,
    pkey = 0,
    type = 0,
    overtime = 0,
    goodslist = [],
    title = [],
    content = [],
    time = 0,
    state = 0
}).