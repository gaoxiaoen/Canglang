%% -----------------------
%% 酒桶节配置表
%% @autor wangweibiao
%% ------------------------
-module(signon_data).
-export([
		get/2
		]).

-include("gain.hrl").
get(9, 1) ->
	{1, 1, [#gain{label = item, val = [111001, 1, 10]}], [#gain{label = item, val = [111001, 1, 20]}]};
get(9, 2) ->
	{0, 0, [#gain{label = item, val = [221104, 1, 4]}], [#gain{label = item, val = [221104, 1, 8]}]};
get(9, 3) ->
	{0, 0, [#gain{label = item, val = [535644, 1, 3]}], [#gain{label = item, val = [535644, 1, 6]}]};
get(9, 4) ->
	{1, 2, [#gain{label = item, val = [535644, 1, 4]}], [#gain{label = item, val = [535644, 1, 8]}]};
get(9, 5) ->
	{0, 0, [#gain{label = item, val = [131001, 1, 4]}], [#gain{label = item, val = [131001, 1, 8]}]};
get(9, 6) ->
	{0, 0, [#gain{label = item, val = [231001, 1, 4]}], [#gain{label = item, val = [231001, 1, 8]}]};
get(9, 7) ->
	{1, 3, [#gain{label = item, val = [111214, 1, 1]}], [#gain{label = item, val = [111214, 1, 2]}]};
get(9, 8) ->
	{0, 0, [#gain{label = item, val = [221104, 1, 6]}], [#gain{label = item, val = [221104, 1, 12]}]};
get(9, 9) ->
	{0, 0, [#gain{label = item, val = [221102, 1, 4]}], [#gain{label = item, val = [221102, 1, 8]}]};
get(9, 10) ->
	{1, 4, [#gain{label = item, val = [535651, 1, 5]}], [#gain{label = item, val = [535651, 1, 10]}]};
get(9, 11) ->
	{0, 0, [#gain{label = item, val = [131001, 1, 8]}], [#gain{label = item, val = [131001, 1, 16]}]};
get(9, 12) ->
	{0, 0, [#gain{label = item, val = [231001, 1, 8]}], [#gain{label = item, val = [231001, 1, 16]}]};
get(_, _) ->
	false.
	
	
