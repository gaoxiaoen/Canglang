{application, mgeew,
 [{description, "game world server"},
  {id, "mgeew"},
  {vsn, "0.1"},
  {modules, [mgeew]},
  {registered, [mgeew, mgeew_sup]},
  {applications, [kernel, stdlib, sasl]},
  {mod, {mgeew, []}},
  {env, []}
  ]}.
