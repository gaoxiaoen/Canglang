%%----------------------------------------------------
%% @doc 任务系统物品行为信息
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(task_data_item).
-export( [
        get/3
    ]
).

-include("task.hrl").
-include("gain.hrl").

%% 获取物品任务行为信息

get(51004, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51004
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}
               ,#loss{label = cn_item, val =  [20036, 9, 5]}

            ]
        }
    };
get(51004, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51004
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}
               ,#loss{label = cn_item, val =  [20036, 9, 5]}

            ]
        }
    };
get(51004, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51004
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}
               ,#loss{label = cn_item, val =  [20036, 9, 5]}

            ]
        }
    };
get(51004, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51004
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}
               ,#loss{label = cn_item, val =  [20036, 9, 5]}

            ]
        }
    };
get(51004, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51004
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}
               ,#loss{label = cn_item, val =  [20036, 9, 5]}

            ]
        }
    };
get(51005, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51005
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}

            ]
        }
    };
get(51005, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51005
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}

            ]
        }
    };
get(51005, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51005
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}

            ]
        }
    };
get(51005, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51005
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}

            ]
        }
    };
get(51005, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51005
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}

            ]
        }
    };
get(51006, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51006
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}
               ,#loss{label = cn_item, val =  [20036, 9, 5]}

            ]
        }
    };
get(51006, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51006
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}
               ,#loss{label = cn_item, val =  [20036, 9, 5]}

            ]
        }
    };
get(51006, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51006
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}
               ,#loss{label = cn_item, val =  [20036, 9, 5]}

            ]
        }
    };
get(51006, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51006
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}
               ,#loss{label = cn_item, val =  [20036, 9, 5]}

            ]
        }
    };
get(51006, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51006
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}
               ,#loss{label = cn_item, val =  [20036, 9, 5]}

            ]
        }
    };
get(51007, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51007
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}

            ]
        }
    };
get(51007, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51007
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}

            ]
        }
    };
get(51007, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51007
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}

            ]
        }
    };
get(51007, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51007
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}

            ]
        }
    };
get(51007, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51007
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}

            ]
        }
    };
get(51008, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51008
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}
               ,#loss{label = cn_item, val =  [20029, 9, 5]}

            ]
        }
    };
get(51008, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51008
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}
               ,#loss{label = cn_item, val =  [20029, 9, 5]}

            ]
        }
    };
get(51008, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51008
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}
               ,#loss{label = cn_item, val =  [20029, 9, 5]}

            ]
        }
    };
get(51008, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51008
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}
               ,#loss{label = cn_item, val =  [20029, 9, 5]}

            ]
        }
    };
get(51008, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51008
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}
               ,#loss{label = cn_item, val =  [20029, 9, 5]}

            ]
        }
    };
get(51009, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51009
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}

            ]
        }
    };
get(51009, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51009
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}

            ]
        }
    };
get(51009, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51009
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}

            ]
        }
    };
get(51009, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51009
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}

            ]
        }
    };
get(51009, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51009
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}

            ]
        }
    };
get(51010, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51010
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}
               ,#loss{label = item, val =  [24010, 9, 5]}

            ]
        }
    };
get(51010, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51010
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}
               ,#loss{label = item, val =  [24010, 9, 5]}

            ]
        }
    };
get(51010, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51010
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}
               ,#loss{label = item, val =  [24010, 9, 5]}

            ]
        }
    };
get(51010, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51010
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}
               ,#loss{label = item, val =  [24010, 9, 5]}

            ]
        }
    };
get(51010, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51010
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}
               ,#loss{label = item, val =  [24010, 9, 5]}

            ]
        }
    };
get(51011, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51011
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}

            ]
        }
    };
get(51011, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51011
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}

            ]
        }
    };
get(51011, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51011
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}

            ]
        }
    };
get(51011, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51011
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}

            ]
        }
    };
get(51011, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51011
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}

            ]
        }
    };
get(51012, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51012
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}
               ,#loss{label = item, val =  [20036, 9, 5]}

            ]
        }
    };
get(51012, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51012
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}
               ,#loss{label = item, val =  [20036, 9, 5]}

            ]
        }
    };
get(51012, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51012
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}
               ,#loss{label = item, val =  [20036, 9, 5]}

            ]
        }
    };
get(51012, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51012
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}
               ,#loss{label = item, val =  [20036, 9, 5]}

            ]
        }
    };
get(51012, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51012
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}
               ,#loss{label = item, val =  [20036, 9, 5]}

            ]
        }
    };
get(51013, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51013
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}

            ]
        }
    };
get(51013, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51013
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}

            ]
        }
    };
get(51013, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51013
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}

            ]
        }
    };
get(51013, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51013
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}

            ]
        }
    };
get(51013, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51013
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}

            ]
        }
    };
get(51014, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51014
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}
               ,#loss{label = item, val =  [27000, 9, 5]}

            ]
        }
    };
get(51014, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51014
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}
               ,#loss{label = item, val =  [27000, 9, 5]}

            ]
        }
    };
get(51014, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51014
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}
               ,#loss{label = item, val =  [27000, 9, 5]}

            ]
        }
    };
