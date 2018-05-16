%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2015 11:03
%%%-------------------------------------------------------------------
-module(guild_war_figure).
-author("hxming").

-include("guild_war.hrl").
-include("common.hrl").
-include("server.hrl").
%% API
-compile(export_all).


format_figure(FigureList) ->
    FieldList = record_info(fields, p_figure),
    ValueList = lists:nthtail(1, tuple_to_list(#p_figure{})),
    KVList = lists:zipwith(fun(Key, Val) -> {Key, Val} end, FieldList, ValueList),
    F = fun(Figure) ->
        F1 = fun({Key, Val}, List) ->
            case lists:keyfind(Key, 1, Figure) of
                false ->
                    [Val | List];
                {_, NewVal} ->
                    [NewVal | List]
            end
             end,
        VList = lists:reverse(lists:foldl(F1, [], KVList)),
        list_to_tuple([p_figure | VList])
        end,
    lists:map(F, util:bitstring_to_term(FigureList)).

pack_figure(FigureList) ->
    FieldList = record_info(fields, p_figure),
    F = fun(Figure) ->
        ValueList = lists:nthtail(1, tuple_to_list(Figure)),
        lists:zipwith(fun(Key, Val) -> {Key, Val} end, FieldList, ValueList)
        end,
    lists:map(F, FigureList).

%%默认信息
default_figure(Pkey) ->
    F = fun(Id) ->
        #p_figure{figure = Id, lv = 1}
        end,
    FigureList = lists:map(F, data_guild_war_figure:ids()),
    StFigure = #st_figure{pkey = Pkey, figure_list = FigureList},
    ets:insert(?ETS_ST_FIGURE, StFigure),
    guild_war_load:replace_figure(StFigure),
    StFigure.

get_figure(Pkey) ->
    case ets:lookup(?ETS_ST_FIGURE, Pkey) of
        [] ->
            case guild_war_load:select_figure(Pkey) of
                null ->
                    default_figure(Pkey);
                FigureList ->
                    NewFigureList = guild_war_figure:format_figure(FigureList),
                    case check_figure(NewFigureList) of
                        {false, Val} ->
                            StFigure = #st_figure{pkey = Pkey, figure_list = Val},
                            ets:insert(?ETS_ST_FIGURE, StFigure);
                        {true, Val} ->
                            StFigure = #st_figure{pkey = Pkey, figure_list = Val},
                            ets:insert(?ETS_ST_FIGURE, StFigure)
                    end,
                    StFigure
            end;
        [StFigure] ->
            case check_figure(StFigure#st_figure.figure_list) of
                {false, _Val} ->
                    StFigure;
                {true, Val} ->
                    NewFigure = StFigure#st_figure{figure_list = Val},
                    ets:insert(?ETS_ST_FIGURE, NewFigure),
                    guild_war_load:replace_figure(NewFigure),
                    NewFigure
            end
    end.

%%获取形象列表
get_figure_list(Pkey) ->
    Figure = get_figure(Pkey),
    FigureList = Figure#st_figure.figure_list,

    F = fun(PFigure) ->
        [PFigure#p_figure.figure, PFigure#p_figure.lv]
        end,
    lists:map(F, FigureList).

%%检查升级
check_figure(FigureList) ->
    F = fun(Id, {IsUp, List}) ->
        case lists:keyfind(Id, #p_figure.figure, FigureList) of
            false ->
                {true, [#p_figure{figure = Id, lv = 1} | List]};
            Val ->
                {IsUp, [Val | List]}
        end
        end,
    lists:foldl(F, {false, []}, data_guild_war_figure:ids()).

%%计算形象属性加成
count_figure_attribute(Player) ->
    case data_guild_war_figure:get(Player#player.figure) of
        [] -> Player;
        Base ->
            HpLim = round(Base#base_guild_war_figure.hp_per + Player#player.attribute#attribute.hp_lim),
            Att = round(Player#player.attribute#attribute.att * Base#base_guild_war_figure.att_per),
            Player#player{attribute = Player#player.attribute#attribute{hp_lim = HpLim, att = Att}}
    end.

%%增加贡献，升价
%%Type 1采集，2助攻，3击杀
add_contrib(Pkey, FigureId, Contrib, Type) ->
    StFigure = guild_war_figure:get_figure(Pkey),
    case lists:keyfind(FigureId, #p_figure.figure, StFigure#st_figure.figure_list) of
        false ->
            0;
        Figure ->
            Base = data_guild_war_figure:get(FigureId),
            ExrPercent =
                case Type of
                    1 ->
                        Base#base_guild_war_figure.collect_per;
                    2 ->
                        Base#base_guild_war_figure.assists_per;
                    3 ->
                        Base#base_guild_war_figure.kill_per;
                    _ -> 0
                end,
            %%extra_contrib = [{1,10,50},{2,0,0}]
            Add =
                case lists:keyfind(Type, 1, Base#base_guild_war_figure.extra_contrib) of
                    false -> 0;
                    {_, Add1, Limit} ->
                        min((Figure#p_figure.lv - 1) * Add1, Limit)
                end,
            ContribAdd = round(Contrib * ExrPercent) + Add,
            ContribTotal = Figure#p_figure.contrib + ContribAdd,
            if ContribTotal >= Base#base_guild_war_figure.contrib ->
                NewFigure = Figure#p_figure{lv = Figure#p_figure.lv + 1, contrib = ContribTotal - Base#base_guild_war_figure.contrib};
                true ->
                    NewFigure = Figure#p_figure{contrib = ContribTotal}
            end,
            FigureList = lists:keyreplace(FigureId, #p_figure.figure, StFigure#st_figure.figure_list, NewFigure),
            NewStFigure = StFigure#st_figure{figure_list = FigureList},
            ets:insert(?ETS_ST_FIGURE, NewStFigure),
            guild_war_load:replace_figure(NewStFigure),
            ContribAdd
    end.