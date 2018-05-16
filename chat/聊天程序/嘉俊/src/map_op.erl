-module(map_op).

%% API
-export([first_not_equal_key/2]).

%% 返回第一个与目标值不相同的key
first_not_equal_key(Map, Key) ->
    not_equal_key_search(maps:keys(Map), Key).

not_equal_key_search([H|T], Key) ->
    if
        H /= Key ->
            {ok, H};
        true -> not_equal_key_search(T, key)
    end;

not_equal_key_search([], _Key) ->
    {ok, "no found"}.
