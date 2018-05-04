%%----------------------------------------------------
%% 防沉迷系统 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(fcm).
-export([
        gm/3
        ,auth/1
        ,auth_sfz/2
        ,warn/1
        ,push_info/2
        ,add_timer_push/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("fcm.hrl").
-include("link.hrl").

gm(ver, _Role, show) ->
    {false, util:fbin("ver:~w", [sys_env:get(fcm_version)])};
gm(ver, Role, Ver) ->
    sys_env:set(fcm_version, Ver),
    Role;
gm(time, Role = #role{fcm = Fcm}, Time) ->
    {ok, NextMsgId, NextTime} = next_tip_time(Time),
    NRole = Role#role{fcm = Fcm#fcm{acc_time = Time, msg_id = NextMsgId, login_time = util:unixtime()}},
    add_timer_warn(NRole, NextTime).

%% @doc 用户防沉迷检测
%% @spec auth(Role) -> {IsOpenWin, NewRole}
%% Role = NewRole = #role{}
%% IsOpenWin = integer() 是否令客户端弹出验证窗口
auth(Role) ->
    case sys_env:get(fcm_version) of
        ?fcm_version_close -> %% 关闭版本
            {?fcm_version_close, 0, 1, Role#role{fcm = #fcm{is_auth = 1}}};
        ?fcm_version_nor -> %% 普通版本
            case fcm_dao:check(Role) of 
                true -> %% 通过认证
                    {?fcm_version_nor, 0, 1, Role#role{fcm = #fcm{is_auth = 1}}};
                false -> %% 未通过认证 防沉迷用户
                    {?fcm_version_nor, 0, 0, Role#role{fcm = #fcm{is_auth = 0}}}
            end;
        _ -> %% 严格版本
            case fcm_dao:check(Role) of 
                true -> %% 通过认证
                    {?fcm_version_strict, 0, 1, Role#role{fcm = #fcm{is_auth = 1}}};
                false -> %% 未通过认证 防沉迷用户
                    case fcm_dao:get_online_info(Role) of
                        {ok, Fcm = #fcm{logout_time = LTime}} when LTime >= ?fcm_offline_reset_time -> %% 下线时间超时
                            {ok, NextMsgId, NextTime} = next_tip_time(0),
                            NR = add_timer_warn(Role, NextTime),
                            NewRole = NR#role{fcm = Fcm#fcm{acc_time = 0, msg_id = NextMsgId}},
                            %% push_info(NewRole, fcm),
                            %% {0, add_timer_push(NewRole)};
                            {?fcm_version_strict, 0, 0, NewRole};
                        {ok, Fcm = #fcm{acc_time = AccTime}} when AccTime >= ?fcm_allow_online_time -> %% 防沉迷用户 在线超时
                            NewRole = Role#role{fcm = Fcm},
                            %% NewRole = role_timer:set_timer(fcm_force_exit, 1000, {fcm, push_info, [alert]}, 1, NRole),
                            push_info(NewRole, alert),
                            {?fcm_version_strict, AccTime, 1, NewRole};
                        {ok, Fcm = #fcm{acc_time = AccTime}} -> %% 防沉迷用户在线非超时
                            {ok, NextMsgId, NextTime} = next_tip_time(AccTime),
                            %% ?DEBUG("AccTime:~w, NextTime:~w, msg_id:~w", [AccTime, NextTime, NextMsgId]),
                            NR = add_timer_warn(Role, NextTime),
                            NewRole = NR#role{fcm = Fcm#fcm{msg_id = NextMsgId}},
                            %% push_info(NewRole, fcm),
                            %% {0, add_timer_push(NewRole)};
                            {?fcm_version_strict, AccTime, 0, NewRole};
                        _ ->
                            {?fcm_version_strict, 0, 1, Role#role{fcm = #fcm{is_auth = 1}}}
                    end
            end
    end.

%% 用户身份证验证
auth_sfz(#role{fcm = #fcm{is_auth = 1}}, _) ->
    {false, <<"无需重新验证">>};
auth_sfz(Role = #role{fcm = Fcm}, {Sfz, Name}) ->
    case check_sfz(Sfz, Name) of
        {false, Reason} -> {false, Reason};
        true ->
            case fcm_dao:add(Role, {Sfz, Name}) of
                {false, Reason} -> {false, Reason};
                {ok, _Rows} ->
                    NRole = case role_timer:del_timer(fcm_push_auth, Role) of
                        {ok, _, NR} -> NR;
                        false -> Role
                    end,
                    NewRole = case role_timer:del_timer(fcm_warn, NRole) of
                        {ok, _, NewR} -> NewR;
                        false -> NRole
                    end,
                    {ok, NewRole#role{fcm = Fcm#fcm{is_auth = 1}}}
            end
    end.

%% @doc 警告
warn(Role = #role{fcm = #fcm{is_auth = 1}}) -> %% 已验证通过
    case role_timer:del_timer(fcm_warn, Role) of
        {ok, _, NR} -> {ok, NR};
        false -> {ok}
    end;
warn(Role = #role{fcm = Fcm}) ->
    AccTime = online_time(Fcm),
    case next_tip_time(AccTime) of
        false -> %% 已超出三小时
            push_info(Role, alert),
            {ok, Role};
        {ok, NextMsgId, NextTime} ->
            push_info(Role, alert),
            %% ?DEBUG("AccTime:~w, NextTime:~w, msg_id:~w", [AccTime, NextTime, NextMsgId]),
            NewRole = add_timer_warn(Role, NextTime),
            {ok, NewRole#role{fcm = Fcm#fcm{msg_id = NextMsgId}}}
    end.

%% 推送提示信息
%% 警告信息
push_info(#role{fcm = #fcm{is_auth = 1}}, _Mod) -> {ok};
push_info(Role = #role{fcm = #fcm{msg_id = MsgId}}, alert) -> 
    case tip_msg(MsgId) of
        {ok, Msg} -> %% 正常提示
            %% TODO 推送个人系统信息
            notice:alert(Msg),
            {ok};
        {exit, Msg} -> %% 提示并退出
            role:stop(async, Role#role.pid, Msg),
            {ok}
    end;
%% 防沉迷信息
push_info(#role{link = #link{conn_pid = ConnPid}, fcm = Fcm = #fcm{is_auth = IsAuth}}, fcm) -> 
    case IsAuth of
        0 ->
            %% TODO 推送个人系统信息
            Ver = case sys_env:get(fcm_version) of
                ?fcm_version_close -> ?fcm_version_close;
                ?fcm_version_nor -> ?fcm_version_nor;
                _ -> ?fcm_version_strict
            end,
            AccTime = online_time(Fcm),
            sys_conn:pack_send(ConnPid, 13401, {Ver, AccTime, IsAuth, <<"账号已纳入防沉迷系统，请填写身份证信息进行认证">>}),
            {ok};
        1 -> %% 现在没推送此数据
            %% sys_conn:pack_send(ConnPid, 13401, {IsAuth, <<"已通过防沉迷认证">>}),
            {ok}
    end;
push_info(_Role, _) -> {ok}. %% 容错

%%-----------------------------------------------------------------
%% 私有函数
%%-----------------------------------------------------------------

%% 定时推送警告信息
add_timer_warn(Role, NextTime) ->
    NRole = case role_timer:del_timer(fcm_warn, Role) of
        {ok, _, NR} -> NR;
        false -> Role
    end,
    role_timer:set_timer(fcm_warn, NextTime * 1000, {fcm, warn, []}, 1, NRole).

%% 弹出验证界面（现在客户端自已处理） 定时推送防沉迷验证信息 30分钟推送一次
add_timer_push(Role) ->
    NRole = case role_timer:del_timer(fcm_push_auth, Role) of
        {ok, _, NR} -> NR;
        false -> Role
    end,
    role_timer:set_timer(fcm_push_auth, 1800000, {fcm, push_info, [fcm]}, 0, NRole).

%% 计算在线时间
online_time(#fcm{login_time = LTime, acc_time = ATime}) ->
    ATime + (util:unixtime() - LTime).

%% 获取距离下一次提示的时间
next_tip_time(Fcm = #fcm{}) ->
    AccTime = online_time(Fcm),
    next_tip_time(AccTime);
next_tip_time(AccTime) when AccTime < 3600 -> %% 距离一小时提示
    {ok, 1, 3600 - AccTime};
next_tip_time(AccTime) when AccTime < 7200 -> %% 距离两小时提示
    {ok, 2, 7200 - AccTime};
next_tip_time(AccTime) when AccTime < 10500 -> %% 距离2小时55分提示
    {ok, 3, 10500 - AccTime};
next_tip_time(AccTime) when AccTime < 10800 -> %% 距离三小时极限提示
    {ok, 4, 10800 - AccTime};
next_tip_time(_) -> %% 超出三小时
    false.

%% 沉迷提示信息
tip_msg(0) -> %% 超出三小时被迫下线后上线
    {exit, <<"你的累计下线时间不满5小时，为了保证您能正常游戏，请您稍后登录">>};
tip_msg(1)-> %% 超过一小时提示
    {ok, <<"你累计在线时间已满1小时">>};
tip_msg(2) -> %% 超过两小时提示
    {ok, <<"你累计在线时间已满2小时">>};
tip_msg(3) -> %% 2小时55分提示
    {ok, <<"你的账户防沉迷剩余时间将在5分钟后进入沉迷状态，系统将自动将您离线休息一段时间">>};
tip_msg(_) -> %% 超出三小时被迫下线
    {exit, <<"你已进入不健康游戏时间，请你暂离游戏进行适当休息和运动，合理安排您的游戏时间，点击确定退出游戏">>}.

%% 校验身份证号
%% 1、15位身份证号码组成： 
%%  ddddddyymmddxxs共15位，其中： 
%%  dddddd为6位的地方代码，根据这6位可以获得该身份证号所在地。 
%%  yy为2位的年份代码，是身份证持有人的出身年份。 
%% 2、18位身份证号码组成： 
%%  ddddddyyyymmddxxsp共18位，其中： 
%%  其他部分都和15位的相同。年份代码由原来的2位升级到4位。最后一位为校验位。
%%  S = Sum(Ai * Wi), i = 0, ... , 16 ，先对前17位数字的权求和 Wi: 7 9 10 5 8 4 2 1 6 3 7 9 10 5 8 4 2
%%  计算模 Y = mod(S, 11)  Y: 0 1 2 3 4 5 6 7 8 9 10  根据Y取相关校验码作最后一位: 1 0 X 9 8 7 6 5 4 3 2 
check_sfz(<<>>, _) -> {false, <<"身份证号不能为空">>};
check_sfz(_, <<>>) -> {false, <<"姓名不能为空">>};
check_sfz(Sfz, _Name) ->
    SfzL = binary_to_list(Sfz),
    Len = length(SfzL),
    if
        Len =:= 15 -> %% 15位身份证号码验证法
            {Y2, _} = string:to_integer(string:substr(SfzL, 7, 2)), %% 15位身份证年份占两位
            Year = 1900 + Y2,
            {NowYear, _, _} = erlang:date(),
            if
                NowYear - Year < 18 ->
                    {false, <<"未成年身份证号">>};
                true -> 
                    true
            end;
        Len =:= 18 -> %% 18位身份证号码验证法
            {Year, _} = string:to_integer(string:substr(SfzL, 7, 4)), %% 18位身份证年份占四位
            {NowYear, _, _} = erlang:date(),
            if
                Year < 1850 ->
                    {false, <<"非法身份证号">>};
                NowYear - Year < 18 ->
                    {false, <<"未成年身份证号">>};
                true -> %% 18位成年身份证号的加权验证法
                    {I18, Sum} = sumW(SfzL, 0, 0),
                    A1 = getA1(Sum rem 11),
                    case A1 =:= I18 of
                        false -> {false, <<"身份证校验不正确">>};
                        true -> true
                    end
            end;
        true ->
            {false, <<"身份证长度不合法">>}
    end.

%% 统计18位身份证号码的前17位加权值
sumW([I18], Sum, 17) -> {ascii(I18), Sum};
sumW([Ii | T], Sum, I) ->
    Wi = getW(I) * ascii(Ii),
    sumW(T, Sum + Wi, I + 1).

%% 身份证前17位的权值
getW(0) -> 7;
getW(1) -> 9;
getW(2) -> 10;
getW(3) -> 5;
getW(4) -> 8;
getW(5) -> 4;
getW(6) -> 2;
getW(7) -> 1;
getW(8) -> 6;
getW(9) -> 3;
getW(10) -> 7;
getW(11) -> 9;
getW(12) -> 10;
getW(13) -> 5;
getW(14) -> 8;
getW(15) -> 4;
getW(16) -> 2.

%% 身份证前17位加权总值除11得余数后的对应值
getA1(0) -> 1;
getA1(1) -> 0;
getA1(2) -> x;
getA1(3) -> 9;
getA1(4) -> 8;
getA1(5) -> 7;
getA1(6) -> 6;
getA1(7) -> 5;
getA1(8) -> 4;
getA1(9) -> 3;
getA1(10) -> 2.

%% ASCII码与数值对应表
ascii($0) -> 0;
ascii($1) -> 1;
ascii($2) -> 2;
ascii($3) -> 3;
ascii($4) -> 4;
ascii($5) -> 5;
ascii($6) -> 6;
ascii($7) -> 7;
ascii($8) -> 8;
ascii($9) -> 9;
ascii($x) -> x;
ascii($X) -> x;
ascii(_) -> 0.
