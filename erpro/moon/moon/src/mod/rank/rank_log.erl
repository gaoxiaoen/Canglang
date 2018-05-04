%%----------------------------------------------------
%% 排行榜日志快照记录 每天0点30分快照 
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(rank_log).
-export([
        save/0
        ,save_darren/0
        ,save/1
        ,save_celebrity/1
    ]).

-include("common.hrl").
-include("rank.hrl").
-include("item.hrl").
-include("pet.hrl").

%% 保存达人榜快照数据
save_darren() -> 
    L = [
        ?rank_darren_coin, ?rank_darren_casino, ?rank_darren_exp, ?rank_darren_attainment
    ],
    save(L).

%% 保存排行榜数据
save() ->
    L = [
        ?rank_role_lev, ?rank_role_coin, ?rank_role_power
        ,?rank_role_soul, ?rank_role_skill, ?rank_role_achieve
        ,?rank_role_pet, ?rank_role_pet_power
        ,?rank_arms, ?rank_armor, ?rank_guild_lev
        ,?rank_vie_acc, ?rank_vie_kill
        ,?rank_flower_acc, ?rank_glamor_acc, ?rank_celebrity
        ,?rank_flower_day, ?rank_glamor_day
        ,?rank_wit_acc, ?rank_wit_last
        ,?rank_total_power, ?rank_cross_total_power
        ,?rank_cross_role_pet_power, ?rank_mount_power, ?rank_cross_mount_power
    ],
    save(L).
save(Type) when is_integer(Type) ->
    spawn( 
        fun() ->
                do_save(Type)
        end
    );
save(Types) when is_list(Types) ->
    NewL = [{Type, rank_mgr:lookup(Type)} || Type <- Types],
    spawn( 
        fun() -> 
                [do_save(Type, Rank) || {Type, Rank} <- NewL]
        end
    );
save(_) -> ok.

save_celebrity([]) -> ok;
save_celebrity(Cel) when is_record(Cel, rank_global_celebrity) ->
    save_celebrity([Cel]);
save_celebrity(L) when is_list(L) ->
    Str = celebrity_to_sql(L),
    Sql = util:fbin("REPLACE INTO sys_rank_celebrity (`ctype`,`rid`,`srv_id`,`name`,`sex`,`career`,`in_time`) VALUES ~s", [Str]),
    %% util:cn(Sql),
    db:execute(Sql);
save_celebrity(_) -> ok.

%%-----------------------------------------------------
%% 内部方法
%%-----------------------------------------------------

%% 快照保存一个榜的数据
do_save(Type) -> %% 普通排行榜
    Rank = rank_mgr:lookup(Type),
    do_save(Type, Rank).

