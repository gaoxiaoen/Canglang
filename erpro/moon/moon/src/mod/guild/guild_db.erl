%----------------------------------------------------
%%  帮会数据数据库操作
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_db).
-export([load/0
        ,load_special_role_guild/0
        ,save/1
        ,save_special_role_guild/1
    ]
).

-include("common.hrl").
-include("guild.hrl").
-include("role.hrl").
-include("storage.hrl").
-include("item.hrl").

%% @spec load() -> List | error
%% List = [#guild{} |...]
%% @doc 重载帮会数据
load() ->
    Sql = <<"select id, srv_id, name, ver, status, vip, lev, number, max_num, fund, day_fund, weal, stove, bulletin, chief, members, permission, aims, treasure, treasure_log, contact_image, rtime, skills, store, store_log, apply_list, note_list, donation_log, data from sys_guild">>,
    case db:get_all(Sql) of
        {ok, Guilds} -> 
            ?DEBUG("++++++++++++++++++ loding data from db +++++++++++++++++++++++"),
            convert_guild_record(Guilds);
        {error, _Why} ->
            ?ERR("帮会数据数据重载失败, 【Reason: ~s】", [_Why]),
            error
    end.

%% @spec load_special_role_guild() -> #special_role_guild{} | error
%% Srvid = binary()
%% @doc 查询角色的帮会扩展信息，该信息保存在sys_special_role_guild表中, 其中id值为0 
load_special_role_guild() ->
    Sql = <<"select id, srv_id, status, fire, gid, gsrv_id, join_date, applyed, invited, updates from sys_special_role_guild">>,
    case db:get_all(Sql) of
        {ok, Specs} ->
            convert_special_role_guild(Specs);
        {error, _Why} ->
            ?ERR("角色帮会扩展信息重载失败, 【Reason: ~s】", [_Why]),
            error
    end.

%% @spec save(Guild) -> true | false
%% Guild = #guild{}
%% @doc 保存帮会数据到数据库中, 后续新增扩展数据，将存储到 data 字段，通过 pack_ext_data 统一打包
save(Guild = #guild{id = {ID, Srvid}, name = Name, ver = Ver, status = Status, gvip = Vip, lev = Lev, num = Number,
        maxnum = MaxNum, fund = Fund, day_fund = DayFund, weal = Weal, stove = Stove, bulletin = Bulletin, chief = Chief, rvip = ChiefVip, 
        members = Members, permission = Permission, aims = Aims, treasure = Treasure, treasure_log = TreasureLog, contact_image = ContactImage,
        rtime = Rtime, skills = Skills, store = Store, store_log = StoreLog, apply_list = ApplyList, note_list = NoteList, donation_log = DonationLog}
)->
    Sql = <<"replace into sys_guild(id, srv_id, name, ver, status, vip, lev, number, max_num, fund, day_fund, weal, stove, bulletin, chief, members, permission, aims, treasure, treasure_log, contact_image, rtime, skills, store, store_log, apply_list, note_list, donation_log, data) values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    Args = [ID, Srvid, Name, Ver, Status, Vip, Lev, Number, MaxNum, Fund, DayFund, Weal, Stove, 
        util:term_to_bitstring(Bulletin),
        util:term_to_bitstring({Chief, ChiefVip}), 
        util:term_to_bitstring([M#guild_member{pid = 0} || M <- Members]), 
        util:term_to_bitstring(Permission), 
        util:term_to_bitstring(transfer_list_ascll(Aims)), 
        util:term_to_bitstring(Treasure), 
        util:term_to_bitstring(TreasureLog), 
        util:term_to_bitstring(ContactImage), 
        util:term_to_bitstring(Rtime), 
        util:term_to_bitstring(pack_skill_info(Skills)), 
        util:term_to_bitstring(pack_store_info(Store)), 
        util:term_to_bitstring(StoreLog), 
        util:term_to_bitstring(ApplyList), 
        util:term_to_bitstring(NoteList), 
        util:term_to_bitstring(DonationLog), 
        util:term_to_bitstring(pack_ext_data(Guild))],
    case db:execute(Sql, Args) of
        {ok, _Result} ->
            true;
        {error, _Why} ->
            ?ERR("帮会 [~w,~s,~s] 数据管理进程执行数据操作时发生错误, 【Reason: ~s】~n【~s】", [ID, Srvid, Name, _Why, Sql]),
            false
    end.

%% @spec save_special_role_guild(Srvid, Data) -> false | true
%% Srvid = binary()
%% Data = [#special_role_guild{} | ...]
%% @doc 保存角色帮会扩展属性
save_special_role_guild(#special_role_guild{id = {Rid, Rsrvid}, applyed = Applyed, invited = Invited, 
        guild = {Gid, Gsrvid, Date}, status = Status, updates = Updates, fire = Fire}
) ->
    Sql = <<"replace into sys_special_role_guild(id, srv_id, status, fire, gid, gsrv_id, join_date, applyed, invited, updates) 
            values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    Args = [Rid, Rsrvid, Status, Fire, Gid, Gsrvid, Date, util:term_to_string(Applyed), util:term_to_string(Invited), util:term_to_string(Updates)],
    case db:execute(Sql, Args) of
        {ok, _Result} ->
            true;
        {error, _Why} ->
            ?ERR("保存角色 [~w,~s] 帮会扩展属性数据时发生错误, 【Reason: ~s】~n【~s】", [Rid, Rsrvid, _Why, Sql]),
            false
    end.

%%-------------------------------------------------------------------------
%% 私有函数
%%-------------------------------------------------------------------------
%% 打包帮会技能属性，用于后台查询
pack_skill_info(Skills) ->
    pack_skill_info(Skills, []).
pack_skill_info([], Skills) ->
    Skills;
pack_skill_info([{Type, Lev} | T], Skills) ->
    {ok, #guild_skill{name = Name, desc = Desc}} = guild_skill_data:get(guild_skill, {Type, Lev}),
    pack_skill_info(T, [{Type, Lev, Name, Desc} | Skills]).

unpack_skill_info(Skills) ->
    unpack_skill_info(Skills, []). 
unpack_skill_info([], Skills) ->
    Skills;
unpack_skill_info([{Type, Lev, _, _} | T], Skills) ->
    unpack_skill_info(T, [{Type, Lev} | Skills]).

%% 打包帮会仓库属性，用于后台查询
pack_store_info(Store = #guild_store{items = Items, free_pos = FreePos}) ->
    Store#guild_store{items = pack_item_info(Items), free_pos = [X + 1000 || X <- FreePos]}.  
pack_item_info(Items) ->
    pack_item_info(Items, []).
pack_item_info([], Items) ->
    Items;
pack_item_info([Item = #item{base_id = BaseID} | T], Items) ->
    case item_data:get(BaseID) of
        {ok, #item_base{name = ItemName}} ->
            pack_item_info(T, [{ItemName, Item}|Items]);
        {false, Reason} ->
            ?ELOG("更新数据库时，包装帮会仓库物品信息操作发生错误，【base_id:~w, Reason: ~s】", [BaseID, Reason]),
            pack_item_info(T, Items)
    end.

unpack_store_info(Store = #guild_store{items = Items, free_pos = FreePos}) ->
    Fun = fun(X) -> case X >= 1000 of true -> X - 1000; false -> X end end,
    Store#guild_store{items = unpack_item_info(Items), free_pos = [Fun(X) || X <- FreePos]}.
unpack_item_info(Items) ->
    unpack_item_info(Items, []).
unpack_item_info([], Items) ->
    Items;
unpack_item_info([{_, Item} | T], Items) ->
    unpack_item_info(T, [Item | Items]).

%% 转换数据库中重载的帮会数据
convert_guild_record(Guilds) ->
    convert_guild_record(Guilds, []).
convert_guild_record([], List) ->
    List;
convert_guild_record([[ID, Srvid, Name, Ver, Status, Vip, Lev, Number, MaxNum, Fund, DayFund, Weal, Stove, BulletinStr, ChiefStr, MembersStr, PermissionStr, AimsStr, TreasureStr, TreasureLogStr, ContactImageStr, RtimeStr, SkillsStr, StoreStr, StoreLogStr, ApplyListStr, NoteListStr, DonationLogStr, DataStr] | T], List) ->
    Bulletin = str2term(BulletinStr),
    ChiefInfo = str2term(ChiefStr), 
    Members = str2term(MembersStr), 
    Permission = str2term(PermissionStr), 
    PAims = str2term(AimsStr), 
    Treasure = str2term(TreasureStr), 
    TreasureLog = str2term(TreasureLogStr), 
    ContactImage = str2term(ContactImageStr), 
    Rtime = str2term(RtimeStr), 
    PSkills = str2term(SkillsStr), 
    PStore = str2term(StoreStr), 
    StoreLog = str2term(StoreLogStr), 
    ApplyList = str2term(ApplyListStr), 
    NoteList = str2term(NoteListStr), 
    DonationLog = str2term(DonationLogStr), 
    Data = str2term(DataStr),
    L = [Bulletin, ChiefInfo, Members, Permission, PAims, Treasure, TreasureLog, ContactImage, Rtime, PSkills, PStore, StoreLog, ApplyList, NoteList, DonationLog, Data],
    case lists:any(fun(X) -> X =:= false end, L) of
        true ->
            ?ERR("[Module: guild_db] 帮会 [~s] 数据转换有误", [Name]),
            error;
        false ->
            {Chief, ChiefVip} = ChiefInfo,
            Skills = unpack_skill_info(PSkills),
            Store = unpack_store_info(PStore),
            Aims = un_transfer_list_ascll(PAims),
            NewStore = item_parse:parse_guildbag(Store),
            Guild = #guild{id = {ID, Srvid}, gid = ID, srv_id = Srvid, name = Name, ver = Ver, status = Status, gvip = Vip, lev = Lev, num = Number,
                maxnum = MaxNum, fund = Fund, day_fund = DayFund, weal = Weal, stove = Stove, bulletin = Bulletin, chief = Chief, rvip = ChiefVip, 
                members = Members, permission = Permission, aims = Aims, treasure = Treasure, treasure_log = TreasureLog, contact_image = ContactImage,
                rtime = Rtime, skills = Skills, store = NewStore, store_log = StoreLog, apply_list = ApplyList, note_list = NoteList, donation_log = DonationLog},
            NewGuild = unpack_ext_data(Guild, Data),    %% 扩展数据存储
            convert_guild_record(T, [NewGuild | List])
    end.

%% 转换数据库中重载的角色特殊帮会数据
convert_special_role_guild(Specs) ->
    convert_special_role_guild(Specs, []).
convert_special_role_guild([], List) ->
    List;
convert_special_role_guild([[Rid, Rsrvid, Status, Fire, Gid, Gsrvid, Date, Applyed, Invited, Updates] | T], List) ->
    A = str2term(Applyed),
    I = str2term(Invited),
    U = str2term(Updates),
    case lists:any(fun(X) -> X =:= false end, [A, I, U]) of
        true ->
            ?ERR("【Module: guild_db】角色【{~w,~s}】special_role_guild 数据[sys_special_role_guild]转换有误", [Rid, Rsrvid]),
            error;
        false ->
            convert_special_role_guild(T, [#special_role_guild{
                        id = {Rid, Rsrvid}, applyed = A, invited = I, guild = {Gid, Gsrvid, Date}, fire = Fire, status = Status, updates = U} | List])
    end.

%% str2term(Str) -> false | term()
str2term(Str) -> 
    case util:bitstring_to_term(Str) of
        {ok, A} ->
            A;
        {error, Why} ->
            ?ERR("对【~w】进行【util:string_to_term】发生错误, 【Reason:~w】", [Str, Why]),
            false
    end.

%% 
transfer_list_ascll(#guild_aims{
        lev = Levs, 
        weal = Weals, 
        stove = Stoves, 
        members = Mems, 
        skill_lev = SLev, 
        skill_learn = SLearn, 
        lev_claim = LevsC, 
        weal_claim = WealC, 
        stove_claim = StoveC, 
        members_claim = MemsC, 
        skill_lev_claim = SkillLevC, 
        skill_learn_claim = SLearnC}
) ->
    Fun = fun(List) -> [X + 1000 || X <- List] end,
    #guild_aims{lev = Fun(Levs), 
        weal = Fun(Weals), 
        stove = Fun(Stoves), 
        members = Fun(Mems), 
        skill_lev = Fun(SLev), 
        skill_learn = Fun(SLearn), 
        lev_claim = Fun(LevsC), 
        weal_claim = Fun(WealC), 
        stove_claim = Fun(StoveC), 
        members_claim = Fun(MemsC), 
        skill_lev_claim = Fun(SkillLevC), 
        skill_learn_claim = Fun(SLearnC)}.

un_transfer_list_ascll(#guild_aims{
        lev = Levs, 
        weal = Weals, 
        stove = Stoves, 
        members = Mems, 
        skill_lev = SLev, 
        skill_learn = SLearn, 
        lev_claim = LevsC, 
        weal_claim = WealC, 
        stove_claim = StoveC, 
        members_claim = MemsC, 
        skill_lev_claim = SkillLevC, 
        skill_learn_claim = SLearnC}
) ->
    Fun = fun(List) -> [X - 1000 || X <- List] end,
    #guild_aims{lev = Fun(Levs), 
        weal = Fun(Weals), 
        stove = Fun(Stoves), 
        members = Fun(Mems), 
        skill_lev = Fun(SLev), 
        skill_learn = Fun(SLearn), 
        lev_claim = Fun(LevsC), 
        weal_claim = Fun(WealC), 
        stove_claim = Fun(StoveC), 
        members_claim = Fun(MemsC), 
        skill_lev_claim = Fun(SkillLevC), 
        skill_learn_claim = Fun(SLearnC)}.

%%-----------------------------------------------------------------
%% 后续新增数据扩展保存，此处进行打包
%%-----------------------------------------------------------------
%% @spec pack_ext_data(Guild) -> PackedData
%% Guild = #guild{}
%% PackedData = term()
%% @doc 封装 ext_data 用于后续信息保存, 这里的 PackedData 数据应该与 unpack_ext_data 函数中的 PackedData 对应
pack_ext_data(#guild{impeach = Impeach, shop = Shop, exp = Exp, wish_item_log = Wish_Item_Log, wish_pool_lvl = PoolLvl, target_info = Target, join_limit = JoinLimit, jingpai = Jingpai}) ->
    PackedData = {Impeach, Shop, Exp, Wish_Item_Log, PoolLvl, Target, JoinLimit, Jingpai},
    PackedData.

%% @spec unpack_ext_data(Guild, PackedData) -> NewGuild
%% Guild = NewGuild = #guild{}
%% PackedData = term()
%% @doc 封装 ext_data 用于后续信息保存, 这里的 PackedData 数据应该与 pack_ext_data 函数中的 PackedData 对应
unpack_ext_data(Guild, {Impeach, Shop, Exp, WishItemLog, PoolLvl, Target, JoinLimit, Jingpai}) ->
    Guild#guild{impeach = Impeach, shop = Shop, exp = Exp, wish_item_log = WishItemLog, wish_pool_lvl = PoolLvl, target_info = Target, join_limit = JoinLimit, jingpai = Jingpai};
unpack_ext_data(Guild, _PackedData) ->
    Guild.

