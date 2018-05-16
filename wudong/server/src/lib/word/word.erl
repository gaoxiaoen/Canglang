%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, junhai
%%% @doc
%%%
%%% @end
%%% Created : 13. 三月 2015 19:40
%%%-------------------------------------------------------------------
-module(word).
-author("fzl").
-include("common.hrl").

-define(ETS_FILTER_NAME, game_filter_words_name).   %%关键字全过滤
-define(ETS_FILTER_NAME2, game_filter_words_name2).  %%关键字二级过滤
%% API
-export([
    init/0,
    reload/0,
    word_in_filter_all/1,
    word_in_filter_base/1,
    chat_word_in_filter_all/1
]).

init() ->
    name_init(),
    ok.

name_init() ->
    ets:new(?ETS_FILTER_NAME, ?ETS_OPTIONS),
    ets:new(?ETS_FILTER_NAME2, ?ETS_OPTIONS),
    import_words_name(?ETS_FILTER_NAME, data_filter:base() ++ data_filter:extra()),
    import_words_name(?ETS_FILTER_NAME2, data_filter:base()),
    ok.

reload() ->
    ets:delete_all_objects(?ETS_FILTER_NAME),
    import_words_name(?ETS_FILTER_NAME, data_filter:base() ++ data_filter:extra()),
    ets:delete_all_objects(?ETS_FILTER_NAME2),
    import_words_name(?ETS_FILTER_NAME2, data_filter:base()),
    ok.

%% 加载名称相关过滤
import_words_name(EtsName, Terms) ->
    Convert = fun(X) ->
        X1 = io_lib:format("~ts", [X]),
        unicode:characters_to_binary(X1)
              end,
    Terms1 = lists:map(Convert, Terms),
    lists:foreach(fun(X) -> add_word_to_ets(X, EtsName) end, Terms1),
    ok.

add_word_to_ets(Word, EtsName) ->
    UniString =
        case catch unicode:characters_to_list(Word) of
            {'EXIT', _} -> [];
            Converted -> Converted
        end,
    case UniString of
        [] -> ignor;
        _ ->
            [HeadChar | _Left] = UniString,
            case ets:lookup(EtsName, HeadChar) of
                [] -> ets:insert(EtsName, {HeadChar, [UniString]});
                [{_H, OldList}] ->
                    case lists:member(UniString, OldList) of
                        false -> ets:insert(EtsName, {HeadChar, [UniString | OldList]});
                        true -> ignor
                    end
            end
    end.

%%是否在全过滤列表
word_in_filter_all(Utf8String) ->
    word_is_filter_name(Utf8String, ?ETS_FILTER_NAME).

%%是否在基础过滤列表
word_in_filter_base(Utf8String) ->
    word_is_filter_name(Utf8String, ?ETS_FILTER_NAME2).


%%Utf8输入文字
%%Ets过滤表名字
word_is_filter_name([], _EtsName) ->
    false;
word_is_filter_name(Utf8String, EtsName) when is_list(Utf8String) ->
    Utf8Binary = list_to_binary(Utf8String),
    word_is_filter_name(Utf8Binary, EtsName);
word_is_filter_name(Utf8Binary, EtsName) when is_binary(Utf8Binary) ->
    UniString =
        case catch unicode:characters_to_list(Utf8Binary) of
            {'EXIT', _} -> [];
            Converted -> Converted
        end,
    word_is_filter_helper(UniString, EtsName).

word_is_filter_helper([], _EtsName) ->
    false;
word_is_filter_helper(UniString, EtsName) ->
    [HeadChar | TailString] = UniString,
    UniStrLen = length(UniString),
    WordList = get_key_char_wordlist(HeadChar, EtsName),
    Match = fun(Word) ->
        WordLen = length(Word),
        if WordLen > UniStrLen -> false; %%小于敏感词长度直接false
            WordLen =:= UniStrLen -> UniString =:= Word; %%等于直接比较
            true -> %%大于取词比较
                HeadStr = lists:sublist(UniString, WordLen),
                HeadStr =:= Word
        end
            end,
    case lists:any(Match, WordList) of
        true ->
            true;
        false ->
            word_is_filter_helper(TailString, EtsName)
    end.

get_key_char_wordlist(KeyChar, EtsName) ->
    case ets:lookup(EtsName, KeyChar) of
        [] -> [];
        [{_H, WordList}] -> WordList
    end.


%%-----聊天过滤-----
%%是否在全过滤列表
chat_word_in_filter_all(Utf8String) ->
    chat_word_is_filter_name(Utf8String, ?ETS_FILTER_NAME, []).

%%Utf8输入文字
%%Ets过滤表名字
chat_word_is_filter_name([], _EtsName, FilterList) ->
    FilterList;
chat_word_is_filter_name(Utf8String, EtsName, FilterList) when is_list(Utf8String) ->
    Utf8Binary = list_to_binary(Utf8String),
    chat_word_is_filter_name(Utf8Binary, EtsName, FilterList);
chat_word_is_filter_name(Utf8Binary, EtsName, FilterList) when is_binary(Utf8Binary) ->
    UniString =
        case catch unicode:characters_to_list(Utf8Binary) of
            {'EXIT', _} -> [];
            Converted -> Converted
        end,
    chat_word_is_filter_helper(UniString, EtsName, FilterList).

chat_word_is_filter_helper([], _EtsName, FilterList) ->
    FilterList;
chat_word_is_filter_helper(UniString, EtsName, FilterList) ->
    [HeadChar | TailString] = UniString,
    UniStrLen = length(UniString),
    WordList = get_key_char_wordlist(HeadChar, EtsName),
    case chat_match(WordList, UniString, UniStrLen) of
        [] ->
            chat_word_is_filter_helper(TailString, EtsName, FilterList);
        Word ->
            chat_word_is_filter_helper(TailString, EtsName, [Word | FilterList])
    end.
chat_match([], _UniString, _UniStrLen) -> [];
chat_match([Word | Tail], UniString, UniStrLen) ->
    WordLen = length(Word),
    if
        WordLen > UniStrLen -> chat_match(Tail, UniString, UniStrLen); %%小于敏感词长度直接false
        WordLen =:= UniStrLen ->
            case UniString =:= Word of %%等于直接比较
                true ->
                    Word;
                false ->
                    chat_match(Tail, UniString, UniStrLen)
            end;
        true -> %%大于取词比较
            HeadStr = lists:sublist(UniString, WordLen),
            case HeadStr =:= Word of
                true ->
                    Word;
                false ->
                    chat_match(Tail, UniString, UniStrLen)
            end
    end.