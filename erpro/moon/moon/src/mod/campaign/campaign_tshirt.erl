%% *************************************
%% 周年庆Tshirt获奖信息收集
%% @author jackguan@jieyou.cn
%% @end
%% *************************************
-module(campaign_tshirt).
-export([add/2]).

-include("common.hrl").
-include("role.hrl").
-include("gain.hrl").

%% @spec add(Role, Data) -> ok | {false, Reason}
%% Role = #role{}
%% Data = term()
%% @doc 添加获奖者信息
add(Role = #role{id = {Rid, SrvId}, account = Acc, name = Name, lev = Lev, career = Career}, {BaseId, RealName, Addr, PostCode, Phone, Picture, Sex, Sizes}) ->
    Now = util:unixtime(),
    role:send_buff_begin(),
    case role_gain:do([#loss{label = item, val = [BaseId, 0, 1]}], Role) of
        {ok, NewRole} ->
            case find_info({Rid, SrvId}) of
                false -> %% 未填写信息
                    case add_db(Rid, SrvId, Name, Acc, Lev, Career, Sex, Sizes, RealName, Addr, PostCode, Phone, Picture, Sizes, Now) of
                        {false, failure} ->
                            role:send_buff_clean(),
                            {false, ?L(<<"获奖数据保存出错，请稍后再保存">>)};
                        true ->
                            role:send_buff_flush(),
                            {ok, NewRole}
                    end;
                true -> %% 已经添加玩家信息
                    role:send_buff_clean(),
                    {false, ?L(<<"亲，你已填写信息，不可重复填写">>)}
            end;
        {false, #loss{}} ->
            role:send_buff_clean(),
            {false, ?L(<<"没有T恤兑换令">>)};
        _ ->
            role:send_buff_clean(),
            {false, ?L(<<"兑换失败">>)}
    end.

%% 检查是否已经添加信息
%% 返回true | false
find_info({Rid, SrvId}) ->
    Sql = "select count(*) from log_tshirt where rid = ~s and srv_id = ~s",
    case db:get_one(Sql, [Rid, SrvId]) of
        {error, Reason} ->
            ?ERR("查找周年庆Tshirt获奖者信息出错：~s", [Reason]),
            false;
        {ok, Num} when Num >= 1 -> true;
        {ok, _} -> false
    end.

%% 插入数据库
add_db(Rid, SrvId, Name, Acc, Lev, Career, Sex, Sizes, RealName, Addr, PostCode, Phone, Picture, Sizes, Time) ->
    Info = util:fbin("收件人:~s, 地址:~s, 邮编:~s, 电话:~s", [RealName, Addr, PostCode, Phone]),
    Sql = "replace into log_tshirt (rid, srv_id, name, account, lev, career, sex, sizes, picture, info, ctime) VALUES (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
    case db:execute(Sql, [Rid, SrvId, Name, Acc, Lev, Career, Sex, Sizes, Picture, Info, Time]) of
        {error, _Reason} ->
            ?ERR("存入周年庆Tshirt获奖者信息出错"),
            {false, failure};
        {ok, _} ->
            true
    end.
