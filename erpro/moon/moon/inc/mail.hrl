%%----------------------------------------------------
%% 邮件数据结构
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------

-define(MAIL_TYPE_NOR, 0). %% 普通邮件
-define(MAIL_TYPE_SYS, 1). %% 系统邮件

-define(mail_max_attachment, 5). %% 最大附件数量

-define(mail_max_subject_byte, 30). %% 标题最大字节 1个汉字3字节
-define(mail_max_content_byte, 1080). %% 信件内容最大字节 

-define(MAIL_SAVE_MAX_DAY, 2592000). %% 邮件过期时间（30天） 30 * 24 * 60 * 60

%% 资产类型 (系统最终通过role_gain发送奖励) [{?mail_coin, 100}]
-define(mail_coin, 2).        %% 金币
-define(mail_gold, 3).        %% 晶钻
-define(mail_gold_bind, 4).   %% 绑定晶钻
-define(mail_stone, 6).       %% 符石
-define(mail_scale, 5).       %% 龙鳞

-define(mail_coin_bind, 1).   %% 绑定金币
-define(mail_arena, 10).       %% 竞技场积分
-define(mail_exp, 12).         %% 经验
-define(mail_psychic, 11).     %% 灵力
%% -define(mail_honor, 7).       %% 荣誉值
-define(mail_activity, 8).       %% 精力、活跃度
-define(mail_attainment, 9).     %% 阅力值
%% -define(mail_evil, 10).       %% 罪恶值
%% -define(mail_prestige, 11).   %% 声望值/功勋值
%% -define(mail_hearsay, 12).    %% 传音次数
-define(mail_charm, 13).         %% 魅力值
-define(mail_flower, 14).        %% 送花积分
%% -define(mail_gold_integral, 15).  %% 充值返还晶钻积分
-define(mail_guild_war, 17).     %% 帮战积分
-define(mail_guild_devote, 18).  %% 帮贡值
-define(mail_career_devote, 19). %% 师门积分
-define(mail_lilian, 20).        %% 仙道历练
-define(mail_practice, 22).      %% 试练积分
-define(mail_soul, 23).         %% 魂气
-define(mail_hscore, 24).         %% 捕宠达人积分

-define(MAIL_SYSTEM_USER,
    fun() ->
            SrvId = case sys_env:get(srv_id) of
                undefined ->
                    {ok, S} = application:get_env(main, srv_id),
                    S;
                S -> S
            end,
            {0, util:to_binary(SrvId)}
    end
). %% 系统用户

-record(mail, {
         id                 %% 邮件ID
        ,send_time = 0      %% 发送时间
        ,from_rid           %% 发件人ID
        ,from_srv_id = <<>> %% 发件人服务器标志
        ,from_name = <<>>   %% 发件人名称
        ,to_rid             %% 收件人ID
        ,to_srv_id = <<>>   %% 收件人服务器标志
        ,to_name = <<>>     %% 收件人名称
        ,status = 0         %% 邮件状态(0:未读 1:已读)
        ,subject = <<>>     %% 邮件标题
        ,content = <<>>     %% 邮件正文
        ,mailtype = 0       %% 邮件类型(0:普通邮件 1:系统邮件)
        ,isatt = 0          %% 是否带附件(0:不带附件1:带附件)
        ,assets = []        %% 资产列表 {类型, 值}
        ,attachment = []    %% 附件 [#item{}]
    }
).

-record(mail_buff, {
        adm = <<"system">>  %% 后台管理者
        ,dest               %% 发送对象
        ,name = <<>>        %% 发送对象名称
        ,submit_time = 0    %% 邮件提交时间
        ,subject = <<>>     %% 邮件主题
        ,content = <<>>     %% 邮件内容
        ,assets = []        %% 资产 [ {integer(), integer()} |...]
        ,items = []         %% 物品 [#item{} | ...]
        ,items_info = <<>>   %% 物品信息用于日志保存
    }
).
