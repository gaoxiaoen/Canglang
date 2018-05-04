%%----------------------------------------------------
%%  职业进阶相关处理
%% @author wpf(wprehard@qq.com)
%%----------------------------------------------------

-module(ascend).
-export([
        init/0
        ,ver_parse/1
        ,login/1
        ,career_ascend/2
        ,ascend_cast/2
        ,get_face_id/3
        ,get_ascend/1
        ,get_ascend/2
        ,get_ascend_str/1
        ,check_is_ascend/1
        ,calc/1
    ]).
-include("common.hrl").
-include("ascend.hrl").
-include("looks.hrl").
-include("role.hrl").
-include("link.hrl").
-include("skill.hrl").
-include("item.hrl").
-include("storage.hrl").

%% @spec init() -> #ascend{}
%% 初始化职业进阶信息
init() ->
    #ascend{}.

%% @spec ver_parse(Ascend) -> #ascend{}
%% 初始化职业进阶信息
ver_parse(Ascend = #ascend{ver = ?ROLE_ASCEND_VER}) ->
    Ascend;
ver_parse(_) ->
    init().

%% @spec login(Role) -> NewRole
%% @doc 角色登陆
login(Role = #role{career = Career, ascend = #ascend{direct = Directs}}) ->
    %% 增加进阶标识
    case lists:keyfind(Career, 1, Directs) of
        false -> Role;
        {Career, AscendType, _} ->
            looks:add(Role, ?LOOKS_TYPE_CAREER_ASCEND, Career, AscendType)
    end.

%% @spec get_ascend(Data) -> integer()
%% @doc 获取玩家的职业进阶方向
get_ascend(#role{career = Career, ascend = Ascend}) ->
    get_ascend(Career, Ascend).

get_ascend(Career, #ascend{direct = Direct}) ->
    case lists:keyfind(Career, 1, Direct) of
        false -> 0;
        {_, AscendType, _} -> AscendType
    end.

%% @spec get_ascend_str(Data) -> bitstring()
%% @doc 获取玩家的职业进阶方向
get_ascend_str(Role = #role{career = Career}) ->
    do_to_str(Career, get_ascend(Role)).

%% @spec career_ascend(AscendType, Role) -> NewRole
%% NewRole = Role = #role{}
%% @doc 职业进阶
career_ascend(AscendType, Role = #role{skill = SA = #skill_all{skill_list = SkillList}, career = Career, ascend = Ascend = #ascend{direct = Directs}, link = #link{conn_pid = ConnPid}}) ->
    %% 技能进阶
    NewList = skill:skill_ascend(AscendType, SkillList),
    Now = util:unixtime(),
    NewDirects = update_ascend_info(Directs, {Career, AscendType, Now}),
    Role00 = Role#role{skill = SA#skill_all{skill_list = NewList}, ascend = Ascend#ascend{direct = NewDirects}},
    Role0 = skill:clean_shortcuts_list(Role00),
    sys_conn:pack_send(ConnPid, 11500, skill:pack_proto_msg(11500, NewList)),
    sys_conn:pack_send(ConnPid, 11561, {AscendType, Now}),
    skill:push_break_out(Role0),
    %% 头像更新
    Role1 = case vip:set_face_push(Role0, vip:get_face_id(Role0)) of
        {ok, R} -> R;
        _ -> Role0
    end,
    %% 播放特效
    map:role_update(looks:add(Role1, ?LOOKS_TYPE_CAREER_ASCEND_EFFECT, 0, 0)),
    notice:effect(11, <<>>),
    %% 洗练技能附加更新
    eqm_api:find_skill_attr_push(Role1),
    %% 更新时装
    Role2 = case update_ascend_eqm(Role1) of
        {ok, NRole1} -> NRole1;
        _ -> Role1
    end,
    %% 增加标识并广播
    NewRole1 = looks:add(Role2, ?LOOKS_TYPE_CAREER_ASCEND, Career, AscendType),
    map:role_update(NewRole1),
    NewRole = role_listener:special_event(NewRole1, {1064, 1}),
    %% 推送属性
    role_api:push_attr(NewRole).

%% @spec calc(Role) -> NewRole;
%% @doc 计算职业进阶的属性附加
calc(Role = #role{ascend = undefined}) -> Role;
calc(Role = #role{career = Career, ascend = #ascend{direct = Directs}}) ->
    case lists:keyfind(Career, 1, Directs) of
        false -> Role;
        {_, AscendType, _} ->
            Attrs = get_attr(Career, AscendType),
            case role_attr:do_attr(Attrs, Role) of
                {ok, NewRole} -> NewRole;
                _ -> Role
            end
    end.

%% @spec check_is_ascend(Role) -> true | false
%% @doc 是否已进阶
check_is_ascend(#role{lev = Lev}) when Lev < 72 -> false;
check_is_ascend(#role{career = Career, ascend = #ascend{direct = Directs}}) ->
    case lists:keyfind(Career, 1, Directs) of
        false -> false;
        _ -> true
    end.

%% @spec ascend_cast(Role, AscendType) -> any()
%% @doc 公告
ascend_cast(Role = #role{career = Career}, {OldAscendType, AscendType}) ->
    RoleMsg = notice:role_to_msg(Role),
    {_, AscendStr} = to_str(Career, AscendType),
    {_, OldAscendStr} = to_str(Career, OldAscendType),
    util:fbin(?L(<<"神人诞生！~s经过了重重历练，终于由【~s】成功飞升为一名【~s】，获得了传说中的飞升力量！{open,55,我要飞升,#00ff24}">>), [RoleMsg, OldAscendStr, AscendStr]);
ascend_cast(Role = #role{career = Career}, AscendType) ->
    RoleMsg = notice:role_to_msg(Role),
    {CareerStr, AscendStr} = to_str(Career, AscendType),
    util:fbin(?L(<<"神人诞生！~s经过了重重历练，终于由【~s】成功飞升为一名【~s】，获得了传说中的飞升力量！{open,55,我要飞升,#00ff24}">>), [RoleMsg, CareerStr, AscendStr]).

%% 获取进阶后的头像
get_face_id(Career, Sex, #ascend{direct = Directs}) ->
    case lists:keyfind(Career, 1, Directs) of
        false ->
            vip:get_face_id(Career, Sex);
        {Career, AT, _} ->
            get_face_id(Career, AT, Sex)
    end;
get_face_id(?career_zhenwu, 1, 1) -> 2100;
get_face_id(?career_zhenwu, 1, 0) -> 2100;
get_face_id(?career_zhenwu, 2, 1) -> 2100;
get_face_id(?career_zhenwu, 2, 0) -> 2100;
get_face_id(?career_cike, 1, 1) -> 2100;
get_face_id(?career_cike, 1, 0) -> 2100;
get_face_id(?career_cike, 2, 1) -> 2100;
get_face_id(?career_cike, 2, 0) -> 2100;
get_face_id(?career_xianzhe, 1, 1) -> 3100;
get_face_id(?career_xianzhe, 1, 0) -> 3100;
get_face_id(?career_xianzhe, 2, 1) -> 3100;
get_face_id(?career_xianzhe, 2, 0) -> 3100;
get_face_id(?career_feiyu, 1, 1) -> 5100;
get_face_id(?career_feiyu, 1, 0) -> 5100;
get_face_id(?career_feiyu, 2, 1) -> 5100;
get_face_id(?career_feiyu, 2, 0) -> 5100;
get_face_id(?career_qishi, 1, 1) -> 5100;
get_face_id(?career_qishi, 1, 0) -> 5100;
get_face_id(?career_qishi, 2, 1) -> 5100;
get_face_id(?career_qishi, 2, 0) -> 5100.




update_ascend_eqm(Role = #role{eqm = ItemList, link = #link{conn_pid = ConnPid}, dress = _Dress}) ->
    case [It || It = #item{type = ?item_shi_zhuang} <- ItemList] of
        [Item = #item{base_id = BaseId}] ->
            case item_data:get(BaseId) of
                {ok, #item_base{condition = Conds}} ->
                    case role_cond:check(Conds, Role) of
                        {false, _} ->
                            storage_api:del_item_info(ConnPid, [{?storage_eqm, Item}]),
                            %% sys_conn:pack_send(ConnPid, 10342, {Dress}),
                            {ok, looks:calc(Role#role{eqm = (ItemList -- [Item])})};
                        _ -> ignore 
                    end;
                _ -> ignore 
            end;
        _ -> ignore 
    end.

%% -----------------------------------------------------------------
%% 内部函数
%% -----------------------------------------------------------------

%% 更新职业进阶信息列表
update_ascend_info(Directs, {Career, AscendType, Time}) ->
    case lists:keyfind(Career, 1, Directs) of
        false -> [{Career, AscendType, Time} | Directs];
        {Career, _, _} -> lists:keyreplace(Career, 1, Directs, {Career, AscendType, Time})
    end.

to_str(1, 1) -> {?L(<<"真武">>), ?L(<<"{handle,53,武神,#0088ff,1,1}">>)};
to_str(1, 2) -> {?L(<<"真武">>), ?L(<<"{handle,53,狂战,#ffff00,1,2}">>)};
to_str(2, 1) -> {?L(<<"刺客">>), ?L(<<"{handle,53,毒仙,#0088ff,2,1}">>)};
to_str(2, 2) -> {?L(<<"刺客">>), ?L(<<"{handle,53,杀神,#ffff00,2,2}">>)};
to_str(3, 1) -> {?L(<<"贤者">>), ?L(<<"{handle,53,医圣,#0088ff,3,1}">>)};
to_str(3, 2) -> {?L(<<"贤者">>), ?L(<<"{handle,53,法圣,#ffff00,3,2}">>)};
to_str(4, 1) -> {?L(<<"飞羽">>), ?L(<<"{handle,53,羽神,#0088ff,4,1}">>)};
to_str(4, 2) -> {?L(<<"飞羽">>), ?L(<<"{handle,53,箭圣,#ffff00,4,2}">>)};
to_str(5, 1) -> {?L(<<"骑士">>), ?L(<<"{handle,53,帝尊,#0088ff,5,1}">>)};
to_str(5, 2) -> {?L(<<"骑士">>), ?L(<<"{handle,53,怒焰,#ffff00,5,2}">>)};
to_str(_, _) -> {<<>>, <<>>}.

do_to_str(1, 1) -> <<"武神">>;
do_to_str(1, 2) -> <<"狂战">>;
do_to_str(2, 1) -> <<"毒仙">>;
do_to_str(2, 2) -> <<"杀神">>;
do_to_str(3, 1) -> <<"医圣">>;
do_to_str(3, 2) -> <<"法圣">>;
do_to_str(4, 1) -> <<"羽神">>;
do_to_str(4, 2) -> <<"箭圣">>;
do_to_str(5, 1) -> <<"帝尊">>;
do_to_str(5, 2) -> <<"怒焰">>;
do_to_str(_, _) -> <<>>.

%% 不同职业方向对应的进阶附加属性
%% 职业	转职名称	方向	附加属性
%% 真武	武神	生存控制	气血+3000，坚韧+50
%% 真武	狂战	低血爆发	攻击+500，暴击+50
%% 刺客	毒仙	毒          暴击+50，毒抗+100
%% 刺客	杀神	速度躲闪	闪避+50，敏捷+1
%% 贤者	医圣	回复辅助	精神+80，气血+1000
%% 贤者	法圣	法伤输出	攻击+400，法伤+400
%% 飞羽	羽神	精准命中	命中+50，闪躲+30
%% 飞羽	箭圣	群攻        攻击+500，暴击+50
%% 骑士	帝尊	生存防守	气血+3000，防御+2000
%% 骑士	怒焰	输出方向	攻击+500，暴击+50
get_attr(1, 1) -> [{hp_max, 3000}, {tenacity, 50}]; %% 真武
get_attr(1, 2) -> [{dmg, 500}, {critrate, 50}];
get_attr(2, 1) -> [{anti_poison, 100}, {critrate, 50}];
get_attr(2, 2) -> [{evasion, 50}, {aspd, 1}];
get_attr(3, 1) -> [{js, 80}, {hp_max, 1000}];
get_attr(3, 2) -> [{dmg, 400}, {dmg_magic, 400}];
get_attr(4, 1) -> [{hitrate, 50}, {evasion, 30}];
get_attr(4, 2) -> [{dmg, 500}, {critrate, 50}];
get_attr(5, 1) -> [{hp_max, 3000}, {defence, 2000}];
get_attr(5, 2) -> [{dmg, 500}, {critrate, 50}];
get_attr(_, _) -> [].
