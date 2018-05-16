%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 四月 2018 下午3:14
%%%-------------------------------------------------------------------
-module(cross_mining_notice).
-author("luobaqun").
-include("server.hrl").
-include("common.hrl").

%% API
-compile(export_all).


%% 奇遇奖励
send_meet_mail(Pkey, Reward) ->
    {Title, Content} = t_mail:mail_content(182),
    mail:sys_send_mail([Pkey], Title, Content, Reward),
    ok.

%% 100% 收获奖励
send_hold_reward(Pkey, Reward) ->
    {Title, Content} = t_mail:mail_content(183),
    mail:sys_send_mail([Pkey], Title, Content, Reward),
    ok.

%%  被抢夺收获奖励
send_hold_reward2(Pkey, Reward) ->
    {Title, Content} = t_mail:mail_content(184),
    mail:sys_send_mail([Pkey], Title, Content, Reward),
    ok.

%%  发送抢夺奖励(收获期间)
send_ripe_att_mail(Pkey, Reward) ->
    {Title, Content} = t_mail:mail_content(185),
    mail:sys_send_mail([Pkey], Title, Content, Reward),
    ok.

%%  发送抢夺奖励(非收获期)
send_att_mail(Pkey, Reward) ->
    {Title, Content} = t_mail:mail_content(186),
    mail:sys_send_mail([Pkey], Title, Content, Reward),
    ok.

%%  被抢夺奖励(非收获期)
send_def_mail(Pkey, Pname, Reward) ->
    Num =
        case Reward of
            [] -> 0;
            _ ->
                {_GoodsId, GoodsNum} = hd(Reward),
                GoodsNum
        end,
    {Title, Content0} = t_mail:mail_content(187),
    Content = io_lib:format(Content0, [Pname, Num]),
    mail:sys_send_mail([Pkey], Title, Content, Reward),
    {ok, Bin} = pt_430:write(43099, {[[196, 1] ++ activity:pack_act_state([])]}),
    server_send:send_to_key(Pkey, Bin),
    ok.

%%  被抢夺奖励(收获期)
send_ripe_def_mail(Pkey, Pname, Reward) ->
    Num =
        case Reward of
            [] -> 0;
            _ ->
                {_GoodsId, GoodsNum} = hd(Reward),
                GoodsNum
        end,
    {Title, Content0} = t_mail:mail_content(188),
    Content = io_lib:format(Content0, [Pname, Num]),
    mail:sys_send_mail([Pkey], Title, Content, []),
    ok.

%%  击杀小偷奖励
send_att_thief_reward(Pkey, Reward) ->
    {Title, Content} = t_mail:mail_content(189),
    mail:sys_send_mail([Pkey], Title, Content, Reward),
    ok.

%% 灵宝出世公告
notice_meet_start() ->
    F = fun(Node) ->
        center:apply(Node, notice_sys, add_notice, [notice_meet_start, []])
        end,
    lists:foreach(F, center:get_nodes()),
    ok.

%% 灵宝消失公告
notice_meet_end(PName, Type, Page, Id, GoodsList) ->
    F = fun(Node) ->
        center:apply(Node, notice_sys, add_notice, [notice_meet_end, [PName, Type, Page, Id, GoodsList]])
        end,
    lists:foreach(F, center:get_nodes()),
    ok.

%% 小偷刷新公告
notice_thief_start() ->
    F = fun(Node) ->
        center:apply(Node, notice_sys, add_notice, [notice_thief_start, []])
        end,
    lists:foreach(F, center:get_nodes()),
    ok.

%% 小偷消失公告
notice_thief_end(PName, Type, Page, Id) ->
    F = fun(Node) ->
        center:apply(Node, notice_sys, add_notice, [notice_thief_end, [PName, Type, Page, Id]])
        end,
    lists:foreach(F, center:get_nodes()),
    ok.

%% 广播公告
notice_sys(MineralInfo, List) ->
    Sids = [Sid || {_, _, Sid} <- List],
    Data = cross_mining_util:make_mine_info_60409(MineralInfo),
    {ok, Bin} = pt_604:write(60409, Data),
    lists:foreach(fun(Sid) -> server_send:send_to_sid(Sid, Bin) end, Sids),
    ok.

reset_notice(List) ->
    Sids = [Sid || {_, _, Sid} <- List],
    {ok, Bin} = pt_604:write(60411, {1}),
    lists:foreach(fun(Sid) -> server_send:send_to_sid(Sid, Bin) end, Sids),
    ok.

send_rank_mail(Pkey, Rank, GoodsList) ->
    {Title, Content0} = t_mail:mail_content(190),
    Content = io_lib:format(Content0, [Rank]),
    mail:sys_send_mail([Pkey], Title, Content, GoodsList),
    ok.

%% 玩家进攻日志
log_cross_mine_att(AttPkey, DefPkey, AttType, Type, Page, Id, Reward, OldHp, NewHp, IsHit, Time) ->
    Sql = io_lib:format("insert into  log_cross_mine_att (att_key,def_key,att_type,location_type,location_page,location_id,reward,old_hp,new_hp,is_hit,time) VALUES(~p,~p,~p,~p,~p,~p,'~s',~p,~p,~p,~p)",
        [AttPkey, DefPkey, AttType, Type, Page, Id, util:term_to_bitstring(Reward), OldHp, NewHp, IsHit, Time]),
    log_proc:log(Sql),
    ok.

%% 奖励日志
log_cross_mine_get_mine_reward(Pkey, EventType, IsHit, Type, Page, Id, Reward) ->
    Sql = io_lib:format("insert into  log_cross_mine_get_mine_reward (pkey,event_type,is_hit,location_type,location_page,location_id,reward,time) VALUES(~p,~p,~p,~p,~p,~p,'~s',~p)",
        [Pkey, EventType, IsHit, Type, Page, Id, util:term_to_bitstring(Reward), util:unixtime()]),
    log_proc:log(Sql),
    ok.
