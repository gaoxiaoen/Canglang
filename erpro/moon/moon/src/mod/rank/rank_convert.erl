%%----------------------------------------------------
%% 转换成排行榜相应数据结构
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(rank_convert).
-export([do/2]).
-include("common.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("map.hrl").
-include("pos.hrl").
-include("link.hrl").
-include("attr.hrl").
-include("vip.hrl").
-include("team.hrl").
-include("rank.hrl").
-include("assets.hrl").
-include("skill.hrl").
-include("guild.hrl").
-include("pet.hrl").
-include("storage.hrl").
-include("item.hrl").
-include("channel.hrl").
-include("achievement.hrl").
-include("wanted.hrl").
-include("dungeon.hrl").
-include("boss.hrl").
-include("cross_pk.hrl").
-include("practice.hrl").
-include("buff.hrl").
-include("world_compete.hrl").
-include("soul_world.hrl").

%% 转换成个人等级排行榜数据
do(to_role_lev, #role{id = {Rid, SrvId}, name = Name, career = Career, sex = Sex, lev = Lev, 
        assets = #assets{exp = Exp}, vip = #vip{type = Vip}, guild = #role_guild{name = Gname},
        eqm = Eqm, looks = Looks, realm = Realm 
    }
) ->
    {ok, #rank_role_lev{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, name = Name, career = Career, 
            sex = Sex, guild = Gname, lev = Lev, exp = Exp, vip = Vip, date = util:unixtime(),
            eqm = Eqm, looks = Looks, realm = Realm}};

%% 转换成财富排行榜数据
do(to_role_coin, #role{id = {Rid, SrvId}, name = Name, career = Career, sex = Sex, vip = #vip{type = Vip},
        assets = #assets{gold = Gold, coin = Coin}, guild = #role_guild{name = Gname},
        lev = Lev, eqm = Eqm, looks = Looks, realm = Realm
    }
) ->
    {ok, #rank_role_coin{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, name = Name, career = Career, 
            sex = Sex, guild = Gname, coin = Coin, gold = Gold, vip = Vip, date = util:unixtime(),
            lev = Lev, eqm = Eqm, looks = Looks, realm = Realm}};

%% 转换成坐骑战力排行数据
do(to_mount_power, Role = #role{id = {Rid, SrvId}, realm = Realm, name = Name, career = Career, sex = Sex, 
         vip = #vip{type = Vip}, guild = #role_guild{name = Gname}, eqm = Eqm, looks = Looks, lev = Lev
    }
) ->
    case mount:get_rank_power(Role) of
        {MountName, Step, MountLev, Quality, Power, _Mount} ->
            {ok, #rank_mount_power{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, 
                    name = Name, career = Career, realm = Realm, sex = Sex, guild = Gname, vip = Vip, date = util:unixtime()
                    ,mount = MountName, step = Step, mount_lev = MountLev, quality = Quality, power = Power
                    ,eqm = Eqm, looks = Looks, lev = Lev
                }};
        _ ->
            false
    end;

%% 转换成坐骑等级排行榜
do(to_mount_lev, Role = #role{id = {Rid, SrvId}, realm = Realm, name = Name, career = Career, sex = Sex, 
         vip = #vip{type = Vip}, guild = #role_guild{name = Gname}, eqm = Eqm, looks = Looks, lev = Lev
    }
) ->
    case mount:get_rank_power(Role) of
        {MountName, Step, MountLev, Quality, Power, _Mount} ->
            {ok, #rank_mount_lev{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, 
                    name = Name, career = Career, realm = Realm, sex = Sex, guild = Gname, vip = Vip, date = util:unixtime()
                    ,mount = MountName, step = Step, mount_lev = MountLev, quality = Quality
                    ,eqm = Eqm, looks = Looks, lev = Lev, power = Power
                }};
        _ ->
            false
    end;

%% 转换成成就排行数据
do(to_role_achieve, #role{id = {Rid, SrvId}, realm = Realm, name = Name, career = Career, sex = Sex, 
        lev = Lev, vip = #vip{type = Vip}, guild = #role_guild{name = Gname}, achievement = #role_achievement{value = Ach}, eqm = Eqm, looks = Looks
    }
) ->
    {ok, #rank_role_achieve{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, 
            name = Name, career = Career, realm = Realm, sex = Sex, guild = Gname, achieve = Ach, lev = Lev, vip = Vip, date = util:unixtime(), eqm = Eqm, looks = Looks}};

%% 转换成战斗力排行数据
do(to_role_power, Role = #role{id = {Rid, SrvId}, name = Name, realm = Realm, career = Career, sex = Sex, attr = #attr{fight_capacity = Power},
        lev = Lev, vip = #vip{type = Vip}, guild = #role_guild{name = Gname}, eqm = Eqm, looks = Looks
    }
) ->
    {ok, #rank_role_power{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, power = Power,
            name = Name, career = Career, realm = Realm, sex = Sex, guild = Gname, lev = Lev, vip = Vip, date = util:unixtime(), ascend = ascend:get_ascend(Role),
            eqm = Eqm, looks = Looks}};

%% 转换成元神排行数据
do(to_role_soul, #role{id = {Rid, SrvId}, name = Name, career = Career, sex = Sex, channels = Souls,
        lev = Lev, vip = #vip{type = Vip}, realm = Realm, guild = #role_guild{name = Gname}, eqm = Eqm, looks = Looks
    }
) ->
    {ok, #rank_role_soul{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, name = Name, soul = round(calc(soul, Souls)),
            career = Career, sex = Sex, realm = Realm, guild = Gname, lev = Lev, vip = Vip, date = util:unixtime(), eqm = Eqm, looks = Looks}};

