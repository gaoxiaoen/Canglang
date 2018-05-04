%%----------------------------------------------------
%% 解析角色扩展数据，转换旧版本数据
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(role_ext_parse).
-export([
        do/2
    ]
).
-include("common.hrl").
-include("role_ext.hrl").
-include("version.hrl").
-include("boss.hrl").
-include("guild_practise.hrl").
-include("storage.hrl").
-include("item.hrl").
-include("arena_career.hrl").
-include("escort.hrl").
-include("task.hrl").
-include("hall.hrl").
-include("campaign.hrl").
-include("lottery_tree.hrl").
-include("wing.hrl").
-include("activity2.hrl").
-include("treasure.hrl").
-include("soul_mark.hrl").
-include("lottery_camp.hrl").
-include("lottery_secret.hrl").
-include("fate.hrl").
-include("soul_world.hrl").
-include("ascend.hrl").
-include("max_fc.hrl").
-include("train.hrl").
-include("misc.hrl").
-include("month_card.hrl").

%% @spec do(Ver, Data) ->
%% @doc 解析角色数据
%% <div>对于不同版本的数据需要在此处进行转换</div>

%% EX.
%% do(0 = Ver, {role_ext, Pos, Eqm, Bag, Store, Collect, Buff, Looks, Trigger}) ->
%%     Data = {role_ext, Pos, Eqm, Bag, Store, Collect, Buff, Looks, Trigger},
%%     do(Ver + 1, Data);

%% 隐藏一部分重复代码，但不方便调试
-define(PACK_CODE,     
						State,Pos,Storage,R_buff,Looks,Sns,Skill,Vip,Guild,Channels,Pet,Escort,Npc_store,Disciple,Offline_exp
						,Dungeon,Dungeon_map,Max_map_id,Expedition,Compete,Activity,Cooldown,Auto,Award,Setting               
						,Rank,Combat,Achievement,Lottery,Guild_practise,Suit_attr,Mounts,Arena_career,Escort_child,Cross_srv_id,Super_boss_store      
						,Task_role,Pet_magic,Hall,Practice,Campaign,Money_tree,Wing ,Activity2,Treasure ,Soul_mark,Lottery_camp,Touch_game,Demon       
						,Secret ,Fate ,Soul_world,Ascend,Max_fc,Pet_rb,Train,Campaign_daily_consume,Treasure_store,Pet_cards_collect,Ttem_gift_luck     
						,Anticrack,Manor_baoshi,Manor_moyao,Medal,Manor_trade,Manor_train,Energy,Tutorial,Manor_enchant,Story,Seven_day_award           
						,Scene_id,Npc_mail,Invitation

).

%% 检查最终的数据格式是否跟当前的版本号一致
do(Ver = 55, {role_ext, ?PACK_CODE}) ->
    Data = {role_ext, ?PACK_CODE, []},    %% 新加瓜瓜乐            
    do(Ver+1, Data);

do(Ver = 56, {role_ext, ?PACK_CODE, GuaGuaLe}) ->
    Data = {role_ext, ?PACK_CODE, GuaGuaLe, []},    %% 新加酒桶节信息            
    do(Ver+1, Data);

