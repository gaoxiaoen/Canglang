%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 一月 2016 下午4:50
%%%-------------------------------------------------------------------
-module(pet_log).
-author("fengzhenlin").
-include("common.hrl").

%% API
-export([
    log_pet/6,
    log_pet_skill/7,
    log_pet_stage/5,
    log_pet_pic/4,
    log_pet_star/7,
    log_pet_figure/4
]).


log_pet(Pkey, Name, PetKey, PTypeId, Pname, Type) ->
    Sql = io_lib:format("insert into log_pet set pkey=~p,nickname = '~s',petkey=~p,ptypeid=~p,pname = '~s',type=~p,`time`=~p",
        [Pkey, Name, PetKey, PTypeId, Pname, Type, util:unixtime()]),
    log_proc:log(Sql),
    ok.

log_pet_skill(Pkey, Name, PetKey, PTypeId, Pname, OldSkill, NewSkill) ->
    Sql = io_lib:format("insert into log_pet_skill set pkey=~p,nickname = '~s',petkey=~p,ptypeid=~p,pname = '~s',old_skill='~s',new_skill='~s',`time`=~p",
        [Pkey, Name, PetKey, PTypeId, Pname, util:term_to_bitstring(OldSkill), util:term_to_bitstring(NewSkill), util:unixtime()]),
    log_proc:log(Sql),
    ok.


log_pet_stage(Pkey, Nickname, Evolve, Lv, Exp) ->
    Sql = io_lib:format("insert into log_pet_stage set pkey=~p,nickname = '~s',stage=~p,lv=~p,exp=~p,time=~p",
        [Pkey, Nickname, Evolve, Lv, Exp, util:unixtime()]),
    log_proc:log(Sql).

log_pet_pic(Pkey, Nickname, FigureId, Lv) ->
    Sql = io_lib:format("insert into log_pet_pic set pkey=~p,nickname = '~s',figure_id=~p,lv=~p,time=~p", [Pkey, Nickname, FigureId, Lv, util:unixtime()]),
    log_proc:log(Sql).

log_pet_star(Pkey, Nickname, PetKey, PetTypeId, PetName, Star, Exp) ->
    Sql = io_lib:format("insert into log_pet_star set pkey=~p,nickname = '~s',`pet_key`=~p,pet_type_id=~p,pet_name = '~s',star=~p,exp=~p,time=~p",
        [Pkey, Nickname, PetKey, PetTypeId, PetName, Star, Exp, util:unixtime()]),
    log_proc:log(Sql).


log_pet_figure(Pkey, Nickname, Figure_old, Figure_new) ->
    Sql = io_lib:format("insert into log_pet_figure set pkey=~p,nickname='~s', figure_old=~p,figure_new=~p,time=~p",
        [Pkey, Nickname, Figure_old, Figure_new, util:unixtime()]),
    db:execute(Sql),
    ok.
