%%----------------------------------------------------
%% 全局计数器
%% 
%% @author qingxuan
%% @end
%%----------------------------------------------------
-module(counter).
-export([
    new/2
    ,next/1
    ,close/1
]).

ensure_started() ->
    case ets:info(global_counter, size) of
        undefined ->
            Ref = erlang:make_ref(),
            Self = self(),
            spawn(fun() ->
                catch begin
                    ets:new(global_counter, [public, named_table, set, {write_concurrency, true}]),
                    register(global_counter, self())
                end,
                Self ! Ref,
                do_loop()
            end),
            receive 
                Ref -> ok
                after 5000 -> ok
            end;
        _ ->
            ignore
    end.

do_loop() ->
    receive
        _ -> do_loop()
    end.

%% ------------------------------------
new(Name, InitValue) ->
    ensure_started(),
    case ets:lookup(global_counter, Name) of
        [] ->
            ets:insert(global_counter, {Name, InitValue}),
            ok;
        _ ->
            {error, already_exists}
    end.

next(Name) ->
    ets:update_counter(global_counter, Name, 1).

close(Name) ->
    ets:delete(global_counter, Name).
