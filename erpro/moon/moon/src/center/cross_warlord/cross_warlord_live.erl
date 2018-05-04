%% --------------------------------------------------------------------
%% 武神坛直播进程
%% @author shawn 
%% @end
%% --------------------------------------------------------------------
-module(cross_warlord_live).
-behaviour(gen_server).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([
        cast/1
        ,get_list/1
        ,get_live/3
    ]
).

-record(state, {
        sky_live_list = []
        ,land_live_list = []
    }
).  

-include("common.hrl").
-include("cross_warlord.hrl").

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

cast({add, _, Quality, _, _}) when Quality < ?cross_warlord_quality_top_32 -> ok;
cast({del, _, Quality, _}) when Quality < ?cross_warlord_quality_top_32-> ok;
cast(Info) -> gen_server:cast(?MODULE, Info).

get_list(Label) ->
    ?CALL(?MODULE, {get_list, Label}).

get_live(Label, Quality, Seq) ->
    ?CALL(?MODULE, {get_live, Label, Quality, Seq}).

%% -------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    State = #state{},
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

handle_call({get_list, ?cross_warlord_label_sky}, _From, State = #state{sky_live_list = SkyLiveList}) ->
    List = [{Quality, Seq} || #cross_warlord_live{id = {Quality,Seq}} <- SkyLiveList],
    {reply, {ok, List}, State};

handle_call({get_list, ?cross_warlord_label_land}, _From, State = #state{land_live_list = LandLiveList}) ->
    List = [{Quality, Seq} || #cross_warlord_live{id = {Quality,Seq}} <- LandLiveList],
    {reply, {ok, List}, State};

handle_call({get_live, ?cross_warlord_label_sky, Quality, Seq}, _From, State = #state{sky_live_list = SkyLiveList}) ->
    case lists:keyfind({Quality, Seq}, #cross_warlord_live.id, SkyLiveList) of
        #cross_warlord_live{id = {Quality, Seq}, combat_pid = CombatPid} ->
            {reply, {ok, CombatPid}, State};
        _ ->
            {reply, false, State}
    end;

handle_call({get_live, ?cross_warlord_label_land, Quality, Seq}, _From, State = #state{land_live_list = LandLiveList}) ->
    case lists:keyfind({Quality, Seq}, #cross_warlord_live.id, LandLiveList) of
        #cross_warlord_live{id = {Quality, Seq}, combat_pid = CombatPid} ->
            {reply, {ok, CombatPid}, State};
        _ ->
            {reply, false, State}
    end;

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(clean, State) ->
    {noreply, State#state{sky_live_list = [], land_live_list = []}};

handle_cast({add, ?cross_warlord_label_sky, Quality, Seq, CombatPid}, State = #state{sky_live_list = SkyLiveList}) ->
    ?DEBUG("Add [~w,~w]",[Quality, Seq]),
    Live = #cross_warlord_live{id = {Quality, Seq}, combat_pid = CombatPid},
    case lists:keyfind({Quality, Seq}, #cross_warlord_live.id, SkyLiveList) of
        false ->
            {noreply, State#state{sky_live_list = [Live | SkyLiveList]}};
        _ ->
            NewSkyLiveList = lists:keyreplace({Quality, Seq}, #cross_warlord_live.id, SkyLiveList, Live),
            {noreply, State#state{sky_live_list = NewSkyLiveList}}
    end;
handle_cast({add, ?cross_warlord_label_land, Quality, Seq, CombatPid}, State = #state{land_live_list = LandLiveList}) ->
    ?DEBUG("Add [~w,~w]",[Quality, Seq]),
    Live = #cross_warlord_live{id = {Quality, Seq}, combat_pid = CombatPid},
    case lists:keyfind({Quality, Seq}, #cross_warlord_live.id, LandLiveList) of
        false ->
            {noreply, State#state{land_live_list = [Live | LandLiveList]}};
        _ ->
            NewLandLiveList = lists:keyreplace({Quality, Seq}, #cross_warlord_live.id, LandLiveList, Live),
            {noreply, State#state{land_live_list = NewLandLiveList}}
    end;

handle_cast({del, ?cross_warlord_label_sky, Quality, Seq}, State = #state{sky_live_list = SkyLiveList}) ->
    ?DEBUG("Del [~w,~w]",[Quality, Seq]),
    case lists:keyfind({Quality, Seq}, #cross_warlord_live.id, SkyLiveList) of
        false ->
            {noreply, State};
        _ ->
            NewSkyLiveList = lists:keydelete({Quality, Seq}, #cross_warlord_live.id, SkyLiveList),
            {noreply, State#state{sky_live_list = NewSkyLiveList}}
    end;
handle_cast({del, ?cross_warlord_label_land, Quality, Seq}, State = #state{land_live_list = LandLiveList}) ->
    ?DEBUG("Del [~w,~w]",[Quality, Seq]),
    case lists:keyfind({Quality, Seq}, #cross_warlord_live.id, LandLiveList) of
        false ->
            {noreply, State};
        _ ->
            NewLandLiveList = lists:keydelete({Quality, Seq}, #cross_warlord_live.id, LandLiveList),
            {noreply, State#state{land_live_list = NewLandLiveList}}
    end;
handle_cast(_Msg, State) ->
    ?DEBUG("_Msg:~w",[_Msg]),
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
