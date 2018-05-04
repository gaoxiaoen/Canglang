%%---------------------------------------------------
%% 角色数据加载
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(role_data).
-export([
        load_role/2
        ,save_role/1
        ,fetch_role/2
        ,fetch_base/2
        ,fetch_ext/2
        ,fetch_name_used/2
        ,save_name_used/1
    ]
).
-include("common.hrl").
-include("role.hrl").
-include("role_ext.hrl").
-include("link.hrl").
-include("buff.hrl").
-include("eqm.hrl").
-include("storage.hrl").
-include("pos.hrl").
-include("assets.hrl").
-include("trigger.hrl").
-include("attr.hrl").
-include("item.hrl").
-include("vip.hrl").
-include("ratio.hrl").
-include("sns.hrl").
-include("guild.hrl").
-include("pet.hrl").
-include("escort.hrl").
-include("npc_store.hrl").
-include("activity.hrl").
-include("version.hrl").
-include("achievement.hrl").
-include("boss.hrl").
-include("guild_practise.hrl").
-include("arena_career.hrl").
-include("campaign.hrl").
-include("task.hrl").
-include("hall.hrl").
-include("wing.hrl").
-include("activity2.hrl").
-include("treasure.hrl").
-include("soul_mark.hrl").
-include("lottery_camp.hrl").
-include("lottery_secret.hrl").
-include("fate.hrl").
-include("soul_world.hrl").
-include("dungeon.hrl").
-include("max_fc.hrl").
-include("train.hrl").
-include("misc.hrl").
-include("manor.hrl").
-include("energy.hrl").
-include("tutorial.hrl").
-include("story.hrl").
-include("seven_day_award.hrl").
-include("invitation.hrl").
-include("month_card.hrl").
-include("expedition.hrl").

%% %% @spec get_lock(Rid, SrvId) -> bool()
%% %% Rid = integer()
%% %% SrvId = string()
%% %% @doc 获取角色数据锁，超过30秒的锁定会自动解锁
%% %% <div>用于阻止同一角色同时创建多个进程</div>
%% get_lock(Rid, SrvId) ->
%%     Sql = <<"update role set is_online = 1, login_time = ~s where id = ~s and srv_id = ~s and (is_online = 0 or login_time < ~s)">>,
%%     Now = util:unixtime(),
%%     case catch db:execute(Sql, [Now, Rid, SrvId, Now - 30]) of
%%         {ok, 1} -> true;
%%         _ -> false
%%     end.
%% 
%% %% @spec release_lock(Rid, SrvId) -> ok
%% %% Rid = integer()
%% %% SrvId = string()
%% %% @doc 释放角色数据锁
%% release_lock(Rid, SrvId) ->
%%     Sql = <<"update role set is_online = 0 where id = ~s and srv_id = ~s">>,
%%     db:execute(Sql, [Rid, SrvId]),
%%     ok.

