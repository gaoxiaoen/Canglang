%%----------------------------------------------------
%% @doc 修行任务奖励
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(task_data_xx).

-export([
        get/3
    ]
).

-include("common.hrl").
-include("task.hrl").
-include("gain.hrl").

get(40, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 40
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  16190}

            ]
        }
    };
get(40, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 40
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  16190}

            ]
        }
    };
get(40, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 40
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  136}

            ]
        }
    };
get(40
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 40
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  6400}

            ]
        }
    };
get(41, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 41
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  17011}

            ]
        }
    };
get(41, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 41
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  17011}

            ]
        }
    };
get(41, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 41
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  139}

            ]
        }
    };
get(41
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 41
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  6724}

            ]
        }
    };
get(42, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 42
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  17855}

            ]
        }
    };
get(42, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 42
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  17855}

            ]
        }
    };
get(42, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 42
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  142}

            ]
        }
    };
get(42
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 42
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  7056}

            ]
        }
    };
get(43, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 43
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  18722}

            ]
        }
    };
get(43, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 43
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  18722}

            ]
        }
    };
get(43, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 43
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  146}

            ]
        }
    };
get(43
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 43
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  7396}

            ]
        }
    };
get(44, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 44
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  19612}

            ]
        }
    };
get(44, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 44
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  19612}

            ]
        }
    };
get(44, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 44
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  149}

            ]
        }
    };
get(44
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 44
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  7744}

            ]
        }
    };
get(45, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 45
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  20526}

            ]
        }
    };
get(45, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 45
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  20526}

            ]
        }
    };
get(45, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 45
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  152}

            ]
        }
    };
get(45
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 45
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  8100}

            ]
        }
    };
get(46, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 46
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  21464}

            ]
        }
    };
get(46, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 46
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  21464}

            ]
        }
    };
get(46, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 46
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  156}

            ]
        }
    };
get(46
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 46
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  8464}

            ]
        }
    };
get(47, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 47
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  22426}

            ]
        }
    };
get(47, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 47
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  22426}

            ]
        }
    };
get(47, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 47
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  159}

            ]
        }
    };
get(47
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 47
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  8836}

            ]
        }
    };
get(48, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 48
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  23411}

            ]
        }
    };
get(48, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 48
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  23411}

            ]
        }
    };
get(48, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 48
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  163}

            ]
        }
    };
get(48
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 48
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  9216}

            ]
        }
    };
get(49, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 49
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  24421}

            ]
        }
    };
get(49, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 49
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  24421}

            ]
        }
    };
get(49, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 49
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  166}

            ]
        }
    };
get(49
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 49
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  9604}

            ]
        }
    };
get(50, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 50
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  25455}

            ]
        }
    };
get(50, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 50
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  25455}

            ]
        }
    };
get(50, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 50
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  170}

            ]
        }
    };
get(50
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 50
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  10000}

            ]
        }
    };
get(51, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 51
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  26514}

            ]
        }
    };
get(51, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 51
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  26514}

            ]
        }
    };
get(51, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 51
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  173}

            ]
        }
    };
get(51
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 51
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  10404}

            ]
        }
    };
get(52, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 52
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  27598}

            ]
        }
    };
get(52, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 52
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  27598}

            ]
        }
    };
get(52, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 52
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  176}

            ]
        }
    };
get(52
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 52
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  10816}

            ]
        }
    };
get(53, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 53
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  28706}

            ]
        }
    };
get(53, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 53
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  28706}

            ]
        }
    };
get(53, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 53
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  180}

            ]
        }
    };
get(53
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 53
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  11236}

            ]
        }
    };
get(54, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 54
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  29840}

            ]
        }
    };
get(54, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 54
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  29840}

            ]
        }
    };
get(54, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 54
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  183}

            ]
        }
    };
get(54
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 54
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  11664}

            ]
        }
    };
get(55, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 55
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  30999}

            ]
        }
    };
