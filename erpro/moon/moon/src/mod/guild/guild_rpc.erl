%----------------------------------------------------
%%  军团系统rpc
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_rpc).
-export([handle/3, broadcast/1]).

-include("common.hrl").
-include("guild.hrl").
-include("role.hrl").
-include("storage.hrl").
-include("item.hrl").
-include("pet.hrl").
-include("link.hrl").
%%
-define(Guild_DAYSEC, 1).   %% TODO 暂时屏蔽24小时限制


%% 获取个人军团信息
handle(12700, {}, Role) ->
    guild_role:push(Role),
    {ok};

%% 请求所有军团列表, 附带角色申请过的帮会
handle(12701, {PageNum}, Role) ->
    guild_mgr:guild_list(Role, PageNum),
    {ok};

%% 根据ID获取指定军团信息(入帮申请使用)
handle(12702, {Gid, Gsrvid}, _Role) ->
     case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{name = Name, chief = Ch, lev = Lev, num = Num, maxnum = Max, bulletin = {Bul, _, _}, fund = Fund, gvip = Gv, rvip = Rv, members = Mems, exp = Exp, skills = Skills} ->
            case lists:keyfind(?guild_chief, #guild_member.position, Mems) of
                false ->
                    {reply, {<<>>, 0, <<>>, 0, 0, <<>>, 0, 0, 0, <<>>, 0, 0, []}};
                #guild_member{id = {Rid, Rsrvid}} ->
                    {reply, {Name, Gv, Ch, Rv, Rid, Rsrvid, Lev, Num, Max, Bul, Fund, Exp, sort_skills(Skills)}}
            end;
        _ ->
            {reply, {<<>>, 0, <<>>, 0, 0, <<>>, 0, 0, 0, <<>>, 0, 0, []}}
    end;

%% 创建军团
handle(12703, {_Way, _Gname, _Bulletin}, #role{guild = #role_guild{gid = Gid}}) when Gid =/=0 ->
    {reply, {?failed_op, ?MSGID(<<"您已经加入了军团，请先退出再来建立军团吧">>)}};      %% 已经有军团
%handle(12703, {_Way, _Gname, _Bulletin}, #role{}) when  task:is_zhux_finish(?OPEN_TASK) =:= false ->
%    {reply, {?failed_op, ?MSGID(<<"等级不足，请等到20级之后再来建立军团吧">>)}};         %% 等级不足
handle(12703, {_Way, Gname, _Bulletin}, _Role) when byte_size(Gname) =:=0 ->
    {reply, {?failed_op, ?MSGID(<<"请输入军团名称">>)}};        %% 军团名字空
handle(12703, {_Way, Gname, _Bulletin}, _Role) when byte_size(Gname) > ?create_name_length ->
    {reply, {?failed_op, ?MSGID(<<"军团名称过长">>)}};      %% 军团名字过长
%%handle(12703, {_Way, _Gname, Bulletin}, _Role) when byte_size(Bulletin) =:=0 ->
%%    {reply, {?failed_op, ?MSGID(<<"请输入军团公告内容">>)}};    %% 军团公告内容为空
handle(12703, {_Way, _Gname, Bulletin}, _Role) when byte_size(Bulletin) > ?create_bulletin_length ->
    {reply, {?failed_op, ?MSGID(<<"军团公告内容过长">>)}};  %% 军团公告内容过长
handle(12703, {255, _Gname, _Bulletin}, _) ->
    {reply, {?failed_op, ?MSGID(<<"请选择创建军团方式">>)}};
handle(12703, {?create_by_coin, Gname, Bulletin}, Role) ->
    case task:is_zhux_finish(?OPEN_TASK) of
        true ->
            case Gname =:= ?L(<<"无军团">>) of
                false ->
                    case forbid_name:check(Gname) orelse forbid_name:check(Bulletin) of
                        false ->
                            case guild_mgr:is_guild_exist(Gname) of    
                                false ->                        
                                    case guild_mgr:create(?create_by_coin, Gname, Bulletin, Role) of
                                        {false, _Reason} ->
                                            {reply, {?failed_op, _Reason}};
                                        {true, NewRole} ->
                                            log:log(log_coin, {<<"建军团">>, <<"">>, Role, NewRole}),
                                            broadcast(NewRole),
                                            {reply, {?success_op, ?MSGID(<<"创建成功，快点召集你的小伙伴一起建设军团吧。">>)}, NewRole};
                                        {ErrorType, Reason} ->
                                            {reply, {ErrorType, Reason}}
                                    end;
                                true ->
                                    {reply, {?failed_op, ?MSGID(<<"该军团名已被使用，请重新输入">>)}}
                            end;
                        true ->
                            {reply, {?failed_op, ?MSGID(<<"请勿输入敏感词或非法字符">>)}} 
                    end;
                _ ->
                    {reply, {?failed_op, ?MSGID(<<"请输入非默认军团名称">>)}}
            end;
        false ->
            {reply, {?failed_op, ?MSGID(<<"军团功能尚未开启">>)}}
    end;

handle(12703, {?create_by_token, Gname, Bulletin}, Role)  ->
    case task:is_zhux_finish(?OPEN_TASK) of
        true ->
            case util:text_banned(Gname) orelse util:text_banned(Bulletin) of
                false ->

                    case guild_mgr:is_guild_exist(Gname) of    
                        false ->                        
                            case guild_mgr:create(?create_by_token, Gname, Bulletin, Role) of
                                {false, Reason} ->
                                    {reply, {?failed_op, Reason}};
                                {true, NewRole} ->
                                    broadcast(NewRole),
                                    {reply, {?success_op, ?MSGID(<<"创建成功，快点召集你的小伙伴一起建设军团吧。">>)}, NewRole}   
                            end;
                        true ->
                            {reply, {?failed_op, ?MSGID(<<"该军团名已被使用，请重新输入">>)}}
                    end;
                true ->
                    {reply, {?failed_op, ?MSGID(<<"请勿输入敏感词或非法字符">>)}} 
            end;
        false ->
            {reply, {?failed_op, ?MSGID(<<"军团功能尚未开启">>)}}
    end;

%% 好友推荐
handle(12704, {Name}, Role) ->
    case guild_mem:invite(Name, Role) of
        {false, Reason} ->
            {reply, {?failed_op, Reason}};
        {ok, Msg} ->
            {reply, {?success_op, Msg}}
    end;

%% 申请入军团
handle(12705, {Gid, Gsrvid}, Role) ->
    case guild_mem:apply_for(by_guild, {Gid, Gsrvid}, Role) of
        {false, Reason} ->
            ?DEBUG("~~~p", [Reason]),
            {reply, {?failed_op, Reason, 0, <<>>}};
        {ok, Msg, Role1} when is_record(Role1, role) ->
            {reply, {?success_op, Msg, 0, <<>>}, Role1};
        {ok, _Gid, Msg} ->
            Role1 = role_listener:special_event(Role, {1014, finish}),  %% 军团任务监听
            {reply, {?success_op, Msg, Gid, Gsrvid}, Role1} 
    end;

%% 退出军团
handle(12706, {}, Role = #role{id = {Rid, Rsrvid}}) ->
    case guild_mem:quit(Role) of
        {false, Reason} ->
            ?DEBUG("申请退出军团失败  原因 ~p~n", [Reason]),
            {reply, {?failed_op, Reason}};
        {ok, NewRole} ->
            guild_mgr:special(reset, {Rid, Rsrvid}),
            {reply, {?success_op, ?MSGID(<<"您已退出军团">>)}, NewRole}
    end;

%% 根据ID获取角色所属军团信息
handle(12707, {}, #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{name = Gname, chief = Chief, lev = Lev, num = Num, maxnum = MaxNum, gvip = Gv, rvip = Rv, bulletin = {Bul, QQ, YY}, fund = Fund, day_fund = DF} ->
            {reply, {Gname, Gv, Chief, Rv, Lev, Num, MaxNum, Fund, DF, Bul, QQ, YY}};
        _ ->
            {reply, {<<>>, 0, <<>>, 0, 0, 0, 0, 0, 0, <<>>, <<>>,<<>>}}
    end;

%% 申请入帮请求被处理(通过)
handle(12708, {Rid, Rsrvid, ?true}, Role) ->
    case guild_mem:approve(Rid, Rsrvid, Role) of
        {false, Reason} ->
            ?DEBUG("处理入帮申请失败 ~p~n", [Reason]),
            {reply, {?failed_op, Reason}};
        {ok, MsgId} ->
            {reply, {?success_op, MsgId}}
    end;

%% 申请入帮请求被处理(拒绝)
handle(12708, {Rid, Rsrvid, ?false}, Role) ->
    case guild_mem:refuse(Rid, Rsrvid, Role) of
        {false, _Reason} ->
            {reply, {?failed_op, ?MSGID(<<"拒绝申请失败！">>)}};
            %%{reply, {?failed_op, Reason}};
        ok ->
            {reply, {?success_op, ?MSGID(<<"拒绝申请成功！">>)}}
            %%{reply, {?success_op, <<>>}}
    end;

%% 军团的申请入帮列表
handle(12709, {}, Role) ->
    {reply, {guild_mem:applys(Role)}};

%% 军团公告修改
handle(12710, {Bulletin, _QQ, _YY}, _Role) when byte_size(Bulletin) =:=0 ->
    {reply, {?failed_op, ?MSGID(<<"请输入军团公告内容">>)}};    %% 军团公告内容为空
handle(12710, {Bulletin, _QQ, _YY}, _Role) when byte_size(Bulletin) > ?create_bulletin_length ->
    {reply, {?failed_op, ?MSGID(<<"军团公告内容过长">>)}};  %% 军团公告内容过长
handle(12710, {_Bulletin, QQ, _YY}, _Role) when byte_size(QQ) > ?qqsize ->
    {reply, {?failed_op, ?MSGID(<<"QQ栏内容超出18个字长度限制">>)}};    
handle(12710, {_Bulletin, _QQ, YY}, _Role) when byte_size(YY) > ?yysize ->
    {reply, {?failed_op, ?MSGID(<<"YY栏内容超出18个字长度限制">>)}};  
handle(12710, {Bulletin, QQ, YY}, Role) ->
    %%case util:text_banned(QQ) orelse util:text_banned(Bulletin) orelse util:text_banned(YY) of
    case forbid_name:check(QQ) orelse forbid_name:check(Bulletin) orelse forbid_name:check(YY) of
        false ->
            case guild_common:bulletin(Bulletin, QQ, YY, Role) of
                {false, _Reason} ->
                    {reply, {?failed_op, ?MSGID(<<"军团公告有非法字符！">>)}};
                    %%{reply, {?failed_op, Reason}};
                ok ->
                    {ok}
            end;
        true ->
            {reply, {?failed_op, ?MSGID(<<"请勿输入敏感词或非法字符">>)}} 
    end;

%% 领取俸禄
handle(12711, {}, Role = #role{guild = #role_guild{salary = _Salary}}) ->
    case guild_common:claim_salary(Role) of
        {false, Reason} ->
            {reply, {?failed_op, Reason}};
        {ok, NewRole} ->
            {ok, NewRole}
    end;

%% 军团捐献
handle(12712, {Coin, Gold}, Role) ->
    Now = util:unixtime(),
    case get(guild_12712) of
        Time when is_integer(Time) andalso (Now - Time) < 1 ->
            {reply, {?false, ?MSGID(<<"慢点...别累着哈!">>)}};
        _ ->
            case guild_common:donate(Coin, Gold, Role) of
                {false, Reason} ->
                    {reply, {?failed_op, Reason}};
                {ok, NewRole} ->
                    put(guild_12712, Now),
                    log:log(log_coin, {<<"军团捐献">>, <<"">>, Role, NewRole}),
                    log:log(log_gold, {<<"军团捐献">>, <<"">>, Role, NewRole}),
                    {reply, {?success_op, ?MSGID(<<"捐献成功">>)}, NewRole};
                {ErrorType, Reason} ->
                    {reply, {ErrorType, Reason}}
            end
    end;

%% 获取军团留言列表
handle(12713, {}, Role) ->
    {reply, {guild_common:notes(Role)}};

%% 军团留言
handle(12714, {Msg}, _Role) when byte_size(Msg) =:= 0 ->
    {reply, {?failed_op, ?MSGID(<<"请输入您要留言的内容">>)}}; 
handle(12714, {Msg}, _Role) when byte_size(Msg) > ?note_length ->
    {reply, {?failed_op, ?MSGID(<<"留言失败，内容超出80个汉字长度！">>)}}; 
handle(12714, {Msg}, Role) ->
    case util:text_banned(Msg) of
        false ->
            guild_common:leave_note(Msg, Role),
            {ok};
        true ->
            {reply, {?failed_op, ?MSGID(<<"请勿输入敏感词或非法字符">>)}} 
    end;

%% 删除留言
handle(12715, {ID}, Role) ->
    case guild_common:delete_note(ID, Role) of
        {false, Reason} ->
            {reply, {?failed_op, Reason}};
        ok ->
            {ok}
    end;

%% 获取角色收到的军团邀请列表
handle(12716, {}, #role{id = {Rid, Rsrvid}}) ->
    {reply, {guild_mgr:lookup_spec(invited, Rid, Rsrvid)}};

%% 角色处理军团邀请列表
handle(12717, {Gid, Gsrvid, Status}, Role) ->
    case guild_mem:handle_invitation(Gid, Gsrvid, Status, Role) of
        {ok} ->
            {ok};
        {false, Reason} ->
            {reply, {?failed_op, Reason}};
        {ok, NewRole = #role{guild = #role_guild{name = Name}}} ->
            {reply, {?success_op, Name}, NewRole}
    end;

%% 获取成员列表
handle(12719, {}, Role) ->
    Mems = lists:foldl(fun(M = #guild_member{pid = Pid}, Acc) ->
                case Pid of
                    0 ->
                        [M|Acc];
                    _ ->
                        [M#guild_member{pid = 1} | Acc]
                end
        end, [], guild_mem:members(Role)),
    ?DEBUG("军团成员列表 ~w", [Mems]),
    {reply, {Mems}};
        
%% 开除成员
handle(12720, {Rid, Srvid}, Role) ->
    case guild_mem:fire(Rid, Srvid, Role) of
        {false, Reason} ->
            {reply, {?failed_op, 0, Reason}};
        {ok, _Msg} ->
            {reply, {?success_op, Rid, Srvid}}
    end;

%% 卸任
handle(12721, {}, Role) ->
    case guild_mem:retire(Role) of
        {false, Reason} ->
            {reply, {?failed_op, Reason}};
        {ok, NewRole} ->
            {reply, {?success_op, ?MSGID(<<"卸任成功">>)}, NewRole}
    end;

%% 转让帮主
handle(12722, {Rid, Srvid}, Role) ->
    case guild_mem:transfer(Rid, Srvid, Role) of
        {false, Reason} ->
            {reply, {?failed_op, Reason}};
        {ok, NewRole} ->
            {reply, {?success_op, ?MSGID(<<"转让成功">>)}, NewRole}
    end;

%% 设置职位
handle(12723, {Rid, Srvid, PreJob, NextJob}, Role) ->
    case guild_mem:appoint(Rid, Srvid, PreJob, NextJob, Role) of
        {false, Reason} ->
            {reply, {?failed_op, Reason}};
        {ok, Msg} ->
            {reply, {?success_op, Msg}}
    end;

%% 设置加入军团限制
handle(12726, _Param = {Lev, Zdl}, Role) ->
    case guild_common:set_join_limit({Lev, Zdl}, Role) of
        {false, MsgId} ->
            notice:alert(error, Role, MsgId),
            {ok};
        _ ->
            ?DEBUG("设置成功"),
            notice:alert(succ, Role, ?MSGID(<<"设置成功">>)),
            {ok}
    end;

%% 获取军团加入限制
handle(12727, {}, Role = #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{join_limit = #join_limit{lev = Lev, zdl = Zdl}} ->
            {reply, {Lev, Zdl}};
        _ ->
            notice:alert(error, Role, ?L(<<"你还没加入军团">>)),
            {ok}
    end;

%% 从仓库取出
handle(12728, {ItemId, Pos}, Role) ->
    case guild_store:out_store(ItemId, Pos, Role) of
        {ok, NewRole} ->
            {reply, {?success_op, <<>>, ItemId}, NewRole};
        {false, Reason} ->
            {reply, {?failed_op, Reason, ItemId}}
    end;

%% 仓库内移动
handle(12729, {ItemId, Pos}, Role) ->
    guild_store:move(ItemId, Pos, Role),
    {ok};

%% 提升仓库容量
handle(12730, {}, Role) ->
    case guild:store(exten, Role) of
        {false, Reason} ->
            {reply, {?failed_op, Reason}};
        {true, Msg} ->
            {reply, {?success_op, Msg}}
    end;

%% 删除物品
handle(12731, {ItemId}, Role) ->
    guild_store:discard(ItemId, Role),
    {ok};

%% 获取仓库操作记录
handle(12732, {}, Role) ->
    {reply, {guild_store:log(Role)}};

%% 获取仓库物品列表
handle(12733, {}, Role) ->
    {reply, {guild_store:items(Role)}};

%% 获取贡献统计
handle(12735, {}, Role) ->
    {reply, {guild_common:donation_stats(Role)}};

%% 获取贡献日志
handle(12736, {}, Role) ->
    {reply, {guild_common:devote_log(Role)}};

%% 获取技能列表
handle(12737, {}, Role = #role{guild = #role_guild{skilled = Skilled}}) ->
    {reply, {guild_common:skills(Role), Skilled}};

%% 技能升级
handle(12739, {Type}, Role) ->
    case guild_common:upgrade_skill(Type, Role) of
        ok ->
            {ok};
        {false, Reason} ->
            {reply, {?failed_op, Reason}}
    end;

%% 一键领用技能
handle(12740, {}, Role) ->
    case guild_common:claim_skill(Role) of
        {ok, Role1} ->
            role_listener:guild_skill(Role1, {}),
            {reply, {?success_op, ?MSGID(<<"领用成功">>)}, Role1};
        {false, Reason} ->
            {reply, {?failed_op, Reason}}
    end;

%% 技能领用
handle(12741, {Type, _Lev}, Role) ->
    case guild_common:claim_skill(Type, Role) of
        {ok, Role1} ->
            role_listener:guild_skill(Role1, {}),
            {reply, {?success_op, ?MSGID(<<"领用成功">>)}, Role1};
        {false, Reason} ->
            {reply, {?failed_op, Reason}}
    end;

%% 获取军团升级信息
handle(12742, {}, #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{lev = Glev, weal = Wlev, stove = Slev} ->
            {ok, #guild_lev{cost_fund = CF}} = case Glev < ?max_guild_lev of
                true ->
                    guild_data:get(guild_lev, Glev + 1);
                false ->
                    guild_data:get(guild_lev, Glev)
            end,
            {ok, #weal_lev{glev = W_Glev, fund = W_Fund}} = case Wlev < ?max_weal_lev of
                true ->
                    guild_data:get(weal_lev, Wlev+1);
                false ->
                    guild_data:get(weal_lev, Wlev)
            end,
            {ok, #stove_lev{glev = S_Glev, fund = S_Fund}} = case Slev < ?max_stove_lev of
                true ->
                    guild_data:get(stove_lev, Slev+1);
                false ->
                    guild_data:get(stove_lev, Slev)
            end,
            {reply, {Glev, CF, Wlev, W_Glev, W_Fund, Slev, S_Glev, S_Fund}};
        _ ->
            {reply, {0,0,0,0,0,0,0,0}}
    end;

%% 升级军团
handle(12743, {?upgrade_guild}, Role) ->
    case guild_common:upgrade_guild(Role) of 
        {false, Reason} ->
            {reply, {?failed_op, Reason}};
        ok ->
            {ok}
    end;

%% 升级福利
handle(12743, {?upgrade_weal}, Role) ->
    case guild_common:upgrade_weal(Role) of 
        {false, Reason} ->
            {reply, {?failed_op, Reason}};
        ok ->
            {ok}
    end;

%% 升级神炉
handle(12743, {?upgrade_stove}, Role) ->
    case guild_common:upgrade_stove(Role) of 
        {false, Reason} ->
            {reply, {?failed_op, Reason}};
        ok ->
            {ok}
    end;

%% 升级商城
handle(12743, {?upgrade_shop}, Role) ->
    case guild_common:upgrade_shop(Role) of 
        {false, Reason} ->
            {reply, {?failed_op, Reason}};
        ok ->
            {ok}
    end;

%% 升级许愿池
handle(12743, {?upgrade_wish}, Role) ->
    case guild_common:upgrade_wish(Role) of 
        {false, Reason} ->
            {reply, {?failed_op, Reason}};
        ok ->
            {ok}
    end;

%% 群发离线消息
handle(12744, {Content}, Role) ->
    case guild_common:send_offline_msg(Content, Role) of
        {ok, Msg} ->
            {reply, {?success_op, Msg}};
        {false, Reason} ->
            {reply, {?failed_op, Reason}}
    end;

%% 修改权限限定信息
handle(12745, {Skill, Stove, Store}, Role) ->
    case guild_common:permission(Skill, Stove, Store, Role) of
        {false, Reason} ->
            {reply, {?failed_op, Reason}};
        ok ->
            {ok}
    end;

%% 获取权限限定信息
handle(12746, {}, #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{permission = {Skill, Stove, Store}} ->
            {reply, {Skill, Stove, Store}};
        _ ->
            {reply, {0, 0, 0}}
    end;

%% 贡献兑换修为
handle(12747, {_Devote}, _Role) ->
    {reply, {?failed_op, ?L(<<"该功能暂时被屏蔽，请静候下次更新，谢谢！">>)}};

%% 寄养宠物升级
handle(12748, {}, Role) ->
    case guild_pet_deposit:pet_upgrade(Role) of
        {true, NewRole} ->
            {reply, {?success_op, ?L(<<"寄养宠物升级成功">>)}, NewRole};
        {false, _} ->
            {ok}
    end;

%% 获取宠物寄养时间
handle(12749, {}, Role) ->
    case guild_pet_deposit:pet_deposited(Role) of
        NewRole = #role{pet = #pet_bag{deposit = {_, Time, _}}} when Time =/=0 ->
            {reply, {Time}, NewRole};
        NewRole ->
            {reply, {0}, NewRole}
    end;

%% 宠物寄养
handle(12750, {Petid, Time}, Role) ->
    case guild_pet_deposit:pet_deposit(Petid, Time, Role) of
        {false, Reason} ->
            {reply, {?failed_op, Reason}};
        {true, NewRole} ->
            {reply, {?success_op, ?MSGID(<<"宠物寄养成功">>)}, NewRole}
    end;

%% 取消寄养
handle(12751, {}, Role) ->
    {reply, {?success_op, <<>>}, guild_pet_deposit:pet_undeposited(Role)};

%% 进入军团领地
handle(12753, {}, Role) ->
    case guild_area:enter(quick, Role) of
        {ok, NewRole} ->
            {ok, NewRole};
        {false, Reason} ->
            {reply, {?failed_op, Reason}};
        {ok} ->
            {ok}
    end;

%% 离开军团领地
handle(12754, {}, Role) ->
    case guild_area:leave(Role) of
        {ok, NewRole} ->
            {ok, NewRole};
        {ok} ->
            {ok};
        {false, Reason} ->
            {reply, {?failed_op, Reason}}
    end;

%% 正常进入军团
handle(12755, {}, Role) ->
    case guild_area:enter(normal, Role) of
        {false, Reason} ->
            {reply, {?failed_op, Reason}};
        {ok, NewRole} ->
            {ok, NewRole};
        {ok} ->
            {ok}
    end;

%% 获取军团目标情况
handle(12761, {}, Role) ->
    Ret = guild_aim:aims_status(Role),
    ?DEBUG("---------------- 军团目标  ~w", [Ret]),
    {reply, Ret};

%% 领取军团目标奖励
handle(12762, {Type}, Role) ->
    case guild_aim:claim_aim(Type, Role) of
        {false, Reason} ->
            {reply, {Reason}};
        _ ->
            {ok}
    end;

%% 获取军团目标所有数据
handle(12765, {}, _Role) ->
    {reply, {guild_aim:aims_data()}};

%% 取消军团申请
handle(12766, {Gid, Gsrvid}, Role) ->
    case guild_mem:cancel_apply(Gid, Gsrvid, Role) of
        {false, Reason} ->
            {reply, {?false, Reason, 0, <<>>}};
        ok ->
            {reply, {?true, ?L(<<"加入军团申请取消成功">>), Gid, Gsrvid}}
    end;

%% 获取今天阅读次数
handle(12767, {}, Role) ->
    {reply, guild_role:read_times(Role)};

%% 阅读藏经阁
handle(12768, {}, Role) ->
    case guild_role:read(Role) of
        {true, Msg, NewRole} ->
            {reply, {Msg}, NewRole};
        {false, Reason} ->
            {reply, {Reason}}
    end;

%% 根据角色来申请入帮
handle(12769, {Rid, Srvid}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case guild_mem:apply_for(by_role, {Rid, Srvid}, Role) of
        {false, Reason} ->
            sys_conn:pack_send(ConnPid, 12705, {?false, Reason, 0, <<>>});
        {ok, {Gid, Gsrvid}, Msg} ->
            sys_conn:pack_send(ConnPid, 12705, {?true, Msg, Gid, Gsrvid}) 
    end,
    {ok};

%% 宠物寄养加速
handle(12770, {Minute}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case guild_pet_deposit:deposit_speed(Minute, Role) of
        {false, Reason} ->
            {reply, {?false, Reason}};
        {ErrorType, Reason} ->
            {reply, {ErrorType, Reason}};
        NewRole = #role{pet = #pet_bag{deposit = {_, Time, _}}} when Time =/=0 ->
            sys_conn:pack_send(ConnPid, 12749, {Time}),
            {reply, {?true, ?L(<<"加速成功">>)}, NewRole};
        NewRole ->
            sys_conn:pack_send(ConnPid, 12749, {0}),
            {reply, {?true, ?L(<<"加速成功">>)}, NewRole}
    end;

%% 获取宝库物品数据
handle(12771, {Type}, #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    Treasures = guild_treasure:get_treasures(Type, {Gid, Gsrvid}),
    Scores = guild_treasure:get_treasures_score(Type, {Gid, Gsrvid}),
    {reply, {Type, Treasures, Scores}};

%% 分配宝库物品
handle(12772, {_Type, _Tid, _Tsrvid, _ID, Quantity}, Role) when Quantity < 1 ->
    ?ERR("角色在尝试分配 ~w 个宝库物品", [Role#role.name]),
    {ok};
handle(12772, {Type, Tid, Tsrvid, ID, Quantity}, Role) ->
    case guild_treasure:allocate(Role, Tid, Tsrvid, ID, Quantity, Type) of
        {false, Reason} ->
            {reply, {?false, Reason}};
        _ ->
            {ok}
    end;

%% 自动分配宝库物品
handle(12773, {Type}, Role) ->
    case guild_treasure:allocate(Role, Type) of
        {false, Reason} ->
            {reply, {?false, Reason}};
        _ ->
            {ok}
    end;

%% 帮战成绩
handle(12774, {}, #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    Now = util:unixtime(),
    case get(guild_rpc_12774) of   %% 不给角色频繁去访问宝库数据, 因为访问帮战数据是一个同步请求
        Time when is_integer(Time) andalso Now - Time =< 5 ->
            {ok};
        _ ->
            put(guild_rpc_12774, Now),
            {CreditCompete, CreditSword, Credit} = guild_treasure:get_guild_war_info({Gid, Gsrvid}),
            List = guild_treasure:get_guild_war_member_info_rank({Gid, Gsrvid}),
            {reply, {CreditCompete, CreditSword, Credit, List}}
    end;

handle(12777, {}, Role) ->
    {reply, guild_treasure:get_allocate_log(Role)};

handle(12778, {}, #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        false ->
            {ok};
        #guild{members = Mems, impeach = #impeach{status = Status, time = Time, name = Name}} ->
            LogIntime = case lists:keyfind(?guild_chief, #guild_member.position, Mems) of
                false -> 0;
                #guild_member{date = Date} -> Date
            end,
            {reply, {Status, Time, Name, LogIntime}}
    end;

handle(12779, {}, Role) ->
    case guild_mem:active_impeach(Role) of
        {false, Reason} -> 
            {reply, {?false, Reason}};
        {ok, NewRole, Msg} ->
            {reply, {?true, Msg}, NewRole}
    end;

handle(12780, {}, Role) ->
    case guild_mem:reject_impeach(Role) of
        {false, Reason} ->
            {reply, {?false, Reason}};
        _ ->
            {ok}
    end;

handle(12781, {}, Role) ->
    guild_store:tidy(Role),
    {ok};

handle(12782, {Gname}, _Role) when byte_size(Gname) =:=0 ->
    {reply, {?failed_op, ?MSGID(<<"请输入军团名称">>)}};        %% 军团名字空
handle(12782, {Gname}, _Role) when byte_size(Gname) > ?create_name_length ->
    {reply, {?failed_op, ?MSGID(<<"军团名称过长">>)}};      %% 军团名字过长
handle(12782, {Gname}, Role) ->
    case Gname =:= ?L(<<"无军团">>) of
        false ->
            case util:text_banned(Gname) of
                false ->
                    case guild_mgr:is_guild_exist(Gname) of
                        false ->
                            case guild_merge:alter_name(Gname, Role) of
                                ok ->
                                    {ok};
                                {false, Reason} ->
                                    {reply, {?failed_op, Reason}}
                            end;
                        true ->
                            {reply, {?failed_op, ?MSGID(<<"该军团名已被使用，请重新输入">>)}}
                    end;
                true ->
                    {reply, {?failed_op, ?MSGID(<<"请勿输入敏感词或非法字符">>)}}
            end;
        _ ->
            {reply, {?failed_op, ?MSGID(<<"请输入非默认军团名称">>)}}
    end;

handle(12783, {}, #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    {First, Second, Third, Total} = guild_treasure:get_guild_arena_info({Gid, Gsrvid}),
    List = guild_treasure:get_guild_arena_member_info_rank({Gid, Gsrvid}),
    {reply, {First, Second, Third, Total, List}};

%% 军团合并列表申请
handle(12785, {}, Role) ->
    ?DEBUG("=======================================>12785"),
    case guild_union:get_union_info(Role) of
        {false, Reason} -> {reply, {0, Reason, []}};
        {ok, GuildList} -> {reply, {1, <<>>, GuildList}}
    end;

%% 军团合并队长选择方式并确认
handle(12786, {Gid1, Gsrvid1, Gname1, Gid2, Gsrvid2, Gname2}, Role) ->
    ?DEBUG("=======================================>12786 [~s <- ~s]", [Gname1, Gname2]),
    case guild_union:send_union_apply(Role, {Gid1, Gsrvid1, Gname1, Gid2, Gsrvid2, Gname2}) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok} -> {reply, {1, ?MSGID(<<"请等待对方确认">>)}}
    end;

%% 同意军团合并 进行合并操作
handle(12788, {_Gid1, _Gsrvid1, _Gid2, _Gsrvid2, 0}, Role) ->
    guild_union:disagree_union(Role),
    {ok};
handle(12788, {Gid1, Gsrvid1, Gid2, Gsrvid2, 1}, Role) ->
    ?DEBUG("=======================================>12788_1"),
    case guild_union:agree_union(Role, {Gid1, Gsrvid1, Gid2, Gsrvid2}) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok} -> {reply, {1, ?MSGID(<<"合帮成功">>)}}
    end;

%% 欢迎新成员加入
handle(12790, {Rid, Srvid}, Role) ->
    case guild_mem:welcome(Role, {Rid, Srvid}) of
        {ok, NewRole, Type, Name} ->
            Msg = case Type of
                1 -> util:fbin(?L(<<"您成功送给【~s】888点经验作为欢迎之礼">>), [Name]);
                2 -> util:fbin(?L(<<"您成功送给【~s】888绑定铜币作为欢迎之礼">>), [Name]);
                3 -> util:fbin(?L(<<"您成功送给【~s】1朵鲜花作为欢迎之礼">>), [Name])
            end,
            {reply, {1, Msg}, NewRole};
        {false, NewRole, Msg} ->
            {reply, {0, Msg}, NewRole};
        {false, Reason} ->
            {reply, {0, Reason}}
    end;

%% 升级军团
handle(12791, {}, Role) ->
    case guild_common:upgrade(Role) of
        {false, gold_less} ->
            {reply, {?gold_less, <<>>}};
        {false, Reason} ->
            {reply, {?false, Reason}};
        {ok, NewRole} ->
            {reply, {?true, ?MSGID(<<"你提交请求已经接受，正在升级中，请注意军团频道信息">>)}, NewRole}
    end;

%% 同步许愿数据给客户端
handle(12792, {}, Role = #role{link = #link{conn_pid = ConnPid}, guild=#role_guild{wish = #wish{times = Times, type = Type, item = Item}}}) ->
    Logs = guild_common:get_wish_item_log(Role),
    sys_conn:pack_send(ConnPid, 12795, {Logs}),
    {reply, {Times, Type, Item}};

%% 军团许愿
handle(12793, {}, Role = #role{link = #link{conn_pid=ConnPid}} ) ->
    case guild_common:wish(Role) of
    {ok, NewRole} ->
        #role{guild = #role_guild{wish = #wish{type = Type, item = Item, num = Num, times=Times}, devote=Devote}} = NewRole,
        log:log(log_guild_wishshop, {<<"许愿">>, Item, Num, ?wish_cost, NewRole}),
        sys_conn:pack_send(ConnPid, 12792, {Times, Devote, 0}),
        role_listener:guild_wish(Role, {}),
        {reply, {0, Type, Item, Num}, NewRole};
    {false, Reason} ->
        {reply, {Reason, 0, 0, 0}}
    end;

%% 获取许愿物品
handle(12794, {}, Role = #role{guild = #role_guild{wish = #wish{}}}) ->
    case guild_common:get_wish_item(Role) of
        {false, Reason} ->
            ?DEBUG("获取许愿物品失败~p~n", [Reason]),
            {reply, {Reason}};
        {ok, NewRole} ->
            {reply, {?MSGID(<<"获取物品成功">>)}, NewRole}
    end;

handle(12796, {}, #role{guild = #role_guild{shop = #shop{times = Times}}}) ->
    {reply, {Times}};

handle(12797, {ItemId, _ItemNum}, Role ) ->
    case guild_common:item_can_buy(ItemId, Role) of
        true ->
            case guild_common:buy(ItemId, Role) of
                {false, Reason} ->
                    ?DEBUG("购买失败，原因~p~n", [Reason]),
                    {reply, {Reason}};
                {ok, Role1, Devote} ->
                    ?DEBUG("购买成功"),
                    log:log(log_guild_wishshop, {<<"购买">>, ItemId, 1, Devote, Role1}),
                    role_listener:guild_buy(Role1, {}),
                    {reply, {?MSGID(<<"兑换成功">>)}, Role1}
            end;
        false ->
            {reply, {?MSGID(<<"不能兑换此物品">>)}}
    end;

%% 查看别的军团的成员信息
handle(12798, {Gid, Gsrvid}, _Role) ->
     case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{ members = Members} ->
            Mems = lists:foldl(fun(M = #guild_member{pid = Pid}, Acc) ->
                    case Pid of
                        0 ->
                            [M|Acc];
                        _ ->
                            [M#guild_member{pid = 1} | Acc]
                    end
                        end, [], Members),
                    {reply, {[{Name, Lev, Pos, Fight} ||  #guild_member{name=Name, lev=Lev, position=Pos, fight=Fight}  <- Mems]}};
            
        _ ->
            {reply, {[]}}
    end;

handle(12799, {}, Role) ->
    case guild_mem:auto_apply(Role) of
    {false, MsgId} ->
        {reply, {?false, MsgId, []}};
    {ok, MsgId, Role1} when is_record(Role1, role) ->
         {reply, {?true, MsgId, []}, Role1};
    {applyed, MsgId, Applyed} ->
        ?DEBUG("*********** 智能申请的军团列表: ~w", [Applyed]),
        {reply, {?true, MsgId, Applyed}}
    end;

handle(_Cmd, _Data, _Role) ->
    ?ERR("军团rpc出错，协议~p, 数据~p, 角色~p", [_Cmd, _Data, 0]),
    {error, unknow_command}.

%% ------------------------------
%% [{type, lev} | ]
sort_skills(Skills) ->
    F = fun({Type1, Lev1}, {Type2, Lev2}) ->
            case Lev1 > Lev2 of
                true ->
                    true;
                false ->
                    Type1 < Type2 
            end
    end,
    lists:sort(F, Skills).

%% util:fbin(?L(<<"<a href='11102&~w&~s'><font color='FF08ff0e'><u>~s</u></font></a>">>), [Gid, Srvid, Gname])
%% util:fbin(?L(<<"<a href='11103&~w&~s'><font color='FF08ff0e'><u>加入</u></font></a>">>), [Gid, Srvid])	
	
broadcast(Role = #role{guild = #role_guild{gid = Gid, srv_id = Srvid, name = Gname}}) ->
    RoleName = notice:get_role_msg(Role),
    GuildInfo = util:fbin(?L(<<"<a href='11102&~w&~s'><font color='FF08ff0e'><u>~s</u></font></a>">>), [Gid, Srvid, Gname]),
    JoinInfo = util:fbin(?L(<<"<a href='11103&~w&~s'><font color='FF08ff0e'><u>加入</u></font></a>">>), [Gid, Srvid]),
    Msg = util:fbin(?L(<<"~s创建了军团~s，勇敢的冒险家们快快~s吧！！！">>), [RoleName, GuildInfo, JoinInfo]),
    role_group:pack_cast(world, 10932, {7, 1, Msg}).

