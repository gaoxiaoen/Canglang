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
                {version, "v130517_00"} %% 当前版本
                ,{srv_id, "dev_fx_0"} %% 当前服务器标识
                ,{srv_ids, ["dev_fx_0"]} %% 数据已合并到本服的服务器
                ,{realm_a, ["4399_20","4399_21"]} %% 数据已合并到本服的服务器
                ,{realm_b, ["4399_mhfx_1"]} %% 数据已合并到本服的服务器
                ,{srv_open_time, 1331268600} %% 开服时间
                ,{server_key, "1111111111111"} %% 服务器密钥
                ,{fcm_version, 2}      %% 防沉迷版本[0:关闭 1:严格版本 2:普通版本]
                ,{platform, "4399"}      %% 平台标志 
                ,{platform_srv_cn, "S1"}      %% 平台分配服务编号 
                ,{host, "mhfx1.me4399.com"}      %% 服务器域名
                ,{platform_srvs, [{"4399","4399_20","1111111111111"},{"4399","4399_21","1111111111111"},{"4399","4399_mhfx_1","1111111111111"}]  %%混服信息
                }

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
                        "127.0.0.1"     %% 地址
                        ,3306           %% 端口号
                        ,"qiyuan"          %% 用户名
                        ,"123456"       %% 密码
                        ,"fx_m"         %% 库名
                        ,utf8           %% 编码
                        ,80              %% 连接数
                    ]
                }
            ]
        }
    ]
}.