get(51014, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51014
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}
               ,#loss{label = item, val =  [27000, 9, 5]}

            ]
        }
    };
get(51014, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51014
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}
               ,#loss{label = item, val =  [27000, 9, 5]}

            ]
        }
    };
get(51015, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51015
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}

            ]
        }
    };
get(51015, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51015
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}

            ]
        }
    };
get(51015, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51015
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}

            ]
        }
    };
get(51015, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51015
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}

            ]
        }
    };
get(51015, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51015
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}

            ]
        }
    };
get(51016, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51016
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}
               ,#loss{label = item, val =  [27001, 9, 2]}

            ]
        }
    };
get(51016, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51016
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}
               ,#loss{label = item, val =  [27001, 9, 2]}

            ]
        }
    };
get(51016, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51016
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}
               ,#loss{label = item, val =  [27001, 9, 2]}

            ]
        }
    };
get(51016, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51016
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}
               ,#loss{label = item, val =  [27001, 9, 2]}

            ]
        }
    };
get(51016, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51016
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}
               ,#loss{label = item, val =  [27001, 9, 2]}

            ]
        }
    };
get(51017, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51017
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}

            ]
        }
    };
get(51017, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51017
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}

            ]
        }
    };
get(51017, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51017
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}

            ]
        }
    };
get(51017, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51017
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}

            ]
        }
    };
get(51017, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51017
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}

            ]
        }
    };
get(51018, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51018
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}
               ,#loss{label = item, val =  [24031, 9, 5]}

            ]
        }
    };
get(51018, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51018
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}
               ,#loss{label = item, val =  [24031, 9, 5]}

            ]
        }
    };
get(51018, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51018
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}
               ,#loss{label = item, val =  [24031, 9, 5]}

            ]
        }
    };
get(51018, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51018
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}
               ,#loss{label = item, val =  [24031, 9, 5]}

            ]
        }
    };
get(51018, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51018
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}
               ,#loss{label = item, val =  [24031, 9, 5]}

            ]
        }
    };
get(51019, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51019
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}

            ]
        }
    };
get(51019, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51019
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}

            ]
        }
    };
get(51019, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51019
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}

            ]
        }
    };
get(51019, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51019
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}

            ]
        }
    };
get(51019, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51019
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}

            ]
        }
    };
get(51020, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51020
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}
               ,#loss{label = item, val =  [24011, 9, 5]}

            ]
        }
    };
get(51020, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51020
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}
               ,#loss{label = item, val =  [24011, 9, 5]}

            ]
        }
    };
get(51020, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51020
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}
               ,#loss{label = item, val =  [24011, 9, 5]}

            ]
        }
    };
get(51020, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51020
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}
               ,#loss{label = item, val =  [24011, 9, 5]}

            ]
        }
    };
get(51020, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51020
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}
               ,#loss{label = item, val =  [24011, 9, 5]}

            ]
        }
    };
get(51021, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51021
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}

            ]
        }
    };
get(51021, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51021
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}

            ]
        }
    };
get(51021, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51021
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}

            ]
        }
    };
get(51021, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51021
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}

            ]
        }
    };
get(51021, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51021
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}

            ]
        }
    };
get(51022, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 51022
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  100}
               ,#loss{label = item, val =  [27001, 9, 3]}

            ]
        }
    };
get(51022, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 51022
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  120}
               ,#loss{label = item, val =  [27001, 9, 3]}

            ]
        }
    };
get(51022, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 51022
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  150}
               ,#loss{label = item, val =  [27001, 9, 3]}

            ]
        }
    };
get(51022, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 51022
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  200}
               ,#loss{label = item, val =  [27001, 9, 3]}

            ]
        }
    };
get(51022, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 51022
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = gold_bind, val =  400}
               ,#loss{label = item, val =  [27001, 9, 3]}

            ]
        }
    };
get(52004, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52004
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1075}

            ]
        }
    };
get(52004, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52004
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1290}

            ]
        }
    };
get(52004, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52004
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1613}

            ]
        }
    };
get(52004, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52004
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2150}

            ]
        }
    };
get(52004, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52004
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  4300}

            ]
        }
    };
get(52005, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52005
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1100}

            ]
        }
    };
get(52005, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52005
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1320}

            ]
        }
    };
get(52005, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52005
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1650}

            ]
        }
    };
get(52005, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52005
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2200}

            ]
        }
    };
get(52005, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52005
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  4400}

            ]
        }
    };
get(52006, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52006
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1125}

            ]
        }
    };
get(52006, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52006
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1350}

            ]
        }
    };
get(52006, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52006
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1688}

            ]
        }
    };
get(52006, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52006
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2250}

            ]
        }
    };
get(52006, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52006
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  4500}

            ]
        }
    };
get(52007, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52007
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1150}

            ]
        }
    };
get(52007, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52007
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1380}

            ]
        }
    };
get(52007, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52007
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1725}

            ]
        }
    };
get(52007, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52007
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2300}

            ]
        }
    };
get(52007, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52007
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  4600}

            ]
        }
    };
