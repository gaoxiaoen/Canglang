%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 机器人 注意:当前为独立模块,不依赖游戏系统额外模块函数
%%% 机器人行为 走路;升级;打怪;完成任务;聊天
%%% @end
%%% Created : 22. 十二月 2015 下午12:05
%%%-------------------------------------------------------------------
-module(robot).
-author("fancy").

-behaviour(gen_server).

%% API

%% gen_server callbacks
-compile(export_all).

-define(TS,1000).
-define(TS_MOVE,200).
-define(TS_TALK,2000).
-define(TS_BATTLE,2000).

-define(SERVER, ?MODULE).
-define(PLATFORM,888).
-define(TICKET,"3e1f8f56ad582a7e76f8ef8adef0a54c").

-record(state, {
    socket = none,
    self = none,
    accname = none,
    pkey = none,
    scene = 0,
    point = [],
    back = []
}).

%%%===================================================================
%%% API
%%%===================================================================

start([IP,Port,N|_]) ->
    IP2 = atom_to_list(IP),
    Port2 = list_to_integer(atom_to_list(Port)),
    Num = list_to_integer(atom_to_list(N)),
    if
        Num > 0 ->
            start_n(Num,IP2,Port2);
        true ->
            start_loop(IP2,Port2)
    end.


start_n(0,_,_) ->
    ok;
start_n(N,IP,Port) ->
    timer:sleep(1000),
    start(IP,Port),
    start_n(N-1,IP,Port).

start_loop(IP,Port) ->
    timer:sleep(1000),
    start(IP,Port),
    start_loop(IP,Port).

start(IP,Port) ->
    gen_server:start(?MODULE, [IP,Port], []).



%%%===================================================================
%%% gen_server callbacks
%%%===================================================================