%% 转换成技能排行数据
do(to_role_skill, #role{id = {Rid, SrvId}, name = Name, career = Career, sex = Sex, skill = #skill_all{skill_list = Skills},
        lev = Lev, vip = #vip{type = Vip}, realm = Realm, guild = #role_guild{name = Gname}, eqm = Eqm, looks = Looks
    }
) ->
    {ok, #rank_role_skill{id = {Rid, SrvId}, realm = Realm, rid = Rid, srv_id = SrvId, name = Name, skill = round(calc(skill, Skills)),
            career = Career, sex = Sex, guild = Gname, lev = Lev, vip = Vip, date = util:unixtime(), eqm = Eqm, looks = Looks}};

%% 转换成武器评分排行数据
do(to_equip_arms, #role{id = {Rid, SrvId}, name = Name, career = Career, sex = Sex, eqm = Eqm,  
        guild = #role_guild{name = Gname}, realm = Realm, lev = Lev, vip = #vip{type = Vip} 
    }
) ->
    case eqm:find_eqm_by_id(Eqm, rank:to_eqm_type(?arms_pos)) of
        {ok, Item = #item{base_id = Baseid, enchant = _Elev, attr = _Attr, require_lev = _Ulev, craft = Craft}} -> 
            % {_Hidden, _Stone, PLev} = calc(stone_hidden, Attr),
            ?DEBUG("--------------~w~n",[Item]),
            case item_data:get(Baseid) of
                 {ok, #item_base{name = Aname, quality = Q}}->
                    ?DEBUG("-----quality_purple-----~w~n",[?quality_purple]),
                    NewAname = case Craft of %% 品阶 0:无 1:精良2:优秀3:完美4:传说
                        1 -> util:fbin("[~s]~s", [?L(<<"精良">>), Aname]);
                        2 -> util:fbin("[~s]~s", [?L(<<"优秀">>), Aname]);
                        3 -> util:fbin("[~s]~s", [?L(<<"完美">>), Aname]);
                        4 -> util:fbin("[~s]~s", [?L(<<"传说">>), Aname]);
                        _ -> Aname
                    end,
                    {ok, #rank_equip_arms{id = {Rid, SrvId}, realm = Realm, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = Gname, 
                            arms = NewAname, score = get_eqm_score(Item, Career), lev = Lev, vip = Vip, date = util:unixtime(),
                            quality = Q, item = Item}};
                % {ok, #item_base{name = Aname, quality = Q}} when Q =:= ?quality_purple ->
                %     ?DEBUG("-----quality_purple-----~w~n",[?quality_purple]),
                %     NewAname = case Craft of %% 品阶 0:无 1:精良2:优秀3:完美4:传说
                %         1 -> util:fbin("[~s]~s", [?L(<<"精良">>), Aname]);
                %         2 -> util:fbin("[~s]~s", [?L(<<"优秀">>), Aname]);
                %         3 -> util:fbin("[~s]~s", [?L(<<"完美">>), Aname]);
                %         4 -> util:fbin("[~s]~s", [?L(<<"传说">>), Aname]);
                %         _ -> Aname
                %     end,
                %     {ok, #rank_equip_arms{id = {Rid, SrvId}, realm = Realm, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = Gname, 
                %             arms = NewAname, score = round(calc(armor, Item, Elev, Career)), lev = Lev, vip = Vip, date = util:unixtime(),
                %             quality = Q, item = Item}};
                % {ok, #item_base{name = Aname, quality = Q}} when Q =:= ?quality_pink->
                %     ?DEBUG("-----quality_pink-----~w~n",[?quality_pink]),
                %     NewAname = case Craft of %% 品阶 0:无 1:精良2:优秀3:完美4:传说
                %         1 -> util:fbin("[~s]~s", [?L(<<"精良">>), Aname]);
                %         2 -> util:fbin("[~s]~s", [?L(<<"优秀">>), Aname]);
                %         3 -> util:fbin("[~s]~s", [?L(<<"完美">>), Aname]);
                %         4 -> util:fbin("[~s]~s", [?L(<<"传说">>), Aname]);
                %         _ -> Aname
                %     end,
                %     {ok, #rank_equip_arms{id = {Rid, SrvId}, realm = Realm, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = Gname, 
                %             arms = NewAname, score = round(calc(armor, Item, Elev, Career)), lev = Lev, vip = Vip, date = util:unixtime(),
                %             quality = Q, item = Item}};
                % {ok, #item_base{name = Aname, quality = Q}} when Q =:= ?quality_orange ->
                %     ?DEBUG("-----quality_orange-----~w~n",[?quality_orange]),
                %     NewAname = case Craft of %% 品阶 0:无 1:精良2:优秀3:完美4:传说
                %         1 -> util:fbin("[~s]~s", [?L(<<"精良">>), Aname]);
                %         2 -> util:fbin("[~s]~s", [?L(<<"优秀">>), Aname]);
                %         3 -> util:fbin("[~s]~s", [?L(<<"完美">>), Aname]);
                %         4 -> util:fbin("[~s]~s", [?L(<<"传说">>), Aname]);
                %         _ -> Aname
                %     end,
                %     {ok, #rank_equip_arms{id = {Rid, SrvId}, realm = Realm, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = Gname, 
                %             arms = NewAname, score = round(calc(armor, Item, Elev, Career)), lev = Lev, vip = Vip, date = util:unixtime(),
                %             quality = Q, item = Item}};
                _ ->
                    ignore
            end;
        _ ->
            ignore
    end;

%% 转换成防具评分排行数据
do({to_equip_armor, _OldRole, Type}, _Role = #role{id = {Rid, SrvId}, name = Name, career = Career, sex = Sex, eqm = Eqm,
        lev = Lev, vip = #vip{type = Vip}, realm = Realm, guild = #role_guild{name = Gname}
    }
) ->
    case eqm:find_eqm_by_id(Eqm, Type) of
        {ok, Item = #item{base_id = Baseid, enchant = _Elev, attr = _Attr}} -> 
            ?DEBUG("-----:~w\t~w\n",[Baseid,Type]),
            case item_data:get(Baseid) of
                {ok, #item_base{name = Aname, quality = Q}} ->
                    {ok, #rank_equip_armor{id = {Rid, SrvId, Type}, realm = Realm, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = Gname, 
                            armor = Aname, score = get_eqm_score(Item, Career), lev = Lev, vip = Vip, date = util:unixtime(),
                            quality = Q, type = Type, item = Item}};
                _ ->
                    ?DEBUG("--ignore---\n"),
                    ignore
            end;
        _ ->
            ?DEBUG("--ignore---\n"),
            ignore
    end;



    % case eqm:find_eqm_by_id(Eqm, Type) of
    %     {ok, Item = #item{base_id = Baseid, require_lev = Ulev, enchant = Elev, attr = Attr, craft = Craft}} -> 
    %         {Hidden, Stone, PLev} = calc(stone_hidden, Attr),
    %         case item_data:get(Baseid) of
    %             {ok, #item_base{name = Aname, quality = Q}} when Q =:= ?quality_purple ->
    %                 NewAname = case Craft of %% 品阶 0:无 1:精良2:优秀3:完美4:传说
    %                     1 -> util:fbin("[~s]~s", [?L(<<"精良">>), Aname]);
    %                     2 -> util:fbin("[~s]~s", [?L(<<"优秀">>), Aname]);
    %                     3 -> util:fbin("[~s]~s", [?L(<<"完美">>), Aname]);
    %                     4 -> util:fbin("[~s]~s", [?L(<<"传说">>), Aname]);
    %                     _ -> Aname
    %                 end,
    %                 {ok, #rank_equip_armor{id = {Rid, SrvId, Type}, realm = Realm, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = Gname, 
    %                         armor = NewAname, score = round(calc(armor, {Item, Hidden, Stone, Ulev, PLev, Elev, ?purple_fac, Type, Craft})), lev = Lev, vip = Vip, date = util:unixtime(),
    %                         quality = Q, type = Type, item = Item}};
    %             {ok, #item_base{name = Aname, quality = Q}} when Q =:= ?quality_orange ->
    %                 NewAname = case Craft of %% 品阶 0:无 1:精良2:优秀3:完美4:传说
    %                     1 -> util:fbin("[~s]~s", [?L(<<"精良">>), Aname]);
    %                     2 -> util:fbin("[~s]~s", [?L(<<"优秀">>), Aname]);
    %                     3 -> util:fbin("[~s]~s", [?L(<<"完美">>), Aname]);
    %                     4 -> util:fbin("[~s]~s", [?L(<<"传说">>), Aname]);
    %                     _ -> Aname
    %                 end,
    %                 {ok, #rank_equip_armor{id = {Rid, SrvId, Type}, realm = Realm, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = Gname, 
    %                         armor = NewAname, score = round(calc(armor, {Item, Hidden, Stone, Ulev, PLev, Elev, ?orange_fac, Type, Craft})), lev = Lev, vip = Vip, date = util:unixtime(),
    %                         quality = Q, type = Type, item = Item}};
    %             _ ->
    %                 ignore
    %         end;
    %     _ ->
    %         ignore
    % end;

%% 转换成试练积分排行榜
do(to_rank_practice, #role{id = {Rid, Srvid}, name = Name, guild = #role_guild{name = Gname}, career = Career, sex = Sex, lev = Lev, vip = #vip{type = Vip}, realm = Realm, assets = #assets{practice_acc = AccScore}}) -> 
    {ok, #rank_practice{id = {Rid, Srvid}, realm = Realm, rid = Rid, srv_id = Srvid, name = Name, guild = Gname, 
            career = Career, sex = Sex, score = AccScore, lev = Lev, vip = Vip, date = util:unixtime()
        }}; 

%% 转换成竞技场累计积分排行榜数据
do(to_vie_acc, #role{id = {Rid, Srvid}, name = Name, guild = #role_guild{name = Gname}, career = Career, sex = Sex, lev = Lev, vip = #vip{type = Vip}, realm = Realm, assets = #assets{acc_arena = AccArena}}) -> 
    {ok, #rank_vie_acc{id = {Rid, Srvid}, realm = Realm, rid = Rid, srv_id = Srvid, name = Name, guild = Gname, 
            career = Career, sex = Sex, score = AccArena, lev = Lev, vip = Vip, date = util:unixtime()
        }}; 

%% 转换成竞技场累计斩杀排行榜数据
do(to_vie_kill, #role{id = {Rid, Srvid}, name = Name, realm = Realm, guild = #role_guild{name = Gname}, career = Career, sex = Sex, lev = Lev, vip = #vip{type = Vip}, rank = L}) ->
    case lists:keyfind(?rank_vie_kill, 1, L) of
        {?rank_vie_kill, Kill} ->
            {ok, #rank_vie_kill{id = {Rid, Srvid}, realm = Realm, rid = Rid, srv_id = Srvid, name = Name, guild = Gname, 
                    career = Career, sex = Sex, kill = Kill, lev = Lev, vip = Vip, date = util:unixtime()
                }};
        _ ->
            false
    end;

%% 转换名人榜角色数据
do(to_celebrity, #role{id = {Rid, Srvid}, name = Name, career = Career, sex = Sex, looks = Looks}) ->
    {ok, #rank_celebrity_role{id = {Rid, Srvid}, rid = Rid, srv_id = Srvid, name = Name 
            ,career = Career, sex = Sex, looks = Looks
        }};
do(to_celebrity, #fighter{rid = Rid, srv_id = Srvid, name = Name, career = Career, sex = Sex}) ->
    {ok, #rank_celebrity_role{id = {Rid, Srvid}, rid = Rid, srv_id = Srvid, name = Name 
            ,career = Career, sex = Sex
        }};
do(to_celebrity, #practice_role{id = {Rid, Srvid}, name = Name, career = Career, sex = Sex}) ->
    {ok, #rank_celebrity_role{id = {Rid, Srvid}, rid = Rid, srv_id = Srvid, name = Name 
            ,career = Career, sex = Sex
        }};
do(to_celebrity, #cross_boss_role{id = {Rid, Srvid}, name = Name, career = Career, sex = Sex}) ->
    {ok, #rank_celebrity_role{id = {Rid, Srvid}, rid = Rid, srv_id = Srvid, name = Name 
            ,career = Career, sex = Sex
        }};
do(to_celebrity, #dungeon_role{rid = {Rid, Srvid}, name = Name, career = Career, sex = Sex}) ->
    {ok, #rank_celebrity_role{id = {Rid, Srvid}, rid = Rid, srv_id = Srvid, name = Name 
            ,career = Career, sex = Sex
        }};
do(to_celebrity, {Rid, Srvid, Name, Career, Sex}) ->
    {ok, #rank_celebrity_role{id = {Rid, Srvid}, rid = Rid, srv_id = Srvid, name = Name 
            ,career = Career, sex = Sex
        }};
do(to_celebrity, #guild{members = Members}) when length(Members) > 0 ->
    case [M || M <- Members, M#guild_member.position =:= ?guild_chief] of
        [#guild_member{rid = Rid, srv_id = Srvid, name = Name, career = Career, sex = Sex} | _] ->
            {ok, #rank_celebrity_role{id = {Rid, Srvid}, rid = Rid, srv_id = Srvid, name = Name 
                    ,career = Career, sex = Sex
                }};
        _ -> false
    end;

%% 帮会数据转换成排行榜数据
do(to_guild_lev, #guild{id = {Gid, Gsrvid}, realm = Realm, name = Gname, chief = Chief, lev =Glev, fund = Fund, num = Num, members = Members}) ->
    case lists:keyfind(?guild_chief, #guild_member.position, Members) of
        #guild_member{rid = Rid, srv_id = Srvid} ->
            {ok, #rank_guild_lev{id = {Gid, Gsrvid}, rid = Gid, srv_id = Gsrvid, name = Gname, cName = Chief, lev = Glev, fund = Fund, num = Num, chief_rid = Rid, chief_srv_id = Srvid, realm = Realm, date = util:unixtime()}};
        _ -> false
    end;

%% 帮会数据转换成排行榜数据
do(to_guild_power, #guild{id = {Gid, Gsrvid}, realm = Realm, name = Gname, chief = Chief, lev =Glev, fund = Fund, num = Num, members = Members}) ->
    case lists:keyfind(?guild_chief, #guild_member.position, Members) of
        #guild_member{rid = Rid, srv_id = Srvid} ->
            {ok, #rank_guild_power{id = {Gid, Gsrvid}, rid = Gid, srv_id = Gsrvid, name = Gname, cName = Chief, lev = Glev, fund = Fund, num = Num, chief_rid = Rid, chief_srv_id = Srvid, realm = Realm, date = util:unixtime()}};
        _ -> false
    end;


%% 转换成跨服竞技成绩排行榜数据
%% TODO 缺少 跨服获胜次数 win
do(to_vie_cross, #role{id = {Rid, SrvId}, name = Name, career = Career, 
        sex = Sex, lev = Lev, realm = Realm, vip  = #vip{type = Vip}}) ->
    {ok, #rank_vie_cross{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, 
            name = Name, career = Career, realm = Realm, sex = Sex, win = 0, lev = Lev, vip = Vip, date = util:unixtime()}};


%% 转换成送花排行榜数据
do(to_flower_acc, #role{id = {Rid, SrvId}, realm = Realm, name = Name, career = Career, assets = #assets{flower = Flower},
        sex = Sex, lev = Lev, vip  = #vip{type = Vip}, guild = #role_guild{name = Gname}
    }
) ->
    {ok, #rank_flower_acc{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, guild = Gname,
            name = Name, career = Career, realm = Realm, sex = Sex, flower = Flower, lev = Lev, vip = Vip, date = util:unixtime()}};

%% 转换成魅力排行榜数据
do(to_glamor_acc, #role{id = {Rid, SrvId}, realm = Realm, name = Name, career = Career, assets = #assets{charm = Glamor},
        sex = Sex, lev = Lev, vip  = #vip{type = Vip}, guild = #role_guild{name = Gname}
    }
) ->
    {ok, #rank_glamor_acc{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, glamor = Glamor, guild = Gname,
            name = Name, career = Career, realm = Realm, sex = Sex, lev = Lev, vip = Vip, date = util:unixtime()}};

%% 转换成今日送花排行榜数据
do(to_flower_day, #role{id = {Rid, SrvId}, realm = Realm, name = Name, career = Career,
        sex = Sex, lev = Lev, vip  = #vip{type = Vip, portrait_id = Face}, guild = #role_guild{name = Gname}, rank = L
    }
) ->
    DayFlower = case lists:keyfind(?rank_flower_day, 1, L) of
        {?rank_flower_day, Val, _} -> Val;
        _ -> 0
    end,
    {ok, #rank_flower_day{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, guild = Gname, face = Face,
            name = Name, career = Career, realm = Realm, sex = Sex, flower = DayFlower, lev = Lev, vip = Vip, date = util:unixtime()}};

%% 转换成今日魅力排行榜数据
do(to_glamor_day, #role{id = {Rid, SrvId}, realm = Realm, name = Name, career = Career,
        sex = Sex, lev = Lev, vip  = #vip{type = Vip, portrait_id = Face}, guild = #role_guild{name = Gname}, rank = L
    }
) ->
    DayGlamor = case lists:keyfind(?rank_glamor_day, 1, L) of
        {?rank_glamor_day, Val, _} -> Val;
        _ -> 0
    end,
    {ok, #rank_glamor_day{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, glamor = DayGlamor, guild = Gname, face = Face,
            name = Name, career = Career, realm = Realm, sex = Sex, lev = Lev, vip = Vip, date = util:unixtime()}};

%% 转换成累积人气排行榜数据
%% TODO 缺少累积魅力积分 popu
do(to_popu_acc, #role{id = {Rid, SrvId}, name = Name, career = Career, 
        sex = Sex, lev = Lev, realm = Realm, vip  = #vip{type = Vip}
    }
) ->
    {ok, #rank_popu_acc{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, 
            name = Name, career = Career, realm = Realm, sex = Sex, popu = 0, lev = Lev, vip = Vip, date = util:unixtime()}};