get(52008, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52008
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1175}

            ]
        }
    };
get(52008, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52008
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1410}

            ]
        }
    };
get(52008, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52008
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1763}

            ]
        }
    };
get(52008, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52008
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2350}

            ]
        }
    };
get(52008, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52008
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  4700}

            ]
        }
    };
get(52009, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52009
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1200}

            ]
        }
    };
get(52009, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52009
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1440}

            ]
        }
    };
get(52009, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52009
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1800}

            ]
        }
    };
get(52009, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52009
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2400}

            ]
        }
    };
get(52009, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52009
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  4800}

            ]
        }
    };
get(52010, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52010
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1225}

            ]
        }
    };
get(52010, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52010
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1470}

            ]
        }
    };
get(52010, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52010
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1838}

            ]
        }
    };
get(52010, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52010
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2450}

            ]
        }
    };
get(52010, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52010
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  4900}

            ]
        }
    };
get(52011, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52011
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1250}

            ]
        }
    };
get(52011, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52011
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1500}

            ]
        }
    };
get(52011, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52011
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1875}

            ]
        }
    };
get(52011, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52011
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2500}

            ]
        }
    };
get(52011, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52011
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  5000}

            ]
        }
    };
get(52012, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52012
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1275}

            ]
        }
    };
get(52012, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52012
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1530}

            ]
        }
    };
get(52012, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52012
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1919}

            ]
        }
    };
get(52012, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52012
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2550}

            ]
        }
    };
get(52012, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52012
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  5100}

            ]
        }
    };
get(52013, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52013
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1300}

            ]
        }
    };
get(52013, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52013
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1560}

            ]
        }
    };
get(52013, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52013
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1950}

            ]
        }
    };
get(52013, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52013
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2600}

            ]
        }
    };
get(52013, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52013
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  5200}

            ]
        }
    };
get(52014, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52014
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1325}

            ]
        }
    };
get(52014, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52014
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1590}

            ]
        }
    };
get(52014, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52014
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1988}

            ]
        }
    };
get(52014, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52014
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2650}

            ]
        }
    };
get(52014, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52014
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  5300}

            ]
        }
    };
get(52015, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52015
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1350}

            ]
        }
    };
get(52015, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52015
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1620}

            ]
        }
    };
get(52015, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52015
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2025}

            ]
        }
    };
get(52015, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52015
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2700}

            ]
        }
    };
get(52015, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52015
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  5400}

            ]
        }
    };
get(52016, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52016
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1375}

            ]
        }
    };
get(52016, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52016
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1650}

            ]
        }
    };
get(52016, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52016
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2063}

            ]
        }
    };
get(52016, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52016
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2750}

            ]
        }
    };
get(52016, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52016
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  5500}

            ]
        }
    };
get(52017, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52017
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1400}

            ]
        }
    };
get(52017, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52017
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1680}

            ]
        }
    };
get(52017, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52017
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2100}

            ]
        }
    };
get(52017, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52017
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2800}

            ]
        }
    };
get(52017, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52017
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  5600}

            ]
        }
    };
get(52018, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52018
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1425}

            ]
        }
    };
get(52018, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52018
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1710}

            ]
        }
    };
get(52018, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52018
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2138}

            ]
        }
    };
get(52018, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52018
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2850}

            ]
        }
    };
get(52018, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52018
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  5700}

            ]
        }
    };
get(52019, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52019
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1450}

            ]
        }
    };
get(52019, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52019
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1740}

            ]
        }
    };
get(52019, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52019
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2175}

            ]
        }
    };
get(52019, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52019
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2900}

            ]
        }
    };
get(52019, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52019
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  5800}

            ]
        }
    };
get(52020, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52020
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1475}

            ]
        }
    };
get(52020, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52020
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1770}

            ]
        }
    };
get(52020, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52020
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2213}

            ]
        }
    };
get(52020, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52020
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2950}

            ]
        }
    };
get(52020, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52020
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  5900}

            ]
        }
    };
get(52021, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52021
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1500}

            ]
        }
    };
get(52021, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52021
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1800}

            ]
        }
    };
get(52021, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52021
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2250}

            ]
        }
    };
get(52021, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52021
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  3000}

            ]
        }
    };
get(52021, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52021
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  6000}

            ]
        }
    };
get(52022, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 52022
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1525}

            ]
        }
    };
get(52022, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 52022
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  1830}

            ]
        }
    };
get(52022, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 52022
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  2288}

            ]
        }
    };
get(52022, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 52022
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  3050}

            ]
        }
    };
get(52022, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 52022
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = attainment, val =  6100}

            ]
        }
    };
get(53004, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53004
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  160000}

            ]
        }
    };
get(53004, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53004
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  192000}

            ]
        }
    };
get(53004, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53004
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  240000}

            ]
        }
    };
get(53004, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53004
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  320000}

            ]
        }
    };
get(53004, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53004
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  640000}

            ]
        }
    };
get(53005, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53005
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  170000}

            ]
        }
    };
get(53005, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53005
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  204000}

            ]
        }
    };
get(53005, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53005
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  255000}

            ]
        }
    };
