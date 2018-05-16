%%----------------------------------------------------
%% Erlang模块热更新到所有线路（包括server的回调函数，如果对state有影响时慎用）
%%
%% 检查：u:c()                %% 列出前5分钟内编译过的文件
%%       u:c(N)               %% 列出前N分钟内编译过的文件
%%
%% 更新：u:u()                %% 更新前5分钟内编译过的文件               
%%       u:u(N)               %% 更新前N分钟内编译过的文件   
%%       u:u([mod_xx, ...])   %% 指定模块（不带后缀名）
%%       u:u(m)               %% 编译并加载文件
%%
%% Tips: u - update, c - check
%%----------------------------------------------------

-module(u).
-compile(export_all).
-include_lib("kernel/include/file.hrl").
-include("common.hrl").

to_path() ->
    case get(ebin_path) of
        undefined ->
            c:cd("../ebin"),
            {ok, EbinPath} = file:get_cwd(),
            put(ebin_path, EbinPath);
        Path ->
            c:cd(Path)
    end.


c() ->
    c(5).
c(S) when is_integer(S) ->
    to_path(),
    case file:list_dir(".") of
        {ok, FileList} ->
            Files = get_new_file(FileList, S * 60),
            info("---------check modules---------~n~w~n=========check modules=========", [Files]);
        Any -> info("Error Dir: ~w", [Any])
    end;
c(_) -> info("ERROR======> Badarg", []).

admin() ->
    spawn(fun() -> u(m) end),
    ok.

u() ->
    u(10).
u(m) ->
    StartTime = util:unixtime(),
    info("----------makes----------", []),
    to_path(),
    c:cd("../"),
    make:all(),
    EndTime = util:unixtime(),
    Time = EndTime - StartTime,
    info("Make Time : ~w s", [Time]),
    u(Time / 60);

u(S) when is_number(S) ->
    to_path(),
    case file:list_dir(".") of
        {ok, FileList} ->
            Files = get_new_file(FileList, util:ceil(S * 60) + 3),

            info("---------modules---------~n~w~n----------nodes----------", [Files]),
            load(Files),
            Files;
        Any ->
            info("Error Dir: ~p", [Any])
    end;
u(Files) when is_list(Files) ->
    to_path(),

    info("---------modules---------~n~w~n----------nodes----------", [Files]),
    load(Files);

u(_) -> info("ERROR======> Badarg", []).

%% m(['src/data/*','src/lib/lib_goods.erl'])
m(Files) when is_list(Files) ->
    StartTime = util:unixtime(),
    info("----------makes----------~n~w~n", [Files]),
    to_path(),
    c:cd("../"),
    Res = make:files(Files, [debug_info, {i, "include"}, {outdir, "ebin"}]),
    to_path(),
    EndTime = util:unixtime(),
    Time = EndTime - StartTime,
    info("Make Time : ~p s", [Time]),
    Res.

info(V) ->
    info(V, []).
info(V, P) ->
    io:format(V ++ "~n", P).


load([]) ->
    info("---------hotfix ok !----------", []),
    ok;
load([FileName | T]) ->
    c:l(FileName),
    load(T).
%    case code:soft_purge(FileName) of
%        true ->
%            case code:load_file(FileName) of
%                {module, _} ->
%                    info("loaded: ~w", [FileName]),
%                    ok;
%                    %% info("loaded: ~w", [FileName]);
%                {error, What} -> info("ERROR======> loading: ~w (~w)", [FileName, What])
%            end;
%        false -> info("ERROR======> Processes lingering : ~w [zone ~w] ", [FileName, srv_kernel:zone_id()])
%    end,
%    load(T).

h() ->
    h(5).
h(M) when is_integer(M) ->
%%     AppDir =
%%         case code:which(?MODULE) of
%%             cover_compiled -> "../";
%%             F ->
%%                 io:format("filename:dirname(F) ~p~n", [filename:dirname(F)]),
%%                 filename:dirname(filename:dirname(F))
%%         end,
%%     io:format("AppDir ~p~n", [AppDir]),
    Now = erlang:localtime(),
    DS = M * 60,
    Dir = "../",
    SrcDir = Dir ++ "src/",
    IncludeDir = Dir ++ "include/",
    EbinDir = Dir ++ "ebin/",
    ModFiles = get_erl_file(SrcDir, Now, DS),
%%     io:format("Recompile Files ~p~n", [ModFiles]),
    make:files(ModFiles, [debug_info, {i, IncludeDir}, {outdir, EbinDir}]),
    u(M);
