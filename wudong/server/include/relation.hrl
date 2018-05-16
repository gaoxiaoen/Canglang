-define(RTYPE_FRIEND, 1).            %好友
-define(RTYPE_BLACK, 2).             %黑名单
-define(RTYPE_ENEMY, 3).             %仇人

-define(PAGE_NUM, 10).               %单页显示人数
-define(FRIENDS_LIMIT, 80).          %好友上限
-define(BLACKLIST_LIMIT, 10).        %黑名单上限
-define(RECENTLY_CONTACTS_LIMIT, 20).%最近联系人上限

-define(RPOSIT, 4).          %关系字段位置

-define(RELATION_ERR_FAIL, 0).
-define(RELATION_ERR_OK, 1).
-define(RELATION_ERR_FRIEND_LIMIT, 2).
-define(RELATION_ERR_BLACKLIST_LIMIT, 3).
-define(RELATION_ERR_FRIEND_EXISTS, 4).
-define(RELATION_ERR_FRIEND_NOT_EXISTS, 5).
-define(RELATION_ERR_BLACKLIST_EXISTS, 6).
-define(RELATION_ERR_BLACKLIST_NOT_EXISTS, 7).
-define(RELATION_ERR_REJECT, 8).
-define(RELATION_ERR_OFFLINE, 9).
-define(RELATION_LIM_LV, data_menu_open:get(17)).%%好友等级限制


-record(st_relation, {
    like_times = 0,       %%今日点赞次数
    self_like_times = 0,  %%今日点被赞次数
    friends = []          %好友列表
    , enemy = []            %仇人列表
    , blacklist = []         %黑名单列表
}).

-record(relation, {
    rkey = 0                 %关系表key
    , type = 0                %1好友2黑名单3仇人
    , pkey = 0               %玩家key
    , nickname = none          %玩家昵称
    , avatar = ""            %%玩家头像
    , decoration_id = 0      %%挂饰
    , qinmidu = 0
    , career = 0             %职业
    , sex = 0               %%性别
    , vip = 0                %vip
    , realm = 0              %阵营
    , cbp = 0                %战力
    , lv = 0                 %等级
    , time = 0               %关系建立时间
    , guild = none           %仙盟名称
    , qinmidu_args = []   % 亲密度每日列表
}).


-record(base_friend_like, {
    level = 0
    , self_award = []
    , other_award = []
}).

-record(friend_like, {
    pkey = 0
    , nickname = []
    , career
    , type
    , data = []
}).

-record(qinmidu, {
    id = 0,     %% id
    value = 0,  %% 每次增加亲密度
    limit = 0   %% 每日上限
}).

-record(base_flower, {
    goods_id = 0,   %% 物品id
    charm = 0,      %% 魅力值
    qinmidu = 0,     %% 亲密度
    is_show = 0,     %% 是否飘字
    desc = "",   %% 花描述
    sweet_get = 0,   %% 收花获得甜蜜值
    sweet_give = 0   %% 送花甜蜜值
}).