get(53005, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53005
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  340000}

            ]
        }
    };
get(53005, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53005
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  680000}

            ]
        }
    };
get(53006, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53006
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  175000}

            ]
        }
    };
get(53006, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53006
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  210000}

            ]
        }
    };
get(53006, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53006
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  262500}

            ]
        }
    };
get(53006, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53006
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  350000}

            ]
        }
    };
get(53006, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53006
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  700000}

            ]
        }
    };
get(53007, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53007
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  180000}

            ]
        }
    };
get(53007, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53007
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  216000}

            ]
        }
    };
get(53007, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53007
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  270000}

            ]
        }
    };
get(53007, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53007
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  360000}

            ]
        }
    };
get(53007, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53007
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  720000}

            ]
        }
    };
get(53008, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53008
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  190000}

            ]
        }
    };
get(53008, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53008
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  228000}

            ]
        }
    };
get(53008, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53008
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  285000}

            ]
        }
    };
get(53008, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53008
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  380000}

            ]
        }
    };
get(53008, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53008
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  760000}

            ]
        }
    };
get(53009, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53009
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  200000}

            ]
        }
    };
get(53009, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53009
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  240000}

            ]
        }
    };
get(53009, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53009
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  300000}

            ]
        }
    };
get(53009, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53009
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  400000}

            ]
        }
    };
get(53009, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53009
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  800000}

            ]
        }
    };
get(53010, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53010
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  210000}

            ]
        }
    };
get(53010, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53010
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  252000}

            ]
        }
    };
get(53010, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53010
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  315000}

            ]
        }
    };
get(53010, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53010
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  420000}

            ]
        }
    };
get(53010, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53010
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  840000}

            ]
        }
    };
get(53011, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53011
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  215000}

            ]
        }
    };
get(53011, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53011
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  258000}

            ]
        }
    };
get(53011, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53011
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  322500}

            ]
        }
    };
get(53011, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53011
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  430000}

            ]
        }
    };
get(53011, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53011
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  860000}

            ]
        }
    };
get(53012, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53012
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  220000}

            ]
        }
    };
get(53012, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53012
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  264000}

            ]
        }
    };
get(53012, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53012
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  330000}

            ]
        }
    };
get(53012, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53012
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  440000}

            ]
        }
    };
get(53012, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53012
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  880000}

            ]
        }
    };
get(53013, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53013
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  230000}

            ]
        }
    };
get(53013, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53013
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  276000}

            ]
        }
    };
get(53013, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53013
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  345000}

            ]
        }
    };
get(53013, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53013
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  460000}

            ]
        }
    };
get(53013, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53013
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  920000}

            ]
        }
    };
get(53014, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53014
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  240000}

            ]
        }
    };
get(53014, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53014
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  288000}

            ]
        }
    };
get(53014, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53014
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  360000}

            ]
        }
    };
get(53014, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53014
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  480000}

            ]
        }
    };
get(53014, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53014
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  960000}

            ]
        }
    };
get(53015, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53015
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  250000}

            ]
        }
    };
get(53015, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53015
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  300000}

            ]
        }
    };
get(53015, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53015
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  375000}

            ]
        }
    };
get(53015, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53015
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  500000}

            ]
        }
    };
get(53015, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53015
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  1000000}

            ]
        }
    };
get(53016, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53016
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  255000}

            ]
        }
    };
get(53016, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53016
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  306000}

            ]
        }
    };
get(53016, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53016
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  382500}

            ]
        }
    };
get(53016, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53016
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  510000}

            ]
        }
    };
get(53016, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53016
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  1020000}

            ]
        }
    };
get(53017, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53017
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  260000}

            ]
        }
    };
get(53017, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53017
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  312000}

            ]
        }
    };
get(53017, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53017
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  390000}

            ]
        }
    };
get(53017, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53017
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  520000}

            ]
        }
    };
get(53017, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53017
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  1040000}

            ]
        }
    };
get(53018, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53018
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  270000}

            ]
        }
    };
get(53018, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53018
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  324000}

            ]
        }
    };
get(53018, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53018
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  405000}

            ]
        }
    };
get(53018, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53018
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  540000}

            ]
        }
    };
get(53018, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53018
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  1080000}

            ]
        }
    };
get(53019, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53019
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  280000}

            ]
        }
    };
get(53019, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53019
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  336000}

            ]
        }
    };
get(53019, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53019
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  420000}

            ]
        }
    };
get(53019, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53019
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  560000}

            ]
        }
    };
get(53019, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53019
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  1120000}

            ]
        }
    };
get(53020, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53020
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  290000}

            ]
        }
    };
get(53020, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53020
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  348000}

            ]
        }
    };
get(53020, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53020
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  435000}

            ]
        }
    };
get(53020, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53020
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  580000}

            ]
        }
    };
get(53020, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53020
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  1160000}

            ]
        }
    };
get(53021, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53021
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  295000}

            ]
        }
    };
get(53021, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53021
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  354000}

            ]
        }
    };
get(53021, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53021
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  442500}

            ]
        }
    };
get(53021, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53021
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  590000}

            ]
        }
    };
