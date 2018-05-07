-module(lib_misc).
-export([qsort/1,pythag/1,perms/1,odds_and_evensl/1,odds_and_evens2/1,count_characters/1,sqrt/1]).

% 快排算法
qsort([])->[];
qsort([Pivot|T]) ->
	qsort([X || X<-T,X<Pivot])
	++ [Pivot] ++
	qsort([X||X<-T,X>=Pivot]).
	

% 相对其中的元素进行排序，然后一一对比其中的元素数值，是否一致
% 毕达格拉斯三元数组
pythag(N) ->
	TmpList = [ {A,B,C} ||
		A<-lists:seq(1,N),
		B<-lists:seq(1,N),
		C<-lists:seq(1,N),
		A+B+C =<N,
		A*A +B*B=:=C*C
	],
	{TmpList}.
	
	
% 回文算法	
perms([]) ->[[]];
perms(L) ->[[H|T] || H<-L,T<-perms(L--[H])].

%归集器,需要遍历列表两次
odds_and_evensl(L) ->
	Odds = [X||X<-L,(X rem 2)=:=1],
	Evens = [X||X<-L,(X rem 2)=:=0],
	{Odds,Evens}.
	
%归集器2
odds_and_evens2(L) ->
		odds_and_evens_acc(L,[],[]).

odds_and_evens_acc([H|T],Odds,Evens) ->
	case(H rem 2) of
		1 ->odds_and_evens_acc(T,[H|Odds],Evens);
		0 ->odds_and_evens_acc(T,Odds,[H|Evens])
	end;
	
odds_and_evens_acc([],Odds,Evens) ->
	{lists:reverse(Odds),lists:reverse(Evens)}.
	
%计算某个字符串里各个字符的出现次数
count_characters(Str) ->
	count_characters(Str,#{}).
	
count_characters([H|T],X) ->
	count_characters(T,X#{H=>1});

count_characters([],X) ->
  X.

sqrt(X) when X<0 ->
    error({squareRootNegativeArgument,X});
sqrt(X) ->

    math:sqrt(X).
























