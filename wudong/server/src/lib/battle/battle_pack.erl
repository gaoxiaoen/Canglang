%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 八月 2015 上午11:38
%%%-------------------------------------------------------------------
-module(battle_pack).
-author("fancy").
-include("common.hrl").
-include("battle.hrl").
-include("skill.hrl").

%% API
-export([
    pack_battle_info_helper/1,
    pack_buff_list/2
]).

pack_battle_info_helper(BSList) ->
    [trans20001(BS) || BS <- BSList].


trans20001(BS) ->
    #bs{
        actor = Actor,
        sign = Sign,
        key = Key,
        hp_lim = HpLim,
        hp = Hp,
        is_restore_hp = IsRestoreHp,
        mp_lim = MpLim,
        mp = Mp,
        mana_lim = ManaLim,
        mana = Mana,
        sin = Sin,
        x = X,
        y = Y,
        is_move = IsMove,
        state = State,
        hurt_list = HurtList,
        buff_list = BuffList,
        now = Now,
        attacker = Attacker,
        element_hurt = ElementHurt
    } = BS,
    BuffListPack = pack_buff_list(BuffList, Now),
    Sign2 = Attacker#attacker.sign,
    [
        Actor, Sign, Sign2, Key, HpLim, Hp, IsRestoreHp, MpLim, Mp, ManaLim, Mana, Sin, X, Y, IsMove, State, ElementHurt, HurtList, BuffListPack
    ].

pack_buff_list(BuffList, Now) ->
    F = fun(SkillBuff) ->
        Rtime = ?IF_ELSE(SkillBuff#skillbuff.time > Now, round(SkillBuff#skillbuff.time - Now), 0),
        [
            SkillBuff#skillbuff.buffid,
            SkillBuff#skillbuff.skillid,
            SkillBuff#skillbuff.stack,
            Rtime
        ]

        end,
    lists:map(F, BuffList).


%%数值转换   1整数正数,2小数正数,3整数负数,4小数负数; 小数*1000取整再传
%% judge_value(V) ->
%%     if
%%         is_integer(V) ->
%%             case abs(V) == V of
%%                 true ->
%%                     {1,V};
%%                 false ->
%%                     {3,V}
%%             end;
%%         is_float(V) ->
%%             case abs(V) == V of
%%                 true ->
%%                     {2,trunc((V * 1000))};
%%                 false ->
%%                     {4,abs(trunc(V*1000))}
%%             end;
%%         true ->
%%             {0,0}
%%     end.
