%%%-------------------------------------------------------------------
%%% File        :common_config_dyn.erl
%%% @doc
%%%     common_config 的动态加载实现版本，之后可以取缔common_config
%%%     目前只支持key-value或者record（首字段为key）的配置文件
%%% @end
%%%-------------------------------------------------------------------
-module(common_config_dyn).


%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
-include("common_server.hrl").

%% API
-export([
         find_common/1,
         load_shop/1
        ]).
-export([
         init/0,
         init/1,
         find/2,
         list/1,
         list_by_module/1
        ]).
-export([
         reload/1,
         reload_all/0,
         gen_all_beam/0
        ]).
-export([
         load_gen_src/2,
         load_gen_src/3
        ]).

-define(DEFINE_CONFIG_MODULE(Name,FilePath,FileType),{ Name, codegen_name(Name),
                                                       get_config_dir() ++ "/" ++ FilePath, FileType }).

%% 支持4种文件类型：record_consult,key_value_consult,key_value_list,record_list,
%% 建议只使用 key_value_consult 结构

-define(CONFIG_FILE_LIST,[%%配置模块名称,路径,类型
                          ?DEFINE_CONFIG_MODULE(title, "title.config", key_value_consult),
                          ?DEFINE_CONFIG_MODULE(system, "system.config", key_value_consult),
                          ?DEFINE_CONFIG_MODULE(etc, "etc.config", key_value_consult),
                          ?DEFINE_CONFIG_MODULE(merge, "merge.config", key_value_consult),
                          ?DEFINE_CONFIG_MODULE(sys_conf,"world/sys_conf.config",key_value_consult),
                          ?DEFINE_CONFIG_MODULE(role_bag,"world/role_bag.config",key_value_consult),
                          ?DEFINE_CONFIG_MODULE(other_activity,"activity/other_activity.config",key_value_consult),
                          ?DEFINE_CONFIG_MODULE(mission_etc,"mission/mission_etc.config",key_value_consult)
                         ]).


-define(FOREACH(Fun,List),lists:foreach(fun(E)-> Fun(E)end, List)).

%% ====================================================================
%% API Functions
%% ====================================================================
init()->
    ?FOREACH(catch_do_load_config,get_config_file_list()),
    ok.

get_config_file_list() ->
    [{common,codegen_name(common),main_exec:get_setting_file(),key_value_consult} | ?CONFIG_FILE_LIST].

%%@result   ok | {error,not_found}
init(ConfigName) when is_atom(ConfigName)->
    reload(ConfigName).

reload_all()->
    ?FOREACH(catch_do_load_config,get_config_file_list()),
    ok.

%%@spec load_shop(ConfigName::atom())
%%@result ok|{error,not_found}
load_shop(ConfigName)->
    ConfigModuleName = codegen_name(shop_shops),
    FilePath = lists:concat([get_config_dir(),"world/shop/",ConfigName,".config"]),
    do_load_config({shop_shops,ConfigModuleName,FilePath,key_value_consult, set}).

%%@spec reload(ConfigName::atom())
%%@result   ok | {error,not_found}
reload(ConfigName) when is_atom(ConfigName)->
    case lists:keyfind(ConfigName, 1, get_config_file_list()) of
        false->
            {error,not_found};
        ConfRec->
            reload2(ConfRec),
            ok
    end.
reload2({AtomName,ConfigModuleName,FilePath,FileType}) ->
    reload2({AtomName,ConfigModuleName,FilePath,FileType,set});
     
reload2({AtomName,ConfigModuleName,FilePath,_,_}=ConfRec) ->
    try
        {ok, Code} = do_load_config(ConfRec),
        file:write_file(lists:concat([get_server_dir(),"ebin/config/", ConfigModuleName, ".beam"]), Code, [write, binary])
    catch
        Err:Reason->
            ?ERROR_MSG("Reason=~w,AtomName=~w,ConfigModuleName=~p,FilePath=~p",[Reason,AtomName,ConfigModuleName,FilePath]),
            throw({Err,Reason})
    end.


%% 常用的几个配置读取接口
%%@result   [] | [Result]
find_common(Key)->
    find_by_module(common_config_codegen,Key).