h(Badarg) ->
    io:format("ERROR Badarg `~p`, Request an Integer~n", [Badarg]).

get_erl_file(SrcDir, Now, DS) ->
    case file:list_dir(SrcDir) of
        {ok, Filenames} ->
            get_erl_file(Filenames, SrcDir, Now, DS, []);
        _Error ->
            []
    end.
get_erl_file([], _SrcDir, _Now, _DS, Ret) ->
    Ret;
get_erl_file([F | R], SrcDir, Now, DS, Ret) ->
    FilePth = SrcDir ++ F,
    case filelib:is_dir(FilePth) of
        true ->
            SubSrcDir = FilePth ++ "/",
            ErlFiles = get_erl_file(SubSrcDir, Now, DS),
            get_erl_file(R, SrcDir, Now, DS, ErlFiles ++ Ret);
        false ->
            case string:tokens(F, ".") of
                [_Left, "erl"] ->
                    case file:read_file_info(FilePth) of
                        {ok, FileInfo} ->
                            case calendar:time_difference(FileInfo#file_info.mtime, Now) of
                                {Days, Times} ->
                                    Seconds = calendar:time_to_seconds(Times),
                                    case Days =:= 0 andalso Seconds < DS of
                                        true ->
                                            get_erl_file(R, SrcDir, Now, DS, [FilePth | Ret]);
                                        false ->
                                            get_erl_file(R, SrcDir, Now, DS, Ret)
                                    end;
                                _ ->
                                    get_erl_file(R, SrcDir, Now, DS, Ret)
                            end;
                        _ ->
                            get_erl_file(R, SrcDir, Now, DS, Ret)
                    end;
                _ ->
                    get_erl_file(R, SrcDir, Now, DS, Ret)
            end
    end.

get_new_file(Files, S) ->
    Now = erlang:localtime(),
    get_new_file(Files, Now, S, []).
get_new_file([], _Now, _S, Result) -> Result;
get_new_file([H | T], Now, S, Result) ->
    NewResult =
        case string:tokens(H, ".") of
            [Left, "beam"] ->
                case file:read_file_info(H) of
                    {ok, FileInfo} ->
                        case calendar:time_difference(FileInfo#file_info.mtime, Now) of
                            {Days, Times} ->
                                Seconds = calendar:time_to_seconds(Times),
                                case Days =:= 0 andalso Seconds < S of
                                    true ->
                                        FileName = list_to_atom(Left),
                                        [FileName | Result];
                                    false -> Result
                                end;
                            _ -> Result
                        end;
                    _ -> Result
                end;
            _ -> Result
        end,
    get_new_file(T, Now, S, NewResult).

%% 根据版本内容热更
u2() ->
    Files = get_new_file_by_version(),
    info("---------modules---------~n~w~n----------nodes----------", [Files]),
    do_load(Files).

do_load([H | T]) ->
    reloader:reload(H),
    do_load(T);
do_load([]) -> ok.


%% 根据版本号拿取文件
get_new_file_by_version() ->
    to_path(),
    case file:list_dir(".") of
        {ok, FileList} ->
            get_new_file_by_version(FileList, []);
        Any ->
            info("Error Dir: ~w", [Any]),
            []
    end.

get_new_file_by_version([], Result) -> Result;
get_new_file_by_version([H | T], Result) ->
    NewResult =
        case string:tokens(H, ".") of
            [Left, "beam"] ->
                FileName = list_to_atom(Left),
                FileVersion = file_version(FileName),
                CodeVersion = code_version(FileName),
                case FileVersion of
                    CodeVersion -> Result;
                    _ -> [FileName | Result]
                end;
            _ ->
                Result
        end,
    get_new_file_by_version(T, NewResult).

%% 文件里边的版本
file_version(Beam) ->
    case beam_lib:version(Beam) of
        {ok, {Beam, [Version]}} -> Version;
        _ -> false
    end.

%% code 的版本
code_version(Beam) ->
    try
        case Beam:module_info(attributes) of
            L when is_list(L) ->
                case lists:keyfind(vsn, 1, L) of
                    {vsn, [Version]} -> Version;
                    false -> false
                end;
            _ -> no_found
        end
    catch
        _:_ ->
            info("find ~s version fail~n", [Beam]),
            error
    end.

%% 编译文件，IsForce不检查时间，直接编译所有.erl文件
m2() -> m(false).
m2(IsForce) when is_boolean(IsForce) ->
    make_tool:make_all(IsForce).



cross() ->
    cross_node:u().