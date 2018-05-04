%%----------------------------------------------------
%%  军团系统
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_common).
-export([start/1
        ,async_maintain/1
        ,donate/3
        ,async_donate_coin/4
        ,async_donate_gold/4
        ,leave_note/2
        ,async_leave_note/4
        ,delete_note/2
        ,async_delete_note/2
        ,notes/1
        ,devote_log/1
        ,donation_stats/1
        ,skills/1
        ,upgrade_guild/1
        ,async_upgrade_guild/2
        ,add_exp/2
        ,upgrade_weal/1
        ,async_upgrade_weal/2
        ,upgrade_stove/1
        ,async_upgrade_stove/2
        ,upgrade_shop/1
        ,async_upgrade_shop/2
        ,upgrade_wish/1
        ,async_upgrade_wish/2
        ,upgrade_skill/2
        ,async_upgrade_skill/3
        ,claim_salary/1
        ,claim_skill/1
        ,claim_skill/2
        ,bulletin/4
        ,async_bulletin/5
        ,permission/4
        ,async_permission/5
        ,email/3
        ,upgrade/1
        ,sync_upgrade/1
        ,degrade/1
        ,sync_degrade/1
        ,wish/1
        ,get_wish_item/1
        ,get_wish_item_log/1
        ,sync_set_wish_item_log/7
        ,do_log_wish_item/2
        ,get_can_buy_list/1
        ,item_can_buy/2
        ,buy/2
        ,guild_fc/1
        ,set_guild_lev/2
        ,async_set_guild_lev/3
        ,send_offline_msg/2
        ,do_send_offline_msg/2
        ,pack_send_notice/1
        ,pack_send_notice/2
        ,set_join_limit/2
        ,async_set_join_limit/3
    ]
).

