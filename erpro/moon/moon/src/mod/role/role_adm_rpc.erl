%%----------------------------------------------------
%% GM命令处理(仅在debug模式下有效)
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(role_adm_rpc).
-export([handle/3]).
-include("common.hrl").
-include("role.hrl").
-include("assets.hrl").
-include("storage.hrl").
-include("link.hrl").
-include("task.hrl").
-include("item.hrl").
-include("vip.hrl").
-include("pet.hrl").
-include("pos.hrl").
-include("guild.hrl").
-include("map.hrl").
-include("offline_exp.hrl").
-include("achievement.hrl").
-include("gain.hrl").
-include("boss.hrl").
-include("combat.hrl").
-include("attr.hrl").
-include("team.hrl").
-include("hall.hrl").
-include("campaign.hrl").
-include("lottery_tree.hrl").
-include("wing.hrl").
-include("dungeon.hrl").
-include("activity.hrl").
-include("activity2.hrl").
-include("fate.hrl").
-include("setting.hrl").
-include("tutorial.hrl").
-include("energy.hrl").
-include("demon.hrl").
-include("manor.hrl").
-include("seven_day_award.hrl").
-include("channel.hrl").
-include("npc_mail.hrl").
-include("month_card.hrl").

% -ifdef(debug).
-ifdef(debug).
    deal_Cmd(Cmd, Role) ->
        do_deal_Cmd(Cmd, Role).
-else.
%% 执行GM命令
deal_Cmd(Cmd, Role) ->
    case sys_env:get(is_gm_available) =:= 1 of
        true ->
            do_deal_Cmd(Cmd, Role);
        _ ->
            % {reply, {<<"GM命令已经关闭">>}}
            {ok}
    end.
-endif.


-define(adm_armor, [?item_yi_fu, ?item_xie_zi, ?item_ku_zi, ?item_yao_dai, ?item_hu_shou, ?item_hu_wan]).
-define(adm_ack, [?item_fei_jian, ?item_bi_shou, ?item_chang_qiang, ?item_fa_zhang, ?item_shen_gong, ?item_jie_zhi]).
-define(adm_hufu, [?item_hu_fu]).

%% 

 get_eqm(2, 10) -> [103011, 103111, 103211, 103311, 103411, 103511, 103611, 103711, 103811, 103911];
 get_eqm(2, 20) -> [103021, 103121, 103221, 103321, 103421, 103521, 103621, 103721, 103821, 103921];
 get_eqm(2, 30) -> [103032, 103132, 103232, 103332, 103432, 103532, 103632, 103732, 103832, 103932];
 get_eqm(2, 40) -> [103043, 103143, 103243, 103343, 103443, 103543, 103643, 103743, 103843, 103943];
 get_eqm(2, 50) -> [103054, 103154, 103254, 103354, 103454, 103554, 103654, 103754, 103854, 103954];

 get_eqm(3, 10) -> [102011, 102111, 102211, 102311, 102411, 102511, 102611, 102711, 102811, 102911];
 get_eqm(3, 20) -> [102021, 102121, 102221, 102321, 102421, 102521, 102621, 102721, 102821, 102921];
 get_eqm(3, 30) -> [102032, 102132, 102232, 102332, 102432, 102532, 102632, 102732, 102832, 102932];
 get_eqm(3, 40) -> [102043, 102143, 102243, 102343, 102443, 102543, 102643, 102743, 102843, 102943];
 get_eqm(3, 50) -> [102054, 102154, 102254, 102354, 102454, 102554, 102654, 102754, 102854, 102954];

 get_eqm(5, 10) -> [101011, 101111, 101211, 101311, 101411, 101511, 101611, 101711, 101811, 101911];
 get_eqm(5, 20) -> [101021, 101121, 101221, 101321, 101421, 101521, 101621, 101721, 101821, 101921];
 get_eqm(5, 30) -> [101032, 101132, 101232, 101332, 101432, 101532, 101632, 101732, 101832, 101932];
 get_eqm(5, 40) -> [101043, 101143, 101243, 101343, 101443, 101543, 101643, 101743, 101843, 101943];
 get_eqm(5, 50) -> [101054, 101154, 101254, 101354, 101454, 101554, 101654, 101754, 101854, 101954];
 get_eqm(_, _) -> [].



%% 获取命令帮助
handle(9900, {}, _Role) ->
    Cmds = [
        {<<"设金币 [数量]">>, <<"设置金币为指定数量">>}
        ,{<<"强化装备 [装备部位] [强化等级]">>, <<"强化部位:衣服,时装,护手,护腕等,等级为1-12">>}
        ,{<<"清空背包">>, <<"清空背包的物品">>}
        ,{<<"设绑定铜 [数量]">>, <<"设置绑定铜为指定数量">>}
        ,{<<"设晶钻 [数量]">>, <<"设置晶钻为指定数量">>}
        ,{<<"设绑定晶钻 [数量]">>, <<"设置绑定晶钻为指定数量">>}
        ,{<<"设等级 [整数]">>, <<"设置当前角色为指定等级">>}
        ,{<<"设战力 [整数]">>, <<"设置当前角色为指定战力">>}
        ,{<<"设血法 [百分数]">>, <<"设置当前角色的血量和法力,如：设血法 20">>}
        ,{<<"设灵力 [整数]">>, <<"设置当前角色的灵力">>}
        ,{<<"设阅历 [整数]">>, <<"设置当前角色的阅历值">>}
        ,{<<"设竞技场积分 [整数]">>, <<"设置当前角色的竞技场积分值">>}
        ,{<<"设职业 [整数]">>, <<"设置当前角色的职业[1真武--->6新手]">>}
        ,{<<"设速度 [整数]">>, <<"设置当前角色的移动速度[默认180], 只能在下次属性更新前有效">>}
        ,{<<"设仙道历练 [整数]">>, <<"设置当前角色的仙道历练">>}
        ,{<<"修炼武器 [修炼方式]">>, <<"修炼人物身上的武器,0:修炼1级,1:修炼至可修炼最大值">>}
        ,{<<"获取物品 [物品ID] [数量]">>, <<"直接获取指定的物品">>}
        ,{<<"设虔诚值 [整数]">>, <<"直接设置宠物虔诚值">>}
        ,{<<"获取多个物品 [{物品ID,数量},...]">>, <<"获取多个指定的物品">>}
        ,{<<"接受任务 [任务ID]">>, <<"接受指定任务">>}
        ,{<<"提交任务 [任务ID]">>, <<"提交指定任务">>}
        ,{<<"测试掉落 [怪物ID] [数量]">>, <<"测试掉落概率">>}
        ,{<<"传送到 [地图ID] [X坐标] [Y坐标]">>, <<"直接传送到任何地图中的任意地点">>}
        ,{<<"飞 [类型] [地图ID] [NPC的ID]">>, <<"模拟类型[1:vip飞天符 2:飞天符 3:5晶钻],传送至NPC处">>}
        ,{<<"重载公告">>, <<"重新载入系统电视公告">>}
        ,{<<"添加公告 [公告内容]">>, <<"增加一条系统公告">>}
        ,{<<"清除公告">>, <<"清除系统公告">>}
        ,{<<"设传音 [次数]">>, <<"传音聊天">>}
        ,{<<"设元神等级 [等级数] [0<境界值<40]">>, <<"设置元神的修炼等级和境界值">>}
        ,{<<"设八门 [等级数] [0<境界值<40]">>, <<"设置八门的修炼等级和境界值">>}
        ,{<<"清元神">>, <<"清除元神的修炼状态, 刷新后有效">>}
        ,{<<"复活 [类型]">>, <<"复活:1普通 2还魂 3等级神佑,暂时只能原地复活">>}
        ,{<<"挂">>, <<"原地死亡广播">>}
        ,{<<"进副本 [副本ID]">>, <<"进入指定的普通副本">>}
        ,{<<"退出副本">>, <<"退出所在的副本">>}
        ,{<<"清副本次数 [副本ID]">>, <<"将进入副本的次数置零">>}
        ,{<<"清关卡副本">>, <<"初始化关卡副本的解锁状态">>}
        ,{<<"清关卡重置数">>, <<"将当天重置关卡副本的次数清零">>}
        ,{<<"通关关卡副本">>, <<"将全部关卡副本解锁">>}
        ,{<<"获取怪物 [怪物ID]">>, <<"生成一只怪物在你身旁（在副本内有效）">>}
        ,{<<"开启试练">>, <<"开启试练">>}
        ,{<<"关闭试练">>, <<"关闭试练">>}
        ,{<<"结算试练">>, <<"结算试练, 保存数据">>}
        ,{<<"清试练次数">>, <<"清零试练次数">>}
        ,{<<"变身 [职业] [变身级别]">>, <<"职业:1~5, 级别:1~6">>}
        ,{<<"学技能 [等级]">>, <<"等级:1~13, 如果与装备加技能等级冲突的,需要调低等级">>}
        ,{<<"伯乐榜登记">>, <<"玩家30级后可以在伯乐榜登记收徒">>}
        ,{<<"设挂机次数 [次数]">>, <<"设挂机次数">>}
        ,{<<"设挂机状态 [状态]">>, <<"设挂机状态: 0普通 1挂机中">>}
        ,{<<"回帮">>, <<"进入帮会领地">>}
        ,{<<"离帮">>, <<"离开帮会领地">>}
        ,{<<"仙池">>, <<"开启仙池">>}
        ,{<<"完成任务链 [任务ID]">>, <<"完成指定任务及前置任务,任务奖励忽略,只限主支线任务。">>}
        ,{<<"设连续天数 [天数Num]">>, <<"设置连续登陆天数">>}
        ,{<<"我要新手卡">>, <<"获得新手卡的md5码">>}
        ,{<<"设开服时间 [年] [月] [日] [时] [分] [秒]">>, <<"设置系统开服时间">>}
        ,{<<"抽奖 [次数]">>, <<"抽奖0<N<10w次">>}
        ,{<<"中奖 [名字]">>, <<"指定下个头奖的中奖者名字">>}
        ,{<<"奖池">>, <<"获取奖池数据">>}
        ,{<<"设离线经验">>, <<"增加离线经验">>}
        ,{<<"清5倍">>, <<"清除当天5倍修炼的领取次数">>}
        ,{<<"许愿池">>, <<"开启许愿池">>}
        ,{<<"许愿池币数">>, <<"获取当前许愿池币数">>}
        ,{<<"许愿设置 [池子币数] [分钟]">>, <<"许愿投币相关设置">>}
        ,{<<"许愿池关闭">>, <<"关闭许愿池">>}
        ,{<<"开启帮战">>, <<"开启帮战">>}
        ,{<<"帮战准备">>, <<"跳过帮战报名时间,进入到准备区阶段">>}
        ,{<<"帮战第一阶段">>, <<"跳过帮战的准备区阶段,进入正式战斗时间">>}
        ,{<<"帮战第二阶段">>, <<"跳过第一阶段,可直接夺取神剑">>}
        ,{<<"结束帮战">>, <<"结束帮战">>}
        ,{<<"帮战报名 [阵型]">>, <<"阵型：1进攻方, 2防守方">>}
        ,{<<"进帮战准备区">>, <<"进入帮战准备区">>}
        ,{<<"进帮战">>, <<"进入帮战战区, 先得进入准备区">>}
        ,{<<"退出帮战">>, <<"退出帮战战场">>}
        ,{<<"设成就 [成就ID] [目标值Num]">>, <<"设置成就数据进度状态">>}
        ,{<<"开启超级怪">>, <<"开启超级世界boss">>}
        ,{<<"关闭超级怪">>, <<"关闭超级世界boss">>}
        ,{<<"打超级怪">>, <<"打超级世界boss">>}
        ,{<<"不打超级怪">>, <<"不打超级世界boss">>}
        ,{<<"金币购买超级怪buff">>, <<"金币购买超级世界boss的buff">>}
        ,{<<"晶钻购买超级怪buff">>, <<"晶钻购买超级世界boss的buff">>}
        ,{<<"设npc好感度">>, <<"设npc好感度">>}
        ,{<<"雇佣npc">>, <<"雇佣npc">>}
        ,{<<"解雇npc">>, <<"解雇npc">>}
        ,{<<"打自己">>, <<"打自己">>}
        ,{<<"新帮战下个阶段">>, <<"">>}
        ,{<<"新帮战重新开始">>, <<"">>}
        ,{<<"新帮战届次">>, <<"">>}
        ,{<<"报名新帮战">>, <<"">>}
        ,{<<"加入新帮战">>, <<"">>}
        ,{<<"仙道会开启">>, <<"">>}
        ,{<<"仙道会关闭">>, <<"">>}
        ,{<<"仙道会开启报名限制">>, <<"">>}
        ,{<<"仙道会关闭报名限制">>, <<"">>}
        ,{<<"仙道勋章等级 [等级]">>, <<"">>}
        ,{<<"仙道会清次数">>, <<"">>}
        ,{<<"仙道会发段位奖励">>, <<"">>}
        ,{<<"仙道会开启段位赛季末测试">>, <<"">>}
        ,{<<"仙道会关闭段位赛季末测试">>, <<"">>}
        ,{<<"仙道会设段位等级 [段位等级]">>, <<"">>}
        ,{<<"创建神秘商店 [NpcId]">>, <<"根据指定NpcID创建神秘商店">>}
        ,{<<"刷新霸主">>, <<"">>}
        ,{<<"坐骑进阶">>, <<"装备中坐骑完美度100%">>}
        ,{<<"设坐骑等级 [数量]">>, <<"设置装备中坐骑等级为指定等级">>}
        ,{<<"删除结拜称号 [类型]">>, <<"删除结拜称号,1=普通结拜,2=生死结拜">>}
        ,{<<"无尽的战斗">>, <<"无尽的战斗">>}
        ,{<<"清全部解除">>, <<"">>}
        ,{<<"清解除时间">>, <<"">>}
        ,{<<"清摇钱次数">>, <<"">>}
        ,{<<"设置新活跃度 [活跃度]">>, <<"活跃度不要大于100">>}
        ,{<<"清新活跃度奖励">>, <<"">>}
        ,{<<"cross_boss">>, <<"">>}
        ,{<<"cross_boss清次数">>, <<"">>}
        ,{<<"转阵营">>, <<"">>}
        ,{<<"转阵营清次数">>, <<"">>}
        ,{<<"跨服组队 [RoleId1, RoleId2]">>, <<"此命令调试用">>}
        ,{<<"设置掉落时间 [年] [月] [日] [时] [分] [秒]">>, <<"测试活动掉落">>}
        ,{<<"清除掉落时间">>, <<"测试活动掉落">>}
        ,{<<"跨服帮战开始">>, <<"">>}
        ,{<<"跨服帮战继续">>, <<"">>}
        ,{<<"设置精力值 [整数]">>, <<"">>}
        ,{<<"设守护等级 [整数]">>, <<"">>}
        ,{<<"设守护技能等级 [整数]">>, <<"只针对激活守护">>}
        ,{<<"设守护洗髓品质 [整数]">>, <<"1-白 2-绿 3-蓝 4-紫 5-橙">>}
        ,{<<"设采仙果次数 [类型]">>, <<"参数为整数">>}
        ,{<<"领养帮派boss [类型]">>, <<"参数为整数">>}
        ,{<<"喂养帮派boss [类型] [经验]">>, <<"参数为整数">>}
        ,{<<"召唤帮派boss [类型]">>, <<"参数为整数">>}
        ,{<<"寻找帮派boss">>, <<"">>}
        ,{<<"设帮派boss等级 [类型] [等级]">>, <<"参数为整数">>}
        ,{<<"cross_ore">>, <<"跨服仙府状态跳转">>}
        ,{<<"设神魔阵等级 [等级]">>, <<"参数为大于0的整数">>}
        ,{<<"设法宝等级 [类型] [等级]">>, <<"参数为大于0的整数">>}
        ,{<<"清空仙友回归">>, <<"清空仙友回归">>}
        ,{<<"设置女巫能量 [能量]">>, <<"参数为大于0的整数">>}
        ,{<<"设置女巫buff [整数]">>, <<"">>}
        ,{<<"清空宠物云朵">>, <<"">>}
        ,{<<"跨服旅行 [srv_id]">>, <<"">>}
        ,{<<"播放录像 [录像id]">>, <<"">>}
		,{<<"清空限购记录">>, <<"">>}
		,{<<"回故乡">>, <<"离开跨服中心城回到原服的洛水城">>}
		,{<<"更新神药阁">>, <<"更新神药阁排行和阁主">>}
		,{<<"设神药阁等级 [等级]">>, <<"等级范围为1~5">>}
		,{<<"设神药阁建设度 [建设度]">>, <<"参数为大于0的整数">>}
		,{<<"清神药阁任务">>, <<"清全部神药阁任务">>}
		,{<<"还原">>, <<"还原角色">>}
        ,{<<"设套装 [等级]">>, <<"设套装 等级">>}
        ,{<<"设化形等级 [精灵ID] [等级]">>, <<"设化形等级 [精灵ID] [等级]">>}
        ,{<<"发奖励">>, <<"发奖励 [奖励id]">>}
        ,{<<"上榜">>, <<"上榜 [类型id]">>}
        ,{<<"设宠物战力 [整数]">>, <<"设宠物战力 [整数]">>}
        ,{<<"离线消息测试 [类型]">>, <<"1:离线,0：在线">>}
        ,{<<"屏蔽 [类型]">>, <<"1:私聊,2：世界聊天,3：军团聊天">>}
        ,{<<"取消屏蔽 [类型]">>, <<"1:私聊,2：世界聊天,3：军团聊天">>}
        ,{<<"生成宠物">>, <<"">>}
        ,{<<"设宠物 [类型]">>, <<"设置宠物模型->101|102|103">>}
        ,{<<"设宠物等级 [等级]">>, <<"设置宠物等级->1-100级">>}
        ,{<<"设宠物技能 [技能id]">>, <<"设宠物技能 [技能id]">>}
        ,{<<"学宠物技能 [技能阶] [技能等级]">>, <<"设宠物技能 [技能阶1|2|3] [技能等级 1-10级]">>}
        ,{<<"完成新手">>, <<>>}
        ,{<<"清空宠物技能">>, <<"">>}
        ,{<<"设勋章 [勋章id]">>, <<"加载特定勋章条件作为当前修炼的勋章">>}
        ,{<<"断开连接 [消息内容]">>, <<"">>}
        ,{<<"获取宠物经验 [经验值]">>, <<"宠物获得经验升级">>}
        ,{<<"获取碎片 [数量]">>, <<"宠物获得经验升级">>}
        ,{<<"测试客户消息 [内容]">>, <<"测试发送客户消息">>}
    ],
    {reply, {Cmds}};


handle(9910, {Cmd}, Role) ->
    deal_Cmd(Cmd, Role);

%% 容错
handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.

do_deal_Cmd(Cmd, Role) ->
    C = string:tokens(erlang:bitstring_to_list(Cmd), " "),
    ?DEBUG("---~p~n",[C]),
    case catch do_cmd(C, Role) of
        {ok} ->
            {reply, {<<"命令执行成功">>}};
        {ok, NewRole} ->
            {reply, {<<"命令执行成功">>}, NewRole};
        {ok, Msg, NewRole} ->
            {reply, {Msg}, NewRole};
        {false, Reason} ->
            {reply, {Reason}};
        _Err ->
            ?ERR("执行GM命令发生未预料的错误Cmd[~s]:~w", [Cmd, _Err]),
            {reply, {<<"执行命令时发生错误:未知命令或命令格式不正确">>}}
    end.

do_cmd(["pp"], Role) ->
    {reply, {_Type, _Val, _Step}, NRole2} = pet_rpc:handle(12615, {1, 1}, Role),
    {ok, NRole2};

