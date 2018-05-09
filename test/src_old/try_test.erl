%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 测试try的用法
%%% @end
%%% Created : 07. 五月 2018 9:41
%%%-------------------------------------------------------------------
-module(try_test).
-author("Administrator").

%% API
-export([demo2/0,demo1/0,demo3/0]).
demo1() ->
  [catcher(I) || I <-[1,2,3,4,5]].

catcher(N) ->
  try generate_exception(N) of
      Val -> {N,normal,Val}
  catch
    throw:X ->{N,caught,thrown,X};
    throw:X ->{N,caught,exited,X};
    throw:X ->{N,caught,error,X}
  end.


demo2() ->
  [{I,(catch generate_exception(I))}||I<-[1,2,3,4,5]].

generate_exception(1)->a;
generate_exception(2)->throw(a);
generate_exception(3)->exit(a);
generate_exception(4)->{'EXIT',a};
generate_exception(5)->error(a).


demo3() ->
    try generate_exception(5)
    catch
        error:X ->
            {X,erlang:get_stacktrace()}
    end.





