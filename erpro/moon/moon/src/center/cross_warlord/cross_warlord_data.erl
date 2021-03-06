%%----------------------------------------------------
%% @doc 武神坛 配置数据 
%% @author  shawn
%% @end
%%----------------------------------------------------
-module(cross_warlord_data).
-export([
        get_zone_type/1
        ,rank_to_zone/1
    ]
).

-include("cross_warlord.hrl").

get_zone_type(?cross_warlord_quality_trial_0) -> {mode_1, 256, 1};
get_zone_type(?cross_warlord_quality_trial_1) -> {mode_1, 128, 1};
get_zone_type(?cross_warlord_quality_trial_2) -> {mode_1, 64, 1};
get_zone_type(?cross_warlord_quality_trial_3) -> {mode_1, 32, 1};
get_zone_type(?cross_warlord_quality_top_32) -> {mode_1, 16, 1};
get_zone_type(?cross_warlord_quality_top_16) -> {mode_1, 8, 1};
get_zone_type(?cross_warlord_quality_top_8) -> {mode_2, 4, 1};
get_zone_type(?cross_warlord_quality_top_4_1) -> {mode_2, 1, 1};
get_zone_type(?cross_warlord_quality_top_4_2) -> {mode_2, 1, 2};
get_zone_type(?cross_warlord_quality_semi_final) -> {mode_2, 1, 1};
get_zone_type(?cross_warlord_quality_final) -> {mode_2, 1, 1};
get_zone_type(_) -> false.

