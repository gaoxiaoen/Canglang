%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 十一月 2015 下午8:54
%%%-------------------------------------------------------------------
-module(relation_load).
-author("fancy").
-include("common.hrl").
-include("server.hrl").


%% API
-export([
    dbadd_relation/7
    , dbget_relations/1
    , dbdel_relation/1
    , dbget_relation_info/1
    , dbget_recommend/3
    , dbget_player_key/1
    , dbget_friend_like/1
    , update_friend_like/3
    , dbupdate_qinmidu/2
    , dbupdate_qinmidu_and_list/3
]).

dbget_relations(Pkey) ->
    SQL = io_lib:format("select rkey ,key1,key2,type,qinmidu,key1_avatar,key2_avatar,time,qinmidu_args from relation where key1 = ~p or key2 = ~p", [Pkey, Pkey]),
    db:get_all(SQL).

dbupdate_qinmidu(Qinmidu, Rkey) ->
    SQL = io_lib:format("update relation set qinmidu = ~p where rkey = ~p", [Qinmidu, Rkey]),
    db:execute(SQL).

dbupdate_qinmidu_and_list(QingmiduList, Qinmidu, Rkey) ->
    SQL = io_lib:format("update relation set qinmidu = ~p ,qinmidu_args = '~s' where rkey = ~p", [Qinmidu, util:term_to_bitstring(QingmiduList),Rkey]),
    db:execute(SQL).

dbadd_relation(Rkey, Key1, Key1Avatar, Key2, Key2Avatar, Type, Time) ->
    SQL = io_lib:format("insert into relation set rkey = ~p ,key1 = ~p  ,key1_avatar = '~s', key2 = ~p, key2_avatar = '~s' ,type = ~p ,time = ~p", [Rkey, Key1, Key1Avatar, Key2, Key2Avatar, Type, Time]),
    db:execute(SQL).

dbdel_relation(Rkey) ->
    SQL = io_lib:format("delete from relation where rkey = ~p", [Rkey]),
    db:execute(SQL).

dbget_relation_info(Pkey) ->
    SQL = io_lib:format("select nickname,career,realm,lv,combat_power,sex,vip_lv from player_state where pkey = ~p ", [Pkey]),
    db:get_row(SQL).

dbget_recommend(Player, Type, FriendKeyList) ->
    Lv = Player#player.lv,
    Location = Player#player.location,
    Career = Player#player.career,
    FriendKeyList3 = ["'" ++ util:make_sure_list(S) ++ "'" || S <- FriendKeyList],
    FriendKeyStr = string:join(FriendKeyList3, ","),
    {Where, Param} = case Type of
                         2 -> {"and ps.career ", util:to_list(Career)};
                         3 -> {"and pl.location ", Location};
                         _ -> {"and 1 ", "1"}
                     end,
    SQL = io_lib:format("select ps.pkey,ps.sn,ps.nickname,ps.career,ps.realm,ps.combat_power,ps.sex,ps.lv,pl.location from player_state ps left join player_login pl on ps.pkey = pl.pkey
        where lv > ~p and lv < ~p ~s = '~s'  and ps.pkey not in (~s) order by pl.last_login_time desc limit 5", [Lv - 4, Lv + 4, Where, Param, FriendKeyStr]),
    util:list_shuffle(db:get_all(SQL)).


dbget_player_key(NickName) ->
    SQL = io_lib:format("select pkey,sn,nickname,career,realm,combat_power,sex,lv,wing_id,wepon_id,clothing_id,light_weapon_id,fashion_cloth_id,head_id from player_state where nickname like '%~s%'", [NickName]),
    db:get_all(SQL).

dbget_friend_like(Player) ->
    case player_util:is_new_role(Player) of
        true ->
            {0, 0};
        false ->
            SQL = io_lib:format("select like_times,self_like_times from friend_like where pkey = ~p", [Player#player.key]),
            case db:get_row(SQL) of
                [] ->
                    {0, 0};
                [LikeTimes, SelfLikeTimes] ->
                    case util:is_same_date(util:unixtime(), Player#player.logout_time) of
                        true ->
                            {LikeTimes, SelfLikeTimes};
                        false ->
                            relation_load:update_friend_like(Player#player.key, 0, 0),
                            {0, 0}
                    end
            end
    end.


update_friend_like(Pkey, LikeTimes, SelfLikeTimes) ->
    Sql = io_lib:format("replace into friend_like set pkey=~p ,like_times = ~p,self_like_times=~p", [Pkey, LikeTimes, SelfLikeTimes]),
    db:execute(Sql).



