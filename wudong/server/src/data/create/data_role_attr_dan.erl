%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_role_attr_dan
	%%% @Created : 2017-11-07 11:44:20
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_role_attr_dan).
-export([get_all/0]).
-export([get/1]).
-include("goods.hrl").

       get_all() ->
       [1401001,1401002,1401003,1401004,1401005,1401006,1401007,1401008,1401009,1401010,1401011,1402001,1402002,1402003,1402004,1402005,1402006,1402007,1402008,1402009,1402010,1402011,1403001,1403002,1403003,1403004,1403005,1403006,1403007,1403008,1403009,1403010,1403011].
   get(1401001) -> #base_role_attr_dan{type = 1 ,id = 1 ,goods_id = 1401001 ,attr_list = [{att,6}],daily_limit = 100 ,max_count = 2000};
get(1401002) -> #base_role_attr_dan{type = 1 ,id = 2 ,goods_id = 1401002 ,attr_list = [{def,6}],daily_limit = 100 ,max_count = 2000};
get(1401003) -> #base_role_attr_dan{type = 1 ,id = 3 ,goods_id = 1401003 ,attr_list = [{hp_lim,60}],daily_limit = 100 ,max_count = 2000};
get(1401004) -> #base_role_attr_dan{type = 1 ,id = 4 ,goods_id = 1401004 ,attr_list = [{att,12}],daily_limit = 75 ,max_count = 1000};
get(1401005) -> #base_role_attr_dan{type = 1 ,id = 5 ,goods_id = 1401005 ,attr_list = [{def,12}],daily_limit = 75 ,max_count = 1000};
get(1401006) -> #base_role_attr_dan{type = 1 ,id = 6 ,goods_id = 1401006 ,attr_list = [{hp_lim,120}],daily_limit = 75 ,max_count = 1000};
get(1401007) -> #base_role_attr_dan{type = 1 ,id = 7 ,goods_id = 1401007 ,attr_list = [{att,20}],daily_limit = 50 ,max_count = 500};
get(1401008) -> #base_role_attr_dan{type = 1 ,id = 8 ,goods_id = 1401008 ,attr_list = [{def,20}],daily_limit = 50 ,max_count = 500};
get(1401009) -> #base_role_attr_dan{type = 1 ,id = 9 ,goods_id = 1401009 ,attr_list = [{hp_lim,200}],daily_limit = 50 ,max_count = 500};
get(1401010) -> #base_role_attr_dan{type = 1 ,id = 10 ,goods_id = 1401010 ,attr_list = [{att,20},{def,20},{hp_lim,200}],daily_limit = 10 ,max_count = 100};
get(1401011) -> #base_role_attr_dan{type = 1 ,id = 11 ,goods_id = 1401011 ,attr_list = [{att,40},{def,40},{hp_lim,400}],daily_limit = 5 ,max_count = 50};
get(1402001) -> #base_role_attr_dan{type = 2 ,id = 1 ,goods_id = 1402001 ,attr_list = [{att,30}],daily_limit = 100 ,max_count = 2000};
get(1402002) -> #base_role_attr_dan{type = 2 ,id = 2 ,goods_id = 1402002 ,attr_list = [{def,30}],daily_limit = 100 ,max_count = 2000};
get(1402003) -> #base_role_attr_dan{type = 2 ,id = 3 ,goods_id = 1402003 ,attr_list = [{hp_lim,300}],daily_limit = 100 ,max_count = 2000};
get(1402004) -> #base_role_attr_dan{type = 2 ,id = 4 ,goods_id = 1402004 ,attr_list = [{att,42}],daily_limit = 75 ,max_count = 1000};
get(1402005) -> #base_role_attr_dan{type = 2 ,id = 5 ,goods_id = 1402005 ,attr_list = [{def,42}],daily_limit = 75 ,max_count = 1000};
get(1402006) -> #base_role_attr_dan{type = 2 ,id = 6 ,goods_id = 1402006 ,attr_list = [{hp_lim,420}],daily_limit = 75 ,max_count = 1000};
get(1402007) -> #base_role_attr_dan{type = 2 ,id = 7 ,goods_id = 1402007 ,attr_list = [{att,56}],daily_limit = 50 ,max_count = 500};
get(1402008) -> #base_role_attr_dan{type = 2 ,id = 8 ,goods_id = 1402008 ,attr_list = [{def,56}],daily_limit = 50 ,max_count = 500};
get(1402009) -> #base_role_attr_dan{type = 2 ,id = 9 ,goods_id = 1402009 ,attr_list = [{hp_lim,560}],daily_limit = 50 ,max_count = 500};
get(1402010) -> #base_role_attr_dan{type = 2 ,id = 10 ,goods_id = 1402010 ,attr_list = [{att,70},{def,70},{hp_lim,700}],daily_limit = 10 ,max_count = 100};
get(1402011) -> #base_role_attr_dan{type = 2 ,id = 11 ,goods_id = 1402011 ,attr_list = [{att,120},{def,120},{hp_lim,1200}],daily_limit = 5 ,max_count = 50};
get(1403001) -> #base_role_attr_dan{type = 3 ,id = 1 ,goods_id = 1403001 ,attr_list = [{att,72}],daily_limit = 100 ,max_count = 2000};
get(1403002) -> #base_role_attr_dan{type = 3 ,id = 2 ,goods_id = 1403002 ,attr_list = [{def,72}],daily_limit = 100 ,max_count = 2000};
get(1403003) -> #base_role_attr_dan{type = 3 ,id = 3 ,goods_id = 1403003 ,attr_list = [{hp_lim,720}],daily_limit = 100 ,max_count = 2000};
get(1403004) -> #base_role_attr_dan{type = 3 ,id = 4 ,goods_id = 1403004 ,attr_list = [{att,90}],daily_limit = 75 ,max_count = 1000};
get(1403005) -> #base_role_attr_dan{type = 3 ,id = 5 ,goods_id = 1403005 ,attr_list = [{def,90}],daily_limit = 75 ,max_count = 1000};
get(1403006) -> #base_role_attr_dan{type = 3 ,id = 6 ,goods_id = 1403006 ,attr_list = [{hp_lim,900}],daily_limit = 75 ,max_count = 1000};
get(1403007) -> #base_role_attr_dan{type = 3 ,id = 7 ,goods_id = 1403007 ,attr_list = [{att,110}],daily_limit = 50 ,max_count = 500};
get(1403008) -> #base_role_attr_dan{type = 3 ,id = 8 ,goods_id = 1403008 ,attr_list = [{def,110}],daily_limit = 50 ,max_count = 500};
get(1403009) -> #base_role_attr_dan{type = 3 ,id = 9 ,goods_id = 1403009 ,attr_list = [{hp_lim,1100}],daily_limit = 50 ,max_count = 500};
get(1403010) -> #base_role_attr_dan{type = 3 ,id = 10 ,goods_id = 1403010 ,attr_list = [{att,200},{def,200},{hp_lim,2000}],daily_limit = 10 ,max_count = 100};
get(1403011) -> #base_role_attr_dan{type = 3 ,id = 11 ,goods_id = 1403011 ,attr_list = [{att,300},{def,300},{hp_lim,3000}],daily_limit = 5 ,max_count = 50};
get(_) -> [].