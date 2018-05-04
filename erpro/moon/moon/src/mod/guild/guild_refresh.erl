%----------------------------------------------------
%%  帮会数据 主动向客户端刷新
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_refresh).
-export([refresh/3]).

-include("common.hrl").
-include("guild.hrl").
-include("role.hrl").

%%------------------------------------------------------
%% 137协议进行数据刷新
%%-----------------------------------------------------
%% 刷新帮会资金
refresh(13720, _Fund, []) ->
    ok;
refresh(13720, Fund, [#guild_member{pid = Pid} | T]) when is_pid(Pid) ->
    role:pack_send(Pid, 13720, {Fund}),
    refresh(13720, Fund, T);
refresh(13720, Fund, [_ | T]) ->
    refresh(13720, Fund, T);

%% 刷新帮会数值类数据
refresh(13721, _DataList, []) ->
    ok;
refresh(13721, DataList, [#guild_member{pid = Pid} | T]) when is_pid(Pid) ->
    role:pack_send(Pid, 13721, {DataList}),
    refresh(13721, DataList, T);
refresh(13721, DataList, [_ | T]) ->
    refresh(13721, DataList, T);

%% 刷新帮会字符串类数据
refresh(13722, _DataList, []) ->
    ok;
refresh(13722, DataList, [#guild_member{pid = Pid} | T]) when is_pid(Pid) ->
    role:pack_send(Pid, 13722, {DataList}),
    refresh(13722, DataList, T);
refresh(13722, DataList, [_ | T]) ->
    refresh(13722, DataList, T);

%% 删除一条留言
refresh(13723, _ID, []) ->
    ok;
refresh(13723, ID, [#guild_member{pid = Pid} | T]) when is_pid(Pid) ->
    role:pack_send(Pid, 13723, {ID}),
    refresh(13723, ID, T);
refresh(13723, Data, [_ | T]) ->
    refresh(13723, Data, T);

%% 增加一条留言
refresh(13724, _Note, []) ->
    ok;
refresh(13724, Note, [#guild_member{pid = Pid} | T]) when is_pid(Pid) ->
    role:pack_send(Pid, 13724, Note),
    refresh(13724, Note, T);
refresh(13724, Data, [_ | T]) ->
    refresh(13724, Data, T);

%% 清除所有的申请记录
refresh(13725, {}, []) ->
    ok;
refresh(13725, {}, [#guild_member{pid = Pid} | T]) when is_pid(Pid) ->
    role:pack_send(Pid, 13725, {}),
    refresh(13725, {}, T);
refresh(13725, {}, [_ | T]) ->
    refresh(13725, {}, T);

%% 删除一条申请记录
refresh(13726, _ID, []) ->
    ok;
refresh(13726, {Rid, Rsrvid}, [#guild_member{pid = Pid} | T]) when is_pid(Pid) ->
    role:pack_send(Pid, 13726, {Rid, Rsrvid}),
    refresh(13726, {Rid, Rsrvid}, T);
refresh(13726, Data, [_ | T]) ->
    refresh(13726, Data, T);

%% 增加一条申请记录
refresh(13727, _Apply, []) ->
    ok;
refresh(13727, Apply, [#guild_member{pid = Pid} | T]) when is_pid(Pid) ->
    role:pack_send(Pid, 13727, Apply),
    refresh(13727, Apply, T);
refresh(13727, Data, [_ | T]) ->
    refresh(13727, Data, T);

%% 删除一个成员（成员列表）
refresh(13728, _ID, []) ->
    ok;
refresh(13728, {Rid, Rsrvid}, [#guild_member{pid = Pid} | T]) when is_pid(Pid) ->
    role:pack_send(Pid, 13728, {Rid, Rsrvid}),
    refresh(13728, {Rid, Rsrvid}, T);
refresh(13728, Data, [_ | T]) ->
    refresh(13728, Data, T);

%% 增加（更新）一个成员（成员列表）
refresh(13729, _Member, []) ->
    ok;
refresh(13729, Member = #guild_member{pid = Pid, id = {Rid, Rsrvid}, name = Name, lev = Lev, position = Job, sex = Sex, career = Career,
        fight = Fight, vip = Vip, donation = Do, gravatar = Icon, date = Date, pet_fight = PF}, [#guild_member{pid = MPid} | T]
) when is_pid(MPid) ->
    case Pid of
        0 -> role:pack_send(MPid, 13729, {Rid, Rsrvid, Name, Lev, Job, Fight, Vip, Icon, Do, Date, Pid, PF, Career, Sex});
        _ -> role:pack_send(MPid, 13729, {Rid, Rsrvid, Name, Lev, Job, Fight, Vip, Icon, Do, Date, 1, PF, Career, Sex})
    end,
    refresh(13729, Member, T);
refresh(13729, Data, [_ | T]) ->
    refresh(13729, Data, T);

%% 增加一条贡献日志
refresh(13730, _DonationLog, []) ->
    ok;
refresh(13730, DonationLog, [#guild_member{pid = Pid} | T]) when is_pid(Pid) ->
    role:pack_send(Pid, 13730, DonationLog),
    refresh(13730, DonationLog, T);
refresh(13730, Data, [_ | T]) ->
    refresh(13730, Data, T);

%% 刷新技能等级
refresh(13731, _SkillInfo, []) ->
    ok;
refresh(13731, SkillInfo, [#guild_member{pid = Pid} | T]) when is_pid(Pid) ->
    role:pack_send(Pid, 13731, SkillInfo),
    
    refresh(13731, SkillInfo, T);
refresh(13731, SkillInfo, [_|T]) ->
    refresh(13731, SkillInfo, T);

%%------------------------------------------------------
%% 127协议进行数据刷新
%%-----------------------------------------------------
%% 刷新贡献统计
refresh(12735, _List, []) ->
    ok;
refresh(12735, List, [#guild_member{pid = Pid} | T]) when is_pid(Pid) ->
    role:pack_send(Pid, 12735, {List}),
    refresh(12735, List, T);
refresh(12735, List, [_| T]) ->
    refresh(12735, List, T);

%% 刷新帮会公告
refresh(12746, _Permission, []) ->
    ok;
refresh(12746, Permission, [#guild_member{pid = Pid} | T]) when is_pid(Pid) ->
    role:pack_send(Pid, 12746, Permission),
    refresh(12746, Permission, T);
refresh(12746, Data, [_ | T]) ->
    refresh(12746, Data, T);

refresh(_Cmd, _Data, _Mem) ->
    ?DEBUG("[~w] 数据刷新调用错误", [?MODULE]),
    ok.

