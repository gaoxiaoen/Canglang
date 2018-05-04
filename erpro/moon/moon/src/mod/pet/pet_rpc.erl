%%----------------------------------------------------
%% 仙宠远程接口 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(pet_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("pet.hrl").
%%
%%
-include("storage.hrl").
-include("item.hrl").
-include("dungeon.hrl").
-include("gain.hrl").
-include("link.hrl").


handle(12600, {}, #role{link = #link{conn_pid = ConnPid}, pet = #pet_bag{active = undefined}}) ->
    notice:alert(error, ConnPid, ?MSGID(<<"还木有伙伴呢，加油加油！！">>)),
    {ok};
handle(12600, {}, Role = #role{pet = #pet_bag{active = Pet}}) when is_record(Pet, pet) ->
    Reply = pet:get_pet_info(Role),
    {reply, Reply};


%% 放生一个宠物
handle(12601, {Id}, Role) ->
    case pet:del(Id, Role) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> {reply, {1, ?L(<<"宠物放生成功">>)}, NRole}
    end;

%% 出战一个宠物
handle(12602, {Id}, Role) ->
    case pet:war(Id, Role) of
        {false, Reason} -> {reply, {Id, 0, Reason}};
        {ok, NRole} -> {reply, {Id, 1, ?L(<<"宠物出战成功">>)}, NRole}
    end;

%% 休息召回宠物
handle(12603, {Id}, Role) ->
    case pet:rest(Id, Role) of
        {false, Reason} -> {reply, {Id, 0, Reason}};
        {ok, NRole} -> {reply, {Id, 1, ?L(<<"宠物召回成功">>)}, NRole}
    end;

%% 升级宠物
handle(12604, {Id}, Role) ->
    case check_time(pet_upgrage, 4) of
        false -> {ok};
        true ->
            case pet:upgrade(Id, Role) of
                {false, exp_not_enough} -> {ok};
                {false, _Reason} -> {ok};
                {ok, NRole} ->
                    role:put_dict(pet_upgrage, util:unixtime()),
                    {reply, {1, ?L(<<"您的宠物升级了">>)}, NRole}
            end
    end;

%% 扩展宠物栏
handle(12605, {}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case pet:expand_limit_num(Role) of
        {false, Reason} ->
            {reply, {?false, Reason}};
        {gold, _Msg} ->
            {reply, {?gold_less, <<>>}};
        {coin, _Msg} ->
            {reply, {?coin_less, <<>>}};
        {ok, NewRole} ->
            log:log(log_coin, {<<"仙宠宠物栏">>, <<"扩展宠物栏">>, Role, NewRole}),
            sys_conn:pack_send(ConnPid, 12600, pet:list(NewRole)),
            {reply, {?true, <<>>}, NewRole}
    end;

%% 重命名宠物
handle(12606, {<<>>}, _Role = #role{link = #link{conn_pid = ConnPid}}) ->
    notice:alert(error, ConnPid, ?MSGID(<<"小伙伴怎么可以没有名字呢-_-">>)),
    {ok};
handle(12606, {Name}, _Role = #role{link = #link{conn_pid = ConnPid}}) when byte_size(Name) > 18 ->
    ?DEBUG("--byte_size-~p~n~n~n", [byte_size(Name)]),
    notice:alert(error, ConnPid, ?MSGID(<<"小伙伴名字长度最长为6个文字哦">>)),
    {ok};
handle(12606, {Name}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    ?DEBUG("--byte_size-~p~n~n~n", [byte_size(Name)]),
    case forbid_name:check(Name) of
        true -> 
            notice:alert(error, ConnPid, ?MSGID(<<"小伙伴名字存在敏感词，不允许使用">>)),
            {ok};
        false ->
            case pet:rename(Name, Role) of
                {ok, NRole} -> 
                    notice:alert(succ, ConnPid, ?MSGID(<<"小伙伴更名成功啦^_^">>)),
                    {reply, {}, NRole};
                {_, Reason} -> 
                    notice:alert(error, ConnPid, Reason),
                    {ok}
            end
    end;


% 破蛋而出
handle(12607, {_PetBaseId, Name}, #role{link = #link{conn_pid = ConnPid}})when byte_size(Name) > 18 ->
    ?DEBUG("--byte_size-~p~n~n~n", [byte_size(Name)]),
    notice:alert(error, ConnPid, ?MSGID(<<"小伙伴名字长度最长为6个文字哦">>)),
    {ok};
handle(12607, {PetBaseId, Name}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    ?DEBUG("--byte_size-~p~n~n~n", [byte_size(Name)]),
   case forbid_name:check(Name) of
        true -> 
            notice:alert(error, ConnPid, ?MSGID(<<"小伙伴名字存在敏感词，不允许使用">>)),
            % {ok};
            {reply, {0}};
        false ->
            case pet:egg_to_pet2({PetBaseId, Name}, Role) of
                {false, Reason} -> 
                    notice:alert(error, ConnPid, Reason),
                    % {ok};
                    {reply, {0}};
                {ok, NRole} -> 
                    % log:log(log_item_del_loss, {<<"宠物破蛋而出">>, Role}),
                    NR   = role_listener:special_event(NRole, {1060, finish}),
                    Push = pet:get_pet_info(NR),
                    sys_conn:pack_send(ConnPid, 12600, Push),

                    {reply, {1}, NR}
            end
    end;

%% 破蛋练魂
handle(12625, {ItemId, Id}, Role) ->
    case pet:egg_to_item({ItemId, Id}, Role) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> 
            log:log(log_item_del_loss, {<<"宠物蛋炼魂">>, Role}),
            {reply, {1, ?L(<<"宠物蛋练魂成功">>)}, NRole}
    end;

%% 购买更名次数
handle(12608, {}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case pet:buy_rename(Role) of
        {false, Reason} -> 
            notice:alert(error, ConnPid, Reason),
            {ok};
        {ok, NRole} ->
            % log:log(log_gold, {<<"购买宠物更名次数">>, <<"购买宠物更名次数">>, Role, NRole}),
            notice:alert(error, ConnPid, ?MSGID(<<"购买伙伴更名次数成功">>)),
            {reply, {1}, NRole}
    end;

%% 宠物继承合并
handle(12609, {MainId, SecondId, SelectBaseId}, Role) ->
    case pet:join({MainId, SecondId, SelectBaseId}, Role) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> {reply, {1, ?L(<<"宠物融合成功">>)}, NRole}
    end;

%% 宠物喂养
handle(12610, {Id}, Role) ->
    case pet:feed(by_id, Id, Role) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> {reply, {1, ?L(<<"宠物喂养成功">>)}, NRole}
    end;

%% 宠物技能遗忘
handle(12611, {SkillId}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case pet:loss_skill(SkillId, Role) of
        {false, Reason} -> 
            notice:alert(error, ConnPid, Reason),
            {ok};
        {ok, NRole, SkillId} ->
            % ?DEBUG("PET ANTI_AATTACK:~w", NRole#role.pet#pet_bag.active#pet.attr#pet_attr.anti_attack),
            {reply, {SkillId}, NRole}
    end;

%% 宠物技能学习预览
handle(12612, {ItemId}, #role{link = #link{conn_pid = ConnPid}, pet = #pet_bag{active = #pet{skill = Skill, skill_slot = Skill_slot}}}) ->
    {ok,#item_base{effect = [{pet_skill, SkillId}]}} = item_data:get(ItemId),
    TempList = lists:map(fun({Id, _, _, _}) -> erlang:round(Id / 100) end, Skill),
    TempSkill = erlang:round(SkillId / 100),
    case lists:member(TempSkill, TempList) of    %%是否已学习同阶技能
        true ->
            notice:alert(error, ConnPid, ?MSGID(<<"已学习同阶技能">>)),
            {ok};
        false ->
            case {lists:member(TempSkill+1, TempList), lists:member(TempSkill+2, TempList)} of
                {false, false} ->
                    case TempSkill rem 10 of    %%是否是低阶技能
                        1 -> %%学习
                            case erlang:length(Skill_slot) > 0 of
                                true ->
                                    {reply, {SkillId, 0}};     %% 根据策划配置表0为一个技能1级的初始经验值,4为下一级需要的经验值
                                false ->
                                    notice:alert(error, ConnPid, ?MSGID(<<"伙伴技能槽不足">>)),
                                    {ok}
                            end;
                        Rem ->      %%不是低阶则判断是否已学习较低阶技能
                            case lists:member(TempSkill - 1, TempList) of
                                true ->     %%已有低阶，学习技能，先计算出合成后新的技能
                                    {New_SkillId, New_Exp, _} = pet_api:get_new_skill(Skill, SkillId),
                                    {reply, {New_SkillId, New_Exp}};
                                false ->        %%需要先学习较低阶
                                    case Rem of %%判断需要中介还是低阶
                                        2 ->       %%需要低阶
                                            notice:alert(error, ConnPid, ?MSGID(<<"需要先学习低阶技能">>)),
                                            {ok};
                                        3 -> %%需要中阶
                                            notice:alert(error, ConnPid, ?MSGID(<<"需要先学习中阶技能">>)),
                                            {ok}
                                    end
                            end
                    end;
                _ ->
                    notice:alert(error, ConnPid, ?MSGID(<<"已经学习了较高技能">>)),
                    {ok}
            end
    end;

%%宠物技能学习
handle(12613, {BaseId}, Role = #role{bag = Bag, link = #link{conn_pid = ConnPid}}) ->
    {ok, #item_base{effect = [{pet_skill, SkillId}]}} = item_data:get(BaseId),
    TmpList = [{BaseId, 1}],
    case storage:del(Bag, TmpList) of
        false -> 
            notice:alert(error, ConnPid, ?MSGID(<<"使用技能物品出错">>)),
            {ok};
        {ok, NewBag, NewDel, Refresh} -> 
            {ok, NR, NSkill1} = pet_api:update_skill(SkillId, Role),
            % NR1 = role_listener:special_event(NR, {1071, SkillId}), 
            NRole = medal:listener(pet_skill, NR),
            NewDel2 = [{?storage_bag, Item}||Item <- NewDel],
            storage_api:del_item_info(ConnPid, NewDel2),
            Refresh2 = [{?storage_bag, Item}||Item <- Refresh],
            storage_api:refresh_mulit(ConnPid, Refresh2),
            % ?DEBUG("PET ANTI_AATTACK:~w", NRole#role.pet#pet_bag.active#pet.attr#pet_attr.anti_attack),
            log:log(log_pet2, {<<"技能学习">>, util:term_to_bitstring(NSkill1), NRole}),
            {reply, {NSkill1}, NRole#role{bag = NewBag}}
    end;


%% 宠物蛋刷新
handle(12614, {ItemId, Refresh, IsBatch}, Role) ->
    case pet:refresh_egg({ItemId, Refresh, IsBatch}, Role) of
        {gold, Reason} -> {reply, {?gold_less, Reason}};
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} ->
            {reply, {1, ?L(<<"宠物蛋刷新成功">>)}, NRole};
        ok -> {ok}
    end;


%% 宠物潜力提升 by bwang
%% Type--潜力类型(1:力 2:体 3:毅 4:巧)
handle(12615, {Type, IsAuto}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
   
    case pet:asc_potential(Type, IsAuto, Role) of
        {false, Reason} -> 
            notice:alert(error, ConnPid, Reason),
            {ok};
        {Val, Msg, NRole, Num_Slot, Step, NextMax} ->
            case Msg of 
                [] -> ok;
                _ -> notice:alert(error, ConnPid, Msg)
            end,
            
            %% log

            log:log(log_pet2, {<<"伙伴潜能">>, util:fbin("~w, ~w", [Type, Val]), NRole}),

            case Num_Slot  of 
                1 -> notice:alert(succ, ConnPid, ?MSGID(<<"开启1个技能槽">>));           
                2 -> notice:alert(succ, ConnPid, ?MSGID(<<"开启2个技能槽">>));           
                0 -> ok
            end,
            ?DEBUG("-------宠物潜力提升-------(~p)~n~n~n~n", [Val]),
            NRole1 = role_listener:special_event(NRole, {1072, finish}),  
            NRole2 = role_listener:special_event(NRole1, {3009, 1}),    %% 触发日常
            {reply, {Type, Val, Step, NextMax}, NRole2}
    end;

%% 宠物洗随
%% Auto ,1:自动购买材料 0:否
handle(12616, {Auto}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case pet:set_sys_attr_per(Auto, Role) of
        {ok, NRole} ->
            log:log(log_coin, {<<"仙宠洗髓">>, <<"优先绑定">>, Role, NRole}),
            notice:alert(succ, ConnPid, ?MSGID(<<"洗点成功">>)),
            {reply, {}, NRole};
        {_, Reason} -> 
            notice:alert(error, ConnPid, Reason),
            {ok}
    end;

%% 宠物炼魂
%%handle(12617, {Id}, Role) ->
%%handle(12617, {next, {Id}}, Role) ->
handle(Cmd = 12617, Data, Role) ->
    case captcha:check(?MODULE, Cmd, Data, Role) of
        false -> {ok};
        {ok, {Id}} ->
            case pet:pet_to_item(Id, Role) of
                {false, Reason} -> {reply, {0, Reason}};
                {ok, NRole} -> {reply, {1, ?L(<<"炼魂成功，仙宠的魂已经在您的背包里凝结">>)}, NRole}
            end
    end;

%% 宠物继承合并预览
handle(12619, {MainId, SecondId}, Role) ->
    case pet:join_preview(0, {MainId, SecondId, 0}, Role) of
        {false, Reason} -> {reply, {MainId, SecondId, 0, Reason, []}};
        {ok, NewPet} -> 
            {reply, {MainId, SecondId, 1, <<>>, [pet_api:pet_to_client(NewPet)]}}
    end;

%% 获取宠物当前批洗数据
handle(12620, {}, Role) ->
    case pet:get_wash(Role) of
        {false, _Reason} -> 
            {ok};
        {ok, L} -> 
            case erlang:length(L) of 
                0 ->
                    {ok};
                _ ->
                    {reply, {L}}
            end
    end;

%% 进行批量洗髓
%% Auto ,1:自动购买材料 0:否
handle(12621, {Auto}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case pet:wash(Auto, Role) of
        {false, Reason} -> 
            notice:alert(error, ConnPid, Reason),
            {ok};
        {ok, L, NRole} ->
                log:log(log_coin, {<<"宠物批量洗髓">>, <<"">>, Role, NRole}), 
            {reply, {L}, NRole}
    end;

%% 选择批量洗髓
handle(12622, {N}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case pet:select_wash(N, Role) of
        {false, Reason} -> 
            notice:alert(error, ConnPid, Reason),
            {ok};
        {ok, NRole} ->  
            {reply, {1}, NRole}
    end;

%% 获取部分公共信息
handle(12623, {}, Role) ->
    {{_Type, _Time, Free}, _Logs} = pet:everyday_limit_log(?pet_log_type_free_egg, Role),
    {reply, {Free}};

%% 每天免费砸蛋
handle(12624, {_type}, Role) ->
    case pet:open_free_egg(Role) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> {reply, {1, <<>>}, NRole};
        {ok, NRole, Msg} ->  {reply, {1, Msg}, NRole}
    end;

%% 宠物成长提升
handle(12626, {Id}, Role) ->
    case pet:grow(Id, Role) of
        {false, Reason} -> {reply, {0, Reason}};
        {coin_all, Reason} -> {reply, {?coin_all_less, Reason}};
        {{fail, Val}, GrowVal, NRole} -> 
            log:log(log_coin, {<<"仙宠成长提升">>, util:fbin("提升失败，当前成长:~p", [GrowVal]), Role, NRole}),
            NewRole = role_listener:special_event(NRole, {1042, finish}), %% 使用一颗宠物成长丹            
            {reply, {0, util:fbin(?L(<<"提升失败，祝福值增加~p">>), [Val])}, NewRole};
        {{suc, Val}, GrowVal, NRole} ->  
            log:log(log_coin, {<<"仙宠成长提升">>, util:fbin("提升成功，当前成长:~p", [GrowVal]), Role, NRole}),
            NewRole = role_listener:special_event(NRole, {1042, finish}), %% 使用一颗宠物成长丹            
            {reply, {1, util:fbin(?L(<<"提升成功，仙宠成长提升到~p，共增加~p个属性点">>), [GrowVal, Val])}, NewRole}
    end;

%% 一键提升宠物成长
handle(close_12628, {Id, GrowVal}, Role) ->
    case pet:grow(Id, GrowVal, Role) of
        {false, Reason} -> {reply, {0, Reason}};
        {coin_all, Reason} -> {reply, {?coin_all_less, Reason}};
        {N, OldPet = #pet{grow_val = Grow}, NewPet = #pet{grow_val = Grow}, _AddAttrVal, NRole} ->
            log:log(log_coin, {<<"一键提升仙宠成长">>, util:fbin("总提升数:~p 目标值:~p 新成长值:~p 原成长值:~p", [N, GrowVal, NewPet#pet.grow_val, OldPet#pet.grow_val]), Role, NRole}),
            NewRole = role_listener:special_event(NRole, {1042, finish}), %% 使用一颗宠物成长丹            
            {reply, {1, util:fbin(?L(<<"提升失败，祝福值增加~p">>), [NewPet#pet.wish_val - OldPet#pet.wish_val])}, NewRole};
        {N, OldPet, NewPet, AddAttrVal, NRole} ->  
            log:log(log_coin, {<<"一键提升仙宠成长">>, util:fbin("总提升数:~p 目标值:~p 新成长值:~p 原成长值:~p", [N, GrowVal, NewPet#pet.grow_val, OldPet#pet.grow_val]), Role, NRole}),
            NewRole = role_listener:special_event(NRole, {1042, finish}), %% 使用一颗宠物成长丹            
            {reply, {1, util:fbin(?L(<<"提升成功，仙宠成长提升到~p，共增加~p个属性点">>), [NewPet#pet.grow_val, AddAttrVal])}, NewRole}
    end;

%% 宠物属性分配计算
handle(12627, {Lev, Grow, XlPer, TzPer, JsPer, LqPer}, _Role) ->
    AttrSys = #pet_attr_sys{xl_per = XlPer, tz_per = TzPer, js_per = JsPer, lq_per = LqPer},
    #pet_grow_base{attr_val = GrowAttrVal} = pet_data:get_grow(Grow),
    #pet_grow_base{attr_val = NextGrowAttrVal} = pet_data:get_grow(Grow + 1),
    {Xl, Tz, Js, Lq} = pet_api:do_sys_attr(Lev * 20 + GrowAttrVal, AttrSys),
    {NextXl, NextTz, NextJs, NextLq} = pet_api:do_sys_attr(Lev * 20 + NextGrowAttrVal, AttrSys),
    {GrowXl, GrowTz, GrowJs, GrowLq} = pet_api:do_sys_attr(GrowAttrVal, AttrSys), 
    {NextGrowXl, NextGrowTz, NextGrowJs, NextGrowLq} = pet_api:do_sys_attr(NextGrowAttrVal, AttrSys),
    {reply, {Xl, Tz, Js, Lq, GrowXl, GrowTz, GrowJs, GrowLq, NextXl, NextTz, NextJs, NextLq, NextGrowXl, NextGrowTz, NextGrowJs, NextGrowLq}};

%% 宠物变身
handle(12629, {Type, Id}, Role) ->
    case pet:reset_baseid(Role, Type, Id) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} ->  
            {reply, {1, <<>>}, NRole}
    end;

%% 宠物进化
handle(12636, {Id}, Role) ->
    case pet:evolve(Role, Id) of
        {false, coin_all} -> {reply, {?coin_all_less, <<>>}};
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole, NewPet} -> 
            log:log(log_item_del_loss, {util:fbin("仙宠进化:~p", [NewPet#pet.evolve]), Role}),
            {reply, {1, <<>>}, NRole}
    end;

%% 当前宠物进化情况
handle(12637, {Id}, Role) ->
    Pets = pet_api:list_pets(Role),
    case lists:keyfind(Id, #pet.id, Pets) of
        #pet{base_id = BaseId, evolve = Evo} ->
            Data = {Id, Evo, pet_data:baseid_type(BaseId), pet_data:get_next_baseid(0, BaseId), pet_data:get_next_baseid(1, BaseId), pet_data:get_next_baseid(2, BaseId), pet_data:get_next_baseid(3, BaseId)},
            {reply, Data};
        _ ->
            {ok}
    end;

%% 指定宠物属性点折算成属性
handle(12638, {RId, SrvId, Id, Type, AttrValL}, Role = #role{id = {RId, SrvId}}) -> %% 自己
    Pets = pet_api:list_pets(Role),
    case lists:keyfind(Id, #pet.id, Pets) of
        false -> 
            {reply, {RId, SrvId, Id, Type, []}};
        Pet ->
            {reply, {RId, SrvId, Id, Type, [pet_attr:calc_grow_attr(Pet, AttrVal) || AttrVal <- AttrValL]}}
    end;
handle(12638, {RId, SrvId, Id, Type, AttrValL}, _Role) -> %% 其他玩家
    case role_api:c_lookup(by_id, {RId, SrvId}) of
        {ok, _, Role = #role{}} ->
            Pets = pet_api:list_pets(Role),
            case lists:keyfind(Id, #pet.id, Pets) of
                false -> 
                    {reply, {RId, SrvId, Id, Type, []}};
                Pet ->
                    {reply, {RId, SrvId, Id, Type, [pet_attr:calc_grow_attr(Pet, AttrVal) || AttrVal <- AttrValL]}}
            end;
        _ ->
            {reply, {RId, SrvId, Id, Type, []}}
    end;

%% 选择宠物外观
handle(12639, {SkinId, Grade}, Role) when Grade >= 0 andalso Grade =< 3 ->
    case pet_ex:change_skin(SkinId, Grade, Role) of
        {ok, NextTime, NewRole} ->
            {reply, {1, SkinId, Grade, NextTime, ?L(<<"更换伙伴形象成功啦">>)}, NewRole};
        {false, Reason} ->
            {reply, {0, 0, 0, 0, Reason}}
    end;
    
%% 获取宠物外观列表
%%handle(12640, {}, #role{pet = #pet_bag{skin_time = Time, skins = Skins, active = #pet{skin_id = SkinId, skin_grade = Grade}}}) ->
%%    Now = util:unixtime(),
%%    RemainTime = case Time > Now of
%%        true -> Time - Now;
%%        false -> 0
%%    end,
%%    {reply, {RemainTime, pet_data:get_next_baseid(0, SkinId), Grade, Skins}};
%%handle(12640, {}, #role{pet = #pet_bag{skin_time = Time, skins = Skins}}) ->
%%    Now = util:unixtime(),
%%    RemainTime = case Time > Now of
%%        true -> Time - Now;
%%        false -> 0
%%    end,
%%    {reply, {RemainTime, 0, 0, Skins}};
%%handle(12640, {}, _) ->
%%    {reply, {0, 0, 0, []}};

%% by bwang 去掉不使用的返回值，eg外观等级
handle(12640, {}, #role{pet = #pet_bag{skin_time = Time, skins = Skins, active = #pet{skin_id = SkinId}}}) ->
    Now = util:unixtime(),
    RemainTime = case Time > Now of
        true -> Time - Now;
        false -> 0
    end,
    {reply, {RemainTime, pet_data:get_next_baseid(0, SkinId), Skins}};
handle(12640, {}, #role{pet = #pet_bag{skin_time = Time, skins = Skins}}) ->
    Now = util:unixtime(),
    RemainTime = case Time > Now of
        true -> Time - Now;
        false -> 0
    end,
    {reply, {RemainTime, 0, 0, Skins}};
handle(12640, {}, _) ->
    {reply, {0, 0, 0, []}};

%% 取消宠物更换外观冷却时间
handle(12641, {}, Role) ->
    case pet_ex:cancel_skin_time(Role) of
        {ok, NewRole} ->
            {reply, {1, 0, ?L(<<"冷却时间已清零">>)}, NewRole};
        {false, Reason} ->
            {reply, {0, 0, Reason}}
    end;

%% 获取宠物当前双天赋
handle(12642, {Id}, Role) ->
    case pet:get_double_talent(Id, Role) of
        {false, Reason} -> {reply, {0, Reason, Id, 0, 0, 0, []}};
        {ok, {Switch, UseId, CoolDown, NewAttrList}} -> {reply, {1, <<>>, Id, Switch, UseId, CoolDown, NewAttrList}}
    end;

%% 开启双天赋 
handle(12643, {Id}, Role) ->
    case pet:open_double_talent(Id, Role) of
        {false, Reason} -> {reply, {?false, Reason}};
        {gold_less, Reason} -> {reply, {?gold_less, Reason}};
        {ok, NewRole} ->
            {reply, {?true, ?L(<<"开启宠物双天赋成功">>)}, NewRole}
    end;

%% 更换双天赋
handle(12644, {Id, UseId}, Role) when UseId >= 1 andalso UseId =< 2->
    case pet:change_double_talent(Id, UseId, Role) of
        {false, Reason} -> {reply, {?false, Reason}};
        {ok, NewRole} ->
            {reply, {?true, ?L(<<"更换宠物天赋成功">>)}, NewRole}
    end;

%% 加速天赋切换CD
handle(12645, {Id}, Role) ->
    case pet:del_double_talent_cd(Id, Role) of
        {false, Reason} -> {reply, {?false, Reason}};
        {gold_less, Reason} -> {reply, {?gold_less, Reason}};
        {ok, NewRole} ->
            {reply, {?true, ?L(<<"加速宠物天赋冷却时间成功">>)}, NewRole}
    end;

%% 获取宠物对话列表
handle(12646, {}, Role = #role{pet = PetBag = #pet_bag{custom_speak = SpeakList}}) ->
    NewSpeakList = pet_ex:check_custom_speak(SpeakList),
    {reply, {NewSpeakList}, Role#role{pet = PetBag#pet_bag{custom_speak = NewSpeakList}}};

%% 修改宠物自定义对话内容
handle(12647, {_Id, Content}, _Role) when byte_size(Content) > 90 ->
    {reply, {0, ?L(<<"对话最多不超过30个字符！">>), 0, <<>>}};
handle(12647, {Id, Content}, Role = #role{pet = PetBag = #pet_bag{custom_speak = SpeakList}}) when is_integer(Id) andalso is_binary(Content) ->
    case pet_ex:text_banned(Content) of
        false ->
            {reply, {1, ?L(<<"修改成功！">>), Id, Content}, Role#role{pet = PetBag#pet_bag{custom_speak = lists:keyreplace(Id, 1, SpeakList, {Id, Content})}}};
        true ->
            {reply, {0, ?L(<<"对话内容存在敏感词，和谐社会请尽量不要使用敏感词">>), 0, <<>>}}
    end;

%% 恢复宠物自定义默认对话内容
handle(12648, {Id}, Role = #role{pet = PetBag = #pet_bag{custom_speak = SpeakList}}) when is_integer(Id) ->
    case petspeak_data:get(Id) of
        {false, Reason} ->
            {reply, {0, Reason, Id, <<>>}};
        {ok, #pet_speak{content = Content}} ->
            {reply, {1, ?L(<<"修改成功！">>), Id, Content}, Role#role{pet = PetBag#pet_bag{custom_speak = lists:keyreplace(Id, 1, SpeakList, {Id, Content})}}}
    end;            

%% 宠物BUFF列表
handle(12651, {}, Role) ->
    {reply, {pet_buff:to_client_buff_list(Role)}};

%% 获取宠物筋斗云数据
handle(12652, {0, _}, #role{pet = #pet_bag{cloud = #pet_cloud{lev = Lev, exp = Exp}}}) ->
    {reply, {0, <<>>, Lev, Exp}};
handle(12652, {Rid, SrvId}, #role{id = {Rid, SrvId}, pet = #pet_bag{cloud = #pet_cloud{lev = Lev, exp = Exp}}}) ->
    {reply, {Rid, SrvId, Lev, Exp}};
handle(12652, {Rid, SrvId}, _) ->
    case role_api:c_lookup(by_id, {Rid, SrvId}, [#role.pet]) of
        {ok, _N, [#pet_bag{cloud = #pet_cloud{lev = Lev, exp = Exp}}]} ->
            {reply, {Rid, SrvId, Lev, Exp}};
        _ ->
            {ok}
    end;

%% 获取猎魔面版数据信息
handle(12660, {}, Role) ->
    {reply, pet_magic:magic_info_client(Role)};

%% 召唤猎魔NPC
handle(close_12661, {NpcId}, Role) ->
    case pet_magic:call_npc(Role, NpcId) of
        {ok, NRole, NpcIds} ->
            {reply, {1, <<>>, NpcIds, []}, NRole};
        {false, gold} ->
            {reply, {?gold_less, <<>>, [], []}};
        {false, Reason} ->
            {reply, {0, Reason, [], []}}
    end;

%% 进行猎魔
handle(12662, {NpcId}, Role) ->
    case pet_magic:hunt(Role, NpcId) of
        {ok, NRole, NewNpcId, NpcIds, Free, AddItemInfo} ->
            log:log(log_coin, {<<"猎魔">>, util:fbin("猎魔NPC:~p", [NpcId]), Role, NRole}),
            {reply, {1, util:fbin(<<"~p">>, [NewNpcId]), NpcIds, Free, AddItemInfo}, NRole};
        {false, gold} ->
            {reply, {?gold_less, <<>>, [], 0, []}};
        {false, coin_all} ->
            {reply, {?coin_all_less, <<>>, [], 0, []}};
        {false, Reason} ->
            {reply, {0, Reason, [], 0, []}}
    end;

%% 猎魔物品处理
handle(12663, {Id, 2 = Type}, Role) -> %% 出售
    case pet_magic:sell(Role, Id) of
        {ok, NRole} -> {reply, {Type, 1, <<>>, Id}, NRole};
        {false, Reason} -> {reply, {Type, 0, Reason, Id}}
    end;
handle(12663, {Id, Type}, Role) ->
    case pet_magic:pick(Role, Id) of
        {ok, NRole} -> {reply, {Type, 1, <<>>, Id}, NRole};
        {false, Reason} -> {reply, {Type, 0, Reason, Id}}
    end;

%% 魔晶背包
handle(12664, {}, #role{pet_magic = #pet_magic{volume = Vol, items = Items}}) ->
    {reply, {Vol, Items}};

%% 魔晶背包开格子
handle(12665, {Num}, Role) ->
    case pet_magic:add_volume(Role, Num) of
        {false, gold} -> {reply, {?gold_less, <<>>, 0}};
        {false, Reason} -> {reply, {0, Reason}, 0};
        {ok, NRole = #role{pet_magic = #pet_magic{volume = Vol}}} -> 
            {reply, {1, <<>>, Vol}, NRole}
    end;

% 宠物装备佩戴
handle(12666, {ItemId}, Role = #role{link = #link{conn_pid = ConnPid}, bag = #bag{items = Items}}) ->
    case storage:find(Items, #item.id, ItemId) of
        {ok, Item} ->
            case pet:puton_pet_eqm(Item, Role) of 
                {ok, NEqm, NRole} ->
                    sys_conn:pack_send(ConnPid, 12667, {NEqm}),
                    {reply, {}, NRole};
                {false, Reason} ->
                    notice:alert(error, ConnPid, Reason),
                    {ok}
            end;
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            {ok}
    end;

% 获取指定宠物的装备信息 
handle(12667, {}, _Role = #role{link = #link{conn_pid = ConnPid}, pet = #pet_bag{active = undefined}}) ->
    notice:alert(error, ConnPid, ?MSGID(<<"未获得小伙伴">>)),
    {ok};
handle(12667, {}, Role = #role{pet = Pet_Bag = #pet_bag{active = Pet = #pet{eqm = Eqm}}}) -> 
    NEqm = check_eqm_fight_capacity(Eqm),
    {reply, {NEqm}, Role#role{pet = Pet_Bag#pet_bag{active = Pet#pet{eqm = NEqm}}}};

% 宠物装备卸载
handle(12668, {BaseId}, Role = #role{link = #link{conn_pid = ConnPid}, bag = #bag{free_pos = Free_Pos}, pet = #pet_bag{active = Pet = #pet{eqm = Eqm, eqm_num = Eqm_Num}}}) -> 
    case lists:keyfind(BaseId, #item.base_id, Eqm) of 
        false ->
            notice:alert(error, ConnPid, ?MSGID(<<"装备不存在，不能卸载">>)),
            {ok};
        Item ->
            case erlang:length(Free_Pos) > 0 of 
                true ->
                    First_Pos = lists:nth(1, Free_Pos),
                    case storage:add(bag, Role, [Item#item{pos = First_Pos}]) of 
                        false -> 
                            notice:alert(error, ConnPid, ?MSGID(<<"背包已满, 卸载失败！">>)),
                            {ok};
                        {ok, NewBag} ->
                            NEqm = lists:keydelete(BaseId, #item.base_id, Eqm),
                            NRole = pet_api:reset(Pet#pet{eqm = NEqm, eqm_num = Eqm_Num - 1}, Role),   
                            sys_conn:pack_send(ConnPid, 12667, {NEqm}),
                            pet_api:push_pet2(refresh, NRole),
                            {reply, {}, NRole#role{bag = NewBag}} 
                    end; 
                false ->
                    notice:alert(error, ConnPid, ?MSGID(<<"背包已满, 卸载失败！">>)),
                    {ok}
            end
    end;

%% 魔晶物品洗炼
handle(12670, {ItemId, ?storage_pet_magic, _PetId, Lock1, Lock2, Lock3, Lock4, Lock5}, Role) -> %% 魔晶背包物品
    case pet_magic:polish_bag(Role, ItemId, {Lock1, Lock2, Lock3, Lock4, Lock5}) of
        {false, gold} -> {reply, {?gold_less, <<>>}};
        {false, coin_all} -> {reply, {?coin_all_less, <<>>}};
        {false, Reason} ->
            {reply, {0, Reason}};
        {ok, NRole, Item} ->
            log:log(log_item_del_loss, {<<"魔晶洗炼[背包 单洗]">>, Role}),
            log:log(log_blacksmith, {<<"魔晶洗练">>, {<<"~s[背包]">>, [Item]}, <<"成功">>, [], Role, NRole}),
            {reply, {1, <<>>}, NRole}
    end;
handle(12670, {ItemId, ?storage_pet_eqm, PetId, Lock1, Lock2, Lock3, Lock4, Lock5}, Role) -> %% 宠物装备栏
    case pet_magic:polish_eqm(Role, PetId, ItemId, 0, {Lock1, Lock2, Lock3, Lock4, Lock5}) of
        {false, gold} -> {reply, {?gold_less, <<>>}};
        {false, coin_all} -> {reply, {?coin_all_less, <<>>}};
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole, Item} -> 
            log:log(log_item_del_loss, {<<"魔晶洗炼[装备栏 单洗]">>, Role}),
            log:log(log_blacksmith, {<<"魔晶洗练">>, {<<"~s[装备栏]">>, [Item]}, <<"成功">>, [], Role, NRole}),
            {reply, {1, <<>>}, NRole}
    end;

%% 魔晶物品批量洗练
handle(12671, {2, ItemId, ?storage_pet_magic, PetId, _, _, _, _, _}, #role{pet_magic = #pet_magic{items = Items}}) -> %% 读取魔晶背包中批量结果属性
    case lists:keyfind(ItemId, #item.id, Items) of
        #item{polish_list = PolishL} -> {reply, {1, <<>>, PetId, PolishL}};
        _ -> {reply, {0, <<>>, PetId, []}}
    end;
handle(12671, {2, ItemId, ?storage_pet_eqm, PetId, _, _, _, _, _}, Role) -> %% 读取宠物栏装备中批量洗练结果属性
    Pets = pet_api:list_pets(Role),
    case lists:keyfind(PetId, #pet.id, Pets) of
        #pet{eqm = Eqm} ->
            case lists:keyfind(ItemId, #item.id, Eqm) of
                #item{polish_list = PolishL} -> {reply, {1, <<>>, PetId, PolishL}};
                _ -> {reply, {0, <<>>, PetId, []}}
            end;
        _ ->
            {reply, {0, <<>>, PetId, []}}
    end;
handle(12671, {1, ItemId, ?storage_pet_magic, PetId, Lock1, Lock2, Lock3, Lock4, Lock5}, Role) -> %% 魔晶背包物品进行批洗
    case pet_magic:polish_batch_bag(Role, ItemId, {Lock1, Lock2, Lock3, Lock4, Lock5}) of
        {false, coin_all} -> {reply, {?coin_all_less, <<>>, PetId, []}};
        {false, gold} -> {reply, {?gold_less, <<>>, PetId, []}};
        {false, Reason} -> {reply, {0, Reason, PetId, []}};
        {ok, NRole, Item = #item{polish_list = PolishL}} -> 
            log:log(log_blacksmith, {<<"魔晶批洗">>, {<<"~s[背包]">>, [Item]}, <<"成功">>, [], Role, NRole}),
            log:log(log_item_del_loss, {<<"魔晶洗炼[背包 批洗]">>, Role}),
            {reply, {1, <<>>, PetId, PolishL}, NRole}
    end;
handle(12671, {1, ItemId, ?storage_pet_eqm, PetId, Lock1, Lock2, Lock3, Lock4, Lock5}, Role) -> %% 宠物栏魔晶物品进行批洗
    case pet_magic:polish_eqm(Role, PetId, ItemId, 1, {Lock1, Lock2, Lock3, Lock4, Lock5}) of
        {false, coin_all} -> {reply, {?coin_all_less, <<>>, PetId, []}};
        {false, gold} -> {reply, {?gold_less, <<>>, PetId, []}};
        {false, Reason} -> {reply, {0, Reason, PetId, []}};
        {ok, NRole, Item = #item{polish_list = PolishL}} -> 
            log:log(log_blacksmith, {<<"魔晶批洗">>, {<<"~s[背包]">>, [Item]}, <<"成功">>, [], Role, NRole}),
            log:log(log_item_del_loss, {<<"魔晶洗炼[装备栏 批洗]">>, Role}),
            {reply, {1, <<>>, PetId, PolishL}, NRole}
    end;

%% 选定洗练属性
handle(12672, {ItemId, ?storage_pet_magic, PolishId, _PetId}, Role) -> %% 魔晶背包物品洗练属性选定
    case pet_magic:polish_select_bag(Role, ItemId, PolishId) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> {reply, {1, <<>>}, NRole}
    end;
handle(12672, {ItemId, ?storage_pet_eqm, PolishId, PetId}, Role) -> %% 宠物栏物品洗练属性选定
    case pet_magic:polish_select_eqm(Role, PetId, ItemId, PolishId) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> {reply, {1, <<>>}, NRole}
    end;

%% 一键吞噬
handle(12673, {}, Role) ->
    case pet_magic:devour_all(Role) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok} -> {ok};
        {ok, AddExp, NRole} -> {reply, {1, util:fbin(<<"~p">>, [AddExp])}, NRole}
    end;

%% 魔晶锁定、解锁
handle(12674, {ItemId, ?storage_pet_magic, _PetId, Bind}, Role) when Bind =:= 1 orelse Bind =:= 0 ->
    case pet_magic:lock_item_bag(Role, ItemId, Bind) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> {reply, {1, <<>>}, NRole}
    end;
handle(12674, {ItemId, ?storage_pet_eqm, PetId, Bind}, Role) when Bind =:= 1 orelse Bind =:= 0 ->
    case pet_magic:lock_item_eqm(Role, PetId, ItemId, Bind) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> {reply, {1, <<>>}, NRole}
    end;

%% 获取魔晶兑换列表
handle(12675, {}, _Role) ->
    L = pet_magic_data:exchange_list(),
    EL = [{BaseId, pet_magic_data:get_exchange(BaseId)} || BaseId <- L],
    {reply, {EL}};

%% 魔晶兑换
handle(12676, {BaseId}, Role) ->
    role:send_buff_begin(),
    case pet_magic:exchange(Role, BaseId) of
        {false, Reason} -> 
            role:send_buff_clean(),
            {reply, {0, Reason}};
        {ok, NRole} -> 
            log:log(log_item_del_loss, {util:fbin(<<"魔晶兑换:~p">>, [BaseId]), Role}),
            role:send_buff_flush(),
            {reply, {1, ?L(<<"魔晶兑换成功">>)}, NRole}
    end;

%% 粽宝宝祝福
handle(12680, {Name, _Type}, #role{name = Name}) ->
    {ok};
handle(12680, {Name, Type}, Role) ->
    role:send_buff_begin(),
    case pet:send_bless(Role, Name, Type) of
        {false, Reason} -> 
            log:log(log_item_del_loss, {util:fbin("宠物祝福[~s][type:~p]", [Name, Type]), Role}),
            role:send_buff_clean(),
            {reply, {0, Reason}};
        {ok, NRole} -> 
            role:send_buff_flush(),
            {reply, {1, <<>>}, NRole}
    end;

%% 获取宠物真身列表
handle(12682, {}, Role) ->
    Reply = pet_rb:list(Role),
    {reply, {Reply}};

%% 获取宠物真身数据累积效果
handle(12683, {}, Role) ->
    Reply = pet_rb:lookup(Role),
    {reply, Reply};

%% 激活真身
handle(12685, {CardId}, Role) ->
    case role_gain:do([#loss{label = item, val = [CardId, 0, 1]}], Role) of  
        {ok, Role1} ->
            case pet_rb:active(Role1, CardId) of
                {false, Msg} ->
                    {reply, {?false, Msg}};
                {ok, Role2} ->
                    NewRole = pet_collect:collect(Role2, CardId), %% 星宠
                    log:log(log_item_del, {[#item{}], <<"使用宠物真身卡">>, util:fbin(<<"baseId:~w 数量 1">>, [CardId]), NewRole}),
                    {ok, NewRole}
            end;
        _ ->
            {reply, {?false, ?L(<<"缺少对应的真身卡">>)}}
    end;

%% 查询星宠信息
handle(12686, {}, Role) ->
    Data =  pet_collect:info(Role),
    {reply, Data};

%% 查询星宠告示
handle(12687, {}, _Role) ->
    Data = pet_collect:history(),
    {reply, {Data}};

%% 获取宠物tips
handle(12689, {BaseId}, #role{link = #link{conn_pid = ConnPid},pet = #pet_bag{active = #pet{eqm = Eqm}}}) ->
    List = [E||E<- Eqm,E#item.base_id == BaseId],
    case List of 
        [] -> 
            notice:alert(error,ConnPid,?L(<<"找不到该装备信息">>)),
            {ok}; 
        _ ->
            #item{special = Special} = lists:last(List),
            {reply,{Special}}
    end;

%% 查看玩家宠物数据
handle(12690, {RId, SrvId}, #role{id = {RId, SrvId},link = #link{conn_pid = ConnPid}, pet = #pet_bag{active = Pet}}) -> %% 自已宠物

    case is_record(Pet, pet) of
        true -> {reply, pet_api:pet_to_client1(Pet)};
        false -> 
            notice:alert(error, ConnPid, ?MSGID(<<"对方无宠物">>)),
            {ok}
    end;
handle(12690, {RId, SrvId}, _Role = #role{link = #link{conn_pid = ConnPid}}) -> %% 其它玩家宠物
    Time = case get(lookup_role_pet) of
        T when is_integer(T) -> T;
        _ -> 0
    end,
    Now = util:unixtime(),
    case Time + ?lookup_cd_time > Now of
        true ->
            {ok};
        false ->
            put(lookup_role_pet, Now),
            case role_api:c_lookup(by_id, {RId, SrvId}, to_role) of
                {ok, _, #role{pet = #pet_bag{active = Pet}}} when is_record(Pet, pet) ->
                    {reply, pet_api:pet_to_client1(Pet)};
                {ok, _, _} ->
                    notice:alert(error, ConnPid, ?MSGID(<<"对方无宠物">>)),
                    {ok};
                _ ->
                    notice:alert(error, ConnPid, ?MSGID(<<"角色不在线">>)),
                    {ok}
            end
    end;

%% 查看玩家指定宠物数据
handle(12691, {RId, SrvId, PetId}, Role = #role{id = {RId, SrvId}, name = RName, pet = #pet_bag{active = Pet = #pet{id = PetId}}}) -> %% 自已宠物
    {ok, PetRareValue} = pet_rb:rare_value(Role),
    {reply, {RId, SrvId, 0, <<>>, RName, PetRareValue, [pet_api:pet_to_client1(Pet)]}};
handle(12691, {RId, SrvId, PetId}, Role = #role{id = {RId, SrvId}, name = RName, pet = #pet_bag{pets = Pets}}) ->
    {ok, PetRareValue} = pet_rb:rare_value(Role),
    case lists:keyfind(PetId, #pet.id, Pets) of
        false -> {reply, {RId, SrvId, 1, ?MSGID(<<"查找不到相关宠物数据">>), RName, PetRareValue, []}};
        Pet -> {reply, {RId, SrvId, 0, <<>>, RName, PetRareValue, [pet_api:pet_to_client1(Pet)]}}
    end;
handle(12691, {RId, SrvId, PetId}, _Role) -> %% 其它玩家宠物
    case role_api:c_lookup(by_id, {RId, SrvId}) of
        {ok, _, TRole = #role{name = RName, pet = #pet_bag{active = Pet = #pet{id = PetId}}}} ->
            {ok, PetRareValue} = pet_rb:rare_value(TRole),
            {reply, {RId, SrvId, 0, <<>>, RName, PetRareValue, [pet_api:pet_to_client1(Pet)]}};
        {ok, _, TRole = #role{name = RName, pet = #pet_bag{pets = Pets}}} ->
            {ok, PetRareValue} = pet_rb:rare_value(TRole),
            case lists:keyfind(PetId, #pet.id, Pets) of
                false -> {reply, {RId, SrvId, 1, ?MSGID(<<"查找不到相关宠物数据">>), RName, 0, []}};
                Pet -> {reply, {RId, SrvId, 0, <<>>, RName, PetRareValue, [pet_api:pet_to_client1(Pet)]}}
            end;
        _ ->
            {reply, {RId, SrvId, 1, ?MSGID(<<"角色不在线">>), <<>>, 0, []}}
    end;

%% 获取宠物幸运值与虔诚值
handle(12692, {}, _Role = #role{pet = #pet_bag{active = undefined}}) ->
    {reply, {0, 0}};
handle(12692, {}, _Role = #role{pet = #pet_bag{active = #pet{lucky_value = Lucky_Val, devout_value = Devout_Val, explore_once = Once, explore_list = List}}}) ->
    Data = pet_mgr:get_all(),
    {reply, {Lucky_Val, Devout_Val, Once, List, Data}};

%% 一次探寻龙族遗迹
handle(12693, {Bind}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case pet:explore(Role, Bind) of 
        {false, Reason} -> 
            notice:alert(error, ConnPid, Reason),
            {ok};
        {ok, NRole, ItemId} -> 
            % log:log(log_gold, {<<"探寻一次龙族遗迹">>, <<"探寻一次龙族遗迹">>, Role, NRole}),
            log:log(log_pet_dragon,{<<"探寻一次龙族遗迹">>, util:fbin(<<"~w">>, [ItemId]), Role, NRole}),
            {reply, {ItemId}, NRole}
    end;

%% 批量探寻龙族遗迹
handle(12694, {Bind}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case pet:explore_batch(Role, Bind) of 
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            {ok};
        {ok, NRole, Items} ->
            % log:log(log_gold, {<<"批量探寻龙族遗迹">>, <<"批量探寻龙族遗迹">>, Role, NRole}),
            log:log(log_pet_dragon,{<<"批量探寻龙族遗迹">>, util:fbin(<<"~w">>, [Items]), Role, NRole}),
            {reply, {Items}, NRole}
    end;

%% 购买探寻到的龙族遗迹宝藏
handle(12695, {ItemId}, Role = #role{link = #link{conn_pid = ConnPid}, pet = #pet_bag{active = #pet{tab = Table}}}) ->
    case pet:buy_item({Table, ItemId}, Role) of 
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            {ok};
        {ok, NRole, NDevout} ->
            log:log(log_pet_dragon,{<<"获取龙族遗迹物品">>, util:fbin(<<"~w">>, [ItemId]), Role, NRole}),
            {reply, {NDevout}, NRole}
    end;

%%宠物技能升级（经验书的使用）
handle(12696, {SkillId, Id}, Role = #role{link = #link{conn_pid = ConnPid}, bag = #bag{items = Items}, pet = PetBag = #pet_bag{active = Pet = #pet{skill = Skills}}}) ->
    case storage:find(Items, #item.id, Id) of 
        {false, _Msg} -> 
            notice:alert(error, ConnPid, ?MSGID(<<"使用经验书出错">>)),
            {ok};
        {ok, #item{base_id = BaseId}} ->
            {ok, #item_base{effect = [{exp, Exp}]}} = item_data:get(BaseId),
            case lists:keyfind(SkillId, 1, Skills) of
                false -> 
                    {ok};
                {_, Cur_Exp, Loc, Arg} ->
                    case SkillId rem 10 of 
                        0 -> %%已达到最高等级
                            notice:alert(error, ConnPid, ?MSGID(<<"技能已达到最高级，请学习更高阶或其他技能">>)),
                            {ok};
                        _ ->
                            case calc_new_skill({SkillId, Cur_Exp}, Exp) of 
                                {false, Rea} ->
                                    notice:alert(error, ConnPid, Rea),
                                    {ok};
                                {NK, NExp} -> 
                                    TmpList = [{Id, 1}],
                                    case role_gain:do([#loss{label = item_id, val = TmpList}], Role) of
                                        {ok, NewRole} ->
                                            NSkills = lists:keydelete(SkillId, 1, Skills), %%替换掉旧的技能
                                            NP0 = Pet#pet{skill = [{NK, NExp, Loc, Arg}|NSkills]},
                                            NP = pet_api:deal_buff_skill(add, NK, NP0),
                                            NRole = NewRole#role{pet = PetBag#pet_bag{active = NP}},
                                            NRole1 = medal:listener(pet_skill, NRole),
                                            NRole2 = pet_api:reset(NP, NRole1),

                                            log:log(log_pet2, {<<"技能升级">>, util:term_to_bitstring(NP#pet.skill), NRole2}),

                                            pet_api:push_pet2(refresh, NRole2),
                                            NRole3 = role_listener:special_event(NRole2, {3010,1}),   %% 触发日常
                                            {reply, {NK, NExp, Loc, Arg}, NRole3};
                                        _ -> 
                                            notice:alert(error, ConnPid, ?MSGID(<<"使用经验书出错">>)),
                                            {ok}
                                    end
                            end
                    end
            end
    end;



%% 进入虔诚商店
handle(12697, {}, _Role) ->
    ItemIds = pet_devout_shop:list(),
    ItemKvs = [{BaseId, pet_devout_shop:get(BaseId)}||BaseId<-ItemIds],
    Sort_ItemKvs = lists:keysort(2, ItemKvs),
    {reply, {[ItemBaseId||{ItemBaseId, _}<-Sort_ItemKvs]}}; 
        


%% 虔诚商店购买物品
handle(12698, {ItemId}, Role = #role{link = #link{conn_pid = Conn_Pid}, pet = Pet_Bag =#pet_bag{active = Pet = #pet{devout_value = Devout_Val}}}) ->
    case pet_devout_shop:get(ItemId) of 
        undefined ->
            notice:alert(error, Conn_Pid, ?MSGID(<<"物品不存在！">>)),
            {ok};
        Cost_Value ->
            case Devout_Val >= Cost_Value of 
                true ->
                    case storage:make_and_add_fresh(ItemId, 0, 1, Role) of 
                        {ok, #role{bag = NewBag}, _} ->
                            NR = Role#role{bag = NewBag},
                            {reply, {ItemId}, NR#role{pet = Pet_Bag#pet_bag{active = Pet#pet{devout_value = Devout_Val- Cost_Value}}}}; %%返回新的虔诚值
                        {_, Reason} ->
                            notice:alert(error, Conn_Pid, Reason),
                            {ok}
                    end;
                false ->
                    notice:alert(error, Conn_Pid, ?MSGID(<<"虔诚值不足，无法购买-_-">>)),
                    {ok}
            end
    end;


handle(_Cmd, _Data, _Role) -> %% 容错处理
    {error, unknow_command}.

%% 时间校验
check_time(Key, N) -> 
    LastTime = case role:get_dict(Key) of
        {ok, undefined} -> 0;
        {ok, T} -> T
    end,
    (LastTime + N) < util:unixtime().

calc_new_skill({SkillId, Cur_Exp}, GainExp) ->
    {ok, #pet_skill{exp = Cur_Need}} = pet_data_skill:get(SkillId),
    case GainExp >= Cur_Need - Cur_Exp of 
        true ->
            case pet_data_skill:get(SkillId + 1) of 
                {ok, #pet_skill{exp = 0}} ->
                    {SkillId + 1, Cur_Need}; %%最高级显示需要测试(暂时赋值为第9级到第10级需要的经验值)
                {ok, #pet_skill{exp = _NExp}} ->    
                    calc_new_skill({SkillId + 1, 0}, GainExp - (Cur_Need - Cur_Exp));
                {false, Reason} ->
                    {false, Reason}
            end;
        false ->
            {SkillId, Cur_Exp + GainExp}
    end.

check_eqm_fight_capacity(Eqm) ->
    do_check(Eqm, []).
do_check([], L) ->L;
do_check([Eqm = #item{special = Special}|T], L) ->
    case lists:keyfind(?special_eqm_point, 1, Special) of 
        false ->
            Power = pet_api:calc_eqm_fight_capacity(Eqm),
            NSpe = [{?special_eqm_point, Power}] ++ Special,
            do_check(T, [Eqm#item{special = NSpe}|L]);
        _ ->
            do_check(T, [Eqm|L])
    end.
