%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 十二月 2017 10:59
%%%-------------------------------------------------------------------
-module(guild_box_handle).
-author("luobq").

-include("common.hrl").
-include("server.hrl").
-include("guild.hrl").
-include("daily.hrl").
%% API
-export([
    handle_cast/2, handle_info/2, handle_call/3
]).

%% 初始化
handle_cast(init_state, _State) ->
    BoxList = guild_box_load:load_all_guild_box(),
    {noreply, #box_state{guild_box_state_list = BoxList}};

%% 获取仙盟宝箱信息
handle_cast({get_box_info, Player, FreeUpCount, BoxGetCount, Cd, IsCd, IndexId}, State) ->
    Now = util:unixtime(),
    GuildBoxStateList = State#box_state.guild_box_state_list,
    MyBoxList = [X || X <- GuildBoxStateList, X#guild_box.pkey == Player#player.key, X#guild_box.is_open /= 1, Now - X#guild_box.end_time < ?ONE_DAY_SECONDS],
    F = fun(GuildBox) ->
        BoxState =
            if
                GuildBox#guild_box.is_open == 1 -> 1;
                true ->
                    if
                        GuildBox#guild_box.end_time > Now -> 3;
                        true -> 2
                    end
            end,
        {HKey, Hname} =
            case GuildBox#guild_box.help_list of
                [{Hkey0, Hname0}] -> {Hkey0, Hname0};
                _ -> {0, ""}
            end,
        [GuildBox#guild_box.box_key,
            GuildBox#guild_box.base_id,
            BoxState,
            max(0, GuildBox#guild_box.end_time - Now),
            HKey, Hname,
            goods:pack_goods(GuildBox#guild_box.reward_list)]
    end,
    MyBoxListInfo = lists:map(F, MyBoxList),
    Base = data_guild_box:get(IndexId),
    {ok, Bin} = pt_400:write(40090, {FreeUpCount, ?GUILD_BOX_FREE_UP_COUTN, BoxGetCount, data_vip_args:get(58, Player#player.vip_lv), max(0, Cd - Now), IsCd, IndexId,
        ?GUILD_BOX_GET_COST,
        Base#base_guild_box.other_reward,
        ?GUILD_BOX_CLEAN_GET_CD_COST,
        ?GUILD_BOX_CLEAN_HELP_CD_COST,
        MyBoxListInfo}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {noreply, State};

%% 获取已协助列表
handle_cast({get_box_help_list, Sid, Gkey}, State) ->
    GuildBoxStateList = State#box_state.guild_box_state_list,
    if
        Gkey == 0 -> HelpList = [];
        true ->
            HelpList = [X || X <- GuildBoxStateList, X#guild_box.help_list /= [], X#guild_box.gkey == Gkey]
    end,
    Now = util:unixtime(),
    F = fun(GuildBox) ->
        {Hkey, Hname} = hd(GuildBox#guild_box.help_list),
        [GuildBox#guild_box.box_key,
            GuildBox#guild_box.base_id,
            GuildBox#guild_box.pkey,
            GuildBox#guild_box.pname,
            Hkey,
            Hname,
            max(0, GuildBox#guild_box.end_time - Now),
            goods:pack_goods(GuildBox#guild_box.reward_list),
            goods:pack_goods([{GoodsId, GoodsNum div 2} || {GoodsId, GoodsNum} <- GuildBox#guild_box.reward_list])]
    end,
    HelpListInfo = lists:map(F, HelpList),
%%     ?DEBUG("HelpListInfo ~p~n",[HelpListInfo]),
    {ok, Bin} = pt_400:write(40091, {lists:sublist(HelpListInfo, 10)}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

%% 获取可协助列表
handle_cast({get_box_not_help_list, HelpCount, Cd, IsCd, Sid, Pkey, Gkey}, State) ->
    Now = util:unixtime(),
    GuildBoxStateList = State#box_state.guild_box_state_list,
    if
        Gkey == 0 -> HelpList = [];
        true ->
            F0 = fun(GuildBox0) ->
                if
                    GuildBox0#guild_box.help_list /= [] -> []; %% 已经被协助
                    GuildBox0#guild_box.gkey /= Gkey -> []; %% 不是同一公会
                    GuildBox0#guild_box.pkey == Pkey -> []; %% 自身宝箱
                    GuildBox0#guild_box.is_open == 1 -> [];%% 已经被打开
                    GuildBox0#guild_box.end_time < Now -> [];%% 开启时间已到
                    true ->
                        ?DEBUG(" 11 GuildBox0#guild_box.end_time ~p~n", [GuildBox0#guild_box.end_time]),
                        ?DEBUG("11 Now ~p~n", [Now]),
                        [GuildBox0]
                end
            end,
            HelpList = lists:flatmap(F0, GuildBoxStateList)
    end,
    F = fun(GuildBox) ->
        [GuildBox#guild_box.box_key,
            GuildBox#guild_box.base_id,
            max(0, GuildBox#guild_box.end_time - Now),
            GuildBox#guild_box.pkey,
            GuildBox#guild_box.pname,
            goods:pack_goods(GuildBox#guild_box.reward_list),
            goods:pack_goods([{GoodsId, GoodsNum div 2} || {GoodsId, GoodsNum} <- GuildBox#guild_box.reward_list])]
    end,
    HelpListInfo = lists:map(F, HelpList),
%%     Data = {HelpCount, ?GUILD_BOX_HELP_COUTN, Cd, IsCd, HelpListInfo},
    {ok, Bin} = pt_400:write(40092, {HelpCount, ?GUILD_BOX_HELP_COUTN, max(0, Cd - Now), IsCd, HelpListInfo}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

%% 获取新宝箱
handle_cast({get_new_box, NewGuildBox}, State) ->
    NewState = State#box_state{guild_box_state_list = [NewGuildBox | State#box_state.guild_box_state_list]},
    guild_box_load:update_guild_box(NewGuildBox),
    {noreply, NewState};

%% 更新玩家宝箱信息
handle_cast({update_player_list_gkey, KeyList, Gkey}, State) ->
    BoxList0 = State#box_state.guild_box_state_list,
    F = fun(Key, BoxList) ->
        BoxList1 = [X || X <- BoxList, X#guild_box.pkey == Key],
        OtherBoxList = [X || X <- BoxList, X#guild_box.pkey /= Key],
        F0 = fun(GuildBox) ->
            NewGuildBox = GuildBox#guild_box{gkey = Gkey},
            guild_box_load:update_guild_box(NewGuildBox),
            NewGuildBox
        end,
        NewBoxList = lists:map(F0, BoxList1),
        NewBoxList ++ OtherBoxList
    end,
    NewList = lists:foldl(F, BoxList0, KeyList),
    NewState = State#box_state{guild_box_state_list = NewList},
    {noreply, NewState};

%% 宝箱求助
handle_cast({box_help_notice, Player, Bkey}, State) ->
    case lists:keyfind(Bkey, #guild_box.box_key, State#box_state.guild_box_state_list) of
        false ->
            skip;
        GuildBox ->
            {GoodsId, GoodsNum} =
                case GuildBox#guild_box.reward_list of
                    [{GoodsId0, GoodsNum0}] -> {GoodsId0, GoodsNum0};
                    _ -> {0, 0}
                end,
            Content = io_lib:format(t_tv:get(291), [t_tv:pn(Player), get_notice_text(GuildBox#guild_box.base_id), t_tv:gn(GoodsId), GoodsNum div 2]),
            notice:add_sys_notice_guild(Content, 291, Player#player.guild#st_guild.guild_key)
    end,
    {noreply, State};

%% 协助宝箱
handle_cast({help_box, Player, Bkey}, State) ->
    case lists:keytake(Bkey, #guild_box.box_key, State#box_state.guild_box_state_list) of
        false ->
            Res = 0,
            NewState = State;
        {value, GuildBox, T} ->
            case GuildBox#guild_box.help_list of
                [] ->
                    Now = util:unixtime(),
                    if
                        GuildBox#guild_box.end_time < Now ->
                            Res = 703,
                            NewState = State;
                        true ->
                            NewEndTime = (GuildBox#guild_box.end_time - Now) div 2 + Now,
                            NewGuildBox =
                                GuildBox#guild_box{
                                    help_list = [{Player#player.key, Player#player.nickname}],
                                    end_time = NewEndTime
                                },
                            Res = 1,
%%                             Player#player.pid ! {give_goods, GuildBox#guild_box.reward_list, 331},
                            NewList = [{GoodsId, GoodsNum div 2} || {GoodsId, GoodsNum} <- GuildBox#guild_box.reward_list],
                            Player#player.pid ! {help_box, NewList},
                            guild_box_load:update_guild_box(NewGuildBox),
                            log_guild_box_help(Player#player.key, Player#player.nickname, GuildBox#guild_box.pkey, GuildBox#guild_box.pname, NewList),
                            NewState = State#box_state{guild_box_state_list = [NewGuildBox | T]}
                    end;
                _ ->
                    Res = 702,
                    NewState = State
            end
    end,
    {ok, Bin} = pt_400:write(40095, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {noreply, NewState};

%% 获取宝箱奖励
handle_cast({get_box_reward, Player, Bkey}, State) ->
    case lists:keytake(Bkey, #guild_box.box_key, State#box_state.guild_box_state_list) of
        false ->
            Res = 0,
            NewState = State;
        {value, GuildBox, T} ->
            case GuildBox#guild_box.is_open of
                1 ->
                    Res = 704,
                    NewState = State;
                _ ->
                    Now = util:unixtime(),
                    if
                        GuildBox#guild_box.end_time > Now ->
                            Res = 705,
                            NewState = State;
                        true ->
                            NewGuildBox =
                                GuildBox#guild_box{
                                    is_open = 1,
                                    end_time = 0
                                },
                            Base = data_guild_box:get(GuildBox#guild_box.base_id),
                            IsHelp = ?IF_ELSE(GuildBox#guild_box.help_list == [], 0, 1),
                            RewardList = ?IF_ELSE(GuildBox#guild_box.help_list == [], GuildBox#guild_box.reward_list, [{10106, Base#base_guild_box.other_reward} | GuildBox#guild_box.reward_list]),
                            Player#player.pid ! {give_goods, RewardList, 332},
                            log_log_guild_box_get(Player#player.key, Player#player.nickname, IsHelp, RewardList),
                            guild_box_load:update_guild_box(NewGuildBox),
                            Res = 1,
                            NewState = State#box_state{guild_box_state_list = [NewGuildBox | T]}
                    end
            end
    end,
    {ok, Bin} = pt_400:write(40098, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {noreply, NewState};

%% 宝箱邮件发送
handle_cast({get_box_reward_to_mail, Player}, State) ->
    BoxList = State#box_state.guild_box_state_list,
    BoxList1 = [X || X <- BoxList, X#guild_box.pkey == Player#player.key],
    OtherBoxList = [X || X <- BoxList, X#guild_box.pkey /= Player#player.key],
    Now = util:unixtime(),
    F0 = fun(GuildBox) ->
        if
            GuildBox#guild_box.end_time < Now andalso GuildBox#guild_box.is_open == 0 ->
                GuildBox;
%%                 Msg = io_lib:format(?T("由于你离开公会，这是你的 ~s 奖励，请拿好"), [get_type_text(GuildBox#guild_box.base_id)]),
%%                 Reward =
%%                     if
%%                         GuildBox#guild_box.help_list == [] -> GuildBox#guild_box.reward_list;
%%                         true ->
%%                             Base = data_guild_box:get(GuildBox#guild_box.base_id),
%%                             [{10106, Base#base_guild_box.other_reward} | GuildBox#guild_box.reward_list]
%%                     end,
%%                 mail:sys_send_mail([Player#player.key], ?T("仙盟宝箱"), Msg, Reward),
%%                 NewGuildBox = GuildBox#guild_box{is_open = 1},
%%                 guild_box_load:update_guild_box(NewGuildBox),
%%                 NewGuildBox;
            true ->
                GuildBox
        end
    end,
    NewBoxList = lists:map(F0, BoxList1),
    NewList = NewBoxList ++ OtherBoxList,
    NewState = State#box_state{guild_box_state_list = NewList},
    {noreply, NewState};

handle_cast({get_notice_player, Player, Count, _Count1}, State) ->
    Ret = if
              Count > 0 -> 1;
%%               Count1 > 0 -> 1;
              true ->
                  Now = util:unixtime(),
                  List = [X || X <- State#box_state.guild_box_state_list, X#guild_box.end_time < Now, X#guild_box.pkey == Player#player.key, X#guild_box.is_open == 0],
                  ?IF_ELSE(List == [], 0, 1)
          end,
    activity:send_act_state(Player, {[[178, Ret] ++ activity:pack_act_state([])]}),
    {noreply, State};

handle_cast(Other, _State) ->
    ?ERR("Other ~p~n", [Other]),
    {noreply, _State}.

handle_call(_, _, _State) ->
    ok.


%%定时清除过期宝箱
handle_info(timer_delete, State) ->
    BoxList = State#box_state.guild_box_state_list,
    Now = util:unixtime(),
    NewList = [X || X <- BoxList, Now - X#guild_box.end_time < ?ONE_DAY_SECONDS * 3],
    guild_box_load:timer_delete(),
    {noreply, State#box_state{guild_box_state_list = NewList}};

handle_info(_, _State) ->
    ok.

get_notice_text(1) -> t_tv:cl(io_lib:format("~s", [util:to_list(?T("青铜宝箱"))]), 1);
get_notice_text(2) -> t_tv:cl(io_lib:format("~s", [util:to_list(?T("秘银宝箱"))]), 2);
get_notice_text(3) -> t_tv:cl(io_lib:format("~s", [util:to_list(?T("紫金宝箱"))]), 3);
get_notice_text(4) -> t_tv:cl(io_lib:format("~s", [util:to_list(?T("黄金宝箱"))]), 4);
get_notice_text(5) -> t_tv:cl(io_lib:format("~s", [util:to_list(?T("红钻宝箱"))]), 5);
get_notice_text(_) -> t_tv:cl(io_lib:format("~s", [util:to_list(?T(""))]), 1).


get_type_text(1) -> ?T("青铜宝箱");
get_type_text(2) -> ?T("秘银宝箱");
get_type_text(3) -> ?T("紫金宝箱");
get_type_text(4) -> ?T("黄金宝箱");
get_type_text(5) -> ?T("红钻宝箱");
get_type_text(_) -> ?T("").

log_log_guild_box_get(Pkey, Nickname, IsHelp, GoodsList) ->
    Sql = io_lib:format("insert into  log_guild_box_get (pkey, nickname,is_help,goods_list,time) VALUES(~p,'~s',~p,'~s',~p)",
        [Pkey, Nickname, IsHelp, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql),
    ok.


log_guild_box_help(Pkey, Nickname, Pkey1, Nickname1, GoodsList) ->
    Sql = io_lib:format("insert into  log_guild_box_help (pkey, nickname,pkey1, nickname1,goods_list,time) VALUES(~p,'~s',~p,'~s','~s',~p)",
        [Pkey, Nickname, Pkey1, Nickname1, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql),
    ok.