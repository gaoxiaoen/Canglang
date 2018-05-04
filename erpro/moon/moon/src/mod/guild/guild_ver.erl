%%----------------------------------------------------
%% 帮会数据版本转换
%% @author liuweihua(yjbgwxf@gmail.com)
%% <div> 只需自定义 version_convert/2 函数</div>
%%----------------------------------------------------
-module(guild_ver).
-export([convert/1]).

-include("common.hrl").
-include("guild.hrl").
-include("version.hrl").
-include("storage.hrl").

-define(version_pos, 6).    %% 在帮会数据中，版本号固定在 6 号位置

%% @spec convert(Guild) -> NewGuild
%% Guild = tuple()
%% NewGuild = #guild{}
%% @doc 帮会数据转换
convert(Guild) ->
    case version_convert(Guild) of
        NewGuild when is_record(NewGuild, guild) ->
            NewGuild;
        _ ->
            ?ERR("帮会数据版本转换失败!"),
            Guild
    end.

%% 版本数据数据转换
version_convert(Guild) ->
    GuildVer = case erlang:element(?version_pos, Guild) of
        Ver when is_integer(Ver) -> Ver;
        _ -> 1
    end, 

    %% 当前帮会数据版本， 后续更新补上帮会数据版本
    NewGuild = version_convert(?guild_ver, GuildVer, Guild),       %% 注意返回新的数据版本 TODO 
    Store = NewGuild#guild.store,
    StoreItems = Store#guild_store.items,
    case item_parse:do(StoreItems) of
        {ok, NewStoreItems} -> 
            NewGuild#guild{ver = ?guild_ver, store = Store#guild_store{items = NewStoreItems}};
        _ ->
            ?ERR("帮会仓库物品列表转换失败"),
            false
    end.

%% 数据版本循环检测，并转换
version_convert(UpgradeVer, CurrentVer, Guild) when CurrentVer >= UpgradeVer ->  %% 检测并转换完成
    Guild;
version_convert(UpgradeVer, CurrentVer, Guild) ->
    NewGuild = version_convert(CurrentVer, Guild),   
    version_convert(UpgradeVer, CurrentVer + 1, NewGuild).

%%-------------------------------------------------------------------------------------------
%% @spec version_convert(Ver, Guild) -> NewGuild
%% Ver = integer()
%% @doc 版本升级，版本是逐级往上升的，例如：当前操作的版本为 ver，操作完后会自升级为 Ver + 1
%%-------------------------------------------------------------------------------------------
%% 第 1 版本 升 第 2 版本
version_convert(1, Guild) ->                %% 对第 1 版本数据进行转换
    Guild1 = convert_contact(Guild),
    Guild2 = convert_treasure_log(Guild1),
    Guild3 = convert_add_version(Guild2),
    Guild3;

%% 第 2 版本 升 第 3 版本
version_convert(2, Guild) ->
    convert_members(Guild);

%% 第 3 版本 升 第 4 版本
version_convert(3, Guild) ->
    convert_add_impeach(Guild);

%% 第 4 版本 升 第 5 版本
version_convert(4, Guild) ->
    convert_add_realm(Guild);

%% 第 5 版本 升 第 6 版本
version_convert(5, Guild) ->
    convert_add_treasure(Guild);

%% 第 6 版本 升 第 7 版本
version_convert(6, Guild) ->
    convert_add_pet_fight(Guild);

%% 第 7 版本 升 第 8 版本
version_convert(7, Guild) ->
    convert_add_guild_boss_treasure(Guild);

version_convert(8, Guild) ->
    convert_add_guild_jingpai(Guild);

%%TODO 每次版本升级，只需要在此处添加新的版本升级 版本升级中不可以使用 record 形式来操作 TODO
%% 每次升级版本，需要在 version.hrl 更新最新的帮会数据版本号

version_convert(_Ver, Guild) ->                %% 对第 1 版本数据进行转换
    ?ERR("错误的版本 [~w] 转换", [_Ver]),
    Guild.

%%--------------------------------------------------------------
%% 具体的转换过程
%%--------------------------------------------------------------
%% 增加通讯录映射字段，版本 1 升级
convert_contact({guild, Pid, Id, Gid, SrvId, Vip, Gvip, Name, Lev, Chief, Rvip, Members, Treasure, Num, MaxNum, Bulletin, Weal, Store, StoreLog, Stove, Fund, DayFund, ApplyList, ApplyNum, NoteList, DonaLog, Aims, Skills, Chairs, Perm, Map, Entrance, Rtime}) ->
    {guild, Pid, Id, Gid, SrvId, Vip, Gvip, Name, Lev, Chief, Rvip, Members, Treasure, Num, MaxNum, Bulletin, Weal, Store, StoreLog, Stove, Fund, DayFund, ApplyList, ApplyNum, NoteList, DonaLog, Aims, Skills, Chairs, Perm, Map, Entrance, Rtime, []};
convert_contact(Guild) -> 
    Guild.

