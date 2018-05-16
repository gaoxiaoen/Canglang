%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_xiulian_tupo
	%%% @Created : 2016-09-13 16:47:40
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_xiulian_tupo).
-export([get/1]).
-export([get_all/0]).
-include("xiulian.hrl").
-include("server.hrl").
  get(2) -> #base_xiulian_tupo{ lv=2,pro=100,cost_num=2,attrs=#attribute{ att=200,def=200,hp_lim=3000 } };
  get(4) -> #base_xiulian_tupo{ lv=4,pro=100,cost_num=2,attrs=#attribute{ att=400,def=400,hp_lim=6000 } };
  get(6) -> #base_xiulian_tupo{ lv=6,pro=100,cost_num=2,attrs=#attribute{ att=600,def=600,hp_lim=9000 } };
  get(8) -> #base_xiulian_tupo{ lv=8,pro=100,cost_num=2,attrs=#attribute{ att=800,def=800,hp_lim=12000 } };
  get(10) -> #base_xiulian_tupo{ lv=10,pro=100,cost_num=2,attrs=#attribute{ att=1000,def=1000,hp_lim=15000 } };
  get(12) -> #base_xiulian_tupo{ lv=12,pro=100,cost_num=2,attrs=#attribute{ att=1200,def=1200,hp_lim=18000 } };
  get(14) -> #base_xiulian_tupo{ lv=14,pro=100,cost_num=2,attrs=#attribute{ att=1400,def=1400,hp_lim=21000 } };
  get(16) -> #base_xiulian_tupo{ lv=16,pro=100,cost_num=2,attrs=#attribute{ att=1600,def=1600,hp_lim=24000 } };
  get(18) -> #base_xiulian_tupo{ lv=18,pro=100,cost_num=2,attrs=#attribute{ att=1800,def=1800,hp_lim=27000 } };
  get(20) -> #base_xiulian_tupo{ lv=20,pro=100,cost_num=2,attrs=#attribute{ att=2000,def=2000,hp_lim=30000 } };
  get(22) -> #base_xiulian_tupo{ lv=22,pro=100,cost_num=2,attrs=#attribute{ att=2200,def=2200,hp_lim=33000 } };
  get(24) -> #base_xiulian_tupo{ lv=24,pro=100,cost_num=2,attrs=#attribute{ att=2400,def=2400,hp_lim=36000 } };
  get(26) -> #base_xiulian_tupo{ lv=26,pro=100,cost_num=2,attrs=#attribute{ att=2600,def=2600,hp_lim=39000 } };
  get(28) -> #base_xiulian_tupo{ lv=28,pro=100,cost_num=2,attrs=#attribute{ att=2800,def=2800,hp_lim=42000 } };
  get(30) -> #base_xiulian_tupo{ lv=30,pro=100,cost_num=2,attrs=#attribute{ att=3000,def=3000,hp_lim=45000 } };
  get(32) -> #base_xiulian_tupo{ lv=32,pro=100,cost_num=2,attrs=#attribute{ att=3200,def=3200,hp_lim=48000 } };
  get(34) -> #base_xiulian_tupo{ lv=34,pro=100,cost_num=2,attrs=#attribute{ att=3400,def=3400,hp_lim=51000 } };
  get(36) -> #base_xiulian_tupo{ lv=36,pro=100,cost_num=2,attrs=#attribute{ att=3600,def=3600,hp_lim=54000 } };
  get(38) -> #base_xiulian_tupo{ lv=38,pro=100,cost_num=2,attrs=#attribute{ att=3800,def=3800,hp_lim=57000 } };
  get(40) -> #base_xiulian_tupo{ lv=40,pro=100,cost_num=2,attrs=#attribute{ att=4000,def=4000,hp_lim=60000 } };
get(_) -> [].
get_all()->[2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40].

