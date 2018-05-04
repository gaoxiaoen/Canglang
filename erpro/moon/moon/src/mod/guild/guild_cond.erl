%----------------------------------------------------
%%  军团系统 处理角色军团数据
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_cond).
-export([condition/2
    ]
).

-include("common.hrl").
-include("guild.hrl").
-include("role.hrl").
-include("attr.hrl").
%%


-define(THREEDAYSEC, 3*86400).       %% 三天时间 86400 = 24*60*60

%%-----------------------------------------------------------
%% @spec conditon(Cmd, Data) -> true | {false, Reason}
%% Cmd = aton()
%% Data = term()
%% @doc 条件判断类
%%----------------------------------------------------------
%% 申请入帮，对角色限制判断
condition(role_apply, #role{guild = #role_guild{gid = Gid}}) when Gid =/= 0 ->
    {false, ?MSGID(<<"您已加入军团，申请失败!">>)};
condition(role_apply, #role{})  ->
    case task:is_zhux_finish(?OPEN_TASK) of
        false ->
            {false, ?MSGID(<<"军团功能尚未开启">>)};
        _ ->
            true
    end;

%% 申请入帮，角色申请过的军团限制判断
condition(role_applyed, {Gid, Gsrvid, #role{id = {Rid, Rsrvid}}}) ->
    case guild_mgr:lookup_spec(Rid, Rsrvid) of
        false ->
            true;
        #special_role_guild{applyed = Applyed} when length(Applyed) >= ?max_apply ->
            {false, ?MSGID(<<"您已申请军团数过多">>)};
        #special_role_guild{applyed = Applyed} ->
            case lists:keyfind({Gid, Gsrvid}, 1, Applyed) of
                false ->
                    true;
                _ ->
                    {false, ?MSGID(<<"请勿重复操作">>)}
            end
    end;

%% 检查是否符合军团要求
condition(guild_limit, {#role{lev = RoleLev, attr = #attr{fight_capacity = RoleZdl}}, #guild{join_limit = #join_limit{lev = Lev, zdl = Zdl}}})
        when (Lev > 0 orelse Zdl > 0), (RoleLev >= Lev andalso RoleZdl >= Zdl) ->
            true;
condition(guild_limit, {#role{lev = _RoleLev, attr = #attr{fight_capacity = _RoleZdl}}, #guild{join_limit = #join_limit{lev = Lev, zdl = Zdl}}}) 
        when (Lev > 0 orelse Zdl > 0) ->
            {false, ?MSGID(<<"不符合加入军团要求">>)};
condition(guild_limit, {#role{lev = _RoleLev, attr = #attr{fight_capacity = _RoleZdl}}, #guild{join_limit = #join_limit{lev = Lev, zdl = Zdl}}}) 
        when (Lev =:= 0 andalso Zdl =:= 0) ->
            true;

%% 申请入帮，军团限制
condition(apply_guild, #guild{members = Mems, maxnum = MaxNum}) when length(Mems) >= MaxNum ->
    {false, ?MSGID(<<"该军团人数已满，您错过了机会">>)};
condition(apply_guild, #guild{apply_list = AL}) when length(AL) >= ?max_applyed ->
    {false, ?MSGID(<<"该军团申请人数过多，申请失败">>)};
condition(apply_guild, _Guild) ->
    true;

%% 推荐入帮
condition(recommend_guild, #guild{members = Mems, maxnum = MaxNum}) when length(Mems) >= MaxNum ->
    {false, ?MSGID(<<"该军团人数已满，您错过了机会">>)};
condition(recommend_guild, _Guild) ->
    true;

%%
condition(quit_date, #role{guild = #role_guild{quit_date = 0}}) -> true;
condition(quit_date, #role{guild = #role_guild{quit_date = QuitDate}}) ->
    Now = util:unixtime(),
    case Now - QuitDate >= 24 * 3600 of
        true ->
            true;
        false ->
            {false, ?MSGID(<<"退出军团24小时方可再次加入军团">>)}
    end;

%% 被推荐者 条件限制
condition(recommend_role, #guild_role{lev = Lev}) when Lev < ?join_lev_limit ->
    {false, ?MSGID(<<"这家伙不给力呀，赶紧催他升级吧">>)};
condition(recommend_role, #guild_role{gid = Gid}) when Gid =/= 0 -> 
    {false, ?MSGID(<<"对方已有军团">>)};
condition(recommend_role, _Role) ->
    true;

%% 申请入帮，对军团限制判断
condition({applyed, _Gid, _Gsrvid}, #special_role_guild{applyed = Applyed}) when length(Applyed) >= ?max_apply ->
    {false, ?MSGID(<<"您申请的军团数过多">>)};
condition({applyed, Gid, Gsrvid}, #special_role_guild{applyed = Applyed}) ->
    case lists:keyfind({Gid, Gsrvid}, 1, Applyed) of
        false ->
            true;
        _ ->
            {false, ?MSGID(<<"请勿重复操作">>)}
    end;

condition(#guild{}, #role{}) -> true;
condition(#guild{}, #guild_role{}) -> true;

condition(Type, _) ->
    ?ERR("无效的条件检测类型 ~w", [Type]),
    {false, <<>>}.
            

