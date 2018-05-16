%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 十一月 2015 下午8:54
%%%-------------------------------------------------------------------
-module(relation_rpc).
-author("fancy").
-include("server.hrl").
-include("common.hrl").
-include("relation.hrl").
%% API
-export([handle/3]).

%%获取关系列表
handle(24000, Player, {Type}) ->
    relation:get_relation_list(Player, Type),
    ok;

%%请求添加好友
handle(24001, Player, {Pkey}) ->
    case relation:add_friend_request(Player, Pkey) of
        ok ->
            {ok, Bin} = pt_240:write(24001, {1}),
            server_send:send_to_sid(Player#player.sid, Bin);
        {false, Code} ->
            {ok, Bin} = pt_240:write(24001, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end,
    ok;

%%添加好友
handle(24003, Player, {Key}) when Player#player.key /= Key ->
    {_, Code} = relation:add_friend(Player, Key),
    {ok, Bin} = pt_240:write(24003, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    relation:update_relation_list(Player, 1),
    ok;

%%删除好友
handle(24004, Player, {Key}) when Player#player.key /= Key ->
    {_, Code} = relation:del_friend(Player, Key),
    {ok, Bin} = pt_240:write(24004, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    relation:update_relation_list(Player, 1),
    ok;

%%添加黑名单
handle(24005, Player, {Key}) ->
    {_, Code} = relation:add_blacklist(Player, Key),
    {ok, Bin} = pt_240:write(24005, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    relation:update_relation_list(Player, 1),
    relation:update_relation_list(Player, 2),
    ok;

%%删除黑名单
handle(24006, Player, {Key}) ->
    {_, Code} = relation:del_blacklist(Player, Key),
    {ok, Bin} = pt_240:write(24006, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    relation:update_relation_list(Player, 2),
    ok;

%%获取推荐好友
handle(24007, Player, _) ->
    Recommend = relation:get_recommend(Player),
    NewRecommend = [[H | T] || [H | T] <- Recommend, H /= Player#player.key], %% 去除自身队伍
    {ok, Bin} = pt_240:write(24007, {NewRecommend}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%搜索玩家
handle(24008, Player, {NickName}) ->
    case relation_load:dbget_player_key(NickName) of
        [] ->
            {ok, Bin} = pt_240:write(24008, {[]});
        PlayerList0 ->
            PlayerList = lists:sublist(PlayerList0, 3),
            NewPlayerList = [[H | T] || [H | T] <- PlayerList, H /= Player#player.key], %% 去除自身
            {ok, Bin} = pt_240:write(24008, {NewPlayerList})
    end,
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%获取可邀请的在线玩家列表(好友+仙盟成员)
handle(24009, Player, {}) ->
    FriendList = relation:get_friend_info_list(),
    MemberList = guild_util:get_member_info_list(Player#player.guild#st_guild.guild_key),
    F = fun({Key, Nickname, Career, Sex, Vip, Lv, Cbp, Avatar}, List) ->
        if Key == Player#player.key ->
            List;
            true ->
                case lists:keymember(Key, 1, List) of
                    false ->
                        List ++ [{Key, Nickname, Career, Sex, Vip, Lv, Cbp, Avatar, Player#player.guild#st_guild.guild_name}];
                    true ->
                        List
                end
        end
    end,
    RelaList = lists:foldl(F, FriendList, MemberList),
    {ok, Bin} = pt_240:write(24009, {[tuple_to_list(Item) || Item <- RelaList]}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%点赞
handle(24011, Player, {Pkey}) ->
    friend_like:like(Pkey, Player);

%%获取最近联系人
handle(24014, Player, _) ->
    relation:pack_recently_contacts(Player);

%%送花
handle(24016, Player, {Pkey, ChatString, GoodsId, Num}) when Pkey =/= Player#player.key ->
    case relation:send_flower(Player, Pkey, GoodsId, Num, ChatString) of
        {ok, Player1, AddCharm, OtherPlayer} ->
            QmVal = relation:get_friend_qmd(Pkey),
            {ok, Bin} = pt_240:write(24016, {1, QmVal}),
            server_send:send_to_sid(Player#player.sid, Bin),
            OtherPlayer#player.pid ! {send_flower, Player#player.key, Player#player.nickname, Player#player.career, Player#player.avatar, GoodsId, Num, ChatString, AddCharm, Player#player.sex},
            {ok, Player1};
        {false, Code} ->
            QmVal = relation:get_friend_qmd(Pkey),
            {ok, Bin} = pt_240:write(24016, {Code, QmVal}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%感谢送花人
handle(24018, Player, {Pkey}) ->
    case player_util:get_player_online(Pkey) of
        [] ->
            {ok, Bin} = pt_240:write(24018, {10}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        OnLine ->
            {ok, Bin1} = pt_240:write(24018, {1}),
            server_send:send_to_sid(Player#player.sid, Bin1),
            OtherPlayer = relation:get_player_info(Player, Player#player.key),
            {ok, Bin24017} = pt_240:write(24017, OtherPlayer),
            server_send:send_to_sid(OnLine#ets_online.sid, Bin24017),
            ok
    end;

%%获取送花关系列表
handle(24020, Player, _) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    List = [[Releat#relation.pkey, Releat#relation.nickname] || Releat <- RelationsSt#st_relation.friends],
    {ok, Bin} = pt_240:write(24020, {List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%获取玩家简要信息
handle(24021, Player, {Pkey}) ->
    OtherPlayer = relation:get_player_info(Player, Pkey),
    {ok, Bin} = pt_240:write(24021, OtherPlayer),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%好友申请处理
handle(24022, Player, {Type, Pkey}) ->
    case player_util:get_player_online(Pkey) of
        [] ->
            skip;
        Online ->
            if
                Type == 1 ->
                    {_, Code} = relation:add_friend(Player, Pkey),
                    {ok, Bin} = pt_240:write(24022, {Code}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    relation:update_relation_list(Player, 1),
                    marry_room:add_friend(Pkey, Player),
                    Online#ets_online.pid ! {friend_return, Player, Type};
                true ->
%%                    {ok, Bin} = pt_240:write(24022, {1}),
                    Online#ets_online.pid ! {friend_return, Player, Type}
            end
    end,
    ok;

handle(_cmd, _Player, _Data) ->
    ok.