%%@spec list/1
%%@doc 为了尽量少改动，接口符合ets:lookup方法的返回值规范，
%%@result   [] | [Result]
list(ConfigName)->
    case do_list(ConfigName) of
        undefined-> [];
        not_implement -> [];
        Val -> Val
    end.

%%@spec find/2
%%@doc 为了尽量少改动，接口符合ets:lookup方法的返回值规范，
%%@result   [] | [Result]
find(ConfigName,Key)->
    case do_find(ConfigName,Key) of
        undefined-> [];
        not_implement -> [];
        Val -> [Val]
    end.

%%@spec list_by_module/1
%%@result   [] | [Result]
list_by_module(ModuleName) when is_atom(ModuleName)->
    case ModuleName:list() of
        undefined-> [];
        not_implement -> [];
        Val -> Val
    end.

%%@spec find_by_module/2
%%@doc  为了尽量少改动，接口符合ets:lookup方法的返回值规范，
%%      如果你的configName是属于频繁调用的，可以在此指定 codegen的模块名
%%@result   [] | [Result]
find_by_module(ModuleName,Key) when is_atom(ModuleName)->
    case ModuleName:find_by_key(Key) of
        undefined-> [];
        not_implement -> [];
        Val -> [Val]
    end.


%%@spec do_list/1
do_list(ConfigName) ->
    ModuleName = common_tool:list_to_atom( codegen_name(ConfigName) ),
    ModuleName:list().

%%@spec do_find/2
do_find(ConfigName,Key) ->
    ModuleName = common_tool:list_to_atom( codegen_name(ConfigName) ),
    ModuleName:find_by_key(Key).

%%@spec load_gen_src/2
%%@doc ConfigName配置名，类型为atom(),KeyValues类型为[{key,Value}|...]
load_gen_src(ConfigName,KeyValues) ->
    load_gen_src(ConfigName,KeyValues,[]).

%%@spec load_gen_src/2
%%@doc ConfigName配置名，类型为atom(),KeyValues类型为[{key,Value}|...]
load_gen_src(ConfigName,KeyValues,ValList) ->
    do_load_gen_src(codegen_name(ConfigName),set,KeyValues,ValList).

%% ====================================================================
%% Local Functions
%% ====================================================================

codegen_name(Name)->
    lists:concat([Name,"_config_codegen"]).

get_server_dir() ->
    main_exec:get_server_dir().

get_config_dir() ->
    main_exec:get_config_dir().


catch_do_load_config({AtomName,ConfigModuleName,FilePath,FileType}) ->
        catch_do_load_config({AtomName,ConfigModuleName,FilePath,FileType,set});
     
catch_do_load_config({AtomName,ConfigModuleName,FilePath,_,_}=ConfRec) ->
             try
                 do_load_config(ConfRec)
             catch
                 Err:Reason->
                     ?ERROR_MSG("Reason=~w,AtomName=~w,ConfigModuleName=~p,FilePath=~p",[Reason,AtomName,ConfigModuleName,FilePath]),
                     throw({Err,Reason})
             end.

gen_all_beam() ->
    AllFileList = lists:keydelete(common, 1, get_config_file_list()),
    lists:foreach(
      fun({AtomName, ConfigModuleName, FilePath, Type}) ->
              io:format("~p~n", [AtomName]),
              gen_all_beam2(AtomName, ConfigModuleName, FilePath, Type, set);
         ({AtomName, ConfigModuleName, FilePath, Type, KeyType}) ->
              io:format("~p~n", [AtomName]),
              gen_all_beam2(AtomName, ConfigModuleName, FilePath, Type, KeyType)
      end, AllFileList),
    ok.

gen_all_beam2(AtomName, ConfigModuleName, FilePath, Type, KeyType) ->
    case AtomName =:= common of
        true ->
            ignore;
        false ->
            try
                gen_src_file(ConfigModuleName, FilePath, Type, KeyType)
            catch
               Err:Reason->
                   erlang:throw({Err,FilePath,Reason})
            end
    end.

