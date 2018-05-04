%% *************************
%% 坐骑rpc模块
%% @author wprehard@qq.com
%% *************************
-module(mount_rpc).
-export([handle/3]).

-include("common.hrl").
%%
-include("role.hrl").
-include("storage.hrl").
-include("item.hrl").
-include("gain.hrl").


%% 进阶，注意这里的MountId是角色物品ID
%handle(12500, {MountId}, Role = #role{eqm = Eqm, bag = #bag{items = Items}}) ->
%    case storage:find(Items, #item.id, MountId) of
%        {false, _} -> {reply, {0, ?L(<<"坐骑不存在，无法进阶">>), 0, 0}}; %% 没有坐骑，祝福上限默认0
%        {ok, Item = #item{base_id = BaseId, bind = Bind, enchant = Enchant, special = Special}} ->
%            case lists:keyfind(MountId, #item.id, Eqm) of
%                {ok, _} -> {reply, {0, ?L(<<"请放入需要进阶的坐骑">>), 0, 0}};
%                false ->
%                    {BlessMax, BlessMin} = mount_data:get_bless(BaseId),
%                    case Enchant >= mount_data:get_need_enchant(BaseId) of
%                        false -> {reply, {0, mount_data:get_fail_prompt(BaseId), 0, BlessMax}};
%                        true ->
%                            case mount_data:get_next_mount(BaseId) of
%                                0 -> {reply, {0, ?L(<<"当前坐骑已经进阶到最高级，不能继续进阶!">>), 0, BlessMax}};
%                                NextId ->
%                                    %% 先扣物品
%                                    LossList = mount_data:get_gain_loss(BaseId),
%                                    role:send_buff_begin(),
%                                    case role_gain:do(LossList, Role) of
%                                        {flase, #loss{msg = Msg}} ->
%                                            role:send_buff_clean(),
%                                            {reply, {0, Msg, 0, BlessMax}};
%                                        {ok, NewRole = #role{bag = NewBag = #bag{items = NewItems}}} ->
%                                            role:send_buff_flush(),
%                                            %% 计算概率
%                                            case lists:keyfind(?special_mount, 1, Special) of
%                                                false -> %% 失败 TODO: 更新祝福值
%                                                    RandBless = 3, %% 第一次失败附加3点祝福值
%                                                    NewItem = Item#item{special = [{?special_mount, {RandBless, 1}} | Special]},
%                                                    %% ?DEBUG("第一次进阶失败:~w", [NewItem]),
%                                                    {reply, {0, ?L(<<"进阶失败, 祝福值增加">>), RandBless, BlessMax}, NewRole#role{bag = NewBag#bag{items = lists:keyreplace(MountId, #item.id, NewItems, NewItem)}}};
%                                                {?special_mount, {BlessVal, FailCnt}} ->
%                                                    case BlessVal >= BlessMin of
%                                                        false -> %% 失败 TODO: 更新祝福值
%                                                            NowBless = BlessVal + util:rand(1, 3), %% 这里必须随机
%                                                            NewItem = Item#item{special = lists:keyreplace(?special_mount, 1, Special, {?special_mount, {NowBless, FailCnt + 1}})},
%                                                            %% ?DEBUG("祝福值不够，失败:~w", [NewItem]),
%                                                            {reply, {0, ?L(<<"进阶失败, 祝福值增加">>), NowBless, BlessMax}, NewRole#role{bag = NewBag#bag{items = lists:keyreplace(MountId, #item.id, NewItems, NewItem)}}};
%                                                        true ->
%                                                            NowVal = 1000 * ((BlessVal + mount_data:get_base_rate(BaseId)) / BlessMax),
%                                                            SeedRate = util:rand(1, 1000),
%                                                            case SeedRate >= 1 andalso SeedRate =< NowVal of
%                                                                false ->
%                                                                    NowBless = mount_data:get_fail_bless(BlessMax, BlessVal, SeedRate),
%                                                                    NewItem = Item#item{special = lists:keyreplace(?special_mount, 1, Special, {?special_mount, {NowBless, FailCnt + 1}})},
%                                                                    %% ?DEBUG("前N次必失败:~w", [NewItem]),
%                                                                    {reply, {0, ?L(<<"进阶失败, 祝福值增加">>), NowBless, BlessMax}, NewRole#role{bag = NewBag#bag{items = lists:keyreplace(MountId, #item.id, NewItems, NewItem)}}};
%                                                                true -> %% 成功进阶 TODO: 更新坐骑, 更新祝福值
%                                                                    %%        ?DEBUG("升阶成功"),
%                                                                    NewRole1 = role_listener:special_event(NewRole, {20003, mount_data:get_mount_lev(NextId)}),
%                                                                    case role_gain:do([
%                                                                            #loss{label = item_id, val = [{MountId, 1}]}
%                                                                            ,#gain{label = item, val = [NextId, Bind, 1]}], NewRole1) of
%                                                                        {false, _GainOrLoss} ->
%                                                                            ?ERR("角色[~s]升级坐骑错误数据[~w]", [Role#role.name, _GainOrLoss]),
%                                                                            {reply, {0, ?L(<<"进阶失败, 祝福值增加">>), NowVal, BlessMax}};
%                                                                        {ok, NewRole2} ->
%                                                                            {Bm, _} = mount_data:get_bless(NextId),
%                                                                            {reply, {1, <<>>, 0, Bm}, NewRole2}
%                                                                    end
%                                                            end
%                                                    end
%                                            end
%                                    end
%                            end
%                    end
%            end
%    end;
%
%handle(12501, {MountId}, #role{bag = #bag{items = Items}}) ->
%    case storage:find(Items, #item.id, MountId) of
%        {false, _} -> {ok};
%        {ok, #item{base_id = BaseId, bind = Bind, attr = Attr, special = Special}} ->
%            {BlessMax, _} = mount_data:get_bless(BaseId),
%            {Item1, Item2, Num1, Num2} = mount_data:get_need_item(BaseId),
%            NextId = mount_data:get_next_mount(BaseId), %% 不能进阶的坐骑，会返回0
%            case lists:keyfind(?special_mount, 1, Special) of
%                false ->
%                    {reply, {NextId, Bind, 0, 0, 0, BlessMax, Item1, Item2, Num1, Num2, Attr}};
%                {?special_mount, {BlessVal, _}} ->
%                    {reply, {NextId, Bind, 0, 0, BlessVal, BlessMax, Item1, Item2, Num1, Num2, Attr}}
%            end
%    end;

%% 坐骑喂养
handle(12502, {_MountId, []}, _Role) -> {reply, {0, 0, ?L(<<"请放入喂养的物品">>)}};
handle(12502, {MountId, FeedItems}, Role = #role{mounts = #mounts{items = Items}}) when is_list(FeedItems) ->
    case storage:find(Items, #item.id, MountId) of
        {false, _Reason} -> {reply, {0, 0, ?L(<<"坐骑不存在">>)}};
        {ok, Mount = #item{status = ?lock_release}} ->
            role:send_buff_begin(),
            case mount:feed(Mount, FeedItems, Role) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {0, 0, Reason}};
                {ok, AddExp, IsUpgrade, NewRole} ->
                    role:send_buff_flush(),
                    Msg = case IsUpgrade of
                        false -> util:fbin(?L(<<"喂养成功，坐骑增加~w点经验。">>), [AddExp]);
                        true -> util:fbin(?L(<<"增加了~w点经验，坐骑升级成功，属性得到了加强!">>), [AddExp])
                    end,
                    NewRole2 = role_listener:special_event(NewRole, {1033, finish}), %% 喂养坐骑
                    {reply, {1, AddExp, Msg}, NewRole2}
            end
    end;

% 获取坐骑列表
handle(12503, {}, #role{mounts = #mounts{items = Items}}) ->
    %?DEBUG("坐骑列表 [~w]", [Items]),
    {reply, {Items}};

% 装备坐骑
handle(12504, {MountId}, #role{ride = ?ride_fly}) ->
    {reply, {0, MountId, ?L(<<"飞行中不能坐骑更换或休息">>)}};
handle(12504, {MountId}, #role{event = Event}) when ?EventCantPutItem ->
    {reply, {0, MountId, ?L(<<"竞技比赛时，不能随便穿装备的啦~">>)}};
handle(12504, {MountId}, Role) ->
    role:send_buff_begin(),
    case mount:equip_mount(MountId, Role) of
        {ok, NewRole} ->
            role:send_buff_flush(),
            NewRole1 = role_listener:eqm_event(NewRole, update),            
            {reply, {1, MountId, <<>>}, NewRole1};
        {false, Reason} ->
            role:send_buff_clean(),
            {reply, {0, MountId, Reason}}
    end;
    

% 卸下坐骑
handle(12505, {}, #role{ride = ?ride_fly}) ->
    {reply, {0, 0, ?L(<<"飞行中不能坐骑更换或休息">>)}};
handle(12505, {}, #role{event = Event}) when ?EventCantPutItem ->
    {reply, {0, 0, ?L(<<"唉哟，竞技比赛的时候就不要脱装备啦~">>)}};
handle(12505, {}, Role) ->
    case mount:takeoff_mount(Role) of
        {false, Reason} ->
            {reply, {0, 0, Reason}};
        {ok, MountId, NewRole} ->
            {reply, {1, MountId, <<>>}, NewRole}
    end;

% 坐骑换装
handle(12506, {SkinId, Grade}, Role) when Grade =:= 0 orelse Grade =:= 1 ->
    case mount:change_skin(SkinId, Grade, Role) of
        {false, Reason} ->
            {reply, {0, 0, 0, 0, 0, Reason}};
        {ok, OldSkinId, OldGrade, NewRole} ->
            {reply, {1, SkinId, Grade, OldSkinId, OldGrade, ?L(<<"坐骑更换形象成功！">>)}, NewRole}
    end;

% 获取坐骑外观列表
handle(12507, {}, #role{mounts = Mounts}) ->
    SkinList = mount:make_skinlist(Mounts),
    {reply, {SkinList}};

% 坐骑进阶
handle(12508, {MountId}, Role = #role{mounts = #mounts{items = Items}}) ->
    case storage:find(Items, #item.id, MountId) of
        {false, _Reason} -> {reply, {0, MountId, 0, ?L(<<"坐骑不存在">>)}};
        {ok, Mount = #item{status = ?lock_release}} ->
            role:send_buff_begin(),
            case mount:upgrade(Mount, Role) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {0, MountId, 0, Reason}};
                {?coin_less, Reason} ->
                    role:send_buff_clean(),
                    {reply, {?coin_less, MountId, 0, Reason}};
                {ok, Flag, NewRole} ->
                    role:send_buff_flush(),
                    {Msg, Res} = case Flag of
                        suc -> {?L(<<"进阶成功！坐骑获得进阶属性，获得了新外形！">>), 1};
                        ready -> {?L(<<"恭喜您非常幸运的得到了幸运暴击，幸运值瞬间涨满！您的坐骑可以进阶了！">>), 0}
                    end,
                    log:log(log_coin, {<<"坐骑">>, util:fbin(<<"进阶成功[~w]">>, [Flag]), Role, NewRole}),
                    NewRole1 = role_listener:eqm_event(NewRole, update),            
                    {reply, {1, MountId, Res, Msg}, NewRole1};
                {ok, fal, AddLuck, NewRole} ->
                    role:send_buff_flush(),
                    Msg = util:fbin(?L(<<"坐骑增加~w点幸运值，幸运值越高，进阶成功的概率越高。">>), [AddLuck]),
                    log:log(log_coin, {<<"坐骑">>, util:fbin(<<"进阶[附加幸运:~w]">>, [AddLuck]), Role, NewRole}),
                    {reply, {1, MountId, 0, Msg}, NewRole}
            end
    end;

% 坐骑放生
handle(12509, {MountId}, Role) ->
    case mount:del(MountId, Role) of
        {false, Reason} ->
            {reply, {0, MountId, Reason}};
        {ok, NewRole} ->
            {reply, {1, MountId, ?L(<<"坐骑放生成功">>)}, NewRole}
    end;

% 坐骑洗髓
handle(12510, {MountId}, Role = #role{mounts = #mounts{items = Items}}) ->
    case lists:keyfind(MountId, #item.id, Items) of
        false ->
            {reply, {0, ?L(<<"坐骑不存在">>)}};
        Mount ->
            case mount:refresh_growth(Mount, Role) of
                {false, Reason} ->
                    {reply, {0, Reason}};
                {?coin_less, Reason} ->
                    {reply, {?coin_less, Reason}};
                {ok, Quality, NewRole} ->
                    Msg = util:fbin(?L(<<"洗髓成功，坐骑成长发生了变化。当前品质为~s">>), [mount_upgrade_data:quantity_name(Quality)]),
                    {reply, {1, Msg}, NewRole}
            end
    end;

%% 坐骑批量洗髓
handle(12511, {MountId, UnBind}, Role = #role{mounts = #mounts{items = Items}}) ->
    case lists:keyfind(MountId, #item.id, Items) of
        false ->
            {reply, {0, ?L(<<"坐骑不存在">>)}};
        Mount ->
            case mount:batch_refresh_growth(Mount, UnBind, Role) of
                {false, Reason} ->
                    {reply, {0, Reason, 0, []}};
                {?coin_less, Reason} ->
                    {reply, {?coin_less, Reason, 0, []}};
                {ok, List, Grade, NewRole} ->
                    DataList = [{Id, Quality, Grows} || {Id, Quality, Grows, _} <- List],
                    {reply, {1, <<>>, Grade, DataList}, NewRole}
            end
    end;

%% 获取坐骑批量洗髓属性
handle(12512, {MountId}, #role{mounts = #mounts{items = Items}}) ->
    case lists:keyfind(MountId, #item.id, Items) of
        false ->
            {reply, {0, []}};
        #item{xisui_list = List, extra = Extra} ->
            {_, Grade, _} = lists:keyfind(19, 1, Extra),
            DataList = [{Id, Quality, Grows} || {Id, Quality, Grows, _} <- List],
            {reply, {Grade, DataList}}
    end;

%% 选择洗髓属性
handle(12513, {MountId, Index}, Role = #role{mounts = #mounts{items = Items}}) ->
    case lists:keyfind(MountId, #item.id, Items) of
        false ->
            {reply, {0, ?L(<<"坐骑不存在">>)}};
        Mount ->
            case mount:choose_growth_per(Mount, Index, Role) of
                {false, Reason} ->
                    {reply, {0, Reason}};
                {ok, Quality, NewRole} ->
                    Msg = util:fbin(?L(<<"洗髓成功，坐骑成长发生了变化。当前品质为~s">>), [mount_upgrade_data:quantity_name(Quality)]),
                    {reply, {1, Msg}, NewRole}
            end
    end;

handle(_Cmd, _Data, _Role) ->
    ?ERR("未知命令:[Cmd: ~w Data: ~w Role: ~w", [_Cmd, _Data, _Role]),
    {error, unknow_command}.
