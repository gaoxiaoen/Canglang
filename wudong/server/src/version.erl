%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%   版本差异配置文件
%%% @end
%%% Created : 22. 十一月 2016 下午6:09
%%%-------------------------------------------------------------------
-module(version).
-author("fancy").

%% API
-compile(export_all).

%%chn  国内版本
%%korea  韩国版本
%%fanti  繁体版本
%%vietnam 越南
%%bt C游变态版本
-define(VER, chn).


%%获取名字长度
get_name_len() ->
    version_name_len(?VER).

version_name_len(korea) ->
    {2, 6};
version_name_len(vietnam) ->
    {2, 12};
version_name_len(_) ->
    {3, 6}.


%%名字是否全局唯一
get_name_unique() ->
    version_name_unique(?VER).

%%version_name_unique(korea) ->
%%    true;
version_name_unique(_) ->
    false.


%%是否回调 facebook api
get_callback_facebook() ->
    version_callback_facebook(?VER).

version_callback_facebook(fanti) ->
    true;
version_callback_facebook(_) ->
    false.

%%是否开启屏蔽字
get_check_words() ->
    version_check_words(?VER).

version_check_words(fanti) ->
    false;
%%version_check_words(korea) ->
%%    false;
version_check_words(_) ->
    true.

%%开放职业列表
get_career_list() ->
    version_career_list(?VER).


version_career_list(_) ->
    [1, 2].

%%产生点
get_born_point() ->
    version_born_point(?VER).

version_born_point(_) ->
    {14,16}.

%%获取语言版本
get_lan_config() -> ?VER.