get(53021, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53021
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  1180000}

            ]
        }
    };
get(53022, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 53022
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  300000}

            ]
        }
    };
get(53022, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 53022
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  360000}

            ]
        }
    };
get(53022, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 53022
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  450000}

            ]
        }
    };
get(53022, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 53022
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  600000}

            ]
        }
    };
get(53022, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 53022
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = coin_bind, val =  1200000}

            ]
        }
    };
get(54004, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54004
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}
               ,#loss{label = item, val =  [24032, 9, 5]}

            ]
        }
    };
get(54004, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54004
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}
               ,#loss{label = item, val =  [24032, 9, 5]}

            ]
        }
    };
get(54004, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54004
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}
               ,#loss{label = item, val =  [24032, 9, 5]}

            ]
        }
    };
get(54004, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54004
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}
               ,#loss{label = item, val =  [24032, 9, 5]}

            ]
        }
    };
get(54004, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54004
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}
               ,#loss{label = item, val =  [24032, 9, 5]}

            ]
        }
    };
get(54005, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54005
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}

            ]
        }
    };
get(54005, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54005
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}

            ]
        }
    };
get(54005, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54005
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}

            ]
        }
    };
get(54005, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54005
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}

            ]
        }
    };
get(54005, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54005
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}

            ]
        }
    };
get(54006, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54006
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}
               ,#loss{label = item, val =  [27000, 9, 2]}

            ]
        }
    };
get(54006, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54006
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}
               ,#loss{label = item, val =  [27000, 9, 2]}

            ]
        }
    };
get(54006, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54006
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}
               ,#loss{label = item, val =  [27000, 9, 2]}

            ]
        }
    };
get(54006, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54006
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}
               ,#loss{label = item, val =  [27000, 9, 2]}

            ]
        }
    };
get(54006, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54006
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}
               ,#loss{label = item, val =  [27000, 9, 2]}

            ]
        }
    };
get(54007, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54007
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}

            ]
        }
    };
get(54007, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54007
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}

            ]
        }
    };
get(54007, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54007
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}

            ]
        }
    };
get(54007, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54007
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}

            ]
        }
    };
get(54007, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54007
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}

            ]
        }
    };
get(54008, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54008
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}
               ,#loss{label = cn_item, val =  [20029, 9, 5]}

            ]
        }
    };
get(54008, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54008
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}
               ,#loss{label = cn_item, val =  [20029, 9, 5]}

            ]
        }
    };
get(54008, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54008
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}
               ,#loss{label = cn_item, val =  [20029, 9, 5]}

            ]
        }
    };
get(54008, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54008
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}
               ,#loss{label = cn_item, val =  [20029, 9, 5]}

            ]
        }
    };
get(54008, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54008
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}
               ,#loss{label = cn_item, val =  [20029, 9, 5]}

            ]
        }
    };
get(54009, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54009
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}

            ]
        }
    };
get(54009, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54009
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}

            ]
        }
    };
get(54009, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54009
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}

            ]
        }
    };
get(54009, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54009
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}

            ]
        }
    };
get(54009, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54009
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}

            ]
        }
    };
get(54010, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54010
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}
               ,#loss{label = cn_item, val =  [20036, 9, 5]}

            ]
        }
    };
get(54010, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54010
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}
               ,#loss{label = cn_item, val =  [20036, 9, 5]}

            ]
        }
    };
get(54010, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54010
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}
               ,#loss{label = cn_item, val =  [20036, 9, 5]}

            ]
        }
    };
get(54010, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54010
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}
               ,#loss{label = cn_item, val =  [20036, 9, 5]}

            ]
        }
    };
get(54010, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54010
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}
               ,#loss{label = cn_item, val =  [20036, 9, 5]}

            ]
        }
    };
get(54011, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54011
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}

            ]
        }
    };
get(54011, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54011
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}

            ]
        }
    };
get(54011, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54011
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}

            ]
        }
    };
get(54011, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54011
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}

            ]
        }
    };
get(54011, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54011
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}

            ]
        }
    };
get(54012, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54012
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}
               ,#loss{label = cn_item, val =  [25011, 9, 5]}

            ]
        }
    };
get(54012, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54012
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}
               ,#loss{label = cn_item, val =  [25011, 9, 5]}

            ]
        }
    };
get(54012, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54012
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}
               ,#loss{label = cn_item, val =  [25011, 9, 5]}

            ]
        }
    };
get(54012, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54012
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}
               ,#loss{label = cn_item, val =  [25011, 9, 5]}

            ]
        }
    };
get(54012, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54012
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}
               ,#loss{label = cn_item, val =  [25011, 9, 5]}

            ]
        }
    };
get(54013, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54013
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}

            ]
        }
    };
get(54013, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54013
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}

            ]
        }
    };
get(54013, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54013
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}

            ]
        }
    };
get(54013, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54013
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}

            ]
        }
    };
get(54013, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54013
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}

            ]
        }
    };
get(54014, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54014
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}
               ,#loss{label = item, val =  [27000, 9, 5]}

            ]
        }
    };