get(55, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 55
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  30999}

            ]
        }
    };
get(55, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 55
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  186}

            ]
        }
    };
get(55
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 55
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  12100}

            ]
        }
    };
get(56, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 56
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  32184}

            ]
        }
    };
get(56, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 56
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  32184}

            ]
        }
    };
get(56, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 56
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  190}

            ]
        }
    };
get(56
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 56
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  12544}

            ]
        }
    };
get(57, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 57
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  33394}

            ]
        }
    };
get(57, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 57
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  33394}

            ]
        }
    };
get(57, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 57
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  193}

            ]
        }
    };
get(57
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 57
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  12996}

            ]
        }
    };
get(58, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 58
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  34630}

            ]
        }
    };
get(58, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 58
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  34630}

            ]
        }
    };
get(58, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 58
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  197}

            ]
        }
    };
get(58
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 58
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  13456}

            ]
        }
    };
get(59, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 59
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  35892}

            ]
        }
    };
get(59, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 59
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  35892}

            ]
        }
    };
get(59, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 59
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  200}

            ]
        }
    };
get(59
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 59
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  13924}

            ]
        }
    };
get(60, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 60
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  37180}

            ]
        }
    };
get(60, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 60
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  37180}

            ]
        }
    };
get(60, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 60
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  204}

            ]
        }
    };
get(60
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 60
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  14400}

            ]
        }
    };
get(61, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 61
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  38494}

            ]
        }
    };
get(61, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 61
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  38494}

            ]
        }
    };
get(61, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 61
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  207}

            ]
        }
    };
get(61
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 61
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  14884}

            ]
        }
    };
get(62, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 62
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  39836}

            ]
        }
    };
get(62, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 62
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  39836}

            ]
        }
    };
get(62, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 62
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  210}

            ]
        }
    };
get(62
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 62
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  15376}

            ]
        }
    };
get(63, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 63
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  41203}

            ]
        }
    };
get(63, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 63
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  41203}

            ]
        }
    };
get(63, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 63
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  214}

            ]
        }
    };
get(63
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 63
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  15876}

            ]
        }
    };
get(64, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 64
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  42598}

            ]
        }
    };
get(64, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 64
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  42598}

            ]
        }
    };
get(64, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 64
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  217}

            ]
        }
    };
get(64
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 64
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  16384}

            ]
        }
    };
get(65, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 65
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  44019}

            ]
        }
    };
get(65, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 65
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  44019}

            ]
        }
    };
get(65, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 65
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  220}

            ]
        }
    };
get(65
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 65
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  16900}

            ]
        }
    };
get(66, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 66
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  45468}

            ]
        }
    };
get(66, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 66
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  45468}

            ]
        }
    };
get(66, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 66
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  224}

            ]
        }
    };
get(66
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 66
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  17424}

            ]
        }
    };
get(67, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 67
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  46944}

            ]
        }
    };
get(67, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 67
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  46944}

            ]
        }
    };
get(67, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 67
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  227}

            ]
        }
    };
get(67
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 67
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  17956}

            ]
        }
    };
get(68, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 68
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  48448}

            ]
        }
    };
get(68, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 68
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  48448}

            ]
        }
    };
get(68, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 68
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  231}

            ]
        }
    };
get(68
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 68
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  18496}

            ]
        }
    };
get(69, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 69
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  49979}

            ]
        }
    };
get(69, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 69
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  49979}

            ]
        }
    };
get(69, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 69
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  234}

            ]
        }
    };
get(69
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 69
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  19044}

            ]
        }
    };
get(70, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 70
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  51538}

            ]
        }
    };
get(70, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 70
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  51538}

            ]
        }
    };
get(70, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 70
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  238}

            ]
        }
    };
get(70
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 70
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  19600}

            ]
        }
    };
get(71, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 71
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  53124}

            ]
        }
    };
get(71, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 71
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  53124}

            ]
        }
    };
get(71, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 71
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  241}

            ]
        }
    };