do_cmd(["delsign"], #role{id = {Rid, SrvId}}) ->
    Sql = "delete from sys_signon where rid = ~s and srv_id = ~s",
    db:execute(Sql, [Rid, SrvId]),
    {ok};

do_cmd(["logsuper"], Role = #role{assets = Assets}) ->
    log:log(log_super_boss, {<<"世界Boss最后一击">>, 1, 10043, <<"啦啦啦啦">>, 1111}),
    log:log(log_super_boss, {<<"世界Boss最强先锋">>, 1, 10043, <<"啦啦啦啦">>, 1111}),
    log:log(log_stone, {<<"测试">>, <<"测试">>, Role, Role#role{assets = Assets#assets{stone = 100050}}}),
    {ok};

%% 这个命令暂时只能在7月使用
% do_cmd(["setsign", N], #role{id = {Rid, SrvId}}) ->
%     Day = to_int(N),
%     case N > 0 of 
%         true ->
%             Sql = "delete from sys_signon where rid = ~s and srv_id = ~s",
%             db:execute(Sql, [Rid, SrvId]),  
%             Sql1 = "insert into sys_signon (rid, srv_id, month, lasttime, info) values (~s, ~s, ~s, ~s, ~s)",
%             Info = [{A, 0, 0}||A<-lists:seq(1, Day)],
%             db:execute(Sql1, [Rid, SrvId, 7, 0, util:term_to_string(Info)]),
%             {ok};
%         false ->
%             {ok}
%     end;

do_cmd(["manor", Arg1, Arg2, Arg3, Arg4, Arg5], #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 19521, {[],[{0,to_int(Arg1)},{0,to_int(Arg2)},{0, to_int(Arg3)},{0, to_int(Arg4)},{0, to_int(Arg5)}]}),
    {ok};

do_cmd(["所有日常"], #role{activity2 = #activity2{actions = _Actions}}) ->
    ?DEBUG("所有日常任务 ~w", [_Actions]),
    {ok};

do_cmd(["增加日常", Arg], Role) ->
    TaskId = to_int(Arg),
    activity2:add_a_task(TaskId, Role);

do_cmd(["增加日常1"], Role) ->
    {Role1,_} = activity2:fire_tasks(Role),
    {ok, Role1};

do_cmd(["触发日常", Arg1, Arg2], Role) ->
    Role1 = role_listener:special_event(Role, {to_int(Arg1), to_int(Arg2)}),
    {ok, Role1};
do_cmd(["提交日常", Arg1], Role) ->
    TaskId = to_int(Arg1),
    case activity_rpc:handle(13805, {TaskId}, Role) of
        {reply, {?true, _}, Role1} ->
            ?DEBUG("领取成功"),
            {ok, Role1};
        {fail, rewarded} ->
            ?DEBUG("无法再次领取"),
            {ok};
        _ ->
            ?DEBUG("领取奖励失败"),
            {ok}
    end;

do_cmd(["日常刷新"], Role) ->
    activity2:day_check(Role);

do_cmd(["清日常"], Role = #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 13804, {[]}),
    {ok, Role#role{activity2 = #activity2{}}};
do_cmd(["清主线"], Role = #role{link = #link{conn_pid = ConnPid}, task = Task}) ->
    Task1 = [T || T = #task{type = Type} <- Task, Type =/= ?task_type_zhux],
    sys_conn:pack_send(ConnPid, 10200, {Task1}),
    {ok, Role#role{task = Task1}};
do_cmd(["清副本任务"], Role = #role{link = #link{conn_pid = ConnPid}, task = TaskList}) ->
    TaskList1 = [T || T = #task{type = Type} <- TaskList, Type =/= ?task_type_star_dun],
    sys_conn:pack_send(ConnPid, 10200, {[Task#task{progress = task_rpc:convert_progress(Progress)} || Task = #task{progress = Progress} <- TaskList1]}),
    {ok, Role#role{task = TaskList1}};

do_cmd(["通知"], #role{}) ->
    notice:inform(<<"测试通知">>),
    {ok};


do_cmd(["重置日常"], Role) ->
    {ok, activity2:reset(Role)};

do_cmd(["adv", DungeonId], Role) ->
    adventure:trigger_adventure(Role, to_int(DungeonId), 1, 0),
    {ok};
do_cmd(["14010"], Role) ->
    award_rpc:handle(14010, {}, Role),
    {ok};
do_cmd(["14013", S, H], Role) ->
    award_rpc:handle(14013, {to_int(S), to_int(H)}, Role),
    {ok};
do_cmd(["14014", S, H], Role) ->
    award_rpc:handle(14014, {to_int(S), to_int(H)}, Role),
    {ok};
do_cmd(["cdemon"], _Role) ->
    ?DEBUG("----demon---~p~n", [_Role#role.demon]),
    NRole = _Role#role{demon = #role_demon{}},
    demon_api:push_demon(NRole),
    {ok, NRole};

do_cmd(["random_reset"], _Role = #role{id = {Rid, _}}) ->
    Data = random_award_data:get_random_cond(),
    random_award_mgr:update_cur_cond(Rid, Data),
    put(random_award_cond, Data),
    {ok};

do_cmd(["event"], _Role = #role{event = _Event}) ->
    ?DEBUG("event 状态:~p~n", [_Event]),
    {ok};

do_cmd(["beer"], _Role) ->
    beer ! test,
    {ok, _Role};

do_cmd(["stat"], Role) ->
    NRole = Role#role{status = ?status_normal, tutorial = undefined},
    {ok, NRole};
    
do_cmd(["demong"], _Role = #role{demon = RoleDemon}) ->
    NRole = _Role#role{demon = RoleDemon#role_demon{grab_times = 30}},
    {ok, NRole};

do_cmd(["2v2r", N], Role) ->
   {ok, medal_compete:gm_set_honor(Role, to_int(N))}; 

do_cmd(["2v2", Result, N], Role) ->
   {ok, medal_compete:gm_set_win_die(Role, to_int(Result), to_int(N))}; 

do_cmd(["leisure"], _Role = #role{pid = Pid}) ->
    Msg = {1, 5, 3, 33, 3, 80, 4, 3, 5, 10, 100, 1000, 10000, [{101010, 1, 1}]},
    role:pack_send(Pid, 19893, Msg), %% 推送副本结算  Goal表示等级， Star表示星星数
    {ok};

do_cmd(["medal", N], #role{pid = Pid}) ->
    medal:gm_set(Pid, to_int(N)),
    {ok};

do_cmd(["清空仓库"], Role) ->
    {ok, Role#role{super_boss_store = #super_boss_store{}}};

do_cmd(["获取碎片", T, N], Role) ->
    Type = to_int(T), 
    Num = to_int(N),
    demon:gain_debris(Role, [{Type, Num}]);


do_cmd(["t07"], Role = #role{link = #link{conn_pid = ConnPid}, medal = Medal}) ->
    NMedal =  Medal#medal{wearid = 10013,  cur_rep = 4096000-1600, cur_medal_id = 10014, need_rep = 4096000, condition = [{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{2,100}],
        gain = lists:seq(10001, 10013), pass = lists:seq(10000, 10012)},
    sys_conn:pack_send(ConnPid, 13060, {10014, 4096000-1600, 1600, NMedal#medal.gain, 1, NMedal#medal.condition}),
    {ok, Role#role{medal = NMedal}};


do_cmd(["设勋章", MedalId], Role = #role{id = {Rid, _}, link = #link{conn_pid = ConnPid}, medal = Medal, special = Special}) ->
    Id = to_int(MedalId),
    case Id < 10001 orelse Id > 10014 of 
        true ->
            notice:alert(error, ConnPid, ?L(<<"勋章ID有误">>)),
            {ok};
        false ->
            case medal_data:get_medal_base(Id) of 
                {ok, #medal_base{condition = Cond, need_rep = Need}} ->
                    NMedal = 
                        case Id =:= 10001 of 
                            false -> 
                                medal_mgr:update_top_n_medal(Role, Id - 1),
                                Medal#medal{wearid = Id - 1,  cur_rep = 0, cur_medal_id = Id, need_rep = Need, condition = medal:get_init_cond(), gain = lists:seq(10001, Id - 1), pass = [{A, 0 , 0}||A<-lists:seq(10000, Id - 2)]};
                            true ->
                                Medal#medal{wearid = 0,  cur_rep = 0, cur_medal_id = Id, need_rep = Need, condition = medal:get_init_cond(), gain = [], pass = []}
                        end,
                    medal_mgr:update_cur_medal_cond(Rid, Cond),
                    sys_conn:pack_send(ConnPid, 13060, {Id, 0, NMedal#medal.need_rep, NMedal#medal.gain, 1, NMedal#medal.condition}),
                    NR1 = Role#role{medal = NMedal},
                    NR2 = manor:fire(Id, NR1),


                    NSpecial = 
                        case Id =:= 10001 of 
                            true ->
                                lists:keydelete(?special_medal, 1, Special);
                            false ->
                                case lists:keyfind(?special_medal, 1, Special) of
                                    false -> [{?special_medal, Id - 1, <<"">>}] ++ Special;
                                    _ ->
                                        lists:keyreplace(?special_medal, 1, Special, {?special_medal, Id - 1, <<"">>})
                                end
                        end,
                    NR3 = NR2#role{special = NSpecial},
                    map:role_update(NR3),
                    {ok, NR3};
                {_, Reason} ->
                    notice:alert(error, ConnPid, Reason),
                    {ok}
            end
    end;

do_cmd(["设纹章", N], Role = #role{assets = Assets}) ->
    NewRole = Role#role{assets = Assets#assets{badge = to_int(N)}},
    NR = role_api:push_assets(Role, NewRole),
    {ok, NR};


do_cmd(["庄园"], #role{manor_baoshi = #manor_baoshi{baoshi_npc = _Baoshi}, manor_moyao = #manor_moyao{material_npc = _M},
        manor_trade = #manor_trade{has_npc = _TradeNpc},
        manor_train = #manor_train{has_npc = _TrainNpc}, manor_enchant = #manor_enchant{has_npc = _EnNpc}}
        ) ->
    ?DEBUG("宝石NPC： ~p", [_Baoshi]),
    ?DEBUG("魔药NPC： ~p", [_M]),
    ?DEBUG("跑商NPC： ~p", [_TradeNpc]),
    ?DEBUG("训龙NPC： ~p", [_TrainNpc]),
    ?DEBUG("强化NPC： ~p", [_EnNpc]),
    {ok};

do_cmd(["获取宠物经验", GainExp], _Role = #role{pet = #pet_bag{active = #pet{lev = _Lev, exp = _Exp}}}) ->
    ?DEBUG("-----Lev---~p~n", [_Lev]),
    ?DEBUG("-----Exp---~p~n", [_Exp]),
    Role2 = pet_api:asc_pet_exp(_Role, to_int(GainExp)),
    {ok, Role2};

do_cmd(["设宠物技能", _SkillId], #role{link = #link{conn_pid = ConnPid}, pet = #pet_bag{active = undefined}}) ->
    notice:alert(error, ConnPid, ?L(<<"未生成宠物">>)),
    {ok};
do_cmd(["设宠物技能", SkillId], Role = #role{link = #link{conn_pid = ConnPid},pet = PetBag = #pet_bag{active = Pet = #pet{skill = Skill, skill_slot = Slot, skill_num = Num}}}) ->
    Skill_id = to_int(SkillId),
    case pet_data_skill:get(Skill_id) of 
        {ok, _} ->
            case lists:keyfind(Skill_id, 1, Skill) of 
                false->
                    Step = Skill_id div 100 rem 10,
                    Lev = Skill_id rem 10 , 
                    Exp = case Lev of 
                             1 -> 0;
                             _ -> if
                                    Step == 1 ->
                                        round(math:pow(2, Lev)/2);
                                    Step == 2 ->
                                        round(math:pow(2, 1+Lev)/2);
                                    true ->
                                        round(math:pow(2, 2+Lev)/2)
                                 end
                            end,
                    case erlang:length(Slot) of 
                        0 ->
                            Slots = [Location||{_, _, Location, _}<-Skill],
                            NSkill = Skill ++ [{Skill_id, Exp, lists:last(lists:sort(Slots)) + 1, []}],
                            sys_conn:pack_send(ConnPid, 12613, {NSkill}),
                            {ok, Role#role{pet=PetBag#pet_bag{active =Pet#pet{skill = NSkill, skill_num = Num + 1}}}};
                        _ ->
                            First = lists:nth(1, Slot),
                            NSlot = Slot -- [First],
                            NSkill = Skill ++ [{Skill_id, Exp, First, []}],
                            sys_conn:pack_send(ConnPid, 12613, {NSkill}),
                            {ok, Role#role{pet=PetBag#pet_bag{active =Pet#pet{skill = NSkill, skill_num = Num + 1, skill_slot = NSlot}}}}
                    end;
                _ ->
                    notice:alert(error, ConnPid, ?L(<<"技能已经存在">>)),
                    {ok}
            end;
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            {ok}
    end;

do_cmd(["学宠物技能", Step, Lev], Role) ->
    NRole = pet:gm_set_skill(Role, to_int(Step), to_int(Lev)),
    NR = medal:listener(pet_skill, NRole),
    {ok, NR};

do_cmd(["设宠物", Num], Role = #role{pet = PetBag = #pet_bag{active = Pet}}) ->
        {ok, Role#role{pet=PetBag#pet_bag{active =Pet#pet{base_id = to_int(Num)}}}};

do_cmd(["生成宠物"], Role = #role{link = #link{conn_pid = ConnPid}}) ->
    NRole = pet:create_default_pet({pet,[{base_id, 101}, {name, <<"花樱精灵">>}, {potential, 0, 0, 0, 0}, {per, 25, 25, 25, 25}]}, Role#role{pet = #pet_bag{}}),
    sys_conn:pack_send(ConnPid, 12600, pet:get_pet_info(NRole)),
    {ok, NRole};

do_cmd(["清空宠物技能"], Role = #role{link = #link{conn_pid = ConnPid}, pet = PetBag = #pet_bag{active = Pet}}) ->
    NPet = Pet#pet{skill = [], skill_num = 0, skill_slot = [1, 2]},
    sys_conn:pack_send(ConnPid, 12613, {[]}),
    {ok, Role#role{pet = PetBag#pet_bag{active = NPet}}};

do_cmd(["屏蔽", Num], Role) ->
    case setting:set_shield(to_int(Num),Role) of 
        {ok, NRole = #role{setting = #setting{shield = _Shield}}} ->
            ?DEBUG("-----~w~n",[_Shield]),
            {ok, NRole};
        {false, _} ->
            {ok}
    end; 

do_cmd(["新手装备", Num], Role) ->
    ?DEBUG("---->> 新手装备 ~p", [Num]),
    case eqm:puton_init_eqm(to_int(Num),Role) of 
        {ok, NRole} ->
            {ok, NRole};
        {false, _Reason} ->
            ?DEBUG("新手装备失败: ~p", [_Reason]),
            {ok}
    end; 

do_cmd(["清装备"], Role) ->
    Role1 = Role#role{eqm = []},
    Role2 = role_api:push_attr(Role1),
    {ok, Role2};
do_cmd(["查看装备"], #role{eqm = Eqm}) ->
    ?DEBUG("所有装备  ~w", [Eqm]),
    {ok};

do_cmd(["查看外观"], #role{looks = Looks}) ->
    ?DEBUG("外观数据  ~w", [Looks]),
    {ok};


do_cmd(["查看来信"], #role{npc_mail = _NpcMail}) ->
    ?DEBUG("当前来信情况  ~w", [_NpcMail]),
    {ok};

do_cmd(["新章节"], #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 10163, {1400}),
    {ok};

do_cmd(["触发来信事件", Order], Role = #role{}) ->
    Order1 = to_int(Order),
    {ok, case Order1 of
        1 ->
            role_listener:finish_task(Role, 10001);
        2 -> 
            role_listener:kill_npc(Role, 10300, 1);
        3 ->
            role_listener:special_event(Role, {1061, 210401});
        _ ->
            Role
    end};

do_cmd(["重置来信"], Role) ->
    {ok, Role#role{npc_mail = npc_mail_data:get()}};

do_cmd(["设远方来信可领"], Role) ->
    All = npc_mail_data:get(),
    N = [NpcMail#npc_mail{status = 1} || NpcMail <- All ],
    Role1 = Role#role{npc_mail = N},
    npc_mail:push(Role1),
    {ok, Role1};

do_cmd(["取消屏蔽", Num], Role) ->
    case setting:cancel_shield(to_int(Num),Role) of 
        {ok, NRole = #role{setting = #setting{shield = _Shield}}} ->
            ?DEBUG("-----~w~n",[_Shield]),
            {ok, NRole};
        {false, _} ->
            {ok}
    end;

%% 清理首冲标志
do_cmd(["清首充标志"], Role = #role{vip = Vip}) ->
    Role1 = Role#role{vip = Vip#vip{charge_cnt = 0}},
    vip:push_charge_flag(Role1),
    {ok, Role1};

do_cmd(["月卡信息"], #role{month_card = _MonthCard}) ->
    ?DEBUG("月卡信息  ~w", [_MonthCard]),
    {ok};

do_cmd(["月卡天数"], Role = #role{month_card = M = #month_card{last_gold_day = Day}}) ->
    {ok, Role#role{month_card = M#month_card{last_gold_day = Day-1}}};

do_cmd(["月卡冲值"], Role = #role{}) ->
    Role1 = charge:online_pay(Role, 300, 0),
    {ok, Role1};

do_cmd(["月卡隔天"], Role = #role{}) ->
    charge:month_card_timer_callback(Role);

do_cmd(["月卡奖励"], #role{id = Rid}) ->
    G = [#gain{label = gold, val = 120}],
    award:send(Rid, 304000, G),
    {ok};

do_cmd(["card", Card], Role) ->
    Card1 = to_int(Card),
    Ret = dungeon_cards:get_config_item(Card1, Role),
    {{gain, item, V},_} = Ret,
    {ok, Role1} = role_gain:do([#gain{label = item, val = V}], Role),
    ?DEBUG("翻牌获得物品: ~p" , [Ret]),
    {ok, Role1};

do_cmd(["查看角色", Rid], #role{id = {_, SrvId}}) ->
    Rid1 = to_int(Rid),
    case role_api:c_lookup(by_id, {Rid1, SrvId}, to_role) of
        {ok, _N, R} when is_record(R, role) ->
            {reply, role_api:pack_proto_msg(10010, R)};
        _E ->
            case role_data:fetch_role(by_id, {Rid, SrvId}) of
                {ok, R} ->
                    R1 = role_attr:calc_attr(R),
                    #role{attr = _Attr} = R1,
                    ?DEBUG("查回来的数据为 Attr: ~w", [_Attr]),
                    %% ?DEBUG("没计算前角色数据: ~w", [R]),
                    {ok};
                    %% {reply, role_api:pack_proto_msg(10010, R)};
                    {false, _} ->
                        {ok}
                end
        end;


do_cmd(["进入比武场", RoomId], Role) ->
    cross_pk:role_enter(Role, list_to_integer(RoomId));

do_cmd(["退出比武场"], Role) ->
    cross_pk:role_leave(Role);

do_cmd(["获取物品", BaseId, Num], Role = #role{id = Rid}) ->
    case storage:make_and_add_fresh(to_int(BaseId), 0, to_int(Num), Role) of
        {ok, NewRole, _} -> 
            NewRole2 = role_listener:get_item(NewRole, #item{base_id = to_int(BaseId), quantity = to_int(Num)}),
            NewRole3 = medal:listener(item, NewRole2, {to_int(BaseId),to_int(Num)}),
            random_award:item(NewRole3, to_int(BaseId), to_int(Num)),
            ?DEBUG("----"), 
            {ok, NewRole3};
        {make_error, Reason} -> {false, Reason};
        {add_error, Reason1} ->
            Gains = [#gain{label = item, val = [to_int(BaseId), 0, to_int(Num)]}],
            award:send(Rid, 202001, Gains),
            notice:alert(succ, Role, ?MSGID(<<"背包已满，奖励发送到奖励大厅">>)),
            {false, Reason1}
    end;

do_cmd(["设虔诚值", Num], Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{devout_value = Devout_Val}}}) ->
        {ok, Role#role{pet=PetBag#pet_bag{active =Pet#pet{devout_value = Devout_Val + to_int(Num)}}}};

do_cmd(["上榜", RankId], Role) ->
        {rank_celebrity:gm_in_rank(Role,to_int(RankId))};

do_cmd(["跨服送花统计"], #role{}) ->
    center:cast(c_rank_mgr, cross_flower, []),
    {ok};

do_cmd(["获取绑定物品", BaseId, Num], Role = #role{}) ->
    case storage:make_and_add_fresh(to_int(BaseId), 1, to_int(Num), Role) of
        {ok, NewRole, _} -> 
            NewRole2 = role_listener:get_item(NewRole, #item{base_id = to_int(BaseId), quantity = to_int(Num)}),
            {ok, NewRole2};
        {make_error, Reason} -> {false, Reason};
        {add_error, Reason1} -> {false, Reason1}
    end;

do_cmd(["设离线经验"], Role = #role{offline_exp = OffInfo}) ->
    NewRole = Role#role{offline_exp = OffInfo#offline_exp{all_time = 36000, all_exp = 100000}}, 
    {ok, NewRole};

do_cmd(["在线时间", Time], Role = #role{campaign = Campaign}) ->
    NewRole = Role#role{campaign = Campaign#campaign_role{day_online = {util:unixtime(), list_to_integer(Time)}}}, 
    {ok, NewRole};

do_cmd(["连续在线天数", Days], Role = #role{campaign = Campaign}) ->
    NewRole = Role#role{campaign = Campaign#campaign_role{keep_days = {list_to_integer(Days), util:unixtime()}}}, 
    {ok, NewRole};

do_cmd(["清5倍"], Role = #role{offline_exp = OffInfo}) ->
    NewRole = Role#role{offline_exp = OffInfo#offline_exp{sit_exp5 = 0}}, 
    {ok, NewRole};

do_cmd(["清转盘次数"], Role) ->
    {ok, NewRole} = lottery_gold:gm(Role),
    {ok, NewRole};

do_cmd(["清帮会历练"], Role) ->
    NewRole = guild_practise:gm(reset, Role), 
    {ok, NewRole};

do_cmd(["后台活动", TotalId, CampId, CondId, Card], Role) ->
    case campaign_adm_reward:exchange(Role, list_to_integer(TotalId), list_to_integer(CampId), list_to_integer(CondId), util:to_binary(Card)) of
        {ok, NRole} -> {ok, NRole};
        {false, Reason} when is_binary(Reason) -> {false, Reason};
        {false, Reason} -> {false, util:fbin("相关资产不足:~w", [Reason])}
    end;

do_cmd(["更新日常目标"], Role) ->
    achievement_everyday:reset(Role);

do_cmd(["清活动任务"], Role = #role{campaign = Campaign}) ->
    {ok, Role#role{campaign = Campaign#campaign_role{task_list = []}}};

%do_cmd(["后台总活动"], _Role) ->
%    CampTotalList = campaign_adm:list_all(),
%    {false, util:fbin(<<"~p:[~w]">>, [length(CampTotalList), [I#campaign_total.iTyped || I <- CampTotalList]])};

do_cmd(["重载后台活动"], _Role) ->
    campaign_adm:reload(),
    {ok};

do_cmd(["后台子活动", TotalId], _Role) ->
    case campaign_adm:lookup(list_to_integer(TotalId)) of
        false -> {false, <<"0">>};
        #campaign_total{camp_list = CampList} -> 
            {false, util:fbin(<<"~p:[~w]">>, [length(CampList), [I#campaign_adm.id || I <- CampList]])}
    end;

do_cmd(["后台规则", TotalId, CampId], _Role) ->
    case campaign_adm:lookup(list_to_integer(TotalId), list_to_integer(CampId)) of
        false -> {false, <<"0">>};
        {ok, _TotalCamp, #campaign_adm{conds = Conds}} -> 
            {false, util:fbin(<<"~p:[~w]">>, [length(Conds), [I#campaign_cond.id || I <- Conds]])}
    end;

do_cmd(["任务状态"], #role{task = _Task}) ->
    ?DEBUG("当前任务状态: ~w", [_Task]),
    {ok};

do_cmd(["获取多个物品", BitString], Role = #role{}) ->
    List = ic_pragma:list_to_term(BitString),
    do_cmd(List, Role);
do_cmd([], Role) -> {ok, Role};
do_cmd([{BaseId, Num} | T], Role) ->
    case do_cmd(["获取物品", BaseId, Num], Role) of
        {false, Reason} -> {false, Reason}; %% TODO: 会有一个bug,最后背包已满失败,客户端会收到消息但服务端会回滚
        {ok, NewRole} ->
            do_cmd(T, NewRole)
    end;

do_cmd(["使用物品", Id, Num], Role) ->
    Id1 = to_int(Id),
    Num1 = to_int(Num),
    case item_rpc:handle(10315, {Id1, Num1}, Role) of
        {reply, {?false, _Msg}} ->
            ?DEBUG("使用物品失败 ~s", [_Msg]),
            {ok};
        {reply, {?true, _Msg}, Role1} ->
            ?DEBUG("使用物品成功 ~s", [_Msg]),
            {ok, Role1}
    end;

do_cmd(["获取瓜瓜乐"], Role) ->
    case item_rpc:handle(10360, {}, Role) of
        {reply, {?false, _MsgId}} ->
            ?DEBUG("领取失败  失败ID ~w", [_MsgId]),
            {ok};
        {reply, {?true, _MsgId}, Role1} ->
            ?DEBUG("领取成功!!!"),
            {ok, Role1}
    end;

do_cmd(["瓜瓜乐数据"], #role{guaguale = _Guaguale}) ->
    ?DEBUG("瓜瓜乐数据  ~w", [_Guaguale]),
    {ok};

do_cmd(["全身", Num], Role = #role{link = #link{conn_pid = ConnPid}, eqm = Eqm}) ->
    Enchant = to_int(Num),
    case Enchant >= 0 andalso Enchant =< 20 of
        true -> 
            NewEqm = do_all_enchant(Eqm, Eqm, ConnPid, Enchant),
            NR = looks:calc(Role#role{eqm = NewEqm}),
            NR1 = role_api:push_attr(NR),
            looks:refresh(Role, NR1),
            {ok, NR1};
        false -> {false, <<"亲,强化等级只能是0-20啊!!!">>}
    end;

do_cmd(["强化装备", Str, Num], Role = #role{link = #link{conn_pid = ConnPid}, wing = Wing, eqm = Eqm}) ->
    Pos = to_int(Str),
    Enchant = to_int(Num),
    ?DEBUG("----> ~p ~p", [Pos, Enchant]),
    case  Pos =/= 0 of
        true ->
            case Enchant >= 0 andalso Enchant =< 20 of
                true ->
                    case eqm:find_eqm_by_id(Eqm, Pos) of
                        {ok, Item} ->
                            NewItem0 = blacksmith:recalc_attr(Item#item{enchant = Enchant}),
                            NewItem = blacksmith:check_enchant_hole(NewItem0),
                            {ok, NewEqm, _NewItem} = storage_api:fresh_item(Item, NewItem, Eqm, ConnPid),
                            NewWing = storage_api:fresh_wing(Item, NewItem, Wing, ConnPid),
                            NR = looks:calc(Role#role{eqm = NewEqm, wing = NewWing}),
                            NR1 = role_api:push_attr(NR),
                            looks:refresh(Role, NR1),
                            {ok, NR1};
                        _ -> {false, <<"请先穿戴此装备,再进行强化">>}
                    end;
                false -> {false, <<"请输入0-20强化等级">>}
            end;
        false -> {false, <<"装备部位名错误">>}
    end;

do_cmd(["查看强化", StrId], Role) ->
    Id = to_int(StrId),
    case blacksmith_rpc:handle(10502, {Id}, Role) of
        {reply, _} ->
            {ok};
        {false, _R} ->
            {ok}
    end;

do_cmd(["强化", StrId, StrAutoBuy], Role) ->
    Id = to_int(StrId),
    AutoBuy = to_int(StrAutoBuy),
    case blacksmith_rpc:handle(10505, {Id, AutoBuy}, Role) of
        {reply, {0, _Reason}} ->
            ?DEBUG("失败 ~s", [_Reason]),
            {ok};
        {reply, {0, Msg}, Role1} ->
            ?DEBUG("失败 1  ~s", [Msg]),
            {ok, Role1};
        {reply, {1, Msg}, Role1} ->
            ?DEBUG("成功  ~s", [Msg]),
            {ok, Role1};
        _Ret ->
            ?DEBUG("返回了未知值 ~w", [_Ret]),
            {ok}
    end;

do_cmd(["强化10", StrId, StrAutoBuy], Role) ->
    Id = to_int(StrId),
    AutoBuy = to_int(StrAutoBuy),
    case blacksmith_rpc:handle(10503, {Id, AutoBuy}, Role) of
        {reply, {0, _Reason}} ->
            ?DEBUG("失败 ~s", [_Reason]),
            {ok};
        {reply, {1, Flags, Msg}, Role1} ->
            ?DEBUG("成功强化10次 ~w   ~s", [Flags, Msg]),
            {ok, Role1};
        _Ret ->
            ?DEBUG("返回了未知值 ~w", [_Ret]),
            {ok}
    end;


do_cmd(["计算装备战斗力", Num], #role{career = Career, eqm = Eqm}) ->
    Pos = to_int(Num),
    ?DEBUG("----> 装备部位 ~p ", [Pos]),
    case  Pos =/= 0 of
        true ->
            case eqm:find_eqm_by_id(Eqm, Pos) of
                {ok, Item} ->
                    eqm_api:calc_point(Item, Career),
                    ?DEBUG("计算装备战斗力成功 ..."),
                    {ok};
                _ -> {false, <<"请先穿戴此装备,再进行强化">>}
            end;
        false -> {false, <<"装备部位名错误">>}
    end;

do_cmd(["设主城ID", _Id], Role = #role{link = #link{conn_pid = ConnPid}}) ->
    _Id1 = to_int(_Id),
    sys_conn:pack_send(ConnPid, 10163, {_Id1}),
    {ok, Role#role{scene_id = _Id1}};

do_cmd(["主城ID"], #role{scene_id = _SceneId}) ->
    ?DEBUG("第一次主城ID ~w", [_SceneId]),
    {ok};

do_cmd(["完成章节"], Role = #role{}) ->
    map_rpc:handle(10164, {}, Role);   

do_cmd(["speed"], #role{speed = _S}) ->
    ?DEBUG("移动速度: ~w", [_S]),
    {ok};

do_cmd(["洗炼装备", Str, Num], Role = #role{eqm = Eqm}) ->
    Pos = to_int(Str),
    WashCnt = to_int(Num),
    ?DEBUG("----> ~p ~p", [Pos, WashCnt]),
    case  Pos =/= 0 of
        true ->
            case eqm:find_eqm_by_id(Eqm, Pos) of
                {ok, Item} ->
                    blacksmith:gm_batch_polish(Role, Item, WashCnt),
                    {ok, Role};
                _ -> {false, <<"请先穿戴此装备,再进行测试">>}
            end;
        false -> {false, <<"装备部位名错误">>}
    end;

do_cmd(["洗炼", Str, Num], Role = #role{link = #link{conn_pid = ConnPid}, wing = Wing, eqm = Eqm}) ->
    Pos = to_int(Str),
    Star = to_int(Num),
    case  Pos =/= 0 of
        true ->
            case Star >= 1 andalso Star =< 10 of
                true ->
                    case eqm:find_eqm_by_id(Eqm, Pos) of
                        {ok, Item = #item{base_id = BaseId, attr = Attr, require_lev = Lev}} ->
                            NewAttr = do_add_polish(Attr, BaseId, Lev, Star),
                            NewItem0 = blacksmith:recalc_attr(Item#item{attr = NewAttr}),
                            NewItem = blacksmith:check_enchant_hole(NewItem0),
                            {ok, NewEqm, _NewItem} = storage_api:fresh_item(Item, NewItem, Eqm, ConnPid),
                            NewWing = storage_api:fresh_wing(Item, NewItem, Wing, ConnPid),
                            NR = looks:calc(Role#role{eqm = NewEqm, wing = NewWing}),
                            NR1 = role_api:push_attr(NR),
                            looks:refresh(Role, NR1),
                            {ok, NR1};
                        _ -> {false, <<"请先穿戴此装备,再进行洗炼">>}
                    end;
                false -> {false, <<"请输入1-10洗炼星级">>}
            end;
        false -> {false, <<"装备部位名错误">>}
    end;

do_cmd(["设品质", Str, Num], Role = #role{link = #link{conn_pid = ConnPid}, eqm = Eqm}) ->
    Pos = to_pos(Str),
    Craft = to_int(Num),
    case Pos =/= 0 of
        true ->
            case Craft >= ?craft_0 andalso Craft =< ?craft_4 of
                true ->
                    case eqm:find_eqm_by_id(Eqm, Pos) of
                        {ok, Item} ->
                            NewItem = blacksmith:recalc_attr(Item#item{craft = Craft}),
                            {ok, NewEqm, _NewItem} = storage_api:fresh_item(Item, NewItem, Eqm, ConnPid),
                            NR = looks:calc(Role#role{eqm = NewEqm}),
                            NR1 = role_api:push_attr(NR),
                            looks:refresh(Role, NR1),
                            {ok, NR1};
                        _ -> {false, <<"请先穿戴此装备,再进行提升">>}
                    end;
                false -> {false, <<"请输入0-4品质等级">>}
            end;
        false -> {false, <<"装备部位名错误">>}
    end;

do_cmd(["清空背包"], Role = #role{link = #link{conn_pid = ConnPid}, bag = Bag = #bag{volume = Volume}}) ->
    NewRole = Role#role{bag = Bag#bag{items = [], free_pos = lists:seq(1, Volume)}},
    storage_api:refresh_client_item(del, ConnPid, [{?storage_bag, Role#role.bag#bag.items}]),
    {ok, NewRole};

do_cmd(["清空魔晶背包"], Role = #role{link = #link{conn_pid = ConnPid}, pet_magic = #pet_magic{volume = Volume}}) ->
    NewRole = Role#role{pet_magic = #pet_magic{free_pos = lists:seq(1, Volume)}},
    storage_api:refresh_client_item(del, ConnPid, [{?storage_pet_magic, Role#role.pet_magic#pet_magic.items}]),
    {ok, NewRole};

do_cmd(["清空仙境背包"], Role = #role{link = #link{conn_pid = ConnPid}}) ->
    NewRole = Role#role{casino = #casino{}},
    storage_api:refresh_client_item(del, ConnPid, [{?storage_casino, Role#role.casino#casino.items}]),
    {ok, NewRole};

do_cmd(["清空缘分"], Role) ->
    {ok, Role#role{fate = #fate{}}};

do_cmd(["设金币", Num], Role = #role{assets = Assets}) ->
    NewRole = Role#role{assets = Assets#assets{coin = to_int(Num)}},
    NRole = medal:listener(coin,NewRole),
    % NR = role_api:push_assets(NRole),
    % NRole = role_listener:coin(NewRole,to_int(Num)),
    NR = role_api:push_assets(Role, NRole),
    {ok, NR};

do_cmd(["设魂气", Num], Role = #role{assets = Assets}) ->
    NewRole = Role#role{assets = Assets#assets{soul = to_int(Num)}},
    NR = role_api:push_assets(Role, NewRole),
    {ok, NR};

do_cmd(["设绑定铜", Num], Role = #role{assets = Assets}) ->
    NewRole = Role#role{assets = Assets#assets{coin_bind = to_int(Num)}},
    NR = role_api:push_assets(Role, NewRole),
    {ok, NR};

do_cmd(["设晶钻", Num], Role = #role{assets = Assets}) ->
    NewRole = Role#role{assets = Assets#assets{gold = to_int(Num)}},
    NRole = medal:listener(wing, NewRole),
    NRole1 = vip:listener(to_int(Num),NRole),
    NR = role_api:push_assets(Role, NRole1),
    random_award:gold(NR, to_int(Num)),
    {ok, NR};
do_cmd(["设绑定晶钻", Num], Role = #role{assets = Assets}) ->
    NewRole = Role#role{assets = Assets#assets{gold_bind = to_int(Num)}},
    NR = role_api:push_assets(Role, NewRole),
    {ok, NR};

do_cmd(["设灵力", Num], Role = #role{assets = Assets}) ->
    NewRole = Role#role{assets = Assets#assets{psychic = to_int(Num)}},
    NR = role_api:push_assets(Role, NewRole),
    {ok, NR};

do_cmd(["设阅历", Num], Role = #role{assets = Assets}) ->
    NewRole = Role#role{assets = Assets#assets{attainment = to_int(Num)}},
    NR = role_api:push_assets(Role, NewRole),
    {ok, NR};

do_cmd(["设竞技场积分", Num], Role = #role{assets = Assets}) ->
    NewRole = Role#role{assets = Assets#assets{arena = to_int(Num)}},
    NR = role_api:push_assets(Role, NewRole),
    {ok, NR};

do_cmd(["设师门积分", Num], Role = #role{assets = Assets}) ->
    NewRole = Role#role{assets = Assets#assets{career_devote = to_int(Num)}},
    NR = role_api:push_assets(Role, NewRole),
    {ok, NR};

do_cmd(["我要变GM"], Role) ->
    NR = role_api:push_attr(Role#role{label = 1}),
    NR2 = role_api:push_assets(Role, NR),
    {ok, NR2};

do_cmd(["VIP信息"], Role) ->
    Msg = util:fbin("VIP:~w", [Role#role.vip]),
    {false, Msg};

do_cmd(["发传闻"], Role) ->
    Msg = notice:get_item_msg([{101010, 1, 1}]),
    ?DEBUG("**********  ~w", [Msg]),
    role_group:pack_cast(world, 10932, {7, 0, Msg}),
    Msg1 = notice:get_role_msg(Role),
    role_group:pack_cast(world, 10932, {7, 0, Msg1}),
    {ok};


do_cmd(["获取翅膀技能", SkillId], Role) ->
    wing_skill:add_bag_skill(Role, list_to_integer(SkillId));

do_cmd(["t1"], Role = #role{assets = #assets{energy = _E}, energy = _Eng}) ->
    ?DEBUG("体力系统: ~p~n, ~p", [_E, _Eng]),
    {ok, Role};

do_cmd(["x1"], Role) ->
?DEBUG(" ------->>> guild_wish   x1"),
    role_listener:guild_wish(Role, 1),
    {ok, Role};

do_cmd(["x2"], Role) ->
?DEBUG(" ------->>> guild_shop"),
    role_listener:guild_buy(Role, 2),
    {ok, Role};

do_cmd(["x3"], Role) ->
?DEBUG(" ------->>> guild_kill_pirate "),
    role_listener:guild_kill_pirate(Role, 3),
    {ok, Role};

do_cmd(["x4"], Role) ->
?DEBUG(" ------->>> guild_chleg  "),
    role_listener:guild_chleg(Role, 4),
    {ok, Role};

do_cmd(["x5"], Role) ->
?DEBUG(" ------->>> guild_gc  "),
    role_listener:guild_gc(Role, 5),
    {ok, Role};
do_cmd(["x6"], Role) ->
?DEBUG(" ------->>> guild_dungeon  "),
    role_listener:guild_dungeon(Role, 6),
    {ok, Role};
do_cmd(["x7"], Role) ->
?DEBUG(" ------->>> guild_tree  "),
    role_listener:guild_tree(Role, 7),
    {ok, Role};
do_cmd(["x8"], Role) ->
?DEBUG(" ------->>> guild_activity  "),
    role_listener:guild_activity(Role, 8),
    {ok, Role};
do_cmd(["x9"], Role) ->
?DEBUG(" ------->>> guild_skill  "),
    role_listener:guild_skill(Role, 9),
    {ok, Role};
do_cmd(["x10"], Role) ->
?DEBUG(" ------->>> guild_multi_dun  "),
    role_listener:guild_multi_dun(Role, 9),
    {ok, Role};
do_cmd(["get_target", _Lev], Role) ->
    ?DEBUG(" ------->>> get_target  "),
    ?DEBUG("获取到的军团目标 ~p~n", [guild_aim:get_target(to_int(_Lev))]),
    {ok, Role};

do_cmd(["清军团在线时间"], Role = #role{energy = Eng}) ->
    Role1 = Role#role{energy = Eng#energy{date = util:unixtime(), online_time = 0}},
    {ok, energy:init_guild_online(Role1)};

do_cmd(["check_out"], Role = #role{guild = #role_guild{pid = Pid}}) when is_pid(Pid) ->
    ?DEBUG(" ------->>> check out target  "),
    Pid ! checkout_target,
    {ok, Role};

do_cmd(["升级宝石", E, V], Role = #role{eqm = Eqms}) ->
    EqmPos = to_int(E),
    Hole = to_int(V),
    Item = eqm:find_eqm_by_id(Eqms, EqmPos),
    case blacksmith:lvlup_stone(Role, Item, Hole) of
        {false, _Reason} ->
            ?DEBUG("~~~  升级失败 ~p", [_Reason]);
        {ok, Role1} ->
            {ok, Role1}
    end;

do_cmd(["所有任务"], #role{task = Task, task_role = #task_role{}}) ->
    ?DEBUG("------>> 所有任务 已接 :~w", [Task]),
    {ok};

do_cmd(["测试委托"], _Role) ->
    daily_task_delegate_mgr:test(),
    {ok};


do_cmd(["设等级", Num], Role) ->
    ?DEBUG("================设等级:~w", [Num]),
    Lev = to_int(Num),
    case Lev >= 0 andalso Lev =< ?ROLE_LEV_LIMIT of
        true ->
            NewRole1 = Role#role{lev = Lev},
            NewRole = role_listener:lev_up(NewRole1),
            %% catch task:lev_up_fire(NewRole),
            %% friend:wish_lev_up(NewRole),
            NewRole2 = medal:listener(level, NewRole),
            NR = role_api:push_attr(NewRole2),
            NR2 = role_api:push_assets(Role, NR),
            arena_career_mgr:sign(NR2),
            {ok, NR2};
        false ->
            {ok}
    end;

do_cmd(["设军团等级", Num], Role) ->
    ?DEBUG("================设等级:~w", [Num]),
    Lev = to_int(Num),
    case Lev >= 0 andalso Lev =< 50 of
        true ->
            guild_common:set_guild_lev(Role,Lev),
            {ok, Role};
        false ->
            {ok}
    end;

do_cmd(["清除领取"], Role) ->
    ?DEBUG("=============== 清除领用奖励"),
    {ok,guild_role:alters([{claim_exp, ?false}], Role)};



do_cmd(["设战力", Num], Role) ->
    ?DEBUG("================设战力:~w", [Num]),
    Power = to_int(Num),
    NewRole = Role#role{attr = #attr{fight_capacity = Power}},
    rank:listener(power, Role, NewRole),
    NewRole1 = medal:listener(fight_capacity, NewRole),
    {ok, NewRole1};

do_cmd(["设宠物战力", Num], Role = #role{pet = PetBag = #pet_bag{active = Pet}}) ->
    ?DEBUG("====设宠物战力:~w", [Num]),
    Power = to_int(Num),
    case Power > 0 of
        true ->
            NewRole = Role#role{pet = PetBag#pet_bag{active = Pet#pet{fight_capacity = Power}}},
            rank:listener(pet, NewRole),
            NewRole1 = medal:listener(dragon_fight_capacity, NewRole),
            {ok, NewRole1};
        false ->
            {ok}
    end;

do_cmd(["增加宠物经验", Num], Role) ->
    ?DEBUG("====增加宠物经验:~w", [Num]),
    Exp = to_int(Num),
    NewRole = pet_api:asc_pet_exp(Role, Exp),
    {ok, NewRole};


do_cmd(["设元神等级", Num1, Num2], Role) ->
    Lev = to_int(Num1),
    State = to_int(Num2) * 10,
    case Lev > 0 andalso Lev < 81 andalso State >= 0 of
        true ->
            channel:gm_set_channel(Role, Lev, State);
        false ->
            {ok}
    end;

do_cmd(["消耗", Num1, Num2], Role) ->
    BaseId = to_int(Num1),
    Num = to_int(Num2),
    role_gain:do([#loss{label=item, val=[BaseId,0,Num]}], Role);

do_cmd(["设符石", Num], Role = #role{assets = Ast}) ->
    ?DEBUG("*******  设符石"),
    Val = to_int(Num),
    Role1 = Role#role{assets = Ast#assets{stone = Val}},
    role_api:push_assets(Role, Role1),
    {ok, Role1};

do_cmd(["清元神"], Role) ->
    {ok, channel:gm_clean(Role)};

do_cmd(["设职业", Num], Role = #role{link = #link{conn_pid = ConnPid}}) ->
    Career = to_int(Num),
    case Career >= ?career_zhenwu andalso Career =< ?career_xinshou of
        true ->
            role:send_buff_begin(),
            NewRole = #role{vip = #vip{portrait_id = FaceId}} = role_api:choose_career(Career, Role),
            sys_conn:pack_send(ConnPid, 10020, {1, <<"设职业陈公公">>, Career, FaceId}),
            role:send_buff_flush(),
            {ok, NewRole};
        false ->
            {ok}
    end;

do_cmd(["设速度", Num], Role = #role{team_pid = TeamPid}) ->
    S = to_int(Num),
    case S > 0 andalso S < 1000 andalso not is_pid(TeamPid) of
        true ->
            NewRole = Role#role{speed = S},
            map:role_update(NewRole),
            {ok, NewRole};
        false ->
            {ok}
    end;

do_cmd(["扩展背包", Num], Role = #role{}) ->
    S = to_int(Num),
    case S > 0 andalso S < 1000 of
        true ->
            case storage_api:add_storage_volume(S, Role) of
                {false, _Reason} ->
                    ?DEBUG("扩展失败, 原因: ~p", [_Reason]);
                {ok, _NowVolume, NewRole} ->
                    ?DEBUG("   扩展成功  "),
                    {ok, NewRole}
            end;
        false ->
            {ok}
    end;

do_cmd(["设仙道历练", Num], Role = #role{assets = Assets}) ->
    X = to_int(Num),
    NewRole = Role#role{assets = Assets#assets{lilian = X}},
    {ok, NewRole};

do_cmd(["设血法", Num], Role = #role{hp_max = HpMax, mp_max = MpMax}) ->
    Per = to_int(Num) / 100,
    NewRole = Role#role{hp = erlang:trunc(Per * HpMax), mp = erlang:trunc(Per * MpMax)},
    NR = role_api:push_attr(NewRole),
    {ok, NR};

do_cmd(["修炼武器", Type], Role) ->
    TrainType = to_int(Type),
    case blacksmith_rpc:handle(10501, {1, 3, TrainType}, Role) of
        {reply, {0, Reason}} -> {false, Reason};
        {reply, {1, _Msg}, NewRole} ->
            {ok, NewRole}
    end;

do_cmd(["学技能", Num], Role) ->
    Lev = to_int(Num),
    case Lev > 0 andalso Lev < 14 of
        true ->
            NR = skill:gm_set_skill2(Role, Lev),
            NR1 = medal:listener(skill, NR),
            {ok, NR1};
        false ->
            {ok}
    end;

do_cmd(["接神秘任务", StrTaskId], Role) ->
    TaskId = to_int(StrTaskId),
    case task:accept_chain(#task_param_accept{role = Role, task_id = TaskId}) of
        {ok, #task_param_accept{role = Role1}} ->
            {ok, Role1};
        _ ->
            {ok}
    end;

do_cmd(["接受任务", ParamTaskId], Role = #role{link = #link{conn_pid = ConnPid}}) ->
    TaskId = erlang:list_to_integer(util:to_list(ParamTaskId)),
    ?DEBUG("接受任务[TaskId:~w]", [TaskId]),
    case task:gm_accept(TaskId, Role) of
        {ok, NewRole = #role{task = TaskList}} ->
            ?DEBUG("接受任务成功:~w", [TaskId]),
            L = [Tsk || Tsk <- TaskList, Tsk#task.task_id =:= TaskId],
            case length(L) > 0 of
                true ->
                    {ok, #task_base{type = _Type, npc_accept = NpcAccept, npc_commit = NpcCommit}} = task_data:get_conf(TaskId),
                    [Task = #task{status = Status}|_] = L,
                    task_rpc:send_add_accepted_task(ConnPid, Task), %% 增加已接任务
                    task_rpc:send_del_acceptable_task(ConnPid, TaskId), %% 删除可接任务 
                    %% task:delete_cache(accetable, Type, [TaskId]),
                    task_rpc:send_upd_npc_status(ConnPid, [{NpcAccept, TaskId, 0}]),
                    case Status =:= 1 of
                        true -> %% 已完成
                            task_rpc:send_upd_npc_status(ConnPid, [{NpcCommit, TaskId, 3}]);
                        false -> %% 未完成
                            task_rpc:send_upd_npc_status(ConnPid, [{NpcAccept, TaskId, 2}])
                    end;
                false ->
                    undo
            end,
            sys_conn:pack_send(ConnPid, 10207, {1, TaskId}),
            {ok, NewRole};
        {false, Reason} ->
            ?DEBUG("接受任务失败:~s", [Reason]),
            {false, Reason}
    end;

do_cmd(["提交任务"], Role = #role{task = Task, career = Career, id = {RoleId, SrvId}, link = #link{conn_pid = ConnPid}}) ->
%%    TaskId = erlang:list_to_integer(util:to_list(ParamTaskId)),
    TaskId = case lists:keyfind(1, #task.type, Task) of
        #task{task_id = Id} -> Id;
        false -> false
    end,
    case TaskId of
        false -> skip;
        TaskId ->
            ?DEBUG("提交任务[TaskId:~w]", [TaskId]),
            case task:finish(TaskId, Role) of
                {ok, NewRole} ->
                    ?DEBUG("提交任务成功:~w", [TaskId]),
                    {ok, #task_base{type = Type, npc_commit = NpcCommit}} = task_data:get_conf(TaskId),
                    task_dao:delete_task(RoleId, SrvId, TaskId),    %% 删除数据库中已接任务
                    task:delete_cache(accepted, Type, [TaskId]),    %% 删除已接任务缓存
                    task_rpc:send_del_accepted_task(ConnPid, TaskId),        %% 发送删除已接任务消息
                    task_rpc:send_upd_npc_status(ConnPid, [{NpcCommit, TaskId, 0}]), %% 删除Npc状态

                    %% 添加新的可接任务
                    NewAcceptableTaskidList = task:refresh_acceptable_task(by_type, NewRole, Type, TaskId),
                    {ok, Data} = task:get_dict(acceptable, Type),
                    AddAcceptable = NewAcceptableTaskidList --  Data,
                    case length(AddAcceptable) > 0 of
                        true -> %% 有新的可接任务
                            task_rpc:send_batch_npc_status(acceptable, ConnPid, AddAcceptable, 1, []), %% 更新Npc状态
                            task_rpc:send_add_acceptable_tasks(ConnPid, Career, AddAcceptable), %% 推送可接任务
                            task:add_cache(acceptable, Type, AddAcceptable);
                        false ->
                            skip 
                    end,
                    sys_conn:pack_send(ConnPid, 10208, {?true, TaskId}),
                    {ok, NewRole};
                {false, _Reason} ->
                    ?DEBUG("提交任务失败:~s", [_Reason]),
                    {ok, Role}
            end
end;

do_cmd(["测试掉落", NpcId, Num], #role{link = #link{}}) ->
    {_SupItemIds, _NormalItemIds} = drop:produce([erlang:list_to_integer(NpcId)], erlang:list_to_integer(Num)),
%%    NewSupItemIds = [{SNpcId, SItemId} || {SNpcId, SItemId} <- SupItemIds, SItemId =/= -1],
%%    NewNormalItems = [{NNpcId, MItems} || {NNpcId, MItems} <- NormalItemIds, length(MItems) > 0],
    ?DEBUG("*********  掉落物品 ~w   ~w", [_SupItemIds, _NormalItemIds]),
    {ok};

do_cmd(["award"], #role{id = Rid}) ->
    G = #gain{label = item, val = [111001, 1, 5]},
    award:send(Rid, 203000, [G]),
    {ok};

do_cmd(["传送到", StrMapId, StrX, StrY], Role) ->
    MapId = list_to_integer(StrMapId),
    X = list_to_integer(StrX),
    Y = list_to_integer(StrY),
    case map:role_enter(MapId, X, Y, Role) of
        {false, _} -> {ok};
        {ok, NewRole} -> {ok, NewRole}
    end;

do_cmd(["发军团传闻"], Role) ->
    guild_rpc:broadcast(Role),
    {ok};

do_cmd(["算属性"], Role) ->
    role_attr:calc_attr(Role),
    {ok};

do_cmd(["设体验时装"], Role) ->
    Role1 = dress:set_exp_fashion(Role),
    {ok, Role1};

do_cmd(["穿体验时装"], Role) ->
    Role1 = dress:puton_exp_fashion(Role),
    {ok, Role1};

do_cmd(["时装测试", Cnt], Role) ->
    Cnt1 = to_int(Cnt),
    do_dress_test(Cnt1, Role);



do_cmd(["a", I], Role) ->
    Id = to_int(I),
    case item_rpc:handle(10343, {[Id]}, Role) of
        {reply, {?false, _R}} ->
            ?DEBUG(" 穿失败  原因 ~s", [_R]);
        {reply, {?true, _R}, Role1} ->
            ?DEBUG("穿成功 "),
            {ok, Role1}
    end;

do_cmd(["b", I], Role) ->
    Id = to_int(I),
    case item_rpc:handle(10345, {Id}, Role) of
        {reply, {?false, _R}} ->
            ?DEBUG("  卸时装失败  原因 ~s", [_R]),
            {ok};
        {reply, {?true, _R}, Role1} ->
            ?DEBUG("卸时装成功 "),
            {ok, Role1}
    end;

do_cmd(["清体验时装"], Role) ->
    Role1 = dress:clear_exp_fashion(Role),
    {ok, Role1};


do_cmd(["manor"], #role{manor_moyao = _ManorMoyao}) ->
    ?DEBUG("所有魔药 ~w", [_ManorMoyao]),
    {ok};

do_cmd(["设全部神觉强化等级", Lev], Role = #role{link = #link{conn_pid = ConnPid}, channels = C = #channels{list = Channels}}) ->
    Lev1 = to_int(Lev),
    A = [RC#role_channel{state = Lev1} || RC=#role_channel{lev = L} <- Channels, L > 0],
    NR1 = Role#role{channels = C#channels{list = A}},
    NewRole = role_listener:special_event(NR1, {20012, update}),
    rank:listener(soul, NewRole),
    NewRole2 = role_listener:special_event(NewRole, {1018, finish}),
    NewRole3 = role_listener:acc_event(NewRole2, {130, 1}), %%元神境界提升一级
    Role4 = medal:listener(divine_3, NewRole3),
    rank_celebrity:divine_jd(Role4),
    ?DEBUG("--After medal--"),                    
    Role5 = role_api:push_attr(Role4),
    [sys_conn:pack_send(ConnPid, 12904, {?true, ?MSGID(<<"神觉强化成功">>), Id, S}) || #role_channel{id = Id, state = S} <- A],
    {ok, Role5};

do_cmd(["设神觉强化等级", Id, Lev], Role = #role{link = #link{conn_pid = ConnPid}, channels = C = #channels{list = Channels}}) ->
    ChannelId = to_int(Id),
    Lev1 = to_int(Lev),
    case lists:keyfind(ChannelId, #role_channel.id, Channels) of
        false ->
            ?ELOG("角色[ID:~w]请求提升的元神不存在[Channel:~w]", [Role#role.id, ChannelId]),
            sys_conn:pack_send(ConnPid, 12904, {?false, ?MSGID(<<"神觉数据错误">>), 0, 0}),
            {ok};
        #role_channel{lev = 0} -> 
            sys_conn:pack_send(ConnPid, 12904, {?false, ?MSGID(<<"神觉还未升级">>), 0, 0}),
            {ok};
        Rc = #role_channel{} ->
            NewRc = Rc#role_channel{state = Lev1},
            NR1 = Role#role{channels = C#channels{list = lists:keyreplace(ChannelId, #role_channel.id, Channels, NewRc)}},
            NewRole = role_listener:special_event(NR1, {20012, update}),
            rank:listener(soul, NewRole),
            NewRole2 = role_listener:special_event(NewRole, {1018, finish}),
            NewRole3 = role_listener:acc_event(NewRole2, {130, 1}), %%元神境界提升一级
            Role4 = medal:listener(divine_3, NewRole3),
            rank_celebrity:divine_jd(Role4),
            ?DEBUG("--After medal--"),                    
            Role5 = role_api:push_attr(Role4),
            sys_conn:pack_send(ConnPid, 12904, {?true, ?MSGID(<<"神觉强化成功">>), ChannelId, Lev1}),
            {ok, Role5}
    end;


do_cmd(["飞", Val0, Val1, Val2], Role = #role{pos = #pos{map = MapId, map_pid = MapPid}}) ->
    Type = list_to_integer(Val0),
    MapBaseId = list_to_integer(Val1),
    NpcBaseId = list_to_integer(Val2),
    {Mid, DX, DY} = case MapId =:= MapBaseId of
        true ->
            #map_npc{x = X, y = Y} =
                lists:keyfind(NpcBaseId, #map_npc.base_id, map:npc_list(MapPid)),
            {MapId, X, Y};
        false ->
            #map_npc{x = X, y = Y} =
                lists:keyfind(NpcBaseId, #map_npc.base_id, map:npc_list(MapBaseId)),
            {MapBaseId, X, Y}
    end,
    ?DEBUG("MAP:~w, X:~w, Y:~w", [Mid, DX, DY]),
    case role_rpc:handle(10021, {Type, Mid, DX, DY}, Role) of
        {reply, {?false, _Reason}} ->
            ?DEBUG("REASON:~w", [_Reason]),
            {ok};
        {reply, {?true, _}, NewRole} -> {ok, NewRole};
        _E ->
            ?DEBUG("ELSE:~w", [_E]),
            {ok}
    end;

do_cmd(["复活", _StrType], Role = #role{link = #link{conn_pid = _ConnPid}}) ->
    NewRole = role_api:revive(Role),
    {ok, NewRole};

do_cmd(["挂"], Role) ->
    NewRole = Role#role{status = ?status_die},
    map:role_update(NewRole),
    {ok, NewRole};

do_cmd(["许愿池"], _Role) ->
    wish:adm_gm_start(),
    {ok};

do_cmd(["许愿设置", StrNum, StrCd], _Role) ->
    Num = list_to_integer(StrNum),
    Cd = list_to_integer(StrCd),
    wish:adm_gm_set(prepare, {Num, Cd}),
    wish:adm_gm_set(ing, {Num, Cd * 2}),
    {ok};

do_cmd(["许愿池币数"], _Role) ->
    {Num, Count} = wish:get_count(),
    {false, util:fbin(<<"当前参与人数：~w,总投币数：~w">>, [Num, Count])};

do_cmd(["许愿池关闭"], _Role) ->
    wish:adm_gm_stop(),
    {ok};

do_cmd(["设开服时间", StrY, StrMo, StrD, StrH, StrMi, StrS], _Role) ->
    Y = to_int(StrY),
    Mo = to_int(StrMo),
    D = to_int(StrD),
    H = to_int(StrH),
    Mi = to_int(StrMi),
    S = to_int(StrS),
    DateTime = {{Y, Mo, D}, {H, Mi, S}},
    Sec = util:datetime_to_seconds(DateTime),
    sys_env:set(srv_open_time, Sec),
    {ok};

do_cmd(["抽奖", StrNum], Role) ->
    N = list_to_integer(StrNum),
    lottery:gm_lucky(N, Role);

do_cmd(["中奖", StrNum], Role) ->
    case StrNum =:= bitstring_to_list(Role#role.name) of
        true ->
            lottery:gm_lucker(Role);
        false ->
            lottery:gm_lucker(bitstring_to_list(StrNum))
    end,
    {ok};

do_cmd(["奖池"], Role) ->
    [Bonus, LastF, LastT, FreeI, PayI, Rands] = lottery:gm_get_state1(),
    Msg = util:fbin(<<"奖池信息----------~n头奖：~w~n上期头奖得主：~w   时间：~w~n当前免费概率区间：~w~n当前付费概率区间：~w~n头奖浮动概率：~w">>,
        [Bonus, LastF, LastT, FreeI, PayI, Rands]),
    {ok, Msg, Role};

do_cmd(["重载公告"], Role) ->
    notice:reload(),
    {ok, Role};

do_cmd(["添加公告", Notice], Role) ->
    notice:add(list_to_binary(Notice)),
    {ok, Role};

do_cmd(["清除公告"], Role) ->
    notice:clear(),
    {ok, Role};

do_cmd(["全服公告"], Role) ->
    notice:reload_board(),
    {ok, Role};

do_cmd(["设传音", Num], Role = #role{vip = Vip}) ->
    {ok, Role#role{vip = Vip#vip{hearsay = list_to_integer(Num)}}};

do_cmd(["重置迷宫机关"], _Role) ->
    dungeon_maze_mgr:apply(async, update_tele),
    {ok};

do_cmd(["进至尊"], Role) ->
    cross_king_api:role_enter(Role),
    {ok};
do_cmd(["cross_king"], _) ->
    center:cast(cross_king_mgr, m, [timeout]),
    {ok};

do_cmd(["开启武神坛"], _) ->
    center:cast(cross_warlord_mgr, switch, [open]),
    {ok};

do_cmd(["武神坛下一阶段"], _) ->
    center:cast(cross_warlord_mgr, m, [timeout]),
    {ok};

do_cmd(["武神坛下一届"], _) ->
    center:cast(cross_warlord_mgr, clean_cd, []),
    {ok};

do_cmd(["跳层进塔", Id], #role{pid = Pid}) ->
    BaseId = to_int(Id),
    role:rpc(Pid, dungeon_rpc, 13567, {BaseId, 1}),
    {ok};

do_cmd(["退出副本"], #role{pid = Pid}) ->
    role:rpc(Pid, dungeon_rpc, 13510, {}),
    {ok};

do_cmd(["清副本次数"], Role = #role{dungeon = RoleDun}) ->
    {ok, Role#role{dungeon = [I || I = {Label, _, _} <- RoleDun, not is_integer(Label)]}};

do_cmd(["清关卡副本"], Role = #role{dungeon = RoleDun}) ->
    {ok, Role#role{dungeon = [I || I = {Label, _, _} <- RoleDun, not(is_tuple(Label) andalso erlang:element(1, Label) =:= level_dun)]}};

do_cmd(["清副本购买数"], Role = #role{dungeon = RoleDun}) ->
    {ok, Role#role{dungeon = [I || I = {Label, _, _} <- RoleDun, not(is_tuple(Label) andalso erlang:element(1, Label) =:= paid)]}};

do_cmd(["重置关卡副本", Did], _Role = #role{pid = Pid}) ->
    role:rpc(Pid, dungeon_rpc, 13542, {to_int(Did)}),
    {ok};

do_cmd(["自动完成关卡副本", Did], _Role = #role{pid = Pid}) ->
    role:rpc(Pid, dungeon_rpc, 13543, {to_int(Did)}),
    {ok};

do_cmd(["购买副本次数", Did], #role{pid = Pid}) ->
    role:rpc(Pid, dungeon_rpc, 13532, {to_int(Did)}),
    {ok};

do_cmd(["dungeon"], #role{dungeon = _RoleDun}) ->
    ?DEBUG("角色副本数据：~w", [_RoleDun]),
    {ok};

do_cmd(["副本进程"], #role{event = ?event_dungeon, event_pid = Epid}) ->
    dungeon:info(Epid),
    {ok};

do_cmd(["副本礼包"], _Role) ->
    dungeon_mgr ! {dungeon_tower_reward2},
    rank_mgr ! dungeon_reward2,
    {ok};

do_cmd(["领取副本礼包", ClearId], _Role = #role{pid = Pid}) ->
    role:rpc(Pid, dungeon_rpc, 13552, {to_int(ClearId)}),
    {ok};

do_cmd(["镇妖塔通关"], Role) ->
    {ok, NewRole} = dungeon_event:unlock(Role, 20101),
    dungeon_event:unlock(NewRole, 20301);

do_cmd(["清场"], #role{pos = #pos{map_pid = Mpid}, event = ?event_dungeon}) ->
    Mpid ! {clear_npc},
    {ok};

do_cmd(["清副本通关数"], Role = #role{dungeon = RoleDun}) ->
    {ok, Role#role{dungeon = [I || I = {Label, _, _} <- RoleDun, not(is_tuple(Label) andalso erlang:element(1, Label) =:= clear)]}};

do_cmd(["进副本大厅", Did], #role{pid = Rpid}) ->
    role:rpc(Rpid, dungeon_rpc, 13571, {to_int(Did)}),
    {ok};

do_cmd(["活动转盘"], Role) ->
    case lottery_camp:luck(Role) of
        {ok, _BaseId, NewRole} ->
            {ok, NewRole};
        {false, _Reason} ->
            ?DEBUG("lottery_camp : ~s", [_Reason]),
            {ok}
    end;

do_cmd(["活动转盘奖励"], Role) ->
    case lottery_camp:reward(Role) of
        {ok, NewRole} ->
            {ok, NewRole};
        {false, _Reason} ->
            ?DEBUG("lottery_camp : ~s", [_Reason]),
            {ok}
    end;

do_cmd(["角色活动转盘"], #role{lottery_camp = _Lcamp}) ->
    ?DEBUG("活动转盘: ~w", [_Lcamp]),
    {ok};

do_cmd(["活动转盘", Count], #role{pid = Rpid}) ->
    util:for(1, to_int(Count), fun(_) -> role:rpc(Rpid, lottery_rpc, 14721, {}), role:rpc(Rpid, lottery_rpc, 14722, {}) end),
    {ok};

do_cmd(["进跨服"], Role) ->
    center_arena:role_enter(Role),
    {ok};

do_cmd(["退出跨服"], Role) ->
    center_arena:role_leave(Role),
    {ok};

do_cmd(["开启大厅"], _Role) ->
    hall_test:start_link(),
    {ok};

do_cmd(["进入大厅", Type], #role{pid = Pid}) ->
    role:rpc(Pid, hall_rpc, 16501, {to_int(Type)}),
    {ok};

do_cmd(["退出大厅"], #role{pid = Pid}) ->
    role:rpc(Pid, hall_rpc, 16502, {}),
    {ok};

do_cmd(["创建房间"], #role{pid = Pid}) ->
    role:rpc(Pid, hall_rpc, 16511, {}),
    {ok};

do_cmd(["接受大厅邀请", HallType, HallId, RoomNo, RoleId, SrvId], #role{pid = Pid}) ->
    role:rpc(Pid, hall_rpc, 16524, {1, to_int(HallType), to_int(HallId), to_int(RoomNo), to_int(RoleId), SrvId}),
    {ok};

do_cmd(["进入房间", RoomNo, Password], #role{pid = Pid}) ->
    role:rpc(Pid, hall_rpc, 16512, {to_int(RoomNo), Password}),
    {ok};

do_cmd(["退出房间"], #role{pid = Pid}) ->
    role:rpc(Pid, hall_rpc, 16513, {}),
    {ok};

do_cmd(["房间准备"], #role{pid = Pid}) ->
    role:rpc(Pid, hall_rpc, 16514, {}),
    {ok};

do_cmd(["房间取消"], #role{pid = Pid}) ->
    role:rpc(Pid, hall_rpc, 16515, {}),
    {ok};

do_cmd(["房间开始"], #role{pid = Pid}) ->
    role:rpc(Pid, hall_rpc, 16516, {}),
    {ok};

do_cmd(["房间类型", Type], #role{pid = Pid}) ->
    role:rpc(Pid, hall_rpc, 16527, {to_int(Type)}),
    {ok};

do_cmd(["房间设置", FightCapacityLimit, Password], #role{pid = Pid}) ->
    role:rpc(Pid, hall_rpc, 16517, {to_int(FightCapacityLimit), Password}),
    {ok};

do_cmd(["房间列表", PageNo, PageSize], #role{pid = Pid}) ->
    role:rpc(Pid, hall_rpc, 16504, {to_int(PageNo), to_int(PageSize)}),
    {ok};

do_cmd(["角色大厅信息"], #role{hall = _RoleHall, event = _Event, event_pid = _EventPid}) ->
    ?DEBUG("大厅信息: ~w", [_RoleHall]),
    ?DEBUG("事件信息: ~w", [{_Event, _EventPid}]),
    {ok};

do_cmd(["开启试练"], _Role) ->
    practice_mgr:start_practice(),
    {ok};

do_cmd(["关闭试练"], _Role) ->
    practice_mgr:stop_practice(),
    {ok};

do_cmd(["结算试练"], _Role) ->
    practice_mgr:settle(),
    {ok};

do_cmd(["试练信息"], #role{practice = _Rprac}) ->
    ?DEBUG("玩家试练信息: ~w", [_Rprac]),
    {ok};

do_cmd(["清试练次数"], Role = #role{}) ->
    {ok, Role#role{practice = []}};

do_cmd(["cross_boss"], #role{}) ->
    center:call(cross_boss_mgr, gm_status, []),
    {ok};

do_cmd(["cross_boss清次数"], #role{}) ->
    center:call(cross_boss_mgr, gm_clean_count, []),
    {ok};

do_cmd(["转阵营"], Role = #role{realm = Realm, link = #link{conn_pid = ConnPid}}) ->
    LL = [#loss{label = gold, val = pay:price(?MODULE, realm, null), msg = <<"晶钻不足">>}],
    case role_gain:do(LL, Role) of
        {false, #loss{err_code = ErrCode, msg = Msg}} ->
            sys_conn:pack_send(ConnPid, 10025, {ErrCode, Msg});
        {ok, Role1} ->
            notice:inform(<<"转换阵营\n消耗 168晶钻">>),
            NewRole = Role1#role{realm = to_other_realm(Realm)},
            map:role_update(NewRole),
            ?DEBUG("原阵营：~w  阵营：~w", [Realm, NewRole#role.realm]),
            {ok, NewRole}
    end;

do_cmd(["转阵营清次数"], #role{}) ->
    misc_mgr:clean_realm_change_cnt(),
    {ok};

do_cmd(["清洛水怪"], #role{pos = #pos{map_pid = Mpid}}) ->
    Mpid ! {clear_guard_npc},
    {ok};

do_cmd(["更新荣耀NPC"], _Role) ->
    npc_mgr ! {update_honour_npc2},
    {ok};

do_cmd(["同步荣耀NPC"], _Role) ->
    npc_mgr ! {sync_honour_npc2},
    {ok};

do_cmd(["获取怪物", NpcBaseId], #role{pos = #pos{map = Mpid, x = X, y = Y}, event = ?event_dungeon}) ->
    npc_mgr:create(to_int(NpcBaseId), Mpid, X, Y),
    {ok};

do_cmd(["浇水", ElemId], Role) ->
    campaign_plant:watering(Role, to_int(ElemId)),
    {ok};

do_cmd(["防沉迷时间", Time], Role) ->
    {ok, fcm:gm(time, Role, list_to_integer(Time))};
do_cmd(["防沉迷版本", Ver], Role) ->
    {ok, fcm:gm(ver, Role, list_to_integer(Ver))};
do_cmd(["防沉迷版本"], Role) ->
    fcm:gm(ver, Role, show);

do_cmd(["清空VIP"], Role) ->
    vip:gm(clear, Role);

do_cmd(["VIP时间", Time], Role) ->
    vip:gm(time, {list_to_integer(Time), Role});

do_cmd(["称号"], Role = #role{achievement = Ach}) ->
    Honors = achievement_data_honor:list(),
    NewHonorL = [{Honor, <<>>, 0} || Honor <- Honors],
    NRole = Role#role{achievement = Ach#role_achievement{honor_all = NewHonorL}},
    achievement:push_info(refresh, honor, NRole),
    {ok, NRole};

do_cmd(["获取称号", H], Role = #role{achievement = Ach = #role_achievement{honor_all = All}}) ->
    HonorId = list_to_integer(H),
    case achievement_data_honor:get(HonorId) of
        {ok, #honor_base{}} ->
            NewAll = lists:keydelete(HonorId, 1, All),
            NRole = Role#role{achievement = Ach#role_achievement{honor_all = NewAll}},
            achievement:add_and_use_honor(NRole, HonorId);
        _ ->
            {false, <<"称号不存在">>}
    end;

do_cmd(["自定义称号", H, HonorName], Role = #role{achievement = Ach = #role_achievement{honor_all = All}}) ->
    HonorId = list_to_integer(H),
    case achievement_data_honor:get(HonorId) of
        {ok, #honor_base{}} ->
            NewAll = lists:keydelete(HonorId, 1, All),
            NRole = Role#role{achievement = Ach#role_achievement{honor_all = [{HonorId, util:to_binary(HonorName), 0} | NewAll]}},
            achievement:push_info(refresh, honor, NRole),
            {ok, NRole};
        _ ->
            {false, <<"称号不存在">>}
    end;

do_cmd(["颜色称号", H, HonorName, Color], Role = #role{achievement = Ach = #role_achievement{honor_all = All}}) ->
    HonorId = list_to_integer(H),
    case achievement_data_honor:get(HonorId) of
        {ok, #honor_base{}} ->
            NewAll = lists:keydelete(HonorId, 1, All),
            NRole = Role#role{achievement = Ach#role_achievement{honor_all = [{HonorId, util:fbin("<font color='#~s'>~s</font>", [Color, HonorName]), 0} | NewAll]}},
            achievement:push_info(refresh, honor, NRole),
            {ok, NRole};
        _ ->
            {false, <<"称号不存在">>}
    end;

do_cmd(["自定义称号", H, HonorName, Time], Role = #role{achievement = Ach = #role_achievement{honor_all = All}}) ->
    HonorId = list_to_integer(H),
    case achievement_data_honor:get(HonorId) of
        {ok, #honor_base{}} ->
            NewAll = lists:keydelete(HonorId, 1, All),
            NRole = Role#role{achievement = Ach#role_achievement{honor_all = NewAll}},
            achievement:add_and_use_honor(NRole, {HonorId, util:to_binary(HonorName), util:unixtime() + list_to_integer(Time)});
        _ ->
            {false, <<"称号不存在">>}
    end;

do_cmd(["全服称号", ID], Role) ->
    honor_mgr:gm(Role, list_to_integer(ID)),
    {ok};

do_cmd(["宠物"], Role) ->
    Pets = pet_api:list_pets(Role),
    Msg = util:fbin("[~w]", [Pets]),
    {false, Msg};

do_cmd(["设挂机次数", StrNum], Role) ->
    {ok, hook:gm_set_num(Role, to_int(StrNum))};

do_cmd(["设挂机状态", StrS], Role) ->
    {ok, hook:gm_set_state(Role, to_int(StrS))};

do_cmd(["设宠物等级", Lev], Role) ->
    pet:do_gm(Role, lev, list_to_integer(Lev));

do_cmd(["设宠物外观", BaseId], Role) ->
    pet:use_change_skin_item(Role, list_to_integer(BaseId));

do_cmd(["设宠物成长", Grow], Role) ->
    pet:do_gm(Role, grow, list_to_integer(Grow));

do_cmd(["设宠物颜色", Type], Role) ->
    pet:do_gm(Role, color, list_to_integer(Type));

do_cmd(["设宠物潜力", Val], Role) ->
    pet:do_gm(Role, potential, list_to_integer(Val));

do_cmd(["设宠物潜力上限", Val], Role) ->
    pet:do_gm(Role, max_potential, list_to_integer(Val));

do_cmd(["设宠物技能经验", Val], Role) ->
    pet:do_gm(Role, skill_exp, list_to_integer(Val));

do_cmd(["设宠物快乐值", Val], Role) ->
    pet:do_gm(Role, happy, list_to_integer(Val));

do_cmd(["设宠物天赋", SkillId, Val], Role) ->
    pet:do_gm(Role, skill_talent, {list_to_integer(SkillId), list_to_integer(Val)});

do_cmd(["宠物洗髓", Type], Role) ->
    Attr = pet_api:test_gm(attr_sys, Role, list_to_integer(Type)),
    Msg = util:fbin("[~w]", [Attr]),
    {false, Msg};

do_cmd(["魔晶经验", Exp], Role) ->
    pet_magic:do_gm(Role, {exp, list_to_integer(Exp)});
do_cmd(["获取魔晶", BaseId], Role) ->
    pet_magic:do_gm(Role, {bag, list_to_integer(BaseId)});

do_cmd(["清空宠物日志"], Role) ->
    pet:do_gm(Role, clear_log, do_this);

do_cmd(["发信件", Num], Role) ->
    mail:send_system(Role, {<<"test">>, <<"test">>, [{0, 10000}, {4, 100000}], {10000, 0, list_to_integer(Num)}}),
    {ok};

do_cmd(["投递信件", Num], Role) ->
    L = lists:seq(1, list_to_integer(Num)),
    RoleList = [Role || _N <- L],
    mail_mgr:deliver(RoleList, {<<"test">>, <<"test">>, [{0, 10000}, {4, 100000}], []}),
    {ok};

do_cmd(["发信件", Type, Num], Role) ->
    mail:send_system(Role, {<<"test">>, <<"test">>, [{list_to_integer(Type), list_to_integer(Num)}], []}),
    {ok};

do_cmd(["信件", Type1, Type2, Type3], Role) ->
    mail:send_system(Role, {<<"test">>, <<"test">>, [{list_to_integer(Type1), 1000},{list_to_integer(Type2), 1000},{list_to_integer(Type3), 1000}], {10000, 0, 1}}),
    {ok};

do_cmd(["普通信件", Name], Role) ->
    _Info = mail:send(Role, util:to_binary(Name), {<<"test">>, <<"test">>, 0, -1}),
    %% util:cn(util:fbin("--------[~w]", [Info])),
    {ok};

do_cmd(["神秘商店", Num], Role) ->
    npc_store_sm:call({gm, list_to_integer(Num), Role});

do_cmd(["清空神秘商店"], Role) ->
    npc_store_sm:call({clear, Role});

do_cmd(["神秘商店"], Role) ->
    npc_store_sm:call({get, Role});

do_cmd(["清空动态商店"], _Role) ->
    npc_store_live:apply(async, reset),
    {ok};

do_cmd(["更新动态商店"], _Role) ->
    npc_store_live:apply(async, update),
    {ok};

do_cmd(["晶钻金币交易", Gold, Coin], _Role) ->
    npc_store_live:apply(async, {gold_coin, list_to_integer(Gold), list_to_integer(Coin)}),
    {ok};

do_cmd(["金币晶钻交易", Coin, Gold], _Role) ->
    npc_store_live:apply(async, {coin_gold, list_to_integer(Gold), list_to_integer(Coin)}),
    {ok};

do_cmd(["动态商店"], _Role) ->
    State = npc_store_live:apply(sync, get_all),
    Msg = util:fbin("[~w]", [State]),
    {false, Msg};

do_cmd(["更新仙宠限购"], _Role) ->
    shop:reload(),
    {ok};

do_cmd(["开封印", N], Role) ->
    case casino_rpc:handle(14205, {1, list_to_integer(N)}, Role) of 
        {reply, {_, _, Items}, NewRole} ->
            Msg = util:fbin("[~w]", [Items]),
            {ok, Msg, NewRole};
        {reply, {_, Reason, _}} ->
            {false, Reason};
        _ -> {ok}
    end;

do_cmd(["开封印"], #role{casino = Casino}) ->
    Msg = util:fbin("[casino_store:~w]", [Casino]),
    {false, Msg};

do_cmd(["开封印状态"], Role) ->
    {RoleL, GloLs} = casino:apply(sync, {state, Role}),
    Msg = util:fbin("[role_open:~w]~n[global_open:~w]", [RoleL, GloLs]),
    {false, Msg};

do_cmd(["开封印整理"], Role) ->
    case casino_rpc:handle(14201, {}, Role) of 
        {reply, _, NR} ->
            {ok, NR};
        _ -> {ok}
    end;

do_cmd(["测试活跃世界树"], Role) ->
    Role1 = role_listener:special_event(Role, {2003, 1}),
    {ok, Role1};

do_cmd(["开封印移动", Id, Type, Pos], Role) ->
    case casino_rpc:handle(14202, {list_to_integer(Id), list_to_integer(Type), list_to_integer(Pos)}, Role) of 
        {reply, _, NR} ->
            {ok, NR};
        _ -> {ok}
    end;

do_cmd(["开封印移动"], Role) ->
    case casino_rpc:handle(14203, {}, Role) of 
        {reply, _, NR} ->
            {ok, NR};
        _ -> {ok}
    end;

do_cmd(["开封印删除", Id], Role) ->
    case casino_rpc:handle(14204, {list_to_integer(Id)}, Role) of 
        {reply, _, NR} ->
            {ok, NR};
        _ -> {ok}
    end;

do_cmd(["晶钻卡", Num], Role) ->
    role_gain:do([#gain{label = item, val = [221104, 1, to_int(Num)]}], Role);

do_cmd(["设置精力值", A], Role) ->
    case role_gain:do([#gain{label = activity, val = list_to_integer(A)}], Role) of
        {ok, NR} ->
            activity:pack_send_table(NR),
            {ok, NR};
        _ ->
            {ok}
    end;

do_cmd(["q"], Role = #role{eqm = Eqm}) ->
    Eqm1 = [Item#item{wash_cnt = 0} || Item = #item{} <- Eqm],
    {ok, Role#role{eqm = Eqm1}};

do_cmd(["z"], #role{eqm = Eqm}) ->
 	NList = [N||#item{wash_cnt = N} <- Eqm],
	_All = lists:sum(NList),   
    ?DEBUG("总鉴定次数  [~w]", [_All]),
    {ok};

do_cmd(["设七天奖励", A], 
    Role = #role{seven_day_award = SevenDayAward = #seven_day_award{
            awards = Awds,
            online_info = Info}}) ->
    Day = list_to_integer(A),
    Role1 =
    case lists:keyfind(Day, 1, Awds) of
        false ->
            L = lists:keyreplace(Day, #award.day, Awds, #award{day = Day, flag = 1}),
            Role#role{seven_day_award = SevenDayAward#seven_day_award{awards = L, 
                    online_info = Info#online_info{last_login = util:unixtime()}}};
        _ ->
            Role
    end,
    seven_day_award:push(Role1),
    {ok, Role1};

do_cmd(["清空七天奖励"], Role) ->
    Role1 = Role#role{seven_day_award = #seven_day_award{awards = ?init_awards_info, type = 1, 
            online_info = #online_info{last_login = util:unixtime(), online_time = 0}}},
    seven_day_award:push(Role1),
    {ok, Role1};


do_cmd(["设活跃度", A], Role = #role{activity2 = Act}) ->
    Val = min(200, list_to_integer(A)),
    NewRole = Role#role{activity2 = Act#activity2{current = Val, last_active = util:unixtime()}},
    activity2:push(13804, NewRole),
    {ok, NewRole};

do_cmd(["清活跃度奖励"], Role = #role{}) ->
    Role1 =  activity2:reset(Role),
    {ok, Role1};
do_cmd(["查看触发器"], #role{trigger = _Trg}) ->
    ?DEBUG("触发器数据为: ~w", [_Trg]),
    {ok};

do_cmd(["时装可见"], Role = #role{setting = Setting = #setting{shield = Shield}}) ->
    case lists:member(?shield_fashion, Shield) of
        true ->
            {ok};
        false ->
            Role1 = Role#role{setting = Setting#setting{shield = [?shield_fashion | Shield]}},
            map:role_update(Role1),
            {ok, Role1}
    end;
do_cmd(["隐藏时装"], Role = #role{setting = Setting = #setting{shield = Shield}}) ->
    Role1 = Role#role{setting = Setting#setting{shield = lists:keydelete(?shield_fashion, 1, Shield)}},
    map:role_update(Role1),
    {ok, Role1};

do_cmd(["查看神秘来信"], #role{vip = #vip{mail_list = _L}}) ->
    ?DEBUG(" 当前神秘来信 : ~w", [_L]),
    {ok};

do_cmd(["设神秘来信", A], Role) ->
    MailId = to_int(A),
    Role1 =

    case MailId of
        1 ->
            vip:set_discount_mail(make_30_eqm, Role);
        2 ->
            vip:set_discount_mail(refine_30_blue_eqm, Role);
        3 ->
            vip:set_discount_mail(weapon_enchant_5, Role);
        4 ->
            vip:set_discount_mail(cloth_enchant_5, Role);
        5 ->
            vip:set_discount_mail(juan_zou, Role);
        6 ->
            vip:set_discount_mail(kill_npc, Role)
    end,
    
    {ok, Role1};

do_cmd(["领取神秘来信", A], Role) ->
    activity_rpc:handle(13810, {to_int(A)}, Role);

do_cmd(["清神秘来信"], Role = #role{vip = Vip}) ->
    {ok, Role#role{vip = Vip#vip{item_flag = 0}}};

do_cmd(["更新排行榜"], _Role) ->
    rank_mgr:async(update),
    {ok};

do_cmd(["更新跨服排行榜"], _Role) ->
    center:cast(c_rank_mgr, cast, [gm_update_rank]),
    {ok};

do_cmd(["排行榜", Type], _Role) ->
    L = rank:list(list_to_integer(Type)),
    Msg = util:fbin("rank_list[~w]", [L]),
    {false, Msg};

do_cmd(["清空排行榜", Type], _Role) ->
    rank_mgr:async({clear, list_to_integer(Type)}),
    {ok};

do_cmd(["清空所有排行榜"], _Role) ->
    rank_mgr:async(clear_all),
    {ok};

do_cmd(["排行榜奖励", Type], _Role) ->
    rank_mgr:async({reward, list_to_integer(Type)}),
    {ok};

do_cmd(["特殊任务", D, VVVV], Role) ->
    D1 = to_int(D),
    V1 = to_int(VVVV),
    Role1 = role_listener:special_event(Role, {D1, V1}),
    {ok, Role1};

do_cmd(["背包"], Role = #role{bag = #bag{items = _Items}}) ->
    ?DEBUG("背包内容: ~w", [_Items]),
    {ok, Role};


do_cmd(["设守护等级", StrStep], Role) ->
    Step = to_int(StrStep),
    {ok, demon:gm_set_step(Step, Role)};
do_cmd(["设守护技能等级", StrLev], Role) ->
    SkillLev = to_int(StrLev),
    {ok, demon:gm_set_skill_lev(SkillLev, Role)};
do_cmd(["设守护洗髓品质", StrCraft], Role) ->
    Craft = to_int(StrCraft),
    demon:gm_set_attr_craft(Craft, Role);

do_cmd(["设连续天数", Num], Role = #role{offline_exp = OffInfo = #offline_exp{login_line = {Id, _, _}}}) ->
    N = to_int(Num),
    Now = util:unixtime(),
    Nr = Role#role{offline_exp = OffInfo#offline_exp{login_line = {Id, N, Now}}},
    offline_exp:pack_login_table(Nr),
    {ok, Nr};

do_cmd(["设活动连续天数", Num], Role = #role{offline_exp = OffInfo = #offline_exp{camp_line = {Id, _, _}}}) ->
    N = to_int(Num),
    Nr = Role#role{offline_exp = OffInfo#offline_exp{camp_line = {Id, N, 0}}},
    {ok, Nr};

do_cmd(["变神器"], Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case eqm:find_eqm_by_id(Role#role.eqm, 1) of
        false -> {false, <<"你先随便弄把武器再来变吧~">>};
        {ok, Item = #item{attr = Attr}} ->
            NewA = blacksmith:replace_base_attr(?attr_dmg_min, Attr, {?attr_dmg_min, 100, 65530}),
            NewB = blacksmith:replace_base_attr(?attr_dmg_max, NewA, {?attr_dmg_max, 100, 65530}),
            NewAttr = [{?attr_speed, 100, 500} | NewB], 
            {ok, NewEqm, _NewItem} = storage_api:fresh_item(Item, Item#item{attr = NewAttr}, Role#role.eqm, ConnPid),
            NewRole = role_api:push_attr(Role#role{eqm = NewEqm}),
            map:role_update(NewRole),
            {ok, NewRole}
    end;
do_cmd(["变神器2"], Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case eqm:find_eqm_by_id(Role#role.eqm, 1) of
        false -> {false, <<"你先随便弄把武器再来变吧~">>};
        {ok, Item = #item{attr = Attr}} ->
            NewA = blacksmith:replace_base_attr(?attr_dmg_min, Attr, {?attr_dmg_min, 100, 655300}),
            NewB = blacksmith:replace_base_attr(?attr_dmg_max, NewA, {?attr_dmg_max, 100, 655300}),
            NewC = blacksmith:replace_base_attr(?attr_hitrate, NewB, {?attr_hitrate, 100, 10000}),
            NewD = blacksmith:replace_base_attr(?attr_aspd, NewC, {?attr_aspd, 100, 1000}),
            NewAttr = [{?attr_js, 100, 10000}, {?attr_dmg_magic, 100, 10000}, {?attr_speed, 100, 500} | NewD], 
            {ok, NewEqm, _NewItem} = storage_api:fresh_item(Item, Item#item{attr = NewAttr}, Role#role.eqm, ConnPid),
            NewRole = role_api:push_attr(Role#role{eqm = NewEqm}),
            map:role_update(NewRole),
            {ok, NewRole}
    end;

do_cmd(["还原"], Role = #role{link = #link{conn_pid = ConnPid}}) ->
    storage_api:refresh_client_item(del, ConnPid, [{?storage_dress, Role#role.dress}]),
    storage_api:refresh_client_item(del, ConnPid, [{?storage_eqm, Role#role.eqm}]),
    storage_api:refresh_client_item(del, ConnPid, [{?storage_wing, Role#role.wing#wing.items}]),
    NewRole = looks:calc(Role#role{eqm = [], dress = [], wing = #wing{}}),
    NewRole1 = role_api:push_attr(NewRole),
    looks:refresh(Role, NewRole1),
    {ok, NewRole1};
            
do_cmd(["变身", Career2, Num], Role = #role{sex = Sex, link = #link{conn_pid = ConnPid}}) ->
    N = to_int(Num),
    case N >= 1 andalso N =< 9 of
        true ->
            role:send_buff_begin(),
            case do_cmd(["设职业", Career2], Role) of
                {ok} -> 
                    role:send_buff_clean(),
                    {false, <<"设职业错误">>};
                {ok, Role1} ->
                    Lev = if
                        N >= 1 andalso N =< 3 -> 40;
                        N >= 4 andalso N =< 6 -> 50;
                        N =:= 7 -> 55;
                        N =:= 8 -> 80;
                        N =:= 9 -> 90;
                        true -> 30
                    end,
                    case do_cmd(["设等级", Lev], Role1) of
                        {ok} ->
                            role:send_buff_clean(),
                            {false, <<"设等级错误">>};
                        {ok, Role2} ->
                            %% 设技能
                            SL = skill:gm_get(N),
                            Role3 = skill:gm_set_skill(Role2, SL),
                            %% 设元神
                            {ToLev, ToState} = channel:gm_get(N),
                            case channel:gm_set_channel(Role3, ToLev, ToState) of
                                {ok, NowRole} ->
                                    %% 增加对应神装
                                    GetItemList = role_adm_data:get(N, NowRole#role.career),
                                    ItemList = GetItemList ++ role_adm_data:get(N, NowRole#role.career, Sex),
                                    Info = mode_to_info(N),
                                    {SoulLev, _} = Info,
                                    Items = make_all(N, ItemList, Info),
                                    NewEqm = puton_all_item(Items),
                                    Dress = case lists:keyfind(10, #item.id, NewEqm) of
                                        false ->
                                            case lists:keyfind(15, #item.id, NewEqm) of
                                                false -> [];
                                                WingItem = #item{base_id = W} ->
                                                    WingId = item_dress_data:baseid_to_id(W),
                                                    [WingItem#item{id = WingId, pos = WingId}]
                                            end;
                                        DressItem = #item{base_id = D} -> 
                                            case lists:keyfind(15, #item.id, NewEqm) of
                                                false ->
                                                    DressId = item_dress_data:baseid_to_id(D),
                                                    [DressItem#item{id = DressId, pos = DressId}];
                                                WingItem = #item{base_id = W} ->
                                                    WingId = item_dress_data:baseid_to_id(W),
                                                    DressId = item_dress_data:baseid_to_id(D),
                                                    [DressItem#item{id = DressId, pos = DressId},
                                                        WingItem#item{id = WingId, pos = WingId}]
                                            end
                                    end,
                                    Wing = case lists:keyfind(15, #item.id, NewEqm) of
                                        false -> #wing{};
                                        WingItem1 = #item{base_id = WingBaseId} ->
                                            #wing{skin_list = [WingBaseId], items = [WingItem1]}
                                    end,
                                    storage_api:refresh_client_item(del, ConnPid, [{?storage_dress, NowRole#role.dress}]),
                                    storage_api:refresh_client_item(del, ConnPid, [{?storage_eqm, NowRole#role.eqm}]),
                                    storage_api:refresh_client_item(del, ConnPid, [{?storage_wing, NowRole#role.wing#wing.items}]),
                                    storage_api:refresh_client_item(add, ConnPid, [{?storage_dress, Dress}]),
                                    storage_api:refresh_client_item(add, ConnPid, [{?storage_eqm, NewEqm}]),
                                    storage_api:refresh_client_item(add, ConnPid, [{?storage_wing, Wing#wing.items}]),
                                    Nrole = looks:calc(NowRole#role{wing = Wing, dress = Dress, eqm = NewEqm, soul_lev = SoulLev}),
                                    NR = case pet:do_gm(Nrole, refresh, N) of
                                        {ok, NewR} -> NewR;
                                        _ -> Nrole
                                    end,
                                    Nr1 = #role{assets = Assets} = role_api:push_attr(NR),
                                    looks:refresh(NowRole, NR),
                                    Nr2 = Nr1#role{assets =
                                        Assets#assets{
                                            gold = 999999,
                                            gold_bind = 999999,
                                            coin = 999999,
                                            coin_bind = 999999,
                                            psychic = 999999
                                        }},
                                    Nr3 = role_api:push_assets(Nr1, Nr2),
                                    role:send_buff_flush(),
                                    {ok, Nr3};
                                {false, Msg} ->
                                    role:send_buff_clean(),
                                    {false, Msg}
                            end
                    end
            end;
        false ->
            {false, <<"唉哟,不要那么强嘛,奥特曼是不存在的~">>}
    end;

do_cmd(["设神佑等级", PosType, Num], Role = #role{eqm = Eqms, link = #link{conn_pid = ConnPid}}) ->
    %%只能1~15 挂饰和武饰不用
    Pos = to_pos(PosType),
    case Pos >= 1 andalso Pos =< 15 of
        true ->
            case lists:keyfind(Pos, #item.id, Eqms) of
                false -> {false, <<"位置错误">>};
                Item ->
                    GsLev = to_int(Num),
                    NewItem = blacksmith:recalc_gs_eqm(by_lev, GsLev, Item),
                    Attr = blacksmith:get_rand_gs_attr(NewItem),
                    NewEqmItem = blacksmith:recalc_gs_eqm(by_attr, Attr, NewItem),
                    {ok, NewEqm, _} = storage_api:fresh_item(Item, NewEqmItem, Eqms, ConnPid),
                    NewRole = Role#role{eqm = NewEqm},
                    NewRole2 = looks:calc(NewRole#role{eqm = NewEqm}),
                    NewRole3 = role_api:push_attr(NewRole2),
                    {ok, NewRole3}
            end;
        false ->
            {false, <<"命令错误">>}
    end;

do_cmd(["设附魔等级", Type, Num], Role = #role{eqm = Eqms, link = #link{conn_pid = ConnPid}}) ->
    Pos = to_pos(Type),
    FmLev = to_int(Num),
    case Pos >= 1 andalso Pos =< 15 of
        true ->
            case FmLev >= 1 andalso FmLev =< 80 of
                true ->
                    case lists:keyfind(Pos, #item.id, Eqms) of
                        false -> {false, <<"位置错误">>};
                        Item ->                            
                            case item:check_is_fumo(Item) of
                                false -> {false, <<"橙装才能附魔">>};
                                true ->
                                    NewEqmItem = blacksmith:refresh_eqm_fumo(FmLev, Item),
                                    {ok, NewEqms, _} = storage_api:fresh_item(Item, NewEqmItem, Eqms, ConnPid),
                                    NewRole = Role#role{eqm = NewEqms},
                                    NewRole2 = looks:calc(NewRole#role{eqm = NewEqms}),
                                    NewRole3 = role_api:push_attr(NewRole2),
                                    {ok, NewRole3}
                            end
                    end;
                false ->
                    {false, <<"附魔等级为1~80">>}
            end;
        false ->
            {false, <<"命令错误">>}
    end;

do_cmd(["设套装", Num], Role = #role{career = Career, link = #link{conn_pid = ConnPid}}) ->
    Lev = to_int(Num),
    case Lev =:= 10 orelse Lev =:= 20 orelse Lev =:= 30 orelse Lev =:= 40 orelse Lev =:= 50 of
        true ->
            role:send_buff_begin(),
            EquipIds = get_eqm(Career, Lev),
            case EquipIds of
                [] -> 
                    {false, <<"SORRY 目前还没有此套装...">>};
                _ ->
                    NewEqm = 
                    case item:make(EquipIds,[]) of
                        false -> [];
                        Equips ->
                            eqm:puton_newhand_equip(Career, Equips, [])
                    end,

                    storage_api:refresh_client_item(del, ConnPid, [{?storage_eqm, Role#role.eqm}]),%%清除
                    storage_api:refresh_client_item(add, ConnPid, [{?storage_eqm, NewEqm}]),%%穿上某件
                    NewRole = looks:calc(Role#role{eqm = NewEqm}),
                    NewRole1 = role_api:push_attr(NewRole),
                    looks:refresh(Role, NewRole1),
                    role:send_buff_flush(),
                    {ok, NewRole1}
            end;
        false ->
            {false, <<"矮油,毁灭宇宙的装备是不存在的~">>}
    end;

do_cmd(["设化形等级", DemonId, Num], Role) ->
    Did = to_int(DemonId),
    Lev = to_int(Num),
    case Did >=1 andalso Did =< 5 of
        true ->
            case Lev >= 1 andalso Lev =< 10 of
                true ->
                    demon:gm_upgrade_shape(Role, Did, Lev),
                    {ok, Role};
                false ->
                    {false, <<"矮油,化形等级为1~10啦">>}
            end;
        false ->
            {false, <<"矮油,精灵ID只有1~5啦">>}
    end;

do_cmd(["扫荡副本", D, N], Role) ->
    D1 = to_int(D),
    N1 = to_int(N),
    Role1 = role_listener:sweep_dungeon(Role, {D1, N1}),
    {ok, Role1};



do_cmd(["完成所有成就"], Role) ->
    {ok, achievement:gm(finish_all, Role)};

do_cmd(["设成就", Id, N], Role) ->
    {ok, achievement:gm(set, {Role, list_to_integer(Id), list_to_integer(N)})};
do_cmd(["设成就值", Value], Role) ->
    {ok, achievement:gm(value, {Role, list_to_integer(Value)})};
do_cmd(["清空成就"], Role) ->
    {ok, achievement:gm(clear, Role)};

do_cmd(["开启超级怪"], Role) ->
    super_boss_mgr:start_boss(),
    {ok, Role};

do_cmd(["关闭超级怪"], Role) ->
    super_boss_mgr:stop_boss(),
    {ok, Role};

do_cmd(["打超级怪"], Role) ->
    boss_rpc:handle(12850, {}, Role),
    {ok, Role};

do_cmd(["eqm", Id], Role) ->
    Id1 = to_int(Id),
    eqm:puton_init_eqm(Id1, Role);


do_cmd(["不打超级怪"], Role) ->
    boss_rpc:handle(12851, {}, Role),
    {ok, Role};

do_cmd(["发送测试"], Role) ->
    ?DEBUG("执行发送测试"),
    role:send_test(0),
    role:send_buff_begin(),
    role:send_test(1),
    role:send_test(2),
    role:send_buff_begin(),
    role:send_test(3),
    role:send_test(4),
    role:send_buff_begin(),
    role:send_test(5),
    role:send_test(6),
    role:send_buff_begin(),
    role:send_test(7),
    role:send_test(8),
    role:send_buff_flush(),
    role:send_buff_clean(),
    role:send_buff_flush(),
    role:send_buff_clean(),
    {ok, Role};

do_cmd(["测试竞技场"], Role) ->
    arena_mgr:m(timeout),
    {ok, Role};

do_cmd(["arena"], Role) ->
    arena_mgr:m(timeout),
    {ok, Role};

do_cmd(["arena_cross"], Role) ->
    arena_center_mgr:next_all(timeout),
    {ok, Role};

do_cmd(["escort"], Role) ->
    escort_mgr:next(timeout),
    {ok, Role};

do_cmd(["escort_child"], Role) ->
    escort_child_mgr:next(timeout),
    {ok, Role};

do_cmd(["escort_cyj"], Role) ->
    escort_cyj_mgr:next(timeout),
    {ok, Role};

do_cmd(["campaign_repay_self"], Role) ->
    campaign_repay_self:next(timeout),
    {ok, Role};

do_cmd(["campaign_repay_bystages"], Role) ->
    campaign_repay_bystages:next(timeout),
    {ok, Role};

do_cmd(["campaign_repay_bystages2"], Role) ->
    campaign_repay_bystages2:next(timeout),
    {ok, Role};

do_cmd(["campaign_repay_bystages3"], Role) ->
    campaign_repay_bystages3:next(timeout),
    {ok, Role};

do_cmd(["market_auto"], Role) ->
    market_auto:next(timeout),
    {ok, Role};

do_cmd(["market_save"], Role) ->
    market:save_avgprice(),
    {ok, Role};

do_cmd(["完成任务链", ParamTaskId], Role = #role{lev = RoleLev, career = Career, link = #link{conn_pid = ConnPid}}) ->
    TaskId = list_to_integer(ParamTaskId),
    {ok, #task_base{type = Type, lev = Lev}} = task_data:get_conf(TaskId),
    Role1 = case RoleLev < Lev of true -> role_api:push_attr(Role#role{lev = Lev}); false -> Role end,
    role_api:push_assets(Role, Role1),
    NewRole = task:finish_link(Role1, [TaskId]),
    NewAcceptableTaskidList = task:refresh_acceptable_task(by_type, NewRole, Type, TaskId),
    sys_conn:pack_send(ConnPid, 10200, {[]}),
    {ok, Data} = task:get_dict(acceptable, Type),
    AddAcceptable = NewAcceptableTaskidList --  Data,
    case length(AddAcceptable) > 0 of
        true -> %% 有新的可接任务
            task_rpc:send_batch_npc_status(acceptable, ConnPid, AddAcceptable, 1, []), %% 更新Npc状态
            task_rpc:send_add_acceptable_tasks(ConnPid, Career, AddAcceptable), %% 推送可接任务
            task:add_cache(acceptable, Type, AddAcceptable);
        false ->
            skip 
    end,
    {ok, NewRole};

do_cmd(["我要新手卡"], #role{account = Account}) ->
    ServerKey = sys_env:get(server_key),
    T = util:md5(lists:concat([ServerKey, binary_to_list(Account)])),
    {false, T};

do_cmd(["我要贵宾卡"], #role{account = Account}) ->
    ServerKey = sys_env:get(server_key),
    T1 = util:md5(lists:concat(["JH3GN-D2B3O-KDKJ-W9OIN-BCE4GC", ServerKey, binary_to_list(Account), "1"])),
    T2 = util:md5(lists:concat(["JH3GN-D2B3O-KDKJ-W9OIN-BCE4GC", ServerKey, binary_to_list(Account), "2"])),
    T3 = util:md5(lists:concat(["JH3GN-D2B3O-KDKJ-W9OIN-BCE4GC", ServerKey, binary_to_list(Account), "3"])),
    T4 = util:md5(lists:concat(["JH3GN-D2B3O-KDKJ-W9OIN-BCE4GC", ServerKey, binary_to_list(Account), "4"])),
    T = [
        string:substr(bitstring_to_list(T1), 1, 18),
        string:substr(bitstring_to_list(T2), 1, 18),
        string:substr(bitstring_to_list(T3), 1, 18),
        string:substr(bitstring_to_list(T4), 1, 18)
    ],
    {false, list_to_binary(util:rand_list(T))};

do_cmd(["设耐久度", Num], Role = #role{link = #link{conn_pid = ConnPid}}) ->
    N = to_int(Num),
    case eqm:find_eqm_by_id(Role#role.eqm, 1) of
        false -> {false, <<"你先随便弄把武器再来变吧~">>};
        {ok, Item} ->
            {ok, NewEqm, _NewItem} = storage_api:fresh_item(Item, Item#item{durability = N}, Role#role.eqm, ConnPid),
            NewRole = role_api:push_attr(Role#role{eqm = NewEqm}),
            map:role_update(NewRole),
            {ok, NewRole}
    end;

do_cmd(["开启帮战"], _Role) ->
    guild_war_flow:start_war(),
    {ok};

do_cmd(["帮战准备"], _Role) ->
    guild_war_flow:prepare(),
    {ok};

do_cmd(["帮战第一阶段"], _Role) ->
    guild_war_flow:war1(),
    {ok};

do_cmd(["帮战第二阶段"], _Role) ->
    guild_war_flow:end_war1(),
    {ok};

do_cmd(["结束帮战"], _Role) ->
    guild_war_flow:end_war(),
    {ok};

do_cmd(["帮战报名", Union], Role) ->
    guild_war_rpc:handle(14601, {to_int(Union)}, Role),
    {ok};

do_cmd(["帮战报名情况"], Role) ->
    guild_war_rpc:handle(14605, {}, Role),
    {ok};

do_cmd(["进帮战准备区"], Role) ->
    guild_war_rpc:handle(14602, {}, Role),
    {ok};

do_cmd(["进帮战"], Role) ->
    guild_war_rpc:handle(14603, {}, Role),
    {ok};

do_cmd(["退出帮战"], Role) ->
    guild_war_rpc:handle(14610, {}, Role),
    {ok};

do_cmd(["设帮战积分", Val], Role) ->
    case role_gain:do([#gain{label = guild_war, val = to_int(Val)}], Role) of
        {ok, NewRole} ->
            {ok, NewRole};
        _ ->
            {ok}
    end;

do_cmd(["帮战机器人"], _Role = #role{event = ?event_guild_war}) ->
    guild_war:create_robot(),
    {ok};

do_cmd(["主将赛报名", TeamNo], Role) ->
    guild_war_rpc:handle(14612, {to_int(TeamNo)}, Role),
    {ok};

do_cmd(["取消主将赛"], Role) ->
    guild_war_rpc:handle(14613, {}, Role),
    {ok};

do_cmd(["开启主将赛"], _Role) ->
    guild_war_compete:start(),
    {ok};

do_cmd(["开启军团副本"], #role{guild = #role_guild{gid = Gid, srv_id = GsrvId}}) ->
    ?DEBUG("XXXX"),
    guild_td_mgr:gm_start({Gid, GsrvId}),
    {ok};

do_cmd(["设军团副本时间", Mode, Lev], Role) ->
    Mode1 = to_int(Mode),
    Lev1 = to_int(Lev),
    ?DEBUG("设军团副本 ~w  ~w", [Mode1, Lev1]),
    case guild_td_rpc:handle(14906, {Mode1, Lev1}, Role) of
        {reply, {_F, _Reason}} ->
            ?DEBUG("返回  ~w, ~s", [_F, _Reason]);
        _Ret ->
            ?DEBUG("返回 Ret ~w", [_Ret])
    end,
    {ok};

do_cmd(["查看军团副本时间"], Role) ->
    case guild_td_rpc:handle(14908, {}, Role) of
        {reply, {_Day, _Time, _Lev}} ->
            ?DEBUG(" day ~w  time ~w  lev ~w", [_Day, _Time, _Lev]);
        _Ret ->
            ?DEBUG("  retrun ~w", [_Ret])
    end,
    {ok};

do_cmd(["修复军团副本开启列表"], #role{}) ->
    ?DEBUG(" 修复军团副本开户列表"),
    guild_td_mgr:adm_fix(),
    {ok};

do_cmd(["军团副本隔天"], #role{}) ->
    guild_td_mgr:gm_day_check(),
    {ok};

do_cmd(["开启洛水"], #role{}) ->
    guard_mgr:gm_start(),
    {ok};

do_cmd(["设置开启守卫洛水"], #role{}) ->
    guard_mgr:next_mode(guard),
    {ok};

do_cmd(["设置开启洛水反击"], #role{}) ->
    guard_mgr:next_mode(c_guard),
    {ok};

do_cmd(["洛水反击下一阶段"], #role{}) ->
    guard_mgr:next_timeout(),
    {ok};

do_cmd(["进入军团副本"], Role) ->
    case guild_td_api:role_enter(Role) of
        {false, Reason} -> {false, Reason};
        {ok, NewRole} -> {ok, NewRole}
    end;

do_cmd(["退出军团副本"], Role) ->
    case guild_td_api:role_leave(Role) of
        {false, Reason} -> {false, Reason};
        {ok, NewRole} -> {ok, NewRole}
    end;

do_cmd(["当前状态"], #role{event = _Event}) ->
    ?DEBUG(">>>>>>>>>>>>>> ~w", [_Event]),
    ok;

do_cmd(["cnb", ID], _Role) ->
    notice:timeout_notice(list_to_integer(ID)),
    {ok};
do_cmd(["寄养加速", M], Role) ->
    case guild_rpc:handle(12770, {list_to_integer(M)}, Role) of
        {reply, {?false, Reason}} ->
            {false, Reason};
        {reply, {?true, _Msg}, NewRole} ->
            {ok, NewRole}
    end;

do_cmd(["取消寄养"], Role) ->
    NewRole = guild_pet_deposit:pet_undeposited(Role),
    {ok, NewRole};

do_cmd(["寄养"], Role) ->
    case guild_pet_deposit:pet_deposit(1, 1, Role) of
        {false, Reason} ->
            {false, Reason};
        {true, NewRole} ->
            {ok, NewRole}
    end;

do_cmd(["领取附件", ID], Role) ->
    notice:claim_notice_attach(list_to_integer(ID), Role),
    {ok};

do_cmd(["添加宝库物品", BaseID, Bind, Quantity, Type], #role{guild = #role_guild{gid = Gid, srv_id = Srvid}}) ->
    guild_treasure:add({Gid, Srvid}, list_to_integer(Type), [{list_to_integer(BaseID), list_to_integer(Bind), list_to_integer(Quantity)}]),
    {ok};

do_cmd(["宝库信息"], Role) ->
    case guild_rpc:handle(12771, {}, Role) of
        {ok} ->
            ?DEBUG("false"),
            {ok};
        {reply, _Reply} ->
            ?DEBUG("guild treasures is ~n~p", [_Reply]),
            {ok}
    end;

do_cmd(["自动分配宝库"], Role) ->
    case guild_treasure:allocate(Role) of
        {false, Reason} ->
            Reason;
        _ ->
            {ok}
    end;

do_cmd(["宝库分配", Rid, Rsrvid, ID, Quantity], Role) ->
    case guild_treasure:allocate(Role, list_to_integer(Rid), list_to_binary(Rsrvid), list_to_integer(ID), list_to_integer(Quantity)) of
        {false, Reason} ->
            Reason;
        _ ->
            {ok}
    end;

do_cmd(["帮战成绩"], Role) ->
    guild_rpc:handle(12774, {}, Role),
    {ok};

do_cmd(["帮会维护"], _Role) ->
    Fun = fun(#guild{pid = Pid}) -> guild:guild_info(Pid, maintain), guild:guild_info(Pid, dismiss_check) end,
    lists:foreach(Fun, guild_mgr:list()),
    {ok};

do_cmd(["宝库日志"], _Role) ->
    ?DEBUG("treasure log is ~w", [guild_treasure:allocate_log(_Role)]),
    {ok};

do_cmd(["背包物品"], #role{bag = _Bag}) ->
    ?DEBUG("bag is ~n~p", [_Bag]),
    {ok};

do_cmd(["种花", ID], Role) ->
    case item_rpc:handle(10315, {list_to_integer(ID), 1}, Role) of
        {reply, _, NewRole} ->
            {ok, NewRole};
        _ ->
            {ok}
    end;

do_cmd(["护花", ID], Role) ->
    case map_rpc:handle(10100, {list_to_integer(ID), 0}, Role) of
        {reply, _, NewRole} ->
            {ok, NewRole};
        _ ->
            {ok}
    end;

do_cmd(["新帮战下个阶段"], _Role) ->
    guild_arena:adm_next(),
    %% center:cast(guild_arena_center_mgr, adm_next, []),
    {ok};

do_cmd(["新帮战重新开始"], _Role) ->
    guild_arena:adm_restart(),
    %% center:cast(guild_arena_center_mgr, adm_restart, []),
    {ok};

do_cmd(["跨服帮战开始"], _Role) ->
    center:cast(guild_arena_center_mgr, adm_restart, []),
    %% center:cast(c_mirror_group, cast, [all, guild_arena, adm_restart, []]),
    {ok};

do_cmd(["跨服帮战继续"], _Role) ->
    center:cast(guild_arena_center_mgr, adm_next, []),
    %% center:cast(c_mirror_group, cast, [all, guild_arena, adm_next, []]),
    {ok};

do_cmd(["跨服帮战信息"], Role) ->
    Reply = case center:call(guild_arena_center_mgr, get_info, [adm_all]) of
        {Id, Round, GuildNum, RoleNum, AreaNum, LastWinner, StateName, Timeout} ->
            util:fbin("跨服帮战信息: ~n, 届次 ~w, 当前轮 ~w, 参战帮派数 ~w, 参战人数 ~w, 当前战区数 ~w, 上届冠军 ~w, 目前状态 ~w, 距离下个状态还有 ~w 毫秒", [Id, Round, GuildNum, RoleNum, AreaNum, LastWinner, StateName, Timeout]);
        _ ->
            <<>>
    end,
    {ok, Reply, Role};

do_cmd(["跨服帮战轮数", Round], _Role) ->
    center:cast(guild_arena_center_mgr, adm_round, [list_to_integer(Round)]),
    {ok};

do_cmd(["接悬赏任务", Id], Role) ->
    case task_rpc:handle(10224, {list_to_integer(Id)}, Role) of
        {reply, R, NewRole} ->
            Data = util:fbin("~w", [R]),
            {ok, Data, NewRole};
        {reply, R} ->
            Data = util:fbin("~w", [R]),
            {ok, Data, Role};
        R ->
            Data = util:fbin("~w", [R]),
            {ok, Data, Role}
    end;

do_cmd(["刷新悬赏任务"], Role = #role{pid = Pid}) ->
    task_wanted:refresh(),
    case task_rpc:handle(10223, {1}, Role) of
        {reply, PageData} ->
            role:pack_send(Pid, 10223, PageData),
            {ok};
        _ ->
            {ok}
    end;

do_cmd(["新帮战届次", Id], _Role) ->
    guild_arena:adm_id(Id),
    {ok};
do_cmd(["报名新帮战"], Role) ->
    guild_arena:join(guild, Role),
    {ok};
do_cmd(["加入新帮战"], Role) ->
    guild_arena:join(role, Role),
    {ok};

do_cmd(["反对弹劾"], Role) ->
    case guild_mem:reject_impeach(Role) of
        {false, Reason} ->
            Reason;
        _ ->
            {ok}
    end;

do_cmd(["帮会仓库"], Role) ->
    guild_store:tidy(Role),
    {ok};

do_cmd(["设npc好感度", NpcBaseId, ImpressionChanged], #role{id = Rid}) ->
    npc_employ_mgr:set_npc_impression(Rid, list_to_integer(NpcBaseId), list_to_integer(ImpressionChanged)),
    {ok};

do_cmd(["雇佣npc", NpcBaseId, EmployHours], #role{id = Rid, pid = RolePid}) ->
    npc_employ_mgr:employ_npc(Rid, RolePid, list_to_integer(NpcBaseId), list_to_integer(EmployHours)),
    {ok};

do_cmd(["解雇npc"], #role{id = Rid, pid = RolePid}) ->
    npc_employ_mgr:fire_npc(Rid, RolePid),
    {ok};

do_cmd(["统计师门奖励"], _Role) ->
    arena_career_mgr:gm_award(),
    {ok};

do_cmd(["统计跨服资格"], _Role) ->
    center:call(c_arena_career_mgr, notice, []),
    {ok};

do_cmd(["打自己"], Role = #role{}) ->
    combat_type:check(?combat_type_arena_career, Role, Role),
    {ok};

do_cmd(["仙道会开启"], _Role) ->
    center:cast(c_world_compete_mgr, start_activity, []),
    {ok};

do_cmd(["仙道会关闭"], _Role) ->
    center:cast(c_world_compete_mgr, stop_activity, []),
    {ok};

do_cmd(["仙道会开启报名限制"], _Role) ->
    world_compete_mgr:open_sign_up_limit(),
    {ok};

do_cmd(["仙道会关闭报名限制"], _Role) ->
    world_compete_mgr:close_sign_up_limit(),
    {ok};

do_cmd(["仙道勋章等级", StrWcLev], Role = #role{assets = Assets}) ->
    WcLev = to_int(StrWcLev),
    {ok, Role#role{assets = Assets#assets{wc_lev = WcLev}}};

do_cmd(["仙道会清次数"], _Role) ->
    world_compete_mgr:force_clear_sign_up_limit(),
    {ok};

do_cmd(["仙道会发段位奖励"], _Role) ->
    center:cast(c_world_compete_mgr, send_day_section_rewards, []),
    {ok};

do_cmd(["仙道会开启段位赛季末测试"], _Role) ->
    center:cast(c_world_compete_mgr, open_section_over_rewards_test, []),
    {ok};

do_cmd(["仙道会关闭段位赛季末测试"], _Role) ->
    center:cast(c_world_compete_mgr, close_section_over_rewards_test, []),
    {ok};

do_cmd(["仙道会设段位等级", Lev], #role{id = RoleId}) ->
    SectionLev = to_int(Lev),
    center:cast(c_world_compete_mgr, set_section_lev, [RoleId, SectionLev]),
    {ok};

do_cmd(["创建神秘商店", NpcId], #role{pos = Pos}) ->
    npc_store_dung:create(list_to_integer(NpcId), Pos),
    {ok};

do_cmd(["翅膀进阶"], Role) ->
    wing:gm(Role, step, step);

do_cmd(["坐骑进阶"], Role) ->
    case mount:gm_upgrade(Role) of
        {false, Reason} ->
            {false, Reason};
        {ok, NewRole} ->
            {ok, NewRole}
    end;

do_cmd(["设坐骑等级", Lev], Role) ->
    case mount:gm_setlev(to_int(Lev), Role) of
        {false, Reason} ->
            {false, Reason};
        {ok, NewRole} ->
            {ok, NewRole}
    end;

do_cmd(["老友归来"], Role = #role{offline_exp = OffInfo}) ->
    {ok, Role#role{offline_exp = OffInfo#offline_exp{award_logout5day = 1}}}; 

do_cmd(["棒子认证"], Role) ->
    case fcm_kr:authenticate(Role) of
        ok -> {ok};
        {false, Reason} -> {false, Reason}
    end;

do_cmd(["删除结拜称号", Type], Role) ->
    {ok, sworn:gm_del_title(Role, to_int(Type))};

do_cmd(["kr_auth"], Role) ->
    fcm_dao:add(Role, {20, <<"sys">>}),
    {ok};

do_cmd(["无尽的战斗"], Role) ->
    _Result = combat:start(?combat_type_practice, 0, role_api:fighter_group(Role), [20001, 20004, 20005, 20006, 20007, 20008], [{start_wave_no, 1}]),
    ?DEBUG("无尽的战斗发起结果:~w", [_Result]),
    {ok};

do_cmd(["清摇钱次数"], Role) ->
    {ok, Role#role{money_tree = #money_tree{times = 0}}};

do_cmd(["开启烟花晚会"], _Role) ->
    fireworks:gm_start(),
    {ok};

do_cmd(["关闭烟花晚会"], _Role) ->
    fireworks:gm_stop(),
    {ok};

do_cmd(["马上开始"], _Role) ->
    fireworks:gm_start_at_once(),
    {ok};

do_cmd(["设烟花数", Count], _Role) ->
    fireworks:gm_set_count(to_int(Count)),
    {ok};

do_cmd(["设采仙果次数", Num], Role) ->
    {ok, NewRole} = lottery_secret:gm_set_num(Role, to_int(Num)),
    {ok, NewRole};

do_cmd(["跨服组队", StrId, SrvId], Role) ->
    Id = to_int(StrId),
    case team_api:create_team(Role, [{Id, list_to_binary(SrvId)}]) of
        {false, Msg} -> {false, Msg};
        {ok, _Tpid} ->
            {ok}
    end;
do_cmd(["跨服组队", StrId1, SrvId1, StrId2, SrvId2], Role) ->
    Id1 = to_int(StrId1),
    Id2 = to_int(StrId2),
    case team_api:create_team(Role, [{Id1, list_to_binary(SrvId1)}, {Id2, list_to_binary(SrvId2)}]) of
        {false, Msg} -> {false, Msg};
        {ok, _Tpid} ->
            {ok}
    end;

do_cmd(["许愿墙"], _Role) ->
    wish_wall:gm_status(),
    center:cast(wish_wall, gm_status, []),
    {ok};

do_cmd(["许愿墙单服"], _Role) ->
    wish_wall:debug(local_luck),
    {ok};

do_cmd(["许愿墙全服"], _Role) ->
    center:cast(wish_wall, debug, [center_luck]),
    {ok};

do_cmd(["设置掉落时间", Year, Month, Day, Hour, Minute, Second], _Role) ->
    Year1 = to_int(Year),
    Month1 = to_int(Month),
    Day1 = to_int(Day),
    Hour1 = to_int(Hour),
    Minute1 = to_int(Minute),
    Second1 = to_int(Second),
    drop_data_mgr:set_drop_time(Year1, Month1, Day1, Hour1, Minute1, Second1),
    {ok};

do_cmd(["清除掉落时间"], _Role) ->
    drop_data_mgr:clear_drop_time(),
    {ok};

do_cmd(["领养帮派boss", Type], Role) ->
    guild_boss:adopt(Role, to_int(Type)),
    {ok};
do_cmd(["喂养帮派boss", Type, Exp], Role) ->
    guild_boss:adm_feed(Role, to_int(Type), to_int(Exp)),
    {ok};
do_cmd(["召唤帮派boss", Type], Role) ->
    guild_boss:call_out(Role, to_int(Type)),
    {ok};
do_cmd(["寻找帮派boss"], Role) ->
    guild_boss:apply_guild_area(Role);
do_cmd(["清帮派boss喂养"], Role) ->
    guild_boss:adm_clean(Role),
    {ok};
do_cmd(["设帮派boss等级", Type, Lev], Role) ->
    guild_boss:adm_lev_up(Role, to_int(Type), to_int(Lev)),
    {ok};
do_cmd(["设帮派boss血量", Type, Hp], Role) ->
    guild_boss:adm_set_hp(Role, to_int(Type), to_int(Hp)),
    {ok};
do_cmd(["top_fight"], Role) ->
    top_fight_center_mgr:next_all(timeout),
    {ok, Role};

do_cmd(["tf报名"], _Role = #role{pid = Rpid}) ->
    role:rpc(Rpid, top_fight_rpc, 17301, {}),
    {ok};

do_cmd(["tf退出"], #role{pid = Rpid}) ->
    role:rpc(Rpid, top_fight_rpc, 17303, {}),
    {ok};

do_cmd(["设进帮会被欢迎次数", Num], Role = #role{guild = Guild}) ->
    {ok, Role#role{guild = Guild#role_guild{welcome_times = to_int(Num)}}};

do_cmd(["cross_ore"], _Role) ->
    center:cast(cross_ore_mgr, gm_status, []),
    {ok};

do_cmd(["设神魔阵等级", Lev], Role) ->
    case soul_world:adm_upgrade_array(Role, to_int(Lev)) of
        NewRole = #role{} ->
            {ok, NewRole};
        _ ->
            {ok}
    end;
do_cmd(["设灵宠阵等级", Lev], Role) ->
    case soul_world:adm_upgrade_array_pet(Role, to_int(Lev)) of
        NewRole = #role{} ->
            {ok, NewRole};
        _ ->
            {ok}
    end;

do_cmd(["设法宝等级", Type, Lev], Role) ->
    case soul_world:adm_upgrade_magic(Role, to_int(Type), to_int(Lev)) of
        NewRole = #role{} ->
            {ok, NewRole};
        _ ->
            {ok}
    end;

do_cmd(["设置女巫能量", Power], _Role) ->
    campaign_plant:set_witch_power(to_int(Power)),
    {ok};

do_cmd(["清空体力购买次数"], Role = #role{energy = Energy}) ->
    Role1 = Role#role{energy = Energy#energy{buy_times = 0}},
    energy:pack_send_19605(Role1),
    {ok, Role1};

do_cmd(["清空体力领取"], Role = #role{energy = Energy = #energy{}}) ->
    Role1 = Role#role{energy = Energy#energy{has_rcv_id = []}},
    energy:pack_send_energy_status(Role1),
    {ok, Role1};


do_cmd(["时装信息"], #role{dress = _Dress}) ->
    ?DEBUG("我的时装信息: ~w", [_Dress]),
    {ok};

do_cmd(["设时装过期", DressId], Role = #role{dress = Dress}) ->
    DressId1 = to_int(DressId),
    case lists:keyfind(DressId1, 1, Dress) of
        {DressId1, _F, Item = #item{special = Spec}} ->
            New = {DressId, _F, Item#item{special = lists:keyreplace(?special_expire_time, 1, Spec, {?special_expire_time, 0})}},
            Dress1 = lists:keydelete(DressId1, 1, Dress),
            {ok, Role#role{dress = [New | Dress1]}};
        false ->
            ?DEBUG("没有此时装"),
            {ok}
    end;

do_cmd(["清除时装"], Role = #role{}) ->
    Role1 = Role#role{dress = []},
    Role2 = looks:calc(Role1),
    Role3 = role_api:push_attr(Role2),
    looks:refresh(Role, Role3),
    dress:pack_send_dress_info(Role3),
    {ok, Role3};

do_cmd(["外观"], #role{looks = _Looks}) ->
    ?DEBUG("外观信息 ~w", [_Looks]),
    {ok};

do_cmd(["过期时装"], Role = #role{dress = Dress}) ->
    Dress1 = item_parse:parse_dress(Dress),
    Role1 = Role#role{dress = Dress1},
    {ok, Role1};


do_cmd(["休闲副本"], Role) ->
    Role1 = role_listener:ease_dungeon(Role, {10011, 1}),
    {ok, Role1};

do_cmd(["获取时装", Arg], Role = #role{link = #link{conn_pid = _ConnPid}, dress = Dress1}) ->
    BaseId = to_int(Arg),

    case item:make(BaseId, 1, 1) of
        {ok, [Item]} -> 
            Id = dress:gen_dress_id(Role),
            Dress2 = [{Id, 0, Item#item{id = Id,durability = util:unixtime()}}| Dress1],
            Role1 = Role#role{dress = Dress2},
            dress:pack_send_dress_info(Role1),
            {ok, Role1};
        false ->
            {ok}
    end;

do_cmd(["穿时装", Arg], Role = #role{}) ->
    Id = to_int(Arg),
    case item_rpc:handle(10343, {[Id]}, Role) of
        {reply, {?false, _Reason}} ->
            ?DEBUG("穿时装失败 原因: ~s", [_Reason]),
            {ok};
        {reply, {?true, _Info}, Role1} ->
            ?DEBUG("穿时装成功!!!"),
            dress:pack_send_dress_info(Role1),
            {ok, Role1}
    end;

do_cmd(["脱时装", Arg], Role = #role{}) ->
    Id = to_int(Arg),
    case item_rpc:handle(10345, {Id}, Role) of
        {reply, {?false, _Reason}} ->
            ?DEBUG("脱时装失败 原因: ~s", [_Reason]),
            {ok};
        {reply, {?true, _Info}, Role1} ->
            ?DEBUG("脱时装成功!!!"),
            dress:pack_send_dress_info(Role1),
            {ok, Role1}
    end;

do_cmd(["购买时装", OprType1, Id1, Expire1, Attr_idx1], Role = #role{}) ->
    OprType = to_int(OprType1), Id = to_int(Id1), Expire = to_int(Expire1), Attr_idx = to_int(Attr_idx1),
    case shop_rpc:handle(12013, {OprType, Id, Expire, Attr_idx}, Role) of
        {ok} ->
            ?DEBUG("购买时装失败"),
            {ok};
        {ok, Role1} ->
            ?DEBUG("购买时装成功!!!"),
            dress:pack_send_dress_info(Role1),
            {ok, Role1}
    end;

do_cmd(["清空装备"], Role = #role{link = #link{conn_pid = ConnPid}}) ->
    Role1 = Role#role{eqm = []},
    sys_conn:pack_send(ConnPid, 10306, {[]}),
    {ok, Role1};

do_cmd(["包"], Role) ->
    role_gain:do([#gain{label = item, val = [221101,0,1]}, #gain{label = item, val = [221101,0,1]}], Role);   

do_cmd(["包1"], Role) ->
    Gains = [#gain{label = item, val = [221101,0,1]}, #gain{label = item, val = [221101,0,1]}],
    Gains1 = role_gain:merge_gains(Gains),
    role_gain:do(Gains1, Role); 

do_cmd(["点副本"], Role) ->
    {reply, {}, Role1} = task_rpc:handle(10238, {}, Role),
    {ok, Role1};

do_cmd(["增加数量", Career, Sex, Num], _Role) ->
    Career1 = to_int(Career),
    Sex1 = to_int(Sex),
    Num1 = to_int(Num),
    role_num_counter:update({Career1, Sex1, Num1}),
    {ok};

do_cmd(["角色数量"], _Role) ->
    ?DEBUG(" 角色数量  ~w", [role_num_counter:lookup()]),
    {ok};

do_cmd(["完成副本任务", DungeonId, Star], Role) ->
    DungeonId1 = to_int(DungeonId),
    Star1 = to_int(Star),
    {ok, role_listener:star_dungeon(Role, {DungeonId1, Star1})};

do_cmd(["查看任务缓存"], _Role) ->
    {ok, FinishStarDun} = role:get_dict(task_finish_stardun),
    {ok, AcceptedStarDun} = role:get_dict(task_accepted_stardun),
     L1 = [TaskId1 || #task_finish{task_id = TaskId1} <- FinishStarDun] ++ AcceptedStarDun,
    ?DEBUG("星级副本任务缓存: ~w", [L1]),
    {ok};

do_cmd(["清副本任务"], #role{id = {RoleId, SrvId}}) ->
    role:put_dict(task_finish_stardun, []),
    role:put_dict(task_accepted_stardun, []),
    Sql = "delete * from role_task_log where role_id = ~s,  srv_id = ~s, type = 10",
    db:execute(Sql, [RoleId, SrvId]),
    {ok};

do_cmd(["接副本任务", TaskId], Role) ->
    {ok, task:accept_star_dungeon(to_int(TaskId), Role)};

do_cmd(["首通副本", DungeonId1], Role  = #role{dungeon = RoleDungeons} ) ->
    DungeonId = to_int(DungeonId1),
    Role1 =
    case lists:keyfind(DungeonId, #role_dungeon.id, RoleDungeons) of
        #role_dungeon{} ->
            Role;
            _ ->
                RD = #role_dungeon{id = DungeonId, best_star = 3, clear_count = 1},
                Role#role{dungeon = [RD | RoleDungeons]}
    end,
    DungeonId1 = to_int(DungeonId),
    Role2 = task:clear_dungeon_fire(DungeonId1, Role1),
    {ok, Role2};

do_cmd(["触发任务"], Role) ->
    {ok, task:finish_task_fire_star_dun(Role)};

do_cmd(["role_dun"], #role{dungeon = Dungeons}) ->
    ?DEBUG("~w", [Dungeons]),
    {ok};
do_cmd(["add_role_dun", DungeonId1, Star1, Count1], Role = #role{dungeon = RoleDungeons}) ->
    DungeonId = to_int(DungeonId1), Star = to_int(Star1), Count = to_int(Count1),

    Role4 = 
    case lists:keyfind(DungeonId, #role_dungeon.id, RoleDungeons) of
        RoleDungeon = #role_dungeon{best_star = BestStar, clear_count = ClearCount} ->
            BestStar2 = BestStar + Star,
            RoleDungeons3 = lists:keyreplace(DungeonId, #role_dungeon.id, RoleDungeons,
                RoleDungeon#role_dungeon{best_star = BestStar2, clear_count = ClearCount + Count}),
            Role#role{dungeon = RoleDungeons3};
            _ ->
                RD = #role_dungeon{id = DungeonId, best_star = Star, clear_count = Count1},
                Role#role{dungeon = [RD | RoleDungeons]}
    end,
    {ok, Role4};


do_cmd(["清空宠物云朵"], Role) ->
    {ok, pet_ex:clean_pet_cloud(Role)};

%% 控制面板输入的SrvId格式是："4399_2"
do_cmd(["跨服旅行", SrvId], #role{pid = Pid}) ->
    cross_trip:enter_cross_srv(Pid, SrvId, 10003, 7140, 690),
    {ok};

do_cmd(["播放录像", ReplayIdStr], #role{pid = Pid, link = #link{conn_pid=ConnPid}}) ->
    {ok, ReplayId} = util:string_to_term(ReplayIdStr),
    combat_replay_mgr:playback(ReplayId, Pid, ConnPid),
    {ok};

do_cmd(["最强帮会"], #role{guild = #role_guild{gid = Gid, srv_id = GsrvId}}) ->
    guild_adm:onekey_max({Gid, GsrvId}),
    {ok};

do_cmd(["reload_shop"], _) ->
    shop:gm_reload(),
    {ok};

do_cmd(["kill_boss"], _) ->
    super_boss_mgr:gm_kill_boss(),
    {ok};

do_cmd(["boss_timeout", Value, Value2], _) ->
    LeftTime = to_int(Value),
    BossCount = to_int(Value2),
    super_boss_mgr:set_left_time(LeftTime, BossCount),
    {ok};

do_cmd(["竞技场"], _) ->
    compete_mgr:set_left_time(1),
    {ok};

do_cmd(["tree_next"], #role{id = Rid}) ->
    tree_api:next_day(Rid),
    {ok};

do_cmd(["buff"], Role = #role{}) ->
    case buff:add(Role, compete_all_1) of
        {ok, Role2} ->
            role_api:push_attr(Role2);
        _ ->
            ignore
    end,
    {ok};

do_cmd(["tree_boss", Value], #role{id = Rid}) ->
    Stage = to_int(Value),
    tree_api:gm_boss(Rid, Stage),
    {ok};

do_cmd(["jail_next"], #role{id = Rid}) ->
    jail_api:next_day(Rid),
    {ok};

do_cmd(["jail_floor", Value], #role{id = Rid}) ->
    Stage = to_int(Value),
    jail_api:gm_floor(Rid, Stage),
    {ok};

do_cmd(["jail_boss", Value, Value2], #role{id = Rid}) ->
    IsClear = to_int(Value),
    NpcBaseId = to_int(Value2),
    jail_api:gm_boss(Rid, IsClear, NpcBaseId),
    {ok};

do_cmd(["jail_add", Value, Value2], #role{id = Rid}) ->
    Stage = to_int(Value),
    Time = to_int(Value2),
    jail_api:gm_add(Rid, Stage, Time),
    {ok};

do_cmd(["clear_4"], Role = #role{id = Rid}) ->
    ets:delete(wanted_role_action, Rid),
    super_boss_mgr:gm_clear_count(Rid),
    {ok, Role#role{expedition = {0, 0}}};

do_cmd(["设合作值", Value], Role = #role{}) ->
    Cooperation = to_int(Value),
    case role_gain:do(#gain{label = cooperation, val = Cooperation}, Role) of
        {ok, Role2} ->
            {ok, Role2};
        _ ->
            {ok, Role}
    end;

do_cmd(["unlock_map"], Role = #role{link = #link{conn_pid = ConnPid}}) ->
    Id = 1425,
    sys_conn:pack_send(ConnPid, 10102, {Id}),
    {ok, Role#role{max_map_id = Id}};

do_cmd(["unlock_dungeon"], Role = #role{pid = Pid, dungeon = RoleDungeons, dungeon_map = DungeonMap}) ->
    RoleDungeons2 = dungeon_api:unlock_all_dungeon(RoleDungeons),
    DungeonMap2 = dungeon_api:unlock_all_map(DungeonMap),

    Msg = dungeon_api:pack_proto_13501(DungeonMap2, RoleDungeons2),
    role:pack_send(Pid, 13501, Msg),
    Role2 = Role#role{dungeon = RoleDungeons2, dungeon_map = DungeonMap2},
    {ok, Role2};

do_cmd(["unlock_some_dungeon"], Role = #role{pid = Pid, dungeon = RoleDungeons, dungeon_map = DungeonMap}) ->
    RoleDungeons2 = dungeon_api:unlock_some_dungeon(RoleDungeons),
    DungeonMap2 = dungeon_api:unlock_all_map(DungeonMap),

    Msg = dungeon_api:pack_proto_13501(DungeonMap2, RoleDungeons2),
    role:pack_send(Pid, 13501, Msg),
    Role2 = Role#role{dungeon = RoleDungeons2, dungeon_map = DungeonMap2},
    {ok, Role2};

do_cmd(["best_dungeon"], Role = #role{pid = Pid, dungeon = RoleDungeons, dungeon_map = _DungeonMap}) ->
    {DungeonMap2, RoleDungeons2} = dungeon_api:best_all_dungeon(RoleDungeons),
    Msg = dungeon_api:pack_proto_13501(DungeonMap2, RoleDungeons2),
    role:pack_send(Pid, 13501, Msg),
    {ok, Role#role{dungeon = RoleDungeons2, dungeon_map = DungeonMap2}};

do_cmd(["reset_box"], Role = #role{pid = Pid, dungeon_map = DungeonMap, dungeon = RoleDungeons}) ->
    DungeonMap2 = dungeon_api:reset_box(DungeonMap),
    Msg = dungeon_api:pack_proto_13501(DungeonMap2, RoleDungeons),
    role:pack_send(Pid, 13501, Msg),
    {ok, Role#role{dungeon_map = DungeonMap2}};

do_cmd(["energy", Value], Role) ->
    Energy = to_int(Value),
    role_gain:do([#gain{label = energy, val = Energy}], Role);

do_cmd(["loss_energy", Value], Role) ->
    Energy = to_int(Value),
    role_gain:do([#loss{label = energy, val = Energy}], Role);

do_cmd(["wanted_timeout", Value], _) ->
    LeftTime = to_int(Value),
    wanted_mgr:set_left_time(LeftTime),
    {ok};

do_cmd(["wanted_clear"], _) ->
    wanted_mgr:gm_clear(),
    {ok};

do_cmd(["wanted_next"], #role{id = _Rid}) ->
    wanted_mgr:gm_next(),
    {ok};

do_cmd(["回故乡"], Role) ->
    trip_mgr:leave_center_city(Role),
    {ok};

do_cmd(["特殊事件", P1, P2], Role) ->
    Role1 = role_listener:special_event(Role, {to_int(P1), to_int(P2)}),
    {ok, Role1};


do_cmd(["pet_exp", Exp], Role) ->
    Exp1 = to_int(Exp),
    Role1 = pet_api:asc_pet_exp(Role, Exp1),
    {ok, Role1};


do_cmd(["送花排行榜奖励"], _Role) ->
    rank_qixi:reward(),
    {ok};

do_cmd(["pool"], Role) ->
    guild_pool:next(),
    {ok, Role};

do_cmd(["清战力"], Role) ->
    {ok, NewRole} = eqm_api:do_clean_max_fc(Role),
    {ok, NewRole};

do_cmd(["设体力", Val], Role = #role{assets = Assets}) ->
    Role1 = Role#role{
        assets = Assets#assets{
            energy = list_to_integer(Val)
        }
    },
    {ok, Role1};

do_cmd(["查看体力信息"], #role{energy = _Eng}) ->
    ?DEBUG("当前体力信息  ~w", [_Eng]),
    {ok};

do_cmd(["清领取体力"], Role = #role{link = #link{conn_pid = ConnPid}, energy = E}) ->
    Role1 = Role#role{energy = E#energy{has_rcv_id = []}},
    case energy:have_new_energy(Role) of
        [] ->
            {ok, Role1};
        CanGetList ->
            sys_conn:pack_send(ConnPid, 19602, {energy:id2detail(CanGetList, [])}),
            {ok, Role1}
    end;

do_cmd(["体力隔天"], Role = #role{energy = _Eng}) ->
    energy:day_check(Role);

%% 同步功能活跃度统计信息
do_cmd(["activity2_log"], _role) ->
    activity2_log:adm_statis(),
    {ok};

do_cmd(["exp", Val], Role) ->
    role_gain:do([#gain{label = exp, val = list_to_integer(Val)}], Role);

do_cmd(["清至尊特权"], Role = #role{campaign = Camp = #campaign_role{camp_card = {Label, Gold, _}}}) ->
    {ok, Role#role{campaign = Camp#campaign_role{camp_card = {Label, Gold, 1}}}};

do_cmd(["设春节登录天数", Day], Role) ->
    case campaign_reward:adm_set_spring_days(Role, to_int(Day)) of
        {ok, NewRole} -> {ok, NewRole};
        {false, Msg} -> {false, Msg}
    end;

do_cmd(["飞仙历练"], Role) ->
    train_common:reset(Role);

do_cmd(["设红包天数", Day, Gold], Role) ->
    case campaign_daily_consume:adm_set_days(Role, to_int(Day), to_int(Gold)) of
        {ok, Role1} -> {ok, Role1};
        {false, Reason} when is_bitstring(Reason) -> {false, Reason};
        _ -> {false, <<"错了">>}
    end;

do_cmd(["清改名"], Role) ->
    Role1 = Role#role{name_used = <<>>},
    {ok, Role1};

do_cmd(["测试庄园"], Role) ->
    _Status = manor:status(Role),
    ?DEBUG("当前庄园状态: ~p ", [_Status]),
    {ok, Role};

do_cmd(["mhfx"], Role) ->
    {ok, NewRole} = do_cmd(["完成任务链", "10064"], Role),
    role:stop(async, Role#role.pid, <<"请刷新">>),
    {ok, NewRole};

do_cmd(["guild_vip"], Role) ->
    case guild_common:upgrade(Role) of
        {false, gold_less} ->
            {false, <<"晶钻不足">>};
        {false, Reason} ->
            {false, Reason};
        {ok, NewRole} ->
            {ok, NewRole}
    end;

do_cmd(["guild_piv"], Role) ->
    case guild_common:degrade(Role) of
        {false, Reason} ->
            {false, Reason};
        _ ->
            {ok}
    end;

do_cmd(["清空邮件"], #role{id = {Rid, SrvId}}) ->
    Sql = "delete from role_mail where to_rid=~s and to_srv_id=~s",
    case db:execute(Sql, [Rid, SrvId]) of
        {ok, Rows} when is_integer(Rows) andalso Rows > 0 -> {false, util:fbin("清空了 ~w 封邮件, F5 刷新", [Rows])};
        _ -> {false, ?L(<<"删除邮件失败">>)}
    end;

do_cmd(["发送系统邮件"], Role = #role{}) ->
    Content = ?L(<<"这是一封系统邮件。">>),
    Assets = [{2, 99}, {3, 200}, {4, 300}, {5, 9}, {6, 55}],
    case mail:send_system([Role], {?L(<<"系统邮件">>), Content, Assets, [{101010, 0, 1}, {531005, 1, 1}]}) of
        ok ->
            ?DEBUG("***发送系统邮件成功哦  ***\n"),
            {ok};
        {false, Reason} ->
            ?ERR("发邮件失败了:~w", [Reason]),
            {ok}
    end;

do_cmd(["send", A], #role{}) ->
    AdmName = <<"灿灿">>,
    Sub = <<"系统邮件">>,
    Content = ?L(<<"管理员发福利啦">>),
    Assets = [{2, 99}, {3, 200}, {4, 300}],
    A1 = list_to_binary(A),
    case mail_adm:send(AdmName, Sub, Content, [A1], [], Assets, [{101011, 0, 1}, {531005, 1, 1}]) of
        [] ->
            ?DEBUG("***发送系统邮件成功哦  ***\n"),
            {ok};
        [Reason] ->
            ?ERR("发邮件失败了:~w", [Reason]),
            {ok}
    end;


%% 本服飞仙历练创建机器人
do_cmd(["train", "local", Lid, Aid, Num], _Role) ->
    train_common:robot(local, list_to_integer(Lid), list_to_integer(Aid), list_to_integer(Num)),
    {ok};

%% 跨服飞仙历练创建机器人
do_cmd(["train", "center", Lid, Aid, Num], _Role) ->
    train_common:robot(center, list_to_integer(Lid), list_to_integer(Aid), list_to_integer(Num)),
    {ok};

%% 测试获取日常任务
do_cmd(["日常", Lev, Id], _Role) ->
    ?DEBUG("lev:~p  Id:~p", [Lev, Id]),
    N1 = to_int(Lev),
    N2 = to_int(Id),
    ?DEBUG("******* ~p ~p", [N1, N2]),
    task:test_get_daily(N1, N2),
    {ok};

%% 测试高斯
do_cmd(["高斯", N], _Role) ->
    N1 = to_int(N),
    test_guss(N1),
    {ok};


%% 重启飞仙历练
do_cmd(["train", "center"], _Role) ->
    train_adm:restart(center),
    {ok};

do_cmd(["train", "local"], _Role) ->
    train_adm:restart(local),
    {ok};

do_cmd(["channel", A, P], Role) ->
    AutoBuy = to_int(A), IsProtected = to_int(P),
    LossList = channel:get_upgrade_loss(AutoBuy, IsProtected) ++ [#loss{label = coin_all, val = 1000, msg = ?MSGID(<<"金币不足">>)}],
    case role_gain:do(LossList, Role) of
        Ret = {ok, _Role1} ->
            ?DEBUG("*********  成功扣除  "),
            Ret;
        {false, #loss{msg = _Msg}} ->
            ?DEBUG("******  失败  ~w", [_Msg]),
            {ok}
    end;

%% 重设劳模活动
do_cmd(["开启劳模"], _Role) ->
    campaign_model_worker:adm_restart(),
    {ok};

%% 结束劳模
do_cmd(["结束劳模"], _Role) ->
    campaign_model_worker:adm_stop(),
    {ok};

%% 技能突破
do_cmd(["技能突破"], Role) ->
    skill:gm_break_out(Role);

%% 发奖励
do_cmd(["发奖励", AwardBaseId], Role) ->
    award:send(Role#role.id, list_to_integer(AwardBaseId)),
    {ok};

%% 发系统奖励
do_cmd(["发系统奖励"], Role) ->
    G = #gain{label = item, val = [101010, 0, 1]},
    award:send(Role#role.id, 301000, ?L(<<"系统邮件">>), ?L(<<"亲爱的玩家，你收到了吗？">>), [G]),
    {ok};

%% 离线消息测试
do_cmd(["离线消息测试", Type], #role{id={RoleId, SrvId}}) ->
    case Type of
        "1" -> notification:send(online, {RoleId, SrvId}, 1, <<"张文君文君对你发起了掠夺战斗，你被胖揍了一顿，黑暗树根怪碎片被抢走了">>, []);
        "2" -> notification:send(online, {RoleId, SrvId}, 2, <<"张文君文君对你发起了掠夺战斗，你被胖揍了一顿，黑暗树根怪碎片被抢走了">>, []);
        "3" -> notification:send(online, {RoleId, SrvId}, 3, <<"张文君文君对你发起了掠夺战斗，你被胖揍了一顿，黑暗树根怪碎片被抢走了">>, []);
        "4" -> notification:send(online, {RoleId, SrvId}, 4, <<"张文君文君对你发起了掠夺战斗，你被胖揍了一顿，黑暗树根怪碎片被抢走了">>, []);
        "5" -> notification:send(online, {RoleId, SrvId}, 5, <<"张文君文君对你发起了掠夺战斗，你被胖揍了一顿，黑暗树根怪碎片被抢走了">>, []);
        _ -> notification:send(offline, {RoleId, SrvId}, 1, <<"离线消息测试">>, [])
    end,
    {ok};

do_cmd(["查看经验"], #role{assets = #assets{exp = _Exp}}) ->
    ?DEBUG("------------------经验 ~w", [_Exp]),
    {ok};

%% 加经验
do_cmd(["加经验", Exp], Role) ->
    {ok, NewRole} = role_gain:do(#gain{label = exp, val = list_to_integer(Exp)}, Role),
    NewRole1 = role_api:push_attr(NewRole),
    NewRole2 = role_api:push_assets(Role, NewRole1),
    {ok, NewRole2};

do_cmd(["完成新手"], Role = #role{tutorial = _T}) ->
    Role1 = Role#role{tutorial = undefined},
    {ok, Role2} = map:role_enter(1400, 220, 450, Role1),
    {ok, Role2};

do_cmd(["断开连接"], Role = #role{id = RoleId}) ->
    spawn(fun()->
        role_api:kick(by_id, RoleId, <<"断开连接">>)
    end),
    {ok, Role};

do_cmd(["断开连接", Reason], Role = #role{id = RoleId}) ->
    spawn(fun()->
        role_api:kick(by_id, RoleId, list_to_binary(Reason))
    end),
    {ok, Role};

do_cmd(["换线", Line], Role = #role{}) ->
    case map_line:switch(list_to_integer(Line), Role) of
        {ok, NewRole} -> {ok, NewRole};
        _ -> {ok, Role}
    end;

do_cmd(["测试客服消息", Msg], Role) ->
    gm_rpc:handle(14506, {list_to_binary(Msg)}, Role),
    {ok, Role};

do_cmd(_C, _Role) ->
    ?DEBUG("==========_C:~p", [_C]),
    {false, <<"未知命令或命令格式不正确">>}.


%% 转整数
to_int(Val) when is_integer(Val) -> Val;
to_int(Val) when is_binary(Val) -> to_int(binary_to_list(Val));
to_int(Val) when is_list(Val) -> to_int(list_to_integer(Val));
to_int(Val) when is_float(Val) -> to_int(float_to_list(Val));
to_int(Val) -> Val.

%% 转换成装备位置
to_pos("武器") -> 1;
to_pos("衣服") -> 2;
to_pos("裤子") -> 6;
to_pos("护手") -> 5;
to_pos("护腕") -> 4;
to_pos("鞋子") -> 7;
to_pos("腰带") -> 3;
to_pos("时装") -> 10;
to_pos("坐骑") -> 14;
to_pos("翅膀") -> 15;
to_pos("戒指1") -> 11;
to_pos("戒指2") -> 12;
to_pos("护符1") -> 8;
to_pos("护符2") -> 9;
to_pos("武饰") -> 16;
to_pos("挂饰") -> 17;
to_pos("足迹") -> 18;
to_pos("聊天框") -> 19;
to_pos("文字") -> 20;
to_pos(_) -> 0.

%% 获取对立阵营值
to_other_realm(?role_realm_a) -> ?role_realm_b;
to_other_realm(?role_realm_b) -> ?role_realm_a;
to_other_realm(Realm) -> Realm.

%% -------------------
%% 变身命令内部处理
%% -------------------

do_all_enchant([], Eqm, _ConnPid, _Enchant) -> Eqm;
do_all_enchant([Item | T], Eqm, ConnPid, Enchant) ->
    NewItem = blacksmith:recalc_attr(Item#item{enchant = Enchant}),
    {ok, NewEqm, _NewItem} = storage_api:fresh_item(Item, NewItem, Eqm, ConnPid),
    do_all_enchant(T, NewEqm, ConnPid, Enchant).

%% 变身模式系数   {注灵等级, 强化等级, 宝石等级, 元神等级, 元神境界}
mode_to_info(1) -> {40, [{eqm, 3, 0}, {armor, 0, 0}, {jiezhi, 0, 0}, {dress, 0, 0}, {hufu, 0, 0}, {wing, 0, 0}]};
mode_to_info(2) -> {40, [{eqm, 4, 0}, {armor, 4, 0}, {jiezhi, 4, 0}, {dress, 0, 0}, {hufu, 4, 0}, {wing, 0, 0}]};
mode_to_info(3) -> {40, [{eqm, 7, 1}, {armor, 6, 0}, {jiezhi, 6, 1}, {dress, 7, 0}, {hufu, 6, 1}, {wing, 6, 0}]};
mode_to_info(4) -> {50, [{eqm, 4, 0}, {armor, 4, 0}, {jiezhi, 4, 0}, {dress, 0, 0}, {hufu, 4, 0}, {wing, 0, 0}]};
mode_to_info(5) -> {50, [{eqm, 6, 1}, {armor, 6, 1}, {jiezhi, 6, 1}, {dress, 6, 0}, {hufu, 6, 1}, {wing, 0, 0}]};
mode_to_info(6) -> {50, [{eqm, 8, 2}, {armor, 7, 2}, {jiezhi, 7, 2}, {dress, 7, 0}, {hufu, 7, 2}, {wing, 7, 0}]};
mode_to_info(7) -> {55, [{eqm, 9, 4}, {armor, 9, 4}, {jiezhi, 9, 4}, {dress, 9, 0}, {hufu, 9, 4}, {wing, 9, 0}]};
mode_to_info(8) -> {80, [{eqm, 9, 4}, {armor, 9, 4}, {jiezhi, 9, 4}, {dress, 9, 0}, {hufu, 9, 4}, {wing, 9, 0}]};
mode_to_info(9) -> {90, [{eqm, 9, 4}, {armor, 9, 4}, {jiezhi, 9, 4}, {dress, 9, 0}, {hufu, 9, 4}, {wing, 9, 0}]}.


type_to_atom(?item_jie_zhi) -> {jiezhi, 0};
type_to_atom(?item_shi_zhuang) -> {dress, 0};
type_to_atom(?item_hu_fu) -> {hufu, 0};
type_to_atom(?item_wing) -> {wing, 0}.

puton_all_item(Items) ->
    puton_all_item(Items, []).
puton_all_item([], Eqm)-> Eqm;
puton_all_item([Item | T], Eqm) ->
    NewEqm = case eqm:find_eqm(Eqm, Item) of
        {Eqm_pos} -> [Item#item{id = Eqm_pos, pos = Eqm_pos} | Eqm];
        _ -> Eqm
    end,
    puton_all_item(T, NewEqm).

make_all(ModeNum, ItemList, Info) ->
    make_all(ModeNum, ItemList, Info, []).
make_all(_ModeNum, [], _Info, NewItems) -> NewItems;
make_all(ModeNum, [Id | T], Info = {Upgrade, InfoList}, NewItems) ->
    {ok, [Item = #item{type = Type}]} = item:make(Id, 1, 1),
    {Atom, U} = case lists:member(Type, ?eqm) of
        true -> {eqm, Upgrade};
        false ->
            case lists:member(Type, ?armor) of
                true -> {armor, 0};
                false -> type_to_atom(Type)
            end
    end,
    {Atom, Enchant, StoneLev} = lists:keyfind(Atom, 1, InfoList), 
    Item1 = Item#item{enchant = Enchant, upgrade = U},
    Item2 = add_stone(Item1, StoneLev),
    Item3 = add_polish(ModeNum, Item2),
    NewItem = blacksmith:recalc_attr(Item3),
    make_all(ModeNum, T, Info, [NewItem | NewItems]).

add_stone(Item, StoneLev) when StoneLev =:= 0 -> Item;
add_stone(Item = #item{attr = Attr, type = Type}, StoneLev) when StoneLev > 0 ->
    NewAttr = case Type of
        ?item_hu_fu ->
            do_add_hufu(Attr, StoneLev);
        _ -> 
            case lists:member(Type, ?adm_armor) of
                true -> 
                    do_add_denfence(Attr, StoneLev);
                false -> case lists:member(Type, ?adm_ack) of
                        true -> do_add_ackstone(Attr, StoneLev);
                        false -> Attr
                    end
            end
    end,
    Item#item{attr = NewAttr}.

check_polish(Mode, weapon) ->
    case Mode of
        1 -> {[?attr_dmg, ?attr_critrate, ?attr_hitrate], 3};
        2 -> {[?attr_dmg, ?attr_critrate, ?attr_hitrate], 3};
        3 -> {[?attr_dmg, ?attr_critrate, ?attr_hitrate, ?attr_js], 5};
        4 -> {[?attr_dmg, ?attr_critrate, ?attr_hitrate], 3};
        5 -> {[?attr_dmg, ?attr_critrate, ?attr_hitrate], 3};
        6 -> {[?attr_dmg, ?attr_critrate, ?attr_hitrate, ?attr_js], 5};
        7 -> {[?attr_dmg, ?attr_critrate, ?attr_hitrate, ?attr_js, ?attr_dmg_magic], 6};
        8 -> {[?attr_dmg, ?attr_critrate, ?attr_hitrate, ?attr_js, ?attr_dmg_magic], 6};
        9 -> {[?attr_dmg, ?attr_critrate, ?attr_hitrate, ?attr_js, ?attr_dmg_magic], 6}
    end;
check_polish(Mode, armor) ->
    case Mode of
        1 -> {[?attr_hp_max, ?attr_defence], 3};
        2 -> {[?attr_hp_max, ?attr_defence], 3};
        3 -> {[?attr_hp_max, ?attr_defence], 5};
        4 -> {[?attr_hp_max, ?attr_defence], 3};
        5 -> {[?attr_hp_max, ?attr_defence], 5};
        6 -> {[?attr_hp_max, ?attr_defence, ?attr_evasion], 5};
        7 -> {[?attr_hp_max, ?attr_hp_max, ?attr_defence, ?attr_evasion], 6};
        8 -> {[?attr_hp_max, ?attr_hp_max, ?attr_defence, ?attr_evasion], 6};
        9 -> {[?attr_hp_max, ?attr_hp_max, ?attr_defence, ?attr_evasion], 6}

    end;
check_polish(Mode, dress) ->
    case Mode of
        1 -> {[], 0};
        2 -> {[], 0};
        3 -> {[?attr_dmg, ?attr_tenacity, ?attr_js, ?attr_anti_stun, ?attr_anti_taunt], 5};
        4 -> {[], 0};
        5 -> {[?attr_dmg, ?attr_tenacity, ?attr_js, ?attr_anti_stun, ?attr_anti_taunt], 3};
        6 -> {[?attr_dmg, ?attr_tenacity, ?attr_js, ?attr_anti_stun, ?attr_anti_taunt], 5};
        7 -> {[?attr_dmg, ?attr_tenacity, ?attr_js, ?attr_anti_stun, ?attr_anti_taunt], 6};
        8 -> {[?attr_dmg, ?attr_tenacity, ?attr_js, ?attr_anti_stun, ?attr_anti_taunt], 6};
        9 -> {[?attr_dmg, ?attr_tenacity, ?attr_js, ?attr_anti_stun, ?attr_anti_taunt], 6}
    end;
check_polish(Mode, jiezhi) ->
    case Mode of
        1 -> {[], 0};
        2 -> {[?attr_dmg], 3};
        3 -> {[?attr_dmg, ?attr_critrate, ?attr_hitrate], 3};
        4 -> {[?attr_dmg, ?attr_critrate, ?attr_hitrate], 3};
        5 -> {[?attr_dmg, ?attr_critrate, ?attr_hitrate], 5};
        6 -> {[?attr_dmg, ?attr_critrate, ?attr_hitrate], 5};
        7 -> {[?attr_dmg, ?attr_critrate, ?attr_hitrate, ?attr_js, ?attr_dmg_magic], 6};
        8 -> {[?attr_dmg, ?attr_critrate, ?attr_hitrate, ?attr_js, ?attr_dmg_magic], 6};
        9 -> {[?attr_dmg, ?attr_critrate, ?attr_hitrate, ?attr_js, ?attr_dmg_magic], 6}
    end;
check_polish(Mode, wing) ->
    case Mode of
        1 -> {[], 0};
        2 -> {[], 0};
        3 -> {[?attr_hp_max, ?attr_hp_max, ?attr_tenacity, ?attr_dmg], 5};
        4 -> {[], 0};
        5 -> {[], 0};
        6 -> {[?attr_hp_max, ?attr_hp_max, ?attr_tenacity, ?attr_dmg], 5};
        7 -> {[?attr_hp_max, ?attr_hp_max, ?attr_tenacity, ?attr_dmg], 6};
        8 -> {[?attr_hp_max, ?attr_hp_max, ?attr_tenacity, ?attr_dmg], 6};
        9 -> {[?attr_hp_max, ?attr_hp_max, ?attr_tenacity, ?attr_dmg], 6}
    end;
check_polish(Mode, hufu) ->
    case Mode of
        1 -> {[], 0};
        2 -> {[?attr_rst_metal, ?attr_rst_wood], 3};
        3 -> {[?attr_rst_metal, ?attr_rst_wood, ?attr_rst_earth], 3};
        4 -> {[?attr_rst_metal, ?attr_rst_wood], 3};
        5 -> {[?attr_rst_metal, ?attr_rst_wood], 5};
        6 -> {[?attr_rst_metal, ?attr_rst_wood, ?attr_rst_earth], 5};
        7 -> {[?attr_rst_metal, ?attr_rst_wood, ?attr_rst_earth, ?attr_rst_water, ?attr_rst_fire], 6};
        8 -> {[?attr_rst_metal, ?attr_rst_wood, ?attr_rst_earth, ?attr_rst_water, ?attr_rst_fire], 6};
        9 -> {[?attr_rst_metal, ?attr_rst_wood, ?attr_rst_earth, ?attr_rst_water, ?attr_rst_fire], 6}
    end.

do_add_polish(Attr, BaseId, Lev, Star) ->
    {_Num, L} = polish_data:get(BaseId),
    StarAttr = [{Name, Flag, Value} || {Name, Flag, Value} <- Attr, Flag >= 100010 andalso Flag =< 1010051, Name =/= ?attr_skill_lev],
    NormalAttr = Attr -- StarAttr,
    NameList = [Name || {Name, _, _} <- StarAttr],
    GetAttr = do_get_polish_attr(L, NameList),
    NewStarAttr = data_to_polish(GetAttr, Star, Lev),
    NormalAttr ++ NewStarAttr.

add_polish(Mode, Item = #item{base_id = BaseId, attr = BaseAttr, type = Type, require_lev = Lev}) ->
    {_Num, L} = polish_data:get(BaseId),
    {NameList, Star} = case Type of
        ?item_jie_zhi -> check_polish(Mode, jiezhi);
        ?item_hu_fu -> check_polish(Mode, hufu);
        ?item_shi_zhuang -> check_polish(Mode, dress);
        ?item_wing -> check_polish(Mode, wing);
        _ ->
            case lists:member(Type, ?eqm) of
                true -> check_polish(Mode, weapon);
                false -> case lists:member(Type, ?armor) of
                        true -> check_polish(Mode, armor);
                        false -> {[], 0}
                    end
            end
    end,
    GetAttr = do_get_polish_attr(L, NameList), 
    Attr = data_to_polish(GetAttr, Star, Lev),
    NewAttr = BaseAttr ++ Attr,
    Item#item{attr = NewAttr}.

data_to_polish(GetAttr, Star, Lev) ->
    data_to_polish(GetAttr, Star, Lev, [], [1, 2, 3, 4, 5]).
data_to_polish([], _Star, _Lev, Attr, _) -> Attr;
data_to_polish([{Name, _Type, List, _Rate} | T], Star, Lev, Attr, [Num | T1]) ->
    case Name =:= ?attr_skill_lev of
        false ->
            [Min | [Max]] = List,
            Value = case (Max - Min) >= 10 of       %% 
                false -> Min + Star - 1;
                true -> blacksmith:get_polish_value(Name, Star, Max) 
            end,
            data_to_polish(T, Star, Lev, [{Name, (Star * 1000 + Lev) * 100 + Num * 10, Value} | Attr], T1);
        true ->
            Value = util:rand_list(List),
            data_to_polish(T, Star, Lev, [{Name, (Star * 1000 + Lev) * 100 + Num * 10, Value} | Attr], T1)
    end.

do_get_polish_attr(L, NameList) ->
    do_get_polish_attr(L, NameList, []).
do_get_polish_attr(_L, [], Get) -> Get;
do_get_polish_attr(L, [Name | T], Get) ->
    G = lists:keyfind(Name, 1, L),
    do_get_polish_attr(L, T, [G | Get]).

do_add_ackstone(Attr, StoneLev) ->
    BaseId1 = 26002 + 20 * (StoneLev - 1), 
    BaseId2 = 26004 + 20 * (StoneLev - 1), 
    BaseId3 = 26005 + 20 * (StoneLev - 1), 
    A = lists:keyreplace(5, 1, Attr, {5, 101, BaseId1}),
    B = lists:keyreplace(6, 1, A, {6, 101, BaseId2}),
    C = lists:keyreplace(7, 1, B, {7, 101, BaseId3}),
    C.
do_add_denfence(Attr, StoneLev) ->
    BaseId1 = 26000 + 20 * (StoneLev - 1), 
    BaseId2 = 26003 + 20 * (StoneLev - 1), 
    BaseId3 = 26006 + 20 * (StoneLev - 1), 
    A = lists:keyreplace(5, 1, Attr, {5, 101, BaseId1}),
    B = lists:keyreplace(6, 1, A, {6, 101, BaseId2}),
    C = lists:keyreplace(7, 1, B, {7, 101, BaseId3}),
    C.
do_add_hufu(Attr, StoneLev) ->
    BaseId1 = 26007 + 20 * (StoneLev - 1), 
    BaseId2 = 26008 + 20 * (StoneLev - 1), 
    BaseId3 = 26005 + 20 * (StoneLev - 1), 
    A = lists:keyreplace(5, 1, Attr, {5, 101, BaseId1}),
    B = lists:keyreplace(6, 1, A, {6, 101, BaseId2}),
    C = lists:keyreplace(7, 1, B, {7, 101, BaseId3}),
    C.

test_guss(N) ->
    do_test_guss(N).

do_test_guss(0) ->
    ?DEBUG("************  测试完毕 .... 没问题的...");
do_test_guss(N) when N > 0 ->
    Val = gaussrand_mgr:get_value(5, 5),
    case Val =< 0 of
        true ->
            ?DEBUG("*********** 出错啦 值为  ~w", [Val]);
        false ->
            do_test_guss(N -1)
    end;
do_test_guss(_N) ->
    ?DEBUG(" 不合法的测试次数...").

do_dress_test(0, Role) -> {ok, Role};
do_dress_test(Cnt, Role) ->
    Id = util:rand(1, 8), %% 随机选一件时装操作
    Opr = util:rand(1,2), %% 操作类型 1-穿 2-脱
    Role2 =
    case Opr of
        1 ->
            case item_rpc:handle(10343, {[Id]}, Role) of
                {reply, {?false, _R}} ->
                    ?DEBUG(" 穿失败  原因 ~s", [_R]),
                    Role;
                {reply, {?true, _R}, Role1} ->
                    ?DEBUG("穿成功 "),
                    Role1
            end;
        2 ->
            case item_rpc:handle(10345, {Id}, Role) of
                {reply, {?false, _R}} ->
                    ?DEBUG("  卸时装失败  原因 ~s", [_R]),
                    Role;
                {reply, {?true, _R}, Role1} ->
                    ?DEBUG("卸时装成功 "),
                    Role1
            end
    end,
    do_dress_test(Cnt-1, Role2).

% -else.

% %% 非DEBUG模式时关闭
% handle(_Cmd, _Data, _Role) ->
%     {error, unknow_command}.
% -endif.


