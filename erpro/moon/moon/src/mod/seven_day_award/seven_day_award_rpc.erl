-module(seven_day_award_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("seven_day_award.hrl").

%%handle(19700, {}, Role) ->
%%    seven_day_award:push(Role),
%%    {ok};
%%
%%handle(19701, {Day}, Role) ->
%%    case seven_day_award:get_award(Day, Role) of
%%        {ok, Role1} ->
%%            %% seven_day_award:push(Role1),
%%            {reply, {?true, Day, ?L(<<"">>)}, Role1};
%%        {?false, Reason} ->
%%            {reply, {?false, Day, Reason}}
%%    end;

handle(_Cmd, _Args, _State) ->
    {error, unknow_command}.