get(71
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 71
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  20164}

            ]
        }
    };
get(72, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 72
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  54740}

            ]
        }
    };
get(72, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 72
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  54740}

            ]
        }
    };
get(72, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 72
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  244}

            ]
        }
    };
get(72
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 72
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  20736}

            ]
        }
    };
get(73, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 73
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  56383}

            ]
        }
    };
get(73, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 73
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  56383}

            ]
        }
    };
get(73, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 73
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  248}

            ]
        }
    };
get(73
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 73
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  21316}

            ]
        }
    };
get(74, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 74
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  58055}

            ]
        }
    };
get(74, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 74
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  58055}

            ]
        }
    };
get(74, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 74
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  251}

            ]
        }
    };
get(74
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 74
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  21904}

            ]
        }
    };
get(75, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 75
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  59755}

            ]
        }
    };
get(75, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 75
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  59755}

            ]
        }
    };
get(75, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 75
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  254}

            ]
        }
    };
get(75
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 75
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  22500}

            ]
        }
    };
get(76, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 76
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  61484}

            ]
        }
    };
get(76, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 76
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  61484}

            ]
        }
    };
get(76, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 76
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  258}

            ]
        }
    };
get(76
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 76
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  23104}

            ]
        }
    };
get(77, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 77
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  63242}

            ]
        }
    };
get(77, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 77
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  63242}

            ]
        }
    };
get(77, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 77
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  261}

            ]
        }
    };
get(77
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 77
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  23716}

            ]
        }
    };
get(78, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 78
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  65030}

            ]
        }
    };
get(78, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 78
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  65030}

            ]
        }
    };
get(78, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 78
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  265}

            ]
        }
    };
get(78
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 78
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  24336}

            ]
        }
    };
get(79, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 79
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  66846}

            ]
        }
    };
get(79, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 79
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  66846}

            ]
        }
    };
get(79, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 79
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  268}

            ]
        }
    };
get(79
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 79
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  24964}

            ]
        }
    };
get(80, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 80
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  68692}

            ]
        }
    };
get(80, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 80
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  68692}

            ]
        }
    };
get(80, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 80
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  272}

            ]
        }
    };
get(80
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 80
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  25600}

            ]
        }
    };
get(81, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 81
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  70567}

            ]
        }
    };
get(81, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 81
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  70567}

            ]
        }
    };
get(81, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 81
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  275}

            ]
        }
    };
get(81
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 81
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  26244}

            ]
        }
    };
get(82, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 82
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  72472}

            ]
        }
    };
get(82, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 82
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  72472}

            ]
        }
    };
get(82, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 82
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  278}

            ]
        }
    };
get(82
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 82
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  26896}

            ]
        }
    };
get(83, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 83
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  74406}

            ]
        }
    };
get(83, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 83
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  74406}

            ]
        }
    };
get(83, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 83
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  282}

            ]
        }
    };
get(83
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 83
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  27556}

            ]
        }
    };
get(84, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 84
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  76371}

            ]
        }
    };
get(84, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 84
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  76371}

            ]
        }
    };
get(84, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 84
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  285}

            ]
        }
    };
get(84
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 84
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  28224}

            ]
        }
    };
get(85, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 85
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  78366}

            ]
        }
    };
get(85, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 85
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  78366}

            ]
        }
    };
get(85, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 85
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  288}

            ]
        }
    };
get(85
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 85
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  28900}

            ]
        }
    };
get(86, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 86
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  80390}

            ]
        }
    };
get(86, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 86
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  80390}

            ]
        }
    };
get(86, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 86
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  292}

            ]
        }
    };
get(86
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 86
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  29584}

            ]
        }
    };
get(87, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 87
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  82446}

            ]
        }
    };
get(87, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 87
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  82446}

            ]
        }
    };
get(87, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 87
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  295}

            ]
        }
    };
get(87
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 87
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  30276}

            ]
        }
    };
