%%----------------------------------------------------
%% 消息计数器系统 
%% 
%% @author qingxuan
%% @end
%%----------------------------------------------------
-module(notice_counter).
-export([
    login/1
    ,push/1
]).
-include("common.hrl").
-include("role.hrl").
-include("skill.hrl").
-include("link.hrl").

-define(count_can_learn_skill, 1).

-define(counter_list, [
    %{?count_can_learn_skill, fun count_can_learn_skill/1}   %% 可学技能
]).

login(Role = #role{}) ->
    role_timer:set_timer(?MODULE, 500, {?MODULE, push, []}, 1, Role),
    Role.

push(Role = #role{link = #link{conn_pid = ConnPid}}) ->
    Data = count(?counter_list, Role),
    sys_conn:pack_send(ConnPid, 11170, {Data}),
    {ok, Role}.
     
count(List, Role) ->
    count(List, Role, []).

count([{Key, F}|T], Role, Acc) ->
    Acc1 = try F(Role) of
        0 -> Acc; 
        Num when is_integer(Num) -> [{Key, Num}|Acc];
        _ -> Acc
        catch A:B ->
            ?ERR("~p : ~p : ~p", [A,B,erlang:get_stacktrace()]),
            Acc
    end,
    count(T, Role, Acc1);
count([], _Role, Acc) ->
    Acc.

%% -------------------------
%% -> int()
% count_can_learn_skill(_Role = #role{lev = Lev, skill = #skill_all{skill_list=SkillList}}) ->
%     lists:foldr(fun(Skill, Num)->
%         case is_record(Skill, skill) of
%             true ->
%                 case skill_data:get(Skill#skill.next_id) of
%                     Sk = #skill{} ->
%                         case Lev >= Sk#skill.cond_lev of
%                             true -> Num + 1;
%                             _ -> Num
%                         end;
%                     _ ->
%                         Num
%                 end;
%             _ ->
%                 Num
%         end
%     end, 0, SkillList).
    
