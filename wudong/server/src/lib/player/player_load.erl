%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 一月 2015 下午9:41
%%%-------------------------------------------------------------------
-module(player_load).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").

%% API
-export([
%%    dbget_player_key_by_accname/2,
    dbget_player_key_by_accname/3,
    dbget_player_ass_by_idpf/1,
    dbget_player_login_data/1,
    dbget_player_state_data/1,
    dbget_name_key/1,
    dbget_player_list/3,
    dbget_player_lastlogin_time/1,
    dbget_name_by_key/1
]).

-export([dbup_player_login/3,
    dbup_player_location/1,
    dbup_player_state/1,
    dbup_player_coin/1,
    dbup_player_gold/1,
    dbup_player_repute/1,
    dbup_player_sd_pt/1,
    dbup_player_honor/1,
    dbup_smelt_value/1,
    dbup_player_lvexp/1,
    dbup_player_designation/1,
    dbup_mount/1,
    dbup_light_weapon_id/1,
    dbup_player_exploit_pri/1,
    dbup_max_stren_lv/1,
    dbup_max_stone_lv/1,
    dbup_player_arena_pt/1,
    dbup_player_xingyun_pt/1,
    dbup_player_xinghun/1,
    dbup_player_reiki/1,
    dbup_player_lv_time/1,
    dbup_player_gm/2,
    dbup_player_avatar/2,
    dbget_player_avatar/1,
    dbget_player_gm_count/0,
    dbup_player_name/1,
    dbup_player_cbp/1,
    dbup_player_charm/1,
    dbup_player_manor_pt/1,
    dbup_player_equip_part/1,
    dbup_player_sex/1,
    dbup_player_sweet/1,
    dbup_player_act_gold/1,
    dbup_player_fairy_crystal/1,
    dbup_player_new_career/1,
    dbup_login_flag/1
]).

-export([create_role/11
]).

-export([
    log_up_lv/5,
    log_login/2
]).

%% 根据账户名称查找角色个数

%% 根据账户名称查找角色个数
dbget_player_key_by_accname(AccName, _Pf1, Lan) when Lan == korea ->
    db:get_row(io_lib:format(<<"select pkey from player_login where accname = '~s' limit 1">>, [AccName]));
dbget_player_key_by_accname(AccName, Pf1, _Lan) ->
    db:get_row(io_lib:format(<<"select pkey from player_login where accname = '~s' and pf = ~p limit 1">>, [AccName, Pf1])).

%%dbget_player_key_by_accname(AccName, Pf1, Pf2) ->
%%    db:get_row(io_lib:format(<<"select pkey from player_login where accname = '~s' and pf in(~p,~p) limit 1">>, [AccName, Pf1, Pf2])).

dbget_player_ass_by_idpf(Pkey) ->
    db:get_row(io_lib:format(<<"select accname ,sn, status from player_login where pkey = ~p limit 1">>, [Pkey])).

dbget_name_key(Name) ->
    db:get_row(io_lib:format(<<"select pkey,sn,pf from player_state where nickname = '~s' limit 1">>, [Name])).

dbget_name_by_key(Pkey) ->
    db:get_row(io_lib:format(<<"select nickname from player_state where pkey = ~p limit 1">>, [Pkey])).

