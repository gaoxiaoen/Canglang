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
-export([demo2/0,demo1/0]).
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
  [{I,(catch generate_expection(I))}||I<-[1,2,3,4,5]].

  generate_expection(1)->a;
  generate_expection(2)->throw(a);
  generate_expection(3)->exit(a);
  generate_expection(4)->{'EXIT',a};
  generate_expection(5)->