get(54014, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54014
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}
               ,#loss{label = item, val =  [27000, 9, 5]}

            ]
        }
    };
get(54014, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54014
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}
               ,#loss{label = item, val =  [27000, 9, 5]}

            ]
        }
    };
get(54014, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54014
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}
               ,#loss{label = item, val =  [27000, 9, 5]}

            ]
        }
    };
get(54014, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54014
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}
               ,#loss{label = item, val =  [27000, 9, 5]}

            ]
        }
    };
get(54015, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54015
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}

            ]
        }
    };
get(54015, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54015
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}

            ]
        }
    };
get(54015, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54015
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}

            ]
        }
    };
get(54015, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54015
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}

            ]
        }
    };
get(54015, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54015
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}

            ]
        }
    };
get(54016, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54016
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}
               ,#loss{label = item, val =  [27001, 9, 2]}

            ]
        }
    };
get(54016, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54016
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}
               ,#loss{label = item, val =  [27001, 9, 2]}

            ]
        }
    };
get(54016, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54016
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}
               ,#loss{label = item, val =  [27001, 9, 2]}

            ]
        }
    };
get(54016, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54016
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}
               ,#loss{label = item, val =  [27001, 9, 2]}

            ]
        }
    };
get(54016, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54016
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}
               ,#loss{label = item, val =  [27001, 9, 2]}

            ]
        }
    };
get(54017, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54017
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}

            ]
        }
    };
get(54017, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54017
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}

            ]
        }
    };
get(54017, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54017
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}

            ]
        }
    };
get(54017, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54017
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}

            ]
        }
    };
get(54017, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54017
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}

            ]
        }
    };
get(54018, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54018
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}
               ,#loss{label = cn_item, val =  [25011, 9, 5]}

            ]
        }
    };
get(54018, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54018
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}
               ,#loss{label = cn_item, val =  [25011, 9, 5]}

            ]
        }
    };
get(54018, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54018
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}
               ,#loss{label = cn_item, val =  [25011, 9, 5]}

            ]
        }
    };
get(54018, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54018
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}
               ,#loss{label = cn_item, val =  [25011, 9, 5]}

            ]
        }
    };
get(54018, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54018
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}
               ,#loss{label = cn_item, val =  [25011, 9, 5]}

            ]
        }
    };
get(54019, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54019
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}

            ]
        }
    };
get(54019, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54019
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}

            ]
        }
    };
get(54019, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54019
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}

            ]
        }
    };
get(54019, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54019
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}

            ]
        }
    };
get(54019, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54019
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}

            ]
        }
    };
get(54020, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54020
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}
               ,#loss{label = item, val =  [24012, 9, 5]}

            ]
        }
    };
get(54020, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54020
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}
               ,#loss{label = item, val =  [24012, 9, 5]}

            ]
        }
    };
get(54020, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54020
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}
               ,#loss{label = item, val =  [24012, 9, 5]}

            ]
        }
    };
get(54020, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54020
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}
               ,#loss{label = item, val =  [24012, 9, 5]}

            ]
        }
    };
get(54020, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54020
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}
               ,#loss{label = item, val =  [24012, 9, 5]}

            ]
        }
    };
get(54021, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54021
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}

            ]
        }
    };
get(54021, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54021
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}

            ]
        }
    };
get(54021, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54021
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}

            ]
        }
    };
get(54021, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54021
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}

            ]
        }
    };
get(54021, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54021
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}

            ]
        }
    };
get(54022, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 54022
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 2]}
               ,#loss{label = item, val =  [24032, 9, 5]}

            ]
        }
    };
get(54022, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 54022
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 3]}
               ,#loss{label = item, val =  [24032, 9, 5]}

            ]
        }
    };
get(54022, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 54022
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 4]}
               ,#loss{label = item, val =  [24032, 9, 5]}

            ]
        }
    };
get(54022, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 54022
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 5]}
               ,#loss{label = item, val =  [24032, 9, 5]}

            ]
        }
    };
get(54022, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 54022
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [32000, 1, 8]}
               ,#loss{label = item, val =  [24032, 9, 5]}

            ]
        }
    };
get(55004, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55004
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  53620}

            ]
        }
    };
get(55004, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55004
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  64343}

            ]
        }
    };
get(55004, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55004
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  80429}

            ]
        }
    };
get(55004, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55004
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  107238}

            ]
        }
    };
get(55004, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55004
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  214476}

            ]
        }
    };
get(55005, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55005
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  59344}

            ]
        }
    };
get(55005, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55005
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  71212}

            ]
        }
    };
get(55005, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55005
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  89015}

            ]
        }
    };
get(55005, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55005
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  118686}

            ]
        }
    };
get(55005, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55005
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  237372}

            ]
        }
    };
get(55006, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55006
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  65068}

            ]
        }
    };
get(55006, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55006
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  78080}

            ]
        }
    };
get(55006, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55006
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  97601}

            ]
        }
    };
get(55006, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55006
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  130134}

            ]
        }
    };
get(55006, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55006
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  260268}

            ]
        }
    };
get(55007, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55007
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  70792}

            ]
        }
    };
get(55007, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55007
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  84949}

            ]
        }
    };