%% 转换帮会宝库数据日志，版本 1 升级
convert_treasure_log({guild, Pid, Id, Gid, SrvId, Vip, Gvip, Name, Lev, Chief, Rvip, Members, Treasure, Num, MaxNum, Bulletin, Weal, Store, StoreLog, Stove, Fund, DayFund, ApplyList, ApplyNum, NoteList, DonaLog, Aims, Skills, Chairs, Perm, Map, Entrance, Rtime, ConTact}) when not(is_list(ApplyNum)) ->
    {guild, Pid, Id, Gid, SrvId, Vip, Gvip, Name, Lev, Chief, Rvip, Members, Treasure, Num, MaxNum, Bulletin, Weal, Store, StoreLog, Stove, Fund, DayFund, ApplyList, [], NoteList, DonaLog, Aims, Skills, Chairs, Perm, Map, Entrance, Rtime, ConTact};
convert_treasure_log(Guild) -> 
    Guild.

%% 增加销毁状态控制, 版本 1 升级
convert_add_version({guild, Pid, Id, Gid, SrvId, Vip, Gvip, Name, Lev, Chief, Rvip, Members, Treasure, Num, MaxNum, Bulletin, Weal, Store, StoreLog, Stove, Fund, DayFund, ApplyList, TreasureLog, NoteList, DonaLog, Aims, Skills, Chairs, Perm, Map, Entrance, Rtime, ConTact}) ->
    {guild, Pid, Id, Gid, SrvId, Vip, Gvip, Name, Lev, Chief, Rvip, Members, Treasure, Num, MaxNum, Bulletin, Weal, Store, StoreLog, Stove, Fund, DayFund, ApplyList, TreasureLog, NoteList, DonaLog, Aims, Skills, Chairs, Perm, Map, Entrance, Rtime, ConTact, 1};
convert_add_version(Guild) -> 
    Guild.

%% 转换帮会成员数据， 版本 2 升级
convert_members({guild, Pid, Id, Gid, SrvId, Ver, Gvip, Name, Lev, Chief, Rvip, Members, Treasure, Num, MaxNum, Bulletin, Weal, Store, StoreLog, Stove, Fund, DayFund, ApplyList, TreasureLog, NoteList, DonaLog, Aims, Skills, Chairs, Perm, Map, Entrance, Rtime, ConTact, Status}) ->
    NewMems = [convert_member_position(Mem) || Mem <- Members],
{guild, Pid, Id, Gid, SrvId, Ver, Gvip, Name, Lev, Chief, Rvip, NewMems, Treasure, Num, MaxNum, Bulletin, Weal, Store, StoreLog, Stove, Fund, DayFund, ApplyList, TreasureLog, NoteList, DonaLog, Aims, Skills, Chairs, Perm, Map, Entrance, Rtime, ConTact, Status};
convert_members(Guild) ->
    Guild.

%% 转换帮会成员职位数据， 版本 2 升级
convert_member_position({guild_member, Pid, ID, Rid, Srvid, Name, Lev, Career, Sex, Position, Gravatar, Vip, Fight, Auth, Donation, Coin, Gold, Date}) ->
    NewPosition = case Position of
        11 -> 20;
        10 -> 30;
        9 -> 30;
        8 -> 40;
        7 -> 40;
        6 -> 40;
        5 -> 40;
        _ -> 60
    end,
    {guild_member, Pid, ID, Rid, Srvid, Name, Lev, Career, Sex, NewPosition, Gravatar, Vip, Fight, Auth, Donation, Coin, Gold, Date}.

%% 转换弹劾帮主数据， 版本 3 升级
convert_add_impeach({guild, Pid, Id, Gid, SrvId, Ver, Gvip, Name, Lev, Chief, Rvip, Members, Treasure, Num, MaxNum, Bulletin, Weal, Store, StoreLog, Stove, Fund, DayFund, ApplyList, TreasureLog, NoteList, DonaLog, Aims, Skills, Chairs, Perm, Map, Entrance, Rtime, ConTact, Status}) ->
    {guild, Pid, Id, Gid, SrvId, Ver, Gvip, Name, Lev, Chief, Rvip, Members, Treasure, Num, MaxNum, Bulletin, Weal, Store, StoreLog, Stove, Fund, DayFund, ApplyList, TreasureLog, NoteList, DonaLog, Aims, Skills, Chairs, Perm, Map, Entrance, Rtime, ConTact, Status, {impeach, 0, 0, 0, 0, <<>>, <<>>}};
convert_add_impeach(Guild) -> Guild.

%% 转换阵营数据， 版本 4 升级
convert_add_realm({guild, Pid, Id, Gid, SrvId, Ver, Gvip, Name, Lev, Chief, Rvip, Members, Treasure, Num, MaxNum, Bulletin, Weal, Store, StoreLog, Stove, Fund, DayFund, ApplyList, TreasureLog, NoteList, DonaLog, Aims, Skills, Chairs, Perm, Map, Entrance, Rtime, ConTact, Status, Impeach}) ->
    {guild, Pid, Id, Gid, SrvId, Ver, Gvip, Name, Lev, Chief, Rvip, Members, Treasure, Num, MaxNum, Bulletin, Weal, Store, StoreLog, Stove, Fund, DayFund, ApplyList, TreasureLog, NoteList, DonaLog, Aims, Skills, Chairs, Perm, Map, Entrance, Rtime, ConTact, Status, Impeach, 0};
