%----------------------------------------------------
%%  帮会系统 处理角色帮会数据
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_role).
-export([login/1
        ,logout/1
        ,push/1             %% 推送帮会信息
        ,convert/1          %% 将角色数据转换成帮会需要的数据
        ,tran_ratio/1       %% 帮会炼炉加成
        ,listener/2         %% 角色加入、退出帮会后涉及相关操作
        ,alters/2
        ,alter/3
        ,get_throne/1
        ,add_invite/5
        ,clear_seat/1
        ,read_times/1
        ,read/1
        ,get_wish_info/1
        ,update_wish_info/2
        ,get_max_wish_time/1
        ,get_max_shop_time/1
        ,day_check_wish/1
        ,day_check_shop/1
        ,add_target_trigger/2
        ,init_target_trigger/2
%        ,claim_timer_callback/1
    ]
).

-include("common.hrl").
-include("guild.hrl").
-include("role.hrl").
-include("storage.hrl").
-include("item.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("vip.hrl").
-include("pet.hrl").
-include("assets.hrl").
-include("pos.hrl").
%%
-include("task.hrl").
-include("attr.hrl").
-include("map.hrl").

-define(DAYSEC, 86400).                 %% 一天的秒数
-define(THREEDAYSEC, 3*86400).          %% 三天时间 86400 = 24*60*60
-define(read_cost(N), (100 + (N*50))).  %% 藏经阁阅读消费

%% @spec login(Role) -> NewRole
%% Role = #role{}
%% NewRole = #role{}
%% @doc 角色登陆时调用，检测自身帮会属性变动
%% 没有帮会
login(Role0 = #role{guild = Guild = #role_guild{gid = 0}}) ->
    Role = guild_mem:clean_role_welcome(Role0),
    Role1 = guild_aim:clear_trigger(Role),
    case check_approval(Role1) of     
        {ok, Role2} ->                                      %% 下线期间被批准入帮
            Role3 = check_role_guild(Role2),                %% 获取最新的帮会数据
            Role4 = listener(join, Role3),                %% 入帮监听
            guild_mem:update(pid, Role4),                     %% 更新角色数据到帮会
            guild_common:pack_send_notice(Role4),
            Role4;
        _ ->
            Role#role{guild = Guild#role_guild{name = <<>>}} %% 没有帮会的角色帮会名字改成 空串
    end;

%% 已经有帮会
login(Role0 = #role{guild = #role_guild{gid = _Gid, srv_id = Gsrvid}}) ->
    Role = guild_mem:clean_role_welcome(Role0),
    case check_ext(Role) of     
        false ->                                           %% 下线期间被帮会开除
            ?DEBUG("===============>>check_ext false------ "),
            Role1 = clear_guild_map(Role),                  %% 如果角色下线时在帮会领地，上线被开除了，更新角色的登录进入地图数据 
            NewRole = listener(offline_quit, Role1),                %% 离线期间被开除帮会清理
            login(NewRole);                                 %% 再次检测是否列离线被批准入帮了
        {ok, Role1 = #role{guild = Guild}} -> 
            %% TODO 特殊，转换role_guild中错误服务器标志, 将永远背着
            NR = #role{guild = _Guild2 = #role_guild{srv_id = _NewGSrvId}} = case Gsrvid =:= <<"qq163_1">> of
                true -> Role1#role{guild = Guild#role_guild{srv_id = <<"qq163_2">>}};
                false -> Role1
            end,
            Role2 = check_role_guild(NR),                %% 获取最新的帮会数据
            Role3 = correct_guild_map(Role2),             %% 如果角色下线时在帮会领地，上线更新帮会领地地图ID
            Role4 = rebuild_target_trigger(Role3),
            %Role5 = set_day_claim_timer(Role4),  %% 每日奖励
            % Role5 = guild_pet_deposit:login(Role4),       %% 宠物寄养
            guild_common:pack_send_notice(Role4),
            guild_mem:update(pid, Role4),                     %% 更新角色数据到帮会
            Role4
    end.

%% @spec logout(Role) -> ok
%% Role = #role{}
%% @doc 角色下线更新
logout(Role) ->
    guild_area:moved(Role),                              %% 下线清理数据，#role{}中specail 不保存, 角色宝座数据保存在special中
    guild_mem:update(reset_pid, Role). 


%% @spec listener(Type, Role) -> NewRole
%% Role = NewRole = #role{}
%% Type = quit | join
%% @doc 当Type为quit时，处理角色退出(开除)帮会涉及相关操作, 角色的帮会信息必须在最后清除
%% <div> 当Type为join时，处理角色加入帮会涉及相关操作，角色的帮会信息必须在调用此操作前更新</div>
listener(quit, Role = #role{id = {Rid, Rsrvid}, link = #link{conn_pid = ConnPid}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    task:refresh_acceptable_task(ref_and_send, Role, ?task_type_bh),
    rank:guild_update(out_guild, Role),
    Role1 = #role{guild = RoleGuild} = alters([{quit_date, util:unixtime()}], Role),
    Role2 = guild_area:move_out(Role1),
    Role3 = Role2#role{guild = quit_save_data(RoleGuild)},
    Role4 = guild_aim:clear_trigger(Role3),
%    Role5 = clear_day_claim_timer(Role4),
    
    push(Role4),
    sys_conn:pack_send(ConnPid, 12760, {<<>>}),
    sys_conn:pack_send(ConnPid, 10931, {55, ?L(<<"您已经退出">>), []}),
    sys_conn:pack_send(ConnPid, 12724, {}),     %% 在帮会领地广播有顺序，否则无法将角色移除领地
    map:role_update(Role4),
    guild_practise_mgr:apply(async, {out_guild, {Gid, Gsrvid}, {Rid, Rsrvid}}), %% 成员退出帮会
    Role5 = energy:stop_guild_online_timer(Role4),
    Role5;

listener(offline_quit, Role = #role{id = {Rid, Rsrvid}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    task:refresh_acceptable_task(ref_and_send, Role, ?task_type_bh),
    rank:guild_update(out_guild, Role),
    Role1 = #role{guild = RoleGuild} = alters([{quit_date, util:unixtime()}], Role),
    NewRole = Role1#role{guild = quit_save_data(RoleGuild)},
    guild_practise_mgr:apply(async, {out_guild, {Gid, Gsrvid}, {Rid, Rsrvid}}), %% 成员退出帮会
    NewRole;

listener(join, Role = #role{id = {Rid, Rsrvid}, account = Account, name = Rname, link = #link{conn_pid = ConnPid}, pos = #pos{map_pid = MapPid}, guild = #role_guild{gid = Gid, srv_id = Gsrvid, name = Gname}}) -> 
    task:refresh_acceptable_task(ref_and_send, Role, ?task_type_bh),
    rank:guild_update(in_guild, Role),
    guild_mgr:special(online_join, {Gid, Gsrvid, Rid, Rsrvid}), 
    Role1 = role_listener:special_event(Role, {1074, 0}),  %% 触发远方来信
    Role2 = role_listener:special_event(Role1, {20001, 1}), %% 入帮会任务完成触发
    Role3 = medal:listener_special(legion, Role2),
    random_award:legion(Role3),
    Role4 = rebuild_target_trigger(Role3),
    case is_pid(MapPid) of
        true ->
            map:role_update(Role4);
        false ->    %% 避免离线入帮广播
            ok
    end,
    catch guild_practise_mgr:apply(async, {in_guild, {Gid, Gsrvid}, {Rid, Rsrvid, Rname}}), %% 新成员入帮
    push(Role4),
    sys_conn:pack_send(ConnPid, 12760, {Gname}),
    sys_conn:pack_send(ConnPid, 12725, {}),
    notice:send_interface({connpid, ConnPid}, 11, Account, Rsrvid, Rname, Gname, []),
    guild_common:pack_send_notice(Role4),
    Role5 = energy:init_guild_online(Role4),
    Role5.

%% @spec add_invite(GuildRole, Gid, Gsrvid, Gname, ReName) -> {false, Reason} | true
%% GuildRole = #guild_role{}
%% Gid = integer()
%% Gsrvid = Gname = ReName = binary()
%% @doc GuildRole 为被推荐人的信息
add_invite(#guild_role{rid = Rid, srv_id = Rsrvid, conn_pid = Cpid}, Gid, Gsrvid, Gname, ReName) ->
    case guild_mgr:lookup_spec(invited, Rid, Rsrvid) of
        Invited when length(Invited) < ?guild_invited_num ->
            guild_mgr:special(add_invited, {Gid, Gsrvid, Gname, ReName, Rid, Rsrvid}),
            mail:send_system({Rid, Rsrvid}, {?L(<<"入帮邀请">>), util:fbin(?L(<<"【~s】推荐您加入帮会【~s】">>), [ReName, Gname])}),
            sys_conn:pack_send(Cpid, 12718, {}),
            sys_conn:pack_send(Cpid, 13702, {Gid, Gsrvid, Gname, ReName}),
            true;
        _ ->
            {false, ?L(<<"角色收到邀请过多，推荐失败">>)}
    end.

%% TODO 2012/07/12 搭车宠物战斗力同步一次角色帮会贡献问题
%% @spec convert(Role) -> GuildRole
%% Role = #role{}
%% GuildRole = #guild_role{}
%% @doc 将角色属性转换成帮会需要的角色数据
convert(#role{
        pid = Pid, id = {Rid, SrvId}, name = Name, lev = Lev, sex = Sex, 
        career = Career, vip = #vip{type = Vip, portrait_id = Gravatar}, 
        link = #link{conn_pid = ConnPid}, guild = #role_guild{gid = Gid, quit_date = Date, donation = Donation},
        attr = #attr{fight_capacity = FC}, realm = Realm, pet = #pet_bag{pets = Pets, active = Active, deposit = {Deposit, _, _}}
    }
) ->
    PetFight = lists:max([if is_record(Pet, pet) -> Pet#pet.fight_capacity; true -> 0 end || Pet <- [Active, Deposit |Pets] ]),
    #guild_role{
        rid = Rid ,srv_id = SrvId ,lev = Lev ,name = Name ,sex = Sex, donation = Donation
        ,career = Career ,vip = Vip ,gravatar = Gravatar ,pid = Pid, realm = Realm
        ,conn_pid = ConnPid ,gid = Gid ,date = Date, fight = FC, pet_fight = PetFight}.

%% @spec alters(Lists, Role) -> NewRole
%% Lists = [{Type, Val} | ...]
%% Type = atom()
%% Val = integer()
%% Role = NewRole = #role{}
%% @doc 修改角色的帮会属性，具体参数见 alter/3
alters([], Role) ->
    Role;
alters([{Type, Val} | T], Role) ->
    alters(T, alter(Type, Val, Role)).

%%------------------------------------------------------------------------------
%% @spec alter(Type, Value, Role) -> NewRole
%% Type = pid | position | devote | salary | claim_exp | skilled | join_date | last_enter | exchange
%% Value = integer()
%% Role = NewRole = #role{}
%% @doc 角色帮会的属性修改接口   本接口主要是为保证角色的帮会属性不是丢失，用于角色进程调用
%%------------------------------------------------------------------------------
%% 修改所有帮会进程PID
alter(pid, Pid, Role = #role{guild = Guild}) ->
    Role#role{guild = Guild#role_guild{pid = Pid}};

%% 修改职位
alter(position, Job, Role = #role{link = #link{conn_pid = ConnPid}, guild = Guild}) ->
    sys_conn:pack_send(ConnPid, 13700, {[{50, Job}]}),
    NewRole = Role#role{guild = Guild#role_guild{position = Job, authority = guild_mem:authority(Job)}},
    NewRole;

%% 修改可用帮会贡献
alter(devote, Devote, Role = #role{link = #link{conn_pid = ConnPid}, guild = Guild}) ->
    sys_conn:pack_send(ConnPid, 13700, {[{51, Devote}]}),
    Role#role{guild = Guild#role_guild{devote = Devote}};

%% 修改累积帮会贡献
alter(donation, Donation, Role = #role{link = #link{conn_pid = ConnPid}, guild = Guild}) ->
    sys_conn:pack_send(ConnPid, 13700, {[{52, Donation}]}),
    Role#role{guild = Guild#role_guild{donation = Donation}};

%% 修改经验俸禄
alter(salary, Salary, Role = #role{link = #link{conn_pid = ConnPid}, guild = Guild}) ->
    sys_conn:pack_send(ConnPid, 13700, {[{53, Salary}]}),
    Role#role{guild = Guild#role_guild{salary = Salary}};

%% 修改每日奖励状态
alter(claim_exp, Status, Role = #role{link = #link{conn_pid = ConnPid}, guild = Guild = #role_guild{}}) ->
    sys_conn:pack_send(ConnPid, 13700, {[{54, Status}]}),
    Role#role{guild = Guild#role_guild{claim_exp = Status}};

%% 修改已经领帮会技能
alter(skilled, 0, Role = #role{link = #link{conn_pid = ConnPid}, guild = Guild}) ->
    sys_conn:pack_send(ConnPid, 13705, {}),
    Role#role{guild = Guild#role_guild{skilled = []}};

alter(skilled, Skill, Role = #role{link = #link{conn_pid = ConnPid}, guild = Guild = #role_guild{skilled = Skilled}}) ->
    sys_conn:pack_send(ConnPid, 13704, {Skill}),
    Role#role{guild = Guild#role_guild{skilled = [Skill | Skilled]}};

%% 修改加入帮会时间
alter(join_date, JoinDate, Role = #role{guild = Guild}) ->
    Role#role{guild = Guild#role_guild{join_date = JoinDate}};

%% 修改退出帮会时间
alter(quit_date, QuitDate, Role = #role{guild = Guild}) ->
    ?DEBUG("退出帮会时间  ~w", [QuitDate]),
    Role#role{guild = Guild#role_guild{quit_date = QuitDate}};

%% 修改帮会名字
alter(gname, Gname, Role = #role{guild = Guild}) ->
    Role#role{guild = Guild#role_guild{name = Gname}};

%% 修改当天累积阅读次数
alter(read, Read, Role = #role{link = #link{conn_pid = ConnPid}, guild = Guild}) ->
    sys_conn:pack_send(ConnPid, 12767, {Read, ?read_cost(Read)}),
    Role#role{guild = Guild#role_guild{read = Read}};

%% 修改角色的地图，角色在帮会领地
alter(guild_map, {MapID, MapPid}, Role = #role{pos = Pos}) ->
    Role#role{pos = Pos#pos{map = MapID, map_pid = MapPid}};

%% 修改角色许愿信息
alter(wish, Wish = #wish{times = Times}, Role = #role{link = #link{conn_pid = ConnPid}, guild = Guild}) ->
    sys_conn:pack_send(ConnPid, 13700, {[{58, Times}]}),
    Role#role{guild = Guild#role_guild{wish = Wish}};

%% 修改角色日贡献数据
alter(day_donation, NewDayDonation = #day_donation{donation = Don}, Role = #role{link = #link{conn_pid = ConnPid}, guild = Guild}) ->
    sys_conn:pack_send(ConnPid, 13700, {[{59, Don}]}),
    Role#role{guild = Guild#role_guild{day_donation = NewDayDonation}};

%% 修改角色军团商城购买信息
alter(shop, Shop = #shop{times = Times}, Role = #role{link = #link{conn_pid = ConnPid},guild = Guild}) ->
    sys_conn:pack_send(ConnPid, 13700, {[{56, Times}]}),
    Role#role{guild = Guild#role_guild{shop = Shop}};

%% 军团商城升级后的更新
alter(shop_lvlup, NewLvl, Role = #role{link = #link{conn_pid = ConnPid}, guild = Guild = #role_guild{shop = Shop = #shop{times = Times, lvl = OldLvl}}}) ->
    CanBuyTimes = Times + get_max_shop_time(NewLvl) - get_max_shop_time(OldLvl),
    sys_conn:pack_send(ConnPid, 13700, {[{55, NewLvl}, {56, CanBuyTimes}]}),
    Role#role{guild = Guild#role_guild{ shop = Shop#shop{ lvl = NewLvl, times= CanBuyTimes}}};

%% 军团许愿池升级后的更新
alter(wish_lvlup, NewLvl, Role = #role{link = #link{conn_pid = ConnPid}, guild = Guild = #role_guild{wish = Wish = #wish{times = Times, lvl = OldLvl}}}) ->
    CanWishTimes = Times + get_max_wish_time(NewLvl) - get_max_wish_time(OldLvl),
    sys_conn:pack_send(ConnPid, 13700, {[{57, NewLvl}, {58, CanWishTimes}]}),
    Role#role{guild = Guild#role_guild{ wish = Wish#wish{lvl = NewLvl,times = CanWishTimes}}};

alter(_Type, _, _Role) ->
    ?ERR("修改角色帮会属性时发生错误，传入错误的修改类型：~w", [_Type]),
    _Role.

%% @spec push(Role) -> ok
%% Role = #role{}
%% @doc 主动推送角色帮会信息给客户端
%%push(#role{link = #link{conn_pid = CP}, guild = #role_guild{ gid = G, srv_id = Gs, position = Job, devote = De, donation = Do, salary = S, claim_exp = C, day_donation = #day_donation{donation = Day_Donation}}}) ->
%%    sys_conn:pack_send(CP, 12700, {G, Gs, Job, De, Do, S, C, Day_Donation}).

push(#role{link = #link{conn_pid = CP}, id = {Rid, Rsrvid}, 
        guild = #role_guild{gid = Gid, srv_id = Gsrvid, position = Job, devote = Devote, 
            salary = Salary, donation = Donation, claim_exp = Claim, day_donation = #day_donation{donation = Day_Don}}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{fund = Fund, members = Members, gvip=Gvip, name=Gname, lev=GLvl, chief=ChiefName, rvip=ChiefVip, 
            num=CurMemNum, maxnum=MaxNum, bulletin = {Bul, QQ, YY}, skills=Skills, exp=Exp, stove=Stove, shop=Shop, wish_pool_lvl=WishPoolLvl} ->
                {Coin1, Gold1} = case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Members) of
                    false ->
                        {0,0};
                    #guild_member{coin = Coin, gold = Gold} ->
                        {Coin, Gold}
                    end,
                    ?DEBUG("** 军团奖励标志 ~w", [Claim]),
                    sys_conn:pack_send(CP, 12700, {Gid, Gsrvid, Job, Devote, Donation, Salary, Claim, Day_Don, Fund, Coin1, Gold1, Gname, Gvip, ChiefName, ChiefVip, GLvl, CurMemNum, MaxNum, Bul, Exp, Skills, QQ, YY, Stove, WishPoolLvl, Shop});
        _ ->
           skip
   end.


%% @spec read_times(Role) -> {integer(), integer()}
%% @doc 获取藏经阁阅读次数
read_times(#role{guild = #role_guild{read = Read}}) ->
    {Read, ?read_cost(Read)}.

%% @spec read(Role) -> {true, NewRole} | {false, Reason}
%% @doc 藏经阁阅读
read(#role{guild = #role_guild{gid = 0}}) ->
    {false, ?L(<<"您还没有加入任何帮会，赶紧去申请吧！">>)};
read(Role = #role{id = {Rid, Rsrvid}, name = Rname, guild = #role_guild{read = Read}}) ->
    case role_gain:do(#loss{label = guild_devote, val = ?read_cost(Read)}, Role) of
        {false, _Reason} ->
            {false, ?L(<<"帮会贡献不足">>)};
        {ok, Role1} ->
            {ok, Role2} = role_gain:do(#gain{label = attainment, val = 500}, Role1),
            Role3 = alters([{read, Read + 1}], Role2),
            NewRole = role_listener:special_event(Role3, {1020, finish}), %% 阅读经书
            role_api:push_assets(Role, NewRole),
            spawn(guild_log, log_claim, [Rid, Rsrvid, Rname, <<"阅读藏经阁">>]),
            log:log(log_attainment, {<<"阅读藏经阁">>, <<>>, Role, NewRole}),
            {true, util:fbin(?L(<<"阅读成功，获得 500 点阅历值。消耗 ~w 点帮会贡献">>), [?read_cost(Read)]), NewRole}
    end.

%% @spec tran_ratio(Role) -> integer()
%% Role = #role{}
%% @doc 炼炉强化加成
tran_ratio(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) when Gid =/= 0 ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{stove = Slev} when Slev > 0 ->
            {Ratio, _, _} = guild_build_data:get_stove(Slev),
            Ratio;
        _ ->
            0
    end;
tran_ratio(_Role) ->
    0.

%% @spec get_throne(Role) -> false | ChairID
%% Role = #role{}
%% ChairID = integer()
%% @doc 检查是否在宝座上，如果在，返回宝座ID，否则返回 false
get_throne(#role{special = Spec}) ->
    case lists:keyfind(?special_guild_sit, 1, Spec) of
        false ->
            false;
        {_, ChairId, _} ->
            ChairId
    end.

%% @spec clear_seat(Role) -> NewRole
%% Role = NewRole = #role{}
%% @doc 清除角色宝座数据 special
clear_seat(Role = #role{special = Spec}) ->
    Role#role{special = lists:keydelete(?special_guild_sit, 1, Spec)}.


%% @spec tget_wish_info(Role) -> {ok, #wish{}}
%% Role = #role{}
%% @doc 获取角色许愿信息
get_wish_info(#role{guild = #role_guild{gid = Gid}}) when Gid =:= 0 ->
    Reason = <<"玩家还没加入军团!">>,
    {false, Reason};
get_wish_info(#role{guild = #role_guild{wish = #wish{times = Times}}}) ->
    {ok, Times}.

%% @spec get_max_wish_time(int) -> int
%% 
%% @doc 可许愿次数
get_max_wish_time(Lvl) when Lvl =< 0 -> 0;
get_max_wish_time(Lvl) ->
    case guild_build_data:get_wish(Lvl) of
        false -> 0;
        {Times, _, _} -> Times
    end.

get_max_shop_time(Lvl) when Lvl =< 0 -> 0;
get_max_shop_time(Lvl) ->
    case guild_build_data:get_shop(Lvl) of
        false -> 0;
        {Times, _, _} -> Times
    end.

%%----------------------------------------------------------------
%% 私有函数
%%----------------------------------------------------------------

update_day_donation_info(#role{guild = #role_guild{day_donation = Day_Don = #day_donation{timestamp = LastTime}}}) ->
    case util:is_today(LastTime) of
        true -> 
             Day_Don;
        false -> 
             Day_Don#day_donation{donation=0}    
    end.

update_wish_info(GuildLvl, #role{guild = #role_guild{wish = Wish = #wish{last_time = LastTime}}}) ->
    Wish1 = case util:is_today(LastTime) of
        false -> Wish#wish{times = get_max_wish_time(GuildLvl)};
        true -> Wish
    end,
    {ok, Wish1}.

%% @spec check_approval(Role) -> false | {ok, NewRole}
%% 角色没有帮会 
check_approval(Role = #role{id = {Rid, Rsrvid}, guild = #role_guild{read = Read, skilled = Skilled, welcome_times = Times}}) ->
    case guild_mgr:lookup_spec(Rid, Rsrvid) of     
        #special_role_guild{status = ?true, guild = {Gid, Gsrvid, Date}} ->    %% 下线期间被批准入帮
            case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
                false ->
                    false;
                #guild{pid = Pid, name = Name, lev = Lev} ->
                    {ok, Role#role{guild = #role_guild{pid = Pid, gid = Gid, srv_id = Gsrvid, name = Name, join_date = Date, read = Read, skilled = Skilled, welcome_times = Times, wish = #wish{times = get_max_wish_time(Lev)}}}}
            end;
        _ ->
            false
    end.

%% @spec check_ext(Role) -> false | {ok, NewRole}
%% 角色有帮会   %% 扩展
check_ext(Role = #role{id = {Rid, Rsrvid}, name = Name, guild = Guild = #role_guild{gid = Gid, srv_id = Gsrvid, name = Gname, join_date = JoinDate}}) ->
    case guild_mgr:lookup_spec(Rid, Rsrvid) of     
        Spec = #special_role_guild{guild = {NewGid, NewGsrvid, DateFlag}} when (Gid =/= NewGid orelse Gsrvid =/= NewGsrvid) andalso (DateFlag =:= -1 orelse DateFlag =:= JoinDate) -> %% 下线合并帮会 被转移至新帮会
            guild_mgr:special(update, Spec#special_role_guild{guild = {NewGid, NewGsrvid, JoinDate}}),
            {ok, Role#role{guild = Guild#role_guild{gid = NewGid, srv_id = NewGsrvid}}};
        Spec = #special_role_guild{fire = ?true} -> %% 下线被开除
            guild_mgr:special(update, Spec#special_role_guild{fire = ?false}),
            false;
        #special_role_guild{updates = []} ->
            {ok, Role};
        Spec1 = #special_role_guild{updates = List} ->   %% 需要清理数据
            Role1 = clear_data(List, Role),
            guild_mgr:special(update, Spec1#special_role_guild{updates = []}),
            {ok, Role1};
        false -> 
            ?ERR("角色 [~s] 有帮会 [~s]，但找不到帮会扩展数据", [Name, Gname]),
            Spec = #special_role_guild{id = {Rid, Rsrvid}, guild = {Gid, Gsrvid, 0}, status = 1},
            guild_mgr:special(update, Spec),
            {ok, Role}
    end.

%% @spec clear_data(List, Role) -> NewRole
%% 角色上线清理个别帮会数据
clear_data([], Role) ->
    Role;
clear_data([H|T], Role) ->
    NewRole = case H of
        1 ->    %% 清理经验领用状态
            alters([{claim_exp, ?false}], Role);
        2 ->    %% 清理已经领过帮会技能
            alters([{skilled, 0}], Role);
        3 ->
            alters([{read, 0}], Role);
        _ ->
            Role
    end,
    clear_data(T, NewRole).

%% 获取角色最新的帮会信息
check_role_guild(Role = #role{id = {Rid, Rsrvid}, name = Rname, lev = Rlev, 
        guild = #role_guild{wish = Wish = #wish{last_time = LastTimeWish, times = WishTimes, lvl = RoleWishLvl}, 
        shop = Shop = #shop{last_time = LastTimeShop, times = ShopTimes, lvl = RoleShopLvl},gid = Gid, srv_id = Gsrvid, position = Job}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{pid = Pid, weal = Weal, members = Mems, name = Gname, shop = ShopLvl, wish_pool_lvl = WishPoolLvl} when is_pid(Pid) ->
            NRole = case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Mems) of
                        #guild_member{position = NewJob} when Job =/= NewJob ->
                            alters([{salary, guild_mem:salary(Rlev, Weal, NewJob)}, {position, NewJob}, {pid, Pid}, {gname, Gname}], Role);
                        #guild_member{position = NewJob} ->
                            alters([{salary, guild_mem:salary(Rlev, Weal, NewJob)}, {pid, Pid}, {gname, Gname}], Role);
                        _ ->
                            Role
                    end,
                    
            NRole1 = case util:is_today(LastTimeWish) of
                        false ->
                            alters([{wish, Wish#wish{lvl = WishPoolLvl, times = get_max_wish_time(WishPoolLvl)}}], NRole);
                        true ->  %% 检查许愿池等级是否已经升级
                            case RoleWishLvl =/= WishPoolLvl of
                                true -> %% 军团升级了
                                    alters([{wish, Wish#wish{lvl = WishPoolLvl, times = WishTimes + get_max_wish_time(WishPoolLvl) - get_max_wish_time(RoleWishLvl)}}], NRole);
                                false ->
                                    NRole
                            end
                    end,
            NRole2 = case util:is_today(LastTimeShop) of
                        false -> %%
                            alters([{shop, Shop#shop{lvl = ShopLvl, times = get_max_shop_time(ShopLvl)}}], NRole1);
                        true -> 
                            case RoleShopLvl =/= ShopLvl of
                                true -> 
                                    alters([{shop, Shop#shop{lvl = ShopLvl, times = ShopTimes + get_max_shop_time(ShopLvl) - get_max_shop_time(RoleShopLvl)}}], NRole1);
                                false ->
                                    NRole1
                            end
                    end,

            Tomorrow = util:unixtime(today) + 86410,
            Now = util:unixtime(),
            NRole3 = role_timer:set_timer(guild_role_wish, (Tomorrow - Now) * 1000, {guild_role, day_check_wish, []}, day_check, NRole2),
            NewDonation = update_day_donation_info(NRole3),
            NRole4 = alters([{day_donation, NewDonation}], NRole3),
            NRole5 = role_timer:set_timer(guild_role_shop, (Tomorrow - Now) * 1000, {guild_role, day_check_shop, []}, day_check, NRole4),
            NRole5;
        #guild{name = Gname} ->
            ?ERR("帮会【~s】数据异常, pid 为 0 , 角色【~s [~w]】没有获取到帮会的 Pid", [Gname, Rname, Rid]),
            Role;
        _ ->
            Role
    end.

%% 日期检测,重置玩家许愿次数 {ok, NewRole}
day_check_wish(Role = #role{id = {Rid, Rsrvid}, guild = Guild = #role_guild{gid = Gid, srv_id = Gsrvid, wish = Wish = #wish{last_time = LastTime, lvl = Lev}}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{pid = Pid, members = Mems} when is_pid(Pid) ->
            case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Mems) of
                #guild_member{} ->
                        case LastTime > util:unixtime(today) of
                            true -> {ok, Role};
                            false -> {ok,Role#role{guild = Guild#role_guild{wish = Wish#wish{times = get_max_wish_time(Lev)}}}}
                        end;
                _ ->
                    {ok,Role}
            end;
        _ -> {ok,Role}
    end.

%% 日期检测,重置玩家商城购买次数 {ok, NewRole}
day_check_shop(Role = #role{id = {Rid, Rsrvid}, guild = Guild = #role_guild{gid = Gid, srv_id = Gsrvid, shop = Shop = #shop{last_time = LastTime, lvl = Lev}}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{pid = Pid, members = Mems} when is_pid(Pid) ->
            case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Mems) of
                #guild_member{} ->
                        case LastTime > util:unixtime(today) of
                            true -> {ok, Role};
                            false -> {ok,Role#role{guild = Guild#role_guild{shop = Shop#shop{times = get_max_shop_time(Lev)}}}}
                        end;
                _ ->
                    {ok,Role}
            end;
        _ -> {ok,Role}
    end.



%% @spec clear_guild_map(Role) -> NewRole
%% 角色离线被开除帮会，更新首次登陆进入地图数据
clear_guild_map(Role = #role{event = ?event_guild, pos = Pos}) ->
    Role#role{event = ?event_no, pos = Pos#pos{map = ?guild_exit_mapid, x = ?guild_exit_x, y = ?guild_exit_y}};
clear_guild_map(_Role) ->
    _Role.

%% @spec correct_guild_map(Role) -> NewRole
%% 检测角色离线时是否在帮会领地，如果在，更新角色的帮会领地地图ID
correct_guild_map(Role = #role{event = ?event_guild, pos = Pos = #pos{x = X, y = Y}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{gvip = ?guild_piv, entrance = {MapId, Ex, Ey}} ->
            #map_data{width = W, height = H} = map_data:get(?guild_piv_mapid),
            case (X > 0 andalso X < W andalso Y > 0 andalso Y < H) of
                true ->
                    Role#role{pos = Pos#pos{map = MapId, map_base_id = ?guild_piv_mapid}};
                false ->
                    Role#role{pos = Pos#pos{map = MapId, map_base_id = ?guild_piv_mapid, x = Ex, y = Ey}}
            end;
        #guild{gvip = ?guild_vip, entrance = {MapId, Ex, Ey}} ->
            #map_data{width = W, height = H} = map_data:get(?guild_vip_mapid),
            case (X > 0 andalso X < W andalso Y > 0 andalso Y < H) of
                true ->
                    Role#role{pos = Pos#pos{map = MapId, map_base_id = ?guild_vip_mapid}};
                false ->
                    Role#role{pos = Pos#pos{map = MapId, map_base_id = ?guild_vip_mapid, x = Ex, y = Ey}}
            end;
        _ ->
            Role
    end;
correct_guild_map(_Role) ->
    _Role.

%% 角色退出帮会需要保留的帮会属性
quit_save_data(#role_guild{read = Read, skilled = Skilled, quit_date = Date, welcome_times = Times}) ->
    #role_guild{read = Read, skilled = Skilled, quit_date = Date, welcome_times = Times}.

%% 建团时团长的初始触发器
init_target_trigger(Role, Targets) ->
    #target_info{target_lst = Lst} = Targets,
    T = [Id || #target{id = Id, cur_val = Val} <- Lst, Val < guild_target_data:finish_val(Id)],
    {ok, add_target_trigger(T, Role)}.

rebuild_target_trigger(Role) ->
    Targets = guild_aim:unaccomplish_target(Role),
    ?DEBUG("------->>>> 所有未完成的军团目标: ~p~n", [Targets]),
    case length(Targets) > 0 of
        true ->
            add_target_trigger(Targets, Role);
        false ->
            Role
    end.

add_target_trigger([], Role) -> Role;
add_target_trigger([TargetId|T], Role = #role{trigger = Trg}) ->
    case guild_target_data:get(TargetId) of
        false -> ?ERR("找不到军团目标配置"), Role;
        {_, Label, _, _} -> 
            case role_trigger:add(Label, Trg, {guild_aim, Label, [TargetId]}) of 
                {ok, _TriggerId, NewTrigger} ->
                    add_target_trigger(T, Role#role{trigger = NewTrigger});
                _ ->
                    add_target_trigger(T, Role)
            end
    end.
