%% ------------------------------
%% 玩家个人设置相关
%% @author wpf (wprehard@qq.com)
%% ------------------------------
-module(setting).
-export([
        init/0
        ,login/1
        ,check/4
        ,check_lock/1
        ,check_lock_length/5
        ,dress_login_init/1
        ,hand_cancel/1
        ,update_auto_skill/3
        ,check_password/1
        ,ver_parse/1
        ,get_shortcuts/1
        ,exp_seal/2
        ,handle_exp_seal/4
        ,set_shield/2
        ,cancel_shield/2
    ]).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("setting.hrl").
-include("item.hrl").
-include("buff.hrl").
-include("skill.hrl").
%%
-include("gain.hrl").
-include("pos.hrl").
-include("assets.hrl").

%% @spec init() -> #plock{}
%% @doc 初始化模块
init() ->
    #setting{
        dress_looks = #dress_looks{},
        plock = #plock{
            is_lock = ?false
            ,has_lock = ?false
            ,q1 = <<>>
            ,q2 = <<>>
        },
        skill = #skill_shortcuts{}
        ,hook_status = ?false
    }.

%%设置屏蔽
% -define(shield_private_chat, 1).
% -define(shield_world_chat, 2).
% -define(shield_guild_chat, 3).
% -define(shield_role, 4).
% -define(shield_pet, 5).
% -define(shield_medal, 6).
set_shield(Type, Role = #role{pid = Pid, link = #link{conn_pid = ConnPid},setting = Setting = #setting{shield = Shield}}) when (Type =:= ?shield_private_chat orelse Type =:= ?shield_world_chat 
    orelse Type =:= ?shield_guild_chat orelse Type =:= ?shield_role orelse Type =:= ?shield_pet orelse Type =:= ?shield_medal )->
    ?DEBUG("--shield_type-------~w~n",[Type]),
    case lists:member(Type, Shield) of 
        true ->
            {ok, Role};
        false ->
            NShield  = [Type|Shield],
            role_group:check_shield({Pid, ConnPid}, [Type]),
            {ok, Role#role{setting = Setting#setting{shield = NShield}}}
    end;

set_shield(_Type, _Role) ->
    {false,?L(<<"未知类型">>)}.

cancel_shield(Type, Role = #role{pid = Pid,setting = Setting = #setting{shield = Shield}}) when (Type =:= ?shield_private_chat orelse Type =:= ?shield_world_chat 
    orelse Type =:= ?shield_guild_chat orelse Type =:= ?shield_role orelse Type =:= ?shield_pet orelse Type =:= ?shield_medal )->
    case lists:member(Type, Shield) of 
        true ->
            NShield  = Shield -- [Type],
            role_group:cancel_shield(Pid, [Type]),
            {ok, Role#role{setting = Setting#setting{shield = NShield}}};
        false ->
            {ok, Role}
    end;

cancel_shield(_Type, _Role) ->
    {false,?L(<<"未知类型">>)}.

%% 版本转换
ver_parse({setting, Dress, Plock}) when is_integer(Dress) ->
    NewDressLooks = #dress_looks{dress = Dress},
    ver_parse({setting, NewDressLooks, Plock, #skill_shortcuts{}}); 
ver_parse({setting, Dress, Plock}) ->
    ver_parse({setting, Dress, Plock, #skill_shortcuts{}}); 
ver_parse({setting, Dress, Plock, Skill}) ->
    ver_parse({setting, Dress, Plock, Skill, ?false}); 
ver_parse({setting, {dress_looks, Dress, WeaponDress, JewelryDress}, Plock, Skill, Hook}) ->
    ver_parse({setting, {dress_looks, Dress, WeaponDress, JewelryDress, 1}, Plock, Skill, Hook}); 
ver_parse({setting, Dress, Plock, Skill, Hook}) ->
    ver_parse({setting, Dress, Plock, Skill, Hook, #exp_seal{}});
ver_parse({setting, Dress, {plock, Is_lock, Has_lock, Password, Q1, A1, Q2, A2}, Skill, Hook, ExpSeal}) ->
    ver_parse({setting, Dress, {plock, Is_lock, Has_lock, Password, Q1, A1, Q2, A2, []}, Skill, Hook, ExpSeal});
ver_parse(Setting) ->
    case is_record(Setting, setting) of
        false -> {false, ?L(<<"角色配置版本转换失败">>)};
        true ->
            case parse_field(Setting, [dress_looks]) of
                {false, Reason} -> {false, Reason};                
                {ok, NewSetting} -> {ok, NewSetting}
            end
    end.

%% 针对每一个子项进行解析
parse_field(Setting, []) -> {ok, Setting};
parse_field(Setting, [H | T]) ->
    case parse_field(Setting, H) of
        {false, Reason} -> {false, Reason};
        {ok, NewSetting} ->
            parse_field(NewSetting, T)
    end;
%% 外观显示列表
parse_field(Setting = #setting{dress_looks = DressLooks}, dress_looks) ->
    case do_parse_field(DressLooks, dress_looks) of
        {ok, NewDressLooks} ->
            {ok, Setting#setting{dress_looks = NewDressLooks}};
        {false, Reason} -> {false, Reason}
    end;
parse_field(_Setting, _Field) ->
    {false, util:fbin(?L(<<"无法识别数据项[~w]">>), [_Field])}.

do_parse_field(DressLooks, dress_looks) ->
    case is_record(DressLooks, dress_looks) of
        true -> {ok, DressLooks};
        false -> {false, ?L(<<"外观显示列表转换失败">>)}
    end.

%% @spec login(Role) -> NewRole
%% @doc 登陆、顶号初始化: 有二级密码就自动开启锁
login(Role = #role{setting = S = #setting{plock = P = #plock{q1 = undefined, q2 = undefined}}}) ->
    login(Role#role{setting = S#setting{plock = P#plock{q1 = <<>>, q2 = <<>>}}});
login(Role = #role{setting = #setting{plock = #plock{has_lock = ?false}}}) -> Role;
login(Role = #role{setting = S = #setting{plock = P = #plock{has_lock = ?true}}}) ->
    Role#role{setting = S#setting{plock = P#plock{is_lock = ?true}}};
login(Role) -> %% 容错
    Role#role{setting = init()}.

%% @spec get_shortcuts(Setting) -> #skill_shortcuts{};
get_shortcuts(#setting{skill = SkillShortCuts, hook_status = ?true}) when is_record(SkillShortCuts, skill_shortcuts) -> SkillShortCuts;
get_shortcuts(_) -> #skill_shortcuts{}.

%% @spec dress_login_init(Eqm, Set) ->
%% @doc 登陆初始化检查是状态显示，并过滤
dress_login_init(Role = #role{eqm = Eqm, setting = Set, soul_lev = _SoulLev, mounts = Mounts}) ->
    MountsLooks = mount:get_skin(Mounts, Eqm),
    WingLooks = wing:calc_looks(Role),
    Looks = looks:suit_looks(Eqm),
    ShapeLooks = looks:calc_shapelooks(Role),
    Role#role{looks = looks:modify_cloth_look(Set, Looks ++ ShapeLooks ++ MountsLooks ++ WingLooks)}.

%% @spec check_lock_length(Password, Answer, Answer2) -> {false, Reason} | true
%% @doc 检测密码和密保答案长度
check_lock_length(P, Q1, Q2, A1, A2) ->
    case check_password(P) of
        {false, M} -> {false, M};
        true ->
            case check_question(Q1, Q2) of
                {false, M} -> {false, M};
                true ->
                    check_answer(A1, A2)
            end
    end.

%% @spec check(Mod, Cmd, Data, State) -> ok | false
%% @doc 检测是否可以通过密码锁检测
check(Mod, Cmd, Data, Role) ->
    case plock_cfg:check(Mod, Cmd, Data) of
        true -> %% 要检测密码锁
            case check_lock(Role) of
                false -> ok; %% 无锁或者已解锁
                true ->
                    case catch plock_cfg:handle_locked(Cmd, Data, Role) of
                        ok ->
                            false;
                        _ ->
                            ?ELOG("密码锁处理出错[MOD:~w, CMD:~w]", [Mod, Cmd]),
                            false
                    end
            end;
        false -> ok
    end.

%% @spec check_lock(Role) -> true | false
%% @doc 检测是否开启了锁，并通知
check_lock(#role{setting = #setting{plock = #plock{is_lock = ?false}}}) -> false;
check_lock(#role{setting = #setting{plock = #plock{is_lock = ?true}}, link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 14107, {1}), %% 通知客户端打开解锁窗口(也可以由客户端主动打开)
    true;
check_lock(_) -> false.
                
%% @spec hand_cancel({Id, SrvId}) -> true | false
%% @doc GM手动重置锁
hand_cancel(Id = {_, _}) ->
    case role_api:lookup(by_id, Id, #role.pid) of
        {ok, _N, Pid} ->
            role:apply(async, Pid, {fun do_hand_cancel/1, []}),
            true;
        _ ->
            false
    end;
hand_cancel(_) -> false.
do_hand_cancel(Role = #role{setting = Setting}) ->
    {ok, Role#role{setting = Setting#setting{
                plock = #plock{
                    is_lock = ?false
                    ,has_lock = ?false
                    ,q1 = <<>>
                    ,q2 = <<>>
                }
            }
        }
    }.

%% 技能升级，同步自动挂机面板
update_auto_skill(SkillId, NewSkillId, Role = #role{setting = Setting = #setting{skill = Shortcuts, hook_status = S11}, link = #link{conn_pid = ConnPid}}) ->
    NewShortcuts = do_update_auto(S11, ConnPid, false, SkillId, NewSkillId, tuple_to_list(Shortcuts), []),
    Role#role{setting = Setting#setting{skill = NewShortcuts}}.
do_update_auto(S11, ConnPid, true, _, _, [], NewS) ->
    NewShortcuts = list_to_tuple(lists:reverse(NewS)),
    {S1, S2, S3, S4, S5, S6, S7, S8, S9, S10} = skill:record2tuple(NewShortcuts),
    sys_conn:pack_send(ConnPid, 14115, {S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11}),
    NewShortcuts;
do_update_auto(_S11, _ConnPid, false, _, _, [], NewS) ->
    list_to_tuple(lists:reverse(NewS));
do_update_auto(S11, ConnPid, _IsChange, SkillId, NewSkillId, [SkillId | T], NewS) ->
    do_update_auto(S11, ConnPid, true, SkillId, NewSkillId, T, [NewSkillId | NewS]);
do_update_auto(S11, ConnPid, IsChange, SkillId, NewSkillId, [H | T], NewS) ->
    do_update_auto(S11, ConnPid, IsChange, SkillId, NewSkillId, T, [H | NewS]).

%% @spec exp_seal(Opt, Role) -> {ok, Reply, NewRole} | {false, Reply}.
%% @doc 经验封印
%% 首次开启封印
exp_seal(?exp_seal_opt_open, Role = #role{setting = Setting = #setting{exp_seal = #exp_seal{status = ?exp_seal_status_zero}}}) ->
    case role_gain:do([#loss{label = coin_all, val = exp_seal_data:get_exp_seal_cost(0)}], Role) of
        {false, #loss{err_code = ErrCode}} ->
            {false, exp_seal_pack(ErrCode, ?L(<<"金币不足，无法开启">>))};
        {ok, NewRole} ->
            log:log(log_coin, {<<"经验封印">>, <<"首次开启">>, Role, NewRole}),
            NewExpSeal = #exp_seal{status = ?exp_seal_status_open, top = exp_seal_data:get_exp_seal_top(0)},
            {ok, exp_seal_pack(1, ?L(<<"成功开启封印">>), NewExpSeal, 0), NewRole#role{setting = Setting#setting{exp_seal = NewExpSeal}}}
    end;
%% 非首次开启封印
exp_seal(?exp_seal_opt_open, Role = #role{setting = Setting = #setting{exp_seal = ExpSeal = #exp_seal{status = ?exp_seal_status_close}}, assets = #assets{seal_exp = Exp}}) ->
    NewExpSeal = ExpSeal#exp_seal{status = ?exp_seal_status_open},
    {ok, exp_seal_pack(1, ?L(<<"成功开启经验封印">>), NewExpSeal, Exp), Role#role{setting = Setting#setting{exp_seal = NewExpSeal}}};
%% 关闭封印
exp_seal(?exp_seal_opt_close, Role = #role{setting = Setting = #setting{exp_seal = ExpSeal = #exp_seal{status = ?exp_seal_status_open}}, assets = #assets{seal_exp = Exp}}) ->
    NewExpSeal = ExpSeal#exp_seal{status = ?exp_seal_status_close},
    {ok, exp_seal_pack(1, ?L(<<"成功关闭经验封印">>), NewExpSeal, Exp), Role#role{setting = Setting#setting{exp_seal = NewExpSeal}}};
%% 提升封印经验上限
exp_seal(?exp_seal_opt_upgrade, #role{setting = #setting{exp_seal = #exp_seal{status = ?exp_seal_status_zero}}}) ->
    {false, exp_seal_pack(0, ?L(<<"经验封印还没开启">>))};
exp_seal(?exp_seal_opt_upgrade, Role = #role{setting = Setting = #setting{exp_seal = ExpSeal = #exp_seal{top = Top}}, assets = #assets{seal_exp = Exp}}) ->
    case exp_seal_data:get_exp_seal_cost(Top) of
        0 -> {false, exp_seal_pack(0, ?L(<<"上限已达到最高，无法再提升">>))};
        Cost ->
            case role_gain:do([#loss{label = coin_all, val = Cost}], Role) of
                {false, #loss{err_code = ErrCode}} ->
                    {false, exp_seal_pack(ErrCode, ?L(<<"金币不足，无法提升上限">>))};
                {ok, NewRole} ->
                    log:log(log_coin, {<<"经验封印">>, <<"提升上限">>, Role, NewRole}),
                    NewExpSeal = ExpSeal#exp_seal{top = exp_seal_data:get_exp_seal_top(Top)},
                    {ok, exp_seal_pack(1, ?L(<<"成功提升经验封印上限">>), NewExpSeal, Exp), NewRole#role{setting = Setting#setting{exp_seal = NewExpSeal}}}
            end
    end;
%% 释放封印经验
exp_seal(?exp_seal_opt_release, #role{setting = #setting{exp_seal = #exp_seal{status = ?exp_seal_status_zero}}}) ->
    {false, exp_seal_pack(0, ?L(<<"经验封印还没开启">>))};
exp_seal(?exp_seal_opt_release, #role{pos = #pos{map_base_id = MapBaseId}}) when MapBaseId < 10001 orelse MapBaseId > 10006 ->
    {false, exp_seal_pack(0, ?L(<<"当前场景不能进行该操作">>))};
exp_seal(?exp_seal_opt_release, #role{assets = #assets{seal_exp = 0}}) ->
    {false, exp_seal_pack(0, <<>>)};
exp_seal(?exp_seal_opt_release, #role{lev = Lev}) when Lev >= ?ROLE_LEV_LIMIT ->
    {false, exp_seal_pack(0, ?L(<<"您的人物等级已达上限，无法转换经验">>))};
exp_seal(?exp_seal_opt_release, Role = #role{lev = Lev, setting = Setting = #setting{exp_seal = ExpSeal}, assets = Assets = #assets{exp = NowExp, seal_exp = Exp}}) ->
    {_, _, RemainExp} = calc_upgrade(Lev, NowExp, Exp),
    AddExp = Exp - RemainExp,
    case role_gain:do([#gain{label = exp, val = AddExp}], Role#role{setting = Setting#setting{exp_seal = ExpSeal#exp_seal{status = ?exp_seal_status_close}}, assets = Assets#assets{seal_exp = RemainExp}}) of
        {ok, NewRole = #role{lev = NewLev, assets = #assets{exp = NewExp}}} ->
            log:log(log_handle_all, {14117, <<"经验封印转换">>, util:fbin("转换经验[~w], 转换前[~w,~w], 转换后[~w,~w]", [AddExp, Lev, NowExp, NewLev, NewExp]), NewRole}),
            {ok, exp_seal_pack(1, util:fbin(?L(<<"成功释放经验，您获得~w经验">>), [AddExp]), ExpSeal, RemainExp), NewRole#role{setting = Setting}};
        _ ->
            {false, exp_seal_pack(0, ?L(<<"经验转换失败">>))}
    end;
%% 容错
exp_seal(_, Role = #role{setting = #setting{exp_seal = ExpSeal}, assets = #assets{seal_exp = Exp}}) ->
    {ok, exp_seal_pack(1, <<>>, ExpSeal, Exp), Role}.

%% @spec handle_exp_seal(ExpSeal, AddExp, Pid) -> {RemainExp, NewExpSeal}.
%% ExpSeal = #exp_seal{}, AddExp = RemainExp = integer, Pid = pid()
%% @doc 获得经验时处理经验封印
handle_exp_seal(ExpSeal = #exp_seal{status = Status, top = Top}, Exp, AddExp, Pid) ->
    case Status of
        ?exp_seal_status_open ->
            Space = Top - Exp,
            case Space > AddExp of
                true ->
                    NewExp = Exp + AddExp,
                    {0, ExpSeal, NewExp};
                false ->
                    NewExpSeal = ExpSeal#exp_seal{status = ?exp_seal_status_close},
                    role:pack_send(Pid, 14117, exp_seal_pack(1, <<>>, NewExpSeal, Top)),
                    {AddExp - Space, NewExpSeal, Top}
            end;
        _ ->
            {AddExp, ExpSeal, Exp}
    end.

%% ------------------------------
%% 内部函数
%% ------------------------------
check_password(P) when is_bitstring(P) ->
    check_password(bitstring_to_list(P));
check_password(P) when is_list(P)->
    if
        length(P) < 6 -> {false, ?L(<<"密码长度不能小于6">>)};
        length(P) > 10 -> {false, ?L(<<"密码长度不能大于10">>)};
        true -> true
    end;
check_password(_) -> {false, ?L(<<"密码输入不正确">>)}.

check_question(Q1, Q2) ->
    {ok, Al1} = asn1rt:utf8_binary_to_list(Q1),
    {ok, Al2} = asn1rt:utf8_binary_to_list(Q2),
    L1 = length(Al1),
    L2 = length(Al2),
    if
        L1 < 2 orelse L2 < 2 -> {false, ?L(<<"密保问题太短!">>)};
        L1 > 20 orelse L2 > 20 -> {false, ?L(<<"密保问题太长!">>)};
        true -> true
    end.

check_answer(A1, A2) ->
    {ok, Al1} = asn1rt:utf8_binary_to_list(A1),
    {ok, Al2} = asn1rt:utf8_binary_to_list(A2),
    L1 = length(Al1),
    L2 = length(Al2),
    if
        L1 < 2 orelse L2 < 2 -> {false, ?L(<<"密保答案太短!">>)};
        L1 > 20 orelse L2 > 20 -> {false, ?L(<<"密保答案太长!">>)};
        true -> true
    end.

%% 经验封印返回数据
exp_seal_pack(Flag, Msg, #exp_seal{status = Status, top = Top}, Exp) ->
    {Flag, Msg, Status, Top, Exp, exp_seal_data:get_exp_seal_top(Top), exp_seal_data:get_exp_seal_cost(Top)}.
exp_seal_pack(Flag, Msg) when Flag =/= 1 ->
    {Flag, Msg, 0, 0, 0, 0, 0}.

%% 判断并计算升级
calc_upgrade(?ROLE_LEV_LIMIT, _Now, Val) -> {?ROLE_LEV_LIMIT, 0, Val}; %% 等级限制
calc_upgrade(Lev, Now, Val) ->
    Need = role_exp_data:get(Lev),
    case Now + Val >= Need of
        true ->
            calc_upgrade(Lev + 1, 0, Now + Val - Need);
        false ->
            {Lev, Now + Val, 0}
    end.