%% @spec load_role(Rid, SrvId) -> {ok, Role} | {false, not_exists} | {false, load_failure}
%% Rid = integer()
%% SrvId = bitstring()
%% Role = #role{}
%% @doc 从MySQL加载指定角色数据，并初始化相关的进程字典数据
%% <div>注意:此函数只能在相应的角色进程内调用</div>
load_role(Rid, SrvId) ->
    %% 先判定是否在DETS中是否有数据未同步到数据库中
    case role_mgr:sync_to_db({Rid, SrvId}) of
        {false, _Why} -> {false, language:get(<<"加载数据异常(同步数据失败)">>)};
        _ ->
            case init_proc_dict(Rid, SrvId, [task_list, task_log, task_daily_log]) of
                ok ->
                    case fetch_role(by_id, {Rid, SrvId}) of
                        {false, Reason} -> {false, Reason};
                        {ok, Role} ->
                            gm_rpc:role_login_check(lock, Role#role{lottery_camp = #lottery_role{}})
                    end;
                _E ->
                    {false, load_failure}
            end
    end.

%% @spec save_role(Role) -> true | {false, Why}
%% @doc 保存角色数据到MySQL
%% <div>注意: 序列化的数据中不能包含有进程标识[pid()]</div>
%% <div>注意: 以下函数是对外接口，调用者不一定是角色进程，所以不能操作进程字典</div>
save_role(Role = #role{
        id = {Rid, SrvId}, name = Name, ride = Ride, event = Event, mod = Mod,
        vip = Vip, assets = Assets, pet = Pet,
        pos = Pos, eqm = Eqm, bag = Bag, buff = Rbuff, store = Store,
        collect = Collect, task_bag = TaskBag, sns = Sns, skill = Skill,
        guild = ExGuild, channels = Channels, escort = Escort, npc_store = NpcStore,
        disciple = Disciple, offline_exp = OffLineExp, dungeon = Dungeon, dungeon_map = DungeonMap, max_map_id = MaxMapId, expedition = Expedition, compete = Compete, activity = Activity,
        cooldown = CdList, auto = Auto, award = Award, setting = Setting, rank = Rank, combat = CombatParams,
        casino = Casino, achievement = Achievement, dress = Dress, lottery = Lottery,
        guild_practise = GuildPra, suit_attr = SuitAttr, mounts = Mounts, arena_career = ArenaCareer,
        escort_child = EscortChild, cross_srv_id = CrossSrvId, super_boss_store = SuperBossStore, task_role = TaskRole,
        pet_magic = PetMagic, hall = Hall, practice = Practice, campaign = Campaign, money_tree = MoneyTree,
        wing = Wing, activity2 = Activity2, treasure = Treasure, soul_mark = SoulMark, lottery_camp = LotteryCamp, 
        demon = RoleDemon, secret = Secret, fate = Fate, soul_world = SoulWorld,
        ascend = Ascend, max_fc = MaxFc, 
        pet_rb = Prb, train = Train,
        campaign_daily_consume = CampaignDailyConsume, pet_cards_collect = PCC, item_gift_luck = ItemLuckVal
        ,anticrack = Anticrask
        ,manor_baoshi = ManorBaoshi
        ,manor_moyao = ManorMoyao
        ,medal = Medal
        ,manor_trade = ManorTrade
        ,manor_train = ManorTrain
        ,energy = Energy
        ,tutorial = Tutorial
        ,manor_enchant = ManorEnchant
        ,story = Story
        ,seven_day_award = SevenDayAward
        ,scene_id = SceneId
        ,npc_mail = NpcMail
        ,invitation = Invitation
        ,guaguale = Guaguale
        ,beer_guide = BeerGuide
        ,month_card = MonthCard
    }
) ->
    %% 背包加锁物品 下线清锁处理
    Items =[Item#item{status = ?lock_release} || Item <- Bag#bag.items],
    NewBag = Bag#bag{items = Items},
    Guild = ExGuild#role_guild{pid = 0},
    CombatParams1 = combat:clear_observe(CombatParams),
    Fun = fun() ->
            save_base(Role#role{bag = NewBag}),
            save_assets(Rid, SrvId, Assets),
            save_ext(Rid, SrvId, #role_ext{
                    state = {Ride, Event, Mod}, pos = Pos#pos{map_pid = 0, town_map_pid = 0},
                    storage = {Eqm, NewBag, Store, Collect, TaskBag, Casino, Dress}, r_buff = Rbuff,
                    sns = Sns, skill = Skill, vip = Vip, guild = Guild, channels = Channels,
                    pet = Pet, escort = Escort, npc_store = NpcStore, disciple = Disciple,
                    offline_exp = OffLineExp, dungeon = Dungeon, dungeon_map = DungeonMap, max_map_id = MaxMapId, expedition = Expedition, compete = Compete, activity = Activity,
                    cooldown = CdList, auto = Auto, award = Award, setting = Setting, rank = Rank, 
                    combat = CombatParams1, achievement = Achievement, lottery = Lottery,
                    guild_practise = GuildPra, suit_attr = SuitAttr, mounts = Mounts,
                    arena_career = ArenaCareer, escort_child = EscortChild, cross_srv_id = CrossSrvId,
                    super_boss_store = SuperBossStore, task_role = TaskRole, pet_magic = PetMagic, hall = Hall#role_hall{pid = 0},
                    practice = Practice, campaign = Campaign, money_tree = MoneyTree,
                    wing = Wing, activity2 = Activity2, treasure = Treasure, soul_mark = SoulMark, lottery_camp = LotteryCamp,
                    demon = RoleDemon, secret = Secret, 
                    fate = Fate, soul_world = SoulWorld,
                    ascend = Ascend, max_fc = MaxFc, 
                    pet_rb = Prb, train = Train,
                    campaign_daily_consume = CampaignDailyConsume,
                    pet_cards_collect = PCC, item_gift_luck = ItemLuckVal, anticrack = Anticrask
                    ,manor_baoshi = ManorBaoshi
                    ,manor_moyao = ManorMoyao
                    ,medal = Medal
                    ,manor_trade = ManorTrade
                    ,manor_train = ManorTrain
                    ,energy = Energy
                    ,tutorial = Tutorial
                    ,manor_enchant = ManorEnchant
                    ,story = Story
                    ,seven_day_award = SevenDayAward
                    ,scene_id = SceneId
                    ,npc_mail = NpcMail
                    ,invitation = Invitation
                    ,guaguale = Guaguale
                    ,beer_guide = BeerGuide
                    ,month_card = MonthCard
                })
    end,
    case db:tx(Fun) of
        {ok, true} -> true;
        {ok, _X} ->
            ?DEBUG("角色[ID:~w]保存数据事务返回ok值:~w", [{Rid, SrvId}, _X]),
            true;
        {error, Err} ->
            ?ERR("保存角色数据[Rid:~w SrvId:~s Name:~s]时发生异常: ~w", [Rid, SrvId, Name, Err]),
            {false, save_failure}
    end.

%% @spec fetch_role(Type, Id) -> {ok, Role} | {false, not_exists} | {false, fetch_failure}
%% Type = by_id | by_name
%% Id = {integer(), bitstring()} | bitstring()
%% Role = #role{}
%% Data = tuple()
%% @doc 从MySQL中查询指定角色的完整数据
%% <div>注意: 以下函数是对外接口，调用者不一定是角色进程，所以不能操作进程字典</div>
fetch_role(Type, Id) ->
    case fetch_base(Type, Id) of
        {false, not_exists} -> {false, not_exists};
        {false, Why} -> {false, Why};
        {ok, Role = #role{id = {Rid, SrvId}, career = Career, sex = Sex, name = Name}} ->
            put(fetch_role_info, {{Rid, SrvId}, Name}),
            case fetch_assets(Rid, SrvId) of
                {false, not_exists} -> %% 该角色从未登录，角色数据需初始化
                    %%{X, Y} = util:rand_list([{1560, 780}]),
                    {ok, Role#role{
                            ratio = #ratio{}
                            ,assets = #assets{}

                            ,trigger = #trigger{}
                            ,eqm = eqm:newhand_equip(Career)
                            ,looks = []
                            ,bag = #bag{free_pos = ?FREEPOS(1, ?bag_def_volume)}
                            ,store = #store{free_pos = ?FREEPOS(1, 42)}
                            ,collect = #collect{}
                            ,task_bag = #task_bag{}
                            ,casino = #casino{}
                            ,super_boss_store = #super_boss_store{}
                            ,buff = buff:init() 
                            ,guild = #role_guild{}
                    %%        ,pos = #pos{x = X, y = Y}
                            ,pos = #pos{map = ?tutorial_map, map_base_id = ?tutorial_map, x = 370, y = 530, dest_x = 370, dest_y = 530}
                            ,skill = skill:init(Career)
                            ,sns = sns:init(Rid, SrvId)
                            ,vip = vip:init(Career, Sex)
                            ,channels = channel:init()
                            ,pet = #pet_bag{}
                            ,escort = #escort{}
                            ,npc_store = #npc_store{}
                            ,offline_exp = offline_exp:init()
                            ,activity = #activity{}
                            ,task = []
                            ,cooldown = []
                            ,auto = hook:init()
                            ,award = []
                            ,setting = setting:init()
                            ,achievement = #role_achievement{}
                            ,guild_practise = #guild_practise{}
                            ,suit_attr = {0, 0, 0, 0}
                            ,mounts = #mounts{}
                            ,arena_career = #arena_career{}
                            ,escort_child = #escort_child{}
                            ,campaign = #campaign_role{}
                            ,task_role = #task_role{}
                            ,pet_magic = #pet_magic{}
                            ,hall = #role_hall{}
                            ,practice = []
                            ,wing = #wing{}
                            ,activity2 = #activity2{}
                            ,treasure = #treasure{}
                            ,soul_mark = #soul_mark{}
                            ,lottery_camp = #lottery_role{}
                            ,demon = demon:init()
							,secret = #secret{}
                            ,fate = #fate{}
                            ,soul_world = #soul_world{}
                            ,ascend = ascend:init()
                            ,max_fc = #max_fc{}
                            ,pet_rb = []
                            ,train = #role_train{}
                            ,campaign_daily_consume = #campaign_daily_consume{}
                            ,pet_cards_collect = []
                            ,item_gift_luck = []
                            ,anticrack = #anticrack{}
                            ,manor_baoshi = #manor_baoshi{}
                            ,manor_moyao = #manor_moyao{}
                            % ,medal = #medal{}
                            ,manor_trade = #manor_trade{}   %% 暂时先在这初始化
                            ,manor_train = #manor_train{}
                            ,energy = #energy{}
                            ,tutorial = #tutorial{}
                            ,manor_enchant = #manor_enchant{}
                            ,story = #story{}
                            ,seven_day_award = #seven_day_award{}
                            ,scene_id = 1400
                            ,npc_mail = npc_mail_data:get()
                            ,invitation = #invitation{}
                            ,guaguale = []
                            ,beer_guide = []
                            ,month_card = #month_card{}
                            ,expedition = #expedition{}
                        }
                    };
                {false, Why} ->
                    {false, Why}; %% 其它情况，也有可能是数据库访问不了
                {ok, Assets} ->
                    case fetch_ext(Rid, SrvId) of
                        {false, Why} -> {false, Why};
                        {ok, #role_ext{
                                state = {Ride, Event, Mod},
                                pos = Pos, storage = {Eqm, Bag, Store, Collect, TaskBag, Casino, Dress},
                                r_buff = Rbuff, sns = Sns, skill = Skill,
                                vip = Vip, guild = Guild, channels = Channels, pet = PetBag, 
                                escort = Escort, npc_store = NpcStore, disciple = Disciple,
                                offline_exp = OffLineExp, dungeon = Dungeon, dungeon_map = DungeonMap, max_map_id = MaxMapId, expedition = Expedition, compete = Compete, activity = Activity,
                                cooldown = CdList, auto = Auto, setting = Setting, award = Award,
                                rank = Rank, combat = CombatParams, achievement = Achievement, lottery = Lottery,
                                guild_practise = GuildPra,
                                suit_attr = SuitAttr, mounts = Mounts, arena_career = ArenaCareer,
                                escort_child = EscortChild, cross_srv_id = CrossSrvId,
                                super_boss_store = SuperBossStore, task_role = TaskRole, pet_magic = PetMagic,
                                hall = Hall, practice = Practice, campaign = Campaign, money_tree = MoneyTree,
                                wing = Wing, activity2 = Activity2, treasure = Treasure, soul_mark= SoulMark, lottery_camp = LotteryCamp,
                                demon = RoleDemon, secret = Secret, 
                                fate = Fate, soul_world = SoulWorld,
                                ascend = Ascend, max_fc = MaxFc, 
                                pet_rb = Prb, train = Train,
                                campaign_daily_consume = CampaignDailyConsume,
                                pet_cards_collect = PCC, item_gift_luck = ItemLuckVal, anticrack = Anticrask
                                ,manor_baoshi = ManorBaoshi
                                ,manor_moyao = ManorMoyao
                                ,medal = Medal
                                ,manor_trade = ManorTrade
                                ,manor_train = ManorTrain
                                ,energy = Energy
                                ,tutorial = Tutorial
                                ,manor_enchant = ManorEnchant
                                ,story = Story
                                ,seven_day_award = SevenDayAward
                                ,scene_id = SceneId
                                ,npc_mail = NpcMail
                                ,invitation = Invitation
                                ,guaguale = Guaguale
                                ,beer_guide = BeerGuide
                                ,month_card = MonthCard
                            }
                        } ->
                            NameUsed = case fetch_name_used(Rid, SrvId) of
                                {ok, OldName} -> OldName;
                                _ -> <<>>
                            end,
                            {ok, Role#role{
                                    ride = Ride, event = Event, mod = Mod
                                    ,ratio = #ratio{}, assets = Assets, trigger = #trigger{}
                                    ,eqm = Eqm, bag = Bag, store = Store, collect = Collect, task_bag = TaskBag
                                    ,casino = Casino, dress = Dress, buff = Rbuff, guild = Guild
                                    ,pos = Pos, skill = Skill, sns = Sns, vip = Vip, channels = Channels
                                    ,pet = PetBag, escort = Escort, npc_store = NpcStore
                                    ,disciple = Disciple, offline_exp = OffLineExp, dungeon = Dungeon, dungeon_map = DungeonMap, max_map_id = MaxMapId, expedition = Expedition, compete = Compete
                                    ,activity = Activity, cooldown = CdList, auto = Auto
                                    ,award = Award, setting = Setting, rank = Rank, combat = CombatParams
                                    ,achievement = Achievement, lottery = Lottery
                                    ,guild_practise = GuildPra
                                    ,suit_attr = SuitAttr, mounts = Mounts, arena_career = ArenaCareer
                                    ,escort_child = EscortChild, cross_srv_id = CrossSrvId
                                    ,super_boss_store = SuperBossStore, task_role = TaskRole, pet_magic = PetMagic
                                    ,campaign = Campaign
                                    ,hall = Hall, practice = Practice, money_tree = MoneyTree
                                    ,wing = Wing, activity2 = Activity2, treasure = Treasure, soul_mark = SoulMark
                                    ,lottery_camp = LotteryCamp, demon = RoleDemon, secret = Secret
                                    ,fate = Fate, soul_world = SoulWorld
                                    ,ascend = Ascend
                                    ,max_fc = MaxFc
                                    ,pet_rb = Prb, train = Train
                                    ,campaign_daily_consume = CampaignDailyConsume
                                    ,name_used = NameUsed, pet_cards_collect = PCC, item_gift_luck = ItemLuckVal
                                    ,anticrack = Anticrask
                                    ,manor_baoshi = ManorBaoshi
                                    ,manor_moyao = ManorMoyao
                                    ,medal = Medal
                                    ,manor_trade = ManorTrade
                                    ,manor_train = ManorTrain
                                    ,energy = Energy
                                    ,tutorial = Tutorial
                                    ,manor_enchant = ManorEnchant
                                    ,story = Story
                                    ,seven_day_award = SevenDayAward
                                    ,scene_id = SceneId
                                    ,npc_mail = NpcMail
                                    ,invitation = Invitation
                                    ,guaguale = Guaguale
                                    ,beer_guide = BeerGuide
                                    ,month_card = MonthCard
                                }
                            }
                    end
            end
    end.

