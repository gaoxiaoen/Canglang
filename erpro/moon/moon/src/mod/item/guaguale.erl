-module(guaguale).

-export([logout/1]).

-include("common.hrl").
-include("trigger.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("item.hrl").
-include("gain.hrl").

logout(Role = #role{guaguale = []}) -> 
    {ok, Role};
logout(Role = #role{id = Rid, guaguale = Guaguale}) ->
    Gains = [#gain{label = item, val = [BaseId, Bind, Num]} || {BaseId, Bind, Num} <- Guaguale],
    award:send(Rid, 209000, Gains),
    {ok, Role#role{guaguale = []}}.