%% markycai 2013.1.18 for topic_activity
gen_src_file("topic_activity_config_codegen",FilePath,_Type,KeyType)->
    {ok,RecList1} = file:consult(FilePath),
    {ok,RecList2} = file:consult(get_config_dir() ++ "activity/topic_activity_etc.config"),
    RecList = RecList1++ RecList2,
    KeyValues = RecList,
    ValList = RecList,
    Src = common_config_code:gen_src("topic_activity_config_codegen",KeyType,KeyValues,ValList),
    file:write_file(lists:concat(["../config/src/", "topic_activity_config_codegen", ".erl"]), Src, [write, binary, {encoding, utf8}]),
    ok;
gen_src_file(ConfigModuleName, FilePath, Type, KeyType) ->
    if 
        Type =:= record_consult ->
            {ok,RecList} = file:consult(FilePath),
            KeyValues = [ begin
                              Key = element(2,Rec), {Key,Rec}
                          end || Rec<- RecList ],
            ValList = RecList;
        Type =:= record_list ->
            {ok,[RecList]} = file:consult(FilePath),
            KeyValues = [ begin
                              Key = element(2,Rec), {Key,Rec}
                          end || Rec<- RecList ],
            ValList = RecList;
        Type =:= key_value_consult ->
            {ok,RecList} = file:consult(FilePath),
            KeyValues = RecList,
            ValList = RecList;
        true ->
            {ok,[RecList]} = file:consult(FilePath),
            KeyValues = RecList,
            ValList = RecList
    end,
    Src = common_config_code:gen_src(ConfigModuleName,KeyType,KeyValues,ValList),
    file:write_file(lists:concat(["../config/src/", ConfigModuleName, ".erl"]), Src, [write, binary, {encoding, utf8}]),
    ok.

%% markycai 2013.1.18 for topic_activity
do_load_config({topic_activity,ConfigModuleName,FilePath,key_value_consult,Type})->
    {ok,RecList1} = file:consult(FilePath),
    {ok,RecList2} = file:consult(get_config_dir() ++ "activity/topic_activity_etc.config"),
    RecList = RecList1++ RecList2,
    KeyValues = RecList,
    ValList = RecList,
    do_load_gen_src(ConfigModuleName,Type,KeyValues,ValList);
do_load_config({_AtomName,ConfigModuleName,FilePath,record_consult, Type}) ->
    {ok,RecList} = file:consult(FilePath),
    KeyValues = [ begin
                      Key = element(2,Rec), {Key,Rec}
                  end || Rec<- RecList ],
    ValList = RecList,
    do_load_gen_src(ConfigModuleName,Type,KeyValues,ValList);

do_load_config({_AtomName,ConfigModuleName,FilePath,record_list, Type}) ->
    {ok,[RecList]} = file:consult(FilePath),
    KeyValues = [ begin
                      Key = element(2,Rec), {Key,Rec}
                  end || Rec<- RecList ],
    ValList = RecList,
    do_load_gen_src(ConfigModuleName,Type,KeyValues,ValList);

do_load_config({_AtomName,ConfigModuleName,FilePath,key_value_consult, Type})->
    {ok,RecList} = file:consult(FilePath),
    KeyValues = RecList,
    ValList = RecList,
    do_load_gen_src(ConfigModuleName,Type,KeyValues,ValList);

do_load_config({_AtomName,ConfigModuleName,FilePath,key_value_list, Type})->
    {ok,[RecList]} = file:consult(FilePath),
    KeyValues = RecList,
    ValList = RecList,
    do_load_gen_src(ConfigModuleName,Type,KeyValues,ValList).

%%@doc 生成源代码，执行编译并load
do_load_gen_src(ConfigModuleName,Type,KeyValues,ValList)->
    try
        Src = common_config_code:gen_src(ConfigModuleName,Type,KeyValues,ValList),
        {Mod, Code} = dynamic_compile:from_string( Src ),
        code:load_binary(Mod, ConfigModuleName ++ ".erl", Code),
        {ok, Code}
    catch
        Type:Reason -> 
            Trace = erlang:get_stacktrace(), string:substr(erlang:get_stacktrace(), 1,200),
            ?CRITICAL_MSG("Error compiling ~p: Type=~w,Reason=~w,Trace=~w,~n", [ConfigModuleName, Type, Reason,Trace ])
    end.