get(55007, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55007
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  106187}

            ]
        }
    };
get(55007, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55007
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  141582}

            ]
        }
    };
get(55007, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55007
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  283164}

            ]
        }
    };
get(55008, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55008
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  76516}

            ]
        }
    };
get(55008, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55008
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  91818}

            ]
        }
    };
get(55008, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55008
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  114773}

            ]
        }
    };
get(55008, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55008
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  153030}

            ]
        }
    };
get(55008, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55008
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  306060}

            ]
        }
    };
get(55009, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55009
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  82240}

            ]
        }
    };
get(55009, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55009
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  98687}

            ]
        }
    };
get(55009, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55009
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  123359}

            ]
        }
    };
get(55009, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55009
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  164478}

            ]
        }
    };
get(55009, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55009
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  328956}

            ]
        }
    };
get(55010, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55010
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  87964}

            ]
        }
    };
get(55010, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55010
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  105556}

            ]
        }
    };
get(55010, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55010
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  131945}

            ]
        }
    };
get(55010, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55010
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  175926}

            ]
        }
    };
get(55010, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55010
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  351852}

            ]
        }
    };
get(55011, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55011
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  93688}

            ]
        }
    };
get(55011, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55011
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  112424}

            ]
        }
    };
get(55011, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55011
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  140531}

            ]
        }
    };
get(55011, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55011
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  187374}

            ]
        }
    };
get(55011, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55011
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  374748}

            ]
        }
    };
get(55012, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55012
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  99412}

            ]
        }
    };
get(55012, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55012
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  119293}

            ]
        }
    };
get(55012, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55012
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  149117}

            ]
        }
    };
get(55012, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55012
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  198822}

            ]
        }
    };
get(55012, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55012
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  397644}

            ]
        }
    };
get(55013, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55013
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  105136}

            ]
        }
    };
get(55013, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55013
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  126162}

            ]
        }
    };
get(55013, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55013
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  157703}

            ]
        }
    };
get(55013, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55013
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  210270}

            ]
        }
    };
get(55013, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55013
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  420540}

            ]
        }
    };
get(55014, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55014
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  110860}

            ]
        }
    };
get(55014, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55014
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  133031}

            ]
        }
    };
get(55014, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55014
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  166289}

            ]
        }
    };
get(55014, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55014
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  221718}

            ]
        }
    };
get(55014, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55014
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  443436}

            ]
        }
    };
get(55015, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55015
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  116584}

            ]
        }
    };
get(55015, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55015
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  139900}

            ]
        }
    };
get(55015, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55015
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  174875}

            ]
        }
    };
get(55015, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55015
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  233166}

            ]
        }
    };
get(55015, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55015
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  466332}

            ]
        }
    };
get(55016, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55016
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  122308}

            ]
        }
    };
get(55016, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55016
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  146768}

            ]
        }
    };
get(55016, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55016
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  183461}

            ]
        }
    };
get(55016, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55016
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  244614}

            ]
        }
    };
get(55016, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55016
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  489228}

            ]
        }
    };
get(55017, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55017
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  128032}

            ]
        }
    };
get(55017, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55017
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  153637}

            ]
        }
    };
get(55017, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55017
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  192047}

            ]
        }
    };
get(55017, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55017
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  256062}

            ]
        }
    };
get(55017, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55017
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  512124}

            ]
        }
    };
get(55018, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55018
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  133756}

            ]
        }
    };
get(55018, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55018
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  160506}

            ]
        }
    };
get(55018, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55018
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  200633}

            ]
        }
    };
get(55018, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55018
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  267510}

            ]
        }
    };
get(55018, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55018
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  535020}

            ]
        }
    };
get(55019, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55019
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  139480}

            ]
        }
    };
get(55019, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55019
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  167375}

            ]
        }
    };
get(55019, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55019
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  209219}

            ]
        }
    };
get(55019, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55019
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  278958}

            ]
        }
    };
get(55019, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55019
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  557916}

            ]
        }
    };
get(55020, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55020
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  145204}

            ]
        }
    };
get(55020, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55020
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  174244}

            ]
        }
    };
get(55020, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55020
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  217805}

            ]
        }
    };
get(55020, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55020
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  290406}

            ]
        }
    };
get(55020, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55020
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  580812}

            ]
        }
    };
get(55021, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55021
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  150928}

            ]
        }
    };
get(55021, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55021
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  181112}

            ]
        }
    };
get(55021, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55021
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  226391}

            ]
        }
    };
get(55021, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55021
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  301854}

            ]
        }
    };
get(55021, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55021
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  603708}

            ]
        }
    };
get(55022, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 55022
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  156652}

            ]
        }
    };
get(55022, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 55022
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  187981}

            ]
        }
    };
get(55022, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 55022
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  234977}

            ]
        }
    };
get(55022, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 55022
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  313302}

            ]
        }
    };
get(55022, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 55022
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = exp, val =  626604}

            ]
        }
    };