do_save(?rank_celebrity = _Type, #rank{roles = L}) when is_list(L) -> %% 名人榜
    save_celebrity(L);
do_save(Type, #rank{roles = [I | T]}) -> %% 普通排行榜
    case to_sql(Type, 1, I) of
        ok -> ok;
        VStr1 ->
            OtherValStr = to_sql(Type, 2, T, <<>>),
            Sql = util:fbin("INSERT INTO log_rank (`r_type`,`sort_val`,`ct`,`rid`,`srv_id`,`r_name`,`lev`,`sex`,`career`,`g_name`,`vip_type`,`val`,`val_ext`, content) VALUES ~s ~s", [VStr1, OtherValStr]),
            %% util:cn("~n~p ---->", [Type]), util:cn(Sql),
            db:execute(Sql)
    end;
do_save(_Type, _Rank) ->
    ok.

%%------------------------------------------------
%% 普通排行榜SQL转换
%%------------------------------------------------

%% 转换成批量插入SQL语句
to_sql(_Type, _N, [], VStr) -> VStr;
to_sql(Type, N, [I | T], VStr) ->
    NewVStr = util:fbin(",~s", [to_sql(Type, N, I)]),
    to_sql(Type, N + 1, T, <<VStr/binary, NewVStr/binary>>).

%% 对每行记录抽取值转换成插入SQL语句字段
to_sql(Type, N, I) ->
    case get_field(I) of
        Fs when is_list(Fs) ->
            Fields = [Type, N, util:unixtime() | Fs],
            db:format_sql("(~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s)", Fields);
        _ -> ok
    end.

%% 个人排行
get_field(#rank_role_lev{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = GName, lev = Lev, vip = Vip, eqm = Eqm}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Lev, <<>>, util:term_to_bitstring(Eqm)];
get_field(#rank_role_coin{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = GName, lev = Lev, vip = Vip, coin = Coin, eqm = Eqm}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Coin, <<>>, util:term_to_bitstring(Eqm)];
get_field(#rank_role_power{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = GName, lev = Lev, vip = Vip, power = Power, eqm = Eqm}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Power, <<>>, util:term_to_bitstring(Eqm)];
get_field(#rank_role_achieve{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = GName, lev = Lev, vip = Vip, achieve = Achieve}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Achieve, <<>>, <<>>];
get_field(#rank_role_soul{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = GName, lev = Lev, vip = Vip, soul = Soul}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Soul, <<>>, <<>>];
get_field(#rank_role_skill{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = GName, lev = Lev, vip = Vip, skill = Skill}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Skill, <<>>, <<>>];

%% 宠物排行
get_field(#rank_role_pet{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, vip = Vip, petlev = PetLev, petname = PetName, pet = Pet = #pet{grow_val = GrowVal, attr = #pet_attr{xl_val = XlVal, tz_val = TzVal, js_val = JsVal, lq_val = LqVal}}}) ->
    [Rid, SrvId, Name, -1, Sex, Career, <<>>, Vip, PetLev, util:fbin("~s,成长:~p,力潜力:~p,体潜力:~p,防潜力:~p,巧潜力:~p", [PetName, GrowVal, XlVal, TzVal, JsVal, LqVal]), util:term_to_bitstring(Pet)];
get_field(#rank_role_pet_power{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, vip = Vip, petname = PetName, power = Power, pet = Pet = #pet{grow_val = GrowVal, attr = #pet_attr{xl_val = XlVal, tz_val = TzVal, js_val = JsVal, lq_val = LqVal}}}) ->
    [Rid, SrvId, Name, -1, Sex, Career, <<>>, Vip, Power, util:fbin("~s,成长:~p,力潜力:~p,体潜力:~p,防潜力:~p,巧潜力:~p", [PetName, GrowVal, XlVal, TzVal, JsVal, LqVal]), util:term_to_bitstring(Pet)];
get_field(#rank_cross_role_pet_power{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, vip = Vip, petname = PetName, power = Power, pet = Pet = #pet{grow_val = GrowVal, attr = #pet_attr{xl_val = XlVal, tz_val = TzVal, js_val = JsVal, lq_val = LqVal}}}) ->
    [Rid, SrvId, Name, -1, Sex, Career, <<>>, Vip, Power, util:fbin("~s,成长:~p,力潜力:~p,体潜力:~p,防潜力:~p,巧潜力:~p", [PetName, GrowVal, XlVal, TzVal, JsVal, LqVal]), util:term_to_bitstring(Pet)];

%% 坐骑排行
get_field(#rank_mount_power{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, vip = Vip, guild = Guild, mount = MountName, step = Step, mount_lev = MountLev, quality = Quality, power = Power, eqm = Eqm}) ->
    [Rid, SrvId, Name, -1, Sex, Career, Guild, Vip, Power, util:fbin("~s,阶数:~p,等级:~p,品质:~p", [MountName, Step, MountLev, Quality]), util:term_to_bitstring(Eqm)];

%% 跨服坐骑排行榜
get_field(#rank_cross_mount_power{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, vip = Vip, guild = Guild, mount = MountName, step = Step, mount_lev = MountLev, quality = Quality, power = Power, eqm = Eqm}) ->
    [Rid, SrvId, Name, -1, Sex, Career, Guild, Vip, Power, util:fbin("~s,阶数:~p,等级:~p,品质:~p", [MountName, Step, MountLev, Quality]), util:term_to_bitstring(Eqm)];

%% 装备排行
get_field(#rank_equip_arms{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = GName, lev = Lev, vip = Vip, score = Score, arms = Arms, quality = Quality, item = Item}) ->
    Ext = case Quality of
        ?quality_purple -> util:fbin("[紫][~s]", [Arms]);
        ?quality_orange -> util:fbin("[橙][~s]", [Arms]);
        _ -> util:fbin("[其它][~s]", [Arms])
    end,
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Score, Ext, util:term_to_bitstring(Item)];
get_field(#rank_equip_armor{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = GName, lev = Lev, vip = Vip, score = Score, armor = Armor, quality = Quality, item = Item}) ->
    ValExt = case Quality of
        ?quality_purple -> util:fbin("[紫][~s]", [Armor]);
        ?quality_orange -> util:fbin("[橙][~s]", [Armor]);
        _ -> util:fbin("[其它][~s]", [Armor])
    end,
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Score, ValExt, util:term_to_bitstring(Item)];

%% 帮会排行
get_field(#rank_guild_lev{chief_rid = Rid, chief_srv_id = SrvId, cName = Name, lev = Lev, name = GName}) ->
    [Rid, SrvId, Name, -1, -1, -1, GName, -1, Lev, <<>>, <<>>];

%% 竞技排行榜
get_field(#rank_vie_acc{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = GName, lev = Lev, vip = Vip, score = Score}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Score, <<>>, <<>>];
get_field(#rank_vie_kill{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = GName, lev = Lev, vip = Vip, kill = Kill}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Kill, <<>>, <<>>];

%% 玫瑰排行榜
get_field(#rank_flower_acc{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = GName, lev = Lev, vip = Vip, flower = Flower}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Flower, <<>>, <<>>];
get_field(#rank_glamor_acc{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = GName, lev = Lev, vip = Vip, glamor = Glamor}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Glamor, <<>>, <<>>];

%% 答题排行榜
get_field(#rank_wit_acc{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = GName, lev = Lev, vip = Vip, score = Score}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Score, <<>>, <<>>];
get_field(#rank_wit_last{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = GName, lev = Lev, vip = Vip, score = Score}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Score, <<>>, <<>>];

%% 试练排行榜
get_field(#rank_practice{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = GName, lev = Lev, vip = Vip, score = Score}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Score, <<>>, <<>>];

%% 副本排行榜
get_field(#rank_dungeon{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, dun_score = DunScore, top_harm = TopHarm, total_hurt = TotalHurt, combat_round = CRound, score_grade = ScoreGrade}) ->
    Ext = util:fbin("[最高伤害:~p][承受伤害:~p][回合:~p][级别:~p]", [TopHarm, TotalHurt, CRound, ScoreGrade]),
    [Rid, SrvId, Name, -1, Sex, Career, <<>>, -1, DunScore, Ext, <<>>];

%% 综合排行榜
get_field(#rank_total_power{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, lev = Lev, guild = GName, total_power = TotalPower, role_power = RolePower, pet_power = PetPower, eqm = Eqm}) ->
    Ext = util:fbin("[人物战斗力:~p][宠物战斗力:~p]", [RolePower, PetPower]),
    [Rid, SrvId, Name, Lev, Sex, Career, GName, -1, TotalPower, Ext, util:term_to_bitstring(Eqm)];
get_field(#rank_cross_total_power{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, lev = Lev, guild = GName, total_power = TotalPower, role_power = RolePower, pet_power = PetPower, eqm = Eqm}) ->
    Ext = util:fbin("[人物战斗力:~p][宠物战斗力:~p]", [RolePower, PetPower]),
    [Rid, SrvId, Name, Lev, Sex, Career, GName, -1, TotalPower, Ext, util:term_to_bitstring(Eqm)];

%% 达人榜快照数据
get_field(#rank_darren_coin{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, lev = Lev, guild = GName, vip = Vip, val = Val}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Val, <<>>, <<>>];
get_field(#rank_darren_exp{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, lev = Lev, guild = GName, vip = Vip, val = Val}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Val, <<>>, <<>>];
get_field(#rank_darren_casino{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, lev = Lev, guild = GName, vip = Vip, val = Val}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Val, <<>>, <<>>];
get_field(#rank_darren_attainment{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, lev = Lev, guild = GName, vip = Vip, val = Val}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Val, <<>>, <<>>];

%% 跨服鲜花排行榜
get_field(#rank_cross_flower{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, lev = Lev, guild = GName, vip = Vip, flower = Val}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Val, <<>>, <<>>];
get_field(#rank_cross_glamor{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, lev = Lev, guild = GName, vip = Vip, glamor = Val}) ->
    [Rid, SrvId, Name, Lev, Sex, Career, GName, Vip, Val, <<>>, <<>>];

get_field(_) -> ok.

%%--------------------------------------
%% 名人榜SQL处理
%%--------------------------------------

celebrity_to_sql(L) ->
    [Row | Rows] = celebrity_to_row(L, []),
    ValStr1 = db:format_sql("(~s,~s,~s,~s,~s,~s,~s)", Row),
    celebrity_to_sql(Rows, ValStr1).
celebrity_to_sql([], Str) -> Str;
celebrity_to_sql([Row | Rows], Str) ->
    NewStr = db:format_sql(",(~s,~s,~s,~s,~s,~s,~s)", Row),
    celebrity_to_sql(Rows, <<Str/binary, NewStr/binary>>).

celebrity_to_row([], Rows) -> Rows;
celebrity_to_row([I | T], Rows) ->
    NewRows = celebrity_to_row(I, I#rank_global_celebrity.r_list, Rows),
    celebrity_to_row(T, NewRows).
celebrity_to_row(_Cel, [], Rows) -> Rows;
celebrity_to_row(Cel = #rank_global_celebrity{id = Id, date = Date}, [#rank_celebrity_role{rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex} | T], Rows) ->
    Row = [Id, Rid, SrvId, Name, Sex, Career, Date],
    celebrity_to_row(Cel, T, [Row | Rows]).




