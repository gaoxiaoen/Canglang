%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2017 15:04
%%%-------------------------------------------------------------------
-module(cross_1vn_init).
-author("Administrator").
-include("cross_1vN.hrl").
-include("common.hrl").
-include("server.hrl").
%% API
-export([
    dbup_cross_1vn_mb/1,
    dbget_cross_1vn_mb_all/0,
    dbget_cross_1vn_shop/1,
    dbup_cross_1vn_shop/1,
    dbup_cross_1vn_final_log_list/1,
    dbup_cross_1vn_final_log/3,
    dbget_cross_1vn_final_log/0,
    dbdelete_history/2,
    init/1]).

dbup_cross_1vn_mb(Mb) ->
    #cross_1vn_mb{
        sn = Sn,
        pkey = Pkey,
        nickname = Nickname,
        career = Career,
        sex = Sex,
        lv = Lv,
        times = Times,
        combo = Combo,
        lv_group = LvGroup,
        cbp = Cbp,
        win = Win,
        lose = Lose,
        score = Score,
        rank = Rank,
        final_floor = Floor, %% 决赛轮次
        guild_name = GuildName,
        guild_key = GuildKey,
        guild_position = GuildPosition,
        time = Time,
        flag = {FlagMonth, FlagDay}
    } = Mb,
    Sql = io_lib:format("replace into player_cross_1vn_mb set pkey = ~p,sn=~p,nickname='~s',career=~p,sex=~p,lv =~p,
   times=~p, combo=~p,lv_group=~p,cbp=~p,win=~p,lose=~p,score=~p,rank=~p,final_floor=~p,guild_name='~s',guild_key=~p,guild_position=~p,time=~p,flag_month=~p,flag_day=~p",
        [Pkey, Sn, Nickname, Career, Sex, Lv, Times, Combo, LvGroup, Cbp, Win, Lose, Score, Rank, Floor, GuildName, GuildKey, GuildPosition, Time, FlagMonth, FlagDay]),
    db:execute(Sql),
    case config:is_center_node() of %% 数据同步单服
        false -> skip;
        true ->
            center:apply_sn(Sn, cross_1vn_init, dbup_cross_1vn_mb, [Mb])
    end,
    ok.

