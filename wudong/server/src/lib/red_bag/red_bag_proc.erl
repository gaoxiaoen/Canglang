%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 四月 2016 下午2:20
%%%-------------------------------------------------------------------
-module(red_bag_proc).
-author("fengzhenlin").

-behaviour(gen_server).

-include("red_bag.hrl").
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-export([
    get_server_pid/0,
    add_red_bag/2,
    open_red_bag/2,
    open_red_bag_guild/2,
    open_red_bag_marry/2,
    add_red_bag_guild/2,
    add_red_bag_guild_by_sys/4,
    add_marry_red_bag/3
]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API
%%%===================================================================
get_server_pid() ->
    case get(red_bag_proc) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            case misc:whereis_name(local, ?MODULE) of
                Pid when is_pid(Pid) ->
                    put(red_bag_proc, Pid),
                    Pid;
                _ ->
                    undefined
            end
    end.

%%增加普通红包
add_red_bag(Player, [GoodsId]) ->
    case data_red_bag:get(GoodsId) of
        [] ->
            skip;
        _ ->
            RedBagKey = misc:unique_key(),
            notice_sys:add_notice(red_bag, [Player, RedBagKey]),
            NoticeMsg = io_lib:format(t_tv:get(187), [t_tv:pn(Player), RedBagKey]),
            Now = util:unixtime(),
            RedBag = #red_bag{
                type = 1,
                key = RedBagKey,
                pkey = Player#player.key,
                name = Player#player.nickname,
                career = Player#player.career,
                sex = Player#player.sex,
                avatar = Player#player.avatar,
                goods_id = GoodsId,
                time = Now
            },
            ?CAST(get_server_pid(), {add_red_bag, RedBag, NoticeMsg}),
            ok
    end.


open_red_bag(RedBagKey, [Pkey, PSid, Pname, Pid, Career, Sex, Avatar]) ->
    ?CAST(get_server_pid(), {open_red_bag, RedBagKey, [Pkey, PSid, Pname, Pid, Career, Sex, Avatar]}),
    ok.

open_red_bag_guild(RedBagKey, PlayerInfo) ->
    ?CAST(get_server_pid(), {open_red_bag_guild, RedBagKey, PlayerInfo}),
    ok.


open_red_bag_marry(RedBagKey, PlayerInfo) ->
    ?CAST(get_server_pid(), {open_red_bag_marry, RedBagKey, PlayerInfo}),
    ok.

%%增加帮派红包
add_red_bag_guild(Player, GoodsId) ->
    Key = misc:unique_key(),
    RedBag = #red_bag{
        type = 2,
        key = Key,
        pkey = Player#player.key,
        gkey = Player#player.guild#st_guild.guild_key,
        name = Player#player.nickname,
        career = Player#player.career,
        sex = Player#player.sex,
        avatar = Player#player.avatar,
        goods_id = GoodsId,
        guild_red_type = 1,
        time = util:unixtime()
    },
    Msg = io_lib:format(t_tv:get(166), [t_tv:pn(Player), Key]),
    chat:sys_send_to_guild(#player{}, Player#player.guild#st_guild.guild_key, Msg),
    ?CAST(get_server_pid(), {add_red_bag, RedBag, ""}),
    ok.

%%增加系统帮派红包
add_red_bag_guild_by_sys(GoodsId, GuildKey, Name,KillKey) ->
    Key = misc:unique_key(),
    RedBag = #red_bag{
        type = 2,
        key = Key,
        pkey = KillKey,
        gkey = GuildKey,
        name = Name,%io_lib:format(?T("~s伤害第一带你飞"), [Name]),
        goods_id = GoodsId,
        guild_red_type = 2,
        time = util:unixtime()
    },
    ?CAST(get_server_pid(), {add_red_bag, RedBag, ""}),
    ok.

%%添加结婚红包
add_marry_red_bag(Player, Couple, [GoodsId]) ->
    case data_red_bag_guild:get(GoodsId) of
        [] ->
            skip;
        _ ->
            RedBagKey = misc:unique_key(),
            notice_sys:add_notice(red_bag_marry, [Player, Couple,RedBagKey]),
            Now = util:unixtime(),
            RedBag = #red_bag{
                type = 3,
                scene = ?SCENE_ID_MAIN,
                key = RedBagKey,
                pkey = Player#player.key,
                name = Player#player.nickname,
                career = Player#player.career,
                sex = Player#player.sex,
                avatar = Player#player.avatar,
                couple_key = Couple#player.key,
                couple_name = Couple#player.nickname,
                couple_career = Couple#player.career,
                couple_sex = Couple#player.sex,
                couple_avatar = Couple#player.avatar,
                goods_id = GoodsId,
                time = Now
            },
            ?CAST(get_server_pid(), {add_red_bag, RedBag, ""}),
            ok
    end.


%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    ets:new(?RED_BAG_ETS, [{keypos, #red_bag.key} | ?ETS_OPTIONS]),
    Ref = erlang:send_after(?RED_BAG_NOTICE_TIME, self(), red_bag_notice_time),
    Ref1 = erlang:send_after(?RED_BAG_EXPIRE_CHECT_TIME * 1000, self(), check_red_bag_expire_time),
    {ok, #red_bag_st{ref = Ref, expire_ref = Ref1}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
handle_call(Request, From, State) ->
    case catch red_bag_handle:handle_call(Request, From, State) of
        {reply, Res, NewState} ->
            {reply, Res, NewState};
        Reason ->
            ?ERR("red_bag_handle handle_info ~p~n", [Reason]),
            {reply, ok, State}
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
handle_cast(Request, State) ->
    case catch red_bag_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("red_bag_handle handle_cast ~p~n", [Reason]),
            {noreply, State}
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(Info, State) ->
    case catch red_bag_handle:handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("red_bag_handle handle_info ~p~n", [Reason]),
            {noreply, State}
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================