%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十一月 2015 10:58
%%%-------------------------------------------------------------------
-module(guild_handle).
-author("hxming").
-include("common.hrl").
-include("guild.hrl").
%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).

%% 调用接口 player:apply
handle_call({apply, {Module, Function, Args}}, _From, State) ->
    case Module:Function(Args) of
        {ok, Reply} ->
            {reply, Reply, State};
        ok ->
            {reply, State};
        _Err ->
            ?ERR("apply unkonw return val ~p~n", [_Err]),
            {noreply, State}
    end;

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%% 调用接口 player:apply
handle_cast({apply, {Module, Function, Args}}, State) ->
    case Module:Function(Args) of
        {ok, NewState} ->
            {noreply, NewState};
        ok ->
            {noreply, State};
        _Err ->
            ?ERR("apply unkonw return val ~p~n", [_Err]),
            {noreply, State}
    end;

handle_cast(_Request, State) ->
    {noreply, State}.


%% 调用接口 player:apply
handle_info({apply, {Module, Function, Args}}, State) ->
    case Module:Function(Args) of
        {ok, NewState} ->
            {noreply, NewState};
        ok ->
            {noreply, State};
        _Err ->
            ?ERR("apply unkonw return val ~p~n", [_Err]),
            {noreply, State}
    end;


%%系统仙盟处理
handle_info(sys_guild_timer, State) ->
    util:cancel_ref([State#guild_state.sys_guild_ref]),
    Ref1 = erlang:send_after(?GUILD_SYS_GUILD_TIME * 1000, self(), sys_guild_timer),
    %%先屏蔽系统工会
%%     guild_sys:guild_sys(),
    {noreply, State#guild_state{sys_guild_ref = Ref1}};

handle_info(timer_update, State) ->
    util:cancel_ref([State#guild_state.timer_update_ref]),
    Ref = erlang:send_after(?GUILD_TIMER_UPDATE * 1000, self(), timer_update),
    guild_init:timer_update(),
    guild_cbp:timer_update(),
    {noreply, State#guild_state{timer_update_ref = Ref}};

%%停止
handle_info({stop}, State) ->
    {stop, normal, State};

handle_info(_Info, State) ->
    {noreply, State}.