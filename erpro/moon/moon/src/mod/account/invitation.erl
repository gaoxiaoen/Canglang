%%----------------------------------------------------
%% 注册邀请码进程
%% 
%% @author qingxuan
%% @end
%%----------------------------------------------------
-module(invitation).
-behaviour(gen_server).
-export([
    get_invitee_code/2
    ,gen_code/1
    ,level_up/1
    ,login/1
    ,invitee_num/1
    ,is_valid_code/2
]).
-export([
    start_link/0
]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("invitation.hrl").
-include("role.hrl").
%%

-record(state, {
    next_seed = 0       
}).

get_invitee_code(_Account, <<>>) ->
    <<>>;
get_invitee_code(Account, DeviceId) ->
    case ets:lookup(?MODULE, Account) of %% 每次登录都要读取，所以这里加了ets作缓存
        [{Account, Code}|_] -> Code;
        _ -> 
            case db:get_one("SELECT `code` FROM `reg_invitation` WHERE `account`=~s LIMIT 1", [Account]) of
                {ok, Code} ->
                    ets:insert(?MODULE, {Account, Code}), %% 加缓存
                    Code;
                _ ->
                    case db:get_one("SELECT `code` FROM `reg_invitation` WHERE `device_id`=~s LIMIT 1", [DeviceId]) of
                        {ok, Code} ->
                            ets:insert(?MODULE, {Account, Code}),
                            add_row(Account, DeviceId, Code),
                            Code;
                        _ ->
                            <<>>
                    end
            end
    end.

%% -> any()
use_code(Role, _Code = <<>>) ->
    Role;
use_code(Role = #role{id = {RoleId, SrvId}, account = Account, login_info = #login_info{device_id = DeviceId}}, Code) ->
    case get_invitee_code(Account, DeviceId) of
        <<>> -> % 没有历史记录，完全的新玩家
            add_history_code(Account, DeviceId, Code),
            invitation_code_counter_up(Code),
            send_invitee_award(RoleId, SrvId),
            Role;
        _OldCode -> %% 有使用过邀请码的老玩家，肯定是合法的邀请码
            send_invitee_award(RoleId, SrvId),
            Role
    end.

%% -> true | false
is_valid_code(Acc, Code) ->
    %% 这里不使用ets作缓存，直接存取db，因考虑到创建角色不多，使用邀请码的不多，而且缓存命中不高
    case db:get_row("SELECT `role_id`, `srv_id`, `account` FROM `invitation_code` WHERE `code`=~s LIMIT 1", [Code]) of
        {ok, [_RoleId, _SrvId, Account]} ->
            case Account =:= Acc of
                true -> false; %% 不能自己邀请自己
                _ -> true
            end;
        _ ->
            false
    end.

add_history_code(Account, DeviceId, Code) ->
    ets:insert(?MODULE, {Account, Code}),
    add_row(Account, DeviceId, Code).    

send_invitee_award(RoleId, SrvId) ->
    ?DEBUG("发invitee奖励"),
    award:send({RoleId, SrvId}, ?invitee_award_baseid).

send_inviter_award(RoleId, SrvId, 1) ->
    ?DEBUG("发inviter奖励1"),
    award:send({RoleId, SrvId}, ?inviter_1_award_baseid);
send_inviter_award(RoleId, SrvId, 2) ->
    ?DEBUG("发inviter奖励2"),
    award:send({RoleId, SrvId}, ?inviter_2_award_baseid);
send_inviter_award(RoleId, SrvId, 3) ->
    ?DEBUG("发inviter奖励3"),
    award:send({RoleId, SrvId}, ?inviter_3_award_baseid);
send_inviter_award(RoleId, SrvId, 4) ->
    ?DEBUG("发inviter奖励4"),
    award:send({RoleId, SrvId}, ?inviter_4_award_baseid);
send_inviter_award(RoleId, SrvId, 5) ->
    ?DEBUG("发inviter奖励5"),
    award:send({RoleId, SrvId}, ?inviter_5_award_baseid);
send_inviter_award(_RoleId, _SrvId, _Num) ->
    ignore.

invitation_code_counter_up(Code) ->
    gen_server:call(?MODULE, {invitation_code_counter_up, Code}),
    ok.

%% -> {ok, #role{}}
gen_code(Role = #role{id = {RoleId, SrvId}, account = Account, lev = Lev, invitation = Invitation}) when Lev >= ?inviter_gen_code_lev ->
    NewInvitation = case Invitation of
        undefined ->
            case gen_server:call(?MODULE, {gen_code, Account, RoleId, SrvId}, infinity) of
                error -> Invitation;
                Code ->
                    #invitation{
                        code = Code
                    }
            end;
        #invitation{code = <<>>} ->
            case gen_server:call(?MODULE, {gen_code, Account, RoleId, SrvId}, infinity) of
                error -> Invitation;
                Code ->
                    Invitation#invitation{
                        code = Code
                    }
            end;
        #invitation{code = _Code} ->
            Invitation
    end,
    {ok, Role#role{
        invitation = NewInvitation
    }};
gen_code(Role) ->
    {ok, Role}.

%% -> any()
level_up(_Role = #role{lev = Lev}) when Lev < ?inviter_gen_code_lev ->
    ignore;
level_up(#role{id = {RoleId, SrvId}}) ->
    gen_server:cast(?MODULE, {inviter_level_up, RoleId, SrvId}).

%% -> #role{}
login(Role = #role{login_info = #login_info{last_login = LastLogin, reg_code = RegCode}}) ->
    %% 邀请都的处理
    Role3 = case gen_code(Role) of
        {ok, Role2} -> Role2;
        _ -> Role
    end,
    %% 被邀请者的处理
    case LastLogin =:= 0 andalso RegCode =/= <<>> of
        true ->
            ?DEBUG("REG LOGIN !!!!!!!!!"),
            use_code(Role3, RegCode);
        _ ->
            ?DEBUG("NORMAL LOGIN !!!!!!!!!"),
            Role3
    end.

%% 已招募的人数
invitee_num(Code) ->
    case db:get_one("SELECT `num` FROM `invitation_code` WHERE `code`=~s LIMIT 1", [Code]) of
        {ok, Num} when is_integer(Num) -> Num;
        _ -> 0
    end.

%%----------------------------------------------------

%% @doc 
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    ets:new(?MODULE, [public, named_table, set]),
    ets:new(invitation_code, [protected, named_table, set]),
    case db_get_seed() of
        Seed when is_integer(Seed) ->
            ?INFO("[~w] 启动完成", [?MODULE]),
            {ok, #state{next_seed = next_seed(Seed)}};
        Error ->
            ?INFO("[~w] 启动失败 ~p", [?MODULE, Error]),
            {stop, Error}  
    end.

handle_call({gen_code, Account, RoleId, SrvId}, _From, State = #state{next_seed = Seed}) ->
    Code = integer_to_hash(Seed),
    case db_save_code(Account, RoleId, SrvId, Seed, Code) of
        true ->
            {reply, Code, State#state{next_seed = next_seed(Seed)}};
        _ ->
            {reply, error, State}
    end;

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast({inviter_level_up, RoleId, SrvId}, State) ->
    case role_api:get_pid({RoleId, SrvId}) of
        undefined -> ignore;
        Pid -> role:apply(async, Pid, {fun gen_code/1, []})
    end,
    {noreply, State};

handle_cast({invitation_code_counter_up, Code}, State) ->
    case db:get_row("SELECT role_id, srv_id, num FROM invitation_code WHERE code=~s LIMIT 1", [Code]) of
        {ok, [RoleId, SrvId, Num]} ->
            db:execute("UPDATE invitation_code SET num=num+1 WHERE code=~s", [Code]),
            send_inviter_award(RoleId, SrvId, Num + 1);
        _ ->
            ignore    
    end,
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------
next_seed(Seed) ->
    Seed + util:rand(10, 100).

integer_to_hash(N) ->
    SL = integer_to_hash(N, []),
    CL = "2NH8ZPYS4XFKJD6MT5UQV39W0AEGR7IB1COL",  %% 全服统一不变化，为避免合服产生麻烦
    list_to_binary([lists:nth(I+1, CL) || I <- SL ]).

integer_to_hash(N, L) ->
    Div = N div 36,
    Rem = N rem 36,
    case Div >= 36 of
        true -> integer_to_hash(Div, [Rem|L]);
        _ ->
            case Div > 0 of
                true -> [Div, Rem|L];
                _ -> [Rem|L]
            end
    end.

db_get_seed() ->
    case db:get_one("SELECT IFNULL(max(seed), 36*36*36*36) FROM `invitation_code`") of
        {ok, Max} -> Max;
        _ -> error
    end.

add_row(Account, DeviceId, Code) ->
    db:execute("INSERT INTO `reg_invitation` (`account`, `device_id`, `code`, `time`) VALUES (~s, ~s, ~s, ~s)", [Account, DeviceId, Code, util:unixtime()]).

db_save_code(Account, RoleId, SrvId, Seed, Code) ->
    case db:execute("INSERT INTO `invitation_code` (`seed`, `code`, `account`, `role_id`, `srv_id`, `time`, `num`) VALUES (~s, ~s, ~s, ~s, ~s, ~s, 0) ON DUPLICATE KEY UPDATE `time`=`time`", [Seed, Code, Account, RoleId, SrvId, util:unixtime()]) of
        {ok, 1} -> true;
        _ -> false
    end.
