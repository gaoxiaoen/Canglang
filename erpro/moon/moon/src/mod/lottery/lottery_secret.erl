%% *********************************
%% 幻灵秘境功能模块
%% @author lishen@jieyou.com
%% *********************************
-module(lottery_secret).
-export([
        get_free_time/1
        ,login/1
        ,reset_time/1
        ,combat_start/1
        ,combat_over/2
        ,get_secret_info/1
        ,handle_win/1
        ,gm_set_num/2
    ]).

-include("role.hrl").
-include("lottery_secret.hrl").
-include("looks.hrl").
%%
-include("combat.hrl").
-include("arena_career.hrl").
-include("pet.hrl").
-include("gain.hrl").
-include("buff.hrl").
-include("attr.hrl").
-include("common.hrl").
-include("demon.hrl").
-include("assets.hrl").

%%----------------------------------------------------
%% GM命令
%%----------------------------------------------------
%% 设置采集次数
gm_set_num(Role = #role{pid = Pid, secret = Secret}, Num) ->
    NewRole = Role#role{secret = Secret#secret{num = Num}},
    role:pack_send(Pid, 14723, get_secret_info(NewRole)),
    {ok, NewRole}.

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
%% @spec get_free_time(Num) -> integer().
%% @doc 计算免费次数
get_free_time(Num) ->
    case Num =:= 0 of
        true -> 1;
        false -> 0
    end.

%% @spec login(Role) -> NewRole.
%% @doc 角色登录处理
login(Role = #role{secret = Secret = #secret{last_time = LastTime}}) ->
    Today = util:unixtime(today),
    NewSecret = case LastTime < Today of
        true ->
            Secret#secret{num = 0, exp = 0};
        false ->
            Secret
    end,
    Tomorrow = Today + 86400,
    role_timer:set_timer(reset_time, (Tomorrow - util:unixtime()) * 1000, {lottery_secret, reset_time, []}, 1, Role#role{secret = NewSecret}).

%% @spec reset_time(Role) -> {ok, NewRole}.
%% @doc 重置采集次数
reset_time(Role = #role{secret = Secret = #secret{last_time = LastTime}}) ->
    Today = util:unixtime(today),
    NewSecret = case LastTime < Today of
        true ->
            Secret#secret{num = 0, exp = 0};
        false ->
            Secret
    end,
    Tomorrow = Today + 86400,
    {ok, role_timer:set_timer(reset_time, (Tomorrow - util:unixtime()) * 1000, {lottery_secret, reset_time, []}, 1, Role#role{secret = NewSecret})}.

%% @spec combat_start(Role) -> {ok, NewRole} | {false, Reason}
%% @doc 战斗开始
combat_start(Role = #role{lev = Lev, assets = #assets{gold = Gold}, secret = #secret{num = Num}, sex = Sex, career = Career, mp_max = MpMax, attr = Attr, skill = Skill}) when Lev >= 40 andalso Lev < 99 ->
    NextNum = Num + 1,
    case Gold < secret_data:cost_gold(Lev, NextNum) of
        true ->
            {false, ?L(<<"晶钻不足，不能采集仙果">>)};
        false ->
            case get_role(Lev, Sex, Career, MpMax, Attr, Skill, NextNum) of
                false ->
                    {false, ?L(<<"人物数据异常，无法进入秘境">>)};
                Foe ->
                    combat_type:check(?combat_type_lottery_secret, Role, Foe),
                    {ok}
            end
    end;
combat_start(_Role) ->
    {false, ?L(<<"您的修为已臻化境，仙果已经无法提升您的修为了。">>)}.

%% @spec get_secret_info(Role) -> {FreeNum, Num, Exp, AllExp, Gole}.
%% @doc 获取幻灵秘境信息
get_secret_info(#role{lev = Lev, secret = #secret{num = Num, exp = Exp}}) when Lev >= 40 andalso Lev < 90 ->
    NextNum = Num + 1,
    {lottery_secret:get_free_time(Num), Num, Exp, secret_data:get_exp(Lev, Num), secret_data:get_exp(Lev, NextNum), secret_data:cost_gold(Lev, NextNum)};
get_secret_info(_Role) ->
    {0, 0, 0, 0, 0, 0}.

%% @spec combat_over(Winner, Loser) -> ok.
%% @doc 战斗结束
combat_over(Winner, Loser) ->
    case [F || F <- Winner ++ Loser, F#fighter.group =:= group_atk] of
        [] ->
            ?ERR("幻灵秘境进攻者列表为空"),
            ok;
        [#fighter{pid = Pid}] ->
            case [F || F <- Winner, F#fighter.is_clone =:= 0] of
                [] ->            
                    role:pack_send(Pid, 10931, {57, ?L(<<"采摘仙果失败，无法获得经验奖励。">>), []}),
                    role:pack_send(Pid, 14725, {0, <<>>});
                _ ->
                    role:apply(async, Pid, {fun handle_win/1, []})
            end
    end.

%% @spec handle_win(Role) -> {ok, NewRole}
%% @doc 处理采集成功
handle_win(Role = #role{pid = Pid, lev = Lev, secret = Secret = #secret{num = Num, exp = Exp}}) ->
    NextNum = Num + 1,
    Val = secret_data:get_exp(Lev, NextNum),
    Gold = secret_data:cost_gold(Lev, NextNum),
    case role_gain:do([#loss{label = gold, val = Gold}], Role) of
        {false, _} ->
            {ok, Role};
        {ok, Role1} ->
            case role_gain:do([#gain{label = exp, val = Val}], Role1) of
                {ok, NewRole} ->
                    role:pack_send(Pid, 10931, {57, util:fbin(?L(<<"采摘仙果成功，获得~w经验奖励。">>), [Val]), []}),
                    notice:inform(util:fbin(?L(<<"获得{str,经验,#00ff24} ~w">>),[Val])),
                    NewRole1 = NewRole#role{secret = Secret#secret{num = NextNum, exp = Exp + Val, last_time = util:unixtime()}},
                    role:pack_send(Pid, 14723, get_secret_info(NewRole1)),
                    log:log(log_gold, {<<"幻灵秘境">>, util:fbin(<<"增加经验~w">>, [Val]), <<"幻灵秘境">>, Role, NewRole1}),
                    {ok, NewRole1};
                _ ->
                    {ok, Role}
            end
    end.

%%----------------------------------------------------
%% 私有函数
%%----------------------------------------------------
get_role(Lev, Sex, Career, MpMax, Attr, Skill, Num) ->
    case secret_data:get_foe(Lev, Num, Career, Sex) of
        false -> false;
        {Name, _AttrEx, AI, Looks, FightCapacity, HpMax, AttrList} ->
            NewAttr = calc_attr(AttrList, Attr#attr{fight_capacity = FightCapacity}),
            #role{id = {0, <<>>}, name = Name, sex = Sex, career = Career, lev = Lev, hp = HpMax, mp = MpMax, hp_max = HpMax, mp_max = MpMax, attr = NewAttr, looks = Looks, pet = #pet_bag{}, skill = Skill, demon = demon:init(), secret = AI}
    end.

calc_attr([], Attr) -> Attr;
calc_attr([{aspd, Val} | T], Attr) ->
    calc_attr(T, Attr#attr{aspd = Val});
calc_attr([{defence, Val} | T], Attr) ->
    calc_attr(T, Attr#attr{defence = Val});
calc_attr([{dmg_min, Val} | T], Attr) ->
    calc_attr(T, Attr#attr{dmg_min = Val});
calc_attr([{dmg_max, Val} | T], Attr) ->
    calc_attr(T, Attr#attr{dmg_max = Val});
calc_attr([{dmg_magic, Val} | T], Attr) ->
    calc_attr(T, Attr#attr{dmg_magic = Val});
calc_attr([{hitrate, Val} | T], Attr) ->
    calc_attr(T, Attr#attr{hitrate = Val});
calc_attr([{evasion, Val} | T], Attr) ->
    calc_attr(T, Attr#attr{evasion = Val});
calc_attr([{critrate, Val} | T], Attr) ->
    calc_attr(T, Attr#attr{critrate = Val});
calc_attr([{tenacity, Val} | T], Attr) ->
    calc_attr(T, Attr#attr{tenacity = Val}).
