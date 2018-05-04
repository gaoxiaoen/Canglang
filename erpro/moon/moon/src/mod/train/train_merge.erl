%%---------------------------------------------------- 
%% 飞仙历练合服
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(train_merge).
-export([merge/1]).

-include("common.hrl").
-include("train.hrl").

merge([H | T]) ->
    dets:open_file(train_merge, [{file, "../var/train.dets"}, {keypos, #train_field.id}, {type, set}]),

    dets:open_file(train_single, [{file, "../var/" ++ H ++ "/train.dets"}, {keypos, #train_field.id}, {type, set}]),
    case dets:first(train_single) of
        '$end_of_table' -> ok;
        _ ->
            dets:traverse(train_single,
                fun(Field) ->
                        dets:insert(train_merge, train_parse:ver(Field)),
                        continue
                end
            ),
            ok
    end,
    dets:close(train_single),

    merge_others(T),
    dets:close(train_merge),
    <<"success">>.

merge_others([]) -> ok;
merge_others([H | T]) ->
    dets:open_file(train_single, [{file, "../var/" ++ H ++ "/train.dets"}, {keypos, #train_field.id}, {type, set}]),
    case dets:first(train_single) of
        '$end_of_table' -> ok;
        _ ->
            dets:traverse(train_single,
                fun(Field) ->
                        handle_train_field(train_parse:ver(Field)),
                        continue
                end
            ),
            ok
    end,
    dets:close(train_single),
    merge_others(T).

handle_train_field(OldField = #train_field{id = Fid, roles = Roles}) ->
    case dets:lookup(train_merge, Fid) of
        [Field = #train_field{roles = OldRoles}] ->
            NewRoles = lists:foldl(fun(Elem, Acc) -> [Elem | Acc] end, OldRoles, Roles),
            dets:insert(train_merge, Field#train_field{roles = NewRoles});
        _ ->
            dets:insert(train_merge, OldField)
    end.
