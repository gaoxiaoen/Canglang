{   
    application, server,
    [   
        {description, "This is game server."},   
        {vsn, "1.0a"},   
        {modules, [game_server_app]},   
        {registered, [game_server_sup]},   
        {applications, [kernel, stdlib, sasl]},   
        {mod, {game_server_app, []}},   
        {start_phases, []}   
    ]   
}.    
 
%% File end.  