dbget_player_list(Accname, _Pf, Lan) when Lan == korea ->
    db:get_all(io_lib:format(<<"select ps.pkey,ps.nickname,ps.career,ps.sex,ps.lv,ps.mount_id,
									ps.wing_id,
									ps.wepon_id,
									ps.clothing_id,
								    ps.light_weapon_id,
									ps.fashion_cloth_id,
									ps.footprint_id,
							 		ps.combat_power,ps.head_id,
							 		ps.vip_lv,ps.vip_type,
							 		ps.sn
 									from player_state ps left join player_login pl on ps.pkey = pl.pkey where pl.accname = '~s'  order by pl.last_login_time desc ">>, [Accname]));
dbget_player_list(Accname, Pf, _Lan) ->
    db:get_all(io_lib:format(<<"select ps.pkey,ps.nickname,ps.career,ps.sex,ps.lv,ps.mount_id,
									ps.wing_id,
									ps.wepon_id,
									ps.clothing_id,
								    ps.light_weapon_id,
									ps.fashion_cloth_id,
									ps.footprint_id,
							 		ps.combat_power,ps.head_id,
							 		ps.vip_lv,ps.vip_type,
							 		ps.sn
 									from player_state ps left join player_login pl on ps.pkey = pl.pkey where pl.accname = '~s' and pl.pf = ~p order by pl.last_login_time desc ">>, [Accname, Pf])).


dbget_player_lastlogin_time(Pkey) ->
    Sql = io_lib:format("select last_login_time from player_login where pkey = ~p", [Pkey]),
    case db:get_row(Sql) of
        [] -> 0;
        [Time] -> Time
    end.

%%创建角色
create_role(AccName, Name, Career, Sex, IP, Source, Pf, PhoneID, OS, GameChannelId, GameId) ->
    SceneId = 10001,
    {X, Y} = version:get_born_point(),
    Platform = ?IF_ELSE(Pf > 0, Pf, 0),
    Time = util:unixtime(),
    Sn = config:get_server_num(),
    IpString = util:ip2bin(IP),
    Lv = 1,
%%    {Forza, Thew} = player_cfg:get_grow_attribute(Lv),
%%    {_Att, Hp_lim, _Def_p} = player_cfg:attribute1to2(Forza, Thew),
    Mp = 0,
    Hp_lim = 1500,
    Hp = Hp_lim,
    Attrs = util:term_to_bitstring([]),
    Pkey = misc:player_key(),
    BGold = 0,
    Gold = 0,
    Bcoin = 0,
    Coin = 0,
    Smelt_value = 0,
    SQL1 = io_lib:format("insert into player_login (pkey, sn , pf , accname , reg_time, reg_ip , last_login_time , last_login_ip , source , phone_id , os, game_channel_id, game_id) values (~p,~p,~p,'~s',~p,'~s',~p,'~s','~s','~s','~s',~p,~p)",
        [Pkey, Sn, Platform, AccName, Time, IpString, Time, IpString, Source, PhoneID, OS, GameChannelId, GameId]),
    SQL2 = io_lib:format("insert into player_state (pkey , sn , pf , nickname , lv ,career ,sex,realm ,scene,hp ,mp ,x,y,gold,bgold,coin,bcoin,smelt_value,attrs) values (~p,~p ,~p ,'~s',~p ,~p,~p ,~p ,~p ,~p,~p,~p,~p,~p,~p,~p,~p,~p,'~s')",
        [Pkey, Sn, Platform, Name, Lv, Career, Sex, 0, SceneId, Hp, Mp, X, Y, Gold, BGold, Coin, Bcoin, Smelt_value, Attrs]),
    F = fun(PoolPid) ->
        ok = db:transaction_query(PoolPid, SQL1),
        ok = db:transaction_query(PoolPid, SQL2)
        end,
    case db:transaction(F) of
        {error, Reason} ->
            ?ERR("create role err:~s/~s/~s ~n", [Reason, SQL1, SQL2]),
            {err, Reason};
        _ ->
            {ok, Pkey}
    end.


dbget_player_login_data(Pkey) ->
    SQL = io_lib:format("select accname ,last_login_time, total_online_time,logout_time,phone_id ,os ,setting,location,reg_time,avatar,reg_ip,login_days,game_id,game_channel_id from player_login where pkey = ~p limit 1", [Pkey]),
    db:get_row(SQL).

dbget_player_state_data(Pkey) ->
    SQL = io_lib:format("select nickname ,lv ,career ,sex,realm ,gold ,coin ,bgold ,bcoin,exp ,repute,honor,smelt_value,scene, x, y ,hp ,mp,sin, mount_id,light_weapon_id,designation,arena_pt,highest_combat_power,xinghun,gm,xingyun_pt,charm,manor_pt,is_interior,reiki,sd_pt,exploit_pri,x_old,y_old,scene_old,old_scene_pk,mkey,sweet,new_career,return_time,continue_end_time,equip_part,act_gold,fairy_crystal from player_state where pkey = ~p limit 1", [Pkey]),
    db:get_row(SQL).


dbup_player_login(Player, Now, IsOnline) ->
    LastLoginTime = Player#player.last_login_time,
    TotalOnlineTime = Player#player.total_online_time + (Now - LastLoginTime),
    SQL = io_lib:format("update player_login set last_login_time = ~p ,total_online_time = ~p ,logout_time = ~p ,login_days=~p,online=~p where pkey = ~p",
        [LastLoginTime, TotalOnlineTime, Now, Player#player.login_days, IsOnline, Player#player.key]),
    db:execute(SQL).

dbup_player_location(Player) ->
    Location = util:ip_location(Player#player.socket),
    SQL = io_lib:format("update player_login set location = '~s' where pkey = ~p", [Location, Player#player.key]),
    db:execute(SQL).


dbup_player_coin(Player) ->
    Sql = io_lib:format("update player_state set bcoin = ~p,coin=~p where pkey = ~p",
        [Player#player.bcoin, Player#player.coin, Player#player.key]),
    db:execute(Sql).

dbup_player_gold(Player) ->
    Sql = io_lib:format("update player_state set gold=~p,bgold = ~p where pkey = ~p",
        [Player#player.gold, Player#player.bgold, Player#player.key]),
    db:execute(Sql).



dbup_player_repute(Player) ->
    Sql = io_lib:format("update player_state set repute = ~p where pkey = ~p",
        [Player#player.repute, Player#player.key]),
    db:execute(Sql).

dbup_player_honor(Player) ->
    Sql = io_lib:format("update player_state set honor = ~p where pkey = ~p",
        [Player#player.honor, Player#player.key]),
    db:execute(Sql).

dbup_player_sd_pt(Player) ->
    Sql = io_lib:format("update player_state set sd_pt = ~p where pkey = ~p",
        [Player#player.sd_pt, Player#player.key]),
    db:execute(Sql).


dbup_player_manor_pt(Player) ->
    Sql = io_lib:format("update player_state set manor_pt = ~p where pkey = ~p",
        [Player#player.manor_pt, Player#player.key]),
    db:execute(Sql).

dbup_player_equip_part(Player) ->
    Sql = io_lib:format("update player_state set equip_part = ~p where pkey = ~p",
        [Player#player.equip_part, Player#player.key]),
    db:execute(Sql).

dbup_player_reiki(Player) ->
    Sql = io_lib:format("update player_state set reiki = ~p where pkey = ~p",
        [Player#player.reiki, Player#player.key]),
    db:execute(Sql).

dbup_player_sweet(Player) ->
    Sql = io_lib:format("update player_state set sweet = ~p where pkey = ~p",
        [Player#player.sweet, Player#player.key]),
    db:execute(Sql).


dbup_player_act_gold(Player) ->
    Sql = io_lib:format("update player_state set act_gold = ~p where pkey = ~p",
        [Player#player.act_gold, Player#player.key]),
    db:execute(Sql).

dbup_player_fairy_crystal(Player) ->
    Sql = io_lib:format("update player_state set fairy_crystal = ~p where pkey = ~p",
        [Player#player.fairy_crystal, Player#player.key]),
    db:execute(Sql).

dbup_player_new_career(Player) ->
    Sql = io_lib:format("update player_state set new_career = ~p where pkey = ~p",
        [Player#player.new_career, Player#player.key]),
    db:execute(Sql).

dbup_player_exploit_pri(Player) ->
    Sql = io_lib:format("update player_state set exploit_pri = ~p where pkey = ~p",
        [Player#player.exploit_pri, Player#player.key]),
    db:execute(Sql).


dbup_player_arena_pt(Player) ->
    Sql = io_lib:format("update player_state set arena_pt = ~p where pkey = ~p",
        [Player#player.arena_pt, Player#player.key]),
    db:execute(Sql).

dbup_player_xingyun_pt(Player) ->
    Sql = io_lib:format("update player_state set xingyun_pt = ~p where pkey = ~p",
        [Player#player.xingyun_pt, Player#player.key]),
    db:execute(Sql).


dbup_player_xinghun(Player) ->
    Sql = io_lib:format("update player_state set xinghun = ~p where pkey = ~p",
        [Player#player.xinghun, Player#player.key]),
    db:execute(Sql).

dbup_player_lv_time(Player) ->
    Sql = io_lib:format("update player_state set lv_up_time = ~p where pkey = ~p",
        [util:unixtime(), Player#player.key]),
    db:execute(Sql).



dbup_player_state(Player) ->
    #player{
        key = Pkey,
        lv = Lv,
        coin = Coin,
        bcoin = Bcoin,
        exp = Exp,
        scene = Scene,
        x = X,
        y = Y,
        hp = Hp,
        mp = Mp,
        sin = Sin,
        cbp = CombatPower,
        highest_cbp = HighestCbp,
        design = Design,
        vip_lv = VipLv,
        career = Career,
        mount_id = MountId,
        fashion = #fashion_figure{
            fashion_cloth_id = Fashion_cloth_id,
            fashion_head_id = Fashion_Head_id
        },
        light_weaponid = Light_weaponid,
        wing_id = WingId,
        baby_wing_id = BabyWingId,
        equip_figure = #equip_figure{
            weapon_id = Weapon_id,
            clothing_id = Clothing_id
        },
        x_old = Oldx,
        y_old = Oldy,
        scene_old = OldScene,
        old_scene_pk = OldScenePk,
        footprint_id = FootprintId,
        return_time = ReturnTime,
        continue_end_time = ContinueEndTime,
        d_vip = Dvip
    } = Player,
    VipType = Dvip#dvip.vip_type,
    AttributeString = util:term_to_bitstring(shadow_init:player_to_backup(Player)),
    DesignStr = util:term_to_bitstring(Design),
    SQL = io_lib:format("update player_state set lv = ~p,coin = ~p ,bcoin = ~p ,
						 exp = ~p ,scene = ~p ,x = ~p ,y = ~p ,hp = ~p ,mp = ~p,sin = ~p, 
						 combat_power = ~p ,highest_combat_power = ~p ,attrs = '~s',designation='~s',
						 vip_lv=~p ,mount_id = ~p,wing_id = ~p,light_weapon_id = ~p,fashion_cloth_id = ~p,
						 footprint_id = ~p,wepon_id = ~p,clothing_id = ~p,career = ~p,x_old=~p,y_old=~p,scene_old=~p,old_scene_pk=~p,head_id=~p,
						 baby_wing_id = ~p,vip_type = ~p,return_time=~p,continue_end_time=~p  where pkey = ~p",
        [Lv, Coin, Bcoin, Exp, Scene, X, Y, Hp, Mp, Sin,
            CombatPower, HighestCbp, AttributeString, DesignStr, VipLv,
            MountId, WingId, Light_weaponid, Fashion_cloth_id, FootprintId, Weapon_id, Clothing_id, Career, Oldx, Oldy, OldScene, OldScenePk, Fashion_Head_id, BabyWingId, VipType, ReturnTime, ContinueEndTime,
            Pkey]),
    db:execute(SQL).

dbup_player_charm(Player) ->
    #player{
        key = Key,
        charm = Charm
    } = Player,
    SQL = io_lib:format("update player_state set charm = ~p where pkey = ~p", [Charm, Key]),
    db:execute(SQL).

dbup_player_lvexp(Player) ->
    #player{
        key = Key,
        lv = Lv,
        exp = Exp
    } = Player,
    SQL = io_lib:format("update player_state set lv = ~p ,exp = ~p where pkey = ~p",
        [Lv, Exp, Key]),
    db:execute(SQL).

dbup_player_designation(Player) ->
    Key = Player#player.key,
    Des = Player#player.design,
    DesStr = util:term_to_string(Des),
    SQL = io_lib:format("update player_state set designation ='~s' where pkey = ~p",
        [DesStr, Key]),
    db:execute(SQL).

dbup_smelt_value(Player) ->
    #player{
        key = Key,
        smelt_value = Smelt_value
    } = Player,
    SQL = io_lib:format("update player_state set smelt_value = ~p  where pkey = ~p",
        [Smelt_value, Key]),
    db:execute(SQL).

dbup_max_stren_lv(Player) ->
    #player{
        key = Key,
        max_stren_lv = Max_stren_lv
    } = Player,
    SQL = io_lib:format("update player_state set max_stren_lv = ~p  where pkey = ~p",
        [Max_stren_lv, Key]),
    db:execute(SQL).

dbup_max_stone_lv(Player) ->
    #player{
        key = Key,
        max_stone_lv = Max_stone_lv
    } = Player,
    SQL = io_lib:format("update player_state set max_stone_lv = ~p  where pkey = ~p",
        [Max_stone_lv, Key]),
    db:execute(SQL).

dbup_mount(Player) ->
    #player{
        key = Key,
        mount_id = MountId
    } = Player,
    SQL = io_lib:format("update player_state set mount_id = ~p  where pkey = ~p",
        [MountId, Key]),
    db:execute(SQL).

dbup_light_weapon_id(Player) ->
    #player{
        key = Key,
        light_weaponid = Light_weapon_id
    } = Player,
    SQL = io_lib:format("update player_state set light_weapon_id = ~p  where pkey = ~p",
        [Light_weapon_id, Key]),
    db:execute(SQL).

dbup_player_gm(Pkey, GM) ->
    Sql = io_lib:format("update player_state set gm = ~p where pkey = ~p", [GM, Pkey]),
    db:execute(Sql),
    ok.

dbup_player_avatar(Pkey, Url) ->
    Sql = io_lib:format("update player_login set avatar = '~s' where pkey = ~p", [Url, Pkey]),
    db:execute(Sql),
    ok.

dbget_player_avatar(Pkey) ->
    Sql = io_lib:format("select avatar from player_login where pkey = ~p", [Pkey]),
    case db:get_row(Sql) of
        [AvatarBin] ->
            util:to_list(AvatarBin);
        _ ->
            []
    end.

dbget_player_gm_count() ->
    Sql = io_lib:format("select count(*) from player_state where gm > 0", []),
    case db:get_row(Sql) of
        [] -> 0;
        [Num] -> Num
    end.

dbup_player_name(Player) ->
    Sql = io_lib:format("update player_state set nickname = '~s' where pkey = ~p", [Player#player.nickname, Player#player.key]),
    db:execute(Sql),
    ok.

dbup_player_cbp(Player) ->
    Sql = io_lib:format("update player_state set combat_power=~p where pkey = ~p", [Player#player.cbp, Player#player.key]),
    db:execute(Sql),
    ok.

log_up_lv(Pkey, NickName, Lv, UpLv, Exptype) ->
    Now = util:unixtime(),
    SQL = io_lib:format("insert into log_lv set pkey = ~p ,nickname = '~s' ,lv = ~p ,uplv = ~p ,exptype = ~p,time = ~p", [Pkey, NickName, Lv, UpLv, Exptype, Now]),
    log_proc:log(SQL),
    ok.

dbup_player_sex(Player) ->
    Sql = io_lib:format("update player_state set sex = ~p where pkey = ~p", [Player#player.sex, Player#player.key]),
    db:execute(Sql),
    ok.

dbup_login_flag(Player) ->
    #player{login_flag = LoginFlag, key = Key} = Player,
    SQL = io_lib:format("update player_state set login_flag = '~s' where pkey = ~p",
        [LoginFlag, Key]),
    db:execute(SQL).

log_login(Player, NowTime) ->
    LastLogoutTime = Player#player.logout_time,
    LastLoginTimeStr =
        case version:get_lan_config() of
            vietnam ->
                util:unixtime_to_time_string4(Player#player.last_login_time);
            _ ->
                util:unixtime_to_time_string3(Player#player.last_login_time)
        end,

    NotTimeStr =
        case version:get_lan_config() of
            vietnam ->
                util:unixtime_to_time_string4(NowTime);
            _ ->
                util:unixtime_to_time_string3(NowTime)
        end,

    LastLoginTime = Player#player.last_login_time,
    TodayTime = util:get_today_midnight(NowTime),
    TotalOnlimeTime = NowTime - LastLoginTime,
    case util:is_same_date(LastLogoutTime, NowTime) of
        true ->
            if NowTime - LastLogoutTime > 300 ->
                SQL = io_lib:format("update log_login set data = CONCAT(data,',~s') ,online_time = online_time + ~p ,login_num = login_num + 1 where pkey = ~p and time = ~p", [util:term_to_string({LastLoginTimeStr, NotTimeStr}), TotalOnlimeTime, Player#player.key, TodayTime]),
                db:execute(SQL);
                true ->
                    skip
            end;
        false ->
            SQL = io_lib:format("insert into log_login set pkey = ~p ,nickname = '~s' ,time = ~p ,data = '~s',online_time = ~p,login_num = 1", [Player#player.key, Player#player.nickname, TodayTime, util:term_to_string({LastLoginTimeStr, NotTimeStr}), TotalOnlimeTime]),
            db:execute(SQL)
    end.
