%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 二月 2017 15:02
%%%-------------------------------------------------------------------
-module(designation_handle).
-author("hxming").
-include("designation.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).

handle_call(_msg, _from, State) ->
    {reply, ok, State}.

handle_cast(_msg, State) ->
    {noreply, State}.


handle_info(init, State) ->
    Now = util:unixtime(),
    F = fun([Dkey, DesId, Pkey, Time]) ->
        case data_designation:get(DesId) of
            [] -> ok;
            Base ->
                if Base#base_designation.time_bar == 0 ->
                    Des = #designation_global{key = Dkey, designation_id = DesId, pkey = Pkey, get_time = Time},
                    ets:insert(?ETS_DESIGNATION_GLOBAL, Des);
                    Time + Base#base_designation.time_bar > Now ->
                        Des = #designation_global{key = Dkey, designation_id = DesId, pkey = Pkey, get_time = Time},
                        ets:insert(?ETS_DESIGNATION_GLOBAL, Des);
                    true ->
                        designation_load:del_designation_global(Dkey),
                        ok
                end
        end
        end,
    lists:foreach(F, designation_load:load_designation_global()),
    {noreply, State};

handle_info(timer, State) ->
    misc:cancel_timer(timer),
    Ref = erlang:send_after(?DES_TIMER * 1000, self(), timer),
    put(timer, Ref),
    check_timeout(),
    {noreply, State};

handle_info({add_des, DesId, PkeyList}, State) ->
    case data_designation:get(DesId) of
        [] ->
            ?ERR("info desid ~p udef ~n", [DesId]),
            ok;
        Base ->
            if Base#base_designation.is_global == 0 ->
                add_des_local(DesId, PkeyList);
                true ->
                    add_des_global(DesId, PkeyList)
            end
    end,
    {noreply, State};

handle_info(_msg, State) ->
    {noreply, State}.


check_timeout() ->
    Now = util:unixtime(),
    F = fun(Designation) ->
        case data_designation:get(Designation#designation_global.designation_id) of
            [] ->
                del_des_global(Designation);
            Base ->
                if Base#base_designation.time_bar == 0 -> ok;
                    Base#base_designation.time_bar + Designation#designation_global.get_time > Now -> ok;
                    true ->
                        del_des_global(Designation)
                end
        end
        end,
    lists:foreach(F, ets:tab2list(?ETS_DESIGNATION_GLOBAL)),
    ok.

%%添加个人称号
add_des_local(DesId, KeyList) ->
    Now = util:unixtime(),
    F = fun(Key) ->
        case ets:lookup(?ETS_ONLINE, Key) of
            [] ->
                designation:add_designation_offline(Key, DesId, Now);
            [Online] ->
                Online#ets_online.pid ! {add_des, DesId}
        end
        end,
    lists:foreach(F, KeyList),
    ok.

%%添加全服称号
add_des_global(DesId, KeyList) ->
    case ets:match_object(?ETS_DESIGNATION_GLOBAL, #designation_global{designation_id = DesId, _ = '_'}) of
        [] ->
            do_add_des_global(DesId, KeyList);
        OldList ->
            F = fun(Designation) ->
                del_des_global(Designation),
                case ets:lookup(?ETS_ONLINE, Designation#designation_global.pkey) of
                    [] -> ok;
                    [Online] -> Online#ets_online.pid ! {del_des_global, DesId}
                end
                end,
            lists:foreach(F, OldList),
            util:sleep(500),
            do_add_des_global(DesId, KeyList)
    end.

do_add_des_global(DesId, KeyList) ->
    Now = util:unixtime(),
    F = fun(Key) ->
        GDes = #designation_global{key = misc:unique_key(), pkey = Key, designation_id = DesId, get_time = Now},
        ets:insert(?ETS_DESIGNATION_GLOBAL, GDes),
        designation_load:insert_designation_global(GDes),
        case ets:lookup(?ETS_ONLINE, Key) of
            [] ->
                skip;
            [Online] ->
                Online#ets_online.pid ! {add_des_global, DesId}
        end
        end,
    lists:foreach(F, KeyList).


del_des_global(Designation)->
    ets:delete(?ETS_DESIGNATION_GLOBAL, Designation#designation_global.key),
    designation_load:del_designation_global(Designation#designation_global.key),
    ok.
