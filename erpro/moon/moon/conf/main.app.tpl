%% 应用程序信息文件
{application, main, [
        {description, "game server"}
        ,{vsn, "0.1"}
        ,{modules, [main]}
        ,{registered, []}
        ,{applications, [kernel, stdlib, sasl]}
        ,{mod, {main, []}}
        ,{start_phases, []}
        ,{env, [
                {version,       "${version}"}     %% 当前版本, 例如："v130517_00"
                ,{srv_id,       "${srv_id}"}      %% 当前服务器标识, 例如："dev_fx_0"
                ,{srv_ids,      []}     %% 数据已合并到本服的服务器, 比如：["dev_fx_0"]
                ,{realm_a,      []}     %% 数据已合并到本服的服务器，比如：["4399_20","4399_21"]
                ,{realm_b,      []}     %% 数据已合并到本服的服务器，比如：["4399_mhfx_1"]
                ,{srv_open_time,${srv_open_time}} %% 开服时间, 比如：1331268600
                ,{server_key,   "${server_key}"}  %% 服务器密钥，比如："1111111111111"
                ,{fcm_version,  ${fcm_version}} %% 防沉迷版本[0:关闭 1:严格版本 2:普通版本]，比如：2
                ,{platform,     "${platform}"}    %% 平台标志, 比如："4399"
                ,{platform_srv_cn, "${platform_srv_cn}"}      %% 平台分配服务编号, 比如："S1"
                ,{host,         "${host}"}        %% 服务器域名, 比如："mhfx1.me4399.com"
                ,{platform_srvs, []}  %%混服信息，比如：[{"4399","4399_20","1111111111111"},{"4399","4399_21","1111111111111"},{"4399","4399_mhfx_1","1111111111111"}
                ,{line_num, 10}
                ,{tcp_acceptor_num, 80} %% 启动acceptor的数量
                ,{tcp_options, [
                        binary
                        ,{packet, 0}
                        ,{active, false}
                        ,{reuseaddr, true}
                        ,{nodelay, false}
                        ,{delay_send, true}
                        ,{exit_on_close, false}
                        ,{send_timeout, 10000}
                        ,{send_timeout_close, false}
                    ]
                }
                ,{tcp_options_flash_843, [
                        binary
                        ,{packet, 0}
                        ,{active, false}
                        ,{reuseaddr, true}
                        ,{exit_on_close, false}
                    ]
                }

                %% 数据库相关设置
                ,{db_cfg, [
                         "127.0.0.1"       %% 地址, 比如："127.0.0.1"
                        ,3306           %% 端口号, 比如：3306
                        ,"${db_user}"    %% 用户名, 比如："qiyuan"
                        ,"${db_pass}"     %% 密码, 比如："123456"
                        ,"${db_name}"     %% 库名, 比如："fx_m"
                        ,'utf8'         %% 编码, 比如: utf8
                        ,${db_conn}     %% 连接数, 比如：80
                    ]
                }
            ]
        }
    ]
}.
