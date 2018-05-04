-module(cfg_router).

-include("common_records.hrl").

-export([find/1]).

find(map_enter)->               {map,mod_map_role};
find(map_enter_confirm)->       {map,mod_map_role};
find(map_update_mapinfo)->      {map,mod_map_actor};
find(map_change_map)->          {map,mod_map_role};
find(map_query)->               {map,mod_map_actor};
find(move_walk_path)->          {map,mod_move};
find(move_walk)->               {map,mod_move};
find(move_sync)->               {map,mod_move};
find(fight_attack) ->           {map,mod_fight};

find(system_config_update)->    {role,mod_system};
find(system_gm)->               {role,mod_gm};

find(goods_query)->             {role,mod_goods};
find(goods_swap)->              {role,mod_goods};
find(goods_tidy)->              {role,mod_goods};
find(goods_divide)->            {role,mod_goods};
find(goods_destroy)->           {role,mod_goods};
find(goods_show)->              {role,mod_goods};
find(goods_use)->               {role,mod_goods};
find(goods_add_grid)->          {role,mod_goods};

find(role_get_info) ->          {role,mod_role_bi};
find(role_set) ->               {role,mod_role_bi};
find(role_get_skill) ->         {role,mod_skill};
find(role_relive) ->            {map, mod_map_role};
find(role_cure) ->              {role,mod_role_bi};

find(letter_get)->              {process,mgeew_letter_server};
find(letter_open)->             {process,mgeew_letter_server};
find(letter_p2p_send)->         {process,mgeew_letter_server};
find(letter_delete)->           {process,mgeew_letter_server};
find(letter_accept_goods)->     {process,mgeew_letter_server};

find(mission_query)->           {role,mod_mission};
find(mission_do)->              {role,mod_mission};
find(mission_do_complete)->     {role,mod_mission};
find(mission_do_submit)->       {role,mod_mission};
find(mission_cancel)->          {role,mod_mission};
find(mission_recolor)->         {role,mod_mission};
find(mission_auto)->            {role,mod_mission};

find(customer_service_query)->  {role,mod_customer};
find(customer_service_do)->     {role,mod_customer};
find(customer_service_del)->    {role,mod_customer};

find(family_query)->            {process,family_manager_server};
find(family_create)->           {role,mod_family};
find(family_request)->          {role,mod_family};
find(family_invite)->           {role,mod_family};
find(family_accept)->           {role,mod_family};
find(family_refuse)->           {role,mod_family};
find(family_disband)->          {role,mod_family};
find(family_fire)->             {role,mod_family};
find(family_leave)->            {role,mod_family};
find(family_set)->              {process,family_manager_server};
find(family_log_query)->        {process,family_manager_server};
find(family_donate)->           {process,family_manager_server};
find(family_tech_query)->       {process,family_manager_server};
find(family_depot_query)->      {process,family_manager_server};
find(family_depot_get)->        {process,family_manager_server};
find(family_depot_destroy)->    {process,family_manager_server};
find(family_get)->              {process,family_manager_server};
find(family_turn)->             {role,mod_family};

find(pet_query) ->              {role,mod_pet};
find(pet_battle) ->             {role,mod_pet};
find(pet_back) ->               {role,mod_pet};
find(pet_free) ->               {role,mod_pet};

find(fb_enter) ->               {role,mod_fb};
find(fb_quit) ->                {role,mod_fb};
find(fb_query) ->               {role,mod_fb};
find(fb_monster) ->             {map, mod_common_fb};

find(ranking_get)->             {process,mgeew_ranking_server};

find(chat_in_channel)->         {role,mod_chat};
find(chat_get_goods)->          {process,chat_goods_cache_server};

find(team_create) ->            {role,mod_team};
find(team_invite) ->            {role,mod_team};
find(team_apply) ->             {role,mod_team};
find(team_accept) ->            {role,mod_team};
find(team_refuse) ->            {role,mod_team};
find(team_leave) ->             {role,mod_team};
find(team_kick) ->              {role,mod_team};
find(team_disband) ->           {role,mod_team};
find(team_appoint) ->           {role,mod_team};
find(team_sync) ->              {role,mod_team};
  
find(_)->[].