dbget_cross_1vn_mb_all() ->
    Data = db:get_all("select  pkey ,sn,nickname,career,sex,lv ,times, combo,lv_group,cbp,win,lose,score,rank,final_floor,guild_name,guild_key,guild_position,time,flag_month,flag_day from player_cross_1vn_mb"),
    Now = util:unixtime(),
    F = fun([Pkey, Sn, Nickname, Career, Sex, Lv, Times, Combo,
        LvGroup, Cbp, Win, Lose, Score, Rank, Floor, GuildName, GuildKey, GuildPosition, Time, FlagMonth, FlagDay], SignList) ->
        case util:is_same_week(Time, Now) of
            false ->
                SignList;
            true ->
                Mb = #cross_1vn_mb{
                    sn = Sn,
                    pkey = Pkey,
                    nickname = Nickname,
                    career = Career,
                    sex = Sex,
                    lv = Lv,
                    times = Times,
                    combo = Combo,
                    lv_group = LvGroup,
                    cbp = Cbp,
                    win = Win,
                    lose = Lose,
                    score = Score,
                    rank = Rank,
                    final_floor = Floor, %% 决赛轮次
                    guild_name = GuildName,
                    guild_key = GuildKey,
                    guild_position = GuildPosition,
                    time = Time,
                    flag = {FlagMonth, FlagDay}
                },
                case lists:keytake(LvGroup, #cross_1vn_group.group, SignList) of
                    false -> [#cross_1vn_group{group = LvGroup, mb_list = [Mb]} | SignList];
                    {value, GroupList, T} ->
                        case lists:keytake(Mb#cross_1vn_mb.pkey, #cross_1vn_mb.pkey, GroupList#cross_1vn_group.mb_list) of
                            false ->
                                [GroupList#cross_1vn_group{mb_list = [Mb | GroupList#cross_1vn_group.mb_list]} | T];
                            {value, _, T0} ->
                                [GroupList#cross_1vn_group{mb_list = [Mb | T0]} | T]
                        end
                end
        end
    end,
    lists:foldl(F, [], Data).

init(#player{key = Pkey} = Player) ->
    St =
        case player_util:is_new_role(Player) of
            true -> #st_cross_1vn_shop{pkey = Pkey};
            false ->
                dbget_cross_1vn_shop(Player)
        end,
    lib_dict:put(?PROC_STATUS_CROSS_1VN_SHOP, St),
    Player.

dbget_cross_1vn_shop(Player) ->
    Sql = io_lib:format("select  pkey,lv_group, final_floor, time,rank, flag_month, flag_day from player_cross_1vn_mb where pkey = ~p", [Player#player.key]),
    case db:get_row(Sql) of
        [] -> #st_cross_1vn_shop{pkey = Player#player.key};
        [Pkey, LvGroup, Floor, Time, Rank, FlagMonth, FlagDay] ->
            case util:is_same_week(Time, util:unixtime()) of
                false ->
                    #st_cross_1vn_shop{pkey = Player#player.key};
                true ->
                    Sql1 = io_lib:format("select  shop_list,time from player_cross_1vn_shop where pkey = ~p", [Player#player.key]),
                    case db:get_row(Sql1) of
                        [] -> #st_cross_1vn_shop{
                            pkey = Pkey,
                            lv_group = LvGroup,
                            time = Time,
                            rank = Rank,
                            is_sign = 1,
                            floor = Floor,
                            flag = {FlagMonth, FlagDay}
                        };
                        [ShopListBin, Time1] ->
                            case util:is_same_week(Time1, util:unixtime()) of
                                false ->
                                    #st_cross_1vn_shop{
                                        pkey = Pkey,
                                        lv_group = LvGroup,
                                        time = Time1,
                                        rank = Rank,
                                        floor = Floor,
                                        is_sign = 1,
                                        shop = [],
                                        flag = {FlagMonth, FlagDay}
                                    };
                                true ->
                                    #st_cross_1vn_shop{
                                        pkey = Pkey,
                                        lv_group = LvGroup,
                                        time = Time1,
                                        rank = Rank,
                                        floor = Floor,
                                        is_sign = 1,
                                        shop = util:bitstring_to_term(ShopListBin),
                                        flag = {FlagMonth, FlagDay}
                                    }
                            end
                    end
            end
    end.

dbup_cross_1vn_shop(St) ->
    #st_cross_1vn_shop{
        pkey = Pkey,
        shop = Shop
    } = St,
    Sql = io_lib:format("replace into player_cross_1vn_shop set pkey = ~p,shop_list = '~s',time=~p",
        [Pkey, util:term_to_bitstring(Shop), util:unixtime()]),
    db:execute(Sql),
    ok.

dbup_cross_1vn_final_log_list(List) ->
    {{_Year, Month, Day}, {_Hour, _Minute, _Second}} = calendar:now_to_local_time({util:unixtime() div 1000000, util:unixtime() rem 1000000, 0}),
    F = fun(CrossGroup) ->
        F0 = fun(Mb) ->
            dbup_cross_1vn_final_log(Mb, Month, Day)
        end,
        lists:foreach(F0, CrossGroup#cross_1vn_group.mb_list)
    end,
    lists:foreach(F, List),
    {[{{Month, Day}, List}], Month, Day}.

dbup_cross_1vn_final_log(Mb, Month, Day) ->
    Sql = io_lib:format("insert into  cross_1vn_final_log (rank,sn,pkey, nickname,vip,guild_name,lv_group,month,day,head_id,mount_id, wing_id, wepon_id, clothing_id, light_wepon_id, fashion_cloth_id,cbp,sex,node ,time) VALUES(~p,~p,~p,'~s',~p,'~s',~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,'~s',~p)",
        [Mb#cross_1vn_mb.rank,
            Mb#cross_1vn_mb.sn,
            Mb#cross_1vn_mb.pkey,
            Mb#cross_1vn_mb.nickname,
            Mb#cross_1vn_mb.vip,
            Mb#cross_1vn_mb.guild_name,
            Mb#cross_1vn_mb.lv_group,
            Month,
            Day,
            Mb#cross_1vn_mb.head_id,
            Mb#cross_1vn_mb.mount_id,
            Mb#cross_1vn_mb.wing_id,
            Mb#cross_1vn_mb.wepon_id,
            Mb#cross_1vn_mb.clothing_id,
            Mb#cross_1vn_mb.light_wepon_id,
            Mb#cross_1vn_mb.fashion_cloth_id,
            Mb#cross_1vn_mb.cbp,
            Mb#cross_1vn_mb.sex,
            node(),
            util:unixtime()]),
    log_proc:log(Sql),
    ok.


dbget_cross_1vn_final_log() ->
    Sql = io_lib:format("select rank,sn,pkey, nickname,vip,guild_name,lv_group,month,day,mount_id, wing_id, wepon_id, clothing_id, light_wepon_id, fashion_cloth_id,head_id,time,cbp,sex from cross_1vn_final_log where node = '~s'", [node()]),
    Data = db:get_all(Sql),
    F = fun([Rank, Sn, Pkey, Nickname, Vip, GuildName, LvGroup, Month, Day,
        MountId, WingId, WeponId, ClothingId, LightWeponId, FashionClothId, HeadId, Time, Cbp, Sex], {HistoryInfo, HistoryGroup}) ->
        Mb = #cross_1vn_mb{
            sn = Sn,
            pkey = Pkey,
            head_id = HeadId,
            nickname = Nickname,
            vip = Vip,
            lv_group = LvGroup,
            rank = Rank,
            guild_name = GuildName,
            time = Time,
            cbp = Cbp,
            flag = {Month, Day},
            mount_id = MountId,
            wing_id = WingId,
            sex = Sex,
            wepon_id = WeponId,
            clothing_id = ClothingId,
            light_wepon_id = LightWeponId,
            fashion_cloth_id = FashionClothId
        },
        NewHistoryGroup =
            case lists:member({Month, Day}, HistoryGroup) of
                false -> [{Month, Day} | HistoryGroup];
                true -> HistoryGroup
            end,
        case lists:keytake({Month, Day}, 1, HistoryInfo) of
            false ->
                {[{{Month, Day}, [#cross_1vn_group{group = LvGroup, mb_list = [Mb]}]} | HistoryInfo], NewHistoryGroup};
            {value, {{Month, Day}, GroupList}, T} ->
                case lists:keytake(Mb#cross_1vn_mb.lv_group, #cross_1vn_group.group, GroupList) of
                    false ->
                        {[{{Month, Day}, [#cross_1vn_group{group = LvGroup, mb_list = [Mb]} | GroupList]} | T], NewHistoryGroup};
                    {value, Cross1vnGroup, T0} ->
                        case lists:keyfind(Mb#cross_1vn_mb.pkey, #cross_1vn_mb.pkey, Cross1vnGroup#cross_1vn_group.mb_list) of
                            false ->
                                {[{{Month, Day}, [Cross1vnGroup#cross_1vn_group{mb_list = [Mb | Cross1vnGroup#cross_1vn_group.mb_list]} | T0]} | T], NewHistoryGroup};
                            _ ->
                                {HistoryInfo, HistoryGroup}
                        end
                end
        end
    end,
    lists:foldl(F, {[], []}, Data).

dbdelete_history(MinMonth, MinDay) ->
    Sql = io_lib:format("delete FROM cross_1vn_final_log where `month` =~p and `day` =~p", [MinMonth, MinDay]),
    db:execute(Sql),
    ok.