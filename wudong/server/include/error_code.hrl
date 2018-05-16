-ifndef(ER_HRL).
-define(ER_HRL,1).


%%-----------------------------------------------物品系统错误码--------------------------------
%%
-define(ER_SUCCEED,   	 	   	   		   1). %%成功 	 
-define(ER_FAIL,   	 	   	   		   	   0). %%失败
-define(ER_NOT_ENOUGH_CELL,   	 	   	   2). %%背部空间不足 	 
-define(ER_NOT_ENOUGH_GOODS_NUM, 	   	   3). %%使用物品数量不足
-define(ER_NOT_ENOUGH_GOLD,			       4). %%元宝不足
-define(ER_NOT_ENOUGH_COIN,			  	   5). %%银币不足
-define(ER_VERIFY_FAILL_GOODS_NOT_EXIST,   6). %%物品不存在
-define(ER_NOT_ENOUGH_NEED_GOODS_NUM,7).  %%开启需要的物品不足
-define(ER_USE_NUMM_ERR,8).               %%使用数量错误
-endif.