%% @spec fetch_base(Type, Id) -> {ok, #rbase{}} | {false, term()}
%% Type = by_id | by_name
%% Id = {Rid, SrvId} | bitstring()
%% @doc 根据角色名称或角色ID从MySQL查找角色基础数据
%% <div>注意: 当有多个同名角色存在时会导致加载失败</div>
fetch_base(by_id, {Rid, SrvId}) ->
    Sql = "select id, srv_id, platform, status, account, name, lock_info, sex, career, realm, lev, soul_lev, hp, mp, label, day_activity, reg_time, login_time, logout_time, reg_code, device_id from role where id = ~s and srv_id = ~s",
    do_fetch_base(Sql, [Rid, SrvId]);
fetch_base(by_name, Name) when is_binary(Name) orelse is_bitstring(Name) ->
    Sql = "select id, srv_id, platform, status, account, name, lock_info, sex, career, realm, lev, soul_lev, hp, mp, label, day_activity, reg_time, login_time, logout_time, reg_code, device_id from role where name = ~s",
    do_fetch_base(Sql, [Name]).

%% 执行查找
do_fetch_base(Sql, Args) ->
    case db:get_row(Sql, Args) of
        {error, undefined} -> {false, not_exists};
        {error, Why} ->
            ?ERR("fetch_base时发生异常: ~s", [Why]),
            {false, fetch_failure};
        {ok, [Id, SrvId, Platform, Status, Acc, Name, LockInfo, Sex, Career, Realm, Lev, SoulLev, Hp, Mp, Label, DayAct, RegTime, LastLoginTime, LastLogoutTime, InvitationCode, DeviceId]} ->
            {ok, #role{id = {Id, SrvId}, status = Status, account = Acc, platform = Platform, name = Name, lock_info = LockInfo, label = Label, sex = Sex, career = Career, realm = Realm, lev = Lev, soul_lev = SoulLev, hp = Hp, mp = Mp, day_activity = DayAct, login_info = #login_info{reg_time = RegTime, last_login = LastLoginTime, last_logout = LastLogoutTime, reg_code = InvitationCode, device_id = DeviceId}}}
    end.

%% 保存角色基础数据到MySQL
save_base(#role{id = {Id, SrvId}, account = Account, name = Name, lock_info = LockInfo, login_info = #login_info{login_time = LoginTime, logout_time = LogoutTime}, status = Status, sex = Sex, career = Career, realm = Realm, lev = Lev, soul_lev = SoulLev, hp = Hp, mp = Mp, label = Label, day_activity = DayAct, link = #link{ip = LoginIp}}) ->
    Sql = "update role set status=~s, account=~s, name=~s, lock_info=~s, sex=~s, career=~s, realm=~s, lev=~s, soul_lev =~s, hp=~s, mp=~s, label=~s, day_activity=~s, login_time=~s, logout_time = ~s, login_ip=~s where id=~s and srv_id=~s",
    case db:execute(Sql, [Status, Account, Name, LockInfo, Sex, Career, Realm, Lev, SoulLev, Hp, Mp, Label, DayAct, LoginTime, LogoutTime, log_conv:ip2bitstring(LoginIp), Id, SrvId]) of
        {error, Err} ->
            ?ERR("save_base时发生异常: ~s", [Err]),
            {false, save_failure};
        {ok, _Affected} -> true
    end.

%% @spec fetch_assets(Rid, SrvId) -> {ok, #assets{}} | {false, term()}
%% Rid = integer()
%% SrvId = string()
%% @doc 从数据库加载收益类数据
fetch_assets(Rid, SrvId) ->
    Sql = "select rid, srv_id, exp, gold, coin, honor, energy, gold_bind, coin_bind, spt, attainment, badge, hearsay, charm, flower, gold_integral, arena, acc_arena, charge, career_devote, both_time, guild_war, guild_war_acc, guard_acc, lilian, wc_lev, practice_acc, practice, seal_exp, soul, soul_acc, scale, cooperation, stone from role_assets where rid = ~s and srv_id = ~s",
    case db:get_row(Sql, [Rid, SrvId]) of
        {error, undefined} -> {false, not_exists};
        {error, Err} ->
            ?ERR("fetch_assets时发生异常: ~s", [Err]),
            {false, fetch_failure};
        {ok, [_Rid, _SrvId, Exp, Gold, Coin, Honor, Energy, GoldBind, CoinBind, Psychic, Attainment, Badge, Hearsay, Charm, Flower, GoldIntegral, Arena, AccArena, Charge, CareerDevote, BothTime, GuildWar, GuildWarAcc, GuardAcc, LiLian, WcLev, PracAcc, Prac, SealExp, Soul, SoulAcc, Scale, Cooperation, Stone]} ->
            {ok, #assets{exp = Exp, gold = Gold, gold_bind = GoldBind, coin = Coin, coin_bind = CoinBind, psychic = Psychic, honor = Honor, energy = Energy, attainment = Attainment, hearsay = Hearsay, charm = Charm, flower = Flower, gold_integral = GoldIntegral, arena = Arena, acc_arena = AccArena, charge = Charge, career_devote = CareerDevote, both_time = BothTime, guild_war = GuildWar, guild_war_acc = GuildWarAcc, guard_acc = GuardAcc, badge = Badge, lilian = LiLian, wc_lev = WcLev, practice_acc = PracAcc, practice = Prac, seal_exp = SealExp, soul = Soul, soul_acc = SoulAcc, scale = Scale, cooperation = Cooperation, stone = Stone}}
    end.

%% @doc 保存角色资产类数据到MySQL
save_assets(Rid, SrvId, #assets{exp = Exp, gold = Gold, gold_bind = GoldBind, coin = Coin,
        coin_bind = CoinBind, psychic = Psychic, honor = Honor, energy = Energy, attainment = Attainment,
        hearsay = Hearsay, charm = Charm, flower = Flower, gold_integral = GoldIntegral, arena = Arena,
        acc_arena = AccArena, charge = Charge, career_devote = CareerDevote, both_time = BothTime,
        guild_war = GuildWar, guild_war_acc = GuildWarAcc, guard_acc = GuardAcc, badge = Badge,
        lilian = LiLian, wc_lev = WcLev, practice_acc = PracAcc, practice = Prac, seal_exp = SealExp,
        soul = Soul, soul_acc = SoulAcc, scale = Scale, cooperation = Cooperation, stone = Stone}) ->
    Sql = "replace into role_assets(rid, srv_id, exp, gold, coin, honor, energy, gold_bind, coin_bind, spt, attainment, badge, hearsay, charm, flower, gold_integral, arena, acc_arena, charge, career_devote, both_time, guild_war, guild_war_acc, guard_acc, lilian, wc_lev, practice_acc, practice, seal_exp, soul, soul_acc, scale, cooperation, stone) values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
    case db:execute(Sql, [Rid, SrvId, Exp, Gold, Coin, Honor, Energy, GoldBind, CoinBind, Psychic, Attainment, Badge, Hearsay, Charm, Flower, GoldIntegral, Arena, AccArena, Charge, CareerDevote, BothTime, GuildWar, GuildWarAcc, GuardAcc, LiLian, WcLev, PracAcc, Prac, SealExp, Soul, SoulAcc, Scale, Cooperation, Stone]) of
        {error, Why} ->
            ?ERR("save_assets时发生异常: ~s", [Why]),
            {false, fetch_failure};
        {ok, _} -> true
    end.

%% @doc 从MySQL加载角色数据
fetch_ext(Rid, SrvId) ->
    Sql = "select * from role_ext where rid = ~s and srv_id = ~s",
    case db:get_row(Sql, [Rid, SrvId]) of
        {error, undefined} -> {false, not_exists};
        {error, Why} ->
            ?ERR("fetch_ext时发生异常: ~s", [Why]),
            {false, fetch_failure};
        {ok, [_, _, Ver, Data]} ->
            case util:bitstring_to_term(Data) of
                {error, Why}  ->
                    ?ERR("[~w:~s]的扩展数据无法正确转换成term(): ~p", [Rid, SrvId, Why]),
                    {false, fetch_failure};
                {ok, Term} ->
                    role_ext_parse:do(Ver, Term)
            end;
        {ok, _Else} ->
            ?ERR("[~w:~s]的角色扩展数据无法识别", [Rid, SrvId]),
            {false, fetch_failure}
    end.

%% @doc 保存角色数据到MySQL
save_ext(Rid, SrvId, Data) ->
    Sql = "replace into role_ext values(~s, ~s, ~s, ~s)",
    case db:execute(Sql, [Rid, SrvId, ?ROLE_EXT_VER, util:term_to_bitstring(Data)]) of
        {error, Why} ->
            ?ERR("save_ext时发生异常: ~s", [Why]),
            {false, save_failure};
        {ok, _X} -> true
    end.

%% @doc 从ets加载角色曾用名
fetch_name_used(Rid, SrvId) ->
    case ets:lookup(ets_role_name_used, {Rid, SrvId}) of
        [#role_name_used{name = Name}] -> {ok, Name};
        _ -> {false, fetch_failure}
    end.

%% @doc 保存角色曾用名到MySQL
save_name_used(#role{id = {Rid, SrvId}, name = NewName, name_used = Name, sex = Sex, career = Career, realm = Realm, vip = #vip{type = Vip}}) ->
    Now = util:unixtime(),
    Sql = "insert into role_name_used(rid, srv_id, name, new_name, sex, career, realm, vip, ctime) values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
    case db:execute(Sql, [Rid, SrvId, Name, NewName, Sex, Career, Realm, Vip, Now]) of
        {error, Why} ->
            ?ERR("save_name_used时发生异常: ~s", [Why]),
            {false, save_failure};
        {ok, _X} -> 
            Cache = #role_name_used{
                id = {Rid, SrvId},
                new_name = NewName,
                name = Name,
                sex = Sex,
                career = Career,
                realm = Realm,
                vip = Vip,
                ctime = Now
            },
            ets:insert(ets_role_name_used, Cache),
            true
    end.

%% 初始化进程字典 ok | {false, Reason}
init_proc_dict(_Rid, _SrvId, []) -> ok;
init_proc_dict(Rid, SrvId, [task_list | T]) ->
    case task_dao:init_get_task_list(Rid, SrvId) of
        {ok, Data} ->
            put({init_task_list, Rid, SrvId}, Data),
            init_proc_dict(Rid, SrvId, T);
        {error, Msg} ->
            ?ERR("获取已接任务数据出错:~w", [Msg]),
            {false , Msg}
    end;
init_proc_dict(Rid, SrvId, [task_log | T]) ->
    case task_dao_log:init_get_log(Rid, SrvId) of
        {ok, Data} ->
            put({init_task_log, Rid, SrvId}, Data),
            init_proc_dict(Rid, SrvId, T);
        {error, Msg} ->
            ?ERR("获取主支线已完成任务数据出错:~w", [Msg]),
            {false , Msg}
    end;
init_proc_dict(Rid, SrvId, [task_daily_log | T]) ->
    case task_dao_log:init_get_daily_log(Rid, SrvId) of
        {ok, Data} ->
            put({init_task_daily_log, Rid, SrvId}, Data),
            init_proc_dict(Rid, SrvId, T);
        {error, Msg} ->
            ?ERR("获取日常已经完成任务数据出错:~w", [Msg]),
            {false , Msg}
    end;
init_proc_dict(Rid, SrvId, [Type | _T]) ->
    ?ERR("角色数据初始化有误，不识别的类型:~w, [Rid:~w, SrvId:~s]", [Type, Rid, SrvId]),
    {false, language:get(<<"角色数据初始化有误">>)}.
