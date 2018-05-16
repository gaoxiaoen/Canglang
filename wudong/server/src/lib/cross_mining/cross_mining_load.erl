%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 四月 2018 上午10:23
%%%-------------------------------------------------------------------
-module(cross_mining_load).
-author("luobaqun").
-include("cross_mining.hrl").
-include("common.hrl").
-compile(export_all).


get_mining_list() ->
    db:get_all("select type,page,id,mtype,start_time,first_hold_time,last_hold_time,ripe_time,end_time,is_notice,hp,hp_lim,is_hit,hold_sn,hold_key,hold_sex,hold_avatar,hold_name,hold_guild_name,hold_cbp,hold_vip,hold_dvip,meet_type,meet_start_time,meet_end_time,thief_start_time,thief_end_time,thief_cbp,help_list from cross_mining").


dbup_cross_mining(MineralInfo) ->
    ?DEBUG("MineralInfo ~p~n",[MineralInfo#mineral_info.help_list]),

    Sql = io_lib:format("replace into cross_mining set type=~p,page=~p,id=~p,mtype=~p,start_time=~p,first_hold_time=~p,last_hold_time=~p,ripe_time=~p,end_time=~p,is_notice=~p,hp=~p,hp_lim=~p,is_hit=~p,hold_sn=~p,hold_key=~p,hold_sex=~p,hold_avatar='~s', hold_name='~s',hold_guild_name='~s',hold_cbp=~p,hold_vip=~p,hold_dvip=~p,meet_type=~p,meet_start_time=~p,meet_end_time=~p,thief_start_time=~p,thief_end_time=~p,thief_cbp=~p,help_list='~s'",
        [
            MineralInfo#mineral_info.type,
            MineralInfo#mineral_info.page,
            MineralInfo#mineral_info.id,
            MineralInfo#mineral_info.mtype,
            MineralInfo#mineral_info.start_time,
            MineralInfo#mineral_info.first_hold_time,
            MineralInfo#mineral_info.last_hold_time,
            MineralInfo#mineral_info.ripe_time,
            MineralInfo#mineral_info.end_time,
            MineralInfo#mineral_info.is_notice,
            MineralInfo#mineral_info.hp,
            MineralInfo#mineral_info.hp_lim,
            MineralInfo#mineral_info.is_hit,
            MineralInfo#mineral_info.hold_sn,
            MineralInfo#mineral_info.hold_key,
            MineralInfo#mineral_info.hold_sex,
            MineralInfo#mineral_info.hold_avatar,
            MineralInfo#mineral_info.hold_name,
            MineralInfo#mineral_info.hold_guild_name,
            MineralInfo#mineral_info.hold_cbp,
            MineralInfo#mineral_info.hold_vip,
            MineralInfo#mineral_info.hold_dvip,
            MineralInfo#mineral_info.meet_type,
            MineralInfo#mineral_info.meet_start_time,
            MineralInfo#mineral_info.meet_end_time,
            MineralInfo#mineral_info.thief_start_time,
            MineralInfo#mineral_info.thief_end_time,
            MineralInfo#mineral_info.thief_cbp,
            util:term_to_bitstring(cross_mining_util:help_recore2list(MineralInfo#mineral_info.help_list))
        ]),
    db:execute(Sql),
    ok.

dbdelete_cross_mining(MineralInfo) ->
    db:execute(io_lib:format("delete from cross_mining where type = ~p and page = ~p and id = ~p", [MineralInfo#mineral_info.type, MineralInfo#mineral_info.page, MineralInfo#mineral_info.id])),
    ok.


dbget_cross_mining_rank_list() ->
    db:get_all("select pkey,sn,nickname,cbp,vip,dvip,score,time,rank from cross_mining_rank").

dbup_cross_mining_rank(Mb) ->
    Sql = io_lib:format("replace into cross_mining_rank set pkey=~p,sn=~p,nickname='~s',cbp=~p,vip=~p,dvip=~p,score=~p,time=~p,rank=~p",
        [
            Mb#mining_info_rank.pkey,
            Mb#mining_info_rank.sn,
            Mb#mining_info_rank.nickname,
            Mb#mining_info_rank.cbp,
            Mb#mining_info_rank.vip,
            Mb#mining_info_rank.dvip,
            Mb#mining_info_rank.score,
            Mb#mining_info_rank.time,
            Mb#mining_info_rank.rank
        ]),
    db:execute(Sql),
    ok.


dbget_player_cross_mining_help(Pkey) ->
    Sql = io_lib:format("select my_help_list, reset_list from player_cross_mining_help where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [MyHelpListBin, ResetListBin] ->
            MyHelpList = util:bitstring_to_term(MyHelpListBin),
            ResetList = util:bitstring_to_term(ResetListBin),
            #st_cross_mine_help{
                pkey = Pkey,
                my_help_list = cross_mining_util:help_list2recore(MyHelpList),   %% 已购买列表 [#help_info{}]
                reset_list = cross_mining_util:help_list2recore(ResetList)
            };
        _ ->
            #st_cross_mine_help{pkey = Pkey}
    end.



dbup_player_cross_mining_help(St) ->
    #st_cross_mine_help{
        pkey = Pkey,
        my_help_list = MyHelpList,
        reset_list = ResetList
    } = St,
    Sql = io_lib:format("replace into player_cross_mining_help set my_help_list='~s',reset_list='~s', pkey=~p",
        [util:term_to_bitstring(cross_mining_util:help_recore2list(MyHelpList)), util:term_to_bitstring(cross_mining_util:help_recore2list(ResetList)), Pkey]),
    db:execute(Sql),
    ok.