convert_add_realm(Guild) -> Guild.

%% 转换宝库数据， 版本 5 升级
convert_add_treasure({guild, Pid, Id, Gid, SrvId, Ver, Gvip, Name, Lev, Chief, Rvip, Members, {NextID, Treasures}, Num, MaxNum, Bulletin, Weal, Store, StoreLog, Stove, Fund, DayFund, ApplyList, TreasureLog, NoteList, DonaLog, Aims, Skills, Chairs, Perm, Map, Entrance, Rtime, ConTact, Status, Impeach, Realm}) when is_integer(NextID) ->
    {guild, Pid, Id, Gid, SrvId, Ver, Gvip, Name, Lev, Chief, Rvip, Members, {{NextID, Treasures, TreasureLog}, {1, [], []}}, Num, MaxNum, Bulletin, Weal, Store, StoreLog, Stove, Fund, DayFund, ApplyList, [], NoteList, DonaLog, Aims, Skills, Chairs, Perm, Map, Entrance, Rtime, ConTact, Status, Impeach, Realm};
convert_add_treasure(Guild) -> Guild.

%% 帮会成员列表增加仙宠战斗力数据,  版本 6 升级
convert_add_pet_fight({guild, Pid, Id, Gid, Srv_id, Ver, Gvip, Name, Lev, Chief, Rvip, Members, Treasure, Num, Maxnum, Bulletin, Weal, Store, Store_log, Stove, Fund, Day_fund, Apply_list, Treasure_log, Note_list, Donation_log, Aims, Skills, Chairs, Permission, Map, Entrance, Rtime, Contact_image, Status, Impeach, Realm}) ->
    NewMembers = [{guild_member, M_Pid, M_Id, M_Rid, M_Srv_id, M_Name, M_Lev, M_Career, M_Sex, M_Position, M_Gravatar, M_Vip, M_Fight, M_Authority, M_Donation, M_Coin, M_Gold, M_Date, 0}||{guild_member, M_Pid, M_Id, M_Rid, M_Srv_id, M_Name, M_Lev, M_Career, M_Sex, M_Position, M_Gravatar, M_Vip, M_Fight, M_Authority, M_Donation, M_Coin, M_Gold, M_Date} <- Members],
    {guild, Pid, Id, Gid, Srv_id, Ver, Gvip, Name, Lev, Chief, Rvip, NewMembers, Treasure, Num, Maxnum, Bulletin, Weal, Store, Store_log, Stove, Fund, Day_fund, Apply_list, Treasure_log, Note_list, Donation_log, Aims, Skills, Chairs, Permission, Map, Entrance, Rtime, Contact_image, Status, Impeach, Realm};
convert_add_pet_fight(Guild) -> Guild.

%% 增加帮会boss宝库类型
convert_add_guild_boss_treasure({guild, Pid, Id, Gid, Srv_id, Ver, Gvip, Name, Lev, Chief, Rvip, NewMembers, {TA, TB}, Num, Maxnum, Bulletin, Weal, Store, Store_log, Stove, Fund, Day_fund, Apply_list, Treasure_log, Note_list, Donation_log, Aims, Skills, Chairs, Permission, Map, Entrance, Rtime, Contact_image, Status, Impeach, Realm}) ->
    {guild, Pid, Id, Gid, Srv_id, Ver, Gvip, Name, Lev, Chief, Rvip, NewMembers, {TA, TB, {1, [], []}}, Num, Maxnum, Bulletin, Weal, Store, Store_log, Stove, Fund, Day_fund, Apply_list, Treasure_log, Note_list, Donation_log, Aims, Skills, Chairs, Permission, Map, Entrance, Rtime, Contact_image, Status, Impeach, Realm};
convert_add_guild_boss_treasure(Guild) ->
    Guild.

%% 增加竞拍  8 升 9
convert_add_guild_jingpai({guild, Pid, Id, Gid, Srv_id, Ver, Gvip, Name, Lev, Chief, Rvip, NewMembers, {TA, TB, {1, [], []}}, Num, Maxnum, Bulletin, Weal, Store, Store_log, Stove, Fund, Day_fund, Apply_list, Treasure_log, Note_list, Donation_log, Aims, Skills, Chairs, Permission, Map, Entrance, Rtime, Contact_image, Status, Impeach, Realm, Shop, Exp, Wish_item_log, Wish_pool_lvl, Target_info, JoinLimit}) ->
    {guild, Pid, Id, Gid, Srv_id, Ver, Gvip, Name, Lev, Chief, Rvip, NewMembers, {TA, TB, {1, [], []}}, Num, Maxnum, Bulletin, Weal, Store, Store_log, Stove, Fund, Day_fund, Apply_list, Treasure_log, Note_list, Donation_log, Aims, Skills, Chairs, Permission, Map, Entrance, Rtime, Contact_image, Status, Impeach, Realm, Shop, Exp, Wish_item_log, Wish_pool_lvl, Target_info, JoinLimit, #jingpai{}};
convert_add_guild_jingpai(Guild) ->
    Guild.