rank_to_zone(1) -> {1,1};
rank_to_zone(2) -> {32,1};
rank_to_zone(3) -> {17,1};
rank_to_zone(4) -> {16,1};
rank_to_zone(5) -> {9,1};
rank_to_zone(6) -> {24,1};
rank_to_zone(7) -> {25,1};
rank_to_zone(8) -> {8,1};
rank_to_zone(9) -> {5,1};
rank_to_zone(10) -> {28,1};
rank_to_zone(11) -> {21,1};
rank_to_zone(12) -> {12,1};
rank_to_zone(13) -> {13,1};
rank_to_zone(14) -> {20,1};
rank_to_zone(15) -> {29,1};
rank_to_zone(16) -> {4,1};
rank_to_zone(17) -> {3,1};
rank_to_zone(18) -> {30,1};
rank_to_zone(19) -> {19,1};
rank_to_zone(20) -> {14,1};
rank_to_zone(21) -> {11,1};
rank_to_zone(22) -> {22,1};
rank_to_zone(23) -> {27,1};
rank_to_zone(24) -> {6,1};
rank_to_zone(25) -> {7,1};
rank_to_zone(26) -> {26,1};
rank_to_zone(27) -> {23,1};
rank_to_zone(28) -> {10,1};
rank_to_zone(29) -> {15,1};
rank_to_zone(30) -> {18,1};
rank_to_zone(31) -> {31,1};
rank_to_zone(32) -> {2,1};
rank_to_zone(33) -> {2,16};
rank_to_zone(34) -> {31,16};
rank_to_zone(35) -> {18,16};
rank_to_zone(36) -> {15,16};
rank_to_zone(37) -> {10,16};
rank_to_zone(38) -> {23,16};
rank_to_zone(39) -> {26,16};
rank_to_zone(40) -> {7,16};
rank_to_zone(41) -> {6,16};
rank_to_zone(42) -> {27,16};
rank_to_zone(43) -> {22,16};
rank_to_zone(44) -> {11,16};
rank_to_zone(45) -> {14,16};
rank_to_zone(46) -> {19,16};
rank_to_zone(47) -> {30,16};
rank_to_zone(48) -> {3,16};
rank_to_zone(49) -> {4,16};
rank_to_zone(50) -> {29,16};
rank_to_zone(51) -> {20,16};
rank_to_zone(52) -> {13,16};
rank_to_zone(53) -> {12,16};
rank_to_zone(54) -> {21,16};
rank_to_zone(55) -> {28,16};
rank_to_zone(56) -> {5,16};
rank_to_zone(57) -> {8,16};
rank_to_zone(58) -> {25,16};
rank_to_zone(59) -> {24,16};
rank_to_zone(60) -> {9,16};
rank_to_zone(61) -> {16,16};
rank_to_zone(62) -> {17,16};
rank_to_zone(63) -> {32,16};
rank_to_zone(64) -> {1,16};
rank_to_zone(65) -> {1,9};
rank_to_zone(66) -> {32,9};
rank_to_zone(67) -> {17,9};
rank_to_zone(68) -> {16,9};
rank_to_zone(69) -> {9,9};
rank_to_zone(70) -> {24,9};
rank_to_zone(71) -> {25,9};
rank_to_zone(72) -> {8,9};
rank_to_zone(73) -> {5,9};
rank_to_zone(74) -> {28,9};
rank_to_zone(75) -> {21,9};
rank_to_zone(76) -> {12,9};
rank_to_zone(77) -> {13,9};
rank_to_zone(78) -> {20,9};
rank_to_zone(79) -> {29,9};
rank_to_zone(80) -> {4,9};
rank_to_zone(81) -> {3,9};
rank_to_zone(82) -> {30,9};
rank_to_zone(83) -> {19,9};
rank_to_zone(84) -> {14,9};
rank_to_zone(85) -> {11,9};
rank_to_zone(86) -> {22,9};
rank_to_zone(87) -> {27,9};
rank_to_zone(88) -> {6,9};
rank_to_zone(89) -> {7,9};
rank_to_zone(90) -> {26,9};
rank_to_zone(91) -> {23,9};
rank_to_zone(92) -> {10,9};
rank_to_zone(93) -> {15,9};
rank_to_zone(94) -> {18,9};
rank_to_zone(95) -> {31,9};
rank_to_zone(96) -> {2,9};
rank_to_zone(97) -> {2,8};
rank_to_zone(98) -> {31,8};
rank_to_zone(99) -> {18,8};
rank_to_zone(100) -> {15,8};
rank_to_zone(101) -> {10,8};
rank_to_zone(102) -> {23,8};
rank_to_zone(103) -> {26,8};
rank_to_zone(104) -> {7,8};
rank_to_zone(105) -> {6,8};
rank_to_zone(106) -> {27,8};
rank_to_zone(107) -> {22,8};
rank_to_zone(108) -> {11,8};
rank_to_zone(109) -> {14,8};
rank_to_zone(110) -> {19,8};
rank_to_zone(111) -> {30,8};
rank_to_zone(112) -> {3,8};
rank_to_zone(113) -> {4,8};
rank_to_zone(114) -> {29,8};
rank_to_zone(115) -> {20,8};
rank_to_zone(116) -> {13,8};
rank_to_zone(117) -> {12,8};
rank_to_zone(118) -> {21,8};
rank_to_zone(119) -> {28,8};
rank_to_zone(120) -> {5,8};
rank_to_zone(121) -> {8,8};
rank_to_zone(122) -> {25,8};
rank_to_zone(123) -> {24,8};
rank_to_zone(124) -> {9,8};
rank_to_zone(125) -> {16,8};
rank_to_zone(126) -> {17,8};
rank_to_zone(127) -> {32,8};
rank_to_zone(128) -> {1,8};
rank_to_zone(129) -> {1,5};
rank_to_zone(130) -> {32,5};
rank_to_zone(131) -> {17,5};
rank_to_zone(132) -> {16,5};
rank_to_zone(133) -> {9,5};
rank_to_zone(134) -> {24,5};
rank_to_zone(135) -> {25,5};
rank_to_zone(136) -> {8,5};
rank_to_zone(137) -> {5,5};
rank_to_zone(138) -> {28,5};
rank_to_zone(139) -> {21,5};
rank_to_zone(140) -> {12,5};
rank_to_zone(141) -> {13,5};
rank_to_zone(142) -> {20,5};
rank_to_zone(143) -> {29,5};
rank_to_zone(144) -> {4,5};
rank_to_zone(145) -> {3,5};
rank_to_zone(146) -> {30,5};
rank_to_zone(147) -> {19,5};
rank_to_zone(148) -> {14,5};
rank_to_zone(149) -> {11,5};
rank_to_zone(150) -> {22,5};
rank_to_zone(151) -> {27,5};
rank_to_zone(152) -> {6,5};
rank_to_zone(153) -> {7,5};
rank_to_zone(154) -> {26,5};
rank_to_zone(155) -> {23,5};
rank_to_zone(156) -> {10,5};
rank_to_zone(157) -> {15,5};
rank_to_zone(158) -> {18,5};
rank_to_zone(159) -> {31,5};
rank_to_zone(160) -> {2,5};
rank_to_zone(161) -> {2,12};
rank_to_zone(162) -> {31,12};
rank_to_zone(163) -> {18,12};
rank_to_zone(164) -> {15,12};
rank_to_zone(165) -> {10,12};
rank_to_zone(166) -> {23,12};
rank_to_zone(167) -> {26,12};
rank_to_zone(168) -> {7,12};
rank_to_zone(169) -> {6,12};
rank_to_zone(170) -> {27,12};
rank_to_zone(171) -> {22,12};
rank_to_zone(172) -> {11,12};
rank_to_zone(173) -> {14,12};
rank_to_zone(174) -> {19,12};
rank_to_zone(175) -> {30,12};
rank_to_zone(176) -> {3,12};
rank_to_zone(177) -> {4,12};
rank_to_zone(178) -> {29,12};
rank_to_zone(179) -> {20,12};
rank_to_zone(180) -> {13,12};
rank_to_zone(181) -> {12,12};
rank_to_zone(182) -> {21,12};
rank_to_zone(183) -> {28,12};
rank_to_zone(184) -> {5,12};
rank_to_zone(185) -> {8,12};
rank_to_zone(186) -> {25,12};
rank_to_zone(187) -> {24,12};
rank_to_zone(188) -> {9,12};
rank_to_zone(189) -> {16,12};
rank_to_zone(190) -> {17,12};
rank_to_zone(191) -> {32,12};
rank_to_zone(192) -> {1,12};
rank_to_zone(193) -> {1,13};
rank_to_zone(194) -> {32,13};
rank_to_zone(195) -> {17,13};
rank_to_zone(196) -> {16,13};
rank_to_zone(197) -> {9,13};
rank_to_zone(198) -> {24,13};
rank_to_zone(199) -> {25,13};
rank_to_zone(200) -> {8,13};
rank_to_zone(201) -> {5,13};
rank_to_zone(202) -> {28,13};
rank_to_zone(203) -> {21,13};
rank_to_zone(204) -> {12,13};
rank_to_zone(205) -> {13,13};
rank_to_zone(206) -> {20,13};
rank_to_zone(207) -> {29,13};
rank_to_zone(208) -> {4,13};
rank_to_zone(209) -> {3,13};
rank_to_zone(210) -> {30,13};
rank_to_zone(211) -> {19,13};
rank_to_zone(212) -> {14,13};
rank_to_zone(213) -> {11,13};
rank_to_zone(214) -> {22,13};
rank_to_zone(215) -> {27,13};
rank_to_zone(216) -> {6,13};
rank_to_zone(217) -> {7,13};
rank_to_zone(218) -> {26,13};
rank_to_zone(219) -> {23,13};
rank_to_zone(220) -> {10,13};
rank_to_zone(221) -> {15,13};
rank_to_zone(222) -> {18,13};
rank_to_zone(223) -> {31,13};
rank_to_zone(224) -> {2,13};
rank_to_zone(225) -> {2,4};
rank_to_zone(226) -> {31,4};
rank_to_zone(227) -> {18,4};
rank_to_zone(228) -> {15,4};
rank_to_zone(229) -> {10,4};
rank_to_zone(230) -> {23,4};
rank_to_zone(231) -> {26,4};
rank_to_zone(232) -> {7,4};
rank_to_zone(233) -> {6,4};
rank_to_zone(234) -> {27,4};
rank_to_zone(235) -> {22,4};
rank_to_zone(236) -> {11,4};
rank_to_zone(237) -> {14,4};
rank_to_zone(238) -> {19,4};
rank_to_zone(239) -> {30,4};
rank_to_zone(240) -> {3,4};
rank_to_zone(241) -> {4,4};
rank_to_zone(242) -> {29,4};
rank_to_zone(243) -> {20,4};
rank_to_zone(244) -> {13,4};
rank_to_zone(245) -> {12,4};
rank_to_zone(246) -> {21,4};
rank_to_zone(247) -> {28,4};
rank_to_zone(248) -> {5,4};
rank_to_zone(249) -> {8,4};
rank_to_zone(250) -> {25,4};
rank_to_zone(251) -> {24,4};
rank_to_zone(252) -> {9,4};
rank_to_zone(253) -> {16,4};
rank_to_zone(254) -> {17,4};
rank_to_zone(255) -> {32,4};
rank_to_zone(256) -> {1,4};
rank_to_zone(257) -> {1,3};
rank_to_zone(258) -> {32,3};
rank_to_zone(259) -> {17,3};
rank_to_zone(260) -> {16,3};
rank_to_zone(261) -> {9,3};
rank_to_zone(262) -> {24,3};
rank_to_zone(263) -> {25,3};
rank_to_zone(264) -> {8,3};
rank_to_zone(265) -> {5,3};
rank_to_zone(266) -> {28,3};
rank_to_zone(267) -> {21,3};
rank_to_zone(268) -> {12,3};
rank_to_zone(269) -> {13,3};
rank_to_zone(270) -> {20,3};
rank_to_zone(271) -> {29,3};
rank_to_zone(272) -> {4,3};
rank_to_zone(273) -> {3,3};
rank_to_zone(274) -> {30,3};
rank_to_zone(275) -> {19,3};
rank_to_zone(276) -> {14,3};
rank_to_zone(277) -> {11,3};
rank_to_zone(278) -> {22,3};
rank_to_zone(279) -> {27,3};
rank_to_zone(280) -> {6,3};
rank_to_zone(281) -> {7,3};
rank_to_zone(282) -> {26,3};
rank_to_zone(283) -> {23,3};
rank_to_zone(284) -> {10,3};
rank_to_zone(285) -> {15,3};
rank_to_zone(286) -> {18,3};
rank_to_zone(287) -> {31,3};
rank_to_zone(288) -> {2,3};
rank_to_zone(289) -> {2,14};
rank_to_zone(290) -> {31,14};
rank_to_zone(291) -> {18,14};
rank_to_zone(292) -> {15,14};
rank_to_zone(293) -> {10,14};
rank_to_zone(294) -> {23,14};
rank_to_zone(295) -> {26,14};
rank_to_zone(296) -> {7,14};
rank_to_zone(297) -> {6,14};
rank_to_zone(298) -> {27,14};
rank_to_zone(299) -> {22,14};
rank_to_zone(300) -> {11,14};
rank_to_zone(301) -> {14,14};
rank_to_zone(302) -> {19,14};
rank_to_zone(303) -> {30,14};
rank_to_zone(304) -> {3,14};
rank_to_zone(305) -> {4,14};
rank_to_zone(306) -> {29,14};
rank_to_zone(307) -> {20,14};
rank_to_zone(308) -> {13,14};
rank_to_zone(309) -> {12,14};
rank_to_zone(310) -> {21,14};
rank_to_zone(311) -> {28,14};
rank_to_zone(312) -> {5,14};
rank_to_zone(313) -> {8,14};
rank_to_zone(314) -> {25,14};
rank_to_zone(315) -> {24,14};
rank_to_zone(316) -> {9,14};
rank_to_zone(317) -> {16,14};
rank_to_zone(318) -> {17,14};
rank_to_zone(319) -> {32,14};
rank_to_zone(320) -> {1,14};
rank_to_zone(321) -> {1,11};
rank_to_zone(322) -> {32,11};
rank_to_zone(323) -> {17,11};
rank_to_zone(324) -> {16,11};
rank_to_zone(325) -> {9,11};
rank_to_zone(326) -> {24,11};
rank_to_zone(327) -> {25,11};
rank_to_zone(328) -> {8,11};
rank_to_zone(329) -> {5,11};
rank_to_zone(330) -> {28,11};
rank_to_zone(331) -> {21,11};
rank_to_zone(332) -> {12,11};
rank_to_zone(333) -> {13,11};
rank_to_zone(334) -> {20,11};
rank_to_zone(335) -> {29,11};
rank_to_zone(336) -> {4,11};
rank_to_zone(337) -> {3,11};
rank_to_zone(338) -> {30,11};
rank_to_zone(339) -> {19,11};
rank_to_zone(340) -> {14,11};
rank_to_zone(341) -> {11,11};
rank_to_zone(342) -> {22,11};
rank_to_zone(343) -> {27,11};
rank_to_zone(344) -> {6,11};
rank_to_zone(345) -> {7,11};
rank_to_zone(346) -> {26,11};
rank_to_zone(347) -> {23,11};
rank_to_zone(348) -> {10,11};
rank_to_zone(349) -> {15,11};
rank_to_zone(350) -> {18,11};
rank_to_zone(351) -> {31,11};
rank_to_zone(352) -> {2,11};
rank_to_zone(353) -> {2,6};
rank_to_zone(354) -> {31,6};
rank_to_zone(355) -> {18,6};
rank_to_zone(356) -> {15,6};
rank_to_zone(357) -> {10,6};
rank_to_zone(358) -> {23,6};
rank_to_zone(359) -> {26,6};
rank_to_zone(360) -> {7,6};
rank_to_zone(361) -> {6,6};
rank_to_zone(362) -> {27,6};
rank_to_zone(363) -> {22,6};
rank_to_zone(364) -> {11,6};
rank_to_zone(365) -> {14,6};
rank_to_zone(366) -> {19,6};
rank_to_zone(367) -> {30,6};
rank_to_zone(368) -> {3,6};
rank_to_zone(369) -> {4,6};
rank_to_zone(370) -> {29,6};
rank_to_zone(371) -> {20,6};
rank_to_zone(372) -> {13,6};
rank_to_zone(373) -> {12,6};
rank_to_zone(374) -> {21,6};
rank_to_zone(375) -> {28,6};
rank_to_zone(376) -> {5,6};
rank_to_zone(377) -> {8,6};
rank_to_zone(378) -> {25,6};
rank_to_zone(379) -> {24,6};
rank_to_zone(380) -> {9,6};
rank_to_zone(381) -> {16,6};
rank_to_zone(382) -> {17,6};
rank_to_zone(383) -> {32,6};
rank_to_zone(384) -> {1,6};
rank_to_zone(385) -> {1,7};
rank_to_zone(386) -> {32,7};
rank_to_zone(387) -> {17,7};
rank_to_zone(388) -> {16,7};
rank_to_zone(389) -> {9,7};
rank_to_zone(390) -> {24,7};
rank_to_zone(391) -> {25,7};
rank_to_zone(392) -> {8,7};
rank_to_zone(393) -> {5,7};
rank_to_zone(394) -> {28,7};
rank_to_zone(395) -> {21,7};
rank_to_zone(396) -> {12,7};
rank_to_zone(397) -> {13,7};
rank_to_zone(398) -> {20,7};
rank_to_zone(399) -> {29,7};
rank_to_zone(400) -> {4,7};
rank_to_zone(401) -> {3,7};
rank_to_zone(402) -> {30,7};
rank_to_zone(403) -> {19,7};
rank_to_zone(404) -> {14,7};
rank_to_zone(405) -> {11,7};
rank_to_zone(406) -> {22,7};
rank_to_zone(407) -> {27,7};
rank_to_zone(408) -> {6,7};
rank_to_zone(409) -> {7,7};
rank_to_zone(410) -> {26,7};
rank_to_zone(411) -> {23,7};
rank_to_zone(412) -> {10,7};
rank_to_zone(413) -> {15,7};
rank_to_zone(414) -> {18,7};
rank_to_zone(415) -> {31,7};
rank_to_zone(416) -> {2,7};
rank_to_zone(417) -> {2,10};
rank_to_zone(418) -> {31,10};
rank_to_zone(419) -> {18,10};
rank_to_zone(420) -> {15,10};
rank_to_zone(421) -> {10,10};
rank_to_zone(422) -> {23,10};
rank_to_zone(423) -> {26,10};
rank_to_zone(424) -> {7,10};
rank_to_zone(425) -> {6,10};
rank_to_zone(426) -> {27,10};
rank_to_zone(427) -> {22,10};
rank_to_zone(428) -> {11,10};
rank_to_zone(429) -> {14,10};
rank_to_zone(430) -> {19,10};
rank_to_zone(431) -> {30,10};
rank_to_zone(432) -> {3,10};
rank_to_zone(433) -> {4,10};
rank_to_zone(434) -> {29,10};
rank_to_zone(435) -> {20,10};
rank_to_zone(436) -> {13,10};
rank_to_zone(437) -> {12,10};
rank_to_zone(438) -> {21,10};
rank_to_zone(439) -> {28,10};
rank_to_zone(440) -> {5,10};
rank_to_zone(441) -> {8,10};
rank_to_zone(442) -> {25,10};
rank_to_zone(443) -> {24,10};
rank_to_zone(444) -> {9,10};
rank_to_zone(445) -> {16,10};
rank_to_zone(446) -> {17,10};
rank_to_zone(447) -> {32,10};
rank_to_zone(448) -> {1,10};
rank_to_zone(449) -> {1,15};
rank_to_zone(450) -> {32,15};
rank_to_zone(451) -> {17,15};
rank_to_zone(452) -> {16,15};
rank_to_zone(453) -> {9,15};
rank_to_zone(454) -> {24,15};
rank_to_zone(455) -> {25,15};
rank_to_zone(456) -> {8,15};
rank_to_zone(457) -> {5,15};
rank_to_zone(458) -> {28,15};
rank_to_zone(459) -> {21,15};
rank_to_zone(460) -> {12,15};
rank_to_zone(461) -> {13,15};
rank_to_zone(462) -> {20,15};
rank_to_zone(463) -> {29,15};
rank_to_zone(464) -> {4,15};
rank_to_zone(465) -> {3,15};
rank_to_zone(466) -> {30,15};
rank_to_zone(467) -> {19,15};
rank_to_zone(468) -> {14,15};
rank_to_zone(469) -> {11,15};
rank_to_zone(470) -> {22,15};
rank_to_zone(471) -> {27,15};
rank_to_zone(472) -> {6,15};
rank_to_zone(473) -> {7,15};
rank_to_zone(474) -> {26,15};
rank_to_zone(475) -> {23,15};
rank_to_zone(476) -> {10,15};
rank_to_zone(477) -> {15,15};
rank_to_zone(478) -> {18,15};
rank_to_zone(479) -> {31,15};
rank_to_zone(480) -> {2,15};
rank_to_zone(481) -> {2,2};
rank_to_zone(482) -> {31,2};
rank_to_zone(483) -> {18,2};
rank_to_zone(484) -> {15,2};
rank_to_zone(485) -> {10,2};
rank_to_zone(486) -> {23,2};
rank_to_zone(487) -> {26,2};
rank_to_zone(488) -> {7,2};
rank_to_zone(489) -> {6,2};
rank_to_zone(490) -> {27,2};
rank_to_zone(491) -> {22,2};
rank_to_zone(492) -> {11,2};
rank_to_zone(493) -> {14,2};
rank_to_zone(494) -> {19,2};
rank_to_zone(495) -> {30,2};
rank_to_zone(496) -> {3,2};
rank_to_zone(497) -> {4,2};
rank_to_zone(498) -> {29,2};
rank_to_zone(499) -> {20,2};
rank_to_zone(500) -> {13,2};
rank_to_zone(501) -> {12,2};
rank_to_zone(502) -> {21,2};
rank_to_zone(503) -> {28,2};
rank_to_zone(504) -> {5,2};
rank_to_zone(505) -> {8,2};
rank_to_zone(506) -> {25,2};
rank_to_zone(507) -> {24,2};
rank_to_zone(508) -> {9,2};
rank_to_zone(509) -> {16,2};
rank_to_zone(510) -> {17,2};
rank_to_zone(511) -> {32,2};
rank_to_zone(512) -> {1,2}.
