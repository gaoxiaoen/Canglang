%%----------------------------------------------------
%% 物品使用效果处理
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(item_effect).
-export([
        do/2
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("assets.hrl").
%%
-include("sns.hrl").
-include("link.hrl").
-include("pet.hrl").

%% 处理使用效果
%% @spec do(Effect, Role) -> {ok, NewRole} | {false, Reason}
%% Effect = list()  使用效果配置数据
%% Role = NewRole = #role{} 角色数据
%% Reason = binary() 处理失败原因

do([], Role) -> {ok, Role};
do([H | T], Role) ->
    case do(H, Role) of
        {ok, Nr} -> do(T, Nr);
        {false, Reason} -> {false, Reason}
    end;

%% 回复血量
do({hp, Val}, Role = #role{hp = Hp, hp_max = HpMax}) ->
    V = if
        Hp + Val > HpMax -> HpMax;
        true -> Hp + Val
    end,
    {ok, Role#role{hp = V}};

%% 回复法术
do({mp, Val}, Role = #role{mp = Mp, mp_max = MpMax}) ->
    V = if
        Mp + Val > MpMax -> MpMax;
        true -> Mp + Val
    end,
    {ok, Role#role{mp = V}};

%% 变身
do({change_mode, Label}, Role) ->
    case buff:add(Role, Label) of
        {false, Reason} -> {false, Reason};
        {ok, NewRole} ->
            Nr = looks:calc(NewRole),
            {ok, Nr}
    end;

%% 坐骑变身
do({mount_buff, Label}, Role) ->
    case buff:add(Role, Label) of
        {false, Reason} -> {false, Reason};
        {ok, NewRole} ->
            case mount:add_buff_skin(Label, NewRole) of
                {false, Reason} -> {false, Reason};
                {ok, Nr} -> {ok, Nr}
            end
    end;

%% 增加Buff
do({buff, wish_lucky}, Role) ->
    case wish:lucky(Role) of %% 幸运泉水
        {false, Reason} -> {false, Reason};
        {ok, BuffBase} ->
            case buff:add(Role, BuffBase) of
                {false, Reason} -> {false, Reason};
                {ok, NewRole} -> {ok, NewRole}
            end
    end;
do({buff, BuffLabel}, Role) ->
    case buff:add(Role, BuffLabel) of
        {false, Reason} -> {false, Reason};
        {ok, NewRole} -> {ok, NewRole}
    end;

%% 增加血池
do({hp_pool, Pool}, Role) ->
    case buff:add_pool(hp_pool, Pool, Role) of
        {false, Reason} -> {false, Reason};
        {ok, NewRole} -> {ok, NewRole}
    end;

do({mp_pool, Pool}, Role) ->
    case buff:add_pool(mp_pool, Pool, Role) of
        {false, Reason} -> {false, Reason};
        {ok, NewRole} -> {ok, NewRole}
    end;

%% 宠物口粮
do({pet_happy, Value}, Role) ->
    case pet:feed(by_val, Value, Role) of
        {false, Reason} -> {false, Reason};
        {ok, NRole} -> {ok, NRole}
    end;

%% 宠物技能经验丹
do({pet_skill_exp, Value}, Role) ->
    pet:skill_exp_update(Value, Role);

%% 宠物经验丹
do({pet_exp, Value}, Role) ->
    pet:exp_update(Value, Role);

%% 固定宠物蛋
do({pet, Value}, Role) ->
    pet:create(Value, Role);

%% 宠物属性变化
do({pet_attr, Value}, Role) ->
    pet:append_attr(Value, Role);

%% 宠物变身卷
do({pet_baseid, BaseId}, Role) ->
    pet:use_change_skin_item(Role, BaseId);

%% 宠物变身卷 带永久附加属性
do({pet_ext_attr, ExtAttrL, Msg}, Role) ->
    pet:ext_attr(Role, ExtAttrL, Msg);

%% 宠物变身卷 带永久附加属性
do({pet_ext_attr, Type, Max, ExtAttrL, Msg}, Role) ->
    pet:ext_attr(Role, ExtAttrL, Msg, Type, Max);

%% 宠物祝福卡 在指定时间内增加属性
%% do({pet_bless, Time, BaseId, ExtAttrL, Msg}, Role) ->
%%    pet:use_bless(Role, Time, BaseId, ExtAttrL, Msg);

do({pet_buff, Label}, Role) ->
    pet_buff:add(Role, Label);

%% 宠物潜力金丹使用
do({pet_potential, Type, Value}, Role) ->
    NewType = case Type of
        0 -> util:rand(1, 4);
        _ -> Type
    end,
    pet:asc_potential_max(Role, {NewType, Value});

%% 仙宠洗点
do({pet_xidian}, _Role) ->
    {false, ?L(<<"物品功能未实现, 还不能使用此物品">>)};

%% VIp头像卡使用
do({vip_face, Faces, Msg}, Role) ->
    vip:add_face(Role, Faces, Msg);

%% 称号卡使用
do({honor_card, {HonorId, Time}}, Role) when is_integer(Time) ->
    achievement:use_card(Role, {HonorId, <<>>, Time});
do({honor_card, {HonorId, HonorName, Time}}, Role) when is_integer(Time) ->
    achievement:use_card(Role, {HonorId, HonorName, Time});

%% 金币卡
do({coin, Value}, Role) ->
    case role_gain:do([#gain{label = coin, val = Value}], Role) of
        {ok, Role1} ->
            log:log(log_coin, {<<"使用金币卡">>, <<"">>, Role, Role1}),
            {ok, Role1};
        _ -> {false, ?L(<<"增加金币失败">>)}
    end;

do({coin_bind, Value}, Role) ->
    case role_gain:do([#gain{label = coin_bind, val = Value}], Role) of
        {ok, Role1} ->
            log:log(log_coin, {<<"使用绑定金币卡">>, <<"">>, Role, Role1}),
            {ok, Role1};
        _ -> {false, ?L(<<"增加绑定金币失败">>)}
    end;

%% 晶钻卡
do({gold, Value}, Role) ->
    case role_gain:do([#gain{label = gold, val = Value}], Role) of
        {ok, NewRole} ->
            log:log(log_gold, {<<"使用晶钻卡">>, <<>>, Role, NewRole}),
            {ok, NewRole};
        _ -> {false, ?L(<<"增加晶钻失败">>)}
    end;

%% 绑定晶钻卡
do({gold_bind, Value}, Role) ->
    case role_gain:do([#gain{label = gold_bind, val = Value}], Role) of
        {ok, NewRole} -> 
            log:log(log_bind_gold, {<<"使用绑定晶钻卡">>, <<>>, Role, NewRole}),
            {ok, NewRole};
        _ -> {false, ?L(<<"增加绑定晶钻失败">>)}
    end;

%% 内部晶钻
do({love, Value}, Role = #role{assets = Assets = #assets{gold = G}}) ->
        Role1 = Role#role{assets = Assets#assets{gold = G + Value}},
        Role2 = vip:listener(Value, Role1),
        role_api:push_assets(Role, Role2),
        log:log(log_gold, {<<"使用内部晶钻卡">>, <<>>, Role, Role2}),
        {ok, Role2};

%% 经验丹
do({exp, Value}, Role) ->
    case role_gain:do([#gain{label = exp, val = Value}], Role) of
        {ok, Role1} ->
            {ok, Role1};
        _ -> {false, ?L(<<"增加经验失败">>)}
    end;

%% 符石卡
do({stone, Value}, Role) ->
    case role_gain:do([#gain{label = stone, val = Value}], Role) of
        {ok, Role1} ->
            log:log(log_stone, {<<"使用符石卡">>, <<"">>, Role, Role1}),
            {ok, Role1};
        _ -> {false, ?L(<<"增加符石失败">>)}
    end;

%% 使用月卡
do({month_card, _V}, Role) ->
    {ok, charge:use_month_card(Role)};

%% 灵力丹
do({spirit, _Value}, Role) ->
    {ok, Role};

%% 见闻录
do({attainment, Value}, Role) ->
    case role_gain:do([#gain{label = attainment, val = Value}], Role) of
        {ok, Role1} ->
            {ok, Role1};
        _ -> {false, ?L(<<"增加阅历失败">>)}
    end;

%% 历练丹
do({lilian, Value}, Role) ->
    case role_gain:do([#gain{label = lilian, val = Value}], Role) of
        {ok, NewRole} -> {ok, NewRole};
        _ -> {false, ?L(<<"增加仙道历练失败">>)}
    end;

%% VIP卡
do({vip, Type}, Role) ->
    {ok, vip:gm({set_vip_lev, Type}, Role)};

%% 妖精匣子
do({demon, BaseId}, Role) ->
    demon:gain_demon(BaseId, Role);

%% 竞技场积分
do({arena, Value}, Role) ->
    case role_gain:do([#gain{label = arena, val = Value}], Role) of
        {ok, NewRole} -> {ok, NewRole};
        _ -> {false, ?L(<<"增加竞技场积分失败">>)}
    end;

%% 帮战积分
do({guild_war, Value}, Role) ->
    case role_gain:do([#gain{label = guild_war, val = Value}], Role) of
        {ok, NewRole} -> {ok, NewRole};
        _ -> {false, ?L(<<"增加帮战积分失败">>)}
    end;

%% 传送
do({transfer, {_MapId, _X, _Y}}, _Role) ->
    {false, ?L(<<"物品功能未实现, 还不能使用此物品">>)};

%% 回城石
do({goto_town, {_MapId, _X, _Y}}, _Role) ->
    {false, ?L(<<"物品功能未实现, 还不能使用此物品">>)};

%% 回帮令
do({goto_guild, _GuildId}, _Role) ->
    {false, ?L(<<"物品功能未实现, 还不能使用此物品">>)};

%% 挖宝
do({treasure, Type}, Role) ->
    item_treasure:use(Role, Type);

%% 翅膀外观卡，带永久附加属性
do({wing_ext_attr, ExtAttrL, Msg}, Role) ->
    wing:ext_attr(Role, ExtAttrL, Msg);

%% 晶钻卷充值
do({charge, Gold}, Role) ->
    NewRole = charge:online_pay(Role, Gold, <<"晶钻卷充值">>),
    {ok, NewRole};

%% 动态表情使用
do({chat_face, L}, Role) ->
    do({chat_face, L, <<>>}, Role);
do({chat_face, L, Msg}, Role = #role{link = #link{conn_pid = ConnPid}, sns = Sns = #sns{chat_face = HadL}}) ->
    case is_list(L) of
        true ->
            NewFace = (HadL -- L) ++ L,
            sys_conn:pack_send(ConnPid, 10970, {chat_data:get(available) ++ NewFace}),
            case Msg of
                <<>> -> ignore;
                _ -> sys_conn:pack_send(ConnPid, 10931, {57, Msg, []})
            end,
            {ok, Role#role{sns = Sns#sns{chat_face = NewFace}}};
        _ ->
            ?ERR("动态表情列表数据错误"),
            {ok, Role}
    end;

%% 添加表情包
do({face_group, Id, 1, _Expire, Msg}, Role = #role{sns = Sns = #sns{face_group = Faces}, link = #link{conn_pid = ConnPid}}) ->
    NewFaces = case lists:keyfind(Id, 1, Faces) of
        {Id, _, _, Order} -> lists:keyreplace(Id, 1, Faces, {Id, 1, 0, Order});
        _ -> [{Id, 1, 0, 0} | Faces]
    end,
    NewRole = Role#role{sns = Sns#sns{face_group = NewFaces}},
    chat:push_face_group(NewRole),
    case Msg of
        <<>> -> ignore;
        _ -> sys_conn:pack_send(ConnPid, 10931, {57, Msg, []})
    end,
    {ok, NewRole};
do({face_group, Id, 0, Expire, Msg}, Role = #role{sns = Sns = #sns{face_group = Faces}, link = #link{conn_pid = ConnPid}}) ->
    Now = util:unixtime(),
    EndTime = case Expire of
        {_Y, _M, _D} -> util:datetime_to_seconds({Expire, {23, 59, 59}});
        _ when is_integer(Expire) -> Now + Expire;
        _ -> 0
    end,
    case EndTime of
        0 ->
            ?ERR("表情包添加出错 ~w", [Expire]),
            {ok, Role};
        _ ->
            NewFaces = case lists:keyfind(Id, 1, Faces) of
                {Id, _, Ex, Order} when is_integer(Expire) andalso Ex > Now -> 
                    lists:keyreplace(Id, 1, Faces, {Id, 0, Ex + Expire, Order});
                {Id, _, _, Order} -> 
                    lists:keyreplace(Id, 1, Faces, {Id, 0, EndTime, Order});
                _ -> [{Id, 0, EndTime, 0} | Faces]
            end,
            NewRole = Role#role{sns = Sns#sns{face_group = NewFaces}},
            chat:push_face_group(NewRole),
            case Msg of
                <<>> -> ignore;
                _ -> sys_conn:pack_send(ConnPid, 10931, {57, Msg, []})
            end,
            {ok, NewRole}
    end;

%% 技能突破丹
do({skill_break_out, IdType}, Role) ->
    skill:break_out(Role, IdType);

%% 容错处理
do(_Eff, _Role) ->
    ?ERR("无法处理的使用效果: ~w", [_Eff]),
    {false, ?L(<<"使用物品失败">>)}.