init([IP,Port]) ->
    case gen_tcp:connect(IP,Port,[binary, {packet, 0}, {reuseaddr, true}, {nodelay, false}, {delay_send, true}, {keepalive, true}, {exit_on_close, true}]) of
        {ok,Socket} ->
            Self = self(),
            gen_tcp:controlling_process(Socket,Self),
            erlang:send_after(1000,Self,login),
            Scene = 10001,
            {ok,#state{socket = Socket,self = Self,point = point(Scene),scene = Scene}};
        _err ->
            io:format("connect :~p:~p error! ~n",[IP,Port]),
            {stop,normal}
    end.


handle_call(_Request, _From, State) ->
    {reply, ok, State}.


handle_cast(_Request, State) ->
    {noreply, State}.


handle_info(login,State) ->
    Accname = unique_key(),
    Bin = write10000(Accname),
    gen_tcp:send(State#state.socket,Bin),
    {noreply,State};

handle_info(create,State) ->
    Bin = write10003(),
    gen_tcp:send(State#state.socket,Bin),
    {noreply,State};

handle_info({create_ok,Key},State) ->
    Bin = write10004(Key),
    gen_tcp:send(State#state.socket,Bin),
    {noreply,State#state{pkey = Key}};

handle_info(load_scene,State) ->
    Bin = write12002(),
    gen_tcp:send(State#state.socket,Bin),
    {noreply,State};

handle_info({tcp,_socket,Bin},State) ->
    case read(Bin) of
        {Code,Bin2} ->
            Method = list_to_atom(lists:concat([read,Code])),
            Fun = fun ?MODULE:Method/1,
            catch Fun(Bin2);
        _Err ->
            io:format("read err:~p~n",[_Err]),
            ok
    end,
    {noreply,State};

handle_info({attack,Key,SkillStr,XStr,YStr},State) ->
    attack(State,Key,SkillStr,XStr,YStr),
    {noreply,State};

%%机器人心跳
handle_info(tick,State) ->
    R = rand(1,1000),
    {Time,State2} =
    if
        R < 700 ->
            {?TS_MOVE,move(State)};
        R > 700 andalso R < 900 ->
            {?TS_BATTLE,findbattle(State)};
        R > 900 andalso R < 980 ->
            {?TS,finishtask(State)};
        R > 980 andalso R < 985  ->
            {?TS_TALK,talk(State)};
        R > 985 andalso R < 1000 ->
            {?TS,uplv(State)};
%%         R == 1000 ->
%%             {?TS,State#state.self ! stop};
        true ->
            {?TS,State}
    end,
    erlang:send_after(Time,State#state.self,tick),
    {noreply,State2};

handle_info(stop,State) ->
    {stop,normal,State};

handle_info(Info, State) ->
    io:format("rec:~p~n",[Info]),
    {noreply, State}.


terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%% 登陆
write10000(Accname) ->
    Time = unixtime(),
    Hex = md5(lists:concat([Accname,?PLATFORM,Time,?TICKET])),
    AccnameBin = write_string(Accname),
    HexBin = write_string(Hex),
    write(10000,<<Time:32,AccnameBin/binary,?PLATFORM:16,HexBin/binary>>) .

read10000(Bin) ->
    <<Code:8,_Ts:32>> = Bin ,
    if
        Code == 4 ->
            self() ! create;
        true ->
            io:format("login err:~p~n",[Code])
    end,
    ok.

%% 创建角色
write10003() ->
    Career = list_rand([1,2,4]),
    Nickname = lists:concat(["rob",longunixtime()]),
    QD = "robot",
    PhoneId = unique_key(),
    OS = "robot",
    write(10003,<<Career:8,(write_string(Nickname))/binary,(write_string(QD))/binary,?PLATFORM:16,(write_string(PhoneId))/binary,(write_string(OS))/binary>>).

read10003(Bin) ->
    <<Code:8,Bin2/binary>> = Bin,
    {Key,_} = read_string(Bin2),
    if
        Code == 1 ->
            self() ! {create_ok,Key};
        true ->
            io:format("create err:~p~n",[Code])
    end,
    ok.

%% 进入场景
write10004(Key) ->
    Time = unixtime(),
    Hex = md5(lists:concat([Key,Time,?TICKET])),
    write(10004,<<(write_string(Key))/binary,Time:32,(write_string(Hex))/binary>>).

read10004(Bin) ->
    <<Code:8,Bin2/binary>> = Bin,
    if
        Code == 1 ->
            self() ! load_scene;
        true ->
            io:format("enter err:~p~n",[Code])
    end,
    ok.

%% 加载场景
write12002() ->
    write(12002,<<>>).

read12002(_Bin) ->
    self() ! tick,
    ok.

%% 走路
write12001(X,Y) ->
    write(12001,<<X:8,Y:8,88:8>>).

%% 发起战斗
write20001(SkillId,X,Y,Key) ->
    TargetList = list_to_binary([<<2:8,(write_string(Key))/binary>>]),
    write(20001,<<SkillId:32,0:8,X:8,Y:8,1:16,TargetList/binary>>).

write13099(Type) ->
    write13099(Type,"").
write13099(Type,Value) ->
    write(13099,<<Type:8,(write_string(Value))/binary>>).
read13099(Bin) ->
    <<Type:8,Bin2/binary>> = Bin,
    {Ret1,Bin3} = read_string(Bin2),
    {Ret2,Bin4} = read_string(Bin3),
    {Ret3,Bin5} = read_string(Bin4),
    {Ret4,_} = read_string(Bin5),
    %%io:format("type:~p |ret1:~p |ret2:~p |ret3:~p |ret4:~p ~n",[Type,Ret1,Ret2,Ret3,Ret4]),
    if
        Type == 3 ->
            self() ! {attack,Ret1,Ret2,Ret3,Ret4};
        true ->
            skip
    end,
    ok.


%% ---------------动作--------
move(State) ->
    case State#state.point of
        [] ->
            {NextScene,NewPoint,NewBack} =
                case rand(1,100) > 30 of
                    true ->
                        case point(State#state.scene + 1) of
                            [] ->
                                {10001,point(10001),[]};
                            _ ->
                                {State#state.scene + 1,point(State#state.scene + 1),[]}
                        end;
                    false ->
                        Back = State#state.back,
                        {State#state.scene,Back,[]}
                end,
            State2 = State#state{scene = NextScene,point = NewPoint,back = NewBack},
            if
                NextScene /= State#state.scene ->
                    changescene(State2);
                true ->
                    State2
            end;
        [{X,Y}|Left] ->
            Bin = write12001(X,Y),
            gen_tcp:send(State#state.socket,Bin),
            Back = State#state.back,
            State#state{point = Left,back = [{X,Y}|Back]}
    end.

talk(State) ->
    List = [
        "相思相见知何日？此时此夜难为情.",
        "相思树底说相思，思郎恨郎郎不知.",
        "落红不是无情物，化作春泥更护花.",
        "关关雎鸠，在河之洲.窈宨淑女，君子好逑.",
        "人生自是有情痴，此恨不关风与月.",
        "梧桐树，三更雨，不道离情正苦.一叶叶，一声声，空阶滴到明.",
        "落花人独立，微雨燕双飞.",
        "执手相看泪眼，竟无语凝噎.",
        "天涯地角有穷时，只有相思无尽处.",
        "多情只有春庭月，犹为离人照落花."],
    Msg = list_rand(List),
    Bin = write13099(1,unicode:characters_to_binary(Msg)),
    gen_tcp:send(State#state.socket,Bin),
    State.

uplv(State) ->
    Bin = write13099(2),
    gen_tcp:send(State#state.socket,Bin),
    State.

findbattle(State) ->
    Bin = write13099(3),
    gen_tcp:send(State#state.socket,Bin),
    State.

finishtask(State) ->
    Bin = write13099(4),
    gen_tcp:send(State#state.socket,Bin),
    State.

changescene(State) ->
    Bin = write13099(5,integer_to_list(State#state.scene)),
    Bin2 = write12002(),
    gen_tcp:send(State#state.socket,<<Bin/binary,Bin2/binary>>),
    State.


attack(State,Key,SkillStr,XStr,YStr) ->
    Bin = write20001(list_to_integer(SkillStr),list_to_integer(XStr),list_to_integer(YStr),Key),
    gen_tcp:send(State#state.socket,Bin),
    State.








point(10001) ->
    [
        {17,28},{20,31},{20,34},{21,36},{22,36},{22,38},{23,39},{23,40},{24,40},{25,41},{26,42},{27,42},{29,42},{30,42},{31,42},{32,43},{33,42},{34,43},{35,43},{37,43},
        {40,43},{41,43},{42,43},{44,42},{45,42},{45,41},{47,42},{48,43},{50,43},{51,45},{52,46},{53,48},{54,53},{54,55},{53,58},{52,59},{50,61},{50,62},{49,62},{49,63},
        {47,66},{46,66},{45,67},{44,69},{42,69},{40,69},{39,70},{38,70},{36,70},{35,70},{34,71},{33,71},{32,71},{31,71},{30,71},{28,72},{27,74},{25,74},{23,76},{21,78},
        {18,81},{18,82},{17,84},{16,84},{16,86},{15,86},{14,87},{14,88},{13,89},{12,90},{12,91},{11,92},{9,96},{8,98},{8,102},{9,105},{10,106},{11,107},{12,108},{14,110},
        {14,114},{15,115},{15,117},{15,118},{15,119},{17,121},{18,123},{19,124},{20,125},{21,126},{24,126},{27,126},{29,125},{30,123},{32,122},{33,121},{34,120},{36,118},
        {37,117},{38,116},{38,115},{39,115},{40,114},{40,113},{41,113},{42,111},{42,110},{45,110},{46,110},{49,110},{51,110},{52,111},{54,112},{55,113},{57,115},{55,117},
        {54,120},{53,120},{53,121},{53,122},{52,123},{52,124},{51,125},{51,126},{52,129},{53,131},{54,133},{55,135},{56,136},{56,139},{56,141}
    ];
point(10002) ->
    [
        {55,141},{7,56},{9,59},{11,58},{14,57},{15,57},{16,57},{17,57},{18,57},{19,56},{20,55},{21,54},{22,53},{23,53},{24,51},{25,50},{26,48},{27,48},{27,47},{28,46},
        {29,46},{29,45},{30,45},{31,44},{31,43},{32,42},{33,39},{34,37},{34,34},{35,31},{34,28},{34,25},{34,23},{33,20},{31,17},{30,15},{28,14},{27,13},{27,12},{25,12},
        {24,12},{23,11},{22,11},{21,11},{20,10},{19,10},{18,10},{17,10},{15,10},{14,10},{13,12},{10,16},{8,17},{11,16},{12,13},{12,12},{14,12},{15,11},{17,12},{18,12},
        {19,12},{21,13},{22,13},{23,13},{24,13},{25,14},{27,14},{29,16},{29,15},{32,18},{33,20},{33,23},{33,25},{34,27},{34,28},{34,29},{34,31},{35,34},{34,36},{35,39},
        {35,41},{34,42},{34,43},{32,43},{29,46},{26,49},{24,55},{25,60},{30,60},{30,58},{33,59},{32,60},{31,61},{30,63},{29,66},{28,68},{26,69},{27,70},{26,75},{26,77},
        {25,77},{23,82},{23,84},{23,87},{24,89},{24,90},{22,92},{21,93},{19,92},{18,92},{17,92},{15,90},{17,92},{19,92},{20,92},{21,92},{23,92},{24,92},{25,94},{26,95},
        {27,95},{28,96},{29,96},{30,97},{31,98},{32,98},{34,98},{35,99},{37,99},{38,98},{40,98},{41,98},{42,98},{44,96},{45,95},{46,92},{46,89},{46,86},{45,83},{44,80},
        {43,78},{42,75},{41,73},{40,70},{40,66},{41,63},{41,60},{41,58},{43,57},{44,56},{43,53},{45,52},{46,51},{48,51},{49,49},{50,49},{52,49},{52,48},{54,47},{55,47},
        {56,47},{57,46},{58,46},{59,44},{61,43},{62,43},{63,42},{64,42},{68,41},{68,38},{69,36},{70,32},{68,28},{68,27},{66,28},{65,29},{65,32},{63,34},{64,36},{61,38},
        {62,42},{64,42},{65,44},{65,48},{64,51},{62,51},{61,52},{60,53},{59,56},{57,58},{58,62},{57,62},{57,65},{59,68},{60,70},{62,71},{64,72},{65,73},{66,74},{68,76},
        {70,77},{71,79},{71,80},{72,81},{71,84},{70,87},{70,89}
    ];

point(_) ->
    [].


%%  util funs

write(Code,Binary) ->
    ByteSize = byte_size(Binary) + 4,
    <<ByteSize:16,Code:16,Binary/binary>> .

read(Binary) ->
    case Binary of
        <<_ByteSize:32,Code:16,_N:8,Bin2/binary>> ->
            {Code,Bin2};
        _ ->
            io:format("read err~n"),
            err
    end.


%% @doc 打包字符串
write_string(S) when is_list(S) ->
    SB = iolist_to_binary(S),
    L = byte_size(SB),
    <<L:16, SB/binary>>;
write_string(S) when is_binary(S) ->
    L = byte_size(S),
    <<L:16, S/binary>>;
write_string(S) when is_integer(S) ->
    Bin = integer_to_binary(S),
    Len = byte_size(Bin),
    <<Len:16, Bin/binary>>;
write_string(_S) ->
    %?ERR("pt:write_string error, Error = ~p~n", [S]),
    <<0:16, <<>>/binary>>.


read_array(<<Len:16,Bin/binary>>,Fun) ->
    read_array_helper(Len,Fun,Bin,[]).

read_array_helper(0,_,Bin,Data) ->
    {lists:reverse(Data),Bin};
read_array_helper(N,Fun,Bin,Data) ->
    {Info,Rest} = Fun(Bin),
    read_array_helper(N - 1,Fun,Rest,[Info|Data]).

%% @doc 读取字符串
read_string(BinData) ->
    {Bin, RestBinData} = read_binary(BinData),
    {binary_to_list(Bin), RestBinData}.

%% @doc 读取二进制数据
read_binary(<<BinLen:16, BinData/binary>>) ->
    case BinData of
        <<Bin:BinLen/binary-unit:8, RestBinData/binary>> ->
            {Bin, RestBinData};
        _Error ->
            {<<>>, <<>>}
    end;
read_binary(_BinData) ->
    {<<>>, <<>>}.


unixtime() ->
    erlang:system_time() div 1000000000.
longunixtime() ->
    erlang:system_time() div 1000000.

unique_key() ->
    Sn = rand(1,89999),
    lists:concat([10000 + Sn,os:system_time() div 100]).

%% 转换成HEX格式的md5
md5(S) ->
    lists:flatten([io_lib:format("~2.16.0b", [N]) || N <- binary_to_list(erlang:md5(S))]).

rand(Same, Same) -> Same;
rand(Min, Max) when Max < Min -> 0;
rand(Min, Max) ->
    Key = "rand_seed",
    %% 以保证不同进程都可取得不同的种子
    case get(Key) of
        undefined ->
            seed(),
            put(Key, 1);
        N when N < 10 ->
            put(Key, N + 1);
        _ ->
            seed(),
            put(Key, 1)
    end,
    M = Min - 1,
    if
        Max - M =< 0 ->
            0;
        true ->
            random:uniform(Max - M) + M
    end.

list_rand([]) -> null;
list_rand([I]) -> I;
list_rand(List) ->
    Len = length(List),
    Index = rand(1, Len),
    get_term_from_list(List, Index).
get_term_from_list(List, 1) ->
    [Term | _R] = List,
    Term;
get_term_from_list(List, Index) ->
    [_H | R] = List,
    get_term_from_list(R, Index - 1).

seed() ->
    random:seed(erlang:timestamp()).

