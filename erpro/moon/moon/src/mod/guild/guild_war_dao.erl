%% --------------------------------------------------------------------
%% 帮战数据库处理
%% @author abu@jieyou.cn
%% @end
%% --------------------------------------------------------------------
-module(guild_war_dao).

-export([
        save_war_mgr/3
        ,load_war_mgr/0
        ,save_war/1
        ,load_last_war/0
        ,get_last_2_war/0
        ,get_own_count/1
    ]).

%% include file
-include("common.hrl").
-include("guild_war.hrl").

%% --------------------------------------------------------------------
%% api functions
%% --------------------------------------------------------------------

%% @spec save_war_mgr(IsFirst, Guilds) 
%% IsFirst = 0 | 1
%% Guilds = [#guild_war_guild{}, ...]
%% 保存帮战管理进程数据
save_war_mgr(IsFirst, OwnerGid, Guilds) ->
    Sql = "select * from sys_guild_war_mgr",
    case db:get_row(Sql) of
        {error, undefined} ->
            InsertSql = "insert into sys_guild_war_mgr(is_first, owner, guilds, srv_id) values (~s, ~s, ~s, ~s)",
            db:execute(InsertSql, [IsFirst, util:term_to_bitstring(OwnerGid), to_db(Guilds), "none"]);
        {ok, _} ->
            UpdateSql = "update sys_guild_war_mgr set is_first = ~s, owner = ~s, guilds = ~s",
            db:execute(UpdateSql, [IsFirst, util:term_to_bitstring(OwnerGid), to_db(Guilds)]);
        _ ->
            ok
    end.

%% @spec load_war_mgr()
%% 读取帮战管理进程数据
load_war_mgr() ->
    Sql = "select is_first, owner, guilds from sys_guild_war_mgr",
    case db:get_row(Sql) of
        {error, undefined} ->
            false;
        {ok, [IsFirst, Owner, GuildsData]} ->
            {IsFirst, to_term(Owner), to_term(GuildsData)};
        _ ->
            false
    end.

%% @spec save_war(WarState) 
%% WarState = #guild_war{}
%% 保存帮战数据
save_war(_WarState = #guild_war{is_first = IsFirst, winner_union = Wunion, winner_guild = Wgid, owner = Owner, attack_union = AtkUnion, defend_union = DfdUnion, guilds = Guilds, roles = Roles}) ->
    Sql = "insert into sys_guild_war_summary (srv_id, type, date, is_first, winner_union, winner_guild, owner) values (~s, ~s, ~s, ~s, ~s, ~s, ~s)",
    SelIdSql = "select id from sys_guild_war_summary order by id desc limit 1",
    case db:execute(Sql, ["none", 1, util:unixtime(), IsFirst, Wunion, util:term_to_bitstring(Wgid), util:term_to_bitstring(Owner)]) of
        {ok, _} ->
            case db:get_row(SelIdSql) of
                {ok, [WarId]} when is_integer(WarId) ->
                    save_war_union(WarId, ?guild_war_union_attack, AtkUnion),
                    save_war_union(WarId, ?guild_war_union_defend, DfdUnion),
                    [save_war_guild(WarId, G) || G <- Guilds],
                    [save_war_role(WarId, R) || R <- Roles];
                _Other2 ->
                    ?ERR("(获取war_id)保存帮战数据出错：~w", [_Other2])
            end;
        {_Type, _Msg} ->
            ?ERR("保存帮战数据出错：type = ~w, msg = ~s", [_Type, _Msg]);
        _Other ->
            ?ERR("保存帮战数据出错：~w", [_Other])
    end.

%% @spec load_last_war() -> WarState
%% WarState = #guild_war{}
%% 读取上一场帮战战况
load_last_war() ->
    Sql = "select Id, type, date, is_first, winner_union, winner_guild, owner from sys_guild_war_summary order by id desc limit 1",
    case db:get_row(Sql) of
        {ok, [Id, _Type, _Date, IsFirst, Wunion, Wguild, Owner]} ->
            Guilds = load_war_guild(Id),
            Roles = load_war_role(Id),
            AtkUnion = load_war_union(Id, ?guild_war_union_attack),
            DfdUnion = load_war_union(Id, ?guild_war_union_defend),
            #guild_war{guilds = Guilds, roles = Roles, attack_union = AtkUnion, defend_union = DfdUnion, is_first = IsFirst, winner_union = Wunion, winner_guild = to_term(Wguild), owner = to_term(Owner)};
        _ ->
            undefined
    end.

%% @spec get_last_2_war() -> WarState
%% WarState = #guild_war{}
%% @doc 读取上2场帮战信息
get_last_2_war() ->
    Sql = "select Id, winner_union from sys_guild_war_summary order by id desc limit 2",
    case db:get_all(Sql) of
        {ok, List} ->
            do_get_last_war_union(List, []);
        _ ->
            []
    end.

%% @spec get_own_count(Owner) -> integer()
%% 获取当前守护帮会已经占领了圣地多少次
get_own_count(Owner) ->
    Sql = "select winner_guild from sys_guild_war_summary order by id desc limit 10",
    case db:get_all(Sql) of
        {ok, Winners} ->
            ?debug_log([winners, Winners]),
            case do_get_own_count(Owner, Winners) of
                C1 when C1 < 0 ->
                    0;
                C2 ->
                    C2
            end;
        {error, _Msg} ->
            0
    end.

%load_last_war2() ->
%    Sql = "select id, type, is_first, date, winner_union, winner_guild, owner, atk_union, dfd_union, guilds, roles from sys_guild_war order by id desc limit 1",
%    case db:get_row(Sql) of
%        {ok, [_Id, _Type, IsFirst, _Date, Wunion, Wguild, Owner, AtkUnion, DfdUnion, Guilds, Roles]} ->
%            #guild_war{is_first = IsFirst, winner_union = Wunion, winner_guild = to_term(Wguild), owner = to_term(Owner), attack_union = to_term(AtkUnion), defend_union = to_term(DfdUnion), guilds = to_term(Guilds), roles = to_term(Roles)};
%        _ ->
%            undefined
%    end.

%% --------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------

%% 将#guild_war_guild转化为数据库可存储的数据
to_db(Guilds) ->
    to_db(Guilds, []).
to_db([], Back) ->
    util:term_to_bitstring(Back);
to_db([#guild_war_guild{union = Union, id = Id} | T], Back) ->
    to_db(T, [{Id, Union} | Back]).

%% 将数据库存储的数据转换为 帮会term
to_term(GuildsData) ->
    case util:bitstring_to_term(GuildsData) of
        {ok, R} ->
            R;
        _ ->
            []
    end.

%% 取得联盟战绩
load_war_union(WarId, Union) ->
    Sql = "select guild_count, credit_combat, credit_compete, credit_total, hold_time, realm from sys_guild_war_union where war_id = ~s and union_type = ~s",
    case db:get_row(Sql, [WarId, Union]) of
        {ok, [Gcount, Ccombat, Ccompete, Ctotal, Htime, Realm]} ->
            #guild_war_union{guild_count = Gcount, credit_combat = Ccombat, credit_compete = Ccompete, hold_time = Htime, credit = Ctotal, realm = Realm};
        _ ->
            #guild_war_union{}
    end.

%% 保存联盟战绩
save_war_union(WarId, Union, #guild_war_union{guild_count = Gcount, credit_combat = Ccombat, credit_compete = Ccompete, credit = Credit, hold_time = Htime, realm = Realm}) when is_integer(WarId) ->
    Sql = "insert into sys_guild_war_union(war_id, union_type, guild_count, credit_combat, credit_compete, credit_total, hold_time, realm) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
    case db:execute(Sql, [WarId, Union, Gcount, Ccombat, Ccompete, Credit, Htime, Realm]) of
        {ok, _} ->
            ok;
        {error, _Msg} ->
            ?ERR("保存联盟战绩出错: ~s", [_Msg])
    end;
save_war_union(_WarId, _Union, _Gunion) ->
    ?ERR("错误的联盟数据：war_id = ~w, union = ~w, data = ~s", [_WarId, _Union, _Gunion]),
    {error, not_match}.
    
%% 保存帮会战绩
save_war_guild(WarId, #guild_war_guild{id = {GuildId, GuildSrvId}, name = Name, union = Union, roles_count = Rcount, credit_combat = Ccombat, credit_compete = Ccompete, credit_stone = Cstone, credit_sword = Csword, credit = Credit, realm = Realm}) when is_integer(WarId) ->
    Sql = "insert into sys_guild_war_guild(war_id, union_type, guild_id, guild_srv_id, name, role_count, credit_combat, credit_compete, credit_stone, credit_sword, credit_total, realm) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
    case db:execute(Sql, [WarId, Union, GuildId, GuildSrvId, Name, Rcount, Ccombat, Ccompete, Cstone, Csword, Credit, Realm]) of
        {ok, _} ->
            ok;
        {error, _Msg} ->
            ?ERR("保存帮会战绩出错: ~s", [_Msg])
    end;
save_war_guild(_WarId, _G) ->
    ?ERR("错误的帮会数据: war_id = ~s, data = ~s", [_WarId, _G]),
    {error, not_match}.

%% 获取帮会战绩
load_war_guild(WarId) ->
    Sql = "select union_type, guild_id, guild_srv_id, name, role_count, credit_combat, credit_compete, credit_stone, credit_sword, credit_total, realm from sys_guild_war_guild where war_id = ~s order by credit_total",
    case db:get_all(Sql, [WarId]) of
        {ok, Gdata} when is_list(Gdata) ->
            convert_to_guild(Gdata, []);
        {error, _Msg} ->
            ?ERR("读取帮会战绩出错: ~s", [_Msg]),
            [];
        _ ->
            []
    end.

convert_to_guild([], Back) ->
    Back;
convert_to_guild([[Union, GuildId, GuildSrvId, Name, Rcount, Ccombat, Ccompete, Cstone, Csword, Credit, Realm] | T], Back) ->
    convert_to_guild(T, [#guild_war_guild{id = {GuildId, GuildSrvId}, union = Union, roles_count = Rcount, name = Name, credit_combat = Ccombat, credit_compete = Ccompete, credit_stone = Cstone, credit_sword = Csword, credit = Credit, realm = Realm} | Back]);
convert_to_guild([_ | T], Back) ->
    convert_to_guild(T, Back);
convert_to_guild(_, Back) ->
    Back.

%% 保存帮战中个人战绩
save_war_role(WarId, #guild_war_role{id = {RoleId, RoleSrvId}, name = Name, guild_id = {GuildId, GuildSrvId}, guild_name = GuildName, union = Union, credit_combat = Ccombat, credit_compete = Ccompete, credit_stone = Cstone, credit_sword = Csword, credit = Credit, realm = Realm}) ->
    Sql = "insert into sys_guild_war_role(war_id, union_type, role_id, role_srv_id, name, guild_id, guild_srv_id, guild_name, credit_combat, credit_compete, credit_stone, credit_sword, credit_total, realm) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
    case db:execute(Sql, [WarId, Union, RoleId, RoleSrvId, Name, GuildId, GuildSrvId, GuildName, Ccombat, Ccompete, Cstone, Csword, Credit, Realm]) of
        {ok, _} ->
            ok;
        {error, _Msg} ->
            ?ERR("保存个人战绩出错:~s", [_Msg])
    end;
save_war_role(_WarId, _Data) ->
    ?ERR("错误的个人数据: war_id = ~w, data = ~w", [_WarId, _Data]).

%% 读取帮战中个人战绩
load_war_role(WarId) ->
    Sql = "select union_type, role_id, role_srv_id, name, guild_id, guild_srv_id, guild_name, credit_combat, credit_compete, credit_stone, credit_sword, credit_total, realm from sys_guild_war_role where war_id = ~s order by credit_total",
    case db:get_all(Sql, [WarId]) of
        {ok, Rdata} when is_list(Rdata) ->
            convert_to_role(Rdata, []);
        {error, _Msg} ->
            ?ERR("读取玩家战绩出错: ~s", [_Msg]),
            [];
        _ ->
            []
    end.

convert_to_role([], Back) ->
    Back;
convert_to_role([[Union, RoleId, RoleSrvId, Name, GuildId, GuildSrvId, GuildName, Ccombat, Ccompete, Cstone, Csword, Credit, Realm] | T], Back) ->
    convert_to_role(T, [#guild_war_role{id = {RoleId, RoleSrvId}, union = Union, name = Name, guild_id = {GuildId, GuildSrvId}, guild_name = GuildName, credit_combat = Ccombat, credit_compete = Ccompete, credit_stone = Cstone, credit_sword = Csword, credit = Credit, realm = Realm} | Back]);
convert_to_role([_ | T], Back) ->
    convert_to_role(T, Back).
    
%% 计算已守护圣地的次数
do_get_own_count(_, []) ->
    0;
do_get_own_count(Owner, Winners) ->
    do_get_own_count(Owner, Winners, 0).
do_get_own_count(_, [], Count) ->
    Count - 1;
do_get_own_count(Owner, [[H] | T], Count) ->
    case Owner =:= to_term(H) of
        true ->
            do_get_own_count(Owner, T, Count + 1);
        false ->
            Count - 1
    end;
do_get_own_count(_, _, _) ->
    0.

%% 返回所有胜利方的联盟信息
do_get_last_war_union([], BackL) -> BackL;
do_get_last_war_union([[Id, Wunion] | T], BackL) ->
    AtkUnion = load_war_union(Id, ?guild_war_union_attack),
    DfdUnion = load_war_union(Id, ?guild_war_union_defend),
    if
        Wunion =:= 1 -> %% 进攻方联盟
            do_get_last_war_union(T, [AtkUnion | BackL]);
        Wunion =:= 2 -> %% 防守方联盟
            do_get_last_war_union(T, [DfdUnion | BackL]);
        true ->
            do_get_last_war_union(T, BackL)
    end.