%% 综合战斗力排行榜数据
%% if 角色战力<=9000
%% 综合战力=角色战力*（1+仙宠战力/7000)
%% if 9000<角色战力<=16000
%% 综合战力=9000*（1+仙宠战力/7000)+(角色战力-9000）*（1+仙宠战力/4000）
%% if 角色战力>16000
%% 综合战力=9000*（1+仙宠战力/7000)+7000*（1+仙宠战力/4000）+(角色战力-16000）*（1+仙宠战力/2000）
do(to_total_power, Role = #role{id = {Rid, SrvId}, name = Name, lev = Lev, sex = Sex, career = Career, realm = Realm, guild = #role_guild{name = Gname}, 
    pet = #pet_bag{active = ActivePet}, eqm = Eqm, looks = Looks, attr = #attr{fight_capacity = RolePower}, vip = #vip{type = VipType}, 
    assets = #assets{wc_lev = WcLev}}) ->

    {Pet, PetPower} = case ActivePet of
        P = #pet{fight_capacity = PetPower1} -> {P, PetPower1};
        _ -> {undefined, 0}
    end,
    TotalPower = PetPower + RolePower,
    %% TotalPower2 = if 
    %%    RolePower =< 9000 -> round(RolePower * (1 + PetPower / 7000));
    %%    RolePower =< 16000 -> round(9000 * (1 + PetPower / 7000) + (RolePower - 9000) * (1 + PetPower / 4000));
    %%    true -> round(9000 * (1 + PetPower / 7000) + 7000 * (1 + PetPower / 4000) + (RolePower - 16000) * (1 + PetPower / 2000))
    %% end,
    %% TotalPower = lists:max([TotalPower1, TotalPower2]),
    {ok, #rank_total_power{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, name = Name, realm = Realm, lev = Lev, sex = Sex, career = Career, guild = Gname, eqm = Eqm, looks = Looks, role_power = RolePower, pet_power = PetPower, total_power = TotalPower, date = util:unixtime(), ascend = ascend:get_ascend(Role), pet = Pet, wc_lev = WcLev, vip = VipType}};

%%----------------------------------------------
%% 宠物相关
%%----------------------------------------------

%% 转换成仙宠排行榜数据(等级)
do(to_role_pet, Role = #role{id = {Rid, SrvId}, name = Name, realm = Realm, career = Career, sex = Sex, vip = #vip{type = Vip}}) ->
    {ok, Rare} = pet_rb:rare_value(Role),
    case pet_api:get_max(#pet.lev, Role) of
        Pet = #pet{id = Petid, name = PetName, type = Color, lev = PetLev, grow_val = GrowRate, 
            attr = #pet_attr{avg_val = Avg}} -> 
                {ok, #rank_role_pet{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, 
                        petid = Petid, color = Color, petname = PetName, petlev = PetLev, aptitude = Avg, petrb = Rare,
                        growrate = GrowRate, realm = Realm, vip = Vip, date = util:unixtime(), pet = Pet}};
            _ -> false
        end;

%% 转换成仙宠战斗力排行榜数据（战力）
do(to_role_pet_power, _Role = #role{id = {Rid, SrvId}, name = Name, realm = Realm, career = Career, sex = Sex, vip = #vip{type = Vip},guild = #role_guild{name = Gname},
    pet = #pet_bag{active = Pet = #pet{id = Petid, name = PetName, type = Color, lev = PetLev, fight_capacity = PetPower}}}) ->
    {ok, #rank_role_pet_power{id = {Rid, SrvId}, rid = Rid, realm = Realm, srv_id = SrvId, name = Name, career = Career, sex = Sex, 
            petid = Petid, color = Color, petname = PetName, petlev = PetLev, vip = Vip, date = util:unixtime(), guild = Gname,
            power = PetPower, pet = Pet}};

% do(to_role_pet_power, Role = #role{id = {Rid, SrvId}, name = Name, realm = Realm, career = Career, sex = Sex, vip = #vip{type = Vip}}) ->
%     {ok, Rare} = pet_rb:rare_value(Role),
%     case pet_api:get_max(#pet.fight_capacity, Role) of
%         Pet =  #pet{id = Petid, name = PetName, type = Color, lev = PetLev, fight_capacity = PetPower} ->
%             {ok, #rank_role_pet_power{id = {Rid, SrvId}, rid = Rid, realm = Realm, srv_id = SrvId, name = Name, career = Career, sex = Sex, petrb = Rare,
%                     petid = Petid, color = Color, petname = PetName, petlev = PetLev, vip = Vip, date = util:unixtime(), 
%                     power = PetPower, pet = Pet}};
%         _ ->
%             false
%     end;

%% 转换成仙宠战斗力排行榜数据（成长）
do(to_pet_grow, Role = #role{id = {Rid, SrvId}, name = Name, realm = Realm, career = Career, sex = Sex, vip = #vip{type = Vip}}) ->
    {ok, Rare} = pet_rb:rare_value(Role),
    case pet_api:get_max(#pet.grow_val, Role) of
        Pet =  #pet{id = Petid, name = PetName, type = Color, lev = PetLev, grow_val = Grow} ->
            {ok, #rank_pet_grow{id = {Rid, SrvId}, rid = Rid, realm = Realm, srv_id = SrvId, name = Name, career = Career, sex = Sex, petrb = Rare,
                    petid = Petid, color = Color, petname = PetName, petlev = PetLev, vip = Vip, date = util:unixtime(), 
                    grow = Grow, pet = Pet}};
        _ ->
            false
    end;

%% 转换成仙宠战斗力排行榜数据（潜力）
do(to_pet_potential, Role = #role{id = {Rid, SrvId}, name = Name, realm = Realm, career = Career, sex = Sex, vip = #vip{type = Vip}}) ->
    {ok, Rare} = pet_rb:rare_value(Role),
    case pet_api:get_max(#pet.fight_capacity, Role) of
        Pet =  #pet{id = Petid, name = PetName, type = Color, lev = PetLev, attr = #pet_attr{avg_val = AvgVal}} ->
            {ok, #rank_pet_potential{id = {Rid, SrvId}, rid = Rid, realm = Realm, srv_id = SrvId, name = Name, career = Career, sex = Sex, petrb = Rare,
                    petid = Petid, color = Color, petname = PetName, petlev = PetLev, vip = Vip, date = util:unixtime(), 
                    potential = AvgVal, pet = Pet}};
        _ ->
            false
    end;

%%--------------------------------------------
%% 达人榜
%%--------------------------------------------

%% 金币达人榜
do(to_darren_coin, {#role{id = {Rid, SrvId}, name = Name, career = Career, 
            sex = Sex, lev = Lev, realm = Realm, vip  = #vip{type = Vip}, guild = #role_guild{name = Gname}, eqm = Eqm, looks = Looks}, Val}
) ->
    {ok, #rank_darren_coin{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, eqm = Eqm, looks = Looks,
            name = Name, career = Career, realm = Realm, sex = Sex, val = Val, lev = Lev, vip = Vip, guild = Gname, date = util:unixtime()}};

%% 寻宝达人榜
do(to_darren_casino, {#role{id = {Rid, SrvId}, name = Name, career = Career, 
            sex = Sex, lev = Lev, realm = Realm, vip  = #vip{type = Vip}, guild = #role_guild{name = Gname}, eqm = Eqm, looks = Looks}, Val}
) ->
    {ok, #rank_darren_casino{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, eqm = Eqm, looks = Looks,
            name = Name, career = Career, realm = Realm, sex = Sex, val = Val, lev = Lev, vip = Vip, guild = Gname, date = util:unixtime()}};

%% 经验达人榜
do(to_darren_exp, {#role{id = {Rid, SrvId}, name = Name, career = Career, eqm = Eqm, looks = Looks,
            sex = Sex, lev = Lev, realm = Realm, vip  = #vip{type = Vip}, guild = #role_guild{name = Gname}}, Val}
) ->
    {ok, #rank_darren_exp{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, eqm = Eqm, looks = Looks,
            name = Name, career = Career, realm = Realm, sex = Sex, val = Val, lev = Lev, vip = Vip, guild = Gname, date = util:unixtime()}};

%% 阅历达人榜
do(to_darren_attainment, {#role{id = {Rid, SrvId}, name = Name, career = Career, eqm = Eqm, looks = Looks,
            sex = Sex, lev = Lev, realm = Realm, vip  = #vip{type = Vip}, guild = #role_guild{name = Gname}}, Val}
) ->
    {ok, #rank_darren_attainment{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, eqm = Eqm, looks = Looks, 
            name = Name, career = Career, realm = Realm, sex = Sex, val = Val, lev = Lev, vip = Vip, guild = Gname, date = util:unixtime()}};

%% 仙道会战胜场数据
do(to_world_compete_win, {#role{id = {Rid, SrvId}, name = Name, career = Career, sex = Sex, lev = Lev, realm = Realm, vip  = #vip{type = Vip}, guild = #role_guild{name = Gname}, looks = Looks, eqm = Eqm}, #world_compete_mark{win_count = WinCount}}
) ->
    {ok, #rank_world_compete_win{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, looks = Looks, eqm = Eqm,
            name = Name, career = Career, sex = Sex, win_count = WinCount, lev = Lev, realm = Realm, vip = Vip, guild = Gname, date = util:unixtime()}};

%% 灵戒战力
do(to_soul_world, Role = #role{id = {Rid, SrvId}, name = Name, career = Career, sex = Sex, lev = RoleLev, realm = Realm, vip  = #vip{type = Vip}, guild = #role_guild{name = Gname}, soul_world = #soul_world{spirits = Spirits, arrays = Arrays}}
) ->
    Power = soul_world:calc_fight_capacity(Role),
    NewSpirits = [Spirit || Spirit <- Spirits, lists:keyfind(Spirit#soul_world_spirit.id, #soul_world_array.spirit_id, Arrays) =/= false],
    {ok, #rank_soul_world{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, spirits = NewSpirits, arrays = Arrays,
            name = Name, career = Career, sex = Sex, role_lev = RoleLev, power = Power, realm = Realm, vip = Vip, guild = Gname, date = util:unixtime()}};

%% 魔阵等级
do(to_soul_world_array, #role{id = {Rid, SrvId}, name = Name, career = Career, sex = Sex, lev = RoleLev, realm = Realm, vip  = #vip{type = Vip}, guild = #role_guild{name = Gname}, soul_world = #soul_world{array_lev = Lev, arrays = Arrays}}
) ->
    {ok, #rank_soul_world_array{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, arrays = Arrays,
            name = Name, career = Career, sex = Sex, lev = Lev, role_lev = RoleLev, realm = Realm, vip = Vip, guild = Gname, date = util:unixtime()}};

%% 妖灵战力
do(to_soul_world_spirit, #role{id = {Rid, SrvId}, name = Name, career = Career, sex = Sex, lev = RoleLev, realm = Realm, vip  = #vip{type = Vip}, guild = #role_guild{name = Gname}, soul_world = #soul_world{spirits = Spirits}}
) when length(Spirits) > 0 ->
    SortL = lists:keysort(#soul_world_spirit.fc, Spirits),
    [Spirit = #soul_world_spirit{fc = Power, quality = Quality, name = SpiritName, lev = SpiritLev} | _] = lists:reverse(SortL),
    {ok, #rank_soul_world_spirit{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, spirit = Spirit, quality = Quality, spirit_name = SpiritName, spirit_lev = SpiritLev,
            name = Name, career = Career, sex = Sex, role_lev = RoleLev, power = Power, realm = Realm, vip = Vip, guild = Gname, date = util:unixtime()}};

%% 容错
do(_Type, _R) ->
    {error, unknow_type}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------
%%获取装备评分
get_eqm_score(Item, Career) ->
    #item{special = Special}= eqm_api:calc_point(Item, Career),
    case lists:keyfind(?special_eqm_point, 1, Special) of 
        {_, Score} ->
            Score;
        _ -> 0
    end.


craft_fac(?craft_1) -> 1.35;
craft_fac(?craft_2) -> 1.45;
craft_fac(?craft_3) -> 1.55;
craft_fac(?craft_4) -> 1.7;
craft_fac(?craft_5) -> 1.85;
craft_fac(_) -> 1.

%% 装备神佑品质系数
item_gs_fac(?quality_orange) -> 2.5;
item_gs_fac(?quality_purple) -> 1.85;
item_gs_fac(?quality_blue) -> 1.5;
item_gs_fac(?quality_green) -> 1.25;
item_gs_fac(_) -> 1.

%% 装备神佑等级系数
item_gs_lev_fac(0) -> 0;
item_gs_lev_fac(1) -> 0.01;
item_gs_lev_fac(2) -> 0.02;
item_gs_lev_fac(3) -> 0.03;
item_gs_lev_fac(4) -> 0.05;
item_gs_lev_fac(5) -> 0.07;
item_gs_lev_fac(6) -> 0.09;
item_gs_lev_fac(7) -> 0.11;
item_gs_lev_fac(8) -> 0.13;
item_gs_lev_fac(9) -> 0.15;
item_gs_lev_fac(10) -> 0.17;
item_gs_lev_fac(11) -> 0.19;
item_gs_lev_fac(12) -> 0.21;
item_gs_lev_fac(13) -> 0.23;
item_gs_lev_fac(14) -> 0.25;
item_gs_lev_fac(15) -> 0.27;
item_gs_lev_fac(16) -> 0.29;
item_gs_lev_fac(17) -> 0.31;
item_gs_lev_fac(18) -> 0.33;
item_gs_lev_fac(19) -> 0.35;
item_gs_lev_fac(20) -> 0.37;
item_gs_lev_fac(_) -> 0.37.

calc(soul, Souls) when is_record(Souls, channels) ->
    calc(soul, Souls#channels.list, 0);
calc(skill, Skills) ->
    calc(skill, Skills, 0);
calc(stone_hidden, Attr) ->
    calc(stone_hidden, Attr, {0, 0, 0});

calc(arms, {Item, Hidden, Stone, Ulev, Lev, Elev, ColorFac, Craft}) ->
    CraftFac = craft_fac(Craft),
    {GsLev, GsQuality} = item:get_gs_pingfeng_args(Item),
    GsQualityFac = item_gs_fac(GsQuality),
    GsLevFac = item_gs_lev_fac(GsLev),
    Score = util:ceil((2.6 * Ulev * (1 + 0.1 * Elev) * CraftFac + 0.8 * Lev * (Hidden/50)) * ?arms_fac * ColorFac * (1 + GsQualityFac * GsLevFac) + Stone * 60),
    % ?DEBUG("------:SCORE--~w~n",[Score]),
    Score;

% calc(armor, {Item, Hidden, Stone, Ulev, Lev, Elev, ColorFac, Type, Craft}) ->
%     CraftFac = craft_fac(Craft),
%     GsQualityFac = item_gs_fac(Item#item.quality),
%     {GsLev, _GsQuality} = item:get_gs_pingfeng_args(Item),
%     GsLevFac = item_gs_lev_fac(GsLev),
%     util:ceil((2.7 * Ulev * (1 + 0.1 * Elev) * CraftFac + 2 * Lev * (Hidden/50)) * armor_fac(Type) * ColorFac * (1 + GsQualityFac * GsLevFac) + Stone * 60);

calc(_Cmd, _Data) ->
    0.

% （等级颜色属性所加战斗力）*（1+强化等级*0.05）+鉴定属性所加战斗力 + 宝石属性所加战斗力
% calc(armor, #item{attr = Attr}, Enchant, Career) ->
%     ?DEBUG("---calc armor--Attr:~w~n",[Attr]),
%     %%计算等级颜色属性带来的属性加成
%     BaseAttr = [{Label1, Value1}||{Label1, Flag1, Value1} <-Attr, Flag1 =:= 100],
%     JdAttr = [{Label2, Value2}||{Label2, Flag2, Value2} <-Attr, Flag2 >= 1000],
%     StoneIds = [BaseId||{_, Flag3, BaseId}<-Attr, Flag3 =:= 101],
%     BaseValue = calc_attr_value(BaseAttr, Career, 0),
%     % ?DEBUG("---BaseAttr---:~w~n",[BaseAttr]),
%     % ?DEBUG("---BaseValue---:~w~n",[BaseValue]),
%     JdValue = calc_attr_value(JdAttr, Career, 0),
%     % ?DEBUG("---JdAttr---:~w~n",[JdAttr]),
%     % ?DEBUG("---JdValue---:~w~n",[JdValue]),
%     StoneValue = calc_stone_value(StoneIds, Career, 0), 
%     % ?DEBUG("---StoneIds---:~w~n",[StoneIds]),
%     % ?DEBUG("---StoneValue---:~w~n",[StoneValue]),
%     Score = round(BaseValue * (1 + Enchant * 0.05) + JdValue + StoneValue),
%     ?DEBUG("-------Score-------~w~n",[Score]),
%     Score.
    


calc(soul, [], Sum) ->
    Sum;
calc(soul, [#role_channel{lev = Lev, state = Uper} | T], Sum) ->
    calc(soul, T, Sum + (Lev * 10 * (200 + Uper)/300));

calc(skill, [], Sum) ->
    Sum;
calc(skill, [#skill{lev = Lev} | T], Sum) ->
    calc(skill, T, Sum + calc_skill(Lev));

calc(stone_hidden, [], {Sum1, Sum2, Sum3}) ->
    {Sum1, Sum2, Sum3};
calc(stone_hidden, [{_Labe, Flag, Value} | T], {Sum1, Sum2, Sum3}) ->
    case (Flag >= 100010) and (Flag =< 1010051) of
        true ->
            calc(stone_hidden, T, {Sum1 + Flag div 100000, Sum2, (Flag div 100) rem 1000});
        false when Flag =:= 101 ->
            calc(stone_hidden, T, {Sum1, Sum2 + stone_data:lev(Value), Sum3});
        _ ->
            calc(stone_hidden, T, {Sum1, Sum2, Sum3})
    end;

calc(_Cmd, _Data, Sum) ->
    Sum.

%%计算属性贡献的战斗力
% calc_attr_value([], _Career, Value) -> Value/18;
% calc_attr_value([{Label, Val}|T], Career, Value) -> 
%     case lists:keyfind(Label, 1, attr_parm(Career)) of 
%         {_, Parm} ->
%             calc_attr_value(T, Career, Val * Parm + Value);
%         _ ->
%             calc_attr_value(T, Career, Value)
%     end.

% calc_stone_value([], _Career, Value) -> Value;
% calc_stone_value([BaseId|T], Career, Value) ->
%     case item_data:get(BaseId) of 
%         {ok, #item_base{attr = Attr}} ->
%             Attr1 = [{Label1, Value1}||{Label1, Flag1, Value1} <-Attr, Flag1 =:= 100],
%             Value1 = calc_attr_value(Attr1, Career, Value),
%             calc_stone_value(T, Career, Value + Value1);
%         _ ->
%             calc_stone_value(T, Career, Value)
%     end.

% %%属性对应的参数
% attr_parm(Career) ->
%     case Career of
%         2 ->
%             [{?attr_aspd, 200}, {?attr_js, 3}, {?attr_dmg, 8.00}, {?attr_defence, 2}, {?attr_rst_metal, 5.00}, {?attr_hp_max, 1}, {?attr_mp_max, 0.1}, 
%             {?attr_hitrate, 25.00}, {?attr_evasion,25.00}, {?attr_critrate, 10.00}, {?attr_tenacity,10.00}, {?attr_dmg_magic, 8.00}];
%         3 ->
%             [{?attr_aspd, 200}, {?attr_js, 10}, {?attr_dmg, 8.00}, {?attr_defence, 2}, {?attr_rst_metal, 5.50}, {?attr_hp_max, 1}, {?attr_mp_max, 0.3}, 
%             {?attr_hitrate, 27.00}, {?attr_evasion,27.00}, {?attr_critrate, 12.00}, {?attr_tenacity,12.00}, {?attr_dmg_magic, 8.00}];
%         5 ->
%             [{?attr_aspd, 200}, {?attr_js, 3}, {?attr_dmg, 8.00}, {?attr_defence, 1.5}, {?attr_rst_metal, 4.5}, {?attr_hp_max, 0.9}, {?attr_mp_max, 0.1}, 
%             {?attr_hitrate, 23.00}, {?attr_evasion,25.00}, {?attr_critrate, 10.00}, {?attr_tenacity,10.00}, {?attr_dmg_magic, 8.00}]
%     end.

%        敏捷  智力  攻击  防御   抗性  生命   魔法  精准    格挡    暴怒    坚韧   绝对伤害
% 2刺客  200   3     8.00    2    5.00    1    0.1   25.00   25.00   10.00   10.00   8.00 
% 3贤者  200   10    8.00    2    5.50    1    0.3   27.00   27.00   12.00   12.00   8.00 
%5 骑士  200   3     8.00    1.5  4.50    0.9  0.1   23.00   25.00   10.00   10.00   8.00 

%% 技能评分计算
calc_skill(1) -> 100;
calc_skill(2) -> 270;
calc_skill(3) -> 370;
calc_skill(4) -> 460;
calc_skill(5) -> 540;
calc_skill(6) -> 615;
calc_skill(7) -> 685;
calc_skill(8) -> 750;
calc_skill(9) -> 810;
calc_skill(10) -> 865;
calc_skill(11) -> 915;
calc_skill(12) -> 960;
calc_skill(13) -> 1000;
calc_skill(_) -> 0.

% armor_fac(?armor_pos_jacket) ->
%     ?armor_fac_jacket;
% armor_fac(?armor_pos_belt) ->
%     ?armor_fac_belt;
% armor_fac(?armor_pos_cuff) ->
%     ?armor_fac_cuff;
% armor_fac(?armor_pos_nipper) ->
%     ?armor_fac_nipper;
% armor_fac(?armor_pos_pants) ->
%     ?armor_fac_pants;
% armor_fac(?armor_pos_shoes) ->
%     ?armor_fac_shoes;
% armor_fac(_) ->
%     0.