do(Ver = 57, {role_ext, ?PACK_CODE, GuaGuaLe, JiuTongJieInfo}) ->
    Data = {role_ext, ?PACK_CODE, GuaGuaLe, JiuTongJieInfo, #month_card{}},    %% 月卡
    do(Ver+1, Data);

do(Ver, Data) ->
    case Ver =:= ?ROLE_EXT_VER andalso is_record(Data, role_ext) of
        false -> {false, ?L(<<"角色扩展数据解析时发生异常">>)};
        true -> 
            case parse_field(Data, [sns, storage, skill, demon, offline_exp, award, medal, achievement, npc_store, mounts, setting, task_role, pet_magic, wing, campaign, buff, role_guild, vip, soul_world, ascend, role_train, anticrack]) of
                {false, Reason} -> {false, Reason};
                {ok, NewData} -> {ok, NewData}
            end
    end.

%% @spec parse_field([{Type::atom(), Data::tuple()}]) -> [NewData::tuple()]
%% @doc 先对role_ext的直接子项进行解释，只有全部正常解释才可以通过
parse_field(RoleExt, []) -> {ok, RoleExt}; 
parse_field(RoleExt, [Field | T]) ->
    case parse_field(RoleExt, Field) of
        {false, Reason} -> {false, Reason};
        {ok, NewRoleExt} ->
            parse_field(NewRoleExt, T)
    end;

%%----------------------------------------------------
%% 针对每一子项进行解析
%%----------------------------------------------------
%% 好友模块
parse_field(RoleExt = #role_ext{sns = Sns}, sns) ->
    case sns_parse:do(sns, Sns) of
        {false, Reason} -> 
            %% 加些日志什么的
            {false, Reason};
        {ok, NewSns} -> {ok, RoleExt#role_ext{sns = NewSns}}
    end;

%% 存储空间物品转换 
parse_field(RoleExt, storage) ->
    do_parse_field(RoleExt, eqm);

parse_field(_RoleExt, storage_2) -> 
    {false, ?L(<<"仓库扩展数据解析时发生异常:数据顶数量不对">>)};

%% 离线经验
parse_field(RoleExt = #role_ext{offline_exp = OfflineExp}, offline_exp) ->
    case offline_exp:ver_parse(OfflineExp) of
        {false, Reason} -> {false, Reason};
        {ok, NewOfflineExp} ->
            {ok, RoleExt#role_ext{offline_exp = NewOfflineExp}}
    end;

%% 奖励
parse_field(RoleExt = #role_ext{award = Award}, award) ->
    case award:ver_parse(Award) of
        {false, Reason} -> {false, Reason};
        {ok, NewAward} ->
            {ok, RoleExt#role_ext{award = NewAward}}
    end;

%% 角色设置
parse_field(RoleExt = #role_ext{setting = Setting}, setting) ->
    case setting:ver_parse(Setting) of
        {false, Reason} -> {false, Reason};
        {ok, NewSetting} ->
            {ok, RoleExt#role_ext{setting = NewSetting}}
    end;

%% 技能
parse_field(RoleExt = #role_ext{skill = Skill}, skill) ->
    {ok, RoleExt#role_ext{skill = skill:ver_parse(Skill)}};

%% 宠物
parse_field(_RoleExt = #role_ext{pet = _PetBag}, pet) ->
    % case pet_parse:do(PetBag) of
    %     {false, Reason} -> 
    %         {false, Reason};
    %     {ok, NewPetBag} ->
    %         {ok, RoleExt#role_ext{pet = NewPetBag}}
    % end;
    ?DEBUG("**NO NEED TO PARSE*",["!!"]);


%% 成就称号
parse_field(RoleExt = #role_ext{achievement = Ach}, achievement) ->
    case achievement_parse:do(Ach) of
        {false, Reason} -> {false, Reason};
        {ok, NewAch} -> {ok, RoleExt#role_ext{achievement = NewAch}}
    end;

%% 竞技勋章
parse_field(RoleExt = #role_ext{medal = Medal}, medal) ->
    {ok, RoleExt#role_ext{medal = medal:parse(Medal)}};

%% NPC商店
parse_field(RoleExt = #role_ext{npc_store = NpcStore}, npc_store) ->
    case npc_store_parse:do(NpcStore) of
        {false, Reason} -> {false, Reason};
        {ok, NewNpcStore} -> {ok, RoleExt#role_ext{npc_store = NewNpcStore}}
    end;

%% 坐骑列表
parse_field(RoleExt = #role_ext{storage = {Eqms, _Bag, _Store, _Collect, _TaskBag, _Casino, _Dress}, mounts = Mounts}, mounts) ->
    case mount_parse:do(Eqms, Mounts) of
        {false, Reason} -> {false, Reason};
        NewMounts -> {ok, RoleExt#role_ext{mounts = NewMounts}}
    end;

%% 盘龙仓库转换
parse_field(RoleExt = #role_ext{super_boss_store = Store}, super_boss_store) ->
    case item_parse:parse_super_boss_store(Store) of
        {false, Reason} -> {false, Reason};
        NewStore -> {ok, RoleExt#role_ext{super_boss_store = NewStore}}
    end;

%% 任务
parse_field(RoleExt = #role_ext{task_role = TaskRole}, task_role) ->
    case task_parse:do(task_role, TaskRole) of
        {false, Reason} -> {false, Reason};
        {ok, NewTaskRole} -> {ok, RoleExt#role_ext{task_role = NewTaskRole}}
    end;

%% 魔晶仓库转换
parse_field(RoleExt = #role_ext{pet_magic = PetMagic}, pet_magic) ->
    case item_parse:parse_pet_magic(PetMagic) of
        {false, Reason} -> {false, Reason};
        NewPetMagic -> {ok, RoleExt#role_ext{pet_magic = NewPetMagic}}
    end;

%% 翅膀数据
parse_field(RoleExt = #role_ext{wing = Wing}, wing) ->
    case wing_parse:do(Wing) of
        {false, Reason} -> {false, Reason};
        {ok, NewWing} -> {ok, RoleExt#role_ext{wing = NewWing}}
    end;

%% 活动数据
parse_field(RoleExt = #role_ext{campaign = Camp}, campaign) ->
    case campaign_parse:do(Camp) of
        {false, Reason} -> {false, Reason};
        {ok, NewCamp} -> {ok, RoleExt#role_ext{campaign = NewCamp}}
    end;

%% buff快捷回复
parse_field(RoleExt = #role_ext{r_buff = Rbuff}, buff) ->
    {ok, RoleExt#role_ext{r_buff = buff:ver_parse(Rbuff)}};

% 精灵守护
parse_field(RoleExt = #role_ext{demon = Demon}, demon) ->
    {ok, RoleExt#role_ext{demon = demon:ver_parse(Demon)}};

%% 个人帮会数据转换
parse_field(RoleExt = #role_ext{guild = RoleGuild}, role_guild) ->
    case guild_role_parse:do(RoleGuild) of
        {false, Reason} -> {false, Reason};
        {ok, NewRoleGuild} -> {ok, RoleExt#role_ext{guild = NewRoleGuild}}
    end;

%% 个人VIP数据转换
parse_field(RoleExt = #role_ext{vip = Vip}, vip) ->
    case vip_parse:do(Vip) of
        {false, Reason} -> {false, Reason};
        {ok, NewVip} -> {ok, RoleExt#role_ext{vip = NewVip}}
    end;

%% 灵戒洞天
parse_field(RoleExt = #role_ext{soul_world = SoulWorld}, soul_world) ->
    case soul_world:ver_parse(SoulWorld) of
        NewSoulWorld = #soul_world{} -> {ok, RoleExt#role_ext{soul_world = NewSoulWorld}};
        _ -> {false, ?L(<<"灵戒洞天数据转换失败">>)}
    end;

%% 职业进阶
parse_field(RoleExt = #role_ext{ascend = Ascend}, ascend) ->
    {ok, RoleExt#role_ext{ascend = ascend:ver_parse(Ascend)}};

%% 飞仙历练
parse_field(RoleExt = #role_ext{train = RoleTrain}, role_train) ->
    case train_parse:ver_parse(RoleTrain) of
        NewRoleTrain= #role_train{} -> {ok, RoleExt#role_ext{train = NewRoleTrain}};
        _ -> {false, ?L(<<"飞仙历练数据转换失败">>)}
    end;

%% 飞外挂
parse_field(RoleExt = #role_ext{anticrack = AntiCrack}, anticrack) ->
    case anticrack_parse:do(AntiCrack) of
        {false, Reason} -> {false, Reason};
        {ok, NewAntiCrack} -> {ok, RoleExt#role_ext{anticrack = NewAntiCrack}}
    end;

%% 容错
parse_field(_RoleExt, Field) ->
    {false, util:fbin(?L(<<"无法识别数据项:~w">>), [Field])}.

%% --------------
%% 存储空间数据转换, 这个数据转换需要在灵器哪里，坐骑那里该
%% -------------
%% 装备列表
do_parse_field(RoleExt = #role_ext{storage = {Eqm, Bag, Store, Collect, TaskBag, Casino, Dress}}, eqm) ->
    case item_parse:parse_eqm(Eqm) of
        {false, Reason} -> {false, Reason};
        NewEqm ->
            do_parse_field(RoleExt#role_ext{storage = {NewEqm, Bag, Store, Collect, TaskBag, Casino, Dress}}, bag)
    end;

%% 背包
do_parse_field(RoleExt = #role_ext{storage = {Eqm, Bag, Store, Collect, TaskBag, Casino, Dress}}, bag) ->
    case item_parse:parse_bag(Bag) of
        {false, Reason} -> {false, Reason};
        NewBag ->
            do_parse_field(RoleExt#role_ext{storage = {Eqm, NewBag, Store, Collect, TaskBag, Casino, Dress}}, store)
    end;

%% 仓库
do_parse_field(RoleExt = #role_ext{storage = {Eqm, Bag, Store, Collect, TaskBag, Casino, Dress}}, store) ->
    case item_parse:parse_store(Store) of
        {false, Reason} -> {false, Reason};
        NewStore ->
            do_parse_field(RoleExt#role_ext{storage = {Eqm, Bag, NewStore, Collect, TaskBag, Casino, Dress}}, collect)
    end;

%% 采集背包
do_parse_field(RoleExt = #role_ext{storage = {Eqm, Bag, Store, Collect, TaskBag, Casino, Dress}}, collect) ->
    case item_parse:parse_collect(Collect) of
        {false, Reason} -> {false, Reason};
        NewCollect ->
            do_parse_field(RoleExt#role_ext{storage = {Eqm, Bag, Store, NewCollect, TaskBag, Casino, Dress}}, taskbag)
    end;

%% 任务背包
do_parse_field(RoleExt = #role_ext{storage = {Eqm, Bag, Store, Collect, TaskBag, Casino, Dress}}, taskbag) ->
    case item_parse:parse_taskbag(TaskBag) of
        {false, Reason} -> {false, Reason};
        NewTaskBag ->
            do_parse_field(RoleExt#role_ext{storage = {Eqm, Bag, Store, Collect, NewTaskBag, Casino, Dress}}, casino)
    end;

%% 封印仓库
do_parse_field(RoleExt = #role_ext{storage = {Eqm, Bag, Store, Collect, TaskBag, Casino, Dress}}, casino) ->
    case item_parse:parse_casino(Casino) of
        {false, Reason} -> {false, Reason};
        NewCasino ->
            do_parse_field(RoleExt#role_ext{storage = {Eqm, Bag, Store, Collect, TaskBag, NewCasino, Dress}}, dress)
    end;

%% 衣柜
do_parse_field(RoleExt = #role_ext{storage = {Eqm, Bag, Store, Collect, TaskBag, Casino, Dress}}, dress) ->
    case item_parse:parse_dress(Dress) of
        {false, Reason} -> {false, Reason};
        NewDress ->
            {ok, RoleExt#role_ext{storage = {Eqm, Bag, Store, Collect, TaskBag, Casino, NewDress}}}
    end.
