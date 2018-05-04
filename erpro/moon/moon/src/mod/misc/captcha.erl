%%----------------------------------------------------
%% 验证码生成
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(captcha).
-export([
        check/4
        ,do/3
        ,get/0
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").

-define(CAPTCHA_KEY, {captcha, Cmd}).

%% @spec check(Mod, Cmd, Data, Role) -> {ok, Data} | false
%% @doc 判断验证码是否正确
%% Mod = atom() 模块名
%% Cmd = integer() 协议号
%% Data = tuple() 客户端请求数据
%% Role = #role{}
%% 返回false需等待客户端进行验证码验证 {ok, Data}已通过客户端验证
check(_Mod, _Cmd, {next, Data}, _Role) -> 
    {ok, Data};
check(Mod, Cmd, Data, #role{link = #link{conn_pid = ConnPid}}) ->
    {Code, ImgBin} = captcha:get(),
    put(?CAPTCHA_KEY, {Code, Mod, Data, 1}),
    sys_conn:pack_send(ConnPid, 13495, {Cmd, ImgBin}), %% 通知客户端打开验证码窗口进行验证
    false.

%% 处理相关协议请求
do(13495, {Cmd}, _Role) -> %% 刷新验证码
    {NewCode, ImgBin} = captcha:get(),
    case get(?CAPTCHA_KEY) of
        {_Code, Mod, Data, N} -> 
            put(?CAPTCHA_KEY, {NewCode, Mod, Data, N}),
            {ok, ImgBin};
        _ -> 
            false
    end;
do(13496, {Cmd, Code}, Role) -> %% 校验验证码
    case get(?CAPTCHA_KEY) of
        {Code, Mod, Data, _N} -> %% 校验成功 进行前面请求操作
            erase(?CAPTCHA_KEY),
            handle_next(Mod, Cmd, Data, Role);
        {_Code, _Mod, _Data, N} when N >= 5 -> %% 多次校验失败 取消之前操作
            erase(?CAPTCHA_KEY),
            false;
        {_Code, Mod, Data, N} -> %% 校验失败 要求客户重新输入验证码
            {NewCode, ImgBin} = captcha:get(),
            put(?CAPTCHA_KEY, {NewCode, Mod, Data, N + 1}),
            {false, ImgBin};
        _ -> %% 非法请求 无相关校验信息
            false
    end.

%% 进行前面请求协议处理操作
handle_next(Mod, Cmd, Data, State = #role{name = Name, link = #link{conn_pid = ConnPid}}) ->
    case catch Mod:handle(Cmd, {next, Data}, State) of
        {ok} -> 
            ok;
        {ok, NewState} when is_record(NewState, role) ->
            {ok, NewState};
        {reply, Reply} ->
            sys_conn:pack_send(ConnPid, Cmd, Reply),
            ok;
        {reply, Reply, NewState} when is_record(NewState, role) ->
            sys_conn:pack_send(ConnPid, Cmd, Reply),
            {ok, NewState};
        _Reason ->
            ?ERR("[~s]的角色进程处理命令时出错:~w [Cmd:~w Data:~w]", [Name, _Reason, Cmd, Data]),
            ok
    end.

%%get() ->
%%    A = util:rand(1, 9),
%%    B = util:rand(1, 9),
%%    Code = A + B,
%%    ImgBin = img("0123456789+-=?"),
%%    {Code, ImgBin}.

%% @spec get() -> {Code, ImgBin}
%% @doc 生成2进制验证码图片
%% Code = integer()  验证码答案
%% ImgBin = binary() 二进制图片信息
get() ->
    %%Type = util:rand(1, 2),
    do(str).

do(1) -> %% 加法
    A = util:rand(1, 100),
    B = util:rand(1, 100),
    Code = A + B,
    %% Str = io_lib:format("123~w+~p=?", [A, B]),
    Str = lists:concat([A, "+", B, "=?"]),
    ImgBin = img(Str),
    {Code, ImgBin};
do(2) -> %% 减法
    B = util:rand(1, 99),
    A = util:rand(B, 99),
    Code = A - B,
    %% Str = io_lib:format("2342~w-~p=?", [A, B]),
    Str = lists:concat([A, "-", B, "=?"]),
    ImgBin = img(Str),
    {Code, ImgBin};
do(_) ->
    Code = util:rand(1000, 9999),
    Str = lists:concat([Code]),
    ImgBin = img(Str),
    {Code, ImgBin}.


%% 生成验证码图片
img(Text) ->
    With = 160, 
    Height = 50,
    Img = egd:create(With, Height),
    noise(point, 100, {With, Height}, Img),
    %% noise(line, 50, {With, Height}, Img),
    %% noise(rectangle, 20, {With, Height}, Img),
    P = {util:rand(45, 50), util:rand(10, 30)},
    lineup(Text, Img, P),
    Bin = egd:render(Img, png),
    %% egd:save(Bin, "d:/captcha.png"),
    egd:destroy(Img),
    Bin.

%% 问题显示处理
lineup([], _Img, _P) -> ok;
lineup([H | T], Img, {X, Y} = P0) ->
    %% P = {X + 16, Y},
    Color = egd:color({util:rand(0, 255), util:rand(0, 255), util:rand(0, 255)}),
    Font = {util:rand(12, 14), util:rand(14, 16), util:rand(1, 3)},
    draw([H], Img, P0, Font, Color),
    P = {X + util:rand(18, 20), Y + util:rand(-5, 5)},
    lineup(T, Img, P).

%% 加噪点
noise(_Mod, 0, _, _Img) -> ok;
noise(Mod = point, N, {With, Height}, Img) -> %% 点形噪点
    Color = egd:color({util:rand(0, 255), util:rand(0, 255), util:rand(0, 255)}),
    X = util:rand(1, With),
    Y = util:rand(1, Height),
    egd:rectangle(Img, {X, Y}, {X + 1, Y + 1} , Color),
    noise(Mod, N - 1, {With, Height}, Img);
noise(Mod = line, N, {With, Height}, Img) -> %% 线形噪点
    Color = egd:color({util:rand(0, 255), util:rand(0, 255), util:rand(0, 255)}),
    X0 = util:rand(0, With),
    Y0 = util:rand(0, Height),
    X1 = util:rand(X0, X0 + 15),
    Y1 = util:rand(Y0 - 5, Y0 + 5),
    egd:line(Img, {X0, Y0}, {X1, Y1} , Color),
    noise(Mod, N - 1, {With, Height}, Img);
noise(Mod = rectangle, N, {With, Height}, Img) -> %% 矩形噪点
    Color = egd:color({util:rand(0, 255), util:rand(0, 255), util:rand(0, 255)}),
    X0 = util:rand(0, With),
    Y0 = util:rand(0, Height),
    R = util:rand(10, 15),
    egd:rectangle(Img, {X0, Y0}, {X0 + R, Y0 + R} , Color),
    noise(Mod, N - 1, {With, Height}, Img).

draw("0", Img, {X, Y}, {W, H, Wei}, Color) ->
    egd:filledRectangle(Img, {X, Y}, {X + Wei, Y + H} , Color),
    egd:filledRectangle(Img, {X, Y}, {X + W, Y + Wei} , Color),
    egd:filledRectangle(Img, {X + W - Wei, Y}, {X + W, Y + H} , Color),
    egd:filledRectangle(Img, {X, Y + H}, {X + W, Y + H + Wei} , Color),
    ok;

draw("1", Img, {X, Y}, {_W, H, Wei}, Color) ->
    egd:filledRectangle(Img, {X, Y}, {X + Wei, Y + H + Wei} , Color),
    ok;

draw("2", Img, {X, Y}, {W, H, Wei}, Color) ->
    egd:filledRectangle(Img, {X, Y}, {X + W, Y + Wei} , Color),
    egd:filledRectangle(Img, {X + W - Wei, Y}, {X + W, Y + H / 2} , Color),
    egd:filledRectangle(Img, {X, Y + H / 2}, {X + W, Y + H / 2 + Wei} , Color),
    egd:filledRectangle(Img, {X, Y + H / 2}, {X + Wei, Y + H} , Color),
    egd:filledRectangle(Img, {X, Y + H}, {X + W, Y + H + Wei} , Color),
    ok;

draw("3", Img, {X, Y}, {W, H, Wei}, Color) ->
    egd:filledRectangle(Img, {X, Y}, {X + W, Y + Wei} , Color),
    egd:filledRectangle(Img, {X + W - Wei, Y + Wei}, {X + W, Y + H} , Color),
    egd:filledRectangle(Img, {X, Y + H / 2}, {X + W, Y + H / 2 + Wei} , Color),
    egd:filledRectangle(Img, {X, Y + H}, {X + W, Y + H + Wei} , Color),
    ok;

draw("4", Img, {X, Y}, {W, H, Wei}, Color) ->
    egd:filledRectangle(Img, {X, Y}, {X + Wei, Y + H /2} , Color),
    egd:filledRectangle(Img, {X, Y + H / 2}, {X + W, Y + H / 2 + Wei} , Color),
    egd:filledRectangle(Img, {X + W - Wei, Y}, {X + W, Y + H + Wei} , Color),
    ok;

draw("5", Img, {X, Y}, {W, H, Wei}, Color) ->
    egd:filledRectangle(Img, {X, Y}, {X + Wei, Y + H / 2} , Color),
    egd:filledRectangle(Img, {X, Y}, {X + W, Y + Wei} , Color),
    egd:filledRectangle(Img, {X + W - Wei, Y + H / 2}, {X + W, Y + H} , Color),
    egd:filledRectangle(Img, {X, Y + H / 2}, {X + W, Y + H / 2 + Wei} , Color),
    egd:filledRectangle(Img, {X, Y + H}, {X + W, Y + H + Wei} , Color),
    ok;

draw("6", Img, {X, Y}, {W, H, Wei}, Color) ->
    egd:filledRectangle(Img, {X, Y}, {X + Wei, Y + H} , Color),
    egd:filledRectangle(Img, {X, Y}, {X + W, Y + Wei} , Color),
    egd:filledRectangle(Img, {X + W - Wei, Y + H / 2}, {X + W, Y + H} , Color),
    egd:filledRectangle(Img, {X, Y + H / 2}, {X + W, Y + H / 2 + Wei} , Color),
    egd:filledRectangle(Img, {X, Y + H}, {X + W, Y + H + Wei} , Color),
    ok;

draw("7", Img, {X, Y}, {W, H, Wei}, Color) ->
    egd:filledRectangle(Img, {X, Y}, {X + W, Y + Wei} , Color),
    egd:filledRectangle(Img, {X + W - Wei, Y + Wei}, {X + W, Y + H + Wei} , Color),
    ok;

draw("8", Img, {X, Y}, {W, H, Wei}, Color) ->
    egd:filledRectangle(Img, {X, Y}, {X + Wei, Y + H} , Color),
    egd:filledRectangle(Img, {X, Y}, {X + W, Y + Wei} , Color),
    egd:filledRectangle(Img, {X + W - Wei, Y}, {X + W, Y + H} , Color),
    egd:filledRectangle(Img, {X, Y + H / 2}, {X + W, Y + H / 2 + Wei} , Color),
    egd:filledRectangle(Img, {X, Y + H}, {X + W, Y + H + Wei} , Color),
    ok;

draw("9", Img, {X, Y}, {W, H, Wei}, Color) ->
    egd:filledRectangle(Img, {X, Y}, {X + Wei, Y + H / 2} , Color),
    egd:filledRectangle(Img, {X, Y}, {X + W, Y + Wei} , Color),
    egd:filledRectangle(Img, {X + W - Wei, Y}, {X + W, Y + H} , Color),
    egd:filledRectangle(Img, {X, Y + H / 2}, {X + W, Y + H / 2 + Wei} , Color),
    egd:filledRectangle(Img, {X, Y + H}, {X + W, Y + H + Wei} , Color),
    ok;

draw("+", Img, {X, Y}, {W, H, Wei}, Color) ->
    egd:filledRectangle(Img, {X, Y + H / 2}, {X + W, Y + H / 2 + Wei} , Color),
    egd:filledRectangle(Img, {X + trunc(W / 2 - Wei / 2), Y + Wei}, {X + trunc(W / 2 - Wei / 2) + Wei, Y + H} , Color),
    ok;

draw("-", Img, {X, Y}, {W, H, Wei}, Color) ->
    egd:filledRectangle(Img, {X, Y + H / 2}, {X + W, Y + H / 2 + Wei} , Color),
    ok;

draw("=", Img, {X, Y}, {W, H, Wei}, Color) ->
    egd:filledRectangle(Img, {X, Y + H / 2 - Wei}, {X + W, Y + H / 2} , Color),
    egd:filledRectangle(Img, {X, Y + H / 2 + Wei}, {X + W, Y + H / 2 + Wei * 2} , Color),
    ok;

draw("?", Img, {X, Y}, {W, H, Wei}, Color) ->
    egd:filledRectangle(Img, {X, Y + H / 2}, {X + Wei, Y + H - Wei * 1.5} , Color),
    egd:filledRectangle(Img, {X, Y}, {X + W, Y + Wei} , Color),
    egd:filledRectangle(Img, {X + W - Wei, Y}, {X + W, Y + H / 2} , Color),
    egd:filledRectangle(Img, {X, Y + H / 2}, {X + W, Y + H / 2 + Wei} , Color),
    egd:filledRectangle(Img, {X, Y + H}, {X + Wei, Y + H + Wei} , Color),
    ok;

draw(_, _Img, _P, _F, _Color) -> 
    ignore.
