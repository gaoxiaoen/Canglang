%%----------------------------------------------------
%% BUFF相关数据结构定义
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------

%% 角色Buff
-record(rbuff, {
        next_id = 1         %% 下一个BuffId
        ,shortcut_pool      %% 快捷血量法力回复 [{hp, HpPool, Switch}, {mp, MpPool, Switch}] {标签, 总量, 开关}
        ,buff_list = []     %% buff列表 [#buff{} | ...]
    }
).

%% buff数据结构
-record(buff, {
         id = 0         %% Buff的唯一标识
        ,label = buff   %% 标签
        ,name = <<>>    %% BUFF名称
        ,baseid = 0     %% BUFF基础ID
        ,icon = 0       %% 对应的图标编号
        ,multi = 0      %% 存在多个同类BUFF时的处理方式(0:不允许多个 1:跟据互斥设置而定 2:累加)
        ,duration = -1  %% -1表示永久有效, 时间:剩余时间, 数值:剩余数值
        ,endtime = 0    %% Buff终止时间 冗余,方便存储计算
        ,type = 0       %% 0 代表数值, 1 代表时间（下线不计时）, 2 代表时间（下线计时, 效果额外计算）
        ,end_date = 0   %% 0 代表无终止期限,其他 {{2011,11,16},{12,0,0}} {Date, Time} 格式
        ,cancel = 0     %% 0 代表不可主动取消, 1代表可主动取消
        ,effect = []    %% BUFF效果
                        %% {dmg, 10} 附加攻击
                        %% {hp_max, 100} 增加血量上限
                        %% {speed, 20} 提升速动速度
                        %% {exp, 20} 经验加成，单位:%
        ,msg = <<>>
    }
).