get(88, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 88
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  84532}

            ]
        }
    };
get(88, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 88
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  84532}

            ]
        }
    };
get(88, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 88
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  299}

            ]
        }
    };
get(88
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 88
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  30976}

            ]
        }
    };
get(89, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 89
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  86649}

            ]
        }
    };
get(89, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 89
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  86649}

            ]
        }
    };
get(89, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 89
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  302}

            ]
        }
    };
get(89
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 89
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  31684}

            ]
        }
    };
get(90, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 90
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  88796}

            ]
        }
    };
get(90, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 90
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  88796}

            ]
        }
    };
get(90, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 90
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  306}

            ]
        }
    };
get(90
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 90
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  32400}

            ]
        }
    };
get(91, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 91
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  90975}

            ]
        }
    };
get(91, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 91
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  90975}

            ]
        }
    };
get(91, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 91
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  309}

            ]
        }
    };
get(91
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 91
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  33124}

            ]
        }
    };
get(92, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 92
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  93184}

            ]
        }
    };
get(92, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 92
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  93184}

            ]
        }
    };
get(92, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 92
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  312}

            ]
        }
    };
get(92
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 92
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  33856}

            ]
        }
    };
get(93, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 93
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  95425}

            ]
        }
    };
get(93, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 93
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  95425}

            ]
        }
    };
get(93, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 93
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  316}

            ]
        }
    };
get(93
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 93
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  34596}

            ]
        }
    };
get(94, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 94
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  97698}

            ]
        }
    };
get(94, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 94
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  97698}

            ]
        }
    };
get(94, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 94
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  319}

            ]
        }
    };
get(94
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 94
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  35344}

            ]
        }
    };
get(95, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 95
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  100002}

            ]
        }
    };
get(95, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 95
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  100002}

            ]
        }
    };
get(95, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 95
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  322}

            ]
        }
    };
get(95
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 95
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  36100}

            ]
        }
    };
get(96, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 96
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  102337}

            ]
        }
    };
get(96, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 96
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  102337}

            ]
        }
    };
get(96, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 96
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  326}

            ]
        }
    };
get(96
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 96
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  36864}

            ]
        }
    };
get(97, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 97
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  104704}

            ]
        }
    };
get(97, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 97
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  104704}

            ]
        }
    };
get(97, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 97
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  329}

            ]
        }
    };
get(97
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 97
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  37636}

            ]
        }
    };
get(98, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 98
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  107104}

            ]
        }
    };
get(98, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 98
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  107104}

            ]
        }
    };
get(98, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 98
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  333}

            ]
        }
    };
get(98
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 98
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  38416}

            ]
        }
    };
get(99, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 99
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  109536}

            ]
        }
    };
get(99, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 99
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  109536}

            ]
        }
    };
get(99, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 99
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  336}

            ]
        }
    };
get(99
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 99
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  39204}

            ]
        }
    };
get(100, ?task_xx_exp, _) ->
    {ok, #task_xx_rewards{
            lev = 100
            ,sec_type = ?task_xx_exp
            ,rewards = [
                #gain{label = exp, val =  112000}

            ]
        }
    };
get(100, ?task_xx_psychic, _) ->
    {ok, #task_xx_rewards{
            lev = 100
            ,sec_type = ?task_xx_psychic
            ,rewards = [
                #gain{label = attainment, val =  112000}

            ]
        }
    };
get(100, ?task_xx_attainment, _) ->
    {ok, #task_xx_rewards{
            lev = 100
            ,sec_type = ?task_xx_attainment
            ,rewards = [
                #gain{label = attainment, val =  340}

            ]
        }
    };
get(100
, ?task_xx_coin, _) ->
    {ok, #task_xx_rewards{
            lev = 100
            ,sec_type = ?task_xx_coin
            ,rewards = [
                #gain{label = coin_bind, val =  40000}

            ]
        }
    };

