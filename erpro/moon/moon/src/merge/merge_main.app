%% 应用程序信息文件
{application, merge_main, [
        {description, "merge server"}
        ,{vsn, "0.1"}
        ,{modules, [merge_main]}
        ,{registered, []}
        ,{applications, [kernel, stdlib, sasl]}
        ,{mod, {merge_main, []}}
        ,{start_phases, []}
        ,{env, [
                %% 服务器信息
                {merge_target, [
                        "127.0.0.1"         %% 地址
                        ,3306                   %% 端口号
                        ,"xge"                 %% 用户名
                        ,"123456"     %% 密码
                        ,"mhfx_target3"         %% 库名
                        ,utf8                   %% 编码
                        ,5                      %% 连接数
                    ]
                }
                ,{merge_src_list, [
                        {
                            "4399_1"            %% 服务器标志符
                            ,"127.0.0.1"    %% 地址
                            ,3306               %% 端口号
                            ,"xge"             %% 用户名
                            ,"123456" %% 密码
                            ,"4399_mhfx1"       %% 库名
                            ,utf8               %% 编码
                            ,8                  %% 连接数
                            ,true               %% 是否需要转阵营
                            ,1                  %% 阵营[0:阵营不变 1:蓬莱 2:逍遥]
                        }
                        ,{
                            "4399_3"            %% 服务器标志符
                            ,"127.0.0.1"    %% 地址
                            ,3306               %% 端口号
                            ,"xge"             %% 用户名
                            ,"123456" %% 密码
                            ,"mhfx_target"       %% 库名
                            ,utf8               %% 编码
                            ,8                  %% 连接数
                            ,true               %% 是否需要转阵营
                            ,2                  %% 阵营[0:阵营不变 1:蓬莱 2:逍遥]
                        }
                    ]
                }
            ]
        }
    ]
}.
