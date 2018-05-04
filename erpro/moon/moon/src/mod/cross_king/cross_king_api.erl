%% --------------------------------------------------------------------
%% 跨服至尊相关接口
%% @author shawn 
%% @end
%% --------------------------------------------------------------------
-module(cross_king_api).
-export(
    [
        role_enter/1
        ,inform_center/1
        ,call_center/1
        ,send_mail/7
        ,send_kill_mail/3
        ,get_looks/1
        ,broadcast/1
    ]
).

-include("role.hrl").
-include("common.hrl").
-include("attr.hrl").
-include("cross_king.hrl").
-include("pet.hrl").
-include("mail.hrl").
-include("vip.hrl").
-include("max_fc.hrl").

%% @spec role_enter(Role) -> {false, Msg} | ok
%% Role = #role{}
role_enter(Role) ->
    case check_enter_pre(Role) of
        {false, Msg} -> {false, Msg};
        ok ->
            KingRole = convert(init, Role),
            center:cast(cross_king_mgr, role_enter, [KingRole]),
            ok
    end.

check_enter_pre(#role{lev = Lev, attr = #attr{fight_capacity = FightCapacity}}) ->
    case Lev < 52 of
        true -> {false, ?L(<<"角色等级不足52级, 无法参加至尊王者战">>)};
        false ->
            case FightCapacity < 8000 of
                true ->
                    {false, ?L(<<"角色战斗力不足8000，无法参加至尊王者">>)};
                false -> ok
            end
    end.

convert(init, #role{id = Id, name = Name, sex = Sex, pid = Pid, lev = Lev, vip = #vip{type = VipType}, career = Career, max_fc = #max_fc{max = FightCapacity}, pet = #pet_bag{active = Pet}}) ->
    PetFight = case Pet of
        #pet{fight_capacity = PetFight1} -> PetFight1;
        _ -> 0
    end,
    #cross_king_role{id = Id, name = Name, sex = Sex, pid = Pid, vip = VipType, lev = Lev, career = Career, fight_capacity = FightCapacity, pet_fight = PetFight}.

%% @spec inform_center(Msg) -> any()
%% @doc 通知中央服跨服boss进程
inform_center(Msg) ->
    center:cast(cross_king_mgr, info, [Msg]).

call_center(Msg) ->
    center:call(cross_king_mgr, call, [Msg]).

%% @spec get_looks(RoleId) -> Looks :: list()
%% @doc 节点服调用，获取外观
get_looks(RoleId) ->
    case role_api:lookup(by_id, RoleId, #role.looks) of
        {ok, _, Looks} -> Looks;
        _ ->
            case role_data:fetch_role(by_id, RoleId) of
                {ok, Role} ->
                    #role{looks = Looks} = setting:dress_login_init(Role),
                    Looks;
                _ ->
                    []
            end
    end.

send_mail({Rid, SrvId}, Name, _Flag, 0, Death, Lev, Score) -> %% 屌丝邮件
    Exp = erlang:round(800 * math:pow(Lev, 1.55) * Score / (Score + 40000)),
    Num = erlang:round((math:pow(Score, 0.5) / 60) + Death),
    Award = [{?mail_exp, Exp}],
    StoneNum = erlang:round(Num / 3),
    StoneItem = do_get_stone(StoneNum), 
    Items = case Num =:= 0 of
        true -> [];
        false -> [{33114, 1, Num} | StoneItem]
    end,
    Subject = ?L(<<"至尊王者赛奖励">>),
    Content = util:fbin(?L(<<"本次至尊王者赛结束，您的求道值为~w，根据您的求道值和死亡次数，您获得了~w个灵魂水晶和~w经验，请查收！">>), [Score, Num, Exp]),
    campaign_reward:handle(doing, {Rid, SrvId, Name}, cross_king),
    campaign_listener:handle(king_kills, {Rid, SrvId}, 0),
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, Award, Items});

send_mail({Rid, SrvId}, Name, _Flag, 1, Death, Lev, Score) -> %% 高富帅
    Exp = erlang:round(1000 * math:pow(Lev, 1.55) * Score / (Score + 10)),
    Award = [{?mail_exp, Exp}],
    Num = erlang:round(Score + Death * 2),
    StoneNum = erlang:round(Num / 3),
    StoneItem = do_get_stone(StoneNum), 
    Items = case Num =:= 0 of
        true -> [];
        false -> [{33114, 1, Num} | StoneItem]
    end,
    Subject = ?L(<<"至尊王者赛奖励">>),
    Content = util:fbin(?L(<<"本次至尊王者赛结束，您的连斩数为~w，根据您的连斩数和死亡次数，您获得了~w个灵魂水晶和~w经验，请查收！">>), [Score, Num, Exp]),
    campaign_reward:handle(doing, {Rid, SrvId, Name}, cross_king),
    campaign_listener:handle(king_kills, {Rid, SrvId}, Score),
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, Award, Items}).

send_kill_mail(Rid, SrvId, Name) ->
    Subject = ?L(<<"至尊王者击杀王者奖励">>),
    Content = ?L(<<"恭喜本战区成功击败王者一次，获得1个灵魂水晶！">>),
    Items = [{33114, 1, 1}],
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items}).

broadcast(RoleList) ->
    broadcast(RoleList, length(RoleList), <<"">>).
broadcast([], L, BinList) ->
    sys_env:set(cross_king_rank_king_1, undefined),
    sys_env:set(cross_king_rank_king_2, undefined),
    notice:send(54, util:fbin(?L(<<"至尊王者赛正式结束，恭喜~s成为本次王者排名前~w名，一时声名大噪，威震寰宇！">>), [BinList, L]));
broadcast([{Rid, SrvId, Name} | T], L, BinList) ->
    B = notice:role_to_msg({Rid, SrvId, Name}),
    case BinList of
        <<"">> -> broadcast(T, L, B);
        _ -> broadcast(T, L, util:fbin(<<"~s、~s">>, [BinList, B]))
    end.

do_get_stone(StoneNum) ->
    do_get_stone(StoneNum, [{26020, 12}, {26021, 25}, {26022, 5}, {26023, 15}, {26024, 12}, {26025, 12}, {26026, 8}, {26027, 8}, {26028, 3}], []).

do_get_stone(0, _, StoneItem) -> StoneItem;
do_get_stone(Num, L, StoneItem) ->
    case get_rand(L) of
        0 -> do_get_stone(Num - 1, L, StoneItem);
        BaseId ->
            case lists:keyfind(BaseId, 1, StoneItem) of
                false ->
                    do_get_stone(Num - 1, L, [{BaseId, 1, 1} | StoneItem]);
                {BaseId, _, BaseIdNum} ->
                    do_get_stone(Num - 1, L, lists:keyreplace(BaseId, 1, StoneItem, {BaseId, 1, BaseIdNum + 1}))
            end
    end.

get_rand(L) ->
    Seed = util:rand(1, 100),
    get_rand(Seed, L).

get_rand(_Seed, []) -> 0;
get_rand(Seed, [{BaseId, Rand} | T]) ->
    case Seed =< Rand of
        true -> BaseId;
        false -> get_rand(Seed - Rand, T)
    end.
