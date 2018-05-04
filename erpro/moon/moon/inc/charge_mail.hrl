%%----------------------------------------------
%% 充值自动发送邮件数据结构 
%% @author lishen(105326073@qq.com)
%%----------------------------------------------

-record(charge_mail, {
        id = 0,             %% 邮件id
        total_gold = 0,     %% 累计充值
        once_gold = 0,      %% 单次充值
        title = <<>>,       %% 标题
        content = <<>>,     %% 内容
        recv_roles = []     %% 已接收者列表({Rid, SrvId, Name})
    }).
