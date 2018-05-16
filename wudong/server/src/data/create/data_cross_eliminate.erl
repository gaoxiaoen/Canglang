%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_eliminate
	%%% @Created : 2017-11-23 20:28:57
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_eliminate).
-export([ids/0]).
-export([get_type/1]).
-export([get_ratio/1]).
-export([get_score/1]).
-export([get_eli_score/1]).
-export([get_buff/1]).
-include("common.hrl").

    ids() ->
    [37201,37202,37203,37204,37205,37206,37207,37208].
get_type(37201)->1;
get_type(37202)->1;
get_type(37203)->1;
get_type(37204)->2;
get_type(37205)->3;
get_type(37206)->4;
get_type(37207)->5;
get_type(37208)->6;
get_type(_) -> 0.
get_ratio(37201)->2850;
get_ratio(37202)->2850;
get_ratio(37203)->2850;
get_ratio(37204)->450;
get_ratio(37205)->450;
get_ratio(37206)->250;
get_ratio(37207)->200;
get_ratio(37208)->100;
get_ratio(_) -> 0.
get_score(37201)->1;
get_score(37202)->1;
get_score(37203)->1;
get_score(37204)->1;
get_score(37205)->1;
get_score(37206)->1;
get_score(37207)->1;
get_score(37208)->20;
get_score(_) -> 0.
get_eli_score(37201)->5;
get_eli_score(37202)->5;
get_eli_score(37203)->5;
get_eli_score(37204)->5;
get_eli_score(37205)->5;
get_eli_score(37206)->5;
get_eli_score(37207)->5;
get_eli_score(37208)->5;
get_eli_score(_) -> 0.
get_buff(37201)->[{0,7300},{56202,300},{56203,300}];
get_buff(37202)->[{0,7300},{56202,300},{56203,300}];
get_buff(37203)->[{0,7300},{56202,300},{56203,300}];
get_buff(37204)->[];
get_buff(37205)->[];
get_buff(37206)->[];
get_buff(37207)->[];
get_buff(37208)->[];
get_buff(_) -> [].
