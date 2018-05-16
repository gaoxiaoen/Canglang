%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 三月 2017 20:22
%%%-------------------------------------------------------------------
-module(buff_init).
-author("hxming").
-include("server.hrl").
-include("common.hrl").
-include("skill.hrl").


%% API
-export([init/1, timer_update/0, logout/0, refresh_buff/1, check_exp_buff/2, add_buff/1, del_buff/1]).

-export([exp_buff/1]).


init(Player) ->
    Now = util:unixtime(),
    StBuff =
        case player_util:is_new_role(Player) of
            true ->
                #st_buff{pkey = Player#player.key};
            false ->
                case buff_load:load_buff(Player#player.key) of
                    [] ->
                        #st_buff{pkey = Player#player.key};
                    [BuffList] ->

                        F = fun({BuffId, Time}, {IsChange, L}) ->
                            if Time > Now ->
                                {IsChange, [{BuffId, Time} | L]};
                                true ->

                                    {1, L}
                            end
                        end,
                        {IsChange1, NewBuffList} = lists:foldl(F, {0, []}, util:bitstring_to_term(BuffList)),
                        #st_buff{pkey = Player#player.key, buff_list = NewBuffList, is_change = IsChange1}
                end
        end,
    lib_dict:put(?PROC_STATUS_BUFF, StBuff),

    F1 = fun({BuffId, Time}) ->
        case data_buff:get(BuffId) of
            [] -> [];
            BaseBuff ->
                buff_proc:set_buff(node(), self(), BuffId, max(1, Time - Now)),
                [#skillbuff{
                    buffid = BuffId,
                    skillid = 8888,
                    skilllv = 1,
                    stack_lim = BaseBuff#buff.stack,
                    stack = 1,
                    param = BaseBuff#buff.param,
                    time = Time,
                    type = BaseBuff#buff.type,
                    subtype = BaseBuff#buff.subtype
                }]
        end
    end,
    SkillBuffList = lists:flatmap(F1, StBuff#st_buff.buff_list),
    Player#player{buff_list = SkillBuffList}.



timer_update() ->
    StBuff = lib_dict:get(?PROC_STATUS_BUFF),
    if StBuff#st_buff.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_BUFF, StBuff#st_buff{is_change = 0}),
        buff_load:replace_buff(StBuff);
        true ->
            ok
    end.

logout() ->
    StBuff = lib_dict:get(?PROC_STATUS_BUFF),
    if StBuff#st_buff.is_change == 1 ->
        buff_load:replace_buff(StBuff);
        true ->
            ok
    end.


refresh_buff(Now) ->
    StBuff = lib_dict:get(?PROC_STATUS_BUFF),
    F = fun({BuffId, Time}, {IsTimeout, L1}) ->
        if Time > Now ->
            {IsTimeout, [{BuffId, Time} | L1]};
            true -> {true, L1}
        end
    end,
    {IsChange, BuffList} = lists:foldl(F, {false, []}, StBuff#st_buff.buff_list),
    if IsChange ->
        NewStBuff = StBuff#st_buff{buff_list = BuffList, is_change = 1},
        lib_dict:put(?PROC_STATUS_BUFF, NewStBuff);
        true ->
            ok
    end.

%%检查经验buff时间叠加上限
check_exp_buff(BuffId, Num) ->
    case data_buff:get(BuffId) of
        [] ->
            false;
        BaseBuff ->
            if BaseBuff#buff.type == 1 andalso BaseBuff#buff.subtype == 1 ->
                StBuff = lib_dict:get(?PROC_STATUS_BUFF),
                Now = util:unixtime(),
                BuffTime = BaseBuff#buff.time,
                case lists:keyfind(BuffId, 1, StBuff#st_buff.buff_list) of
                    false -> true;
                    {_, LastTime} ->
                        case max(0, LastTime - Now) + BuffTime * Num > ?ONE_HOUR_SECONDS * 12 of
                            true -> false;
                            false -> true
                        end
                end;
                true ->
                    true
            end
    end.

%%添加buff
add_buff(BuffId) ->
    case data_buff:get(BuffId) of
        [] ->
            ?ERR("udef buff ~p~n", [BuffId]),
            ok;
        BaseBuff ->
            StBuff = lib_dict:get(?PROC_STATUS_BUFF),
            Now = util:unixtime(),
            BuffTime = BaseBuff#buff.time,
            BuffList =
                case BaseBuff#buff.is_cover of
                    2 ->
                        {FilterList,Time0} = filter_buff1(BaseBuff, StBuff#st_buff.buff_list),
                        [{BuffId, Now + Time0 + BuffTime} | FilterList];
                    1 ->
                        FilterList = filter_buff(BaseBuff, StBuff#st_buff.buff_list),
                        [{BuffId, Now + BuffTime} | FilterList];
                    0 ->
                        case lists:keytake(BuffId, 1, StBuff#st_buff.buff_list) of
                            false ->
                                [{BuffId, Now + BuffTime} | StBuff#st_buff.buff_list];
                            {value, {_, OldTime}, T} ->
                                Time = buff_time(BaseBuff#buff.stack_type, Now, BuffTime, OldTime, BaseBuff#buff.time_max),
                                [{BuffId, Time} | T]
                        end
                end,
            NewStBuff = StBuff#st_buff{buff_list = BuffList, is_change = 1},
            lib_dict:put(?PROC_STATUS_BUFF, NewStBuff)
    end.

%%删除buff
del_buff(BuffId) ->
    StBuff = lib_dict:get(?PROC_STATUS_BUFF),
    case lists:keytake(BuffId, 1, StBuff#st_buff.buff_list) of
        false ->
            skip;
        {value, _, T} ->
            NewStBuff = StBuff#st_buff{buff_list = T, is_change = 1},
            lib_dict:put(?PROC_STATUS_BUFF, NewStBuff)
    end.

buff_time(StackType, Now, BuffTime, OldTime, AddMaxTime) ->
    case StackType of
        1 ->
            %%刷新时间，效果叠加
            Now + BuffTime;
        2 ->
            %%时间延长 t/层数
            OldTime + BuffTime;
        3 ->
            %%取最长时间
            max(Now + BuffTime, OldTime);
        4 ->
            %%替换
            Now + BuffTime;
        5 ->
            %%时间叠加
            ?IF_ELSE(OldTime == 0, Now + BuffTime, OldTime + BuffTime);
        6 ->
            %%时间叠加，并且有最大值
            if
                OldTime >= Now ->
                    AddTime = min(OldTime-Now+BuffTime, AddMaxTime),
                    Now + AddTime;
                true ->
                    Now + BuffTime
            end;
        _ ->
            Now + BuffTime
    end.

filter_buff(Buff, BuffList) ->
    F = fun({Id, _Time}) ->
        case data_buff:get(Id) of
            [] -> false;
            Base ->
                Base#buff.subtype =/= Buff#buff.subtype
        end
    end,
    lists:filter(F, BuffList).


filter_buff1(Buff, BuffList) ->
    F = fun({Id, Time}, {List, Time0}) ->
        case data_buff:get(Id) of
            [] -> {List, Time0};
            Base ->
                if Base#buff.subtype =/= Buff#buff.subtype ->
                    {[{Id, Time} | List], Time0};
                    true ->
                        {List, Time - util:unixtime()}
                end
        end
    end,
    lists:foldl(F, {[], 0}, BuffList).


%%获取经验buff加成
exp_buff(Player) ->
    F = fun(SkillBuff) ->
        if SkillBuff#skillbuff.type == 1 andalso SkillBuff#skillbuff.subtype == 1 ->
            [max(0, SkillBuff#skillbuff.param - 1)];
            true -> []
        end
    end,
    case lists:flatmap(F, Player#player.buff_list) of
        [] -> 0;
        ParamList ->
            lists:sum(ParamList)
    end.
