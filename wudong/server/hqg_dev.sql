/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50538
 Source Host           : localhost
 Source Database       : hqg_dev

 Target Server Type    : MySQL
 Target Server Version : 50538
 File Encoding         : utf-8

 Date: 05/15/2018 11:56:27 AM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `achieve`
-- ----------------------------
DROP TABLE IF EXISTS `achieve`;
CREATE TABLE `achieve` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '当前积分',
  `achieve_list` mediumtext NOT NULL COMMENT '成就列表',
  `log` text NOT NULL COMMENT '等级奖励记录',
  `rec_log` text NOT NULL COMMENT '最近完成的成就',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='成就';

-- ----------------------------
--  Table structure for `act_back_buy`
-- ----------------------------
DROP TABLE IF EXISTS `act_back_buy`;
CREATE TABLE `act_back_buy` (
  `id` int(10) NOT NULL DEFAULT '0',
  `total_num` int(10) NOT NULL DEFAULT '0',
  `open_day` int(10) NOT NULL,
  PRIMARY KEY (`id`,`open_day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='返利限购';

-- ----------------------------
--  Table structure for `act_cbp_rank`
-- ----------------------------
DROP TABLE IF EXISTS `act_cbp_rank`;
CREATE TABLE `act_cbp_rank` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(20) DEFAULT '' COMMENT '昵称',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `vip` int(10) NOT NULL DEFAULT '0' COMMENT 'vip等级',
  `cbp_change` int(10) NOT NULL DEFAULT '0' COMMENT '变更战力',
  `sn` int(10) NOT NULL DEFAULT '0' COMMENT '服号',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跃升冲榜活动';

-- ----------------------------
--  Table structure for `act_festival_red_gift`
-- ----------------------------
DROP TABLE IF EXISTS `act_festival_red_gift`;
CREATE TABLE `act_festival_red_gift` (
  `node` varchar(200) NOT NULL,
  `score` int(10) NOT NULL,
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`node`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='中心服红包雨';

-- ----------------------------
--  Table structure for `act_lv_back`
-- ----------------------------
DROP TABLE IF EXISTS `act_lv_back`;
CREATE TABLE `act_lv_back` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家pkey',
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `buy_id` smallint(4) DEFAULT '0' COMMENT '购买的ID',
  `get_award_id` varchar(400) DEFAULT '[]' COMMENT '领取的档数列表',
  PRIMARY KEY (`pkey`,`act_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家等级返利';

-- ----------------------------
--  Table structure for `act_open_info`
-- ----------------------------
DROP TABLE IF EXISTS `act_open_info`;
CREATE TABLE `act_open_info` (
  `open_day` int(11) NOT NULL DEFAULT '0' COMMENT '开服天数',
  `act_info` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '当天活动信息',
  PRIMARY KEY (`open_day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='循环活动';

-- ----------------------------
--  Table structure for `act_rank`
-- ----------------------------
DROP TABLE IF EXISTS `act_rank`;
CREATE TABLE `act_rank` (
  `data` text COMMENT '活动数据',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`update_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='冲榜活动数据';

-- ----------------------------
--  Table structure for `active`
-- ----------------------------
DROP TABLE IF EXISTS `active`;
CREATE TABLE `active` (
  `open_day` int(11) NOT NULL COMMENT '开服天数',
  `login` int(11) NOT NULL DEFAULT '0' COMMENT '登陆人次',
  PRIMARY KEY (`open_day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='登陆活跃统计';

-- ----------------------------
--  Table structure for `activity_area_group`
-- ----------------------------
DROP TABLE IF EXISTS `activity_area_group`;
CREATE TABLE `activity_area_group` (
  `activity_name` varchar(150) NOT NULL DEFAULT '[]' COMMENT '活动名称',
  `id_list` text NOT NULL COMMENT '服号列表',
  `group_list` text NOT NULL COMMENT '分组列表',
  PRIMARY KEY (`activity_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='区域跨服活动分区表';

-- ----------------------------
--  Table structure for `area_consume_rank`
-- ----------------------------
DROP TABLE IF EXISTS `area_consume_rank`;
CREATE TABLE `area_consume_rank` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `sn` int(11) NOT NULL DEFAULT '0' COMMENT '服务器号',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `consume_gold` int(11) NOT NULL DEFAULT '0' COMMENT '消费元宝',
  `change_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后消费时间',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '玩家等级',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='区域跨服消费榜';

-- ----------------------------
--  Table structure for `area_recharge_rank`
-- ----------------------------
DROP TABLE IF EXISTS `area_recharge_rank`;
CREATE TABLE `area_recharge_rank` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `sn` int(11) NOT NULL DEFAULT '0' COMMENT '服务器号',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `RECHARGE_gold` int(11) NOT NULL DEFAULT '0' COMMENT '消费元宝',
  `change_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后消费时间',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '玩家等级',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='充值排行榜(区域)';

-- ----------------------------
--  Table structure for `arena`
-- ----------------------------
DROP TABLE IF EXISTS `arena`;
CREATE TABLE `arena` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家KEY',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型（0机器人，1玩家）',
  `realm` int(11) NOT NULL DEFAULT '0' COMMENT '阵营',
  `career` smallint(1) NOT NULL DEFAULT '0' COMMENT '职业',
  `sex` tinyint(1) NOT NULL DEFAULT '0' COMMENT '性别',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '排名，0为未上榜',
  `max_rank` int(11) NOT NULL DEFAULT '0' COMMENT '最高排名',
  `times` tinyint(1) NOT NULL DEFAULT '0' COMMENT '次数',
  `reset_time` int(11) NOT NULL DEFAULT '0' COMMENT '恢复次数时间戳',
  `buy_times` tinyint(1) NOT NULL DEFAULT '0' COMMENT '今日购买次数',
  `cd` int(11) NOT NULL DEFAULT '0' COMMENT '挑战冷却时间',
  `in_cd` int(11) NOT NULL DEFAULT '0' COMMENT '是否CD中',
  `wins` int(11) NOT NULL DEFAULT '0' COMMENT '连胜',
  `combo` int(11) NOT NULL DEFAULT '0' COMMENT '连胜',
  `reward` text NOT NULL COMMENT '可领取奖励',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '每日时间戳',
  `rank_reward` text NOT NULL COMMENT '排名奖励记录',
  PRIMARY KEY (`pkey`),
  KEY `rank` (`rank`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='竞技场';

-- ----------------------------
--  Table structure for `attr_dan`
-- ----------------------------
DROP TABLE IF EXISTS `attr_dan`;
CREATE TABLE `attr_dan` (
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `attr_dan` varchar(1000) NOT NULL DEFAULT '[]' COMMENT '使用物品数量',
  PRIMARY KEY (`pkey`),
  KEY `index_pkey` (`pkey`) USING BTREE COMMENT '玩家pkey索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='属性丹';

-- ----------------------------
--  Table structure for `baby`
-- ----------------------------
DROP TABLE IF EXISTS `baby`;
CREATE TABLE `baby` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `type_id` int(11) NOT NULL DEFAULT '0' COMMENT '类型id',
  `name` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `figure` int(11) NOT NULL DEFAULT '0' COMMENT '形象id',
  `figure_list` text COMMENT '当前激活形象列表',
  `step` int(11) NOT NULL DEFAULT '0' COMMENT '阶数',
  `step_exp` int(11) NOT NULL DEFAULT '0' COMMENT '阶级经验',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `lv_exp` int(11) NOT NULL DEFAULT '0' COMMENT '等级经验',
  `state` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '宝宝出生时间',
  `skill` text NOT NULL COMMENT '技能列表',
  `equip_list` text NOT NULL COMMENT '装备列表',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战力',
  `attribute` text NOT NULL COMMENT '属性列表',
  PRIMARY KEY (`pkey`),
  KEY `pkey` (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='宝宝列表';

-- ----------------------------
--  Table structure for `baby_mount`
-- ----------------------------
DROP TABLE IF EXISTS `baby_mount`;
CREATE TABLE `baby_mount` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `stage` int(11) NOT NULL COMMENT '阶数',
  `exp` int(11) NOT NULL COMMENT '经验',
  `bless_cd` int(11) NOT NULL COMMENT '祝福CD',
  `baby_mount_id` int(11) NOT NULL COMMENT '形象',
  `skill_list` text NOT NULL COMMENT '技能列表',
  `equip_list` varchar(500) NOT NULL DEFAULT '[]' COMMENT '装备列表',
  `grow_num` int(11) NOT NULL DEFAULT '0' COMMENT '成长丹数量',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战力',
  `attribute` text NOT NULL COMMENT '属性列表',
  `spirit_list` text NOT NULL COMMENT '灵脉列表',
  `last_spirit` int(11) NOT NULL DEFAULT '0' COMMENT '上一次提升的灵脉',
  `spirit` int(11) NOT NULL DEFAULT '0' COMMENT '灵力值',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='子女坐骑';

-- ----------------------------
--  Table structure for `baby_weapon`
-- ----------------------------
DROP TABLE IF EXISTS `baby_weapon`;
CREATE TABLE `baby_weapon` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `stage` int(11) NOT NULL COMMENT '阶数',
  `exp` int(11) NOT NULL COMMENT '经验',
  `bless_cd` int(11) NOT NULL COMMENT '祝福CD',
  `baby_weapon_id` int(11) NOT NULL COMMENT '形象',
  `skill_list` text NOT NULL COMMENT '技能列表',
  `equip_list` varchar(500) NOT NULL DEFAULT '[]' COMMENT '装备列表',
  `grow_num` int(11) NOT NULL DEFAULT '0' COMMENT '成长丹数量',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战力',
  `attribute` text NOT NULL COMMENT '属性列表',
  `spirit_list` text NOT NULL COMMENT '灵脉列表',
  `last_spirit` int(11) NOT NULL DEFAULT '0' COMMENT '上一次提升的灵脉',
  `spirit` int(11) NOT NULL DEFAULT '0' COMMENT '灵力值',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='子女武器';

-- ----------------------------
--  Table structure for `baby_wing`
-- ----------------------------
DROP TABLE IF EXISTS `baby_wing`;
CREATE TABLE `baby_wing` (
  `pkey` int(11) NOT NULL,
  `stage` int(1) NOT NULL COMMENT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `bless_cd` int(11) NOT NULL DEFAULT '0',
  `current_image_id` int(1) NOT NULL DEFAULT '0',
  `own_special_image` varchar(500) NOT NULL DEFAULT '',
  `combatpower` int(10) NOT NULL DEFAULT '0' COMMENT '光翼战力',
  `star_list` varchar(400) NOT NULL DEFAULT '[]' COMMENT '星等',
  `skill_list` varchar(400) NOT NULL DEFAULT '[]' COMMENT '技能列表',
  `equip_list` varchar(500) NOT NULL DEFAULT '[]' COMMENT '装备列表',
  `grow_num` int(11) NOT NULL DEFAULT '0' COMMENT '成长丹数量',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战力',
  `attribute` text NOT NULL COMMENT '属性列表',
  `spirit_list` text NOT NULL COMMENT '灵脉列表',
  `last_spirit` int(11) NOT NULL DEFAULT '0' COMMENT '上一次提升的灵脉',
  `spirit` int(11) NOT NULL DEFAULT '0' COMMENT '灵力值',
  PRIMARY KEY (`pkey`),
  KEY `stage` (`stage`) USING BTREE,
  KEY `combatpower` (`combatpower`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家子女翅膀表';

-- ----------------------------
--  Table structure for `battlefield`
-- ----------------------------
DROP TABLE IF EXISTS `battlefield`;
CREATE TABLE `battlefield` (
  `pkey` int(11) NOT NULL COMMENT '玩家KEY',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '积分',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '排名',
  `honor` int(11) NOT NULL DEFAULT '0' COMMENT '荣誉',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='战场信息';

-- ----------------------------
--  Table structure for `bubble`
-- ----------------------------
DROP TABLE IF EXISTS `bubble`;
CREATE TABLE `bubble` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `bubble_list` text NOT NULL COMMENT '泡泡列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='泡泡';

-- ----------------------------
--  Table structure for `buff`
-- ----------------------------
DROP TABLE IF EXISTS `buff`;
CREATE TABLE `buff` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `buff_list` text NOT NULL COMMENT 'buff列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='长CDbuff列表';

-- ----------------------------
--  Table structure for `cat`
-- ----------------------------
DROP TABLE IF EXISTS `cat`;
CREATE TABLE `cat` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `stage` int(11) NOT NULL COMMENT '阶数',
  `exp` int(11) NOT NULL COMMENT '经验',
  `bless_cd` int(11) NOT NULL COMMENT '祝福CD',
  `cat_id` int(11) NOT NULL COMMENT '形象',
  `skill_list` text NOT NULL COMMENT '技能列表',
  `equip_list` varchar(500) NOT NULL DEFAULT '[]' COMMENT '装备列表',
  `grow_num` int(11) NOT NULL DEFAULT '0' COMMENT '成长丹数量',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战力',
  `attribute` text NOT NULL COMMENT '属性列表',
  `spirit_list` text NOT NULL COMMENT '灵脉列表',
  `last_spirit` int(11) NOT NULL DEFAULT '0' COMMENT '上一次提升的灵脉',
  `spirit` int(11) NOT NULL DEFAULT '0' COMMENT '灵力值',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='灵猫';

-- ----------------------------
--  Table structure for `consume_type`
-- ----------------------------
DROP TABLE IF EXISTS `consume_type`;
CREATE TABLE `consume_type` (
  `id` int(10) NOT NULL DEFAULT '0' COMMENT '消费id',
  `name` varchar(500) DEFAULT '' COMMENT '消费名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消费类型';

-- ----------------------------
--  Table structure for `cron_consume_type`
-- ----------------------------
DROP TABLE IF EXISTS `cron_consume_type`;
CREATE TABLE `cron_consume_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '统计时间',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '货币类型: 1 为钻石 2 为绑定钻石 3为铜币',
  `data` mediumtext NOT NULL COMMENT '序列化后的统计数据',
  PRIMARY KEY (`id`),
  UNIQUE KEY `time, type` (`time`,`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12022 DEFAULT CHARSET=utf8 COMMENT='消费类型统计表格';

-- ----------------------------
--  Table structure for `cron_cur_money`
-- ----------------------------
DROP TABLE IF EXISTS `cron_cur_money`;
CREATE TABLE `cron_cur_money` (
  `gold` int(10) DEFAULT '0' COMMENT '产出的总钻石数',
  `bgold` int(10) DEFAULT '0' COMMENT '产出的总绑定钻石数',
  `coin` int(10) DEFAULT '0' COMMENT '产出的总金币数',
  `bcoin` int(10) DEFAULT '0' COMMENT '产出的总绑定金币数',
  `time` int(10) DEFAULT '0' COMMENT '更新时间戳',
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='全服当天产出的总钻石、金币日志';

-- ----------------------------
--  Table structure for `cron_daily`
-- ----------------------------
DROP TABLE IF EXISTS `cron_daily`;
CREATE TABLE `cron_daily` (
  `time` int(10) NOT NULL,
  `login_num` int(10) DEFAULT '0' COMMENT '登陆数',
  `reg_num` int(10) DEFAULT '0' COMMENT '每日注册数',
  `reg_time_data` text COMMENT '序列化的时间注册数据',
  PRIMARY KEY (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='当天玩家登陆数';

-- ----------------------------
--  Table structure for `cron_goods_count`
-- ----------------------------
DROP TABLE IF EXISTS `cron_goods_count`;
CREATE TABLE `cron_goods_count` (
  `goods_id` int(10) NOT NULL DEFAULT '0' COMMENT '物品类型id',
  `num` int(10) DEFAULT '0' COMMENT '物品总数量',
  `goods_name` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`goods_id`),
  KEY `num` (`num`) USING BTREE,
  KEY `goodsname` (`goods_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='物品统计日志';

-- ----------------------------
--  Table structure for `cron_login`
-- ----------------------------
DROP TABLE IF EXISTS `cron_login`;
CREATE TABLE `cron_login` (
  `time` int(11) NOT NULL COMMENT '时间戳',
  `sn` int(11) NOT NULL DEFAULT '0' COMMENT '服务器id',
  `acc_login` int(11) NOT NULL DEFAULT '0' COMMENT '登陆人数',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '平均等级',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '平均战力',
  `acc_charge` int(11) NOT NULL DEFAULT '0' COMMENT '总充值',
  PRIMARY KEY (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='每日活跃统计';

-- ----------------------------
--  Table structure for `cron_money`
-- ----------------------------
DROP TABLE IF EXISTS `cron_money`;
CREATE TABLE `cron_money` (
  `gold` int(10) DEFAULT '0' COMMENT '产出的总钻石数',
  `bgold` int(10) DEFAULT '0' COMMENT '产出的总绑定钻石数',
  `coin` int(10) DEFAULT '0' COMMENT '产出的总金币数',
  `bcoin` int(10) DEFAULT '0' COMMENT '产出的总绑定金币数',
  `time` int(10) DEFAULT '0' COMMENT '更新时间戳',
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='全服产出的总钻石、金币日志';

-- ----------------------------
--  Table structure for `cron_player_goods_count`
-- ----------------------------
DROP TABLE IF EXISTS `cron_player_goods_count`;
CREATE TABLE `cron_player_goods_count` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `goods_list` text COMMENT '今天获得的物品列表[goodsid,goodsnum]',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家当天物品获得统计数据';

-- ----------------------------
--  Table structure for `cron_player_money`
-- ----------------------------
DROP TABLE IF EXISTS `cron_player_money`;
CREATE TABLE `cron_player_money` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家ID',
  `sum_gold` int(10) DEFAULT '0' COMMENT '今天获得的总钻石数',
  `sum_coin` int(10) DEFAULT '0' COMMENT '今天获得的总金币数',
  `time` int(10) DEFAULT '0' COMMENT '更新时间戳',
  PRIMARY KEY (`pkey`),
  KEY `gold` (`sum_gold`) USING BTREE,
  KEY `coin` (`sum_coin`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家当天获得钻石、金币日志';

-- ----------------------------
--  Table structure for `cron_rate_ltv`
-- ----------------------------
DROP TABLE IF EXISTS `cron_rate_ltv`;
CREATE TABLE `cron_rate_ltv` (
  `date` int(10) NOT NULL,
  `d1` float(10,2) DEFAULT NULL,
  `d2` float(10,2) DEFAULT NULL,
  `d3` float(10,2) DEFAULT NULL,
  `d4` float(10,2) DEFAULT NULL,
  `d5` float(10,2) DEFAULT NULL,
  `d6` float(10,2) DEFAULT NULL,
  `d7` float(10,2) DEFAULT NULL,
  `d10` float(10,2) DEFAULT NULL,
  `d15` float(10,2) DEFAULT NULL,
  `d30` float(10,2) DEFAULT NULL,
  PRIMARY KEY (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='7日ltv';

-- ----------------------------
--  Table structure for `cron_rate_online`
-- ----------------------------
DROP TABLE IF EXISTS `cron_rate_online`;
CREATE TABLE `cron_rate_online` (
  `date` int(10) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `online_data` text COMMENT '在线数据',
  PRIMARY KEY (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='在线时长数据表';

-- ----------------------------
--  Table structure for `cron_rate_player`
-- ----------------------------
DROP TABLE IF EXISTS `cron_rate_player`;
CREATE TABLE `cron_rate_player` (
  `date` int(11) NOT NULL,
  `d1` float(10,3) DEFAULT NULL,
  `d2` float(10,3) DEFAULT NULL,
  `d3` float(10,3) DEFAULT NULL,
  `d4` float(10,3) DEFAULT NULL,
  `d5` float(10,3) DEFAULT NULL,
  `d6` float(10,3) DEFAULT NULL,
  `d7` float(10,3) DEFAULT NULL,
  `d15` float(10,3) DEFAULT NULL,
  `d30` float(10,3) DEFAULT NULL,
  PRIMARY KEY (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家留存表';

-- ----------------------------
--  Table structure for `cron_rate_time`
-- ----------------------------
DROP TABLE IF EXISTS `cron_rate_time`;
CREATE TABLE `cron_rate_time` (
  `date` int(10) NOT NULL COMMENT '日期时间戳',
  `ratetime` text CHARACTER SET latin1 COMMENT '流失率数据',
  PRIMARY KEY (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='时间流失率';

-- ----------------------------
--  Table structure for `cron_recharge`
-- ----------------------------
DROP TABLE IF EXISTS `cron_recharge`;
CREATE TABLE `cron_recharge` (
  `time` int(10) NOT NULL DEFAULT '0' COMMENT '时间',
  `total_fee` int(10) DEFAULT '0' COMMENT '充值金额',
  `charge_times` int(10) DEFAULT '0' COMMENT '充值次数',
  `charge_users` int(10) DEFAULT '0' COMMENT '充值人数',
  `charge_new_users` int(10) DEFAULT '0' COMMENT '新用户充值数',
  `charge_new_rate` float(10,4) DEFAULT NULL COMMENT '新用户付费率',
  `charge_act_users` int(11) DEFAULT '0' COMMENT '活跃付费用户数',
  `charge_act_rate` float(10,4) DEFAULT NULL COMMENT '活跃用户付费率',
  PRIMARY KEY (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='充值统计表';

-- ----------------------------
--  Table structure for `cron_return`
-- ----------------------------
DROP TABLE IF EXISTS `cron_return`;
CREATE TABLE `cron_return` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `is_return` smallint(1) NOT NULL DEFAULT '0' COMMENT '最大格子数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='旧玩家是否处理过表';

-- ----------------------------
--  Table structure for `cron_task`
-- ----------------------------
DROP TABLE IF EXISTS `cron_task`;
CREATE TABLE `cron_task` (
  `task_id` int(11) NOT NULL DEFAULT '0' COMMENT '任务id',
  `name` varchar(50) NOT NULL DEFAULT '0' COMMENT '任务名称',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '任务类型(1主线，2支线)',
  `acc_accept` int(11) NOT NULL DEFAULT '0' COMMENT '接受统计',
  `acc_finish` int(11) NOT NULL DEFAULT '0' COMMENT '完成统计',
  PRIMARY KEY (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='任务统计';

-- ----------------------------
--  Table structure for `cross_1vn_final_log`
-- ----------------------------
DROP TABLE IF EXISTS `cross_1vn_final_log`;
CREATE TABLE `cross_1vn_final_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(20) NOT NULL DEFAULT '[]' COMMENT '昵称',
  `rank` int(11) NOT NULL COMMENT '排名',
  `sn` int(11) NOT NULL COMMENT '服号',
  `vip` int(11) NOT NULL COMMENT 'vip等级',
  `guild_name` varchar(20) NOT NULL DEFAULT '[]' COMMENT '公会名称',
  `lv_group` int(11) NOT NULL COMMENT '战区分组',
  `month` int(11) NOT NULL COMMENT '期数(月)',
  `day` int(11) NOT NULL COMMENT '期数(日)',
  `mount_id` int(11) NOT NULL COMMENT '坐骑id',
  `wing_id` int(11) NOT NULL COMMENT '翅膀id',
  `wepon_id` int(11) NOT NULL COMMENT '武器id',
  `clothing_id` int(11) NOT NULL COMMENT '服装id',
  `light_wepon_id` int(11) NOT NULL COMMENT '光武id',
  `fashion_cloth_id` int(11) NOT NULL COMMENT '时装id',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `head_id` int(11) NOT NULL DEFAULT '0' COMMENT '头像id',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战斗力',
  `sex` int(11) NOT NULL DEFAULT '1' COMMENT '性别',
  `node` varchar(256) NOT NULL DEFAULT '[]' COMMENT '区域节点名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `cross_1vn_shop`
-- ----------------------------
DROP TABLE IF EXISTS `cross_1vn_shop`;
CREATE TABLE `cross_1vn_shop` (
  `sn` int(11) NOT NULL DEFAULT '0' COMMENT '服号',
  `shop` text NOT NULL COMMENT '限购列表',
  `shop_base` text NOT NULL COMMENT '配置列表',
  `shop_round` int(11) NOT NULL DEFAULT '1' COMMENT '轮次',
  `op_time` int(11) NOT NULL DEFAULT '1' COMMENT '更新时间',
  PRIMARY KEY (`sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服1vn商城信息';

-- ----------------------------
--  Table structure for `cross_arena`
-- ----------------------------
DROP TABLE IF EXISTS `cross_arena`;
CREATE TABLE `cross_arena` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家KEY',
  `node` varchar(50) NOT NULL DEFAULT '' COMMENT '跨服节点',
  `nickname` varchar(100) NOT NULL DEFAULT '' COMMENT '昵称',
  `career` tinyint(1) NOT NULL COMMENT '职业',
  `sex` tinyint(1) NOT NULL DEFAULT '0' COMMENT '性别',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战力',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '排名',
  `shadow` text NOT NULL COMMENT '分身数据',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '每日时间戳',
  `vs` int(11) NOT NULL DEFAULT '0' COMMENT '挑战次数',
  PRIMARY KEY (`pkey`,`node`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服竞技场';

-- ----------------------------
--  Table structure for `cross_arena_mb`
-- ----------------------------
DROP TABLE IF EXISTS `cross_arena_mb`;
CREATE TABLE `cross_arena_mb` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `times` tinyint(1) NOT NULL COMMENT '可挑战次数',
  `reset_time` int(11) NOT NULL COMMENT '恢复时间戳',
  `buy_times` tinyint(1) NOT NULL COMMENT '购买次数',
  `in_cd` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否CD中',
  `cd` int(11) NOT NULL DEFAULT '0' COMMENT 'CD时间',
  `time` int(11) NOT NULL COMMENT '每日时间戳',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '积分',
  `score_reward` text NOT NULL COMMENT '积分领取记录',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服竞技场玩家次数信息';

-- ----------------------------
--  Table structure for `cross_boss`
-- ----------------------------
DROP TABLE IF EXISTS `cross_boss`;
CREATE TABLE `cross_boss` (
  `node` varchar(50) NOT NULL DEFAULT '' COMMENT '节点',
  `boss_id` int(11) NOT NULL COMMENT 'bossid',
  PRIMARY KEY (`node`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服boss信息';

-- ----------------------------
--  Table structure for `cross_boss_mb`
-- ----------------------------
DROP TABLE IF EXISTS `cross_boss_mb`;
CREATE TABLE `cross_boss_mb` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `times` int(11) NOT NULL COMMENT '挑战次数',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服boss玩家挑战信息';

-- ----------------------------
--  Table structure for `cross_consume_rank`
-- ----------------------------
DROP TABLE IF EXISTS `cross_consume_rank`;
CREATE TABLE `cross_consume_rank` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `sn` int(11) NOT NULL DEFAULT '0' COMMENT '服务器号',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `consume_gold` int(11) NOT NULL DEFAULT '0' COMMENT '消费元宝',
  `change_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后消费时间',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '玩家等级',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服消费榜';

-- ----------------------------
--  Table structure for `cross_dark_blibe`
-- ----------------------------
DROP TABLE IF EXISTS `cross_dark_blibe`;
CREATE TABLE `cross_dark_blibe` (
  `id` int(32) unsigned NOT NULL DEFAULT '0' COMMENT '服务器ID',
  `p_num` text COMMENT '参与人数',
  `t_val` int(32) DEFAULT '0' COMMENT '占领值',
  `task_list` text COMMENT '服务器任务列表',
  `time` int(32) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='深渊魔宫跨服数据';

-- ----------------------------
--  Table structure for `cross_dark_blibe_player`
-- ----------------------------
DROP TABLE IF EXISTS `cross_dark_blibe_player`;
CREATE TABLE `cross_dark_blibe_player` (
  `player_id` int(11) NOT NULL DEFAULT '0' COMMENT '玩家ID',
  `nick_name` varchar(500) DEFAULT NULL COMMENT '玩家名字',
  `kill_p_num` int(11) DEFAULT '0' COMMENT '击杀玩家数量',
  `kill_m_num` int(11) DEFAULT '0' COMMENT '击杀怪物数量',
  `t_val` int(11) DEFAULT '0' COMMENT '占领值',
  `get_task_ids` varchar(500) DEFAULT '[]' COMMENT '已经领取的任务列表',
  `task_list` varchar(500) DEFAULT '[]' COMMENT '玩家任务列表',
  `time` int(11) DEFAULT NULL COMMENT '时间',
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='深渊魔宫玩家数据';

-- ----------------------------
--  Table structure for `cross_eliminate`
-- ----------------------------
DROP TABLE IF EXISTS `cross_eliminate`;
CREATE TABLE `cross_eliminate` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `sn` int(11) NOT NULL COMMENT '服务器号',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `wins` int(11) NOT NULL COMMENT '胜利次数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消消乐';

-- ----------------------------
--  Table structure for `cross_eliminate_reward`
-- ----------------------------
DROP TABLE IF EXISTS `cross_eliminate_reward`;
CREATE TABLE `cross_eliminate_reward` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '排名',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服消消乐奖励';

-- ----------------------------
--  Table structure for `cross_elite`
-- ----------------------------
DROP TABLE IF EXISTS `cross_elite`;
CREATE TABLE `cross_elite` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '段位等级',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '积分',
  `times` int(11) NOT NULL DEFAULT '0' COMMENT '今日挑战次数',
  `daily_score` int(11) NOT NULL DEFAULT '0' COMMENT '今日获得功勋',
  `reward` text NOT NULL COMMENT '奖励领取列表',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服1v1数据';

-- ----------------------------
--  Table structure for `cross_flower`
-- ----------------------------
DROP TABLE IF EXISTS `cross_flower`;
CREATE TABLE `cross_flower` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `sn` int(10) NOT NULL DEFAULT '0' COMMENT '服务器号',
  `sex` int(10) NOT NULL DEFAULT '0' COMMENT '性别',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `give` int(10) NOT NULL DEFAULT '0' COMMENT '送花次数',
  `obtain` int(10) NOT NULL DEFAULT '0' COMMENT '收花次数',
  `avatar` varchar(150) NOT NULL DEFAULT '[]' COMMENT '头像地址',
  `give_change_time` int(11) NOT NULL DEFAULT '0' COMMENT '送花修改时间',
  `get_change_time` int(11) NOT NULL DEFAULT '0' COMMENT '收花修改时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服鲜花榜';

-- ----------------------------
--  Table structure for `cross_flower_achieve`
-- ----------------------------
DROP TABLE IF EXISTS `cross_flower_achieve`;
CREATE TABLE `cross_flower_achieve` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `give` int(10) NOT NULL DEFAULT '0' COMMENT '送花次数',
  `give_list` varchar(150) NOT NULL DEFAULT '[]' COMMENT '送花领取列表[id1,id2]',
  `obtain` int(10) NOT NULL DEFAULT '0' COMMENT '收花次数',
  `obtain_list` varchar(150) NOT NULL DEFAULT '[]' COMMENT '收花领取列表[id1,id2]',
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动id',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服鲜花领取记录';

-- ----------------------------
--  Table structure for `cross_fruit_player`
-- ----------------------------
DROP TABLE IF EXISTS `cross_fruit_player`;
CREATE TABLE `cross_fruit_player` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `name` varchar(30) NOT NULL COMMENT '玩家名字',
  `sn` int(10) NOT NULL DEFAULT '0' COMMENT '服号',
  `career` int(10) NOT NULL DEFAULT '0' COMMENT '职业',
  `sex` int(10) NOT NULL DEFAULT '0' COMMENT '性别',
  `avatar` text COMMENT '头像地址',
  `win_times` int(10) NOT NULL DEFAULT '0' COMMENT '胜利次数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服水果大作战';

-- ----------------------------
--  Table structure for `cross_lucky_turn`
-- ----------------------------
DROP TABLE IF EXISTS `cross_lucky_turn`;
CREATE TABLE `cross_lucky_turn` (
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `gold` int(11) DEFAULT '0' COMMENT '奖池大小',
  `log_list` text COMMENT '中奖信息',
  PRIMARY KEY (`act_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='转盘跨服元宝数据';

-- ----------------------------
--  Table structure for `cross_mining`
-- ----------------------------
DROP TABLE IF EXISTS `cross_mining`;
CREATE TABLE `cross_mining` (
  `type` int(11) NOT NULL COMMENT '矿洞类型 1普通 2高级 3稀有',
  `page` int(11) NOT NULL COMMENT '分页',
  `id` int(11) NOT NULL COMMENT '位置编号',
  `mtype` int(11) NOT NULL COMMENT '矿点类型',
  `start_time` int(11) NOT NULL COMMENT '创建时间戳',
  `first_hold_time` int(11) NOT NULL COMMENT '第一次被占领时间点',
  `last_hold_time` int(11) NOT NULL COMMENT '上一次被占领时间点',
  `ripe_time` int(11) NOT NULL COMMENT '成熟时间戳 成熟在结算之前 first_hold_time + lift_time',
  `end_time` int(11) NOT NULL COMMENT '结算时间戳',
  `is_notice` int(11) NOT NULL COMMENT '是否推送成熟',
  `hp` int(11) NOT NULL COMMENT '当前血量',
  `hp_lim` int(11) NOT NULL COMMENT '总血量',
  `is_hit` int(11) NOT NULL COMMENT '收获期是否被攻击',
  `hold_sn` int(11) NOT NULL COMMENT '占领玩家服号',
  `hold_key` int(11) NOT NULL COMMENT '占领玩家key',
  `hold_name` varchar(20) NOT NULL DEFAULT '' COMMENT '占领玩家名称',
  `hold_guild_name` varchar(50) NOT NULL DEFAULT '' COMMENT '占领玩家工会名',
  `meet_type` int(11) NOT NULL COMMENT '奇遇类型',
  `meet_start_time` int(11) NOT NULL COMMENT '奇遇开始时间',
  `meet_end_time` int(11) NOT NULL COMMENT '奇遇结束时间',
  `thief_start_time` int(11) NOT NULL COMMENT '小偷开始时间',
  `thief_end_time` int(11) NOT NULL COMMENT '小偷结束时间',
  `thief_cbp` int(11) NOT NULL COMMENT '小偷战斗力',
  `hold_sex` int(11) NOT NULL DEFAULT '0' COMMENT '性别',
  `hold_avatar` varchar(120) NOT NULL DEFAULT '[]' COMMENT '头像',
  `hold_cbp` int(11) NOT NULL DEFAULT '0' COMMENT '占领玩家战斗力',
  `hold_vip` int(11) NOT NULL DEFAULT '0' COMMENT '玩家vip',
  `hold_dvip` int(11) NOT NULL DEFAULT '0' COMMENT '玩家dvip',
  `help_list` text NOT NULL,
  PRIMARY KEY (`type`,`page`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仙晶矿洞';

-- ----------------------------
--  Table structure for `cross_mining_rank`
-- ----------------------------
DROP TABLE IF EXISTS `cross_mining_rank`;
CREATE TABLE `cross_mining_rank` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `sn` int(11) NOT NULL COMMENT '玩家服号',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `cbp` int(11) NOT NULL COMMENT '战力',
  `vip` int(11) NOT NULL COMMENT 'vip',
  `dvip` int(11) NOT NULL COMMENT '钻石vip',
  `score` int(11) NOT NULL COMMENT '积分',
  `rank` int(11) NOT NULL COMMENT '排名',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仙晶矿域排名';

-- ----------------------------
--  Table structure for `cross_node`
-- ----------------------------
DROP TABLE IF EXISTS `cross_node`;
CREATE TABLE `cross_node` (
  `sn` int(11) NOT NULL DEFAULT '0' COMMENT '服务器id',
  `node_area` varchar(500) NOT NULL DEFAULT 'none' COMMENT '区域跨服节点',
  `node_area_time` int(11) NOT NULL DEFAULT '0' COMMENT '区域跨服重新分配时间',
  `node_war` varchar(500) NOT NULL DEFAULT 'none' COMMENT '城战跨服节点',
  `node_war_time` int(11) NOT NULL DEFAULT '0' COMMENT '城战重新分配时间',
  PRIMARY KEY (`sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服节点配置';

-- ----------------------------
--  Table structure for `cross_recharge_rank`
-- ----------------------------
DROP TABLE IF EXISTS `cross_recharge_rank`;
CREATE TABLE `cross_recharge_rank` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `sn` int(11) NOT NULL DEFAULT '0' COMMENT '服务器号',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `RECHARGE_gold` int(11) NOT NULL DEFAULT '0' COMMENT '消费元宝',
  `change_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后消费时间',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '玩家等级',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服充值榜';

-- ----------------------------
--  Table structure for `cross_war`
-- ----------------------------
DROP TABLE IF EXISTS `cross_war`;
CREATE TABLE `cross_war` (
  `center_sn` int(10) NOT NULL DEFAULT '0' COMMENT '中央服号',
  `pkey` int(10) NOT NULL DEFAULT '0',
  `nickname` varchar(100) NOT NULL DEFAULT '""' COMMENT '城主昵称',
  PRIMARY KEY (`center_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `cross_war_area`
-- ----------------------------
DROP TABLE IF EXISTS `cross_war_area`;
CREATE TABLE `cross_war_area` (
  `sn` int(11) NOT NULL COMMENT '服务器号',
  `day` int(11) NOT NULL COMMENT '开服基本天数',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='战场分组跨服分组信息';

-- ----------------------------
--  Table structure for `cross_war_king`
-- ----------------------------
DROP TABLE IF EXISTS `cross_war_king`;
CREATE TABLE `cross_war_king` (
  `node` varchar(100) NOT NULL DEFAULT '0' COMMENT '跨服节点',
  `pkey` int(10) NOT NULL,
  `gkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '城主仙盟key',
  `sign` int(10) NOT NULL DEFAULT '0' COMMENT '王者仙盟阵营',
  `last_pkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '上次仙盟城主',
  `last_gkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '上届城主仙盟',
  `acc_win` int(10) NOT NULL DEFAULT '0' COMMENT '连胜次数',
  `kill_war_door_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '攻破城门玩家',
  `kill_king_door_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '攻破王城门',
  `def_gkey_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '防守阵营公会key',
  `att_gkey_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '攻击阵营公会',
  PRIMARY KEY (`node`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服攻城战王者信息';

-- ----------------------------
--  Table structure for `daily_mask`
-- ----------------------------
DROP TABLE IF EXISTS `daily_mask`;
CREATE TABLE `daily_mask` (
  `player_id` int(11) NOT NULL COMMENT '玩家ID',
  `list` text COMMENT '每日数据',
  `last_reset_time` int(11) DEFAULT NULL COMMENT '重置时间',
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家每日数据';

-- ----------------------------
--  Table structure for `decoration`
-- ----------------------------
DROP TABLE IF EXISTS `decoration`;
CREATE TABLE `decoration` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `decoration_list` text NOT NULL COMMENT '挂饰列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='挂饰';

-- ----------------------------
--  Table structure for `designation`
-- ----------------------------
DROP TABLE IF EXISTS `designation`;
CREATE TABLE `designation` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `designation_list` text NOT NULL COMMENT '称号列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家个人称号';

-- ----------------------------
--  Table structure for `designation_global`
-- ----------------------------
DROP TABLE IF EXISTS `designation_global`;
CREATE TABLE `designation_global` (
  `dkey` bigint(20) NOT NULL DEFAULT '0',
  `des_id` int(10) NOT NULL DEFAULT '0' COMMENT '称号id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `get_time` int(10) NOT NULL DEFAULT '0' COMMENT '获得时间',
  PRIMARY KEY (`dkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='全服称号数据';

-- ----------------------------
--  Table structure for `dun_cross_guard_ets`
-- ----------------------------
DROP TABLE IF EXISTS `dun_cross_guard_ets`;
CREATE TABLE `dun_cross_guard_ets` (
  `key` varchar(200) NOT NULL COMMENT '{副本id,层数}',
  `player_list` text NOT NULL COMMENT '玩家列表',
  `time` int(11) NOT NULL COMMENT '通关时间戳',
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服试炼副本里程碑';

-- ----------------------------
--  Table structure for `equip_magic`
-- ----------------------------
DROP TABLE IF EXISTS `equip_magic`;
CREATE TABLE `equip_magic` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `magic_info` text NOT NULL COMMENT '附魔信息',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='装备附魔表';

-- ----------------------------
--  Table structure for `equip_refine`
-- ----------------------------
DROP TABLE IF EXISTS `equip_refine`;
CREATE TABLE `equip_refine` (
  `pkey` int(11) NOT NULL,
  `refine_info` text NOT NULL COMMENT '精炼信息',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='装备精炼表';

-- ----------------------------
--  Table structure for `equip_soul`
-- ----------------------------
DROP TABLE IF EXISTS `equip_soul`;
CREATE TABLE `equip_soul` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `soul_info` text NOT NULL COMMENT '武魂信息',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='装备武魂表';

-- ----------------------------
--  Table structure for `equip_wash`
-- ----------------------------
DROP TABLE IF EXISTS `equip_wash`;
CREATE TABLE `equip_wash` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `wash` text NOT NULL COMMENT '洗练信息',
  `wash_attr` text NOT NULL COMMENT '最新洗练信息',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家装备洗练信息';

-- ----------------------------
--  Table structure for `fashion`
-- ----------------------------
DROP TABLE IF EXISTS `fashion`;
CREATE TABLE `fashion` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `fashion_list` text NOT NULL COMMENT '时装列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='时装';

-- ----------------------------
--  Table structure for `fashion_suit`
-- ----------------------------
DROP TABLE IF EXISTS `fashion_suit`;
CREATE TABLE `fashion_suit` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家pkey',
  `ac_suit_ids` text COMMENT '激活套装列表',
  `fashion_act_suit_ids` text NOT NULL COMMENT '套装等级加成列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家激活套装ID';

-- ----------------------------
--  Table structure for `fb_act`
-- ----------------------------
DROP TABLE IF EXISTS `fb_act`;
CREATE TABLE `fb_act` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(11) NOT NULL COMMENT '活动id',
  `goods` text NOT NULL COMMENT '物品',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`pkey`,`act_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='fb 分享奖励';

-- ----------------------------
--  Table structure for `festival_back_buy`
-- ----------------------------
DROP TABLE IF EXISTS `festival_back_buy`;
CREATE TABLE `festival_back_buy` (
  `id` int(10) NOT NULL DEFAULT '0',
  `total_num` int(10) NOT NULL DEFAULT '0',
  `open_day` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`,`open_day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='返利限购';

-- ----------------------------
--  Table structure for `flower_rank`
-- ----------------------------
DROP TABLE IF EXISTS `flower_rank`;
CREATE TABLE `flower_rank` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `sex` int(10) NOT NULL DEFAULT '0' COMMENT '性别',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `give` int(10) NOT NULL DEFAULT '0' COMMENT '送花次数',
  `obtain` int(10) NOT NULL DEFAULT '0' COMMENT '收花次数',
  `avatar` varchar(150) NOT NULL DEFAULT '[]' COMMENT '头像地址',
  `give_change_time` int(11) NOT NULL DEFAULT '0' COMMENT '送花修改时间',
  `get_change_time` int(11) NOT NULL DEFAULT '0' COMMENT '收花修改时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='单服鲜花榜';

-- ----------------------------
--  Table structure for `flower_rank_achieve`
-- ----------------------------
DROP TABLE IF EXISTS `flower_rank_achieve`;
CREATE TABLE `flower_rank_achieve` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `give` int(10) NOT NULL DEFAULT '0' COMMENT '送花次数',
  `give_list` varchar(150) NOT NULL DEFAULT '[]' COMMENT '送花领取列表[id1,id2]',
  `obtain` int(10) NOT NULL DEFAULT '0' COMMENT '收花次数',
  `obtain_list` varchar(150) NOT NULL DEFAULT '[]' COMMENT '收花领取列表[id1,id2]',
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动id',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='单服鲜花领取表';

-- ----------------------------
--  Table structure for `footprint`
-- ----------------------------
DROP TABLE IF EXISTS `footprint`;
CREATE TABLE `footprint` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `stage` int(11) NOT NULL COMMENT '阶数',
  `exp` int(11) NOT NULL COMMENT '经验',
  `bless_cd` int(11) NOT NULL COMMENT '祝福CD',
  `footprint_id` int(11) NOT NULL COMMENT '形象',
  `skill_list` text NOT NULL COMMENT '技能列表',
  `equip_list` varchar(500) NOT NULL DEFAULT '[]' COMMENT '装备列表',
  `grow_num` int(11) NOT NULL DEFAULT '0' COMMENT '成长丹数量',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战力',
  `attribute` text NOT NULL COMMENT '属性列表',
  `spirit_list` text NOT NULL COMMENT '灵脉列表',
  `last_spirit` int(11) NOT NULL DEFAULT '0' COMMENT '上一次提升的灵脉',
  `spirit` int(11) NOT NULL DEFAULT '0' COMMENT '灵力值',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='足迹';

-- ----------------------------
--  Table structure for `friend_like`
-- ----------------------------
DROP TABLE IF EXISTS `friend_like`;
CREATE TABLE `friend_like` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `like_times` smallint(5) NOT NULL DEFAULT '0' COMMENT '赞别人的数目',
  `self_like_times` int(1) NOT NULL DEFAULT '0' COMMENT '被赞的数字',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家背包信息表';

-- ----------------------------
--  Table structure for `gem_exp`
-- ----------------------------
DROP TABLE IF EXISTS `gem_exp`;
CREATE TABLE `gem_exp` (
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `exp_string` varchar(1000) NOT NULL DEFAULT '' COMMENT '经验文档',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='宝石合成表';

-- ----------------------------
--  Table structure for `gemstone`
-- ----------------------------
DROP TABLE IF EXISTS `gemstone`;
CREATE TABLE `gemstone` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `subtype` int(11) NOT NULL COMMENT '装备类型',
  `gemstone` text NOT NULL COMMENT '宝石列表',
  PRIMARY KEY (`pkey`,`subtype`),
  KEY `pkey` (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='宝石';

-- ----------------------------
--  Table structure for `global_daily_count`
-- ----------------------------
DROP TABLE IF EXISTS `global_daily_count`;
CREATE TABLE `global_daily_count` (
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
  `count` int(11) NOT NULL DEFAULT '0' COMMENT '计数',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='全局每日计数';

-- ----------------------------
--  Table structure for `global_forever_count`
-- ----------------------------
DROP TABLE IF EXISTS `global_forever_count`;
CREATE TABLE `global_forever_count` (
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
  `count` int(11) NOT NULL DEFAULT '0' COMMENT '计数',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='全局每日计数';

-- ----------------------------
--  Table structure for `god_treasure`
-- ----------------------------
DROP TABLE IF EXISTS `god_treasure`;
CREATE TABLE `god_treasure` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `stage` int(11) NOT NULL COMMENT '阶数',
  `exp` int(11) NOT NULL COMMENT '经验',
  `bless_cd` int(11) NOT NULL COMMENT '祝福CD',
  `god_treasure_id` int(11) NOT NULL COMMENT '形象',
  `skill_list` text NOT NULL COMMENT '技能列表',
  `equip_list` varchar(500) NOT NULL DEFAULT '[]' COMMENT '装备列表',
  `grow_num` int(11) NOT NULL DEFAULT '0' COMMENT '成长丹数量',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战力',
  `attribute` text NOT NULL COMMENT '属性列表',
  `spirit_list` text NOT NULL COMMENT '灵脉列表',
  `last_spirit` int(11) NOT NULL DEFAULT '0' COMMENT '上一次提升的灵脉',
  `spirit` int(11) NOT NULL DEFAULT '0' COMMENT '灵力值',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仙宝';

-- ----------------------------
--  Table structure for `god_weapon`
-- ----------------------------
DROP TABLE IF EXISTS `god_weapon`;
CREATE TABLE `god_weapon` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `weapon_list` text NOT NULL COMMENT '神器列表',
  `skill_id` int(11) NOT NULL DEFAULT '0' COMMENT '技能id',
  `weapon_id` int(11) NOT NULL DEFAULT '0' COMMENT '当前幻化',
  `star_list` text COMMENT '阶级/洗练',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='十荒神器';

-- ----------------------------
--  Table structure for `godness`
-- ----------------------------
DROP TABLE IF EXISTS `godness`;
CREATE TABLE `godness` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `key` bigint(22) NOT NULL DEFAULT '0',
  `pkey` int(10) NOT NULL DEFAULT '0',
  `godness_id` int(10) NOT NULL DEFAULT '0',
  `is_war` int(1) NOT NULL DEFAULT '0' COMMENT '0未出战1出战',
  `lv` int(3) NOT NULL DEFAULT '0',
  `star` int(2) NOT NULL DEFAULT '0',
  `exp` int(10) NOT NULL DEFAULT '0',
  `skill_list` varchar(1024) NOT NULL DEFAULT '[]',
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`) USING BTREE,
  KEY `pkey` (`pkey`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=596 DEFAULT CHARSET=utf8 COMMENT='神祇';

-- ----------------------------
--  Table structure for `gold_silver_tower_ets`
-- ----------------------------
DROP TABLE IF EXISTS `gold_silver_tower_ets`;
CREATE TABLE `gold_silver_tower_ets` (
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `sys_buy_list` text NOT NULL COMMENT '金银塔日志表',
  UNIQUE KEY `key` (`act_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='金银塔日志表';

-- ----------------------------
--  Table structure for `golden_body`
-- ----------------------------
DROP TABLE IF EXISTS `golden_body`;
CREATE TABLE `golden_body` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `stage` int(11) NOT NULL COMMENT '阶数',
  `exp` int(11) NOT NULL COMMENT '经验',
  `bless_cd` int(11) NOT NULL COMMENT '祝福CD',
  `golden_body_id` int(11) NOT NULL COMMENT '形象',
  `skill_list` text NOT NULL COMMENT '技能列表',
  `equip_list` varchar(500) NOT NULL DEFAULT '[]' COMMENT '装备列表',
  `grow_num` int(11) NOT NULL DEFAULT '0' COMMENT '成长丹数量',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战力',
  `attribute` text NOT NULL COMMENT '属性列表',
  `spirit_list` text NOT NULL COMMENT '灵脉列表',
  `last_spirit` int(11) NOT NULL DEFAULT '0' COMMENT '上一次提升的灵脉',
  `spirit` int(11) NOT NULL DEFAULT '0' COMMENT '灵力值',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='灵猫';

-- ----------------------------
--  Table structure for `goods`
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods` (
  `gkey` bigint(22) NOT NULL COMMENT 'key',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `goods_id` int(9) NOT NULL DEFAULT '0' COMMENT '类型id',
  `location` tinyint(2) NOT NULL DEFAULT '0' COMMENT '位置',
  `cell` smallint(2) NOT NULL DEFAULT '0' COMMENT '所在格子 ',
  `state` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 正常 1删除',
  `num` smallint(5) unsigned NOT NULL DEFAULT '1' COMMENT '数量',
  `bind` tinyint(2) NOT NULL DEFAULT '0' COMMENT '绑定状态',
  `expiretime` int(10) DEFAULT '0' COMMENT '过期时间',
  `createtime` int(10) DEFAULT '0' COMMENT '创建时间',
  `origin` int(10) DEFAULT '0' COMMENT '来源0系统',
  `goods_lv` int(1) NOT NULL DEFAULT '0' COMMENT '物品等级',
  `star` int(1) NOT NULL DEFAULT '0' COMMENT '星星',
  `stren` int(1) DEFAULT '0' COMMENT '强化数',
  `color` int(1) NOT NULL DEFAULT '0' COMMENT '颜色',
  `exp` int(10) NOT NULL DEFAULT '0' COMMENT '经验值',
  `wear_key` bigint(22) NOT NULL DEFAULT '0' COMMENT '装在某一神祇上',
  `wash_luck_value` int(1) NOT NULL DEFAULT '0' COMMENT '幸运值',
  `wash_attrs` varchar(300) DEFAULT '' COMMENT '洗练属性列表',
  `xian_wash_attrs` varchar(300) DEFAULT '[]' COMMENT '仙练属性[{key, value, color}]',
  `gemstone_groove` varchar(100) DEFAULT '' COMMENT '镶嵌的宝石',
  `total_attrs` varchar(200) DEFAULT '' COMMENT '总属性',
  `combat_power` int(1) DEFAULT '0' COMMENT '战斗力',
  `refine_attr` varchar(300) DEFAULT '[]' COMMENT '洗练属性列表',
  `god_forging` int(11) NOT NULL DEFAULT '0' COMMENT '神炼等级',
  `lock_s` int(11) NOT NULL DEFAULT '0' COMMENT '锁定状态',
  `fix_attrs` varchar(300) DEFAULT '[]' COMMENT '固定属性',
  `random_attrs` varchar(300) DEFAULT '[]' COMMENT '随机属性',
  `sex` tinyint(2) DEFAULT '0' COMMENT '装备性别',
  `level` int(11) NOT NULL DEFAULT '0' COMMENT '装备等级',
  PRIMARY KEY (`gkey`),
  KEY `expire` (`expiretime`) USING BTREE,
  KEY `pid` (`pkey`) USING BTREE,
  KEY `cpw` (`combat_power`) USING BTREE,
  KEY `location` (`location`) USING BTREE,
  KEY `cell` (`cell`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家物品表';

-- ----------------------------
--  Table structure for `guild`
-- ----------------------------
DROP TABLE IF EXISTS `guild`;
CREATE TABLE `guild` (
  `gkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '公会ID',
  `name` varchar(50) NOT NULL DEFAULT 'Helloword' COMMENT '公会名称',
  `cn_time` int(11) NOT NULL DEFAULT '0' COMMENT '改名时间',
  `icon` int(11) NOT NULL DEFAULT '0' COMMENT '图标',
  `icon_list` text NOT NULL COMMENT '图标列表',
  `realm` tinyint(1) NOT NULL DEFAULT '0' COMMENT '阵营',
  `lv` tinyint(1) NOT NULL DEFAULT '1' COMMENT '公会等级',
  `num` tinyint(1) NOT NULL DEFAULT '0' COMMENT '人数',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '会长KEY',
  `pname` varchar(50) NOT NULL DEFAULT 'Helloword' COMMENT '会长昵称',
  `pcareer` smallint(4) NOT NULL DEFAULT '0' COMMENT '会长职业',
  `pvip` int(10) NOT NULL DEFAULT '0' COMMENT '帮主vip等级',
  `notice` varchar(500) NOT NULL DEFAULT 'HelloWord' COMMENT '公告',
  `log` text NOT NULL COMMENT '日志',
  `dedicate` int(11) NOT NULL DEFAULT '0' COMMENT '奉献',
  `acc_task` int(11) NOT NULL DEFAULT '0' COMMENT '任务统计',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '公会类型1系统0玩家',
  `sys_id` tinyint(1) NOT NULL DEFAULT '0' COMMENT '系统公会id',
  `condition` text NOT NULL COMMENT '加入条件',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `last_hy_key` int(11) NOT NULL DEFAULT '0' COMMENT '上一次活跃之星',
  `last_hy_val` int(11) NOT NULL DEFAULT '0' COMMENT '昨日活跃值',
  `like_times` int(11) NOT NULL DEFAULT '0' COMMENT '点赞次数',
  `hy_gift_time` int(11) NOT NULL DEFAULT '0' COMMENT '活跃奖励领取时间',
  `max_pass_floor` int(11) NOT NULL DEFAULT '0' COMMENT '今日最高通关波数',
  `pass_pkey` int(11) NOT NULL DEFAULT '0' COMMENT '通关玩家key',
  `pass_floor_list` text NOT NULL COMMENT '通关波数列表',
  `pass_update_time` int(11) NOT NULL DEFAULT '0' COMMENT '妖魔通关更新时间',
  `boss_star` int(11) NOT NULL DEFAULT '1' COMMENT 'boss星级',
  `boss_exp` int(11) NOT NULL DEFAULT '0' COMMENT 'boss经验',
  `boss_state` int(11) NOT NULL DEFAULT '0' COMMENT 'boss状态',
  `last_name` varchar(250) NOT NULL DEFAULT '[]' COMMENT '上次特殊召唤玩家',
  `guild_icon` int(11) NOT NULL DEFAULT '1' COMMENT '公会图标',
  PRIMARY KEY (`gkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公会信息';

-- ----------------------------
--  Table structure for `guild_apply`
-- ----------------------------
DROP TABLE IF EXISTS `guild_apply`;
CREATE TABLE `guild_apply` (
  `akey` bigint(22) NOT NULL COMMENT '唯一ID',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `gkey` bigint(22) NOT NULL COMMENT '公会key',
  `from` tinyint(1) NOT NULL DEFAULT '0' COMMENT '来源0普通1推荐',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT '申请时间',
  PRIMARY KEY (`akey`),
  KEY `pkey` (`pkey`),
  KEY `gkey` (`gkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='工会申请表';

-- ----------------------------
--  Table structure for `guild_box`
-- ----------------------------
DROP TABLE IF EXISTS `guild_box`;
CREATE TABLE `guild_box` (
  `box_key` bigint(22) NOT NULL DEFAULT '0' COMMENT '宝箱key',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `gkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '公会key',
  `pname` varchar(50) NOT NULL DEFAULT '[]' COMMENT '昵称',
  `start_time` int(11) NOT NULL DEFAULT '0' COMMENT '宝箱创建时间',
  `end_time` int(11) NOT NULL DEFAULT '0' COMMENT '宝箱结束时间',
  `base_id` int(11) NOT NULL DEFAULT '1' COMMENT '宝箱id',
  `help_list` varchar(250) NOT NULL DEFAULT '[]' COMMENT '帮助列表',
  `reward_list` varchar(250) NOT NULL DEFAULT '[]' COMMENT '宝箱奖励列表',
  `is_open` int(11) NOT NULL DEFAULT '0' COMMENT '是否已开启',
  PRIMARY KEY (`box_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='仙盟宝箱';

-- ----------------------------
--  Table structure for `guild_cross_war_sign`
-- ----------------------------
DROP TABLE IF EXISTS `guild_cross_war_sign`;
CREATE TABLE `guild_cross_war_sign` (
  `gkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '公会key',
  `sign` int(1) NOT NULL DEFAULT '0' COMMENT '1防守2攻击',
  `change_time` int(10) NOT NULL DEFAULT '0' COMMENT '更改阵营时间',
  PRIMARY KEY (`gkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服攻城战，仙盟数据';

-- ----------------------------
--  Table structure for `guild_fight`
-- ----------------------------
DROP TABLE IF EXISTS `guild_fight`;
CREATE TABLE `guild_fight` (
  `gkey` bigint(22) NOT NULL DEFAULT '0',
  `medal` int(10) NOT NULL DEFAULT '0' COMMENT '勋章数',
  `fight_list` text NOT NULL,
  `flag_lv` int(10) NOT NULL DEFAULT '0' COMMENT '旗帜等级',
  `flag_exp` int(10) NOT NULL DEFAULT '0' COMMENT '旗帜经验',
  `sum_lv` int(10) NOT NULL DEFAULT '0' COMMENT '攻破总等级',
  `guild_num` int(10) NOT NULL DEFAULT '0' COMMENT '攻破仙盟数量',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`gkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公会对战数据';

-- ----------------------------
--  Table structure for `guild_fight_shadow`
-- ----------------------------
DROP TABLE IF EXISTS `guild_fight_shadow`;
CREATE TABLE `guild_fight_shadow` (
  `gkey` bigint(22) NOT NULL,
  `g_sn` int(10) NOT NULL,
  `g_name` varchar(100) NOT NULL,
  `g_lv` int(10) NOT NULL,
  `g_cbp` int(10) NOT NULL,
  `g_num` int(10) NOT NULL,
  `member_list` text NOT NULL,
  PRIMARY KEY (`gkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仙盟对战镜像';

-- ----------------------------
--  Table structure for `guild_history`
-- ----------------------------
DROP TABLE IF EXISTS `guild_history`;
CREATE TABLE `guild_history` (
  `pkey` int(11) NOT NULL DEFAULT '0',
  `dedicate` tinyint(1) NOT NULL DEFAULT '0' COMMENT '奉献',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `q_times` int(11) NOT NULL DEFAULT '0' COMMENT '离开次数',
  `q_time` int(11) NOT NULL DEFAULT '0' COMMENT '离开时间',
  `daily_gift_get_time` int(11) NOT NULL DEFAULT '0' COMMENT '每日福利领取时间',
  `pass_floor` int(11) NOT NULL DEFAULT '0' COMMENT '今日通关波数',
  `cheer_times` int(11) NOT NULL DEFAULT '0' COMMENT '今日助威次数',
  `cheer_keys` varchar(200) NOT NULL DEFAULT '[]' COMMENT '今日助威的玩家列表',
  `be_cheer_times` int(11) NOT NULL DEFAULT '0' COMMENT '今日被助威次数',
  `demon_update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `get_demon_gift_list` varchar(1000) NOT NULL DEFAULT '[]' COMMENT '领取通关奖励列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公会历史';

-- ----------------------------
--  Table structure for `guild_manor`
-- ----------------------------
DROP TABLE IF EXISTS `guild_manor`;
CREATE TABLE `guild_manor` (
  `gkey` bigint(22) NOT NULL COMMENT '公会key',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验',
  `building_list` longtext NOT NULL COMMENT '建筑列表',
  `retinue_list` text NOT NULL COMMENT '随从列表',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '每日时间戳',
  PRIMARY KEY (`gkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='帮派家园';

-- ----------------------------
--  Table structure for `guild_member`
-- ----------------------------
DROP TABLE IF EXISTS `guild_member`;
CREATE TABLE `guild_member` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `gkey` bigint(22) NOT NULL COMMENT '公会key',
  `position` tinyint(1) NOT NULL DEFAULT '0' COMMENT '职位',
  `acc_dedicate` int(11) NOT NULL DEFAULT '0' COMMENT '奉献累计值',
  `leave_dedicate` int(11) NOT NULL DEFAULT '0' COMMENT '技能升级剩余奉献',
  `daily_dedicate` int(11) NOT NULL DEFAULT '0' COMMENT '每日奉献值',
  `dedicate_time` int(11) NOT NULL DEFAULT '0' COMMENT '最近一次奉献时间',
  `jc_hy_val` int(11) NOT NULL DEFAULT '0' COMMENT '剑池活跃值',
  `jc_hy_time` int(11) NOT NULL DEFAULT '0' COMMENT '剑池活跃值改变时间',
  `sum_hy_val` int(11) NOT NULL DEFAULT '0' COMMENT '当天总活跃值',
  `like_time` int(11) NOT NULL DEFAULT '0' COMMENT '点赞时间',
  `daily_gift_get_time` int(10) NOT NULL DEFAULT '0' COMMENT '每日福利领取时间',
  `highest_pass_floor` int(10) NOT NULL DEFAULT '0' COMMENT '最高通关波数',
  `pass_floor` int(10) NOT NULL DEFAULT '0' COMMENT '今日通关波数',
  `cheer_times` int(10) NOT NULL DEFAULT '0' COMMENT '今日助威次数',
  `cheer_keys` varchar(500) NOT NULL DEFAULT '[]' COMMENT '今日助威的玩家列表',
  `cheer_me_keys` varchar(200) NOT NULL DEFAULT '[]' COMMENT '助威我的玩家key列表',
  `be_cheer_times` int(10) NOT NULL DEFAULT '0' COMMENT '今日被助威次数',
  `demon_update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `get_demon_gift_list` varchar(500) NOT NULL DEFAULT '[]' COMMENT '领取通关奖励列表',
  `help_cheer_list` varchar(500) NOT NULL DEFAULT '[]' COMMENT '请求助威玩家key',
  `help_cheer_time` int(10) NOT NULL DEFAULT '0' COMMENT '请求助威时间',
  `acc_task` int(11) NOT NULL DEFAULT '0' COMMENT '累计任务完成次数',
  `task_log` text NOT NULL COMMENT '每日任务完成次数',
  `task_time` int(11) NOT NULL DEFAULT '0' COMMENT '最近一次任务完成时间',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT '每日时间戳',
  `war_p` int(11) NOT NULL COMMENT '公会战单期积分',
  `h_war_p` int(11) NOT NULL COMMENT '公会战历史最高积分',
  PRIMARY KEY (`pkey`),
  KEY `gkey` (`gkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公会成员';

-- ----------------------------
--  Table structure for `guild_skill`
-- ----------------------------
DROP TABLE IF EXISTS `guild_skill`;
CREATE TABLE `guild_skill` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `skill_list` text NOT NULL COMMENT '技能列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公会技能';

-- ----------------------------
--  Table structure for `guild_war`
-- ----------------------------
DROP TABLE IF EXISTS `guild_war`;
CREATE TABLE `guild_war` (
  `gkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '公会KEY',
  `group` tinyint(1) NOT NULL DEFAULT '0' COMMENT '分组',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '报名时间',
  PRIMARY KEY (`gkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公会站报名表';

-- ----------------------------
--  Table structure for `guild_war_figure`
-- ----------------------------
DROP TABLE IF EXISTS `guild_war_figure`;
CREATE TABLE `guild_war_figure` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家KEY',
  `figure_list` text NOT NULL COMMENT '形象列表信息',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公会战形象';

-- ----------------------------
--  Table structure for `head`
-- ----------------------------
DROP TABLE IF EXISTS `head`;
CREATE TABLE `head` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `head_list` text NOT NULL COMMENT '头饰列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='头饰';

-- ----------------------------
--  Table structure for `hp_pool`
-- ----------------------------
DROP TABLE IF EXISTS `hp_pool`;
CREATE TABLE `hp_pool` (
  `pkey` int(11) NOT NULL,
  `hp` int(11) NOT NULL DEFAULT '0' COMMENT '血量',
  `recover` int(11) NOT NULL DEFAULT '0' COMMENT '恢复值',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='血池';

-- ----------------------------
--  Table structure for `hunt_target`
-- ----------------------------
DROP TABLE IF EXISTS `hunt_target`;
CREATE TABLE `hunt_target` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `target` text NOT NULL COMMENT '目标列表',
  `kill_count` text NOT NULL COMMENT '击杀统计',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '每日时间戳',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='猎场目标';

-- ----------------------------
--  Table structure for `invest`
-- ----------------------------
DROP TABLE IF EXISTS `invest`;
CREATE TABLE `invest` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `is_buy_luxury` int(1) NOT NULL DEFAULT '0' COMMENT '是否购买奢侈投资',
  `is_buy_extreme` int(1) NOT NULL DEFAULT '0' COMMENT '是否购买至尊投资',
  `luxury_award` varchar(200) NOT NULL DEFAULT '[]' COMMENT '奢侈投资领取情况',
  `extreme_award` varchar(200) NOT NULL DEFAULT '[]' COMMENT '至尊投资奖励',
  `invest_award` varchar(200) NOT NULL DEFAULT '[]' COMMENT '投资赠礼领取',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家投资表';

-- ----------------------------
--  Table structure for `jade`
-- ----------------------------
DROP TABLE IF EXISTS `jade`;
CREATE TABLE `jade` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `stage` int(11) NOT NULL COMMENT '阶数',
  `exp` int(11) NOT NULL COMMENT '经验',
  `bless_cd` int(11) NOT NULL COMMENT '祝福CD',
  `jade_id` int(11) NOT NULL COMMENT '形象',
  `skill_list` text NOT NULL COMMENT '技能列表',
  `equip_list` varchar(500) NOT NULL DEFAULT '[]' COMMENT '装备列表',
  `grow_num` int(11) NOT NULL DEFAULT '0' COMMENT '成长丹数量',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战力',
  `attribute` text NOT NULL COMMENT '属性列表',
  `spirit_list` text NOT NULL COMMENT '灵脉列表',
  `last_spirit` int(11) NOT NULL DEFAULT '0' COMMENT '上一次提升的灵脉',
  `spirit` int(11) NOT NULL DEFAULT '0' COMMENT '灵力值',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玉佩';

-- ----------------------------
--  Table structure for `light_weapon`
-- ----------------------------
DROP TABLE IF EXISTS `light_weapon`;
CREATE TABLE `light_weapon` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `stage` int(11) NOT NULL COMMENT '阶数',
  `exp` int(11) NOT NULL COMMENT '经验',
  `bless_cd` int(11) NOT NULL COMMENT '祝福CD',
  `weapon_id` int(11) NOT NULL COMMENT '形象',
  `skill_list` text NOT NULL COMMENT '技能列表',
  `equip_list` varchar(500) NOT NULL DEFAULT '[]' COMMENT '装备列表',
  `grow_num` int(11) NOT NULL DEFAULT '0' COMMENT '成长丹数量',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战力',
  `attribute` text NOT NULL COMMENT '属性列表',
  `spirit_list` text NOT NULL COMMENT '灵脉列表',
  `last_spirit` int(11) NOT NULL DEFAULT '0' COMMENT '上一次提升的灵脉',
  `star_list` text NOT NULL COMMENT '星级列表',
  `own_special_image` text NOT NULL COMMENT ' 图鉴列表',
  `spirit` int(11) NOT NULL DEFAULT '0' COMMENT '灵力值',
  `activation_list` text NOT NULL COMMENT '外观等级激活',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='法宝';

-- ----------------------------
--  Table structure for `lim_shop`
-- ----------------------------
DROP TABLE IF EXISTS `lim_shop`;
CREATE TABLE `lim_shop` (
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '子活动id',
  `data` text COMMENT '活动数据',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `act_day` int(10) NOT NULL DEFAULT '0' COMMENT '默认抢购活动天数',
  PRIMARY KEY (`update_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='全服抢购商店活动数据';

-- ----------------------------
--  Table structure for `local_lucky_turn`
-- ----------------------------
DROP TABLE IF EXISTS `local_lucky_turn`;
CREATE TABLE `local_lucky_turn` (
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `gold` int(11) DEFAULT '0' COMMENT '奖池大小',
  `log_list` text COMMENT '中奖信息',
  PRIMARY KEY (`act_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='本服转盘元宝数据';

-- ----------------------------
--  Table structure for `log_acc_charge_turntable`
-- ----------------------------
DROP TABLE IF EXISTS `log_acc_charge_turntable`;
CREATE TABLE `log_acc_charge_turntable` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家昵称',
  `goods_id` int(10) DEFAULT '0' COMMENT '物品id',
  `goods_num` int(10) DEFAULT '0' COMMENT '物品数量',
  `time` int(10) DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家累充转盘抽奖日志';

-- ----------------------------
--  Table structure for `log_achieve`
-- ----------------------------
DROP TABLE IF EXISTS `log_achieve`;
CREATE TABLE `log_achieve` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `type` int(11) NOT NULL COMMENT '类型1成就2积分奖励',
  `ach_id` int(11) NOT NULL COMMENT '成就id，积分类型',
  `time` int(10) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=6157 DEFAULT CHARSET=utf8 COMMENT='成就日志';

-- ----------------------------
--  Table structure for `log_act_all_rank`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_all_rank`;
CREATE TABLE `log_act_all_rank` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `rank_type` int(10) NOT NULL DEFAULT '0',
  `rank_min` int(10) NOT NULL DEFAULT '0',
  `rank_max` int(10) NOT NULL DEFAULT '0',
  `rank_list` text NOT NULL,
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8 COMMENT='全民冲榜日志';

-- ----------------------------
--  Table structure for `log_act_con_charge`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_con_charge`;
CREATE TABLE `log_act_con_charge` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '玩家等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '0 每日奖励 1累充奖励',
  `n_id` int(11) NOT NULL DEFAULT '0' COMMENT '编号id',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8 COMMENT='连续充值日志';

-- ----------------------------
--  Table structure for `log_act_consume_score`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_consume_score`;
CREATE TABLE `log_act_consume_score` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `goods_list` varchar(150) NOT NULL DEFAULT '[]' COMMENT '物品列表',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '消耗积分',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=310 DEFAULT CHARSET=utf8 COMMENT='消费积分日志';

-- ----------------------------
--  Table structure for `log_act_daily_task`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_daily_task`;
CREATE TABLE `log_act_daily_task` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) NOT NULL COMMENT '玩家ID',
  `nickname` varchar(50) NOT NULL COMMENT '玩家名字',
  `goods_list` text COMMENT '物品列表',
  `time` int(11) DEFAULT '0' COMMENT '领取时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='每日任务活动日志';

-- ----------------------------
--  Table structure for `log_act_draw_turntable`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_draw_turntable`;
CREATE TABLE `log_act_draw_turntable` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '玩家等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `goods_list` varchar(150) NOT NULL DEFAULT '[]' COMMENT '奖励物品',
  `gold` int(11) NOT NULL DEFAULT '0' COMMENT '消耗元宝',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8 COMMENT='抽奖转盘日志';

-- ----------------------------
--  Table structure for `log_act_draw_turntable_exchange`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_draw_turntable_exchange`;
CREATE TABLE `log_act_draw_turntable_exchange` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '玩家等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '物品id',
  `goods_num` int(11) NOT NULL DEFAULT '0' COMMENT '物品数量',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '消耗积分',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='抽奖转盘兑换日志';

-- ----------------------------
--  Table structure for `log_act_exchange`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_exchange`;
CREATE TABLE `log_act_exchange` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `goods_num` int(10) NOT NULL DEFAULT '0',
  `consume` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '道具消耗',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活动兑换日志';

-- ----------------------------
--  Table structure for `log_act_flip_card`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_flip_card`;
CREATE TABLE `log_act_flip_card` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) NOT NULL COMMENT '玩家ID',
  `nickname` varchar(50) NOT NULL COMMENT '玩家名字',
  `goods_list` text COMMENT '物品列表',
  `time` int(11) DEFAULT '0' COMMENT '领取时间',
  `cost` int(11) DEFAULT '0' COMMENT '消耗',
  `same` int(11) DEFAULT '0' COMMENT '相同数',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8 COMMENT='幸运翻牌日志';

-- ----------------------------
--  Table structure for `log_act_hi_fan_point`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_hi_fan_point`;
CREATE TABLE `log_act_hi_fan_point` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `act_id` int(11) DEFAULT '0' COMMENT '活动子ID',
  `hi_id` smallint(4) DEFAULT '0' COMMENT 'hi_id',
  `desc` text COMMENT 'hi_id描述',
  `curtime` smallint(4) DEFAULT '0' COMMENT '次数上限',
  `hi_point` int(11) DEFAULT '0' COMMENT '当前hi点',
  `time` int(11) DEFAULT '0' COMMENT '当前时间点',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`)
) ENGINE=InnoDB AUTO_INCREMENT=255 DEFAULT CHARSET=utf8 COMMENT='hi翻天hi点日志';

-- ----------------------------
--  Table structure for `log_act_hi_fan_tian`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_hi_fan_tian`;
CREATE TABLE `log_act_hi_fan_tian` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT NULL COMMENT '玩家ID',
  `nickname` varchar(500) DEFAULT NULL COMMENT '玩家名字',
  `hi_id` smallint(6) DEFAULT '0' COMMENT '领取的档数',
  `goods_list` text COMMENT '领取的奖励',
  `time` int(11) DEFAULT '0' COMMENT '领取时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COMMENT='全民hi翻天领取日志';

-- ----------------------------
--  Table structure for `log_act_invest`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_invest`;
CREATE TABLE `log_act_invest` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_num` int(10) NOT NULL DEFAULT '0',
  `invest_gold` int(10) NOT NULL DEFAULT '0',
  `recv_day` int(10) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `goods_num` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `key2` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COMMENT='投资计划日志';

-- ----------------------------
--  Table structure for `log_act_jbp`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_jbp`;
CREATE TABLE `log_act_jbp` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `recv_id` int(1) NOT NULL DEFAULT '0',
  `recv_day` int(1) NOT NULL DEFAULT '0',
  `reward` varchar(200) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='聚宝盆日志';

-- ----------------------------
--  Table structure for `log_act_limit_pet`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_limit_pet`;
CREATE TABLE `log_act_limit_pet` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `cost` int(10) NOT NULL DEFAULT '0',
  `get` varchar(1024) NOT NULL DEFAULT '[]',
  `num` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=396 DEFAULT CHARSET=utf8 COMMENT='限时宠物成长抽奖';

-- ----------------------------
--  Table structure for `log_act_limit_pet_center`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_limit_pet_center`;
CREATE TABLE `log_act_limit_pet_center` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `node` varchar(200) NOT NULL DEFAULT '""',
  `pkey` int(10) NOT NULL DEFAULT '0',
  `score` int(10) NOT NULL DEFAULT '0',
  `rank` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8 COMMENT='限时宠物成长排行';

-- ----------------------------
--  Table structure for `log_act_limit_pet_reward`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_limit_pet_reward`;
CREATE TABLE `log_act_limit_pet_reward` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `rank` int(10) NOT NULL DEFAULT '0',
  `score` int(10) NOT NULL DEFAULT '0',
  `reward` varchar(1024) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='限时宠物成长排行';

-- ----------------------------
--  Table structure for `log_act_limit_xian`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_limit_xian`;
CREATE TABLE `log_act_limit_xian` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `cost` int(10) NOT NULL DEFAULT '0',
  `get` varchar(1024) NOT NULL DEFAULT '[]',
  `num` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8 COMMENT='仙装限时抢购';

-- ----------------------------
--  Table structure for `log_act_limit_xian_center`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_limit_xian_center`;
CREATE TABLE `log_act_limit_xian_center` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `node` varchar(200) NOT NULL DEFAULT '""',
  `pkey` int(10) NOT NULL DEFAULT '0',
  `score` int(10) NOT NULL DEFAULT '0',
  `rank` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='仙装限时抢购中心服日志';

-- ----------------------------
--  Table structure for `log_act_limit_xian_reward`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_limit_xian_reward`;
CREATE TABLE `log_act_limit_xian_reward` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `rank` int(10) NOT NULL DEFAULT '0',
  `score` int(10) NOT NULL DEFAULT '0',
  `reward` varchar(1024) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='仙装限时抢购日志';

-- ----------------------------
--  Table structure for `log_act_lucky_turn`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_lucky_turn`;
CREATE TABLE `log_act_lucky_turn` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT NULL COMMENT '玩家ID',
  `nickname` varchar(500) DEFAULT NULL COMMENT '玩家名字',
  `goods` varchar(500) DEFAULT NULL COMMENT '获得的物品',
  `gold` int(11) DEFAULT NULL COMMENT '获得的元宝',
  `cost_gold` int(11) DEFAULT NULL COMMENT '消耗的元宝',
  `score` int(11) DEFAULT NULL COMMENT '当前积分',
  `opera` tinyint(4) DEFAULT NULL COMMENT '操作(1一次转盘,2十次转盘,3兑换)',
  `time` int(11) DEFAULT NULL COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8 COMMENT='转盘抽奖兑换日志';

-- ----------------------------
--  Table structure for `log_act_lv_back`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_lv_back`;
CREATE TABLE `log_act_lv_back` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `act_id` int(11) DEFAULT '0' COMMENT '活动ID',
  `opera` tinyint(1) DEFAULT '0' COMMENT '(1:激活，2领取)',
  `buy_id` tinyint(1) DEFAULT '0' COMMENT '购买的档位',
  `cost` int(11) DEFAULT '0' COMMENT '购买消耗',
  `get_sub_id` tinyint(1) DEFAULT '0' COMMENT '领取的等级档位奖励',
  `get_b_gold` int(11) DEFAULT '0' COMMENT '领取的奖励',
  `time` int(11) DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8 COMMENT='玩家等级礼包返利';

-- ----------------------------
--  Table structure for `log_act_meet_limit`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_meet_limit`;
CREATE TABLE `log_act_meet_limit` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `act_type` int(11) NOT NULL DEFAULT '0' COMMENT '类型 1领取 2激活 3过期',
  `goods_list` text NOT NULL COMMENT '物品列表',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '配置id',
  `type_id` int(11) NOT NULL DEFAULT '0' COMMENT '子id',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='奇遇礼包日志表';

-- ----------------------------
--  Table structure for `log_act_mystery_tree`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_mystery_tree`;
CREATE TABLE `log_act_mystery_tree` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '玩家等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `goods_list` varchar(150) NOT NULL DEFAULT '[]' COMMENT '物品列表',
  `cost` int(11) NOT NULL DEFAULT '0' COMMENT '消耗元宝',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8 COMMENT='秘境神树日志';

-- ----------------------------
--  Table structure for `log_act_new_wealth_cat`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_new_wealth_cat`;
CREATE TABLE `log_act_new_wealth_cat` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '玩家等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `cost_gold` int(11) NOT NULL DEFAULT '0' COMMENT '消耗元宝',
  `add_gold` int(11) NOT NULL DEFAULT '0' COMMENT '增加元宝',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='新招财猫日志';

-- ----------------------------
--  Table structure for `log_act_rank`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_rank`;
CREATE TABLE `log_act_rank` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `rank` int(2) NOT NULL DEFAULT '0',
  `desc` varchar(100) NOT NULL DEFAULT '""' COMMENT '排行榜描述',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `goods_num` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='全名冲榜活动日志';

-- ----------------------------
--  Table structure for `log_act_wealth_cat`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_wealth_cat`;
CREATE TABLE `log_act_wealth_cat` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '玩家等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `cost_gold` int(11) NOT NULL DEFAULT '0' COMMENT '消耗元宝',
  `add_gold` int(11) NOT NULL DEFAULT '0' COMMENT '增加元宝',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='招财猫日志';

-- ----------------------------
--  Table structure for `log_act_welkin_hunt`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_welkin_hunt`;
CREATE TABLE `log_act_welkin_hunt` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '玩家等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `goods_list` varchar(150) NOT NULL DEFAULT '[]' COMMENT '物品列表',
  `cost` int(11) NOT NULL DEFAULT '0' COMMENT '消耗元宝',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=291 DEFAULT CHARSET=utf8 COMMENT='天宫寻宝日志';

-- ----------------------------
--  Table structure for `log_act_well_draw`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_well_draw`;
CREATE TABLE `log_act_well_draw` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '0' COMMENT '玩家名称',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
  `gold_cost` int(11) NOT NULL DEFAULT '0' COMMENT '消耗元宝',
  `coin_cost` int(11) NOT NULL DEFAULT '0' COMMENT '消耗活动金币',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '积分',
  `goods_list` varchar(150) NOT NULL DEFAULT '0' COMMENT '物品列表',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20024 DEFAULT CHARSET=utf8 COMMENT='单服许愿池抽奖';

-- ----------------------------
--  Table structure for `log_act_well_final`
-- ----------------------------
DROP TABLE IF EXISTS `log_act_well_final`;
CREATE TABLE `log_act_well_final` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '0' COMMENT '玩家名称',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '排名',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '积分',
  `goods_list` varchar(150) NOT NULL DEFAULT '0' COMMENT '物品列表',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 COMMENT='单服许愿池结算';

-- ----------------------------
--  Table structure for `log_answer_rank`
-- ----------------------------
DROP TABLE IF EXISTS `log_answer_rank`;
CREATE TABLE `log_answer_rank` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `sn` int(11) DEFAULT '0' COMMENT '服号',
  `goods` text COMMENT '物品',
  `rank` int(16) DEFAULT '0' COMMENT '排名',
  `point` int(10) DEFAULT '0' COMMENT '积分',
  `time` int(10) DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='答题排名奖励日记';

-- ----------------------------
--  Table structure for `log_area_consume_rank_final`
-- ----------------------------
DROP TABLE IF EXISTS `log_area_consume_rank_final`;
CREATE TABLE `log_area_consume_rank_final` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '昵称',
  `sn` int(11) NOT NULL DEFAULT '0' COMMENT '服号',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '最终排名',
  `value` int(11) NOT NULL DEFAULT '0' COMMENT '价值',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=217 DEFAULT CHARSET=utf8 COMMENT='区域跨服消费榜日志';

-- ----------------------------
--  Table structure for `log_area_recharge_rank_final`
-- ----------------------------
DROP TABLE IF EXISTS `log_area_recharge_rank_final`;
CREATE TABLE `log_area_recharge_rank_final` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '昵称',
  `sn` int(11) NOT NULL DEFAULT '0' COMMENT '服号',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '最终排名',
  `value` int(11) NOT NULL DEFAULT '0' COMMENT '花价值',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=utf8 COMMENT='区域跨服充值榜日志';

-- ----------------------------
--  Table structure for `log_arena`
-- ----------------------------
DROP TABLE IF EXISTS `log_arena`;
CREATE TABLE `log_arena` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `ret` tinyint(1) NOT NULL DEFAULT '0' COMMENT '挑战结果（1成功，0失败）',
  `old_rank` int(11) NOT NULL DEFAULT '0' COMMENT '旧的排名',
  `new_rank` int(11) NOT NULL DEFAULT '0' COMMENT '新的排名',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=319 DEFAULT CHARSET=utf8 COMMENT='竞技场挑战';

-- ----------------------------
--  Table structure for `log_arena_rank`
-- ----------------------------
DROP TABLE IF EXISTS `log_arena_rank`;
CREATE TABLE `log_arena_rank` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` char(22) DEFAULT '0' COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家昵称',
  `rank` int(10) DEFAULT '0' COMMENT '排行',
  `time` int(10) DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `name` (`nickname`) USING BTREE,
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='竞技排行榜日志';

-- ----------------------------
--  Table structure for `log_baby_mount_equip`
-- ----------------------------
DROP TABLE IF EXISTS `log_baby_mount_equip`;
CREATE TABLE `log_baby_mount_equip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `subtype` smallint(4) NOT NULL COMMENT '部位',
  `old_gid` int(11) NOT NULL COMMENT '旧装备id',
  `new_gid` int(11) NOT NULL COMMENT '新装备id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='子女坐骑装备日志';

-- ----------------------------
--  Table structure for `log_baby_mount_skill`
-- ----------------------------
DROP TABLE IF EXISTS `log_baby_mount_skill`;
CREATE TABLE `log_baby_mount_skill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `cell` tinyint(1) NOT NULL COMMENT '格子',
  `old_sid` int(11) NOT NULL COMMENT '旧技能id',
  `new_sid` int(11) NOT NULL COMMENT '新技能id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8 COMMENT='子女坐骑技能日志';

-- ----------------------------
--  Table structure for `log_baby_mount_spirit`
-- ----------------------------
DROP TABLE IF EXISTS `log_baby_mount_spirit`;
CREATE TABLE `log_baby_mount_spirit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=804 DEFAULT CHARSET=utf8 COMMENT='子女坐骑灵脉日志';

-- ----------------------------
--  Table structure for `log_baby_mount_stage`
-- ----------------------------
DROP TABLE IF EXISTS `log_baby_mount_stage`;
CREATE TABLE `log_baby_mount_stage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `stage` int(11) NOT NULL COMMENT '新阶数',
  `old_stage` int(11) NOT NULL COMMENT '旧阶数',
  `exp` int(11) NOT NULL COMMENT '当前经验',
  `old_exp` int(11) NOT NULL COMMENT '旧经验',
  `time` int(11) NOT NULL COMMENT '时间戳',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型0正常1清零',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=2382 DEFAULT CHARSET=utf8 COMMENT='子女坐骑升阶日志';

-- ----------------------------
--  Table structure for `log_baby_operator`
-- ----------------------------
DROP TABLE IF EXISTS `log_baby_operator`;
CREATE TABLE `log_baby_operator` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) DEFAULT NULL COMMENT '玩家id',
  `type_id` int(11) DEFAULT NULL COMMENT '类型ID',
  `name` varchar(500) DEFAULT NULL COMMENT '宠物名称',
  `figure` int(11) DEFAULT NULL COMMENT '当前形象ID',
  `figure_list` text COMMENT '激活形象列表',
  `step` smallint(6) DEFAULT NULL COMMENT '当前阶级',
  `step_exp` int(11) DEFAULT NULL COMMENT '阶级经验',
  `lv` smallint(6) DEFAULT NULL COMMENT '等级',
  `lv_exp` int(11) DEFAULT NULL COMMENT '等级经验',
  `skill` text COMMENT '技能列表',
  `equip` text COMMENT '装备列表',
  `attribute` text COMMENT '属性列表',
  `cbp` int(11) DEFAULT '0' COMMENT '战力',
  `oper` tinyint(1) DEFAULT NULL COMMENT '操作(1创建宠物，2改名，3进阶，4等级升级，5技能升级，6武器装备,7幻化,8激活图鉴,9变性)',
  `time` int(11) DEFAULT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=5861 DEFAULT CHARSET=utf8 COMMENT='玩家宝宝操作日志';

-- ----------------------------
--  Table structure for `log_baby_weapon_equip`
-- ----------------------------
DROP TABLE IF EXISTS `log_baby_weapon_equip`;
CREATE TABLE `log_baby_weapon_equip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `subtype` smallint(4) NOT NULL COMMENT '部位',
  `old_gid` int(11) NOT NULL COMMENT '旧装备id',
  `new_gid` int(11) NOT NULL COMMENT '新装备id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='子女武器装备日志';

-- ----------------------------
--  Table structure for `log_baby_weapon_skill`
-- ----------------------------
DROP TABLE IF EXISTS `log_baby_weapon_skill`;
CREATE TABLE `log_baby_weapon_skill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `cell` tinyint(1) NOT NULL COMMENT '格子',
  `old_sid` int(11) NOT NULL COMMENT '旧技能id',
  `new_sid` int(11) NOT NULL COMMENT '新技能id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8 COMMENT='子女武器技能日志';

-- ----------------------------
--  Table structure for `log_baby_weapon_spirit`
-- ----------------------------
DROP TABLE IF EXISTS `log_baby_weapon_spirit`;
CREATE TABLE `log_baby_weapon_spirit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='子女武器灵脉日志';

-- ----------------------------
--  Table structure for `log_baby_weapon_stage`
-- ----------------------------
DROP TABLE IF EXISTS `log_baby_weapon_stage`;
CREATE TABLE `log_baby_weapon_stage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `stage` int(11) NOT NULL COMMENT '新阶数',
  `old_stage` int(11) NOT NULL COMMENT '旧阶数',
  `exp` int(11) NOT NULL COMMENT '当前经验',
  `old_exp` int(11) NOT NULL COMMENT '旧经验',
  `time` int(11) NOT NULL COMMENT '时间戳',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型0正常1清零',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=1941 DEFAULT CHARSET=utf8 COMMENT='子女武器升阶日志';

-- ----------------------------
--  Table structure for `log_baby_wing_equip`
-- ----------------------------
DROP TABLE IF EXISTS `log_baby_wing_equip`;
CREATE TABLE `log_baby_wing_equip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `subtype` smallint(4) NOT NULL COMMENT '部位',
  `old_gid` int(11) NOT NULL COMMENT '旧装备id',
  `new_gid` int(11) NOT NULL COMMENT '新装备id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='子女翅膀装备日志';

-- ----------------------------
--  Table structure for `log_baby_wing_skill`
-- ----------------------------
DROP TABLE IF EXISTS `log_baby_wing_skill`;
CREATE TABLE `log_baby_wing_skill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `cell` tinyint(1) NOT NULL COMMENT '格子',
  `old_sid` int(11) NOT NULL COMMENT '旧技能id',
  `new_sid` int(11) NOT NULL COMMENT '新技能id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8 COMMENT='子女翅膀技能日志';

-- ----------------------------
--  Table structure for `log_baby_wing_spirit`
-- ----------------------------
DROP TABLE IF EXISTS `log_baby_wing_spirit`;
CREATE TABLE `log_baby_wing_spirit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='子女翅膀灵脉日志';

-- ----------------------------
--  Table structure for `log_baby_wing_stage`
-- ----------------------------
DROP TABLE IF EXISTS `log_baby_wing_stage`;
CREATE TABLE `log_baby_wing_stage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `stage` int(11) NOT NULL COMMENT '新阶数',
  `old_stage` int(11) NOT NULL COMMENT '旧阶数',
  `exp` int(11) NOT NULL COMMENT '当前经验',
  `old_exp` int(11) NOT NULL COMMENT '旧经验',
  `time` int(11) NOT NULL COMMENT '时间戳',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型0正常1清零',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=404 DEFAULT CHARSET=utf8 COMMENT='子女翅膀升阶日志';

-- ----------------------------
--  Table structure for `log_battlefield`
-- ----------------------------
DROP TABLE IF EXISTS `log_battlefield`;
CREATE TABLE `log_battlefield` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `rank` int(11) NOT NULL COMMENT '排名',
  `goods` text NOT NULL COMMENT '奖励',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='单服战场日志';

-- ----------------------------
--  Table structure for `log_boss_join`
-- ----------------------------
DROP TABLE IF EXISTS `log_boss_join`;
CREATE TABLE `log_boss_join` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `boss_id` int(11) NOT NULL COMMENT 'bossid',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT 'boss名称',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(100) NOT NULL DEFAULT '' COMMENT '玩家昵称',
  `gkey` bigint(22) NOT NULL,
  `hurt` int(11) NOT NULL COMMENT '伤害输出',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `boss_id` (`boss_id`),
  KEY `pkey` (`pkey`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 COMMENT='boss参与伤害日志';

-- ----------------------------
--  Table structure for `log_bubble`
-- ----------------------------
DROP TABLE IF EXISTS `log_bubble`;
CREATE TABLE `log_bubble` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `type` tinyint(1) NOT NULL COMMENT '类型1激活2升级3过期',
  `bubble_id` int(11) NOT NULL COMMENT '泡泡id',
  `stage` tinyint(1) NOT NULL COMMENT '阶数',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=494 DEFAULT CHARSET=utf8 COMMENT='气泡日志';

-- ----------------------------
--  Table structure for `log_buy_money`
-- ----------------------------
DROP TABLE IF EXISTS `log_buy_money`;
CREATE TABLE `log_buy_money` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL,
  `buy_type` int(11) NOT NULL DEFAULT '0' COMMENT '购买类型 1银币 2灵气',
  `cost` int(11) NOT NULL DEFAULT '0' COMMENT '花费',
  `val` int(11) NOT NULL DEFAULT '0' COMMENT '获得奖励',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`)
) ENGINE=InnoDB AUTO_INCREMENT=791 DEFAULT CHARSET=utf8 COMMENT='招财进宝日志';

-- ----------------------------
--  Table structure for `log_buy_red_equip`
-- ----------------------------
DROP TABLE IF EXISTS `log_buy_red_equip`;
CREATE TABLE `log_buy_red_equip` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `goods_list` varchar(150) NOT NULL DEFAULT '[]' COMMENT '物品列表',
  `cost` int(11) NOT NULL DEFAULT '0' COMMENT '消耗元宝',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=1497 DEFAULT CHARSET=utf8 COMMENT='红装限时抢购日志';

-- ----------------------------
--  Table structure for `log_call_godness_count`
-- ----------------------------
DROP TABLE IF EXISTS `log_call_godness_count`;
CREATE TABLE `log_call_godness_count` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '0' COMMENT '玩家名称',
  `count_id` int(11) NOT NULL DEFAULT '0' COMMENT '领取id',
  `goods_list` varchar(1024) NOT NULL DEFAULT '0' COMMENT '物品列表',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COMMENT='换神活动次数奖励';

-- ----------------------------
--  Table structure for `log_call_godness_draw`
-- ----------------------------
DROP TABLE IF EXISTS `log_call_godness_draw`;
CREATE TABLE `log_call_godness_draw` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '0' COMMENT '玩家名称',
  `cost` int(11) NOT NULL DEFAULT '0' COMMENT '消耗',
  `goods_list` varchar(1024) NOT NULL DEFAULT '0' COMMENT '物品列表',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=204 DEFAULT CHARSET=utf8 COMMENT='换神活动抽奖';

-- ----------------------------
--  Table structure for `log_cat_equip`
-- ----------------------------
DROP TABLE IF EXISTS `log_cat_equip`;
CREATE TABLE `log_cat_equip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `subtype` smallint(4) NOT NULL COMMENT '部位',
  `old_gid` int(11) NOT NULL COMMENT '旧装备id',
  `new_gid` int(11) NOT NULL COMMENT '新装备id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='灵猫装备日志';

-- ----------------------------
--  Table structure for `log_cat_skill`
-- ----------------------------
DROP TABLE IF EXISTS `log_cat_skill`;
CREATE TABLE `log_cat_skill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `cell` tinyint(1) NOT NULL COMMENT '格子',
  `old_sid` int(11) NOT NULL COMMENT '旧技能id',
  `new_sid` int(11) NOT NULL COMMENT '新技能id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=159 DEFAULT CHARSET=utf8 COMMENT='灵猫技能日志';

-- ----------------------------
--  Table structure for `log_cat_spirit`
-- ----------------------------
DROP TABLE IF EXISTS `log_cat_spirit`;
CREATE TABLE `log_cat_spirit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=160 DEFAULT CHARSET=utf8 COMMENT='灵猫灵脉日志';

-- ----------------------------
--  Table structure for `log_cat_stage`
-- ----------------------------
DROP TABLE IF EXISTS `log_cat_stage`;
CREATE TABLE `log_cat_stage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `stage` int(11) NOT NULL COMMENT '新阶数',
  `old_stage` int(11) NOT NULL COMMENT '旧阶数',
  `exp` int(11) NOT NULL COMMENT '当前经验',
  `old_exp` int(11) NOT NULL COMMENT '旧经验',
  `time` int(11) NOT NULL COMMENT '时间戳',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型0正常1清零',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=3314 DEFAULT CHARSET=utf8 COMMENT='灵猫升阶日志';

-- ----------------------------
--  Table structure for `log_cbp`
-- ----------------------------
DROP TABLE IF EXISTS `log_cbp`;
CREATE TABLE `log_cbp` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `old_cbp` bigint(20) DEFAULT '0' COMMENT '旧战力',
  `new_cbp` bigint(20) DEFAULT '0' COMMENT '新战力',
  `log` text NOT NULL COMMENT '变化内容',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=281 DEFAULT CHARSET=utf8 COMMENT='战力减少日志';

-- ----------------------------
--  Table structure for `log_cbp_rank_final`
-- ----------------------------
DROP TABLE IF EXISTS `log_cbp_rank_final`;
CREATE TABLE `log_cbp_rank_final` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '排名',
  `start_cbp` int(11) NOT NULL DEFAULT '0' COMMENT '初始战力',
  `high_cbp` int(11) NOT NULL DEFAULT '0' COMMENT '最高战力',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `change_cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战力变化',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=457 DEFAULT CHARSET=utf8 COMMENT='跃升冲榜日志';

-- ----------------------------
--  Table structure for `log_charge_gift`
-- ----------------------------
DROP TABLE IF EXISTS `log_charge_gift`;
CREATE TABLE `log_charge_gift` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `bgold` int(11) NOT NULL DEFAULT '0' COMMENT '绑定元宝数',
  `day` int(11) NOT NULL DEFAULT '0' COMMENT '剩余天数',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='绑元礼包日志';

-- ----------------------------
--  Table structure for `log_charm_rank`
-- ----------------------------
DROP TABLE IF EXISTS `log_charm_rank`;
CREATE TABLE `log_charm_rank` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` char(22) DEFAULT '0' COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家昵称',
  `charm` int(10) DEFAULT '0' COMMENT '魅力值',
  `rank` int(10) DEFAULT '0' COMMENT '排行',
  `time` int(10) DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `name` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='魅力排行榜日志';

-- ----------------------------
--  Table structure for `log_chat`
-- ----------------------------
DROP TABLE IF EXISTS `log_chat`;
CREATE TABLE `log_chat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型1世界，2公会',
  `content` longtext NOT NULL COMMENT '内容',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `vip` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'vip',
  `tokey` int(11) DEFAULT '0' COMMENT '目标key',
  `toname` varchar(50) DEFAULT '[]' COMMENT '目标昵称',
  `tolv` int(11) NOT NULL DEFAULT '0' COMMENT '目标等级',
  `tovip` tinyint(4) NOT NULL DEFAULT '0' COMMENT '目标vip',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `ts` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=750 DEFAULT CHARSET=utf8 COMMENT='聊天记录';

-- ----------------------------
--  Table structure for `log_cmd`
-- ----------------------------
DROP TABLE IF EXISTS `log_cmd`;
CREATE TABLE `log_cmd` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `nickname` varchar(100) NOT NULL DEFAULT '""',
  `sn` int(10) NOT NULL DEFAULT '0',
  `name` varchar(100) NOT NULL DEFAULT '""' COMMENT '功能名',
  `cmd` int(10) NOT NULL DEFAULT '0' COMMENT '协议号',
  `cmd_num` int(10) NOT NULL DEFAULT '0' COMMENT '协议刷新次数',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `key2` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='协议监控';

-- ----------------------------
--  Table structure for `log_coin`
-- ----------------------------
DROP TABLE IF EXISTS `log_coin`;
CREATE TABLE `log_coin` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家ID',
  `oldcoin` int(11) NOT NULL DEFAULT '0' COMMENT '原来铜币数',
  `newcoin` int(11) NOT NULL DEFAULT '0' COMMENT '新铜币数',
  `addcoin` int(11) NOT NULL DEFAULT '0' COMMENT '修改铜币数(负数代表扣减)',
  `addreason` int(11) NOT NULL DEFAULT '0' COMMENT '修改原因',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `game_id` int(11) NOT NULL DEFAULT '0' COMMENT '游戏id',
  `channel_id` int(11) NOT NULL DEFAULT '0' COMMENT '平台id',
  `game_channel_id` int(11) NOT NULL DEFAULT '0' COMMENT '包体id',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '物品id',
  `goods_num` int(11) NOT NULL DEFAULT '0' COMMENT '物品数量',
  `desc` varchar(500) NOT NULL DEFAULT '' COMMENT '消耗描述',
  `sn` int(11) NOT NULL DEFAULT '0' COMMENT '服务器号',
  `acc_name` varchar(100) NOT NULL DEFAULT '' COMMENT '账号',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `time` (`time`),
  KEY `addreason` (`addreason`)
) ENGINE=InnoDB AUTO_INCREMENT=13240 DEFAULT CHARSET=utf8 COMMENT='铜币修改日志';

-- ----------------------------
--  Table structure for `log_combatpower_rank`
-- ----------------------------
DROP TABLE IF EXISTS `log_combatpower_rank`;
CREATE TABLE `log_combatpower_rank` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` char(22) DEFAULT '0' COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家昵称',
  `combatpower` int(10) DEFAULT '0' COMMENT '战斗力',
  `rank` int(10) DEFAULT '0' COMMENT '排行',
  `time` int(10) DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `name` (`nickname`) USING BTREE,
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='战力排行榜日志';

-- ----------------------------
--  Table structure for `log_consume_back_charge`
-- ----------------------------
DROP TABLE IF EXISTS `log_consume_back_charge`;
CREATE TABLE `log_consume_back_charge` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `charge_gold` int(10) NOT NULL DEFAULT '0',
  `percent` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消费抽返利充值';

-- ----------------------------
--  Table structure for `log_consume_back_charge_draw`
-- ----------------------------
DROP TABLE IF EXISTS `log_consume_back_charge_draw`;
CREATE TABLE `log_consume_back_charge_draw` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `charge_gold` int(10) NOT NULL DEFAULT '0',
  `percent` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COMMENT='消费抽返利抽奖';

-- ----------------------------
--  Table structure for `log_convoy`
-- ----------------------------
DROP TABLE IF EXISTS `log_convoy`;
CREATE TABLE `log_convoy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家KEY',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `color` tinyint(1) NOT NULL DEFAULT '0' COMMENT '护送颜色',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8 COMMENT='护送日志';

-- ----------------------------
--  Table structure for `log_cross_1vn_bet`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_1vn_bet`;
CREATE TABLE `log_cross_1vn_bet` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `group` int(11) NOT NULL DEFAULT '0' COMMENT '分组',
  `floor` int(11) NOT NULL DEFAULT '0' COMMENT '轮次',
  `cost` int(11) NOT NULL DEFAULT '0' COMMENT '消耗',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '1输 2赢',
  `type1` int(11) NOT NULL DEFAULT '0' COMMENT '1中场 2擂主',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COMMENT='玩家投注日志';

-- ----------------------------
--  Table structure for `log_cross_1vn_match`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_1vn_match`;
CREATE TABLE `log_cross_1vn_match` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `floor` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `node` varchar(256) NOT NULL DEFAULT '[]' COMMENT '区域节点名',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `list` text NOT NULL COMMENT '匹配列表',
  PRIMARY KEY (`id`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8 COMMENT='跨服1vn匹配';

-- ----------------------------
--  Table structure for `log_cross_1vn_shop`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_1vn_shop`;
CREATE TABLE `log_cross_1vn_shop` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家key',
  `type` int(11) DEFAULT '0' COMMENT '类型 0挑战 1擂主',
  `cid` int(11) DEFAULT '0' COMMENT '子id',
  `cost` int(11) DEFAULT '0' COMMENT '消耗',
  `goods_id` int(11) DEFAULT '0' COMMENT '物品id',
  `goods_num` int(11) DEFAULT '0' COMMENT '物品数量',
  `time` int(11) DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服1vn商城';

-- ----------------------------
--  Table structure for `log_cross_act_well_draw`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_act_well_draw`;
CREATE TABLE `log_cross_act_well_draw` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '0' COMMENT '玩家名称',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型 1金币 2元宝',
  `gold_cost` int(11) NOT NULL DEFAULT '0' COMMENT '消耗元宝',
  `coin_cost` int(11) NOT NULL DEFAULT '0' COMMENT '消耗活动金币',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '积分',
  `goods_list` varchar(150) NOT NULL DEFAULT '0' COMMENT '物品列表',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=19421 DEFAULT CHARSET=utf8 COMMENT='跨服许愿池抽奖';

-- ----------------------------
--  Table structure for `log_cross_act_well_final`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_act_well_final`;
CREATE TABLE `log_cross_act_well_final` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '0' COMMENT '玩家名称',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '排名',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '积分',
  `sn` int(11) NOT NULL DEFAULT '0' COMMENT '服号',
  `sn_group` int(11) NOT NULL DEFAULT '0' COMMENT '分组',
  `goods_list` varchar(150) NOT NULL DEFAULT '0' COMMENT '物品列表',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='跨服许愿池结算';

-- ----------------------------
--  Table structure for `log_cross_battlefield`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_battlefield`;
CREATE TABLE `log_cross_battlefield` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `score` int(11) NOT NULL COMMENT '积分',
  `rank` int(11) NOT NULL COMMENT '排名',
  `goods` text NOT NULL COMMENT '奖励',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服战场日志';

-- ----------------------------
--  Table structure for `log_cross_boss`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_boss`;
CREATE TABLE `log_cross_boss` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `rank` int(11) NOT NULL COMMENT '排名',
  `damage` int(11) NOT NULL COMMENT '伤害',
  `goods` text NOT NULL COMMENT '物品奖励',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服boss日志';

-- ----------------------------
--  Table structure for `log_cross_boss_drop`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_boss_drop`;
CREATE TABLE `log_cross_boss_drop` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `goods_num` int(10) NOT NULL DEFAULT '0',
  `mon_id` int(10) NOT NULL DEFAULT '0',
  `mon_desc` varchar(50) NOT NULL DEFAULT '""',
  `layer` int(1) NOT NULL DEFAULT '0' COMMENT '层数',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COMMENT='跨服boss掉落拾取';

-- ----------------------------
--  Table structure for `log_cross_boss_has`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_boss_has`;
CREATE TABLE `log_cross_boss_has` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `mon_id` int(10) NOT NULL DEFAULT '0',
  `mon_desc` varchar(50) NOT NULL DEFAULT '""',
  `layer` int(1) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COMMENT='跨服boss掉落归属';

-- ----------------------------
--  Table structure for `log_cross_consume_rank_final`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_consume_rank_final`;
CREATE TABLE `log_cross_consume_rank_final` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '昵称',
  `sn` int(11) NOT NULL DEFAULT '0' COMMENT '服号',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '最终排名',
  `value` int(11) NOT NULL DEFAULT '0' COMMENT '价值',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COMMENT='跨服消费榜日志';

-- ----------------------------
--  Table structure for `log_cross_dun`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_dun`;
CREATE TABLE `log_cross_dun` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(100) NOT NULL DEFAULT '' COMMENT '昵称',
  `dun_id` int(11) NOT NULL COMMENT '副本id',
  `goods_list` text NOT NULL COMMENT '奖励列表',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服副本日志';

-- ----------------------------
--  Table structure for `log_cross_dungeon_guard`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_dungeon_guard`;
CREATE TABLE `log_cross_dungeon_guard` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) NOT NULL COMMENT '玩家ID',
  `nickname` varchar(50) NOT NULL COMMENT '玩家名字',
  `dun_id` int(11) DEFAULT '0' COMMENT '副本id',
  `floor` int(11) DEFAULT '0' COMMENT '副本层数',
  `use_time` int(11) DEFAULT '0' COMMENT '使用时间',
  `time` int(11) DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8 COMMENT='跨服试炼日志';

-- ----------------------------
--  Table structure for `log_cross_elite`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_elite`;
CREATE TABLE `log_cross_elite` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `lv` int(11) NOT NULL COMMENT '当前段位',
  `exp` int(11) NOT NULL COMMENT '当前经验',
  `ret` int(11) NOT NULL COMMENT '挑战结果',
  `score` int(11) NOT NULL COMMENT '获得积分',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8 COMMENT='跨服精英日志';

-- ----------------------------
--  Table structure for `log_cross_flower_rank_final`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_flower_rank_final`;
CREATE TABLE `log_cross_flower_rank_final` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '昵称',
  `sn` int(11) NOT NULL DEFAULT '0' COMMENT '服号',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '最终排名',
  `log_rank` int(11) NOT NULL DEFAULT '0' COMMENT '日志排名',
  `value` int(11) NOT NULL DEFAULT '0' COMMENT '花价值',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型 1送花 2收花',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='跨服鲜花榜日志';

-- ----------------------------
--  Table structure for `log_cross_fruit`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_fruit`;
CREATE TABLE `log_cross_fruit` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家昵称',
  `sn` int(10) DEFAULT '0' COMMENT '服号',
  `rank` int(10) DEFAULT '0' COMMENT '排名',
  `win_times` int(10) DEFAULT '0' COMMENT '胜利次数',
  `time` int(10) DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `name` (`nickname`) USING BTREE,
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服水果大作战周排名日志';

-- ----------------------------
--  Table structure for `log_cross_mine_att`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_mine_att`;
CREATE TABLE `log_cross_mine_att` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `att_key` int(11) NOT NULL COMMENT '攻击者key',
  `def_key` int(11) NOT NULL COMMENT '被攻击key',
  `att_type` int(11) NOT NULL COMMENT '1成功 5成功未占领 6收货期成功 0失败',
  `location_type` int(11) NOT NULL COMMENT '矿洞类型',
  `location_page` int(11) NOT NULL COMMENT '分页',
  `location_id` int(11) NOT NULL COMMENT '编号id',
  `old_hp` int(11) NOT NULL COMMENT '原本hp',
  `new_hp` int(11) NOT NULL COMMENT '进攻后hp',
  `is_hit` int(11) NOT NULL COMMENT '是否成熟期',
  `reward` varchar(150) NOT NULL DEFAULT '[]' COMMENT '物品列表',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `att_key` (`att_key`) USING BTREE,
  KEY `att_type` (`att_type`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=419 DEFAULT CHARSET=utf8 COMMENT='矿洞玩家进攻日志';

-- ----------------------------
--  Table structure for `log_cross_mine_get_mine_reward`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_mine_get_mine_reward`;
CREATE TABLE `log_cross_mine_get_mine_reward` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT 'key',
  `event_type` int(11) NOT NULL COMMENT '1主动收获 2奇遇奖励 3成熟邮件 4进攻小偷',
  `is_hit` int(11) NOT NULL COMMENT '成熟期是否被攻击',
  `location_type` int(11) NOT NULL COMMENT '矿洞类型',
  `location_page` int(11) NOT NULL COMMENT '分页',
  `location_id` int(11) NOT NULL COMMENT '编号id',
  `reward` varchar(150) NOT NULL DEFAULT '[]' COMMENT '物品列表',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=363 DEFAULT CHARSET=utf8 COMMENT='矿洞玩家进攻日志';

-- ----------------------------
--  Table structure for `log_cross_recharge_rank_final`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_recharge_rank_final`;
CREATE TABLE `log_cross_recharge_rank_final` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '昵称',
  `sn` int(11) NOT NULL DEFAULT '0' COMMENT '服号',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '最终排名',
  `value` int(11) NOT NULL DEFAULT '0' COMMENT '花价值',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 COMMENT='跨服充值榜日志';

-- ----------------------------
--  Table structure for `log_cross_six_dragon`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_six_dragon`;
CREATE TABLE `log_cross_six_dragon` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `sn` int(11) DEFAULT '0' COMMENT '服号',
  `goods` text COMMENT '物品',
  `rank` int(16) DEFAULT '0' COMMENT '排名',
  `point` int(10) DEFAULT '0' COMMENT '积分',
  `time` int(10) DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='全跨服六龙争霸排名奖励日记';

-- ----------------------------
--  Table structure for `log_cross_six_dragon_one_fight`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_six_dragon_one_fight`;
CREATE TABLE `log_cross_six_dragon_one_fight` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `sn` int(11) DEFAULT '0' COMMENT '玩家服号',
  `goods` text COMMENT '物品',
  `fight_times` int(16) DEFAULT '0' COMMENT '战斗次数',
  `point` int(10) DEFAULT '0' COMMENT '积分',
  `time` int(10) DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='六龙争霸玩家单次通关';

-- ----------------------------
--  Table structure for `log_cross_war`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_war`;
CREATE TABLE `log_cross_war` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `goods` text NOT NULL COMMENT '物品列表',
  `ret` tinyint(1) NOT NULL DEFAULT '0' COMMENT '结果',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '参战类型1防守，2进攻，3支援防守，4支援进攻',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='城战个人奖励日志';

-- ----------------------------
--  Table structure for `log_cross_war_daily`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_war_daily`;
CREATE TABLE `log_cross_war_daily` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `type` int(10) NOT NULL DEFAULT '0',
  `recv_list` varchar(200) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE,
  KEY `pkey` (`pkey`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='攻城战每日奖励';

-- ----------------------------
--  Table structure for `log_cross_war_enter`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_war_enter`;
CREATE TABLE `log_cross_war_enter` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `sign` int(1) NOT NULL DEFAULT '0' COMMENT '阵营方',
  `time` int(10) NOT NULL DEFAULT '0' COMMENT '进入战场时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='攻城战参战日志';

-- ----------------------------
--  Table structure for `log_cross_war_reward`
-- ----------------------------
DROP TABLE IF EXISTS `log_cross_war_reward`;
CREATE TABLE `log_cross_war_reward` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `title` varchar(200) NOT NULL DEFAULT '[]',
  `content` varchar(200) NOT NULL DEFAULT '[]',
  `reward` varchar(200) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=193 DEFAULT CHARSET=utf8 COMMENT='攻城战奖励日志';

-- ----------------------------
--  Table structure for `log_cs_charge_d`
-- ----------------------------
DROP TABLE IF EXISTS `log_cs_charge_d`;
CREATE TABLE `log_cs_charge_d` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `recv_list` varchar(200) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='财神单笔充值';

-- ----------------------------
--  Table structure for `log_daily_charge`
-- ----------------------------
DROP TABLE IF EXISTS `log_daily_charge`;
CREATE TABLE `log_daily_charge` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家昵称',
  `goods_id` int(10) DEFAULT '0' COMMENT '物品id',
  `time` int(10) DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家每日充值抽奖日志';

-- ----------------------------
--  Table structure for `log_decoration`
-- ----------------------------
DROP TABLE IF EXISTS `log_decoration`;
CREATE TABLE `log_decoration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `type` tinyint(1) NOT NULL COMMENT '类型1激活2升级3过期',
  `decoration_id` int(11) NOT NULL COMMENT '挂饰id',
  `stage` tinyint(1) NOT NULL COMMENT '阶数',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=565 DEFAULT CHARSET=utf8 COMMENT='挂饰日志';

-- ----------------------------
--  Table structure for `log_designation`
-- ----------------------------
DROP TABLE IF EXISTS `log_designation`;
CREATE TABLE `log_designation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `type` tinyint(1) NOT NULL COMMENT '类型1激活2升级3过期',
  `designation_id` int(11) NOT NULL COMMENT '称号id',
  `stage` tinyint(1) NOT NULL COMMENT '阶数',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=1867 DEFAULT CHARSET=utf8 COMMENT='称号日志';

-- ----------------------------
--  Table structure for `log_dun_element`
-- ----------------------------
DROP TABLE IF EXISTS `log_dun_element`;
CREATE TABLE `log_dun_element` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `dun_id` int(10) NOT NULL DEFAULT '0',
  `result` int(10) NOT NULL DEFAULT '0',
  `reward` varchar(100) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `log_dun_jiandao`
-- ----------------------------
DROP TABLE IF EXISTS `log_dun_jiandao`;
CREATE TABLE `log_dun_jiandao` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL,
  `dun_id` int(10) NOT NULL,
  `score` int(10) NOT NULL,
  `reward` varchar(100) NOT NULL,
  `time` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `log_dun_marry`
-- ----------------------------
DROP TABLE IF EXISTS `log_dun_marry`;
CREATE TABLE `log_dun_marry` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `problem_id` int(10) NOT NULL DEFAULT '0',
  `result` varchar(200) NOT NULL DEFAULT '[]',
  `problem_reward` varchar(200) NOT NULL DEFAULT '[]',
  `collect_num` int(10) NOT NULL DEFAULT '0',
  `collect_reward` varchar(200) NOT NULL DEFAULT '[]',
  `pass_reward` varchar(200) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='爱情试炼副本';

-- ----------------------------
--  Table structure for `log_dungeon`
-- ----------------------------
DROP TABLE IF EXISTS `log_dungeon`;
CREATE TABLE `log_dungeon` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `dun_id` int(11) NOT NULL DEFAULT '0' COMMENT '副本ID',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '副本类型',
  `open_time` int(11) NOT NULL DEFAULT '0' COMMENT '开启时间',
  `is_pass` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否通关（1通关，0否）',
  `reward` text NOT NULL COMMENT '奖励',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `dun_id` (`dun_id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=2631 DEFAULT CHARSET=utf8 COMMENT='副本日志';

-- ----------------------------
--  Table structure for `log_dungeon_pass_info`
-- ----------------------------
DROP TABLE IF EXISTS `log_dungeon_pass_info`;
CREATE TABLE `log_dungeon_pass_info` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `pkey` int(10) NOT NULL DEFAULT '0',
  `nickname` varchar(50) NOT NULL DEFAULT '""',
  `cbp` int(10) NOT NULL DEFAULT '0' COMMENT '玩家战力',
  `dungeon_id` int(10) NOT NULL DEFAULT '0' COMMENT '副本ID',
  `dungeon_type` int(10) DEFAULT '0' COMMENT '副本类型',
  `dungeon_desc` varchar(50) DEFAULT '""' COMMENT '副本描述',
  `layer` int(10) DEFAULT '0' COMMENT '大层',
  `layer_desc` varchar(50) DEFAULT '""' COMMENT '大层描述',
  `sub_layer` int(10) DEFAULT '0' COMMENT '子层',
  `time` int(10) NOT NULL DEFAULT '0' COMMENT '通关时间',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=650 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='副本通关日志';

-- ----------------------------
--  Table structure for `log_dvip_ex_gold`
-- ----------------------------
DROP TABLE IF EXISTS `log_dvip_ex_gold`;
CREATE TABLE `log_dvip_ex_gold` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT NULL COMMENT '玩家ID',
  `bgold` int(11) DEFAULT NULL COMMENT '绑定元宝',
  `gold` int(11) DEFAULT NULL COMMENT '非绑定元宝',
  `cnt` smallint(11) DEFAULT NULL COMMENT '兑换次数',
  `time` int(11) DEFAULT NULL COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='玩家钻石vip 钻石兑换日志';

-- ----------------------------
--  Table structure for `log_dvip_ex_market`
-- ----------------------------
DROP TABLE IF EXISTS `log_dvip_ex_market`;
CREATE TABLE `log_dvip_ex_market` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `index` tinyint(2) DEFAULT '0' COMMENT '兑换下标',
  `cnt` smallint(11) DEFAULT '0' COMMENT '兑换次数',
  `costtype` tinyint(2) DEFAULT '0' COMMENT '(兑换消耗类型,1银币，2元宝，3绑定元宝,4钻石)',
  `cost` int(11) DEFAULT '0' COMMENT '消耗数量',
  `goods_list` text COMMENT '兑换的物品列表',
  `time` int(11) DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`)
) ENGINE=InnoDB AUTO_INCREMENT=286 DEFAULT CHARSET=utf8 COMMENT='玩家钻石vip 商城兑换日志';

-- ----------------------------
--  Table structure for `log_dvip_ex_step`
-- ----------------------------
DROP TABLE IF EXISTS `log_dvip_ex_step`;
CREATE TABLE `log_dvip_ex_step` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `index` tinyint(2) DEFAULT '0' COMMENT '下表ID',
  `cnt` smallint(4) DEFAULT '0' COMMENT '兑换次数',
  `cost_gold` int(11) DEFAULT NULL COMMENT '消耗元宝',
  `del_goods` text COMMENT '删除的物品列表',
  `give_goods` text COMMENT '给予的物品列表',
  `time` int(11) DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='玩家钻石vip 进阶丹兑换日志';

-- ----------------------------
--  Table structure for `log_dvip_player`
-- ----------------------------
DROP TABLE IF EXISTS `log_dvip_player`;
CREATE TABLE `log_dvip_player` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `vip_type` tinyint(1) DEFAULT '0' COMMENT 'vip类型',
  `time` int(11) DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8 COMMENT='玩家钻石vip日志';

-- ----------------------------
--  Table structure for `log_element_up_e_lv`
-- ----------------------------
DROP TABLE IF EXISTS `log_element_up_e_lv`;
CREATE TABLE `log_element_up_e_lv` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `race` int(1) NOT NULL DEFAULT '0',
  `e_lv` int(10) NOT NULL DEFAULT '0',
  `cost` varchar(50) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=823 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `log_element_up_lv`
-- ----------------------------
DROP TABLE IF EXISTS `log_element_up_lv`;
CREATE TABLE `log_element_up_lv` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `lv` int(10) NOT NULL DEFAULT '0',
  `race` int(10) NOT NULL DEFAULT '0',
  `cost` varchar(100) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `log_element_up_stage`
-- ----------------------------
DROP TABLE IF EXISTS `log_element_up_stage`;
CREATE TABLE `log_element_up_stage` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `race` int(10) NOT NULL DEFAULT '0',
  `stage` int(10) NOT NULL DEFAULT '0',
  `cost` varchar(50) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `log_element_wear`
-- ----------------------------
DROP TABLE IF EXISTS `log_element_wear`;
CREATE TABLE `log_element_wear` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `race` int(10) NOT NULL DEFAULT '0',
  `new_pos` int(10) NOT NULL DEFAULT '0',
  `old_pos` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `log_elite_boss_back`
-- ----------------------------
DROP TABLE IF EXISTS `log_elite_boss_back`;
CREATE TABLE `log_elite_boss_back` (
  `id` int(10) NOT NULL DEFAULT '0',
  `pkey` int(10) NOT NULL DEFAULT '0',
  `scene_id` int(10) NOT NULL DEFAULT '0',
  `back_list` varchar(100) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='精英boss返还';

-- ----------------------------
--  Table structure for `log_elite_boss_dun_reward`
-- ----------------------------
DROP TABLE IF EXISTS `log_elite_boss_dun_reward`;
CREATE TABLE `log_elite_boss_dun_reward` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `dun_id` int(10) NOT NULL DEFAULT '0',
  `reward` varchar(100) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8 COMMENT='精英bossVIP副本奖励';

-- ----------------------------
--  Table structure for `log_elite_boss_enter`
-- ----------------------------
DROP TABLE IF EXISTS `log_elite_boss_enter`;
CREATE TABLE `log_elite_boss_enter` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `scene_id` int(10) NOT NULL DEFAULT '0',
  `consume` varchar(100) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=301 DEFAULT CHARSET=utf8 COMMENT='精英boss进入';

-- ----------------------------
--  Table structure for `log_elite_boss_rank`
-- ----------------------------
DROP TABLE IF EXISTS `log_elite_boss_rank`;
CREATE TABLE `log_elite_boss_rank` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `scene_id` int(10) NOT NULL DEFAULT '0',
  `reward` varchar(100) NOT NULL DEFAULT '[]',
  `rank` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=208 DEFAULT CHARSET=utf8 COMMENT='精英boss排名';

-- ----------------------------
--  Table structure for `log_elite_dun_enter`
-- ----------------------------
DROP TABLE IF EXISTS `log_elite_dun_enter`;
CREATE TABLE `log_elite_dun_enter` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `dun_id` int(10) NOT NULL DEFAULT '0',
  `cost_gold` int(10) NOT NULL DEFAULT '0',
  `consume` varchar(100) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8 COMMENT='精英boss副本进入';

-- ----------------------------
--  Table structure for `log_equip_god_forging`
-- ----------------------------
DROP TABLE IF EXISTS `log_equip_god_forging`;
CREATE TABLE `log_equip_god_forging` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '玩家名字',
  `goods_id` int(1) NOT NULL DEFAULT '0' COMMENT '物品id',
  `result` int(1) NOT NULL DEFAULT '0' COMMENT '结果',
  `befor_lv` int(1) NOT NULL DEFAULT '0' COMMENT '之前等级',
  `after_lv` int(1) NOT NULL DEFAULT '0' COMMENT '之后等级',
  `cost_goods` int(1) NOT NULL DEFAULT '0' COMMENT '扣除物品',
  `goods_num` int(1) NOT NULL DEFAULT '0' COMMENT '扣除物品数量',
  `time` int(1) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `pname` (`nickname`) USING BTREE,
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='装备神炼日志表';

-- ----------------------------
--  Table structure for `log_equip_inlay`
-- ----------------------------
DROP TABLE IF EXISTS `log_equip_inlay`;
CREATE TABLE `log_equip_inlay` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '玩家名字',
  `type` int(1) NOT NULL DEFAULT '0' COMMENT '1.镶嵌 2拆除 3升级 4.开孔',
  `gem_goods_id` int(1) NOT NULL DEFAULT '0' COMMENT '物品id',
  `gem_num` int(1) NOT NULL DEFAULT '0' COMMENT '宝石数量',
  `goods_id` int(1) NOT NULL DEFAULT '0' COMMENT '物品id',
  `befor_attr` varchar(200) NOT NULL DEFAULT '',
  `after_attr` varchar(200) NOT NULL,
  `cost_money` varchar(50) NOT NULL DEFAULT '' COMMENT '消耗钱的数量',
  `time` int(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `pname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=872 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='宝石镶嵌表';

-- ----------------------------
--  Table structure for `log_equip_level_up`
-- ----------------------------
DROP TABLE IF EXISTS `log_equip_level_up`;
CREATE TABLE `log_equip_level_up` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '玩家名字',
  `gkey` bigint(22) NOT NULL COMMENT '物品key',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '所升级物品id',
  `cost_goods` int(11) NOT NULL DEFAULT '0' COMMENT '消耗物品id',
  `coin` int(11) NOT NULL DEFAULT '0' COMMENT '货币',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间',
  `subtype` int(11) NOT NULL DEFAULT '0' COMMENT '部位',
  `before_level` int(11) NOT NULL DEFAULT '0' COMMENT '之前等级',
  `after_level` int(11) NOT NULL DEFAULT '0' COMMENT '之后等级',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `pname` (`nickname`) USING BTREE,
  KEY `gkey` (`gkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=910 DEFAULT CHARSET=utf8 COMMENT='装备等级提升日志';

-- ----------------------------
--  Table structure for `log_equip_part`
-- ----------------------------
DROP TABLE IF EXISTS `log_equip_part`;
CREATE TABLE `log_equip_part` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `old_pt` int(11) NOT NULL DEFAULT '0' COMMENT '旧值',
  `new_pt` int(11) NOT NULL DEFAULT '0' COMMENT '新值',
  `change_pt` int(11) NOT NULL DEFAULT '0' COMMENT '变化值',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1056 DEFAULT CHARSET=utf8 COMMENT='装备碎片日志';

-- ----------------------------
--  Table structure for `log_equip_rank`
-- ----------------------------
DROP TABLE IF EXISTS `log_equip_rank`;
CREATE TABLE `log_equip_rank` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` char(22) DEFAULT '0' COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家昵称',
  `equip_name` varchar(50) DEFAULT NULL COMMENT '装备名称',
  `equip_combatpower` int(10) DEFAULT '0' COMMENT '战斗力',
  `rank` int(10) DEFAULT '0' COMMENT '排行',
  `time` int(10) DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `name` (`nickname`) USING BTREE,
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='装备排行榜日志';

-- ----------------------------
--  Table structure for `log_equip_refine`
-- ----------------------------
DROP TABLE IF EXISTS `log_equip_refine`;
CREATE TABLE `log_equip_refine` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自动递增',
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '玩家名字',
  `subtype` int(1) NOT NULL DEFAULT '0' COMMENT '精炼部位',
  `refine_before` int(1) NOT NULL DEFAULT '0' COMMENT '精炼前等级',
  `refine_after` int(1) NOT NULL DEFAULT '0' COMMENT '精炼后等级',
  `cost_goods_id` int(1) NOT NULL DEFAULT '0' COMMENT '扣除物品id',
  `time` int(1) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `pname` (`nickname`) USING BTREE,
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=1965 DEFAULT CHARSET=utf8 COMMENT='装备精练日志';

-- ----------------------------
--  Table structure for `log_equip_shop`
-- ----------------------------
DROP TABLE IF EXISTS `log_equip_shop`;
CREATE TABLE `log_equip_shop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '0' COMMENT '玩家名称',
  `cost` int(11) NOT NULL DEFAULT '0' COMMENT '消耗',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '物品id',
  `goods_num` int(11) NOT NULL DEFAULT '0' COMMENT '物品数量',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=291 DEFAULT CHARSET=utf8 COMMENT='碎片商店日志';

-- ----------------------------
--  Table structure for `log_equip_smelt`
-- ----------------------------
DROP TABLE IF EXISTS `log_equip_smelt`;
CREATE TABLE `log_equip_smelt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '玩家名字',
  `result` int(1) NOT NULL DEFAULT '0' COMMENT '0.失败 1.成功 2.最高品质物品熔炼化为荣炼值',
  `goods_id1` int(1) NOT NULL DEFAULT '0' COMMENT '物品2',
  `goods_id2` int(1) NOT NULL DEFAULT '0' COMMENT '物品3',
  `goods_id3` int(1) NOT NULL DEFAULT '0' COMMENT '物品3',
  `goods_id4` int(1) NOT NULL DEFAULT '0' COMMENT '物品4',
  `goods_id5` int(1) NOT NULL DEFAULT '0' COMMENT '物品5',
  `color` int(1) NOT NULL DEFAULT '0' COMMENT '颜色',
  `lv` int(1) NOT NULL DEFAULT '0' COMMENT '等级',
  `get_goods_id` int(1) NOT NULL DEFAULT '0' COMMENT '获得的物品',
  `get_num` int(1) NOT NULL DEFAULT '0' COMMENT '数量',
  `time` int(1) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `pname` (`nickname`) USING BTREE,
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='装备熔炼表';

-- ----------------------------
--  Table structure for `log_equip_soul_op`
-- ----------------------------
DROP TABLE IF EXISTS `log_equip_soul_op`;
CREATE TABLE `log_equip_soul_op` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL,
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `old_goods` int(11) NOT NULL DEFAULT '0' COMMENT '旧武魂id',
  `new_goods` int(11) NOT NULL DEFAULT '0' COMMENT '新武魂id',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=513 DEFAULT CHARSET=utf8 COMMENT='武魂操作日志';

-- ----------------------------
--  Table structure for `log_equip_soul_up`
-- ----------------------------
DROP TABLE IF EXISTS `log_equip_soul_up`;
CREATE TABLE `log_equip_soul_up` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL,
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `cost_goods` int(11) NOT NULL DEFAULT '0' COMMENT '消耗武魂',
  `cost_num` int(11) NOT NULL DEFAULT '0' COMMENT '消耗数量',
  `get_goods` int(11) NOT NULL DEFAULT '0' COMMENT '获得武魂',
  `get_num` int(11) NOT NULL DEFAULT '0' COMMENT '获得数量',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=680 DEFAULT CHARSET=utf8 COMMENT='武魂升级日志';

-- ----------------------------
--  Table structure for `log_equip_streng`
-- ----------------------------
DROP TABLE IF EXISTS `log_equip_streng`;
CREATE TABLE `log_equip_streng` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '玩家名字',
  `goods_id` int(1) NOT NULL DEFAULT '0' COMMENT '物品id',
  `result` int(1) NOT NULL DEFAULT '0' COMMENT '结果',
  `befor_lv` int(1) NOT NULL DEFAULT '0' COMMENT '之前等级',
  `after_lv` int(1) NOT NULL DEFAULT '0' COMMENT '之后等级',
  `cost_coin` int(1) NOT NULL DEFAULT '0' COMMENT '扣除金钱',
  `cost_goods` int(1) NOT NULL DEFAULT '0' COMMENT '扣除物品',
  `time` int(1) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `pname` (`nickname`) USING BTREE,
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=1363 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='装备强化日志表';

-- ----------------------------
--  Table structure for `log_equip_upgrade`
-- ----------------------------
DROP TABLE IF EXISTS `log_equip_upgrade`;
CREATE TABLE `log_equip_upgrade` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '玩家名字',
  `gkey` bigint(22) NOT NULL COMMENT '物品key',
  `goods_id` int(1) NOT NULL DEFAULT '0' COMMENT '物品id',
  `after_goods_id` int(1) NOT NULL DEFAULT '0' COMMENT '升级后物品id',
  `cost_money` int(1) NOT NULL DEFAULT '0' COMMENT '所消耗的钱',
  `cost_goods` varchar(200) NOT NULL DEFAULT '' COMMENT '消耗的物品',
  `time` int(1) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `pname` (`nickname`) USING BTREE,
  KEY `gkey` (`gkey`) USING BTREE,
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=666 DEFAULT CHARSET=utf8 COMMENT='装备升级日志';

-- ----------------------------
--  Table structure for `log_equip_wash`
-- ----------------------------
DROP TABLE IF EXISTS `log_equip_wash`;
CREATE TABLE `log_equip_wash` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '玩家名字',
  `type` int(1) NOT NULL DEFAULT '0' COMMENT '1洗练 2洗练替换',
  `gkey` char(22) NOT NULL DEFAULT '' COMMENT '物品key',
  `goods_id` int(1) NOT NULL DEFAULT '0' COMMENT '物品id',
  `befor_attr` varchar(200) NOT NULL DEFAULT '' COMMENT '洗练前',
  `after_attr` varchar(200) NOT NULL DEFAULT '' COMMENT '洗练后',
  `lock_pos` varchar(50) NOT NULL DEFAULT '' COMMENT '锁信息',
  `time` int(1) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `pname` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE,
  KEY `gkey` (`gkey`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=830 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='装备洗练日志表';

-- ----------------------------
--  Table structure for `log_exp_rank`
-- ----------------------------
DROP TABLE IF EXISTS `log_exp_rank`;
CREATE TABLE `log_exp_rank` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家昵称',
  `lv` int(10) DEFAULT '0' COMMENT '等级',
  `rank` int(10) DEFAULT '0' COMMENT '排行',
  `time` int(10) DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `name` (`nickname`) USING BTREE,
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='等级排行榜日志';

-- ----------------------------
--  Table structure for `log_fairy_soul`
-- ----------------------------
DROP TABLE IF EXISTS `log_fairy_soul`;
CREATE TABLE `log_fairy_soul` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT NULL COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家名字',
  `gold` int(11) DEFAULT NULL COMMENT '消耗元宝',
  `time` int(11) DEFAULT '0' COMMENT '领取时间',
  `goods_list` text COMMENT '物品列表',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=13710 DEFAULT CHARSET=utf8 COMMENT='仙魂猎魂日志';

-- ----------------------------
--  Table structure for `log_fairy_soul_resolved`
-- ----------------------------
DROP TABLE IF EXISTS `log_fairy_soul_resolved`;
CREATE TABLE `log_fairy_soul_resolved` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT NULL COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家名字',
  `exp` int(11) DEFAULT NULL COMMENT '获得经验',
  `goods_key` bigint(20) DEFAULT NULL COMMENT '物品key',
  `goods_id` int(11) DEFAULT NULL COMMENT '物品id',
  `time` int(11) DEFAULT '0' COMMENT '领取时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=1609 DEFAULT CHARSET=utf8 COMMENT='仙魂分解日志';

-- ----------------------------
--  Table structure for `log_fairy_soul_upgrade`
-- ----------------------------
DROP TABLE IF EXISTS `log_fairy_soul_upgrade`;
CREATE TABLE `log_fairy_soul_upgrade` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT NULL COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家名字',
  `exp` int(11) DEFAULT NULL COMMENT '消耗经验',
  `old_lv` int(11) DEFAULT NULL COMMENT '升级前等级',
  `new_lv` int(11) DEFAULT NULL COMMENT '升级后等级',
  `goods_key` bigint(20) DEFAULT NULL COMMENT '物品key',
  `goods_id` int(11) DEFAULT NULL COMMENT '物品id',
  `time` int(11) DEFAULT '0' COMMENT '领取时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8 COMMENT='仙魂升级日志';

-- ----------------------------
--  Table structure for `log_fashion`
-- ----------------------------
DROP TABLE IF EXISTS `log_fashion`;
CREATE TABLE `log_fashion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `type` tinyint(1) NOT NULL COMMENT '类型1激活2升级3过期',
  `fashion_id` int(11) NOT NULL COMMENT '时装id',
  `stage` tinyint(1) NOT NULL COMMENT '阶数',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=1816 DEFAULT CHARSET=utf8 COMMENT='时装日志';

-- ----------------------------
--  Table structure for `log_fashion_suit`
-- ----------------------------
DROP TABLE IF EXISTS `log_fashion_suit`;
CREATE TABLE `log_fashion_suit` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `act_suit_id` int(11) DEFAULT '0' COMMENT '当前激活套装ID',
  `all_ids` varchar(400) DEFAULT '[]' COMMENT '身上所有套装ID列表',
  `time` int(11) DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8 COMMENT='玩家套装日志';

-- ----------------------------
--  Table structure for `log_festival_acc_charge`
-- ----------------------------
DROP TABLE IF EXISTS `log_festival_acc_charge`;
CREATE TABLE `log_festival_acc_charge` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `recv_list` varchar(200) NOT NULL DEFAULT '[]',
  `recv_charge_gold` int(10) NOT NULL DEFAULT '0' COMMENT '领取额度',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8 COMMENT='节日活动之累充有礼';

-- ----------------------------
--  Table structure for `log_festival_back_buy`
-- ----------------------------
DROP TABLE IF EXISTS `log_festival_back_buy`;
CREATE TABLE `log_festival_back_buy` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `goods_num` int(10) NOT NULL DEFAULT '0',
  `cost_gold` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8 COMMENT='节日活动之疯狂抢购';

-- ----------------------------
--  Table structure for `log_festival_challenge_cs`
-- ----------------------------
DROP TABLE IF EXISTS `log_festival_challenge_cs`;
CREATE TABLE `log_festival_challenge_cs` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `cost_goods_id` int(10) NOT NULL DEFAULT '0',
  `cost_goods_num` int(10) NOT NULL DEFAULT '0',
  `result` int(1) NOT NULL DEFAULT '0',
  `bgold` int(10) NOT NULL DEFAULT '0',
  `gold` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='节日活动之财神挑战';

-- ----------------------------
--  Table structure for `log_festival_exchange`
-- ----------------------------
DROP TABLE IF EXISTS `log_festival_exchange`;
CREATE TABLE `log_festival_exchange` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `consume` varchar(200) NOT NULL DEFAULT '[]',
  `get_list` varchar(200) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8 COMMENT='节日活动之道具兑换';

-- ----------------------------
--  Table structure for `log_festival_login_gift`
-- ----------------------------
DROP TABLE IF EXISTS `log_festival_login_gift`;
CREATE TABLE `log_festival_login_gift` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `day` int(10) NOT NULL DEFAULT '0',
  `recv_list` varchar(200) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8 COMMENT='节日活动之登陆有礼';

-- ----------------------------
--  Table structure for `log_festival_red_gift`
-- ----------------------------
DROP TABLE IF EXISTS `log_festival_red_gift`;
CREATE TABLE `log_festival_red_gift` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `gift_id` int(10) NOT NULL DEFAULT '0',
  `recv_list` varchar(200) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8 COMMENT='节日活动红包';

-- ----------------------------
--  Table structure for `log_field_boss`
-- ----------------------------
DROP TABLE IF EXISTS `log_field_boss`;
CREATE TABLE `log_field_boss` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家KEY',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `boss_id` int(11) NOT NULL DEFAULT '0' COMMENT 'bossID',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '排名',
  `reward` text NOT NULL COMMENT '奖励',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='野外boss记录';

-- ----------------------------
--  Table structure for `log_field_boss_rank`
-- ----------------------------
DROP TABLE IF EXISTS `log_field_boss_rank`;
CREATE TABLE `log_field_boss_rank` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `scene_id` int(11) NOT NULL COMMENT '场景id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `point` int(11) NOT NULL COMMENT '积分',
  `rank` int(11) NOT NULL COMMENT '排名',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `scene_id` (`scene_id`),
  KEY `pkey` (`pkey`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COMMENT='野外boss周积分排行';

-- ----------------------------
--  Table structure for `log_final_war`
-- ----------------------------
DROP TABLE IF EXISTS `log_final_war`;
CREATE TABLE `log_final_war` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wtkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '战队KEY',
  `wtname` varchar(50) NOT NULL DEFAULT '0' COMMENT '战队昵称',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '玩家name',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '积分',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '排名',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `wtkey` (`wtkey`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='乱斗精英赛决赛日志';

-- ----------------------------
--  Table structure for `log_findback_act_time`
-- ----------------------------
DROP TABLE IF EXISTS `log_findback_act_time`;
CREATE TABLE `log_findback_act_time` (
  `type` int(11) NOT NULL COMMENT '玩法类型',
  `last_open_time` int(11) NOT NULL COMMENT '最后开启时间',
  `args` text NOT NULL COMMENT '参数',
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='找回活动开启时间';

-- ----------------------------
--  Table structure for `log_flower_rank`
-- ----------------------------
DROP TABLE IF EXISTS `log_flower_rank`;
CREATE TABLE `log_flower_rank` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey1` int(11) NOT NULL DEFAULT '0' COMMENT '送花人key',
  `nickname1` varchar(150) NOT NULL DEFAULT '[]' COMMENT '送花人昵称',
  `pkey2` int(11) NOT NULL DEFAULT '0' COMMENT '收花人key',
  `nickname2` varchar(150) NOT NULL DEFAULT '[]' COMMENT '收花人昵称',
  `val` int(11) NOT NULL DEFAULT '0' COMMENT '送花价值',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey1` (`pkey1`),
  KEY `nickname1` (`nickname1`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8 COMMENT='送花日志表';

-- ----------------------------
--  Table structure for `log_flower_rank_final`
-- ----------------------------
DROP TABLE IF EXISTS `log_flower_rank_final`;
CREATE TABLE `log_flower_rank_final` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '昵称',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '最终排名',
  `log_rank` int(11) NOT NULL DEFAULT '0' COMMENT '日志排名',
  `value` int(11) NOT NULL DEFAULT '0' COMMENT '花价值',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型 1送花 2收花',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='鲜花榜日志';

-- ----------------------------
--  Table structure for `log_footprint_equip`
-- ----------------------------
DROP TABLE IF EXISTS `log_footprint_equip`;
CREATE TABLE `log_footprint_equip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `subtype` smallint(4) NOT NULL COMMENT '部位',
  `old_gid` int(11) NOT NULL COMMENT '旧装备id',
  `new_gid` int(11) NOT NULL COMMENT '新装备id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COMMENT='足迹装备日志';

-- ----------------------------
--  Table structure for `log_footprint_skill`
-- ----------------------------
DROP TABLE IF EXISTS `log_footprint_skill`;
CREATE TABLE `log_footprint_skill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `cell` tinyint(1) NOT NULL COMMENT '格子',
  `old_sid` int(11) NOT NULL COMMENT '旧技能id',
  `new_sid` int(11) NOT NULL COMMENT '新技能id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=197 DEFAULT CHARSET=utf8 COMMENT='足迹技能日志';

-- ----------------------------
--  Table structure for `log_footprint_spirit`
-- ----------------------------
DROP TABLE IF EXISTS `log_footprint_spirit`;
CREATE TABLE `log_footprint_spirit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='足迹灵脉日志';

-- ----------------------------
--  Table structure for `log_footprint_stage`
-- ----------------------------
DROP TABLE IF EXISTS `log_footprint_stage`;
CREATE TABLE `log_footprint_stage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `stage` int(11) NOT NULL COMMENT '新阶数',
  `old_stage` int(11) NOT NULL COMMENT '旧阶数',
  `exp` int(11) NOT NULL COMMENT '当前经验',
  `old_exp` int(11) NOT NULL COMMENT '旧经验',
  `time` int(11) NOT NULL COMMENT '时间戳',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型0正常1清零',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=5177 DEFAULT CHARSET=utf8 COMMENT='足迹升阶日志';

-- ----------------------------
--  Table structure for `log_free_gift`
-- ----------------------------
DROP TABLE IF EXISTS `log_free_gift`;
CREATE TABLE `log_free_gift` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL,
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '档次',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='零元礼包日志';

-- ----------------------------
--  Table structure for `log_fuwen_compound`
-- ----------------------------
DROP TABLE IF EXISTS `log_fuwen_compound`;
CREATE TABLE `log_fuwen_compound` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `goods_lv` int(10) NOT NULL DEFAULT '0',
  `cost_exp` int(10) NOT NULL DEFAULT '0',
  `consume` varchar(200) NOT NULL DEFAULT '[GoodsKey]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8 COMMENT='双属性符文合成日志';

-- ----------------------------
--  Table structure for `log_fuwen_compound_consume`
-- ----------------------------
DROP TABLE IF EXISTS `log_fuwen_compound_consume`;
CREATE TABLE `log_fuwen_compound_consume` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `goods_key` bigint(22) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `color` int(1) NOT NULL DEFAULT '0',
  `goods_lv` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8 COMMENT='双属性符文合成消耗日志';

-- ----------------------------
--  Table structure for `log_fuwen_put_on`
-- ----------------------------
DROP TABLE IF EXISTS `log_fuwen_put_on`;
CREATE TABLE `log_fuwen_put_on` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `nickname` varchar(100) NOT NULL DEFAULT '""',
  `fuwen_key` bigint(22) NOT NULL DEFAULT '0' COMMENT '符文唯一key',
  `old_fuwen_desc` varchar(100) NOT NULL DEFAULT '""',
  `new_fuwen_desc` varchar(100) NOT NULL DEFAULT '""',
  `old_pos` int(1) NOT NULL DEFAULT '0' COMMENT '旧的穿戴位置',
  `new_pos` int(1) NOT NULL DEFAULT '0' COMMENT '新的穿戴位置',
  `old_lv` int(3) NOT NULL DEFAULT '0' COMMENT '旧符文等级',
  `new_lv` bigint(22) NOT NULL DEFAULT '0' COMMENT '新符文等级',
  `color` int(1) NOT NULL DEFAULT '0' COMMENT '品质',
  `goods_id` int(10) NOT NULL DEFAULT '0' COMMENT '符文配置ID',
  `time` int(10) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=153 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='符文替换日志';

-- ----------------------------
--  Table structure for `log_fuwen_resolved`
-- ----------------------------
DROP TABLE IF EXISTS `log_fuwen_resolved`;
CREATE TABLE `log_fuwen_resolved` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '符文key',
  `nickname` varchar(100) NOT NULL DEFAULT '""' COMMENT '昵称',
  `fuwen_key` bigint(22) NOT NULL DEFAULT '0' COMMENT '序号',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `color` int(2) NOT NULL DEFAULT '0' COMMENT '品质',
  `fuwen_desc` varchar(100) NOT NULL DEFAULT '""' COMMENT '符文描述',
  `goods_lv` int(3) NOT NULL DEFAULT '0' COMMENT '符文等级',
  `exp` int(10) NOT NULL DEFAULT '0' COMMENT '分解经验',
  `best_exp` int(10) NOT NULL DEFAULT '0' COMMENT '返还至尊精华',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=6419 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='符文分解';

-- ----------------------------
--  Table structure for `log_fuwen_upgrade`
-- ----------------------------
DROP TABLE IF EXISTS `log_fuwen_upgrade`;
CREATE TABLE `log_fuwen_upgrade` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `pkey` int(10) NOT NULL,
  `nickname` varchar(100) NOT NULL DEFAULT '""',
  `fuwen_key` bigint(22) NOT NULL DEFAULT '0' COMMENT '符文key',
  `fuwen_desc` varchar(100) NOT NULL DEFAULT '""',
  `goods_id` int(10) NOT NULL DEFAULT '0' COMMENT '物品配置ID',
  `color` int(1) NOT NULL DEFAULT '0' COMMENT '品质',
  `lv` int(3) NOT NULL DEFAULT '0' COMMENT '符文等级',
  `time` int(10) NOT NULL DEFAULT '0' COMMENT '升级时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=1929 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='符文升级';

-- ----------------------------
--  Table structure for `log_gift`
-- ----------------------------
DROP TABLE IF EXISTS `log_gift`;
CREATE TABLE `log_gift` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家昵称',
  `gift_id` int(10) DEFAULT '0' COMMENT '礼包id',
  `gift_name` varchar(50) DEFAULT '' COMMENT '礼包名称',
  `from` int(10) DEFAULT '0' COMMENT '领取来源',
  `time` int(10) DEFAULT '0' COMMENT '时间',
  `gift_num` int(10) DEFAULT '0' COMMENT '礼包数量',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE,
  KEY `from` (`from`) USING BTREE,
  KEY `name` (`nickname`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=367 DEFAULT CHARSET=utf8 COMMENT='玩家礼包领取日志';

-- ----------------------------
--  Table structure for `log_god_treasure_equip`
-- ----------------------------
DROP TABLE IF EXISTS `log_god_treasure_equip`;
CREATE TABLE `log_god_treasure_equip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `subtype` smallint(4) NOT NULL COMMENT '部位',
  `old_gid` int(11) NOT NULL COMMENT '旧装备id',
  `new_gid` int(11) NOT NULL COMMENT '新装备id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COMMENT='仙宝装备日志';

-- ----------------------------
--  Table structure for `log_god_treasure_skill`
-- ----------------------------
DROP TABLE IF EXISTS `log_god_treasure_skill`;
CREATE TABLE `log_god_treasure_skill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `cell` tinyint(1) NOT NULL COMMENT '格子',
  `old_sid` int(11) NOT NULL COMMENT '旧技能id',
  `new_sid` int(11) NOT NULL COMMENT '新技能id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=543 DEFAULT CHARSET=utf8 COMMENT='仙宝技能日志';

-- ----------------------------
--  Table structure for `log_god_treasure_spirit`
-- ----------------------------
DROP TABLE IF EXISTS `log_god_treasure_spirit`;
CREATE TABLE `log_god_treasure_spirit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=271 DEFAULT CHARSET=utf8 COMMENT='仙宝灵脉日志';

-- ----------------------------
--  Table structure for `log_god_treasure_stage`
-- ----------------------------
DROP TABLE IF EXISTS `log_god_treasure_stage`;
CREATE TABLE `log_god_treasure_stage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `stage` int(11) NOT NULL COMMENT '新阶数',
  `old_stage` int(11) NOT NULL COMMENT '旧阶数',
  `exp` int(11) NOT NULL COMMENT '当前经验',
  `old_exp` int(11) NOT NULL COMMENT '旧经验',
  `time` int(11) NOT NULL COMMENT '时间戳',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型0正常1清零',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15800 DEFAULT CHARSET=utf8 COMMENT='仙宝升阶日志';

-- ----------------------------
--  Table structure for `log_god_weapon_upgrade`
-- ----------------------------
DROP TABLE IF EXISTS `log_god_weapon_upgrade`;
CREATE TABLE `log_god_weapon_upgrade` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `weapon_id` int(11) NOT NULL DEFAULT '0' COMMENT '神器id',
  `old_star` int(11) NOT NULL DEFAULT '0' COMMENT '原阶数',
  `new_star` int(11) NOT NULL DEFAULT '0' COMMENT '新阶数',
  `weaponId` int(11) NOT NULL DEFAULT '0' COMMENT '神器id',
  `goods_list` text NOT NULL COMMENT '物品列表',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=650 DEFAULT CHARSET=utf8 COMMENT='神器升阶日志';

-- ----------------------------
--  Table structure for `log_godness_dun`
-- ----------------------------
DROP TABLE IF EXISTS `log_godness_dun`;
CREATE TABLE `log_godness_dun` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `dun_id` int(10) NOT NULL DEFAULT '0',
  `reward` char(100) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8 COMMENT='神祇副本';

-- ----------------------------
--  Table structure for `log_godness_dun_saodang`
-- ----------------------------
DROP TABLE IF EXISTS `log_godness_dun_saodang`;
CREATE TABLE `log_godness_dun_saodang` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `dun_id` int(10) NOT NULL DEFAULT '0',
  `saodang_num` int(10) NOT NULL DEFAULT '0',
  `reward` text NOT NULL,
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COMMENT='神祇副本扫荡';

-- ----------------------------
--  Table structure for `log_godness_limit`
-- ----------------------------
DROP TABLE IF EXISTS `log_godness_limit`;
CREATE TABLE `log_godness_limit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '0' COMMENT '玩家名称',
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '领取id',
  `cost` int(11) NOT NULL DEFAULT '0' COMMENT '消耗',
  `goods_list` varchar(1024) NOT NULL DEFAULT '0' COMMENT '物品列表',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COMMENT='神祇限购购买';

-- ----------------------------
--  Table structure for `log_godness_skill`
-- ----------------------------
DROP TABLE IF EXISTS `log_godness_skill`;
CREATE TABLE `log_godness_skill` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `godness_id` int(10) NOT NULL DEFAULT '0',
  `godness_key` bigint(22) NOT NULL DEFAULT '0',
  `befor_skill_list` varchar(100) NOT NULL DEFAULT '[]',
  `after_skill_list` varchar(100) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=132 DEFAULT CHARSET=utf8 COMMENT='神祇技能升级';

-- ----------------------------
--  Table structure for `log_godness_uplv`
-- ----------------------------
DROP TABLE IF EXISTS `log_godness_uplv`;
CREATE TABLE `log_godness_uplv` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `godness_id` int(10) NOT NULL DEFAULT '0',
  `godness_key` bigint(22) NOT NULL DEFAULT '0',
  `cost` varchar(100) NOT NULL DEFAULT '[]',
  `befor_lv` int(10) NOT NULL DEFAULT '0',
  `after_lv` int(10) NOT NULL DEFAULT '0',
  `befor_exp` int(10) NOT NULL DEFAULT '0',
  `after_exp` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21743 DEFAULT CHARSET=utf8 COMMENT='神祇升级';

-- ----------------------------
--  Table structure for `log_godness_upstar`
-- ----------------------------
DROP TABLE IF EXISTS `log_godness_upstar`;
CREATE TABLE `log_godness_upstar` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `godness_id` int(10) NOT NULL DEFAULT '0',
  `godness_key` bigint(22) NOT NULL DEFAULT '0',
  `cost` varchar(100) NOT NULL DEFAULT '[]',
  `befor_star` int(10) NOT NULL DEFAULT '0',
  `after_star` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=227 DEFAULT CHARSET=utf8 COMMENT='神祇升星';

-- ----------------------------
--  Table structure for `log_godsoul_put_on`
-- ----------------------------
DROP TABLE IF EXISTS `log_godsoul_put_on`;
CREATE TABLE `log_godsoul_put_on` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `goods_key` bigint(22) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `pos` int(10) NOT NULL DEFAULT '0',
  `godness_key` bigint(22) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=631 DEFAULT CHARSET=utf8 COMMENT='神魂穿戴';

-- ----------------------------
--  Table structure for `log_godsoul_tunsi`
-- ----------------------------
DROP TABLE IF EXISTS `log_godsoul_tunsi`;
CREATE TABLE `log_godsoul_tunsi` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `goods_key` bigint(22) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `lv` int(10) NOT NULL DEFAULT '0',
  `exp` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1042 DEFAULT CHARSET=utf8 COMMENT='神魂吞噬';

-- ----------------------------
--  Table structure for `log_godsoul_uplv`
-- ----------------------------
DROP TABLE IF EXISTS `log_godsoul_uplv`;
CREATE TABLE `log_godsoul_uplv` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `goods_key` bigint(22) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `befor_lv` int(10) NOT NULL DEFAULT '0',
  `befor_exp` int(10) NOT NULL DEFAULT '0',
  `after_lv` int(10) NOT NULL DEFAULT '0',
  `after_exp` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=315 DEFAULT CHARSET=utf8 COMMENT='神魂升级';

-- ----------------------------
--  Table structure for `log_gold`
-- ----------------------------
DROP TABLE IF EXISTS `log_gold`;
CREATE TABLE `log_gold` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家ID',
  `oldgold` int(11) NOT NULL DEFAULT '0' COMMENT '原来钻石数',
  `oldbgold` int(11) NOT NULL DEFAULT '0' COMMENT '原来的绑定钻石数',
  `newgold` int(11) NOT NULL DEFAULT '0' COMMENT '新钻石数',
  `newbgold` int(11) NOT NULL DEFAULT '0' COMMENT '新绑定钻石数',
  `addgold` int(11) NOT NULL DEFAULT '0' COMMENT '修改钻石数(负数代表扣减)',
  `addreason` int(11) NOT NULL DEFAULT '0' COMMENT '修改原因',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `game_id` int(11) NOT NULL DEFAULT '0' COMMENT '游戏id',
  `channel_id` int(11) NOT NULL DEFAULT '0' COMMENT '平台id',
  `game_channel_id` int(11) NOT NULL DEFAULT '0' COMMENT '游戏包id',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '物品id',
  `goods_num` int(11) NOT NULL DEFAULT '0' COMMENT '物品数量',
  `desc` varchar(100) NOT NULL DEFAULT '' COMMENT '消耗描述',
  `sn` int(11) NOT NULL DEFAULT '0' COMMENT '服务器号',
  `acc_name` varchar(100) NOT NULL DEFAULT '' COMMENT '账号',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `time` (`time`),
  KEY `addreason` (`addreason`)
) ENGINE=InnoDB AUTO_INCREMENT=123930 DEFAULT CHARSET=utf8 COMMENT='钻石修改日志';

-- ----------------------------
--  Table structure for `log_golden_body_equip`
-- ----------------------------
DROP TABLE IF EXISTS `log_golden_body_equip`;
CREATE TABLE `log_golden_body_equip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `subtype` smallint(4) NOT NULL COMMENT '部位',
  `old_gid` int(11) NOT NULL COMMENT '旧装备id',
  `new_gid` int(11) NOT NULL COMMENT '新装备id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='灵猫装备日志';

-- ----------------------------
--  Table structure for `log_golden_body_skill`
-- ----------------------------
DROP TABLE IF EXISTS `log_golden_body_skill`;
CREATE TABLE `log_golden_body_skill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `cell` tinyint(1) NOT NULL COMMENT '格子',
  `old_sid` int(11) NOT NULL COMMENT '旧技能id',
  `new_sid` int(11) NOT NULL COMMENT '新技能id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8 COMMENT='灵猫技能日志';

-- ----------------------------
--  Table structure for `log_golden_body_spirit`
-- ----------------------------
DROP TABLE IF EXISTS `log_golden_body_spirit`;
CREATE TABLE `log_golden_body_spirit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='灵猫灵脉日志';

-- ----------------------------
--  Table structure for `log_golden_body_stage`
-- ----------------------------
DROP TABLE IF EXISTS `log_golden_body_stage`;
CREATE TABLE `log_golden_body_stage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `stage` int(11) NOT NULL COMMENT '新阶数',
  `old_stage` int(11) NOT NULL COMMENT '旧阶数',
  `exp` int(11) NOT NULL COMMENT '当前经验',
  `old_exp` int(11) NOT NULL COMMENT '旧经验',
  `time` int(11) NOT NULL COMMENT '时间戳',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型0正常1清零',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=4250 DEFAULT CHARSET=utf8 COMMENT='灵猫升阶日志';

-- ----------------------------
--  Table structure for `log_goods_create`
-- ----------------------------
DROP TABLE IF EXISTS `log_goods_create`;
CREATE TABLE `log_goods_create` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '编号',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `goods_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品类型ID',
  `goods_name` varchar(50) NOT NULL DEFAULT '[]' COMMENT '物品名称',
  `create_num` int(11) NOT NULL DEFAULT '0' COMMENT '创建数量',
  `from` int(11) NOT NULL DEFAULT '0' COMMENT '创建原因',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '日记时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=142286 DEFAULT CHARSET=utf8 COMMENT='物品创建日志';

-- ----------------------------
--  Table structure for `log_goods_use`
-- ----------------------------
DROP TABLE IF EXISTS `log_goods_use`;
CREATE TABLE `log_goods_use` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '编号',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `goods_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品类型ID',
  `goods_name` varchar(50) NOT NULL DEFAULT '[]' COMMENT '物品名称',
  `create_num` int(11) NOT NULL DEFAULT '0' COMMENT '创建数量',
  `reason` int(11) NOT NULL DEFAULT '0' COMMENT '创建原因',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '日记时间',
  `goods_star` int(11) NOT NULL DEFAULT '0' COMMENT '物品星级',
  `expiretime` int(11) NOT NULL DEFAULT '0' COMMENT '过期时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=133808 DEFAULT CHARSET=utf8 COMMENT='物品使用日志';

-- ----------------------------
--  Table structure for `log_guild`
-- ----------------------------
DROP TABLE IF EXISTS `log_guild`;
CREATE TABLE `log_guild` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '公会KEY',
  `gname` varchar(50) NOT NULL DEFAULT '0' COMMENT '公会昵称',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '玩家name',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型（1创建公会，2解散公会）',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `gkey` (`gkey`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8 COMMENT='公会操作日志';

-- ----------------------------
--  Table structure for `log_guild_boss`
-- ----------------------------
DROP TABLE IF EXISTS `log_guild_boss`;
CREATE TABLE `log_guild_boss` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `gkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '公会ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `rank` int(11) DEFAULT '0' COMMENT '排名',
  `mid` int(11) DEFAULT '0' COMMENT '怪物id',
  `time` int(11) DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `gkey` (`gkey`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8 COMMENT='仙盟神兽日志';

-- ----------------------------
--  Table structure for `log_guild_boss_feeding`
-- ----------------------------
DROP TABLE IF EXISTS `log_guild_boss_feeding`;
CREATE TABLE `log_guild_boss_feeding` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `gkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '公会ID',
  `cost` int(11) DEFAULT '0' COMMENT '消耗',
  `type` int(11) DEFAULT '0' COMMENT '0物品 1元宝',
  `old_star` int(11) DEFAULT '0' COMMENT '旧星级',
  `old_exp` int(11) DEFAULT '0' COMMENT '旧经验',
  `new_star` int(11) DEFAULT '0' COMMENT '新星级',
  `new_exp` int(11) DEFAULT '0' COMMENT '新经验',
  `exp` int(11) DEFAULT '0' COMMENT '增加经验值',
  `time` int(11) DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `gkey` (`gkey`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8 COMMENT='仙盟神兽喂养日志';

-- ----------------------------
--  Table structure for `log_guild_box_get`
-- ----------------------------
DROP TABLE IF EXISTS `log_guild_box_get`;
CREATE TABLE `log_guild_box_get` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `is_help` int(11) NOT NULL DEFAULT '0' COMMENT '是否协助',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `goods_list` varchar(300) NOT NULL DEFAULT '[]' COMMENT '物品列表',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8 COMMENT='公会宝箱领取日志';

-- ----------------------------
--  Table structure for `log_guild_box_help`
-- ----------------------------
DROP TABLE IF EXISTS `log_guild_box_help`;
CREATE TABLE `log_guild_box_help` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `pkey1` int(11) NOT NULL COMMENT '协助玩家key',
  `nickname1` varchar(150) NOT NULL DEFAULT '[]' COMMENT '协助玩家昵称',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `goods_list` varchar(300) NOT NULL DEFAULT '[]' COMMENT '物品列表',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='公会宝箱协助日志';

-- ----------------------------
--  Table structure for `log_guild_change_main`
-- ----------------------------
DROP TABLE IF EXISTS `log_guild_change_main`;
CREATE TABLE `log_guild_change_main` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `gkey` bigint(22) NOT NULL DEFAULT '0',
  `pkey` int(10) NOT NULL DEFAULT '0',
  `old_pkey` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='帮主更换日志';

-- ----------------------------
--  Table structure for `log_guild_dedicate`
-- ----------------------------
DROP TABLE IF EXISTS `log_guild_dedicate`;
CREATE TABLE `log_guild_dedicate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家KEY',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `gkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '公会KEY',
  `goods_num` int(1) NOT NULL DEFAULT '0' COMMENT '仙盟令数量',
  `gold_num` int(1) NOT NULL DEFAULT '0' COMMENT '钻石数',
  `dedicate` int(11) NOT NULL DEFAULT '0' COMMENT '奉献进度',
  `acc_dedicate` int(10) NOT NULL DEFAULT '0' COMMENT '累计奉献',
  `leave_dedicate` int(10) NOT NULL DEFAULT '0' COMMENT '剩余奉献',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `msg` varchar(50) NOT NULL DEFAULT '' COMMENT '改变原因',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `gkey` (`gkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8 COMMENT='公会奉献';

-- ----------------------------
--  Table structure for `log_guild_fight`
-- ----------------------------
DROP TABLE IF EXISTS `log_guild_fight`;
CREATE TABLE `log_guild_fight` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `att_pkey` int(10) NOT NULL DEFAULT '0',
  `att_gkey` bigint(22) NOT NULL DEFAULT '0',
  `att_gname` varchar(50) NOT NULL DEFAULT '[]',
  `def_pkey` int(10) NOT NULL DEFAULT '0',
  `def_gname` varchar(50) NOT NULL DEFAULT '[]',
  `def_gkey` bigint(22) NOT NULL DEFAULT '0',
  `ret` int(10) NOT NULL DEFAULT '0',
  `att_reward` varchar(100) NOT NULL DEFAULT '[]',
  `def_reward` varchar(100) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `att_pkey` (`att_pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='仙盟对战挑战日志';

-- ----------------------------
--  Table structure for `log_guild_fight_box`
-- ----------------------------
DROP TABLE IF EXISTS `log_guild_fight_box`;
CREATE TABLE `log_guild_fight_box` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `gkey` bigint(22) NOT NULL DEFAULT '0',
  `gname` varchar(50) NOT NULL DEFAULT '[]',
  `guild_num` int(10) NOT NULL DEFAULT '0',
  `guild_sum_lv` int(10) NOT NULL DEFAULT '0',
  `reward` varchar(100) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='仙盟对战进度奖励领取';

-- ----------------------------
--  Table structure for `log_guild_fight_exchange`
-- ----------------------------
DROP TABLE IF EXISTS `log_guild_fight_exchange`;
CREATE TABLE `log_guild_fight_exchange` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `goods_num` int(10) NOT NULL DEFAULT '0',
  `cost` varchar(100) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE,
  KEY `pkey` (`pkey`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='公会对战兑换';

-- ----------------------------
--  Table structure for `log_guild_mb`
-- ----------------------------
DROP TABLE IF EXISTS `log_guild_mb`;
CREATE TABLE `log_guild_mb` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '公会KEY',
  `gname` varchar(50) NOT NULL DEFAULT '0' COMMENT '公会昵称',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '玩家name',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型（1加入，2退出，3踢出，4任命）',
  `pos_old` int(11) NOT NULL DEFAULT '0' COMMENT '旧职位',
  `pos_new` int(11) NOT NULL DEFAULT '0' COMMENT '新职位',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `gkey` (`gkey`),
  KEY `gname` (`gname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=246 DEFAULT CHARSET=utf8 COMMENT='公会人员操作日志';

-- ----------------------------
--  Table structure for `log_guild_name`
-- ----------------------------
DROP TABLE IF EXISTS `log_guild_name`;
CREATE TABLE `log_guild_name` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gkey` bigint(22) NOT NULL COMMENT '公会key',
  `name_old` varchar(50) NOT NULL DEFAULT '' COMMENT '原名字',
  `name_new` varchar(50) NOT NULL DEFAULT '' COMMENT '新名字',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `name_old` (`name_old`),
  KEY `name_new` (`name_new`),
  KEY `pkey` (`pkey`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='公会改名';

-- ----------------------------
--  Table structure for `log_guild_rank`
-- ----------------------------
DROP TABLE IF EXISTS `log_guild_rank`;
CREATE TABLE `log_guild_rank` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `gkey` bigint(22) DEFAULT '0' COMMENT '帮派ID',
  `name` varchar(50) DEFAULT NULL COMMENT '帮派名',
  `lv` int(10) DEFAULT '0' COMMENT '等级',
  `num` int(10) DEFAULT '0' COMMENT '人数',
  `vigor` int(10) DEFAULT '0' COMMENT '活跃度',
  `rank` int(10) DEFAULT '0' COMMENT '排行',
  `time` int(10) DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `gkey` (`gkey`) USING BTREE,
  KEY `name` (`name`) USING BTREE,
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='帮派排行榜日志';

-- ----------------------------
--  Table structure for `log_guild_skill`
-- ----------------------------
DROP TABLE IF EXISTS `log_guild_skill`;
CREATE TABLE `log_guild_skill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(22) NOT NULL DEFAULT '0' COMMENT '玩家KEY',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '玩家昵称',
  `sid` tinyint(1) NOT NULL DEFAULT '0' COMMENT '技能类型ID%% 1生命，2攻击，3护甲，4魔抗，5破甲，6穿透，7命中，8闪避，9暴击，10韧性，11最终伤害，12最终减伤\\n',
  `old_lv` smallint(4) NOT NULL DEFAULT '0' COMMENT '提升前等级',
  `new_lv` smallint(4) NOT NULL DEFAULT '0' COMMENT '提升等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8 COMMENT='公会技能';

-- ----------------------------
--  Table structure for `log_guild_war`
-- ----------------------------
DROP TABLE IF EXISTS `log_guild_war`;
CREATE TABLE `log_guild_war` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家KEY',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '玩家昵称',
  `gkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '公会KEy',
  `gname` varchar(50) NOT NULL DEFAULT '0' COMMENT '公会名称',
  `contrib` int(11) NOT NULL DEFAULT '0' COMMENT '获得贡献',
  `group` tinyint(1) NOT NULL DEFAULT '0' COMMENT '所在分组',
  `group_rank` tinyint(1) NOT NULL DEFAULT '0' COMMENT '公会分组排名',
  `rank` smallint(4) NOT NULL DEFAULT '0' COMMENT '所在分组内排名',
  `reward` text NOT NULL COMMENT '奖励',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公会战记录';

-- ----------------------------
--  Table structure for `log_head`
-- ----------------------------
DROP TABLE IF EXISTS `log_head`;
CREATE TABLE `log_head` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `type` tinyint(1) NOT NULL COMMENT '类型1激活2升级3过期',
  `head_id` int(11) NOT NULL COMMENT '头饰id',
  `stage` tinyint(1) NOT NULL COMMENT '阶数',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=556 DEFAULT CHARSET=utf8 COMMENT='头饰日志';

-- ----------------------------
--  Table structure for `log_hqg_daily_charge`
-- ----------------------------
DROP TABLE IF EXISTS `log_hqg_daily_charge`;
CREATE TABLE `log_hqg_daily_charge` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `goods_num` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `key2` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=944 DEFAULT CHARSET=utf8 COMMENT='每日首充领取日志';

-- ----------------------------
--  Table structure for `log_hunt_reward`
-- ----------------------------
DROP TABLE IF EXISTS `log_hunt_reward`;
CREATE TABLE `log_hunt_reward` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家KEY',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '玩家昵称',
  `target_id` int(11) NOT NULL DEFAULT '0' COMMENT '目标id',
  `goods_list` text NOT NULL COMMENT '奖励列表',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='猎场奖励';

-- ----------------------------
--  Table structure for `log_jade_equip`
-- ----------------------------
DROP TABLE IF EXISTS `log_jade_equip`;
CREATE TABLE `log_jade_equip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `subtype` smallint(4) NOT NULL COMMENT '部位',
  `old_gid` int(11) NOT NULL COMMENT '旧装备id',
  `new_gid` int(11) NOT NULL COMMENT '新装备id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COMMENT='玉佩装备日志';

-- ----------------------------
--  Table structure for `log_jade_skill`
-- ----------------------------
DROP TABLE IF EXISTS `log_jade_skill`;
CREATE TABLE `log_jade_skill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `cell` tinyint(1) NOT NULL COMMENT '格子',
  `old_sid` int(11) NOT NULL COMMENT '旧技能id',
  `new_sid` int(11) NOT NULL COMMENT '新技能id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=222 DEFAULT CHARSET=utf8 COMMENT='玉佩技能日志';

-- ----------------------------
--  Table structure for `log_jade_spirit`
-- ----------------------------
DROP TABLE IF EXISTS `log_jade_spirit`;
CREATE TABLE `log_jade_spirit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=312 DEFAULT CHARSET=utf8 COMMENT='玉佩灵脉日志';

-- ----------------------------
--  Table structure for `log_jade_stage`
-- ----------------------------
DROP TABLE IF EXISTS `log_jade_stage`;
CREATE TABLE `log_jade_stage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `stage` int(11) NOT NULL COMMENT '新阶数',
  `old_stage` int(11) NOT NULL COMMENT '旧阶数',
  `exp` int(11) NOT NULL COMMENT '当前经验',
  `old_exp` int(11) NOT NULL COMMENT '旧经验',
  `time` int(11) NOT NULL COMMENT '时间戳',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型0正常1清零',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16171 DEFAULT CHARSET=utf8 COMMENT='玉佩升阶日志';

-- ----------------------------
--  Table structure for `log_jiandao_up_lv`
-- ----------------------------
DROP TABLE IF EXISTS `log_jiandao_up_lv`;
CREATE TABLE `log_jiandao_up_lv` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `point_id` int(10) NOT NULL DEFAULT '0',
  `lv` int(10) NOT NULL DEFAULT '0',
  `cost` varchar(50) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8108 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `log_jiandao_up_stage`
-- ----------------------------
DROP TABLE IF EXISTS `log_jiandao_up_stage`;
CREATE TABLE `log_jiandao_up_stage` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `stage` int(10) NOT NULL DEFAULT '0',
  `cost` varchar(100) NOT NULL DEFAULT '[]',
  `time` int(10) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `log_kill_player`
-- ----------------------------
DROP TABLE IF EXISTS `log_kill_player`;
CREATE TABLE `log_kill_player` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `att_key` int(11) DEFAULT NULL COMMENT '攻击者key',
  `att_name` varchar(500) DEFAULT NULL COMMENT '攻击者名字',
  `att_lv` int(11) DEFAULT NULL COMMENT '攻击者等级',
  `att_pk_state` int(11) DEFAULT NULL COMMENT '攻击者Pk状态',
  `der_key` int(11) DEFAULT NULL COMMENT '攻击者key',
  `der_name` varchar(500) DEFAULT NULL COMMENT '攻击者名字',
  `der_lv` int(11) DEFAULT NULL COMMENT '攻击者等级',
  `der_pk_state` int(11) DEFAULT NULL COMMENT '攻击者Pk状态',
  `time` int(11) DEFAULT NULL COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `att_key` (`att_key`) USING BTREE,
  KEY `der_key` (`der_key`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `log_light_weapon_equip`
-- ----------------------------
DROP TABLE IF EXISTS `log_light_weapon_equip`;
CREATE TABLE `log_light_weapon_equip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `subtype` smallint(4) NOT NULL COMMENT '部位',
  `old_gid` int(11) NOT NULL COMMENT '旧装备id',
  `new_gid` int(11) NOT NULL COMMENT '新装备id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='神兵装备日志';

-- ----------------------------
--  Table structure for `log_light_weapon_skill`
-- ----------------------------
DROP TABLE IF EXISTS `log_light_weapon_skill`;
CREATE TABLE `log_light_weapon_skill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `cell` tinyint(1) NOT NULL COMMENT '格子',
  `old_sid` int(11) NOT NULL COMMENT '旧技能id',
  `new_sid` int(11) NOT NULL COMMENT '新技能id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=272 DEFAULT CHARSET=utf8 COMMENT='神兵技能日志';

-- ----------------------------
--  Table structure for `log_light_weapon_spirit`
-- ----------------------------
DROP TABLE IF EXISTS `log_light_weapon_spirit`;
CREATE TABLE `log_light_weapon_spirit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='神兵灵脉日志';

-- ----------------------------
--  Table structure for `log_light_weapon_stage`
-- ----------------------------
DROP TABLE IF EXISTS `log_light_weapon_stage`;
CREATE TABLE `log_light_weapon_stage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `stage` int(11) NOT NULL COMMENT '新阶数',
  `old_stage` int(11) NOT NULL COMMENT '旧阶数',
  `exp` int(11) NOT NULL COMMENT '当前经验',
  `old_exp` int(11) NOT NULL COMMENT '旧经验',
  `time` int(11) NOT NULL COMMENT '时间戳',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型0正常1清零',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=9072 DEFAULT CHARSET=utf8 COMMENT='神兵升阶日志';

-- ----------------------------
--  Table structure for `log_light_weapon_star`
-- ----------------------------
DROP TABLE IF EXISTS `log_light_weapon_star`;
CREATE TABLE `log_light_weapon_star` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `mount_id` int(11) NOT NULL COMMENT '坐骑id',
  `star` int(11) NOT NULL COMMENT '星级',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=546 DEFAULT CHARSET=utf8 COMMENT='神兵图鉴日志';

-- ----------------------------
--  Table structure for `log_login`
-- ----------------------------
DROP TABLE IF EXISTS `log_login`;
CREATE TABLE `log_login` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) DEFAULT NULL COMMENT '玩家key',
  `nickname` varchar(20) DEFAULT '' COMMENT '昵称',
  `time` int(10) DEFAULT '0' COMMENT '时间戳',
  `data` text COMMENT '登陆信息',
  `online_time` int(10) DEFAULT '0' COMMENT '在线时长',
  `login_num` int(11) DEFAULT '0' COMMENT '登陆次数',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `ts` (`time`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=3191 DEFAULT CHARSET=utf8 COMMENT='登陆日志表';

-- ----------------------------
--  Table structure for `log_lv`
-- ----------------------------
DROP TABLE IF EXISTS `log_lv`;
CREATE TABLE `log_lv` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家昵称',
  `lv` smallint(2) DEFAULT '0' COMMENT '等级',
  `uplv` int(11) DEFAULT '0' COMMENT '升等级',
  `exptype` int(1) DEFAULT '0' COMMENT '经验类型',
  `time` int(10) DEFAULT '0' COMMENT '升级时间戳',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=33130 DEFAULT CHARSET=utf8 COMMENT='玩家升级日志';

-- ----------------------------
--  Table structure for `log_magic_weapon_equip`
-- ----------------------------
DROP TABLE IF EXISTS `log_magic_weapon_equip`;
CREATE TABLE `log_magic_weapon_equip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `subtype` smallint(4) NOT NULL COMMENT '部位',
  `old_gid` int(11) NOT NULL COMMENT '旧装备id',
  `new_gid` int(11) NOT NULL COMMENT '新装备id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='法宝装备日志';

-- ----------------------------
--  Table structure for `log_magic_weapon_skill`
-- ----------------------------
DROP TABLE IF EXISTS `log_magic_weapon_skill`;
CREATE TABLE `log_magic_weapon_skill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `cell` tinyint(1) NOT NULL COMMENT '格子',
  `old_sid` int(11) NOT NULL COMMENT '旧技能id',
  `new_sid` int(11) NOT NULL COMMENT '新技能id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=utf8 COMMENT='法宝技能日志';

-- ----------------------------
--  Table structure for `log_magic_weapon_spirit`
-- ----------------------------
DROP TABLE IF EXISTS `log_magic_weapon_spirit`;
CREATE TABLE `log_magic_weapon_spirit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='法宝灵脉日志';

-- ----------------------------
--  Table structure for `log_magic_weapon_stage`
-- ----------------------------
DROP TABLE IF EXISTS `log_magic_weapon_stage`;
CREATE TABLE `log_magic_weapon_stage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `stage` int(11) NOT NULL COMMENT '新阶数',
  `old_stage` int(11) NOT NULL COMMENT '旧阶数',
  `exp` int(11) NOT NULL COMMENT '当前经验',
  `old_exp` int(11) NOT NULL COMMENT '旧经验',
  `time` int(11) NOT NULL COMMENT '时间戳',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型0正常1清零',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=3964 DEFAULT CHARSET=utf8 COMMENT='法宝升阶日志';

-- ----------------------------
--  Table structure for `log_mail`
-- ----------------------------
DROP TABLE IF EXISTS `log_mail`;
CREATE TABLE `log_mail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '[]' COMMENT '昵称',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '类型1新增，2提取',
  `goods` text NOT NULL COMMENT '物品列表',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `title` varchar(20) NOT NULL DEFAULT '' COMMENT '标题',
  `content` varchar(250) NOT NULL DEFAULT '' COMMENT '内容',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=16247 DEFAULT CHARSET=utf8 COMMENT='邮件列表';

-- ----------------------------
--  Table structure for `log_manor_pt`
-- ----------------------------
DROP TABLE IF EXISTS `log_manor_pt`;
CREATE TABLE `log_manor_pt` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `old_pt` int(11) NOT NULL DEFAULT '0' COMMENT '旧的物资值',
  `new_pt` int(11) NOT NULL DEFAULT '0' COMMENT '新物资值',
  `change_pt` int(11) NOT NULL DEFAULT '0' COMMENT '变化值',
  `from` int(11) NOT NULL DEFAULT '0' COMMENT '来源',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '物品id',
  `num` int(11) NOT NULL DEFAULT '0' COMMENT '数量',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8 COMMENT='家园物资日志';

-- ----------------------------
--  Table structure for `log_market`
-- ----------------------------
DROP TABLE IF EXISTS `log_market`;
CREATE TABLE `log_market` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '玩家名字',
  `type` int(1) NOT NULL DEFAULT '0' COMMENT '1.上架 2取回 3重新上架 4购买',
  `goods_id` int(1) NOT NULL DEFAULT '0' COMMENT '购买的物品id',
  `num` int(1) NOT NULL COMMENT '数量',
  `price` int(1) NOT NULL DEFAULT '0' COMMENT '出售价格',
  `time` int(1) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='交易所日志表';

-- ----------------------------
--  Table structure for `log_market_buy`
-- ----------------------------
DROP TABLE IF EXISTS `log_market_buy`;
CREATE TABLE `log_market_buy` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `mkey` bigint(22) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `goods_num` int(10) NOT NULL DEFAULT '0',
  `price` int(10) NOT NULL DEFAULT '0',
  `sell_pkey` int(10) NOT NULL DEFAULT '0',
  `sell_args` varchar(1024) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='集市购买日志';

-- ----------------------------
--  Table structure for `log_market_past_due`
-- ----------------------------
DROP TABLE IF EXISTS `log_market_past_due`;
CREATE TABLE `log_market_past_due` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `mkey` bigint(22) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `goods_num` int(10) NOT NULL DEFAULT '0',
  `sell_args` varchar(1024) NOT NULL DEFAULT '[]',
  `price` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='集市过期日志';

-- ----------------------------
--  Table structure for `log_market_sell`
-- ----------------------------
DROP TABLE IF EXISTS `log_market_sell`;
CREATE TABLE `log_market_sell` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL,
  `mkey` bigint(22) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `goods_num` int(10) NOT NULL DEFAULT '0',
  `price` int(10) NOT NULL DEFAULT '0',
  `sell_args` varchar(1024) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='集市出售日志';

-- ----------------------------
--  Table structure for `log_market_sell_out`
-- ----------------------------
DROP TABLE IF EXISTS `log_market_sell_out`;
CREATE TABLE `log_market_sell_out` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `mkey` bigint(22) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `goods_num` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='集市下架日志';

-- ----------------------------
--  Table structure for `log_marry`
-- ----------------------------
DROP TABLE IF EXISTS `log_marry`;
CREATE TABLE `log_marry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '类型1结婚2离婚',
  `pkey1` int(11) NOT NULL DEFAULT '0' COMMENT '玩家1',
  `nickname1` varchar(50) NOT NULL DEFAULT '[]' COMMENT '玩家1昵称',
  `pkey2` int(11) NOT NULL DEFAULT '0' COMMENT '玩家2key',
  `nickname2` varchar(50) NOT NULL DEFAULT '[]' COMMENT '玩家2昵称',
  `marry_type` int(11) NOT NULL DEFAULT '0' COMMENT '结婚类型',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8 COMMENT='婚姻日志';

-- ----------------------------
--  Table structure for `log_marry_cruise`
-- ----------------------------
DROP TABLE IF EXISTS `log_marry_cruise`;
CREATE TABLE `log_marry_cruise` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `key_boy` int(11) NOT NULL DEFAULT '0' COMMENT '男key',
  `key_girl` int(11) NOT NULL DEFAULT '0' COMMENT '女key',
  `mkey` bigint(11) NOT NULL DEFAULT '0' COMMENT '婚姻key',
  `akey` bigint(11) NOT NULL DEFAULT '0' COMMENT '唯一key',
  `date` int(11) NOT NULL DEFAULT '0' COMMENT '预约时间',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '操作时间',
  `nickname_boy` varchar(150) NOT NULL DEFAULT '0' COMMENT '男方名',
  `nickname_girl` varchar(150) NOT NULL DEFAULT '0' COMMENT '女方名',
  `old_cruise_num` int(11) NOT NULL DEFAULT '0' COMMENT '巡游次数(旧)',
  `new_cruise_num` int(11) NOT NULL DEFAULT '0' COMMENT '巡游次数(新)',
  PRIMARY KEY (`id`),
  KEY `key_boy` (`key_boy`) USING BTREE,
  KEY `key_girl` (`key_girl`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COMMENT='婚宴预约日志';

-- ----------------------------
--  Table structure for `log_marry_cruise_buy`
-- ----------------------------
DROP TABLE IF EXISTS `log_marry_cruise_buy`;
CREATE TABLE `log_marry_cruise_buy` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `cost` int(11) NOT NULL DEFAULT '0' COMMENT '玩家消耗',
  `old_cruise_num` int(11) NOT NULL DEFAULT '0' COMMENT '婚宴次数(旧)',
  `new_cruise_num` int(11) NOT NULL DEFAULT '0' COMMENT '婚宴次数(新)',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8 COMMENT='婚宴预约购买日志';

-- ----------------------------
--  Table structure for `log_marry_heart`
-- ----------------------------
DROP TABLE IF EXISTS `log_marry_heart`;
CREATE TABLE `log_marry_heart` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `cur_type` int(11) NOT NULL DEFAULT '0' COMMENT '级数',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '阶数',
  `change_time` int(11) NOT NULL DEFAULT '0' COMMENT '记录时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `change_time` (`change_time`)
) ENGINE=InnoDB AUTO_INCREMENT=3406 DEFAULT CHARSET=utf8 COMMENT='羁绊升级日志表';

-- ----------------------------
--  Table structure for `log_marry_ring`
-- ----------------------------
DROP TABLE IF EXISTS `log_marry_ring`;
CREATE TABLE `log_marry_ring` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL,
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 COMMENT='结婚戒指日志';

-- ----------------------------
--  Table structure for `log_marry_tree`
-- ----------------------------
DROP TABLE IF EXISTS `log_marry_tree`;
CREATE TABLE `log_marry_tree` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `befor_lv` int(10) NOT NULL DEFAULT '0',
  `after_lv` int(10) NOT NULL DEFAULT '0',
  `befor_exp` int(10) NOT NULL DEFAULT '0',
  `after_exp` int(10) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `goods_num` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10363 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='姻缘树';

-- ----------------------------
--  Table structure for `log_marry_tree_reward`
-- ----------------------------
DROP TABLE IF EXISTS `log_marry_tree_reward`;
CREATE TABLE `log_marry_tree_reward` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `recv_lv` int(10) NOT NULL DEFAULT '0',
  `cost` int(10) NOT NULL DEFAULT '0',
  `reward` varchar(1024) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COMMENT='姻缘树奖励';

-- ----------------------------
--  Table structure for `log_meridian`
-- ----------------------------
DROP TABLE IF EXISTS `log_meridian`;
CREATE TABLE `log_meridian` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `type` int(11) NOT NULL COMMENT '经脉类型',
  `subtype` int(11) NOT NULL COMMENT '经络类型',
  `lv` int(11) NOT NULL COMMENT '等级，0经络表示突破等级',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8 COMMENT='经脉日志';

-- ----------------------------
--  Table structure for `log_mon_photo`
-- ----------------------------
DROP TABLE IF EXISTS `log_mon_photo`;
CREATE TABLE `log_mon_photo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `mid` int(11) NOT NULL COMMENT '怪物id',
  `lv` int(11) NOT NULL COMMENT '等级',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=861 DEFAULT CHARSET=utf8 COMMENT='图鉴日志';

-- ----------------------------
--  Table structure for `log_mount_equip`
-- ----------------------------
DROP TABLE IF EXISTS `log_mount_equip`;
CREATE TABLE `log_mount_equip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `subtype` smallint(4) NOT NULL COMMENT '部位',
  `old_gid` int(11) NOT NULL COMMENT '旧装备id',
  `new_gid` int(11) NOT NULL COMMENT '新装备id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COMMENT='坐骑装备日志';

-- ----------------------------
--  Table structure for `log_mount_skill`
-- ----------------------------
DROP TABLE IF EXISTS `log_mount_skill`;
CREATE TABLE `log_mount_skill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `cell` tinyint(1) NOT NULL COMMENT '格子',
  `old_sid` int(11) NOT NULL COMMENT '旧技能id',
  `new_sid` int(11) NOT NULL COMMENT '新技能id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=513 DEFAULT CHARSET=utf8 COMMENT='坐骑技能日志';

-- ----------------------------
--  Table structure for `log_mount_spirit`
-- ----------------------------
DROP TABLE IF EXISTS `log_mount_spirit`;
CREATE TABLE `log_mount_spirit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COMMENT='坐骑灵脉日志';

-- ----------------------------
--  Table structure for `log_mount_stage`
-- ----------------------------
DROP TABLE IF EXISTS `log_mount_stage`;
CREATE TABLE `log_mount_stage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `stage` int(11) NOT NULL COMMENT '新阶数',
  `old_stage` int(11) NOT NULL COMMENT '旧阶数',
  `exp` int(11) NOT NULL COMMENT '当前经验',
  `old_exp` int(11) NOT NULL COMMENT '旧经验',
  `time` int(11) NOT NULL COMMENT '时间戳',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型0正常1清零',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=24773 DEFAULT CHARSET=utf8 COMMENT='坐骑升阶日志';

-- ----------------------------
--  Table structure for `log_mount_star`
-- ----------------------------
DROP TABLE IF EXISTS `log_mount_star`;
CREATE TABLE `log_mount_star` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `mount_id` int(11) NOT NULL COMMENT '坐骑id',
  `star` int(11) NOT NULL COMMENT '星级',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=347 DEFAULT CHARSET=utf8 COMMENT='坐骑图鉴日志';

-- ----------------------------
--  Table structure for `log_new_free_gift`
-- ----------------------------
DROP TABLE IF EXISTS `log_new_free_gift`;
CREATE TABLE `log_new_free_gift` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL,
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '档次',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='新零元礼包日志';

-- ----------------------------
--  Table structure for `log_new_shop`
-- ----------------------------
DROP TABLE IF EXISTS `log_new_shop`;
CREATE TABLE `log_new_shop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '0' COMMENT '玩家名称',
  `cost_type` varchar(150) NOT NULL DEFAULT '0' COMMENT '消耗类型',
  `cost` int(11) NOT NULL DEFAULT '0' COMMENT '消耗',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '物品id',
  `goods_num` int(11) NOT NULL DEFAULT '0' COMMENT '物品数量',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE,
  KEY `cost_type` (`cost_type`) USING BTREE,
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=806 DEFAULT CHARSET=utf8 COMMENT='商店购买日志';

-- ----------------------------
--  Table structure for `log_one_gold_buy`
-- ----------------------------
DROP TABLE IF EXISTS `log_one_gold_buy`;
CREATE TABLE `log_one_gold_buy` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_num` int(10) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `cost` int(10) NOT NULL DEFAULT '0' COMMENT '消耗元宝',
  `buy_num` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `key2` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='一元抢购活动日志';

-- ----------------------------
--  Table structure for `log_one_gold_buy_back`
-- ----------------------------
DROP TABLE IF EXISTS `log_one_gold_buy_back`;
CREATE TABLE `log_one_gold_buy_back` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_num` int(10) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `back_gold` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `key1` (`pkey`) USING BTREE,
  KEY `key2` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='一元购买活动返还日志';

-- ----------------------------
--  Table structure for `log_one_gold_buy_goods`
-- ----------------------------
DROP TABLE IF EXISTS `log_one_gold_buy_goods`;
CREATE TABLE `log_one_gold_buy_goods` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_num` int(10) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `goods_num` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `key1` (`pkey`) USING BTREE,
  KEY `key2` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='一元购买活动中奖日志';

-- ----------------------------
--  Table structure for `log_online_reward`
-- ----------------------------
DROP TABLE IF EXISTS `log_online_reward`;
CREATE TABLE `log_online_reward` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) NOT NULL COMMENT '玩家ID',
  `nickname` varchar(50) NOT NULL COMMENT '玩家名字',
  `goods_list` text COMMENT '物品列表',
  `time` int(11) DEFAULT '0' COMMENT '领取时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8 COMMENT='在线有礼日志';

-- ----------------------------
--  Table structure for `log_open_gift`
-- ----------------------------
DROP TABLE IF EXISTS `log_open_gift`;
CREATE TABLE `log_open_gift` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '玩家等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `goods_list` text NOT NULL COMMENT '物品列表',
  `gift_id` int(11) NOT NULL DEFAULT '0' COMMENT '礼包id',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=58823 DEFAULT CHARSET=utf8 COMMENT='礼包开启日志';

-- ----------------------------
--  Table structure for `log_party`
-- ----------------------------
DROP TABLE IF EXISTS `log_party`;
CREATE TABLE `log_party` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) NOT NULL COMMENT '玩家ID',
  `nickname` varchar(500) NOT NULL COMMENT '玩家名字',
  `lv` smallint(6) NOT NULL DEFAULT '0' COMMENT '玩家等级',
  `desc` varchar(500) NOT NULL COMMENT '描述',
  `app_time_string` varchar(500) NOT NULL COMMENT '预约时间',
  `app_time` int(11) NOT NULL DEFAULT '0' COMMENT '预约时间戳',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '操作时间',
  `type` varchar(500) NOT NULL DEFAULT '绑定元宝' COMMENT '消耗类型',
  `price` int(11) NOT NULL DEFAULT '0' COMMENT '价格',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 COMMENT='宴会日志';

-- ----------------------------
--  Table structure for `log_party_reward`
-- ----------------------------
DROP TABLE IF EXISTS `log_party_reward`;
CREATE TABLE `log_party_reward` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `type` int(11) DEFAULT '0' COMMENT '晚宴类型',
  `count` int(11) DEFAULT '0' COMMENT '参与人数',
  `goods_list` text COMMENT '物品',
  `time` int(10) DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='晚宴主人奖励日志';

-- ----------------------------
--  Table structure for `log_pet`
-- ----------------------------
DROP TABLE IF EXISTS `log_pet`;
CREATE TABLE `log_pet` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型1增加2删除',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家昵称',
  `petkey` bigint(22) DEFAULT '0' COMMENT '宠物id',
  `ptypeid` int(10) DEFAULT '0' COMMENT '宠物类型id',
  `pname` varchar(50) DEFAULT NULL COMMENT '宠物名称',
  `time` int(10) DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `name` (`nickname`) USING BTREE,
  KEY `time` (`time`),
  KEY `petkey` (`petkey`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3577 DEFAULT CHARSET=utf8 COMMENT='宠物创建日志';

-- ----------------------------
--  Table structure for `log_pet_figure`
-- ----------------------------
DROP TABLE IF EXISTS `log_pet_figure`;
CREATE TABLE `log_pet_figure` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(100) NOT NULL DEFAULT '' COMMENT '昵称',
  `figure_old` int(11) NOT NULL COMMENT '形象id_旧',
  `figure_new` int(11) NOT NULL COMMENT '新形象id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COMMENT='宠物幻化日志';

-- ----------------------------
--  Table structure for `log_pet_pic`
-- ----------------------------
DROP TABLE IF EXISTS `log_pet_pic`;
CREATE TABLE `log_pet_pic` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(100) NOT NULL DEFAULT '' COMMENT '昵称',
  `figure_id` int(11) NOT NULL COMMENT '形象id',
  `lv` int(11) NOT NULL COMMENT '等级',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8 COMMENT='宠物图鉴日志';

-- ----------------------------
--  Table structure for `log_pet_rank`
-- ----------------------------
DROP TABLE IF EXISTS `log_pet_rank`;
CREATE TABLE `log_pet_rank` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家昵称',
  `petkey` bigint(22) DEFAULT '0' COMMENT '宠物ID',
  `pet_name` varchar(50) DEFAULT NULL COMMENT '宠物名称',
  `pet_combatpower` int(10) DEFAULT '0' COMMENT '战斗力',
  `rank` int(10) DEFAULT '0' COMMENT '排行',
  `time` int(10) DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `name` (`nickname`) USING BTREE,
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='宠物排行榜日志';

-- ----------------------------
--  Table structure for `log_pet_round_dun_saodang`
-- ----------------------------
DROP TABLE IF EXISTS `log_pet_round_dun_saodang`;
CREATE TABLE `log_pet_round_dun_saodang` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `dun_id` int(10) NOT NULL DEFAULT '0',
  `chapter` int(10) NOT NULL DEFAULT '0',
  `saodang` int(10) NOT NULL DEFAULT '0',
  `reward` varchar(200) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COMMENT='宠物对战扫荡奖励';

-- ----------------------------
--  Table structure for `log_pet_round_dun_star`
-- ----------------------------
DROP TABLE IF EXISTS `log_pet_round_dun_star`;
CREATE TABLE `log_pet_round_dun_star` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `chapter` int(2) NOT NULL DEFAULT '0',
  `recv_star` int(10) NOT NULL DEFAULT '0',
  `reward` varchar(200) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8 COMMENT='宠物对战星数奖励';

-- ----------------------------
--  Table structure for `log_pet_round_dungeon`
-- ----------------------------
DROP TABLE IF EXISTS `log_pet_round_dungeon`;
CREATE TABLE `log_pet_round_dungeon` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `dun_id` int(10) NOT NULL DEFAULT '0',
  `ret` int(1) NOT NULL DEFAULT '0',
  `chapter` int(10) NOT NULL DEFAULT '0',
  `first_pass_reward` varchar(200) NOT NULL DEFAULT '[]',
  `daily_pass_reward` varchar(200) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=384 DEFAULT CHARSET=utf8 COMMENT='宠物对战';

-- ----------------------------
--  Table structure for `log_pet_skill`
-- ----------------------------
DROP TABLE IF EXISTS `log_pet_skill`;
CREATE TABLE `log_pet_skill` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家昵称',
  `petkey` bigint(22) DEFAULT '0' COMMENT '宠物id',
  `ptypeid` int(10) DEFAULT '0' COMMENT '宠物类型id',
  `pname` varchar(50) DEFAULT NULL COMMENT '宠物名称',
  `old_skill` text COMMENT '旧技能列表',
  `new_skill` text COMMENT '新技能列表',
  `time` int(10) DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `petkey` (`petkey`) USING BTREE,
  KEY `name` (`nickname`) USING BTREE,
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8 COMMENT='宠物学习技能日志';

-- ----------------------------
--  Table structure for `log_pet_stage`
-- ----------------------------
DROP TABLE IF EXISTS `log_pet_stage`;
CREATE TABLE `log_pet_stage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `stage` int(11) NOT NULL COMMENT '阶数',
  `lv` int(11) NOT NULL COMMENT '等级',
  `exp` int(11) NOT NULL COMMENT '经验',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=7669 DEFAULT CHARSET=utf8 COMMENT='宠物光环日志';

-- ----------------------------
--  Table structure for `log_pet_star`
-- ----------------------------
DROP TABLE IF EXISTS `log_pet_star`;
CREATE TABLE `log_pet_star` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `pet_key` bigint(11) NOT NULL COMMENT '宠物key',
  `pet_type_id` int(11) NOT NULL COMMENT '宠物类型id',
  `pet_name` varchar(50) NOT NULL DEFAULT '' COMMENT '提升前的类型id',
  `star` int(11) NOT NULL COMMENT '星级',
  `exp` int(11) NOT NULL COMMENT '经验',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=418 DEFAULT CHARSET=utf8 COMMENT='宠物升星日志';

-- ----------------------------
--  Table structure for `log_pet_weapon_equip`
-- ----------------------------
DROP TABLE IF EXISTS `log_pet_weapon_equip`;
CREATE TABLE `log_pet_weapon_equip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `subtype` smallint(4) NOT NULL COMMENT '部位',
  `old_gid` int(11) NOT NULL COMMENT '旧装备id',
  `new_gid` int(11) NOT NULL COMMENT '新装备id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COMMENT='妖灵装备日志';

-- ----------------------------
--  Table structure for `log_pet_weapon_skill`
-- ----------------------------
DROP TABLE IF EXISTS `log_pet_weapon_skill`;
CREATE TABLE `log_pet_weapon_skill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `cell` tinyint(1) NOT NULL COMMENT '格子',
  `old_sid` int(11) NOT NULL COMMENT '旧技能id',
  `new_sid` int(11) NOT NULL COMMENT '新技能id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=235 DEFAULT CHARSET=utf8 COMMENT='妖灵技能日志';

-- ----------------------------
--  Table structure for `log_pet_weapon_spirit`
-- ----------------------------
DROP TABLE IF EXISTS `log_pet_weapon_spirit`;
CREATE TABLE `log_pet_weapon_spirit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8 COMMENT='妖灵灵脉日志';

-- ----------------------------
--  Table structure for `log_pet_weapon_stage`
-- ----------------------------
DROP TABLE IF EXISTS `log_pet_weapon_stage`;
CREATE TABLE `log_pet_weapon_stage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `stage` int(11) NOT NULL COMMENT '新阶数',
  `old_stage` int(11) NOT NULL COMMENT '旧阶数',
  `exp` int(11) NOT NULL COMMENT '当前经验',
  `old_exp` int(11) NOT NULL COMMENT '旧经验',
  `time` int(11) NOT NULL COMMENT '时间戳',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型0正常1清零',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=7307 DEFAULT CHARSET=utf8 COMMENT='妖灵升阶日志';

-- ----------------------------
--  Table structure for `log_player_chivalry`
-- ----------------------------
DROP TABLE IF EXISTS `log_player_chivalry`;
CREATE TABLE `log_player_chivalry` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT NULL COMMENT '玩家key',
  `pname` varchar(500) DEFAULT NULL COMMENT '玩家名字',
  `old_evil` int(11) DEFAULT NULL COMMENT '变更前',
  `new_evil` int(11) DEFAULT NULL COMMENT '变更后',
  `time` int(11) DEFAULT NULL COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `log_player_evil`
-- ----------------------------
DROP TABLE IF EXISTS `log_player_evil`;
CREATE TABLE `log_player_evil` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT NULL COMMENT '玩家key',
  `pname` varchar(500) DEFAULT NULL COMMENT '玩家名字',
  `old_evil` int(11) DEFAULT NULL COMMENT '变更前',
  `new_evil` int(11) DEFAULT NULL COMMENT '变更后',
  `time` int(11) DEFAULT NULL COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `log_present_fashion`
-- ----------------------------
DROP TABLE IF EXISTS `log_present_fashion`;
CREATE TABLE `log_present_fashion` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey1` int(11) NOT NULL DEFAULT '0' COMMENT '赠送者id',
  `nickname1` varchar(100) NOT NULL DEFAULT '' COMMENT '赠送者名称',
  `pkey2` int(11) NOT NULL DEFAULT '0' COMMENT '收到者id',
  `nickname2` varchar(100) NOT NULL DEFAULT '' COMMENT '收到者名称',
  `present_time` int(11) NOT NULL DEFAULT '0' COMMENT '赠送时间',
  `fashion_id` int(11) NOT NULL DEFAULT '0' COMMENT '时装id',
  `fashion_name` varchar(100) NOT NULL DEFAULT '' COMMENT '时装名称',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `log_random_market`
-- ----------------------------
DROP TABLE IF EXISTS `log_random_market`;
CREATE TABLE `log_random_market` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '玩家名字',
  `type` int(1) NOT NULL DEFAULT '0' COMMENT '商店类型 1神秘商店 2黑店 3熔炼商店 4竞技商店',
  `goods_id` int(1) NOT NULL DEFAULT '0' COMMENT '购买的物品id',
  `goods_attr` varchar(100) NOT NULL DEFAULT '' COMMENT '购买物品的洗练镶嵌属性',
  `gold` int(1) NOT NULL DEFAULT '0' COMMENT '钻石数量',
  `money` int(1) NOT NULL DEFAULT '0' COMMENT '其他相应货币的数量',
  `time` int(1) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `pname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='随机商店日志表';

-- ----------------------------
--  Table structure for `log_rank`
-- ----------------------------
DROP TABLE IF EXISTS `log_rank`;
CREATE TABLE `log_rank` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `type` int(10) DEFAULT '0' COMMENT '榜类型',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家昵称',
  `rank_data` int(10) DEFAULT '0' COMMENT '排行数值',
  `rank` int(10) DEFAULT '0' COMMENT '排行',
  `time` int(10) DEFAULT '0' COMMENT '时间戳',
  `sex` tinyint(11) DEFAULT '0' COMMENT '性别',
  `lv` int(11) DEFAULT '0' COMMENT '等级',
  `vip` tinyint(11) DEFAULT '0' COMMENT 'vip',
  `guild_key` bigint(22) DEFAULT '0' COMMENT '公会key',
  `guild_name` varchar(50) DEFAULT NULL COMMENT '公会名称',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `name` (`nickname`) USING BTREE,
  KEY `type_key` (`type`,`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15727546 DEFAULT CHARSET=utf8 COMMENT='排行榜日志';

-- ----------------------------
--  Table structure for `log_re_recharge_inf`
-- ----------------------------
DROP TABLE IF EXISTS `log_re_recharge_inf`;
CREATE TABLE `log_re_recharge_inf` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) NOT NULL COMMENT '玩家ID',
  `nickname` varchar(50) NOT NULL COMMENT '玩家名字',
  `goods_list` text COMMENT '物品列表',
  `time` int(11) DEFAULT '0' COMMENT '领取时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=207 DEFAULT CHARSET=utf8 COMMENT='充值有礼日志';

-- ----------------------------
--  Table structure for `log_recharge_inf`
-- ----------------------------
DROP TABLE IF EXISTS `log_recharge_inf`;
CREATE TABLE `log_recharge_inf` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) NOT NULL COMMENT '玩家ID',
  `nickname` varchar(50) NOT NULL COMMENT '玩家名字',
  `goods_list` text COMMENT '物品列表',
  `time` int(11) DEFAULT '0' COMMENT '领取时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8 COMMENT='充值有礼日志';

-- ----------------------------
--  Table structure for `log_role_attr_dan`
-- ----------------------------
DROP TABLE IF EXISTS `log_role_attr_dan`;
CREATE TABLE `log_role_attr_dan` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT NULL COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家名字',
  `type` int(11) DEFAULT NULL COMMENT '类型',
  `num_id` int(11) DEFAULT NULL COMMENT '编号id',
  `goods_id` int(11) DEFAULT NULL COMMENT '物品id',
  `use_count` int(11) DEFAULT NULL COMMENT '使用数量',
  `time` int(11) DEFAULT NULL COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8 COMMENT='玩家属性丹日志';

-- ----------------------------
--  Table structure for `log_sell_equip`
-- ----------------------------
DROP TABLE IF EXISTS `log_sell_equip`;
CREATE TABLE `log_sell_equip` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `nickname` varchar(50) NOT NULL DEFAULT '""',
  `goods_id` int(10) NOT NULL DEFAULT '0' COMMENT '炫装配置ID',
  `goods_desc` varchar(50) NOT NULL DEFAULT '""' COMMENT '物品描述',
  `cost` int(10) NOT NULL DEFAULT '0' COMMENT '花费元宝',
  `time` int(10) NOT NULL DEFAULT '0' COMMENT '购买时间',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='特权炫装日志';

-- ----------------------------
--  Table structure for `log_sign_in`
-- ----------------------------
DROP TABLE IF EXISTS `log_sign_in`;
CREATE TABLE `log_sign_in` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `type` tinyint(1) NOT NULL COMMENT '类型1签到，2累签奖励',
  `day` int(11) NOT NULL COMMENT '天数',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=315 DEFAULT CHARSET=utf8 COMMENT='签到日志';

-- ----------------------------
--  Table structure for `log_small_charge_d`
-- ----------------------------
DROP TABLE IF EXISTS `log_small_charge_d`;
CREATE TABLE `log_small_charge_d` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `recv_list` varchar(200) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='小额充值日志';

-- ----------------------------
--  Table structure for `log_smelt`
-- ----------------------------
DROP TABLE IF EXISTS `log_smelt`;
CREATE TABLE `log_smelt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `lv` int(11) NOT NULL COMMENT '等级',
  `exp` int(11) NOT NULL COMMENT '经验',
  `time` int(11) NOT NULL COMMENT '时间戳',
  `equip_part` int(11) NOT NULL DEFAULT '0' COMMENT '装备碎片',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=184 DEFAULT CHARSET=utf8 COMMENT='熔炼日志';

-- ----------------------------
--  Table structure for `log_star_luck`
-- ----------------------------
DROP TABLE IF EXISTS `log_star_luck`;
CREATE TABLE `log_star_luck` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) DEFAULT '0' COMMENT '玩家ID',
  `nickname` varchar(50) DEFAULT NULL COMMENT '玩家昵称',
  `star_luck_key` bigint(22) DEFAULT '0' COMMENT '主星运key',
  `star_luck_id` int(10) DEFAULT '0' COMMENT '星运类型id',
  `star_luck_name` varchar(50) DEFAULT NULL COMMENT '主星运名字',
  `lv` int(10) DEFAULT '0' COMMENT '星运等级',
  `exp` int(10) DEFAULT '0' COMMENT '星运经验',
  `type` tinyint(5) DEFAULT '0' COMMENT '操作 1合成2吞噬3占星',
  `star_luck_key2` bigint(22) DEFAULT '0' COMMENT '被合成/吞噬的星运key',
  `star_luck_id2` int(10) DEFAULT '0' COMMENT '星运类型id',
  `star_luck_name2` varchar(50) DEFAULT NULL COMMENT '星运名字',
  `lv2` int(10) DEFAULT '0' COMMENT '星运等级',
  `exp2` int(10) DEFAULT '0' COMMENT '星运经验',
  `time` int(10) DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `key` (`pkey`) USING BTREE,
  KEY `star_luck_key` (`star_luck_key`) USING BTREE,
  KEY `star_luck_key2` (`star_luck_key2`) USING BTREE,
  KEY `name` (`nickname`) USING BTREE,
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='宠物升星日志';

-- ----------------------------
--  Table structure for `log_sword_pool`
-- ----------------------------
DROP TABLE IF EXISTS `log_sword_pool`;
CREATE TABLE `log_sword_pool` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `type` int(11) NOT NULL COMMENT '类型1升级2每日奖励，3找回',
  `lv` int(11) NOT NULL COMMENT '等级',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=591 DEFAULT CHARSET=utf8 COMMENT='剑池日志';

-- ----------------------------
--  Table structure for `log_taobao`
-- ----------------------------
DROP TABLE IF EXISTS `log_taobao`;
CREATE TABLE `log_taobao` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '玩家名字',
  `type` int(1) NOT NULL DEFAULT '0' COMMENT '淘宝类型',
  `cost_money` int(1) NOT NULL DEFAULT '0' COMMENT '购买的物品id',
  `get_goods` varchar(1200) NOT NULL DEFAULT '' COMMENT '本次获得物品',
  `time` int(1) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `pname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='淘宝日志表';

-- ----------------------------
--  Table structure for `log_throw_egg`
-- ----------------------------
DROP TABLE IF EXISTS `log_throw_egg`;
CREATE TABLE `log_throw_egg` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) NOT NULL COMMENT '玩家ID',
  `nickname` varchar(50) NOT NULL COMMENT '玩家名字',
  `gold` int(11) DEFAULT NULL COMMENT '消耗元宝',
  `time` int(11) DEFAULT '0' COMMENT '领取时间',
  `goods_list` text COMMENT '物品列表',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=583 DEFAULT CHARSET=utf8 COMMENT='疯狂砸蛋日志';

-- ----------------------------
--  Table structure for `log_throw_egg_count`
-- ----------------------------
DROP TABLE IF EXISTS `log_throw_egg_count`;
CREATE TABLE `log_throw_egg_count` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) NOT NULL COMMENT '玩家ID',
  `nickname` varchar(50) NOT NULL COMMENT '玩家名字',
  `count` int(11) DEFAULT NULL COMMENT '消耗元宝',
  `time` int(11) DEFAULT '0' COMMENT '领取时间',
  `goods_list` text COMMENT '物品列表',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COMMENT='疯狂砸蛋次数奖励日志';

-- ----------------------------
--  Table structure for `log_throw_fruit`
-- ----------------------------
DROP TABLE IF EXISTS `log_throw_fruit`;
CREATE TABLE `log_throw_fruit` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) NOT NULL COMMENT '玩家ID',
  `nickname` varchar(500) NOT NULL COMMENT '玩家名字',
  `gold` int(11) DEFAULT NULL COMMENT '消耗元宝',
  `time` int(11) DEFAULT '0' COMMENT '领取时间',
  `goods_list` text COMMENT '物品列表',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8 COMMENT='水果大战日志';

-- ----------------------------
--  Table structure for `log_throw_fruit_count`
-- ----------------------------
DROP TABLE IF EXISTS `log_throw_fruit_count`;
CREATE TABLE `log_throw_fruit_count` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pkey` int(11) NOT NULL COMMENT '玩家ID',
  `nickname` varchar(50) NOT NULL COMMENT '玩家名字',
  `count` int(11) DEFAULT NULL COMMENT '次数',
  `time` int(11) DEFAULT '0' COMMENT '领取时间',
  `goods_list` text COMMENT '物品列表',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='水果大战次数日志';

-- ----------------------------
--  Table structure for `log_treasure`
-- ----------------------------
DROP TABLE IF EXISTS `log_treasure`;
CREATE TABLE `log_treasure` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '玩家昵称',
  `map_id` int(11) NOT NULL DEFAULT '0' COMMENT '宝藏ID',
  `act` tinyint(1) NOT NULL DEFAULT '0' COMMENT '挖宝类型',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='寻宝';

-- ----------------------------
--  Table structure for `log_treasure_hourse`
-- ----------------------------
DROP TABLE IF EXISTS `log_treasure_hourse`;
CREATE TABLE `log_treasure_hourse` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_day` int(10) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `goods_num` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1053 DEFAULT CHARSET=utf8 COMMENT='藏宝阁';

-- ----------------------------
--  Table structure for `log_war_team`
-- ----------------------------
DROP TABLE IF EXISTS `log_war_team`;
CREATE TABLE `log_war_team` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wtkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '战队KEY',
  `wtname` varchar(50) NOT NULL DEFAULT '0' COMMENT '战队昵称',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '玩家name',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型（1创建，2解散）',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `wtkey` (`wtkey`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='战队操作日志';

-- ----------------------------
--  Table structure for `log_wash_replace`
-- ----------------------------
DROP TABLE IF EXISTS `log_wash_replace`;
CREATE TABLE `log_wash_replace` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `weapon_id` int(11) NOT NULL DEFAULT '0' COMMENT '神器id',
  `wash_list` text NOT NULL COMMENT '替换属性',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=198 DEFAULT CHARSET=utf8 COMMENT='神器洗练替换日志';

-- ----------------------------
--  Table structure for `log_wash_weapon`
-- ----------------------------
DROP TABLE IF EXISTS `log_wash_weapon`;
CREATE TABLE `log_wash_weapon` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `weapon_id` int(11) NOT NULL DEFAULT '0' COMMENT '神器id',
  `bgold` int(11) NOT NULL DEFAULT '0' COMMENT '绑元',
  `goods_cost` int(11) NOT NULL DEFAULT '0' COMMENT '物品',
  `coin_cost` int(11) NOT NULL DEFAULT '0' COMMENT '银币',
  `old_wash` text NOT NULL COMMENT '原属性',
  `new_wash` text NOT NULL COMMENT '新属性',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1705 DEFAULT CHARSET=utf8 COMMENT='神器洗练日志';

-- ----------------------------
--  Table structure for `log_wing_equip`
-- ----------------------------
DROP TABLE IF EXISTS `log_wing_equip`;
CREATE TABLE `log_wing_equip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `subtype` smallint(4) NOT NULL COMMENT '部位',
  `old_gid` int(11) NOT NULL COMMENT '旧装备id',
  `new_gid` int(11) NOT NULL COMMENT '新装备id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='翅膀装备日志';

-- ----------------------------
--  Table structure for `log_wing_skill`
-- ----------------------------
DROP TABLE IF EXISTS `log_wing_skill`;
CREATE TABLE `log_wing_skill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `cell` tinyint(1) NOT NULL COMMENT '格子',
  `old_sid` int(11) NOT NULL COMMENT '旧技能id',
  `new_sid` int(11) NOT NULL COMMENT '新技能id',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8 COMMENT='翅膀技能日志';

-- ----------------------------
--  Table structure for `log_wing_spirit`
-- ----------------------------
DROP TABLE IF EXISTS `log_wing_spirit`;
CREATE TABLE `log_wing_spirit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=226 DEFAULT CHARSET=utf8 COMMENT='翅膀灵脉日志';

-- ----------------------------
--  Table structure for `log_wing_stage`
-- ----------------------------
DROP TABLE IF EXISTS `log_wing_stage`;
CREATE TABLE `log_wing_stage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `stage` int(11) NOT NULL COMMENT '新阶数',
  `old_stage` int(11) NOT NULL COMMENT '旧阶数',
  `exp` int(11) NOT NULL COMMENT '当前经验',
  `old_exp` int(11) NOT NULL COMMENT '旧经验',
  `time` int(11) NOT NULL COMMENT '时间戳',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型0正常1清零',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8 COMMENT='翅膀升阶日志';

-- ----------------------------
--  Table structure for `log_wing_star`
-- ----------------------------
DROP TABLE IF EXISTS `log_wing_star`;
CREATE TABLE `log_wing_star` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `wing_id` int(11) NOT NULL COMMENT '翅膀id',
  `star` int(11) NOT NULL COMMENT '星级',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`),
  KEY `nickname` (`nickname`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=204 DEFAULT CHARSET=utf8 COMMENT='翅膀图鉴日志';

-- ----------------------------
--  Table structure for `log_xian_attr_swap`
-- ----------------------------
DROP TABLE IF EXISTS `log_xian_attr_swap`;
CREATE TABLE `log_xian_attr_swap` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `goods_key1` bigint(22) NOT NULL DEFAULT '0',
  `goods_id1` int(10) NOT NULL DEFAULT '0',
  `goods_key2` bigint(22) NOT NULL DEFAULT '0',
  `goods_id2` int(10) NOT NULL DEFAULT '0',
  `old_attr_list1` text NOT NULL,
  `attr_list1` text NOT NULL,
  `old_attr_list2` text NOT NULL,
  `attr_list2` text NOT NULL,
  `cost` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=337 DEFAULT CHARSET=utf8 COMMENT='仙装属性交换';

-- ----------------------------
--  Table structure for `log_xian_map`
-- ----------------------------
DROP TABLE IF EXISTS `log_xian_map`;
CREATE TABLE `log_xian_map` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `type` int(1) NOT NULL DEFAULT '0',
  `list` varchar(1024) NOT NULL DEFAULT '[]',
  `reward` varchar(1024) NOT NULL DEFAULT '[]',
  `cost` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=860 DEFAULT CHARSET=utf8 COMMENT='仙装寻宝';

-- ----------------------------
--  Table structure for `log_xian_skill_upgrade`
-- ----------------------------
DROP TABLE IF EXISTS `log_xian_skill_upgrade`;
CREATE TABLE `log_xian_skill_upgrade` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `subtype` int(10) NOT NULL DEFAULT '0',
  `befor_lv` int(10) NOT NULL DEFAULT '0',
  `after_lv` int(10) NOT NULL DEFAULT '0',
  `consume` varchar(1024) NOT NULL DEFAULT '[]',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='飞仙技能觉醒';

-- ----------------------------
--  Table structure for `log_xian_upgrade`
-- ----------------------------
DROP TABLE IF EXISTS `log_xian_upgrade`;
CREATE TABLE `log_xian_upgrade` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `stage` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COMMENT='仙装进阶';

-- ----------------------------
--  Table structure for `log_xianzhuang_put_on`
-- ----------------------------
DROP TABLE IF EXISTS `log_xianzhuang_put_on`;
CREATE TABLE `log_xianzhuang_put_on` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL,
  `goods_id` int(10) NOT NULL DEFAULT '0' COMMENT '上阵仙装',
  `goods_key` bigint(22) NOT NULL DEFAULT '0' COMMENT '上阵仙装唯一key',
  `goods_lv` int(3) NOT NULL DEFAULT '0' COMMENT '上阵仙装等级',
  `color` int(1) NOT NULL DEFAULT '0',
  `star` int(1) NOT NULL DEFAULT '0',
  `pos` int(1) NOT NULL DEFAULT '0' COMMENT '上阵部位',
  `old_goods_id` int(10) NOT NULL,
  `old_goods_key` bigint(22) NOT NULL,
  `old_goods_lv` int(3) NOT NULL,
  `old_color` int(1) NOT NULL,
  `old_star` int(1) NOT NULL,
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8 COMMENT='仙装替换日志';

-- ----------------------------
--  Table structure for `log_xianzhuang_resolved`
-- ----------------------------
DROP TABLE IF EXISTS `log_xianzhuang_resolved`;
CREATE TABLE `log_xianzhuang_resolved` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL,
  `goods_id` int(10) NOT NULL,
  `goods_key` bigint(22) NOT NULL,
  `goods_lv` int(3) NOT NULL,
  `color` int(1) NOT NULL,
  `star` int(1) NOT NULL,
  `xianyu` int(10) NOT NULL,
  `time` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3829 DEFAULT CHARSET=utf8 COMMENT='仙装分解';

-- ----------------------------
--  Table structure for `log_xianzhuang_upgrade`
-- ----------------------------
DROP TABLE IF EXISTS `log_xianzhuang_upgrade`;
CREATE TABLE `log_xianzhuang_upgrade` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pkey` int(10) NOT NULL DEFAULT '0',
  `goods_key` bigint(22) NOT NULL DEFAULT '0',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `color` int(1) NOT NULL DEFAULT '0',
  `star` int(1) NOT NULL DEFAULT '0',
  `befor_lv` int(3) NOT NULL DEFAULT '0',
  `befor_exp` int(10) NOT NULL DEFAULT '0',
  `cost` int(10) NOT NULL DEFAULT '0',
  `cost_gold` int(10) NOT NULL DEFAULT '0',
  `after_lv` int(3) NOT NULL DEFAULT '0',
  `after_exp` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pkey` (`pkey`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2039 DEFAULT CHARSET=utf8 COMMENT='仙装进阶日志';

-- ----------------------------
--  Table structure for `magic_weapon`
-- ----------------------------
DROP TABLE IF EXISTS `magic_weapon`;
CREATE TABLE `magic_weapon` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `stage` int(11) NOT NULL COMMENT '阶数',
  `exp` int(11) NOT NULL COMMENT '经验',
  `bless_cd` int(11) NOT NULL COMMENT '祝福CD',
  `weapon_id` int(11) NOT NULL COMMENT '形象',
  `skill_list` text NOT NULL COMMENT '技能列表',
  `equip_list` varchar(500) NOT NULL DEFAULT '[]' COMMENT '装备列表',
  `grow_num` int(11) NOT NULL DEFAULT '0' COMMENT '成长丹数量',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战力',
  `attribute` text NOT NULL COMMENT '属性列表',
  `spirit_list` text NOT NULL COMMENT '灵脉列表',
  `last_spirit` int(11) NOT NULL DEFAULT '0' COMMENT '上一次提升的灵脉',
  `spirit` int(11) NOT NULL DEFAULT '0' COMMENT '灵力值',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='法宝';

-- ----------------------------
--  Table structure for `mail`
-- ----------------------------
DROP TABLE IF EXISTS `mail`;
CREATE TABLE `mail` (
  `mkey` bigint(22) NOT NULL COMMENT 'key',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '邮件类型',
  `goodslist` text NOT NULL COMMENT '物品列表[{goodstype,bind,num}]',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '邮件标题',
  `content` varchar(500) NOT NULL DEFAULT '' COMMENT '内容',
  `time` int(10) NOT NULL DEFAULT '0' COMMENT '邮件时间',
  `state` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1未读1已读',
  `overtime` int(11) NOT NULL DEFAULT '0' COMMENT '有效期',
  PRIMARY KEY (`mkey`),
  KEY `time` (`time`) USING BTREE,
  KEY `pid` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='邮件';

-- ----------------------------
--  Table structure for `mail_adm`
-- ----------------------------
DROP TABLE IF EXISTS `mail_adm`;
CREATE TABLE `mail_adm` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `gm_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '中央服全服邮件ID',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '邮件类型0全服1指定玩家',
  `players` text NOT NULL COMMENT '玩家列表',
  `title` varchar(20) DEFAULT '' COMMENT '标题',
  `content` varchar(200) NOT NULL COMMENT '邮件内容',
  `reason` varchar(50) NOT NULL DEFAULT '' COMMENT '添加物品附件原因',
  `goodslist` text NOT NULL COMMENT '物品列表',
  `time` int(11) DEFAULT NULL COMMENT '时间戳',
  `user` varchar(50) NOT NULL COMMENT '操作者',
  `state` int(10) NOT NULL COMMENT '状态0未审核1发送中2发送完毕',
  `lv_s` int(11) DEFAULT '0' COMMENT '开始等级',
  `lv_e` int(11) DEFAULT '0' COMMENT '结束等级',
  `reg_time_s` int(11) DEFAULT '0' COMMENT '注册时间',
  `reg_time_e` int(11) DEFAULT '0' COMMENT '注册时间',
  `login_time_s` int(11) DEFAULT '0' COMMENT '登陆时间',
  `login_time_e` int(11) DEFAULT '0' COMMENT '登陆时间',
  `game_channel_id` int(11) DEFAULT '0' COMMENT '渠道ID',
  `send_time` int(11) DEFAULT '0' COMMENT '发送时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='管理员邮件记录';

-- ----------------------------
--  Table structure for `manor`
-- ----------------------------
DROP TABLE IF EXISTS `manor`;
CREATE TABLE `manor` (
  `scene_id` mediumint(11) NOT NULL COMMENT '场景id',
  `gkey` bigint(22) NOT NULL COMMENT '公会key',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`scene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='领地战';

-- ----------------------------
--  Table structure for `manor_war`
-- ----------------------------
DROP TABLE IF EXISTS `manor_war`;
CREATE TABLE `manor_war` (
  `gkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '公会key',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '报名时间',
  `scene_list` text NOT NULL COMMENT '占领的场景列表',
  `mb_list` text NOT NULL COMMENT '玩家数据',
  `party_time` int(11) NOT NULL COMMENT '晚宴有效时间',
  `party_lv` int(11) NOT NULL COMMENT '晚宴等级',
  `party_exp` int(11) NOT NULL COMMENT '晚宴经验',
  `party_scene` int(11) NOT NULL COMMENT '晚宴开启场景',
  `party_full` int(11) NOT NULL COMMENT '晚宴饱和度',
  `party_mbs` text NOT NULL COMMENT '贡献列表',
  PRIMARY KEY (`gkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='领地战报名';

-- ----------------------------
--  Table structure for `market`
-- ----------------------------
DROP TABLE IF EXISTS `market`;
CREATE TABLE `market` (
  `mkey` bigint(22) NOT NULL COMMENT '集市key',
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `goods_id` int(1) NOT NULL DEFAULT '0' COMMENT '物品id',
  `num` int(1) NOT NULL DEFAULT '0' COMMENT '数量',
  `price` int(1) NOT NULL DEFAULT '0' COMMENT '价格',
  `tip` int(11) NOT NULL DEFAULT '0' COMMENT '手续费',
  `args` text COMMENT '额外参数',
  `time` int(1) NOT NULL DEFAULT '0' COMMENT '上架时间',
  PRIMARY KEY (`mkey`),
  KEY `index_pkey` (`pkey`) USING BTREE COMMENT '玩家索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='交易所';

-- ----------------------------
--  Table structure for `market_info`
-- ----------------------------
DROP TABLE IF EXISTS `market_info`;
CREATE TABLE `market_info` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `last_time` int(1) NOT NULL DEFAULT '0' COMMENT '时间',
  `times` int(1) NOT NULL DEFAULT '0' COMMENT '次数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家交易所上架时间表';

-- ----------------------------
--  Table structure for `market_trad_record`
-- ----------------------------
DROP TABLE IF EXISTS `market_trad_record`;
CREATE TABLE `market_trad_record` (
  `pkey` int(11) NOT NULL COMMENT '玩家唯一id',
  `sell_record` longtext COMMENT '出售记录',
  `buy_record` longtext COMMENT '购买记录',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家交易记录';

-- ----------------------------
--  Table structure for `marry`
-- ----------------------------
DROP TABLE IF EXISTS `marry`;
CREATE TABLE `marry` (
  `mkey` bigint(22) NOT NULL COMMENT '结婚key',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型',
  `key_boy` int(11) NOT NULL COMMENT '新郎key',
  `key_girl` int(11) NOT NULL COMMENT '新娘key',
  `time` int(10) NOT NULL DEFAULT '0' COMMENT '结婚时间',
  `cruise` int(11) NOT NULL DEFAULT '0' COMMENT '是否已巡游1是0否',
  `heart_lv` varchar(150) NOT NULL DEFAULT '[{0,0},{0,0}]' COMMENT '羁绊等级',
  `ring_lv` varchar(150) NOT NULL DEFAULT '[{0,0},{0,0}]' COMMENT '羁绊等级',
  `cruise_num` int(2) NOT NULL DEFAULT '0' COMMENT '巡游次数',
  PRIMARY KEY (`mkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='结婚信息';

-- ----------------------------
--  Table structure for `marry_cruise`
-- ----------------------------
DROP TABLE IF EXISTS `marry_cruise`;
CREATE TABLE `marry_cruise` (
  `akey` bigint(20) NOT NULL COMMENT '预约key',
  `date` int(11) NOT NULL COMMENT '每日时间戳',
  `time` text NOT NULL COMMENT '预定时间',
  `mkey` bigint(20) NOT NULL COMMENT '婚姻key',
  PRIMARY KEY (`akey`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='巡游时间表';

-- ----------------------------
--  Table structure for `marry_rank`
-- ----------------------------
DROP TABLE IF EXISTS `marry_rank`;
CREATE TABLE `marry_rank` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `bpkey` int(11) NOT NULL DEFAULT '0' COMMENT '男 key',
  `bname` varchar(150) NOT NULL DEFAULT '' COMMENT '男 姓名',
  `bavatar` varchar(150) NOT NULL DEFAULT '' COMMENT '男 姓名',
  `gpkey` int(11) NOT NULL DEFAULT '0' COMMENT '女 key',
  `gname` varchar(150) NOT NULL DEFAULT '' COMMENT '女 姓名',
  `gavatar` varchar(150) NOT NULL DEFAULT '' COMMENT '女 姓名',
  `marry_time` int(11) NOT NULL DEFAULT '0' COMMENT '记录时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='结婚排行榜';

-- ----------------------------
--  Table structure for `merge_act_back_buy`
-- ----------------------------
DROP TABLE IF EXISTS `merge_act_back_buy`;
CREATE TABLE `merge_act_back_buy` (
  `act_id` int(10) NOT NULL DEFAULT '0',
  `id` int(10) NOT NULL DEFAULT '0',
  `total_num` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`act_id`,`id`),
  UNIQUE KEY `key` (`act_id`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='返利限购';

-- ----------------------------
--  Table structure for `merge_info`
-- ----------------------------
DROP TABLE IF EXISTS `merge_info`;
CREATE TABLE `merge_info` (
  `time` int(10) NOT NULL,
  `sn` int(10) DEFAULT '0' COMMENT '服号',
  `times` int(11) NOT NULL DEFAULT '0' COMMENT '合服次数',
  PRIMARY KEY (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='合服日志';

-- ----------------------------
--  Table structure for `merge_mail`
-- ----------------------------
DROP TABLE IF EXISTS `merge_mail`;
CREATE TABLE `merge_mail` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `nickname` varchar(255) DEFAULT '' COMMENT '玩家昵称',
  `goodstype` int(10) DEFAULT '0' COMMENT '物品类型id',
  `state` tinyint(4) DEFAULT '0' COMMENT '0未发送1已发送',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='合服邮件发送';

-- ----------------------------
--  Table structure for `meridian`
-- ----------------------------
DROP TABLE IF EXISTS `meridian`;
CREATE TABLE `meridian` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `meridian_list` text NOT NULL COMMENT '经脉信息列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='经脉';

-- ----------------------------
--  Table structure for `mon_photo`
-- ----------------------------
DROP TABLE IF EXISTS `mon_photo`;
CREATE TABLE `mon_photo` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `photo_list` text NOT NULL COMMENT '图鉴列表',
  `mon_list` text NOT NULL COMMENT '击杀怪物列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='图鉴';

-- ----------------------------
--  Table structure for `mount`
-- ----------------------------
DROP TABLE IF EXISTS `mount`;
CREATE TABLE `mount` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `stage` int(1) NOT NULL DEFAULT '0' COMMENT '阶数',
  `exp` int(1) NOT NULL DEFAULT '0' COMMENT '经验',
  `bless_cd` int(11) NOT NULL DEFAULT '0' COMMENT '祝福CD',
  `current_image_id` int(11) NOT NULL DEFAULT '0' COMMENT '当前坐骑形象',
  `current_sword_id` int(11) NOT NULL DEFAULT '0' COMMENT '当前飞剑形象',
  `old_current_image_id` int(11) NOT NULL DEFAULT '0' COMMENT '幻化前坐骑id',
  `own_special_image` varchar(400) NOT NULL DEFAULT '',
  `star_list` varchar(400) NOT NULL DEFAULT '[]' COMMENT '星等',
  `skill_list` varchar(400) NOT NULL DEFAULT '[]' COMMENT '技能列表',
  `equip_list` varchar(500) NOT NULL DEFAULT '[]' COMMENT '装备列表',
  `grow_num` int(11) NOT NULL DEFAULT '0' COMMENT '成长丹数量',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战力',
  `attribute` text NOT NULL COMMENT '属性列表',
  `spirit_list` text NOT NULL COMMENT '灵脉列表',
  `last_spirit` int(11) NOT NULL DEFAULT '0' COMMENT '上一次提升的灵脉id',
  `spirit` int(11) NOT NULL DEFAULT '0' COMMENT '灵力值',
  `activation_list` text NOT NULL COMMENT '外观激活列表',
  PRIMARY KEY (`pkey`),
  KEY `stage` (`stage`) USING BTREE,
  KEY `exp` (`exp`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='坐骑';

-- ----------------------------
--  Table structure for `one_gold_buy`
-- ----------------------------
DROP TABLE IF EXISTS `one_gold_buy`;
CREATE TABLE `one_gold_buy` (
  `node` varchar(100) NOT NULL DEFAULT '[]',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `act_type` int(10) NOT NULL DEFAULT '0' COMMENT '活动类型索引',
  `act_num` int(10) NOT NULL DEFAULT '0' COMMENT '第几轮',
  `order_id` int(10) NOT NULL DEFAULT '0' COMMENT '货架ID',
  `goods_id` int(10) NOT NULL DEFAULT '0',
  `goods_num` int(10) NOT NULL DEFAULT '0',
  `total_num` int(10) NOT NULL DEFAULT '0',
  `log` varchar(1024) NOT NULL DEFAULT '[]',
  `buy_list` text NOT NULL COMMENT '玩家购买列表',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`node`,`act_id`,`act_num`,`order_id`),
  KEY `key` (`node`,`act_id`) USING BTREE,
  KEY `key2` (`op_time`,`node`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='一元夺宝商品表';

-- ----------------------------
--  Table structure for `online`
-- ----------------------------
DROP TABLE IF EXISTS `online`;
CREATE TABLE `online` (
  `num` int(10) NOT NULL DEFAULT '0' COMMENT '在线人数',
  `time` int(10) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='在线统计表';

-- ----------------------------
--  Table structure for `open_act_all_target`
-- ----------------------------
DROP TABLE IF EXISTS `open_act_all_target`;
CREATE TABLE `open_act_all_target` (
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `act_type` int(1) NOT NULL DEFAULT '0' COMMENT '类型1坐骑,2仙羽,3法宝,4神兵,5灵童,6灵弓,7灵兽',
  `base_lv` int(6) NOT NULL DEFAULT '0' COMMENT '目标阶数',
  `base_num` int(6) NOT NULL DEFAULT '0' COMMENT '目标人数',
  `num` int(6) NOT NULL DEFAULT '0' COMMENT '合格人数',
  UNIQUE KEY `key` (`act_id`,`act_type`,`base_lv`,`base_num`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='全服总动员';

-- ----------------------------
--  Table structure for `open_act_all_target2`
-- ----------------------------
DROP TABLE IF EXISTS `open_act_all_target2`;
CREATE TABLE `open_act_all_target2` (
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `act_type` int(1) NOT NULL DEFAULT '0' COMMENT '类型1坐骑,2仙羽,3法宝,4神兵,5灵童,6灵弓,7灵兽',
  `base_lv` int(6) NOT NULL DEFAULT '0' COMMENT '目标阶数',
  `base_num` int(6) NOT NULL DEFAULT '0' COMMENT '目标人数',
  `num` int(6) NOT NULL DEFAULT '0' COMMENT '合格人数',
  UNIQUE KEY `key` (`act_id`,`act_type`,`base_lv`,`base_num`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='全服总动员2';

-- ----------------------------
--  Table structure for `open_act_all_target3`
-- ----------------------------
DROP TABLE IF EXISTS `open_act_all_target3`;
CREATE TABLE `open_act_all_target3` (
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `act_type` int(1) NOT NULL DEFAULT '0' COMMENT '类型1坐骑,2仙羽,3法宝,4神兵,5灵童,6灵弓,7灵兽',
  `base_lv` int(6) NOT NULL DEFAULT '0' COMMENT '目标阶数',
  `base_num` int(6) NOT NULL DEFAULT '0' COMMENT '目标人数',
  `num` int(6) NOT NULL DEFAULT '0' COMMENT '合格人数',
  UNIQUE KEY `key` (`act_id`,`act_type`,`base_lv`,`base_num`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='全服总动员3';

-- ----------------------------
--  Table structure for `open_act_back_buy`
-- ----------------------------
DROP TABLE IF EXISTS `open_act_back_buy`;
CREATE TABLE `open_act_back_buy` (
  `act_id` int(10) NOT NULL DEFAULT '0',
  `id` int(10) NOT NULL DEFAULT '0',
  `total_num` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`act_id`,`id`),
  UNIQUE KEY `key` (`act_id`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='返利限购';

-- ----------------------------
--  Table structure for `party`
-- ----------------------------
DROP TABLE IF EXISTS `party`;
CREATE TABLE `party` (
  `akey` bigint(20) NOT NULL COMMENT '预约key',
  `date` int(11) NOT NULL COMMENT '每日时间戳',
  `time` int(11) NOT NULL COMMENT '预定时间',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `type` tinyint(1) NOT NULL COMMENT '类型',
  `status` tinyint(1) NOT NULL COMMENT '状态0未举行，1举行',
  `price_type` int(11) NOT NULL COMMENT '价格类型1绑定2非绑元宝',
  `price` int(11) NOT NULL COMMENT '价格',
  PRIMARY KEY (`akey`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='宴席预定时间表';

-- ----------------------------
--  Table structure for `party_state`
-- ----------------------------
DROP TABLE IF EXISTS `party_state`;
CREATE TABLE `party_state` (
  `party_key` bigint(20) NOT NULL COMMENT '晚宴key',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `price_type` int(11) NOT NULL DEFAULT '0' COMMENT '价格类型',
  `price` int(11) NOT NULL DEFAULT '0' COMMENT '价格',
  PRIMARY KEY (`party_key`),
  KEY `pkey` (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='晚宴状态记录';

-- ----------------------------
--  Table structure for `pet`
-- ----------------------------
DROP TABLE IF EXISTS `pet`;
CREATE TABLE `pet` (
  `pet_key` bigint(22) NOT NULL DEFAULT '0' COMMENT '宠物key',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `type_id` int(11) NOT NULL DEFAULT '0' COMMENT '类型id',
  `name` varchar(50) NOT NULL DEFAULT '0' COMMENT '昵称',
  `figure` int(11) NOT NULL DEFAULT '0' COMMENT '形象id',
  `stage` int(11) NOT NULL DEFAULT '0' COMMENT '阶数',
  `star` int(11) NOT NULL DEFAULT '0' COMMENT '星级',
  `star_exp` int(11) NOT NULL DEFAULT '0' COMMENT '星级经验',
  `state` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  `assist_cell` tinyint(1) NOT NULL DEFAULT '0' COMMENT '助战位置',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `skill` text NOT NULL COMMENT '技能列表',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战力',
  `attribute` text NOT NULL COMMENT '属性列表',
  PRIMARY KEY (`pet_key`),
  KEY `pkey` (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='宠物列表';

-- ----------------------------
--  Table structure for `pet_info`
-- ----------------------------
DROP TABLE IF EXISTS `pet_info`;
CREATE TABLE `pet_info` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `figure` int(11) NOT NULL COMMENT '当前形象id',
  `stage` int(11) NOT NULL COMMENT '阶数',
  `stage_lv` int(11) NOT NULL COMMENT '阶数等级',
  `stage_exp` int(11) NOT NULL COMMENT '阶数经验',
  `pic_list` text NOT NULL COMMENT '图鉴列表',
  `egg_list` text NOT NULL COMMENT '宠物蛋列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='宠物阶数信息';

-- ----------------------------
--  Table structure for `pet_weapon`
-- ----------------------------
DROP TABLE IF EXISTS `pet_weapon`;
CREATE TABLE `pet_weapon` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `stage` int(11) NOT NULL COMMENT '阶数',
  `exp` int(11) NOT NULL COMMENT '经验',
  `bless_cd` int(11) NOT NULL COMMENT '祝福CD',
  `weapon_id` int(11) NOT NULL COMMENT '形象',
  `skill_list` text NOT NULL COMMENT '技能列表',
  `equip_list` varchar(500) NOT NULL DEFAULT '[]' COMMENT '装备列表',
  `grow_num` int(11) NOT NULL DEFAULT '0' COMMENT '成长丹数量',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战力',
  `attribute` text NOT NULL COMMENT '属性列表',
  `spirit_list` text NOT NULL COMMENT '灵脉列表',
  `last_spirit` int(11) NOT NULL DEFAULT '0' COMMENT '上一次提升的灵脉',
  `spirit` int(11) NOT NULL DEFAULT '0' COMMENT '灵力值',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='妖灵';

-- ----------------------------
--  Table structure for `plant`
-- ----------------------------
DROP TABLE IF EXISTS `plant`;
CREATE TABLE `plant` (
  `key` int(11) NOT NULL COMMENT '植物key',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '植物id',
  `plant_state` int(11) NOT NULL DEFAULT '0' COMMENT '状态',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '状态持续时间',
  `x` int(11) NOT NULL DEFAULT '0' COMMENT 'X坐标',
  `y` int(11) NOT NULL DEFAULT '0' COMMENT 'Y坐标',
  `water_times` int(11) NOT NULL DEFAULT '0' COMMENT '浇水次数',
  `water_time` int(11) NOT NULL DEFAULT '0' COMMENT '最近一次浇水时间',
  `collect` text NOT NULL COMMENT '采集记录',
  `log` text NOT NULL COMMENT '操作日志',
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='种植表';

-- ----------------------------
--  Table structure for `plant_mb`
-- ----------------------------
DROP TABLE IF EXISTS `plant_mb`;
CREATE TABLE `plant_mb` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `collect_times` int(11) NOT NULL DEFAULT '0' COMMENT '采集次数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='种植玩家表';

-- ----------------------------
--  Table structure for `player_acc_charge_gift`
-- ----------------------------
DROP TABLE IF EXISTS `player_acc_charge_gift`;
CREATE TABLE `player_acc_charge_gift` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `acc_val` int(10) NOT NULL DEFAULT '0' COMMENT '累充金额',
  `times` int(10) NOT NULL DEFAULT '0' COMMENT '已领奖次数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家累充礼包信息';

-- ----------------------------
--  Table structure for `player_acc_charge_turntable`
-- ----------------------------
DROP TABLE IF EXISTS `player_acc_charge_turntable`;
CREATE TABLE `player_acc_charge_turntable` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `acc_val` int(10) NOT NULL DEFAULT '0' COMMENT '累充金额',
  `times` int(10) NOT NULL DEFAULT '0' COMMENT '已抽奖次数',
  `luck_val` int(10) NOT NULL DEFAULT '0' COMMENT '幸运值',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后更新时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家累充抽奖信息';

-- ----------------------------
--  Table structure for `player_acc_consume`
-- ----------------------------
DROP TABLE IF EXISTS `player_acc_consume`;
CREATE TABLE `player_acc_consume` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `get_acc_ids` text NOT NULL COMMENT '已领取的累计充值活动id',
  `time` int(10) NOT NULL DEFAULT '0' COMMENT '领取时间',
  `acc_val` int(10) NOT NULL DEFAULT '0' COMMENT '累计消费额度',
  `act_id` int(10) NOT NULL DEFAULT '1' COMMENT '活动id',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家累计消费表';

-- ----------------------------
--  Table structure for `player_acc_recharge`
-- ----------------------------
DROP TABLE IF EXISTS `player_acc_recharge`;
CREATE TABLE `player_acc_recharge` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `get_acc_ids` text NOT NULL COMMENT '已领取的连续充值活动id',
  `time` int(10) NOT NULL DEFAULT '0' COMMENT '领取时间',
  `acc_val` int(10) NOT NULL DEFAULT '0' COMMENT '累计充值额度',
  `act_id` int(10) NOT NULL DEFAULT '1' COMMENT '活动id',
  PRIMARY KEY (`pkey`),
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家累计充值表';

-- ----------------------------
--  Table structure for `player_acc_recharge_d`
-- ----------------------------
DROP TABLE IF EXISTS `player_acc_recharge_d`;
CREATE TABLE `player_acc_recharge_d` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `get_acc_ids` text NOT NULL COMMENT '已领取的连续充值活动id',
  `time` int(10) NOT NULL DEFAULT '0' COMMENT '领取时间',
  `acc_val` int(10) NOT NULL DEFAULT '0' COMMENT '累计充值额度',
  `act_id` int(10) NOT NULL DEFAULT '1' COMMENT '活动id',
  PRIMARY KEY (`pkey`),
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家大额累计充值表';

-- ----------------------------
--  Table structure for `player_act_cbp_rank`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_cbp_rank`;
CREATE TABLE `player_act_cbp_rank` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `get_list` varchar(200) DEFAULT '' COMMENT '已领取达标奖励id',
  `nickname` varchar(20) DEFAULT '' COMMENT '昵称',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `vip` int(10) NOT NULL DEFAULT '0' COMMENT 'vip等级',
  `start_cbp` int(10) NOT NULL DEFAULT '0' COMMENT '初始战斗力',
  `high_cbp` int(10) NOT NULL DEFAULT '0' COMMENT '最高战力',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跃升冲榜活动';

-- ----------------------------
--  Table structure for `player_act_charge`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_charge`;
CREATE TABLE `player_act_charge` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `charge_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '充值列表',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家充值数据';

-- ----------------------------
--  Table structure for `player_act_collection_hero`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_collection_hero`;
CREATE TABLE `player_act_collection_hero` (
  `state0` int(11) NOT NULL COMMENT '领取状态',
  `accname` varchar(100) NOT NULL DEFAULT '' COMMENT '平台账号',
  PRIMARY KEY (`accname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='集聚英雄';

-- ----------------------------
--  Table structure for `player_act_con_recharge`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_con_recharge`;
CREATE TABLE `player_act_con_recharge` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `recharge_list` text COMMENT '充值列表',
  `award_list` text COMMENT '已领取累充奖励列表',
  `daily_list` text COMMENT '每天已领取列表',
  `change_time` int(10) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `act_list` varchar(50) NOT NULL DEFAULT '[]' COMMENT '大额标记',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家连续充值活动信息';

-- ----------------------------
--  Table structure for `player_act_consume_rebate`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_consume_rebate`;
CREATE TABLE `player_act_consume_rebate` (
  `pkey` int(11) unsigned NOT NULL COMMENT '玩家key',
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动id',
  `acc_consume` int(11) NOT NULL DEFAULT '0' COMMENT '累计消费',
  `recv_list` text NOT NULL COMMENT '奖励日志',
  `op_time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家消费返利';

-- ----------------------------
--  Table structure for `player_act_convoy`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_convoy`;
CREATE TABLE `player_act_convoy` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `convoy_num` int(5) NOT NULL DEFAULT '0' COMMENT '护送次数',
  `is_recv` int(1) NOT NULL DEFAULT '0' COMMENT '0未领取1已经领取',
  `op_time` int(10) NOT NULL DEFAULT '0',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='护送称号活动';

-- ----------------------------
--  Table structure for `player_act_daily_task`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_daily_task`;
CREATE TABLE `player_act_daily_task` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `last_login_time` int(11) NOT NULL DEFAULT '0' COMMENT '上次登陆时间',
  `trigger_list` varchar(150) NOT NULL DEFAULT '[]' COMMENT '已达成列表',
  `get_list` varchar(150) NOT NULL DEFAULT '[]' COMMENT '已领取列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='每日任务活动';

-- ----------------------------
--  Table structure for `player_act_equip_sell`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_equip_sell`;
CREATE TABLE `player_act_equip_sell` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '0',
  `act_id` int(5) NOT NULL DEFAULT '0',
  `buy_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '[{序号，num}]',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='特权炫装';

-- ----------------------------
--  Table structure for `player_act_exp_dungeon`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_exp_dungeon`;
CREATE TABLE `player_act_exp_dungeon` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `is_buy` int(11) NOT NULL DEFAULT '0' COMMENT '是否购买',
  `get_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取列表',
  `op_time` int(11) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='经验副本投资';

-- ----------------------------
--  Table structure for `player_act_festival_acc_charge`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_festival_acc_charge`;
CREATE TABLE `player_act_festival_acc_charge` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `acc_charge_gold` int(10) NOT NULL DEFAULT '0' COMMENT '玩家累充钻石',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '已经领取的额度列表',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次操作时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='节日活动之累充';

-- ----------------------------
--  Table structure for `player_act_festival_back_buy`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_festival_back_buy`;
CREATE TABLE `player_act_festival_back_buy` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `buy_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '[{id, num}]',
  `op_time` int(10) NOT NULL DEFAULT '0',
  `open_day` int(10) NOT NULL DEFAULT '0' COMMENT '活动开启第几天',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开服活动之返利限购';

-- ----------------------------
--  Table structure for `player_act_festival_login_gift`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_festival_login_gift`;
CREATE TABLE `player_act_festival_login_gift` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `login_day` int(10) NOT NULL DEFAULT '0',
  `charge_gold` int(10) NOT NULL DEFAULT '0',
  `recv_list` varchar(200) NOT NULL DEFAULT '[]',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='节日活动之登陆有礼';

-- ----------------------------
--  Table structure for `player_act_flip_card`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_flip_card`;
CREATE TABLE `player_act_flip_card` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key值',
  `same_flag` int(11) NOT NULL DEFAULT '0' COMMENT '相同标记',
  `card_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '翻牌列表',
  `last_login_time` int(11) NOT NULL DEFAULT '0' COMMENT '上次登陆时间',
  `log_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '翻牌日志',
  PRIMARY KEY (`pkey`),
  UNIQUE KEY `key` (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='幸运翻牌';

-- ----------------------------
--  Table structure for `player_act_invest`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_invest`;
CREATE TABLE `player_act_invest` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_num` int(3) NOT NULL DEFAULT '1' COMMENT '轮数',
  `invest_gold` int(10) NOT NULL DEFAULT '0' COMMENT '投资钻石数',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取列表',
  `recv_time` int(10) NOT NULL DEFAULT '0' COMMENT '奖励领取时间',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  UNIQUE KEY `key` (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开服7天投资资金';

-- ----------------------------
--  Table structure for `player_act_jbp`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_jbp`;
CREATE TABLE `player_act_jbp` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `charge_list` varchar(1024) NOT NULL DEFAULT '[]',
  `recv_list` varchar(2048) NOT NULL DEFAULT '[]' COMMENT '[{ChargeGold, RecvNum}]',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`),
  KEY `op_time` (`op_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='聚宝盆';

-- ----------------------------
--  Table structure for `player_act_limit_pet`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_limit_pet`;
CREATE TABLE `player_act_limit_pet` (
  `pkey` int(10) NOT NULL,
  `act_id` int(10) NOT NULL DEFAULT '0',
  `score` int(10) NOT NULL DEFAULT '0',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='限时宠物成长';

-- ----------------------------
--  Table structure for `player_act_limit_xian`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_limit_xian`;
CREATE TABLE `player_act_limit_xian` (
  `pkey` int(10) NOT NULL,
  `act_id` int(10) NOT NULL DEFAULT '0',
  `score` int(10) NOT NULL DEFAULT '0',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仙装限时抢购';

-- ----------------------------
--  Table structure for `player_act_map`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_map`;
CREATE TABLE `player_act_map` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key值',
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `step` int(6) NOT NULL DEFAULT '0' COMMENT '当前步数',
  `pass_num` int(10) NOT NULL DEFAULT '0' COMMENT '玩家通关轮数',
  `use_free_num` int(10) NOT NULL DEFAULT '0' COMMENT '当前已经使用的免费次数',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '已经领取的坑',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次操作时间',
  PRIMARY KEY (`pkey`),
  UNIQUE KEY `key` (`pkey`),
  KEY `key2` (`act_id`,`op_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='迷宫寻宝';

-- ----------------------------
--  Table structure for `player_act_meet_limit`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_meet_limit`;
CREATE TABLE `player_act_meet_limit` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key值',
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动id',
  `child_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '子活动记录',
  `get_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '已领取最大id',
  PRIMARY KEY (`pkey`),
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='奇遇礼包';

-- ----------------------------
--  Table structure for `player_act_one_gold_buy`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_one_gold_buy`;
CREATE TABLE `player_act_one_gold_buy` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `buy_num` int(10) NOT NULL DEFAULT '0',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取次数奖励列表',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='一元抢购活动';

-- ----------------------------
--  Table structure for `player_act_other_charge`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_other_charge`;
CREATE TABLE `player_act_other_charge` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `acc_charge_gold` int(10) NOT NULL DEFAULT '0' COMMENT '玩家累充钻石',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '已经领取的额度列表',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次操作时间',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='额外特惠活动';

-- ----------------------------
--  Table structure for `player_act_rank`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_rank`;
CREATE TABLE `player_act_rank` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `equip_stren_lv` int(10) NOT NULL DEFAULT '0' COMMENT '装备强化等级',
  `equip_stren_lv_time` int(10) NOT NULL DEFAULT '0' COMMENT '装备强化更新时间',
  `baoshi_lv` int(10) NOT NULL DEFAULT '0' COMMENT '宝石等级',
  `baoshi_lv_time` int(10) NOT NULL DEFAULT '0' COMMENT '宝石等级更新时间',
  PRIMARY KEY (`pkey`),
  KEY `equip_stren_lv` (`equip_stren_lv`),
  KEY `baoshi_lv` (`baoshi_lv`),
  KEY `equip_stren_lv_time` (`equip_stren_lv_time`) USING BTREE,
  KEY `baoshi_lv_time` (`baoshi_lv_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家冲榜活动数据';

-- ----------------------------
--  Table structure for `player_act_rank_goal`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_rank_goal`;
CREATE TABLE `player_act_rank_goal` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动子id',
  `get_list` text COMMENT '领取列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家冲榜达标活动数据';

-- ----------------------------
--  Table structure for `player_act_small_charge`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_small_charge`;
CREATE TABLE `player_act_small_charge` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `charge_list` varchar(1024) NOT NULL DEFAULT '[]',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取列表',
  `buy_num` int(2) NOT NULL DEFAULT '0' COMMENT '当前购买的次数',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='小额充值';

-- ----------------------------
--  Table structure for `player_act_super_charge`
-- ----------------------------
DROP TABLE IF EXISTS `player_act_super_charge`;
CREATE TABLE `player_act_super_charge` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `acc_charge_gold` int(10) NOT NULL DEFAULT '0' COMMENT '玩家累充钻石',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '已经领取的额度列表',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次操作时间',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='超值特惠活动';

-- ----------------------------
--  Table structure for `player_awake`
-- ----------------------------
DROP TABLE IF EXISTS `player_awake`;
CREATE TABLE `player_awake` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `type` int(11) NOT NULL COMMENT '等级',
  `cell` int(11) NOT NULL COMMENT '格子',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='天命觉醒';

-- ----------------------------
--  Table structure for `player_bag`
-- ----------------------------
DROP TABLE IF EXISTS `player_bag`;
CREATE TABLE `player_bag` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `max_cell` smallint(5) NOT NULL DEFAULT '0' COMMENT '最大格子数',
  `kill_mon_num` int(1) NOT NULL DEFAULT '0' COMMENT '杀怪数量',
  `warehouse_cell` smallint(1) NOT NULL DEFAULT '0' COMMENT '仓库最大格子',
  `fuwen_cell` int(3) NOT NULL DEFAULT '0' COMMENT '符文最大格子数',
  `fairy_cell` int(11) NOT NULL DEFAULT '0' COMMENT '仙魂背包',
  `xian_cell` int(3) NOT NULL DEFAULT '0' COMMENT '仙装最大格子数',
  `god_soul_cell` int(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家背包信息表';

-- ----------------------------
--  Table structure for `player_buy_money`
-- ----------------------------
DROP TABLE IF EXISTS `player_buy_money`;
CREATE TABLE `player_buy_money` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `coin_free_num` int(11) NOT NULL DEFAULT '0' COMMENT '已购买银币免费次数',
  `coin_all_num` int(11) NOT NULL DEFAULT '0' COMMENT '已购买银币总次数',
  `xinghun_free_num` int(11) NOT NULL DEFAULT '0' COMMENT '已免费购买星魂次数',
  `xinghun_all_num` int(11) NOT NULL DEFAULT '0' COMMENT '已免费购买总次数',
  `online_time` int(11) NOT NULL DEFAULT '0' COMMENT '当日在线时长',
  `last_login_time` int(11) NOT NULL DEFAULT '0' COMMENT '上次登陆时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='招财进宝';

-- ----------------------------
--  Table structure for `player_buy_red_equip`
-- ----------------------------
DROP TABLE IF EXISTS `player_buy_red_equip`;
CREATE TABLE `player_buy_red_equip` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动id',
  `info_list` text NOT NULL COMMENT '玩家记录',
  `re_count` int(11) NOT NULL DEFAULT '0' COMMENT '刷新次数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='红装限时抢购';

-- ----------------------------
--  Table structure for `player_call_godness`
-- ----------------------------
DROP TABLE IF EXISTS `player_call_godness`;
CREATE TABLE `player_call_godness` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `count` int(10) NOT NULL DEFAULT '0' COMMENT '次数',
  `value` int(10) NOT NULL DEFAULT '0' COMMENT '幸运值',
  `get_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取列表记录',
  `op_time` int(10) NOT NULL DEFAULT '0',
  `free_count` int(11) NOT NULL DEFAULT '0' COMMENT '今日免费次数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='神邸唤神';

-- ----------------------------
--  Table structure for `player_card`
-- ----------------------------
DROP TABLE IF EXISTS `player_card`;
CREATE TABLE `player_card` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
  `date` int(11) NOT NULL DEFAULT '0' COMMENT '到期时间',
  `bgold` int(11) NOT NULL DEFAULT '0' COMMENT '每日返回元宝',
  PRIMARY KEY (`pkey`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='月卡年卡';

-- ----------------------------
--  Table structure for `player_cbp`
-- ----------------------------
DROP TABLE IF EXISTS `player_cbp`;
CREATE TABLE `player_cbp` (
  `pkey` int(11) unsigned NOT NULL,
  `cbp` bigint(20) NOT NULL DEFAULT '0',
  `cbp_list` text,
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家战力记录';

-- ----------------------------
--  Table structure for `player_change_career`
-- ----------------------------
DROP TABLE IF EXISTS `player_change_career`;
CREATE TABLE `player_change_career` (
  `pkey` int(11) NOT NULL,
  `career` int(11) NOT NULL DEFAULT '1' COMMENT '转身职业',
  `is_career` int(11) NOT NULL DEFAULT '0' COMMENT '是否可转身',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='转职状态表';

-- ----------------------------
--  Table structure for `player_charge_gift`
-- ----------------------------
DROP TABLE IF EXISTS `player_charge_gift`;
CREATE TABLE `player_charge_gift` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `date` int(11) NOT NULL DEFAULT '0' COMMENT '到期时间',
  `bgold` int(11) NOT NULL DEFAULT '0' COMMENT '每日返回元宝',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='绑元礼包';

-- ----------------------------
--  Table structure for `player_charge_return`
-- ----------------------------
DROP TABLE IF EXISTS `player_charge_return`;
CREATE TABLE `player_charge_return` (
  `accname` varchar(50) NOT NULL DEFAULT '' COMMENT '账号',
  `pf` int(11) NOT NULL DEFAULT '0' COMMENT '平台',
  `total_fee` int(11) NOT NULL DEFAULT '0' COMMENT '充值金额',
  `state` tinyint(11) NOT NULL DEFAULT '0' COMMENT '状态0未领取1领取',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '领取时间',
  PRIMARY KEY (`accname`,`pf`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='删档充值返还';

-- ----------------------------
--  Table structure for `player_charge_return_bg`
-- ----------------------------
DROP TABLE IF EXISTS `player_charge_return_bg`;
CREATE TABLE `player_charge_return_bg` (
  `accname` varchar(50) NOT NULL DEFAULT '' COMMENT '账号',
  `pf` int(11) NOT NULL DEFAULT '0' COMMENT '平台',
  `bgold` int(11) NOT NULL DEFAULT '0' COMMENT '返回绑定钻石',
  `state` tinyint(11) NOT NULL DEFAULT '0' COMMENT '状态0未领取1领取',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '领取时间',
  PRIMARY KEY (`accname`,`pf`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='删档充值返还绑钻';

-- ----------------------------
--  Table structure for `player_con_charge`
-- ----------------------------
DROP TABLE IF EXISTS `player_con_charge`;
CREATE TABLE `player_con_charge` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `charge_list` text COMMENT '充值列表',
  `get_list` text COMMENT '已领奖列表',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `get_gift_time` int(10) NOT NULL DEFAULT '0' COMMENT '终极礼包领取时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家连续充值信息';

-- ----------------------------
--  Table structure for `player_consume_back_charge`
-- ----------------------------
DROP TABLE IF EXISTS `player_consume_back_charge`;
CREATE TABLE `player_consume_back_charge` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `consume_gold` int(10) NOT NULL DEFAULT '0' COMMENT '消耗元宝',
  `back_num` int(5) NOT NULL DEFAULT '0' COMMENT '返还次数',
  `back_gold` int(10) NOT NULL DEFAULT '0' COMMENT '总返还钻石',
  `back_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '[{charge_gold, percent, is_use}]',
  `log` varchar(2048) NOT NULL DEFAULT '[]' COMMENT '[{charge_gold, percent, is_use, out_time}]',
  `op_time` int(10) DEFAULT '0',
  PRIMARY KEY (`pkey`),
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消费返充值比例活动';

-- ----------------------------
--  Table structure for `player_consume_rank`
-- ----------------------------
DROP TABLE IF EXISTS `player_consume_rank`;
CREATE TABLE `player_consume_rank` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动id',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `consume_gold` int(11) NOT NULL DEFAULT '0' COMMENT '消费元宝',
  `change_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后消费时间',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '玩家等级',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消费排行榜';

-- ----------------------------
--  Table structure for `player_convoy`
-- ----------------------------
DROP TABLE IF EXISTS `player_convoy`;
CREATE TABLE `player_convoy` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `color` tinyint(1) NOT NULL DEFAULT '0' COMMENT '护送品质',
  `times` tinyint(1) NOT NULL DEFAULT '0' COMMENT '护送次数',
  `extra_times` tinyint(1) NOT NULL DEFAULT '0' COMMENT '额外护送次数',
  `times_total` int(11) NOT NULL DEFAULT '0' COMMENT '总护送次数',
  `rob_times` tinyint(1) NOT NULL DEFAULT '0' COMMENT '抢夺次数',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '每日时间戳',
  `refresh_free` int(11) NOT NULL DEFAULT '0' COMMENT '免费刷新次数',
  `godt` int(11) NOT NULL DEFAULT '0' COMMENT '是否使用无敌0无',
  `help_times` tinyint(1) NOT NULL DEFAULT '0' COMMENT '帮组次数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家护送数据';

-- ----------------------------
--  Table structure for `player_crazy_click`
-- ----------------------------
DROP TABLE IF EXISTS `player_crazy_click`;
CREATE TABLE `player_crazy_click` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `att_times` int(10) NOT NULL DEFAULT '0' COMMENT '剩余攻击次数',
  `cd_times` int(10) NOT NULL DEFAULT '0' COMMENT 'cd开始时间',
  `mon_id` int(10) NOT NULL DEFAULT '0' COMMENT '怪物id',
  `mon_hp` int(10) NOT NULL DEFAULT '0' COMMENT '怪物血量',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '每天增加攻击次数更新时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='疯狂点击数据';

-- ----------------------------
--  Table structure for `player_cross_1vn_mb`
-- ----------------------------
DROP TABLE IF EXISTS `player_cross_1vn_mb`;
CREATE TABLE `player_cross_1vn_mb` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `sn` int(11) NOT NULL DEFAULT '0' COMMENT '服号',
  `nickname` varchar(20) NOT NULL DEFAULT '' COMMENT '昵称',
  `career` tinyint(1) NOT NULL DEFAULT '0' COMMENT '职业',
  `sex` tinyint(1) NOT NULL DEFAULT '0' COMMENT '性别1男2女',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `times` int(11) NOT NULL DEFAULT '0' COMMENT '次数',
  `combo` int(11) NOT NULL DEFAULT '0' COMMENT '连胜数',
  `lv_group` int(11) NOT NULL DEFAULT '0' COMMENT '分组',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战斗力',
  `win` int(11) NOT NULL DEFAULT '0' COMMENT '胜场',
  `lose` int(11) NOT NULL DEFAULT '0' COMMENT '败场',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '积分',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '排名',
  `final_floor` int(11) NOT NULL DEFAULT '0' COMMENT '决赛轮次',
  `guild_name` varchar(20) NOT NULL DEFAULT '' COMMENT '仙盟名称',
  `guild_key` bigint(22) NOT NULL DEFAULT '0' COMMENT '公会key',
  `guild_position` int(11) NOT NULL DEFAULT '0' COMMENT '职位',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '变更时间',
  `flag_month` int(11) NOT NULL DEFAULT '0' COMMENT '期数(月)',
  `flag_day` int(11) NOT NULL DEFAULT '0' COMMENT '期数(日)',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家跨服1vn信息';

-- ----------------------------
--  Table structure for `player_cross_1vn_shop`
-- ----------------------------
DROP TABLE IF EXISTS `player_cross_1vn_shop`;
CREATE TABLE `player_cross_1vn_shop` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `shop_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '购买列表',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `player_cross_boss`
-- ----------------------------
DROP TABLE IF EXISTS `player_cross_boss`;
CREATE TABLE `player_cross_boss` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `drop_num` int(10) NOT NULL DEFAULT '0' COMMENT '领取跨服boss掉落归属次数',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服boss疲劳度';

-- ----------------------------
--  Table structure for `player_cross_fruit`
-- ----------------------------
DROP TABLE IF EXISTS `player_cross_fruit`;
CREATE TABLE `player_cross_fruit` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `get_times` int(10) NOT NULL DEFAULT '0' COMMENT '领取奖励次数',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `win_times` int(10) NOT NULL DEFAULT '0' COMMENT '胜利次数',
  `win_update_time` int(10) NOT NULL DEFAULT '0' COMMENT '胜利更新时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家跨服水果大作战';

-- ----------------------------
--  Table structure for `player_cross_mining_help`
-- ----------------------------
DROP TABLE IF EXISTS `player_cross_mining_help`;
CREATE TABLE `player_cross_mining_help` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `my_help_list` text COMMENT '已购买列表',
  `reset_list` text COMMENT '刷新镜像列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仙晶矿域援助';

-- ----------------------------
--  Table structure for `player_cross_war`
-- ----------------------------
DROP TABLE IF EXISTS `player_cross_war`;
CREATE TABLE `player_cross_war` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `contrib` int(10) NOT NULL DEFAULT '0' COMMENT '本期贡献值',
  `contrib_list` varchar(100) NOT NULL DEFAULT '[]' COMMENT '贡献材料集合',
  `is_recv_member` int(1) NOT NULL DEFAULT '0' COMMENT '1已领取',
  `is_recv_king` int(1) NOT NULL DEFAULT '0' COMMENT '1已领取',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  `guild_key` bigint(22) NOT NULL DEFAULT '0' COMMENT '最后捐献时所在的公会',
  `is_orz` int(1) NOT NULL DEFAULT '0' COMMENT '是否膜拜',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服攻城战，玩家私有数据';

-- ----------------------------
--  Table structure for `player_cross_wishing_well`
-- ----------------------------
DROP TABLE IF EXISTS `player_cross_wishing_well`;
CREATE TABLE `player_cross_wishing_well` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `count_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '次数列表[{Type,Count}]',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '积分',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次操作时间',
  `gold_coin` int(10) NOT NULL DEFAULT '0' COMMENT '金币数',
  `charge_count` int(11) NOT NULL COMMENT '已经兑换金币次数',
  `charge_val` int(11) NOT NULL DEFAULT '0' COMMENT '未转化金币的充值数',
  `nickname` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '角色名',
  PRIMARY KEY (`pkey`),
  UNIQUE KEY `key` (`pkey`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='许愿池(跨服)';

-- ----------------------------
--  Table structure for `player_cs_charge_d`
-- ----------------------------
DROP TABLE IF EXISTS `player_cs_charge_d`;
CREATE TABLE `player_cs_charge_d` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `charge_list` varchar(1024) NOT NULL DEFAULT '[]',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '[{ChargeGold, RecvNum}]',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`),
  KEY `op_time` (`op_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='财神单笔充值';

-- ----------------------------
--  Table structure for `player_daily_acc_recharge`
-- ----------------------------
DROP TABLE IF EXISTS `player_daily_acc_recharge`;
CREATE TABLE `player_daily_acc_recharge` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `get_acc_ids` text NOT NULL COMMENT '已领取的连续充值活动id',
  `time` int(10) NOT NULL DEFAULT '0' COMMENT '领取时间',
  `acc_val` int(10) NOT NULL DEFAULT '0' COMMENT '累计充值额度',
  `act_id` int(10) NOT NULL DEFAULT '1' COMMENT '活动id',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家每日累计充值表';

-- ----------------------------
--  Table structure for `player_daily_charge`
-- ----------------------------
DROP TABLE IF EXISTS `player_daily_charge`;
CREATE TABLE `player_daily_charge` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `get_list` text NOT NULL COMMENT '领取状态列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家每日充值活动数据';

-- ----------------------------
--  Table structure for `player_daily_count`
-- ----------------------------
DROP TABLE IF EXISTS `player_daily_count`;
CREATE TABLE `player_daily_count` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `daily_count` text NOT NULL COMMENT '计数列表[{type,count}]',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '刷新时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家日常数据';

-- ----------------------------
--  Table structure for `player_daily_fir_charge_return`
-- ----------------------------
DROP TABLE IF EXISTS `player_daily_fir_charge_return`;
CREATE TABLE `player_daily_fir_charge_return` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `get_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家每日首冲返还信息';

-- ----------------------------
--  Table structure for `player_day7login`
-- ----------------------------
DROP TABLE IF EXISTS `player_day7login`;
CREATE TABLE `player_day7login` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `daysinfo` text NOT NULL COMMENT '7天状态',
  `time` int(10) NOT NULL DEFAULT '0' COMMENT '最后的更新时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家7天登陆数据';

-- ----------------------------
--  Table structure for `player_draw_turntable`
-- ----------------------------
DROP TABLE IF EXISTS `player_draw_turntable`;
CREATE TABLE `player_draw_turntable` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `score` int(10) NOT NULL DEFAULT '0' COMMENT '玩家积分',
  `turntable_id` int(10) NOT NULL DEFAULT '1' COMMENT '当前转盘id',
  `exchange_list` varchar(150) NOT NULL DEFAULT '[]' COMMENT '购买状态',
  `location` int(11) NOT NULL DEFAULT '0' COMMENT '指向位置',
  `count` int(11) NOT NULL DEFAULT '0' COMMENT '转动次数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='抽奖转盘';

-- ----------------------------
--  Table structure for `player_drop_vitality`
-- ----------------------------
DROP TABLE IF EXISTS `player_drop_vitality`;
CREATE TABLE `player_drop_vitality` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `task_list` text COMMENT '任务列表',
  `history_list` text COMMENT '历史列表',
  `sum_point` int(10) NOT NULL DEFAULT '0' COMMENT '当天总活跃度',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家物品掉落活跃度';

-- ----------------------------
--  Table structure for `player_dun_cross`
-- ----------------------------
DROP TABLE IF EXISTS `player_dun_cross`;
CREATE TABLE `player_dun_cross` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `dun_list` text NOT NULL COMMENT '通过副本列表',
  `times` int(11) NOT NULL COMMENT '今日通关次数',
  `time` int(11) NOT NULL COMMENT '每日时间戳',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服副本';

-- ----------------------------
--  Table structure for `player_dun_cross_guard`
-- ----------------------------
DROP TABLE IF EXISTS `player_dun_cross_guard`;
CREATE TABLE `player_dun_cross_guard` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `dun_list` text NOT NULL COMMENT '通过副本列表',
  `times` int(11) NOT NULL COMMENT '今日通关次数',
  `time` int(11) NOT NULL COMMENT '每日时间戳',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '玩家等级',
  `milestone_list` text NOT NULL COMMENT '里程碑记录',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服试炼副本';

-- ----------------------------
--  Table structure for `player_dun_daily`
-- ----------------------------
DROP TABLE IF EXISTS `player_dun_daily`;
CREATE TABLE `player_dun_daily` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `dun_list` text NOT NULL COMMENT '通关的副本列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='每日副本';

-- ----------------------------
--  Table structure for `player_dun_element`
-- ----------------------------
DROP TABLE IF EXISTS `player_dun_element`;
CREATE TABLE `player_dun_element` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `log_list` varchar(1024) NOT NULL DEFAULT '[]',
  `saodang_list` varchar(1024) NOT NULL DEFAULT '[]',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='元素副本';

-- ----------------------------
--  Table structure for `player_dun_equip`
-- ----------------------------
DROP TABLE IF EXISTS `player_dun_equip`;
CREATE TABLE `player_dun_equip` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `times` tinyint(11) NOT NULL DEFAULT '0' COMMENT '挑战次数',
  `dun_list` text NOT NULL COMMENT '副本列表',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='神装副本信息';

-- ----------------------------
--  Table structure for `player_dun_exp`
-- ----------------------------
DROP TABLE IF EXISTS `player_dun_exp`;
CREATE TABLE `player_dun_exp` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `round_highest` int(11) NOT NULL DEFAULT '0' COMMENT '最大波数',
  `round` int(11) NOT NULL DEFAULT '0' COMMENT '当前波数',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='经验副本';

-- ----------------------------
--  Table structure for `player_dun_fuwen_tower`
-- ----------------------------
DROP TABLE IF EXISTS `player_dun_fuwen_tower`;
CREATE TABLE `player_dun_fuwen_tower` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `dun_list` text NOT NULL COMMENT '当天挑战过的dun_id列表',
  `layer_highest` int(10) NOT NULL DEFAULT '0' COMMENT '通关最大层数',
  `sub_layer` int(10) NOT NULL DEFAULT '0' COMMENT '子层',
  `unlock_pos` int(10) NOT NULL DEFAULT '0' COMMENT '解锁镶孔',
  `unlock_fuwen_subtype` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '解锁符文类型',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='符文塔副本';

-- ----------------------------
--  Table structure for `player_dun_god_weapon`
-- ----------------------------
DROP TABLE IF EXISTS `player_dun_god_weapon`;
CREATE TABLE `player_dun_god_weapon` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `layer` int(11) NOT NULL DEFAULT '0' COMMENT '当前层数',
  `layer_h` int(11) NOT NULL DEFAULT '0' COMMENT '历史层数',
  `round` int(11) NOT NULL DEFAULT '0' COMMENT '轮次',
  `round_h` int(11) NOT NULL DEFAULT '0' COMMENT '历史轮次',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='神器副本';

-- ----------------------------
--  Table structure for `player_dun_godness`
-- ----------------------------
DROP TABLE IF EXISTS `player_dun_godness`;
CREATE TABLE `player_dun_godness` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `buy_num` text NOT NULL,
  `left_godsoul_num` text NOT NULL,
  `left_godness_num` text NOT NULL,
  `right_godsoul_num` text NOT NULL,
  `right_godness_num` text NOT NULL,
  `left_pass_list` text NOT NULL,
  `right_pass_list` text NOT NULL,
  `log_dun_id_list` text NOT NULL,
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='神祇副本';

-- ----------------------------
--  Table structure for `player_dun_guard_td`
-- ----------------------------
DROP TABLE IF EXISTS `player_dun_guard_td`;
CREATE TABLE `player_dun_guard_td` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `round` int(11) NOT NULL DEFAULT '0' COMMENT '存档波数',
  `round_max` int(11) NOT NULL DEFAULT '0' COMMENT '最高层数',
  `first_round` int(11) NOT NULL DEFAULT '0' COMMENT '已获得首通奖励最高层数',
  `change_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `reward_list` varchar(400) NOT NULL DEFAULT '[]' COMMENT '每日已获得奖励波数列表',
  `pass_time` int(11) NOT NULL DEFAULT '0' COMMENT '通关时间',
  `first_time` int(11) NOT NULL DEFAULT '0' COMMENT '首次达到此层时间',
  `is_sweep` int(11) NOT NULL DEFAULT '0' COMMENT '今日是否已经扫荡',
  `sweep_round` int(11) NOT NULL DEFAULT '0' COMMENT '扫荡层数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `player_dun_jiandao`
-- ----------------------------
DROP TABLE IF EXISTS `player_dun_jiandao`;
CREATE TABLE `player_dun_jiandao` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `log_list` varchar(1024) NOT NULL DEFAULT '[]',
  `challenge_num` int(10) NOT NULL DEFAULT '0',
  `buy_list` varchar(1024) NOT NULL DEFAULT '[]',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `player_dun_marry`
-- ----------------------------
DROP TABLE IF EXISTS `player_dun_marry`;
CREATE TABLE `player_dun_marry` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `pass` int(10) NOT NULL DEFAULT '0' COMMENT '当日是否通关0没有1通关',
  `is_reset` int(2) NOT NULL DEFAULT '0' COMMENT '重置次数',
  `saodang` int(2) NOT NULL DEFAULT '0' COMMENT '0不可扫荡1可以扫荡2已经扫荡',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='爱情试炼副本';

-- ----------------------------
--  Table structure for `player_dun_material`
-- ----------------------------
DROP TABLE IF EXISTS `player_dun_material`;
CREATE TABLE `player_dun_material` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `dun_list` text NOT NULL COMMENT '副本列表',
  `time` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='材料副本';

-- ----------------------------
--  Table structure for `player_dun_tower`
-- ----------------------------
DROP TABLE IF EXISTS `player_dun_tower`;
CREATE TABLE `player_dun_tower` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `dun_list` text NOT NULL COMMENT '通关的副本信息',
  `layer` int(11) NOT NULL DEFAULT '0' COMMENT '当前层数',
  `use_time` int(11) NOT NULL DEFAULT '0' COMMENT '通关用时',
  `click` int(11) NOT NULL COMMENT '打开次数',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '每日时间戳',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='九霄塔副本';

-- ----------------------------
--  Table structure for `player_element`
-- ----------------------------
DROP TABLE IF EXISTS `player_element`;
CREATE TABLE `player_element` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `race` int(10) NOT NULL DEFAULT '0',
  `lv` int(10) NOT NULL DEFAULT '0',
  `e_lv` int(10) NOT NULL DEFAULT '0',
  `stage` int(10) NOT NULL DEFAULT '0',
  `pos` int(10) NOT NULL,
  `is_wear` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`,`race`),
  KEY `pkey` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家元素';

-- ----------------------------
--  Table structure for `player_eliminate`
-- ----------------------------
DROP TABLE IF EXISTS `player_eliminate`;
CREATE TABLE `player_eliminate` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `wins` int(11) NOT NULL DEFAULT '0' COMMENT '胜利次数',
  `winning_streak` int(11) NOT NULL DEFAULT '0' COMMENT '连胜',
  `losing_streak` int(11) NOT NULL DEFAULT '0' COMMENT '连败',
  `times` tinyint(1) NOT NULL DEFAULT '0' COMMENT '每日挑战次数',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消消乐';

-- ----------------------------
--  Table structure for `player_elite_boss_back`
-- ----------------------------
DROP TABLE IF EXISTS `player_elite_boss_back`;
CREATE TABLE `player_elite_boss_back` (
  `pkey` int(10) NOT NULL,
  `node` varchar(100) NOT NULL,
  `sn` int(10) NOT NULL,
  `scene_id` int(10) NOT NULL,
  `back_list` varchar(500) NOT NULL,
  `time` int(10) NOT NULL,
  PRIMARY KEY (`pkey`,`scene_id`),
  KEY `scene_id` (`scene_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='精英boss停服返还';

-- ----------------------------
--  Table structure for `player_elite_boss_dun`
-- ----------------------------
DROP TABLE IF EXISTS `player_elite_boss_dun`;
CREATE TABLE `player_elite_boss_dun` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `challenge_num` int(10) NOT NULL DEFAULT '0',
  `is_recv` int(10) NOT NULL DEFAULT '0' COMMENT '每日福利0未领取1已领取',
  `buy_num` int(10) NOT NULL DEFAULT '0',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='精英bossVIP副本';

-- ----------------------------
--  Table structure for `player_equip_part_shop`
-- ----------------------------
DROP TABLE IF EXISTS `player_equip_part_shop`;
CREATE TABLE `player_equip_part_shop` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `buy_list` text COMMENT '购买列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='装备碎片商城';

-- ----------------------------
--  Table structure for `player_equip_suit`
-- ----------------------------
DROP TABLE IF EXISTS `player_equip_suit`;
CREATE TABLE `player_equip_suit` (
  `pkey` int(10) NOT NULL,
  `act_ids` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '激活ID',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='装备套装';

-- ----------------------------
--  Table structure for `player_exchange`
-- ----------------------------
DROP TABLE IF EXISTS `player_exchange`;
CREATE TABLE `player_exchange` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `get_list` text COMMENT '已领取列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='兑换活动数据';

-- ----------------------------
--  Table structure for `player_face`
-- ----------------------------
DROP TABLE IF EXISTS `player_face`;
CREATE TABLE `player_face` (
  `pkey` int(10) NOT NULL,
  `vip_face_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT 'vip卡数据[{Vip, Time}]',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='VIP表情卡';

-- ----------------------------
--  Table structure for `player_fairl_soul`
-- ----------------------------
DROP TABLE IF EXISTS `player_fairl_soul`;
CREATE TABLE `player_fairl_soul` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `exp` int(10) NOT NULL DEFAULT '0' COMMENT '仙魂经验',
  `chip` int(10) NOT NULL DEFAULT '0' COMMENT '仙魂碎片',
  `pos` int(2) NOT NULL DEFAULT '0' COMMENT '激活位置',
  `floor` int(10) NOT NULL DEFAULT '1' COMMENT '当前位置',
  `max_floor` int(10) NOT NULL DEFAULT '1' COMMENT '最大点亮位置',
  `list` varchar(150) NOT NULL DEFAULT '[]' COMMENT '猎魂列表',
  `is_first` int(10) NOT NULL DEFAULT '0' COMMENT '是否首次付费',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='宠物仙魂';

-- ----------------------------
--  Table structure for `player_fcm`
-- ----------------------------
DROP TABLE IF EXISTS `player_fcm`;
CREATE TABLE `player_fcm` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `acc_online` int(11) NOT NULL COMMENT '累计在线',
  `acc_logout` int(11) NOT NULL COMMENT '累计离线',
  `identity` tinyint(1) NOT NULL DEFAULT '0' COMMENT '身份0未认证1成年2未成年',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家防沉迷信息';

-- ----------------------------
--  Table structure for `player_festival_exchange`
-- ----------------------------
DROP TABLE IF EXISTS `player_festival_exchange`;
CREATE TABLE `player_festival_exchange` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `exchange_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '兑换信息列表',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='节日活动之兑换';

-- ----------------------------
--  Table structure for `player_festival_red_gift`
-- ----------------------------
DROP TABLE IF EXISTS `player_festival_red_gift`;
CREATE TABLE `player_festival_red_gift` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取列表',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='节日红包雨';

-- ----------------------------
--  Table structure for `player_field_boss_buy`
-- ----------------------------
DROP TABLE IF EXISTS `player_field_boss_buy`;
CREATE TABLE `player_field_boss_buy` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `buy_num` int(10) NOT NULL DEFAULT '0',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `player_field_point`
-- ----------------------------
DROP TABLE IF EXISTS `player_field_point`;
CREATE TABLE `player_field_point` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `sn` int(10) NOT NULL DEFAULT '0',
  `name` varchar(100) NOT NULL DEFAULT '""',
  `lv` int(10) NOT NULL DEFAULT '0',
  `cbp` int(11) NOT NULL DEFAULT '0',
  `point_list` text NOT NULL,
  `update_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='精英boss积分';

-- ----------------------------
--  Table structure for `player_findback_exp`
-- ----------------------------
DROP TABLE IF EXISTS `player_findback_exp`;
CREATE TABLE `player_findback_exp` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `outline_time` int(10) NOT NULL COMMENT '离线时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家离线找回经验数据';

-- ----------------------------
--  Table structure for `player_findback_src`
-- ----------------------------
DROP TABLE IF EXISTS `player_findback_src`;
CREATE TABLE `player_findback_src` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `type_list` text NOT NULL COMMENT '功能找回信息列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家离线资源找回数据';

-- ----------------------------
--  Table structure for `player_first_charge`
-- ----------------------------
DROP TABLE IF EXISTS `player_first_charge`;
CREATE TABLE `player_first_charge` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `get_list` text NOT NULL COMMENT '已领取列表',
  `charge_time` int(10) NOT NULL DEFAULT '0' COMMENT '充值时间',
  `last_get_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后领取时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家首冲数据';

-- ----------------------------
--  Table structure for `player_first_login_gift`
-- ----------------------------
DROP TABLE IF EXISTS `player_first_login_gift`;
CREATE TABLE `player_first_login_gift` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `state` int(10) NOT NULL DEFAULT '0' COMMENT '领取状态',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家首次登陆奖励';

-- ----------------------------
--  Table structure for `player_free_gift`
-- ----------------------------
DROP TABLE IF EXISTS `player_free_gift`;
CREATE TABLE `player_free_gift` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(1) NOT NULL DEFAULT '0' COMMENT '活动id',
  `type` int(1) NOT NULL DEFAULT '0' COMMENT '礼包类型',
  `state` int(1) NOT NULL DEFAULT '0' COMMENT '发送状态',
  `buy_time` int(1) NOT NULL DEFAULT '0' COMMENT '购买时间',
  `delay_day` int(1) NOT NULL DEFAULT '0' COMMENT '延迟天使',
  `reward` varchar(500) NOT NULL DEFAULT '[]' COMMENT '奖励列表',
  `desc` varchar(500) NOT NULL DEFAULT '' COMMENT '描述',
  PRIMARY KEY (`pkey`,`act_id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='零元礼包';

-- ----------------------------
--  Table structure for `player_fuwen`
-- ----------------------------
DROP TABLE IF EXISTS `player_fuwen`;
CREATE TABLE `player_fuwen` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `fuwen_exp` int(10) NOT NULL DEFAULT '0' COMMENT '符文经验',
  `fuwen_chip` int(10) NOT NULL DEFAULT '0' COMMENT '符文碎片',
  `pos` int(2) NOT NULL DEFAULT '0' COMMENT '激活位置',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='符文';

-- ----------------------------
--  Table structure for `player_fuwen_map`
-- ----------------------------
DROP TABLE IF EXISTS `player_fuwen_map`;
CREATE TABLE `player_fuwen_map` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `luck_value` int(10) NOT NULL DEFAULT '0' COMMENT '幸运值',
  `fuwen_bag_id` int(10) NOT NULL DEFAULT '0' COMMENT '当前激活符文库ID',
  `last_free_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次免费寻宝时间',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='符文寻宝';

-- ----------------------------
--  Table structure for `player_godness_limit`
-- ----------------------------
DROP TABLE IF EXISTS `player_godness_limit`;
CREATE TABLE `player_godness_limit` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `buy_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '购买的列表记录',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='神邸抢购';

-- ----------------------------
--  Table structure for `player_gold_silver_tower`
-- ----------------------------
DROP TABLE IF EXISTS `player_gold_silver_tower`;
CREATE TABLE `player_gold_silver_tower` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `count_list` varchar(150) NOT NULL DEFAULT '0' COMMENT '抽奖层数记录',
  `index_floor` int(10) NOT NULL DEFAULT '0' COMMENT '当前层数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='金银塔';

-- ----------------------------
--  Table structure for `player_goods_exchange`
-- ----------------------------
DROP TABLE IF EXISTS `player_goods_exchange`;
CREATE TABLE `player_goods_exchange` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `get_list` varchar(150) NOT NULL DEFAULT '[]' COMMENT '已领取的活动列表',
  `get_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后兑换时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家物品兑换信息';

-- ----------------------------
--  Table structure for `player_guide`
-- ----------------------------
DROP TABLE IF EXISTS `player_guide`;
CREATE TABLE `player_guide` (
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `guide_list` text COMMENT '引导k-v列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='新手引导进度表';

-- ----------------------------
--  Table structure for `player_guild_box`
-- ----------------------------
DROP TABLE IF EXISTS `player_guild_box`;
CREATE TABLE `player_guild_box` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `get_cd` int(11) NOT NULL COMMENT '获取cd',
  `is_get_cd` int(11) NOT NULL COMMENT '是否获取cd中',
  `help_cd` int(11) NOT NULL COMMENT '协助cd',
  `is_help_cd` int(11) NOT NULL COMMENT '是否协助cd中',
  `index_id` int(11) NOT NULL COMMENT '当前宝箱id',
  `index_count` int(11) NOT NULL COMMENT '当前刷新次数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='仙盟宝箱';

-- ----------------------------
--  Table structure for `player_guild_fight`
-- ----------------------------
DROP TABLE IF EXISTS `player_guild_fight`;
CREATE TABLE `player_guild_fight` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `challenge_num` int(10) NOT NULL DEFAULT '0',
  `recv_list` varchar(100) NOT NULL DEFAULT '[]',
  `shop` varchar(1024) NOT NULL DEFAULT '[]',
  `challenge_time` int(10) NOT NULL DEFAULT '0' COMMENT '挑战时间',
  `fail_reward` int(10) NOT NULL DEFAULT '0' COMMENT '战败获取的勋章数',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仙盟对战';

-- ----------------------------
--  Table structure for `player_hi_fan`
-- ----------------------------
DROP TABLE IF EXISTS `player_hi_fan`;
CREATE TABLE `player_hi_fan` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `last_login_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次登陆时间',
  `val` int(10) NOT NULL DEFAULT '0' COMMENT 'hi点',
  `list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取列表',
  UNIQUE KEY `key` (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='全民hi翻天';

-- ----------------------------
--  Table structure for `player_hqg_daily_charge`
-- ----------------------------
DROP TABLE IF EXISTS `player_hqg_daily_charge`;
CREATE TABLE `player_hqg_daily_charge` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `charge_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '首次充值额度列表',
  `recv_first` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '已领取首充奖励列表',
  `acc_charge_gold` int(10) NOT NULL DEFAULT '0' COMMENT '累充元宝',
  `recv_acc` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '已领取累充奖励列表',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  `is_first` int(10) NOT NULL DEFAULT '0' COMMENT '首次参与活动领取的累充类型[1,2]',
  `type1` int(10) NOT NULL DEFAULT '0' COMMENT '是否使用的累充1时间戳',
  `type2` int(10) NOT NULL DEFAULT '0' COMMENT '是否使用累充2时间戳',
  `recv_first_list` varchar(2048) DEFAULT '[]' COMMENT '已经领取过的第一次额度列表',
  `test` varchar(11) DEFAULT '[]',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='迷宫寻宝';

-- ----------------------------
--  Table structure for `player_hundred_return`
-- ----------------------------
DROP TABLE IF EXISTS `player_hundred_return`;
CREATE TABLE `player_hundred_return` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动id',
  `state` int(11) NOT NULL DEFAULT '0' COMMENT '是否购买,0未购买,1已购买',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `player_invite_code`
-- ----------------------------
DROP TABLE IF EXISTS `player_invite_code`;
CREATE TABLE `player_invite_code` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `be_invited` int(11) NOT NULL DEFAULT '0' COMMENT '被邀请奖励',
  `nickname` varchar(20) DEFAULT '' COMMENT '昵称',
  `invite_code` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家邀请码',
  `get_list` varchar(150) NOT NULL DEFAULT '[]' COMMENT '已领取列表',
  `invite_num` int(11) NOT NULL DEFAULT '0' COMMENT '已邀请人数',
  `key_list` text NOT NULL COMMENT '邀请玩家key',
  `use_invited_code` varchar(150) NOT NULL COMMENT '已使用邀请码',
  `use_invited_key` int(11) NOT NULL DEFAULT '0' COMMENT '对方key',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家邀请码信息';

-- ----------------------------
--  Table structure for `player_jiandao`
-- ----------------------------
DROP TABLE IF EXISTS `player_jiandao`;
CREATE TABLE `player_jiandao` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `stage` int(10) NOT NULL DEFAULT '0',
  `lv` int(10) NOT NULL DEFAULT '0',
  `point_id` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家剑道';

-- ----------------------------
--  Table structure for `player_jiandao_map`
-- ----------------------------
DROP TABLE IF EXISTS `player_jiandao_map`;
CREATE TABLE `player_jiandao_map` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `luck_value` int(10) NOT NULL DEFAULT '0' COMMENT '幸运值',
  `jiandao_bag_id` int(10) NOT NULL DEFAULT '0' COMMENT '当前激活符文库ID',
  `last_free_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次免费寻宝时间',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='剑道寻宝';

-- ----------------------------
--  Table structure for `player_lim_shop`
-- ----------------------------
DROP TABLE IF EXISTS `player_lim_shop`;
CREATE TABLE `player_lim_shop` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '子活动id',
  `data` text COMMENT '活动数据',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='全服抢购商店活动数据';

-- ----------------------------
--  Table structure for `player_limit_buy`
-- ----------------------------
DROP TABLE IF EXISTS `player_limit_buy`;
CREATE TABLE `player_limit_buy` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `buy_list` varchar(2048) NOT NULL DEFAULT '[]' COMMENT '已经购买的信息列表[{商品shop_id, 商品num}]',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取的列表[Num1, ...]',
  `op_time` int(10) NOT NULL DEFAULT '0',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='限时抢购';

-- ----------------------------
--  Table structure for `player_limit_time_gift`
-- ----------------------------
DROP TABLE IF EXISTS `player_limit_time_gift`;
CREATE TABLE `player_limit_time_gift` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `buy_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '购买的列表记录',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='抢购礼包';

-- ----------------------------
--  Table structure for `player_live_card`
-- ----------------------------
DROP TABLE IF EXISTS `player_live_card`;
CREATE TABLE `player_live_card` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `start_time` int(10) NOT NULL DEFAULT '0' COMMENT '开始时间',
  `last_get_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后领取时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家终身卡信息';

-- ----------------------------
--  Table structure for `player_local_lucky_turn`
-- ----------------------------
DROP TABLE IF EXISTS `player_local_lucky_turn`;
CREATE TABLE `player_local_lucky_turn` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(11) DEFAULT '0' COMMENT '活动ID',
  `score` int(11) DEFAULT '0' COMMENT '积分',
  `ex_list` varchar(500) DEFAULT '[]' COMMENT '积分兑换下标次数',
  `draw_time` int(11) DEFAULT '0' COMMENT '抽奖次数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='本服转盘抽奖';

-- ----------------------------
--  Table structure for `player_login`
-- ----------------------------
DROP TABLE IF EXISTS `player_login`;
CREATE TABLE `player_login` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `sn` smallint(5) NOT NULL COMMENT '服号',
  `pf` int(11) NOT NULL COMMENT '平台代号',
  `accname` varchar(100) DEFAULT '' COMMENT '平台账号',
  `reg_time` int(10) DEFAULT '0' COMMENT '注册时间',
  `reg_ip` varchar(20) DEFAULT '' COMMENT '注册ip',
  `last_login_time` int(10) DEFAULT '0' COMMENT '最后登录时间',
  `last_login_ip` varchar(20) DEFAULT '' COMMENT '最后登录ip',
  `location` varchar(20) DEFAULT '' COMMENT 'ip所在地',
  `logout_time` int(10) DEFAULT '0' COMMENT '登出时间',
  `status` tinyint(1) DEFAULT '0' COMMENT '账号状态0正常1封号',
  `source` varchar(20) DEFAULT '' COMMENT '来源',
  `phone_id` varchar(40) DEFAULT '' COMMENT '设备ID',
  `os` varchar(20) NOT NULL DEFAULT '' COMMENT '系统',
  `game_channel_id` int(10) NOT NULL DEFAULT '0' COMMENT 'game_channel_id',
  `game_id` int(10) NOT NULL DEFAULT '0' COMMENT 'game_id',
  `setting` varchar(250) DEFAULT '' COMMENT '游戏设置',
  `avatar` varchar(100) DEFAULT '' COMMENT '头像地址',
  `login_days` int(11) NOT NULL DEFAULT '0' COMMENT ' 登陆天数',
  `silent` int(10) DEFAULT '0' COMMENT '禁言时间',
  `online` tinyint(1) DEFAULT '0' COMMENT '0离线1在线',
  `total_online_time` int(11) NOT NULL DEFAULT '0' COMMENT '累计在线',
  PRIMARY KEY (`pkey`,`os`),
  KEY `llt` (`last_login_time`) USING BTREE,
  KEY `accname` (`accname`) USING BTREE,
  KEY `rt` (`reg_time`),
  KEY `ri` (`reg_ip`) USING BTREE,
  KEY `gcid` (`game_channel_id`),
  KEY `online` (`online`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家登录信息表';

-- ----------------------------
--  Table structure for `player_login_online`
-- ----------------------------
DROP TABLE IF EXISTS `player_login_online`;
CREATE TABLE `player_login_online` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(5) NOT NULL DEFAULT '0',
  `charge_gold` int(10) NOT NULL DEFAULT '0' COMMENT '累积充值钻石',
  `login_gift` int(1) NOT NULL DEFAULT '0' COMMENT '是否领取当天登陆奖励',
  `online_gift_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '是否领取当天在线奖励',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  UNIQUE KEY `key` (`pkey`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='登陆在线有礼';

-- ----------------------------
--  Table structure for `player_lucky_turn`
-- ----------------------------
DROP TABLE IF EXISTS `player_lucky_turn`;
CREATE TABLE `player_lucky_turn` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(11) DEFAULT '0' COMMENT '活动ID',
  `score` int(11) DEFAULT '0' COMMENT '积分',
  `ex_list` varchar(500) DEFAULT '[]' COMMENT '积分兑换下标次数',
  `draw_time` int(11) DEFAULT '0' COMMENT '抽奖次数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='转盘抽奖';

-- ----------------------------
--  Table structure for `player_lv_gift`
-- ----------------------------
DROP TABLE IF EXISTS `player_lv_gift`;
CREATE TABLE `player_lv_gift` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `get_list` text NOT NULL COMMENT '已领取的等级列表',
  `time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家等级礼包数据';

-- ----------------------------
--  Table structure for `player_market`
-- ----------------------------
DROP TABLE IF EXISTS `player_market`;
CREATE TABLE `player_market` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `sell_num` int(10) NOT NULL DEFAULT '0',
  `buy_num` int(10) NOT NULL DEFAULT '0',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='集市';

-- ----------------------------
--  Table structure for `player_marry`
-- ----------------------------
DROP TABLE IF EXISTS `player_marry`;
CREATE TABLE `player_marry` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `marry_key` bigint(22) NOT NULL COMMENT '结婚key',
  `state` int(10) NOT NULL DEFAULT '0' COMMENT '结婚状态',
  `flower_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次撒花时间',
  `send_beg_num` int(10) NOT NULL DEFAULT '0' COMMENT '送红包次数',
  `send_beg_time` int(10) NOT NULL DEFAULT '0' COMMENT '送红包时间',
  `collect_num` int(10) NOT NULL DEFAULT '0' COMMENT '采集数',
  `collect_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后采集时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家结婚信息';

-- ----------------------------
--  Table structure for `player_marry_designation`
-- ----------------------------
DROP TABLE IF EXISTS `player_marry_designation`;
CREATE TABLE `player_marry_designation` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `designation` varchar(150) NOT NULL DEFAULT '[]' COMMENT '已获取称号列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='结婚称号';

-- ----------------------------
--  Table structure for `player_marry_gift`
-- ----------------------------
DROP TABLE IF EXISTS `player_marry_gift`;
CREATE TABLE `player_marry_gift` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `buy_type` int(1) NOT NULL DEFAULT '0' COMMENT '0没有1限时2永久',
  `recv_first` int(1) NOT NULL DEFAULT '0' COMMENT '固定奖励领取0未领1已领取',
  `daily_recv` int(1) NOT NULL DEFAULT '0' COMMENT '0当天未领1已领取',
  `buy_out_time` int(10) NOT NULL DEFAULT '0' COMMENT '购买香囊过期时间',
  `is_buy` int(10) NOT NULL DEFAULT '0' COMMENT '是否为对方购买',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='爱情香囊';

-- ----------------------------
--  Table structure for `player_marry_heart`
-- ----------------------------
DROP TABLE IF EXISTS `player_marry_heart`;
CREATE TABLE `player_marry_heart` (
  `pkey` int(11) NOT NULL,
  `heart_list` varchar(150) NOT NULL DEFAULT '' COMMENT '羁绊[{id,lv}]',
  `last_heart` int(11) NOT NULL DEFAULT '0' COMMENT '上一次提升的羁绊',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='结婚羁绊';

-- ----------------------------
--  Table structure for `player_marry_rank`
-- ----------------------------
DROP TABLE IF EXISTS `player_marry_rank`;
CREATE TABLE `player_marry_rank` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动id',
  `record_time` int(11) NOT NULL DEFAULT '0' COMMENT '记录时间',
  `re_state` int(11) NOT NULL DEFAULT '0' COMMENT '状态',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='结婚排行榜';

-- ----------------------------
--  Table structure for `player_marry_room`
-- ----------------------------
DROP TABLE IF EXISTS `player_marry_room`;
CREATE TABLE `player_marry_room` (
  `pkey` int(10) NOT NULL,
  `rp_val` int(10) NOT NULL DEFAULT '0' COMMENT '人气值',
  `qm_val` int(10) NOT NULL DEFAULT '0' COMMENT '亲密度',
  `is_marry` int(1) NOT NULL DEFAULT '0' COMMENT '0单身1已婚',
  `love_desc` varchar(100) NOT NULL DEFAULT '""' COMMENT '爱情宣言',
  `love_desc_type` int(10) NOT NULL DEFAULT '0' COMMENT '爱情宣言类型',
  `love_desc_time` int(10) NOT NULL DEFAULT '0' COMMENT '爱情宣言时间',
  `my_look` text NOT NULL COMMENT '我的关注[{sn,pkey}]',
  `my_face` text NOT NULL COMMENT '我的粉丝[{sn, pkey}]',
  `is_first_photo` int(1) NOT NULL DEFAULT '0' COMMENT '设置头像0没有1有',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仙侣大厅';

-- ----------------------------
--  Table structure for `player_marry_tree`
-- ----------------------------
DROP TABLE IF EXISTS `player_marry_tree`;
CREATE TABLE `player_marry_tree` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `lv` int(4) NOT NULL DEFAULT '0',
  `exp` int(10) NOT NULL DEFAULT '0',
  `cbp` int(10) NOT NULL DEFAULT '0' COMMENT '战力',
  `tree_reward_list` text NOT NULL,
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='姻缘树';

-- ----------------------------
--  Table structure for `player_mask`
-- ----------------------------
DROP TABLE IF EXISTS `player_mask`;
CREATE TABLE `player_mask` (
  `player_id` int(11) NOT NULL COMMENT '玩家ID',
  `list` text COMMENT '玩家掩码数据',
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家个人掩码';

-- ----------------------------
--  Table structure for `player_merge_act_acc_charge`
-- ----------------------------
DROP TABLE IF EXISTS `player_merge_act_acc_charge`;
CREATE TABLE `player_merge_act_acc_charge` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `acc_charge_gold` int(10) NOT NULL DEFAULT '0' COMMENT '玩家累充钻石',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '已经领取的额度列表',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次操作时间',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='合服活动累充';

-- ----------------------------
--  Table structure for `player_merge_act_acc_consume`
-- ----------------------------
DROP TABLE IF EXISTS `player_merge_act_acc_consume`;
CREATE TABLE `player_merge_act_acc_consume` (
  `pkey` int(11) unsigned NOT NULL COMMENT '玩家key',
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动id',
  `acc_consume` int(11) NOT NULL DEFAULT '0' COMMENT '累计消费',
  `recv_list` text NOT NULL COMMENT '奖励日志',
  `op_time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='合服玩家消费有礼';

-- ----------------------------
--  Table structure for `player_merge_act_back_buy`
-- ----------------------------
DROP TABLE IF EXISTS `player_merge_act_back_buy`;
CREATE TABLE `player_merge_act_back_buy` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `buy_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '[{id, num}]',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='合服活动之返利限购';

-- ----------------------------
--  Table structure for `player_merge_act_group_charge`
-- ----------------------------
DROP TABLE IF EXISTS `player_merge_act_group_charge`;
CREATE TABLE `player_merge_act_group_charge` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取列表[{类型ID,条件}]',
  `charge_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '活动区间内的充值表',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次操作时间',
  UNIQUE KEY `key` (`pkey`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='合服活动首充团购';

-- ----------------------------
--  Table structure for `player_merge_act_up_target`
-- ----------------------------
DROP TABLE IF EXISTS `player_merge_act_up_target`;
CREATE TABLE `player_merge_act_up_target` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取列表[{类型ID,条件}]',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次操作时间',
  UNIQUE KEY `key` (`pkey`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='合服活动进阶目标1';

-- ----------------------------
--  Table structure for `player_merge_act_up_target2`
-- ----------------------------
DROP TABLE IF EXISTS `player_merge_act_up_target2`;
CREATE TABLE `player_merge_act_up_target2` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取列表[{类型ID,条件}]',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次操作时间',
  UNIQUE KEY `key` (`pkey`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='合服活动进阶目标2';

-- ----------------------------
--  Table structure for `player_merge_act_up_target3`
-- ----------------------------
DROP TABLE IF EXISTS `player_merge_act_up_target3`;
CREATE TABLE `player_merge_act_up_target3` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取列表[{类型ID,条件}]',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次操作时间',
  UNIQUE KEY `key` (`pkey`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='合服活动进阶目标3';

-- ----------------------------
--  Table structure for `player_merge_day7login`
-- ----------------------------
DROP TABLE IF EXISTS `player_merge_day7login`;
CREATE TABLE `player_merge_day7login` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `daysinfo` varchar(150) NOT NULL DEFAULT '[]' COMMENT '已领取天数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='合服七天登陆';

-- ----------------------------
--  Table structure for `player_merge_exchange`
-- ----------------------------
DROP TABLE IF EXISTS `player_merge_exchange`;
CREATE TABLE `player_merge_exchange` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `exchange_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '兑换信息列表',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`),
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='合服兑换活动';

-- ----------------------------
--  Table structure for `player_merge_sign_in`
-- ----------------------------
DROP TABLE IF EXISTS `player_merge_sign_in`;
CREATE TABLE `player_merge_sign_in` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `get_list` text COMMENT '已领取的活动列表',
  `get_gift_time` int(10) NOT NULL DEFAULT '0' COMMENT '普通终极礼包领取时间',
  `charge_list` text COMMENT '累充列表',
  `charge_get_list` text COMMENT '至尊领取列表',
  `charge_gift_time` int(10) NOT NULL DEFAULT '0' COMMENT '至尊终极礼包领取时间',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后更新时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家合服签到信息';

-- ----------------------------
--  Table structure for `player_monopoly`
-- ----------------------------
DROP TABLE IF EXISTS `player_monopoly`;
CREATE TABLE `player_monopoly` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `finish_times` int(10) NOT NULL DEFAULT '0' COMMENT '完成圈数',
  `cell_list` text COMMENT '当前全格子事件id列表',
  `cur_step` int(10) NOT NULL DEFAULT '0' COMMENT '当前步数',
  `cur_step_state` int(10) NOT NULL DEFAULT '0' COMMENT '当前步数状态',
  `dice_num` int(10) NOT NULL DEFAULT '0' COMMENT '总骰子次数',
  `use_dice_num` int(10) NOT NULL DEFAULT '0' COMMENT '已使用骰子次数',
  `buy_dice_num` int(10) NOT NULL DEFAULT '0' COMMENT '购买骰子次数',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `gift_get_list` text COMMENT '圈数礼包领取列表',
  `task_list` text COMMENT '任务状态列表',
  `step_history` text COMMENT '当前圈步数历史',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家大富翁信息';

-- ----------------------------
--  Table structure for `player_month_card`
-- ----------------------------
DROP TABLE IF EXISTS `player_month_card`;
CREATE TABLE `player_month_card` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `start_time` int(10) NOT NULL DEFAULT '0' COMMENT '开始时间',
  `end_time` int(10) NOT NULL DEFAULT '0' COMMENT '结束时间',
  `get_day` int(10) NOT NULL DEFAULT '0' COMMENT '已领取的天数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家月卡信息';

-- ----------------------------
--  Table structure for `player_month_card_gift`
-- ----------------------------
DROP TABLE IF EXISTS `player_month_card_gift`;
CREATE TABLE `player_month_card_gift` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `get_list` text COMMENT '已领取记录',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后领取时间',
  `month_card_time` int(10) NOT NULL DEFAULT '0' COMMENT '月卡激活时间',
  `live_card_time` int(10) NOT NULL DEFAULT '0' COMMENT '终身卡激活时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家月卡全民福利领取信息';

-- ----------------------------
--  Table structure for `player_mystery_shop`
-- ----------------------------
DROP TABLE IF EXISTS `player_mystery_shop`;
CREATE TABLE `player_mystery_shop` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `shop_info` varchar(1024) NOT NULL DEFAULT '0' COMMENT '格子信息',
  `refresh_time` int(10) NOT NULL DEFAULT '0' COMMENT '刷新时间',
  `refresh_num` int(10) NOT NULL DEFAULT '0' COMMENT '刷新次数',
  `buy_num` int(10) NOT NULL DEFAULT '0' COMMENT '购买次数',
  `recv_refresh_reward` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取刷新次数列表',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='神秘商城';

-- ----------------------------
--  Table structure for `player_mystery_tree`
-- ----------------------------
DROP TABLE IF EXISTS `player_mystery_tree`;
CREATE TABLE `player_mystery_tree` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动id',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '积分',
  `count` int(11) NOT NULL DEFAULT '0' COMMENT '当前次数',
  `log_list` text NOT NULL COMMENT '玩家记录',
  PRIMARY KEY (`pkey`,`act_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='秘境神树';

-- ----------------------------
--  Table structure for `player_new_daily_charge`
-- ----------------------------
DROP TABLE IF EXISTS `player_new_daily_charge`;
CREATE TABLE `player_new_daily_charge` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `get_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后领取时间',
  `last_charge_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后充值时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='新每日充值数据';

-- ----------------------------
--  Table structure for `player_new_exchange`
-- ----------------------------
DROP TABLE IF EXISTS `player_new_exchange`;
CREATE TABLE `player_new_exchange` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `exchange_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '兑换信息列表',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`),
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='新兑换活动';

-- ----------------------------
--  Table structure for `player_new_free_gift`
-- ----------------------------
DROP TABLE IF EXISTS `player_new_free_gift`;
CREATE TABLE `player_new_free_gift` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(1) NOT NULL DEFAULT '0' COMMENT '活动id',
  `type` int(1) NOT NULL DEFAULT '0' COMMENT '礼包类型',
  `state` int(1) NOT NULL DEFAULT '0' COMMENT '发送状态',
  `buy_time` int(1) NOT NULL DEFAULT '0' COMMENT '购买时间',
  `delay_day` int(1) NOT NULL DEFAULT '0' COMMENT '延迟天使',
  `reward` varchar(500) NOT NULL DEFAULT '[]' COMMENT '奖励列表',
  `desc` varchar(500) NOT NULL DEFAULT '' COMMENT '描述',
  PRIMARY KEY (`pkey`,`act_id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='零元礼包';

-- ----------------------------
--  Table structure for `player_new_one_charge`
-- ----------------------------
DROP TABLE IF EXISTS `player_new_one_charge`;
CREATE TABLE `player_new_one_charge` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动子id',
  `get_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后领取时间',
  `max_charge` int(10) NOT NULL DEFAULT '0' COMMENT '最大单笔充值金额',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='新单笔充值数据';

-- ----------------------------
--  Table structure for `player_new_wealth_cat`
-- ----------------------------
DROP TABLE IF EXISTS `player_new_wealth_cat`;
CREATE TABLE `player_new_wealth_cat` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动id',
  `id` int(11) NOT NULL DEFAULT '1' COMMENT '当前档位id',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='新招财猫活动表';

-- ----------------------------
--  Table structure for `player_one_recharge`
-- ----------------------------
DROP TABLE IF EXISTS `player_one_recharge`;
CREATE TABLE `player_one_recharge` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `get_acc_ids` text NOT NULL COMMENT '已领取的连续充值活动id',
  `time` int(10) NOT NULL DEFAULT '0' COMMENT '领取时间',
  `charge_list` varchar(150) NOT NULL DEFAULT '[]' COMMENT '充值列表',
  `act_id` int(10) NOT NULL DEFAULT '1' COMMENT '活动id',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家单笔充值表';

-- ----------------------------
--  Table structure for `player_online_gift`
-- ----------------------------
DROP TABLE IF EXISTS `player_online_gift`;
CREATE TABLE `player_online_gift` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `get_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后领取时间',
  `get_list` text COMMENT '今天领取列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='在线奖励数据';

-- ----------------------------
--  Table structure for `player_online_reward`
-- ----------------------------
DROP TABLE IF EXISTS `player_online_reward`;
CREATE TABLE `player_online_reward` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `use_count` int(11) NOT NULL DEFAULT '0' COMMENT '已经使用数量',
  `online_time` int(11) NOT NULL DEFAULT '0' COMMENT '当日在线时长',
  `last_login_time` int(11) NOT NULL DEFAULT '0' COMMENT '上次登陆时间',
  `reward` varchar(150) NOT NULL DEFAULT '[]' COMMENT '已领取奖励id列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='在线有礼';

-- ----------------------------
--  Table structure for `player_online_time_gift`
-- ----------------------------
DROP TABLE IF EXISTS `player_online_time_gift`;
CREATE TABLE `player_online_time_gift` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `get_list` text COMMENT '领取列表',
  `last_get_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后领取时间',
  `online_time` int(10) NOT NULL DEFAULT '0' COMMENT '今天累计在线时长 秒',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='在线时长奖励数据';

-- ----------------------------
--  Table structure for `player_open_act_acc_charge`
-- ----------------------------
DROP TABLE IF EXISTS `player_open_act_acc_charge`;
CREATE TABLE `player_open_act_acc_charge` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `acc_charge_gold` int(10) NOT NULL DEFAULT '0' COMMENT '玩家累充钻石',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '已经领取的额度列表',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次操作时间',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开服活动累充';

-- ----------------------------
--  Table structure for `player_open_act_all_rank`
-- ----------------------------
DROP TABLE IF EXISTS `player_open_act_all_rank`;
CREATE TABLE `player_open_act_all_rank` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '[{rank_type, base_lv}]',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开服活动全民冲榜';

-- ----------------------------
--  Table structure for `player_open_act_all_rank2`
-- ----------------------------
DROP TABLE IF EXISTS `player_open_act_all_rank2`;
CREATE TABLE `player_open_act_all_rank2` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '[{rank_type, base_lv}]',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开服活动全民冲榜2';

-- ----------------------------
--  Table structure for `player_open_act_all_rank3`
-- ----------------------------
DROP TABLE IF EXISTS `player_open_act_all_rank3`;
CREATE TABLE `player_open_act_all_rank3` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '[{rank_type, base_lv}]',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开服活动全民冲榜3';

-- ----------------------------
--  Table structure for `player_open_act_all_target`
-- ----------------------------
DROP TABLE IF EXISTS `player_open_act_all_target`;
CREATE TABLE `player_open_act_all_target` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '[{类型，阶数，达标人数}]',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开服活动全服总动员';

-- ----------------------------
--  Table structure for `player_open_act_all_target2`
-- ----------------------------
DROP TABLE IF EXISTS `player_open_act_all_target2`;
CREATE TABLE `player_open_act_all_target2` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '[{类型，阶数，达标人数}]',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开服活动全服总动员2';

-- ----------------------------
--  Table structure for `player_open_act_all_target3`
-- ----------------------------
DROP TABLE IF EXISTS `player_open_act_all_target3`;
CREATE TABLE `player_open_act_all_target3` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '[{类型，阶数，达标人数}]',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开服活动全服总动员3';

-- ----------------------------
--  Table structure for `player_open_act_back_buy`
-- ----------------------------
DROP TABLE IF EXISTS `player_open_act_back_buy`;
CREATE TABLE `player_open_act_back_buy` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `buy_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '[{id, num}]',
  `op_time` int(10) NOT NULL DEFAULT '0',
  `open_day` int(10) NOT NULL DEFAULT '0' COMMENT '活动开启第几天',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开服活动之返利限购';

-- ----------------------------
--  Table structure for `player_open_act_group_charge`
-- ----------------------------
DROP TABLE IF EXISTS `player_open_act_group_charge`;
CREATE TABLE `player_open_act_group_charge` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取列表[{类型ID,条件}]',
  `charge_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '活动区间内的充值表',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次操作时间',
  UNIQUE KEY `key` (`pkey`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开服活动首充团购';

-- ----------------------------
--  Table structure for `player_open_act_jh_rank`
-- ----------------------------
DROP TABLE IF EXISTS `player_open_act_jh_rank`;
CREATE TABLE `player_open_act_jh_rank` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取列表[{类型ID,条件}]',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次操作时间',
  UNIQUE KEY `key` (`pkey`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开服活动江湖榜';

-- ----------------------------
--  Table structure for `player_open_act_up_target`
-- ----------------------------
DROP TABLE IF EXISTS `player_open_act_up_target`;
CREATE TABLE `player_open_act_up_target` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取列表[{类型ID,条件}]',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次操作时间',
  `open_day` int(10) NOT NULL DEFAULT '0' COMMENT '活动开启的开服天数',
  UNIQUE KEY `key` (`pkey`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开服活动进阶目标';

-- ----------------------------
--  Table structure for `player_open_act_up_target2`
-- ----------------------------
DROP TABLE IF EXISTS `player_open_act_up_target2`;
CREATE TABLE `player_open_act_up_target2` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取列表[{类型ID,条件}]',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次操作时间',
  `open_day` int(10) NOT NULL DEFAULT '0',
  UNIQUE KEY `key` (`pkey`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开服活动进阶目标2';

-- ----------------------------
--  Table structure for `player_open_act_up_target3`
-- ----------------------------
DROP TABLE IF EXISTS `player_open_act_up_target3`;
CREATE TABLE `player_open_act_up_target3` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取列表[{类型ID,条件}]',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次操作时间',
  `open_day` int(10) NOT NULL DEFAULT '0',
  UNIQUE KEY `key` (`pkey`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开服活动进阶目标3';

-- ----------------------------
--  Table structure for `player_open_egg`
-- ----------------------------
DROP TABLE IF EXISTS `player_open_egg`;
CREATE TABLE `player_open_egg` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `charge_val` int(10) NOT NULL DEFAULT '0' COMMENT '累充额度',
  `use_times` int(10) NOT NULL DEFAULT '0' COMMENT '砸蛋次数',
  `get_list` text COMMENT '领取列表',
  `goods_list` text COMMENT '物品库',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家砸蛋信息';

-- ----------------------------
--  Table structure for `player_pet_dun`
-- ----------------------------
DROP TABLE IF EXISTS `player_pet_dun`;
CREATE TABLE `player_pet_dun` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `dun_id` int(10) NOT NULL DEFAULT '0' COMMENT '关卡ID',
  `recv_star_list` text NOT NULL COMMENT '[{chapter章节, star星}]',
  `saodang_list` text NOT NULL COMMENT '[{关卡ID,Num}]',
  `op_time` int(11) NOT NULL,
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='宠物回合制关卡';

-- ----------------------------
--  Table structure for `player_pet_map`
-- ----------------------------
DROP TABLE IF EXISTS `player_pet_map`;
CREATE TABLE `player_pet_map` (
  `pkey` int(10) NOT NULL,
  `map` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '阵型图',
  `use_map` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='宠物对战阵型';

-- ----------------------------
--  Table structure for `player_pk`
-- ----------------------------
DROP TABLE IF EXISTS `player_pk`;
CREATE TABLE `player_pk` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `pk` int(10) NOT NULL DEFAULT '0' COMMENT 'pk状态',
  `pk_val` int(10) NOT NULL DEFAULT '0' COMMENT 'pk值',
  `pk_change_time` int(10) NOT NULL DEFAULT '0' COMMENT 'pk修改时间',
  `pk_old` int(10) NOT NULL DEFAULT '0' COMMENT '旧pk值',
  `chivalry` int(10) NOT NULL DEFAULT '0' COMMENT '狭义值',
  `kill_count` int(10) NOT NULL DEFAULT '0' COMMENT '击杀数',
  `protect_time` int(10) NOT NULL DEFAULT '0' COMMENT '保护到时时间',
  `online_time` int(10) NOT NULL DEFAULT '0' COMMENT '累计挂机时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家pk数据';

-- ----------------------------
--  Table structure for `player_re_login`
-- ----------------------------
DROP TABLE IF EXISTS `player_re_login`;
CREATE TABLE `player_re_login` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `daysinfo` varchar(150) NOT NULL DEFAULT '[]' COMMENT '已领取天数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='回归登陆';

-- ----------------------------
--  Table structure for `player_recharge`
-- ----------------------------
DROP TABLE IF EXISTS `player_recharge`;
CREATE TABLE `player_recharge` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `total_fee` int(10) unsigned DEFAULT '0' COMMENT '充值总金额',
  `total_gold` int(10) DEFAULT '0' COMMENT '总钻石',
  `charge_list` text COMMENT '购买物品列表',
  `return_time` int(10) NOT NULL DEFAULT '0' COMMENT '充值返还时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家充值信息表';

-- ----------------------------
--  Table structure for `player_recharge_rank`
-- ----------------------------
DROP TABLE IF EXISTS `player_recharge_rank`;
CREATE TABLE `player_recharge_rank` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动id',
  `nickname` varchar(150) NOT NULL DEFAULT '[]' COMMENT '玩家昵称',
  `recharge_gold` int(11) NOT NULL DEFAULT '0' COMMENT '充值元宝',
  `change_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后充值时间',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '玩家等级',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='充值排行榜';

-- ----------------------------
--  Table structure for `player_res_gift`
-- ----------------------------
DROP TABLE IF EXISTS `player_res_gift`;
CREATE TABLE `player_res_gift` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家KEY',
  `gift_state` varchar(500) NOT NULL DEFAULT '[]' COMMENT '领取状态 1领取0否 ',
  `praise_gift` tinyint(1) NOT NULL DEFAULT '0' COMMENT '点赞礼包',
  `is_get` int(1) NOT NULL DEFAULT '0' COMMENT '下载礼包-领取红点',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家资料礼包领取状态';

-- ----------------------------
--  Table structure for `player_return_exchange`
-- ----------------------------
DROP TABLE IF EXISTS `player_return_exchange`;
CREATE TABLE `player_return_exchange` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `exchange_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '兑换信息列表',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='回归活动之兑换';

-- ----------------------------
--  Table structure for `player_ring`
-- ----------------------------
DROP TABLE IF EXISTS `player_ring`;
CREATE TABLE `player_ring` (
  `pkey` int(11) NOT NULL,
  `stage` int(11) NOT NULL DEFAULT '0' COMMENT '阶级',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '戒指类型 0单身 1结婚',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='结婚戒指';

-- ----------------------------
--  Table structure for `player_role_d_acc_charge`
-- ----------------------------
DROP TABLE IF EXISTS `player_role_d_acc_charge`;
CREATE TABLE `player_role_d_acc_charge` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `acc_val` int(10) NOT NULL DEFAULT '0' COMMENT '累充金额',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `get_list` text COMMENT '领取列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家角色每日累充信息';

-- ----------------------------
--  Table structure for `player_sign_in`
-- ----------------------------
DROP TABLE IF EXISTS `player_sign_in`;
CREATE TABLE `player_sign_in` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `days` int(11) NOT NULL COMMENT '累计登陆天数',
  `sign_in` text NOT NULL COMMENT '签到记录',
  `acc_reward` text NOT NULL COMMENT '累计登陆奖励',
  `time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='签到';

-- ----------------------------
--  Table structure for `player_skill`
-- ----------------------------
DROP TABLE IF EXISTS `player_skill`;
CREATE TABLE `player_skill` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `skill_effect` tinyint(1) NOT NULL DEFAULT '0' COMMENT '技能效果',
  `skill_battle_list` text NOT NULL COMMENT '技能列表',
  `skill_passive_list` text NOT NULL COMMENT '被动技能列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家技能';

-- ----------------------------
--  Table structure for `player_small_charge_d`
-- ----------------------------
DROP TABLE IF EXISTS `player_small_charge_d`;
CREATE TABLE `player_small_charge_d` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0',
  `charge_list` varchar(1024) NOT NULL DEFAULT '[]',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '[{ChargeGold, RecvNum}]',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`),
  KEY `op_time` (`op_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='小额单笔充值3档';

-- ----------------------------
--  Table structure for `player_smelt`
-- ----------------------------
DROP TABLE IF EXISTS `player_smelt`;
CREATE TABLE `player_smelt` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `stage` int(11) NOT NULL COMMENT '阶数',
  `exp` int(11) NOT NULL COMMENT '经验',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='装备熔炼';

-- ----------------------------
--  Table structure for `player_star_luck`
-- ----------------------------
DROP TABLE IF EXISTS `player_star_luck`;
CREATE TABLE `player_star_luck` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `free_times` int(5) NOT NULL DEFAULT '0' COMMENT '已使用免费次数',
  `star_pos` varchar(150) NOT NULL DEFAULT '[]' COMMENT '占星当前位置',
  `open_bag_num` int(10) NOT NULL DEFAULT '0' COMMENT '经验',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `double_times` int(10) NOT NULL DEFAULT '0' COMMENT '已使用双倍次数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家星运数据';

-- ----------------------------
--  Table structure for `player_star_luck_goods`
-- ----------------------------
DROP TABLE IF EXISTS `player_star_luck_goods`;
CREATE TABLE `player_star_luck_goods` (
  `gkey` bigint(22) NOT NULL COMMENT '物品key',
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `goods_id` int(10) NOT NULL DEFAULT '0' COMMENT '物品id',
  `lv` tinyint(5) NOT NULL DEFAULT '0' COMMENT '等级',
  `exp` int(10) NOT NULL DEFAULT '0' COMMENT '经验',
  `location` tinyint(5) NOT NULL DEFAULT '0' COMMENT '物品位置 1身上 2背包 3占星',
  `pos` tinyint(5) NOT NULL DEFAULT '0' COMMENT '装备的位置',
  `lock` tinyint(5) NOT NULL DEFAULT '0' COMMENT '是否锁定',
  `create_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`gkey`),
  KEY `pkey` (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家星运物品数据';

-- ----------------------------
--  Table structure for `player_star_sign`
-- ----------------------------
DROP TABLE IF EXISTS `player_star_sign`;
CREATE TABLE `player_star_sign` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `data` text COMMENT '活动数据',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家星座数据';

-- ----------------------------
--  Table structure for `player_state`
-- ----------------------------
DROP TABLE IF EXISTS `player_state`;
CREATE TABLE `player_state` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `sn` smallint(5) DEFAULT NULL COMMENT '服号',
  `pf` int(11) DEFAULT NULL COMMENT '平台代号',
  `nickname` varchar(20) DEFAULT '' COMMENT '昵称',
  `lv` smallint(5) DEFAULT '0' COMMENT '等级',
  `career` tinyint(1) DEFAULT '0' COMMENT '职业',
  `sex` tinyint(1) DEFAULT '0' COMMENT '性别1男2女',
  `realm` tinyint(1) DEFAULT '0' COMMENT '阵营',
  `gold` int(10) DEFAULT '0' COMMENT '金币',
  `bgold` int(10) DEFAULT '0' COMMENT '绑定钻石',
  `coin` int(10) DEFAULT '0' COMMENT '铜币',
  `bcoin` int(10) DEFAULT '0' COMMENT '绑定金币',
  `repute` int(10) DEFAULT '0' COMMENT '声望值',
  `honor` int(10) DEFAULT '0',
  `smelt_value` int(10) DEFAULT '0' COMMENT '熔炼值',
  `chips` int(10) NOT NULL DEFAULT '0' COMMENT '消耗碎片值',
  `exp` bigint(10) DEFAULT '0' COMMENT '经验',
  `scene` int(10) DEFAULT '0' COMMENT '场景id',
  `x` smallint(5) DEFAULT '0' COMMENT 'x坐标',
  `y` smallint(5) DEFAULT '0' COMMENT 'y坐标',
  `hp` int(10) DEFAULT '0' COMMENT '血',
  `mp` int(10) DEFAULT '0' COMMENT '蓝',
  `sin` int(10) NOT NULL DEFAULT '0' COMMENT '神罚值',
  `guild_name` varchar(50) NOT NULL DEFAULT '' COMMENT '所在公会名字',
  `mount_id` int(1) NOT NULL DEFAULT '0' COMMENT '坐骑形象id',
  `wing_id` int(1) NOT NULL DEFAULT '0' COMMENT '翅膀形象id',
  `light_weapon_id` int(1) NOT NULL DEFAULT '0' COMMENT '玩家佩戴光武信息',
  `wepon_id` int(1) NOT NULL DEFAULT '0' COMMENT '武器形象id',
  `clothing_id` int(1) NOT NULL DEFAULT '0' COMMENT '衣服形象id',
  `fashion_cloth_id` int(1) NOT NULL DEFAULT '0' COMMENT '时装衣服id',
  `footprint_id` int(1) NOT NULL DEFAULT '0' COMMENT '时装足迹',
  `max_stren_lv` int(1) NOT NULL DEFAULT '0' COMMENT '历史最大强化等级',
  `max_stone_lv` int(1) NOT NULL DEFAULT '0' COMMENT '历史最大镶嵌宝石等级',
  `combat_power` int(10) NOT NULL DEFAULT '0' COMMENT '玩家战力',
  `highest_combat_power` int(11) NOT NULL DEFAULT '0' COMMENT '历史最高战力',
  `attrs` text COMMENT '属性列表',
  `designation` varchar(100) NOT NULL DEFAULT '[]' COMMENT '佩戴的称号类型',
  `arena_pt` int(11) NOT NULL DEFAULT '0' COMMENT '竞技场积分',
  `vip_lv` tinyint(5) NOT NULL DEFAULT '0' COMMENT 'vip等级',
  `revive_times` int(11) NOT NULL DEFAULT '0' COMMENT '时间内复活次数',
  `revive_time` int(11) NOT NULL DEFAULT '0' COMMENT '复活时间',
  `exploit` int(11) NOT NULL DEFAULT '0' COMMENT '功勋',
  `xinghun` int(10) NOT NULL DEFAULT '0' COMMENT '星魂值',
  `lv_up_time` int(10) NOT NULL DEFAULT '0' COMMENT '等级更新时间',
  `gm` tinyint(5) NOT NULL DEFAULT '0' COMMENT '身份 0普通1新手指导员',
  `xingyun_pt` int(10) NOT NULL DEFAULT '0' COMMENT '星运积分',
  `charm` int(1) NOT NULL DEFAULT '0' COMMENT '玩家魅力值',
  `manor_pt` int(11) NOT NULL DEFAULT '0' COMMENT '家园物资',
  `is_interior` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否内部号',
  `head_id` int(11) NOT NULL DEFAULT '0' COMMENT '头部id',
  `reiki` int(10) NOT NULL DEFAULT '0' COMMENT '十荒神器(器灵)',
  `sd_pt` int(10) NOT NULL DEFAULT '0' COMMENT '六龙历练',
  `exploit_pri` int(10) NOT NULL DEFAULT '0' COMMENT '玩家功勋值',
  `x_old` int(10) NOT NULL DEFAULT '0' COMMENT '上一次坐标x',
  `y_old` int(10) NOT NULL DEFAULT '0' COMMENT '上一次坐标y',
  `scene_old` int(10) NOT NULL DEFAULT '0' COMMENT '上一次场景id',
  `old_scene_pk` int(10) NOT NULL DEFAULT '0' COMMENT '上一次切场景的pk',
  `mkey` bigint(20) NOT NULL DEFAULT '0' COMMENT '结婚key',
  `sweet` int(11) NOT NULL DEFAULT '0' COMMENT '甜蜜度',
  `baby_wing_id` int(1) NOT NULL DEFAULT '0' COMMENT '灵羽形象id',
  `new_career` int(11) NOT NULL DEFAULT '0' COMMENT '转身职业',
  `vip_type` int(11) NOT NULL DEFAULT '0' COMMENT '钻石vip 0为拥有 1显示 2永久',
  `login_flag` varchar(100) NOT NULL DEFAULT 'ios' COMMENT '登陆标识，不读只写',
  `return_time` int(11) NOT NULL DEFAULT '0' COMMENT '回归时间',
  `continue_end_time` int(11) NOT NULL DEFAULT '0' COMMENT '回归有效期',
  `equip_part` int(11) NOT NULL DEFAULT '0' COMMENT '装备碎片',
  `act_gold` int(11) NOT NULL DEFAULT '0' COMMENT '活动金币',
  `fairy_crystal` int(11) NOT NULL DEFAULT '0' COMMENT '仙晶',
  PRIMARY KEY (`pkey`),
  KEY `cpw` (`combat_power`) USING BTREE,
  KEY `name` (`nickname`) USING BTREE,
  KEY `scene` (`scene`) USING BTREE,
  KEY `lv` (`lv`) USING BTREE,
  KEY `lv_up_time` (`lv_up_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家游戏信息表';

-- ----------------------------
--  Table structure for `player_target_act`
-- ----------------------------
DROP TABLE IF EXISTS `player_target_act`;
CREATE TABLE `player_target_act` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `target_list` text COMMENT '目标列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家目标福利信息';

-- ----------------------------
--  Table structure for `player_task`
-- ----------------------------
DROP TABLE IF EXISTS `player_task`;
CREATE TABLE `player_task` (
  `pkey` int(11) NOT NULL COMMENT '??KEY',
  `bag` text COMMENT '任务包',
  `log` text COMMENT '任务日志',
  `log_clean` text COMMENT '每日可清任务日志',
  `timestamp` int(11) DEFAULT '0' COMMENT '每日时间戳',
  `story` text COMMENT '剧情ID',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家任务表';

-- ----------------------------
--  Table structure for `player_task_cycle`
-- ----------------------------
DROP TABLE IF EXISTS `player_task_cycle`;
CREATE TABLE `player_task_cycle` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `cycle` int(11) NOT NULL DEFAULT '0' COMMENT '当前环数',
  `tid` int(11) NOT NULL DEFAULT '0' COMMENT '任务ID',
  `log` text NOT NULL COMMENT '已完成任务列表',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `is_reward` tinyint(1) NOT NULL DEFAULT '0' COMMENT '满环奖励是否领取（1是0否）',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跑环任务';

-- ----------------------------
--  Table structure for `player_task_guild`
-- ----------------------------
DROP TABLE IF EXISTS `player_task_guild`;
CREATE TABLE `player_task_guild` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `cycle` int(11) NOT NULL DEFAULT '0' COMMENT '当前环数',
  `tid` int(11) NOT NULL DEFAULT '0' COMMENT '任务ID',
  `log` text NOT NULL COMMENT '已完成任务列表',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `is_reward` tinyint(1) NOT NULL DEFAULT '0' COMMENT '满环奖励是否领取（1是0否）',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仙盟跑环任务';

-- ----------------------------
--  Table structure for `player_task_log`
-- ----------------------------
DROP TABLE IF EXISTS `player_task_log`;
CREATE TABLE `player_task_log` (
  `key` bigint(22) NOT NULL,
  `pkey` int(11) DEFAULT NULL COMMENT '玩家key',
  `taskid` int(10) DEFAULT '0' COMMENT '任务id',
  `type` smallint(5) DEFAULT '0' COMMENT '任务类型',
  `time` int(10) DEFAULT '0' COMMENT '完成时间',
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='历史任务完成记录';

-- ----------------------------
--  Table structure for `player_throw_egg`
-- ----------------------------
DROP TABLE IF EXISTS `player_throw_egg`;
CREATE TABLE `player_throw_egg` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动id',
  `count` int(11) NOT NULL DEFAULT '0' COMMENT '每日次数',
  `count_list` varchar(150) NOT NULL DEFAULT '[]' COMMENT '次数奖励领取记录',
  `is_free` int(11) NOT NULL DEFAULT '0' COMMENT '使用免费次数',
  `re_set_count` int(11) NOT NULL DEFAULT '0' COMMENT '免费刷新次数',
  `egg_info` text NOT NULL COMMENT '金蛋信息',
  `last_login_time` int(11) NOT NULL DEFAULT '0' COMMENT '上次登陆时间',
  `online_time` int(11) NOT NULL DEFAULT '0' COMMENT '当日在线时长',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='疯狂砸蛋';

-- ----------------------------
--  Table structure for `player_throw_fruit`
-- ----------------------------
DROP TABLE IF EXISTS `player_throw_fruit`;
CREATE TABLE `player_throw_fruit` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动id',
  `count` int(11) NOT NULL DEFAULT '0' COMMENT '每日次数',
  `count_list` varchar(150) NOT NULL DEFAULT '[]' COMMENT '次数奖励领取记录',
  `is_free` int(11) NOT NULL DEFAULT '0' COMMENT '使用免费次数',
  `re_set_count` int(11) NOT NULL DEFAULT '0' COMMENT '免费刷新次数',
  `fruit_info` text NOT NULL COMMENT '水果信息',
  `last_login_time` int(11) NOT NULL DEFAULT '0' COMMENT '上次登陆时间',
  `online_time` int(11) NOT NULL DEFAULT '0' COMMENT '当日在线时长',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='水果大战';

-- ----------------------------
--  Table structure for `player_treasure`
-- ----------------------------
DROP TABLE IF EXISTS `player_treasure`;
CREATE TABLE `player_treasure` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `map_id` int(11) NOT NULL DEFAULT '0' COMMENT '藏宝图ID',
  `scene` int(11) NOT NULL DEFAULT '0' COMMENT '场景ID',
  `x` int(11) NOT NULL DEFAULT '0' COMMENT 'X坐标',
  `y` int(11) NOT NULL DEFAULT '0' COMMENT 'Y坐标',
  `shadow_kill` smallint(1) NOT NULL DEFAULT '0' COMMENT '击杀玩家镜像统计',
  `pet_kill` smallint(1) NOT NULL DEFAULT '0' COMMENT '击杀宠物统计',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '每日时间戳',
  `times` smallint(4) NOT NULL DEFAULT '0' COMMENT '挖宝次数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家藏宝图相关';

-- ----------------------------
--  Table structure for `player_treasure_hourse`
-- ----------------------------
DROP TABLE IF EXISTS `player_treasure_hourse`;
CREATE TABLE `player_treasure_hourse` (
  `pkey` int(11) NOT NULL COMMENT '玩家KEY',
  `charge_gold` int(10) NOT NULL DEFAULT '0' COMMENT '活动内充值钻石总数',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `is_recv` int(1) NOT NULL DEFAULT '0' COMMENT '0没有领取1已经领取每日登陆礼包',
  `buy_list` varchar(200) NOT NULL DEFAULT '[]' COMMENT '购买列表[{GiftId,Num}]',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  `act_open_time` int(10) NOT NULL DEFAULT '0' COMMENT '活动开启时间',
  `recv_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`),
  KEY `key` (`act_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='藏宝阁';

-- ----------------------------
--  Table structure for `player_uplv_box`
-- ----------------------------
DROP TABLE IF EXISTS `player_uplv_box`;
CREATE TABLE `player_uplv_box` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `recv_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '领取过的ID列表',
  `use_free_num` int(10) NOT NULL DEFAULT '0' COMMENT '已经使用过的免费次数',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  `online_time` int(10) NOT NULL DEFAULT '0' COMMENT '活动内在线时间',
  `open_day` int(10) NOT NULL DEFAULT '0' COMMENT '活动开启天数',
  UNIQUE KEY `key` (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='进阶宝箱';

-- ----------------------------
--  Table structure for `player_vip`
-- ----------------------------
DROP TABLE IF EXISTS `player_vip`;
CREATE TABLE `player_vip` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `charge_val` int(10) NOT NULL DEFAULT '0' COMMENT '充值额度',
  `other_val` int(10) NOT NULL DEFAULT '0' COMMENT '其他额度',
  `buy_list` text NOT NULL COMMENT 'vip抢购列表',
  `free_lv` int(10) NOT NULL DEFAULT '0' COMMENT 'vip体验等级',
  `free_time` int(10) NOT NULL DEFAULT '0' COMMENT 'vip体验到期时间',
  `week_num` int(10) NOT NULL DEFAULT '0' COMMENT '每周奖励领取数量',
  `week_get_time` int(10) NOT NULL DEFAULT '0' COMMENT '每周领取更新时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家vip信息';

-- ----------------------------
--  Table structure for `player_vip_gift`
-- ----------------------------
DROP TABLE IF EXISTS `player_vip_gift`;
CREATE TABLE `player_vip_gift` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动id',
  `buy_list` text COMMENT '累充金额',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家vip福利信息';

-- ----------------------------
--  Table structure for `player_week_card`
-- ----------------------------
DROP TABLE IF EXISTS `player_week_card`;
CREATE TABLE `player_week_card` (
  `pkey` int(11) NOT NULL,
  `remain_day` int(6) NOT NULL DEFAULT '0' COMMENT '周卡剩余天数',
  `use_time` int(10) NOT NULL DEFAULT '0' COMMENT '使用时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `player_welkin_hunt`
-- ----------------------------
DROP TABLE IF EXISTS `player_welkin_hunt`;
CREATE TABLE `player_welkin_hunt` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动id',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '积分',
  `count` int(11) NOT NULL DEFAULT '0' COMMENT '当前次数',
  `log_list` text NOT NULL COMMENT '玩家记录',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='天宫寻宝';

-- ----------------------------
--  Table structure for `player_wishing_well`
-- ----------------------------
DROP TABLE IF EXISTS `player_wishing_well`;
CREATE TABLE `player_wishing_well` (
  `pkey` int(10) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `act_id` int(6) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `count_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '次数列表[{Type,Count}]',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '积分',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '上次操作时间',
  `gold_coin` int(10) NOT NULL DEFAULT '0' COMMENT '金币数',
  `charge_count` int(11) NOT NULL COMMENT '已经兑换金币次数',
  `charge_val` int(11) NOT NULL DEFAULT '0' COMMENT '未转化金币的充值数',
  `nickname` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '角色名',
  PRIMARY KEY (`pkey`),
  UNIQUE KEY `key` (`pkey`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='许愿池(单服)';

-- ----------------------------
--  Table structure for `player_wybq`
-- ----------------------------
DROP TABLE IF EXISTS `player_wybq`;
CREATE TABLE `player_wybq` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `cbp` int(10) NOT NULL DEFAULT '0' COMMENT '总战力',
  `cbp_list` varchar(2048) NOT NULL DEFAULT '[]' COMMENT '各类型战力列表[{类型，cbp}, ... ]',
  `lv` int(10) NOT NULL DEFAULT '0' COMMENT '玩家等级',
  UNIQUE KEY `key` (`pkey`) USING BTREE,
  KEY `key2` (`cbp`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='我要变强';

-- ----------------------------
--  Table structure for `player_xian_exchange`
-- ----------------------------
DROP TABLE IF EXISTS `player_xian_exchange`;
CREATE TABLE `player_xian_exchange` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `exchange_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '兑换信息列表',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`),
  UNIQUE KEY `key` (`pkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='新兑换活动';

-- ----------------------------
--  Table structure for `player_xian_map`
-- ----------------------------
DROP TABLE IF EXISTS `player_xian_map`;
CREATE TABLE `player_xian_map` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `time1` int(10) NOT NULL DEFAULT '0' COMMENT '地仙寻宝时间',
  `num1` int(10) NOT NULL DEFAULT '0' COMMENT '当天地仙寻宝免费次数',
  `time2` int(10) NOT NULL DEFAULT '0' COMMENT '鸿钧寻宝时间',
  `num2` int(10) NOT NULL DEFAULT '0' COMMENT '当天鸿钧寻宝免费次数',
  `op_time` int(10) NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='飞仙寻宝';

-- ----------------------------
--  Table structure for `player_xian_skill`
-- ----------------------------
DROP TABLE IF EXISTS `player_xian_skill`;
CREATE TABLE `player_xian_skill` (
  `pkey` int(10) NOT NULL,
  `skill_lv_list` varchar(200) NOT NULL DEFAULT '[]' COMMENT '激活列表[{SubType,Lv}]',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仙装技能';

-- ----------------------------
--  Table structure for `player_xian_stage`
-- ----------------------------
DROP TABLE IF EXISTS `player_xian_stage`;
CREATE TABLE `player_xian_stage` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `xian_stage` int(10) NOT NULL DEFAULT '0' COMMENT '仙阶',
  `task_info` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '仙阶任务信息',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仙阶';

-- ----------------------------
--  Table structure for `player_xiulian`
-- ----------------------------
DROP TABLE IF EXISTS `player_xiulian`;
CREATE TABLE `player_xiulian` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `tupo_lv` int(10) NOT NULL DEFAULT '0' COMMENT '突破等级',
  `data_list` text COMMENT '数据',
  `cd_time` int(10) NOT NULL DEFAULT '0' COMMENT 'cd到期时间',
  `spec_times` int(10) NOT NULL DEFAULT '0' COMMENT '使用半价次数',
  `spec_update_time` int(10) NOT NULL DEFAULT '0' COMMENT '使用半价次数更新时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家修炼数据';

-- ----------------------------
--  Table structure for `player_xj_map`
-- ----------------------------
DROP TABLE IF EXISTS `player_xj_map`;
CREATE TABLE `player_xj_map` (
  `pkey` int(10) NOT NULL DEFAULT '0',
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `step` int(10) NOT NULL DEFAULT '0' COMMENT '当前第几个步',
  `use_free_num` int(10) NOT NULL DEFAULT '0' COMMENT '当前使用的寻宝次数',
  `use_reset_num` int(10) NOT NULL DEFAULT '0' COMMENT '当前使用的重置次数',
  `op_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仙境寻宝';

-- ----------------------------
--  Table structure for `player_yuanli`
-- ----------------------------
DROP TABLE IF EXISTS `player_yuanli`;
CREATE TABLE `player_yuanli` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `tupo_lv` int(10) NOT NULL DEFAULT '0' COMMENT '突破等级',
  `data_list` text COMMENT '数据',
  `cd_time` int(10) NOT NULL DEFAULT '0' COMMENT 'cd到期时间',
  `spec_times` int(10) NOT NULL DEFAULT '0' COMMENT '使用半价次数',
  `spec_update_time` int(10) NOT NULL DEFAULT '0' COMMENT '使用半价次数更新时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家原力数据';

-- ----------------------------
--  Table structure for `pray_bag`
-- ----------------------------
DROP TABLE IF EXISTS `pray_bag`;
CREATE TABLE `pray_bag` (
  `key` bigint(22) NOT NULL COMMENT '唯一key',
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `goods_id` int(2) NOT NULL DEFAULT '0' COMMENT '物品id',
  `wash_attr` varchar(500) NOT NULL DEFAULT '' COMMENT '洗练属性',
  `gemstone_groove` varchar(500) NOT NULL DEFAULT '' COMMENT '打孔属性',
  `num` int(1) NOT NULL DEFAULT '0' COMMENT '数量',
  `state` int(1) NOT NULL DEFAULT '0' COMMENT '状态',
  PRIMARY KEY (`key`),
  KEY `index_pkey` (`pkey`) USING HASH COMMENT '玩家pkey索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家祈祷背包';

-- ----------------------------
--  Table structure for `pray_info`
-- ----------------------------
DROP TABLE IF EXISTS `pray_info`;
CREATE TABLE `pray_info` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `max_cell` smallint(5) NOT NULL DEFAULT '25' COMMENT '最大格子数',
  `equip_remain_time` int(1) NOT NULL DEFAULT '0' COMMENT '获取装备剩余时间',
  `quick_times` int(1) NOT NULL DEFAULT '0' COMMENT '今日快速完成时间',
  `fashion_id` int(1) NOT NULL DEFAULT '0' COMMENT '时装id',
  `fashion_time` int(1) NOT NULL DEFAULT '0' COMMENT '时装剩余时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家背包信息表';

-- ----------------------------
--  Table structure for `random_shop_athletics`
-- ----------------------------
DROP TABLE IF EXISTS `random_shop_athletics`;
CREATE TABLE `random_shop_athletics` (
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `id` int(2) NOT NULL DEFAULT '0' COMMENT '商品Id',
  `goods_id` int(2) NOT NULL DEFAULT '0' COMMENT '物品id',
  `wash_attr` varchar(500) NOT NULL DEFAULT '[]' COMMENT '洗练属性',
  `num` int(1) NOT NULL DEFAULT '0' COMMENT '商品数量',
  `gemstone_groove` varchar(500) NOT NULL DEFAULT '[]' COMMENT '镶嵌属性',
  `money` int(2) NOT NULL DEFAULT '0' COMMENT '商品金币价格',
  `diamond` int(2) NOT NULL DEFAULT '0' COMMENT '商品钻石价格',
  PRIMARY KEY (`pkey`,`id`),
  KEY `index_pkey` (`pkey`) USING BTREE COMMENT '玩家key索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家竞技商店数据';

-- ----------------------------
--  Table structure for `random_shop_battlefield`
-- ----------------------------
DROP TABLE IF EXISTS `random_shop_battlefield`;
CREATE TABLE `random_shop_battlefield` (
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `id` int(2) NOT NULL DEFAULT '0' COMMENT '商品id',
  `goods_id` int(2) NOT NULL DEFAULT '0' COMMENT '物品Id',
  `wash_attr` varchar(500) NOT NULL DEFAULT '[]' COMMENT '洗练属性',
  `num` int(1) NOT NULL DEFAULT '0' COMMENT '数量',
  `gemstone_groove` varchar(500) NOT NULL DEFAULT '[]' COMMENT '镶嵌信息',
  `money` int(2) NOT NULL DEFAULT '0' COMMENT '物品出售金币价格',
  `diamond` int(2) NOT NULL DEFAULT '0' COMMENT '物品出售钻石价格',
  PRIMARY KEY (`pkey`,`id`),
  KEY `index_pkey` (`pkey`) USING BTREE COMMENT '玩家key所以'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家黑店数据';

-- ----------------------------
--  Table structure for `random_shop_black`
-- ----------------------------
DROP TABLE IF EXISTS `random_shop_black`;
CREATE TABLE `random_shop_black` (
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `id` int(2) NOT NULL DEFAULT '0' COMMENT '商品id',
  `goods_id` int(2) NOT NULL DEFAULT '0' COMMENT '物品Id',
  `wash_attr` varchar(500) NOT NULL DEFAULT '[]' COMMENT '洗练属性',
  `num` int(1) NOT NULL DEFAULT '0' COMMENT '数量',
  `gemstone_groove` varchar(500) NOT NULL DEFAULT '[]' COMMENT '镶嵌信息',
  `money` int(2) NOT NULL DEFAULT '0' COMMENT '物品出售金币价格',
  `diamond` int(2) NOT NULL DEFAULT '0' COMMENT '物品出售钻石价格',
  PRIMARY KEY (`pkey`,`id`),
  KEY `index_pkey` (`pkey`) USING HASH COMMENT '玩家key所以'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家黑店数据';

-- ----------------------------
--  Table structure for `random_shop_guild`
-- ----------------------------
DROP TABLE IF EXISTS `random_shop_guild`;
CREATE TABLE `random_shop_guild` (
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `id` int(2) NOT NULL DEFAULT '0' COMMENT '商品Id',
  `goods_id` int(2) NOT NULL DEFAULT '0' COMMENT '物品id',
  `wash_attr` varchar(500) NOT NULL DEFAULT '[]' COMMENT '洗练属性',
  `num` int(1) NOT NULL DEFAULT '0' COMMENT '商品数量',
  `gemstone_groove` varchar(500) NOT NULL DEFAULT '[]' COMMENT '镶嵌属性',
  `money` int(2) NOT NULL DEFAULT '0' COMMENT '商品金币价格',
  `diamond` int(2) NOT NULL DEFAULT '0' COMMENT '商品钻石价格',
  PRIMARY KEY (`pkey`,`id`),
  KEY `index_pkey` (`pkey`) USING BTREE COMMENT '玩家key索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家公会商店数据';

-- ----------------------------
--  Table structure for `random_shop_mystical`
-- ----------------------------
DROP TABLE IF EXISTS `random_shop_mystical`;
CREATE TABLE `random_shop_mystical` (
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `id` int(2) NOT NULL DEFAULT '0' COMMENT '商品id',
  `goods_id` int(2) NOT NULL DEFAULT '0' COMMENT '物品id',
  `wash_attr` varchar(500) NOT NULL DEFAULT '[]' COMMENT '洗练属性',
  `num` int(1) NOT NULL DEFAULT '0' COMMENT '默认数量',
  `gemstone_groove` varchar(500) NOT NULL DEFAULT '[]' COMMENT '镶嵌属性',
  `money` int(2) NOT NULL DEFAULT '0' COMMENT '商品出售金币价格',
  `diamond` int(2) NOT NULL DEFAULT '0' COMMENT '商品出售钻石价格',
  PRIMARY KEY (`pkey`,`id`),
  KEY `index_pkey` (`pkey`) USING HASH COMMENT '玩家key索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家神秘商店数据';

-- ----------------------------
--  Table structure for `random_shop_refresh_count`
-- ----------------------------
DROP TABLE IF EXISTS `random_shop_refresh_count`;
CREATE TABLE `random_shop_refresh_count` (
  `pkey` int(11) NOT NULL,
  `mystical_shop_refresh_time` int(1) NOT NULL DEFAULT '0',
  `black_shop_refresh_time` int(1) NOT NULL DEFAULT '0',
  `smelt_shop_refresh_time` int(1) NOT NULL DEFAULT '0',
  `athletics_shop_refresh_time` int(1) NOT NULL DEFAULT '0',
  `guild_shop_refresh_time` int(1) NOT NULL DEFAULT '0',
  `battlefield_shop_refresh_time` int(1) NOT NULL DEFAULT '0',
  `star_shop_refresh_time` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家随机商店信息';

-- ----------------------------
--  Table structure for `random_shop_refresh_time`
-- ----------------------------
DROP TABLE IF EXISTS `random_shop_refresh_time`;
CREATE TABLE `random_shop_refresh_time` (
  `pkey` int(11) NOT NULL,
  `mystical_shop_refresh_time` int(1) NOT NULL DEFAULT '0',
  `black_shop_refresh_time` int(1) NOT NULL DEFAULT '0',
  `smelt_shop_refresh_time` int(1) NOT NULL DEFAULT '0',
  `athletics_shop_refresh_time` int(1) NOT NULL DEFAULT '0',
  `guild_shop_refresh_time` int(1) NOT NULL DEFAULT '0',
  `battlefield_shop_refresh_time` int(1) NOT NULL DEFAULT '0',
  `star_shop_refresh_time` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家随机商店信息';

-- ----------------------------
--  Table structure for `random_shop_smelt`
-- ----------------------------
DROP TABLE IF EXISTS `random_shop_smelt`;
CREATE TABLE `random_shop_smelt` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `id` int(2) NOT NULL DEFAULT '0' COMMENT '商品id',
  `goods_id` int(2) NOT NULL DEFAULT '0' COMMENT '物品Id',
  `wash_attr` varchar(500) NOT NULL DEFAULT '[]' COMMENT '洗练属性',
  `num` int(1) NOT NULL DEFAULT '0' COMMENT '物品数量',
  `gemstone_groove` varchar(500) NOT NULL DEFAULT '[]' COMMENT '镶孔信息',
  `money` int(2) NOT NULL DEFAULT '0' COMMENT '出售金币价格',
  `diamond` int(2) NOT NULL DEFAULT '0' COMMENT '出售钻石价格',
  PRIMARY KEY (`pkey`,`id`),
  KEY `inexe_pkey` (`pkey`) USING BTREE COMMENT '玩家key索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家熔炼商店数据';

-- ----------------------------
--  Table structure for `random_shop_star`
-- ----------------------------
DROP TABLE IF EXISTS `random_shop_star`;
CREATE TABLE `random_shop_star` (
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `id` int(2) NOT NULL DEFAULT '0' COMMENT '商品id',
  `goods_id` int(2) NOT NULL DEFAULT '0' COMMENT '物品id',
  `wash_attr` varchar(500) NOT NULL DEFAULT '[]' COMMENT '洗练属性',
  `num` int(1) NOT NULL DEFAULT '0' COMMENT '默认数量',
  `gemstone_groove` varchar(500) NOT NULL DEFAULT '[]' COMMENT '镶嵌属性',
  `money` int(2) NOT NULL DEFAULT '0' COMMENT '商品出售金币价格',
  `diamond` int(2) NOT NULL DEFAULT '0' COMMENT '商品出售钻石价格',
  PRIMARY KEY (`pkey`,`id`),
  KEY `index_pkey` (`pkey`) USING BTREE COMMENT '玩家key索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='星运商店表';

-- ----------------------------
--  Table structure for `rank_wp`
-- ----------------------------
DROP TABLE IF EXISTS `rank_wp`;
CREATE TABLE `rank_wp` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家ID',
  `worship_times` int(10) DEFAULT '0' COMMENT '膜拜次数',
  `update_time` int(10) DEFAULT '0' COMMENT '更新时间',
  `worship_list` varchar(200) DEFAULT '[]' COMMENT '被膜拜列表',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='排行榜膜拜';

-- ----------------------------
--  Table structure for `recently_contacts`
-- ----------------------------
DROP TABLE IF EXISTS `recently_contacts`;
CREATE TABLE `recently_contacts` (
  `pkey` int(11) NOT NULL COMMENT '记录key',
  `contacts` varchar(1500) NOT NULL DEFAULT '' COMMENT '联系人',
  PRIMARY KEY (`pkey`),
  KEY `k1` (`contacts`(255)) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='关系表';

-- ----------------------------
--  Table structure for `recharge`
-- ----------------------------
DROP TABLE IF EXISTS `recharge`;
CREATE TABLE `recharge` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `jh_order_id` char(100) DEFAULT '' COMMENT '君海订单号',
  `app_order_id` char(100) DEFAULT '' COMMENT '应用订单号',
  `app_role_id` int(11) NOT NULL COMMENT '玩家key',
  `user_id` char(100) DEFAULT '' COMMENT '用户id',
  `channel_id` int(10) DEFAULT '0' COMMENT '渠道ID/平台ID',
  `game_channel_id` int(10) DEFAULT '0' COMMENT '渠道id',
  `server_id` int(10) DEFAULT '0' COMMENT '服务器号',
  `time` int(10) DEFAULT '0' COMMENT '充值时间戳',
  `total_fee` int(10) DEFAULT '0' COMMENT '充值金额(分)',
  `pay_result` tinyint(1) DEFAULT '1',
  `goods_type` int(10) DEFAULT '0' COMMENT '购买的物品类型 0钻石1月卡',
  `lv` int(10) DEFAULT '0' COMMENT '玩家等级',
  `career` tinyint(1) DEFAULT '0' COMMENT '玩家职业',
  `nickname` varchar(100) DEFAULT '' COMMENT '玩家昵称',
  `state` tinyint(1) DEFAULT '0' COMMENT '1未进账0已进账',
  `product_id` int(10) NOT NULL COMMENT '最终购买的产品id',
  `total_gold` int(10) NOT NULL COMMENT '最终给予的钻石数',
  `base_gold` int(10) NOT NULL DEFAULT '0' COMMENT '最终增加的基础钻石',
  `res_product_id` int(10) NOT NULL DEFAULT '0' COMMENT '最终商品id',
  `pay_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '支付类型1网页，其他',
  PRIMARY KEY (`id`),
  KEY `order1` (`jh_order_id`) USING BTREE,
  KEY `name` (`nickname`) USING BTREE,
  KEY `time` (`time`) USING BTREE,
  KEY `key` (`app_role_id`) USING BTREE,
  KEY `order2` (`app_order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=513 DEFAULT CHARSET=utf8 COMMENT='充值表';

-- ----------------------------
--  Table structure for `relation`
-- ----------------------------
DROP TABLE IF EXISTS `relation`;
CREATE TABLE `relation` (
  `rkey` bigint(22) NOT NULL COMMENT '记录key',
  `key1` int(11) DEFAULT NULL COMMENT '玩家1key',
  `key2` int(11) DEFAULT NULL COMMENT '玩家2key',
  `type` tinyint(1) DEFAULT '0' COMMENT '1好友2黑名单3仇人',
  `qinmidu` int(1) NOT NULL DEFAULT '0' COMMENT '亲密度',
  `key1_avatar` varchar(200) NOT NULL DEFAULT '' COMMENT '头像url',
  `key2_avatar` varchar(200) NOT NULL DEFAULT '' COMMENT '头像URL',
  `time` int(10) DEFAULT '0' COMMENT '添加时间戳',
  `qinmidu_args` varchar(200) NOT NULL DEFAULT '[]' COMMENT '每日亲密度变化',
  PRIMARY KEY (`rkey`),
  KEY `k1` (`key1`) USING BTREE,
  KEY `k2` (`key2`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='关系表';

-- ----------------------------
--  Table structure for `sensitive_word`
-- ----------------------------
DROP TABLE IF EXISTS `sensitive_word`;
CREATE TABLE `sensitive_word` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `word_list` longtext NOT NULL COMMENT '敏感词列表',
  `time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `server_info`
-- ----------------------------
DROP TABLE IF EXISTS `server_info`;
CREATE TABLE `server_info` (
  `sn` int(10) NOT NULL,
  `opentime` int(10) DEFAULT '0' COMMENT '开服时间',
  PRIMARY KEY (`sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='游戏服信息表';

-- ----------------------------
--  Table structure for `server_key`
-- ----------------------------
DROP TABLE IF EXISTS `server_key`;
CREATE TABLE `server_key` (
  `sn` int(11) NOT NULL DEFAULT '0' COMMENT '服务器号',
  `unique_id` bigint(22) NOT NULL DEFAULT '0' COMMENT '自增id',
  `player_id` int(11) NOT NULL DEFAULT '0' COMMENT '玩家自增id',
  PRIMARY KEY (`sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家key自增id';

-- ----------------------------
--  Table structure for `shadow`
-- ----------------------------
DROP TABLE IF EXISTS `shadow`;
CREATE TABLE `shadow` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家KEY',
  `nickname` varchar(100) NOT NULL DEFAULT '' COMMENT '昵称',
  `career` tinyint(1) NOT NULL COMMENT '职业',
  `sex` tinyint(1) NOT NULL COMMENT '性别',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战力',
  `attrs` text NOT NULL COMMENT '分身数据',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服镜像数据';

-- ----------------------------
--  Table structure for `strength_exp`
-- ----------------------------
DROP TABLE IF EXISTS `strength_exp`;
CREATE TABLE `strength_exp` (
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  `exp_string` varchar(1000) NOT NULL DEFAULT '' COMMENT '经验文档',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='强化经验表';

-- ----------------------------
--  Table structure for `strength_lv`
-- ----------------------------
DROP TABLE IF EXISTS `strength_lv`;
CREATE TABLE `strength_lv` (
  `pkey` int(11) NOT NULL COMMENT '玩家唯一key',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='强化等级老数据是否已经处理';

-- ----------------------------
--  Table structure for `sword_pool`
-- ----------------------------
DROP TABLE IF EXISTS `sword_pool`;
CREATE TABLE `sword_pool` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `figure` int(11) NOT NULL DEFAULT '0' COMMENT '形象id',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验',
  `target_list` text NOT NULL COMMENT '今日已完成目标',
  `exp_daily` int(11) NOT NULL DEFAULT '0' COMMENT '每日经验',
  `goods_daily` tinyint(1) NOT NULL DEFAULT '0' COMMENT '每日奖励状态',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '每日时间戳',
  `find_back_list` text NOT NULL COMMENT '可找回次数',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='剑池';

-- ----------------------------
--  Table structure for `sys_campaign_join_log`
-- ----------------------------
DROP TABLE IF EXISTS `sys_campaign_join_log`;
CREATE TABLE `sys_campaign_join_log` (
  `camp_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `act_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动子ID',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家ID',
  `info_list` text COMMENT '玩家参与数据',
  PRIMARY KEY (`camp_id`,`act_id`,`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家活动参与数据';

-- ----------------------------
--  Table structure for `sys_limit_buy`
-- ----------------------------
DROP TABLE IF EXISTS `sys_limit_buy`;
CREATE TABLE `sys_limit_buy` (
  `act_id` int(10) NOT NULL DEFAULT '0' COMMENT '活动ID',
  `sys_buy_list` varchar(2048) NOT NULL DEFAULT '[]' COMMENT '系统购买信息列表',
  UNIQUE KEY `key` (`act_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统抢购数据表';

-- ----------------------------
--  Table structure for `taobao_bag`
-- ----------------------------
DROP TABLE IF EXISTS `taobao_bag`;
CREATE TABLE `taobao_bag` (
  `gkey` bigint(22) NOT NULL COMMENT 'key',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `goods_id` int(9) NOT NULL DEFAULT '0' COMMENT '类型id',
  `location` tinyint(2) NOT NULL DEFAULT '0' COMMENT '位置',
  `cell` smallint(2) NOT NULL DEFAULT '0' COMMENT '所在格子 ',
  `state` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 正常 1删除',
  `num` smallint(5) unsigned NOT NULL DEFAULT '1' COMMENT '数量',
  `bind` tinyint(2) NOT NULL DEFAULT '0' COMMENT '绑定状态',
  `expiretime` int(10) DEFAULT '0' COMMENT '过期时间',
  `createtime` int(10) DEFAULT '0' COMMENT '创建时间',
  `origin` int(10) DEFAULT '0' COMMENT '来源0系统',
  `goods_lv` int(1) NOT NULL DEFAULT '0' COMMENT '物品等级',
  `star` int(1) NOT NULL DEFAULT '0' COMMENT '星星',
  `stren` tinyint(2) DEFAULT '0' COMMENT '强化数',
  `color` int(1) NOT NULL DEFAULT '0' COMMENT '颜色',
  `wash_luck_value` int(1) NOT NULL DEFAULT '0' COMMENT '幸运值',
  `wash_attrs` varchar(300) DEFAULT '' COMMENT '洗练属性列表',
  `gemstone_groove` varchar(100) DEFAULT '' COMMENT '镶嵌的宝石',
  `total_attrs` varchar(200) DEFAULT '' COMMENT '总属性',
  `combat_power` int(1) DEFAULT '0' COMMENT '战斗力',
  `lock_s` int(11) NOT NULL DEFAULT '0' COMMENT '锁定状态',
  PRIMARY KEY (`gkey`),
  KEY `expire` (`expiretime`) USING BTREE,
  KEY `pid` (`pkey`) USING BTREE,
  KEY `cpw` (`combat_power`) USING BTREE,
  KEY `location` (`location`) USING BTREE,
  KEY `cell` (`cell`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='淘宝背包物品表';

-- ----------------------------
--  Table structure for `taobao_info`
-- ----------------------------
DROP TABLE IF EXISTS `taobao_info`;
CREATE TABLE `taobao_info` (
  `pkey` int(11) NOT NULL COMMENT 'pkey',
  `luck_value` int(1) NOT NULL DEFAULT '0' COMMENT '幸运值',
  `times` varchar(100) NOT NULL DEFAULT '' COMMENT '今日剩余次数',
  `refresh_times` varchar(200) NOT NULL DEFAULT '' COMMENT '刷新时间',
  `recently_goods` varchar(200) NOT NULL DEFAULT '' COMMENT '最近自己淘宝获得的东西',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='淘宝信息表';

-- ----------------------------
--  Table structure for `war_team`
-- ----------------------------
DROP TABLE IF EXISTS `war_team`;
CREATE TABLE `war_team` (
  `wtkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '公会ID',
  `name` varchar(50) NOT NULL DEFAULT 'Helloword' COMMENT '公会名称',
  `num` tinyint(1) NOT NULL DEFAULT '0' COMMENT '人数',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '会长KEY',
  `pname` varchar(50) NOT NULL DEFAULT 'Helloword' COMMENT '会长昵称',
  `pcareer` smallint(4) NOT NULL DEFAULT '0' COMMENT '会长职业',
  `pvip` int(10) NOT NULL DEFAULT '0' COMMENT '帮主vip等级',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `sn` int(10) NOT NULL DEFAULT '0' COMMENT '服号',
  `win` int(10) NOT NULL DEFAULT '0' COMMENT '胜场',
  `lose` int(10) NOT NULL DEFAULT '0' COMMENT '败场',
  `score` int(10) NOT NULL DEFAULT '0' COMMENT '积分',
  PRIMARY KEY (`wtkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公会信息';

-- ----------------------------
--  Table structure for `war_team_apply`
-- ----------------------------
DROP TABLE IF EXISTS `war_team_apply`;
CREATE TABLE `war_team_apply` (
  `akey` bigint(22) NOT NULL DEFAULT '0' COMMENT '唯一ID',
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `wtkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '战队key',
  `nickname` varchar(50) NOT NULL DEFAULT '[]' COMMENT '名称',
  `career` int(11) NOT NULL DEFAULT '0' COMMENT '玩家职业',
  `lv` int(11) NOT NULL DEFAULT '0' COMMENT '等级',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战斗力',
  `vip` int(11) NOT NULL DEFAULT '0' COMMENT 'vip',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT '申请时间',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '排名',
  PRIMARY KEY (`akey`),
  KEY `pkey` (`pkey`),
  KEY `wtkey` (`wtkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='战队申请表';

-- ----------------------------
--  Table structure for `war_team_member`
-- ----------------------------
DROP TABLE IF EXISTS `war_team_member`;
CREATE TABLE `war_team_member` (
  `pkey` int(11) NOT NULL COMMENT '玩家key',
  `wtkey` bigint(22) NOT NULL DEFAULT '0' COMMENT '战队key',
  `position` int(1) NOT NULL DEFAULT '0' COMMENT '职位',
  `career` int(1) NOT NULL DEFAULT '0' COMMENT '职业',
  `sex` int(1) NOT NULL DEFAULT '0' COMMENT '性别',
  `lv` int(1) NOT NULL DEFAULT '0' COMMENT '等级',
  `vip` int(1) NOT NULL DEFAULT '0' COMMENT 'vip',
  `join_time` int(11) NOT NULL DEFAULT '0' COMMENT '加入时间',
  `att` int(11) NOT NULL DEFAULT '0' COMMENT '伤害',
  `der` int(11) NOT NULL DEFAULT '0' COMMENT '承受伤害',
  `rank` int(11) NOT NULL DEFAULT '0' COMMENT '最高排名',
  `count` int(11) NOT NULL DEFAULT '0' COMMENT '参与次数',
  `name` varchar(50) NOT NULL DEFAULT '[]' COMMENT '名称',
  `use_role` varchar(500) NOT NULL DEFAULT '[]' COMMENT '常用角色',
  `kill` int(11) NOT NULL DEFAULT '0' COMMENT '杀人数',
  PRIMARY KEY (`pkey`),
  KEY `wtkey` (`wtkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公会成员';

-- ----------------------------
--  Table structure for `wash_recover`
-- ----------------------------
DROP TABLE IF EXISTS `wash_recover`;
CREATE TABLE `wash_recover` (
  `pkey` int(11) NOT NULL COMMENT 'pkey',
  `wash_attr` text NOT NULL COMMENT '洗练恢复属性',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='洗练恢复表';

-- ----------------------------
--  Table structure for `wdjt`
-- ----------------------------
DROP TABLE IF EXISTS `wdjt`;
CREATE TABLE `wdjt` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `wing`
-- ----------------------------
DROP TABLE IF EXISTS `wing`;
CREATE TABLE `wing` (
  `pkey` int(11) NOT NULL,
  `stage` int(1) NOT NULL COMMENT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `bless_cd` int(11) NOT NULL DEFAULT '0',
  `current_image_id` int(1) NOT NULL DEFAULT '0',
  `own_special_image` varchar(500) NOT NULL DEFAULT '',
  `combatpower` int(10) NOT NULL DEFAULT '0' COMMENT '光翼战力',
  `star_list` varchar(400) NOT NULL DEFAULT '[]' COMMENT '星等',
  `skill_list` varchar(400) NOT NULL DEFAULT '[]' COMMENT '技能列表',
  `equip_list` varchar(500) NOT NULL DEFAULT '[]' COMMENT '装备列表',
  `grow_num` int(11) NOT NULL DEFAULT '0' COMMENT '成长丹数量',
  `cbp` int(11) NOT NULL DEFAULT '0' COMMENT '战力',
  `attribute` text NOT NULL COMMENT '属性列表',
  `spirit_list` text NOT NULL COMMENT '灵脉列表',
  `last_spirit` int(11) NOT NULL DEFAULT '0' COMMENT '上一次提升的灵脉',
  `spirit` int(11) NOT NULL DEFAULT '0' COMMENT '灵力值',
  `activation_list` text NOT NULL COMMENT '外观等级激活',
  PRIMARY KEY (`pkey`),
  KEY `stage` (`stage`) USING BTREE,
  KEY `combatpower` (`combatpower`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='玩家翅膀表';

-- ----------------------------
--  Table structure for `wish_tree`
-- ----------------------------
DROP TABLE IF EXISTS `wish_tree`;
CREATE TABLE `wish_tree` (
  `pkey` int(11) NOT NULL DEFAULT '0' COMMENT '玩家key',
  `goods_list` varchar(1000) NOT NULL DEFAULT '[]' COMMENT '物品id',
  `lv` int(1) NOT NULL DEFAULT '0' COMMENT '等级',
  `exp` int(1) NOT NULL DEFAULT '0' COMMENT '经验',
  `free_times` int(1) NOT NULL DEFAULT '0' COMMENT '免费刷新次数',
  `refresh_progress` int(1) unsigned NOT NULL DEFAULT '0' COMMENT '刷新进度',
  `orange_goods_list` varchar(1000) NOT NULL DEFAULT '[]' COMMENT '橙色装备',
  `client_rank_value` int(1) NOT NULL DEFAULT '0' COMMENT '随机值',
  `maturity_degree` int(1) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `max_maturity_degree` int(1) NOT NULL DEFAULT '0' COMMENT '最大成熟度',
  `last_watering_time` int(1) NOT NULL DEFAULT '0' COMMENT '上次浇水时间',
  `pick_goods` varchar(500) NOT NULL DEFAULT '[]' COMMENT '强化数',
  `watering_times` int(1) NOT NULL DEFAULT '0' COMMENT '浇水次数',
  `fertilizer_times` int(1) NOT NULL DEFAULT '0' COMMENT '施肥次数',
  `harvest_time` int(1) NOT NULL DEFAULT '0' COMMENT '收货时间',
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='许愿树表';

-- ----------------------------
--  Table structure for `worship`
-- ----------------------------
DROP TABLE IF EXISTS `worship`;
CREATE TABLE `worship` (
  `worship_list` varchar(500) NOT NULL DEFAULT '[]' COMMENT '雕像列表',
  `time` int(10) NOT NULL DEFAULT '0' COMMENT '换人时间',
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='王城雕像数据';

SET FOREIGN_KEY_CHECKS = 1;
