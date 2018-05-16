%%角色信息
-record(player_status, {
  accid = 0,          % 账号id
  accname = none,     % 名字
  pid = none,         % process id
  socket = none,
  sid = none
}).


%%###########ETS##################
-record(ets_online, {
  id = 0,
  accname = none,
  pid = 0,
  sid = 0
}).
