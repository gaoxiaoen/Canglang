<?php
/*-----------------------------------------------------+
 * 默认公共配置
 +-----------------------------------------------------*/
return array(
    'server_id' => '${srv_id}', // 服务器ID
    'server_name' => '${title}', // 服务器名称，有时也作为页面title
    'server_key' => '${server_key}',  // 游戏登录密钥
    'server_host' => 'http://${host}', // 服务器URL
    'login_url' => 'http://${host}/api/tmp/login.php', // 游戏登录地址URL
    'website' => 'http://${host}/', // 官网地址
    'bbs' => 'http://${host}', // 论坛地址
    'cdn' => 'http://${host}/g/', // CDN资源地址(空表示不使用)
    // 'cdn' => 'http://mhfx1.me4399.com/g/', // CDN资源地址(空表示不使用)
    'guest_mode' => '0', // 是否使用游客模式(0:否 1:是)

    // 游戏逻辑服务器配置
    'game_host' => array(
        array('host' => '${ip}', 'port' => ${game_port}),
    ),

    // ERLANG节点信息(只需填写主节点的信息)
    'erl' => array(
        'cookie' => '${erl_cookie}',
        'node_name' => '${tag}@${ip}',
    ),

    // 充值接口相关配置
    'pay' => array(
        'key' => '${server_key}', // 充值请求加密密钥
        'url' => 'http://${host}', // 充值地址
        'ticket_lifetime' => 60, // ticket失效时间，单位:秒
        // 允许发起充值请求的IP，为空则没有限制
        'allow_ips' => array(
            
        )
    ),

    'key_api' => '${server_key}', // API接口密钥

    'timezone' => 'Asia/Shanghai', // 时区
    'ticket_lifetime' => 300, // ticket生命，单位：秒

    // 数据库服务器信息
    'database' => array(
        'driver' => 'mysql',
        'encode' => 'utf8',
        'host' => '127.0.0.1',
        'user' => '${db_user}',
        'pass' => '${db_pass}',
        'dbname' => '${db_name}'
    ),

    // 用于验证的一些正则表达式
    're' => array(
        'name' => '/^[a-z0-9_]{3,20}$/' // 角色名规则
    )
);
