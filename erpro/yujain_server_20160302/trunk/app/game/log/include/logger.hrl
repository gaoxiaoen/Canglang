%%%-------------------------------------------------------------------
%%% File        :logger.hrl
%%%-------------------------------------------------------------------
-define(APP_NAME, logger.server).

-define(DEV(Format, Args),
        common_logger:dev(?APP_NAME, ?MODULE, ?LINE, Format, Args)).

-define(DEBUG(Format, Args),
        common_logger:debug_msg(?APP_NAME, ?MODULE,?LINE,Format, Args)).

-define(INFO_MSG(Format, Args),
        common_logger:info_msg( node(), ?MODULE,?LINE,Format, Args)).
                  
-define(WARNING_MSG(Format, Args),
        common_logger:warning_msg( node(), ?MODULE,?LINE,Format, Args)).
                  
-define(ERROR_MSG(Format, Args),
        common_logger:error_msg( node(), ?MODULE,?LINE,Format, Args)).

-include("common.hrl").

-define(DEFAULT_POOL,emysql_pool).
-define(POOL_SIZE,8).
-define(POOL_PORT,3306).
-define(ENCODING,utf8).


