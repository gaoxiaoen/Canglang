%%---------------------------------------------
%% 精灵守护(侍宠)系统
%% @author wpf(wprehard@qq.com)
%% @end
%%---------------------------------------------

-module(demon).
-export([
        init/0
        ,ver_parse/1
        ,login/1
        ,get_combat_skill_list/1
        ,activate/2
        ,unactivate/2
        ,get_polish_list/2
        ,polish_craft/3
        ,polish_craft_list/3
        ,select_polish/3
        ,use_item/2
        ,polish_type_to_num/1
        ,polish_skill/2
        ,select_skill/4
        ,forget_skill/3
        ,lev_to_skill_num/1
        ,up_skill/3
        ,feed/1
        ,add_intimacy/3
        ,follow/2
        ,unfollow/1
        ,add_follow_looks/1
        ,both_sit/2
        ,both_exp_ratio/0
        ,add_both_looks/2
        ,upgrade_shape/2
        ,gm_set_step/2
        ,gm_set_skill_lev/2
        ,gm_set_attr_craft/2
        ,gm_upgrade_shape/3
        ,devour/3
        ,devour2/3
        ,gain_debris/2
        ,loss_debris/2
        ,gain_exp/2
        ,gain_demon/2
        ,active_demon/2
        ,grab/2
        ,flush/0
        ,check_target_exist/3
        ,get_target_name/3
        ,get_grab_debris_id/0
        ,deal_grab/2
        ,loss_notify/2
        ,update_grab_times/1
        ,upgrade_once/3
        ,upgrade_batch/3
        ,upgrade_grow/2
    ]).

-include("common.hrl").
-include("role.hrl").
-include("demon.hrl").
-include("gain.hrl").
-include("item.hrl").
-include("looks.hrl").
-include("storage.hrl").
-include("link.hrl").
-include("notification.hrl").

-define(Stone, 641201).

%% 守护化形技能配置
-define(DEMON_SHAPE_SKILLS,{
[82700 ,82701 ,82702 ,82703 ,82704]
,[83700 ,83701 ,83702 ,83703 ,83704]
,[85700 ,85701 ,85702 ,85703 ,85704]
,[84700 ,84701 ,84702 ,84703 ,84704]
,[86700 ,86701 ,86702 ,86703 ,86704]
}).

%% @spec init() -> #role_demon{}
%% @doc 初始数据
init() ->
    #role_demon{
        step = 1       %% 默认1级
    }.

%% @spec ver_parse(RoleDemon) -> NewRoleDemon
%% @doc 版本解析
ver_parse({role_demon, ?DEMON_ROLE_VER = Ver, Act, Follow, Bag, Attr, Exp, Step, OpId, SkillBag, SkillPolish, LuckCoin, LuckGold, ShapeLev, ShapeSkills}) ->
    ver_parse({role_demon, Ver, Act, Follow, Bag, Attr, Exp, Step, OpId, SkillBag, SkillPolish, LuckCoin, LuckGold, ShapeLev, ShapeSkills, ?GRAB_TIMES});

ver_parse({role_demon, ?DEMON_ROLE_VER = Ver, Act, Follow, Bag, Attr, Exp, Step, OpId, SkillBag, SkillPolish, LuckCoin, LuckGold, ShapeLev, ShapeSkills,
     Grab_times}) when is_integer(Grab_times)->
    ver_parse({role_demon, Ver, Act, Follow, Bag, Attr, Exp, Step, OpId, SkillBag, SkillPolish, LuckCoin, LuckGold, ShapeLev, ShapeSkills, 
        {Grab_times, 0}});