-include("common.hrl").
-include("guild.hrl").
-include("role.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("vip.hrl").
-include("buff.hrl").
-include("pos.hrl").
-include("chat_rpc.hrl").
-include("rank.hrl").
-include("notification.hrl").
%%

-define(email_cost, 50).                %% 群发邮件，消费50军团资金
-define(DAYSEC, 30).                 %% 一天秒数 24*60*60 = 86400


%% @spec start(GuildID) -> ok
%% GuildID = gid()
%% @doc 午夜维护函数
start({Gid, Gsrvid}) ->
    guild:reg_maintain_callback({Gid, Gsrvid}, {?MODULE,  async_maintain, []}).

%% @spec async_maintain(Guild) -> {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% @doc 午夜维护回调函数
async_maintain(Guild = #guild{donation_log = DonationLog, note_list = Notes}) ->
    {ok, guild:alters([{donation_log, lists:sublist(DonationLog, 200)}, {note_list, lists:sublist(Notes, 200)}], Guild)}.

%% @spec donate(Coin, Gold, Role) -> {ok, NewRole} | {false, Reason}
%% Coin = Gold = integer()
%% Role = NewRole = #role{}
%% Reasno = binary()
%% @doc 军团捐献
donate(0, 0, _Role) ->
    {false, ?MSGID(<<"木有选择额度呀">>)};
donate(_Coin, _Gold, #role{guild = #role_guild{gid = 0}}) ->
    {false, <<>>};
donate(Coin, 0, Role = #role{id = {Rid, Rsrvid}, link = #link{conn_pid = _ConnPid}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case role_gain:do([#loss{label = coin, val = Coin}], Role) of
        {ok, Role1} ->
            guild:apply(async, {Gid, Gsrvid}, {?MODULE, async_donate_coin, [Coin, Rid, Rsrvid]}),
            {ok, NewRole} = role_gain:do(#gain{label = guild_devote, val = ?coin2devote(Coin)}, Role1),
            role_api:push_assets(Role, NewRole),
            %% sys_conn:pack_send(ConnPid, 10931, {55, util:fbin(?L(<<"捐献 ~w 金币成功, 增加 ~w 军团资金, 获得 ~w 军团贡献">>), [Coin, ?coin2devote(Coin), ?coin2devote(Coin)]), []}),
            {ok, NewRole};
        _ ->
            {?coin_less, ?MSGID(<<"捐献失败，铜币不足">>)}
    end;
donate(0, Gold, Role = #role{id = {Rid, Rsrvid}, link = #link{conn_pid = _ConnPid}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case role_gain:do(#loss{label = gold, val = Gold}, Role) of
        {ok, Role1} ->
            guild:apply(async, {Gid, Gsrvid}, {?MODULE, async_donate_gold, [Gold, Rid, Rsrvid]}),
            {ok, NewRole} = role_gain:do(#gain{label = guild_devote, val = ?gold2devote(Gold)}, Role1),
            role_api:push_assets(Role, NewRole),
            %%暂时去掉此广播
            %% sys_conn:pack_send(ConnPid, 10931, {55, util:fbin(?L(<<"捐献 ~w 晶钻成功, 增加 ~w 军团资金, 获得 ~w 军团贡献">>), [Gold, ?gold2devote(Gold), ?gold2devote(Gold)]), []}),
            {ok, NewRole};
        _ ->
            {?gold_less, ?MSGID(<<"晶钻不足">>)}
    end.

%% @spec async_donate_coin(Guild, Coin, Rid, Rsrvid) -> {ok} | {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% Coin = Gid = integer()
%% Rsrvid = binary()
%% @doc 军团捐献 捐金币
async_donate_coin(Guild = #guild{donation_log = Dlog, members = Members}, Coin, Rid, Rsrvid) ->
    case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Members) of
        false ->
            {ok};
        M = #guild_member{pid = Pid, name = Rname, coin = Coin1} ->
            M1 = M#guild_member{coin = Coin1 + Coin},
            NewMems = lists:keyreplace({Rid, Rsrvid}, #guild_member.id, Members, M1),
            Log = {util:fbin(?L(<<"~s 给军团捐献了 ~w 金币">>), [Rname, Coin]), util:unixtime()},
            NewGuild = guild:alters([{donation_log, [Log |Dlog]}, {members, NewMems}], Guild),
            %% guild:guild_chat(Members, util:fbin(?L(<<"{role, ~w, ~s, ~s, FFFF66}给军团捐献了 ~w 金币\n增加 ~w 军团资金, 获得 ~w 军团贡献。{open,46,我要捐献,#00ff24}">>), [Rid, Rsrvid, Rname, Coin, ?coin2devote(Coin), ?coin2devote(Coin)])),
            guild_refresh:refresh(13729, M1, Members),
            guild_refresh:refresh(13730, Log, Members),
            notify_bypid(Pid, {[{60, Coin1+Coin}]}),
            {ok, NewGuild}
    end.

%% @spec async_donate_gold(Guild, Gold, Rid, Rsrvid) -> {ok} | {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% Gold = Gid = integer()
%% Rsrvid = binary()
%% 军团捐献 捐晶钻
async_donate_gold(Guild = #guild{donation_log = Dlog, members = Members}, Gold, Rid, Rsrvid) ->
    case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Members) of
        false ->
            {ok};
        M = #guild_member{pid = Pid, name = Rname, gold = Gold1} ->
            M1 = M#guild_member{gold = Gold1 + Gold},
            Log = {util:fbin(?L(<<"~s 给军团捐献了 ~w 晶钻">>), [Rname, Gold]), util:unixtime()},
            NewMems = lists:keyreplace({Rid, Rsrvid}, #guild_member.id, Members, M1),
            NewGuild = guild:alters([{donation_log, [Log |Dlog]}, {members, NewMems}], Guild),
            %%guild:guild_chat(Members, util:fbin(?L(<<"{role, ~w, ~s, ~s, FFFF66}给军团捐献了 ~w 晶钻\n增加 ~w 帮会资金, 获得 ~w 帮会贡献。{open,46,我要捐献,#00ff24}">>), [Rid, Rsrvid, Rname, Gold, ?gold2devote(Gold), ?gold2devote(Gold)])),
            guild_refresh:refresh(13730, Log, Members),
            notify_bypid(Pid, {[{61, Gold+Gold1}]}),
            {ok, NewGuild}
    end.

%% @spec leave_note(Msg, Role) -> ok | false
%% Msg = binary()
%% Role = #role{}
%% @doc 军团留言
leave_note(Msg, #role{name = Name, guild = #role_guild{pid = Pid}, vip = #vip{type = Vip}}) when is_pid(Pid) ->
    guild:apply(async, Pid, {?MODULE, async_leave_note, [Msg, Name, Vip]});
leave_note(_Msg, _Role) ->
    false.

%% @spec async_leave_note(Guild, Msg, Name, Vip) -> {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% Msg = Name = binary()
%% Vip = integer()
%% @doc 军团留言
async_leave_note(Guild = #guild{members = Members, note_list = []}, Msg, Name, Vip) ->
    Note = {1, Vip, Name, Msg, util:unixtime()},
    NewGuild = guild:alters([{note_list, [Note]}], Guild),
    guild_refresh:refresh(13724, Note, Members),
    {ok, NewGuild};
async_leave_note(Guild = #guild{members = Members, note_list = NL = [{ID, _, _, _, _} |_T]}, Msg, Name, Vip) ->
    Note = {ID+1, Vip, Name, Msg, util:unixtime()},
    NewGuild = guild:alters([{note_list, [Note | NL]}], Guild),
    guild_refresh:refresh(13724, Note, Members),
    {ok, NewGuild}.

%% @spec delete_note(ID, Role) -> {false, Reason} | ok
%% ID = integer()
%% Role = #role{}
%% Reason = binary()
%% @doc 删除留言
delete_note(_ID, #role{guild = #role_guild{authority = Auth}}) when Auth < ?delete_note ->
    {false, ?MSGID(<<"权限不足">>)};
delete_note(ID, #role{guild = #role_guild{pid = Pid}}) when is_pid(Pid) ->
    guild:apply(async, Pid, {?MODULE, async_delete_note, [ID]});
delete_note(_ID, _Role) ->
    {false, <<>>}.

%% @spec async_delete_note(Guild, ID) -> {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% ID = integer()
%% @doc 删除留言
async_delete_note(Guild = #guild{members = Members, note_list = NL}, ID) ->
    guild_refresh:refresh(13723, ID, Members),
    NewGuild = guild:alters([{note_list, lists:keydelete(ID, 1, NL)}], Guild),
    {ok, NewGuild}.

%% @spec notes(Role) -> List
%% Role = #role{}
%% @doc 军团留言列表
notes(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{note_list = NL} -> NL;
        _ -> []
    end.

%% @spec devete_log(Role) -> List
%% Role = #role{}
%% @doc 贡献日志
devote_log(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{donation_log = Dlog} -> Dlog;
        _ -> []
    end.

%% @spec donation_stats(Role) -> List
%% Role = #role{}
%% @doc 贡献统计
donation_stats(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{members = Members} -> lists:reverse(lists:keysort(#guild_member.gold, lists:keysort(#guild_member.coin, Members)));
        _ -> []
    end.

%% @spec skills(Role) -> List
%% Role = #role{}
%% @doc 获取军团技能列表
skills(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{skills = Skills} ->
            Fun = fun({_, Lev1}, {_, Lev2}) -> Lev1 > Lev2 end,
            lists:sort(Fun, Skills);
        _ -> []
    end.

%% @spec upgrade_guild(Role) -> ok | {false, Reason}
%% Role = #role{}
%% Reason = binary()
%% @doc 军团提升
upgrade_guild(#role{guild = #role_guild{gid = 0}}) -> {false, ?MSGID(<<"您还没有加入军团">>)};
upgrade_guild(#role{guild = #role_guild{authority = Auth}}) when Auth =/= ?chief_op andalso Auth =/= ?elder_op-> {false, ?MSGID(<<"权限不足">>)};
upgrade_guild(#role{link = #link{conn_pid = ConnPid}, guild = #role_guild{pid = Pid}}) ->
    guild:apply(async, Pid, {?MODULE, async_upgrade_guild, [ConnPid]}).

%% @spec async_upgrade_guild(Guild, ConnPid) -> {ok} | {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% ConnPid = pid()
%% @doc 提升军团
async_upgrade_guild(#guild{lev = Lev}, ConnPid) when Lev >= ?max_guild_lev ->
    sys_conn:pack_send(ConnPid, 10931, {58, ?MSGID(<<"军团已经是最高等级">>), []}),
    {ok};
async_upgrade_guild(Guild = #guild{members = Mems, lev = Lev, fund = Fund, rtime = Rtime}, ConnPid) ->
    {ok, #guild_lev{cost_fund =  CF, day_fund = DF, maxnum = MaxNum}} = guild_data:get(guild_lev, Lev + 1),
    case Fund >= CF of
        false ->
            sys_conn:pack_send(ConnPid, 10931, {58, ?MSGID(<<"军团资金不足">>), []}),
            {ok};
        true ->
            NewFund = Fund - CF, NewLev = Lev + 1,
            NewGuild = guild:alters([{lev, NewLev}, {fund, NewFund}, {maxnum, MaxNum}, {day_fund, DF}, {rtime, [{NewLev, util:unixtime()}|Rtime]}], Guild),
            spawn(guild_rss, upgrade_lev, [NewGuild]),
            guild:guild_chat(Mems, util:fbin(?L(<<"军团 已升至 ~w 级">>), [NewLev])),
            sys_conn:pack_send(ConnPid, 12743, {?true, ?MSGID(<<"军团升级成功">>)}),
            {ok, NewGuild}
    end.


%% @spec add_exp(Guild) -> {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% @doc 完成军团目标升级军团
add_exp(Exp, Guild = #guild{members = Mems, lev = Lev, exp = CurExp, rtime = Rtime}) ->
    {NewLev, RemainExp} = exp2lev(Lev, CurExp, Exp),
    case NewLev =/= Lev of
        true ->
            {ok, #guild_lev{day_fund = DF, maxnum = MaxNum}} = guild_data:get(guild_lev, Lev + 1),
            Guild1 = guild:alters([{lev, NewLev}, {exp, RemainExp}, {maxnum, MaxNum}, {day_fund, DF}, {rtime, [{NewLev, util:unixtime()}|Rtime]}], Guild),
            rank:listener(guild_lev, Guild1),    %% 帮会等级排行榜监听
            spawn(guild_rss, upgrade_lev, [Guild1]),
            guild:guild_chat(Mems, util:fbin(?L(<<"军团 已升至 ~w 级">>), [NewLev])),
            {ok, Guild1};
    false ->
        Guild1 = guild:alters([{exp, RemainExp}], Guild),
        {ok, Guild1}
    end.


%% @spec upgrade_weal(Role) -> {false, Reason} | ok
%% Role = #role{}
%% Reason = binary()
%% @doc 军团福利升级
upgrade_weal(#role{guild = #role_guild{gid = 0}}) -> {false, ?MSGID(<<"您还没有加入军团">>)};
upgrade_weal(#role{guild = #role_guild{authority = Auth}}) when Auth =/= ?chief_op -> {false, ?MSGID(<<"权限不足">>)};
upgrade_weal(#role{link = #link{conn_pid = ConnPid}, guild = #role_guild{pid = Pid}}) ->
    guild:apply(async, Pid, {?MODULE, async_upgrade_weal, [ConnPid]}).

%% @spec async_upgrade_weal(Guild, ConnPid) -> {ok} | {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% ConnPid = pid()
%% @doc 升级福利
async_upgrade_weal(#guild{weal = Weal}, ConnPid) when Weal >= ?max_weal_lev ->
    sys_conn:pack_send(ConnPid, 10931, {58, ?MSGID(<<"福利已经是最高等级">>), []}),
    {ok};
async_upgrade_weal(Guild = #guild{lev = Glev, weal = Wlev, fund = Fund, members = Mems}, ConnPid) ->
    NewWeal = Wlev + 1,
    {ok, #weal_lev{glev = W_Glev, fund = W_Fund}} = guild_data:get(weal_lev, NewWeal),
    case Glev >= W_Glev of
        false ->
            sys_conn:pack_send(ConnPid, 10931, {58, ?MSGID(<<"军团等级不足">>), []}),
            {ok};
        true when Fund >= W_Fund ->
            NewFund = Fund - W_Fund, 
            NewGuild = guild:alters([{weal, NewWeal}, {fund, NewFund}], Guild),
            Fun = fun(#guild_member{pid = Pid}) when is_pid(Pid) -> role:apply(async, Pid, {guild_api, set, [{weal, NewWeal}]});
                (_GuildMember) -> ok
            end,
            spawn(lists, foreach, [Fun, Mems]),
            guild:guild_chat(Mems, util:fbin(?L(<<"福利 已升至 ~w 级">>), [NewWeal])),
            sys_conn:pack_send(ConnPid, 12743, {?true, ?MSGID(<<"福利升级成功">>)}),
            {ok, NewGuild};
        _ ->
            sys_conn:pack_send(ConnPid, 10931, {58, ?MSGID(<<"军团资金不足">>), []}),
            {ok}
    end.

%% @spec upgrade_stove(Role) -> {false, Reason} | ok
%% Role = #role{}
%% Reason = binary()
%% @doc 军团神炉升级
upgrade_stove(#role{guild = #role_guild{gid = 0}}) -> {false, ?MSGID(<<"您还没有加入军团">>)};
upgrade_stove(#role{guild = #role_guild{authority = Auth}}) when Auth =/= ?chief_op andalso Auth =/= ?elder_op -> {false, ?MSGID(<<"权限不足">>)};
upgrade_stove(#role{link = #link{conn_pid = ConnPid}, guild = #role_guild{pid = Pid}}) ->
    guild:apply(async, Pid, {?MODULE, async_upgrade_stove, [ConnPid]}).

%% @spec async_upgrade_stove(Guild, ConnPid) -> {ok} | {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% ConnPid = pid()
%% @doc 升级神炉
async_upgrade_stove(#guild{stove = Stove}, ConnPid) when Stove >= ?max_stove_lev ->
    sys_conn:pack_send(ConnPid, 12743, {?false, ?MSGID(<<"神炉已经是最高等级">>)}),
    {ok};
async_upgrade_stove(Guild = #guild{lev = Glev, stove = Slev, fund = Fund, members = Mems}, ConnPid) ->
    NewStove = Slev + 1,
    case guild_build_data:get_stove(NewStove) of
        false -> 
            sys_conn:pack_send(ConnPid, 12743, {?false, ?MSGID(<<"找不到神炉配置">>)});
        {_Stove_Rate, S_Fund, NeedLev} ->
            case Glev >= NeedLev of
                false ->
                    sys_conn:pack_send(ConnPid, 12743, {?false, ?MSGID(<<"军团等级不足">>)}),
                    {ok};
            true when Fund >= S_Fund ->
                NewGuild = guild:alters([{stove, NewStove}, {fund, Fund - S_Fund}], Guild),
                guild:guild_chat(Mems, util:fbin(?L(<<"神炉 已升至 ~w 级">>), [NewStove])),
                sys_conn:pack_send(ConnPid, 12743, {?true, ?MSGID(<<"神炉升级成功">>)}),
                {ok, NewGuild};
            _ ->
                sys_conn:pack_send(ConnPid, 12743, {?false, ?MSGID(<<"军团资金不足">>)}),
                {ok}
            end
    end.



%% @spec upgrade_shop(Role) -> {false, Reason} | ok
%% Role = #role{}
%% Reason = binary()
%% @doc 军团商城升级
upgrade_shop(#role{guild = #role_guild{gid = 0}}) -> {false, ?MSGID(<<"您还没有加入军团">>)};
upgrade_shop(#role{guild = #role_guild{authority = Auth}}) when Auth =/= ?chief_op andalso Auth =/= ?elder_op-> {false, ?MSGID(<<"权限不足">>)};
upgrade_shop(#role{link = #link{conn_pid = ConnPid}, guild = #role_guild{pid = Pid}}) ->
    guild:apply(async, Pid, {?MODULE, async_upgrade_shop, [ConnPid]}).

%% @spec async_upgrade_shop(Guild, ConnPid) -> {ok} | {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% ConnPid = pid()
%% @doc 升级商城
async_upgrade_shop(#guild{shop = Shop}, ConnPid) when Shop >= ?max_weal_lev ->
    sys_conn:pack_send(ConnPid, 12743, {?false, ?MSGID(<<"商城已经是最高等级">>)}),
    {ok};
async_upgrade_shop(Guild = #guild{lev = Lev, shop = Shop, fund = Fund, members = Mems}, ConnPid) ->
    NewShop = Shop + 1,
    case guild_build_data:get_shop(NewShop) of
        false -> 
            sys_conn:pack_send(ConnPid, 12743, {?false, ?MSGID(<<"找不到新商城配置">>)});
        {_BuyTimes, _Cost, NeedLev} when Lev < NeedLev ->
            sys_conn:pack_send(ConnPid, 12743, {?false, ?MSGID(<<"军团等级不足">>)}),
            {ok};
        {_BuyTimes, Cost, _NeedLev} ->
            case Fund >= Cost of
                true ->
                    NewFund = Fund - 1000, 
                    NewGuild = guild:alters([{shop, NewShop}, {fund, NewFund}], Guild),
                    Fun = fun(#guild_member{pid = Pid}) when is_pid(Pid) -> role:apply(async, Pid, {guild_api, set, [{shop_lvlup, NewShop}]}); (_GuildMember) -> ok end,
                    spawn(lists, foreach, [Fun, Mems]),
                    sys_conn:pack_send(ConnPid, 12743, {?true, ?MSGID(<<"商城升级成功">>)}),
                    {ok, NewGuild};
                false ->
                    sys_conn:pack_send(ConnPid, 12743, {?false, ?MSGID(<<"军团资金不足">>)}),
                    {ok}
            end
    end.


%% @spec upgrade_wish(Role) -> {false, Reason} | ok
%% Role = #role{}
%% Reason = binary()
%% @doc 军团许愿池升级
upgrade_wish(#role{guild = #role_guild{gid = 0}}) -> {false, ?MSGID(<<"您还没有加入军团">>)};
upgrade_wish(#role{guild = #role_guild{authority = Auth}}) when Auth =/= ?chief_op andalso Auth =/= ?elder_op-> {false, ?MSGID(<<"权限不足">>)};
upgrade_wish(#role{link = #link{conn_pid = ConnPid}, guild = #role_guild{pid = Pid}}) ->
    guild:apply(async, Pid, {?MODULE, async_upgrade_wish, [ConnPid]}).

%% @spec async_upgrade_wish(Guild, ConnPid) -> {ok} | {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% ConnPid = pid()
%% @doc 升级许愿池
async_upgrade_wish(#guild{weal = Weal}, ConnPid) when Weal >= ?max_weal_lev ->
    sys_conn:pack_send(ConnPid, 12743, {?false, ?MSGID(<<"许愿池已经是最高等级">>), []}),
    {ok};
async_upgrade_wish(Guild = #guild{lev = Lev, wish_pool_lvl = WishLvl, fund = Fund, members = Mems}, ConnPid) ->
    NewWishLvl = WishLvl + 1,
    case guild_build_data:get_wish(NewWishLvl) of
        false ->
            sys_conn:pack_send(ConnPid, 12743, {?false, ?MSGID(<<"找不到许愿池配置">>)}),
            {ok};
    {_Time, _Cost, NeedLev} when Lev < NeedLev ->
            sys_conn:pack_send(ConnPid, 12743, {?false, ?MSGID(<<"军团等级不足">>)}),
            {ok};
    {_Time, Cost, _NeedLev} ->
        case Fund >= Cost of
            true ->
                NewFund = Fund - Cost, 
                NewGuild = guild:alters([{wish, NewWishLvl}, {fund, NewFund}], Guild),
                Fun = fun(#guild_member{pid = Pid}) when is_pid(Pid) -> role:apply(async, Pid, {guild_api, set, [{wish_lvlup, NewWishLvl}]});
                    (_GuildMember) -> ok end,
                spawn(lists, foreach, [Fun, Mems]),
                sys_conn:pack_send(ConnPid, 12743, {?true, ?MSGID(<<"许愿池升级成功">>)}),
                {ok, NewGuild};
            false ->
                sys_conn:pack_send(ConnPid, 12743, {?false, ?MSGID(<<"军团资金不足">>)}),
                {ok}
            end
    end.

%% @spec upgrade_skill(Type, Role) -> ok | {false, Reason}
%% Type = integer()
%% Role = #role{}
%% Reason = binary()
%% @doc 军团技能提升
upgrade_skill(_Type, #role{guild = #role_guild{gid = 0}}) -> {false, ?MSGID(<<"你还没有加入军团">>)};
upgrade_skill(_Type, #role{guild = #role_guild{authority = Auth}}) when Auth =/= ?chief_op andalso Auth =/= ?elder_op-> {false, ?MSGID(<<"权限不足">>)};
upgrade_skill(Type, #role{link = #link{conn_pid = ConnPid}, guild = #role_guild{pid = Pid}}) ->
    guild:apply(async, Pid, {?MODULE, async_upgrade_skill, [Type, ConnPid]}).

%% @spec async_upgrade_skill(Guild, Type, ConnPid) -> {ok} | {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% Type = integer()
%% ConnPid = pid()
%% @doc 技能升级
async_upgrade_skill(Guild = #guild{skills = Skills, lev = Glev, fund = Fund, members = Mems}, Type, ConnPid) ->
    case lists:keyfind(Type, 1, Skills) of
        false ->
            {ok};
        {Type, SkillLev} when SkillLev >= ?max_skill_lev ->
            sys_conn:pack_send(ConnPid, 12739, {?false, ?MSGID(<<"该技能已是最高等级">>)}),
            {ok};
        {Type, Slev} ->
            %% ?DEBUG("================>>~p~n", [{Type, Slev}]),
            {ok, #guild_skill{name = Skill, glev = Glev_limit, fund = F_Cost}} = guild_skill_data:get(guild_skill, {Type, Slev + 1}),
            case Glev >= Glev_limit of
                false ->
                    sys_conn:pack_send(ConnPid, 12739, {?false, ?MSGID(<<"军团等级不足">>)}),
                    {ok};
                true when Fund >= F_Cost ->
                    NewSlev = Slev + 1,
                    NewGuild = guild:alters([{fund, Fund - F_Cost}, {skills, lists:keyreplace(Type, 1, Skills, {Type, NewSlev})}], Guild),
                    guild_refresh:refresh(13731, {Type, NewSlev}, Mems),
                    [role:apply(async, Pid, {guild_common, pack_send_notice, [NewGuild]}) || #guild_member{pid = Pid} <- Mems, is_pid(Pid)],
                    guild:guild_chat(Mems, util:fbin(?L(<<"技能【{str, ~s, #9A32CD}】已升至 ~w 级">>), [Skill, NewSlev])),
                    sys_conn:pack_send(ConnPid, 12739, {?true, ?MSGID(<<"技能升级成功">>)}),
                    {ok, NewGuild};
                _ ->
                    sys_conn:pack_send(ConnPid, 12739, {?false, ?MSGID(<<"军团资金不足">>)}),
                    {ok}
            end
    end.

%% @spec claim_salary(Role) -> {false, Reason} | {ok, NewRole}
%% Role = NewRole = #role{}
%% Reason = binary()
%% @doc 领取俸禄
claim_salary(#role{guild = #role_guild{gid = 0}})->
    {false, <<>>};
claim_salary(Role = #role{id = {Rid, Rsrvid}, name = Rname, link = #link{conn_pid = ConnPid}, guild = #role_guild{gid = Gid, srv_id =  Gsrvid, claim_exp = Status}})->
    case Status =/= ?false of
        true ->
            {false, ?MSGID(<<"每天只可领取一次奖励">>)};
        false ->
            case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of 
                #guild{lev = Lev} ->
                    spawn(guild_log, log_claim, [Rid, Rsrvid, Rname, <<"领用军团每日奖励">>]),
                    Coin = guild_exp_data:get_bonus(Lev),
                    Role1 = guild_role:alters([{claim_exp, ?true}], Role),
                    Msg = util:fbin("获得金币~w", [Coin]),
                    notice:alert(succ, ConnPid, Msg),
                    guild_common:pack_send_notice(Role1),
                    role_gain:do([#gain{label = coin, val = Coin}], Role1);
                _ ->
                    {false, <<>>}
            end
    end.

%% @spec claim_skill(Type, Role) -> {false, Reason} | {ok, NewRole}
%% Role = NewRole = #role{}
%% Type = integer()
%% Reason = binary()
%% @doc 领用技能
claim_skill(_Type, #role{guild = #role_guild{gid = 0}}) ->
    {false, <<>>};
claim_skill(Type, Role = #role{id = {Rid, Rsrvid}, name = Rname, guild = #role_guild{gid = Gid, srv_id = Gsrvid, donation = DO, skilled = Skilled}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        Guild = #guild{skills = Skills, permission = {Limit, _, _}} when DO >= Limit ->
            case lists:keyfind(Type, 1, Skills) of
                {_, Lev} when Lev > 0 -> 
                    case lists:member(Type, Skilled) of
                        false ->
                            case role_gain:do(#loss{label = guild_devote, val = count_skills_cost(Skilled)}, Role) of
                                {ok, Role1} ->
                                    case add_able_skill_buff([{Type, Lev}], Role1) of
                                        {false, Reason} ->
                                            {false, Reason};
                                        Role2 ->
                                            spawn(guild_log, log_claim, [Rid, Rsrvid, Rname, <<"领用军团技能">>]),
                                            Role3 = guild_role:alters([{skilled, Type}], Role2),
                                            guild_common:pack_send_notice(Role3, Guild),
                                            {ok, role_api:push_attr(Role3)}
                                    end;
                                _ ->
                                    {false, ?MSGID(<<"可用军团贡献不足">>)}
                            end;
                        _ ->
                            {false, ?MSGID(<<"每天只可以领取一次">>)}
                    end;
                {_, 0} ->
                    {false, ?MSGID(<<"不可领用未学习的技能">>)};
                _ ->
                    {false, <<>>}
            end;
        #guild{} ->
            {false, ?MSGID(<<"累积军团贡献低于使用限制！">>)};
        _ ->
            {false, <<>>}
    end.

%% @spec claim_skill(Role) -> {false, Reason} | {ok, NewRole}
%% Role = NewRole = #role{}
%% Reason = binary()
%% @doc 一键领用所有技能
claim_skill(#role{guild = #role_guild{gid = 0}}) ->
    {false, ?MSGID(<<"">>)};
claim_skill(Role = #role{id = {Rid, Rsrvid}, name = Rname, guild = #role_guild{gid = Gid, srv_id = Gsrvid, donation = DO, skilled = Skilled}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{skills = Skills, permission = {Limit, _, _}} when DO >= Limit ->
            case get_able_skills(Skills, Skilled) of
                [] -> {false, ?MSGID(<<"没有可用的技能可领取">>)};
                AbleSkills ->
                    case role_gain:do(#loss{label = guild_devote, val = count_skills_cost(Skilled)}, Role) of
                        {ok, Role1} ->
                            case add_able_skill_buff(AbleSkills, Role1) of
                                {false, _Reason} ->
                                    {false, ?MSGID(<<"增加军团技能BUFF失败">>)};
                                Role2 ->
                                    spawn(guild_log, log_claim, [Rid, Rsrvid, Rname, <<"领用军团技能">>]),
                                    Role3 = guild_role:alters([{skilled, Type} || {Type, _} <- AbleSkills], Role2),
                                    {ok, role_api:push_attr(Role3)}
                            end;
                        _ ->
                            {false, ?MSGID(<<"可用军团贡献不足">>)}
                    end
            end;
        #guild{} ->
            {false, ?MSGID(<<"累积军团贡献低于使用限制！">>)};
        _ ->
            {false, ?MSGID(<<"">>)}
    end.

%% @spec bulletin(Bulletin, QQ, YY, Role) -> {false, Reason} | ok
%% Bulletin = QQ = YY = Reason = binary()
%% Role = #role{}
%% @doc 修改军团公告
bulletin(_Bulletin, _QQ, _YY, #role{guild = #role_guild{gid = 0}}) -> {false, <<>>};
bulletin(_Bulletin, _QQ, _YY, #role{guild = #role_guild{authority = Auth}}) when Auth < ?alter_bulletin ->
    {false, ?MSGID(<<"权限不足">>)};
bulletin(Bulletin, QQ, YY, #role{link = #link{conn_pid = ConnPid}, guild = #role_guild{pid = Pid}}) ->
    guild:apply(async, Pid, {?MODULE, async_bulletin, [Bulletin, QQ, YY, ConnPid]}).

%% @spec async_bulletin(Guild, Bulletin, QQ, YY, ConnPid) -> {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% Bulletin = QQ = YY = binary()
%% ConnPid = pid()
%% @doc 修改军团公告
async_bulletin(Guild = #guild{members = Mems}, Bulletin, QQ, YY, ConnPid) ->
    NewGuild = guild:alters([{bulletin, {Bulletin, QQ, YY}}], Guild),
    guild:guild_chat(Mems, ?MSGID(<<"军团公告 有更新">>)),
    guild_mgr:listen(guild_rank, NewGuild),    %% 军团管理进程 数据副本监听
    sys_conn:pack_send(ConnPid, 12710, {?true, ?MSGID(<<"军团公告修改成功">>)}), 
    {ok, NewGuild}.

%% @spec permission(Skill, Stove, Store, Role) -> {false, Reason} | ok
%% Skill = Stove = Store = integer()
%% Role = #role{}
%% Reason = binary()
%% @doc 修改军团权限限制值
permission(_Skill, _Stove, _Store, #role{guild = #role_guild{gid = 0}}) -> {false, <<>>};
permission(_Skill, _Stove, _Store, #role{guild = #role_guild{authority = Auth}}) when Auth < ?alter_permission ->
    {false, ?MSGID(<<"权限不足">>)};
permission(Skill, Stove, Store, #role{link = #link{conn_pid = ConnPid}, guild = #role_guild{pid = Pid}}) ->
    guild:apply(async, Pid, {?MODULE, async_permission, [Skill, Stove, Store, ConnPid]}).

%% @spec async_permission(Guild, Skill, Stove, Store, ConnPid) -> {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% Skill = Stove = Store = integer()
%% ConnPid = pid()
%% @doc 修改权限值
async_permission(Guild = #guild{members = Mems}, Skill, Stove, Store, ConnPid) ->
    NewGuild = guild:alters([{permission, {Skill, Stove, Store}}], Guild),
    guild:guild_chat(Mems, ?L(<<"军团长修改了 技能 神炉 的使用贡献限制">>)),
    sys_conn:pack_send(ConnPid, 12745, {?true, ?MSGID(<<"权限限制修改成功">>)}), 
    {ok, NewGuild}.

%% @spec email(Subject, Text, Role) -> {true, Msg} | {false, Reasno}
%% Subject = Text = Msg = Reason = binary()
%% Role = #role{}
%% @doc 帮主给军团成员群发邮件
email(_Subject, _Text, #role{guild = #role_guild{position = Position}}) when Position =/= ?guild_chief ->
    {false, ?MSGID(<<"权限不足">>)};
email(Subject, Text, #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{members = Members, pid = Pid} ->
            case guild:guild_loss(Pid, ?email_cost) of
                {false, Reason} ->
                    {false, Reason};
                true ->
                    guild:guild_mail({Gid, Gsrvid}, {Subject, Text}),
                   guild:guild_chat(Members, ?L(<<"各团友，请查收军团邮件">>)),
                    {ok, ?MSGID(<<"军团邮件发送成功">>)}
            end;
        _ ->
            {false, <<>>}
    end.

%% @spec send_offline_msg(Subject, Text, Role) -> {true, Msg} | {false, Reasno}
%% Subject = Text = Msg = Reason = binary()
%% Role = #role{}
%% @doc 团长给军团成员发送离线信息
send_offline_msg(_Text, #role{guild = #role_guild{position = Position}}) when Position =/= ?guild_chief ->
    {false, ?MSGID(<<"权限不足">>)};
send_offline_msg(Text, #role{id = SelfId, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{members = Mems} ->
            Mems1 = [M || M = #guild_member{id = Id} <- Mems, Id =/= SelfId],
            spawn(guild_common, do_send_offline_msg, [Text, Mems1]),
            {ok, ?MSGID(<<"发送信息成功">>)};
        _ ->
            {false, 0}
    end.

do_send_offline_msg(Text, Mems) ->
    [notification:send(offline, Id, ?notify_type_wanted, Text, []) || #guild_member{id = Id} <- Mems ].


%% 军团通知信息
%% 军团技能领取
pack_send_notice(#role{link = #link{conn_pid = ConnPid}, guild = #role_guild{claim_exp= _ClaimExp, donation = _DO, skilled = Skilled}}, #guild{skills = Skills, permission = {_Limit, _, _}}) ->
    NoticeSkill = [{?notice_type_skill, length(get_able_skills(Skills, Skilled))}],
    sys_conn:pack_send(ConnPid, 13732, {NoticeSkill}),
    {ok}.

%% 申请列表
pack_send_notice(#guild{apply_list = ApplyList, members = Mems}) ->
    ChiefPid = [Pid || #guild_member{pid = Pid, position = ?guild_chief} <- Mems, is_pid(Pid)],%%在线的团长
    ElderPid = [Pid || #guild_member{pid = Pid, position = ?guild_elder} <- Mems, is_pid(Pid)],
    Pids = ChiefPid ++ ElderPid,
    Len = length(ApplyList),
    [role:apply(async, RolePid, {fun send_notice / 2, [Len]}) || RolePid <- Pids],
    {ok};

%% 奖励 & 技能
pack_send_notice(#role{guild = #role_guild{gid = 0}}) -> ok;
pack_send_notice(#role{link = #link{conn_pid = ConnPid}, guild = #role_guild{gid = Gid, srv_id = Gsrvid, claim_exp= ClaimExp, skilled = Skilled, position = Pos}}) ->
    Claim = [{?notice_type_claim, case ClaimExp =:= 0 of true-> 1; _->0 end}],
    {S, A} =
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{skills = Skills, apply_list = List} ->
            {{?notice_type_skill, length(get_able_skills(Skills, Skilled))}, {?notice_type_apply, length(List)}};
        _ -> {{?notice_type_skill, 0}, {?notice_type_apply, 0}}
    end,
    case Pos =:= ?guild_chief orelse Pos =:= ?guild_elder of
        true ->
            sys_conn:pack_send(ConnPid, 13732, {Claim ++ [S,A]});
        false ->
            sys_conn:pack_send(ConnPid, 13732, {Claim ++ [S]})
    end,
    {ok}.

send_notice(#role{link = #link{conn_pid = ConnPid}}, Len) ->
    sys_conn:pack_send(ConnPid, 13732, {[{?notice_type_apply, Len}]}),
    {ok}.

%% @spec upgrade(Role) -> {ok, NewRole} | {false, Reason}
%% Role = #role{}
%% @doc 升级军团到VIP帮会
upgrade(#role{guild = #role_guild{position = Position}}) when Position =/= ?guild_chief ->
    {false, ?L(<<"权限不足">>)};
upgrade(Role = #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{gvip = ?guild_piv, pid = Pid, map = MapPid} ->
            case map:role_list(MapPid) of
                [] -> 
                    Gold = pay:price(?MODULE, upgrade_vip, ignore),
                    role:send_buff_begin(),
                    case role_gain:do([#loss{label = gold, val = Gold}], Role) of
                        {ok, NewRole} ->
                            case guild:apply(sync, Pid, {?MODULE, sync_upgrade, []}) of
                                true ->
                                    role:send_buff_flush(),
                                    {ok, NewRole};
                                {false, Reason} -> 
                                    role:send_buff_clean(),
                                    {false, Reason};
                                _ ->
                                    role:send_buff_clean(),
                                    {false, ?L(<<"请稍候再试">>)}
                            end;
                        _ ->
                            role:send_buff_clean(),
                            {false, gold_less}
                    end;
                _ ->
                    {false, ?L(<<"在升级军团前，请让所有军团成员先离开帮会领地">>)}
            end;
        #guild{gvip = ?guild_vip} ->
            {false, ?L(<<"您军团已经是VIP军团，无需升级！">>)};
        _ ->
            {false, <<>>}
    end.

%% @spec degrade(Role) -> ok
%% Role = #role{}
%% @doc 降级军团到非VIP帮会
degrade(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{gvip = ?guild_vip, pid = Pid, map = MapPid} ->
            case map:role_list(MapPid) of
                [] ->
                    case guild:apply(sync, Pid, {?MODULE, sync_degrade, []}) of
                        true -> ok;
                        {false, Reason} -> {false, Reason};
                        _ -> {false, ?L(<<"请稍候再试">>)}
                    end;
                _ ->
                    {false, ?L(<<"在降级军团前，请让所有军团成员先离开军团领地">>)}
            end;
        #guild{gvip = ?guild_piv} ->
            {false, ?L(<<"您军团不是VIP军团，不可降级！">>)};
        _ ->
            {false, <<>>}
    end.

%% @spec sync_upgrade(Guild) -> NewGuild
%% Guild = NewGuild = #guild{}
%% @doc 升级军团到VIP帮会
sync_upgrade(Guild = #guild{pid = Pid, gvip = ?guild_piv}) ->
    case get(member_manage) of
        undefined ->
            NewGuild = Guild#guild{gvip = ?guild_vip},
            guild:restart(Pid, upgrade, <<"升级VIP军团">>),
            {ok, true, NewGuild};
        _ -> {ok, {false, ?L(<<"军团集体性活动中，禁止退出军团">>)}}
    end;
sync_upgrade(_Guild) ->
    {ok, {?false, ?L(<<"您军团已经是VIP军团">>)}}.

%% @spec sync_degrade(Guild) -> NewGuild
%% Guild = NewGuild = #guild{}
%% @doc 降级军团到非VIP帮会
sync_degrade(Guild = #guild{pid = Pid, gvip = ?guild_vip}) ->
    case get(member_manage) of
        undefined ->
            NewGuild = Guild#guild{gvip = ?guild_piv},
            guild:restart(Pid, degrade, <<"降级非VIP军团">>),
            {ok, true, NewGuild};
        _ -> {ok, {false, ?L(<<"军团集体性活动中，禁止退出军团">>)}}
    end;
sync_degrade(_Guild) ->
    {ok, {?false, ?L(<<"您军团已经是普通军团">>)}}.


%% @spec wish(Role) -> {ok, #wish{}}
%% Role = #role{}
%% @doc 许愿
wish(#role{guild = #role_guild{gid = Gid}}) when Gid =:= 0 ->
    {false, ?MSGID(<<"还没加入军团">>)};
wish(#role{guild = #role_guild{wish = #wish{times = Times}}}) when Times =< 0 ->
    {false, ?MSGID(<<"许愿次数不足">>)}; %%次数不足

wish(#role{guild = #role_guild{wish = #wish{item = Item}}}) when Item =/= 0 ->
    {false, ?MSGID(<<"请先领取物品">>)}; %%

wish(Role = #role{name = Rname, link = #link{conn_pid = ConnPid}, guild = #role_guild{gid = Gid, srv_id = Gsrvid, wish = Wish = #wish{times = Times}}}) ->
    case role_gain:do(#loss{label = guild_devote, val = ?wish_cost}, Role) of
        {false, _Reason} ->
            {false, ?MSGID(<<"军团贡献不足">>)};

        {ok, Role1} ->
            case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
                #guild{wish_pool_lvl = ShopLvl} ->
                    case gen_rand_wish_item(ShopLvl) of
                        {false, Reason} -> {false, Reason};
                        {Type, ItemId, Num, IsGood, _} ->
                            ?DEBUG("------->> 许愿物品 ~p ~p ~p", [Type, ItemId, Num]),
                            case IsGood =:= 1 of
                                true -> guild:apply(sync, {Gid, Gsrvid}, {?MODULE, sync_set_wish_item_log, [Rname, ConnPid, Type, ItemId, Gid, Gsrvid]});
                                false -> skip
                            end,
                            Role2 = guild_role:alters([{wish, Wish#wish{times = Times-1, last_time = util:unixtime(), type = Type, item = ItemId, num = Num}}], Role1),
                            {ok, Role2}
                    end
           end
   end.

%%获取许愿得到的物品
get_wish_item(#role{guild = #role_guild{wish = #wish{item = Item}}}) when Item =:= 0 ->
    {false, ?MSGID(<<"没有可获取的许愿物品">>)};
get_wish_item(Role = #role{link = #link{conn_pid = ConnPid}, guild = #role_guild{wish = Wish = #wish{item = Item, num = Num}}}) ->
    case item:make(Item, 1, Num) of
        false -> 
            {false, ?MSGID(<<"">>)};
        {ok, ItemList} ->
            case storage:add(bag, Role, ItemList) of
                false ->
                    notice:alert(error, ConnPid, ?MSGID(<<"背包空间不足">>)),
                    {false, ?MSGID(<<"背包空间不足">>)};
                {ok, NewBag} ->
                    notice:alert(succ, ConnPid, ?MSGID(<<"领取成功">>)),
                    NewRole = Role#role{bag = NewBag},
                    NewRole1 = guild_role:alters([{wish, Wish#wish{type = 0, item=0}}], NewRole),
                    {ok, NewRole1}
            end
    end.

%% 许愿池:记录大奖列表
sync_set_wish_item_log(Guild = #guild{wish_item_log = WishItemLog}, Rname, ConnPid, _Type, Item, Gid, Gsrvid) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        false ->
            {ok};
        _ ->
            Log = {util:fbin(<<"~s">>, [Rname]), Item, util:unixtime()},
            case do_log_wish_item(Log, WishItemLog) of
                {ok, NewLog} -> 
                    NewGuild = #guild{wish_item_log = Logs} = guild:alters([{wish_item_log, NewLog}], Guild),
                    sys_conn:pack_send(ConnPid, 12795, {Logs}),
                    {ok, NewGuild};
                {false} -> 
                    {ok}
            end
    end.

do_log_wish_item(AddLog, OldLog) ->
    case length(OldLog) < 10 of
        true ->
            {ok, [AddLog|OldLog]};
        false ->
            {ok, [AddLog| OldLog -- [lists:last(OldLog)]]}
    end.

%% @spec wish_item_log(Role) -> List
%% Role = #role{}
%% @doc 军团许愿大奖列表
get_wish_item_log(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{wish_item_log = WishItemLog} -> WishItemLog;
        _ -> []
    end.

%% @spec get_can_buy_list(Role) -> List
%% Role = #role{}
%% @doc 获取军团商城可购买列表
get_can_buy_list(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{shop = ShopLvl} -> get_items_by_shoplvl(ShopLvl);
        _ -> []
    end.

%% @spec item_can_buy(ItemId, Role) -> List
%% Role = #role{}
%% @doc 获取军团商城可购买列表
item_can_buy(ItemId,#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{shop = ShopLvl} -> 
           Ret = case is_valid_item_in_shop(ShopLvl, ItemId) of
                true -> true;
                false -> false
            end,
            Ret;
        _ -> false
    end.

buy(_ItemdId, #role{guild = #role_guild{shop = #shop{times = Times}}}) when Times =< 0 ->
    {false, ?MSGID(<<"今天购买次数不足">>)};
buy(ItemId, Role = #role{guild = #role_guild{shop = Shop = #shop{times = Times}}}) ->
    Res = guild_shop_data:cost(ItemId),
    case Res of
        false ->
            {false, ?MSGID(<<"商城中不存在此商品">>)};
        NeedDevote ->
            case item:make(ItemId, 1, 1) of
                false -> 
                    {false, ?MSGID(<<"">>)}; %% 配置表没有此物品
                {ok, ItemList} ->
                    case storage:add(bag, Role, ItemList) of
                        false ->
                            {false, ?MSGID(<<"背包空间不足">>)};
                        {ok, NewBag} ->
                            case role_gain:do(#loss{label = guild_devote, val = NeedDevote}, Role) of
                                {false, _} ->
                                    {false, ?MSGID(<<"个人贡献不足">>)};
                                {ok, Role1} ->
                                    Role2 = Role1#role{bag = NewBag},
                                    Role3 = guild_role:alters([{shop, Shop#shop{times = Times-1, last_time = util:unixtime()}}], Role2),
                                    {ok, Role3, NeedDevote}
                            end
                    end
            end
    end.

%% 获取军团总战力
guild_fc({Gid, Gsrvid}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{members = Members} ->
            F = fun(#guild_member{fight = Fc}, Sum) -> Sum + Fc end,
            SumFc = lists:foldl(F, 0, Members),
            SumFc;
        _ ->
            0
    end.

set_join_limit(_, #role{guild = #role_guild{gid = 0}}) -> {false, ?MSGID(<<"你还没有加入军团">>)};
set_join_limit(_, #role{guild = #role_guild{authority = Auth}}) when Auth =/= ?chief_op andalso Auth =/= ?elder_op-> {false, ?MSGID(<<"权限不足">>)};
set_join_limit({Lev, Zdl}, #role{guild = #role_guild{pid = Pid}}) ->
    guild:apply(async, Pid, {?MODULE, async_set_join_limit, [Lev, Zdl]}).

async_set_join_limit(Guild = #guild{}, Lev, Zdl) ->
    {ok, Guild#guild{join_limit = #join_limit{lev = Lev, zdl = Zdl}}}.


%%--------------------------------------------------------------------
%% 私有函数
%%--------------------------------------------------------------------

notify_bypid(Pid, V) when is_pid(Pid) ->
    role:pack_send(Pid, 13700, V);
notify_bypid(_Pid, _V) -> skip.

get_items_by_shoplvl(ShopLvl) ->
    Res = guild_shop_data:get(ShopLvl),
    case Res of
        {ok, ItemList} -> ItemList;
        _ -> []
    end.


is_valid_item_in_shop(_ShopLvl, _ItemId) -> true.

%% 许愿抽奖
%% -> {Type, ItemId, Number, IsGood, Rate}
gen_rand_wish_item(GuildLvl) ->
    case guild_wish_data:get(GuildLvl) of
        false ->
            {false, ?MSGID(<<"找不到军团许愿物品配置">>)};
        AllItems ->
            AllRate = calc_all_rate(AllItems),
            %% ?DEBUG("********* all rate: ~p", [AllRate]),
            Rate = util:rand(1, AllRate),
            get_item_by_rate(AllItems, Rate)
    end.

%% 根据权重找出符合的物品
get_item_by_rate(ItemList, Rate) ->
    do_get_item(ItemList, 0, Rate).

do_get_item([], _, _) -> false;
do_get_item([Item = {_Type, _ItemId, _Num, _IsGood, ItemRate} | T], NowRate, Rate) ->
    case Rate =< NowRate+ItemRate of
        true -> Item;
        false -> do_get_item(T, NowRate+ItemRate, Rate)
    end.

%% 获取许愿物品中所有权重之和
calc_all_rate(ItemList) ->
    lists:sum([Rate|| {_,_,_,_,Rate} <- ItemList]).

get_able_skills(Skills, Skilled) ->
    [{Type, Lev} || {Type, Lev} <- clear_skilled(Skills, Skilled), Lev > 0].

%% 去除已领用过技能
clear_skilled(Skills, []) -> Skills;
clear_skilled(Skills, [Type | T]) -> 
    clear_skilled(lists:keydelete(Type, 1, Skills), T).

%% 计算累积消费
count_skills_cost(Skilled) ->
    skill_cost(length(Skilled)).

%% 领用技能消耗
skill_cost(0) -> 10;
skill_cost(1) -> 20;
skill_cost(2) -> 40;
skill_cost(3) -> 80;
skill_cost(4) -> 160;
skill_cost(5) -> 480;
skill_cost(6) -> 640.

%% 加上buff
add_able_skill_buff([], Role) ->
    Role;
add_able_skill_buff([{Type, Lev} | Skills], Role) ->
    {ok, #guild_skill{buff = Label}} = guild_skill_data:get(guild_skill, {Type, Lev}),
    case buff_data:get(Label) of
        {ok, Buff} ->
            case buff:add(Role, Buff#buff{end_date = {date(), {23,59,59}}}) of
                {ok, NewRole} ->
                    add_able_skill_buff(Skills, NewRole);
                {false, Reason} ->
                    {false, Reason}
            end;
        _ ->
            {false, ?MSGID(<<"领用技能失败">>)}
    end.

%% Lev -> 当前等级
%% Now -> 当前经验
%% Val -> 要加的经验

%% exp2lev  -> 新等级 , 新经验
exp2lev(Lev, Now, _) when Lev >= ?max_guild_lev -> {Lev, Now};  %% 等级限制
exp2lev(Lev, Now, Val) ->
    Need = guild_exp_data:get(Lev+1),
    case Now + Val >= Need of
        true ->
            exp2lev(Lev + 1, 0, Now + Val - Need);
        false ->
            {Lev, Now + Val}
    end.


%% *********  GM ***********

%% @spec upgrade_guild(Role) -> ok | {false, Reason}
%% Role = #role{}
%% Reason = binary()
%% @doc 军团提升
set_guild_lev(#role{link = #link{conn_pid = ConnPid}, guild = #role_guild{gid = 0}}, _NewLev) ->
    sys_conn:pack_send(ConnPid, 10931, {58, ?L(<<"你没有军团">>), []});
set_guild_lev(#role{link = #link{conn_pid = ConnPid}, guild = #role_guild{pid = Pid}}, NewLev) ->
    guild:apply(async, Pid, {?MODULE, async_set_guild_lev, [ConnPid, NewLev]}).

%% @spec async_upgrade_guild(Guild, ConnPid) -> {ok} | {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% ConnPid = pid()
%% @doc 提升军团
async_set_guild_lev(#guild{}, ConnPid, NewLev) when NewLev >= ?max_guild_lev ->
    sys_conn:pack_send(ConnPid, 10931, {58, ?L(<<"军团已经是最高等级">>), []}),
    {ok};
async_set_guild_lev(Guild = #guild{members = Mems, rtime = Rtime}, ConnPid, NewLev) ->
    {ok, #guild_lev{maxnum = MaxNum}} = guild_data:get(guild_lev, NewLev),
    NewGuild = guild:alters([{lev, NewLev},{maxnum, MaxNum}, {rtime, [{NewLev, util:unixtime()}|Rtime]}], Guild),
    spawn(guild_rss, upgrade_lev, [NewGuild]),
    guild:guild_chat(Mems, util:fbin(?L(<<"军团 已升至 ~w 级">>), [NewLev])),
    sys_conn:pack_send(ConnPid, 12743, {?true, ?MSGID(<<"军团升级成功">>)}),
    ?DEBUG("**********  军团升级成功  **********"),
    {ok, NewGuild}.