get(40, ?task_xx_map, 0) ->
    {ok, #task_xx_rewards{
            lev = 40
            ,sec_type = ?task_xx_map
            ,quality = 0
            ,rewards = [
                #gain{label = item, val =  [29200, 1, 1]}

            ]
        }
    };
get(40, ?task_xx_pet, 0) ->
    {ok, #task_xx_rewards{
            lev = 40
            ,sec_type = ?task_xx_pet
            ,quality = 0
            ,rewards = [
                #gain{label = item, val =  [23000, 1, 5]}

            ]
        }
    };
get(40, ?task_xx_map, 1) ->
    {ok, #task_xx_rewards{
            lev = 40
            ,sec_type = ?task_xx_map
            ,quality = 1
            ,rewards = [
                #gain{label = item, val =  [29200, 1, 1]}

            ]
        }
    };
get(40, ?task_xx_pet, 1) ->
    {ok, #task_xx_rewards{
            lev = 40
            ,sec_type = ?task_xx_pet
            ,quality = 1
            ,rewards = [
                #gain{label = item, val =  [23002, 1, 1]}

            ]
        }
    };
get(40, ?task_xx_map, 2) ->
    {ok, #task_xx_rewards{
            lev = 40
            ,sec_type = ?task_xx_map
            ,quality = 2
            ,rewards = [
                #gain{label = item, val =  [29200, 1, 2]}

            ]
        }
    };
get(40, ?task_xx_pet, 2) ->
    {ok, #task_xx_rewards{
            lev = 40
            ,sec_type = ?task_xx_pet
            ,quality = 2
            ,rewards = [
                #gain{label = item, val =  [23006, 1, 1]}

            ]
        }
    };
get(40, ?task_xx_map, 3) ->
    {ok, #task_xx_rewards{
            lev = 40
            ,sec_type = ?task_xx_map
            ,quality = 3
            ,rewards = [
                #gain{label = item, val =  [29200, 1, 2]}

            ]
        }
    };
get(40, ?task_xx_pet, 3) ->
    {ok, #task_xx_rewards{
            lev = 40
            ,sec_type = ?task_xx_pet
            ,quality = 3
            ,rewards = [
                #gain{label = item, val =  [23001, 1, 1]}

            ]
        }
    };
get(40, ?task_xx_map, 4) ->
    {ok, #task_xx_rewards{
            lev = 40
            ,sec_type = ?task_xx_map
            ,quality = 4
            ,rewards = [
                #gain{label = item, val =  [29200, 1, 3]}

            ]
        }
    };
get(40, ?task_xx_pet, 4) ->
    {ok, #task_xx_rewards{
            lev = 40
            ,sec_type = ?task_xx_pet
            ,quality = 4
            ,rewards = [
                #gain{label = item, val =  [23002, 1, 2]}
               ,#gain{label = item, val =  [23001, 1, 1]}

            ]
        }
    };
get(50, ?task_xx_map, 0) ->
    {ok, #task_xx_rewards{
            lev = 50
            ,sec_type = ?task_xx_map
            ,quality = 0
            ,rewards = [
                #gain{label = item, val =  [29201, 1, 1]}

            ]
        }
    };
get(50, ?task_xx_pet, 0) ->
    {ok, #task_xx_rewards{
            lev = 50
            ,sec_type = ?task_xx_pet
            ,quality = 0
            ,rewards = [
                #gain{label = item, val =  [23000, 1, 5]}

            ]
        }
    };
get(50, ?task_xx_map, 1) ->
    {ok, #task_xx_rewards{
            lev = 50
            ,sec_type = ?task_xx_map
            ,quality = 1
            ,rewards = [
                #gain{label = item, val =  [29201, 1, 1]}

            ]
        }
    };
get(50, ?task_xx_pet, 1) ->
    {ok, #task_xx_rewards{
            lev = 50
            ,sec_type = ?task_xx_pet
            ,quality = 1
            ,rewards = [
                #gain{label = item, val =  [23002, 1, 1]}

            ]
        }
    };