get(56004, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56004
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56004, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56004
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56004, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56004
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56004, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56004
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56004, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56004
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(56005, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56005
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56005, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56005
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56005, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56005
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56005, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56005
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56005, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56005
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(56006, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56006
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56006, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56006
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56006, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56006
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56006, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56006
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56006, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56006
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(56007, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56007
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56007, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56007
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56007, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56007
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56007, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56007
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56007, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56007
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(56008, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56008
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56008, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56008
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56008, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56008
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56008, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56008
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56008, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56008
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(56009, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56009
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56009, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56009
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56009, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56009
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56009, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56009
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56009, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56009
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(56010, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56010
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56010, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56010
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56010, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56010
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56010, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56010
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56010, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56010
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(56011, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56011
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56011, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56011
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56011, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56011
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56011, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56011
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56011, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56011
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(56012, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56012
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56012, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56012
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56012, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56012
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56012, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56012
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56012, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56012
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(56013, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56013
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56013, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56013
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56013, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56013
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56013, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56013
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56013, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56013
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(56014, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56014
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56014, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56014
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56014, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56014
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56014, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56014
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56014, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56014
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(56015, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56015
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56015, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56015
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56015, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56015
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56015, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56015
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56015, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56015
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(56016, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56016
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56016, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56016
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56016, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56016
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56016, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56016
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56016, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56016
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(56017, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56017
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56017, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56017
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56017, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56017
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56017, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56017
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56017, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56017
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(56018, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56018
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56018, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56018
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56018, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56018
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56018, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56018
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56018, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56018
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(56019, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56019
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56019, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56019
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56019, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56019
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56019, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56019
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56019, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56019
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(56020, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56020
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56020, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56020
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56020, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56020
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56020, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56020
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56020, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56020
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(56021, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56021
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56021, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56021
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56021, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56021
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56021, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56021
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56021, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56021
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(56022, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 56022
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 2]}

            ]
        }
    };
get(56022, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 56022
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 3]}

            ]
        }
    };
get(56022, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 56022
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 4]}

            ]
        }
    };
get(56022, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 56022
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 5]}

            ]
        }
    };
get(56022, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 56022
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [21011, 1, 8]}

            ]
        }
    };
get(57004, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57004
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57004, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57004
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57004, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57004
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57004, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57004
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57004, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57004
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };
get(57005, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57005
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57005, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57005
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57005, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57005
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57005, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57005
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57005, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57005
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };
get(57006, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57006
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57006, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57006
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57006, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57006
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57006, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57006
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57006, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57006
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };
get(57007, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57007
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57007, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57007
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57007, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57007
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57007, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57007
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57007, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57007
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };
get(57008, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57008
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57008, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57008
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57008, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57008
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57008, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57008
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57008, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57008
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };
get(57009, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57009
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57009, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57009
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57009, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57009
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57009, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57009
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57009, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57009
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };
get(57010, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57010
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57010, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57010
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57010, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57010
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57010, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57010
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57010, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57010
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };
get(57011, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57011
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57011, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57011
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57011, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57011
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57011, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57011
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57011, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57011
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };
get(57012, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57012
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57012, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57012
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57012, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57012
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57012, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57012
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57012, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57012
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };
get(57013, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57013
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57013, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57013
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57013, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57013
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57013, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57013
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57013, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57013
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };
get(57014, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57014
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57014, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57014
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57014, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57014
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57014, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57014
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57014, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57014
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };
get(57015, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57015
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57015, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57015
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57015, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57015
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57015, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57015
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57015, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57015
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };
get(57016, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57016
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57016, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57016
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57016, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57016
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57016, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57016
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57016, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57016
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };
get(57017, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57017
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57017, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57017
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57017, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57017
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57017, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57017
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57017, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57017
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };
get(57018, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57018
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57018, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57018
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57018, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57018
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57018, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57018
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57018, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57018
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };
get(57019, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57019
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57019, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57019
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57019, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57019
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57019, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57019
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57019, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57019
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };
get(57020, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57020
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57020, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57020
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57020, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57020
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57020, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57020
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57020, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57020
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };
get(57021, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57021
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57021, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57021
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57021, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57021
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57021, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57021
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57021, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57021
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };
get(57022, 31000, 1) ->
    {ok, #task_base_item{
            task_id = 57022
            ,item_base_id = 31000
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 2]}

            ]
        }
    };
get(57022, 31001, 1) ->
    {ok, #task_base_item{
            task_id = 57022
            ,item_base_id = 31001
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 3]}

            ]
        }
    };
get(57022, 31002, 1) ->
    {ok, #task_base_item{
            task_id = 57022
            ,item_base_id = 31002
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 4]}

            ]
        }
    };
get(57022, 31003, 1) ->
    {ok, #task_base_item{
            task_id = 57022
            ,item_base_id = 31003
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 5]}

            ]
        }
    };
get(57022, 31004, 1) ->
    {ok, #task_base_item{
            task_id = 57022
            ,item_base_id = 31004
            ,item_num = 1
            ,finish_rewards = [
                #gain{label = item, val =  [23001, 1, 10]}

            ]
        }
    };

get(_TaskId, _ItemBaseId, _Num) ->
    {false, language:get(<<"找不到相应数据">>)}.