ver_parse(RoleDemon = #role_demon{ver = ?DEMON_ROLE_VER, active = Active, bag = Bag}) ->
    RoleDemon#role_demon{active = do_ver_parse_bag(Active), bag = ver_parse_bag(Bag, [])}.
    

%% @spec login(Role) -> NewRole.
%% @doc 登陆初始化
% login(Role = #role{demon = #role_demon{active = 0}}) ->
%     demon_debris_mgr:login(Role);
login(Role = #role{demon = RoleDemon = #role_demon{active = Demon, grab_times = {Grab_times, _}}, special = Special, login_info = #login_info{last_logout = LastLogout}}) ->
    NRole = 
        case is_record(Demon, demon2) of
            true -> 
                #demon2{base_id = BaseId} = Demon,
                NSpecial = [{?special_demon, BaseId, <<>>}] ++ Special,
                Role#role{special = NSpecial};
            _ -> Role
        end,

    Now = util:unixtime(),
    NGrabTimes = 
        case Grab_times > ?GRAB_TIMES of 
            true -> Grab_times;
            false -> ?GRAB_TIMES
        end,
    NRole1 = 
        case util:is_same_day2(LastLogout, Now) of 
            false ->
                NRole#role{demon = RoleDemon#role_demon{grab_times = {NGrabTimes, 0}}};
            true -> NRole
    end,
    NRole2 = role_timer:set_timer(update_grab_times1, util:unixtime({nexttime, 86407}) * 1000, {?MODULE, update_grab_times, []}, 1, NRole1),
    demon_debris_mgr:login(NRole2).

update_grab_times(Role = #role{demon = RoleDemon = #role_demon{grab_times = {Grab_times, _}}}) ->
    NGrabTimes = 
        case Grab_times > ?GRAB_TIMES of 
            true -> Grab_times;
            false -> ?GRAB_TIMES
        end,
    NRole = Role#role{demon = RoleDemon#role_demon{grab_times = {NGrabTimes, 0}}},
    {ok, role_timer:set_timer(update_grab_times2, util:unixtime({nexttime, 86407}) * 1000, {?MODULE, update_grab_times, []}, 1, NRole)}.

%% @sepc gain_demon(DemonId, Role) -> NRole |{false Reason}
%% @doc 获取妖兽
gain_demon(DemonBaseId, 
    Role = #role{demon = RoleDemon = #role_demon{active = _Active, op_id = Next_Id, bag = Bag}}) ->
    %%需要加入消耗逻辑
    case demon_data2:get_demon_base(DemonBaseId) of 
        {ok, Demon} when is_record(Demon, demon2) ->
            Id      = Next_Id,
            NDemon  = demon_api:reset(Demon#demon2{id = Id}), 
            NBag    = [NDemon|Bag],
            NRole   = Role#role{demon = RoleDemon#role_demon{bag = NBag, op_id = Next_Id + 1}},
            demon_api:push_demon(NRole, NDemon), %%刷新已有的契约兽信息,需要优化为刷一只兽
            % demon_api:push_debris(Role, NRole),
            NRole1 = role_listener:special_event(NRole, {1075, DemonBaseId}),%% 获得拳王
            NRole2 = demon_debris_mgr:update_role_demon(NRole1, DemonBaseId),

            log:log(log_demon2, {<<"妖精召唤">>, util:fbin("~w", [DemonBaseId]), 0, 0, NRole2}),

            random_award:monsters_contract(NRole2),
            random_award:monster_contract(NRole2, DemonBaseId),
            NRole3 = medal:listener(monster, NRole2),
            {ok, NRole3};
        _ ->
            {false, ?MSGID(<<"契约兽不存在!">>)}
    end.

%% @spec gain_exp(GainExp, Role) -> NRole
%% @doc 出战妖兽获取经验
gain_exp(_GainExp, Role = #role{link = #link{conn_pid = _ConnPid}, demon = #role_demon{active = 0}}) ->  
    Role;
gain_exp(GainExp, Role = #role{lev = RoleLev, demon = RoleDemon = #role_demon{active = Demon = #demon2{lev = Lev}}}) when Lev < RoleLev ->
    NDemon  = demon_gain_exp(Demon, RoleLev, GainExp),
    NDemon1 = demon_api:reset(NDemon),
    demon_api:push_demon(Role, NDemon1),
    NRole   = Role#role{demon = RoleDemon#role_demon{active = NDemon1}},
    medal:listener(monster, NRole);
gain_exp(_GainExp, Role) -> 
    Role.

%% @spec upgrade_once(DemonId, Role) ->{ok, NRole}|{false, Reason}
%% @doc 升级一次，消耗一个道具
upgrade_once(DemonId, Is_Auto, Role = #role{lev = RoleLev, bag = #bag{items = Items}, demon = #role_demon{active = ActiveDemon, bag = Bag}}) ->
    case get_demon_by_id(DemonId, ActiveDemon, Bag) of
        false -> 
            {false, ?MSGID(<<"妖精不存在!">>)};
        Demon when is_record(Demon, demon2) ->
            Lev    = Demon#demon2.lev,
            case Lev >= RoleLev of
                false ->
                    StoneExp = get_stone_exp(),
                    NDemon   = demon_gain_exp(Demon, RoleLev, StoneExp),
                    case make_loss(1, Is_Auto, Items) of
                        {false, Res} -> 
                            {false, Res};
                        Loss ->
                            do_cost_and_refrsh(Role, Loss, NDemon)
                    end;
                true -> 
                    {false, ?MSGID(<<"妖精等级不能超过人物等级">>)}
            end
    end.

%% @spec upgrade_batch(DemonId, Role) ->{ok, NRole}|{false, Reason}
%% @doc 升级到下一级，消耗n个道具
upgrade_batch(DemonId, Is_Auto, Role = #role{lev = RoleLev, bag = #bag{items = Items}, demon = #role_demon{active = ActiveDemon, bag = Bag}}) ->
    case get_demon_by_id(DemonId, ActiveDemon, Bag) of
        false -> 
            {false, ?MSGID(<<"妖精不存在!">>)};
        Demon when is_record(Demon, demon2) ->
            Lev    = Demon#demon2.lev,
            CurExp = Demon#demon2.exp,
            case Lev >= RoleLev of
                false -> 
                    StoneExp = get_stone_exp(),
                    N        = calc_next_lev_stone(Lev, CurExp, StoneExp),
                    NDemon   = demon_gain_exp(Demon, RoleLev, StoneExp * N),
                    case make_loss(N, Is_Auto, Items) of
                        {false, Res} -> 
                            {false, Res};
                        Loss ->
                            do_cost_and_refrsh(Role, Loss, NDemon)
                    end;
                true -> 
                    {false, ?MSGID(<<"妖精等级不能超过人物等级">>)}
            end
    end.

do_cost_and_refrsh(Role, Loss, Demon) ->
    case role_gain:do(Loss, Role) of
        {ok, NRole} -> 
            NDemon1 = demon_api:reset(Demon),
            demon_api:push_demon(Role, NDemon1),

            NRole1  = update_role_demons(NDemon1, NRole),
            NRole2 = medal:listener(monster, NRole1),
            {ok, NRole2};
        {false, #loss{msg = Msg}} -> 
            {false, Msg};
        {false, Reason} -> 
            {false, Reason}
    end.

get_demon_by_id(DemonId, ActiveDemon, Bag) ->
    Demons = 
        case is_record(ActiveDemon, demon2) of
            true -> 
                [ActiveDemon] ++ Bag;
            false -> 
                Bag
        end,
    case lists:keyfind(DemonId, #demon2.id, Demons) of
        Demon = #demon2{} -> 
            Demon;
        _ -> 
            false
    end.

calc_next_lev_stone(Lev, CurExp, StoneExp) ->
    BaseNeedExp = demon_lev_exp:get(Lev),
    CurNeedExp  = BaseNeedExp - CurExp,
    case CurNeedExp rem StoneExp of
        0 -> CurNeedExp div StoneExp;
        _ -> 
            CurNeedExp div StoneExp + 1
    end.


demon_gain_exp(Demon = #demon2{lev = Lev, exp = Exp}, RoleLev, GainExp) -> 
    case GainExp > 0 of 
        true ->
            NDemon1 = 
                case calc_new_lev_exp({Lev, Exp}, RoleLev, GainExp) of 
                    {Lev, NewExp} ->
                        Demon#demon2{exp = NewExp};
                    {NewLev, NewExp} ->
                        Demon#demon2{lev = NewLev, exp = NewExp}
                end,
            NDemon1;
        false ->
            Demon
    end.

update_role_demons(Demon = #demon2{id = Id, mod = Mod}, Role = #role{demon = RoleDemon = #role_demon{bag = Bag}}) -> 
    case Mod of
        1 ->
            Role#role{demon = RoleDemon#role_demon{active = Demon}};
        0 -> 
            Bag1 = lists:keydelete(Id, #demon2.id, Bag),
            Bag2 = [Demon] ++ Bag1,
            Role#role{demon = RoleDemon#role_demon{bag = Bag2}}
    end.

make_loss(Num, Is_Auto, Items) ->
    Has = 
        case storage:find(Items, #item.base_id, ?Stone) of 
            {false, _Msg} -> 0;
            {ok, Num0, _, _, _} -> Num0
        end,
    case Has >= Num of
        true -> 
            [#loss{label = item, val = [?Stone, 0, Num]}];
        false ->
            case Is_Auto of
                1 -> 
                    Price = get_price(),
                    [
                        #loss{label = item, val = [?Stone, 0, Has]}, 
                        #loss{label = gold, val = (Num - Has) * Price, msg = ?MSGID(<<"晶钻不足">>)} %% 这个价格后面要去读商城
                    ];
                0 -> 
                    {false, ?MSGID(<<"物品不足！">>)}
            end
    end.

%% @spec gain_debris(Role, Gain) -> {ok, NRole}
%% @doc 获取碎片
gain_debris(Role, []) -> {ok, Role};
gain_debris(Role = #role{demon = RoleDemon = #role_demon{shape_skills = Debris}}, Gain) ->
    NDebris = do_gain_debris(Gain, Debris),
    NRole   = Role#role{demon = RoleDemon#role_demon{shape_skills = NDebris}},
    demon_api:push_debris(Role, NRole),
    demon_debris_mgr:update_role_debris(NRole),
    {ok, NRole}.

%% @spec loss_debris(Role, Loss) -> {ok, NRole}
%% @doc 失去碎片
loss_debris(Role, []) -> {ok, Role};
loss_debris(Role = #role{demon = RoleDemon = #role_demon{shape_skills = Debris}}, Loss) ->
    NDebris = do_loss_debris(Loss, Debris),
    NRole   = Role#role{demon = RoleDemon#role_demon{shape_skills = NDebris}},
    demon_api:push_debris(Role, NRole),
    demon_debris_mgr:update_role_debris(NRole),
    {ok, NRole}.

%% @spec active_demon(Id, Role) ->{ok, NRole} | {false, Reason}
%% @doc 出战一只契约兽
active_demon(Id, Role = #role{special = Special, link = #link{conn_pid = ConnPid}, demon = RoleDemon = #role_demon{active = ActiveDemon, bag = Bag}})->
    case check_if_active(Id, ActiveDemon) of 
        true ->
            {false, ?MSGID(<<"已经出战!">>)};
        false ->
            case lists:keyfind(Id, #demon.id, Bag) of 
                Demon when is_record(Demon, demon2) ->
                    #demon2{base_id = BaseId, name = _Name} = Demon,

                    {NRole, NewActiveDemon, NeedRefresh} = demon_api:deal_del_buff(Role, ActiveDemon),
                    case NeedRefresh of 
                        true ->
                            demon_api:push_demon(NRole, NewActiveDemon);
                        false ->
                            ignore
                    end,

                    {NBag,  NSpecial} = 
                        case is_record(NewActiveDemon, demon2) of
                            true ->
                                Bag1     = [NewActiveDemon#demon2{mod = 0}] ++ Bag -- [Demon],
                                Special1 = lists:keyreplace(?special_demon, 1, Special, {?special_demon, BaseId, <<>>}),
                                {Bag1, Special1};
                            false ->
                                Bag1     = Bag -- [Demon],
                                Special1 = [{?special_demon, BaseId, <<>>}] ++ Special,
                                {Bag1, Special1}
                        end,

                    NRole1 = NRole#role{special = NSpecial, demon = RoleDemon#role_demon{active = Demon#demon2{mod = 1}, bag = NBag}},

                    {NRole2, NewDemon2, NeedRefresh2} = demon_api:deal_add_buff(NRole1),
                    sys_conn:pack_send(ConnPid, 17237, {}),
                    NRole3 = 
                        case NeedRefresh2 of 
                            true ->
                                demon_api:push_demon(NRole2, NewDemon2),
                                role_api:push_attr(NRole2);
                            false ->
                                case NeedRefresh of 
                                    true->
                                        role_api:push_attr(NRole2);
                                    false ->
                                        NRole2
                                end
                        end,
                    demon_api:refresh_role_special(NRole3),
                    {ok, NRole3};
                _ ->
                    {false, ?MSGID(<<"妖精不存在">>)}
            end
    end.

%% @spec devour(DemonId, {Demons, Debris}, Role) ->{ok, NRole} | {false, Reason}
%% @doc 吞噬
devour(DemonId, {Demons, Debris}, Role = #role{lev = RoleLev, demon = RoleDemon = #role_demon{active= Active, bag = Bag, shape_skills = HavedDebris}}) ->
    All = 
        case is_record(Active, demon2) of 
            true ->
                [Active] ++ Bag;
            false ->
                Bag
        end,
    case lists:keyfind(DemonId, #demon2.id, All) of 
        Demon when is_record(Demon, demon2) ->
            #demon2{grow = Grow, grow_max = GrowMax, bless = Bless, mod = Mod, lev = Lev, exp = Exp} = Demon,
                case get_demon_bless_exp(Demons, All) of 
                    {Demons_Bless, Demons_Exp, Used_Demons, Used_DemonBasedIds} ->
                        case get_debris_bless(Debris) of
                            {false, Reason} -> 
                                {false, Reason};
                            {Debris_Bless, Used_Debris} ->
                                Gain_Bless = Demons_Bless + Debris_Bless,

                                {NewGrow2, NewBless2} = 
                                    case Grow >= GrowMax of 
                                        false -> 
                                            {NewGrow, NewBless} = calc_new_grow_bless({Grow, Bless}, Gain_Bless),
                                            case NewGrow >= GrowMax of 
                                                true -> {GrowMax, 0};
                                                false -> {NewGrow, NewBless}
                                            end;
                                        true -> 
                                            {Grow, Bless}
                                    end,

                                {NewLev, NewExp} = calc_new_lev_exp({Lev, Exp}, RoleLev, Demons_Exp),

                                NDemon = Demon#demon2{grow = NewGrow2, bless = NewBless2, lev = NewLev, exp = NewExp},
                                log:log(log_demon2, {<<"妖精吞噬">>, util:fbin("~w", [Used_DemonBasedIds]), NewGrow2 - Grow, NewExp - Exp, Role}),

                                NDemon1 = demon_api:reset(NDemon),

                                {NR, NDemon2} = check_new_skill_buff(Role, NDemon1, Demon),

                                NBag = delete_used_demons(Bag, Used_Demons),

                                {NActive, NBag1} = 
                                    case Mod of 
                                        1 -> {NDemon2, NBag};
                                        _ ->
                                            T = lists:keydelete(DemonId, #demon2.id, NBag),
                                            {Active, [NDemon2] ++ T}
                                    end,

                                RestDebris = delete_used_debris(HavedDebris, Used_Debris),

                                NRole = NR#role{demon = RoleDemon#role_demon{active = NActive, shape_skills = RestDebris, bag = NBag1}},
                                demon_api:push_debris(NR, NRole),
                                demon_api:push_demon(NRole, NDemon2),

                                demon_debris_mgr:update_role_debris(NRole),
                                NRole1 = medal:listener(monster, NRole),
                                {ok, NRole1}
                        end;
                    {false, Reason} ->
                        {false, Reason}
                end;     
        _ ->
            {false, ?MSGID(<<"找不到发起吞噬的妖精">>)}
    end.

%% @doc 献祭
devour2(MDemonId, SDemonId, Role = #role{lev = RoleLev}) ->
    case check_conditions(MDemonId, SDemonId, Role) of
        {false, Reason} -> 
            {false, Reason};
        {MDemon, SDemon} -> 
            SBaseId  = SDemon#demon2.base_id,
            ALLExp   = SDemon#demon2.exp + calc_exp_by_lev(SDemon#demon2.lev - 1),
            NMDemon  = demon_gain_exp(MDemon, RoleLev, erlang:round(ALLExp)),
            NMDemon1 = add_devour_ext_attr(NMDemon, SBaseId),

            NDemon1  = demon_api:reset(NMDemon1),

            NRole1   = update_role_demons(NDemon1, Role), %% 更新妖精到角色

            RoleDemon = NRole1#role.demon,
            Devours   = NRole1#role.demon#role_demon.skill_polish,
            Bag       = NRole1#role.demon#role_demon.bag,

            NDevours  = add_devour(Devours, MDemonId, SBaseId), %% 记录献祭

            NBag      = lists:keydelete(SDemonId, #demon2.id, Bag), %% 删除使用的妖精
            NRole2    = NRole1#role{demon = RoleDemon#role_demon{skill_polish = NDevours, bag = NBag}},

            demon_api:push_demon(NRole2),
            {ok, NRole2}
    end.

%% @doc 升星
upgrade_grow(MDemonId, Role = #role{demon = #role_demon{active = ActiveDemon, bag = Bag, skill_polish = Devours}}) ->
    case get_demon_by_id(MDemonId, ActiveDemon, Bag) of
        MDemon when is_record(MDemon, demon2) ->
            case lists:keyfind(MDemonId, 1, Devours) of
                {_, A, B} when A =/= 0 andalso B =/= 0 -> 
                    Grow    = MDemon#demon2.grow,
                    ExtAttr = MDemon#demon2.ext_attr,
                    MBaseId = MDemon#demon2.base_id,
                    Index   = (Grow - 1) * 2 + 3,

                    {_, AttrData} = demon_devour_data:get_devour_attr(MBaseId),
                    AddAttr = 
                        case Index > erlang:length(AttrData) of
                            true -> [];
                            false -> 
                                lists:nth(Index, AttrData)
                        end,

                    NExtAttr = add_attr(ExtAttr, AddAttr),
                    MDemon1  = MDemon#demon2{ext_attr = NExtAttr, grow = Grow + 1},
                    MDemon2  = demon_api:reset(MDemon1),
                    demon_api:push_demon(Role, MDemon2),

                    NRole     = update_role_demons(MDemon2, Role),

                    RoleDemon = NRole#role.demon,
                    Devours   = NRole#role.demon#role_demon.skill_polish,
                    NDevours  = lists:keydelete(MDemonId, 1, Devours),
                    NRole1    = NRole#role{demon = RoleDemon#role_demon{skill_polish = NDevours}},

                    {ok, NRole1};
                _ ->
                    {false, ?MSGID(<<"献祭两只妖精才能升星!">>)}
            end;
        _ -> 
            {false, ?MSGID(<<"妖精不存在!">>)}
    end.

%% 进入掠夺面板
grab(_Role = #role{id = Id, demon = #role_demon{shape_skills = Debris}}, DebriId) ->
    case lists:keyfind(DebriId, 1, Debris) of 
        {_, Val} when Val > 0 ->
            role:put_dict(role_garb_debrisId, DebriId),
            get_search_result(Id, DebriId);
        _ ->
            {false, ?MSGID(<<"自己没有这个碎片不能参与掠夺哦">>)}
    end.

%% 关闭面板时清空已有的查询结果
flush() ->
    ?DEBUG("清空已有的查询结果~n~n~n"),
    role:put_dict(role_garb_debrisId, 0),
    role:put_dict(search_role_debris, []).

%% 掠夺战结束处理 -- 只有战斗胜利时才调用
deal_grab(Role = #role{name = RoleName, id = Id}, {Type, Rid, Srvid}) ->
    DebrisId = get_grab_debris_id(),
    % {RoleWeight, NpcWeight} = demon_data2:get_demon_weight(DebrisId),
    {RoleWeight, NpcWeight} = calcu_call_weight(DebrisId, Id),
    ?DEBUG("role weight:~p, npc weight:~p~n", [RoleWeight, NpcWeight]),
    case Type of 
        ?demon_challenge_type_virtual -> 
            Rand = util:rand(1, 100),
            case Rand =< NpcWeight of 
                true ->
                    {ok, [#gain{label = fragile, val = [DebrisId, 1]}], Role};
                false ->
                    {ok, [], Role}
            end;
        _ ->
            Debris = demon_debris_mgr:get_role_debris(Rid),
           
            FromRoleNameFmt = get_role_msg(RoleName, Id),
            ItemNameFmt = notice:item_msg({DebrisId, 0, 1}),
            case role_api:c_lookup(by_id, {Rid, Srvid}, #role.pid) of %%检查是否在线,在线则发送消息通知
                {ok, _, Pid} when is_pid(Pid)  -> %% 在线
                    case lists:keyfind(DebrisId, 1, Debris) of 
                        {_, Have} ->
                            case Have > 1 of 
                                true ->
                                    Rand = util:rand(1, 100),
                                    case Rand =< RoleWeight of 
                                        true ->
                                            role:apply(async, Pid, {demon, loss_debris, [[{DebrisId, 1}]]}),
                                            
                                            notification:send(offline, {Rid, Srvid}, 2, util:fbin(<<"~s对你发起了掠夺战斗，你被胖揍了一顿，~s碎片被抢走了">>,
                                                [FromRoleNameFmt, ItemNameFmt]), []),

                                            update_search_result({Rid, Srvid}, Have - 1),

                                            {ok, [#gain{label = fragile, val = [DebrisId, 1]}], Role};
                                        false ->
                                            notification:send(offline, {Rid, Srvid}, 2, util:fbin(<<"~s对你发起了掠夺战斗，你被胖揍了一顿，好在碎片没被抢走">>,
                                                [FromRoleNameFmt]), []),
                                            {ok, [], Role}
                                    end;
                                false -> {ok, [], Role}
                            end;
                        _ -> {ok, [], Role}
                    end;
                _ -> %% 不在线
                    case lists:keyfind(DebrisId, 1, Debris) of 
                        {_, Have} ->
                            case Have > 1 of 
                                true ->
                                    Rand = util:rand(1, 100),
                                    case Rand =< RoleWeight of 
                                        true ->
                                            NDebris = lists:keyreplace(DebrisId, 1, Debris, {DebrisId, Have - 1}),
                                            demon_debris_mgr:update_role_debris({Rid, NDebris}), %% 更新到ets与数据库， 角色上线时需要统一
                                            
                                            notification:send(offline, {Rid, Srvid}, ?notify_type_arena_career_lose, 
                                                util:fbin(<<"~s对你发起了掠夺战斗，你被胖揍了一顿，~s碎片被抢走了">>, [FromRoleNameFmt, ItemNameFmt]), []),
                                            
                                            update_search_result({Rid, Srvid}, Have - 1),

                                            {ok, [#gain{label = fragile, val = [DebrisId, 1]}], Role};
                                        false ->
                                            notification:send(offline, {Rid, Srvid}, ?notify_type_arena_career_lose, 
                                                util:fbin(<<"~s对你发起了掠夺战斗，你被胖揍了一顿，好在碎片没被抢走">>, [FromRoleNameFmt]), []),
                                            {ok, [], Role}
                                    end;
                                false -> {ok, [], Role}
                            end;
                        _ -> {ok, [], Role}
                    end
            end
    end.

%% @spec  loss_notify(Role, {Type, Rid, Srvid}) -> ::integer()
%% @doc 失败时发送给胜利方的离线消息
loss_notify(_Role = #role{name = RoleName, id = Id}, {Type, Rid, Srvid}) ->
    case Type of 
        ?demon_challenge_type_virtual -> 
            {ok, {}};
        _ ->
            FromRoleNameFmt = get_role_msg(RoleName, Id),
            notification:send(offline, {Rid, Srvid}, ?notify_type_arena_career_win, 
                util:fbin(<<"~s对你发起了掠夺战斗，你把他打的屁滚尿流">>, [FromRoleNameFmt]), []),
            {ok, {}}
    end.

get_role_msg(RoleName, {RoleId, SrvId}) ->    
    Color = ffffa500,
    util:fbin(<<"<a href='11101&~s&~w&~s'><u><font color='~s'>~s</font></u></a>">>, [RoleName, RoleId, SrvId, Color, RoleName]).

%% @spec  get_grab_debris_id() -> ::integer()
%% @doc 获取掠夺的对象
get_grab_debris_id() ->
    case role:get_dict(role_garb_debrisId) of
        {ok, Data} ->
            case Data of 
                undefined -> 0;
                _ -> Data
            end;
        _ -> 0
    end.

%% @spec  check_target_exist(Type, Rid, Srvid) - true | false
%% @doc 检查掠夺对象是否存在
check_target_exist(Type, Rid, Srvid) ->
    case role:get_dict(search_role_debris) of
        {ok, Data} -> 
            case Data of 
                undefined -> false;
                [] -> false;
                _ -> 
                    do_check_target_exist(Type, Rid, Srvid, Data)
            end;
        _ -> 
            false
    end.

%% @spec  get_target_name(Type, Rid, Srvid) - {ok, string()}| false
%% @doc 获取掠夺对象的名字, 同时将该对象在匹配结果中删除
get_target_name(Type, Rid, Srvid) ->
    case role:get_dict(search_role_debris) of
        {ok, Data} -> 
            case Data of 
                undefined -> false;
                [] -> false;
                _ -> 
                    case do_get_target_name(Type, Rid, Srvid, Data) of 
                        {ok, Name} ->
                            % NData = lists:keydelete(Rid, 2, Data),
                            % role:put_dict(search_role_debris, NData),
                            {ok, Name};
                        Other -> Other
                    end
            end;
        _ -> 
            false
    end.


%%------------------------------------------------------------------------------
%%  Internal Func
%%------------------------------------------------------------------------------

calcu_call_weight(DebrisId, {Rid, Srvid}) ->
    OldInfo = demon_debris_mgr:get_role_grab_info(Rid),
    ?DEBUG("--*****DebrisId:~p~n", [DebrisId]),
    RoleWeights = demon_call_weight:get(role, DebrisId),

    case erlang:length(RoleWeights) > 0 of 
        true ->
            NpcWeights = demon_call_weight:get(npc, DebrisId),
            Nth = case lists:keyfind(DebrisId, 1, OldInfo) of 
                {_, N} -> N + 1;
                false -> 1 
            end,

            {_, RoleWeight} = case lists:keyfind(Nth, 1, RoleWeights) of
                {_XX, RWeight} -> {_XX, RWeight};
                _ -> lists:last(RoleWeights)
            end,

            {_, NpcWeight} = case lists:keyfind(Nth, 1, NpcWeights) of
                {_ZZ, NWeight} -> {_ZZ, NWeight};
                _ -> lists:last(NpcWeights)
            end,
            
            OldInfo1 = lists:keydelete(DebrisId, 1, OldInfo),
            OldInfo2 = [{DebrisId, Nth}] ++ OldInfo1,
            demon_debris_mgr:update_role_grab_info({Rid, Srvid, OldInfo2}),

            {RoleWeight, NpcWeight};
        false ->{0, 0}
    end.
    
update_search_result({Rid, Srvid}, Left) ->
    DebrisId = get_grab_debris_id(),
    case DebrisId of
        0 -> ignore;
        _ ->
            case Left > 1 of
                true -> ignore;
                false ->
                    case role:get_dict(search_role_debris) of
                        {ok, Data} -> 
                            case Data of 
                                undefined -> ignore;
                                [] -> ignore;
                                _ -> 
                                    del_from_search_result(Data, {Rid, Srvid})
                            end;
                        _ -> 
                            ignore
                    end
            end
    end.
del_from_search_result(Data, {Rid, Srvid}) ->
    Result = do_del({Rid, Srvid}, Data),
    role:put_dict(search_role_debris, Result).


do_del({Rid, _}, Data) ->
    T = [D||D = {Type, _Rid, _Srvid, _, _, _, _, _} <- Data , Type == ?demon_challenge_type_real, _Rid =:= Rid],
    Data -- T.


do_get_target_name(_Type, _Rid, _Srvid, []) -> false;
do_get_target_name(_Type, _Rid, _Srvid, [{_Type, _Rid, _Srvid, Name, _, _, _, _}|_]) -> {ok, Name};
do_get_target_name(Type, Rid, Srvid, [{_Type, _Rid, _Srvid, _, _, _, _, _}|T]) -> 
    do_get_target_name(Type, Rid, Srvid, T).


do_check_target_exist(_Type, _Rid, _Srvid, []) -> false;
do_check_target_exist(_Type, _Rid, _Srvid, [{_Type, _Rid, _Srvid, _, _, _, _, _}|_]) -> true;
do_check_target_exist(Type, Rid, Srvid, [{_Type, _Rid, _Srvid, _, _, _, _, _}|T]) -> 
    do_check_target_exist(Type, Rid, Srvid, T).


get_search_result(Id, DebriId) ->
    NData = 
        case role:get_dict(search_role_debris) of
            {ok, Data} -> 
                case Data of 
                    undefined -> undefined;
                    [] -> undefined;
                    _ -> get_rand_five(Data)
                end;
            _ -> 
                undefined
        end,
    case NData of 
        undefined -> 
            Result = demon_debris_mgr:search_role_debris(Id, DebriId),
            case erlang:length(Result) > 0 of 
                true ->
                    role:put_dict(search_role_debris, Result),
                    get_rand_five(Result);
                false ->
                    role:put_dict(search_role_debris, []),
                    []
            end;
        _ ->
            NData %% 已经获取5个了
    end.

get_rand_five([]) -> [];
get_rand_five(Data) when is_list(Data)->
    Max = erlang:length(Data),
    case Max =< 5 of 
        true ->
            Data;
        false ->
            do_get_five(Data, Max, 0, [])
    end;
get_rand_five(_) ->
    [].

do_get_five([], _Max, _N, Return) -> Return;
do_get_five(_Data, _Max, 5, Return) -> Return;
do_get_five(Data, Max, N, Return) ->
    Nth = util:rand(1, Max),
    D = lists:nth(Nth, Data),
    case lists:member(D, Return) of
        true ->
            do_get_five(Data, Max, N, Return);
        false ->
            do_get_five(Data, Max, N + 1, [D|Return])
    end.

calc_new_lev_exp({CurLev, CurExp}, RoleLev, GainExp) ->
    case CurLev >= RoleLev of
        false ->
            CurNeedExp = demon_lev_exp:get(CurLev),
            case GainExp >= CurNeedExp - CurExp of 
                true ->
                    case demon_lev_exp:get(CurLev + 1) of 
                        0 ->
                            {CurLev + 1, 0};
                        _ ->
                            calc_new_lev_exp({CurLev + 1, 0}, RoleLev, GainExp - (CurNeedExp - CurExp))
                    end;
                false ->
                    {CurLev, CurExp + GainExp}
            end;
        true -> 
            {CurLev, CurExp}
    end.

do_gain_debris([], Debris) -> Debris;
do_gain_debris([{Type, Num}|T], Debris) ->
    case lists:keyfind(Type, 1, Debris) of
        {_, Val}->
            NVal = Val + Num,
            NDebris = lists:keyreplace(Type, 1, Debris, {Type, NVal}),
            do_gain_debris(T, NDebris);
        _ ->
            NDebris = [{Type, Num}] ++ Debris,
            do_gain_debris(T, NDebris)
    end.

do_loss_debris([], Debris) -> Debris;
do_loss_debris([{Type, Num}|T], Debris) ->
    case lists:keyfind(Type, 1, Debris) of
        {_, Val}->
            NDebris = 
                case Val > Num of 
                    true -> 
                        lists:keyreplace(Type, 1, Debris, {Type, Val - Num});
                    false -> 
                        lists:keydelete(Type, 1, Debris)
                end,
            do_loss_debris(T, NDebris);
        _ ->
            do_loss_debris(T, Debris)
    end.

check_new_skill_buff(Role, NewDemon = #demon2{mod = Mod, skills = NewSkills}, _OldDemon = #demon2{skills = OldSkills})->
    case Mod of 
        1 ->
            case has_new_buff(NewSkills, OldSkills) of 
                true ->
                    {NRole = #role{demon = RoleDemon}, NDemon, _} = demon_api:deal_del_buff(Role, NewDemon#demon2{skills = OldSkills}),
                    {NRole1, NDemon2, _} = demon_api:deal_add_buff(NRole#role{demon = RoleDemon#role_demon{active = NDemon#demon2{skills = NewSkills}}}),
                    NRole2 = role_api:push_attr(NRole1),
                    {NRole2, NDemon2};
                false ->
                    {Role, NewDemon}
            end;
        0 ->
            {Role, NewDemon}
    end.
has_new_buff(NSkills, OSkills) ->
    Left = NSkills -- OSkills,
    case erlang:length(Left) > 0 of 
        true ->
            Buff = [SkillId||SkillId <- Left, is_atom(SkillId) == true],
            case erlang:length(Buff) > 0 of 
                true ->
                    true;
                false ->
                    false
            end;
        false ->
            false
    end.     

delete_used_demons(Bag, []) -> Bag;
delete_used_demons(Bag, [Id|T]) ->
    NBag = lists:keydelete(Id, #demon2.id, Bag),
    delete_used_demons(NBag, T).

delete_used_debris(HavedDebris, []) -> HavedDebris;
delete_used_debris(HavedDebris, [{ItemId, Num}|T]) ->
    case lists:keyfind(ItemId, 1, HavedDebris) of 
        {_, Had} ->
            Res = 
                case Had > Num of 
                    true ->
                        Had - Num;
                    false -> 0
                end,
            NHad = lists:keyreplace(ItemId, 1, HavedDebris, {ItemId, Res}),
            delete_used_debris(NHad, T);
        false ->
            delete_used_debris(HavedDebris, T)
    end.

calc_new_grow_bless({CurGrow, CurBless}, GainBless) ->
    CurNeedBless = demon_grow_bless:get(CurGrow),
    case GainBless >= CurNeedBless - CurBless of 
        true ->
            case demon_grow_bless:get(CurGrow + 1) of 
                0 ->
                    {CurGrow + 1, 0};
                _ ->
                    calc_new_grow_bless({CurGrow + 1, 0}, GainBless - (CurNeedBless - CurBless))
            end;
        false ->
            {CurGrow, CurBless + GainBless}
    end.    

get_demon_bless_exp(Demon, All) ->
    do_get_demon_bless_exp(Demon, All, 0, 0, [], []).

do_get_demon_bless_exp([], _All, ReturnBless, ReturnExp, Demons, DemonBaseIds) -> {ReturnBless, erlang:round(ReturnExp*0.75), Demons, DemonBaseIds};
do_get_demon_bless_exp([Id|T], All, ReturnBless, ReturnExp, Demons, DemonBaseIds) ->
    case lists:keyfind(Id, #demon2.id, All) of 
        D when is_record(D, demon2) ->
            #demon2{base_id = DemonBaseId, bless = Bless, lev = Lev, exp = Exp, grow = Grow} = D,
            case demon_data2:get_demon_base(DemonBaseId) of 
                {ok, #demon2{devour = Devour}} ->
                    AllBless = Bless + calc_bless_by_grow(Grow - 1),
                    AllExp = Exp + calc_exp_by_lev(Lev -1),
                    do_get_demon_bless_exp(T, All, AllBless + Devour + ReturnBless, AllExp + ReturnExp, [Id|Demons], [DemonBaseId|DemonBaseIds]);
                {false, Reason} ->
                    {false, Reason}
            end;
        false ->
            {false, ?MSGID(<<"使用了尚未召唤的妖精！">>)}
    end.

get_debris_bless(Debris) ->
    do_get_debris_bless(Debris, 0, []).

do_get_debris_bless([], Res, Items) -> {Res, Items};
do_get_debris_bless([{ItemId, Num}|T], Res, Items) ->
    case item_data:get(ItemId) of 
        {ok, _} ->
            Parm = item_bless_parm(ItemId),
            do_get_debris_bless(T, Parm * Num + Res, [{ItemId, Num}] ++ Items);
        {false, _Reason} ->
            {false, _Reason}
    end.
    
item_bless_parm(ItemId) ->
    case item_data:get(ItemId) of 
        {ok, #item_base{quality = Q}} ->
            demon_data2:get_quality_bless(Q);
        _ -> 0
    end.

%%根据成长值计算兽总的累积祝福值
calc_bless_by_grow(0) -> 0;
calc_bless_by_grow(Grow) ->
    do_calc_bless_by_grow(Grow, 0).
do_calc_bless_by_grow(0, AllBless) -> AllBless;
do_calc_bless_by_grow(Grow, AllBless) -> 
    Bless = demon_grow_bless:get(Grow),
    do_calc_bless_by_grow(Grow - 1, Bless + AllBless).

%%根据等级计算兽总的经验值
calc_exp_by_lev(0) -> 0;
calc_exp_by_lev(Lev) ->
    do_calc_exp_by_lev(Lev, 0).
do_calc_exp_by_lev(0, AllExp) -> AllExp;
do_calc_exp_by_lev(Lev, AllExp) -> 
    Exp = demon_lev_exp:get(Lev),
    do_calc_exp_by_lev(Lev - 1, Exp + AllExp).

%% @spec get_combat_skill_list(Role) -> lists()
%% @doc 获取战斗战斗技能列表
get_combat_skill_list(#role{demon = #role_demon{active = 0}}) -> [];
get_combat_skill_list(#role{demon = #role_demon{active = DemonId, bag = Demons}}) ->
    case lists:keyfind(DemonId, #demon.id, Demons) of
        false -> [];
        #demon{skills = SL} ->
            [{Sid, Sid} || {Sid, _, _} <- SL]
    end.

%% @spec check_lock_list(LockList) -> list()
%% 检测洗髓锁的合法状态
check_lock_list(LockList) ->
    %% LockId表示需要锁的属性类型ID
    %% TODO: 此处没有判断重复的类型ID，暂不过滤 (因为概率随锁增加降低，作弊是傻x)
    L = [LockId || LockId <- LockList, is_integer(LockId) andalso LockId >= 1 andalso LockId =< 14],
    case length(L) > 7 of
        true -> [];
        false -> L
    end.

%% 每次洗髓重设置最新锁状态
set_polish_lock(LockList, AL) ->
    NewAL = [{A, C, V, 0} || {A, C, V, _Lock} <- AL],
    do_set_polish_lock(LockList, NewAL).
do_set_polish_lock([], AL) -> AL;
do_set_polish_lock([TypeId | T], AL) ->
    A = demon_api:int_to_attr(TypeId),
    case lists:keyfind(A, 1, AL) of
        false ->
            do_set_polish_lock(T, AL);
        {A, C, V, _Lock} ->
            do_set_polish_lock(T, lists:keyreplace(A, 1, AL, {A, C, V, ?true}))
    end.

%% @spec polish_craft(DemonId, LockList, Role) -> {ok, NewRole} | {false, Msg}
%% @doc 守护洗髓
polish_craft(DemonId, LockList, Role = #role{demon = RoleDemon = #role_demon{active = ActId, step = Step, bag = Demons}}) ->
    case lists:keyfind(DemonId, #demon.id, Demons) of
        false -> {false, ?L(<<"未找到该精灵守护">>)};
        D = #demon{id = Did, attr = AL} ->
            RandList = get_rand_form(length(LockList)),
            LockAL = set_polish_lock(check_lock_list(LockList), AL),
            NewAL = recalc_attr(Did, polish_rand_attr(RandList, LockAL, []), Step),
            NewCraft = merge_craft(NewAL),
            NewD = D#demon{craft = NewCraft, attr = NewAL, polish_attrs = []},
            NewRD = refresh_demon(NewD, RoleDemon),
            log:log(log_demon_update, {<<"守护洗髓">>, util:fbin(<<"[~w]品质~w锁~w属性~w">>, [Did, NewCraft, LockList, NewAL]), RoleDemon, NewRD, Role}),
            demon_api:pack_and_send(17201, NewD, Role),
            case Did =:= ActId of
                true ->
                    {ok, role_api:push_attr(Role#role{demon = NewRD})};
                false ->
                    {ok, Role#role{demon = NewRD}}
            end
    end.

%% @spec get_polish_list(DemonId, Role) -> {ok, list()} | {false, Msg}
%% @doc 获取守护的批洗髓属性列表
get_polish_list(DemonId, #role{demon = #role_demon{bag = Demons}}) ->
    case lists:keyfind(DemonId, #demon.id, Demons) of
        false -> {false, ?L(<<"未找到该精灵守护">>)};
        #demon{polish_attrs = PL} ->
            {ok, PL}
    end.

%% @spec polish_craft_list(DemonId, LockList, Role) -> {ok, PolishList, NewRole} | {false, Msg}
%% @doc 守护批量洗髓
polish_craft_list(DemonId, LockList, Role = #role{demon = RoleDemon = #role_demon{step = Step, bag = Demons}}) ->
    case lists:keyfind(DemonId, #demon.id, Demons) of
        false -> {false, ?L(<<"未找到该精灵守护">>)};
        D = #demon{id = Did, attr = AL} ->
            RandList = get_rand_form(length(LockList)),
            LockAL = set_polish_lock(check_lock_list(LockList), AL),
            NewPL = batch_polish_rand_attr(RandList, Did, Step, LockAL),
            NewD = D#demon{polish_attrs = NewPL},
            NewRD = refresh_demon(NewD, RoleDemon),
            log:log(log_demon_update, {<<"批量洗髓">>, util:fbin(<<"[~w]守护[锁:~w]">>, [Did, LockList]), RoleDemon, NewRD, Role}),
            demon_api:pack_and_send(17220, NewPL, Role),
            {ok, NewPL, Role#role{demon = NewRD}}
    end.

%% @spec select_polish(DemonId, PolishId, Role) -> {ok, NewRole} | {false, Msg}
%% @doc 选定批洗属性
select_polish(DemonId, PolishId, Role = #role{demon = RoleDemon = #role_demon{active = ActId, bag = Demons}}) ->
    case lists:keyfind(DemonId, #demon.id, Demons) of
        false -> {false, ?L(<<"未找到该精灵守护">>)};
        D = #demon{polish_attrs = PL} ->
            case lists:keyfind(PolishId, 1, PL) of
                false -> {false, ?L(<<"不存在这个属性">>)};
                {_N, C, AL} ->
                    NewD = D#demon{craft = C, attr = AL, polish_attrs = []},
                    NewRD = refresh_demon(NewD, RoleDemon),
                    log:log(log_demon_update, {<<"选定属性">>, util:fbin(<<"[~w]守护选定属性~w">>, [DemonId, PolishId]), RoleDemon, NewRD, Role}),
                    demon_api:pack_and_send(17201, NewD, Role),
                    case DemonId =:= ActId of
                        true ->
                            {ok, role_api:push_attr(Role#role{demon = NewRD})};
                        false ->
                            {ok, Role#role{demon = NewRD}}
                    end;
                _ -> {false, ?L(<<"批量洗髓属性异常">>)}
            end
    end.

%% @spec polish_type_to_num(PolishType) -> integer()
%% 守护刷新技能方式对应数量
polish_type_to_num(1) -> 1;
polish_type_to_num(2) -> 1;
polish_type_to_num(3) -> 8;
polish_type_to_num(4) -> 8;
polish_type_to_num(_) -> 1.

%% @spec polish_skill(PolishType::integer(), Role) -> {ok, Data} | {ok, Data, NewRole} | {false, Msg}
%% @doc 刷新技能
polish_skill(0, Role = #role{demon = RoleDemon}) ->
    demon_api:pack_and_send(17225, RoleDemon, Role),
    {ok};
polish_skill(PolishType, Role = #role{demon = RoleDemon = #role_demon{luck_coin = LuckCoin, luck_gold = LuckGold}}) ->
    TL = demon_data:get_skill_type_polish_rand(),
    CL = if
        PolishType=:=1 orelse PolishType=:=3 ->
            demon_data:get_skill_craft_polish_rand(1, LuckCoin); %% 金币
        PolishType=:=2 orelse PolishType=:=4 ->
            demon_data:get_skill_craft_polish_rand(2, LuckGold); %% 晶钻
        true -> []
    end,
    Num = polish_type_to_num(PolishType),
    PSL = rand_skill(Num, TL, CL),
    NewRD = #role_demon{luck_coin = LC, luck_gold = LG} = if
        PolishType =:= 1 -> RoleDemon#role_demon{skill_polish = PSL, luck_coin = LuckCoin+?VAL_LUCK_COIN};
        PolishType =:= 2 -> RoleDemon#role_demon{skill_polish = PSL, luck_gold = LuckGold+?VAL_LUCK_GOLD};
        PolishType =:= 3 -> RoleDemon#role_demon{skill_polish = PSL, luck_coin = LuckCoin+(?VAL_LUCK_COIN*Num)};
        PolishType =:= 4 -> RoleDemon#role_demon{skill_polish = PSL, luck_gold = LuckGold+(?VAL_LUCK_GOLD*Num)};
        true -> RoleDemon
    end,
    log:log(log_demon_update, {<<"刷新神通">>, util:fbin(<<"方式~w，金币幸运~w晶钻幸运~w">>, [PolishType, LC, LG]), RoleDemon, NewRD, Role}),
    demon_api:pack_and_send(17225, NewRD, Role),
    {ok, Role#role{demon = NewRD}}.

%% @spec lev_to_skill_num(Step) -> integer()
%% @doc 根据守护等级确定技能格子数
lev_to_skill_num(Step) when Step >= 50 -> 7;
lev_to_skill_num(Step) when Step >= 40 -> 6;
lev_to_skill_num(Step) when Step >= 35 -> 5;
lev_to_skill_num(Step) when Step >= 30 -> 4;
lev_to_skill_num(Step) when Step >= 10 -> 3;
lev_to_skill_num(_Step) -> 2.

%% 技能级别
skill_craft(#demon_skill{craft = Craft}) -> Craft;
skill_craft(_) -> 0.

%% @spec select_skill(Mode, SelectId, DemonId, Role) -> {ok, NewRole} | {false, Msg}
%% @doc 选择并操作刷新的技能、背包的技能
%% 选择直接学习
select_skill(1, SelectId, DemonId, Role = #role{demon = RoleDemon = #role_demon{step = Step, bag = Demons, skill_polish = PolishList}}) ->
    case lists:keyfind(DemonId, #demon.id, Demons) of
        false -> {false, ?L(<<"不存在该守护">>)};
        D = #demon{name = Dname, skills = Skills} ->
            case lists:keyfind(SelectId, 1, PolishList) of
                false -> {false, ?L(<<"未找到该技能">>)};
                {SelectId, Sid} ->
                    DemonSkill = demon_data:get_skill(Sid),
                    DemonCraft = skill_craft(DemonSkill),
                    case check_study(DemonId, DemonSkill, Skills) of
                        {false, Msg} -> {false, Msg};
                        {true, SkillInfo} ->
                            NewSkills = study_skill(DemonSkill, SkillInfo, Skills),
                            NewD = D#demon{skills = NewSkills},
                            NewRD = RoleDemon#role_demon{bag = update_demon(NewD, Demons), skill_polish = [], luck_coin = 0, luck_gold = 0},
                            log:log(log_demon_update, {<<"直接学习">>, util:fbin(<<"选择[~s]，覆盖升级">>, [get_skill_name(Sid)]), RoleDemon, NewRD, Role}),
                            demon_api:pack_and_send(17201, NewD, Role),
                            demon_api:pack_and_send(17225, NewRD, Role),
                            campaign_listener:handle(demon_skill_step, Role, DemonCraft),  %% 后台活动
                            Msg = util:fbin(?L(<<"~s成功学习[~s]">>), [Dname, get_skill_name(Sid)]),
                            {ok, Msg, Role#role{demon = NewRD}};
                        true ->
                            case lev_to_skill_num(Step) > length(Skills) of
                                false -> {false, ?L(<<"您的技能格子数不够，需要先提升守护精灵的等级">>)};
                                true ->
                                    NewSkills = study_skill(DemonSkill, Skills),
                                    NewD = D#demon{skills = NewSkills},
                                    NewRD = RoleDemon#role_demon{bag = update_demon(NewD, Demons), skill_polish = [], luck_coin = 0, luck_gold = 0},
                                    log:log(log_demon_update, {<<"直接学习">>, util:fbin(<<"选择第~w项[~s]">>, [SelectId, get_skill_name(Sid)]), RoleDemon, NewRD, Role}),
                                    demon_api:pack_and_send(17201, NewD, Role),
                                    demon_api:pack_and_send(17225, NewRD, Role),
                                    campaign_listener:handle(demon_skill_step, Role, DemonCraft),  %% 后台活动
                                    Msg = util:fbin(?L(<<"~s成功学习[~s]">>), [Dname, get_skill_name(Sid)]),
                                    {ok, Msg, Role#role{demon = NewRD}}
                            end
                    end
            end
    end;
%% 放入背包
select_skill(2, SelectId, _, Role = #role{demon = RoleDemon = #role_demon{op_id = MaxOpId, skill_bag = SkillBag, skill_polish = PolishList}}) ->
    case length(SkillBag) >= ?SKILL_BAG_MAX of
        true -> {false, ?L(<<"您的守护神通背包已满，无法继续放入神通秘籍">>)};
        false ->
            case lists:keyfind(SelectId, 1, PolishList) of
                false -> {false, ?L(<<"未找到该技能">>)};
                {SelectId, Sid} ->
                    NewSkillBag = [{MaxOpId, Sid} | SkillBag],
                    NewRD = RoleDemon#role_demon{op_id = MaxOpId+1, skill_bag = NewSkillBag, skill_polish = [], luck_coin = 0, luck_gold = 0},
                    log:log(log_demon_update, {<<"放入背包">>, util:fbin(<<"选择~w项[~s]">>, [SelectId, get_skill_name(Sid)]), RoleDemon, NewRD, Role}),
                    demon_api:pack_and_send(17228, NewSkillBag, Role),
                    demon_api:pack_and_send(17225, NewRD, Role),
                    {ok, Role#role{demon = NewRD}}
            end
    end;
%% 学习背包技能
select_skill(3, SelectId, DemonId, Role = #role{demon = RoleDemon = #role_demon{step = Step, skill_bag = SkillBag, bag = Demons}}) ->
    case lists:keyfind(DemonId, #demon.id, Demons) of
        false -> {false, ?L(<<"不存在该守护">>)};
        D = #demon{name = Dname, skills = Skills} ->
            case lists:keyfind(SelectId, 1, SkillBag) of
                false -> {false, ?L(<<"未找到该技能">>)};
                {SelectId, Sid} ->
                    DemonSkill = demon_data:get_skill(Sid),
                    DemonCraft = skill_craft(DemonSkill),
                    case check_study(DemonId, DemonSkill, Skills) of
                        {false, Msg} -> {false, Msg};
                        {true, SkillInfo} ->
                            ?DEBUG("SELECT ID: ~w  DemonId:~w, SELECT INFO: ~w, DemonSkill:~w", [SelectId, DemonId, SkillInfo, DemonSkill]),
                            NewSkills = study_skill(DemonSkill, SkillInfo, Skills),
                            NewD = D#demon{skills = NewSkills},
                            NewSkillBag = lists:keydelete(SelectId, 1, SkillBag),
                            NewRD = RoleDemon#role_demon{bag = update_demon(NewD, Demons), skill_bag = NewSkillBag},
                            log:log(log_demon_update, {<<"学习背包技能">>, util:fbin(<<"学习[~s]，覆盖升级">>, [get_skill_name(Sid)]), RoleDemon, NewRD, Role}),
                            demon_api:pack_and_send(17201, NewD, Role),
                            demon_api:pack_and_send(17228, NewSkillBag, Role),
                            campaign_listener:handle(demon_skill_step, Role, DemonCraft),  %% 后台活动
                            Msg = util:fbin(?L(<<"~s成功学习[~s]">>), [Dname, get_skill_name(Sid)]),
                            {ok, Msg, Role#role{demon = NewRD}};
                        true ->
                            case lev_to_skill_num(Step) > length(Skills) of
                                false -> {false, ?L(<<"您的技能格子数不够，需要先提升守护精灵的等级">>)};
                                true ->
                                    NewSkills = study_skill(DemonSkill, Skills),
                                    NewD = D#demon{skills = NewSkills},
                                    NewSkillBag = lists:keydelete(SelectId, 1, SkillBag),
                                    NewRD = RoleDemon#role_demon{bag = update_demon(NewD, Demons), skill_bag = NewSkillBag},
                                    log:log(log_demon_update, {<<"学习背包技能">>, util:fbin(<<"学习[~s]">>, [get_skill_name(Sid)]), RoleDemon, NewRD, Role}),
                                    campaign_listener:handle(demon_skill_step, Role, DemonCraft),  %% 后台活动
                                    demon_api:pack_and_send(17201, NewD, Role),
                                    demon_api:pack_and_send(17228, NewSkillBag, Role),
                                    Msg = util:fbin(?L(<<"~s成功学习[~s]">>), [Dname, get_skill_name(Sid)]),
                                    {ok, Msg, Role#role{demon = NewRD}}
                            end
                    end
            end
    end.

%% @spec forget_skill(DemonId, SkillId, Role) -> {ok, NewRole} | {false, Msg}
%% @doc 遗忘技能
%% 丢弃背包技能
forget_skill(0, OpId, Role = #role{demon = RoleDemon = #role_demon{skill_bag = SkillBag}}) ->
    case lists:keyfind(OpId, 1, SkillBag) of
        false -> {false, ?L(<<"未找到该技能">>)};
        {OpId, Sid} ->
            NewSkillBag = lists:keydelete(OpId, 1, SkillBag),
            NewRD = RoleDemon#role_demon{skill_bag = NewSkillBag},
            log:log(log_demon_update, {<<"丢弃技能">>, util:fbin(<<"~s">>, [get_skill_name(Sid)]), RoleDemon, NewRD, Role}),
            demon_api:pack_and_send(17228, NewSkillBag, Role),
            {ok, Role#role{demon = NewRD}}
    end;
%% 遗忘已学技能
forget_skill(DemonId, SkillId, Role = #role{demon = RoleDemon = #role_demon{bag = Demons}}) ->
    case lists:keyfind(DemonId, #demon.id, Demons) of
        false -> {false, ?L(<<"不存在该守护">>)};
        D = #demon{skills = Skills} ->
            case lists:keyfind(SkillId, 1, Skills) of
                false -> {false, ?L(<<"未找到该技能">>)};
                {_, _Step, _Exp} ->
                    NewSkills = lists:keydelete(SkillId, 1, Skills),
                    NewD = D#demon{skills = NewSkills},
                    NewRD = RoleDemon#role_demon{bag = update_demon(NewD, Demons)},
                    log:log(log_demon_update, {<<"遗忘技能">>, util:fbin(<<"~s">>, [get_skill_name(SkillId)]), RoleDemon, NewRD, Role}),
                    demon_api:pack_and_send(17201, NewD, Role),
                    {ok, Role#role{demon = NewRD}}
            end
    end.

%% @spec up_skill(DemonId, SkillId, Role) -> {ok, NewRole} | {false, Msg}
%% @doc 升级技能
up_skill(DemonId, SkillId, Role = #role{demon = RoleDemon = #role_demon{bag = Demons}}) ->
    case lists:keyfind(DemonId, #demon.id, Demons) of
        false -> {false, ?L(<<"未找到该精灵守护">>)};
        D = #demon{skills = Skills} ->
            case lists:keyfind(SkillId, 1, Skills) of
                false -> {false, ?L(<<"未找到该精灵守护神通">>)};
                {_Sid, Step, _Exp} when Step >= ?SKILL_STEP_MAX -> {false, ?L(<<"该神通已升级至最高级">>)};
                {Sid, _Step, Exp} ->
                    LL = [#loss{label = item, val = [id_to_up_item(DemonId), 1, 1], msg = ?L(<<"神通升级需要守护本源，背包未找到">>)}],
                    case role_gain:do(LL, Role) of
                        {false, #loss{msg = Msg}} -> {false, Msg};
                        {ok, Role1} ->
                            case (Exp >= demon_data:get_skill_exp(Sid)) of
                                false -> {false, ?L(<<"该神通经验值未满">>)};
                                true -> 
                                    case demon_data:get_skill(Sid) of
                                        #demon_skill{next_id = 0} -> {false, ?L(<<"该神通已升级至最高级了">>)};
                                        #demon_skill{step = Lv, next_id = NextId} ->
                                            NewD = D#demon{skills = lists:keyreplace(Sid, 1, Skills, {NextId, Lv+1, 0})},
                                            demon_api:pack_and_send(17201, NewD, Role),
                                            {ok, Role1#role{demon = RoleDemon#role_demon{bag = lists:keyreplace(DemonId, #demon.id, Demons, NewD)}}}
                                    end
                            end
                    end
            end
    end.

%% @spec activate(DemonId, Role) -> {ok, NewRole} | {false, Msg} | {ok}
%% @doc 激活守护
activate(DemonId, #role{demon = #role_demon{active = DemonId}}) ->
    {ok};
activate(DemonId, Role = #role{demon = RoleDemon = #role_demon{bag = Demons}}) ->
    case lists:keyfind(DemonId, #demon.id, Demons) of
        false -> {false, ?L(<<"未找到该精灵守护">>)};
        D = #demon{shape_skills = ShapeSkills, shape_lev = ShapeLev} ->
            NewRD = RoleDemon#role_demon{active = DemonId, attr = find_attrs(DemonId, Demons), shape_skills = ShapeSkills, shape_lev = ShapeLev},
            demon_api:pack_and_send(17202, NewRD, Role),
            demon_api:pack_and_send(17210, D, Role),
            {ok, role_api:push_attr(Role#role{demon = NewRD})}
    end.

%% @spec unactivate(DemonId, Role) -> {ok, NewRole} | {false, Msg} | {ok}
%% @doc 停止激活守护
unactivate(DemonId, Role = #role{demon = RoleDemon = #role_demon{active = DemonId, bag = Demons}}) ->
    case lists:keyfind(DemonId, #demon.id, Demons) of
        false -> {false, ?L(<<"未找到该精灵守护">>)};
        #demon{} ->
            NewRD = RoleDemon#role_demon{active = 0, attr = [], shape_skills = [], shape_lev = 0},
            demon_api:pack_and_send(17202, NewRD, Role),
            {ok, role_api:push_attr(Role#role{demon = NewRD})}
    end;
unactivate(_DemonId, _) ->
    {false, ?L(<<"已取消该精灵守护的激活">>)}.

%% ------------------------------------
%% @spec use_item({BaseId, Num}, Role) -> {ok, NewRole} | {false, Msg}
%% @doc 精灵守护道具直接使用
%% ------------------------------------
%% 守护之魂
use_item({BaseId, Num}, _Role)
when BaseId >= 27500 andalso BaseId =< 27504 andalso Num > 1 ->
    {false, ?L(<<"守护之魂很珍贵，不能批量使用">>)};
use_item({BaseId, _Num}, Role = #role{demon = RoleDemon = #role_demon{step = Step, bag = Demons}})
when BaseId >= 27500 andalso BaseId =< 27504 ->
    Demon = #demon{name = DemonName, id = Did} = get_demon(BaseId),
    case lists:keyfind(Did, #demon.id, Demons) of
        false when Demons =:= [] -> %% 增加守护，激活
            AL = recalc_attr(Did, [], Step),
            Craft = merge_craft(AL),
            NewDemon = Demon#demon{attr = AL, craft = Craft},
            NewRD = RoleDemon#role_demon{bag = [NewDemon | Demons]},
            NewRole = Role#role{demon = NewRD},
            log:log(log_demon_update, {<<"守护之魂">>, util:fbin(<<"使用增加守护[~w]并激活">>, [Did]), RoleDemon, NewRD, Role}),
            demon_api:pack_and_send(17201, NewDemon, Role),
            ProtoMsg = {?true, util:fbin(?L(<<"您成功使用守护之魂，~s的魂魄幽幽现身，承诺伴您共渡飞仙之路。">>), [DemonName])},
            case activate(Did, NewRole) of
                {ok, NewRole1} -> {ok, ProtoMsg, NewRole1};
                _ -> {ok, ProtoMsg, NewRole}
            end;
        false -> %% 增加守护
            AL = recalc_attr(Did, [], Step),
            Craft = merge_craft(AL),
            NewDemon = Demon#demon{attr = AL, craft = Craft},
            NewRD = RoleDemon#role_demon{bag = [NewDemon | Demons]},
            log:log(log_demon_update, {<<"守护之魂">>, util:fbin(<<"使用增加守护[~w]">>, [Did]), RoleDemon, NewRD, Role}),
            demon_api:pack_and_send(17201, NewDemon, Role),
            ProtoMsg = {?true, util:fbin(?L(<<"您成功使用守护之魂，~s的魂魄幽幽现身，承诺伴您共渡飞仙之路。">>), [DemonName])},
            {ok, ProtoMsg, Role#role{demon = NewRD}};
        #demon{skills = []} ->
            {false, ?L(<<"您当前激活的守护没有学习神通，守护之魂无法施法神通">>)};
        D = #demon{skills = SL} ->
            case add_skill_exp(?SKILL_EXP_STEP_SIZE, SL) of
                {false, Msg} -> {false, Msg};
                {ok, {Sid, NewExp, NewStep}, NewSL} -> %% 升级
                    NewDemon = D#demon{skills = NewSL},
                    NewRD = RoleDemon#role_demon{bag = update_demon(NewDemon, Demons)},
                    log:log(log_demon_update, {<<"技能升阶">>, util:fbin(<<"使用守护之魂，[~w]技能[~s]升至~w阶经验~w">>, [Did, get_skill_name(Sid), NewStep, NewExp]), RoleDemon, NewRD, Role}),
                    demon_api:pack_and_send(17201, NewDemon, Role),
                    ProtoMsg = {?true, util:fbin(?L(<<"您成功使用守护之魂，[~s]增加经验~w点，升至~w阶">>), [get_skill_name(Sid), ?SKILL_EXP_STEP_SIZE, NewStep])},
                    {ok, ProtoMsg, Role#role{demon = NewRD}};
                {ok, {Sid, NewExp}, NewSL} ->
                    NewDemon = D#demon{skills = NewSL},
                    NewRD = RoleDemon#role_demon{bag = update_demon(NewDemon, Demons)},
                    log:log(log_demon_update, {<<"守护之魂">>, util:fbin(<<"[~w]守护技能[~s]经验增加至~w">>, [Did, get_skill_name(Sid), NewExp]), RoleDemon, NewRD, Role}),
                    demon_api:pack_and_send(17201, NewDemon, Role),
                    ProtoMsg = {?true, util:fbin(?L(<<"您成功使用守护之魂，[~s]增加经验~w点">>), [get_skill_name(Sid), ?SKILL_EXP_STEP_SIZE])},
                    {ok, ProtoMsg, Role#role{demon = NewRD}}
            end
    end;
%% 守护水晶
use_item({BaseId, _Num}, #role{demon = #role_demon{step = Step}})
when BaseId =:= 27505 andalso Step >= ?DEMON_STEP_MAX ->
    {false, ?L(<<"您精灵守护已至最高阶">>)};
use_item({BaseId, _Num}, #role{demon = #role_demon{bag = []}})
when BaseId =:= 27505 ->
    {false, ?L(<<"您需要先激活一个守护精灵，才能使用守护水晶哦">>)};
use_item({BaseId, Num}, Role = #role{demon = RoleDemon = #role_demon{exp = Exp, step = Step}})
when BaseId =:= 27505 ->
    case can_upgrade(Step, Exp, ?STEP_EXP_STEP_SIZE*Num) of
        {NewStep, NewExp} when NewStep > Step -> %% 升级
            NewRD1 = RoleDemon#role_demon{exp = NewExp, step = NewStep},
            NewRD = refresh_all_demon(NewRD1),
            demon_api:pack_and_send(17200, NewRD, Role),
            demon_api:pack_and_send(17213, {Num, Step, NewStep}, Role),
            campaign_listener:handle(demon_lev, Role, Step, NewStep), %% 后台活动事件
            log:log(log_demon_update, {<<"守护升级">>, util:fbin(<<"吞噬水晶~w个，升至~w级">>, [Num, NewStep]), RoleDemon, NewRD, Role}),
            {ok, role_api:push_attr(Role#role{demon = NewRD})};
        {Step, NewExp} ->
            NewRD = RoleDemon#role_demon{exp = NewExp, step = Step},
            demon_api:pack_and_send(17202, NewRD, Role),
            demon_api:pack_and_send(17213, {Num, Step, Step}, Role),
            log:log(log_demon_update, {<<"守护喂养">>, util:fbin(<<"吞噬水晶~w个，经验增加至~w">>, [Num, NewExp]), RoleDemon, NewRD, Role}),
            {ok, Role#role{demon = NewRD}};
        _ ->
            {false, ?L(<<"物品使用出现异常">>)}
    end;
%% 守护本源
use_item({BaseId, _Num}, #role{demon = #role_demon{active = 0}})
when BaseId =:= 27507 ->
    {false, ?L(<<"您需要先激活一个守护精灵，才能使用守护本源增加神通经验哦">>)};
use_item({BaseId, Num}, _)
when BaseId =:= 27507 andalso Num > 1 ->
    {false, ?L(<<"守护本源很珍贵，不能批量使用">>)};
use_item({BaseId, _Num}, Role = #role{demon = RoleDemon = #role_demon{active = ActId, bag = Demons}})
when BaseId =:= 27507 ->
    case lists:keyfind(ActId, #demon.id, Demons) of
        false -> {false, ?L(<<"未找到该守护">>)};
        #demon{skills = []} -> {false, ?L(<<"您当前激活的守护没有神通，守护本源无法施法神通">>)};
        D = #demon{id = Did, skills = SL} ->
            ExpAdd = 10, %% 活动道具，增加10点经验
            case add_skill_exp(ExpAdd, SL) of
                {false, Msg} -> {false, Msg};
                {ok, {NewSid, NewExp, NewStep}, NewSL} ->
                    NewDemon = D#demon{skills = NewSL},
                    NewRD = RoleDemon#role_demon{bag = update_demon(NewDemon, Demons)},
                    log:log(log_demon_update, {<<"技能升阶">>, util:fbin(<<"使用守护本源，[~w]技能[~s]升至~w阶经验~w">>, [Did, get_skill_name(NewSid), NewStep, NewExp]), RoleDemon, NewRD, Role}),
                    demon_api:pack_and_send(17201, NewDemon, Role),
                    ProtoMsg = {?true, util:fbin(?L(<<"您成功使用守护本源，[~s]增加经验~w点，升至~w阶">>), [get_skill_name(NewSid), ExpAdd, NewStep])},
                    {ok, ProtoMsg, Role#role{demon = NewRD}};
                {ok, {NewSid, NewExp}, NewSL} ->
                    NewDemon = D#demon{skills = NewSL},
                    NewRD = RoleDemon#role_demon{bag = update_demon(NewDemon, Demons)},
                    log:log(log_demon_update, {<<"使用本源">>, util:fbin(<<"[~w]守护技能[~s]经验增加至~w">>, [Did, get_skill_name(NewSid), NewExp]), RoleDemon, NewRD, Role}),
                    demon_api:pack_and_send(17201, NewDemon, Role),
                    ProtoMsg = {?true, util:fbin(?L(<<"您成功使用守护本源，[~s]增加经验~w点">>), [get_skill_name(NewSid), ExpAdd])},
                    {ok, ProtoMsg, Role#role{demon = NewRD}}
            end
    end;
use_item(_I, _Role) ->
    ?DEBUG("USE ITEM:~w", [_I]),
    {false, ?L(<<"此精灵守护道具不可以直接使用">>)}.

%% @spec feed(Role) -> {false, Msg} | {ok, NewRole}
%% @doc 喂养
feed(#role{demon = #role_demon{step = Step}})
when Step >= ?DEMON_STEP_MAX ->
    {false, ?L(<<"守护已达最高阶">>)};
feed(#role{demon = #role_demon{bag = []}}) ->
    {false, ?L(<<"您需要先激活一个守护精灵，才能使用守护水晶哦">>)};
feed(Role = #role{demon = RoleDemon = #role_demon{exp = Exp, step = Step}}) ->
    LL = [#loss{label = item, val = [27505, 1, 1], msg = ?L(<<"背包没有守护水晶">>)}],
    case role_gain:do(LL, Role) of
        {false, #loss{msg = Msg}} -> {false, Msg};
        {ok, Role1} ->
            log:log(log_item_del_loss, {<<"守护吞噬">>, Role}),
            NewExp = round(Exp + ?STEP_EXP_STEP_SIZE),
            case NewExp - demon_data:get_exp(Step) of
                NowE when NowE >= 0 -> %% 升级
                    NewRD1 = RoleDemon#role_demon{exp = NowE, step = Step+1},
                    NewRD = refresh_all_demon(NewRD1),
                    demon_api:pack_and_send(17200, NewRD, Role),
                    demon_api:pack_and_send(17213, {1, Step, Step+1}, Role),
                    campaign_listener:handle(demon_lev, Role, Step, Step + 1),  %% 后台活动事件
                    log:log(log_demon_update, {<<"守护升级">>, util:fbin(<<"守护升至~w级">>, [Step+1]), RoleDemon, NewRD, Role}),
                    {ok, role_api:push_attr(Role1#role{demon = NewRD})};
                _ ->
                    NewRD = RoleDemon#role_demon{exp = NewExp, step = Step},
                    demon_api:pack_and_send(17202, NewRD, Role),
                    demon_api:pack_and_send(17213, {1, Step, Step}, Role),
                    log:log(log_demon_update, {<<"守护喂养">>, util:fbin(<<"守护经验增加至~w">>, [NewExp]), RoleDemon, NewRD, Role}),
                    {ok, Role1#role{demon = NewRD}}
            end
    end.

%% @spec add_intimacy(DemonId, ItemList, Role) -> {ok, NowInti, NewRole} | {false, Msg}
%% ItemList = [{ItemId, Num} | ...]
%% @doc 增加精灵守护亲密度
add_intimacy(_DemonId, _ItemList, #role_demon{step = Step}) when Step < 30 ->
    {false, ?L(<<"精灵守护等阶还不满30阶，不能增加亲密度">>)};
add_intimacy(DemonId, ItemList, Role = #role{bag = #bag{items = Items}, demon = RoleDemon}) ->
    {BaseList, IdList} = storage_api:check_items_to_feed(ItemList, Items, [], []),
    LL = [#loss{label = item_id, val = IdList, msg = ?L(<<"物品扣除出错">>)}],
    case role_gain:do(LL, Role) of
        {false, #loss{msg = Msg}} -> {false, Msg};
        {ok, Role1} ->
            case do_add_intimacy(DemonId, RoleDemon, BaseList) of
                {false, Msg} -> {false, Msg};
                {ok, NowInti, NewRoleDemon} ->
                    log:log(log_item_del_loss, {<<"守护亲密">>, Role1}),
                    log:log(log_demon_update, {<<"守护亲密">>, util:fbin(<<"[~w]增加亲密至~w">>, [DemonId, NowInti]), RoleDemon, NewRoleDemon, Role1}),
                    {ok, NowInti, Role1#role{demon = NewRoleDemon}}
            end
    end.

%% @spec follow(DemonId, Role) -> {ok, NewRole} | {false, Msg}
%% @doc 选择守护跟随
%% <div> 增加守护BUFF & 守护模型跟随
follow(DemonId, #role{demon = #role_demon{follow = DemonId}}) ->
    {false, ?L(<<"该守护当前已在跟随中">>)};
follow(DemonId, Role = #role{demon = RoleDemon = #role_demon{bag = Demons}, looks = Looks}) ->
    case lists:keyfind(DemonId, #demon.id, Demons) of
        false -> {false, ?L(<<"未找到该守护">>)};
        #demon{intimacy = Inti} when Inti < 5000 ->
            {false, ?L(<<"该守护亲密值未达到5000，无法跟随">>)};
        D = #demon{intimacy = Inti} ->
            BuffLabel = inti_to_buff(Inti),
            case buff:add(Role, BuffLabel) of
                {false, Msg} -> {false, Msg};
                {ok, Role1} ->
                    NewInti = Inti - 10,
                    NewD = D#demon{intimacy = NewInti},
                    NewRD = RoleDemon#role_demon{follow = DemonId, bag = update_demon(NewD, Demons)},
                    Role2 = Role1#role{demon = NewRD, looks = add_looks({?LOOKS_TYPE_DEMON, 0, to_looks_val(DemonId)}, Looks)},
                    log:log(log_demon_update, {<<"守护跟随">>, util:fbin(<<"亲密减为~w">>, [NewInti]), RoleDemon, NewRD, Role}),
                    demon_api:pack_and_send(17201, NewD, Role),
                    map:role_update(Role2),
                    {ok, role_api:push_attr(Role2)}
            end
    end.

%% 取消守护跟随
unfollow(Role = #role{action = ?action_sit_demon}) ->
    unfollow(sit:handle_sit(?action_no, Role)); %% 先取消守护双修状态
unfollow(Role = #role{demon = RoleDemon, looks = Looks}) ->
    NewLooks = lists:keydelete(?LOOKS_TYPE_DEMON, 1, Looks),
    Role#role{demon = RoleDemon#role_demon{follow = 0}, looks = NewLooks}.

%% 增加跟随LOOKS
add_follow_looks(Role = #role{demon = #role_demon{follow = DemonId}, looks = Looks}) ->
    Role#role{looks = add_looks({?LOOKS_TYPE_DEMON, 0, to_looks_val(DemonId)}, Looks)}.

%% @spec both_sit(DemonId, Role) ->{ok, NewRole} | {false, Msg} 
%% @doc 守护双修
%% <div> 双修模块新增类型 </div>
both_sit(DemonId, #role{demon = #role_demon{follow = Did}}) when DemonId =/= Did ->
    {false, ?L(<<"该守护需要先打开跟随状态才可以进入双修">>)};
both_sit(DemonId, Role = #role{action = ?action_no, demon = #role_demon{bag = Demons}}) ->
    case lists:keyfind(DemonId, #demon.id, Demons) of
        false -> {false, ?L(<<"未找到该守护">>)};
        #demon{} ->
            {ok, sit:handle_sit(?action_sit_demon, Role)}
    end;
both_sit(DemonId, Role = #role{action = ?action_sit_demon, demon = #role_demon{bag = Demons}}) ->
    case lists:keyfind(DemonId, #demon.id, Demons) of
        false -> {false, ?L(<<"未找到该守护">>)};
        #demon{} ->
            {ok, sit:handle_sit(?action_no, Role)}
    end;
both_sit(DemonId, Role = #role{action = Action})
when Action >= ?action_sit_both andalso Action =< ?action_sit_lovers ->
    both_sit(DemonId, sit:handle_sit(?action_no, Role)); %% 已经打坐或者双修状态中，则先取消
both_sit(_DemonId, _Role) ->
    {false, ?L(<<"您现在不能进行守护双修">>)}.

%% 精灵守护双修的双修倍数
both_exp_ratio() -> 10.

%% 精灵守护双修增加looks外观
add_both_looks(Looks, #role{demon = #role_demon{follow = Did}}) ->
    [{?LOOKS_TYPE_DEMON_BOTH, 0, to_looks_val(Did)} | Looks].

%% 精灵守护化形进阶
upgrade_shape(#role{demon = #role_demon{step = Step}}, _DemonId) when Step < 15 ->
    step_lower;
upgrade_shape(Role = #role{demon = RD = #role_demon{active = ActId, bag = Bag}}, DemonId) ->
    case lists:keyfind(DemonId, #demon.id, Bag) of
        %% 最高阶
        #demon{shape_lev = ?SHAPE_MAX_LEV} ->
            max_lev;
        %% 已激活的守卫化形进阶成功
        D = #demon{id = ActId, shape_lev = ShapeLev, shape_luck = Luck, shape_max_luck = MaxLuck} when Luck >= MaxLuck ->
            NewShapeLev = ShapeLev + 1,
            NewMaxLuck = get_shape_max_luck(NewShapeLev),
            Skills = get_shape_skills(DemonId, NewShapeLev),
            NewD = D#demon{shape_lev = NewShapeLev, 
                shape_luck = 0, 
                shape_max_luck = NewMaxLuck, 
                shape_skills = Skills},
            campaign_listener:handle(demon_shape_lev, Role, ShapeLev, NewShapeLev), %% 后台活动事件
            NewBag = lists:keyreplace(DemonId, #demon.id, Bag, NewD),
            demon_api:pack_and_send(17201, NewD, Role),
            {up, NewShapeLev, Role#role{demon = RD#role_demon{bag = NewBag, shape_skills = Skills, shape_lev = NewShapeLev}}};
        %% 未激活的守卫化形进阶成功
        D = #demon{shape_lev = ShapeLev, shape_luck = Luck, shape_max_luck = MaxLuck} when Luck >= MaxLuck ->
            NewShapeLev = ShapeLev + 1,
            NewMaxLuck = get_shape_max_luck(NewShapeLev),
            Skills = get_shape_skills(DemonId, NewShapeLev),
            NewD = D#demon{shape_lev = NewShapeLev, shape_luck = 0, shape_max_luck = NewMaxLuck, shape_skills = Skills},
            NewBag = lists:keyreplace(DemonId, #demon.id, Bag, NewD),
            demon_api:pack_and_send(17201, NewD, Role),
            campaign_listener:handle(demon_shape_lev, Role, ShapeLev, NewShapeLev), %% 后台活动事件
            {up, NewShapeLev, Role#role{demon = RD#role_demon{bag = NewBag}}};
        %% 只是增加化形值
        D = #demon{shape_lev = ShapeLev, shape_luck = Luck, shape_max_luck = MaxLuck} ->
            %% 化形丹id 33152
            CostNum = get_upgrade_item_cost(ShapeLev),
            case role_gain:do([#loss{label = item, val = [33152, 1, CostNum]}, #loss{label = coin_all, val = 1000}], Role) of
                {ok, NewRole} ->
                    case get_luck_ratio(ShapeLev + 1, Luck) >= util:rand(1, 100) of
                        true ->
                            NewD = D#demon{shape_luck = MaxLuck},
                            NewBag = lists:keyreplace(DemonId, #demon.id, Bag, NewD),
                            demon_api:pack_and_send(17201, NewD, Role),
                            {full, NewRole#role{demon = RD#role_demon{bag = NewBag}}};
                        _ ->
                            Rand = util:rand(1, 3),
                            case Rand + Luck of
                                Num when Num >= MaxLuck -> 
                                    NewD = D#demon{shape_luck = MaxLuck},
                                    NewBag = lists:keyreplace(DemonId, #demon.id, Bag, NewD),
                                    demon_api:pack_and_send(17201, NewD, Role),
                                    {full, NewRole#role{demon = RD#role_demon{bag = NewBag}}};
                                Num -> 
                                    NewD = D#demon{shape_luck = Num},
                                    NewBag = lists:keyreplace(DemonId, #demon.id, Bag, NewD),
                                    demon_api:pack_and_send(17201, NewD, Role),
                                    {ok, Rand, NewRole#role{demon = RD#role_demon{bag = NewBag}}}
                            end
                    end;
                {false, #loss{err_code = ?coin_all_less}} ->
                    coin_less;
                _ ->
                    item_less
            end;
        _ ->
            demon_not_found
    end.


%% ----------------------------------------------------
%% GM 方法
%% ----------------------------------------------------

gm_set_step(Step, Role) when Step > 100 ->
    Role;
gm_set_step(Step, Role = #role{demon = RoleDemon}) ->
    NewRD = refresh_all_demon(RoleDemon#role_demon{step = Step}),
    demon_api:pack_and_send(17200, NewRD, Role),
    Role#role{demon = NewRD}.

gm_set_skill_lev(Slv, Role = #role{demon = RoleDemon = #role_demon{active = ActId, bag = Demons}}) ->
    case lists:keyfind(ActId, #demon.id, Demons) of
        false -> {false, ?L(<<"未激活">>)};
        D = #demon{skills = SL} ->
            NewSL = gm_set_lev(Slv, SL),
            NewD = D#demon{skills = NewSL},
            demon_api:pack_and_send(17201, NewD, Role),
            NewRD = RoleDemon#role_demon{bag = lists:keyreplace(ActId, #demon.id, Demons, NewD)},
            Role#role{demon = NewRD}
    end.
gm_set_lev(NewLv, SL) ->
    gm_set_lev(NewLv, SL, []).
gm_set_lev(_, [], L) -> L;
gm_set_lev(NewLv, [{Sid, NewLv, Exp} | T], L) ->
    gm_set_lev(NewLv, T, [{Sid, NewLv, Exp} | L]);
gm_set_lev(NewLv, [{Sid, Step, Exp} | T], L) when NewLv > Step ->
    #demon_skill{next_id = NextId} = demon_data:get_skill(Sid),
    #demon_skill{step = NextStep} = demon_data:get_skill(NextId),
    gm_set_lev(NewLv, [{NextId, NextStep, Exp} | T], L);
gm_set_lev(1 = NewLv, [{Sid, _Step, Exp} | T], L) ->
    #demon_skill{type = Type, craft = Craft} = demon_data:get_skill(Sid),
    StartSid = demon_data:get_skill_id(Type, Craft),
    #demon_skill{step = NextStep} = demon_data:get_skill(StartSid),
    gm_set_lev(NewLv, [{StartSid, NextStep, Exp} | T], L);
gm_set_lev(NewLv, [{Sid, _Step, Exp} | T], L) ->
    #demon_skill{type = Type, craft = Craft} = demon_data:get_skill(Sid),
    StartSid = demon_data:get_skill_id(Type, Craft), %% 从第一级开始
    #demon_skill{next_id = NextId} = demon_data:get_skill(StartSid),
    #demon_skill{step = NextStep} = demon_data:get_skill(NextId),
    gm_set_lev(NewLv, [{NextId, NextStep, Exp} | T], L).

%% 设置守护属性品质，默认针对当前激活的守护
gm_set_attr_craft(Craft, Role = #role{demon = RoleDemon = #role_demon{active = ActId, step = Step, bag = Demons}})
when Craft >= 1 andalso Craft =< 5 ->
    case lists:keyfind(ActId, #demon.id, Demons) of
        false -> {false, ?L(<<"未找到该精灵守护">>)};
        D = #demon{id = Did, attr = AL} ->
            NewAL = recalc_attr(Did, [{A, Craft, V, Lock} || {A, _, V, Lock} <- AL], Step),
            NewCraft = merge_craft(NewAL),
            NewD = D#demon{craft = NewCraft, attr = NewAL},
            NewRD = refresh_demon(NewD, RoleDemon),
            demon_api:pack_and_send(17201, NewD, Role),
            {ok, role_api:push_attr(Role#role{demon = NewRD})}
    end.

%% gm命令精灵守护化形进阶
gm_upgrade_shape(#role{demon = #role_demon{step = Step}}, _DemonId, _Lev) when Step < 15 ->
    step_lower;
        %% 最高阶
gm_upgrade_shape(_Role, _DemonId, Lev) when Lev > ?SHAPE_MAX_LEV ->
            max_lev;
gm_upgrade_shape(Role = #role{demon = RD = #role_demon{active = ActId, bag = Bag}}, DemonId, Lev) ->
    case lists:keyfind(DemonId, #demon.id, Bag) of
        %% 已激活的守卫化形进阶成功
        D = #demon{id = ActId, shape_lev = ShapeLev} ->
            NewShapeLev = Lev,
            NewMaxLuck = get_shape_max_luck(NewShapeLev),
            Skills = get_shape_skills(DemonId, NewShapeLev),
            NewD = D#demon{shape_lev = NewShapeLev, 
                shape_luck = 0, 
                shape_max_luck = NewMaxLuck, 
                shape_skills = Skills},
            campaign_listener:handle(demon_shape_lev, Role, ShapeLev, NewShapeLev), %% 后台活动事件
            NewBag = lists:keyreplace(DemonId, #demon.id, Bag, NewD),
            demon_api:pack_and_send(17201, NewD, Role),
            {up, NewShapeLev, Role#role{demon = RD#role_demon{bag = NewBag, shape_skills = Skills, shape_lev = NewShapeLev}}};
        %% 未激活的守卫化形进阶成功
        D = #demon{shape_lev = ShapeLev} ->
            NewShapeLev = ShapeLev + 1,
            NewMaxLuck = get_shape_max_luck(NewShapeLev),
            Skills = get_shape_skills(DemonId, NewShapeLev),
            NewD = D#demon{shape_lev = NewShapeLev, shape_luck = 0, shape_max_luck = NewMaxLuck, shape_skills = Skills},
            NewBag = lists:keyreplace(DemonId, #demon.id, Bag, NewD),
            demon_api:pack_and_send(17201, NewD, Role),
            campaign_listener:handle(demon_shape_lev, Role, ShapeLev, NewShapeLev), %% 后台活动事件
            {up, NewShapeLev, Role#role{demon = RD#role_demon{bag = NewBag}}};
        _ ->
            nothing
    end.

%% ----------------------------------------------------
%% 内部函数
%% ----------------------------------------------------

%% 解析守护背包
ver_parse_bag([], NewBag) -> NewBag;
ver_parse_bag([H | T], NewBag) ->
    ver_parse_bag(T, [do_ver_parse_bag(H) | NewBag]).

%% 解析子项
% do_ver_parse_bag({demon, 1 = Ver, Id, Name, Craft, Attrs, Skills, Inti}) ->
%     do_ver_parse_bag({demon, Ver+1, Id, Name, Craft, Attrs, Skills, Inti, []});
% do_ver_parse_bag({demon, 2 = Ver, Id, Name, Craft, Attrs, Skills, Inti, PolishList}) ->
%     do_ver_parse_bag({demon, Ver+1, Id, Name, Craft, Attrs, Skills, Inti, PolishList, 0, [], 0, get_shape_max_luck(0)});
% do_ver_parse_bag({demon, 3 = Ver, Id, Name, Craft, Attrs, Skills, Inti, PolishList, ShapeLev, ShapeSkills, ShapeLuck, ShapeMaxLuck}) ->
%     NewAL = [{A, C, V, ?false} || {A, C, V} <- Attrs],
%     Fun = fun(AFC) when is_list(AFC) ->
%             [{A, C, V, ?false} || {A, C, V} <- AFC];
%         (_) -> []
%     end,
%     NewPL = [{N, C, Fun(AFC)} || {N, C, AFC} <- PolishList],
%     do_ver_parse_bag({demon, Ver+1, Id, Name, Craft, NewAL, Skills, Inti, NewPL, ShapeLev, ShapeSkills, ShapeLuck, ShapeMaxLuck});
% do_ver_parse_bag(Demon = #demon{ver = ?DEMON_VER}) ->
%     Demon.

do_ver_parse_bag({demon2, 4 = Ver, Id, BaseId, Name, Mod, Craft, Lev, Exp, Grow, GrowMax, Bless, Debris, Debris_num, Devour,
                    Attack_type, Attr, Skills}) ->
    do_ver_parse_bag({demon2, Ver, Id, BaseId, Name, Mod, Craft, Lev, Exp, Grow, GrowMax, Bless, Debris, Debris_num, Devour,
                    Attack_type, Attr, #demon_ratio{}, Skills});
do_ver_parse_bag({demon2, 4 = Ver, Id, BaseId, Name, Mod, Craft, Lev, Exp, Grow, GrowMax, Bless, Debris, Debris_num, Devour,
                    Attack_type, Attr, Ratio, Skills}) ->
    do_ver_parse_bag({demon2, Ver, Id, BaseId, Name, Mod, Craft, Lev, Exp, Grow, GrowMax, Bless, Debris, Debris_num, Devour,
                    Attack_type, Attr, Ratio, Skills, []});
do_ver_parse_bag({demon2, 4 = Ver, Id, BaseId, Name, Mod, Craft, Lev, Exp, Grow, GrowMax, Bless, Debris, Debris_num, Devour,
                    Attack_type, Attr, Ratio, Skills, ExtAttr}) ->
    {demon2, Ver, Id, BaseId, Name, Mod, Craft, Lev, Exp, Grow, GrowMax, Bless, Debris, Debris_num, Devour,
                    Attack_type, Attr, Ratio, Skills, ExtAttr};
do_ver_parse_bag(0) -> 0.
%% 守护升级判断
can_upgrade(?DEMON_STEP_MAX, _, _) -> {?DEMON_STEP_MAX, 0}; %% 等级限制
can_upgrade(Lev, Now, Val) ->
    Need = demon_data:get_exp(Lev),
    case Now + Val >= Need of
        true ->
            can_upgrade(Lev + 1, 0, Now + Val - Need);
        false ->
            {Lev, Now + Val}
    end.

%% 随机增加技能经验 N 次
%% add_skill_exp(0, _ExpAdd, ChangeList, SL) -> 
%%     {ok, ChangeList, SL};
%% add_skill_exp(1, ExpAdd, _ChangeList, SL) -> 
%%     add_skill_exp(ExpAdd, SL);
%% add_skill_exp(Num, ExpAdd, ChangeList, SL) when Num > 0 ->
%%     case add_skill_exp(ExpAdd, SL) of
%%         {false, Msg} -> {false, Msg};
%%         {ok, {Sid, Exp}, NewSL} ->
%%             add_skill_exp(Num - 1, ExpAdd, [{Sid, Exp} | ChangeList], NewSL)
%%     end.
%% 随机增加技能经验
add_skill_exp(ExpAdd, SL) ->
    case [{Sid, Step, Exp} || {Sid, Step, Exp} <- SL, (Step < ?SKILL_STEP_MAX)] of
        [] -> {false, ?L(<<"该守护的所有技能均已升级至最高阶">>)};
        TL1 ->
            {Sid, Step, Exp} = util:rand_list(TL1),
            NewExp = (Exp + ExpAdd),
            case recalc_skill_lev(Sid, NewExp) of
                {Sid, _Step} ->
                    {ok, {Sid, NewExp}, lists:keyreplace(Sid, 1, SL, {Sid, Step, NewExp})};
                {NewSid, NewStep} -> %% 技能升级
                    {ok, {NewSid, NewExp, NewStep}, lists:keyreplace(Sid, 1, SL, {NewSid, NewStep, NewExp})};
                _ -> %% 异常，经验也加上
                    {ok, {Sid, NewExp}, lists:keyreplace(Sid, 1, SL, {Sid, Step, NewExp})}
            end
    end.

%% 更新精灵背包某个守护信息
update_demon(Demon = #demon{id = Did}, Demons) ->
    case lists:keyfind(Did, #demon.id, Demons) of
        false -> [Demon | Demons];
        _ ->
            lists:keyreplace(Did, #demon.id, Demons, Demon)
    end.

%% 更新所有精灵守护的信息(属性)
refresh_all_demon(RD = #role_demon{active = ActId, step = Step, bag = Demons}) ->
    NewDemons = [D#demon{attr = recalc_attr(Did, Attrs, Step)} || D = #demon{id = Did, attr = Attrs} <- Demons],
    RD#role_demon{attr = find_attrs(ActId, NewDemons), bag = NewDemons}.

%% 更新精灵守护的信息(属性)
refresh_demon(D = #demon{id = Did, attr = AL}, RD = #role_demon{active = ActId, bag = Demons}) ->
    NewDemons = lists:keyreplace(Did, #demon.id, Demons, D),
    case Did =:= ActId of
        true ->
            RD#role_demon{attr = AL, bag = NewDemons};
        false ->
            RD#role_demon{bag = NewDemons}
    end.

%% 重新计算精灵守护的attr
recalc_attr(DemonId, [], Step) ->
    AL =  demon_data:get_demon_attr(DemonId, Step),
    [{A, 1, round(craft_to_ratio(1) * V), ?false} || {A, V} <- AL]; %% 初始默认白色品质
recalc_attr(DemonId, Attrs, Step) when is_list(Attrs) ->
    AL =  demon_data:get_demon_attr(DemonId, Step),
    [{A, C, round(craft_to_ratio(C) * find_attr_base(A, AL)), Lock} || {A, C, _, Lock} <- Attrs].

%% 找到某属性的原始基础值
find_attr_base(_A, []) -> 0;
find_attr_base(A, [{A, V} | _]) -> V;
find_attr_base(A, [_ | T]) ->
    find_attr_base(A, T).

%% 找到对应ID守护的attr
find_attrs(Did, Demons) ->
    case lists:keyfind(Did, #demon.id, Demons) of
        false -> [];
        #demon{attr = Attr} -> Attr
    end.

%% 合并属性品质
merge_craft(Attr) ->
    Total = merge_craft(Attr, 0),
    if
        Total >= 8 andalso Total < 9 ->     1; %% 白
        Total >= 9 andalso Total < 10.5 ->  2;
        Total >= 10.5 andalso Total < 12 -> 3;
        Total >= 12 andalso Total < 13.6 -> 4;
        Total >= 13.6 andalso Total =< 16 ->5;
        true -> 1
    end.
merge_craft([], X) -> X;
merge_craft([{_, C, _, _} | T], X) ->
    merge_craft(T, craft_to_ratio(C) + X).

%% 品质转化系数
craft_to_ratio(1) -> 1;
craft_to_ratio(2) -> 1.2;
craft_to_ratio(3) -> 1.4;
craft_to_ratio(4) -> 1.7;
craft_to_ratio(5) -> 2;
craft_to_ratio(_) -> 1.

%% 亲密度转化buff名
inti_to_buff(Inti) when Inti >= 30000 ->    demon_4;
inti_to_buff(Inti) when Inti >= 20000 ->    demon_3;
inti_to_buff(Inti) when Inti >= 10000 ->    demon_2;
inti_to_buff(Inti) when Inti >= 5000 ->     demon_1;
inti_to_buff(_Inti) -> demon_1.

%% 锁数量对应的洗髓概率分布
get_rand_form(0) -> [{2, 300}, {3, 265}, {4, 100}, {5, 15}, {1, 320}];
get_rand_form(1) -> [{2, 290}, {3, 270}, {4, 97}, {5, 13} , {1, 330}];
get_rand_form(2) -> [{2, 280}, {3, 290}, {4, 80}, {5, 10} , {1, 340}];
get_rand_form(3) -> [{2, 280}, {3, 292}, {4, 70}, {5, 8}  , {1, 350}];
get_rand_form(4) -> [{2, 270}, {3, 315}, {4, 50}, {5, 5}  , {1, 360}];
get_rand_form(5) -> [{2, 260}, {3, 337}, {4, 30}, {5, 3}  , {1, 370}];
get_rand_form(6) -> [{2, 260}, {3, 338}, {4, 20}, {5, 2}  , {1, 380}];
get_rand_form(7) -> [{2, 250}, {3, 349}, {4, 10}, {5, 1}  , {1, 390}];
get_rand_form(_) -> [].
%% 垃圾属性安慰概率
%% 法力、防御
get_rand_form_rubbish() -> [{1, 300},{2, 300},{3, 200},{4, 150},{5, 50}].

%% 洗练一组属性
polish_rand_attr([], AL, _L) -> AL; %% 随机列表为空，取消随机
polish_rand_attr(_Form, [], L) -> L;
polish_rand_attr(Form, [{A, _, V, ?false} | T], L) when A =:= mp_max orelse A =:= defence ->
    C = do_rand(get_rand_form_rubbish(), util:rand(1, 1000)),
    polish_rand_attr(Form, T, [{A, C, V, ?false} | L]);
polish_rand_attr(Form, [{A, _, V, ?false} | T], L) ->
    C = do_rand(Form, util:rand(1, 1000)),
    polish_rand_attr(Form, T, [{A, C, V, ?false} | L]);
polish_rand_attr(Form, [{A, C, V, Lock} | T], L) ->
    polish_rand_attr(Form, T, [{A, C, V, Lock} | L]). %% 已锁的属性保留

%% 批量随机一组属性
batch_polish_rand_attr(RandList, DemonId, Step, AL) ->
    batch_polish_rand_attr(RandList, DemonId, Step, AL, [], 6).
batch_polish_rand_attr(_RandList, _DemonId, _Step, _AL, L, 0) -> L;
batch_polish_rand_attr(RandList, DemonId, Step, AL, L, N) ->
    Attrs = polish_rand_attr(RandList, AL, []),
    NewAttrs = recalc_attr(DemonId, Attrs, Step),
    NewCraft = merge_craft(NewAttrs),
    batch_polish_rand_attr(RandList, DemonId, Step, AL, [{N, NewCraft, NewAttrs} | L], N-1).

%% 洗髓品质
do_rand([{C, _}], _) -> C;
do_rand([{C, R} | T], Rand) ->
    case Rand =< R of
        true -> C;
        false -> do_rand(T, Rand - R)
    end.

%% 根据守护ID判断技能升级道具ID
id_to_up_item(1) -> 27507;
id_to_up_item(2) -> 27508;
id_to_up_item(3) -> 27509;
id_to_up_item(4) -> 27510;
id_to_up_item(5) -> 27511.

%% 计算增加的亲密度
calc_intimacy([], N) -> N;
calc_intimacy([{BaseId, Num} | T], N) ->
    case item_data:get(BaseId) of
        {ok, #item_base{value = ValList}} ->
            Add = case lists:keyfind(intimate, 1, ValList) of
                false -> 0;
                {_, V} -> V
            end,
            calc_intimacy(T, N + Add*Num);
        _ -> calc_intimacy(T, N)
    end.

%% 增加亲密度
do_add_intimacy(_DemonId, _RoleDemon, []) -> {false, ?L(<<"未选择扣除物品">>)};
do_add_intimacy(DemonId, RoleDemon = #role_demon{bag = Demons}, BaseL) ->
    case lists:keyfind(DemonId, #demon.id, Demons) of
        false -> {false, ?L(<<"未找到该精灵守护">>)};
        D = #demon{intimacy = Inti} ->
            AddIntimate = calc_intimacy(BaseL, 0),
            NewDemons = lists:keyreplace(DemonId, #demon.id, Demons, D#demon{intimacy = Inti+AddIntimate}),
            {ok, Inti+AddIntimate, RoleDemon#role_demon{bag = NewDemons}}
    end.

%% 增加守护跟随模型
add_looks(Look, Looks) ->
    add_looks(Look, Looks, []).
add_looks(Look, [], L) ->
    [Look | L];
add_looks(Look, [{?LOOKS_TYPE_DEMON, _, _} | T], L) ->
    add_looks(Look, T, L);
add_looks(Look, [H | T], L) ->
    add_looks(Look, T, [H | L]).

%% 检查当前buff列表是否有守护跟随buff
% check_demon_buff(_Role, []) -> false;
% check_demon_buff(Role, [Label | T]) ->
%     case buff:check_buff(Role, Label) of
%         false ->
%             check_demon_buff(Role, T);
%         _ ->
%             true
%     end.

%% 守护类型转化为外观值ID
to_looks_val(1) -> 10;
to_looks_val(2) -> 20;
to_looks_val(3) -> 30;
to_looks_val(4) -> 40;
to_looks_val(5) -> 50;
to_looks_val(_) -> 50.

%% 随机刷新技能
rand_skill(_, [], _) -> [];
rand_skill(_, _, []) -> [];
rand_skill(Num, TL, CL) ->
    TypeTotal = lists:sum([V || {_, V} <- TL]),
    CraftTotal = lists:sum([V || {_, V} <- CL]),
    rand_skill(Num, TypeTotal, CraftTotal, TL, CL, []).
rand_skill(0, _, _, _, _, L) -> L;
rand_skill(Num, TT, CT, TL, CL, L) ->
    Type = do_rand(TL, util:rand(1, TT)),
    Craft = do_rand(CL, util:rand(1, CT)),
    Sid = demon_data:get_skill_id(Type, Craft),
    rand_skill(Num-1, TT, CT, TL, CL, [{Num, Sid} | L]).

%% 检查守护是否可以学习:
%% 1、是否是当前守护限制学习的技能
%% 2、是否已学习过同类型技能 -> 同类型基础技能是否已学
check_study(_DemonId, false, _Skills) ->
    {false, ?L(<<"无法学习该技能">>)};
check_study(DemonId, #demon_skill{craft = C, type = T, limit = LimitList}, Skills) ->
    case lists:member(DemonId, LimitList) of
        true -> {false, ?L(<<"当前属性的守护无法学习该技能">>)};
        false ->
            check_study_craft(T, C, Skills)
    end.

check_study_craft(_T, C, []) when C > 1 ->
    {false, ?L(<<"您需要先学习该类型技能的初级技能">>)};
check_study_craft(_T, _C, []) ->
    true;
check_study_craft(Type, Craft, [SkillInfo = {Sid, _, _} | T]) ->
    case demon_data:get_skill(Sid) of
        #demon_skill{type = Type, craft = C1} when Craft =< C1 -> {false, ?L(<<"您必须用更高级品质技能才能覆盖低级技能">>)};
        #demon_skill{type = Type, craft = C1} when Craft =:= C1 + 1 -> {true, SkillInfo};
        #demon_skill{type = Type} -> {false, ?L(<<"您必须按照技能品质顺序，先学习低一级技能才能覆盖">>)};
        _ -> check_study_craft(Type, Craft, T)
    end.

%% 学习技能
study_skill(#demon_skill{id = Sid, step = Step}, Skills) ->
    [{Sid, Step, 0} | Skills].
%% 合并技能(经验)
study_skill(#demon_skill{id = Sid}, {SkillId, _, Exp}, Skills) ->
    case recalc_skill_lev(Sid, Exp) of
        {NewSid, NewStep} ->
            lists:keyreplace(SkillId, 1, Skills, {NewSid, NewStep, Exp});
        _E ->
            Skills
    end.

%% 重新计算技能等级
recalc_skill_lev(Sid, Exp) ->
    case demon_data:get_skill(Sid) of
        #demon_skill{id = Sid, step = Step, exp = ExpNeed} when ExpNeed > Exp ->
            {Sid, Step};
        #demon_skill{id = Sid, step = Step, next_id = 0} ->
            {Sid, Step}; %% 已是最高级
        #demon_skill{next_id = NextId} ->
            recalc_skill_lev(NextId, Exp);
        _E ->
            ?ERR("Sid:~w, Exp:~w _E:~w", [Sid, Exp, _E]),
            false
    end.

%% 获取技能名称
get_skill_name(SkillId) ->
    case demon_data:get_skill(SkillId) of
        #demon_skill{name = Name} -> Name;
        _ -> <<>>
    end.

%% 根据物品ID对应生成守护
get_demon(27500) ->
    
    #demon{
        id = 1, name = ?L(<<"剑舞倾城">>), craft = 1,
        skills = [
            {86000, 1, 0}
            ,{util:rand_list([86500, 86600]), 1, 0}
        ]};
get_demon(27501) ->
    #demon{
        id = 2, name = ?L(<<"弓腰姬">>), craft = 1,
        skills = [
            {86100, 1, 0}
            ,{util:rand_list([86500, 86600]), 1, 0}
        ]};
get_demon(27502) ->
    #demon{
        id = 3, name = ?L(<<"玲珑仙子">>), craft = 1,
        skills = [
            {86200, 1, 0}
            ,{util:rand_list([86500, 86600]), 1, 0}
        ]};
get_demon(27503) ->
    #demon{
        id = 4, name = ?L(<<"俏飞凰">>), craft = 1,
        skills = [
            {86300, 1, 0}
            ,{util:rand_list([86500, 86600]), 1, 0}
        ]};
get_demon(27504) ->
    #demon{
        id = 5, name = ?L(<<"梦语琴心">>), craft = 1,
        skills = [
            {86400, 1, 0}
            ,{util:rand_list([86500, 86600]), 1, 0}
        ]}.

%% 获取精灵化形所需幸运值
get_shape_max_luck(0) ->
    30;
get_shape_max_luck(1) ->
    60;
get_shape_max_luck(2) ->
    120;
get_shape_max_luck(3) ->
    150;
get_shape_max_luck(4) ->
    200;
get_shape_max_luck(5) ->
    250;
get_shape_max_luck(6) ->
    250;
get_shape_max_luck(7) ->
    300;
get_shape_max_luck(8) ->
    400;
get_shape_max_luck(9) ->
    400;
get_shape_max_luck(10) ->
    400.

%% 各等级对应技能
get_shape_skills(Id, Lev) when is_integer(Id) =/= true orelse is_integer(Lev) =/= true ->
    [];
get_shape_skills(Id, 10) ->
    Skill = lists:nth(5, erlang:element(Id, ?DEMON_SHAPE_SKILLS)),
    [Skill];
get_shape_skills(Id, Lev) when Lev >= 8 ->
    Skill = lists:nth(4, erlang:element(Id, ?DEMON_SHAPE_SKILLS)),
    [Skill];
get_shape_skills(Id, Lev) when Lev >= 6 ->
    Skill = lists:nth(3, erlang:element(Id, ?DEMON_SHAPE_SKILLS)),
    [Skill];
get_shape_skills(Id, Lev) when Lev >= 3 ->
    Skill = lists:nth(2, erlang:element(Id, ?DEMON_SHAPE_SKILLS)),
    [Skill];
get_shape_skills(Id, Lev) when Lev >= 1 ->
    Skill = lists:nth(1, erlang:element(Id, ?DEMON_SHAPE_SKILLS)),
    [Skill];
get_shape_skills(_Id, _Lev) ->
    [].

%% 获取守护化形进阶的成功概率
get_luck_ratio(1, Luck) when Luck >= 0 andalso Luck =< 10 -> 5;
get_luck_ratio(1, Luck) when Luck >= 11 andalso Luck =< 20 -> 10;
get_luck_ratio(1, Luck) when Luck >= 21 andalso Luck =< 30 -> 100;
get_luck_ratio(2, Luck) when Luck >= 0 andalso Luck =< 20 -> 0;
get_luck_ratio(2, Luck) when Luck >= 21 andalso Luck =< 30 -> 1;
get_luck_ratio(2, Luck) when Luck >= 31 andalso Luck =< 40 -> 10;
get_luck_ratio(2, Luck) when Luck >= 41 andalso Luck =< 60 -> 100;
get_luck_ratio(3, Luck) when Luck >= 0 andalso Luck =< 40 -> 0;
get_luck_ratio(3, Luck) when Luck >= 41 andalso Luck =< 70 -> 1;
get_luck_ratio(3, Luck) when Luck >= 71 andalso Luck =< 90 -> 10;
get_luck_ratio(3, Luck) when Luck >= 91 andalso Luck =< 120 -> 100;
get_luck_ratio(4, Luck) when Luck >= 0 andalso Luck =< 40 -> 0;
get_luck_ratio(4, Luck) when Luck >= 41 andalso Luck =< 70 -> 1;
get_luck_ratio(4, Luck) when Luck >= 71 andalso Luck =< 100 -> 10;
get_luck_ratio(4, Luck) when Luck >= 101 andalso Luck =< 150 -> 100;
get_luck_ratio(5, Luck) when Luck >= 0 andalso Luck =< 80 -> 0;
get_luck_ratio(5, Luck) when Luck >= 81 andalso Luck =< 110 -> 1;
get_luck_ratio(5, Luck) when Luck >= 111 andalso Luck =< 140 -> 10;
get_luck_ratio(5, Luck) when Luck >= 141 andalso Luck =< 200 -> 100;
get_luck_ratio(6, Luck) when Luck >= 0 andalso Luck =< 120 -> 0;
get_luck_ratio(6, Luck) when Luck >= 121 andalso Luck =< 170 -> 1;
get_luck_ratio(6, Luck) when Luck >= 171 andalso Luck =< 200 -> 10;
get_luck_ratio(6, Luck) when Luck >= 201 andalso Luck =< 250 -> 100;
get_luck_ratio(7, Luck) when Luck >= 0 andalso Luck =< 120 -> 0;
get_luck_ratio(7, Luck) when Luck >= 121 andalso Luck =< 170 -> 1;
get_luck_ratio(7, Luck) when Luck >= 171 andalso Luck =< 200 -> 10;
get_luck_ratio(7, Luck) when Luck >= 201 andalso Luck =< 250 -> 100;
get_luck_ratio(8, Luck) when Luck >= 0 andalso Luck =< 150 -> 0;
get_luck_ratio(8, Luck) when Luck >= 151 andalso Luck =< 200 -> 1;
get_luck_ratio(8, Luck) when Luck >= 201 andalso Luck =< 230 -> 10;
get_luck_ratio(8, Luck) when Luck >= 231 andalso Luck =< 300 -> 100;
get_luck_ratio(9, Luck) when Luck >= 0 andalso Luck =< 180 -> 0;
get_luck_ratio(9, Luck) when Luck >= 181 andalso Luck =< 250 -> 1;
get_luck_ratio(9, Luck) when Luck >= 251 andalso Luck =< 300 -> 10;
get_luck_ratio(9, Luck) when Luck >= 301 andalso Luck =< 400 -> 100;
get_luck_ratio(10, Luck) when Luck >= 0 andalso Luck =< 180 -> 0;
get_luck_ratio(10, Luck) when Luck >= 181 andalso Luck =< 250 -> 1;
get_luck_ratio(10, Luck) when Luck >= 251 andalso Luck =< 300 -> 10;
get_luck_ratio(10, Luck) when Luck >= 301 andalso Luck =< 400 -> 100;
get_luck_ratio(_, _Luck) -> 0.

%% 获取化形丹的消耗个数
get_upgrade_item_cost(0) -> 1;
get_upgrade_item_cost(1) -> 1;
get_upgrade_item_cost(2) -> 1;
get_upgrade_item_cost(3) -> 2;
get_upgrade_item_cost(4) -> 2;
get_upgrade_item_cost(5) -> 2;
get_upgrade_item_cost(6) -> 3;
get_upgrade_item_cost(7) -> 3;
get_upgrade_item_cost(8) -> 3;
get_upgrade_item_cost(9) -> 4;
get_upgrade_item_cost(_) -> 0.

%% 根据id检查是否是出战兽
check_if_active(Id, ActiveDemon) ->
    case is_record(ActiveDemon, demon2) of
        true ->
            #demon2{id = AId} = ActiveDemon,
            if
                Id =:= AId ->
                    true;
                true ->
                    false
            end;
        false ->
            false
    end.



%% 增加献祭属性加成
add_devour_ext_attr(Demon = #demon2{base_id = MBaseId, grow = Grow, ext_attr = ExtAttr}, SBaseId) ->
    {_, DevourData} = demon_devour_data:get_devour_target(MBaseId),
    Attr = 
        case get_index(Grow, SBaseId, DevourData) of
            0 -> 
                [];
            Index ->
                {_, AttrData} = demon_devour_data:get_devour_attr(MBaseId),
                case Index > erlang:length(AttrData) of
                    true -> [];
                    false -> 
                        lists:nth(Index, AttrData)
                end
        end,
    NExtAttr = add_attr(ExtAttr, Attr),
    Demon#demon2{ext_attr = NExtAttr}.

add_attr(ExtAttr, []) -> ExtAttr;
add_attr(ExtAttr, [{Key, Value}|T]) ->
    case lists:keyfind(Key, 1, ExtAttr) of
        {_, Value0} -> 
            NExtAttr  = lists:keydelete(Key, 1, ExtAttr),
            NExtAttr1 = [{Key, Value0 + Value}] ++ NExtAttr,
            add_attr(NExtAttr1, T);
        false -> 
            add_attr([{Key, Value}|ExtAttr], T)
    end.

get_index(MGrow, SBaseId, DevourData) ->
    LeftId  = (MGrow - 1) * 3 + 1,
    RightId = (MGrow - 1) * 3 + 2,
    LeftData= 
    case lists:keyfind(LeftId, 1, DevourData) of
        {_, LD} -> LD;
        false -> []
    end,
    RightData =  
        case lists:keyfind(RightId, 1, DevourData) of
            {_, RD} -> RD;
            false -> []
        end,
    IsLeft  = lists:member(SBaseId, LeftData),
    IsRight = lists:member(SBaseId, RightData),
    if
        IsLeft == true ->
            LeftId;
        IsRight == true ->
            RightId;
        true->
            0
    end.

%% 更新全局献祭信息
add_devour(Devours, MDemonId, SBaseId) -> 
    case lists:keyfind(MDemonId, 1, Devours) of
        {_, A, B} -> 
            NDevours = lists:keydelete(MDemonId, 1, Devours),
            Element  = 
                if 
                    A == 0 -> 
                        {MDemonId, SBaseId, B};
                    true ->
                        {MDemonId, A, SBaseId}
                end,
            [Element] ++ NDevours;
        false -> 
            [{MDemonId, SBaseId, 0}] ++ Devours
    end.

check_conditions(MDemonId, SDemonId, #role{demon = #role_demon{active = ActiveDemon, bag = Bag, skill_polish = Devours}}) ->
    case get_demon_by_id(MDemonId, ActiveDemon, Bag) of
        MDemon when is_record(MDemon, demon2) ->
            case get_demon_by_id(SDemonId, ActiveDemon, Bag) of
                SDemon when is_record(SDemon, demon2) ->
                    case SDemon#demon2.mod of
                        0 -> 
                            SBaseId = SDemon#demon2.base_id,
                            case check_if_devour(MDemonId, SBaseId, Devours) of
                                ok ->
                                    SGrow  = SDemon#demon2.grow,
                                    SGrowM = SDemon#demon2.grow_max,
                                    case SGrow < SGrowM of
                                        false -> 
                                            MBaseId = MDemon#demon2.base_id,
                                            MGrow   = MDemon#demon2.grow,
                                            {GrowMax, DevourData} = demon_devour_data:get_devour_target(MBaseId),
                                            case MGrow >= GrowMax of
                                                false ->
                                                    case check_target(MGrow, SBaseId, DevourData) of
                                                        true -> 
                                                            {MDemon, SDemon};
                                                        false -> 
                                                            {false, ?MSGID(<<"不能献祭!">>)}        
                                                    end;
                                                true -> 
                                                    {false, ?MSGID(<<"主妖精已满星!">>)}
                                            end;
                                        true -> 
                                            {false, ?MSGID(<<"献祭妖精未满星!">>)}
                                    end;
                                false ->
                                    {false, ?MSGID(<<"已经献祭!">>)}
                            end;
                        1 -> 
                            {false, ?MSGID(<<"出战妖精不能被献祭!">>)}
                    end;
                false -> 
                    {false, ?MSGID(<<"献祭妖精不存在!">>)}
            end;
        false -> 
            {false, ?MSGID(<<"主妖精不存在!">>)}
    end.

%% Devours = [{DemonId, LeftId, RightId}...]
check_if_devour(MDemonId, SBaseId, Devours) ->
    case lists:keyfind(MDemonId, 1, Devours) of
        {_, Left, Right} -> 
            case SBaseId == Left orelse SBaseId == Right of
                true -> 
                    false;
                false -> 
                    ok
            end;
        _ -> 
            ok
    end.

%% 
check_target(MGrow, SBaseId, DevourData) ->
    LeftId  = (MGrow - 1) * 3 + 1,
    RightId = (MGrow - 1) * 3 + 2,

    LeftData = 
        case lists:keyfind(LeftId, 1, DevourData) of
            {_, LData} -> 
                LData;
            _ -> []
        end,

    RightData = 
        case lists:keyfind(RightId, 1, DevourData) of
            {_, RData} ->     
                RData;
            false ->
                []
        end,
    lists:member(SBaseId, LeftData ++ RightData).

get_stone_exp() ->
    BaseId = ?Stone,
    case item_data:get(BaseId) of
        {ok, #item_base{effect = Effect}} ->
            case lists:keyfind(exp_npc, 1, Effect) of
                {_, Exp} ->
                    Exp;
                _ -> 0
            end;
        _ -> 0
    end.

get_price() ->
    case shop:item_price(?Stone) of
        false -> 10;
        Price -> Price
    end.