get(50, ?task_xx_map, 2) ->
    {ok, #task_xx_rewards{
            lev = 50
            ,sec_type = ?task_xx_map
            ,quality = 2
            ,rewards = [
                #gain{label = item, val =  [29201, 1, 2]}

            ]
        }
    };
get(50, ?task_xx_pet, 2) ->
    {ok, #task_xx_rewards{
            lev = 50
            ,sec_type = ?task_xx_pet
            ,quality = 2
            ,rewards = [
                #gain{label = item, val =  [23006, 1, 1]}

            ]
        }
    };
get(50, ?task_xx_map, 3) ->
    {ok, #task_xx_rewards{
            lev = 50
            ,sec_type = ?task_xx_map
            ,quality = 3
            ,rewards = [
                #gain{label = item, val =  [29201, 1, 2]}

            ]
        }
    };
get(50, ?task_xx_pet, 3) ->
    {ok, #task_xx_rewards{
            lev = 50
            ,sec_type = ?task_xx_pet
            ,quality = 3
            ,rewards = [
                #gain{label = item, val =  [23001, 1, 1]}

            ]
        }
    };
get(50, ?task_xx_map, 4) ->
    {ok, #task_xx_rewards{
            lev = 50
            ,sec_type = ?task_xx_map
            ,quality = 4
            ,rewards = [
                #gain{label = item, val =  [29201, 1, 3]}

            ]
        }
    };
get(50, ?task_xx_pet, 4) ->
    {ok, #task_xx_rewards{
            lev = 50
            ,sec_type = ?task_xx_pet
            ,quality = 4
            ,rewards = [
                #gain{label = item, val =  [23002, 1, 2]}
               ,#gain{label = item, val =  [23001, 1, 1]}

            ]
        }
    };
get(60, ?task_xx_map, 0) ->
    {ok, #task_xx_rewards{
            lev = 60
            ,sec_type = ?task_xx_map
            ,quality = 0
            ,rewards = [
                #gain{label = item, val =  [29202, 1, 1]}

            ]
        }
    };
get(60, ?task_xx_pet, 0) ->
    {ok, #task_xx_rewards{
            lev = 60
            ,sec_type = ?task_xx_pet
            ,quality = 0
            ,rewards = [
                #gain{label = item, val =  [23000, 1, 5]}

            ]
        }
    };
get(60, ?task_xx_map, 1) ->
    {ok, #task_xx_rewards{
            lev = 60
            ,sec_type = ?task_xx_map
            ,quality = 1
            ,rewards = [
                #gain{label = item, val =  [29202, 1, 1]}

            ]
        }
    };
get(60, ?task_xx_pet, 1) ->
    {ok, #task_xx_rewards{
            lev = 60
            ,sec_type = ?task_xx_pet
            ,quality = 1
            ,rewards = [
                #gain{label = item, val =  [23002, 1, 1]}

            ]
        }
    };
get(60, ?task_xx_map, 2) ->
    {ok, #task_xx_rewards{
            lev = 60
            ,sec_type = ?task_xx_map
            ,quality = 2
            ,rewards = [
                #gain{label = item, val =  [29202, 1, 2]}

            ]
        }
    };
get(60, ?task_xx_pet, 2) ->
    {ok, #task_xx_rewards{
            lev = 60
            ,sec_type = ?task_xx_pet
            ,quality = 2
            ,rewards = [
                #gain{label = item, val =  [23006, 1, 1]}

            ]
        }
    };
get(60, ?task_xx_map, 3) ->
    {ok, #task_xx_rewards{
            lev = 60
            ,sec_type = ?task_xx_map
            ,quality = 3
            ,rewards = [
                #gain{label = item, val =  [29202, 1, 2]}

            ]
        }
    };
get(60, ?task_xx_pet, 3) ->
    {ok, #task_xx_rewards{
            lev = 60
            ,sec_type = ?task_xx_pet
            ,quality = 3
            ,rewards = [
                #gain{label = item, val =  [23001, 1, 1]}

            ]
        }
    };
get(60, ?task_xx_map, 4) ->
    {ok, #task_xx_rewards{
            lev = 60
            ,sec_type = ?task_xx_map
            ,quality = 4
            ,rewards = [
                #gain{label = item, val =  [29202, 1, 3]}

            ]
        }
    };
get(60, ?task_xx_pet, 4) ->
    {ok, #task_xx_rewards{
            lev = 60
            ,sec_type = ?task_xx_pet
            ,quality = 4
            ,rewards = [
                #gain{label = item, val =  [23002, 1, 2]}
               ,#gain{label = item, val =  [23001, 1, 1]}

            ]
        }
    };
get(70, ?task_xx_map, 0) ->
    {ok, #task_xx_rewards{
            lev = 70
            ,sec_type = ?task_xx_map
            ,quality = 0
            ,rewards = [
                #gain{label = item, val =  [29203, 1, 1]}

            ]
        }
    };
get(70, ?task_xx_pet, 0) ->
    {ok, #task_xx_rewards{
            lev = 70
            ,sec_type = ?task_xx_pet
            ,quality = 0
            ,rewards = [
                #gain{label = item, val =  [23000, 1, 5]}

            ]
        }
    };
get(70, ?task_xx_map, 1) ->
    {ok, #task_xx_rewards{
            lev = 70
            ,sec_type = ?task_xx_map
            ,quality = 1
            ,rewards = [
                #gain{label = item, val =  [29203, 1, 1]}

            ]
        }
    };
get(70, ?task_xx_pet, 1) ->
    {ok, #task_xx_rewards{
            lev = 70
            ,sec_type = ?task_xx_pet
            ,quality = 1
            ,rewards = [
                #gain{label = item, val =  [23002, 1, 1]}

            ]
        }
    };
get(70, ?task_xx_map, 2) ->
    {ok, #task_xx_rewards{
            lev = 70
            ,sec_type = ?task_xx_map
            ,quality = 2
            ,rewards = [
                #gain{label = item, val =  [29203, 1, 2]}

            ]
        }
    };
get(70, ?task_xx_pet, 2) ->
    {ok, #task_xx_rewards{
            lev = 70
            ,sec_type = ?task_xx_pet
            ,quality = 2
            ,rewards = [
                #gain{label = item, val =  [23006, 1, 1]}

            ]
        }
    };
get(70, ?task_xx_map, 3) ->
    {ok, #task_xx_rewards{
            lev = 70
            ,sec_type = ?task_xx_map
            ,quality = 3
            ,rewards = [
                #gain{label = item, val =  [29203, 1, 2]}

            ]
        }
    };
get(70, ?task_xx_pet, 3) ->
    {ok, #task_xx_rewards{
            lev = 70
            ,sec_type = ?task_xx_pet
            ,quality = 3
            ,rewards = [
                #gain{label = item, val =  [23001, 1, 1]}

            ]
        }
    };
get(70, ?task_xx_map, 4) ->
    {ok, #task_xx_rewards{
            lev = 70
            ,sec_type = ?task_xx_map
            ,quality = 4
            ,rewards = [
                #gain{label = item, val =  [29203, 1, 3]}

            ]
        }
    };
get(70, ?task_xx_pet, 4) ->
    {ok, #task_xx_rewards{
            lev = 70
            ,sec_type = ?task_xx_pet
            ,quality = 4
            ,rewards = [
                #gain{label = item, val =  [23002, 1, 2]}
               ,#gain{label = item, val =  [23001, 1, 1]}

            ]
        }
    };
get(Lev, SecType, Quality) ->
    ?ERR("出大事了，修行任务找不到对应的奖励信息[lev:~w, SecType:~w, Quality:~w]", [Lev, SecType, Quality]),
    {false, <<"找不奖励信息">>}.

