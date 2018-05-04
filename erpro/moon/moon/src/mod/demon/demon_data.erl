%%---------------------------------------------
%% 精灵守护(侍宠)系统数据表
%% @author wpf(wprehard@qq.com)
%% @end
%%---------------------------------------------

-module(demon_data).
-export([
        get_exp/1
        ,get_skill_exp/1
        ,get_demon_attr/2
        ,get_skill/1
        ,get_skill_id/2
        ,get_skill_craft_polish_rand/2
        ,get_skill_type_polish_rand/0
    ]).
-include("demon.hrl").

%% 根据守护类型和等级获取属性
get_demon_attr(1, 1) ->
    [
        {hp_max, 100}
        ,{mp_max, 50}
        ,{dmg, 10}
        ,{dmg_magic, 10}
        ,{defence, 50}
        ,{critrate, 2}
        ,{tenacity, 2}
        ,{resist_metal, 25}
    ];
get_demon_attr(1, 2) ->
    [
        {hp_max, 200}
        ,{mp_max, 100}
        ,{dmg, 20}
        ,{dmg_magic, 20}
        ,{defence, 100}
        ,{critrate, 4}
        ,{tenacity, 4}
        ,{resist_metal, 50}
    ];
get_demon_attr(1, 3) ->
    [
        {hp_max, 300}
        ,{mp_max, 150}
        ,{dmg, 30}
        ,{dmg_magic, 30}
        ,{defence, 150}
        ,{critrate, 6}
        ,{tenacity, 6}
        ,{resist_metal, 75}
    ];
get_demon_attr(1, 4) ->
    [
        {hp_max, 400}
        ,{mp_max, 200}
        ,{dmg, 40}
        ,{dmg_magic, 40}
        ,{defence, 200}
        ,{critrate, 8}
        ,{tenacity, 8}
        ,{resist_metal, 100}
    ];
get_demon_attr(1, 5) ->
    [
        {hp_max, 500}
        ,{mp_max, 250}
        ,{dmg, 50}
        ,{dmg_magic, 50}
        ,{defence, 250}
        ,{critrate, 10}
        ,{tenacity, 10}
        ,{resist_metal, 125}
    ];
get_demon_attr(1, 6) ->
    [
        {hp_max, 600}
        ,{mp_max, 300}
        ,{dmg, 60}
        ,{dmg_magic, 60}
        ,{defence, 300}
        ,{critrate, 12}
        ,{tenacity, 12}
        ,{resist_metal, 150}
    ];
get_demon_attr(1, 7) ->
    [
        {hp_max, 700}
        ,{mp_max, 350}
        ,{dmg, 70}
        ,{dmg_magic, 70}
        ,{defence, 350}
        ,{critrate, 14}
        ,{tenacity, 14}
        ,{resist_metal, 175}
    ];
get_demon_attr(1, 8) ->
    [
        {hp_max, 800}
        ,{mp_max, 400}
        ,{dmg, 80}
        ,{dmg_magic, 80}
        ,{defence, 400}
        ,{critrate, 16}
        ,{tenacity, 16}
        ,{resist_metal, 200}
    ];
get_demon_attr(1, 9) ->
    [
        {hp_max, 900}
        ,{mp_max, 450}
        ,{dmg, 90}
        ,{dmg_magic, 90}
        ,{defence, 450}
        ,{critrate, 18}
        ,{tenacity, 18}
        ,{resist_metal, 225}
    ];
get_demon_attr(1, 10) ->
    [
        {hp_max, 1000}
        ,{mp_max, 500}
        ,{dmg, 100}
        ,{dmg_magic, 100}
        ,{defence, 500}
        ,{critrate, 20}
        ,{tenacity, 20}
        ,{resist_metal, 250}
    ];
get_demon_attr(1, 11) ->
    [
        {hp_max, 1100}
        ,{mp_max, 550}
        ,{dmg, 110}
        ,{dmg_magic, 110}
        ,{defence, 550}
        ,{critrate, 22}
        ,{tenacity, 22}
        ,{resist_metal, 275}
    ];
get_demon_attr(1, 12) ->
    [
        {hp_max, 1200}
        ,{mp_max, 600}
        ,{dmg, 120}
        ,{dmg_magic, 120}
        ,{defence, 600}
        ,{critrate, 24}
        ,{tenacity, 24}
        ,{resist_metal, 300}
    ];
get_demon_attr(1, 13) ->
    [
        {hp_max, 1300}
        ,{mp_max, 650}
        ,{dmg, 130}
        ,{dmg_magic, 130}
        ,{defence, 650}
        ,{critrate, 26}
        ,{tenacity, 26}
        ,{resist_metal, 325}
    ];
get_demon_attr(1, 14) ->
    [
        {hp_max, 1400}
        ,{mp_max, 700}
        ,{dmg, 140}
        ,{dmg_magic, 140}
        ,{defence, 700}
        ,{critrate, 28}
        ,{tenacity, 28}
        ,{resist_metal, 350}
    ];
get_demon_attr(1, 15) ->
    [
        {hp_max, 1500}
        ,{mp_max, 750}
        ,{dmg, 150}
        ,{dmg_magic, 150}
        ,{defence, 750}
        ,{critrate, 30}
        ,{tenacity, 30}
        ,{resist_metal, 375}
    ];
get_demon_attr(1, 16) ->
    [
        {hp_max, 1600}
        ,{mp_max, 800}
        ,{dmg, 160}
        ,{dmg_magic, 160}
        ,{defence, 800}
        ,{critrate, 32}
        ,{tenacity, 32}
        ,{resist_metal, 400}
    ];
get_demon_attr(1, 17) ->
    [
        {hp_max, 1700}
        ,{mp_max, 850}
        ,{dmg, 170}
        ,{dmg_magic, 170}
        ,{defence, 850}
        ,{critrate, 34}
        ,{tenacity, 34}
        ,{resist_metal, 425}
    ];
get_demon_attr(1, 18) ->
    [
        {hp_max, 1800}
        ,{mp_max, 900}
        ,{dmg, 180}
        ,{dmg_magic, 180}
        ,{defence, 900}
        ,{critrate, 36}
        ,{tenacity, 36}
        ,{resist_metal, 450}
    ];
get_demon_attr(1, 19) ->
    [
        {hp_max, 1900}
        ,{mp_max, 950}
        ,{dmg, 190}
        ,{dmg_magic, 190}
        ,{defence, 950}
        ,{critrate, 38}
        ,{tenacity, 38}
        ,{resist_metal, 475}
    ];
get_demon_attr(1, 20) ->
    [
        {hp_max, 2000}
        ,{mp_max, 1000}
        ,{dmg, 200}
        ,{dmg_magic, 200}
        ,{defence, 1000}
        ,{critrate, 40}
        ,{tenacity, 40}
        ,{resist_metal, 500}
    ];
get_demon_attr(1, 21) ->
    [
        {hp_max, 2100}
        ,{mp_max, 1050}
        ,{dmg, 210}
        ,{dmg_magic, 210}
        ,{defence, 1050}
        ,{critrate, 42}
        ,{tenacity, 42}
        ,{resist_metal, 525}
    ];
get_demon_attr(1, 22) ->
    [
        {hp_max, 2200}
        ,{mp_max, 1100}
        ,{dmg, 220}
        ,{dmg_magic, 220}
        ,{defence, 1100}
        ,{critrate, 44}
        ,{tenacity, 44}
        ,{resist_metal, 550}
    ];
get_demon_attr(1, 23) ->
    [
        {hp_max, 2300}
        ,{mp_max, 1150}
        ,{dmg, 230}
        ,{dmg_magic, 230}
        ,{defence, 1150}
        ,{critrate, 46}
        ,{tenacity, 46}
        ,{resist_metal, 575}
    ];
get_demon_attr(1, 24) ->
    [
        {hp_max, 2400}
        ,{mp_max, 1200}
        ,{dmg, 240}
        ,{dmg_magic, 240}
        ,{defence, 1200}
        ,{critrate, 48}
        ,{tenacity, 48}
        ,{resist_metal, 600}
    ];
get_demon_attr(1, 25) ->
    [
        {hp_max, 2500}
        ,{mp_max, 1250}
        ,{dmg, 250}
        ,{dmg_magic, 250}
        ,{defence, 1250}
        ,{critrate, 50}
        ,{tenacity, 50}
        ,{resist_metal, 625}
    ];
get_demon_attr(1, 26) ->
    [
        {hp_max, 2600}
        ,{mp_max, 1300}
        ,{dmg, 260}
        ,{dmg_magic, 260}
        ,{defence, 1300}
        ,{critrate, 52}
        ,{tenacity, 52}
        ,{resist_metal, 650}
    ];
get_demon_attr(1, 27) ->
    [
        {hp_max, 2700}
        ,{mp_max, 1350}
        ,{dmg, 270}
        ,{dmg_magic, 270}
        ,{defence, 1350}
        ,{critrate, 54}
        ,{tenacity, 54}
        ,{resist_metal, 675}
    ];
get_demon_attr(1, 28) ->
    [
        {hp_max, 2800}
        ,{mp_max, 1400}
        ,{dmg, 280}
        ,{dmg_magic, 280}
        ,{defence, 1400}
        ,{critrate, 56}
        ,{tenacity, 56}
        ,{resist_metal, 700}
    ];
get_demon_attr(1, 29) ->
    [
        {hp_max, 2900}
        ,{mp_max, 1450}
        ,{dmg, 290}
        ,{dmg_magic, 290}
        ,{defence, 1450}
        ,{critrate, 58}
        ,{tenacity, 58}
        ,{resist_metal, 725}
    ];
get_demon_attr(1, 30) ->
    [
        {hp_max, 3000}
        ,{mp_max, 1500}
        ,{dmg, 300}
        ,{dmg_magic, 300}
        ,{defence, 1500}
        ,{critrate, 60}
        ,{tenacity, 60}
        ,{resist_metal, 750}
    ];
get_demon_attr(1, 31) ->
    [
        {hp_max, 3100}
        ,{mp_max, 1550}
        ,{dmg, 310}
        ,{dmg_magic, 310}
        ,{defence, 1550}
        ,{critrate, 62}
        ,{tenacity, 62}
        ,{resist_metal, 775}
    ];
get_demon_attr(1, 32) ->
    [
        {hp_max, 3200}
        ,{mp_max, 1600}
        ,{dmg, 320}
        ,{dmg_magic, 320}
        ,{defence, 1600}
        ,{critrate, 64}
        ,{tenacity, 64}
        ,{resist_metal, 800}
    ];
get_demon_attr(1, 33) ->
    [
        {hp_max, 3300}
        ,{mp_max, 1650}
        ,{dmg, 330}
        ,{dmg_magic, 330}
        ,{defence, 1650}
        ,{critrate, 66}
        ,{tenacity, 66}
        ,{resist_metal, 825}
    ];
get_demon_attr(1, 34) ->
    [
        {hp_max, 3400}
        ,{mp_max, 1700}
        ,{dmg, 340}
        ,{dmg_magic, 340}
        ,{defence, 1700}
        ,{critrate, 68}
        ,{tenacity, 68}
        ,{resist_metal, 850}
    ];
get_demon_attr(1, 35) ->
    [
        {hp_max, 3500}
        ,{mp_max, 1750}
        ,{dmg, 350}
        ,{dmg_magic, 350}
        ,{defence, 1750}
        ,{critrate, 70}
        ,{tenacity, 70}
        ,{resist_metal, 875}
    ];
get_demon_attr(1, 36) ->
    [
        {hp_max, 3600}
        ,{mp_max, 1800}
        ,{dmg, 360}
        ,{dmg_magic, 360}
        ,{defence, 1800}
        ,{critrate, 72}
        ,{tenacity, 72}
        ,{resist_metal, 900}
    ];
get_demon_attr(1, 37) ->
    [
        {hp_max, 3700}
        ,{mp_max, 1850}
        ,{dmg, 370}
        ,{dmg_magic, 370}
        ,{defence, 1850}
        ,{critrate, 74}
        ,{tenacity, 74}
        ,{resist_metal, 925}
    ];
get_demon_attr(1, 38) ->
    [
        {hp_max, 3800}
        ,{mp_max, 1900}
        ,{dmg, 380}
        ,{dmg_magic, 380}
        ,{defence, 1900}
        ,{critrate, 76}
        ,{tenacity, 76}
        ,{resist_metal, 950}
    ];
get_demon_attr(1, 39) ->
    [
        {hp_max, 3900}
        ,{mp_max, 1950}
        ,{dmg, 390}
        ,{dmg_magic, 390}
        ,{defence, 1950}
        ,{critrate, 78}
        ,{tenacity, 78}
        ,{resist_metal, 975}
    ];
get_demon_attr(1, 40) ->
    [
        {hp_max, 4000}
        ,{mp_max, 2000}
        ,{dmg, 400}
        ,{dmg_magic, 400}
        ,{defence, 2000}
        ,{critrate, 80}
        ,{tenacity, 80}
        ,{resist_metal, 1000}
    ];
get_demon_attr(1, 41) ->
    [
        {hp_max, 4100}
        ,{mp_max, 2050}
        ,{dmg, 410}
        ,{dmg_magic, 410}
        ,{defence, 2050}
        ,{critrate, 82}
        ,{tenacity, 82}
        ,{resist_metal, 1025}
    ];
get_demon_attr(1, 42) ->
    [
        {hp_max, 4200}
        ,{mp_max, 2100}
        ,{dmg, 420}
        ,{dmg_magic, 420}
        ,{defence, 2100}
        ,{critrate, 84}
        ,{tenacity, 84}
        ,{resist_metal, 1050}
    ];
get_demon_attr(1, 43) ->
    [
        {hp_max, 4300}
        ,{mp_max, 2150}
        ,{dmg, 430}
        ,{dmg_magic, 430}
        ,{defence, 2150}
        ,{critrate, 86}
        ,{tenacity, 86}
        ,{resist_metal, 1075}
    ];
get_demon_attr(1, 44) ->
    [
        {hp_max, 4400}
        ,{mp_max, 2200}
        ,{dmg, 440}
        ,{dmg_magic, 440}
        ,{defence, 2200}
        ,{critrate, 88}
        ,{tenacity, 88}
        ,{resist_metal, 1100}
    ];
get_demon_attr(1, 45) ->
    [
        {hp_max, 4500}
        ,{mp_max, 2250}
        ,{dmg, 450}
        ,{dmg_magic, 450}
        ,{defence, 2250}
        ,{critrate, 90}
        ,{tenacity, 90}
        ,{resist_metal, 1125}
    ];
get_demon_attr(1, 46) ->
    [
        {hp_max, 4600}
        ,{mp_max, 2300}
        ,{dmg, 460}
        ,{dmg_magic, 460}
        ,{defence, 2300}
        ,{critrate, 92}
        ,{tenacity, 92}
        ,{resist_metal, 1150}
    ];
get_demon_attr(1, 47) ->
    [
        {hp_max, 4700}
        ,{mp_max, 2350}
        ,{dmg, 470}
        ,{dmg_magic, 470}
        ,{defence, 2350}
        ,{critrate, 94}
        ,{tenacity, 94}
        ,{resist_metal, 1175}
    ];
get_demon_attr(1, 48) ->
    [
        {hp_max, 4800}
        ,{mp_max, 2400}
        ,{dmg, 480}
        ,{dmg_magic, 480}
        ,{defence, 2400}
        ,{critrate, 96}
        ,{tenacity, 96}
        ,{resist_metal, 1200}
    ];
get_demon_attr(1, 49) ->
    [
        {hp_max, 4900}
        ,{mp_max, 2450}
        ,{dmg, 490}
        ,{dmg_magic, 490}
        ,{defence, 2450}
        ,{critrate, 98}
        ,{tenacity, 98}
        ,{resist_metal, 1225}
    ];
get_demon_attr(1, 50) ->
    [
        {hp_max, 5000}
        ,{mp_max, 2500}
        ,{dmg, 500}
        ,{dmg_magic, 500}
        ,{defence, 2500}
        ,{critrate, 100}
        ,{tenacity, 100}
        ,{resist_metal, 1250}
    ];
get_demon_attr(1, 51) ->
    [
        {hp_max, 5100}
        ,{mp_max, 2550}
        ,{dmg, 510}
        ,{dmg_magic, 510}
        ,{defence, 2550}
        ,{critrate, 102}
        ,{tenacity, 102}
        ,{resist_metal, 1275}
    ];
get_demon_attr(1, 52) ->
    [
        {hp_max, 5200}
        ,{mp_max, 2600}
        ,{dmg, 520}
        ,{dmg_magic, 520}
        ,{defence, 2600}
        ,{critrate, 104}
        ,{tenacity, 104}
        ,{resist_metal, 1300}
    ];
get_demon_attr(1, 53) ->
    [
        {hp_max, 5300}
        ,{mp_max, 2650}
        ,{dmg, 530}
        ,{dmg_magic, 530}
        ,{defence, 2650}
        ,{critrate, 106}
        ,{tenacity, 106}
        ,{resist_metal, 1325}
    ];
get_demon_attr(1, 54) ->
    [
        {hp_max, 5400}
        ,{mp_max, 2700}
        ,{dmg, 540}
        ,{dmg_magic, 540}
        ,{defence, 2700}
        ,{critrate, 108}
        ,{tenacity, 108}
        ,{resist_metal, 1350}
    ];
get_demon_attr(1, 55) ->
    [
        {hp_max, 5500}
        ,{mp_max, 2750}
        ,{dmg, 550}
        ,{dmg_magic, 550}
        ,{defence, 2750}
        ,{critrate, 110}
        ,{tenacity, 110}
        ,{resist_metal, 1375}
    ];
get_demon_attr(1, 56) ->
    [
        {hp_max, 5600}
        ,{mp_max, 2800}
        ,{dmg, 560}
        ,{dmg_magic, 560}
        ,{defence, 2800}
        ,{critrate, 112}
        ,{tenacity, 112}
        ,{resist_metal, 1400}
    ];
get_demon_attr(1, 57) ->
    [
        {hp_max, 5700}
        ,{mp_max, 2850}
        ,{dmg, 570}
        ,{dmg_magic, 570}
        ,{defence, 2850}
        ,{critrate, 114}
        ,{tenacity, 114}
        ,{resist_metal, 1425}
    ];
get_demon_attr(1, 58) ->
    [
        {hp_max, 5800}
        ,{mp_max, 2900}
        ,{dmg, 580}
        ,{dmg_magic, 580}
        ,{defence, 2900}
        ,{critrate, 116}
        ,{tenacity, 116}
        ,{resist_metal, 1450}
    ];
get_demon_attr(1, 59) ->
    [
        {hp_max, 5900}
        ,{mp_max, 2950}
        ,{dmg, 590}
        ,{dmg_magic, 590}
        ,{defence, 2950}
        ,{critrate, 118}
        ,{tenacity, 118}
        ,{resist_metal, 1475}
    ];
get_demon_attr(1, 60) ->
    [
        {hp_max, 6000}
        ,{mp_max, 3000}
        ,{dmg, 600}
        ,{dmg_magic, 600}
        ,{defence, 3000}
        ,{critrate, 120}
        ,{tenacity, 120}
        ,{resist_metal, 1500}
    ];
get_demon_attr(1, 61) ->
    [
        {hp_max, 6100}
        ,{mp_max, 3050}
        ,{dmg, 610}
        ,{dmg_magic, 610}
        ,{defence, 3050}
        ,{critrate, 122}
        ,{tenacity, 122}
        ,{resist_metal, 1525}
    ];
get_demon_attr(1, 62) ->
    [
        {hp_max, 6200}
        ,{mp_max, 3100}
        ,{dmg, 620}
        ,{dmg_magic, 620}
        ,{defence, 3100}
        ,{critrate, 124}
        ,{tenacity, 124}
        ,{resist_metal, 1550}
    ];
get_demon_attr(1, 63) ->
    [
        {hp_max, 6300}
        ,{mp_max, 3150}
        ,{dmg, 630}
        ,{dmg_magic, 630}
        ,{defence, 3150}
        ,{critrate, 126}
        ,{tenacity, 126}
        ,{resist_metal, 1575}
    ];
get_demon_attr(1, 64) ->
    [
        {hp_max, 6400}
        ,{mp_max, 3200}
        ,{dmg, 640}
        ,{dmg_magic, 640}
        ,{defence, 3200}
        ,{critrate, 128}
        ,{tenacity, 128}
        ,{resist_metal, 1600}
    ];
get_demon_attr(1, 65) ->
    [
        {hp_max, 6500}
        ,{mp_max, 3250}
        ,{dmg, 650}
        ,{dmg_magic, 650}
        ,{defence, 3250}
        ,{critrate, 130}
        ,{tenacity, 130}
        ,{resist_metal, 1625}
    ];
get_demon_attr(1, 66) ->
    [
        {hp_max, 6600}
        ,{mp_max, 3300}
        ,{dmg, 660}
        ,{dmg_magic, 660}
        ,{defence, 3300}
        ,{critrate, 132}
        ,{tenacity, 132}
        ,{resist_metal, 1650}
    ];
get_demon_attr(1, 67) ->
    [
        {hp_max, 6700}
        ,{mp_max, 3350}
        ,{dmg, 670}
        ,{dmg_magic, 670}
        ,{defence, 3350}
        ,{critrate, 134}
        ,{tenacity, 134}
        ,{resist_metal, 1675}
    ];
get_demon_attr(1, 68) ->
    [
        {hp_max, 6800}
        ,{mp_max, 3400}
        ,{dmg, 680}
        ,{dmg_magic, 680}
        ,{defence, 3400}
        ,{critrate, 136}
        ,{tenacity, 136}
        ,{resist_metal, 1700}
    ];
get_demon_attr(1, 69) ->
    [
        {hp_max, 6900}
        ,{mp_max, 3450}
        ,{dmg, 690}
        ,{dmg_magic, 690}
        ,{defence, 3450}
        ,{critrate, 138}
        ,{tenacity, 138}
        ,{resist_metal, 1725}
    ];
get_demon_attr(1, 70) ->
    [
        {hp_max, 7000}
        ,{mp_max, 3500}
        ,{dmg, 700}
        ,{dmg_magic, 700}
        ,{defence, 3500}
        ,{critrate, 140}
        ,{tenacity, 140}
        ,{resist_metal, 1750}
    ];
get_demon_attr(1, 71) ->
    [
        {hp_max, 7100}
        ,{mp_max, 3550}
        ,{dmg, 710}
        ,{dmg_magic, 710}
        ,{defence, 3550}
        ,{critrate, 142}
        ,{tenacity, 142}
        ,{resist_metal, 1775}
    ];
get_demon_attr(1, 72) ->
    [
        {hp_max, 7200}
        ,{mp_max, 3600}
        ,{dmg, 720}
        ,{dmg_magic, 720}
        ,{defence, 3600}
        ,{critrate, 144}
        ,{tenacity, 144}
        ,{resist_metal, 1800}
    ];
get_demon_attr(1, 73) ->
    [
        {hp_max, 7300}
        ,{mp_max, 3650}
        ,{dmg, 730}
        ,{dmg_magic, 730}
        ,{defence, 3650}
        ,{critrate, 146}
        ,{tenacity, 146}
        ,{resist_metal, 1825}
    ];
get_demon_attr(1, 74) ->
    [
        {hp_max, 7400}
        ,{mp_max, 3700}
        ,{dmg, 740}
        ,{dmg_magic, 740}
        ,{defence, 3700}
        ,{critrate, 148}
        ,{tenacity, 148}
        ,{resist_metal, 1850}
    ];
get_demon_attr(1, 75) ->
    [
        {hp_max, 7500}
        ,{mp_max, 3750}
        ,{dmg, 750}
        ,{dmg_magic, 750}
        ,{defence, 3750}
        ,{critrate, 150}
        ,{tenacity, 150}
        ,{resist_metal, 1875}
    ];
get_demon_attr(1, 76) ->
    [
        {hp_max, 7600}
        ,{mp_max, 3800}
        ,{dmg, 760}
        ,{dmg_magic, 760}
        ,{defence, 3800}
        ,{critrate, 152}
        ,{tenacity, 152}
        ,{resist_metal, 1900}
    ];
get_demon_attr(1, 77) ->
    [
        {hp_max, 7700}
        ,{mp_max, 3850}
        ,{dmg, 770}
        ,{dmg_magic, 770}
        ,{defence, 3850}
        ,{critrate, 154}
        ,{tenacity, 154}
        ,{resist_metal, 1925}
    ];
get_demon_attr(1, 78) ->
    [
        {hp_max, 7800}
        ,{mp_max, 3900}
        ,{dmg, 780}
        ,{dmg_magic, 780}
        ,{defence, 3900}
        ,{critrate, 156}
        ,{tenacity, 156}
        ,{resist_metal, 1950}
    ];
get_demon_attr(1, 79) ->
    [
        {hp_max, 7900}
        ,{mp_max, 3950}
        ,{dmg, 790}
        ,{dmg_magic, 790}
        ,{defence, 3950}
        ,{critrate, 158}
        ,{tenacity, 158}
        ,{resist_metal, 1975}
    ];
get_demon_attr(1, 80) ->
    [
        {hp_max, 8000}
        ,{mp_max, 4000}
        ,{dmg, 800}
        ,{dmg_magic, 800}
        ,{defence, 4000}
        ,{critrate, 160}
        ,{tenacity, 160}
        ,{resist_metal, 2000}
    ];
get_demon_attr(1, 81) ->
    [
        {hp_max, 8100}
        ,{mp_max, 4050}
        ,{dmg, 810}
        ,{dmg_magic, 810}
        ,{defence, 4050}
        ,{critrate, 162}
        ,{tenacity, 162}
        ,{resist_metal, 2025}
    ];
get_demon_attr(1, 82) ->
    [
        {hp_max, 8200}
        ,{mp_max, 4100}
        ,{dmg, 820}
        ,{dmg_magic, 820}
        ,{defence, 4100}
        ,{critrate, 164}
        ,{tenacity, 164}
        ,{resist_metal, 2050}
    ];
get_demon_attr(1, 83) ->
    [
        {hp_max, 8300}
        ,{mp_max, 4150}
        ,{dmg, 830}
        ,{dmg_magic, 830}
        ,{defence, 4150}
        ,{critrate, 166}
        ,{tenacity, 166}
        ,{resist_metal, 2075}
    ];
get_demon_attr(1, 84) ->
    [
        {hp_max, 8400}
        ,{mp_max, 4200}
        ,{dmg, 840}
        ,{dmg_magic, 840}
        ,{defence, 4200}
        ,{critrate, 168}
        ,{tenacity, 168}
        ,{resist_metal, 2100}
    ];
get_demon_attr(1, 85) ->
    [
        {hp_max, 8500}
        ,{mp_max, 4250}
        ,{dmg, 850}
        ,{dmg_magic, 850}
        ,{defence, 4250}
        ,{critrate, 170}
        ,{tenacity, 170}
        ,{resist_metal, 2125}
    ];
get_demon_attr(1, 86) ->
    [
        {hp_max, 8600}
        ,{mp_max, 4300}
        ,{dmg, 860}
        ,{dmg_magic, 860}
        ,{defence, 4300}
        ,{critrate, 172}
        ,{tenacity, 172}
        ,{resist_metal, 2150}
    ];
get_demon_attr(1, 87) ->
    [
        {hp_max, 8700}
        ,{mp_max, 4350}
        ,{dmg, 870}
        ,{dmg_magic, 870}
        ,{defence, 4350}
        ,{critrate, 174}
        ,{tenacity, 174}
        ,{resist_metal, 2175}
    ];
get_demon_attr(1, 88) ->
    [
        {hp_max, 8800}
        ,{mp_max, 4400}
        ,{dmg, 880}
        ,{dmg_magic, 880}
        ,{defence, 4400}
        ,{critrate, 176}
        ,{tenacity, 176}
        ,{resist_metal, 2200}
    ];
get_demon_attr(1, 89) ->
    [
        {hp_max, 8900}
        ,{mp_max, 4450}
        ,{dmg, 890}
        ,{dmg_magic, 890}
        ,{defence, 4450}
        ,{critrate, 178}
        ,{tenacity, 178}
        ,{resist_metal, 2225}
    ];
get_demon_attr(1, 90) ->
    [
        {hp_max, 9000}
        ,{mp_max, 4500}
        ,{dmg, 900}
        ,{dmg_magic, 900}
        ,{defence, 4500}
        ,{critrate, 180}
        ,{tenacity, 180}
        ,{resist_metal, 2250}
    ];
get_demon_attr(1, 91) ->
    [
        {hp_max, 9100}
        ,{mp_max, 4550}
        ,{dmg, 910}
        ,{dmg_magic, 910}
        ,{defence, 4550}
        ,{critrate, 182}
        ,{tenacity, 182}
        ,{resist_metal, 2275}
    ];
get_demon_attr(1, 92) ->
    [
        {hp_max, 9200}
        ,{mp_max, 4600}
        ,{dmg, 920}
        ,{dmg_magic, 920}
        ,{defence, 4600}
        ,{critrate, 184}
        ,{tenacity, 184}
        ,{resist_metal, 2300}
    ];
get_demon_attr(1, 93) ->
    [
        {hp_max, 9300}
        ,{mp_max, 4650}
        ,{dmg, 930}
        ,{dmg_magic, 930}
        ,{defence, 4650}
        ,{critrate, 186}
        ,{tenacity, 186}
        ,{resist_metal, 2325}
    ];
get_demon_attr(1, 94) ->
    [
        {hp_max, 9400}
        ,{mp_max, 4700}
        ,{dmg, 940}
        ,{dmg_magic, 940}
        ,{defence, 4700}
        ,{critrate, 188}
        ,{tenacity, 188}
        ,{resist_metal, 2350}
    ];
get_demon_attr(1, 95) ->
    [
        {hp_max, 9500}
        ,{mp_max, 4750}
        ,{dmg, 950}
        ,{dmg_magic, 950}
        ,{defence, 4750}
        ,{critrate, 190}
        ,{tenacity, 190}
        ,{resist_metal, 2375}
    ];
get_demon_attr(1, 96) ->
    [
        {hp_max, 9600}
        ,{mp_max, 4800}
        ,{dmg, 960}
        ,{dmg_magic, 960}
        ,{defence, 4800}
        ,{critrate, 192}
        ,{tenacity, 192}
        ,{resist_metal, 2400}
    ];
get_demon_attr(1, 97) ->
    [
        {hp_max, 9700}
        ,{mp_max, 4850}
        ,{dmg, 970}
        ,{dmg_magic, 970}
        ,{defence, 4850}
        ,{critrate, 194}
        ,{tenacity, 194}
        ,{resist_metal, 2425}
    ];
get_demon_attr(1, 98) ->
    [
        {hp_max, 9800}
        ,{mp_max, 4900}
        ,{dmg, 980}
        ,{dmg_magic, 980}
        ,{defence, 4900}
        ,{critrate, 196}
        ,{tenacity, 196}
        ,{resist_metal, 2450}
    ];
get_demon_attr(1, 99) ->
    [
        {hp_max, 9900}
        ,{mp_max, 4950}
        ,{dmg, 990}
        ,{dmg_magic, 990}
        ,{defence, 4950}
        ,{critrate, 198}
        ,{tenacity, 198}
        ,{resist_metal, 2475}
    ];
get_demon_attr(1, 100) ->
    [
        {hp_max, 10000}
        ,{mp_max, 5000}
        ,{dmg, 1000}
        ,{dmg_magic, 1000}
        ,{defence, 5000}
        ,{critrate, 200}
        ,{tenacity, 200}
        ,{resist_metal, 2500}
    ];
get_demon_attr(2, 1) ->
    [
        {hp_max, 100}
        ,{mp_max, 50}
        ,{dmg, 10}
        ,{dmg_magic, 10}
        ,{defence, 50}
        ,{critrate, 2}
        ,{tenacity, 2}
        ,{resist_wood, 25}
    ];
get_demon_attr(2, 2) ->
    [
        {hp_max, 200}
        ,{mp_max, 100}
        ,{dmg, 20}
        ,{dmg_magic, 20}
        ,{defence, 100}
        ,{critrate, 4}
        ,{tenacity, 4}
        ,{resist_wood, 50}
    ];
get_demon_attr(2, 3) ->
    [
        {hp_max, 300}
        ,{mp_max, 150}
        ,{dmg, 30}
        ,{dmg_magic, 30}
        ,{defence, 150}
        ,{critrate, 6}
        ,{tenacity, 6}
        ,{resist_wood, 75}
    ];
get_demon_attr(2, 4) ->
    [
        {hp_max, 400}
        ,{mp_max, 200}
        ,{dmg, 40}
        ,{dmg_magic, 40}
        ,{defence, 200}
        ,{critrate, 8}
        ,{tenacity, 8}
        ,{resist_wood, 100}
    ];
get_demon_attr(2, 5) ->
    [
        {hp_max, 500}
        ,{mp_max, 250}
        ,{dmg, 50}
        ,{dmg_magic, 50}
        ,{defence, 250}
        ,{critrate, 10}
        ,{tenacity, 10}
        ,{resist_wood, 125}
    ];
get_demon_attr(2, 6) ->
    [
        {hp_max, 600}
        ,{mp_max, 300}
        ,{dmg, 60}
        ,{dmg_magic, 60}
        ,{defence, 300}
        ,{critrate, 12}
        ,{tenacity, 12}
        ,{resist_wood, 150}
    ];
get_demon_attr(2, 7) ->
    [
        {hp_max, 700}
        ,{mp_max, 350}
        ,{dmg, 70}
        ,{dmg_magic, 70}
        ,{defence, 350}
        ,{critrate, 14}
        ,{tenacity, 14}
        ,{resist_wood, 175}
    ];
get_demon_attr(2, 8) ->
    [
        {hp_max, 800}
        ,{mp_max, 400}
        ,{dmg, 80}
        ,{dmg_magic, 80}
        ,{defence, 400}
        ,{critrate, 16}
        ,{tenacity, 16}
        ,{resist_wood, 200}
    ];
get_demon_attr(2, 9) ->
    [
        {hp_max, 900}
        ,{mp_max, 450}
        ,{dmg, 90}
        ,{dmg_magic, 90}
        ,{defence, 450}
        ,{critrate, 18}
        ,{tenacity, 18}
        ,{resist_wood, 225}
    ];
get_demon_attr(2, 10) ->
    [
        {hp_max, 1000}
        ,{mp_max, 500}
        ,{dmg, 100}
        ,{dmg_magic, 100}
        ,{defence, 500}
        ,{critrate, 20}
        ,{tenacity, 20}
        ,{resist_wood, 250}
    ];
get_demon_attr(2, 11) ->
    [
        {hp_max, 1100}
        ,{mp_max, 550}
        ,{dmg, 110}
        ,{dmg_magic, 110}
        ,{defence, 550}
        ,{critrate, 22}
        ,{tenacity, 22}
        ,{resist_wood, 275}
    ];
get_demon_attr(2, 12) ->
    [
        {hp_max, 1200}
        ,{mp_max, 600}
        ,{dmg, 120}
        ,{dmg_magic, 120}
        ,{defence, 600}
        ,{critrate, 24}
        ,{tenacity, 24}
        ,{resist_wood, 300}
    ];
get_demon_attr(2, 13) ->
    [
        {hp_max, 1300}
        ,{mp_max, 650}
        ,{dmg, 130}
        ,{dmg_magic, 130}
        ,{defence, 650}
        ,{critrate, 26}
        ,{tenacity, 26}
        ,{resist_wood, 325}
    ];
get_demon_attr(2, 14) ->
    [
        {hp_max, 1400}
        ,{mp_max, 700}
        ,{dmg, 140}
        ,{dmg_magic, 140}
        ,{defence, 700}
        ,{critrate, 28}
        ,{tenacity, 28}
        ,{resist_wood, 350}
    ];
get_demon_attr(2, 15) ->
    [
        {hp_max, 1500}
        ,{mp_max, 750}
        ,{dmg, 150}
        ,{dmg_magic, 150}
        ,{defence, 750}
        ,{critrate, 30}
        ,{tenacity, 30}
        ,{resist_wood, 375}
    ];
get_demon_attr(2, 16) ->
    [
        {hp_max, 1600}
        ,{mp_max, 800}
        ,{dmg, 160}
        ,{dmg_magic, 160}
        ,{defence, 800}
        ,{critrate, 32}
        ,{tenacity, 32}
        ,{resist_wood, 400}
    ];
get_demon_attr(2, 17) ->
    [
        {hp_max, 1700}
        ,{mp_max, 850}
        ,{dmg, 170}
        ,{dmg_magic, 170}
        ,{defence, 850}
        ,{critrate, 34}
        ,{tenacity, 34}
        ,{resist_wood, 425}
    ];
get_demon_attr(2, 18) ->
    [
        {hp_max, 1800}
        ,{mp_max, 900}
        ,{dmg, 180}
        ,{dmg_magic, 180}
        ,{defence, 900}
        ,{critrate, 36}
        ,{tenacity, 36}
        ,{resist_wood, 450}
    ];
get_demon_attr(2, 19) ->
    [
        {hp_max, 1900}
        ,{mp_max, 950}
        ,{dmg, 190}
        ,{dmg_magic, 190}
        ,{defence, 950}
        ,{critrate, 38}
        ,{tenacity, 38}
        ,{resist_wood, 475}
    ];
get_demon_attr(2, 20) ->
    [
        {hp_max, 2000}
        ,{mp_max, 1000}
        ,{dmg, 200}
        ,{dmg_magic, 200}
        ,{defence, 1000}
        ,{critrate, 40}
        ,{tenacity, 40}
        ,{resist_wood, 500}
    ];
get_demon_attr(2, 21) ->
    [
        {hp_max, 2100}
        ,{mp_max, 1050}
        ,{dmg, 210}
        ,{dmg_magic, 210}
        ,{defence, 1050}
        ,{critrate, 42}
        ,{tenacity, 42}
        ,{resist_wood, 525}
    ];
get_demon_attr(2, 22) ->
    [
        {hp_max, 2200}
        ,{mp_max, 1100}
        ,{dmg, 220}
        ,{dmg_magic, 220}
        ,{defence, 1100}
        ,{critrate, 44}
        ,{tenacity, 44}
        ,{resist_wood, 550}
    ];
get_demon_attr(2, 23) ->
    [
        {hp_max, 2300}
        ,{mp_max, 1150}
        ,{dmg, 230}
        ,{dmg_magic, 230}
        ,{defence, 1150}
        ,{critrate, 46}
        ,{tenacity, 46}
        ,{resist_wood, 575}
    ];
get_demon_attr(2, 24) ->
    [
        {hp_max, 2400}
        ,{mp_max, 1200}
        ,{dmg, 240}
        ,{dmg_magic, 240}
        ,{defence, 1200}
        ,{critrate, 48}
        ,{tenacity, 48}
        ,{resist_wood, 600}
    ];
get_demon_attr(2, 25) ->
    [
        {hp_max, 2500}
        ,{mp_max, 1250}
        ,{dmg, 250}
        ,{dmg_magic, 250}
        ,{defence, 1250}
        ,{critrate, 50}
        ,{tenacity, 50}
        ,{resist_wood, 625}
    ];
get_demon_attr(2, 26) ->
    [
        {hp_max, 2600}
        ,{mp_max, 1300}
        ,{dmg, 260}
        ,{dmg_magic, 260}
        ,{defence, 1300}
        ,{critrate, 52}
        ,{tenacity, 52}
        ,{resist_wood, 650}
    ];
get_demon_attr(2, 27) ->
    [
        {hp_max, 2700}
        ,{mp_max, 1350}
        ,{dmg, 270}
        ,{dmg_magic, 270}
        ,{defence, 1350}
        ,{critrate, 54}
        ,{tenacity, 54}
        ,{resist_wood, 675}
    ];
get_demon_attr(2, 28) ->
    [
        {hp_max, 2800}
        ,{mp_max, 1400}
        ,{dmg, 280}
        ,{dmg_magic, 280}
        ,{defence, 1400}
        ,{critrate, 56}
        ,{tenacity, 56}
        ,{resist_wood, 700}
    ];
get_demon_attr(2, 29) ->
    [
        {hp_max, 2900}
        ,{mp_max, 1450}
        ,{dmg, 290}
        ,{dmg_magic, 290}
        ,{defence, 1450}
        ,{critrate, 58}
        ,{tenacity, 58}
        ,{resist_wood, 725}
    ];
get_demon_attr(2, 30) ->
    [
        {hp_max, 3000}
        ,{mp_max, 1500}
        ,{dmg, 300}
        ,{dmg_magic, 300}
        ,{defence, 1500}
        ,{critrate, 60}
        ,{tenacity, 60}
        ,{resist_wood, 750}
    ];
get_demon_attr(2, 31) ->
    [
        {hp_max, 3100}
        ,{mp_max, 1550}
        ,{dmg, 310}
        ,{dmg_magic, 310}
        ,{defence, 1550}
        ,{critrate, 62}
        ,{tenacity, 62}
        ,{resist_wood, 775}
    ];
get_demon_attr(2, 32) ->
    [
        {hp_max, 3200}
        ,{mp_max, 1600}
        ,{dmg, 320}
        ,{dmg_magic, 320}
        ,{defence, 1600}
        ,{critrate, 64}
        ,{tenacity, 64}
        ,{resist_wood, 800}
    ];
get_demon_attr(2, 33) ->
    [
        {hp_max, 3300}
        ,{mp_max, 1650}
        ,{dmg, 330}
        ,{dmg_magic, 330}
        ,{defence, 1650}
        ,{critrate, 66}
        ,{tenacity, 66}
        ,{resist_wood, 825}
    ];
get_demon_attr(2, 34) ->
    [
        {hp_max, 3400}
        ,{mp_max, 1700}
        ,{dmg, 340}
        ,{dmg_magic, 340}
        ,{defence, 1700}
        ,{critrate, 68}
        ,{tenacity, 68}
        ,{resist_wood, 850}
    ];
get_demon_attr(2, 35) ->
    [
        {hp_max, 3500}
        ,{mp_max, 1750}
        ,{dmg, 350}
        ,{dmg_magic, 350}
        ,{defence, 1750}
        ,{critrate, 70}
        ,{tenacity, 70}
        ,{resist_wood, 875}
    ];
get_demon_attr(2, 36) ->
    [
        {hp_max, 3600}
        ,{mp_max, 1800}
        ,{dmg, 360}
        ,{dmg_magic, 360}
        ,{defence, 1800}
        ,{critrate, 72}
        ,{tenacity, 72}
        ,{resist_wood, 900}
    ];
get_demon_attr(2, 37) ->
    [
        {hp_max, 3700}
        ,{mp_max, 1850}
        ,{dmg, 370}
        ,{dmg_magic, 370}
        ,{defence, 1850}
        ,{critrate, 74}
        ,{tenacity, 74}
        ,{resist_wood, 925}
    ];
get_demon_attr(2, 38) ->
    [
        {hp_max, 3800}
        ,{mp_max, 1900}
        ,{dmg, 380}
        ,{dmg_magic, 380}
        ,{defence, 1900}
        ,{critrate, 76}
        ,{tenacity, 76}
        ,{resist_wood, 950}
    ];
get_demon_attr(2, 39) ->
    [
        {hp_max, 3900}
        ,{mp_max, 1950}
        ,{dmg, 390}
        ,{dmg_magic, 390}
        ,{defence, 1950}
        ,{critrate, 78}
        ,{tenacity, 78}
        ,{resist_wood, 975}
    ];
get_demon_attr(2, 40) ->
    [
        {hp_max, 4000}
        ,{mp_max, 2000}
        ,{dmg, 400}
        ,{dmg_magic, 400}
        ,{defence, 2000}
        ,{critrate, 80}
        ,{tenacity, 80}
        ,{resist_wood, 1000}
    ];
get_demon_attr(2, 41) ->
    [
        {hp_max, 4100}
        ,{mp_max, 2050}
        ,{dmg, 410}
        ,{dmg_magic, 410}
        ,{defence, 2050}
        ,{critrate, 82}
        ,{tenacity, 82}
        ,{resist_wood, 1025}
    ];
get_demon_attr(2, 42) ->
    [
        {hp_max, 4200}
        ,{mp_max, 2100}
        ,{dmg, 420}
        ,{dmg_magic, 420}
        ,{defence, 2100}
        ,{critrate, 84}
        ,{tenacity, 84}
        ,{resist_wood, 1050}
    ];
get_demon_attr(2, 43) ->
    [
        {hp_max, 4300}
        ,{mp_max, 2150}
        ,{dmg, 430}
        ,{dmg_magic, 430}
        ,{defence, 2150}
        ,{critrate, 86}
        ,{tenacity, 86}
        ,{resist_wood, 1075}
    ];
get_demon_attr(2, 44) ->
    [
        {hp_max, 4400}
        ,{mp_max, 2200}
        ,{dmg, 440}
        ,{dmg_magic, 440}
        ,{defence, 2200}
        ,{critrate, 88}
        ,{tenacity, 88}
        ,{resist_wood, 1100}
    ];
get_demon_attr(2, 45) ->
    [
        {hp_max, 4500}
        ,{mp_max, 2250}
        ,{dmg, 450}
        ,{dmg_magic, 450}
        ,{defence, 2250}
        ,{critrate, 90}
        ,{tenacity, 90}
        ,{resist_wood, 1125}
    ];
get_demon_attr(2, 46) ->
    [
        {hp_max, 4600}
        ,{mp_max, 2300}
        ,{dmg, 460}
        ,{dmg_magic, 460}
        ,{defence, 2300}
        ,{critrate, 92}
        ,{tenacity, 92}
        ,{resist_wood, 1150}
    ];
get_demon_attr(2, 47) ->
    [
        {hp_max, 4700}
        ,{mp_max, 2350}
        ,{dmg, 470}
        ,{dmg_magic, 470}
        ,{defence, 2350}
        ,{critrate, 94}
        ,{tenacity, 94}
        ,{resist_wood, 1175}
    ];
get_demon_attr(2, 48) ->
    [
        {hp_max, 4800}
        ,{mp_max, 2400}
        ,{dmg, 480}
        ,{dmg_magic, 480}
        ,{defence, 2400}
        ,{critrate, 96}
        ,{tenacity, 96}
        ,{resist_wood, 1200}
    ];
get_demon_attr(2, 49) ->
    [
        {hp_max, 4900}
        ,{mp_max, 2450}
        ,{dmg, 490}
        ,{dmg_magic, 490}
        ,{defence, 2450}
        ,{critrate, 98}
        ,{tenacity, 98}
        ,{resist_wood, 1225}
    ];
get_demon_attr(2, 50) ->
    [
        {hp_max, 5000}
        ,{mp_max, 2500}
        ,{dmg, 500}
        ,{dmg_magic, 500}
        ,{defence, 2500}
        ,{critrate, 100}
        ,{tenacity, 100}
        ,{resist_wood, 1250}
    ];
get_demon_attr(2, 51) ->
    [
        {hp_max, 5100}
        ,{mp_max, 2550}
        ,{dmg, 510}
        ,{dmg_magic, 510}
        ,{defence, 2550}
        ,{critrate, 102}
        ,{tenacity, 102}
        ,{resist_wood, 1275}
    ];
get_demon_attr(2, 52) ->
    [
        {hp_max, 5200}
        ,{mp_max, 2600}
        ,{dmg, 520}
        ,{dmg_magic, 520}
        ,{defence, 2600}
        ,{critrate, 104}
        ,{tenacity, 104}
        ,{resist_wood, 1300}
    ];
get_demon_attr(2, 53) ->
    [
        {hp_max, 5300}
        ,{mp_max, 2650}
        ,{dmg, 530}
        ,{dmg_magic, 530}
        ,{defence, 2650}
        ,{critrate, 106}
        ,{tenacity, 106}
        ,{resist_wood, 1325}
    ];
get_demon_attr(2, 54) ->
    [
        {hp_max, 5400}
        ,{mp_max, 2700}
        ,{dmg, 540}
        ,{dmg_magic, 540}
        ,{defence, 2700}
        ,{critrate, 108}
        ,{tenacity, 108}
        ,{resist_wood, 1350}
    ];
get_demon_attr(2, 55) ->
    [
        {hp_max, 5500}
        ,{mp_max, 2750}
        ,{dmg, 550}
        ,{dmg_magic, 550}
        ,{defence, 2750}
        ,{critrate, 110}
        ,{tenacity, 110}
        ,{resist_wood, 1375}
    ];
get_demon_attr(2, 56) ->
    [
        {hp_max, 5600}
        ,{mp_max, 2800}
        ,{dmg, 560}
        ,{dmg_magic, 560}
        ,{defence, 2800}
        ,{critrate, 112}
        ,{tenacity, 112}
        ,{resist_wood, 1400}
    ];
get_demon_attr(2, 57) ->
    [
        {hp_max, 5700}
        ,{mp_max, 2850}
        ,{dmg, 570}
        ,{dmg_magic, 570}
        ,{defence, 2850}
        ,{critrate, 114}
        ,{tenacity, 114}
        ,{resist_wood, 1425}
    ];
get_demon_attr(2, 58) ->
    [
        {hp_max, 5800}
        ,{mp_max, 2900}
        ,{dmg, 580}
        ,{dmg_magic, 580}
        ,{defence, 2900}
        ,{critrate, 116}
        ,{tenacity, 116}
        ,{resist_wood, 1450}
    ];
get_demon_attr(2, 59) ->
    [
        {hp_max, 5900}
        ,{mp_max, 2950}
        ,{dmg, 590}
        ,{dmg_magic, 590}
        ,{defence, 2950}
        ,{critrate, 118}
        ,{tenacity, 118}
        ,{resist_wood, 1475}
    ];
get_demon_attr(2, 60) ->
    [
        {hp_max, 6000}
        ,{mp_max, 3000}
        ,{dmg, 600}
        ,{dmg_magic, 600}
        ,{defence, 3000}
        ,{critrate, 120}
        ,{tenacity, 120}
        ,{resist_wood, 1500}
    ];
get_demon_attr(2, 61) ->
    [
        {hp_max, 6100}
        ,{mp_max, 3050}
        ,{dmg, 610}
        ,{dmg_magic, 610}
        ,{defence, 3050}
        ,{critrate, 122}
        ,{tenacity, 122}
        ,{resist_wood, 1525}
    ];
get_demon_attr(2, 62) ->
    [
        {hp_max, 6200}
        ,{mp_max, 3100}
        ,{dmg, 620}
        ,{dmg_magic, 620}
        ,{defence, 3100}
        ,{critrate, 124}
        ,{tenacity, 124}
        ,{resist_wood, 1550}
    ];
get_demon_attr(2, 63) ->
    [
        {hp_max, 6300}
        ,{mp_max, 3150}
        ,{dmg, 630}
        ,{dmg_magic, 630}
        ,{defence, 3150}
        ,{critrate, 126}
        ,{tenacity, 126}
        ,{resist_wood, 1575}
    ];
get_demon_attr(2, 64) ->
    [
        {hp_max, 6400}
        ,{mp_max, 3200}
        ,{dmg, 640}
        ,{dmg_magic, 640}
        ,{defence, 3200}
        ,{critrate, 128}
        ,{tenacity, 128}
        ,{resist_wood, 1600}
    ];
get_demon_attr(2, 65) ->
    [
        {hp_max, 6500}
        ,{mp_max, 3250}
        ,{dmg, 650}
        ,{dmg_magic, 650}
        ,{defence, 3250}
        ,{critrate, 130}
        ,{tenacity, 130}
        ,{resist_wood, 1625}
    ];
get_demon_attr(2, 66) ->
    [
        {hp_max, 6600}
        ,{mp_max, 3300}
        ,{dmg, 660}
        ,{dmg_magic, 660}
        ,{defence, 3300}
        ,{critrate, 132}
        ,{tenacity, 132}
        ,{resist_wood, 1650}
    ];
get_demon_attr(2, 67) ->
    [
        {hp_max, 6700}
        ,{mp_max, 3350}
        ,{dmg, 670}
        ,{dmg_magic, 670}
        ,{defence, 3350}
        ,{critrate, 134}
        ,{tenacity, 134}
        ,{resist_wood, 1675}
    ];
get_demon_attr(2, 68) ->
    [
        {hp_max, 6800}
        ,{mp_max, 3400}
        ,{dmg, 680}
        ,{dmg_magic, 680}
        ,{defence, 3400}
        ,{critrate, 136}
        ,{tenacity, 136}
        ,{resist_wood, 1700}
    ];
get_demon_attr(2, 69) ->
    [
        {hp_max, 6900}
        ,{mp_max, 3450}
        ,{dmg, 690}
        ,{dmg_magic, 690}
        ,{defence, 3450}
        ,{critrate, 138}
        ,{tenacity, 138}
        ,{resist_wood, 1725}
    ];
get_demon_attr(2, 70) ->
    [
        {hp_max, 7000}
        ,{mp_max, 3500}
        ,{dmg, 700}
        ,{dmg_magic, 700}
        ,{defence, 3500}
        ,{critrate, 140}
        ,{tenacity, 140}
        ,{resist_wood, 1750}
    ];
get_demon_attr(2, 71) ->
    [
        {hp_max, 7100}
        ,{mp_max, 3550}
        ,{dmg, 710}
        ,{dmg_magic, 710}
        ,{defence, 3550}
        ,{critrate, 142}
        ,{tenacity, 142}
        ,{resist_wood, 1775}
    ];
get_demon_attr(2, 72) ->
    [
        {hp_max, 7200}
        ,{mp_max, 3600}
        ,{dmg, 720}
        ,{dmg_magic, 720}
        ,{defence, 3600}
        ,{critrate, 144}
        ,{tenacity, 144}
        ,{resist_wood, 1800}
    ];
get_demon_attr(2, 73) ->
    [
        {hp_max, 7300}
        ,{mp_max, 3650}
        ,{dmg, 730}
        ,{dmg_magic, 730}
        ,{defence, 3650}
        ,{critrate, 146}
        ,{tenacity, 146}
        ,{resist_wood, 1825}
    ];
get_demon_attr(2, 74) ->
    [
        {hp_max, 7400}
        ,{mp_max, 3700}
        ,{dmg, 740}
        ,{dmg_magic, 740}
        ,{defence, 3700}
        ,{critrate, 148}
        ,{tenacity, 148}
        ,{resist_wood, 1850}
    ];
get_demon_attr(2, 75) ->
    [
        {hp_max, 7500}
        ,{mp_max, 3750}
        ,{dmg, 750}
        ,{dmg_magic, 750}
        ,{defence, 3750}
        ,{critrate, 150}
        ,{tenacity, 150}
        ,{resist_wood, 1875}
    ];
get_demon_attr(2, 76) ->
    [
        {hp_max, 7600}
        ,{mp_max, 3800}
        ,{dmg, 760}
        ,{dmg_magic, 760}
        ,{defence, 3800}
        ,{critrate, 152}
        ,{tenacity, 152}
        ,{resist_wood, 1900}
    ];
get_demon_attr(2, 77) ->
    [
        {hp_max, 7700}
        ,{mp_max, 3850}
        ,{dmg, 770}
        ,{dmg_magic, 770}
        ,{defence, 3850}
        ,{critrate, 154}
        ,{tenacity, 154}
        ,{resist_wood, 1925}
    ];
get_demon_attr(2, 78) ->
    [
        {hp_max, 7800}
        ,{mp_max, 3900}
        ,{dmg, 780}
        ,{dmg_magic, 780}
        ,{defence, 3900}
        ,{critrate, 156}
        ,{tenacity, 156}
        ,{resist_wood, 1950}
    ];
get_demon_attr(2, 79) ->
    [
        {hp_max, 7900}
        ,{mp_max, 3950}
        ,{dmg, 790}
        ,{dmg_magic, 790}
        ,{defence, 3950}
        ,{critrate, 158}
        ,{tenacity, 158}
        ,{resist_wood, 1975}
    ];
get_demon_attr(2, 80) ->
    [
        {hp_max, 8000}
        ,{mp_max, 4000}
        ,{dmg, 800}
        ,{dmg_magic, 800}
        ,{defence, 4000}
        ,{critrate, 160}
        ,{tenacity, 160}
        ,{resist_wood, 2000}
    ];
get_demon_attr(2, 81) ->
    [
        {hp_max, 8100}
        ,{mp_max, 4050}
        ,{dmg, 810}
        ,{dmg_magic, 810}
        ,{defence, 4050}
        ,{critrate, 162}
        ,{tenacity, 162}
        ,{resist_wood, 2025}
    ];
get_demon_attr(2, 82) ->
    [
        {hp_max, 8200}
        ,{mp_max, 4100}
        ,{dmg, 820}
        ,{dmg_magic, 820}
        ,{defence, 4100}
        ,{critrate, 164}
        ,{tenacity, 164}
        ,{resist_wood, 2050}
    ];
get_demon_attr(2, 83) ->
    [
        {hp_max, 8300}
        ,{mp_max, 4150}
        ,{dmg, 830}
        ,{dmg_magic, 830}
        ,{defence, 4150}
        ,{critrate, 166}
        ,{tenacity, 166}
        ,{resist_wood, 2075}
    ];
get_demon_attr(2, 84) ->
    [
        {hp_max, 8400}
        ,{mp_max, 4200}
        ,{dmg, 840}
        ,{dmg_magic, 840}
        ,{defence, 4200}
        ,{critrate, 168}
        ,{tenacity, 168}
        ,{resist_wood, 2100}
    ];
get_demon_attr(2, 85) ->
    [
        {hp_max, 8500}
        ,{mp_max, 4250}
        ,{dmg, 850}
        ,{dmg_magic, 850}
        ,{defence, 4250}
        ,{critrate, 170}
        ,{tenacity, 170}
        ,{resist_wood, 2125}
    ];
get_demon_attr(2, 86) ->
    [
        {hp_max, 8600}
        ,{mp_max, 4300}
        ,{dmg, 860}
        ,{dmg_magic, 860}
        ,{defence, 4300}
        ,{critrate, 172}
        ,{tenacity, 172}
        ,{resist_wood, 2150}
    ];
get_demon_attr(2, 87) ->
    [
        {hp_max, 8700}
        ,{mp_max, 4350}
        ,{dmg, 870}
        ,{dmg_magic, 870}
        ,{defence, 4350}
        ,{critrate, 174}
        ,{tenacity, 174}
        ,{resist_wood, 2175}
    ];
get_demon_attr(2, 88) ->
    [
        {hp_max, 8800}
        ,{mp_max, 4400}
        ,{dmg, 880}
        ,{dmg_magic, 880}
        ,{defence, 4400}
        ,{critrate, 176}
        ,{tenacity, 176}
        ,{resist_wood, 2200}
    ];
get_demon_attr(2, 89) ->
    [
        {hp_max, 8900}
        ,{mp_max, 4450}
        ,{dmg, 890}
        ,{dmg_magic, 890}
        ,{defence, 4450}
        ,{critrate, 178}
        ,{tenacity, 178}
        ,{resist_wood, 2225}
    ];
get_demon_attr(2, 90) ->
    [
        {hp_max, 9000}
        ,{mp_max, 4500}
        ,{dmg, 900}
        ,{dmg_magic, 900}
        ,{defence, 4500}
        ,{critrate, 180}
        ,{tenacity, 180}
        ,{resist_wood, 2250}
    ];
get_demon_attr(2, 91) ->
    [
        {hp_max, 9100}
        ,{mp_max, 4550}
        ,{dmg, 910}
        ,{dmg_magic, 910}
        ,{defence, 4550}
        ,{critrate, 182}
        ,{tenacity, 182}
        ,{resist_wood, 2275}
    ];
get_demon_attr(2, 92) ->
    [
        {hp_max, 9200}
        ,{mp_max, 4600}
        ,{dmg, 920}
        ,{dmg_magic, 920}
        ,{defence, 4600}
        ,{critrate, 184}
        ,{tenacity, 184}
        ,{resist_wood, 2300}
    ];
get_demon_attr(2, 93) ->
    [
        {hp_max, 9300}
        ,{mp_max, 4650}
        ,{dmg, 930}
        ,{dmg_magic, 930}
        ,{defence, 4650}
        ,{critrate, 186}
        ,{tenacity, 186}
        ,{resist_wood, 2325}
    ];
get_demon_attr(2, 94) ->
    [
        {hp_max, 9400}
        ,{mp_max, 4700}
        ,{dmg, 940}
        ,{dmg_magic, 940}
        ,{defence, 4700}
        ,{critrate, 188}
        ,{tenacity, 188}
        ,{resist_wood, 2350}
    ];
get_demon_attr(2, 95) ->
    [
        {hp_max, 9500}
        ,{mp_max, 4750}
        ,{dmg, 950}
        ,{dmg_magic, 950}
        ,{defence, 4750}
        ,{critrate, 190}
        ,{tenacity, 190}
        ,{resist_wood, 2375}
    ];
get_demon_attr(2, 96) ->
    [
        {hp_max, 9600}
        ,{mp_max, 4800}
        ,{dmg, 960}
        ,{dmg_magic, 960}
        ,{defence, 4800}
        ,{critrate, 192}
        ,{tenacity, 192}
        ,{resist_wood, 2400}
    ];
get_demon_attr(2, 97) ->
    [
        {hp_max, 9700}
        ,{mp_max, 4850}
        ,{dmg, 970}
        ,{dmg_magic, 970}
        ,{defence, 4850}
        ,{critrate, 194}
        ,{tenacity, 194}
        ,{resist_wood, 2425}
    ];
get_demon_attr(2, 98) ->
    [
        {hp_max, 9800}
        ,{mp_max, 4900}
        ,{dmg, 980}
        ,{dmg_magic, 980}
        ,{defence, 4900}
        ,{critrate, 196}
        ,{tenacity, 196}
        ,{resist_wood, 2450}
    ];
get_demon_attr(2, 99) ->
    [
        {hp_max, 9900}
        ,{mp_max, 4950}
        ,{dmg, 990}
        ,{dmg_magic, 990}
        ,{defence, 4950}
        ,{critrate, 198}
        ,{tenacity, 198}
        ,{resist_wood, 2475}
    ];
get_demon_attr(2, 100) ->
    [
        {hp_max, 10000}
        ,{mp_max, 5000}
        ,{dmg, 1000}
        ,{dmg_magic, 1000}
        ,{defence, 5000}
        ,{critrate, 200}
        ,{tenacity, 200}
        ,{resist_wood, 2500}
    ];
get_demon_attr(3, 1) ->
    [
        {hp_max, 100}
        ,{mp_max, 50}
        ,{dmg, 10}
        ,{dmg_magic, 10}
        ,{defence, 50}
        ,{critrate, 2}
        ,{tenacity, 2}
        ,{resist_water, 25}
    ];
get_demon_attr(3, 2) ->
    [
        {hp_max, 200}
        ,{mp_max, 100}
        ,{dmg, 20}
        ,{dmg_magic, 20}
        ,{defence, 100}
        ,{critrate, 4}
        ,{tenacity, 4}
        ,{resist_water, 50}
    ];
get_demon_attr(3, 3) ->
    [
        {hp_max, 300}
        ,{mp_max, 150}
        ,{dmg, 30}
        ,{dmg_magic, 30}
        ,{defence, 150}
        ,{critrate, 6}
        ,{tenacity, 6}
        ,{resist_water, 75}
    ];
get_demon_attr(3, 4) ->
    [
        {hp_max, 400}
        ,{mp_max, 200}
        ,{dmg, 40}
        ,{dmg_magic, 40}
        ,{defence, 200}
        ,{critrate, 8}
        ,{tenacity, 8}
        ,{resist_water, 100}
    ];
get_demon_attr(3, 5) ->
    [
        {hp_max, 500}
        ,{mp_max, 250}
        ,{dmg, 50}
        ,{dmg_magic, 50}
        ,{defence, 250}
        ,{critrate, 10}
        ,{tenacity, 10}
        ,{resist_water, 125}
    ];
get_demon_attr(3, 6) ->
    [
        {hp_max, 600}
        ,{mp_max, 300}
        ,{dmg, 60}
        ,{dmg_magic, 60}
        ,{defence, 300}
        ,{critrate, 12}
        ,{tenacity, 12}
        ,{resist_water, 150}
    ];
get_demon_attr(3, 7) ->
    [
        {hp_max, 700}
        ,{mp_max, 350}
        ,{dmg, 70}
        ,{dmg_magic, 70}
        ,{defence, 350}
        ,{critrate, 14}
        ,{tenacity, 14}
        ,{resist_water, 175}
    ];
get_demon_attr(3, 8) ->
    [
        {hp_max, 800}
        ,{mp_max, 400}
        ,{dmg, 80}
        ,{dmg_magic, 80}
        ,{defence, 400}
        ,{critrate, 16}
        ,{tenacity, 16}
        ,{resist_water, 200}
    ];
get_demon_attr(3, 9) ->
    [
        {hp_max, 900}
        ,{mp_max, 450}
        ,{dmg, 90}
        ,{dmg_magic, 90}
        ,{defence, 450}
        ,{critrate, 18}
        ,{tenacity, 18}
        ,{resist_water, 225}
    ];
get_demon_attr(3, 10) ->
    [
        {hp_max, 1000}
        ,{mp_max, 500}
        ,{dmg, 100}
        ,{dmg_magic, 100}
        ,{defence, 500}
        ,{critrate, 20}
        ,{tenacity, 20}
        ,{resist_water, 250}
    ];
get_demon_attr(3, 11) ->
    [
        {hp_max, 1100}
        ,{mp_max, 550}
        ,{dmg, 110}
        ,{dmg_magic, 110}
        ,{defence, 550}
        ,{critrate, 22}
        ,{tenacity, 22}
        ,{resist_water, 275}
    ];
get_demon_attr(3, 12) ->
    [
        {hp_max, 1200}
        ,{mp_max, 600}
        ,{dmg, 120}
        ,{dmg_magic, 120}
        ,{defence, 600}
        ,{critrate, 24}
        ,{tenacity, 24}
        ,{resist_water, 300}
    ];
get_demon_attr(3, 13) ->
    [
        {hp_max, 1300}
        ,{mp_max, 650}
        ,{dmg, 130}
        ,{dmg_magic, 130}
        ,{defence, 650}
        ,{critrate, 26}
        ,{tenacity, 26}
        ,{resist_water, 325}
    ];
get_demon_attr(3, 14) ->
    [
        {hp_max, 1400}
        ,{mp_max, 700}
        ,{dmg, 140}
        ,{dmg_magic, 140}
        ,{defence, 700}
        ,{critrate, 28}
        ,{tenacity, 28}
        ,{resist_water, 350}
    ];
get_demon_attr(3, 15) ->
    [
        {hp_max, 1500}
        ,{mp_max, 750}
        ,{dmg, 150}
        ,{dmg_magic, 150}
        ,{defence, 750}
        ,{critrate, 30}
        ,{tenacity, 30}
        ,{resist_water, 375}
    ];
get_demon_attr(3, 16) ->
    [
        {hp_max, 1600}
        ,{mp_max, 800}
        ,{dmg, 160}
        ,{dmg_magic, 160}
        ,{defence, 800}
        ,{critrate, 32}
        ,{tenacity, 32}
        ,{resist_water, 400}
    ];
get_demon_attr(3, 17) ->
    [
        {hp_max, 1700}
        ,{mp_max, 850}
        ,{dmg, 170}
        ,{dmg_magic, 170}
        ,{defence, 850}
        ,{critrate, 34}
        ,{tenacity, 34}
        ,{resist_water, 425}
    ];
get_demon_attr(3, 18) ->
    [
        {hp_max, 1800}
        ,{mp_max, 900}
        ,{dmg, 180}
        ,{dmg_magic, 180}
        ,{defence, 900}
        ,{critrate, 36}
        ,{tenacity, 36}
        ,{resist_water, 450}
    ];
get_demon_attr(3, 19) ->
    [
        {hp_max, 1900}
        ,{mp_max, 950}
        ,{dmg, 190}
        ,{dmg_magic, 190}
        ,{defence, 950}
        ,{critrate, 38}
        ,{tenacity, 38}
        ,{resist_water, 475}
    ];
get_demon_attr(3, 20) ->
    [
        {hp_max, 2000}
        ,{mp_max, 1000}
        ,{dmg, 200}
        ,{dmg_magic, 200}
        ,{defence, 1000}
        ,{critrate, 40}
        ,{tenacity, 40}
        ,{resist_water, 500}
    ];
get_demon_attr(3, 21) ->
    [
        {hp_max, 2100}
        ,{mp_max, 1050}
        ,{dmg, 210}
        ,{dmg_magic, 210}
        ,{defence, 1050}
        ,{critrate, 42}
        ,{tenacity, 42}
        ,{resist_water, 525}
    ];
get_demon_attr(3, 22) ->
    [
        {hp_max, 2200}
        ,{mp_max, 1100}
        ,{dmg, 220}
        ,{dmg_magic, 220}
        ,{defence, 1100}
        ,{critrate, 44}
        ,{tenacity, 44}
        ,{resist_water, 550}
    ];
get_demon_attr(3, 23) ->
    [
        {hp_max, 2300}
        ,{mp_max, 1150}
        ,{dmg, 230}
        ,{dmg_magic, 230}
        ,{defence, 1150}
        ,{critrate, 46}
        ,{tenacity, 46}
        ,{resist_water, 575}
    ];
get_demon_attr(3, 24) ->
    [
        {hp_max, 2400}
        ,{mp_max, 1200}
        ,{dmg, 240}
        ,{dmg_magic, 240}
        ,{defence, 1200}
        ,{critrate, 48}
        ,{tenacity, 48}
        ,{resist_water, 600}
    ];
get_demon_attr(3, 25) ->
    [
        {hp_max, 2500}
        ,{mp_max, 1250}
        ,{dmg, 250}
        ,{dmg_magic, 250}
        ,{defence, 1250}
        ,{critrate, 50}
        ,{tenacity, 50}
        ,{resist_water, 625}
    ];
get_demon_attr(3, 26) ->
    [
        {hp_max, 2600}
        ,{mp_max, 1300}
        ,{dmg, 260}
        ,{dmg_magic, 260}
        ,{defence, 1300}
        ,{critrate, 52}
        ,{tenacity, 52}
        ,{resist_water, 650}
    ];
get_demon_attr(3, 27) ->
    [
        {hp_max, 2700}
        ,{mp_max, 1350}
        ,{dmg, 270}
        ,{dmg_magic, 270}
        ,{defence, 1350}
        ,{critrate, 54}
        ,{tenacity, 54}
        ,{resist_water, 675}
    ];
get_demon_attr(3, 28) ->
    [
        {hp_max, 2800}
        ,{mp_max, 1400}
        ,{dmg, 280}
        ,{dmg_magic, 280}
        ,{defence, 1400}
        ,{critrate, 56}
        ,{tenacity, 56}
        ,{resist_water, 700}
    ];
get_demon_attr(3, 29) ->
    [
        {hp_max, 2900}
        ,{mp_max, 1450}
        ,{dmg, 290}
        ,{dmg_magic, 290}
        ,{defence, 1450}
        ,{critrate, 58}
        ,{tenacity, 58}
        ,{resist_water, 725}
    ];
get_demon_attr(3, 30) ->
    [
        {hp_max, 3000}
        ,{mp_max, 1500}
        ,{dmg, 300}
        ,{dmg_magic, 300}
        ,{defence, 1500}
        ,{critrate, 60}
        ,{tenacity, 60}
        ,{resist_water, 750}
    ];
get_demon_attr(3, 31) ->
    [
        {hp_max, 3100}
        ,{mp_max, 1550}
        ,{dmg, 310}
        ,{dmg_magic, 310}
        ,{defence, 1550}
        ,{critrate, 62}
        ,{tenacity, 62}
        ,{resist_water, 775}
    ];
get_demon_attr(3, 32) ->
    [
        {hp_max, 3200}
        ,{mp_max, 1600}
        ,{dmg, 320}
        ,{dmg_magic, 320}
        ,{defence, 1600}
        ,{critrate, 64}
        ,{tenacity, 64}
        ,{resist_water, 800}
    ];
get_demon_attr(3, 33) ->
    [
        {hp_max, 3300}
        ,{mp_max, 1650}
        ,{dmg, 330}
        ,{dmg_magic, 330}
        ,{defence, 1650}
        ,{critrate, 66}
        ,{tenacity, 66}
        ,{resist_water, 825}
    ];
get_demon_attr(3, 34) ->
    [
        {hp_max, 3400}
        ,{mp_max, 1700}
        ,{dmg, 340}
        ,{dmg_magic, 340}
        ,{defence, 1700}
        ,{critrate, 68}
        ,{tenacity, 68}
        ,{resist_water, 850}
    ];
get_demon_attr(3, 35) ->
    [
        {hp_max, 3500}
        ,{mp_max, 1750}
        ,{dmg, 350}
        ,{dmg_magic, 350}
        ,{defence, 1750}
        ,{critrate, 70}
        ,{tenacity, 70}
        ,{resist_water, 875}
    ];
get_demon_attr(3, 36) ->
    [
        {hp_max, 3600}
        ,{mp_max, 1800}
        ,{dmg, 360}
        ,{dmg_magic, 360}
        ,{defence, 1800}
        ,{critrate, 72}
        ,{tenacity, 72}
        ,{resist_water, 900}
    ];
get_demon_attr(3, 37) ->
    [
        {hp_max, 3700}
        ,{mp_max, 1850}
        ,{dmg, 370}
        ,{dmg_magic, 370}
        ,{defence, 1850}
        ,{critrate, 74}
        ,{tenacity, 74}
        ,{resist_water, 925}
    ];
get_demon_attr(3, 38) ->
    [
        {hp_max, 3800}
        ,{mp_max, 1900}
        ,{dmg, 380}
        ,{dmg_magic, 380}
        ,{defence, 1900}
        ,{critrate, 76}
        ,{tenacity, 76}
        ,{resist_water, 950}
    ];
get_demon_attr(3, 39) ->
    [
        {hp_max, 3900}
        ,{mp_max, 1950}
        ,{dmg, 390}
        ,{dmg_magic, 390}
        ,{defence, 1950}
        ,{critrate, 78}
        ,{tenacity, 78}
        ,{resist_water, 975}
    ];
get_demon_attr(3, 40) ->
    [
        {hp_max, 4000}
        ,{mp_max, 2000}
        ,{dmg, 400}
        ,{dmg_magic, 400}
        ,{defence, 2000}
        ,{critrate, 80}
        ,{tenacity, 80}
        ,{resist_water, 1000}
    ];
get_demon_attr(3, 41) ->
    [
        {hp_max, 4100}
        ,{mp_max, 2050}
        ,{dmg, 410}
        ,{dmg_magic, 410}
        ,{defence, 2050}
        ,{critrate, 82}
        ,{tenacity, 82}
        ,{resist_water, 1025}
    ];
get_demon_attr(3, 42) ->
    [
        {hp_max, 4200}
        ,{mp_max, 2100}
        ,{dmg, 420}
        ,{dmg_magic, 420}
        ,{defence, 2100}
        ,{critrate, 84}
        ,{tenacity, 84}
        ,{resist_water, 1050}
    ];
get_demon_attr(3, 43) ->
    [
        {hp_max, 4300}
        ,{mp_max, 2150}
        ,{dmg, 430}
        ,{dmg_magic, 430}
        ,{defence, 2150}
        ,{critrate, 86}
        ,{tenacity, 86}
        ,{resist_water, 1075}
    ];
get_demon_attr(3, 44) ->
    [
        {hp_max, 4400}
        ,{mp_max, 2200}
        ,{dmg, 440}
        ,{dmg_magic, 440}
        ,{defence, 2200}
        ,{critrate, 88}
        ,{tenacity, 88}
        ,{resist_water, 1100}
    ];
get_demon_attr(3, 45) ->
    [
        {hp_max, 4500}
        ,{mp_max, 2250}
        ,{dmg, 450}
        ,{dmg_magic, 450}
        ,{defence, 2250}
        ,{critrate, 90}
        ,{tenacity, 90}
        ,{resist_water, 1125}
    ];
get_demon_attr(3, 46) ->
    [
        {hp_max, 4600}
        ,{mp_max, 2300}
        ,{dmg, 460}
        ,{dmg_magic, 460}
        ,{defence, 2300}
        ,{critrate, 92}
        ,{tenacity, 92}
        ,{resist_water, 1150}
    ];
get_demon_attr(3, 47) ->
    [
        {hp_max, 4700}
        ,{mp_max, 2350}
        ,{dmg, 470}
        ,{dmg_magic, 470}
        ,{defence, 2350}
        ,{critrate, 94}
        ,{tenacity, 94}
        ,{resist_water, 1175}
    ];
get_demon_attr(3, 48) ->
    [
        {hp_max, 4800}
        ,{mp_max, 2400}
        ,{dmg, 480}
        ,{dmg_magic, 480}
        ,{defence, 2400}
        ,{critrate, 96}
        ,{tenacity, 96}
        ,{resist_water, 1200}
    ];
get_demon_attr(3, 49) ->
    [
        {hp_max, 4900}
        ,{mp_max, 2450}
        ,{dmg, 490}
        ,{dmg_magic, 490}
        ,{defence, 2450}
        ,{critrate, 98}
        ,{tenacity, 98}
        ,{resist_water, 1225}
    ];
get_demon_attr(3, 50) ->
    [
        {hp_max, 5000}
        ,{mp_max, 2500}
        ,{dmg, 500}
        ,{dmg_magic, 500}
        ,{defence, 2500}
        ,{critrate, 100}
        ,{tenacity, 100}
        ,{resist_water, 1250}
    ];
get_demon_attr(3, 51) ->
    [
        {hp_max, 5100}
        ,{mp_max, 2550}
        ,{dmg, 510}
        ,{dmg_magic, 510}
        ,{defence, 2550}
        ,{critrate, 102}
        ,{tenacity, 102}
        ,{resist_water, 1275}
    ];
get_demon_attr(3, 52) ->
    [
        {hp_max, 5200}
        ,{mp_max, 2600}
        ,{dmg, 520}
        ,{dmg_magic, 520}
        ,{defence, 2600}
        ,{critrate, 104}
        ,{tenacity, 104}
        ,{resist_water, 1300}
    ];
get_demon_attr(3, 53) ->
    [
        {hp_max, 5300}
        ,{mp_max, 2650}
        ,{dmg, 530}
        ,{dmg_magic, 530}
        ,{defence, 2650}
        ,{critrate, 106}
        ,{tenacity, 106}
        ,{resist_water, 1325}
    ];
get_demon_attr(3, 54) ->
    [
        {hp_max, 5400}
        ,{mp_max, 2700}
        ,{dmg, 540}
        ,{dmg_magic, 540}
        ,{defence, 2700}
        ,{critrate, 108}
        ,{tenacity, 108}
        ,{resist_water, 1350}
    ];
get_demon_attr(3, 55) ->
    [
        {hp_max, 5500}
        ,{mp_max, 2750}
        ,{dmg, 550}
        ,{dmg_magic, 550}
        ,{defence, 2750}
        ,{critrate, 110}
        ,{tenacity, 110}
        ,{resist_water, 1375}
    ];
get_demon_attr(3, 56) ->
    [
        {hp_max, 5600}
        ,{mp_max, 2800}
        ,{dmg, 560}
        ,{dmg_magic, 560}
        ,{defence, 2800}
        ,{critrate, 112}
        ,{tenacity, 112}
        ,{resist_water, 1400}
    ];
get_demon_attr(3, 57) ->
    [
        {hp_max, 5700}
        ,{mp_max, 2850}
        ,{dmg, 570}
        ,{dmg_magic, 570}
        ,{defence, 2850}
        ,{critrate, 114}
        ,{tenacity, 114}
        ,{resist_water, 1425}
    ];
get_demon_attr(3, 58) ->
    [
        {hp_max, 5800}
        ,{mp_max, 2900}
        ,{dmg, 580}
        ,{dmg_magic, 580}
        ,{defence, 2900}
        ,{critrate, 116}
        ,{tenacity, 116}
        ,{resist_water, 1450}
    ];
get_demon_attr(3, 59) ->
    [
        {hp_max, 5900}
        ,{mp_max, 2950}
        ,{dmg, 590}
        ,{dmg_magic, 590}
        ,{defence, 2950}
        ,{critrate, 118}
        ,{tenacity, 118}
        ,{resist_water, 1475}
    ];
get_demon_attr(3, 60) ->
    [
        {hp_max, 6000}
        ,{mp_max, 3000}
        ,{dmg, 600}
        ,{dmg_magic, 600}
        ,{defence, 3000}
        ,{critrate, 120}
        ,{tenacity, 120}
        ,{resist_water, 1500}
    ];
get_demon_attr(3, 61) ->
    [
        {hp_max, 6100}
        ,{mp_max, 3050}
        ,{dmg, 610}
        ,{dmg_magic, 610}
        ,{defence, 3050}
        ,{critrate, 122}
        ,{tenacity, 122}
        ,{resist_water, 1525}
    ];
get_demon_attr(3, 62) ->
    [
        {hp_max, 6200}
        ,{mp_max, 3100}
        ,{dmg, 620}
        ,{dmg_magic, 620}
        ,{defence, 3100}
        ,{critrate, 124}
        ,{tenacity, 124}
        ,{resist_water, 1550}
    ];
get_demon_attr(3, 63) ->
    [
        {hp_max, 6300}
        ,{mp_max, 3150}
        ,{dmg, 630}
        ,{dmg_magic, 630}
        ,{defence, 3150}
        ,{critrate, 126}
        ,{tenacity, 126}
        ,{resist_water, 1575}
    ];
get_demon_attr(3, 64) ->
    [
        {hp_max, 6400}
        ,{mp_max, 3200}
        ,{dmg, 640}
        ,{dmg_magic, 640}
        ,{defence, 3200}
        ,{critrate, 128}
        ,{tenacity, 128}
        ,{resist_water, 1600}
    ];
get_demon_attr(3, 65) ->
    [
        {hp_max, 6500}
        ,{mp_max, 3250}
        ,{dmg, 650}
        ,{dmg_magic, 650}
        ,{defence, 3250}
        ,{critrate, 130}
        ,{tenacity, 130}
        ,{resist_water, 1625}
    ];
get_demon_attr(3, 66) ->
    [
        {hp_max, 6600}
        ,{mp_max, 3300}
        ,{dmg, 660}
        ,{dmg_magic, 660}
        ,{defence, 3300}
        ,{critrate, 132}
        ,{tenacity, 132}
        ,{resist_water, 1650}
    ];
get_demon_attr(3, 67) ->
    [
        {hp_max, 6700}
        ,{mp_max, 3350}
        ,{dmg, 670}
        ,{dmg_magic, 670}
        ,{defence, 3350}
        ,{critrate, 134}
        ,{tenacity, 134}
        ,{resist_water, 1675}
    ];
get_demon_attr(3, 68) ->
    [
        {hp_max, 6800}
        ,{mp_max, 3400}
        ,{dmg, 680}
        ,{dmg_magic, 680}
        ,{defence, 3400}
        ,{critrate, 136}
        ,{tenacity, 136}
        ,{resist_water, 1700}
    ];
get_demon_attr(3, 69) ->
    [
        {hp_max, 6900}
        ,{mp_max, 3450}
        ,{dmg, 690}
        ,{dmg_magic, 690}
        ,{defence, 3450}
        ,{critrate, 138}
        ,{tenacity, 138}
        ,{resist_water, 1725}
    ];
get_demon_attr(3, 70) ->
    [
        {hp_max, 7000}
        ,{mp_max, 3500}
        ,{dmg, 700}
        ,{dmg_magic, 700}
        ,{defence, 3500}
        ,{critrate, 140}
        ,{tenacity, 140}
        ,{resist_water, 1750}
    ];
get_demon_attr(3, 71) ->
    [
        {hp_max, 7100}
        ,{mp_max, 3550}
        ,{dmg, 710}
        ,{dmg_magic, 710}
        ,{defence, 3550}
        ,{critrate, 142}
        ,{tenacity, 142}
        ,{resist_water, 1775}
    ];
get_demon_attr(3, 72) ->
    [
        {hp_max, 7200}
        ,{mp_max, 3600}
        ,{dmg, 720}
        ,{dmg_magic, 720}
        ,{defence, 3600}
        ,{critrate, 144}
        ,{tenacity, 144}
        ,{resist_water, 1800}
    ];
get_demon_attr(3, 73) ->
    [
        {hp_max, 7300}
        ,{mp_max, 3650}
        ,{dmg, 730}
        ,{dmg_magic, 730}
        ,{defence, 3650}
        ,{critrate, 146}
        ,{tenacity, 146}
        ,{resist_water, 1825}
    ];
get_demon_attr(3, 74) ->
    [
        {hp_max, 7400}
        ,{mp_max, 3700}
        ,{dmg, 740}
        ,{dmg_magic, 740}
        ,{defence, 3700}
        ,{critrate, 148}
        ,{tenacity, 148}
        ,{resist_water, 1850}
    ];
get_demon_attr(3, 75) ->
    [
        {hp_max, 7500}
        ,{mp_max, 3750}
        ,{dmg, 750}
        ,{dmg_magic, 750}
        ,{defence, 3750}
        ,{critrate, 150}
        ,{tenacity, 150}
        ,{resist_water, 1875}
    ];
get_demon_attr(3, 76) ->
    [
        {hp_max, 7600}
        ,{mp_max, 3800}
        ,{dmg, 760}
        ,{dmg_magic, 760}
        ,{defence, 3800}
        ,{critrate, 152}
        ,{tenacity, 152}
        ,{resist_water, 1900}
    ];
get_demon_attr(3, 77) ->
    [
        {hp_max, 7700}
        ,{mp_max, 3850}
        ,{dmg, 770}
        ,{dmg_magic, 770}
        ,{defence, 3850}
        ,{critrate, 154}
        ,{tenacity, 154}
        ,{resist_water, 1925}
    ];
get_demon_attr(3, 78) ->
    [
        {hp_max, 7800}
        ,{mp_max, 3900}
        ,{dmg, 780}
        ,{dmg_magic, 780}
        ,{defence, 3900}
        ,{critrate, 156}
        ,{tenacity, 156}
        ,{resist_water, 1950}
    ];
get_demon_attr(3, 79) ->
    [
        {hp_max, 7900}
        ,{mp_max, 3950}
        ,{dmg, 790}
        ,{dmg_magic, 790}
        ,{defence, 3950}
        ,{critrate, 158}
        ,{tenacity, 158}
        ,{resist_water, 1975}
    ];
get_demon_attr(3, 80) ->
    [
        {hp_max, 8000}
        ,{mp_max, 4000}
        ,{dmg, 800}
        ,{dmg_magic, 800}
        ,{defence, 4000}
        ,{critrate, 160}
        ,{tenacity, 160}
        ,{resist_water, 2000}
    ];
get_demon_attr(3, 81) ->
    [
        {hp_max, 8100}
        ,{mp_max, 4050}
        ,{dmg, 810}
        ,{dmg_magic, 810}
        ,{defence, 4050}
        ,{critrate, 162}
        ,{tenacity, 162}
        ,{resist_water, 2025}
    ];
get_demon_attr(3, 82) ->
    [
        {hp_max, 8200}
        ,{mp_max, 4100}
        ,{dmg, 820}
        ,{dmg_magic, 820}
        ,{defence, 4100}
        ,{critrate, 164}
        ,{tenacity, 164}
        ,{resist_water, 2050}
    ];
get_demon_attr(3, 83) ->
    [
        {hp_max, 8300}
        ,{mp_max, 4150}
        ,{dmg, 830}
        ,{dmg_magic, 830}
        ,{defence, 4150}
        ,{critrate, 166}
        ,{tenacity, 166}
        ,{resist_water, 2075}
    ];
get_demon_attr(3, 84) ->
    [
        {hp_max, 8400}
        ,{mp_max, 4200}
        ,{dmg, 840}
        ,{dmg_magic, 840}
        ,{defence, 4200}
        ,{critrate, 168}
        ,{tenacity, 168}
        ,{resist_water, 2100}
    ];
get_demon_attr(3, 85) ->
    [
        {hp_max, 8500}
        ,{mp_max, 4250}
        ,{dmg, 850}
        ,{dmg_magic, 850}
        ,{defence, 4250}
        ,{critrate, 170}
        ,{tenacity, 170}
        ,{resist_water, 2125}
    ];
get_demon_attr(3, 86) ->
    [
        {hp_max, 8600}
        ,{mp_max, 4300}
        ,{dmg, 860}
        ,{dmg_magic, 860}
        ,{defence, 4300}
        ,{critrate, 172}
        ,{tenacity, 172}
        ,{resist_water, 2150}
    ];
get_demon_attr(3, 87) ->
    [
        {hp_max, 8700}
        ,{mp_max, 4350}
        ,{dmg, 870}
        ,{dmg_magic, 870}
        ,{defence, 4350}
        ,{critrate, 174}
        ,{tenacity, 174}
        ,{resist_water, 2175}
    ];
get_demon_attr(3, 88) ->
    [
        {hp_max, 8800}
        ,{mp_max, 4400}
        ,{dmg, 880}
        ,{dmg_magic, 880}
        ,{defence, 4400}
        ,{critrate, 176}
        ,{tenacity, 176}
        ,{resist_water, 2200}
    ];
get_demon_attr(3, 89) ->
    [
        {hp_max, 8900}
        ,{mp_max, 4450}
        ,{dmg, 890}
        ,{dmg_magic, 890}
        ,{defence, 4450}
        ,{critrate, 178}
        ,{tenacity, 178}
        ,{resist_water, 2225}
    ];
get_demon_attr(3, 90) ->
    [
        {hp_max, 9000}
        ,{mp_max, 4500}
        ,{dmg, 900}
        ,{dmg_magic, 900}
        ,{defence, 4500}
        ,{critrate, 180}
        ,{tenacity, 180}
        ,{resist_water, 2250}
    ];
get_demon_attr(3, 91) ->
    [
        {hp_max, 9100}
        ,{mp_max, 4550}
        ,{dmg, 910}
        ,{dmg_magic, 910}
        ,{defence, 4550}
        ,{critrate, 182}
        ,{tenacity, 182}
        ,{resist_water, 2275}
    ];
get_demon_attr(3, 92) ->
    [
        {hp_max, 9200}
        ,{mp_max, 4600}
        ,{dmg, 920}
        ,{dmg_magic, 920}
        ,{defence, 4600}
        ,{critrate, 184}
        ,{tenacity, 184}
        ,{resist_water, 2300}
    ];
get_demon_attr(3, 93) ->
    [
        {hp_max, 9300}
        ,{mp_max, 4650}
        ,{dmg, 930}
        ,{dmg_magic, 930}
        ,{defence, 4650}
        ,{critrate, 186}
        ,{tenacity, 186}
        ,{resist_water, 2325}
    ];
get_demon_attr(3, 94) ->
    [
        {hp_max, 9400}
        ,{mp_max, 4700}
        ,{dmg, 940}
        ,{dmg_magic, 940}
        ,{defence, 4700}
        ,{critrate, 188}
        ,{tenacity, 188}
        ,{resist_water, 2350}
    ];
get_demon_attr(3, 95) ->
    [
        {hp_max, 9500}
        ,{mp_max, 4750}
        ,{dmg, 950}
        ,{dmg_magic, 950}
        ,{defence, 4750}
        ,{critrate, 190}
        ,{tenacity, 190}
        ,{resist_water, 2375}
    ];
get_demon_attr(3, 96) ->
    [
        {hp_max, 9600}
        ,{mp_max, 4800}
        ,{dmg, 960}
        ,{dmg_magic, 960}
        ,{defence, 4800}
        ,{critrate, 192}
        ,{tenacity, 192}
        ,{resist_water, 2400}
    ];
get_demon_attr(3, 97) ->
    [
        {hp_max, 9700}
        ,{mp_max, 4850}
        ,{dmg, 970}
        ,{dmg_magic, 970}
        ,{defence, 4850}
        ,{critrate, 194}
        ,{tenacity, 194}
        ,{resist_water, 2425}
    ];
get_demon_attr(3, 98) ->
    [
        {hp_max, 9800}
        ,{mp_max, 4900}
        ,{dmg, 980}
        ,{dmg_magic, 980}
        ,{defence, 4900}
        ,{critrate, 196}
        ,{tenacity, 196}
        ,{resist_water, 2450}
    ];
get_demon_attr(3, 99) ->
    [
        {hp_max, 9900}
        ,{mp_max, 4950}
        ,{dmg, 990}
        ,{dmg_magic, 990}
        ,{defence, 4950}
        ,{critrate, 198}
        ,{tenacity, 198}
        ,{resist_water, 2475}
    ];
get_demon_attr(3, 100) ->
    [
        {hp_max, 10000}
        ,{mp_max, 5000}
        ,{dmg, 1000}
        ,{dmg_magic, 1000}
        ,{defence, 5000}
        ,{critrate, 200}
        ,{tenacity, 200}
        ,{resist_water, 2500}
    ];
get_demon_attr(4, 1) ->
    [
        {hp_max, 100}
        ,{mp_max, 50}
        ,{dmg, 10}
        ,{dmg_magic, 10}
        ,{defence, 50}
        ,{critrate, 2}
        ,{tenacity, 2}
        ,{resist_fire, 25}
    ];
get_demon_attr(4, 2) ->
    [
        {hp_max, 200}
        ,{mp_max, 100}
        ,{dmg, 20}
        ,{dmg_magic, 20}
        ,{defence, 100}
        ,{critrate, 4}
        ,{tenacity, 4}
        ,{resist_fire, 50}
    ];
get_demon_attr(4, 3) ->
    [
        {hp_max, 300}
        ,{mp_max, 150}
        ,{dmg, 30}
        ,{dmg_magic, 30}
        ,{defence, 150}
        ,{critrate, 6}
        ,{tenacity, 6}
        ,{resist_fire, 75}
    ];
get_demon_attr(4, 4) ->
    [
        {hp_max, 400}
        ,{mp_max, 200}
        ,{dmg, 40}
        ,{dmg_magic, 40}
        ,{defence, 200}
        ,{critrate, 8}
        ,{tenacity, 8}
        ,{resist_fire, 100}
    ];
get_demon_attr(4, 5) ->
    [
        {hp_max, 500}
        ,{mp_max, 250}
        ,{dmg, 50}
        ,{dmg_magic, 50}
        ,{defence, 250}
        ,{critrate, 10}
        ,{tenacity, 10}
        ,{resist_fire, 125}
    ];
get_demon_attr(4, 6) ->
    [
        {hp_max, 600}
        ,{mp_max, 300}
        ,{dmg, 60}
        ,{dmg_magic, 60}
        ,{defence, 300}
        ,{critrate, 12}
        ,{tenacity, 12}
        ,{resist_fire, 150}
    ];
get_demon_attr(4, 7) ->
    [
        {hp_max, 700}
        ,{mp_max, 350}
        ,{dmg, 70}
        ,{dmg_magic, 70}
        ,{defence, 350}
        ,{critrate, 14}
        ,{tenacity, 14}
        ,{resist_fire, 175}
    ];
get_demon_attr(4, 8) ->
    [
        {hp_max, 800}
        ,{mp_max, 400}
        ,{dmg, 80}
        ,{dmg_magic, 80}
        ,{defence, 400}
        ,{critrate, 16}
        ,{tenacity, 16}
        ,{resist_fire, 200}
    ];
get_demon_attr(4, 9) ->
    [
        {hp_max, 900}
        ,{mp_max, 450}
        ,{dmg, 90}
        ,{dmg_magic, 90}
        ,{defence, 450}
        ,{critrate, 18}
        ,{tenacity, 18}
        ,{resist_fire, 225}
    ];
get_demon_attr(4, 10) ->
    [
        {hp_max, 1000}
        ,{mp_max, 500}
        ,{dmg, 100}
        ,{dmg_magic, 100}
        ,{defence, 500}
        ,{critrate, 20}
        ,{tenacity, 20}
        ,{resist_fire, 250}
    ];
get_demon_attr(4, 11) ->
    [
        {hp_max, 1100}
        ,{mp_max, 550}
        ,{dmg, 110}
        ,{dmg_magic, 110}
        ,{defence, 550}
        ,{critrate, 22}
        ,{tenacity, 22}
        ,{resist_fire, 275}
    ];
get_demon_attr(4, 12) ->
    [
        {hp_max, 1200}
        ,{mp_max, 600}
        ,{dmg, 120}
        ,{dmg_magic, 120}
        ,{defence, 600}
        ,{critrate, 24}
        ,{tenacity, 24}
        ,{resist_fire, 300}
    ];
get_demon_attr(4, 13) ->
    [
        {hp_max, 1300}
        ,{mp_max, 650}
        ,{dmg, 130}
        ,{dmg_magic, 130}
        ,{defence, 650}
        ,{critrate, 26}
        ,{tenacity, 26}
        ,{resist_fire, 325}
    ];
get_demon_attr(4, 14) ->
    [
        {hp_max, 1400}
        ,{mp_max, 700}
        ,{dmg, 140}
        ,{dmg_magic, 140}
        ,{defence, 700}
        ,{critrate, 28}
        ,{tenacity, 28}
        ,{resist_fire, 350}
    ];
get_demon_attr(4, 15) ->
    [
        {hp_max, 1500}
        ,{mp_max, 750}
        ,{dmg, 150}
        ,{dmg_magic, 150}
        ,{defence, 750}
        ,{critrate, 30}
        ,{tenacity, 30}
        ,{resist_fire, 375}
    ];
get_demon_attr(4, 16) ->
    [
        {hp_max, 1600}
        ,{mp_max, 800}
        ,{dmg, 160}
        ,{dmg_magic, 160}
        ,{defence, 800}
        ,{critrate, 32}
        ,{tenacity, 32}
        ,{resist_fire, 400}
    ];
get_demon_attr(4, 17) ->
    [
        {hp_max, 1700}
        ,{mp_max, 850}
        ,{dmg, 170}
        ,{dmg_magic, 170}
        ,{defence, 850}
        ,{critrate, 34}
        ,{tenacity, 34}
        ,{resist_fire, 425}
    ];
get_demon_attr(4, 18) ->
    [
        {hp_max, 1800}
        ,{mp_max, 900}
        ,{dmg, 180}
        ,{dmg_magic, 180}
        ,{defence, 900}
        ,{critrate, 36}
        ,{tenacity, 36}
        ,{resist_fire, 450}
    ];
get_demon_attr(4, 19) ->
    [
        {hp_max, 1900}
        ,{mp_max, 950}
        ,{dmg, 190}
        ,{dmg_magic, 190}
        ,{defence, 950}
        ,{critrate, 38}
        ,{tenacity, 38}
        ,{resist_fire, 475}
    ];
get_demon_attr(4, 20) ->
    [
        {hp_max, 2000}
        ,{mp_max, 1000}
        ,{dmg, 200}
        ,{dmg_magic, 200}
        ,{defence, 1000}
        ,{critrate, 40}
        ,{tenacity, 40}
        ,{resist_fire, 500}
    ];
get_demon_attr(4, 21) ->
    [
        {hp_max, 2100}
        ,{mp_max, 1050}
        ,{dmg, 210}
        ,{dmg_magic, 210}
        ,{defence, 1050}
        ,{critrate, 42}
        ,{tenacity, 42}
        ,{resist_fire, 525}
    ];
get_demon_attr(4, 22) ->
    [
        {hp_max, 2200}
        ,{mp_max, 1100}
        ,{dmg, 220}
        ,{dmg_magic, 220}
        ,{defence, 1100}
        ,{critrate, 44}
        ,{tenacity, 44}
        ,{resist_fire, 550}
    ];
get_demon_attr(4, 23) ->
    [
        {hp_max, 2300}
        ,{mp_max, 1150}
        ,{dmg, 230}
        ,{dmg_magic, 230}
        ,{defence, 1150}
        ,{critrate, 46}
        ,{tenacity, 46}
        ,{resist_fire, 575}
    ];
get_demon_attr(4, 24) ->
    [
        {hp_max, 2400}
        ,{mp_max, 1200}
        ,{dmg, 240}
        ,{dmg_magic, 240}
        ,{defence, 1200}
        ,{critrate, 48}
        ,{tenacity, 48}
        ,{resist_fire, 600}
    ];
get_demon_attr(4, 25) ->
    [
        {hp_max, 2500}
        ,{mp_max, 1250}
        ,{dmg, 250}
        ,{dmg_magic, 250}
        ,{defence, 1250}
        ,{critrate, 50}
        ,{tenacity, 50}
        ,{resist_fire, 625}
    ];
get_demon_attr(4, 26) ->
    [
        {hp_max, 2600}
        ,{mp_max, 1300}
        ,{dmg, 260}
        ,{dmg_magic, 260}
        ,{defence, 1300}
        ,{critrate, 52}
        ,{tenacity, 52}
        ,{resist_fire, 650}
    ];
get_demon_attr(4, 27) ->
    [
        {hp_max, 2700}
        ,{mp_max, 1350}
        ,{dmg, 270}
        ,{dmg_magic, 270}
        ,{defence, 1350}
        ,{critrate, 54}
        ,{tenacity, 54}
        ,{resist_fire, 675}
    ];
get_demon_attr(4, 28) ->
    [
        {hp_max, 2800}
        ,{mp_max, 1400}
        ,{dmg, 280}
        ,{dmg_magic, 280}
        ,{defence, 1400}
        ,{critrate, 56}
        ,{tenacity, 56}
        ,{resist_fire, 700}
    ];
get_demon_attr(4, 29) ->
    [
        {hp_max, 2900}
        ,{mp_max, 1450}
        ,{dmg, 290}
        ,{dmg_magic, 290}
        ,{defence, 1450}
        ,{critrate, 58}
        ,{tenacity, 58}
        ,{resist_fire, 725}
    ];
get_demon_attr(4, 30) ->
    [
        {hp_max, 3000}
        ,{mp_max, 1500}
        ,{dmg, 300}
        ,{dmg_magic, 300}
        ,{defence, 1500}
        ,{critrate, 60}
        ,{tenacity, 60}
        ,{resist_fire, 750}
    ];
get_demon_attr(4, 31) ->
    [
        {hp_max, 3100}
        ,{mp_max, 1550}
        ,{dmg, 310}
        ,{dmg_magic, 310}
        ,{defence, 1550}
        ,{critrate, 62}
        ,{tenacity, 62}
        ,{resist_fire, 775}
    ];
get_demon_attr(4, 32) ->
    [
        {hp_max, 3200}
        ,{mp_max, 1600}
        ,{dmg, 320}
        ,{dmg_magic, 320}
        ,{defence, 1600}
        ,{critrate, 64}
        ,{tenacity, 64}
        ,{resist_fire, 800}
    ];
get_demon_attr(4, 33) ->
    [
        {hp_max, 3300}
        ,{mp_max, 1650}
        ,{dmg, 330}
        ,{dmg_magic, 330}
        ,{defence, 1650}
        ,{critrate, 66}
        ,{tenacity, 66}
        ,{resist_fire, 825}
    ];
get_demon_attr(4, 34) ->
    [
        {hp_max, 3400}
        ,{mp_max, 1700}
        ,{dmg, 340}
        ,{dmg_magic, 340}
        ,{defence, 1700}
        ,{critrate, 68}
        ,{tenacity, 68}
        ,{resist_fire, 850}
    ];
get_demon_attr(4, 35) ->
    [
        {hp_max, 3500}
        ,{mp_max, 1750}
        ,{dmg, 350}
        ,{dmg_magic, 350}
        ,{defence, 1750}
        ,{critrate, 70}
        ,{tenacity, 70}
        ,{resist_fire, 875}
    ];
get_demon_attr(4, 36) ->
    [
        {hp_max, 3600}
        ,{mp_max, 1800}
        ,{dmg, 360}
        ,{dmg_magic, 360}
        ,{defence, 1800}
        ,{critrate, 72}
        ,{tenacity, 72}
        ,{resist_fire, 900}
    ];
get_demon_attr(4, 37) ->
    [
        {hp_max, 3700}
        ,{mp_max, 1850}
        ,{dmg, 370}
        ,{dmg_magic, 370}
        ,{defence, 1850}
        ,{critrate, 74}
        ,{tenacity, 74}
        ,{resist_fire, 925}
    ];
get_demon_attr(4, 38) ->
    [
        {hp_max, 3800}
        ,{mp_max, 1900}
        ,{dmg, 380}
        ,{dmg_magic, 380}
        ,{defence, 1900}
        ,{critrate, 76}
        ,{tenacity, 76}
        ,{resist_fire, 950}
    ];
get_demon_attr(4, 39) ->
    [
        {hp_max, 3900}
        ,{mp_max, 1950}
        ,{dmg, 390}
        ,{dmg_magic, 390}
        ,{defence, 1950}
        ,{critrate, 78}
        ,{tenacity, 78}
        ,{resist_fire, 975}
    ];
get_demon_attr(4, 40) ->
    [
        {hp_max, 4000}
        ,{mp_max, 2000}
        ,{dmg, 400}
        ,{dmg_magic, 400}
        ,{defence, 2000}
        ,{critrate, 80}
        ,{tenacity, 80}
        ,{resist_fire, 1000}
    ];
get_demon_attr(4, 41) ->
    [
        {hp_max, 4100}
        ,{mp_max, 2050}
        ,{dmg, 410}
        ,{dmg_magic, 410}
        ,{defence, 2050}
        ,{critrate, 82}
        ,{tenacity, 82}
        ,{resist_fire, 1025}
    ];
get_demon_attr(4, 42) ->
    [
        {hp_max, 4200}
        ,{mp_max, 2100}
        ,{dmg, 420}
        ,{dmg_magic, 420}
        ,{defence, 2100}
        ,{critrate, 84}
        ,{tenacity, 84}
        ,{resist_fire, 1050}
    ];
get_demon_attr(4, 43) ->
    [
        {hp_max, 4300}
        ,{mp_max, 2150}
        ,{dmg, 430}
        ,{dmg_magic, 430}
        ,{defence, 2150}
        ,{critrate, 86}
        ,{tenacity, 86}
        ,{resist_fire, 1075}
    ];
get_demon_attr(4, 44) ->
    [
        {hp_max, 4400}
        ,{mp_max, 2200}
        ,{dmg, 440}
        ,{dmg_magic, 440}
        ,{defence, 2200}
        ,{critrate, 88}
        ,{tenacity, 88}
        ,{resist_fire, 1100}
    ];
get_demon_attr(4, 45) ->
    [
        {hp_max, 4500}
        ,{mp_max, 2250}
        ,{dmg, 450}
        ,{dmg_magic, 450}
        ,{defence, 2250}
        ,{critrate, 90}
        ,{tenacity, 90}
        ,{resist_fire, 1125}
    ];
get_demon_attr(4, 46) ->
    [
        {hp_max, 4600}
        ,{mp_max, 2300}
        ,{dmg, 460}
        ,{dmg_magic, 460}
        ,{defence, 2300}
        ,{critrate, 92}
        ,{tenacity, 92}
        ,{resist_fire, 1150}
    ];
get_demon_attr(4, 47) ->
    [
        {hp_max, 4700}
        ,{mp_max, 2350}
        ,{dmg, 470}
        ,{dmg_magic, 470}
        ,{defence, 2350}
        ,{critrate, 94}
        ,{tenacity, 94}
        ,{resist_fire, 1175}
    ];
get_demon_attr(4, 48) ->
    [
        {hp_max, 4800}
        ,{mp_max, 2400}
        ,{dmg, 480}
        ,{dmg_magic, 480}
        ,{defence, 2400}
        ,{critrate, 96}
        ,{tenacity, 96}
        ,{resist_fire, 1200}
    ];
get_demon_attr(4, 49) ->
    [
        {hp_max, 4900}
        ,{mp_max, 2450}
        ,{dmg, 490}
        ,{dmg_magic, 490}
        ,{defence, 2450}
        ,{critrate, 98}
        ,{tenacity, 98}
        ,{resist_fire, 1225}
    ];
get_demon_attr(4, 50) ->
    [
        {hp_max, 5000}
        ,{mp_max, 2500}
        ,{dmg, 500}
        ,{dmg_magic, 500}
        ,{defence, 2500}
        ,{critrate, 100}
        ,{tenacity, 100}
        ,{resist_fire, 1250}
    ];
get_demon_attr(4, 51) ->
    [
        {hp_max, 5100}
        ,{mp_max, 2550}
        ,{dmg, 510}
        ,{dmg_magic, 510}
        ,{defence, 2550}
        ,{critrate, 102}
        ,{tenacity, 102}
        ,{resist_fire, 1275}
    ];
get_demon_attr(4, 52) ->
    [
        {hp_max, 5200}
        ,{mp_max, 2600}
        ,{dmg, 520}
        ,{dmg_magic, 520}
        ,{defence, 2600}
        ,{critrate, 104}
        ,{tenacity, 104}
        ,{resist_fire, 1300}
    ];
get_demon_attr(4, 53) ->
    [
        {hp_max, 5300}
        ,{mp_max, 2650}
        ,{dmg, 530}
        ,{dmg_magic, 530}
        ,{defence, 2650}
        ,{critrate, 106}
        ,{tenacity, 106}
        ,{resist_fire, 1325}
    ];
get_demon_attr(4, 54) ->
    [
        {hp_max, 5400}
        ,{mp_max, 2700}
        ,{dmg, 540}
        ,{dmg_magic, 540}
        ,{defence, 2700}
        ,{critrate, 108}
        ,{tenacity, 108}
        ,{resist_fire, 1350}
    ];
get_demon_attr(4, 55) ->
    [
        {hp_max, 5500}
        ,{mp_max, 2750}
        ,{dmg, 550}
        ,{dmg_magic, 550}
        ,{defence, 2750}
        ,{critrate, 110}
        ,{tenacity, 110}
        ,{resist_fire, 1375}
    ];
get_demon_attr(4, 56) ->
    [
        {hp_max, 5600}
        ,{mp_max, 2800}
        ,{dmg, 560}
        ,{dmg_magic, 560}
        ,{defence, 2800}
        ,{critrate, 112}
        ,{tenacity, 112}
        ,{resist_fire, 1400}
    ];
get_demon_attr(4, 57) ->
    [
        {hp_max, 5700}
        ,{mp_max, 2850}
        ,{dmg, 570}
        ,{dmg_magic, 570}
        ,{defence, 2850}
        ,{critrate, 114}
        ,{tenacity, 114}
        ,{resist_fire, 1425}
    ];
get_demon_attr(4, 58) ->
    [
        {hp_max, 5800}
        ,{mp_max, 2900}
        ,{dmg, 580}
        ,{dmg_magic, 580}
        ,{defence, 2900}
        ,{critrate, 116}
        ,{tenacity, 116}
        ,{resist_fire, 1450}
    ];
get_demon_attr(4, 59) ->
    [
        {hp_max, 5900}
        ,{mp_max, 2950}
        ,{dmg, 590}
        ,{dmg_magic, 590}
        ,{defence, 2950}
        ,{critrate, 118}
        ,{tenacity, 118}
        ,{resist_fire, 1475}
    ];
get_demon_attr(4, 60) ->
    [
        {hp_max, 6000}
        ,{mp_max, 3000}
        ,{dmg, 600}
        ,{dmg_magic, 600}
        ,{defence, 3000}
        ,{critrate, 120}
        ,{tenacity, 120}
        ,{resist_fire, 1500}
    ];
get_demon_attr(4, 61) ->
    [
        {hp_max, 6100}
        ,{mp_max, 3050}
        ,{dmg, 610}
        ,{dmg_magic, 610}
        ,{defence, 3050}
        ,{critrate, 122}
        ,{tenacity, 122}
        ,{resist_fire, 1525}
    ];
get_demon_attr(4, 62) ->
    [
        {hp_max, 6200}
        ,{mp_max, 3100}
        ,{dmg, 620}
        ,{dmg_magic, 620}
        ,{defence, 3100}
        ,{critrate, 124}
        ,{tenacity, 124}
        ,{resist_fire, 1550}
    ];
get_demon_attr(4, 63) ->
    [
        {hp_max, 6300}
        ,{mp_max, 3150}
        ,{dmg, 630}
        ,{dmg_magic, 630}
        ,{defence, 3150}
        ,{critrate, 126}
        ,{tenacity, 126}
        ,{resist_fire, 1575}
    ];
get_demon_attr(4, 64) ->
    [
        {hp_max, 6400}
        ,{mp_max, 3200}
        ,{dmg, 640}
        ,{dmg_magic, 640}
        ,{defence, 3200}
        ,{critrate, 128}
        ,{tenacity, 128}
        ,{resist_fire, 1600}
    ];
get_demon_attr(4, 65) ->
    [
        {hp_max, 6500}
        ,{mp_max, 3250}
        ,{dmg, 650}
        ,{dmg_magic, 650}
        ,{defence, 3250}
        ,{critrate, 130}
        ,{tenacity, 130}
        ,{resist_fire, 1625}
    ];
get_demon_attr(4, 66) ->
    [
        {hp_max, 6600}
        ,{mp_max, 3300}
        ,{dmg, 660}
        ,{dmg_magic, 660}
        ,{defence, 3300}
        ,{critrate, 132}
        ,{tenacity, 132}
        ,{resist_fire, 1650}
    ];
get_demon_attr(4, 67) ->
    [
        {hp_max, 6700}
        ,{mp_max, 3350}
        ,{dmg, 670}
        ,{dmg_magic, 670}
        ,{defence, 3350}
        ,{critrate, 134}
        ,{tenacity, 134}
        ,{resist_fire, 1675}
    ];
get_demon_attr(4, 68) ->
    [
        {hp_max, 6800}
        ,{mp_max, 3400}
        ,{dmg, 680}
        ,{dmg_magic, 680}
        ,{defence, 3400}
        ,{critrate, 136}
        ,{tenacity, 136}
        ,{resist_fire, 1700}
    ];
get_demon_attr(4, 69) ->
    [
        {hp_max, 6900}
        ,{mp_max, 3450}
        ,{dmg, 690}
        ,{dmg_magic, 690}
        ,{defence, 3450}
        ,{critrate, 138}
        ,{tenacity, 138}
        ,{resist_fire, 1725}
    ];
get_demon_attr(4, 70) ->
    [
        {hp_max, 7000}
        ,{mp_max, 3500}
        ,{dmg, 700}
        ,{dmg_magic, 700}
        ,{defence, 3500}
        ,{critrate, 140}
        ,{tenacity, 140}
        ,{resist_fire, 1750}
    ];
get_demon_attr(4, 71) ->
    [
        {hp_max, 7100}
        ,{mp_max, 3550}
        ,{dmg, 710}
        ,{dmg_magic, 710}
        ,{defence, 3550}
        ,{critrate, 142}
        ,{tenacity, 142}
        ,{resist_fire, 1775}
    ];
get_demon_attr(4, 72) ->
    [
        {hp_max, 7200}
        ,{mp_max, 3600}
        ,{dmg, 720}
        ,{dmg_magic, 720}
        ,{defence, 3600}
        ,{critrate, 144}
        ,{tenacity, 144}
        ,{resist_fire, 1800}
    ];
get_demon_attr(4, 73) ->
    [
        {hp_max, 7300}
        ,{mp_max, 3650}
        ,{dmg, 730}
        ,{dmg_magic, 730}
        ,{defence, 3650}
        ,{critrate, 146}
        ,{tenacity, 146}
        ,{resist_fire, 1825}
    ];
get_demon_attr(4, 74) ->
    [
        {hp_max, 7400}
        ,{mp_max, 3700}
        ,{dmg, 740}
        ,{dmg_magic, 740}
        ,{defence, 3700}
        ,{critrate, 148}
        ,{tenacity, 148}
        ,{resist_fire, 1850}
    ];
get_demon_attr(4, 75) ->
    [
        {hp_max, 7500}
        ,{mp_max, 3750}
        ,{dmg, 750}
        ,{dmg_magic, 750}
        ,{defence, 3750}
        ,{critrate, 150}
        ,{tenacity, 150}
        ,{resist_fire, 1875}
    ];
get_demon_attr(4, 76) ->
    [
        {hp_max, 7600}
        ,{mp_max, 3800}
        ,{dmg, 760}
        ,{dmg_magic, 760}
        ,{defence, 3800}
        ,{critrate, 152}
        ,{tenacity, 152}
        ,{resist_fire, 1900}
    ];
get_demon_attr(4, 77) ->
    [
        {hp_max, 7700}
        ,{mp_max, 3850}
        ,{dmg, 770}
        ,{dmg_magic, 770}
        ,{defence, 3850}
        ,{critrate, 154}
        ,{tenacity, 154}
        ,{resist_fire, 1925}
    ];
get_demon_attr(4, 78) ->
    [
        {hp_max, 7800}
        ,{mp_max, 3900}
        ,{dmg, 780}
        ,{dmg_magic, 780}
        ,{defence, 3900}
        ,{critrate, 156}
        ,{tenacity, 156}
        ,{resist_fire, 1950}
    ];
get_demon_attr(4, 79) ->
    [
        {hp_max, 7900}
        ,{mp_max, 3950}
        ,{dmg, 790}
        ,{dmg_magic, 790}
        ,{defence, 3950}
        ,{critrate, 158}
        ,{tenacity, 158}
        ,{resist_fire, 1975}
    ];
get_demon_attr(4, 80) ->
    [
        {hp_max, 8000}
        ,{mp_max, 4000}
        ,{dmg, 800}
        ,{dmg_magic, 800}
        ,{defence, 4000}
        ,{critrate, 160}
        ,{tenacity, 160}
        ,{resist_fire, 2000}
    ];
get_demon_attr(4, 81) ->
    [
        {hp_max, 8100}
        ,{mp_max, 4050}
        ,{dmg, 810}
        ,{dmg_magic, 810}
        ,{defence, 4050}
        ,{critrate, 162}
        ,{tenacity, 162}
        ,{resist_fire, 2025}
    ];
get_demon_attr(4, 82) ->
    [
        {hp_max, 8200}
        ,{mp_max, 4100}
        ,{dmg, 820}
        ,{dmg_magic, 820}
        ,{defence, 4100}
        ,{critrate, 164}
        ,{tenacity, 164}
        ,{resist_fire, 2050}
    ];
get_demon_attr(4, 83) ->
    [
        {hp_max, 8300}
        ,{mp_max, 4150}
        ,{dmg, 830}
        ,{dmg_magic, 830}
        ,{defence, 4150}
        ,{critrate, 166}
        ,{tenacity, 166}
        ,{resist_fire, 2075}
    ];
get_demon_attr(4, 84) ->
    [
        {hp_max, 8400}
        ,{mp_max, 4200}
        ,{dmg, 840}
        ,{dmg_magic, 840}
        ,{defence, 4200}
        ,{critrate, 168}
        ,{tenacity, 168}
        ,{resist_fire, 2100}
    ];
get_demon_attr(4, 85) ->
    [
        {hp_max, 8500}
        ,{mp_max, 4250}
        ,{dmg, 850}
        ,{dmg_magic, 850}
        ,{defence, 4250}
        ,{critrate, 170}
        ,{tenacity, 170}
        ,{resist_fire, 2125}
    ];
get_demon_attr(4, 86) ->
    [
        {hp_max, 8600}
        ,{mp_max, 4300}
        ,{dmg, 860}
        ,{dmg_magic, 860}
        ,{defence, 4300}
        ,{critrate, 172}
        ,{tenacity, 172}
        ,{resist_fire, 2150}
    ];
get_demon_attr(4, 87) ->
    [
        {hp_max, 8700}
        ,{mp_max, 4350}
        ,{dmg, 870}
        ,{dmg_magic, 870}
        ,{defence, 4350}
        ,{critrate, 174}
        ,{tenacity, 174}
        ,{resist_fire, 2175}
    ];
get_demon_attr(4, 88) ->
    [
        {hp_max, 8800}
        ,{mp_max, 4400}
        ,{dmg, 880}
        ,{dmg_magic, 880}
        ,{defence, 4400}
        ,{critrate, 176}
        ,{tenacity, 176}
        ,{resist_fire, 2200}
    ];
get_demon_attr(4, 89) ->
    [
        {hp_max, 8900}
        ,{mp_max, 4450}
        ,{dmg, 890}
        ,{dmg_magic, 890}
        ,{defence, 4450}
        ,{critrate, 178}
        ,{tenacity, 178}
        ,{resist_fire, 2225}
    ];
get_demon_attr(4, 90) ->
    [
        {hp_max, 9000}
        ,{mp_max, 4500}
        ,{dmg, 900}
        ,{dmg_magic, 900}
        ,{defence, 4500}
        ,{critrate, 180}
        ,{tenacity, 180}
        ,{resist_fire, 2250}
    ];
get_demon_attr(4, 91) ->
    [
        {hp_max, 9100}
        ,{mp_max, 4550}
        ,{dmg, 910}
        ,{dmg_magic, 910}
        ,{defence, 4550}
        ,{critrate, 182}
        ,{tenacity, 182}
        ,{resist_fire, 2275}
    ];
get_demon_attr(4, 92) ->
    [
        {hp_max, 9200}
        ,{mp_max, 4600}
        ,{dmg, 920}
        ,{dmg_magic, 920}
        ,{defence, 4600}
        ,{critrate, 184}
        ,{tenacity, 184}
        ,{resist_fire, 2300}
    ];
get_demon_attr(4, 93) ->
    [
        {hp_max, 9300}
        ,{mp_max, 4650}
        ,{dmg, 930}
        ,{dmg_magic, 930}
        ,{defence, 4650}
        ,{critrate, 186}
        ,{tenacity, 186}
        ,{resist_fire, 2325}
    ];
get_demon_attr(4, 94) ->
    [
        {hp_max, 9400}
        ,{mp_max, 4700}
        ,{dmg, 940}
        ,{dmg_magic, 940}
        ,{defence, 4700}
        ,{critrate, 188}
        ,{tenacity, 188}
        ,{resist_fire, 2350}
    ];
get_demon_attr(4, 95) ->
    [
        {hp_max, 9500}
        ,{mp_max, 4750}
        ,{dmg, 950}
        ,{dmg_magic, 950}
        ,{defence, 4750}
        ,{critrate, 190}
        ,{tenacity, 190}
        ,{resist_fire, 2375}
    ];
get_demon_attr(4, 96) ->
    [
        {hp_max, 9600}
        ,{mp_max, 4800}
        ,{dmg, 960}
        ,{dmg_magic, 960}
        ,{defence, 4800}
        ,{critrate, 192}
        ,{tenacity, 192}
        ,{resist_fire, 2400}
    ];
get_demon_attr(4, 97) ->
    [
        {hp_max, 9700}
        ,{mp_max, 4850}
        ,{dmg, 970}
        ,{dmg_magic, 970}
        ,{defence, 4850}
        ,{critrate, 194}
        ,{tenacity, 194}
        ,{resist_fire, 2425}
    ];
get_demon_attr(4, 98) ->
    [
        {hp_max, 9800}
        ,{mp_max, 4900}
        ,{dmg, 980}
        ,{dmg_magic, 980}
        ,{defence, 4900}
        ,{critrate, 196}
        ,{tenacity, 196}
        ,{resist_fire, 2450}
    ];
get_demon_attr(4, 99) ->
    [
        {hp_max, 9900}
        ,{mp_max, 4950}
        ,{dmg, 990}
        ,{dmg_magic, 990}
        ,{defence, 4950}
        ,{critrate, 198}
        ,{tenacity, 198}
        ,{resist_fire, 2475}
    ];
get_demon_attr(4, 100) ->
    [
        {hp_max, 10000}
        ,{mp_max, 5000}
        ,{dmg, 1000}
        ,{dmg_magic, 1000}
        ,{defence, 5000}
        ,{critrate, 200}
        ,{tenacity, 200}
        ,{resist_fire, 2500}
    ];
get_demon_attr(5, 1) ->
    [
        {hp_max, 100}
        ,{mp_max, 50}
        ,{dmg, 10}
        ,{dmg_magic, 10}
        ,{defence, 50}
        ,{critrate, 2}
        ,{tenacity, 2}
        ,{resist_earth, 25}
    ];
get_demon_attr(5, 2) ->
    [
        {hp_max, 200}
        ,{mp_max, 100}
        ,{dmg, 20}
        ,{dmg_magic, 20}
        ,{defence, 100}
        ,{critrate, 4}
        ,{tenacity, 4}
        ,{resist_earth, 50}
    ];
get_demon_attr(5, 3) ->
    [
        {hp_max, 300}
        ,{mp_max, 150}
        ,{dmg, 30}
        ,{dmg_magic, 30}
        ,{defence, 150}
        ,{critrate, 6}
        ,{tenacity, 6}
        ,{resist_earth, 75}
    ];
get_demon_attr(5, 4) ->
    [
        {hp_max, 400}
        ,{mp_max, 200}
        ,{dmg, 40}
        ,{dmg_magic, 40}
        ,{defence, 200}
        ,{critrate, 8}
        ,{tenacity, 8}
        ,{resist_earth, 100}
    ];
get_demon_attr(5, 5) ->
    [
        {hp_max, 500}
        ,{mp_max, 250}
        ,{dmg, 50}
        ,{dmg_magic, 50}
        ,{defence, 250}
        ,{critrate, 10}
        ,{tenacity, 10}
        ,{resist_earth, 125}
    ];
get_demon_attr(5, 6) ->
    [
        {hp_max, 600}
        ,{mp_max, 300}
        ,{dmg, 60}
        ,{dmg_magic, 60}
        ,{defence, 300}
        ,{critrate, 12}
        ,{tenacity, 12}
        ,{resist_earth, 150}
    ];
get_demon_attr(5, 7) ->
    [
        {hp_max, 700}
        ,{mp_max, 350}
        ,{dmg, 70}
        ,{dmg_magic, 70}
        ,{defence, 350}
        ,{critrate, 14}
        ,{tenacity, 14}
        ,{resist_earth, 175}
    ];
get_demon_attr(5, 8) ->
    [
        {hp_max, 800}
        ,{mp_max, 400}
        ,{dmg, 80}
        ,{dmg_magic, 80}
        ,{defence, 400}
        ,{critrate, 16}
        ,{tenacity, 16}
        ,{resist_earth, 200}
    ];
get_demon_attr(5, 9) ->
    [
        {hp_max, 900}
        ,{mp_max, 450}
        ,{dmg, 90}
        ,{dmg_magic, 90}
        ,{defence, 450}
        ,{critrate, 18}
        ,{tenacity, 18}
        ,{resist_earth, 225}
    ];
get_demon_attr(5, 10) ->
    [
        {hp_max, 1000}
        ,{mp_max, 500}
        ,{dmg, 100}
        ,{dmg_magic, 100}
        ,{defence, 500}
        ,{critrate, 20}
        ,{tenacity, 20}
        ,{resist_earth, 250}
    ];
get_demon_attr(5, 11) ->
    [
        {hp_max, 1100}
        ,{mp_max, 550}
        ,{dmg, 110}
        ,{dmg_magic, 110}
        ,{defence, 550}
        ,{critrate, 22}
        ,{tenacity, 22}
        ,{resist_earth, 275}
    ];
get_demon_attr(5, 12) ->
    [
        {hp_max, 1200}
        ,{mp_max, 600}
        ,{dmg, 120}
        ,{dmg_magic, 120}
        ,{defence, 600}
        ,{critrate, 24}
        ,{tenacity, 24}
        ,{resist_earth, 300}
    ];
get_demon_attr(5, 13) ->
    [
        {hp_max, 1300}
        ,{mp_max, 650}
        ,{dmg, 130}
        ,{dmg_magic, 130}
        ,{defence, 650}
        ,{critrate, 26}
        ,{tenacity, 26}
        ,{resist_earth, 325}
    ];
get_demon_attr(5, 14) ->
    [
        {hp_max, 1400}
        ,{mp_max, 700}
        ,{dmg, 140}
        ,{dmg_magic, 140}
        ,{defence, 700}
        ,{critrate, 28}
        ,{tenacity, 28}
        ,{resist_earth, 350}
    ];
get_demon_attr(5, 15) ->
    [
        {hp_max, 1500}
        ,{mp_max, 750}
        ,{dmg, 150}
        ,{dmg_magic, 150}
        ,{defence, 750}
        ,{critrate, 30}
        ,{tenacity, 30}
        ,{resist_earth, 375}
    ];
get_demon_attr(5, 16) ->
    [
        {hp_max, 1600}
        ,{mp_max, 800}
        ,{dmg, 160}
        ,{dmg_magic, 160}
        ,{defence, 800}
        ,{critrate, 32}
        ,{tenacity, 32}
        ,{resist_earth, 400}
    ];
get_demon_attr(5, 17) ->
    [
        {hp_max, 1700}
        ,{mp_max, 850}
        ,{dmg, 170}
        ,{dmg_magic, 170}
        ,{defence, 850}
        ,{critrate, 34}
        ,{tenacity, 34}
        ,{resist_earth, 425}
    ];
get_demon_attr(5, 18) ->
    [
        {hp_max, 1800}
        ,{mp_max, 900}
        ,{dmg, 180}
        ,{dmg_magic, 180}
        ,{defence, 900}
        ,{critrate, 36}
        ,{tenacity, 36}
        ,{resist_earth, 450}
    ];
get_demon_attr(5, 19) ->
    [
        {hp_max, 1900}
        ,{mp_max, 950}
        ,{dmg, 190}
        ,{dmg_magic, 190}
        ,{defence, 950}
        ,{critrate, 38}
        ,{tenacity, 38}
        ,{resist_earth, 475}
    ];
get_demon_attr(5, 20) ->
    [
        {hp_max, 2000}
        ,{mp_max, 1000}
        ,{dmg, 200}
        ,{dmg_magic, 200}
        ,{defence, 1000}
        ,{critrate, 40}
        ,{tenacity, 40}
        ,{resist_earth, 500}
    ];
get_demon_attr(5, 21) ->
    [
        {hp_max, 2100}
        ,{mp_max, 1050}
        ,{dmg, 210}
        ,{dmg_magic, 210}
        ,{defence, 1050}
        ,{critrate, 42}
        ,{tenacity, 42}
        ,{resist_earth, 525}
    ];
get_demon_attr(5, 22) ->
    [
        {hp_max, 2200}
        ,{mp_max, 1100}
        ,{dmg, 220}
        ,{dmg_magic, 220}
        ,{defence, 1100}
        ,{critrate, 44}
        ,{tenacity, 44}
        ,{resist_earth, 550}
    ];
get_demon_attr(5, 23) ->
    [
        {hp_max, 2300}
        ,{mp_max, 1150}
        ,{dmg, 230}
        ,{dmg_magic, 230}
        ,{defence, 1150}
        ,{critrate, 46}
        ,{tenacity, 46}
        ,{resist_earth, 575}
    ];
get_demon_attr(5, 24) ->
    [
        {hp_max, 2400}
        ,{mp_max, 1200}
        ,{dmg, 240}
        ,{dmg_magic, 240}
        ,{defence, 1200}
        ,{critrate, 48}
        ,{tenacity, 48}
        ,{resist_earth, 600}
    ];
get_demon_attr(5, 25) ->
    [
        {hp_max, 2500}
        ,{mp_max, 1250}
        ,{dmg, 250}
        ,{dmg_magic, 250}
        ,{defence, 1250}
        ,{critrate, 50}
        ,{tenacity, 50}
        ,{resist_earth, 625}
    ];
get_demon_attr(5, 26) ->
    [
        {hp_max, 2600}
        ,{mp_max, 1300}
        ,{dmg, 260}
        ,{dmg_magic, 260}
        ,{defence, 1300}
        ,{critrate, 52}
        ,{tenacity, 52}
        ,{resist_earth, 650}
    ];
get_demon_attr(5, 27) ->
    [
        {hp_max, 2700}
        ,{mp_max, 1350}
        ,{dmg, 270}
        ,{dmg_magic, 270}
        ,{defence, 1350}
        ,{critrate, 54}
        ,{tenacity, 54}
        ,{resist_earth, 675}
    ];
get_demon_attr(5, 28) ->
    [
        {hp_max, 2800}
        ,{mp_max, 1400}
        ,{dmg, 280}
        ,{dmg_magic, 280}
        ,{defence, 1400}
        ,{critrate, 56}
        ,{tenacity, 56}
        ,{resist_earth, 700}
    ];
get_demon_attr(5, 29) ->
    [
        {hp_max, 2900}
        ,{mp_max, 1450}
        ,{dmg, 290}
        ,{dmg_magic, 290}
        ,{defence, 1450}
        ,{critrate, 58}
        ,{tenacity, 58}
        ,{resist_earth, 725}
    ];
get_demon_attr(5, 30) ->
    [
        {hp_max, 3000}
        ,{mp_max, 1500}
        ,{dmg, 300}
        ,{dmg_magic, 300}
        ,{defence, 1500}
        ,{critrate, 60}
        ,{tenacity, 60}
        ,{resist_earth, 750}
    ];
get_demon_attr(5, 31) ->
    [
        {hp_max, 3100}
        ,{mp_max, 1550}
        ,{dmg, 310}
        ,{dmg_magic, 310}
        ,{defence, 1550}
        ,{critrate, 62}
        ,{tenacity, 62}
        ,{resist_earth, 775}
    ];
get_demon_attr(5, 32) ->
    [
        {hp_max, 3200}
        ,{mp_max, 1600}
        ,{dmg, 320}
        ,{dmg_magic, 320}
        ,{defence, 1600}
        ,{critrate, 64}
        ,{tenacity, 64}
        ,{resist_earth, 800}
    ];
get_demon_attr(5, 33) ->
    [
        {hp_max, 3300}
        ,{mp_max, 1650}
        ,{dmg, 330}
        ,{dmg_magic, 330}
        ,{defence, 1650}
        ,{critrate, 66}
        ,{tenacity, 66}
        ,{resist_earth, 825}
    ];
get_demon_attr(5, 34) ->
    [
        {hp_max, 3400}
        ,{mp_max, 1700}
        ,{dmg, 340}
        ,{dmg_magic, 340}
        ,{defence, 1700}
        ,{critrate, 68}
        ,{tenacity, 68}
        ,{resist_earth, 850}
    ];
get_demon_attr(5, 35) ->
    [
        {hp_max, 3500}
        ,{mp_max, 1750}
        ,{dmg, 350}
        ,{dmg_magic, 350}
        ,{defence, 1750}
        ,{critrate, 70}
        ,{tenacity, 70}
        ,{resist_earth, 875}
    ];
get_demon_attr(5, 36) ->
    [
        {hp_max, 3600}
        ,{mp_max, 1800}
        ,{dmg, 360}
        ,{dmg_magic, 360}
        ,{defence, 1800}
        ,{critrate, 72}
        ,{tenacity, 72}
        ,{resist_earth, 900}
    ];
get_demon_attr(5, 37) ->
    [
        {hp_max, 3700}
        ,{mp_max, 1850}
        ,{dmg, 370}
        ,{dmg_magic, 370}
        ,{defence, 1850}
        ,{critrate, 74}
        ,{tenacity, 74}
        ,{resist_earth, 925}
    ];
get_demon_attr(5, 38) ->
    [
        {hp_max, 3800}
        ,{mp_max, 1900}
        ,{dmg, 380}
        ,{dmg_magic, 380}
        ,{defence, 1900}
        ,{critrate, 76}
        ,{tenacity, 76}
        ,{resist_earth, 950}
    ];
get_demon_attr(5, 39) ->
    [
        {hp_max, 3900}
        ,{mp_max, 1950}
        ,{dmg, 390}
        ,{dmg_magic, 390}
        ,{defence, 1950}
        ,{critrate, 78}
        ,{tenacity, 78}
        ,{resist_earth, 975}
    ];
get_demon_attr(5, 40) ->
    [
        {hp_max, 4000}
        ,{mp_max, 2000}
        ,{dmg, 400}
        ,{dmg_magic, 400}
        ,{defence, 2000}
        ,{critrate, 80}
        ,{tenacity, 80}
        ,{resist_earth, 1000}
    ];
get_demon_attr(5, 41) ->
    [
        {hp_max, 4100}
        ,{mp_max, 2050}
        ,{dmg, 410}
        ,{dmg_magic, 410}
        ,{defence, 2050}
        ,{critrate, 82}
        ,{tenacity, 82}
        ,{resist_earth, 1025}
    ];
get_demon_attr(5, 42) ->
    [
        {hp_max, 4200}
        ,{mp_max, 2100}
        ,{dmg, 420}
        ,{dmg_magic, 420}
        ,{defence, 2100}
        ,{critrate, 84}
        ,{tenacity, 84}
        ,{resist_earth, 1050}
    ];
get_demon_attr(5, 43) ->
    [
        {hp_max, 4300}
        ,{mp_max, 2150}
        ,{dmg, 430}
        ,{dmg_magic, 430}
        ,{defence, 2150}
        ,{critrate, 86}
        ,{tenacity, 86}
        ,{resist_earth, 1075}
    ];
get_demon_attr(5, 44) ->
    [
        {hp_max, 4400}
        ,{mp_max, 2200}
        ,{dmg, 440}
        ,{dmg_magic, 440}
        ,{defence, 2200}
        ,{critrate, 88}
        ,{tenacity, 88}
        ,{resist_earth, 1100}
    ];
get_demon_attr(5, 45) ->
    [
        {hp_max, 4500}
        ,{mp_max, 2250}
        ,{dmg, 450}
        ,{dmg_magic, 450}
        ,{defence, 2250}
        ,{critrate, 90}
        ,{tenacity, 90}
        ,{resist_earth, 1125}
    ];
get_demon_attr(5, 46) ->
    [
        {hp_max, 4600}
        ,{mp_max, 2300}
        ,{dmg, 460}
        ,{dmg_magic, 460}
        ,{defence, 2300}
        ,{critrate, 92}
        ,{tenacity, 92}
        ,{resist_earth, 1150}
    ];
get_demon_attr(5, 47) ->
    [
        {hp_max, 4700}
        ,{mp_max, 2350}
        ,{dmg, 470}
        ,{dmg_magic, 470}
        ,{defence, 2350}
        ,{critrate, 94}
        ,{tenacity, 94}
        ,{resist_earth, 1175}
    ];
get_demon_attr(5, 48) ->
    [
        {hp_max, 4800}
        ,{mp_max, 2400}
        ,{dmg, 480}
        ,{dmg_magic, 480}
        ,{defence, 2400}
        ,{critrate, 96}
        ,{tenacity, 96}
        ,{resist_earth, 1200}
    ];
get_demon_attr(5, 49) ->
    [
        {hp_max, 4900}
        ,{mp_max, 2450}
        ,{dmg, 490}
        ,{dmg_magic, 490}
        ,{defence, 2450}
        ,{critrate, 98}
        ,{tenacity, 98}
        ,{resist_earth, 1225}
    ];
get_demon_attr(5, 50) ->
    [
        {hp_max, 5000}
        ,{mp_max, 2500}
        ,{dmg, 500}
        ,{dmg_magic, 500}
        ,{defence, 2500}
        ,{critrate, 100}
        ,{tenacity, 100}
        ,{resist_earth, 1250}
    ];
get_demon_attr(5, 51) ->
    [
        {hp_max, 5100}
        ,{mp_max, 2550}
        ,{dmg, 510}
        ,{dmg_magic, 510}
        ,{defence, 2550}
        ,{critrate, 102}
        ,{tenacity, 102}
        ,{resist_earth, 1275}
    ];
get_demon_attr(5, 52) ->
    [
        {hp_max, 5200}
        ,{mp_max, 2600}
        ,{dmg, 520}
        ,{dmg_magic, 520}
        ,{defence, 2600}
        ,{critrate, 104}
        ,{tenacity, 104}
        ,{resist_earth, 1300}
    ];
get_demon_attr(5, 53) ->
    [
        {hp_max, 5300}
        ,{mp_max, 2650}
        ,{dmg, 530}
        ,{dmg_magic, 530}
        ,{defence, 2650}
        ,{critrate, 106}
        ,{tenacity, 106}
        ,{resist_earth, 1325}
    ];
get_demon_attr(5, 54) ->
    [
        {hp_max, 5400}
        ,{mp_max, 2700}
        ,{dmg, 540}
        ,{dmg_magic, 540}
        ,{defence, 2700}
        ,{critrate, 108}
        ,{tenacity, 108}
        ,{resist_earth, 1350}
    ];
get_demon_attr(5, 55) ->
    [
        {hp_max, 5500}
        ,{mp_max, 2750}
        ,{dmg, 550}
        ,{dmg_magic, 550}
        ,{defence, 2750}
        ,{critrate, 110}
        ,{tenacity, 110}
        ,{resist_earth, 1375}
    ];
get_demon_attr(5, 56) ->
    [
        {hp_max, 5600}
        ,{mp_max, 2800}
        ,{dmg, 560}
        ,{dmg_magic, 560}
        ,{defence, 2800}
        ,{critrate, 112}
        ,{tenacity, 112}
        ,{resist_earth, 1400}
    ];
get_demon_attr(5, 57) ->
    [
        {hp_max, 5700}
        ,{mp_max, 2850}
        ,{dmg, 570}
        ,{dmg_magic, 570}
        ,{defence, 2850}
        ,{critrate, 114}
        ,{tenacity, 114}
        ,{resist_earth, 1425}
    ];
get_demon_attr(5, 58) ->
    [
        {hp_max, 5800}
        ,{mp_max, 2900}
        ,{dmg, 580}
        ,{dmg_magic, 580}
        ,{defence, 2900}
        ,{critrate, 116}
        ,{tenacity, 116}
        ,{resist_earth, 1450}
    ];
get_demon_attr(5, 59) ->
    [
        {hp_max, 5900}
        ,{mp_max, 2950}
        ,{dmg, 590}
        ,{dmg_magic, 590}
        ,{defence, 2950}
        ,{critrate, 118}
        ,{tenacity, 118}
        ,{resist_earth, 1475}
    ];
get_demon_attr(5, 60) ->
    [
        {hp_max, 6000}
        ,{mp_max, 3000}
        ,{dmg, 600}
        ,{dmg_magic, 600}
        ,{defence, 3000}
        ,{critrate, 120}
        ,{tenacity, 120}
        ,{resist_earth, 1500}
    ];
get_demon_attr(5, 61) ->
    [
        {hp_max, 6100}
        ,{mp_max, 3050}
        ,{dmg, 610}
        ,{dmg_magic, 610}
        ,{defence, 3050}
        ,{critrate, 122}
        ,{tenacity, 122}
        ,{resist_earth, 1525}
    ];
get_demon_attr(5, 62) ->
    [
        {hp_max, 6200}
        ,{mp_max, 3100}
        ,{dmg, 620}
        ,{dmg_magic, 620}
        ,{defence, 3100}
        ,{critrate, 124}
        ,{tenacity, 124}
        ,{resist_earth, 1550}
    ];
get_demon_attr(5, 63) ->
    [
        {hp_max, 6300}
        ,{mp_max, 3150}
        ,{dmg, 630}
        ,{dmg_magic, 630}
        ,{defence, 3150}
        ,{critrate, 126}
        ,{tenacity, 126}
        ,{resist_earth, 1575}
    ];
get_demon_attr(5, 64) ->
    [
        {hp_max, 6400}
        ,{mp_max, 3200}
        ,{dmg, 640}
        ,{dmg_magic, 640}
        ,{defence, 3200}
        ,{critrate, 128}
        ,{tenacity, 128}
        ,{resist_earth, 1600}
    ];
get_demon_attr(5, 65) ->
    [
        {hp_max, 6500}
        ,{mp_max, 3250}
        ,{dmg, 650}
        ,{dmg_magic, 650}
        ,{defence, 3250}
        ,{critrate, 130}
        ,{tenacity, 130}
        ,{resist_earth, 1625}
    ];
get_demon_attr(5, 66) ->
    [
        {hp_max, 6600}
        ,{mp_max, 3300}
        ,{dmg, 660}
        ,{dmg_magic, 660}
        ,{defence, 3300}
        ,{critrate, 132}
        ,{tenacity, 132}
        ,{resist_earth, 1650}
    ];
get_demon_attr(5, 67) ->
    [
        {hp_max, 6700}
        ,{mp_max, 3350}
        ,{dmg, 670}
        ,{dmg_magic, 670}
        ,{defence, 3350}
        ,{critrate, 134}
        ,{tenacity, 134}
        ,{resist_earth, 1675}
    ];
get_demon_attr(5, 68) ->
    [
        {hp_max, 6800}
        ,{mp_max, 3400}
        ,{dmg, 680}
        ,{dmg_magic, 680}
        ,{defence, 3400}
        ,{critrate, 136}
        ,{tenacity, 136}
        ,{resist_earth, 1700}
    ];
get_demon_attr(5, 69) ->
    [
        {hp_max, 6900}
        ,{mp_max, 3450}
        ,{dmg, 690}
        ,{dmg_magic, 690}
        ,{defence, 3450}
        ,{critrate, 138}
        ,{tenacity, 138}
        ,{resist_earth, 1725}
    ];
get_demon_attr(5, 70) ->
    [
        {hp_max, 7000}
        ,{mp_max, 3500}
        ,{dmg, 700}
        ,{dmg_magic, 700}
        ,{defence, 3500}
        ,{critrate, 140}
        ,{tenacity, 140}
        ,{resist_earth, 1750}
    ];
get_demon_attr(5, 71) ->
    [
        {hp_max, 7100}
        ,{mp_max, 3550}
        ,{dmg, 710}
        ,{dmg_magic, 710}
        ,{defence, 3550}
        ,{critrate, 142}
        ,{tenacity, 142}
        ,{resist_earth, 1775}
    ];
get_demon_attr(5, 72) ->
    [
        {hp_max, 7200}
        ,{mp_max, 3600}
        ,{dmg, 720}
        ,{dmg_magic, 720}
        ,{defence, 3600}
        ,{critrate, 144}
        ,{tenacity, 144}
        ,{resist_earth, 1800}
    ];
get_demon_attr(5, 73) ->
    [
        {hp_max, 7300}
        ,{mp_max, 3650}
        ,{dmg, 730}
        ,{dmg_magic, 730}
        ,{defence, 3650}
        ,{critrate, 146}
        ,{tenacity, 146}
        ,{resist_earth, 1825}
    ];
get_demon_attr(5, 74) ->
    [
        {hp_max, 7400}
        ,{mp_max, 3700}
        ,{dmg, 740}
        ,{dmg_magic, 740}
        ,{defence, 3700}
        ,{critrate, 148}
        ,{tenacity, 148}
        ,{resist_earth, 1850}
    ];
get_demon_attr(5, 75) ->
    [
        {hp_max, 7500}
        ,{mp_max, 3750}
        ,{dmg, 750}
        ,{dmg_magic, 750}
        ,{defence, 3750}
        ,{critrate, 150}
        ,{tenacity, 150}
        ,{resist_earth, 1875}
    ];
get_demon_attr(5, 76) ->
    [
        {hp_max, 7600}
        ,{mp_max, 3800}
        ,{dmg, 760}
        ,{dmg_magic, 760}
        ,{defence, 3800}
        ,{critrate, 152}
        ,{tenacity, 152}
        ,{resist_earth, 1900}
    ];
get_demon_attr(5, 77) ->
    [
        {hp_max, 7700}
        ,{mp_max, 3850}
        ,{dmg, 770}
        ,{dmg_magic, 770}
        ,{defence, 3850}
        ,{critrate, 154}
        ,{tenacity, 154}
        ,{resist_earth, 1925}
    ];
get_demon_attr(5, 78) ->
    [
        {hp_max, 7800}
        ,{mp_max, 3900}
        ,{dmg, 780}
        ,{dmg_magic, 780}
        ,{defence, 3900}
        ,{critrate, 156}
        ,{tenacity, 156}
        ,{resist_earth, 1950}
    ];
get_demon_attr(5, 79) ->
    [
        {hp_max, 7900}
        ,{mp_max, 3950}
        ,{dmg, 790}
        ,{dmg_magic, 790}
        ,{defence, 3950}
        ,{critrate, 158}
        ,{tenacity, 158}
        ,{resist_earth, 1975}
    ];
get_demon_attr(5, 80) ->
    [
        {hp_max, 8000}
        ,{mp_max, 4000}
        ,{dmg, 800}
        ,{dmg_magic, 800}
        ,{defence, 4000}
        ,{critrate, 160}
        ,{tenacity, 160}
        ,{resist_earth, 2000}
    ];
get_demon_attr(5, 81) ->
    [
        {hp_max, 8100}
        ,{mp_max, 4050}
        ,{dmg, 810}
        ,{dmg_magic, 810}
        ,{defence, 4050}
        ,{critrate, 162}
        ,{tenacity, 162}
        ,{resist_earth, 2025}
    ];
get_demon_attr(5, 82) ->
    [
        {hp_max, 8200}
        ,{mp_max, 4100}
        ,{dmg, 820}
        ,{dmg_magic, 820}
        ,{defence, 4100}
        ,{critrate, 164}
        ,{tenacity, 164}
        ,{resist_earth, 2050}
    ];
get_demon_attr(5, 83) ->
    [
        {hp_max, 8300}
        ,{mp_max, 4150}
        ,{dmg, 830}
        ,{dmg_magic, 830}
        ,{defence, 4150}
        ,{critrate, 166}
        ,{tenacity, 166}
        ,{resist_earth, 2075}
    ];
get_demon_attr(5, 84) ->
    [
        {hp_max, 8400}
        ,{mp_max, 4200}
        ,{dmg, 840}
        ,{dmg_magic, 840}
        ,{defence, 4200}
        ,{critrate, 168}
        ,{tenacity, 168}
        ,{resist_earth, 2100}
    ];
get_demon_attr(5, 85) ->
    [
        {hp_max, 8500}
        ,{mp_max, 4250}
        ,{dmg, 850}
        ,{dmg_magic, 850}
        ,{defence, 4250}
        ,{critrate, 170}
        ,{tenacity, 170}
        ,{resist_earth, 2125}
    ];
get_demon_attr(5, 86) ->
    [
        {hp_max, 8600}
        ,{mp_max, 4300}
        ,{dmg, 860}
        ,{dmg_magic, 860}
        ,{defence, 4300}
        ,{critrate, 172}
        ,{tenacity, 172}
        ,{resist_earth, 2150}
    ];
get_demon_attr(5, 87) ->
    [
        {hp_max, 8700}
        ,{mp_max, 4350}
        ,{dmg, 870}
        ,{dmg_magic, 870}
        ,{defence, 4350}
        ,{critrate, 174}
        ,{tenacity, 174}
        ,{resist_earth, 2175}
    ];
get_demon_attr(5, 88) ->
    [
        {hp_max, 8800}
        ,{mp_max, 4400}
        ,{dmg, 880}
        ,{dmg_magic, 880}
        ,{defence, 4400}
        ,{critrate, 176}
        ,{tenacity, 176}
        ,{resist_earth, 2200}
    ];
get_demon_attr(5, 89) ->
    [
        {hp_max, 8900}
        ,{mp_max, 4450}
        ,{dmg, 890}
        ,{dmg_magic, 890}
        ,{defence, 4450}
        ,{critrate, 178}
        ,{tenacity, 178}
        ,{resist_earth, 2225}
    ];
get_demon_attr(5, 90) ->
    [
        {hp_max, 9000}
        ,{mp_max, 4500}
        ,{dmg, 900}
        ,{dmg_magic, 900}
        ,{defence, 4500}
        ,{critrate, 180}
        ,{tenacity, 180}
        ,{resist_earth, 2250}
    ];
get_demon_attr(5, 91) ->
    [
        {hp_max, 9100}
        ,{mp_max, 4550}
        ,{dmg, 910}
        ,{dmg_magic, 910}
        ,{defence, 4550}
        ,{critrate, 182}
        ,{tenacity, 182}
        ,{resist_earth, 2275}
    ];
get_demon_attr(5, 92) ->
    [
        {hp_max, 9200}
        ,{mp_max, 4600}
        ,{dmg, 920}
        ,{dmg_magic, 920}
        ,{defence, 4600}
        ,{critrate, 184}
        ,{tenacity, 184}
        ,{resist_earth, 2300}
    ];
get_demon_attr(5, 93) ->
    [
        {hp_max, 9300}
        ,{mp_max, 4650}
        ,{dmg, 930}
        ,{dmg_magic, 930}
        ,{defence, 4650}
        ,{critrate, 186}
        ,{tenacity, 186}
        ,{resist_earth, 2325}
    ];
get_demon_attr(5, 94) ->
    [
        {hp_max, 9400}
        ,{mp_max, 4700}
        ,{dmg, 940}
        ,{dmg_magic, 940}
        ,{defence, 4700}
        ,{critrate, 188}
        ,{tenacity, 188}
        ,{resist_earth, 2350}
    ];
get_demon_attr(5, 95) ->
    [
        {hp_max, 9500}
        ,{mp_max, 4750}
        ,{dmg, 950}
        ,{dmg_magic, 950}
        ,{defence, 4750}
        ,{critrate, 190}
        ,{tenacity, 190}
        ,{resist_earth, 2375}
    ];
get_demon_attr(5, 96) ->
    [
        {hp_max, 9600}
        ,{mp_max, 4800}
        ,{dmg, 960}
        ,{dmg_magic, 960}
        ,{defence, 4800}
        ,{critrate, 192}
        ,{tenacity, 192}
        ,{resist_earth, 2400}
    ];
get_demon_attr(5, 97) ->
    [
        {hp_max, 9700}
        ,{mp_max, 4850}
        ,{dmg, 970}
        ,{dmg_magic, 970}
        ,{defence, 4850}
        ,{critrate, 194}
        ,{tenacity, 194}
        ,{resist_earth, 2425}
    ];
get_demon_attr(5, 98) ->
    [
        {hp_max, 9800}
        ,{mp_max, 4900}
        ,{dmg, 980}
        ,{dmg_magic, 980}
        ,{defence, 4900}
        ,{critrate, 196}
        ,{tenacity, 196}
        ,{resist_earth, 2450}
    ];
get_demon_attr(5, 99) ->
    [
        {hp_max, 9900}
        ,{mp_max, 4950}
        ,{dmg, 990}
        ,{dmg_magic, 990}
        ,{defence, 4950}
        ,{critrate, 198}
        ,{tenacity, 198}
        ,{resist_earth, 2475}
    ];
get_demon_attr(5, 100) ->
    [
        {hp_max, 10000}
        ,{mp_max, 5000}
        ,{dmg, 1000}
        ,{dmg_magic, 1000}
        ,{defence, 5000}
        ,{critrate, 200}
        ,{tenacity, 200}
        ,{resist_earth, 2500}
    ];
get_demon_attr(_, _) -> [].

%% 根据精灵等级获取升级经验值
get_exp(1) -> 300;
get_exp(2) -> 382;
get_exp(3) -> 440;
get_exp(4) -> 487;
get_exp(5) -> 526;
get_exp(6) -> 561;
get_exp(7) -> 592;
get_exp(8) -> 621;
get_exp(9) -> 647;
get_exp(10) -> 671;
get_exp(11) -> 694;
get_exp(12) -> 715;
get_exp(13) -> 736;
get_exp(14) -> 755;
get_exp(15) -> 774;
get_exp(16) -> 791;
get_exp(17) -> 808;
get_exp(18) -> 825;
get_exp(19) -> 840;
get_exp(20) -> 856;
get_exp(21) -> 870;
get_exp(22) -> 885;
get_exp(23) -> 898;
get_exp(24) -> 912;
get_exp(25) -> 925;
get_exp(26) -> 938;
get_exp(27) -> 966;
get_exp(28) -> 995;
get_exp(29) -> 1025;
get_exp(30) -> 1055;
get_exp(31) -> 1068;
get_exp(32) -> 1081;
get_exp(33) -> 1093;
get_exp(34) -> 1106;
get_exp(35) -> 1117;
get_exp(36) -> 1129;
get_exp(37) -> 1141;
get_exp(38) -> 1152;
get_exp(39) -> 1163;
get_exp(40) -> 1174;
get_exp(41) -> 1185;
get_exp(42) -> 1195;
get_exp(43) -> 1206;
get_exp(44) -> 1216;
get_exp(45) -> 1226;
get_exp(46) -> 1256;
get_exp(47) -> 1285;
get_exp(48) -> 1316;
get_exp(49) -> 1347;
get_exp(50) -> 1379;
get_exp(51) -> 1390;
get_exp(52) -> 1400;
get_exp(53) -> 1411;
get_exp(54) -> 1421;
get_exp(55) -> 1431;
get_exp(56) -> 1441;
get_exp(57) -> 1451;
get_exp(58) -> 1461;
get_exp(59) -> 1471;
get_exp(60) -> 1481;
get_exp(61) -> 1490;
get_exp(62) -> 1500;
get_exp(63) -> 1519;
get_exp(64) -> 1559;
get_exp(65) -> 1649;
get_exp(66) -> 1809;
get_exp(67) -> 2059;
get_exp(68) -> 2419;
get_exp(69) -> 2909;
get_exp(70) -> 3549;
get_exp(71) -> 4359;
get_exp(72) -> 5359;
get_exp(73) -> 6569;
get_exp(74) -> 8009;
get_exp(75) -> 9699;
get_exp(76) -> 11659;
get_exp(77) -> 13909;
get_exp(78) -> 16469;
get_exp(79) -> 19359;
get_exp(80) -> 21157;
get_exp(81) -> 23141;
get_exp(82) -> 25331;
get_exp(83) -> 27751;
get_exp(84) -> 30427;
get_exp(85) -> 33389;
get_exp(86) -> 36670;
get_exp(87) -> 40307;
get_exp(88) -> 44343;
get_exp(89) -> 48825;
get_exp(90) -> 53807;
get_exp(91) -> 59349;
get_exp(92) -> 65520;
get_exp(93) -> 72397;
get_exp(94) -> 80067;
get_exp(95) -> 88630;
get_exp(96) -> 98199;
get_exp(97) -> 108902;
get_exp(98) -> 120884;
get_exp(99) -> 134310;
get_exp(100) -> 0;
get_exp(_) -> 9999999999.

%% 根据技能当前等级获取升级经验
get_skill_exp(86000) -> 2;
get_skill_exp(86001) -> 5;
get_skill_exp(86002) -> 10;
get_skill_exp(86003) -> 21;
get_skill_exp(86004) -> 42;
get_skill_exp(86005) -> 85;
get_skill_exp(86006) -> 170;
get_skill_exp(86007) -> 341;
get_skill_exp(86008) -> 682;
get_skill_exp(86009) -> 683;
get_skill_exp(86100) -> 2;
get_skill_exp(86101) -> 5;
get_skill_exp(86102) -> 10;
get_skill_exp(86103) -> 21;
get_skill_exp(86104) -> 42;
get_skill_exp(86105) -> 85;
get_skill_exp(86106) -> 170;
get_skill_exp(86107) -> 341;
get_skill_exp(86108) -> 682;
get_skill_exp(86109) -> 683;
get_skill_exp(86200) -> 2;
get_skill_exp(86201) -> 5;
get_skill_exp(86202) -> 10;
get_skill_exp(86203) -> 21;
get_skill_exp(86204) -> 42;
get_skill_exp(86205) -> 85;
get_skill_exp(86206) -> 170;
get_skill_exp(86207) -> 341;
get_skill_exp(86208) -> 682;
get_skill_exp(86209) -> 683;
get_skill_exp(86300) -> 2;
get_skill_exp(86301) -> 5;
get_skill_exp(86302) -> 10;
get_skill_exp(86303) -> 21;
get_skill_exp(86304) -> 42;
get_skill_exp(86305) -> 85;
get_skill_exp(86306) -> 170;
get_skill_exp(86307) -> 341;
get_skill_exp(86308) -> 682;
get_skill_exp(86309) -> 683;
get_skill_exp(86400) -> 2;
get_skill_exp(86401) -> 5;
get_skill_exp(86402) -> 10;
get_skill_exp(86403) -> 21;
get_skill_exp(86404) -> 42;
get_skill_exp(86405) -> 85;
get_skill_exp(86406) -> 170;
get_skill_exp(86407) -> 341;
get_skill_exp(86408) -> 682;
get_skill_exp(86409) -> 683;
get_skill_exp(86500) -> 2;
get_skill_exp(86501) -> 5;
get_skill_exp(86502) -> 10;
get_skill_exp(86503) -> 21;
get_skill_exp(86504) -> 42;
get_skill_exp(86505) -> 85;
get_skill_exp(86506) -> 170;
get_skill_exp(86507) -> 341;
get_skill_exp(86508) -> 682;
get_skill_exp(86509) -> 683;
get_skill_exp(86600) -> 2;
get_skill_exp(86601) -> 5;
get_skill_exp(86602) -> 10;
get_skill_exp(86603) -> 21;
get_skill_exp(86604) -> 42;
get_skill_exp(86605) -> 85;
get_skill_exp(86606) -> 170;
get_skill_exp(86607) -> 341;
get_skill_exp(86608) -> 682;
get_skill_exp(86609) -> 683;
get_skill_exp(86900) -> 2;
get_skill_exp(86901) -> 5;
get_skill_exp(86902) -> 10;
get_skill_exp(86903) -> 21;
get_skill_exp(86904) -> 42;
get_skill_exp(86905) -> 85;
get_skill_exp(86906) -> 170;
get_skill_exp(86907) -> 341;
get_skill_exp(86908) -> 682;
get_skill_exp(86909) -> 683;
get_skill_exp(86800) -> 2;
get_skill_exp(86801) -> 5;
get_skill_exp(86802) -> 10;
get_skill_exp(86803) -> 21;
get_skill_exp(86804) -> 42;
get_skill_exp(86805) -> 85;
get_skill_exp(86806) -> 170;
get_skill_exp(86807) -> 341;
get_skill_exp(86808) -> 682;
get_skill_exp(86809) -> 683;
get_skill_exp(85000) -> 2;
get_skill_exp(85001) -> 5;
get_skill_exp(85002) -> 11;
get_skill_exp(85003) -> 23;
get_skill_exp(85004) -> 46;
get_skill_exp(85005) -> 93;
get_skill_exp(85006) -> 187;
get_skill_exp(85007) -> 375;
get_skill_exp(85008) -> 750;
get_skill_exp(85009) -> 755;
get_skill_exp(85100) -> 2;
get_skill_exp(85101) -> 5;
get_skill_exp(85102) -> 11;
get_skill_exp(85103) -> 23;
get_skill_exp(85104) -> 46;
get_skill_exp(85105) -> 93;
get_skill_exp(85106) -> 187;
get_skill_exp(85107) -> 375;
get_skill_exp(85108) -> 750;
get_skill_exp(85109) -> 755;
get_skill_exp(85200) -> 2;
get_skill_exp(85201) -> 5;
get_skill_exp(85202) -> 11;
get_skill_exp(85203) -> 23;
get_skill_exp(85204) -> 46;
get_skill_exp(85205) -> 93;
get_skill_exp(85206) -> 187;
get_skill_exp(85207) -> 375;
get_skill_exp(85208) -> 750;
get_skill_exp(85209) -> 755;
get_skill_exp(85300) -> 2;
get_skill_exp(85301) -> 5;
get_skill_exp(85302) -> 11;
get_skill_exp(85303) -> 23;
get_skill_exp(85304) -> 46;
get_skill_exp(85305) -> 93;
get_skill_exp(85306) -> 187;
get_skill_exp(85307) -> 375;
get_skill_exp(85308) -> 750;
get_skill_exp(85309) -> 755;
get_skill_exp(85400) -> 2;
get_skill_exp(85401) -> 5;
get_skill_exp(85402) -> 11;
get_skill_exp(85403) -> 23;
get_skill_exp(85404) -> 46;
get_skill_exp(85405) -> 93;
get_skill_exp(85406) -> 187;
get_skill_exp(85407) -> 375;
get_skill_exp(85408) -> 750;
get_skill_exp(85409) -> 755;
get_skill_exp(85500) -> 2;
get_skill_exp(85501) -> 5;
get_skill_exp(85502) -> 11;
get_skill_exp(85503) -> 23;
get_skill_exp(85504) -> 46;
get_skill_exp(85505) -> 93;
get_skill_exp(85506) -> 187;
get_skill_exp(85507) -> 375;
get_skill_exp(85508) -> 750;
get_skill_exp(85509) -> 755;
get_skill_exp(85600) -> 2;
get_skill_exp(85601) -> 5;
get_skill_exp(85602) -> 11;
get_skill_exp(85603) -> 23;
get_skill_exp(85604) -> 46;
get_skill_exp(85605) -> 93;
get_skill_exp(85606) -> 187;
get_skill_exp(85607) -> 375;
get_skill_exp(85608) -> 750;
get_skill_exp(85609) -> 755;
get_skill_exp(85900) -> 2;
get_skill_exp(85901) -> 5;
get_skill_exp(85902) -> 11;
get_skill_exp(85903) -> 23;
get_skill_exp(85904) -> 46;
get_skill_exp(85905) -> 93;
get_skill_exp(85906) -> 187;
get_skill_exp(85907) -> 375;
get_skill_exp(85908) -> 750;
get_skill_exp(85909) -> 755;
get_skill_exp(85800) -> 2;
get_skill_exp(85801) -> 5;
get_skill_exp(85802) -> 11;
get_skill_exp(85803) -> 23;
get_skill_exp(85804) -> 46;
get_skill_exp(85805) -> 93;
get_skill_exp(85806) -> 187;
get_skill_exp(85807) -> 375;
get_skill_exp(85808) -> 750;
get_skill_exp(85809) -> 755;
get_skill_exp(84000) -> 3;
get_skill_exp(84001) -> 7;
get_skill_exp(84002) -> 14;
get_skill_exp(84003) -> 30;
get_skill_exp(84004) -> 60;
get_skill_exp(84005) -> 121;
get_skill_exp(84006) -> 243;
get_skill_exp(84007) -> 487;
get_skill_exp(84008) -> 975;
get_skill_exp(84009) -> 1200;
get_skill_exp(84100) -> 3;
get_skill_exp(84101) -> 7;
get_skill_exp(84102) -> 14;
get_skill_exp(84103) -> 30;
get_skill_exp(84104) -> 60;
get_skill_exp(84105) -> 121;
get_skill_exp(84106) -> 243;
get_skill_exp(84107) -> 487;
get_skill_exp(84108) -> 975;
get_skill_exp(84109) -> 1200;
get_skill_exp(84200) -> 3;
get_skill_exp(84201) -> 7;
get_skill_exp(84202) -> 14;
get_skill_exp(84203) -> 30;
get_skill_exp(84204) -> 60;
get_skill_exp(84205) -> 121;
get_skill_exp(84206) -> 243;
get_skill_exp(84207) -> 487;
get_skill_exp(84208) -> 975;
get_skill_exp(84209) -> 1200;
get_skill_exp(84300) -> 3;
get_skill_exp(84301) -> 7;
get_skill_exp(84302) -> 14;
get_skill_exp(84303) -> 30;
get_skill_exp(84304) -> 60;
get_skill_exp(84305) -> 121;
get_skill_exp(84306) -> 243;
get_skill_exp(84307) -> 487;
get_skill_exp(84308) -> 975;
get_skill_exp(84309) -> 1200;
get_skill_exp(84400) -> 3;
get_skill_exp(84401) -> 7;
get_skill_exp(84402) -> 14;
get_skill_exp(84403) -> 30;
get_skill_exp(84404) -> 60;
get_skill_exp(84405) -> 121;
get_skill_exp(84406) -> 243;
get_skill_exp(84407) -> 487;
get_skill_exp(84408) -> 975;
get_skill_exp(84409) -> 1200;
get_skill_exp(84500) -> 3;
get_skill_exp(84501) -> 7;
get_skill_exp(84502) -> 14;
get_skill_exp(84503) -> 30;
get_skill_exp(84504) -> 60;
get_skill_exp(84505) -> 121;
get_skill_exp(84506) -> 243;
get_skill_exp(84507) -> 487;
get_skill_exp(84508) -> 975;
get_skill_exp(84509) -> 1200;
get_skill_exp(84600) -> 3;
get_skill_exp(84601) -> 7;
get_skill_exp(84602) -> 14;
get_skill_exp(84603) -> 30;
get_skill_exp(84604) -> 60;
get_skill_exp(84605) -> 121;
get_skill_exp(84606) -> 243;
get_skill_exp(84607) -> 487;
get_skill_exp(84608) -> 975;
get_skill_exp(84609) -> 1200;
get_skill_exp(84900) -> 3;
get_skill_exp(84901) -> 7;
get_skill_exp(84902) -> 14;
get_skill_exp(84903) -> 30;
get_skill_exp(84904) -> 60;
get_skill_exp(84905) -> 121;
get_skill_exp(84906) -> 243;
get_skill_exp(84907) -> 487;
get_skill_exp(84908) -> 975;
get_skill_exp(84909) -> 1200;
get_skill_exp(84800) -> 3;
get_skill_exp(84801) -> 7;
get_skill_exp(84802) -> 14;
get_skill_exp(84803) -> 30;
get_skill_exp(84804) -> 60;
get_skill_exp(84805) -> 121;
get_skill_exp(84806) -> 243;
get_skill_exp(84807) -> 487;
get_skill_exp(84808) -> 975;
get_skill_exp(84809) -> 1200;
get_skill_exp(83000) -> 4;
get_skill_exp(83001) -> 10;
get_skill_exp(83002) -> 20;
get_skill_exp(83003) -> 42;
get_skill_exp(83004) -> 84;
get_skill_exp(83005) -> 170;
get_skill_exp(83006) -> 340;
get_skill_exp(83007) -> 682;
get_skill_exp(83008) -> 1365;
get_skill_exp(83009) -> 1800;
get_skill_exp(83100) -> 4;
get_skill_exp(83101) -> 10;
get_skill_exp(83102) -> 20;
get_skill_exp(83103) -> 42;
get_skill_exp(83104) -> 84;
get_skill_exp(83105) -> 170;
get_skill_exp(83106) -> 340;
get_skill_exp(83107) -> 682;
get_skill_exp(83108) -> 1365;
get_skill_exp(83109) -> 1800;
get_skill_exp(83200) -> 4;
get_skill_exp(83201) -> 10;
get_skill_exp(83202) -> 20;
get_skill_exp(83203) -> 42;
get_skill_exp(83204) -> 84;
get_skill_exp(83205) -> 170;
get_skill_exp(83206) -> 340;
get_skill_exp(83207) -> 682;
get_skill_exp(83208) -> 1365;
get_skill_exp(83209) -> 1800;
get_skill_exp(83300) -> 4;
get_skill_exp(83301) -> 10;
get_skill_exp(83302) -> 20;
get_skill_exp(83303) -> 42;
get_skill_exp(83304) -> 84;
get_skill_exp(83305) -> 170;
get_skill_exp(83306) -> 340;
get_skill_exp(83307) -> 682;
get_skill_exp(83308) -> 1365;
get_skill_exp(83309) -> 1800;
get_skill_exp(83400) -> 4;
get_skill_exp(83401) -> 10;
get_skill_exp(83402) -> 20;
get_skill_exp(83403) -> 42;
get_skill_exp(83404) -> 84;
get_skill_exp(83405) -> 170;
get_skill_exp(83406) -> 340;
get_skill_exp(83407) -> 682;
get_skill_exp(83408) -> 1365;
get_skill_exp(83409) -> 1800;
get_skill_exp(83500) -> 4;
get_skill_exp(83501) -> 10;
get_skill_exp(83502) -> 20;
get_skill_exp(83503) -> 42;
get_skill_exp(83504) -> 84;
get_skill_exp(83505) -> 170;
get_skill_exp(83506) -> 340;
get_skill_exp(83507) -> 682;
get_skill_exp(83508) -> 1365;
get_skill_exp(83509) -> 1800;
get_skill_exp(83600) -> 4;
get_skill_exp(83601) -> 10;
get_skill_exp(83602) -> 20;
get_skill_exp(83603) -> 42;
get_skill_exp(83604) -> 84;
get_skill_exp(83605) -> 170;
get_skill_exp(83606) -> 340;
get_skill_exp(83607) -> 682;
get_skill_exp(83608) -> 1365;
get_skill_exp(83609) -> 1800;
get_skill_exp(83900) -> 4;
get_skill_exp(83901) -> 10;
get_skill_exp(83902) -> 20;
get_skill_exp(83903) -> 42;
get_skill_exp(83904) -> 84;
get_skill_exp(83905) -> 170;
get_skill_exp(83906) -> 340;
get_skill_exp(83907) -> 682;
get_skill_exp(83908) -> 1365;
get_skill_exp(83909) -> 1800;
get_skill_exp(83800) -> 4;
get_skill_exp(83801) -> 10;
get_skill_exp(83802) -> 20;
get_skill_exp(83803) -> 42;
get_skill_exp(83804) -> 84;
get_skill_exp(83805) -> 170;
get_skill_exp(83806) -> 340;
get_skill_exp(83807) -> 682;
get_skill_exp(83808) -> 1365;
get_skill_exp(83809) -> 1800;
get_skill_exp(82000) -> 6;
get_skill_exp(82001) -> 15;
get_skill_exp(82002) -> 30;
get_skill_exp(82003) -> 63;
get_skill_exp(82004) -> 126;
get_skill_exp(82005) -> 255;
get_skill_exp(82006) -> 510;
get_skill_exp(82007) -> 1024;
get_skill_exp(82008) -> 2048;
get_skill_exp(82009) -> 2500;
get_skill_exp(82100) -> 6;
get_skill_exp(82101) -> 15;
get_skill_exp(82102) -> 30;
get_skill_exp(82103) -> 63;
get_skill_exp(82104) -> 126;
get_skill_exp(82105) -> 255;
get_skill_exp(82106) -> 510;
get_skill_exp(82107) -> 1024;
get_skill_exp(82108) -> 2048;
get_skill_exp(82109) -> 2500;
get_skill_exp(82200) -> 6;
get_skill_exp(82201) -> 15;
get_skill_exp(82202) -> 30;
get_skill_exp(82203) -> 63;
get_skill_exp(82204) -> 126;
get_skill_exp(82205) -> 255;
get_skill_exp(82206) -> 510;
get_skill_exp(82207) -> 1024;
get_skill_exp(82208) -> 2048;
get_skill_exp(82209) -> 2500;
get_skill_exp(82300) -> 6;
get_skill_exp(82301) -> 15;
get_skill_exp(82302) -> 30;
get_skill_exp(82303) -> 63;
get_skill_exp(82304) -> 126;
get_skill_exp(82305) -> 255;
get_skill_exp(82306) -> 510;
get_skill_exp(82307) -> 1024;
get_skill_exp(82308) -> 2048;
get_skill_exp(82309) -> 2500;
get_skill_exp(82400) -> 6;
get_skill_exp(82401) -> 15;
get_skill_exp(82402) -> 30;
get_skill_exp(82403) -> 63;
get_skill_exp(82404) -> 126;
get_skill_exp(82405) -> 255;
get_skill_exp(82406) -> 510;
get_skill_exp(82407) -> 1024;
get_skill_exp(82408) -> 2048;
get_skill_exp(82409) -> 2500;
get_skill_exp(82500) -> 6;
get_skill_exp(82501) -> 15;
get_skill_exp(82502) -> 30;
get_skill_exp(82503) -> 63;
get_skill_exp(82504) -> 126;
get_skill_exp(82505) -> 255;
get_skill_exp(82506) -> 510;
get_skill_exp(82507) -> 1024;
get_skill_exp(82508) -> 2048;
get_skill_exp(82509) -> 2500;
get_skill_exp(82600) -> 6;
get_skill_exp(82601) -> 15;
get_skill_exp(82602) -> 30;
get_skill_exp(82603) -> 63;
get_skill_exp(82604) -> 126;
get_skill_exp(82605) -> 255;
get_skill_exp(82606) -> 510;
get_skill_exp(82607) -> 1024;
get_skill_exp(82608) -> 2048;
get_skill_exp(82609) -> 2500;
get_skill_exp(82900) -> 6;
get_skill_exp(82901) -> 15;
get_skill_exp(82902) -> 30;
get_skill_exp(82903) -> 63;
get_skill_exp(82904) -> 126;
get_skill_exp(82905) -> 255;
get_skill_exp(82906) -> 510;
get_skill_exp(82907) -> 1024;
get_skill_exp(82908) -> 2048;
get_skill_exp(82909) -> 2500;
get_skill_exp(82800) -> 6;
get_skill_exp(82801) -> 15;
get_skill_exp(82802) -> 30;
get_skill_exp(82803) -> 63;
get_skill_exp(82804) -> 126;
get_skill_exp(82805) -> 255;
get_skill_exp(82806) -> 510;
get_skill_exp(82807) -> 1024;
get_skill_exp(82808) -> 2048;
get_skill_exp(82809) -> 2500;
get_skill_exp(89000) -> 2;
get_skill_exp(89001) -> 5;
get_skill_exp(89002) -> 10;
get_skill_exp(89003) -> 21;
get_skill_exp(89004) -> 42;
get_skill_exp(89005) -> 85;
get_skill_exp(89006) -> 170;
get_skill_exp(89007) -> 341;
get_skill_exp(89008) -> 682;
get_skill_exp(89009) -> 683;
get_skill_exp(89010) -> 2;
get_skill_exp(89011) -> 5;
get_skill_exp(89012) -> 10;
get_skill_exp(89013) -> 21;
get_skill_exp(89014) -> 42;
get_skill_exp(89015) -> 85;
get_skill_exp(89016) -> 170;
get_skill_exp(89017) -> 341;
get_skill_exp(89018) -> 682;
get_skill_exp(89019) -> 683;
get_skill_exp(89020) -> 2;
get_skill_exp(89021) -> 5;
get_skill_exp(89022) -> 10;
get_skill_exp(89023) -> 21;
get_skill_exp(89024) -> 42;
get_skill_exp(89025) -> 85;
get_skill_exp(89026) -> 170;
get_skill_exp(89027) -> 341;
get_skill_exp(89028) -> 682;
get_skill_exp(89029) -> 683;
get_skill_exp(89030) -> 2;
get_skill_exp(89031) -> 5;
get_skill_exp(89032) -> 10;
get_skill_exp(89033) -> 21;
get_skill_exp(89034) -> 42;
get_skill_exp(89035) -> 85;
get_skill_exp(89036) -> 170;
get_skill_exp(89037) -> 341;
get_skill_exp(89038) -> 682;
get_skill_exp(89039) -> 683;
get_skill_exp(89040) -> 2;
get_skill_exp(89041) -> 5;
get_skill_exp(89042) -> 10;
get_skill_exp(89043) -> 21;
get_skill_exp(89044) -> 42;
get_skill_exp(89045) -> 85;
get_skill_exp(89046) -> 170;
get_skill_exp(89047) -> 341;
get_skill_exp(89048) -> 682;
get_skill_exp(89049) -> 683;
get_skill_exp(89050) -> 2;
get_skill_exp(89051) -> 5;
get_skill_exp(89052) -> 10;
get_skill_exp(89053) -> 21;
get_skill_exp(89054) -> 42;
get_skill_exp(89055) -> 85;
get_skill_exp(89056) -> 170;
get_skill_exp(89057) -> 341;
get_skill_exp(89058) -> 682;
get_skill_exp(89059) -> 683;
get_skill_exp(89060) -> 2;
get_skill_exp(89061) -> 5;
get_skill_exp(89062) -> 10;
get_skill_exp(89063) -> 21;
get_skill_exp(89064) -> 42;
get_skill_exp(89065) -> 85;
get_skill_exp(89066) -> 170;
get_skill_exp(89067) -> 341;
get_skill_exp(89068) -> 682;
get_skill_exp(89069) -> 683;
get_skill_exp(89100) -> 2;
get_skill_exp(89101) -> 5;
get_skill_exp(89102) -> 11;
get_skill_exp(89103) -> 23;
get_skill_exp(89104) -> 46;
get_skill_exp(89105) -> 93;
get_skill_exp(89106) -> 187;
get_skill_exp(89107) -> 375;
get_skill_exp(89108) -> 750;
get_skill_exp(89109) -> 755;
get_skill_exp(89110) -> 2;
get_skill_exp(89111) -> 5;
get_skill_exp(89112) -> 11;
get_skill_exp(89113) -> 23;
get_skill_exp(89114) -> 46;
get_skill_exp(89115) -> 93;
get_skill_exp(89116) -> 187;
get_skill_exp(89117) -> 375;
get_skill_exp(89118) -> 750;
get_skill_exp(89119) -> 755;
get_skill_exp(89120) -> 2;
get_skill_exp(89121) -> 5;
get_skill_exp(89122) -> 11;
get_skill_exp(89123) -> 23;
get_skill_exp(89124) -> 46;
get_skill_exp(89125) -> 93;
get_skill_exp(89126) -> 187;
get_skill_exp(89127) -> 375;
get_skill_exp(89128) -> 750;
get_skill_exp(89129) -> 755;
get_skill_exp(89130) -> 2;
get_skill_exp(89131) -> 5;
get_skill_exp(89132) -> 11;
get_skill_exp(89133) -> 23;
get_skill_exp(89134) -> 46;
get_skill_exp(89135) -> 93;
get_skill_exp(89136) -> 187;
get_skill_exp(89137) -> 375;
get_skill_exp(89138) -> 750;
get_skill_exp(89139) -> 755;
get_skill_exp(89140) -> 2;
get_skill_exp(89141) -> 5;
get_skill_exp(89142) -> 11;
get_skill_exp(89143) -> 23;
get_skill_exp(89144) -> 46;
get_skill_exp(89145) -> 93;
get_skill_exp(89146) -> 187;
get_skill_exp(89147) -> 375;
get_skill_exp(89148) -> 750;
get_skill_exp(89149) -> 755;
get_skill_exp(89150) -> 2;
get_skill_exp(89151) -> 5;
get_skill_exp(89152) -> 11;
get_skill_exp(89153) -> 23;
get_skill_exp(89154) -> 46;
get_skill_exp(89155) -> 93;
get_skill_exp(89156) -> 187;
get_skill_exp(89157) -> 375;
get_skill_exp(89158) -> 750;
get_skill_exp(89159) -> 755;
get_skill_exp(89160) -> 2;
get_skill_exp(89161) -> 5;
get_skill_exp(89162) -> 11;
get_skill_exp(89163) -> 23;
get_skill_exp(89164) -> 46;
get_skill_exp(89165) -> 93;
get_skill_exp(89166) -> 187;
get_skill_exp(89167) -> 375;
get_skill_exp(89168) -> 750;
get_skill_exp(89169) -> 755;
get_skill_exp(89200) -> 3;
get_skill_exp(89201) -> 7;
get_skill_exp(89202) -> 14;
get_skill_exp(89203) -> 30;
get_skill_exp(89204) -> 60;
get_skill_exp(89205) -> 121;
get_skill_exp(89206) -> 243;
get_skill_exp(89207) -> 487;
get_skill_exp(89208) -> 975;
get_skill_exp(89209) -> 1200;
get_skill_exp(89210) -> 3;
get_skill_exp(89211) -> 7;
get_skill_exp(89212) -> 14;
get_skill_exp(89213) -> 30;
get_skill_exp(89214) -> 60;
get_skill_exp(89215) -> 121;
get_skill_exp(89216) -> 243;
get_skill_exp(89217) -> 487;
get_skill_exp(89218) -> 975;
get_skill_exp(89219) -> 1200;
get_skill_exp(89220) -> 3;
get_skill_exp(89221) -> 7;
get_skill_exp(89222) -> 14;
get_skill_exp(89223) -> 30;
get_skill_exp(89224) -> 60;
get_skill_exp(89225) -> 121;
get_skill_exp(89226) -> 243;
get_skill_exp(89227) -> 487;
get_skill_exp(89228) -> 975;
get_skill_exp(89229) -> 1200;
get_skill_exp(89230) -> 3;
get_skill_exp(89231) -> 7;
get_skill_exp(89232) -> 14;
get_skill_exp(89233) -> 30;
get_skill_exp(89234) -> 60;
get_skill_exp(89235) -> 121;
get_skill_exp(89236) -> 243;
get_skill_exp(89237) -> 487;
get_skill_exp(89238) -> 975;
get_skill_exp(89239) -> 1200;
get_skill_exp(89240) -> 3;
get_skill_exp(89241) -> 7;
get_skill_exp(89242) -> 14;
get_skill_exp(89243) -> 30;
get_skill_exp(89244) -> 60;
get_skill_exp(89245) -> 121;
get_skill_exp(89246) -> 243;
get_skill_exp(89247) -> 487;
get_skill_exp(89248) -> 975;
get_skill_exp(89249) -> 1200;
get_skill_exp(89250) -> 3;
get_skill_exp(89251) -> 7;
get_skill_exp(89252) -> 14;
get_skill_exp(89253) -> 30;
get_skill_exp(89254) -> 60;
get_skill_exp(89255) -> 121;
get_skill_exp(89256) -> 243;
get_skill_exp(89257) -> 487;
get_skill_exp(89258) -> 975;
get_skill_exp(89259) -> 1200;
get_skill_exp(89260) -> 3;
get_skill_exp(89261) -> 7;
get_skill_exp(89262) -> 14;
get_skill_exp(89263) -> 30;
get_skill_exp(89264) -> 60;
get_skill_exp(89265) -> 121;
get_skill_exp(89266) -> 243;
get_skill_exp(89267) -> 487;
get_skill_exp(89268) -> 975;
get_skill_exp(89269) -> 1200;
get_skill_exp(89300) -> 4;
get_skill_exp(89301) -> 10;
get_skill_exp(89302) -> 20;
get_skill_exp(89303) -> 42;
get_skill_exp(89304) -> 84;
get_skill_exp(89305) -> 170;
get_skill_exp(89306) -> 340;
get_skill_exp(89307) -> 682;
get_skill_exp(89308) -> 1365;
get_skill_exp(89309) -> 1800;
get_skill_exp(89310) -> 4;
get_skill_exp(89311) -> 10;
get_skill_exp(89312) -> 20;
get_skill_exp(89313) -> 42;
get_skill_exp(89314) -> 84;
get_skill_exp(89315) -> 170;
get_skill_exp(89316) -> 340;
get_skill_exp(89317) -> 682;
get_skill_exp(89318) -> 1365;
get_skill_exp(89319) -> 1800;
get_skill_exp(89320) -> 4;
get_skill_exp(89321) -> 10;
get_skill_exp(89322) -> 20;
get_skill_exp(89323) -> 42;
get_skill_exp(89324) -> 84;
get_skill_exp(89325) -> 170;
get_skill_exp(89326) -> 340;
get_skill_exp(89327) -> 682;
get_skill_exp(89328) -> 1365;
get_skill_exp(89329) -> 1800;
get_skill_exp(89330) -> 4;
get_skill_exp(89331) -> 10;
get_skill_exp(89332) -> 20;
get_skill_exp(89333) -> 42;
get_skill_exp(89334) -> 84;
get_skill_exp(89335) -> 170;
get_skill_exp(89336) -> 340;
get_skill_exp(89337) -> 682;
get_skill_exp(89338) -> 1365;
get_skill_exp(89339) -> 1800;
get_skill_exp(89340) -> 4;
get_skill_exp(89341) -> 10;
get_skill_exp(89342) -> 20;
get_skill_exp(89343) -> 42;
get_skill_exp(89344) -> 84;
get_skill_exp(89345) -> 170;
get_skill_exp(89346) -> 340;
get_skill_exp(89347) -> 682;
get_skill_exp(89348) -> 1365;
get_skill_exp(89349) -> 1800;
get_skill_exp(89350) -> 4;
get_skill_exp(89351) -> 10;
get_skill_exp(89352) -> 20;
get_skill_exp(89353) -> 42;
get_skill_exp(89354) -> 84;
get_skill_exp(89355) -> 170;
get_skill_exp(89356) -> 340;
get_skill_exp(89357) -> 682;
get_skill_exp(89358) -> 1365;
get_skill_exp(89359) -> 1800;
get_skill_exp(89360) -> 4;
get_skill_exp(89361) -> 10;
get_skill_exp(89362) -> 20;
get_skill_exp(89363) -> 42;
get_skill_exp(89364) -> 84;
get_skill_exp(89365) -> 170;
get_skill_exp(89366) -> 340;
get_skill_exp(89367) -> 682;
get_skill_exp(89368) -> 1365;
get_skill_exp(89369) -> 1800;
get_skill_exp(89400) -> 6;
get_skill_exp(89401) -> 15;
get_skill_exp(89402) -> 30;
get_skill_exp(89403) -> 63;
get_skill_exp(89404) -> 126;
get_skill_exp(89405) -> 255;
get_skill_exp(89406) -> 510;
get_skill_exp(89407) -> 1024;
get_skill_exp(89408) -> 2048;
get_skill_exp(89409) -> 2500;
get_skill_exp(89410) -> 6;
get_skill_exp(89411) -> 15;
get_skill_exp(89412) -> 30;
get_skill_exp(89413) -> 63;
get_skill_exp(89414) -> 126;
get_skill_exp(89415) -> 255;
get_skill_exp(89416) -> 510;
get_skill_exp(89417) -> 1024;
get_skill_exp(89418) -> 2048;
get_skill_exp(89419) -> 2500;
get_skill_exp(89420) -> 6;
get_skill_exp(89421) -> 15;
get_skill_exp(89422) -> 30;
get_skill_exp(89423) -> 63;
get_skill_exp(89424) -> 126;
get_skill_exp(89425) -> 255;
get_skill_exp(89426) -> 510;
get_skill_exp(89427) -> 1024;
get_skill_exp(89428) -> 2048;
get_skill_exp(89429) -> 2500;
get_skill_exp(89430) -> 6;
get_skill_exp(89431) -> 15;
get_skill_exp(89432) -> 30;
get_skill_exp(89433) -> 63;
get_skill_exp(89434) -> 126;
get_skill_exp(89435) -> 255;
get_skill_exp(89436) -> 510;
get_skill_exp(89437) -> 1024;
get_skill_exp(89438) -> 2048;
get_skill_exp(89439) -> 2500;
get_skill_exp(89440) -> 6;
get_skill_exp(89441) -> 15;
get_skill_exp(89442) -> 30;
get_skill_exp(89443) -> 63;
get_skill_exp(89444) -> 126;
get_skill_exp(89445) -> 255;
get_skill_exp(89446) -> 510;
get_skill_exp(89447) -> 1024;
get_skill_exp(89448) -> 2048;
get_skill_exp(89449) -> 2500;
get_skill_exp(89450) -> 6;
get_skill_exp(89451) -> 15;
get_skill_exp(89452) -> 30;
get_skill_exp(89453) -> 63;
get_skill_exp(89454) -> 126;
get_skill_exp(89455) -> 255;
get_skill_exp(89456) -> 510;
get_skill_exp(89457) -> 1024;
get_skill_exp(89458) -> 2048;
get_skill_exp(89459) -> 2500;
get_skill_exp(89460) -> 6;
get_skill_exp(89461) -> 15;
get_skill_exp(89462) -> 30;
get_skill_exp(89463) -> 63;
get_skill_exp(89464) -> 126;
get_skill_exp(89465) -> 255;
get_skill_exp(89466) -> 510;
get_skill_exp(89467) -> 1024;
get_skill_exp(89468) -> 2048;
get_skill_exp(89469) -> 2500;
get_skill_exp(_) -> 999999999.

%% 根据技能ID获取技能信息，返回#demon_skill{} | false
%% 战斗映射参数:
%% 角色技能：{c_skill, TargetNum, Cd, Args, Buffs}
%% 宠物技能：{pet_skill, Args, BuffSelf, BuffTarget, Cd}
get_skill(86000) ->
    #demon_skill{
        id = 86000
        ,name = <<"初级金系攻击">>
        ,type = 1
        ,step = 1
        ,craft = 1
        ,exp = 2
        ,next_id = 86001
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 86000, 1, 1, [5,0,950], []}
    };
get_skill(86001) ->
    #demon_skill{
        id = 86001
        ,name = <<"初级金系攻击">>
        ,type = 1
        ,step = 2
        ,craft = 1
        ,exp = 5
        ,next_id = 86002
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 86001, 1, 1, [7,0,1100], []}
    };
get_skill(86002) ->
    #demon_skill{
        id = 86002
        ,name = <<"初级金系攻击">>
        ,type = 1
        ,step = 3
        ,craft = 1
        ,exp = 10
        ,next_id = 86003
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 86002, 1, 1, [9,0,1250], []}
    };
get_skill(86003) ->
    #demon_skill{
        id = 86003
        ,name = <<"初级金系攻击">>
        ,type = 1
        ,step = 4
        ,craft = 1
        ,exp = 21
        ,next_id = 86004
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 86003, 1, 1, [11,0,1400], []}
    };
get_skill(86004) ->
    #demon_skill{
        id = 86004
        ,name = <<"初级金系攻击">>
        ,type = 1
        ,step = 5
        ,craft = 1
        ,exp = 42
        ,next_id = 86005
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 86004, 1, 1, [13,0,1550], []}
    };
get_skill(86005) ->
    #demon_skill{
        id = 86005
        ,name = <<"初级金系攻击">>
        ,type = 1
        ,step = 6
        ,craft = 1
        ,exp = 85
        ,next_id = 86006
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 86005, 1, 1, [15,0,1700], []}
    };
get_skill(86006) ->
    #demon_skill{
        id = 86006
        ,name = <<"初级金系攻击">>
        ,type = 1
        ,step = 7
        ,craft = 1
        ,exp = 170
        ,next_id = 86007
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 86006, 1, 1, [17,0,1850], []}
    };
get_skill(86007) ->
    #demon_skill{
        id = 86007
        ,name = <<"初级金系攻击">>
        ,type = 1
        ,step = 8
        ,craft = 1
        ,exp = 341
        ,next_id = 86008
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 86007, 1, 1, [19,0,2000], []}
    };
get_skill(86008) ->
    #demon_skill{
        id = 86008
        ,name = <<"初级金系攻击">>
        ,type = 1
        ,step = 9
        ,craft = 1
        ,exp = 682
        ,next_id = 86009
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 86008, 1, 1, [21,0,2150], []}
    };
get_skill(86009) ->
    #demon_skill{
        id = 86009
        ,name = <<"初级金系攻击">>
        ,type = 1
        ,step = 10
        ,craft = 1
        ,exp = 683
        ,next_id = 0
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 86009, 1, 1, [23,0,2300], []}
    };
get_skill(86100) ->
    #demon_skill{
        id = 86100
        ,name = <<"初级木系攻击">>
        ,type = 2
        ,step = 1
        ,craft = 1
        ,exp = 2
        ,next_id = 86101
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 86100, 1, 1, [5,0,950], []}
    };
get_skill(86101) ->
    #demon_skill{
        id = 86101
        ,name = <<"初级木系攻击">>
        ,type = 2
        ,step = 2
        ,craft = 1
        ,exp = 5
        ,next_id = 86102
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 86101, 1, 1, [7,0,1100], []}
    };
get_skill(86102) ->
    #demon_skill{
        id = 86102
        ,name = <<"初级木系攻击">>
        ,type = 2
        ,step = 3
        ,craft = 1
        ,exp = 10
        ,next_id = 86103
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 86102, 1, 1, [9,0,1250], []}
    };
get_skill(86103) ->
    #demon_skill{
        id = 86103
        ,name = <<"初级木系攻击">>
        ,type = 2
        ,step = 4
        ,craft = 1
        ,exp = 21
        ,next_id = 86104
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 86103, 1, 1, [11,0,1400], []}
    };
get_skill(86104) ->
    #demon_skill{
        id = 86104
        ,name = <<"初级木系攻击">>
        ,type = 2
        ,step = 5
        ,craft = 1
        ,exp = 42
        ,next_id = 86105
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 86104, 1, 1, [13,0,1550], []}
    };
get_skill(86105) ->
    #demon_skill{
        id = 86105
        ,name = <<"初级木系攻击">>
        ,type = 2
        ,step = 6
        ,craft = 1
        ,exp = 85
        ,next_id = 86106
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 86105, 1, 1, [15,0,1700], []}
    };
get_skill(86106) ->
    #demon_skill{
        id = 86106
        ,name = <<"初级木系攻击">>
        ,type = 2
        ,step = 7
        ,craft = 1
        ,exp = 170
        ,next_id = 86107
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 86106, 1, 1, [17,0,1850], []}
    };
get_skill(86107) ->
    #demon_skill{
        id = 86107
        ,name = <<"初级木系攻击">>
        ,type = 2
        ,step = 8
        ,craft = 1
        ,exp = 341
        ,next_id = 86108
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 86107, 1, 1, [19,0,2000], []}
    };
get_skill(86108) ->
    #demon_skill{
        id = 86108
        ,name = <<"初级木系攻击">>
        ,type = 2
        ,step = 9
        ,craft = 1
        ,exp = 682
        ,next_id = 86109
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 86108, 1, 1, [21,0,2150], []}
    };
get_skill(86109) ->
    #demon_skill{
        id = 86109
        ,name = <<"初级木系攻击">>
        ,type = 2
        ,step = 10
        ,craft = 1
        ,exp = 683
        ,next_id = 0
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 86109, 1, 1, [23,0,2300], []}
    };
get_skill(86200) ->
    #demon_skill{
        id = 86200
        ,name = <<"初级水系攻击">>
        ,type = 3
        ,step = 1
        ,craft = 1
        ,exp = 2
        ,next_id = 86201
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 86200, 1, 1, [5,0,950], []}
    };
get_skill(86201) ->
    #demon_skill{
        id = 86201
        ,name = <<"初级水系攻击">>
        ,type = 3
        ,step = 2
        ,craft = 1
        ,exp = 5
        ,next_id = 86202
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 86201, 1, 1, [7,0,1100], []}
    };
get_skill(86202) ->
    #demon_skill{
        id = 86202
        ,name = <<"初级水系攻击">>
        ,type = 3
        ,step = 3
        ,craft = 1
        ,exp = 10
        ,next_id = 86203
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 86202, 1, 1, [9,0,1250], []}
    };
get_skill(86203) ->
    #demon_skill{
        id = 86203
        ,name = <<"初级水系攻击">>
        ,type = 3
        ,step = 4
        ,craft = 1
        ,exp = 21
        ,next_id = 86204
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 86203, 1, 1, [11,0,1400], []}
    };
get_skill(86204) ->
    #demon_skill{
        id = 86204
        ,name = <<"初级水系攻击">>
        ,type = 3
        ,step = 5
        ,craft = 1
        ,exp = 42
        ,next_id = 86205
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 86204, 1, 1, [13,0,1550], []}
    };
get_skill(86205) ->
    #demon_skill{
        id = 86205
        ,name = <<"初级水系攻击">>
        ,type = 3
        ,step = 6
        ,craft = 1
        ,exp = 85
        ,next_id = 86206
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 86205, 1, 1, [15,0,1700], []}
    };
get_skill(86206) ->
    #demon_skill{
        id = 86206
        ,name = <<"初级水系攻击">>
        ,type = 3
        ,step = 7
        ,craft = 1
        ,exp = 170
        ,next_id = 86207
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 86206, 1, 1, [17,0,1850], []}
    };
get_skill(86207) ->
    #demon_skill{
        id = 86207
        ,name = <<"初级水系攻击">>
        ,type = 3
        ,step = 8
        ,craft = 1
        ,exp = 341
        ,next_id = 86208
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 86207, 1, 1, [19,0,2000], []}
    };
get_skill(86208) ->
    #demon_skill{
        id = 86208
        ,name = <<"初级水系攻击">>
        ,type = 3
        ,step = 9
        ,craft = 1
        ,exp = 682
        ,next_id = 86209
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 86208, 1, 1, [21,0,2150], []}
    };
get_skill(86209) ->
    #demon_skill{
        id = 86209
        ,name = <<"初级水系攻击">>
        ,type = 3
        ,step = 10
        ,craft = 1
        ,exp = 683
        ,next_id = 0
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 86209, 1, 1, [23,0,2300], []}
    };
get_skill(86300) ->
    #demon_skill{
        id = 86300
        ,name = <<"初级火系攻击">>
        ,type = 4
        ,step = 1
        ,craft = 1
        ,exp = 2
        ,next_id = 86301
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 86300, 1, 1, [5,0,950], []}
    };
get_skill(86301) ->
    #demon_skill{
        id = 86301
        ,name = <<"初级火系攻击">>
        ,type = 4
        ,step = 2
        ,craft = 1
        ,exp = 5
        ,next_id = 86302
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 86301, 1, 1, [7,0,1100], []}
    };
get_skill(86302) ->
    #demon_skill{
        id = 86302
        ,name = <<"初级火系攻击">>
        ,type = 4
        ,step = 3
        ,craft = 1
        ,exp = 10
        ,next_id = 86303
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 86302, 1, 1, [9,0,1250], []}
    };
get_skill(86303) ->
    #demon_skill{
        id = 86303
        ,name = <<"初级火系攻击">>
        ,type = 4
        ,step = 4
        ,craft = 1
        ,exp = 21
        ,next_id = 86304
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 86303, 1, 1, [11,0,1400], []}
    };
get_skill(86304) ->
    #demon_skill{
        id = 86304
        ,name = <<"初级火系攻击">>
        ,type = 4
        ,step = 5
        ,craft = 1
        ,exp = 42
        ,next_id = 86305
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 86304, 1, 1, [13,0,1550], []}
    };
get_skill(86305) ->
    #demon_skill{
        id = 86305
        ,name = <<"初级火系攻击">>
        ,type = 4
        ,step = 6
        ,craft = 1
        ,exp = 85
        ,next_id = 86306
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 86305, 1, 1, [15,0,1700], []}
    };
get_skill(86306) ->
    #demon_skill{
        id = 86306
        ,name = <<"初级火系攻击">>
        ,type = 4
        ,step = 7
        ,craft = 1
        ,exp = 170
        ,next_id = 86307
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 86306, 1, 1, [17,0,1850], []}
    };
get_skill(86307) ->
    #demon_skill{
        id = 86307
        ,name = <<"初级火系攻击">>
        ,type = 4
        ,step = 8
        ,craft = 1
        ,exp = 341
        ,next_id = 86308
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 86307, 1, 1, [19,0,2000], []}
    };
get_skill(86308) ->
    #demon_skill{
        id = 86308
        ,name = <<"初级火系攻击">>
        ,type = 4
        ,step = 9
        ,craft = 1
        ,exp = 682
        ,next_id = 86309
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 86308, 1, 1, [21,0,2150], []}
    };
get_skill(86309) ->
    #demon_skill{
        id = 86309
        ,name = <<"初级火系攻击">>
        ,type = 4
        ,step = 10
        ,craft = 1
        ,exp = 683
        ,next_id = 0
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 86309, 1, 1, [23,0,2300], []}
    };
get_skill(86400) ->
    #demon_skill{
        id = 86400
        ,name = <<"初级土系攻击">>
        ,type = 5
        ,step = 1
        ,craft = 1
        ,exp = 2
        ,next_id = 86401
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 86400, 1, 1, [5,0,950], []}
    };
get_skill(86401) ->
    #demon_skill{
        id = 86401
        ,name = <<"初级土系攻击">>
        ,type = 5
        ,step = 2
        ,craft = 1
        ,exp = 5
        ,next_id = 86402
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 86401, 1, 1, [7,0,1100], []}
    };
get_skill(86402) ->
    #demon_skill{
        id = 86402
        ,name = <<"初级土系攻击">>
        ,type = 5
        ,step = 3
        ,craft = 1
        ,exp = 10
        ,next_id = 86403
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 86402, 1, 1, [9,0,1250], []}
    };
get_skill(86403) ->
    #demon_skill{
        id = 86403
        ,name = <<"初级土系攻击">>
        ,type = 5
        ,step = 4
        ,craft = 1
        ,exp = 21
        ,next_id = 86404
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 86403, 1, 1, [11,0,1400], []}
    };
get_skill(86404) ->
    #demon_skill{
        id = 86404
        ,name = <<"初级土系攻击">>
        ,type = 5
        ,step = 5
        ,craft = 1
        ,exp = 42
        ,next_id = 86405
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 86404, 1, 1, [13,0,1550], []}
    };
get_skill(86405) ->
    #demon_skill{
        id = 86405
        ,name = <<"初级土系攻击">>
        ,type = 5
        ,step = 6
        ,craft = 1
        ,exp = 85
        ,next_id = 86406
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 86405, 1, 1, [15,0,1700], []}
    };
get_skill(86406) ->
    #demon_skill{
        id = 86406
        ,name = <<"初级土系攻击">>
        ,type = 5
        ,step = 7
        ,craft = 1
        ,exp = 170
        ,next_id = 86407
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 86406, 1, 1, [17,0,1850], []}
    };
get_skill(86407) ->
    #demon_skill{
        id = 86407
        ,name = <<"初级土系攻击">>
        ,type = 5
        ,step = 8
        ,craft = 1
        ,exp = 341
        ,next_id = 86408
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 86407, 1, 1, [19,0,2000], []}
    };
get_skill(86408) ->
    #demon_skill{
        id = 86408
        ,name = <<"初级土系攻击">>
        ,type = 5
        ,step = 9
        ,craft = 1
        ,exp = 682
        ,next_id = 86409
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 86408, 1, 1, [21,0,2150], []}
    };
get_skill(86409) ->
    #demon_skill{
        id = 86409
        ,name = <<"初级土系攻击">>
        ,type = 5
        ,step = 10
        ,craft = 1
        ,exp = 683
        ,next_id = 0
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 86409, 1, 1, [23,0,2300], []}
    };
get_skill(86500) ->
    #demon_skill{
        id = 86500
        ,name = <<"初级法伤吸收">>
        ,type = 6
        ,step = 1
        ,craft = 1
        ,exp = 2
        ,next_id = 86501
        ,limit = []
        ,combat_info = {c_skill, 86500, 1, 1, [5,0,750], []}
    };
get_skill(86501) ->
    #demon_skill{
        id = 86501
        ,name = <<"初级法伤吸收">>
        ,type = 6
        ,step = 2
        ,craft = 1
        ,exp = 5
        ,next_id = 86502
        ,limit = []
        ,combat_info = {c_skill, 86501, 1, 1, [7,0,850], []}
    };
get_skill(86502) ->
    #demon_skill{
        id = 86502
        ,name = <<"初级法伤吸收">>
        ,type = 6
        ,step = 3
        ,craft = 1
        ,exp = 10
        ,next_id = 86503
        ,limit = []
        ,combat_info = {c_skill, 86502, 1, 1, [9,0,950], []}
    };
get_skill(86503) ->
    #demon_skill{
        id = 86503
        ,name = <<"初级法伤吸收">>
        ,type = 6
        ,step = 4
        ,craft = 1
        ,exp = 21
        ,next_id = 86504
        ,limit = []
        ,combat_info = {c_skill, 86503, 1, 1, [11,0,1050], []}
    };
get_skill(86504) ->
    #demon_skill{
        id = 86504
        ,name = <<"初级法伤吸收">>
        ,type = 6
        ,step = 5
        ,craft = 1
        ,exp = 42
        ,next_id = 86505
        ,limit = []
        ,combat_info = {c_skill, 86504, 1, 1, [13,0,1150], []}
    };
get_skill(86505) ->
    #demon_skill{
        id = 86505
        ,name = <<"初级法伤吸收">>
        ,type = 6
        ,step = 6
        ,craft = 1
        ,exp = 85
        ,next_id = 86506
        ,limit = []
        ,combat_info = {c_skill, 86505, 1, 1, [15,0,1250], []}
    };
get_skill(86506) ->
    #demon_skill{
        id = 86506
        ,name = <<"初级法伤吸收">>
        ,type = 6
        ,step = 7
        ,craft = 1
        ,exp = 170
        ,next_id = 86507
        ,limit = []
        ,combat_info = {c_skill, 86506, 1, 1, [17,0,1350], []}
    };
get_skill(86507) ->
    #demon_skill{
        id = 86507
        ,name = <<"初级法伤吸收">>
        ,type = 6
        ,step = 8
        ,craft = 1
        ,exp = 341
        ,next_id = 86508
        ,limit = []
        ,combat_info = {c_skill, 86507, 1, 1, [19,0,1450], []}
    };
get_skill(86508) ->
    #demon_skill{
        id = 86508
        ,name = <<"初级法伤吸收">>
        ,type = 6
        ,step = 9
        ,craft = 1
        ,exp = 682
        ,next_id = 86509
        ,limit = []
        ,combat_info = {c_skill, 86508, 1, 1, [21,0,1550], []}
    };
get_skill(86509) ->
    #demon_skill{
        id = 86509
        ,name = <<"初级法伤吸收">>
        ,type = 6
        ,step = 10
        ,craft = 1
        ,exp = 683
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 86509, 1, 1, [23,0,1650], []}
    };
get_skill(86600) ->
    #demon_skill{
        id = 86600
        ,name = <<"初级伤害抵抗">>
        ,type = 7
        ,step = 1
        ,craft = 1
        ,exp = 2
        ,next_id = 86601
        ,limit = []
        ,combat_info = {c_skill, 86600, 1, 1, [5,10,0], []}
    };
get_skill(86601) ->
    #demon_skill{
        id = 86601
        ,name = <<"初级伤害抵抗">>
        ,type = 7
        ,step = 2
        ,craft = 1
        ,exp = 5
        ,next_id = 86602
        ,limit = []
        ,combat_info = {c_skill, 86601, 1, 1, [7,11,0], []}
    };
get_skill(86602) ->
    #demon_skill{
        id = 86602
        ,name = <<"初级伤害抵抗">>
        ,type = 7
        ,step = 3
        ,craft = 1
        ,exp = 10
        ,next_id = 86603
        ,limit = []
        ,combat_info = {c_skill, 86602, 1, 1, [9,12,0], []}
    };
get_skill(86603) ->
    #demon_skill{
        id = 86603
        ,name = <<"初级伤害抵抗">>
        ,type = 7
        ,step = 4
        ,craft = 1
        ,exp = 21
        ,next_id = 86604
        ,limit = []
        ,combat_info = {c_skill, 86603, 1, 1, [11,13,0], []}
    };
get_skill(86604) ->
    #demon_skill{
        id = 86604
        ,name = <<"初级伤害抵抗">>
        ,type = 7
        ,step = 5
        ,craft = 1
        ,exp = 42
        ,next_id = 86605
        ,limit = []
        ,combat_info = {c_skill, 86604, 1, 1, [13,14,0], []}
    };
get_skill(86605) ->
    #demon_skill{
        id = 86605
        ,name = <<"初级伤害抵抗">>
        ,type = 7
        ,step = 6
        ,craft = 1
        ,exp = 85
        ,next_id = 86606
        ,limit = []
        ,combat_info = {c_skill, 86605, 1, 1, [15,15,0], []}
    };
get_skill(86606) ->
    #demon_skill{
        id = 86606
        ,name = <<"初级伤害抵抗">>
        ,type = 7
        ,step = 7
        ,craft = 1
        ,exp = 170
        ,next_id = 86607
        ,limit = []
        ,combat_info = {c_skill, 86606, 1, 1, [17,16,0], []}
    };
get_skill(86607) ->
    #demon_skill{
        id = 86607
        ,name = <<"初级伤害抵抗">>
        ,type = 7
        ,step = 8
        ,craft = 1
        ,exp = 341
        ,next_id = 86608
        ,limit = []
        ,combat_info = {c_skill, 86607, 1, 1, [19,17,0], []}
    };
get_skill(86608) ->
    #demon_skill{
        id = 86608
        ,name = <<"初级伤害抵抗">>
        ,type = 7
        ,step = 9
        ,craft = 1
        ,exp = 682
        ,next_id = 86609
        ,limit = []
        ,combat_info = {c_skill, 86608, 1, 1, [21,18,0], []}
    };
get_skill(86609) ->
    #demon_skill{
        id = 86609
        ,name = <<"初级伤害抵抗">>
        ,type = 7
        ,step = 10
        ,craft = 1
        ,exp = 683
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 86609, 1, 1, [23,19,0], []}
    };
get_skill(86900) ->
    #demon_skill{
        id = 86900
        ,name = <<"初级灵动">>
        ,type = 15
        ,step = 1
        ,craft = 1
        ,exp = 2
        ,next_id = 86901
        ,limit = []
        ,combat_info = {c_skill, 86900, 1, 1, [5], []}
    };
get_skill(86901) ->
    #demon_skill{
        id = 86901
        ,name = <<"初级灵动">>
        ,type = 15
        ,step = 2
        ,craft = 1
        ,exp = 5
        ,next_id = 86902
        ,limit = []
        ,combat_info = {c_skill, 86901, 1, 1, [10], []}
    };
get_skill(86902) ->
    #demon_skill{
        id = 86902
        ,name = <<"初级灵动">>
        ,type = 15
        ,step = 3
        ,craft = 1
        ,exp = 10
        ,next_id = 86903
        ,limit = []
        ,combat_info = {c_skill, 86902, 1, 1, [15], []}
    };
get_skill(86903) ->
    #demon_skill{
        id = 86903
        ,name = <<"初级灵动">>
        ,type = 15
        ,step = 4
        ,craft = 1
        ,exp = 21
        ,next_id = 86904
        ,limit = []
        ,combat_info = {c_skill, 86903, 1, 1, [20], []}
    };
get_skill(86904) ->
    #demon_skill{
        id = 86904
        ,name = <<"初级灵动">>
        ,type = 15
        ,step = 5
        ,craft = 1
        ,exp = 42
        ,next_id = 86905
        ,limit = []
        ,combat_info = {c_skill, 86904, 1, 1, [25], []}
    };
get_skill(86905) ->
    #demon_skill{
        id = 86905
        ,name = <<"初级灵动">>
        ,type = 15
        ,step = 6
        ,craft = 1
        ,exp = 85
        ,next_id = 86906
        ,limit = []
        ,combat_info = {c_skill, 86905, 1, 1, [30], []}
    };
get_skill(86906) ->
    #demon_skill{
        id = 86906
        ,name = <<"初级灵动">>
        ,type = 15
        ,step = 7
        ,craft = 1
        ,exp = 170
        ,next_id = 86907
        ,limit = []
        ,combat_info = {c_skill, 86906, 1, 1, [35], []}
    };
get_skill(86907) ->
    #demon_skill{
        id = 86907
        ,name = <<"初级灵动">>
        ,type = 15
        ,step = 8
        ,craft = 1
        ,exp = 341
        ,next_id = 86908
        ,limit = []
        ,combat_info = {c_skill, 86907, 1, 1, [40], []}
    };
get_skill(86908) ->
    #demon_skill{
        id = 86908
        ,name = <<"初级灵动">>
        ,type = 15
        ,step = 9
        ,craft = 1
        ,exp = 682
        ,next_id = 86909
        ,limit = []
        ,combat_info = {c_skill, 86908, 1, 1, [45], []}
    };
get_skill(86909) ->
    #demon_skill{
        id = 86909
        ,name = <<"初级灵动">>
        ,type = 15
        ,step = 10
        ,craft = 1
        ,exp = 683
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 86909, 1, 1, [50], []}
    };
get_skill(86800) ->
    #demon_skill{
        id = 86800
        ,name = <<"初级震怒">>
        ,type = 16
        ,step = 1
        ,craft = 1
        ,exp = 2
        ,next_id = 86801
        ,limit = []
        ,combat_info = {c_skill, 86800, 1, 1, [200], []}
    };
get_skill(86801) ->
    #demon_skill{
        id = 86801
        ,name = <<"初级震怒">>
        ,type = 16
        ,step = 2
        ,craft = 1
        ,exp = 5
        ,next_id = 86802
        ,limit = []
        ,combat_info = {c_skill, 86801, 1, 1, [210], []}
    };
get_skill(86802) ->
    #demon_skill{
        id = 86802
        ,name = <<"初级震怒">>
        ,type = 16
        ,step = 3
        ,craft = 1
        ,exp = 10
        ,next_id = 86803
        ,limit = []
        ,combat_info = {c_skill, 86802, 1, 1, [220], []}
    };
get_skill(86803) ->
    #demon_skill{
        id = 86803
        ,name = <<"初级震怒">>
        ,type = 16
        ,step = 4
        ,craft = 1
        ,exp = 21
        ,next_id = 86804
        ,limit = []
        ,combat_info = {c_skill, 86803, 1, 1, [230], []}
    };
get_skill(86804) ->
    #demon_skill{
        id = 86804
        ,name = <<"初级震怒">>
        ,type = 16
        ,step = 5
        ,craft = 1
        ,exp = 42
        ,next_id = 86805
        ,limit = []
        ,combat_info = {c_skill, 86804, 1, 1, [240], []}
    };
get_skill(86805) ->
    #demon_skill{
        id = 86805
        ,name = <<"初级震怒">>
        ,type = 16
        ,step = 6
        ,craft = 1
        ,exp = 85
        ,next_id = 86806
        ,limit = []
        ,combat_info = {c_skill, 86805, 1, 1, [250], []}
    };
get_skill(86806) ->
    #demon_skill{
        id = 86806
        ,name = <<"初级震怒">>
        ,type = 16
        ,step = 7
        ,craft = 1
        ,exp = 170
        ,next_id = 86807
        ,limit = []
        ,combat_info = {c_skill, 86806, 1, 1, [260], []}
    };
get_skill(86807) ->
    #demon_skill{
        id = 86807
        ,name = <<"初级震怒">>
        ,type = 16
        ,step = 8
        ,craft = 1
        ,exp = 341
        ,next_id = 86808
        ,limit = []
        ,combat_info = {c_skill, 86807, 1, 1, [270], []}
    };
get_skill(86808) ->
    #demon_skill{
        id = 86808
        ,name = <<"初级震怒">>
        ,type = 16
        ,step = 9
        ,craft = 1
        ,exp = 682
        ,next_id = 86809
        ,limit = []
        ,combat_info = {c_skill, 86808, 1, 1, [280], []}
    };
get_skill(86809) ->
    #demon_skill{
        id = 86809
        ,name = <<"初级震怒">>
        ,type = 16
        ,step = 10
        ,craft = 1
        ,exp = 683
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 86809, 1, 1, [290], []}
    };
get_skill(85000) ->
    #demon_skill{
        id = 85000
        ,name = <<"中级金系攻击">>
        ,type = 1
        ,step = 1
        ,craft = 2
        ,exp = 2
        ,next_id = 85001
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 85000, 1, 1, [5,0,1350], []}
    };
get_skill(85001) ->
    #demon_skill{
        id = 85001
        ,name = <<"中级金系攻击">>
        ,type = 1
        ,step = 2
        ,craft = 2
        ,exp = 5
        ,next_id = 85002
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 85000, 1, 1, [7,0,1500], []}
    };
get_skill(85002) ->
    #demon_skill{
        id = 85002
        ,name = <<"中级金系攻击">>
        ,type = 1
        ,step = 3
        ,craft = 2
        ,exp = 11
        ,next_id = 85003
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 85000, 1, 1, [9,0,1650], []}
    };
get_skill(85003) ->
    #demon_skill{
        id = 85003
        ,name = <<"中级金系攻击">>
        ,type = 1
        ,step = 4
        ,craft = 2
        ,exp = 23
        ,next_id = 85004
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 85000, 1, 1, [11,0,1800], []}
    };
get_skill(85004) ->
    #demon_skill{
        id = 85004
        ,name = <<"中级金系攻击">>
        ,type = 1
        ,step = 5
        ,craft = 2
        ,exp = 46
        ,next_id = 85005
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 85000, 1, 1, [13,0,1950], []}
    };
get_skill(85005) ->
    #demon_skill{
        id = 85005
        ,name = <<"中级金系攻击">>
        ,type = 1
        ,step = 6
        ,craft = 2
        ,exp = 93
        ,next_id = 85006
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 85000, 1, 1, [15,0,2100], []}
    };
get_skill(85006) ->
    #demon_skill{
        id = 85006
        ,name = <<"中级金系攻击">>
        ,type = 1
        ,step = 7
        ,craft = 2
        ,exp = 187
        ,next_id = 85007
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 85000, 1, 1, [17,0,2250], []}
    };
get_skill(85007) ->
    #demon_skill{
        id = 85007
        ,name = <<"中级金系攻击">>
        ,type = 1
        ,step = 8
        ,craft = 2
        ,exp = 375
        ,next_id = 85008
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 85000, 1, 1, [19,0,2400], []}
    };
get_skill(85008) ->
    #demon_skill{
        id = 85008
        ,name = <<"中级金系攻击">>
        ,type = 1
        ,step = 9
        ,craft = 2
        ,exp = 750
        ,next_id = 85009
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 85000, 1, 1, [21,0,2550], []}
    };
get_skill(85009) ->
    #demon_skill{
        id = 85009
        ,name = <<"中级金系攻击">>
        ,type = 1
        ,step = 10
        ,craft = 2
        ,exp = 755
        ,next_id = 0
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 85000, 1, 1, [23,0,2700], []}
    };
get_skill(85100) ->
    #demon_skill{
        id = 85100
        ,name = <<"中级木系攻击">>
        ,type = 2
        ,step = 1
        ,craft = 2
        ,exp = 2
        ,next_id = 85101
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 85100, 1, 1, [5,0,1350], []}
    };
get_skill(85101) ->
    #demon_skill{
        id = 85101
        ,name = <<"中级木系攻击">>
        ,type = 2
        ,step = 2
        ,craft = 2
        ,exp = 5
        ,next_id = 85102
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 85100, 1, 1, [7,0,1500], []}
    };
get_skill(85102) ->
    #demon_skill{
        id = 85102
        ,name = <<"中级木系攻击">>
        ,type = 2
        ,step = 3
        ,craft = 2
        ,exp = 11
        ,next_id = 85103
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 85100, 1, 1, [9,0,1650], []}
    };
get_skill(85103) ->
    #demon_skill{
        id = 85103
        ,name = <<"中级木系攻击">>
        ,type = 2
        ,step = 4
        ,craft = 2
        ,exp = 23
        ,next_id = 85104
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 85100, 1, 1, [11,0,1800], []}
    };
get_skill(85104) ->
    #demon_skill{
        id = 85104
        ,name = <<"中级木系攻击">>
        ,type = 2
        ,step = 5
        ,craft = 2
        ,exp = 46
        ,next_id = 85105
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 85100, 1, 1, [13,0,1950], []}
    };
get_skill(85105) ->
    #demon_skill{
        id = 85105
        ,name = <<"中级木系攻击">>
        ,type = 2
        ,step = 6
        ,craft = 2
        ,exp = 93
        ,next_id = 85106
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 85100, 1, 1, [15,0,2100], []}
    };
get_skill(85106) ->
    #demon_skill{
        id = 85106
        ,name = <<"中级木系攻击">>
        ,type = 2
        ,step = 7
        ,craft = 2
        ,exp = 187
        ,next_id = 85107
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 85100, 1, 1, [17,0,2250], []}
    };
get_skill(85107) ->
    #demon_skill{
        id = 85107
        ,name = <<"中级木系攻击">>
        ,type = 2
        ,step = 8
        ,craft = 2
        ,exp = 375
        ,next_id = 85108
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 85100, 1, 1, [19,0,2400], []}
    };
get_skill(85108) ->
    #demon_skill{
        id = 85108
        ,name = <<"中级木系攻击">>
        ,type = 2
        ,step = 9
        ,craft = 2
        ,exp = 750
        ,next_id = 85109
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 85100, 1, 1, [21,0,2550], []}
    };
get_skill(85109) ->
    #demon_skill{
        id = 85109
        ,name = <<"中级木系攻击">>
        ,type = 2
        ,step = 10
        ,craft = 2
        ,exp = 755
        ,next_id = 0
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 85100, 1, 1, [23,0,2700], []}
    };
get_skill(85200) ->
    #demon_skill{
        id = 85200
        ,name = <<"中级水系攻击">>
        ,type = 3
        ,step = 1
        ,craft = 2
        ,exp = 2
        ,next_id = 85201
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 85200, 1, 1, [5,0,1350], []}
    };
get_skill(85201) ->
    #demon_skill{
        id = 85201
        ,name = <<"中级水系攻击">>
        ,type = 3
        ,step = 2
        ,craft = 2
        ,exp = 5
        ,next_id = 85202
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 85200, 1, 1, [7,0,1500], []}
    };
get_skill(85202) ->
    #demon_skill{
        id = 85202
        ,name = <<"中级水系攻击">>
        ,type = 3
        ,step = 3
        ,craft = 2
        ,exp = 11
        ,next_id = 85203
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 85200, 1, 1, [9,0,1650], []}
    };
get_skill(85203) ->
    #demon_skill{
        id = 85203
        ,name = <<"中级水系攻击">>
        ,type = 3
        ,step = 4
        ,craft = 2
        ,exp = 23
        ,next_id = 85204
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 85200, 1, 1, [11,0,1800], []}
    };
get_skill(85204) ->
    #demon_skill{
        id = 85204
        ,name = <<"中级水系攻击">>
        ,type = 3
        ,step = 5
        ,craft = 2
        ,exp = 46
        ,next_id = 85205
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 85200, 1, 1, [13,0,1950], []}
    };
get_skill(85205) ->
    #demon_skill{
        id = 85205
        ,name = <<"中级水系攻击">>
        ,type = 3
        ,step = 6
        ,craft = 2
        ,exp = 93
        ,next_id = 85206
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 85200, 1, 1, [15,0,2100], []}
    };
get_skill(85206) ->
    #demon_skill{
        id = 85206
        ,name = <<"中级水系攻击">>
        ,type = 3
        ,step = 7
        ,craft = 2
        ,exp = 187
        ,next_id = 85207
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 85200, 1, 1, [17,0,2250], []}
    };
get_skill(85207) ->
    #demon_skill{
        id = 85207
        ,name = <<"中级水系攻击">>
        ,type = 3
        ,step = 8
        ,craft = 2
        ,exp = 375
        ,next_id = 85208
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 85200, 1, 1, [19,0,2400], []}
    };
get_skill(85208) ->
    #demon_skill{
        id = 85208
        ,name = <<"中级水系攻击">>
        ,type = 3
        ,step = 9
        ,craft = 2
        ,exp = 750
        ,next_id = 85209
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 85200, 1, 1, [21,0,2550], []}
    };
get_skill(85209) ->
    #demon_skill{
        id = 85209
        ,name = <<"中级水系攻击">>
        ,type = 3
        ,step = 10
        ,craft = 2
        ,exp = 755
        ,next_id = 0
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 85200, 1, 1, [23,0,2700], []}
    };
get_skill(85300) ->
    #demon_skill{
        id = 85300
        ,name = <<"中级火系攻击">>
        ,type = 4
        ,step = 1
        ,craft = 2
        ,exp = 2
        ,next_id = 85301
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 85300, 1, 1, [5,0,1350], []}
    };
get_skill(85301) ->
    #demon_skill{
        id = 85301
        ,name = <<"中级火系攻击">>
        ,type = 4
        ,step = 2
        ,craft = 2
        ,exp = 5
        ,next_id = 85302
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 85300, 1, 1, [7,0,1500], []}
    };
get_skill(85302) ->
    #demon_skill{
        id = 85302
        ,name = <<"中级火系攻击">>
        ,type = 4
        ,step = 3
        ,craft = 2
        ,exp = 11
        ,next_id = 85303
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 85300, 1, 1, [9,0,1650], []}
    };
get_skill(85303) ->
    #demon_skill{
        id = 85303
        ,name = <<"中级火系攻击">>
        ,type = 4
        ,step = 4
        ,craft = 2
        ,exp = 23
        ,next_id = 85304
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 85300, 1, 1, [11,0,1800], []}
    };
get_skill(85304) ->
    #demon_skill{
        id = 85304
        ,name = <<"中级火系攻击">>
        ,type = 4
        ,step = 5
        ,craft = 2
        ,exp = 46
        ,next_id = 85305
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 85300, 1, 1, [13,0,1950], []}
    };
get_skill(85305) ->
    #demon_skill{
        id = 85305
        ,name = <<"中级火系攻击">>
        ,type = 4
        ,step = 6
        ,craft = 2
        ,exp = 93
        ,next_id = 85306
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 85300, 1, 1, [15,0,2100], []}
    };
get_skill(85306) ->
    #demon_skill{
        id = 85306
        ,name = <<"中级火系攻击">>
        ,type = 4
        ,step = 7
        ,craft = 2
        ,exp = 187
        ,next_id = 85307
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 85300, 1, 1, [17,0,2250], []}
    };
get_skill(85307) ->
    #demon_skill{
        id = 85307
        ,name = <<"中级火系攻击">>
        ,type = 4
        ,step = 8
        ,craft = 2
        ,exp = 375
        ,next_id = 85308
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 85300, 1, 1, [19,0,2400], []}
    };
get_skill(85308) ->
    #demon_skill{
        id = 85308
        ,name = <<"中级火系攻击">>
        ,type = 4
        ,step = 9
        ,craft = 2
        ,exp = 750
        ,next_id = 85309
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 85300, 1, 1, [21,0,2550], []}
    };
get_skill(85309) ->
    #demon_skill{
        id = 85309
        ,name = <<"中级火系攻击">>
        ,type = 4
        ,step = 10
        ,craft = 2
        ,exp = 755
        ,next_id = 0
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 85300, 1, 1, [23,0,2700], []}
    };
get_skill(85400) ->
    #demon_skill{
        id = 85400
        ,name = <<"中级土系攻击">>
        ,type = 5
        ,step = 1
        ,craft = 2
        ,exp = 2
        ,next_id = 85401
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 85400, 1, 1, [5,0,1350], []}
    };
get_skill(85401) ->
    #demon_skill{
        id = 85401
        ,name = <<"中级土系攻击">>
        ,type = 5
        ,step = 2
        ,craft = 2
        ,exp = 5
        ,next_id = 85402
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 85400, 1, 1, [7,0,1500], []}
    };
get_skill(85402) ->
    #demon_skill{
        id = 85402
        ,name = <<"中级土系攻击">>
        ,type = 5
        ,step = 3
        ,craft = 2
        ,exp = 11
        ,next_id = 85403
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 85400, 1, 1, [9,0,1650], []}
    };
get_skill(85403) ->
    #demon_skill{
        id = 85403
        ,name = <<"中级土系攻击">>
        ,type = 5
        ,step = 4
        ,craft = 2
        ,exp = 23
        ,next_id = 85404
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 85400, 1, 1, [11,0,1800], []}
    };
get_skill(85404) ->
    #demon_skill{
        id = 85404
        ,name = <<"中级土系攻击">>
        ,type = 5
        ,step = 5
        ,craft = 2
        ,exp = 46
        ,next_id = 85405
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 85400, 1, 1, [13,0,1950], []}
    };
get_skill(85405) ->
    #demon_skill{
        id = 85405
        ,name = <<"中级土系攻击">>
        ,type = 5
        ,step = 6
        ,craft = 2
        ,exp = 93
        ,next_id = 85406
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 85400, 1, 1, [15,0,2100], []}
    };
get_skill(85406) ->
    #demon_skill{
        id = 85406
        ,name = <<"中级土系攻击">>
        ,type = 5
        ,step = 7
        ,craft = 2
        ,exp = 187
        ,next_id = 85407
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 85400, 1, 1, [17,0,2250], []}
    };
get_skill(85407) ->
    #demon_skill{
        id = 85407
        ,name = <<"中级土系攻击">>
        ,type = 5
        ,step = 8
        ,craft = 2
        ,exp = 375
        ,next_id = 85408
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 85400, 1, 1, [19,0,2400], []}
    };
get_skill(85408) ->
    #demon_skill{
        id = 85408
        ,name = <<"中级土系攻击">>
        ,type = 5
        ,step = 9
        ,craft = 2
        ,exp = 750
        ,next_id = 85409
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 85400, 1, 1, [21,0,2550], []}
    };
get_skill(85409) ->
    #demon_skill{
        id = 85409
        ,name = <<"中级土系攻击">>
        ,type = 5
        ,step = 10
        ,craft = 2
        ,exp = 755
        ,next_id = 0
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 85400, 1, 1, [23,0,2700], []}
    };
get_skill(85500) ->
    #demon_skill{
        id = 85500
        ,name = <<"中级法伤吸收">>
        ,type = 6
        ,step = 1
        ,craft = 2
        ,exp = 2
        ,next_id = 85501
        ,limit = []
        ,combat_info = {c_skill, 85500, 1, 1, [6,0,950], []}
    };
get_skill(85501) ->
    #demon_skill{
        id = 85501
        ,name = <<"中级法伤吸收">>
        ,type = 6
        ,step = 2
        ,craft = 2
        ,exp = 5
        ,next_id = 85502
        ,limit = []
        ,combat_info = {c_skill, 85500, 1, 1, [8,0,1050], []}
    };
get_skill(85502) ->
    #demon_skill{
        id = 85502
        ,name = <<"中级法伤吸收">>
        ,type = 6
        ,step = 3
        ,craft = 2
        ,exp = 11
        ,next_id = 85503
        ,limit = []
        ,combat_info = {c_skill, 85500, 1, 1, [10,0,1150], []}
    };
get_skill(85503) ->
    #demon_skill{
        id = 85503
        ,name = <<"中级法伤吸收">>
        ,type = 6
        ,step = 4
        ,craft = 2
        ,exp = 23
        ,next_id = 85504
        ,limit = []
        ,combat_info = {c_skill, 85500, 1, 1, [12,0,1250], []}
    };
get_skill(85504) ->
    #demon_skill{
        id = 85504
        ,name = <<"中级法伤吸收">>
        ,type = 6
        ,step = 5
        ,craft = 2
        ,exp = 46
        ,next_id = 85505
        ,limit = []
        ,combat_info = {c_skill, 85500, 1, 1, [14,0,1350], []}
    };
get_skill(85505) ->
    #demon_skill{
        id = 85505
        ,name = <<"中级法伤吸收">>
        ,type = 6
        ,step = 6
        ,craft = 2
        ,exp = 93
        ,next_id = 85506
        ,limit = []
        ,combat_info = {c_skill, 85500, 1, 1, [16,0,1450], []}
    };
get_skill(85506) ->
    #demon_skill{
        id = 85506
        ,name = <<"中级法伤吸收">>
        ,type = 6
        ,step = 7
        ,craft = 2
        ,exp = 187
        ,next_id = 85507
        ,limit = []
        ,combat_info = {c_skill, 85500, 1, 1, [18,0,1550], []}
    };
get_skill(85507) ->
    #demon_skill{
        id = 85507
        ,name = <<"中级法伤吸收">>
        ,type = 6
        ,step = 8
        ,craft = 2
        ,exp = 375
        ,next_id = 85508
        ,limit = []
        ,combat_info = {c_skill, 85500, 1, 1, [20,0,1650], []}
    };
get_skill(85508) ->
    #demon_skill{
        id = 85508
        ,name = <<"中级法伤吸收">>
        ,type = 6
        ,step = 9
        ,craft = 2
        ,exp = 750
        ,next_id = 85509
        ,limit = []
        ,combat_info = {c_skill, 85500, 1, 1, [22,0,1750], []}
    };
get_skill(85509) ->
    #demon_skill{
        id = 85509
        ,name = <<"中级法伤吸收">>
        ,type = 6
        ,step = 10
        ,craft = 2
        ,exp = 755
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 85500, 1, 1, [24,0,1850], []}
    };
get_skill(85600) ->
    #demon_skill{
        id = 85600
        ,name = <<"中级伤害抵抗">>
        ,type = 7
        ,step = 1
        ,craft = 2
        ,exp = 2
        ,next_id = 85601
        ,limit = []
        ,combat_info = {c_skill, 85600, 1, 1, [6,11,0], []}
    };
get_skill(85601) ->
    #demon_skill{
        id = 85601
        ,name = <<"中级伤害抵抗">>
        ,type = 7
        ,step = 2
        ,craft = 2
        ,exp = 5
        ,next_id = 85602
        ,limit = []
        ,combat_info = {c_skill, 85600, 1, 1, [8,12,0], []}
    };
get_skill(85602) ->
    #demon_skill{
        id = 85602
        ,name = <<"中级伤害抵抗">>
        ,type = 7
        ,step = 3
        ,craft = 2
        ,exp = 11
        ,next_id = 85603
        ,limit = []
        ,combat_info = {c_skill, 85600, 1, 1, [10,13,0], []}
    };
get_skill(85603) ->
    #demon_skill{
        id = 85603
        ,name = <<"中级伤害抵抗">>
        ,type = 7
        ,step = 4
        ,craft = 2
        ,exp = 23
        ,next_id = 85604
        ,limit = []
        ,combat_info = {c_skill, 85600, 1, 1, [12,14,0], []}
    };
get_skill(85604) ->
    #demon_skill{
        id = 85604
        ,name = <<"中级伤害抵抗">>
        ,type = 7
        ,step = 5
        ,craft = 2
        ,exp = 46
        ,next_id = 85605
        ,limit = []
        ,combat_info = {c_skill, 85600, 1, 1, [14,15,0], []}
    };
get_skill(85605) ->
    #demon_skill{
        id = 85605
        ,name = <<"中级伤害抵抗">>
        ,type = 7
        ,step = 6
        ,craft = 2
        ,exp = 93
        ,next_id = 85606
        ,limit = []
        ,combat_info = {c_skill, 85600, 1, 1, [16,16,0], []}
    };
get_skill(85606) ->
    #demon_skill{
        id = 85606
        ,name = <<"中级伤害抵抗">>
        ,type = 7
        ,step = 7
        ,craft = 2
        ,exp = 187
        ,next_id = 85607
        ,limit = []
        ,combat_info = {c_skill, 85600, 1, 1, [18,17,0], []}
    };
get_skill(85607) ->
    #demon_skill{
        id = 85607
        ,name = <<"中级伤害抵抗">>
        ,type = 7
        ,step = 8
        ,craft = 2
        ,exp = 375
        ,next_id = 85608
        ,limit = []
        ,combat_info = {c_skill, 85600, 1, 1, [20,18,0], []}
    };
get_skill(85608) ->
    #demon_skill{
        id = 85608
        ,name = <<"中级伤害抵抗">>
        ,type = 7
        ,step = 9
        ,craft = 2
        ,exp = 750
        ,next_id = 85609
        ,limit = []
        ,combat_info = {c_skill, 85600, 1, 1, [22,19,0], []}
    };
get_skill(85609) ->
    #demon_skill{
        id = 85609
        ,name = <<"中级伤害抵抗">>
        ,type = 7
        ,step = 10
        ,craft = 2
        ,exp = 755
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 85600, 1, 1, [24,20,0], []}
    };
get_skill(85900) ->
    #demon_skill{
        id = 85900
        ,name = <<"中级灵动">>
        ,type = 15
        ,step = 1
        ,craft = 2
        ,exp = 2
        ,next_id = 85901
        ,limit = []
        ,combat_info = {c_skill, 85900, 1, 1, [30], []}
    };
get_skill(85901) ->
    #demon_skill{
        id = 85901
        ,name = <<"中级灵动">>
        ,type = 15
        ,step = 2
        ,craft = 2
        ,exp = 5
        ,next_id = 85902
        ,limit = []
        ,combat_info = {c_skill, 85900, 1, 1, [35], []}
    };
get_skill(85902) ->
    #demon_skill{
        id = 85902
        ,name = <<"中级灵动">>
        ,type = 15
        ,step = 3
        ,craft = 2
        ,exp = 11
        ,next_id = 85903
        ,limit = []
        ,combat_info = {c_skill, 85900, 1, 1, [40], []}
    };
get_skill(85903) ->
    #demon_skill{
        id = 85903
        ,name = <<"中级灵动">>
        ,type = 15
        ,step = 4
        ,craft = 2
        ,exp = 23
        ,next_id = 85904
        ,limit = []
        ,combat_info = {c_skill, 85900, 1, 1, [45], []}
    };
get_skill(85904) ->
    #demon_skill{
        id = 85904
        ,name = <<"中级灵动">>
        ,type = 15
        ,step = 5
        ,craft = 2
        ,exp = 46
        ,next_id = 85905
        ,limit = []
        ,combat_info = {c_skill, 85900, 1, 1, [50], []}
    };
get_skill(85905) ->
    #demon_skill{
        id = 85905
        ,name = <<"中级灵动">>
        ,type = 15
        ,step = 6
        ,craft = 2
        ,exp = 93
        ,next_id = 85906
        ,limit = []
        ,combat_info = {c_skill, 85900, 1, 1, [55], []}
    };
get_skill(85906) ->
    #demon_skill{
        id = 85906
        ,name = <<"中级灵动">>
        ,type = 15
        ,step = 7
        ,craft = 2
        ,exp = 187
        ,next_id = 85907
        ,limit = []
        ,combat_info = {c_skill, 85900, 1, 1, [60], []}
    };
get_skill(85907) ->
    #demon_skill{
        id = 85907
        ,name = <<"中级灵动">>
        ,type = 15
        ,step = 8
        ,craft = 2
        ,exp = 375
        ,next_id = 85908
        ,limit = []
        ,combat_info = {c_skill, 85900, 1, 1, [65], []}
    };
get_skill(85908) ->
    #demon_skill{
        id = 85908
        ,name = <<"中级灵动">>
        ,type = 15
        ,step = 9
        ,craft = 2
        ,exp = 750
        ,next_id = 85909
        ,limit = []
        ,combat_info = {c_skill, 85900, 1, 1, [70], []}
    };
get_skill(85909) ->
    #demon_skill{
        id = 85909
        ,name = <<"中级灵动">>
        ,type = 15
        ,step = 10
        ,craft = 2
        ,exp = 755
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 85900, 1, 1, [75], []}
    };
get_skill(85800) ->
    #demon_skill{
        id = 85800
        ,name = <<"中级震怒">>
        ,type = 16
        ,step = 1
        ,craft = 2
        ,exp = 2
        ,next_id = 85801
        ,limit = []
        ,combat_info = {c_skill, 85800, 1, 1, [230], []}
    };
get_skill(85801) ->
    #demon_skill{
        id = 85801
        ,name = <<"中级震怒">>
        ,type = 16
        ,step = 2
        ,craft = 2
        ,exp = 5
        ,next_id = 85802
        ,limit = []
        ,combat_info = {c_skill, 85800, 1, 1, [240], []}
    };
get_skill(85802) ->
    #demon_skill{
        id = 85802
        ,name = <<"中级震怒">>
        ,type = 16
        ,step = 3
        ,craft = 2
        ,exp = 11
        ,next_id = 85803
        ,limit = []
        ,combat_info = {c_skill, 85800, 1, 1, [250], []}
    };
get_skill(85803) ->
    #demon_skill{
        id = 85803
        ,name = <<"中级震怒">>
        ,type = 16
        ,step = 4
        ,craft = 2
        ,exp = 23
        ,next_id = 85804
        ,limit = []
        ,combat_info = {c_skill, 85800, 1, 1, [260], []}
    };
get_skill(85804) ->
    #demon_skill{
        id = 85804
        ,name = <<"中级震怒">>
        ,type = 16
        ,step = 5
        ,craft = 2
        ,exp = 46
        ,next_id = 85805
        ,limit = []
        ,combat_info = {c_skill, 85800, 1, 1, [270], []}
    };
get_skill(85805) ->
    #demon_skill{
        id = 85805
        ,name = <<"中级震怒">>
        ,type = 16
        ,step = 6
        ,craft = 2
        ,exp = 93
        ,next_id = 85806
        ,limit = []
        ,combat_info = {c_skill, 85800, 1, 1, [280], []}
    };
get_skill(85806) ->
    #demon_skill{
        id = 85806
        ,name = <<"中级震怒">>
        ,type = 16
        ,step = 7
        ,craft = 2
        ,exp = 187
        ,next_id = 85807
        ,limit = []
        ,combat_info = {c_skill, 85800, 1, 1, [290], []}
    };
get_skill(85807) ->
    #demon_skill{
        id = 85807
        ,name = <<"中级震怒">>
        ,type = 16
        ,step = 8
        ,craft = 2
        ,exp = 375
        ,next_id = 85808
        ,limit = []
        ,combat_info = {c_skill, 85800, 1, 1, [300], []}
    };
get_skill(85808) ->
    #demon_skill{
        id = 85808
        ,name = <<"中级震怒">>
        ,type = 16
        ,step = 9
        ,craft = 2
        ,exp = 750
        ,next_id = 85809
        ,limit = []
        ,combat_info = {c_skill, 85800, 1, 1, [310], []}
    };
get_skill(85809) ->
    #demon_skill{
        id = 85809
        ,name = <<"中级震怒">>
        ,type = 16
        ,step = 10
        ,craft = 2
        ,exp = 755
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 85800, 1, 1, [320], []}
    };
get_skill(84000) ->
    #demon_skill{
        id = 84000
        ,name = <<"高级金系攻击">>
        ,type = 1
        ,step = 1
        ,craft = 3
        ,exp = 3
        ,next_id = 84001
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 84000, 1, 1, [5,0,1750], []}
    };
get_skill(84001) ->
    #demon_skill{
        id = 84001
        ,name = <<"高级金系攻击">>
        ,type = 1
        ,step = 2
        ,craft = 3
        ,exp = 7
        ,next_id = 84002
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 84000, 1, 1, [7,0,1900], []}
    };
get_skill(84002) ->
    #demon_skill{
        id = 84002
        ,name = <<"高级金系攻击">>
        ,type = 1
        ,step = 3
        ,craft = 3
        ,exp = 14
        ,next_id = 84003
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 84000, 1, 1, [9,0,2050], []}
    };
get_skill(84003) ->
    #demon_skill{
        id = 84003
        ,name = <<"高级金系攻击">>
        ,type = 1
        ,step = 4
        ,craft = 3
        ,exp = 30
        ,next_id = 84004
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 84000, 1, 1, [11,0,2200], []}
    };
get_skill(84004) ->
    #demon_skill{
        id = 84004
        ,name = <<"高级金系攻击">>
        ,type = 1
        ,step = 5
        ,craft = 3
        ,exp = 60
        ,next_id = 84005
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 84000, 1, 1, [13,0,2350], []}
    };
get_skill(84005) ->
    #demon_skill{
        id = 84005
        ,name = <<"高级金系攻击">>
        ,type = 1
        ,step = 6
        ,craft = 3
        ,exp = 121
        ,next_id = 84006
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 84000, 1, 1, [15,0,2500], []}
    };
get_skill(84006) ->
    #demon_skill{
        id = 84006
        ,name = <<"高级金系攻击">>
        ,type = 1
        ,step = 7
        ,craft = 3
        ,exp = 243
        ,next_id = 84007
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 84000, 1, 1, [17,0,2650], []}
    };
get_skill(84007) ->
    #demon_skill{
        id = 84007
        ,name = <<"高级金系攻击">>
        ,type = 1
        ,step = 8
        ,craft = 3
        ,exp = 487
        ,next_id = 84008
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 84000, 1, 1, [19,0,2800], []}
    };
get_skill(84008) ->
    #demon_skill{
        id = 84008
        ,name = <<"高级金系攻击">>
        ,type = 1
        ,step = 9
        ,craft = 3
        ,exp = 975
        ,next_id = 84009
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 84000, 1, 1, [21,0,2950], []}
    };
get_skill(84009) ->
    #demon_skill{
        id = 84009
        ,name = <<"高级金系攻击">>
        ,type = 1
        ,step = 10
        ,craft = 3
        ,exp = 1200
        ,next_id = 0
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 84000, 1, 1, [23,0,3100], []}
    };
get_skill(84100) ->
    #demon_skill{
        id = 84100
        ,name = <<"高级木系攻击">>
        ,type = 2
        ,step = 1
        ,craft = 3
        ,exp = 3
        ,next_id = 84101
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 84100, 1, 1, [5,0,1750], []}
    };
get_skill(84101) ->
    #demon_skill{
        id = 84101
        ,name = <<"高级木系攻击">>
        ,type = 2
        ,step = 2
        ,craft = 3
        ,exp = 7
        ,next_id = 84102
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 84100, 1, 1, [7,0,1900], []}
    };
get_skill(84102) ->
    #demon_skill{
        id = 84102
        ,name = <<"高级木系攻击">>
        ,type = 2
        ,step = 3
        ,craft = 3
        ,exp = 14
        ,next_id = 84103
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 84100, 1, 1, [9,0,2050], []}
    };
get_skill(84103) ->
    #demon_skill{
        id = 84103
        ,name = <<"高级木系攻击">>
        ,type = 2
        ,step = 4
        ,craft = 3
        ,exp = 30
        ,next_id = 84104
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 84100, 1, 1, [11,0,2200], []}
    };
get_skill(84104) ->
    #demon_skill{
        id = 84104
        ,name = <<"高级木系攻击">>
        ,type = 2
        ,step = 5
        ,craft = 3
        ,exp = 60
        ,next_id = 84105
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 84100, 1, 1, [13,0,2350], []}
    };
get_skill(84105) ->
    #demon_skill{
        id = 84105
        ,name = <<"高级木系攻击">>
        ,type = 2
        ,step = 6
        ,craft = 3
        ,exp = 121
        ,next_id = 84106
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 84100, 1, 1, [15,0,2500], []}
    };
get_skill(84106) ->
    #demon_skill{
        id = 84106
        ,name = <<"高级木系攻击">>
        ,type = 2
        ,step = 7
        ,craft = 3
        ,exp = 243
        ,next_id = 84107
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 84100, 1, 1, [17,0,2650], []}
    };
get_skill(84107) ->
    #demon_skill{
        id = 84107
        ,name = <<"高级木系攻击">>
        ,type = 2
        ,step = 8
        ,craft = 3
        ,exp = 487
        ,next_id = 84108
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 84100, 1, 1, [19,0,2800], []}
    };
get_skill(84108) ->
    #demon_skill{
        id = 84108
        ,name = <<"高级木系攻击">>
        ,type = 2
        ,step = 9
        ,craft = 3
        ,exp = 975
        ,next_id = 84109
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 84100, 1, 1, [21,0,2950], []}
    };
get_skill(84109) ->
    #demon_skill{
        id = 84109
        ,name = <<"高级木系攻击">>
        ,type = 2
        ,step = 10
        ,craft = 3
        ,exp = 1200
        ,next_id = 0
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 84100, 1, 1, [23,0,3100], []}
    };
get_skill(84200) ->
    #demon_skill{
        id = 84200
        ,name = <<"高级水系攻击">>
        ,type = 3
        ,step = 1
        ,craft = 3
        ,exp = 3
        ,next_id = 84201
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 84200, 1, 1, [5,0,1750], []}
    };
get_skill(84201) ->
    #demon_skill{
        id = 84201
        ,name = <<"高级水系攻击">>
        ,type = 3
        ,step = 2
        ,craft = 3
        ,exp = 7
        ,next_id = 84202
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 84200, 1, 1, [7,0,1900], []}
    };
get_skill(84202) ->
    #demon_skill{
        id = 84202
        ,name = <<"高级水系攻击">>
        ,type = 3
        ,step = 3
        ,craft = 3
        ,exp = 14
        ,next_id = 84203
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 84200, 1, 1, [9,0,2050], []}
    };
get_skill(84203) ->
    #demon_skill{
        id = 84203
        ,name = <<"高级水系攻击">>
        ,type = 3
        ,step = 4
        ,craft = 3
        ,exp = 30
        ,next_id = 84204
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 84200, 1, 1, [11,0,2200], []}
    };
get_skill(84204) ->
    #demon_skill{
        id = 84204
        ,name = <<"高级水系攻击">>
        ,type = 3
        ,step = 5
        ,craft = 3
        ,exp = 60
        ,next_id = 84205
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 84200, 1, 1, [13,0,2350], []}
    };
get_skill(84205) ->
    #demon_skill{
        id = 84205
        ,name = <<"高级水系攻击">>
        ,type = 3
        ,step = 6
        ,craft = 3
        ,exp = 121
        ,next_id = 84206
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 84200, 1, 1, [15,0,2500], []}
    };
get_skill(84206) ->
    #demon_skill{
        id = 84206
        ,name = <<"高级水系攻击">>
        ,type = 3
        ,step = 7
        ,craft = 3
        ,exp = 243
        ,next_id = 84207
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 84200, 1, 1, [17,0,2650], []}
    };
get_skill(84207) ->
    #demon_skill{
        id = 84207
        ,name = <<"高级水系攻击">>
        ,type = 3
        ,step = 8
        ,craft = 3
        ,exp = 487
        ,next_id = 84208
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 84200, 1, 1, [19,0,2800], []}
    };
get_skill(84208) ->
    #demon_skill{
        id = 84208
        ,name = <<"高级水系攻击">>
        ,type = 3
        ,step = 9
        ,craft = 3
        ,exp = 975
        ,next_id = 84209
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 84200, 1, 1, [21,0,2950], []}
    };
get_skill(84209) ->
    #demon_skill{
        id = 84209
        ,name = <<"高级水系攻击">>
        ,type = 3
        ,step = 10
        ,craft = 3
        ,exp = 1200
        ,next_id = 0
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 84200, 1, 1, [23,0,3100], []}
    };
get_skill(84300) ->
    #demon_skill{
        id = 84300
        ,name = <<"高级火系攻击">>
        ,type = 4
        ,step = 1
        ,craft = 3
        ,exp = 3
        ,next_id = 84301
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 84300, 1, 1, [5,0,1750], []}
    };
get_skill(84301) ->
    #demon_skill{
        id = 84301
        ,name = <<"高级火系攻击">>
        ,type = 4
        ,step = 2
        ,craft = 3
        ,exp = 7
        ,next_id = 84302
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 84300, 1, 1, [7,0,1900], []}
    };
get_skill(84302) ->
    #demon_skill{
        id = 84302
        ,name = <<"高级火系攻击">>
        ,type = 4
        ,step = 3
        ,craft = 3
        ,exp = 14
        ,next_id = 84303
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 84300, 1, 1, [9,0,2050], []}
    };
get_skill(84303) ->
    #demon_skill{
        id = 84303
        ,name = <<"高级火系攻击">>
        ,type = 4
        ,step = 4
        ,craft = 3
        ,exp = 30
        ,next_id = 84304
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 84300, 1, 1, [11,0,2200], []}
    };
get_skill(84304) ->
    #demon_skill{
        id = 84304
        ,name = <<"高级火系攻击">>
        ,type = 4
        ,step = 5
        ,craft = 3
        ,exp = 60
        ,next_id = 84305
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 84300, 1, 1, [13,0,2350], []}
    };
get_skill(84305) ->
    #demon_skill{
        id = 84305
        ,name = <<"高级火系攻击">>
        ,type = 4
        ,step = 6
        ,craft = 3
        ,exp = 121
        ,next_id = 84306
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 84300, 1, 1, [15,0,2500], []}
    };
get_skill(84306) ->
    #demon_skill{
        id = 84306
        ,name = <<"高级火系攻击">>
        ,type = 4
        ,step = 7
        ,craft = 3
        ,exp = 243
        ,next_id = 84307
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 84300, 1, 1, [17,0,2650], []}
    };
get_skill(84307) ->
    #demon_skill{
        id = 84307
        ,name = <<"高级火系攻击">>
        ,type = 4
        ,step = 8
        ,craft = 3
        ,exp = 487
        ,next_id = 84308
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 84300, 1, 1, [19,0,2800], []}
    };
get_skill(84308) ->
    #demon_skill{
        id = 84308
        ,name = <<"高级火系攻击">>
        ,type = 4
        ,step = 9
        ,craft = 3
        ,exp = 975
        ,next_id = 84309
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 84300, 1, 1, [21,0,2950], []}
    };
get_skill(84309) ->
    #demon_skill{
        id = 84309
        ,name = <<"高级火系攻击">>
        ,type = 4
        ,step = 10
        ,craft = 3
        ,exp = 1200
        ,next_id = 0
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 84300, 1, 1, [23,0,3100], []}
    };
get_skill(84400) ->
    #demon_skill{
        id = 84400
        ,name = <<"高级土系攻击">>
        ,type = 5
        ,step = 1
        ,craft = 3
        ,exp = 3
        ,next_id = 84401
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 84400, 1, 1, [5,0,1750], []}
    };
get_skill(84401) ->
    #demon_skill{
        id = 84401
        ,name = <<"高级土系攻击">>
        ,type = 5
        ,step = 2
        ,craft = 3
        ,exp = 7
        ,next_id = 84402
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 84400, 1, 1, [7,0,1900], []}
    };
get_skill(84402) ->
    #demon_skill{
        id = 84402
        ,name = <<"高级土系攻击">>
        ,type = 5
        ,step = 3
        ,craft = 3
        ,exp = 14
        ,next_id = 84403
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 84400, 1, 1, [9,0,2050], []}
    };
get_skill(84403) ->
    #demon_skill{
        id = 84403
        ,name = <<"高级土系攻击">>
        ,type = 5
        ,step = 4
        ,craft = 3
        ,exp = 30
        ,next_id = 84404
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 84400, 1, 1, [11,0,2200], []}
    };
get_skill(84404) ->
    #demon_skill{
        id = 84404
        ,name = <<"高级土系攻击">>
        ,type = 5
        ,step = 5
        ,craft = 3
        ,exp = 60
        ,next_id = 84405
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 84400, 1, 1, [13,0,2350], []}
    };
get_skill(84405) ->
    #demon_skill{
        id = 84405
        ,name = <<"高级土系攻击">>
        ,type = 5
        ,step = 6
        ,craft = 3
        ,exp = 121
        ,next_id = 84406
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 84400, 1, 1, [15,0,2500], []}
    };
get_skill(84406) ->
    #demon_skill{
        id = 84406
        ,name = <<"高级土系攻击">>
        ,type = 5
        ,step = 7
        ,craft = 3
        ,exp = 243
        ,next_id = 84407
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 84400, 1, 1, [17,0,2650], []}
    };
get_skill(84407) ->
    #demon_skill{
        id = 84407
        ,name = <<"高级土系攻击">>
        ,type = 5
        ,step = 8
        ,craft = 3
        ,exp = 487
        ,next_id = 84408
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 84400, 1, 1, [19,0,2800], []}
    };
get_skill(84408) ->
    #demon_skill{
        id = 84408
        ,name = <<"高级土系攻击">>
        ,type = 5
        ,step = 9
        ,craft = 3
        ,exp = 975
        ,next_id = 84409
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 84400, 1, 1, [21,0,2950], []}
    };
get_skill(84409) ->
    #demon_skill{
        id = 84409
        ,name = <<"高级土系攻击">>
        ,type = 5
        ,step = 10
        ,craft = 3
        ,exp = 1200
        ,next_id = 0
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 84400, 1, 1, [23,0,3100], []}
    };
get_skill(84500) ->
    #demon_skill{
        id = 84500
        ,name = <<"高级法伤吸收">>
        ,type = 6
        ,step = 1
        ,craft = 3
        ,exp = 3
        ,next_id = 84501
        ,limit = []
        ,combat_info = {c_skill, 84500, 1, 1, [7,0,1050], []}
    };
get_skill(84501) ->
    #demon_skill{
        id = 84501
        ,name = <<"高级法伤吸收">>
        ,type = 6
        ,step = 2
        ,craft = 3
        ,exp = 7
        ,next_id = 84502
        ,limit = []
        ,combat_info = {c_skill, 84500, 1, 1, [9,0,1150], []}
    };
get_skill(84502) ->
    #demon_skill{
        id = 84502
        ,name = <<"高级法伤吸收">>
        ,type = 6
        ,step = 3
        ,craft = 3
        ,exp = 14
        ,next_id = 84503
        ,limit = []
        ,combat_info = {c_skill, 84500, 1, 1, [11,0,1250], []}
    };
get_skill(84503) ->
    #demon_skill{
        id = 84503
        ,name = <<"高级法伤吸收">>
        ,type = 6
        ,step = 4
        ,craft = 3
        ,exp = 30
        ,next_id = 84504
        ,limit = []
        ,combat_info = {c_skill, 84500, 1, 1, [13,0,1350], []}
    };
get_skill(84504) ->
    #demon_skill{
        id = 84504
        ,name = <<"高级法伤吸收">>
        ,type = 6
        ,step = 5
        ,craft = 3
        ,exp = 60
        ,next_id = 84505
        ,limit = []
        ,combat_info = {c_skill, 84500, 1, 1, [15,0,1450], []}
    };
get_skill(84505) ->
    #demon_skill{
        id = 84505
        ,name = <<"高级法伤吸收">>
        ,type = 6
        ,step = 6
        ,craft = 3
        ,exp = 121
        ,next_id = 84506
        ,limit = []
        ,combat_info = {c_skill, 84500, 1, 1, [17,0,1550], []}
    };
get_skill(84506) ->
    #demon_skill{
        id = 84506
        ,name = <<"高级法伤吸收">>
        ,type = 6
        ,step = 7
        ,craft = 3
        ,exp = 243
        ,next_id = 84507
        ,limit = []
        ,combat_info = {c_skill, 84500, 1, 1, [19,0,1650], []}
    };
get_skill(84507) ->
    #demon_skill{
        id = 84507
        ,name = <<"高级法伤吸收">>
        ,type = 6
        ,step = 8
        ,craft = 3
        ,exp = 487
        ,next_id = 84508
        ,limit = []
        ,combat_info = {c_skill, 84500, 1, 1, [21,0,1750], []}
    };
get_skill(84508) ->
    #demon_skill{
        id = 84508
        ,name = <<"高级法伤吸收">>
        ,type = 6
        ,step = 9
        ,craft = 3
        ,exp = 975
        ,next_id = 84509
        ,limit = []
        ,combat_info = {c_skill, 84500, 1, 1, [23,0,1850], []}
    };
get_skill(84509) ->
    #demon_skill{
        id = 84509
        ,name = <<"高级法伤吸收">>
        ,type = 6
        ,step = 10
        ,craft = 3
        ,exp = 1200
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 84500, 1, 1, [25,0,1950], []}
    };
get_skill(84600) ->
    #demon_skill{
        id = 84600
        ,name = <<"高级伤害抵抗">>
        ,type = 7
        ,step = 1
        ,craft = 3
        ,exp = 3
        ,next_id = 84601
        ,limit = []
        ,combat_info = {c_skill, 84600, 1, 1, [7,13,0], []}
    };
get_skill(84601) ->
    #demon_skill{
        id = 84601
        ,name = <<"高级伤害抵抗">>
        ,type = 7
        ,step = 2
        ,craft = 3
        ,exp = 7
        ,next_id = 84602
        ,limit = []
        ,combat_info = {c_skill, 84600, 1, 1, [9,14,0], []}
    };
get_skill(84602) ->
    #demon_skill{
        id = 84602
        ,name = <<"高级伤害抵抗">>
        ,type = 7
        ,step = 3
        ,craft = 3
        ,exp = 14
        ,next_id = 84603
        ,limit = []
        ,combat_info = {c_skill, 84600, 1, 1, [11,15,0], []}
    };
get_skill(84603) ->
    #demon_skill{
        id = 84603
        ,name = <<"高级伤害抵抗">>
        ,type = 7
        ,step = 4
        ,craft = 3
        ,exp = 30
        ,next_id = 84604
        ,limit = []
        ,combat_info = {c_skill, 84600, 1, 1, [13,16,0], []}
    };
get_skill(84604) ->
    #demon_skill{
        id = 84604
        ,name = <<"高级伤害抵抗">>
        ,type = 7
        ,step = 5
        ,craft = 3
        ,exp = 60
        ,next_id = 84605
        ,limit = []
        ,combat_info = {c_skill, 84600, 1, 1, [15,17,0], []}
    };
get_skill(84605) ->
    #demon_skill{
        id = 84605
        ,name = <<"高级伤害抵抗">>
        ,type = 7
        ,step = 6
        ,craft = 3
        ,exp = 121
        ,next_id = 84606
        ,limit = []
        ,combat_info = {c_skill, 84600, 1, 1, [17,18,0], []}
    };
get_skill(84606) ->
    #demon_skill{
        id = 84606
        ,name = <<"高级伤害抵抗">>
        ,type = 7
        ,step = 7
        ,craft = 3
        ,exp = 243
        ,next_id = 84607
        ,limit = []
        ,combat_info = {c_skill, 84600, 1, 1, [19,19,0], []}
    };
get_skill(84607) ->
    #demon_skill{
        id = 84607
        ,name = <<"高级伤害抵抗">>
        ,type = 7
        ,step = 8
        ,craft = 3
        ,exp = 487
        ,next_id = 84608
        ,limit = []
        ,combat_info = {c_skill, 84600, 1, 1, [21,20,0], []}
    };
get_skill(84608) ->
    #demon_skill{
        id = 84608
        ,name = <<"高级伤害抵抗">>
        ,type = 7
        ,step = 9
        ,craft = 3
        ,exp = 975
        ,next_id = 84609
        ,limit = []
        ,combat_info = {c_skill, 84600, 1, 1, [23,21,0], []}
    };
get_skill(84609) ->
    #demon_skill{
        id = 84609
        ,name = <<"高级伤害抵抗">>
        ,type = 7
        ,step = 10
        ,craft = 3
        ,exp = 1200
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 84600, 1, 1, [25,22,0], []}
    };
get_skill(84900) ->
    #demon_skill{
        id = 84900
        ,name = <<"高级灵动">>
        ,type = 15
        ,step = 1
        ,craft = 3
        ,exp = 3
        ,next_id = 84901
        ,limit = []
        ,combat_info = {c_skill, 84900, 1, 1, [55], []}
    };
get_skill(84901) ->
    #demon_skill{
        id = 84901
        ,name = <<"高级灵动">>
        ,type = 15
        ,step = 2
        ,craft = 3
        ,exp = 7
        ,next_id = 84902
        ,limit = []
        ,combat_info = {c_skill, 84900, 1, 1, [60], []}
    };
get_skill(84902) ->
    #demon_skill{
        id = 84902
        ,name = <<"高级灵动">>
        ,type = 15
        ,step = 3
        ,craft = 3
        ,exp = 14
        ,next_id = 84903
        ,limit = []
        ,combat_info = {c_skill, 84900, 1, 1, [65], []}
    };
get_skill(84903) ->
    #demon_skill{
        id = 84903
        ,name = <<"高级灵动">>
        ,type = 15
        ,step = 4
        ,craft = 3
        ,exp = 30
        ,next_id = 84904
        ,limit = []
        ,combat_info = {c_skill, 84900, 1, 1, [70], []}
    };
get_skill(84904) ->
    #demon_skill{
        id = 84904
        ,name = <<"高级灵动">>
        ,type = 15
        ,step = 5
        ,craft = 3
        ,exp = 60
        ,next_id = 84905
        ,limit = []
        ,combat_info = {c_skill, 84900, 1, 1, [75], []}
    };
get_skill(84905) ->
    #demon_skill{
        id = 84905
        ,name = <<"高级灵动">>
        ,type = 15
        ,step = 6
        ,craft = 3
        ,exp = 121
        ,next_id = 84906
        ,limit = []
        ,combat_info = {c_skill, 84900, 1, 1, [80], []}
    };
get_skill(84906) ->
    #demon_skill{
        id = 84906
        ,name = <<"高级灵动">>
        ,type = 15
        ,step = 7
        ,craft = 3
        ,exp = 243
        ,next_id = 84907
        ,limit = []
        ,combat_info = {c_skill, 84900, 1, 1, [85], []}
    };
get_skill(84907) ->
    #demon_skill{
        id = 84907
        ,name = <<"高级灵动">>
        ,type = 15
        ,step = 8
        ,craft = 3
        ,exp = 487
        ,next_id = 84908
        ,limit = []
        ,combat_info = {c_skill, 84900, 1, 1, [90], []}
    };
get_skill(84908) ->
    #demon_skill{
        id = 84908
        ,name = <<"高级灵动">>
        ,type = 15
        ,step = 9
        ,craft = 3
        ,exp = 975
        ,next_id = 84909
        ,limit = []
        ,combat_info = {c_skill, 84900, 1, 1, [95], []}
    };
get_skill(84909) ->
    #demon_skill{
        id = 84909
        ,name = <<"高级灵动">>
        ,type = 15
        ,step = 10
        ,craft = 3
        ,exp = 1200
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 84900, 1, 1, [100], []}
    };
get_skill(84800) ->
    #demon_skill{
        id = 84800
        ,name = <<"高级震怒">>
        ,type = 16
        ,step = 1
        ,craft = 3
        ,exp = 3
        ,next_id = 84801
        ,limit = []
        ,combat_info = {c_skill, 84800, 1, 1, [260], []}
    };
get_skill(84801) ->
    #demon_skill{
        id = 84801
        ,name = <<"高级震怒">>
        ,type = 16
        ,step = 2
        ,craft = 3
        ,exp = 7
        ,next_id = 84802
        ,limit = []
        ,combat_info = {c_skill, 84800, 1, 1, [270], []}
    };
get_skill(84802) ->
    #demon_skill{
        id = 84802
        ,name = <<"高级震怒">>
        ,type = 16
        ,step = 3
        ,craft = 3
        ,exp = 14
        ,next_id = 84803
        ,limit = []
        ,combat_info = {c_skill, 84800, 1, 1, [280], []}
    };
get_skill(84803) ->
    #demon_skill{
        id = 84803
        ,name = <<"高级震怒">>
        ,type = 16
        ,step = 4
        ,craft = 3
        ,exp = 30
        ,next_id = 84804
        ,limit = []
        ,combat_info = {c_skill, 84800, 1, 1, [290], []}
    };
get_skill(84804) ->
    #demon_skill{
        id = 84804
        ,name = <<"高级震怒">>
        ,type = 16
        ,step = 5
        ,craft = 3
        ,exp = 60
        ,next_id = 84805
        ,limit = []
        ,combat_info = {c_skill, 84800, 1, 1, [300], []}
    };
get_skill(84805) ->
    #demon_skill{
        id = 84805
        ,name = <<"高级震怒">>
        ,type = 16
        ,step = 6
        ,craft = 3
        ,exp = 121
        ,next_id = 84806
        ,limit = []
        ,combat_info = {c_skill, 84800, 1, 1, [310], []}
    };
get_skill(84806) ->
    #demon_skill{
        id = 84806
        ,name = <<"高级震怒">>
        ,type = 16
        ,step = 7
        ,craft = 3
        ,exp = 243
        ,next_id = 84807
        ,limit = []
        ,combat_info = {c_skill, 84800, 1, 1, [320], []}
    };
get_skill(84807) ->
    #demon_skill{
        id = 84807
        ,name = <<"高级震怒">>
        ,type = 16
        ,step = 8
        ,craft = 3
        ,exp = 487
        ,next_id = 84808
        ,limit = []
        ,combat_info = {c_skill, 84800, 1, 1, [330], []}
    };
get_skill(84808) ->
    #demon_skill{
        id = 84808
        ,name = <<"高级震怒">>
        ,type = 16
        ,step = 9
        ,craft = 3
        ,exp = 975
        ,next_id = 84809
        ,limit = []
        ,combat_info = {c_skill, 84800, 1, 1, [340], []}
    };
get_skill(84809) ->
    #demon_skill{
        id = 84809
        ,name = <<"高级震怒">>
        ,type = 16
        ,step = 10
        ,craft = 3
        ,exp = 1200
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 84800, 1, 1, [350], []}
    };
get_skill(83000) ->
    #demon_skill{
        id = 83000
        ,name = <<"至尊金系攻击">>
        ,type = 1
        ,step = 1
        ,craft = 4
        ,exp = 4
        ,next_id = 83001
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 83000, 1, 1, [5,0,2150], []}
    };
get_skill(83001) ->
    #demon_skill{
        id = 83001
        ,name = <<"至尊金系攻击">>
        ,type = 1
        ,step = 2
        ,craft = 4
        ,exp = 10
        ,next_id = 83002
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 83000, 1, 1, [7,0,2300], []}
    };
get_skill(83002) ->
    #demon_skill{
        id = 83002
        ,name = <<"至尊金系攻击">>
        ,type = 1
        ,step = 3
        ,craft = 4
        ,exp = 20
        ,next_id = 83003
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 83000, 1, 1, [9,0,2450], []}
    };
get_skill(83003) ->
    #demon_skill{
        id = 83003
        ,name = <<"至尊金系攻击">>
        ,type = 1
        ,step = 4
        ,craft = 4
        ,exp = 42
        ,next_id = 83004
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 83000, 1, 1, [11,0,2600], []}
    };
get_skill(83004) ->
    #demon_skill{
        id = 83004
        ,name = <<"至尊金系攻击">>
        ,type = 1
        ,step = 5
        ,craft = 4
        ,exp = 84
        ,next_id = 83005
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 83000, 1, 1, [13,0,2750], []}
    };
get_skill(83005) ->
    #demon_skill{
        id = 83005
        ,name = <<"至尊金系攻击">>
        ,type = 1
        ,step = 6
        ,craft = 4
        ,exp = 170
        ,next_id = 83006
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 83000, 1, 1, [15,0,2900], []}
    };
get_skill(83006) ->
    #demon_skill{
        id = 83006
        ,name = <<"至尊金系攻击">>
        ,type = 1
        ,step = 7
        ,craft = 4
        ,exp = 340
        ,next_id = 83007
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 83000, 1, 1, [17,0,3050], []}
    };
get_skill(83007) ->
    #demon_skill{
        id = 83007
        ,name = <<"至尊金系攻击">>
        ,type = 1
        ,step = 8
        ,craft = 4
        ,exp = 682
        ,next_id = 83008
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 83000, 1, 1, [19,0,3200], []}
    };
get_skill(83008) ->
    #demon_skill{
        id = 83008
        ,name = <<"至尊金系攻击">>
        ,type = 1
        ,step = 9
        ,craft = 4
        ,exp = 1365
        ,next_id = 83009
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 83000, 1, 1, [21,0,3350], []}
    };
get_skill(83009) ->
    #demon_skill{
        id = 83009
        ,name = <<"至尊金系攻击">>
        ,type = 1
        ,step = 10
        ,craft = 4
        ,exp = 1800
        ,next_id = 0
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 83000, 1, 1, [23,0,3500], []}
    };
get_skill(83100) ->
    #demon_skill{
        id = 83100
        ,name = <<"至尊木系攻击">>
        ,type = 2
        ,step = 1
        ,craft = 4
        ,exp = 4
        ,next_id = 83101
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 83100, 1, 1, [5,0,2150], []}
    };
get_skill(83101) ->
    #demon_skill{
        id = 83101
        ,name = <<"至尊木系攻击">>
        ,type = 2
        ,step = 2
        ,craft = 4
        ,exp = 10
        ,next_id = 83102
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 83100, 1, 1, [7,0,2300], []}
    };
get_skill(83102) ->
    #demon_skill{
        id = 83102
        ,name = <<"至尊木系攻击">>
        ,type = 2
        ,step = 3
        ,craft = 4
        ,exp = 20
        ,next_id = 83103
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 83100, 1, 1, [9,0,2450], []}
    };
get_skill(83103) ->
    #demon_skill{
        id = 83103
        ,name = <<"至尊木系攻击">>
        ,type = 2
        ,step = 4
        ,craft = 4
        ,exp = 42
        ,next_id = 83104
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 83100, 1, 1, [11,0,2600], []}
    };
get_skill(83104) ->
    #demon_skill{
        id = 83104
        ,name = <<"至尊木系攻击">>
        ,type = 2
        ,step = 5
        ,craft = 4
        ,exp = 84
        ,next_id = 83105
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 83100, 1, 1, [13,0,2750], []}
    };
get_skill(83105) ->
    #demon_skill{
        id = 83105
        ,name = <<"至尊木系攻击">>
        ,type = 2
        ,step = 6
        ,craft = 4
        ,exp = 170
        ,next_id = 83106
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 83100, 1, 1, [15,0,2900], []}
    };
get_skill(83106) ->
    #demon_skill{
        id = 83106
        ,name = <<"至尊木系攻击">>
        ,type = 2
        ,step = 7
        ,craft = 4
        ,exp = 340
        ,next_id = 83107
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 83100, 1, 1, [17,0,3050], []}
    };
get_skill(83107) ->
    #demon_skill{
        id = 83107
        ,name = <<"至尊木系攻击">>
        ,type = 2
        ,step = 8
        ,craft = 4
        ,exp = 682
        ,next_id = 83108
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 83100, 1, 1, [19,0,3200], []}
    };
get_skill(83108) ->
    #demon_skill{
        id = 83108
        ,name = <<"至尊木系攻击">>
        ,type = 2
        ,step = 9
        ,craft = 4
        ,exp = 1365
        ,next_id = 83109
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 83100, 1, 1, [21,0,3350], []}
    };
get_skill(83109) ->
    #demon_skill{
        id = 83109
        ,name = <<"至尊木系攻击">>
        ,type = 2
        ,step = 10
        ,craft = 4
        ,exp = 1800
        ,next_id = 0
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 83100, 1, 1, [23,0,3500], []}
    };
get_skill(83200) ->
    #demon_skill{
        id = 83200
        ,name = <<"至尊水系攻击">>
        ,type = 3
        ,step = 1
        ,craft = 4
        ,exp = 4
        ,next_id = 83201
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 83200, 1, 1, [5,0,2150], []}
    };
get_skill(83201) ->
    #demon_skill{
        id = 83201
        ,name = <<"至尊水系攻击">>
        ,type = 3
        ,step = 2
        ,craft = 4
        ,exp = 10
        ,next_id = 83202
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 83200, 1, 1, [7,0,2300], []}
    };
get_skill(83202) ->
    #demon_skill{
        id = 83202
        ,name = <<"至尊水系攻击">>
        ,type = 3
        ,step = 3
        ,craft = 4
        ,exp = 20
        ,next_id = 83203
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 83200, 1, 1, [9,0,2450], []}
    };
get_skill(83203) ->
    #demon_skill{
        id = 83203
        ,name = <<"至尊水系攻击">>
        ,type = 3
        ,step = 4
        ,craft = 4
        ,exp = 42
        ,next_id = 83204
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 83200, 1, 1, [11,0,2600], []}
    };
get_skill(83204) ->
    #demon_skill{
        id = 83204
        ,name = <<"至尊水系攻击">>
        ,type = 3
        ,step = 5
        ,craft = 4
        ,exp = 84
        ,next_id = 83205
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 83200, 1, 1, [13,0,2750], []}
    };
get_skill(83205) ->
    #demon_skill{
        id = 83205
        ,name = <<"至尊水系攻击">>
        ,type = 3
        ,step = 6
        ,craft = 4
        ,exp = 170
        ,next_id = 83206
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 83200, 1, 1, [15,0,2900], []}
    };
get_skill(83206) ->
    #demon_skill{
        id = 83206
        ,name = <<"至尊水系攻击">>
        ,type = 3
        ,step = 7
        ,craft = 4
        ,exp = 340
        ,next_id = 83207
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 83200, 1, 1, [17,0,3050], []}
    };
get_skill(83207) ->
    #demon_skill{
        id = 83207
        ,name = <<"至尊水系攻击">>
        ,type = 3
        ,step = 8
        ,craft = 4
        ,exp = 682
        ,next_id = 83208
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 83200, 1, 1, [19,0,3200], []}
    };
get_skill(83208) ->
    #demon_skill{
        id = 83208
        ,name = <<"至尊水系攻击">>
        ,type = 3
        ,step = 9
        ,craft = 4
        ,exp = 1365
        ,next_id = 83209
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 83200, 1, 1, [21,0,3350], []}
    };
get_skill(83209) ->
    #demon_skill{
        id = 83209
        ,name = <<"至尊水系攻击">>
        ,type = 3
        ,step = 10
        ,craft = 4
        ,exp = 1800
        ,next_id = 0
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 83200, 1, 1, [23,0,3500], []}
    };
get_skill(83300) ->
    #demon_skill{
        id = 83300
        ,name = <<"至尊火系攻击">>
        ,type = 4
        ,step = 1
        ,craft = 4
        ,exp = 4
        ,next_id = 83301
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 83300, 1, 1, [5,0,2150], []}
    };
get_skill(83301) ->
    #demon_skill{
        id = 83301
        ,name = <<"至尊火系攻击">>
        ,type = 4
        ,step = 2
        ,craft = 4
        ,exp = 10
        ,next_id = 83302
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 83300, 1, 1, [7,0,2300], []}
    };
get_skill(83302) ->
    #demon_skill{
        id = 83302
        ,name = <<"至尊火系攻击">>
        ,type = 4
        ,step = 3
        ,craft = 4
        ,exp = 20
        ,next_id = 83303
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 83300, 1, 1, [9,0,2450], []}
    };
get_skill(83303) ->
    #demon_skill{
        id = 83303
        ,name = <<"至尊火系攻击">>
        ,type = 4
        ,step = 4
        ,craft = 4
        ,exp = 42
        ,next_id = 83304
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 83300, 1, 1, [11,0,2600], []}
    };
get_skill(83304) ->
    #demon_skill{
        id = 83304
        ,name = <<"至尊火系攻击">>
        ,type = 4
        ,step = 5
        ,craft = 4
        ,exp = 84
        ,next_id = 83305
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 83300, 1, 1, [13,0,2750], []}
    };
get_skill(83305) ->
    #demon_skill{
        id = 83305
        ,name = <<"至尊火系攻击">>
        ,type = 4
        ,step = 6
        ,craft = 4
        ,exp = 170
        ,next_id = 83306
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 83300, 1, 1, [15,0,2900], []}
    };
get_skill(83306) ->
    #demon_skill{
        id = 83306
        ,name = <<"至尊火系攻击">>
        ,type = 4
        ,step = 7
        ,craft = 4
        ,exp = 340
        ,next_id = 83307
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 83300, 1, 1, [17,0,3050], []}
    };
get_skill(83307) ->
    #demon_skill{
        id = 83307
        ,name = <<"至尊火系攻击">>
        ,type = 4
        ,step = 8
        ,craft = 4
        ,exp = 682
        ,next_id = 83308
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 83300, 1, 1, [19,0,3200], []}
    };
get_skill(83308) ->
    #demon_skill{
        id = 83308
        ,name = <<"至尊火系攻击">>
        ,type = 4
        ,step = 9
        ,craft = 4
        ,exp = 1365
        ,next_id = 83309
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 83300, 1, 1, [21,0,3350], []}
    };
get_skill(83309) ->
    #demon_skill{
        id = 83309
        ,name = <<"至尊火系攻击">>
        ,type = 4
        ,step = 10
        ,craft = 4
        ,exp = 1800
        ,next_id = 0
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 83300, 1, 1, [23,0,3500], []}
    };
get_skill(83400) ->
    #demon_skill{
        id = 83400
        ,name = <<"至尊土系攻击">>
        ,type = 5
        ,step = 1
        ,craft = 4
        ,exp = 4
        ,next_id = 83401
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 83400, 1, 1, [5,0,2150], []}
    };
get_skill(83401) ->
    #demon_skill{
        id = 83401
        ,name = <<"至尊土系攻击">>
        ,type = 5
        ,step = 2
        ,craft = 4
        ,exp = 10
        ,next_id = 83402
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 83400, 1, 1, [7,0,2300], []}
    };
get_skill(83402) ->
    #demon_skill{
        id = 83402
        ,name = <<"至尊土系攻击">>
        ,type = 5
        ,step = 3
        ,craft = 4
        ,exp = 20
        ,next_id = 83403
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 83400, 1, 1, [9,0,2450], []}
    };
get_skill(83403) ->
    #demon_skill{
        id = 83403
        ,name = <<"至尊土系攻击">>
        ,type = 5
        ,step = 4
        ,craft = 4
        ,exp = 42
        ,next_id = 83404
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 83400, 1, 1, [11,0,2600], []}
    };
get_skill(83404) ->
    #demon_skill{
        id = 83404
        ,name = <<"至尊土系攻击">>
        ,type = 5
        ,step = 5
        ,craft = 4
        ,exp = 84
        ,next_id = 83405
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 83400, 1, 1, [13,0,2750], []}
    };
get_skill(83405) ->
    #demon_skill{
        id = 83405
        ,name = <<"至尊土系攻击">>
        ,type = 5
        ,step = 6
        ,craft = 4
        ,exp = 170
        ,next_id = 83406
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 83400, 1, 1, [15,0,2900], []}
    };
get_skill(83406) ->
    #demon_skill{
        id = 83406
        ,name = <<"至尊土系攻击">>
        ,type = 5
        ,step = 7
        ,craft = 4
        ,exp = 340
        ,next_id = 83407
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 83400, 1, 1, [17,0,3050], []}
    };
get_skill(83407) ->
    #demon_skill{
        id = 83407
        ,name = <<"至尊土系攻击">>
        ,type = 5
        ,step = 8
        ,craft = 4
        ,exp = 682
        ,next_id = 83408
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 83400, 1, 1, [19,0,3200], []}
    };
get_skill(83408) ->
    #demon_skill{
        id = 83408
        ,name = <<"至尊土系攻击">>
        ,type = 5
        ,step = 9
        ,craft = 4
        ,exp = 1365
        ,next_id = 83409
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 83400, 1, 1, [21,0,3350], []}
    };
get_skill(83409) ->
    #demon_skill{
        id = 83409
        ,name = <<"至尊土系攻击">>
        ,type = 5
        ,step = 10
        ,craft = 4
        ,exp = 1800
        ,next_id = 0
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 83400, 1, 1, [23,0,3500], []}
    };
get_skill(83500) ->
    #demon_skill{
        id = 83500
        ,name = <<"至尊法伤吸收">>
        ,type = 6
        ,step = 1
        ,craft = 4
        ,exp = 4
        ,next_id = 83501
        ,limit = []
        ,combat_info = {c_skill, 83500, 1, 1, [8,0,1350], []}
    };
get_skill(83501) ->
    #demon_skill{
        id = 83501
        ,name = <<"至尊法伤吸收">>
        ,type = 6
        ,step = 2
        ,craft = 4
        ,exp = 10
        ,next_id = 83502
        ,limit = []
        ,combat_info = {c_skill, 83500, 1, 1, [10,0,1450], []}
    };
get_skill(83502) ->
    #demon_skill{
        id = 83502
        ,name = <<"至尊法伤吸收">>
        ,type = 6
        ,step = 3
        ,craft = 4
        ,exp = 20
        ,next_id = 83503
        ,limit = []
        ,combat_info = {c_skill, 83500, 1, 1, [12,0,1550], []}
    };
get_skill(83503) ->
    #demon_skill{
        id = 83503
        ,name = <<"至尊法伤吸收">>
        ,type = 6
        ,step = 4
        ,craft = 4
        ,exp = 42
        ,next_id = 83504
        ,limit = []
        ,combat_info = {c_skill, 83500, 1, 1, [14,0,1650], []}
    };
get_skill(83504) ->
    #demon_skill{
        id = 83504
        ,name = <<"至尊法伤吸收">>
        ,type = 6
        ,step = 5
        ,craft = 4
        ,exp = 84
        ,next_id = 83505
        ,limit = []
        ,combat_info = {c_skill, 83500, 1, 1, [16,0,1750], []}
    };
get_skill(83505) ->
    #demon_skill{
        id = 83505
        ,name = <<"至尊法伤吸收">>
        ,type = 6
        ,step = 6
        ,craft = 4
        ,exp = 170
        ,next_id = 83506
        ,limit = []
        ,combat_info = {c_skill, 83500, 1, 1, [18,0,1850], []}
    };
get_skill(83506) ->
    #demon_skill{
        id = 83506
        ,name = <<"至尊法伤吸收">>
        ,type = 6
        ,step = 7
        ,craft = 4
        ,exp = 340
        ,next_id = 83507
        ,limit = []
        ,combat_info = {c_skill, 83500, 1, 1, [20,0,1950], []}
    };
get_skill(83507) ->
    #demon_skill{
        id = 83507
        ,name = <<"至尊法伤吸收">>
        ,type = 6
        ,step = 8
        ,craft = 4
        ,exp = 682
        ,next_id = 83508
        ,limit = []
        ,combat_info = {c_skill, 83500, 1, 1, [22,0,2050], []}
    };
get_skill(83508) ->
    #demon_skill{
        id = 83508
        ,name = <<"至尊法伤吸收">>
        ,type = 6
        ,step = 9
        ,craft = 4
        ,exp = 1365
        ,next_id = 83509
        ,limit = []
        ,combat_info = {c_skill, 83500, 1, 1, [24,0,2150], []}
    };
get_skill(83509) ->
    #demon_skill{
        id = 83509
        ,name = <<"至尊法伤吸收">>
        ,type = 6
        ,step = 10
        ,craft = 4
        ,exp = 1800
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 83500, 1, 1, [26,0,2250], []}
    };
get_skill(83600) ->
    #demon_skill{
        id = 83600
        ,name = <<"至尊伤害抵抗">>
        ,type = 7
        ,step = 1
        ,craft = 4
        ,exp = 4
        ,next_id = 83601
        ,limit = []
        ,combat_info = {c_skill, 83600, 1, 1, [8,16,0], []}
    };
get_skill(83601) ->
    #demon_skill{
        id = 83601
        ,name = <<"至尊伤害抵抗">>
        ,type = 7
        ,step = 2
        ,craft = 4
        ,exp = 10
        ,next_id = 83602
        ,limit = []
        ,combat_info = {c_skill, 83600, 1, 1, [10,17,0], []}
    };
get_skill(83602) ->
    #demon_skill{
        id = 83602
        ,name = <<"至尊伤害抵抗">>
        ,type = 7
        ,step = 3
        ,craft = 4
        ,exp = 20
        ,next_id = 83603
        ,limit = []
        ,combat_info = {c_skill, 83600, 1, 1, [12,18,0], []}
    };
get_skill(83603) ->
    #demon_skill{
        id = 83603
        ,name = <<"至尊伤害抵抗">>
        ,type = 7
        ,step = 4
        ,craft = 4
        ,exp = 42
        ,next_id = 83604
        ,limit = []
        ,combat_info = {c_skill, 83600, 1, 1, [14,19,0], []}
    };
get_skill(83604) ->
    #demon_skill{
        id = 83604
        ,name = <<"至尊伤害抵抗">>
        ,type = 7
        ,step = 5
        ,craft = 4
        ,exp = 84
        ,next_id = 83605
        ,limit = []
        ,combat_info = {c_skill, 83600, 1, 1, [16,20,0], []}
    };
get_skill(83605) ->
    #demon_skill{
        id = 83605
        ,name = <<"至尊伤害抵抗">>
        ,type = 7
        ,step = 6
        ,craft = 4
        ,exp = 170
        ,next_id = 83606
        ,limit = []
        ,combat_info = {c_skill, 83600, 1, 1, [18,21,0], []}
    };
get_skill(83606) ->
    #demon_skill{
        id = 83606
        ,name = <<"至尊伤害抵抗">>
        ,type = 7
        ,step = 7
        ,craft = 4
        ,exp = 340
        ,next_id = 83607
        ,limit = []
        ,combat_info = {c_skill, 83600, 1, 1, [20,22,0], []}
    };
get_skill(83607) ->
    #demon_skill{
        id = 83607
        ,name = <<"至尊伤害抵抗">>
        ,type = 7
        ,step = 8
        ,craft = 4
        ,exp = 682
        ,next_id = 83608
        ,limit = []
        ,combat_info = {c_skill, 83600, 1, 1, [22,23,0], []}
    };
get_skill(83608) ->
    #demon_skill{
        id = 83608
        ,name = <<"至尊伤害抵抗">>
        ,type = 7
        ,step = 9
        ,craft = 4
        ,exp = 1365
        ,next_id = 83609
        ,limit = []
        ,combat_info = {c_skill, 83600, 1, 1, [24,24,0], []}
    };
get_skill(83609) ->
    #demon_skill{
        id = 83609
        ,name = <<"至尊伤害抵抗">>
        ,type = 7
        ,step = 10
        ,craft = 4
        ,exp = 1800
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 83600, 1, 1, [26,25,0], []}
    };
get_skill(83900) ->
    #demon_skill{
        id = 83900
        ,name = <<"至尊灵动">>
        ,type = 15
        ,step = 1
        ,craft = 4
        ,exp = 4
        ,next_id = 83901
        ,limit = []
        ,combat_info = {c_skill, 83900, 1, 1, [80], []}
    };
get_skill(83901) ->
    #demon_skill{
        id = 83901
        ,name = <<"至尊灵动">>
        ,type = 15
        ,step = 2
        ,craft = 4
        ,exp = 10
        ,next_id = 83902
        ,limit = []
        ,combat_info = {c_skill, 83900, 1, 1, [85], []}
    };
get_skill(83902) ->
    #demon_skill{
        id = 83902
        ,name = <<"至尊灵动">>
        ,type = 15
        ,step = 3
        ,craft = 4
        ,exp = 20
        ,next_id = 83903
        ,limit = []
        ,combat_info = {c_skill, 83900, 1, 1, [90], []}
    };
get_skill(83903) ->
    #demon_skill{
        id = 83903
        ,name = <<"至尊灵动">>
        ,type = 15
        ,step = 4
        ,craft = 4
        ,exp = 42
        ,next_id = 83904
        ,limit = []
        ,combat_info = {c_skill, 83900, 1, 1, [95], []}
    };
get_skill(83904) ->
    #demon_skill{
        id = 83904
        ,name = <<"至尊灵动">>
        ,type = 15
        ,step = 5
        ,craft = 4
        ,exp = 84
        ,next_id = 83905
        ,limit = []
        ,combat_info = {c_skill, 83900, 1, 1, [100], []}
    };
get_skill(83905) ->
    #demon_skill{
        id = 83905
        ,name = <<"至尊灵动">>
        ,type = 15
        ,step = 6
        ,craft = 4
        ,exp = 170
        ,next_id = 83906
        ,limit = []
        ,combat_info = {c_skill, 83900, 1, 1, [105], []}
    };
get_skill(83906) ->
    #demon_skill{
        id = 83906
        ,name = <<"至尊灵动">>
        ,type = 15
        ,step = 7
        ,craft = 4
        ,exp = 340
        ,next_id = 83907
        ,limit = []
        ,combat_info = {c_skill, 83900, 1, 1, [110], []}
    };
get_skill(83907) ->
    #demon_skill{
        id = 83907
        ,name = <<"至尊灵动">>
        ,type = 15
        ,step = 8
        ,craft = 4
        ,exp = 682
        ,next_id = 83908
        ,limit = []
        ,combat_info = {c_skill, 83900, 1, 1, [115], []}
    };
get_skill(83908) ->
    #demon_skill{
        id = 83908
        ,name = <<"至尊灵动">>
        ,type = 15
        ,step = 9
        ,craft = 4
        ,exp = 1365
        ,next_id = 83909
        ,limit = []
        ,combat_info = {c_skill, 83900, 1, 1, [120], []}
    };
get_skill(83909) ->
    #demon_skill{
        id = 83909
        ,name = <<"至尊灵动">>
        ,type = 15
        ,step = 10
        ,craft = 4
        ,exp = 1800
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 83900, 1, 1, [125], []}
    };
get_skill(83800) ->
    #demon_skill{
        id = 83800
        ,name = <<"至尊震怒">>
        ,type = 16
        ,step = 1
        ,craft = 4
        ,exp = 4
        ,next_id = 83801
        ,limit = []
        ,combat_info = {c_skill, 83800, 1, 1, [290], []}
    };
get_skill(83801) ->
    #demon_skill{
        id = 83801
        ,name = <<"至尊震怒">>
        ,type = 16
        ,step = 2
        ,craft = 4
        ,exp = 10
        ,next_id = 83802
        ,limit = []
        ,combat_info = {c_skill, 83800, 1, 1, [300], []}
    };
get_skill(83802) ->
    #demon_skill{
        id = 83802
        ,name = <<"至尊震怒">>
        ,type = 16
        ,step = 3
        ,craft = 4
        ,exp = 20
        ,next_id = 83803
        ,limit = []
        ,combat_info = {c_skill, 83800, 1, 1, [310], []}
    };
get_skill(83803) ->
    #demon_skill{
        id = 83803
        ,name = <<"至尊震怒">>
        ,type = 16
        ,step = 4
        ,craft = 4
        ,exp = 42
        ,next_id = 83804
        ,limit = []
        ,combat_info = {c_skill, 83800, 1, 1, [320], []}
    };
get_skill(83804) ->
    #demon_skill{
        id = 83804
        ,name = <<"至尊震怒">>
        ,type = 16
        ,step = 5
        ,craft = 4
        ,exp = 84
        ,next_id = 83805
        ,limit = []
        ,combat_info = {c_skill, 83800, 1, 1, [330], []}
    };
get_skill(83805) ->
    #demon_skill{
        id = 83805
        ,name = <<"至尊震怒">>
        ,type = 16
        ,step = 6
        ,craft = 4
        ,exp = 170
        ,next_id = 83806
        ,limit = []
        ,combat_info = {c_skill, 83800, 1, 1, [340], []}
    };
get_skill(83806) ->
    #demon_skill{
        id = 83806
        ,name = <<"至尊震怒">>
        ,type = 16
        ,step = 7
        ,craft = 4
        ,exp = 340
        ,next_id = 83807
        ,limit = []
        ,combat_info = {c_skill, 83800, 1, 1, [350], []}
    };
get_skill(83807) ->
    #demon_skill{
        id = 83807
        ,name = <<"至尊震怒">>
        ,type = 16
        ,step = 8
        ,craft = 4
        ,exp = 682
        ,next_id = 83808
        ,limit = []
        ,combat_info = {c_skill, 83800, 1, 1, [360], []}
    };
get_skill(83808) ->
    #demon_skill{
        id = 83808
        ,name = <<"至尊震怒">>
        ,type = 16
        ,step = 9
        ,craft = 4
        ,exp = 1365
        ,next_id = 83809
        ,limit = []
        ,combat_info = {c_skill, 83800, 1, 1, [370], []}
    };
get_skill(83809) ->
    #demon_skill{
        id = 83809
        ,name = <<"至尊震怒">>
        ,type = 16
        ,step = 10
        ,craft = 4
        ,exp = 1800
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 83800, 1, 1, [380], []}
    };
get_skill(82000) ->
    #demon_skill{
        id = 82000
        ,name = <<"神级金系攻击">>
        ,type = 1
        ,step = 1
        ,craft = 5
        ,exp = 6
        ,next_id = 82001
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 82000, 1, 1, [5,0,2550], []}
    };
get_skill(82001) ->
    #demon_skill{
        id = 82001
        ,name = <<"神级金系攻击">>
        ,type = 1
        ,step = 2
        ,craft = 5
        ,exp = 15
        ,next_id = 82002
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 82000, 1, 1, [7,0,2700], []}
    };
get_skill(82002) ->
    #demon_skill{
        id = 82002
        ,name = <<"神级金系攻击">>
        ,type = 1
        ,step = 3
        ,craft = 5
        ,exp = 30
        ,next_id = 82003
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 82000, 1, 1, [9,0,2850], []}
    };
get_skill(82003) ->
    #demon_skill{
        id = 82003
        ,name = <<"神级金系攻击">>
        ,type = 1
        ,step = 4
        ,craft = 5
        ,exp = 63
        ,next_id = 82004
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 82000, 1, 1, [11,0,3000], []}
    };
get_skill(82004) ->
    #demon_skill{
        id = 82004
        ,name = <<"神级金系攻击">>
        ,type = 1
        ,step = 5
        ,craft = 5
        ,exp = 126
        ,next_id = 82005
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 82000, 1, 1, [13,0,3150], []}
    };
get_skill(82005) ->
    #demon_skill{
        id = 82005
        ,name = <<"神级金系攻击">>
        ,type = 1
        ,step = 6
        ,craft = 5
        ,exp = 255
        ,next_id = 82006
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 82000, 1, 1, [15,0,3300], []}
    };
get_skill(82006) ->
    #demon_skill{
        id = 82006
        ,name = <<"神级金系攻击">>
        ,type = 1
        ,step = 7
        ,craft = 5
        ,exp = 510
        ,next_id = 82007
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 82000, 1, 1, [17,0,3450], []}
    };
get_skill(82007) ->
    #demon_skill{
        id = 82007
        ,name = <<"神级金系攻击">>
        ,type = 1
        ,step = 8
        ,craft = 5
        ,exp = 1024
        ,next_id = 82008
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 82000, 1, 1, [19,0,3600], []}
    };
get_skill(82008) ->
    #demon_skill{
        id = 82008
        ,name = <<"神级金系攻击">>
        ,type = 1
        ,step = 9
        ,craft = 5
        ,exp = 2048
        ,next_id = 82009
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 82000, 1, 1, [21,0,3750], []}
    };
get_skill(82009) ->
    #demon_skill{
        id = 82009
        ,name = <<"神级金系攻击">>
        ,type = 1
        ,step = 10
        ,craft = 5
        ,exp = 2500
        ,next_id = 0
        ,limit = [2,3,4,5]
        ,combat_info = {c_skill, 82000, 1, 1, [23,0,3900], []}
    };
get_skill(82100) ->
    #demon_skill{
        id = 82100
        ,name = <<"神级木系攻击">>
        ,type = 2
        ,step = 1
        ,craft = 5
        ,exp = 6
        ,next_id = 82101
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 82100, 1, 1, [5,0,2550], []}
    };
get_skill(82101) ->
    #demon_skill{
        id = 82101
        ,name = <<"神级木系攻击">>
        ,type = 2
        ,step = 2
        ,craft = 5
        ,exp = 15
        ,next_id = 82102
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 82100, 1, 1, [7,0,2700], []}
    };
get_skill(82102) ->
    #demon_skill{
        id = 82102
        ,name = <<"神级木系攻击">>
        ,type = 2
        ,step = 3
        ,craft = 5
        ,exp = 30
        ,next_id = 82103
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 82100, 1, 1, [9,0,2850], []}
    };
get_skill(82103) ->
    #demon_skill{
        id = 82103
        ,name = <<"神级木系攻击">>
        ,type = 2
        ,step = 4
        ,craft = 5
        ,exp = 63
        ,next_id = 82104
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 82100, 1, 1, [11,0,3000], []}
    };
get_skill(82104) ->
    #demon_skill{
        id = 82104
        ,name = <<"神级木系攻击">>
        ,type = 2
        ,step = 5
        ,craft = 5
        ,exp = 126
        ,next_id = 82105
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 82100, 1, 1, [13,0,3150], []}
    };
get_skill(82105) ->
    #demon_skill{
        id = 82105
        ,name = <<"神级木系攻击">>
        ,type = 2
        ,step = 6
        ,craft = 5
        ,exp = 255
        ,next_id = 82106
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 82100, 1, 1, [15,0,3300], []}
    };
get_skill(82106) ->
    #demon_skill{
        id = 82106
        ,name = <<"神级木系攻击">>
        ,type = 2
        ,step = 7
        ,craft = 5
        ,exp = 510
        ,next_id = 82107
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 82100, 1, 1, [17,0,3450], []}
    };
get_skill(82107) ->
    #demon_skill{
        id = 82107
        ,name = <<"神级木系攻击">>
        ,type = 2
        ,step = 8
        ,craft = 5
        ,exp = 1024
        ,next_id = 82108
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 82100, 1, 1, [19,0,3600], []}
    };
get_skill(82108) ->
    #demon_skill{
        id = 82108
        ,name = <<"神级木系攻击">>
        ,type = 2
        ,step = 9
        ,craft = 5
        ,exp = 2048
        ,next_id = 82109
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 82100, 1, 1, [21,0,3750], []}
    };
get_skill(82109) ->
    #demon_skill{
        id = 82109
        ,name = <<"神级木系攻击">>
        ,type = 2
        ,step = 10
        ,craft = 5
        ,exp = 2500
        ,next_id = 0
        ,limit = [1,3,4,5]
        ,combat_info = {c_skill, 82100, 1, 1, [23,0,3900], []}
    };
get_skill(82200) ->
    #demon_skill{
        id = 82200
        ,name = <<"神级水系攻击">>
        ,type = 3
        ,step = 1
        ,craft = 5
        ,exp = 6
        ,next_id = 82201
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 82200, 1, 1, [5,0,2550], []}
    };
get_skill(82201) ->
    #demon_skill{
        id = 82201
        ,name = <<"神级水系攻击">>
        ,type = 3
        ,step = 2
        ,craft = 5
        ,exp = 15
        ,next_id = 82202
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 82200, 1, 1, [7,0,2700], []}
    };
get_skill(82202) ->
    #demon_skill{
        id = 82202
        ,name = <<"神级水系攻击">>
        ,type = 3
        ,step = 3
        ,craft = 5
        ,exp = 30
        ,next_id = 82203
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 82200, 1, 1, [9,0,2850], []}
    };
get_skill(82203) ->
    #demon_skill{
        id = 82203
        ,name = <<"神级水系攻击">>
        ,type = 3
        ,step = 4
        ,craft = 5
        ,exp = 63
        ,next_id = 82204
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 82200, 1, 1, [11,0,3000], []}
    };
get_skill(82204) ->
    #demon_skill{
        id = 82204
        ,name = <<"神级水系攻击">>
        ,type = 3
        ,step = 5
        ,craft = 5
        ,exp = 126
        ,next_id = 82205
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 82200, 1, 1, [13,0,3150], []}
    };
get_skill(82205) ->
    #demon_skill{
        id = 82205
        ,name = <<"神级水系攻击">>
        ,type = 3
        ,step = 6
        ,craft = 5
        ,exp = 255
        ,next_id = 82206
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 82200, 1, 1, [15,0,3300], []}
    };
get_skill(82206) ->
    #demon_skill{
        id = 82206
        ,name = <<"神级水系攻击">>
        ,type = 3
        ,step = 7
        ,craft = 5
        ,exp = 510
        ,next_id = 82207
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 82200, 1, 1, [17,0,3450], []}
    };
get_skill(82207) ->
    #demon_skill{
        id = 82207
        ,name = <<"神级水系攻击">>
        ,type = 3
        ,step = 8
        ,craft = 5
        ,exp = 1024
        ,next_id = 82208
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 82200, 1, 1, [19,0,3600], []}
    };
get_skill(82208) ->
    #demon_skill{
        id = 82208
        ,name = <<"神级水系攻击">>
        ,type = 3
        ,step = 9
        ,craft = 5
        ,exp = 2048
        ,next_id = 82209
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 82200, 1, 1, [21,0,3750], []}
    };
get_skill(82209) ->
    #demon_skill{
        id = 82209
        ,name = <<"神级水系攻击">>
        ,type = 3
        ,step = 10
        ,craft = 5
        ,exp = 2500
        ,next_id = 0
        ,limit = [1,2,4,5]
        ,combat_info = {c_skill, 82200, 1, 1, [23,0,3900], []}
    };
get_skill(82300) ->
    #demon_skill{
        id = 82300
        ,name = <<"神级火系攻击">>
        ,type = 4
        ,step = 1
        ,craft = 5
        ,exp = 6
        ,next_id = 82301
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 82300, 1, 1, [5,0,2550], []}
    };
get_skill(82301) ->
    #demon_skill{
        id = 82301
        ,name = <<"神级火系攻击">>
        ,type = 4
        ,step = 2
        ,craft = 5
        ,exp = 15
        ,next_id = 82302
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 82300, 1, 1, [7,0,2700], []}
    };
get_skill(82302) ->
    #demon_skill{
        id = 82302
        ,name = <<"神级火系攻击">>
        ,type = 4
        ,step = 3
        ,craft = 5
        ,exp = 30
        ,next_id = 82303
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 82300, 1, 1, [9,0,2850], []}
    };
get_skill(82303) ->
    #demon_skill{
        id = 82303
        ,name = <<"神级火系攻击">>
        ,type = 4
        ,step = 4
        ,craft = 5
        ,exp = 63
        ,next_id = 82304
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 82300, 1, 1, [11,0,3000], []}
    };
get_skill(82304) ->
    #demon_skill{
        id = 82304
        ,name = <<"神级火系攻击">>
        ,type = 4
        ,step = 5
        ,craft = 5
        ,exp = 126
        ,next_id = 82305
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 82300, 1, 1, [13,0,3150], []}
    };
get_skill(82305) ->
    #demon_skill{
        id = 82305
        ,name = <<"神级火系攻击">>
        ,type = 4
        ,step = 6
        ,craft = 5
        ,exp = 255
        ,next_id = 82306
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 82300, 1, 1, [15,0,3300], []}
    };
get_skill(82306) ->
    #demon_skill{
        id = 82306
        ,name = <<"神级火系攻击">>
        ,type = 4
        ,step = 7
        ,craft = 5
        ,exp = 510
        ,next_id = 82307
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 82300, 1, 1, [17,0,3450], []}
    };
get_skill(82307) ->
    #demon_skill{
        id = 82307
        ,name = <<"神级火系攻击">>
        ,type = 4
        ,step = 8
        ,craft = 5
        ,exp = 1024
        ,next_id = 82308
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 82300, 1, 1, [19,0,3600], []}
    };
get_skill(82308) ->
    #demon_skill{
        id = 82308
        ,name = <<"神级火系攻击">>
        ,type = 4
        ,step = 9
        ,craft = 5
        ,exp = 2048
        ,next_id = 82309
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 82300, 1, 1, [21,0,3750], []}
    };
get_skill(82309) ->
    #demon_skill{
        id = 82309
        ,name = <<"神级火系攻击">>
        ,type = 4
        ,step = 10
        ,craft = 5
        ,exp = 2500
        ,next_id = 0
        ,limit = [1,2,3,5]
        ,combat_info = {c_skill, 82300, 1, 1, [23,0,3900], []}
    };
get_skill(82400) ->
    #demon_skill{
        id = 82400
        ,name = <<"神级土系攻击">>
        ,type = 5
        ,step = 1
        ,craft = 5
        ,exp = 6
        ,next_id = 82401
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 82400, 1, 1, [5,0,2550], []}
    };
get_skill(82401) ->
    #demon_skill{
        id = 82401
        ,name = <<"神级土系攻击">>
        ,type = 5
        ,step = 2
        ,craft = 5
        ,exp = 15
        ,next_id = 82402
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 82400, 1, 1, [7,0,2700], []}
    };
get_skill(82402) ->
    #demon_skill{
        id = 82402
        ,name = <<"神级土系攻击">>
        ,type = 5
        ,step = 3
        ,craft = 5
        ,exp = 30
        ,next_id = 82403
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 82400, 1, 1, [9,0,2850], []}
    };
get_skill(82403) ->
    #demon_skill{
        id = 82403
        ,name = <<"神级土系攻击">>
        ,type = 5
        ,step = 4
        ,craft = 5
        ,exp = 63
        ,next_id = 82404
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 82400, 1, 1, [11,0,3000], []}
    };
get_skill(82404) ->
    #demon_skill{
        id = 82404
        ,name = <<"神级土系攻击">>
        ,type = 5
        ,step = 5
        ,craft = 5
        ,exp = 126
        ,next_id = 82405
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 82400, 1, 1, [13,0,3150], []}
    };
get_skill(82405) ->
    #demon_skill{
        id = 82405
        ,name = <<"神级土系攻击">>
        ,type = 5
        ,step = 6
        ,craft = 5
        ,exp = 255
        ,next_id = 82406
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 82400, 1, 1, [15,0,3300], []}
    };
get_skill(82406) ->
    #demon_skill{
        id = 82406
        ,name = <<"神级土系攻击">>
        ,type = 5
        ,step = 7
        ,craft = 5
        ,exp = 510
        ,next_id = 82407
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 82400, 1, 1, [17,0,3450], []}
    };
get_skill(82407) ->
    #demon_skill{
        id = 82407
        ,name = <<"神级土系攻击">>
        ,type = 5
        ,step = 8
        ,craft = 5
        ,exp = 1024
        ,next_id = 82408
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 82400, 1, 1, [19,0,3600], []}
    };
get_skill(82408) ->
    #demon_skill{
        id = 82408
        ,name = <<"神级土系攻击">>
        ,type = 5
        ,step = 9
        ,craft = 5
        ,exp = 2048
        ,next_id = 82409
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 82400, 1, 1, [21,0,3750], []}
    };
get_skill(82409) ->
    #demon_skill{
        id = 82409
        ,name = <<"神级土系攻击">>
        ,type = 5
        ,step = 10
        ,craft = 5
        ,exp = 2500
        ,next_id = 0
        ,limit = [1,2,3,4]
        ,combat_info = {c_skill, 82400, 1, 1, [23,0,3900], []}
    };
get_skill(82500) ->
    #demon_skill{
        id = 82500
        ,name = <<"神级法伤吸收">>
        ,type = 6
        ,step = 1
        ,craft = 5
        ,exp = 6
        ,next_id = 82501
        ,limit = []
        ,combat_info = {c_skill, 82500, 1, 1, [9,0,1750], []}
    };
get_skill(82501) ->
    #demon_skill{
        id = 82501
        ,name = <<"神级法伤吸收">>
        ,type = 6
        ,step = 2
        ,craft = 5
        ,exp = 15
        ,next_id = 82502
        ,limit = []
        ,combat_info = {c_skill, 82500, 1, 1, [11,0,1850], []}
    };
get_skill(82502) ->
    #demon_skill{
        id = 82502
        ,name = <<"神级法伤吸收">>
        ,type = 6
        ,step = 3
        ,craft = 5
        ,exp = 30
        ,next_id = 82503
        ,limit = []
        ,combat_info = {c_skill, 82500, 1, 1, [13,0,1950], []}
    };
get_skill(82503) ->
    #demon_skill{
        id = 82503
        ,name = <<"神级法伤吸收">>
        ,type = 6
        ,step = 4
        ,craft = 5
        ,exp = 63
        ,next_id = 82504
        ,limit = []
        ,combat_info = {c_skill, 82500, 1, 1, [15,0,2050], []}
    };
get_skill(82504) ->
    #demon_skill{
        id = 82504
        ,name = <<"神级法伤吸收">>
        ,type = 6
        ,step = 5
        ,craft = 5
        ,exp = 126
        ,next_id = 82505
        ,limit = []
        ,combat_info = {c_skill, 82500, 1, 1, [17,0,2150], []}
    };
get_skill(82505) ->
    #demon_skill{
        id = 82505
        ,name = <<"神级法伤吸收">>
        ,type = 6
        ,step = 6
        ,craft = 5
        ,exp = 255
        ,next_id = 82506
        ,limit = []
        ,combat_info = {c_skill, 82500, 1, 1, [19,0,2250], []}
    };
get_skill(82506) ->
    #demon_skill{
        id = 82506
        ,name = <<"神级法伤吸收">>
        ,type = 6
        ,step = 7
        ,craft = 5
        ,exp = 510
        ,next_id = 82507
        ,limit = []
        ,combat_info = {c_skill, 82500, 1, 1, [21,0,2350], []}
    };
get_skill(82507) ->
    #demon_skill{
        id = 82507
        ,name = <<"神级法伤吸收">>
        ,type = 6
        ,step = 8
        ,craft = 5
        ,exp = 1024
        ,next_id = 82508
        ,limit = []
        ,combat_info = {c_skill, 82500, 1, 1, [23,0,2450], []}
    };
get_skill(82508) ->
    #demon_skill{
        id = 82508
        ,name = <<"神级法伤吸收">>
        ,type = 6
        ,step = 9
        ,craft = 5
        ,exp = 2048
        ,next_id = 82509
        ,limit = []
        ,combat_info = {c_skill, 82500, 1, 1, [25,0,2550], []}
    };
get_skill(82509) ->
    #demon_skill{
        id = 82509
        ,name = <<"神级法伤吸收">>
        ,type = 6
        ,step = 10
        ,craft = 5
        ,exp = 2500
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 82500, 1, 1, [27,0,2650], []}
    };
get_skill(82600) ->
    #demon_skill{
        id = 82600
        ,name = <<"神级伤害抵抗">>
        ,type = 7
        ,step = 1
        ,craft = 5
        ,exp = 6
        ,next_id = 82601
        ,limit = []
        ,combat_info = {c_skill, 82600, 1, 1, [9,20,0], []}
    };
get_skill(82601) ->
    #demon_skill{
        id = 82601
        ,name = <<"神级伤害抵抗">>
        ,type = 7
        ,step = 2
        ,craft = 5
        ,exp = 15
        ,next_id = 82602
        ,limit = []
        ,combat_info = {c_skill, 82600, 1, 1, [11,21,0], []}
    };
get_skill(82602) ->
    #demon_skill{
        id = 82602
        ,name = <<"神级伤害抵抗">>
        ,type = 7
        ,step = 3
        ,craft = 5
        ,exp = 30
        ,next_id = 82603
        ,limit = []
        ,combat_info = {c_skill, 82600, 1, 1, [13,22,0], []}
    };
get_skill(82603) ->
    #demon_skill{
        id = 82603
        ,name = <<"神级伤害抵抗">>
        ,type = 7
        ,step = 4
        ,craft = 5
        ,exp = 63
        ,next_id = 82604
        ,limit = []
        ,combat_info = {c_skill, 82600, 1, 1, [15,23,0], []}
    };
get_skill(82604) ->
    #demon_skill{
        id = 82604
        ,name = <<"神级伤害抵抗">>
        ,type = 7
        ,step = 5
        ,craft = 5
        ,exp = 126
        ,next_id = 82605
        ,limit = []
        ,combat_info = {c_skill, 82600, 1, 1, [17,24,0], []}
    };
get_skill(82605) ->
    #demon_skill{
        id = 82605
        ,name = <<"神级伤害抵抗">>
        ,type = 7
        ,step = 6
        ,craft = 5
        ,exp = 255
        ,next_id = 82606
        ,limit = []
        ,combat_info = {c_skill, 82600, 1, 1, [19,25,0], []}
    };
get_skill(82606) ->
    #demon_skill{
        id = 82606
        ,name = <<"神级伤害抵抗">>
        ,type = 7
        ,step = 7
        ,craft = 5
        ,exp = 510
        ,next_id = 82607
        ,limit = []
        ,combat_info = {c_skill, 82600, 1, 1, [21,26,0], []}
    };
get_skill(82607) ->
    #demon_skill{
        id = 82607
        ,name = <<"神级伤害抵抗">>
        ,type = 7
        ,step = 8
        ,craft = 5
        ,exp = 1024
        ,next_id = 82608
        ,limit = []
        ,combat_info = {c_skill, 82600, 1, 1, [23,27,0], []}
    };
get_skill(82608) ->
    #demon_skill{
        id = 82608
        ,name = <<"神级伤害抵抗">>
        ,type = 7
        ,step = 9
        ,craft = 5
        ,exp = 2048
        ,next_id = 82609
        ,limit = []
        ,combat_info = {c_skill, 82600, 1, 1, [25,28,0], []}
    };
get_skill(82609) ->
    #demon_skill{
        id = 82609
        ,name = <<"神级伤害抵抗">>
        ,type = 7
        ,step = 10
        ,craft = 5
        ,exp = 2500
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 82600, 1, 1, [27,29,0], []}
    };
get_skill(82900) ->
    #demon_skill{
        id = 82900
        ,name = <<"神级灵动">>
        ,type = 15
        ,step = 1
        ,craft = 5
        ,exp = 6
        ,next_id = 82901
        ,limit = []
        ,combat_info = {c_skill, 82900, 1, 1, [105], []}
    };
get_skill(82901) ->
    #demon_skill{
        id = 82901
        ,name = <<"神级灵动">>
        ,type = 15
        ,step = 2
        ,craft = 5
        ,exp = 15
        ,next_id = 82902
        ,limit = []
        ,combat_info = {c_skill, 82900, 1, 1, [110], []}
    };
get_skill(82902) ->
    #demon_skill{
        id = 82902
        ,name = <<"神级灵动">>
        ,type = 15
        ,step = 3
        ,craft = 5
        ,exp = 30
        ,next_id = 82903
        ,limit = []
        ,combat_info = {c_skill, 82900, 1, 1, [115], []}
    };
get_skill(82903) ->
    #demon_skill{
        id = 82903
        ,name = <<"神级灵动">>
        ,type = 15
        ,step = 4
        ,craft = 5
        ,exp = 63
        ,next_id = 82904
        ,limit = []
        ,combat_info = {c_skill, 82900, 1, 1, [120], []}
    };
get_skill(82904) ->
    #demon_skill{
        id = 82904
        ,name = <<"神级灵动">>
        ,type = 15
        ,step = 5
        ,craft = 5
        ,exp = 126
        ,next_id = 82905
        ,limit = []
        ,combat_info = {c_skill, 82900, 1, 1, [125], []}
    };
get_skill(82905) ->
    #demon_skill{
        id = 82905
        ,name = <<"神级灵动">>
        ,type = 15
        ,step = 6
        ,craft = 5
        ,exp = 255
        ,next_id = 82906
        ,limit = []
        ,combat_info = {c_skill, 82900, 1, 1, [130], []}
    };
get_skill(82906) ->
    #demon_skill{
        id = 82906
        ,name = <<"神级灵动">>
        ,type = 15
        ,step = 7
        ,craft = 5
        ,exp = 510
        ,next_id = 82907
        ,limit = []
        ,combat_info = {c_skill, 82900, 1, 1, [135], []}
    };
get_skill(82907) ->
    #demon_skill{
        id = 82907
        ,name = <<"神级灵动">>
        ,type = 15
        ,step = 8
        ,craft = 5
        ,exp = 1024
        ,next_id = 82908
        ,limit = []
        ,combat_info = {c_skill, 82900, 1, 1, [140], []}
    };
get_skill(82908) ->
    #demon_skill{
        id = 82908
        ,name = <<"神级灵动">>
        ,type = 15
        ,step = 9
        ,craft = 5
        ,exp = 2048
        ,next_id = 82909
        ,limit = []
        ,combat_info = {c_skill, 82900, 1, 1, [145], []}
    };
get_skill(82909) ->
    #demon_skill{
        id = 82909
        ,name = <<"神级灵动">>
        ,type = 15
        ,step = 10
        ,craft = 5
        ,exp = 2500
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 82900, 1, 1, [150], []}
    };
get_skill(82800) ->
    #demon_skill{
        id = 82800
        ,name = <<"神级震怒">>
        ,type = 16
        ,step = 1
        ,craft = 5
        ,exp = 6
        ,next_id = 82801
        ,limit = []
        ,combat_info = {c_skill, 82800, 1, 1, [320], []}
    };
get_skill(82801) ->
    #demon_skill{
        id = 82801
        ,name = <<"神级震怒">>
        ,type = 16
        ,step = 2
        ,craft = 5
        ,exp = 15
        ,next_id = 82802
        ,limit = []
        ,combat_info = {c_skill, 82800, 1, 1, [330], []}
    };
get_skill(82802) ->
    #demon_skill{
        id = 82802
        ,name = <<"神级震怒">>
        ,type = 16
        ,step = 3
        ,craft = 5
        ,exp = 30
        ,next_id = 82803
        ,limit = []
        ,combat_info = {c_skill, 82800, 1, 1, [340], []}
    };
get_skill(82803) ->
    #demon_skill{
        id = 82803
        ,name = <<"神级震怒">>
        ,type = 16
        ,step = 4
        ,craft = 5
        ,exp = 63
        ,next_id = 82804
        ,limit = []
        ,combat_info = {c_skill, 82800, 1, 1, [350], []}
    };
get_skill(82804) ->
    #demon_skill{
        id = 82804
        ,name = <<"神级震怒">>
        ,type = 16
        ,step = 5
        ,craft = 5
        ,exp = 126
        ,next_id = 82805
        ,limit = []
        ,combat_info = {c_skill, 82800, 1, 1, [360], []}
    };
get_skill(82805) ->
    #demon_skill{
        id = 82805
        ,name = <<"神级震怒">>
        ,type = 16
        ,step = 6
        ,craft = 5
        ,exp = 255
        ,next_id = 82806
        ,limit = []
        ,combat_info = {c_skill, 82800, 1, 1, [370], []}
    };
get_skill(82806) ->
    #demon_skill{
        id = 82806
        ,name = <<"神级震怒">>
        ,type = 16
        ,step = 7
        ,craft = 5
        ,exp = 510
        ,next_id = 82807
        ,limit = []
        ,combat_info = {c_skill, 82800, 1, 1, [380], []}
    };
get_skill(82807) ->
    #demon_skill{
        id = 82807
        ,name = <<"神级震怒">>
        ,type = 16
        ,step = 8
        ,craft = 5
        ,exp = 1024
        ,next_id = 82808
        ,limit = []
        ,combat_info = {c_skill, 82800, 1, 1, [390], []}
    };
get_skill(82808) ->
    #demon_skill{
        id = 82808
        ,name = <<"神级震怒">>
        ,type = 16
        ,step = 9
        ,craft = 5
        ,exp = 2048
        ,next_id = 82809
        ,limit = []
        ,combat_info = {c_skill, 82800, 1, 1, [400], []}
    };
get_skill(82809) ->
    #demon_skill{
        id = 82809
        ,name = <<"神级震怒">>
        ,type = 16
        ,step = 10
        ,craft = 5
        ,exp = 2500
        ,next_id = 0
        ,limit = []
        ,combat_info = {c_skill, 82800, 1, 1, [410], []}
    };
get_skill(89000) ->
    #demon_skill{
        id = 89000
        ,name = <<"初级急速治愈">>
        ,type = 8
        ,step = 1
        ,craft = 1
        ,exp = 2
        ,next_id = 89001
        ,limit = []
        ,pet_info = {pet_skill, 289000, [6], [{101011,[100,3,1,1000]}], [], 3}
    };
get_skill(89001) ->
    #demon_skill{
        id = 89001
        ,name = <<"初级急速治愈">>
        ,type = 8
        ,step = 2
        ,craft = 1
        ,exp = 5
        ,next_id = 89002
        ,limit = []
        ,pet_info = {pet_skill, 289000, [7], [{101011,[100,3,1,1500]}], [], 3}
    };
get_skill(89002) ->
    #demon_skill{
        id = 89002
        ,name = <<"初级急速治愈">>
        ,type = 8
        ,step = 3
        ,craft = 1
        ,exp = 10
        ,next_id = 89003
        ,limit = []
        ,pet_info = {pet_skill, 289000, [8], [{101011,[100,3,1,2000]}], [], 3}
    };
get_skill(89003) ->
    #demon_skill{
        id = 89003
        ,name = <<"初级急速治愈">>
        ,type = 8
        ,step = 4
        ,craft = 1
        ,exp = 21
        ,next_id = 89004
        ,limit = []
        ,pet_info = {pet_skill, 289000, [9], [{101011,[100,3,1,2500]}], [], 3}
    };
get_skill(89004) ->
    #demon_skill{
        id = 89004
        ,name = <<"初级急速治愈">>
        ,type = 8
        ,step = 5
        ,craft = 1
        ,exp = 42
        ,next_id = 89005
        ,limit = []
        ,pet_info = {pet_skill, 289000, [10], [{101011,[100,3,1,3000]}], [], 3}
    };
get_skill(89005) ->
    #demon_skill{
        id = 89005
        ,name = <<"初级急速治愈">>
        ,type = 8
        ,step = 6
        ,craft = 1
        ,exp = 85
        ,next_id = 89006
        ,limit = []
        ,pet_info = {pet_skill, 289000, [11], [{101011,[100,3,1,3500]}], [], 3}
    };
get_skill(89006) ->
    #demon_skill{
        id = 89006
        ,name = <<"初级急速治愈">>
        ,type = 8
        ,step = 7
        ,craft = 1
        ,exp = 170
        ,next_id = 89007
        ,limit = []
        ,pet_info = {pet_skill, 289000, [12], [{101011,[100,3,1,4000]}], [], 3}
    };
get_skill(89007) ->
    #demon_skill{
        id = 89007
        ,name = <<"初级急速治愈">>
        ,type = 8
        ,step = 8
        ,craft = 1
        ,exp = 341
        ,next_id = 89008
        ,limit = []
        ,pet_info = {pet_skill, 289000, [13], [{101011,[100,3,1,4500]}], [], 3}
    };
get_skill(89008) ->
    #demon_skill{
        id = 89008
        ,name = <<"初级急速治愈">>
        ,type = 8
        ,step = 9
        ,craft = 1
        ,exp = 682
        ,next_id = 89009
        ,limit = []
        ,pet_info = {pet_skill, 289000, [14], [{101011,[100,3,1,5000]}], [], 3}
    };
get_skill(89009) ->
    #demon_skill{
        id = 89009
        ,name = <<"初级急速治愈">>
        ,type = 8
        ,step = 10
        ,craft = 1
        ,exp = 683
        ,next_id = 0
        ,limit = []
        ,pet_info = {pet_skill, 289000, [15], [{101011,[100,3,1,5500]}], [], 3}
    };
get_skill(89010) ->
    #demon_skill{
        id = 89010
        ,name = <<"初级金系护宠">>
        ,type = 9
        ,step = 1
        ,craft = 1
        ,exp = 2
        ,next_id = 89011
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289010, [22], [{102170,[100,3,1,80]}], [], 3}
    };
get_skill(89011) ->
    #demon_skill{
        id = 89011
        ,name = <<"初级金系护宠">>
        ,type = 9
        ,step = 2
        ,craft = 1
        ,exp = 5
        ,next_id = 89012
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289010, [23], [{102170,[100,3,1,90]}], [], 3}
    };
get_skill(89012) ->
    #demon_skill{
        id = 89012
        ,name = <<"初级金系护宠">>
        ,type = 9
        ,step = 3
        ,craft = 1
        ,exp = 10
        ,next_id = 89013
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289010, [24], [{102170,[100,3,1,100]}], [], 3}
    };
get_skill(89013) ->
    #demon_skill{
        id = 89013
        ,name = <<"初级金系护宠">>
        ,type = 9
        ,step = 4
        ,craft = 1
        ,exp = 21
        ,next_id = 89014
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289010, [25], [{102170,[100,3,1,110]}], [], 3}
    };
get_skill(89014) ->
    #demon_skill{
        id = 89014
        ,name = <<"初级金系护宠">>
        ,type = 9
        ,step = 5
        ,craft = 1
        ,exp = 42
        ,next_id = 89015
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289010, [26], [{102170,[100,3,1,120]}], [], 3}
    };
get_skill(89015) ->
    #demon_skill{
        id = 89015
        ,name = <<"初级金系护宠">>
        ,type = 9
        ,step = 6
        ,craft = 1
        ,exp = 85
        ,next_id = 89016
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289010, [27], [{102170,[100,3,1,130]}], [], 3}
    };
get_skill(89016) ->
    #demon_skill{
        id = 89016
        ,name = <<"初级金系护宠">>
        ,type = 9
        ,step = 7
        ,craft = 1
        ,exp = 170
        ,next_id = 89017
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289010, [28], [{102170,[100,3,1,140]}], [], 3}
    };
get_skill(89017) ->
    #demon_skill{
        id = 89017
        ,name = <<"初级金系护宠">>
        ,type = 9
        ,step = 8
        ,craft = 1
        ,exp = 341
        ,next_id = 89018
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289010, [29], [{102170,[100,3,1,150]}], [], 3}
    };
get_skill(89018) ->
    #demon_skill{
        id = 89018
        ,name = <<"初级金系护宠">>
        ,type = 9
        ,step = 9
        ,craft = 1
        ,exp = 682
        ,next_id = 89019
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289010, [30], [{102170,[100,3,1,160]}], [], 3}
    };
get_skill(89019) ->
    #demon_skill{
        id = 89019
        ,name = <<"初级金系护宠">>
        ,type = 9
        ,step = 10
        ,craft = 1
        ,exp = 683
        ,next_id = 0
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289010, [31], [{102170,[100,3,1,170]}], [], 3}
    };
get_skill(89020) ->
    #demon_skill{
        id = 89020
        ,name = <<"初级木系护宠">>
        ,type = 10
        ,step = 1
        ,craft = 1
        ,exp = 2
        ,next_id = 89021
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289020, [22], [{102180,[100,3,1,80]}], [], 3}
    };
get_skill(89021) ->
    #demon_skill{
        id = 89021
        ,name = <<"初级木系护宠">>
        ,type = 10
        ,step = 2
        ,craft = 1
        ,exp = 5
        ,next_id = 89022
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289020, [23], [{102180,[100,3,1,90]}], [], 3}
    };
get_skill(89022) ->
    #demon_skill{
        id = 89022
        ,name = <<"初级木系护宠">>
        ,type = 10
        ,step = 3
        ,craft = 1
        ,exp = 10
        ,next_id = 89023
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289020, [24], [{102180,[100,3,1,100]}], [], 3}
    };
get_skill(89023) ->
    #demon_skill{
        id = 89023
        ,name = <<"初级木系护宠">>
        ,type = 10
        ,step = 4
        ,craft = 1
        ,exp = 21
        ,next_id = 89024
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289020, [25], [{102180,[100,3,1,110]}], [], 3}
    };
get_skill(89024) ->
    #demon_skill{
        id = 89024
        ,name = <<"初级木系护宠">>
        ,type = 10
        ,step = 5
        ,craft = 1
        ,exp = 42
        ,next_id = 89025
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289020, [26], [{102180,[100,3,1,120]}], [], 3}
    };
get_skill(89025) ->
    #demon_skill{
        id = 89025
        ,name = <<"初级木系护宠">>
        ,type = 10
        ,step = 6
        ,craft = 1
        ,exp = 85
        ,next_id = 89026
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289020, [27], [{102180,[100,3,1,130]}], [], 3}
    };
get_skill(89026) ->
    #demon_skill{
        id = 89026
        ,name = <<"初级木系护宠">>
        ,type = 10
        ,step = 7
        ,craft = 1
        ,exp = 170
        ,next_id = 89027
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289020, [28], [{102180,[100,3,1,140]}], [], 3}
    };
get_skill(89027) ->
    #demon_skill{
        id = 89027
        ,name = <<"初级木系护宠">>
        ,type = 10
        ,step = 8
        ,craft = 1
        ,exp = 341
        ,next_id = 89028
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289020, [29], [{102180,[100,3,1,150]}], [], 3}
    };
get_skill(89028) ->
    #demon_skill{
        id = 89028
        ,name = <<"初级木系护宠">>
        ,type = 10
        ,step = 9
        ,craft = 1
        ,exp = 682
        ,next_id = 89029
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289020, [30], [{102180,[100,3,1,160]}], [], 3}
    };
get_skill(89029) ->
    #demon_skill{
        id = 89029
        ,name = <<"初级木系护宠">>
        ,type = 10
        ,step = 10
        ,craft = 1
        ,exp = 683
        ,next_id = 0
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289020, [31], [{102180,[100,3,1,170]}], [], 3}
    };
get_skill(89030) ->
    #demon_skill{
        id = 89030
        ,name = <<"初级水系护宠">>
        ,type = 11
        ,step = 1
        ,craft = 1
        ,exp = 2
        ,next_id = 89031
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289030, [22], [{102200,[100,3,1,80]}], [], 3}
    };
get_skill(89031) ->
    #demon_skill{
        id = 89031
        ,name = <<"初级水系护宠">>
        ,type = 11
        ,step = 2
        ,craft = 1
        ,exp = 5
        ,next_id = 89032
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289030, [23], [{102200,[100,3,1,90]}], [], 3}
    };
get_skill(89032) ->
    #demon_skill{
        id = 89032
        ,name = <<"初级水系护宠">>
        ,type = 11
        ,step = 3
        ,craft = 1
        ,exp = 10
        ,next_id = 89033
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289030, [24], [{102200,[100,3,1,100]}], [], 3}
    };
get_skill(89033) ->
    #demon_skill{
        id = 89033
        ,name = <<"初级水系护宠">>
        ,type = 11
        ,step = 4
        ,craft = 1
        ,exp = 21
        ,next_id = 89034
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289030, [25], [{102200,[100,3,1,110]}], [], 3}
    };
get_skill(89034) ->
    #demon_skill{
        id = 89034
        ,name = <<"初级水系护宠">>
        ,type = 11
        ,step = 5
        ,craft = 1
        ,exp = 42
        ,next_id = 89035
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289030, [26], [{102200,[100,3,1,120]}], [], 3}
    };
get_skill(89035) ->
    #demon_skill{
        id = 89035
        ,name = <<"初级水系护宠">>
        ,type = 11
        ,step = 6
        ,craft = 1
        ,exp = 85
        ,next_id = 89036
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289030, [27], [{102200,[100,3,1,130]}], [], 3}
    };
get_skill(89036) ->
    #demon_skill{
        id = 89036
        ,name = <<"初级水系护宠">>
        ,type = 11
        ,step = 7
        ,craft = 1
        ,exp = 170
        ,next_id = 89037
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289030, [28], [{102200,[100,3,1,140]}], [], 3}
    };
get_skill(89037) ->
    #demon_skill{
        id = 89037
        ,name = <<"初级水系护宠">>
        ,type = 11
        ,step = 8
        ,craft = 1
        ,exp = 341
        ,next_id = 89038
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289030, [29], [{102200,[100,3,1,150]}], [], 3}
    };
get_skill(89038) ->
    #demon_skill{
        id = 89038
        ,name = <<"初级水系护宠">>
        ,type = 11
        ,step = 9
        ,craft = 1
        ,exp = 682
        ,next_id = 89039
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289030, [30], [{102200,[100,3,1,160]}], [], 3}
    };
get_skill(89039) ->
    #demon_skill{
        id = 89039
        ,name = <<"初级水系护宠">>
        ,type = 11
        ,step = 10
        ,craft = 1
        ,exp = 683
        ,next_id = 0
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289030, [31], [{102200,[100,3,1,170]}], [], 3}
    };
get_skill(89040) ->
    #demon_skill{
        id = 89040
        ,name = <<"初级火系护宠">>
        ,type = 12
        ,step = 1
        ,craft = 1
        ,exp = 2
        ,next_id = 89041
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289040, [22], [{102190,[100,3,1,80]}], [], 3}
    };
get_skill(89041) ->
    #demon_skill{
        id = 89041
        ,name = <<"初级火系护宠">>
        ,type = 12
        ,step = 2
        ,craft = 1
        ,exp = 5
        ,next_id = 89042
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289040, [23], [{102190,[100,3,1,90]}], [], 3}
    };
get_skill(89042) ->
    #demon_skill{
        id = 89042
        ,name = <<"初级火系护宠">>
        ,type = 12
        ,step = 3
        ,craft = 1
        ,exp = 10
        ,next_id = 89043
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289040, [24], [{102190,[100,3,1,100]}], [], 3}
    };
get_skill(89043) ->
    #demon_skill{
        id = 89043
        ,name = <<"初级火系护宠">>
        ,type = 12
        ,step = 4
        ,craft = 1
        ,exp = 21
        ,next_id = 89044
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289040, [25], [{102190,[100,3,1,110]}], [], 3}
    };
get_skill(89044) ->
    #demon_skill{
        id = 89044
        ,name = <<"初级火系护宠">>
        ,type = 12
        ,step = 5
        ,craft = 1
        ,exp = 42
        ,next_id = 89045
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289040, [26], [{102190,[100,3,1,120]}], [], 3}
    };
get_skill(89045) ->
    #demon_skill{
        id = 89045
        ,name = <<"初级火系护宠">>
        ,type = 12
        ,step = 6
        ,craft = 1
        ,exp = 85
        ,next_id = 89046
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289040, [27], [{102190,[100,3,1,130]}], [], 3}
    };
get_skill(89046) ->
    #demon_skill{
        id = 89046
        ,name = <<"初级火系护宠">>
        ,type = 12
        ,step = 7
        ,craft = 1
        ,exp = 170
        ,next_id = 89047
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289040, [28], [{102190,[100,3,1,140]}], [], 3}
    };
get_skill(89047) ->
    #demon_skill{
        id = 89047
        ,name = <<"初级火系护宠">>
        ,type = 12
        ,step = 8
        ,craft = 1
        ,exp = 341
        ,next_id = 89048
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289040, [29], [{102190,[100,3,1,150]}], [], 3}
    };
get_skill(89048) ->
    #demon_skill{
        id = 89048
        ,name = <<"初级火系护宠">>
        ,type = 12
        ,step = 9
        ,craft = 1
        ,exp = 682
        ,next_id = 89049
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289040, [30], [{102190,[100,3,1,160]}], [], 3}
    };
get_skill(89049) ->
    #demon_skill{
        id = 89049
        ,name = <<"初级火系护宠">>
        ,type = 12
        ,step = 10
        ,craft = 1
        ,exp = 683
        ,next_id = 0
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289040, [31], [{102190,[100,3,1,170]}], [], 3}
    };
get_skill(89050) ->
    #demon_skill{
        id = 89050
        ,name = <<"初级土系护宠">>
        ,type = 13
        ,step = 1
        ,craft = 1
        ,exp = 2
        ,next_id = 89051
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289050, [22], [{102210,[100,3,1,80]}], [], 3}
    };
get_skill(89051) ->
    #demon_skill{
        id = 89051
        ,name = <<"初级土系护宠">>
        ,type = 13
        ,step = 2
        ,craft = 1
        ,exp = 5
        ,next_id = 89052
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289050, [23], [{102210,[100,3,1,90]}], [], 3}
    };
get_skill(89052) ->
    #demon_skill{
        id = 89052
        ,name = <<"初级土系护宠">>
        ,type = 13
        ,step = 3
        ,craft = 1
        ,exp = 10
        ,next_id = 89053
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289050, [24], [{102210,[100,3,1,100]}], [], 3}
    };
get_skill(89053) ->
    #demon_skill{
        id = 89053
        ,name = <<"初级土系护宠">>
        ,type = 13
        ,step = 4
        ,craft = 1
        ,exp = 21
        ,next_id = 89054
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289050, [25], [{102210,[100,3,1,110]}], [], 3}
    };
get_skill(89054) ->
    #demon_skill{
        id = 89054
        ,name = <<"初级土系护宠">>
        ,type = 13
        ,step = 5
        ,craft = 1
        ,exp = 42
        ,next_id = 89055
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289050, [26], [{102210,[100,3,1,120]}], [], 3}
    };
get_skill(89055) ->
    #demon_skill{
        id = 89055
        ,name = <<"初级土系护宠">>
        ,type = 13
        ,step = 6
        ,craft = 1
        ,exp = 85
        ,next_id = 89056
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289050, [27], [{102210,[100,3,1,130]}], [], 3}
    };
get_skill(89056) ->
    #demon_skill{
        id = 89056
        ,name = <<"初级土系护宠">>
        ,type = 13
        ,step = 7
        ,craft = 1
        ,exp = 170
        ,next_id = 89057
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289050, [28], [{102210,[100,3,1,140]}], [], 3}
    };
get_skill(89057) ->
    #demon_skill{
        id = 89057
        ,name = <<"初级土系护宠">>
        ,type = 13
        ,step = 8
        ,craft = 1
        ,exp = 341
        ,next_id = 89058
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289050, [29], [{102210,[100,3,1,150]}], [], 3}
    };
get_skill(89058) ->
    #demon_skill{
        id = 89058
        ,name = <<"初级土系护宠">>
        ,type = 13
        ,step = 9
        ,craft = 1
        ,exp = 682
        ,next_id = 89059
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289050, [30], [{102210,[100,3,1,160]}], [], 3}
    };
get_skill(89059) ->
    #demon_skill{
        id = 89059
        ,name = <<"初级土系护宠">>
        ,type = 13
        ,step = 10
        ,craft = 1
        ,exp = 683
        ,next_id = 0
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289050, [31], [{102210,[100,3,1,170]}], [], 3}
    };
get_skill(89060) ->
    #demon_skill{
        id = 89060
        ,name = <<"初级轮回天生">>
        ,type = 14
        ,step = 1
        ,craft = 1
        ,exp = 2
        ,next_id = 89061
        ,limit = []
        ,pet_info = {pet_skill, 289060, [1,20,1], [], [], 99}
    };
get_skill(89061) ->
    #demon_skill{
        id = 89061
        ,name = <<"初级轮回天生">>
        ,type = 14
        ,step = 2
        ,craft = 1
        ,exp = 5
        ,next_id = 89062
        ,limit = []
        ,pet_info = {pet_skill, 289060, [1,25,2], [], [], 99}
    };
get_skill(89062) ->
    #demon_skill{
        id = 89062
        ,name = <<"初级轮回天生">>
        ,type = 14
        ,step = 3
        ,craft = 1
        ,exp = 10
        ,next_id = 89063
        ,limit = []
        ,pet_info = {pet_skill, 289060, [1,30,3], [], [], 99}
    };
get_skill(89063) ->
    #demon_skill{
        id = 89063
        ,name = <<"初级轮回天生">>
        ,type = 14
        ,step = 4
        ,craft = 1
        ,exp = 21
        ,next_id = 89064
        ,limit = []
        ,pet_info = {pet_skill, 289060, [1,35,4], [], [], 99}
    };
get_skill(89064) ->
    #demon_skill{
        id = 89064
        ,name = <<"初级轮回天生">>
        ,type = 14
        ,step = 5
        ,craft = 1
        ,exp = 42
        ,next_id = 89065
        ,limit = []
        ,pet_info = {pet_skill, 289060, [1,40,5], [], [], 99}
    };
get_skill(89065) ->
    #demon_skill{
        id = 89065
        ,name = <<"初级轮回天生">>
        ,type = 14
        ,step = 6
        ,craft = 1
        ,exp = 85
        ,next_id = 89066
        ,limit = []
        ,pet_info = {pet_skill, 289060, [1,45,6], [], [], 99}
    };
get_skill(89066) ->
    #demon_skill{
        id = 89066
        ,name = <<"初级轮回天生">>
        ,type = 14
        ,step = 7
        ,craft = 1
        ,exp = 170
        ,next_id = 89067
        ,limit = []
        ,pet_info = {pet_skill, 289060, [1,50,7], [], [], 99}
    };
get_skill(89067) ->
    #demon_skill{
        id = 89067
        ,name = <<"初级轮回天生">>
        ,type = 14
        ,step = 8
        ,craft = 1
        ,exp = 341
        ,next_id = 89068
        ,limit = []
        ,pet_info = {pet_skill, 289060, [1,55,8], [], [], 99}
    };
get_skill(89068) ->
    #demon_skill{
        id = 89068
        ,name = <<"初级轮回天生">>
        ,type = 14
        ,step = 9
        ,craft = 1
        ,exp = 682
        ,next_id = 89069
        ,limit = []
        ,pet_info = {pet_skill, 289060, [1,60,9], [], [], 99}
    };
get_skill(89069) ->
    #demon_skill{
        id = 89069
        ,name = <<"初级轮回天生">>
        ,type = 14
        ,step = 10
        ,craft = 1
        ,exp = 683
        ,next_id = 0
        ,limit = []
        ,pet_info = {pet_skill, 289060, [1,65,10], [], [], 99}
    };
get_skill(89100) ->
    #demon_skill{
        id = 89100
        ,name = <<"中级急速治愈">>
        ,type = 8
        ,step = 1
        ,craft = 2
        ,exp = 2
        ,next_id = 89101
        ,limit = []
        ,pet_info = {pet_skill, 289100, [7], [{101011,[100,3,1,1500]}], [], 3}
    };
get_skill(89101) ->
    #demon_skill{
        id = 89101
        ,name = <<"中级急速治愈">>
        ,type = 8
        ,step = 2
        ,craft = 2
        ,exp = 5
        ,next_id = 89102
        ,limit = []
        ,pet_info = {pet_skill, 289100, [8], [{101011,[100,3,1,2000]}], [], 3}
    };
get_skill(89102) ->
    #demon_skill{
        id = 89102
        ,name = <<"中级急速治愈">>
        ,type = 8
        ,step = 3
        ,craft = 2
        ,exp = 11
        ,next_id = 89103
        ,limit = []
        ,pet_info = {pet_skill, 289100, [9], [{101011,[100,3,1,2500]}], [], 3}
    };
get_skill(89103) ->
    #demon_skill{
        id = 89103
        ,name = <<"中级急速治愈">>
        ,type = 8
        ,step = 4
        ,craft = 2
        ,exp = 23
        ,next_id = 89104
        ,limit = []
        ,pet_info = {pet_skill, 289100, [10], [{101011,[100,3,1,3000]}], [], 3}
    };
get_skill(89104) ->
    #demon_skill{
        id = 89104
        ,name = <<"中级急速治愈">>
        ,type = 8
        ,step = 5
        ,craft = 2
        ,exp = 46
        ,next_id = 89105
        ,limit = []
        ,pet_info = {pet_skill, 289100, [11], [{101011,[100,3,1,3500]}], [], 3}
    };
get_skill(89105) ->
    #demon_skill{
        id = 89105
        ,name = <<"中级急速治愈">>
        ,type = 8
        ,step = 6
        ,craft = 2
        ,exp = 93
        ,next_id = 89106
        ,limit = []
        ,pet_info = {pet_skill, 289100, [12], [{101011,[100,3,1,4000]}], [], 3}
    };
get_skill(89106) ->
    #demon_skill{
        id = 89106
        ,name = <<"中级急速治愈">>
        ,type = 8
        ,step = 7
        ,craft = 2
        ,exp = 187
        ,next_id = 89107
        ,limit = []
        ,pet_info = {pet_skill, 289100, [13], [{101011,[100,3,1,4500]}], [], 3}
    };
get_skill(89107) ->
    #demon_skill{
        id = 89107
        ,name = <<"中级急速治愈">>
        ,type = 8
        ,step = 8
        ,craft = 2
        ,exp = 375
        ,next_id = 89108
        ,limit = []
        ,pet_info = {pet_skill, 289100, [14], [{101011,[100,3,1,5000]}], [], 3}
    };
get_skill(89108) ->
    #demon_skill{
        id = 89108
        ,name = <<"中级急速治愈">>
        ,type = 8
        ,step = 9
        ,craft = 2
        ,exp = 750
        ,next_id = 89109
        ,limit = []
        ,pet_info = {pet_skill, 289100, [15], [{101011,[100,3,1,5500]}], [], 3}
    };
get_skill(89109) ->
    #demon_skill{
        id = 89109
        ,name = <<"中级急速治愈">>
        ,type = 8
        ,step = 10
        ,craft = 2
        ,exp = 755
        ,next_id = 0
        ,limit = []
        ,pet_info = {pet_skill, 289100, [16], [{101011,[100,3,1,6000]}], [], 3}
    };
get_skill(89110) ->
    #demon_skill{
        id = 89110
        ,name = <<"中级金系护宠">>
        ,type = 9
        ,step = 1
        ,craft = 2
        ,exp = 2
        ,next_id = 89111
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289110, [23], [{102170,[100,3,1,90]}], [], 3}
    };
get_skill(89111) ->
    #demon_skill{
        id = 89111
        ,name = <<"中级金系护宠">>
        ,type = 9
        ,step = 2
        ,craft = 2
        ,exp = 5
        ,next_id = 89112
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289110, [24], [{102170,[100,3,1,100]}], [], 3}
    };
get_skill(89112) ->
    #demon_skill{
        id = 89112
        ,name = <<"中级金系护宠">>
        ,type = 9
        ,step = 3
        ,craft = 2
        ,exp = 11
        ,next_id = 89113
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289110, [25], [{102170,[100,3,1,110]}], [], 3}
    };
get_skill(89113) ->
    #demon_skill{
        id = 89113
        ,name = <<"中级金系护宠">>
        ,type = 9
        ,step = 4
        ,craft = 2
        ,exp = 23
        ,next_id = 89114
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289110, [26], [{102170,[100,3,1,120]}], [], 3}
    };
get_skill(89114) ->
    #demon_skill{
        id = 89114
        ,name = <<"中级金系护宠">>
        ,type = 9
        ,step = 5
        ,craft = 2
        ,exp = 46
        ,next_id = 89115
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289110, [27], [{102170,[100,3,1,130]}], [], 3}
    };
get_skill(89115) ->
    #demon_skill{
        id = 89115
        ,name = <<"中级金系护宠">>
        ,type = 9
        ,step = 6
        ,craft = 2
        ,exp = 93
        ,next_id = 89116
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289110, [28], [{102170,[100,3,1,140]}], [], 3}
    };
get_skill(89116) ->
    #demon_skill{
        id = 89116
        ,name = <<"中级金系护宠">>
        ,type = 9
        ,step = 7
        ,craft = 2
        ,exp = 187
        ,next_id = 89117
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289110, [29], [{102170,[100,3,1,150]}], [], 3}
    };
get_skill(89117) ->
    #demon_skill{
        id = 89117
        ,name = <<"中级金系护宠">>
        ,type = 9
        ,step = 8
        ,craft = 2
        ,exp = 375
        ,next_id = 89118
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289110, [30], [{102170,[100,3,1,160]}], [], 3}
    };
get_skill(89118) ->
    #demon_skill{
        id = 89118
        ,name = <<"中级金系护宠">>
        ,type = 9
        ,step = 9
        ,craft = 2
        ,exp = 750
        ,next_id = 89119
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289110, [31], [{102170,[100,3,1,170]}], [], 3}
    };
get_skill(89119) ->
    #demon_skill{
        id = 89119
        ,name = <<"中级金系护宠">>
        ,type = 9
        ,step = 10
        ,craft = 2
        ,exp = 755
        ,next_id = 0
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289110, [32], [{102170,[100,3,1,180]}], [], 3}
    };
get_skill(89120) ->
    #demon_skill{
        id = 89120
        ,name = <<"中级木系护宠">>
        ,type = 10
        ,step = 1
        ,craft = 2
        ,exp = 2
        ,next_id = 89121
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289120, [23], [{102180,[100,3,1,90]}], [], 3}
    };
get_skill(89121) ->
    #demon_skill{
        id = 89121
        ,name = <<"中级木系护宠">>
        ,type = 10
        ,step = 2
        ,craft = 2
        ,exp = 5
        ,next_id = 89122
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289120, [24], [{102180,[100,3,1,100]}], [], 3}
    };
get_skill(89122) ->
    #demon_skill{
        id = 89122
        ,name = <<"中级木系护宠">>
        ,type = 10
        ,step = 3
        ,craft = 2
        ,exp = 11
        ,next_id = 89123
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289120, [25], [{102180,[100,3,1,110]}], [], 3}
    };
get_skill(89123) ->
    #demon_skill{
        id = 89123
        ,name = <<"中级木系护宠">>
        ,type = 10
        ,step = 4
        ,craft = 2
        ,exp = 23
        ,next_id = 89124
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289120, [26], [{102180,[100,3,1,120]}], [], 3}
    };
get_skill(89124) ->
    #demon_skill{
        id = 89124
        ,name = <<"中级木系护宠">>
        ,type = 10
        ,step = 5
        ,craft = 2
        ,exp = 46
        ,next_id = 89125
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289120, [27], [{102180,[100,3,1,130]}], [], 3}
    };
get_skill(89125) ->
    #demon_skill{
        id = 89125
        ,name = <<"中级木系护宠">>
        ,type = 10
        ,step = 6
        ,craft = 2
        ,exp = 93
        ,next_id = 89126
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289120, [28], [{102180,[100,3,1,140]}], [], 3}
    };
get_skill(89126) ->
    #demon_skill{
        id = 89126
        ,name = <<"中级木系护宠">>
        ,type = 10
        ,step = 7
        ,craft = 2
        ,exp = 187
        ,next_id = 89127
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289120, [29], [{102180,[100,3,1,150]}], [], 3}
    };
get_skill(89127) ->
    #demon_skill{
        id = 89127
        ,name = <<"中级木系护宠">>
        ,type = 10
        ,step = 8
        ,craft = 2
        ,exp = 375
        ,next_id = 89128
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289120, [30], [{102180,[100,3,1,160]}], [], 3}
    };
get_skill(89128) ->
    #demon_skill{
        id = 89128
        ,name = <<"中级木系护宠">>
        ,type = 10
        ,step = 9
        ,craft = 2
        ,exp = 750
        ,next_id = 89129
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289120, [31], [{102180,[100,3,1,170]}], [], 3}
    };
get_skill(89129) ->
    #demon_skill{
        id = 89129
        ,name = <<"中级木系护宠">>
        ,type = 10
        ,step = 10
        ,craft = 2
        ,exp = 755
        ,next_id = 0
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289120, [32], [{102180,[100,3,1,180]}], [], 3}
    };
get_skill(89130) ->
    #demon_skill{
        id = 89130
        ,name = <<"中级水系护宠">>
        ,type = 11
        ,step = 1
        ,craft = 2
        ,exp = 2
        ,next_id = 89131
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289130, [23], [{102200,[100,3,1,90]}], [], 3}
    };
get_skill(89131) ->
    #demon_skill{
        id = 89131
        ,name = <<"中级水系护宠">>
        ,type = 11
        ,step = 2
        ,craft = 2
        ,exp = 5
        ,next_id = 89132
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289130, [24], [{102200,[100,3,1,100]}], [], 3}
    };
get_skill(89132) ->
    #demon_skill{
        id = 89132
        ,name = <<"中级水系护宠">>
        ,type = 11
        ,step = 3
        ,craft = 2
        ,exp = 11
        ,next_id = 89133
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289130, [25], [{102200,[100,3,1,110]}], [], 3}
    };
get_skill(89133) ->
    #demon_skill{
        id = 89133
        ,name = <<"中级水系护宠">>
        ,type = 11
        ,step = 4
        ,craft = 2
        ,exp = 23
        ,next_id = 89134
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289130, [26], [{102200,[100,3,1,120]}], [], 3}
    };
get_skill(89134) ->
    #demon_skill{
        id = 89134
        ,name = <<"中级水系护宠">>
        ,type = 11
        ,step = 5
        ,craft = 2
        ,exp = 46
        ,next_id = 89135
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289130, [27], [{102200,[100,3,1,130]}], [], 3}
    };
get_skill(89135) ->
    #demon_skill{
        id = 89135
        ,name = <<"中级水系护宠">>
        ,type = 11
        ,step = 6
        ,craft = 2
        ,exp = 93
        ,next_id = 89136
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289130, [28], [{102200,[100,3,1,140]}], [], 3}
    };
get_skill(89136) ->
    #demon_skill{
        id = 89136
        ,name = <<"中级水系护宠">>
        ,type = 11
        ,step = 7
        ,craft = 2
        ,exp = 187
        ,next_id = 89137
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289130, [29], [{102200,[100,3,1,150]}], [], 3}
    };
get_skill(89137) ->
    #demon_skill{
        id = 89137
        ,name = <<"中级水系护宠">>
        ,type = 11
        ,step = 8
        ,craft = 2
        ,exp = 375
        ,next_id = 89138
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289130, [30], [{102200,[100,3,1,160]}], [], 3}
    };
get_skill(89138) ->
    #demon_skill{
        id = 89138
        ,name = <<"中级水系护宠">>
        ,type = 11
        ,step = 9
        ,craft = 2
        ,exp = 750
        ,next_id = 89139
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289130, [31], [{102200,[100,3,1,170]}], [], 3}
    };
get_skill(89139) ->
    #demon_skill{
        id = 89139
        ,name = <<"中级水系护宠">>
        ,type = 11
        ,step = 10
        ,craft = 2
        ,exp = 755
        ,next_id = 0
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289130, [32], [{102200,[100,3,1,180]}], [], 3}
    };
get_skill(89140) ->
    #demon_skill{
        id = 89140
        ,name = <<"中级火系护宠">>
        ,type = 12
        ,step = 1
        ,craft = 2
        ,exp = 2
        ,next_id = 89141
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289140, [23], [{102190,[100,3,1,90]}], [], 3}
    };
get_skill(89141) ->
    #demon_skill{
        id = 89141
        ,name = <<"中级火系护宠">>
        ,type = 12
        ,step = 2
        ,craft = 2
        ,exp = 5
        ,next_id = 89142
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289140, [24], [{102190,[100,3,1,100]}], [], 3}
    };
get_skill(89142) ->
    #demon_skill{
        id = 89142
        ,name = <<"中级火系护宠">>
        ,type = 12
        ,step = 3
        ,craft = 2
        ,exp = 11
        ,next_id = 89143
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289140, [25], [{102190,[100,3,1,110]}], [], 3}
    };
get_skill(89143) ->
    #demon_skill{
        id = 89143
        ,name = <<"中级火系护宠">>
        ,type = 12
        ,step = 4
        ,craft = 2
        ,exp = 23
        ,next_id = 89144
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289140, [26], [{102190,[100,3,1,120]}], [], 3}
    };
get_skill(89144) ->
    #demon_skill{
        id = 89144
        ,name = <<"中级火系护宠">>
        ,type = 12
        ,step = 5
        ,craft = 2
        ,exp = 46
        ,next_id = 89145
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289140, [27], [{102190,[100,3,1,130]}], [], 3}
    };
get_skill(89145) ->
    #demon_skill{
        id = 89145
        ,name = <<"中级火系护宠">>
        ,type = 12
        ,step = 6
        ,craft = 2
        ,exp = 93
        ,next_id = 89146
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289140, [28], [{102190,[100,3,1,140]}], [], 3}
    };
get_skill(89146) ->
    #demon_skill{
        id = 89146
        ,name = <<"中级火系护宠">>
        ,type = 12
        ,step = 7
        ,craft = 2
        ,exp = 187
        ,next_id = 89147
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289140, [29], [{102190,[100,3,1,150]}], [], 3}
    };
get_skill(89147) ->
    #demon_skill{
        id = 89147
        ,name = <<"中级火系护宠">>
        ,type = 12
        ,step = 8
        ,craft = 2
        ,exp = 375
        ,next_id = 89148
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289140, [30], [{102190,[100,3,1,160]}], [], 3}
    };
get_skill(89148) ->
    #demon_skill{
        id = 89148
        ,name = <<"中级火系护宠">>
        ,type = 12
        ,step = 9
        ,craft = 2
        ,exp = 750
        ,next_id = 89149
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289140, [31], [{102190,[100,3,1,170]}], [], 3}
    };
get_skill(89149) ->
    #demon_skill{
        id = 89149
        ,name = <<"中级火系护宠">>
        ,type = 12
        ,step = 10
        ,craft = 2
        ,exp = 755
        ,next_id = 0
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289140, [32], [{102190,[100,3,1,180]}], [], 3}
    };
get_skill(89150) ->
    #demon_skill{
        id = 89150
        ,name = <<"中级土系护宠">>
        ,type = 13
        ,step = 1
        ,craft = 2
        ,exp = 2
        ,next_id = 89151
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289150, [23], [{102210,[100,3,1,90]}], [], 3}
    };
get_skill(89151) ->
    #demon_skill{
        id = 89151
        ,name = <<"中级土系护宠">>
        ,type = 13
        ,step = 2
        ,craft = 2
        ,exp = 5
        ,next_id = 89152
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289150, [24], [{102210,[100,3,1,100]}], [], 3}
    };
get_skill(89152) ->
    #demon_skill{
        id = 89152
        ,name = <<"中级土系护宠">>
        ,type = 13
        ,step = 3
        ,craft = 2
        ,exp = 11
        ,next_id = 89153
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289150, [25], [{102210,[100,3,1,110]}], [], 3}
    };
get_skill(89153) ->
    #demon_skill{
        id = 89153
        ,name = <<"中级土系护宠">>
        ,type = 13
        ,step = 4
        ,craft = 2
        ,exp = 23
        ,next_id = 89154
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289150, [26], [{102210,[100,3,1,120]}], [], 3}
    };
get_skill(89154) ->
    #demon_skill{
        id = 89154
        ,name = <<"中级土系护宠">>
        ,type = 13
        ,step = 5
        ,craft = 2
        ,exp = 46
        ,next_id = 89155
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289150, [27], [{102210,[100,3,1,130]}], [], 3}
    };
get_skill(89155) ->
    #demon_skill{
        id = 89155
        ,name = <<"中级土系护宠">>
        ,type = 13
        ,step = 6
        ,craft = 2
        ,exp = 93
        ,next_id = 89156
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289150, [28], [{102210,[100,3,1,140]}], [], 3}
    };
get_skill(89156) ->
    #demon_skill{
        id = 89156
        ,name = <<"中级土系护宠">>
        ,type = 13
        ,step = 7
        ,craft = 2
        ,exp = 187
        ,next_id = 89157
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289150, [29], [{102210,[100,3,1,150]}], [], 3}
    };
get_skill(89157) ->
    #demon_skill{
        id = 89157
        ,name = <<"中级土系护宠">>
        ,type = 13
        ,step = 8
        ,craft = 2
        ,exp = 375
        ,next_id = 89158
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289150, [30], [{102210,[100,3,1,160]}], [], 3}
    };
get_skill(89158) ->
    #demon_skill{
        id = 89158
        ,name = <<"中级土系护宠">>
        ,type = 13
        ,step = 9
        ,craft = 2
        ,exp = 750
        ,next_id = 89159
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289150, [31], [{102210,[100,3,1,170]}], [], 3}
    };
get_skill(89159) ->
    #demon_skill{
        id = 89159
        ,name = <<"中级土系护宠">>
        ,type = 13
        ,step = 10
        ,craft = 2
        ,exp = 755
        ,next_id = 0
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289150, [32], [{102210,[100,3,1,180]}], [], 3}
    };
get_skill(89160) ->
    #demon_skill{
        id = 89160
        ,name = <<"中级轮回天生">>
        ,type = 14
        ,step = 1
        ,craft = 2
        ,exp = 2
        ,next_id = 89161
        ,limit = []
        ,pet_info = {pet_skill, 289160, [1,25,1], [], [], 99}
    };
get_skill(89161) ->
    #demon_skill{
        id = 89161
        ,name = <<"中级轮回天生">>
        ,type = 14
        ,step = 2
        ,craft = 2
        ,exp = 5
        ,next_id = 89162
        ,limit = []
        ,pet_info = {pet_skill, 289160, [1,30,2], [], [], 99}
    };
get_skill(89162) ->
    #demon_skill{
        id = 89162
        ,name = <<"中级轮回天生">>
        ,type = 14
        ,step = 3
        ,craft = 2
        ,exp = 11
        ,next_id = 89163
        ,limit = []
        ,pet_info = {pet_skill, 289160, [1,35,3], [], [], 99}
    };
get_skill(89163) ->
    #demon_skill{
        id = 89163
        ,name = <<"中级轮回天生">>
        ,type = 14
        ,step = 4
        ,craft = 2
        ,exp = 23
        ,next_id = 89164
        ,limit = []
        ,pet_info = {pet_skill, 289160, [1,40,4], [], [], 99}
    };
get_skill(89164) ->
    #demon_skill{
        id = 89164
        ,name = <<"中级轮回天生">>
        ,type = 14
        ,step = 5
        ,craft = 2
        ,exp = 46
        ,next_id = 89165
        ,limit = []
        ,pet_info = {pet_skill, 289160, [1,45,5], [], [], 99}
    };
get_skill(89165) ->
    #demon_skill{
        id = 89165
        ,name = <<"中级轮回天生">>
        ,type = 14
        ,step = 6
        ,craft = 2
        ,exp = 93
        ,next_id = 89166
        ,limit = []
        ,pet_info = {pet_skill, 289160, [1,50,6], [], [], 99}
    };
get_skill(89166) ->
    #demon_skill{
        id = 89166
        ,name = <<"中级轮回天生">>
        ,type = 14
        ,step = 7
        ,craft = 2
        ,exp = 187
        ,next_id = 89167
        ,limit = []
        ,pet_info = {pet_skill, 289160, [1,55,7], [], [], 99}
    };
get_skill(89167) ->
    #demon_skill{
        id = 89167
        ,name = <<"中级轮回天生">>
        ,type = 14
        ,step = 8
        ,craft = 2
        ,exp = 375
        ,next_id = 89168
        ,limit = []
        ,pet_info = {pet_skill, 289160, [1,60,8], [], [], 99}
    };
get_skill(89168) ->
    #demon_skill{
        id = 89168
        ,name = <<"中级轮回天生">>
        ,type = 14
        ,step = 9
        ,craft = 2
        ,exp = 750
        ,next_id = 89169
        ,limit = []
        ,pet_info = {pet_skill, 289160, [1,65,9], [], [], 99}
    };
get_skill(89169) ->
    #demon_skill{
        id = 89169
        ,name = <<"中级轮回天生">>
        ,type = 14
        ,step = 10
        ,craft = 2
        ,exp = 755
        ,next_id = 0
        ,limit = []
        ,pet_info = {pet_skill, 289160, [1,70,10], [], [], 99}
    };
get_skill(89200) ->
    #demon_skill{
        id = 89200
        ,name = <<"高级急速治愈">>
        ,type = 8
        ,step = 1
        ,craft = 3
        ,exp = 3
        ,next_id = 89201
        ,limit = []
        ,pet_info = {pet_skill, 289200, [8], [{101011,[100,3,1,2500]}], [], 3}
    };
get_skill(89201) ->
    #demon_skill{
        id = 89201
        ,name = <<"高级急速治愈">>
        ,type = 8
        ,step = 2
        ,craft = 3
        ,exp = 7
        ,next_id = 89202
        ,limit = []
        ,pet_info = {pet_skill, 289200, [9], [{101011,[100,3,1,3000]}], [], 3}
    };
get_skill(89202) ->
    #demon_skill{
        id = 89202
        ,name = <<"高级急速治愈">>
        ,type = 8
        ,step = 3
        ,craft = 3
        ,exp = 14
        ,next_id = 89203
        ,limit = []
        ,pet_info = {pet_skill, 289200, [10], [{101011,[100,3,1,3500]}], [], 3}
    };
get_skill(89203) ->
    #demon_skill{
        id = 89203
        ,name = <<"高级急速治愈">>
        ,type = 8
        ,step = 4
        ,craft = 3
        ,exp = 30
        ,next_id = 89204
        ,limit = []
        ,pet_info = {pet_skill, 289200, [11], [{101011,[100,3,1,4000]}], [], 3}
    };
get_skill(89204) ->
    #demon_skill{
        id = 89204
        ,name = <<"高级急速治愈">>
        ,type = 8
        ,step = 5
        ,craft = 3
        ,exp = 60
        ,next_id = 89205
        ,limit = []
        ,pet_info = {pet_skill, 289200, [12], [{101011,[100,3,1,4500]}], [], 3}
    };
get_skill(89205) ->
    #demon_skill{
        id = 89205
        ,name = <<"高级急速治愈">>
        ,type = 8
        ,step = 6
        ,craft = 3
        ,exp = 121
        ,next_id = 89206
        ,limit = []
        ,pet_info = {pet_skill, 289200, [13], [{101011,[100,3,1,5000]}], [], 3}
    };
get_skill(89206) ->
    #demon_skill{
        id = 89206
        ,name = <<"高级急速治愈">>
        ,type = 8
        ,step = 7
        ,craft = 3
        ,exp = 243
        ,next_id = 89207
        ,limit = []
        ,pet_info = {pet_skill, 289200, [14], [{101011,[100,3,1,5500]}], [], 3}
    };
get_skill(89207) ->
    #demon_skill{
        id = 89207
        ,name = <<"高级急速治愈">>
        ,type = 8
        ,step = 8
        ,craft = 3
        ,exp = 487
        ,next_id = 89208
        ,limit = []
        ,pet_info = {pet_skill, 289200, [15], [{101011,[100,3,1,6000]}], [], 3}
    };
get_skill(89208) ->
    #demon_skill{
        id = 89208
        ,name = <<"高级急速治愈">>
        ,type = 8
        ,step = 9
        ,craft = 3
        ,exp = 975
        ,next_id = 89209
        ,limit = []
        ,pet_info = {pet_skill, 289200, [16], [{101011,[100,3,1,6500]}], [], 3}
    };
get_skill(89209) ->
    #demon_skill{
        id = 89209
        ,name = <<"高级急速治愈">>
        ,type = 8
        ,step = 10
        ,craft = 3
        ,exp = 1200
        ,next_id = 0
        ,limit = []
        ,pet_info = {pet_skill, 289200, [17], [{101011,[100,3,1,7000]}], [], 3}
    };
get_skill(89210) ->
    #demon_skill{
        id = 89210
        ,name = <<"高级金系护宠">>
        ,type = 9
        ,step = 1
        ,craft = 3
        ,exp = 3
        ,next_id = 89211
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289210, [24], [{102170,[100,3,1,110]}], [], 3}
    };
get_skill(89211) ->
    #demon_skill{
        id = 89211
        ,name = <<"高级金系护宠">>
        ,type = 9
        ,step = 2
        ,craft = 3
        ,exp = 7
        ,next_id = 89212
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289210, [25], [{102170,[100,3,1,120]}], [], 3}
    };
get_skill(89212) ->
    #demon_skill{
        id = 89212
        ,name = <<"高级金系护宠">>
        ,type = 9
        ,step = 3
        ,craft = 3
        ,exp = 14
        ,next_id = 89213
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289210, [26], [{102170,[100,3,1,130]}], [], 3}
    };
get_skill(89213) ->
    #demon_skill{
        id = 89213
        ,name = <<"高级金系护宠">>
        ,type = 9
        ,step = 4
        ,craft = 3
        ,exp = 30
        ,next_id = 89214
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289210, [27], [{102170,[100,3,1,140]}], [], 3}
    };
get_skill(89214) ->
    #demon_skill{
        id = 89214
        ,name = <<"高级金系护宠">>
        ,type = 9
        ,step = 5
        ,craft = 3
        ,exp = 60
        ,next_id = 89215
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289210, [28], [{102170,[100,3,1,150]}], [], 3}
    };
get_skill(89215) ->
    #demon_skill{
        id = 89215
        ,name = <<"高级金系护宠">>
        ,type = 9
        ,step = 6
        ,craft = 3
        ,exp = 121
        ,next_id = 89216
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289210, [29], [{102170,[100,3,1,160]}], [], 3}
    };
get_skill(89216) ->
    #demon_skill{
        id = 89216
        ,name = <<"高级金系护宠">>
        ,type = 9
        ,step = 7
        ,craft = 3
        ,exp = 243
        ,next_id = 89217
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289210, [30], [{102170,[100,3,1,170]}], [], 3}
    };
get_skill(89217) ->
    #demon_skill{
        id = 89217
        ,name = <<"高级金系护宠">>
        ,type = 9
        ,step = 8
        ,craft = 3
        ,exp = 487
        ,next_id = 89218
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289210, [31], [{102170,[100,3,1,180]}], [], 3}
    };
get_skill(89218) ->
    #demon_skill{
        id = 89218
        ,name = <<"高级金系护宠">>
        ,type = 9
        ,step = 9
        ,craft = 3
        ,exp = 975
        ,next_id = 89219
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289210, [32], [{102170,[100,3,1,190]}], [], 3}
    };
get_skill(89219) ->
    #demon_skill{
        id = 89219
        ,name = <<"高级金系护宠">>
        ,type = 9
        ,step = 10
        ,craft = 3
        ,exp = 1200
        ,next_id = 0
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289210, [33], [{102170,[100,3,1,200]}], [], 3}
    };
get_skill(89220) ->
    #demon_skill{
        id = 89220
        ,name = <<"高级木系护宠">>
        ,type = 10
        ,step = 1
        ,craft = 3
        ,exp = 3
        ,next_id = 89221
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289220, [24], [{102180,[100,3,1,110]}], [], 3}
    };
get_skill(89221) ->
    #demon_skill{
        id = 89221
        ,name = <<"高级木系护宠">>
        ,type = 10
        ,step = 2
        ,craft = 3
        ,exp = 7
        ,next_id = 89222
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289220, [25], [{102180,[100,3,1,120]}], [], 3}
    };
get_skill(89222) ->
    #demon_skill{
        id = 89222
        ,name = <<"高级木系护宠">>
        ,type = 10
        ,step = 3
        ,craft = 3
        ,exp = 14
        ,next_id = 89223
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289220, [26], [{102180,[100,3,1,130]}], [], 3}
    };
get_skill(89223) ->
    #demon_skill{
        id = 89223
        ,name = <<"高级木系护宠">>
        ,type = 10
        ,step = 4
        ,craft = 3
        ,exp = 30
        ,next_id = 89224
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289220, [27], [{102180,[100,3,1,140]}], [], 3}
    };
get_skill(89224) ->
    #demon_skill{
        id = 89224
        ,name = <<"高级木系护宠">>
        ,type = 10
        ,step = 5
        ,craft = 3
        ,exp = 60
        ,next_id = 89225
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289220, [28], [{102180,[100,3,1,150]}], [], 3}
    };
get_skill(89225) ->
    #demon_skill{
        id = 89225
        ,name = <<"高级木系护宠">>
        ,type = 10
        ,step = 6
        ,craft = 3
        ,exp = 121
        ,next_id = 89226
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289220, [29], [{102180,[100,3,1,160]}], [], 3}
    };
get_skill(89226) ->
    #demon_skill{
        id = 89226
        ,name = <<"高级木系护宠">>
        ,type = 10
        ,step = 7
        ,craft = 3
        ,exp = 243
        ,next_id = 89227
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289220, [30], [{102180,[100,3,1,170]}], [], 3}
    };
get_skill(89227) ->
    #demon_skill{
        id = 89227
        ,name = <<"高级木系护宠">>
        ,type = 10
        ,step = 8
        ,craft = 3
        ,exp = 487
        ,next_id = 89228
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289220, [31], [{102180,[100,3,1,180]}], [], 3}
    };
get_skill(89228) ->
    #demon_skill{
        id = 89228
        ,name = <<"高级木系护宠">>
        ,type = 10
        ,step = 9
        ,craft = 3
        ,exp = 975
        ,next_id = 89229
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289220, [32], [{102180,[100,3,1,190]}], [], 3}
    };
get_skill(89229) ->
    #demon_skill{
        id = 89229
        ,name = <<"高级木系护宠">>
        ,type = 10
        ,step = 10
        ,craft = 3
        ,exp = 1200
        ,next_id = 0
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289220, [33], [{102180,[100,3,1,200]}], [], 3}
    };
get_skill(89230) ->
    #demon_skill{
        id = 89230
        ,name = <<"高级水系护宠">>
        ,type = 11
        ,step = 1
        ,craft = 3
        ,exp = 3
        ,next_id = 89231
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289230, [24], [{102200,[100,3,1,110]}], [], 3}
    };
get_skill(89231) ->
    #demon_skill{
        id = 89231
        ,name = <<"高级水系护宠">>
        ,type = 11
        ,step = 2
        ,craft = 3
        ,exp = 7
        ,next_id = 89232
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289230, [25], [{102200,[100,3,1,120]}], [], 3}
    };
get_skill(89232) ->
    #demon_skill{
        id = 89232
        ,name = <<"高级水系护宠">>
        ,type = 11
        ,step = 3
        ,craft = 3
        ,exp = 14
        ,next_id = 89233
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289230, [26], [{102200,[100,3,1,130]}], [], 3}
    };
get_skill(89233) ->
    #demon_skill{
        id = 89233
        ,name = <<"高级水系护宠">>
        ,type = 11
        ,step = 4
        ,craft = 3
        ,exp = 30
        ,next_id = 89234
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289230, [27], [{102200,[100,3,1,140]}], [], 3}
    };
get_skill(89234) ->
    #demon_skill{
        id = 89234
        ,name = <<"高级水系护宠">>
        ,type = 11
        ,step = 5
        ,craft = 3
        ,exp = 60
        ,next_id = 89235
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289230, [28], [{102200,[100,3,1,150]}], [], 3}
    };
get_skill(89235) ->
    #demon_skill{
        id = 89235
        ,name = <<"高级水系护宠">>
        ,type = 11
        ,step = 6
        ,craft = 3
        ,exp = 121
        ,next_id = 89236
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289230, [29], [{102200,[100,3,1,160]}], [], 3}
    };
get_skill(89236) ->
    #demon_skill{
        id = 89236
        ,name = <<"高级水系护宠">>
        ,type = 11
        ,step = 7
        ,craft = 3
        ,exp = 243
        ,next_id = 89237
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289230, [30], [{102200,[100,3,1,170]}], [], 3}
    };
get_skill(89237) ->
    #demon_skill{
        id = 89237
        ,name = <<"高级水系护宠">>
        ,type = 11
        ,step = 8
        ,craft = 3
        ,exp = 487
        ,next_id = 89238
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289230, [31], [{102200,[100,3,1,180]}], [], 3}
    };
get_skill(89238) ->
    #demon_skill{
        id = 89238
        ,name = <<"高级水系护宠">>
        ,type = 11
        ,step = 9
        ,craft = 3
        ,exp = 975
        ,next_id = 89239
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289230, [32], [{102200,[100,3,1,190]}], [], 3}
    };
get_skill(89239) ->
    #demon_skill{
        id = 89239
        ,name = <<"高级水系护宠">>
        ,type = 11
        ,step = 10
        ,craft = 3
        ,exp = 1200
        ,next_id = 0
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289230, [33], [{102200,[100,3,1,200]}], [], 3}
    };
get_skill(89240) ->
    #demon_skill{
        id = 89240
        ,name = <<"高级火系护宠">>
        ,type = 12
        ,step = 1
        ,craft = 3
        ,exp = 3
        ,next_id = 89241
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289240, [24], [{102190,[100,3,1,110]}], [], 3}
    };
get_skill(89241) ->
    #demon_skill{
        id = 89241
        ,name = <<"高级火系护宠">>
        ,type = 12
        ,step = 2
        ,craft = 3
        ,exp = 7
        ,next_id = 89242
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289240, [25], [{102190,[100,3,1,120]}], [], 3}
    };
get_skill(89242) ->
    #demon_skill{
        id = 89242
        ,name = <<"高级火系护宠">>
        ,type = 12
        ,step = 3
        ,craft = 3
        ,exp = 14
        ,next_id = 89243
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289240, [26], [{102190,[100,3,1,130]}], [], 3}
    };
get_skill(89243) ->
    #demon_skill{
        id = 89243
        ,name = <<"高级火系护宠">>
        ,type = 12
        ,step = 4
        ,craft = 3
        ,exp = 30
        ,next_id = 89244
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289240, [27], [{102190,[100,3,1,140]}], [], 3}
    };
get_skill(89244) ->
    #demon_skill{
        id = 89244
        ,name = <<"高级火系护宠">>
        ,type = 12
        ,step = 5
        ,craft = 3
        ,exp = 60
        ,next_id = 89245
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289240, [28], [{102190,[100,3,1,150]}], [], 3}
    };
get_skill(89245) ->
    #demon_skill{
        id = 89245
        ,name = <<"高级火系护宠">>
        ,type = 12
        ,step = 6
        ,craft = 3
        ,exp = 121
        ,next_id = 89246
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289240, [29], [{102190,[100,3,1,160]}], [], 3}
    };
get_skill(89246) ->
    #demon_skill{
        id = 89246
        ,name = <<"高级火系护宠">>
        ,type = 12
        ,step = 7
        ,craft = 3
        ,exp = 243
        ,next_id = 89247
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289240, [30], [{102190,[100,3,1,170]}], [], 3}
    };
get_skill(89247) ->
    #demon_skill{
        id = 89247
        ,name = <<"高级火系护宠">>
        ,type = 12
        ,step = 8
        ,craft = 3
        ,exp = 487
        ,next_id = 89248
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289240, [31], [{102190,[100,3,1,180]}], [], 3}
    };
get_skill(89248) ->
    #demon_skill{
        id = 89248
        ,name = <<"高级火系护宠">>
        ,type = 12
        ,step = 9
        ,craft = 3
        ,exp = 975
        ,next_id = 89249
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289240, [32], [{102190,[100,3,1,190]}], [], 3}
    };
get_skill(89249) ->
    #demon_skill{
        id = 89249
        ,name = <<"高级火系护宠">>
        ,type = 12
        ,step = 10
        ,craft = 3
        ,exp = 1200
        ,next_id = 0
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289240, [33], [{102190,[100,3,1,200]}], [], 3}
    };
get_skill(89250) ->
    #demon_skill{
        id = 89250
        ,name = <<"高级土系护宠">>
        ,type = 13
        ,step = 1
        ,craft = 3
        ,exp = 3
        ,next_id = 89251
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289250, [24], [{102210,[100,3,1,110]}], [], 3}
    };
get_skill(89251) ->
    #demon_skill{
        id = 89251
        ,name = <<"高级土系护宠">>
        ,type = 13
        ,step = 2
        ,craft = 3
        ,exp = 7
        ,next_id = 89252
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289250, [25], [{102210,[100,3,1,120]}], [], 3}
    };
get_skill(89252) ->
    #demon_skill{
        id = 89252
        ,name = <<"高级土系护宠">>
        ,type = 13
        ,step = 3
        ,craft = 3
        ,exp = 14
        ,next_id = 89253
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289250, [26], [{102210,[100,3,1,130]}], [], 3}
    };
get_skill(89253) ->
    #demon_skill{
        id = 89253
        ,name = <<"高级土系护宠">>
        ,type = 13
        ,step = 4
        ,craft = 3
        ,exp = 30
        ,next_id = 89254
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289250, [27], [{102210,[100,3,1,140]}], [], 3}
    };
get_skill(89254) ->
    #demon_skill{
        id = 89254
        ,name = <<"高级土系护宠">>
        ,type = 13
        ,step = 5
        ,craft = 3
        ,exp = 60
        ,next_id = 89255
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289250, [28], [{102210,[100,3,1,150]}], [], 3}
    };
get_skill(89255) ->
    #demon_skill{
        id = 89255
        ,name = <<"高级土系护宠">>
        ,type = 13
        ,step = 6
        ,craft = 3
        ,exp = 121
        ,next_id = 89256
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289250, [29], [{102210,[100,3,1,160]}], [], 3}
    };
get_skill(89256) ->
    #demon_skill{
        id = 89256
        ,name = <<"高级土系护宠">>
        ,type = 13
        ,step = 7
        ,craft = 3
        ,exp = 243
        ,next_id = 89257
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289250, [30], [{102210,[100,3,1,170]}], [], 3}
    };
get_skill(89257) ->
    #demon_skill{
        id = 89257
        ,name = <<"高级土系护宠">>
        ,type = 13
        ,step = 8
        ,craft = 3
        ,exp = 487
        ,next_id = 89258
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289250, [31], [{102210,[100,3,1,180]}], [], 3}
    };
get_skill(89258) ->
    #demon_skill{
        id = 89258
        ,name = <<"高级土系护宠">>
        ,type = 13
        ,step = 9
        ,craft = 3
        ,exp = 975
        ,next_id = 89259
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289250, [32], [{102210,[100,3,1,190]}], [], 3}
    };
get_skill(89259) ->
    #demon_skill{
        id = 89259
        ,name = <<"高级土系护宠">>
        ,type = 13
        ,step = 10
        ,craft = 3
        ,exp = 1200
        ,next_id = 0
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289250, [33], [{102210,[100,3,1,200]}], [], 3}
    };
get_skill(89260) ->
    #demon_skill{
        id = 89260
        ,name = <<"高级轮回天生">>
        ,type = 14
        ,step = 1
        ,craft = 3
        ,exp = 3
        ,next_id = 89261
        ,limit = []
        ,pet_info = {pet_skill, 289260, [1,30,2], [], [], 99}
    };
get_skill(89261) ->
    #demon_skill{
        id = 89261
        ,name = <<"高级轮回天生">>
        ,type = 14
        ,step = 2
        ,craft = 3
        ,exp = 7
        ,next_id = 89262
        ,limit = []
        ,pet_info = {pet_skill, 289260, [1,35,3], [], [], 99}
    };
get_skill(89262) ->
    #demon_skill{
        id = 89262
        ,name = <<"高级轮回天生">>
        ,type = 14
        ,step = 3
        ,craft = 3
        ,exp = 14
        ,next_id = 89263
        ,limit = []
        ,pet_info = {pet_skill, 289260, [1,40,4], [], [], 99}
    };
get_skill(89263) ->
    #demon_skill{
        id = 89263
        ,name = <<"高级轮回天生">>
        ,type = 14
        ,step = 4
        ,craft = 3
        ,exp = 30
        ,next_id = 89264
        ,limit = []
        ,pet_info = {pet_skill, 289260, [1,45,5], [], [], 99}
    };
get_skill(89264) ->
    #demon_skill{
        id = 89264
        ,name = <<"高级轮回天生">>
        ,type = 14
        ,step = 5
        ,craft = 3
        ,exp = 60
        ,next_id = 89265
        ,limit = []
        ,pet_info = {pet_skill, 289260, [1,50,6], [], [], 99}
    };
get_skill(89265) ->
    #demon_skill{
        id = 89265
        ,name = <<"高级轮回天生">>
        ,type = 14
        ,step = 6
        ,craft = 3
        ,exp = 121
        ,next_id = 89266
        ,limit = []
        ,pet_info = {pet_skill, 289260, [1,55,7], [], [], 99}
    };
get_skill(89266) ->
    #demon_skill{
        id = 89266
        ,name = <<"高级轮回天生">>
        ,type = 14
        ,step = 7
        ,craft = 3
        ,exp = 243
        ,next_id = 89267
        ,limit = []
        ,pet_info = {pet_skill, 289260, [1,60,8], [], [], 99}
    };
get_skill(89267) ->
    #demon_skill{
        id = 89267
        ,name = <<"高级轮回天生">>
        ,type = 14
        ,step = 8
        ,craft = 3
        ,exp = 487
        ,next_id = 89268
        ,limit = []
        ,pet_info = {pet_skill, 289260, [1,65,9], [], [], 99}
    };
get_skill(89268) ->
    #demon_skill{
        id = 89268
        ,name = <<"高级轮回天生">>
        ,type = 14
        ,step = 9
        ,craft = 3
        ,exp = 975
        ,next_id = 89269
        ,limit = []
        ,pet_info = {pet_skill, 289260, [1,70,10], [], [], 99}
    };
get_skill(89269) ->
    #demon_skill{
        id = 89269
        ,name = <<"高级轮回天生">>
        ,type = 14
        ,step = 10
        ,craft = 3
        ,exp = 1200
        ,next_id = 0
        ,limit = []
        ,pet_info = {pet_skill, 289260, [1,75,11], [], [], 99}
    };
get_skill(89300) ->
    #demon_skill{
        id = 89300
        ,name = <<"至尊急速治愈">>
        ,type = 8
        ,step = 1
        ,craft = 4
        ,exp = 4
        ,next_id = 89301
        ,limit = []
        ,pet_info = {pet_skill, 289300, [9], [{101011,[100,3,1,4000]}], [], 3}
    };
get_skill(89301) ->
    #demon_skill{
        id = 89301
        ,name = <<"至尊急速治愈">>
        ,type = 8
        ,step = 2
        ,craft = 4
        ,exp = 10
        ,next_id = 89302
        ,limit = []
        ,pet_info = {pet_skill, 289300, [10], [{101011,[100,3,1,4500]}], [], 3}
    };
get_skill(89302) ->
    #demon_skill{
        id = 89302
        ,name = <<"至尊急速治愈">>
        ,type = 8
        ,step = 3
        ,craft = 4
        ,exp = 20
        ,next_id = 89303
        ,limit = []
        ,pet_info = {pet_skill, 289300, [11], [{101011,[100,3,1,5000]}], [], 3}
    };
get_skill(89303) ->
    #demon_skill{
        id = 89303
        ,name = <<"至尊急速治愈">>
        ,type = 8
        ,step = 4
        ,craft = 4
        ,exp = 42
        ,next_id = 89304
        ,limit = []
        ,pet_info = {pet_skill, 289300, [12], [{101011,[100,3,1,5500]}], [], 3}
    };
get_skill(89304) ->
    #demon_skill{
        id = 89304
        ,name = <<"至尊急速治愈">>
        ,type = 8
        ,step = 5
        ,craft = 4
        ,exp = 84
        ,next_id = 89305
        ,limit = []
        ,pet_info = {pet_skill, 289300, [13], [{101011,[100,3,1,6000]}], [], 3}
    };
get_skill(89305) ->
    #demon_skill{
        id = 89305
        ,name = <<"至尊急速治愈">>
        ,type = 8
        ,step = 6
        ,craft = 4
        ,exp = 170
        ,next_id = 89306
        ,limit = []
        ,pet_info = {pet_skill, 289300, [14], [{101011,[100,3,1,6500]}], [], 3}
    };
get_skill(89306) ->
    #demon_skill{
        id = 89306
        ,name = <<"至尊急速治愈">>
        ,type = 8
        ,step = 7
        ,craft = 4
        ,exp = 340
        ,next_id = 89307
        ,limit = []
        ,pet_info = {pet_skill, 289300, [15], [{101011,[100,3,1,7000]}], [], 3}
    };
get_skill(89307) ->
    #demon_skill{
        id = 89307
        ,name = <<"至尊急速治愈">>
        ,type = 8
        ,step = 8
        ,craft = 4
        ,exp = 682
        ,next_id = 89308
        ,limit = []
        ,pet_info = {pet_skill, 289300, [16], [{101011,[100,3,1,7500]}], [], 3}
    };
get_skill(89308) ->
    #demon_skill{
        id = 89308
        ,name = <<"至尊急速治愈">>
        ,type = 8
        ,step = 9
        ,craft = 4
        ,exp = 1365
        ,next_id = 89309
        ,limit = []
        ,pet_info = {pet_skill, 289300, [17], [{101011,[100,3,1,8000]}], [], 3}
    };
get_skill(89309) ->
    #demon_skill{
        id = 89309
        ,name = <<"至尊急速治愈">>
        ,type = 8
        ,step = 10
        ,craft = 4
        ,exp = 1800
        ,next_id = 0
        ,limit = []
        ,pet_info = {pet_skill, 289300, [18], [{101011,[100,3,1,8500]}], [], 3}
    };
get_skill(89310) ->
    #demon_skill{
        id = 89310
        ,name = <<"至尊金系护宠">>
        ,type = 9
        ,step = 1
        ,craft = 4
        ,exp = 4
        ,next_id = 89311
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289310, [25], [{102170,[100,3,1,140]}], [], 3}
    };
get_skill(89311) ->
    #demon_skill{
        id = 89311
        ,name = <<"至尊金系护宠">>
        ,type = 9
        ,step = 2
        ,craft = 4
        ,exp = 10
        ,next_id = 89312
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289310, [26], [{102170,[100,3,1,150]}], [], 3}
    };
get_skill(89312) ->
    #demon_skill{
        id = 89312
        ,name = <<"至尊金系护宠">>
        ,type = 9
        ,step = 3
        ,craft = 4
        ,exp = 20
        ,next_id = 89313
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289310, [27], [{102170,[100,3,1,160]}], [], 3}
    };
get_skill(89313) ->
    #demon_skill{
        id = 89313
        ,name = <<"至尊金系护宠">>
        ,type = 9
        ,step = 4
        ,craft = 4
        ,exp = 42
        ,next_id = 89314
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289310, [28], [{102170,[100,3,1,170]}], [], 3}
    };
get_skill(89314) ->
    #demon_skill{
        id = 89314
        ,name = <<"至尊金系护宠">>
        ,type = 9
        ,step = 5
        ,craft = 4
        ,exp = 84
        ,next_id = 89315
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289310, [29], [{102170,[100,3,1,180]}], [], 3}
    };
get_skill(89315) ->
    #demon_skill{
        id = 89315
        ,name = <<"至尊金系护宠">>
        ,type = 9
        ,step = 6
        ,craft = 4
        ,exp = 170
        ,next_id = 89316
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289310, [30], [{102170,[100,3,1,190]}], [], 3}
    };
get_skill(89316) ->
    #demon_skill{
        id = 89316
        ,name = <<"至尊金系护宠">>
        ,type = 9
        ,step = 7
        ,craft = 4
        ,exp = 340
        ,next_id = 89317
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289310, [31], [{102170,[100,3,1,200]}], [], 3}
    };
get_skill(89317) ->
    #demon_skill{
        id = 89317
        ,name = <<"至尊金系护宠">>
        ,type = 9
        ,step = 8
        ,craft = 4
        ,exp = 682
        ,next_id = 89318
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289310, [32], [{102170,[100,3,1,210]}], [], 3}
    };
get_skill(89318) ->
    #demon_skill{
        id = 89318
        ,name = <<"至尊金系护宠">>
        ,type = 9
        ,step = 9
        ,craft = 4
        ,exp = 1365
        ,next_id = 89319
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289310, [33], [{102170,[100,3,1,220]}], [], 3}
    };
get_skill(89319) ->
    #demon_skill{
        id = 89319
        ,name = <<"至尊金系护宠">>
        ,type = 9
        ,step = 10
        ,craft = 4
        ,exp = 1800
        ,next_id = 0
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289310, [34], [{102170,[100,3,1,230]}], [], 3}
    };
get_skill(89320) ->
    #demon_skill{
        id = 89320
        ,name = <<"至尊木系护宠">>
        ,type = 10
        ,step = 1
        ,craft = 4
        ,exp = 4
        ,next_id = 89321
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289320, [25], [{102180,[100,3,1,140]}], [], 3}
    };
get_skill(89321) ->
    #demon_skill{
        id = 89321
        ,name = <<"至尊木系护宠">>
        ,type = 10
        ,step = 2
        ,craft = 4
        ,exp = 10
        ,next_id = 89322
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289320, [26], [{102180,[100,3,1,150]}], [], 3}
    };
get_skill(89322) ->
    #demon_skill{
        id = 89322
        ,name = <<"至尊木系护宠">>
        ,type = 10
        ,step = 3
        ,craft = 4
        ,exp = 20
        ,next_id = 89323
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289320, [27], [{102180,[100,3,1,160]}], [], 3}
    };
get_skill(89323) ->
    #demon_skill{
        id = 89323
        ,name = <<"至尊木系护宠">>
        ,type = 10
        ,step = 4
        ,craft = 4
        ,exp = 42
        ,next_id = 89324
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289320, [28], [{102180,[100,3,1,170]}], [], 3}
    };
get_skill(89324) ->
    #demon_skill{
        id = 89324
        ,name = <<"至尊木系护宠">>
        ,type = 10
        ,step = 5
        ,craft = 4
        ,exp = 84
        ,next_id = 89325
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289320, [29], [{102180,[100,3,1,180]}], [], 3}
    };
get_skill(89325) ->
    #demon_skill{
        id = 89325
        ,name = <<"至尊木系护宠">>
        ,type = 10
        ,step = 6
        ,craft = 4
        ,exp = 170
        ,next_id = 89326
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289320, [30], [{102180,[100,3,1,190]}], [], 3}
    };
get_skill(89326) ->
    #demon_skill{
        id = 89326
        ,name = <<"至尊木系护宠">>
        ,type = 10
        ,step = 7
        ,craft = 4
        ,exp = 340
        ,next_id = 89327
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289320, [31], [{102180,[100,3,1,200]}], [], 3}
    };
get_skill(89327) ->
    #demon_skill{
        id = 89327
        ,name = <<"至尊木系护宠">>
        ,type = 10
        ,step = 8
        ,craft = 4
        ,exp = 682
        ,next_id = 89328
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289320, [32], [{102180,[100,3,1,210]}], [], 3}
    };
get_skill(89328) ->
    #demon_skill{
        id = 89328
        ,name = <<"至尊木系护宠">>
        ,type = 10
        ,step = 9
        ,craft = 4
        ,exp = 1365
        ,next_id = 89329
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289320, [33], [{102180,[100,3,1,220]}], [], 3}
    };
get_skill(89329) ->
    #demon_skill{
        id = 89329
        ,name = <<"至尊木系护宠">>
        ,type = 10
        ,step = 10
        ,craft = 4
        ,exp = 1800
        ,next_id = 0
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289320, [34], [{102180,[100,3,1,230]}], [], 3}
    };
get_skill(89330) ->
    #demon_skill{
        id = 89330
        ,name = <<"至尊水系护宠">>
        ,type = 11
        ,step = 1
        ,craft = 4
        ,exp = 4
        ,next_id = 89331
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289330, [25], [{102200,[100,3,1,140]}], [], 3}
    };
get_skill(89331) ->
    #demon_skill{
        id = 89331
        ,name = <<"至尊水系护宠">>
        ,type = 11
        ,step = 2
        ,craft = 4
        ,exp = 10
        ,next_id = 89332
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289330, [26], [{102200,[100,3,1,150]}], [], 3}
    };
get_skill(89332) ->
    #demon_skill{
        id = 89332
        ,name = <<"至尊水系护宠">>
        ,type = 11
        ,step = 3
        ,craft = 4
        ,exp = 20
        ,next_id = 89333
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289330, [27], [{102200,[100,3,1,160]}], [], 3}
    };
get_skill(89333) ->
    #demon_skill{
        id = 89333
        ,name = <<"至尊水系护宠">>
        ,type = 11
        ,step = 4
        ,craft = 4
        ,exp = 42
        ,next_id = 89334
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289330, [28], [{102200,[100,3,1,170]}], [], 3}
    };
get_skill(89334) ->
    #demon_skill{
        id = 89334
        ,name = <<"至尊水系护宠">>
        ,type = 11
        ,step = 5
        ,craft = 4
        ,exp = 84
        ,next_id = 89335
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289330, [29], [{102200,[100,3,1,180]}], [], 3}
    };
get_skill(89335) ->
    #demon_skill{
        id = 89335
        ,name = <<"至尊水系护宠">>
        ,type = 11
        ,step = 6
        ,craft = 4
        ,exp = 170
        ,next_id = 89336
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289330, [30], [{102200,[100,3,1,190]}], [], 3}
    };
get_skill(89336) ->
    #demon_skill{
        id = 89336
        ,name = <<"至尊水系护宠">>
        ,type = 11
        ,step = 7
        ,craft = 4
        ,exp = 340
        ,next_id = 89337
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289330, [31], [{102200,[100,3,1,200]}], [], 3}
    };
get_skill(89337) ->
    #demon_skill{
        id = 89337
        ,name = <<"至尊水系护宠">>
        ,type = 11
        ,step = 8
        ,craft = 4
        ,exp = 682
        ,next_id = 89338
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289330, [32], [{102200,[100,3,1,210]}], [], 3}
    };
get_skill(89338) ->
    #demon_skill{
        id = 89338
        ,name = <<"至尊水系护宠">>
        ,type = 11
        ,step = 9
        ,craft = 4
        ,exp = 1365
        ,next_id = 89339
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289330, [33], [{102200,[100,3,1,220]}], [], 3}
    };
get_skill(89339) ->
    #demon_skill{
        id = 89339
        ,name = <<"至尊水系护宠">>
        ,type = 11
        ,step = 10
        ,craft = 4
        ,exp = 1800
        ,next_id = 0
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289330, [34], [{102200,[100,3,1,230]}], [], 3}
    };
get_skill(89340) ->
    #demon_skill{
        id = 89340
        ,name = <<"至尊火系护宠">>
        ,type = 12
        ,step = 1
        ,craft = 4
        ,exp = 4
        ,next_id = 89341
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289340, [25], [{102190,[100,3,1,140]}], [], 3}
    };
get_skill(89341) ->
    #demon_skill{
        id = 89341
        ,name = <<"至尊火系护宠">>
        ,type = 12
        ,step = 2
        ,craft = 4
        ,exp = 10
        ,next_id = 89342
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289340, [26], [{102190,[100,3,1,150]}], [], 3}
    };
get_skill(89342) ->
    #demon_skill{
        id = 89342
        ,name = <<"至尊火系护宠">>
        ,type = 12
        ,step = 3
        ,craft = 4
        ,exp = 20
        ,next_id = 89343
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289340, [27], [{102190,[100,3,1,160]}], [], 3}
    };
get_skill(89343) ->
    #demon_skill{
        id = 89343
        ,name = <<"至尊火系护宠">>
        ,type = 12
        ,step = 4
        ,craft = 4
        ,exp = 42
        ,next_id = 89344
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289340, [28], [{102190,[100,3,1,170]}], [], 3}
    };
get_skill(89344) ->
    #demon_skill{
        id = 89344
        ,name = <<"至尊火系护宠">>
        ,type = 12
        ,step = 5
        ,craft = 4
        ,exp = 84
        ,next_id = 89345
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289340, [29], [{102190,[100,3,1,180]}], [], 3}
    };
get_skill(89345) ->
    #demon_skill{
        id = 89345
        ,name = <<"至尊火系护宠">>
        ,type = 12
        ,step = 6
        ,craft = 4
        ,exp = 170
        ,next_id = 89346
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289340, [30], [{102190,[100,3,1,190]}], [], 3}
    };
get_skill(89346) ->
    #demon_skill{
        id = 89346
        ,name = <<"至尊火系护宠">>
        ,type = 12
        ,step = 7
        ,craft = 4
        ,exp = 340
        ,next_id = 89347
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289340, [31], [{102190,[100,3,1,200]}], [], 3}
    };
get_skill(89347) ->
    #demon_skill{
        id = 89347
        ,name = <<"至尊火系护宠">>
        ,type = 12
        ,step = 8
        ,craft = 4
        ,exp = 682
        ,next_id = 89348
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289340, [32], [{102190,[100,3,1,210]}], [], 3}
    };
get_skill(89348) ->
    #demon_skill{
        id = 89348
        ,name = <<"至尊火系护宠">>
        ,type = 12
        ,step = 9
        ,craft = 4
        ,exp = 1365
        ,next_id = 89349
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289340, [33], [{102190,[100,3,1,220]}], [], 3}
    };
get_skill(89349) ->
    #demon_skill{
        id = 89349
        ,name = <<"至尊火系护宠">>
        ,type = 12
        ,step = 10
        ,craft = 4
        ,exp = 1800
        ,next_id = 0
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289340, [34], [{102190,[100,3,1,230]}], [], 3}
    };
get_skill(89350) ->
    #demon_skill{
        id = 89350
        ,name = <<"至尊土系护宠">>
        ,type = 13
        ,step = 1
        ,craft = 4
        ,exp = 4
        ,next_id = 89351
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289350, [25], [{102210,[100,3,1,140]}], [], 3}
    };
get_skill(89351) ->
    #demon_skill{
        id = 89351
        ,name = <<"至尊土系护宠">>
        ,type = 13
        ,step = 2
        ,craft = 4
        ,exp = 10
        ,next_id = 89352
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289350, [26], [{102210,[100,3,1,150]}], [], 3}
    };
get_skill(89352) ->
    #demon_skill{
        id = 89352
        ,name = <<"至尊土系护宠">>
        ,type = 13
        ,step = 3
        ,craft = 4
        ,exp = 20
        ,next_id = 89353
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289350, [27], [{102210,[100,3,1,160]}], [], 3}
    };
get_skill(89353) ->
    #demon_skill{
        id = 89353
        ,name = <<"至尊土系护宠">>
        ,type = 13
        ,step = 4
        ,craft = 4
        ,exp = 42
        ,next_id = 89354
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289350, [28], [{102210,[100,3,1,170]}], [], 3}
    };
get_skill(89354) ->
    #demon_skill{
        id = 89354
        ,name = <<"至尊土系护宠">>
        ,type = 13
        ,step = 5
        ,craft = 4
        ,exp = 84
        ,next_id = 89355
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289350, [29], [{102210,[100,3,1,180]}], [], 3}
    };
get_skill(89355) ->
    #demon_skill{
        id = 89355
        ,name = <<"至尊土系护宠">>
        ,type = 13
        ,step = 6
        ,craft = 4
        ,exp = 170
        ,next_id = 89356
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289350, [30], [{102210,[100,3,1,190]}], [], 3}
    };
get_skill(89356) ->
    #demon_skill{
        id = 89356
        ,name = <<"至尊土系护宠">>
        ,type = 13
        ,step = 7
        ,craft = 4
        ,exp = 340
        ,next_id = 89357
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289350, [31], [{102210,[100,3,1,200]}], [], 3}
    };
get_skill(89357) ->
    #demon_skill{
        id = 89357
        ,name = <<"至尊土系护宠">>
        ,type = 13
        ,step = 8
        ,craft = 4
        ,exp = 682
        ,next_id = 89358
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289350, [32], [{102210,[100,3,1,210]}], [], 3}
    };
get_skill(89358) ->
    #demon_skill{
        id = 89358
        ,name = <<"至尊土系护宠">>
        ,type = 13
        ,step = 9
        ,craft = 4
        ,exp = 1365
        ,next_id = 89359
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289350, [33], [{102210,[100,3,1,220]}], [], 3}
    };
get_skill(89359) ->
    #demon_skill{
        id = 89359
        ,name = <<"至尊土系护宠">>
        ,type = 13
        ,step = 10
        ,craft = 4
        ,exp = 1800
        ,next_id = 0
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289350, [34], [{102210,[100,3,1,230]}], [], 3}
    };
get_skill(89360) ->
    #demon_skill{
        id = 89360
        ,name = <<"至尊轮回天生">>
        ,type = 14
        ,step = 1
        ,craft = 4
        ,exp = 4
        ,next_id = 89361
        ,limit = []
        ,pet_info = {pet_skill, 289360, [1,35,2], [], [], 99}
    };
get_skill(89361) ->
    #demon_skill{
        id = 89361
        ,name = <<"至尊轮回天生">>
        ,type = 14
        ,step = 2
        ,craft = 4
        ,exp = 10
        ,next_id = 89362
        ,limit = []
        ,pet_info = {pet_skill, 289360, [1,40,3], [], [], 99}
    };
get_skill(89362) ->
    #demon_skill{
        id = 89362
        ,name = <<"至尊轮回天生">>
        ,type = 14
        ,step = 3
        ,craft = 4
        ,exp = 20
        ,next_id = 89363
        ,limit = []
        ,pet_info = {pet_skill, 289360, [1,45,4], [], [], 99}
    };
get_skill(89363) ->
    #demon_skill{
        id = 89363
        ,name = <<"至尊轮回天生">>
        ,type = 14
        ,step = 4
        ,craft = 4
        ,exp = 42
        ,next_id = 89364
        ,limit = []
        ,pet_info = {pet_skill, 289360, [1,50,5], [], [], 99}
    };
get_skill(89364) ->
    #demon_skill{
        id = 89364
        ,name = <<"至尊轮回天生">>
        ,type = 14
        ,step = 5
        ,craft = 4
        ,exp = 84
        ,next_id = 89365
        ,limit = []
        ,pet_info = {pet_skill, 289360, [1,55,6], [], [], 99}
    };
get_skill(89365) ->
    #demon_skill{
        id = 89365
        ,name = <<"至尊轮回天生">>
        ,type = 14
        ,step = 6
        ,craft = 4
        ,exp = 170
        ,next_id = 89366
        ,limit = []
        ,pet_info = {pet_skill, 289360, [1,60,7], [], [], 99}
    };
get_skill(89366) ->
    #demon_skill{
        id = 89366
        ,name = <<"至尊轮回天生">>
        ,type = 14
        ,step = 7
        ,craft = 4
        ,exp = 340
        ,next_id = 89367
        ,limit = []
        ,pet_info = {pet_skill, 289360, [1,65,8], [], [], 99}
    };
get_skill(89367) ->
    #demon_skill{
        id = 89367
        ,name = <<"至尊轮回天生">>
        ,type = 14
        ,step = 8
        ,craft = 4
        ,exp = 682
        ,next_id = 89368
        ,limit = []
        ,pet_info = {pet_skill, 289360, [1,70,9], [], [], 99}
    };
get_skill(89368) ->
    #demon_skill{
        id = 89368
        ,name = <<"至尊轮回天生">>
        ,type = 14
        ,step = 9
        ,craft = 4
        ,exp = 1365
        ,next_id = 89369
        ,limit = []
        ,pet_info = {pet_skill, 289360, [1,75,10], [], [], 99}
    };
get_skill(89369) ->
    #demon_skill{
        id = 89369
        ,name = <<"至尊轮回天生">>
        ,type = 14
        ,step = 10
        ,craft = 4
        ,exp = 1800
        ,next_id = 0
        ,limit = []
        ,pet_info = {pet_skill, 289360, [1,80,11], [], [], 99}
    };
get_skill(89400) ->
    #demon_skill{
        id = 89400
        ,name = <<"神级急速治愈">>
        ,type = 8
        ,step = 1
        ,craft = 5
        ,exp = 6
        ,next_id = 89401
        ,limit = []
        ,pet_info = {pet_skill, 289400, [10], [{101011,[100,3,1,6000]}], [], 3}
    };
get_skill(89401) ->
    #demon_skill{
        id = 89401
        ,name = <<"神级急速治愈">>
        ,type = 8
        ,step = 2
        ,craft = 5
        ,exp = 15
        ,next_id = 89402
        ,limit = []
        ,pet_info = {pet_skill, 289400, [11], [{101011,[100,3,1,6500]}], [], 3}
    };
get_skill(89402) ->
    #demon_skill{
        id = 89402
        ,name = <<"神级急速治愈">>
        ,type = 8
        ,step = 3
        ,craft = 5
        ,exp = 30
        ,next_id = 89403
        ,limit = []
        ,pet_info = {pet_skill, 289400, [12], [{101011,[100,3,1,7000]}], [], 3}
    };
get_skill(89403) ->
    #demon_skill{
        id = 89403
        ,name = <<"神级急速治愈">>
        ,type = 8
        ,step = 4
        ,craft = 5
        ,exp = 63
        ,next_id = 89404
        ,limit = []
        ,pet_info = {pet_skill, 289400, [13], [{101011,[100,3,1,7500]}], [], 3}
    };
get_skill(89404) ->
    #demon_skill{
        id = 89404
        ,name = <<"神级急速治愈">>
        ,type = 8
        ,step = 5
        ,craft = 5
        ,exp = 126
        ,next_id = 89405
        ,limit = []
        ,pet_info = {pet_skill, 289400, [14], [{101011,[100,3,1,8000]}], [], 3}
    };
get_skill(89405) ->
    #demon_skill{
        id = 89405
        ,name = <<"神级急速治愈">>
        ,type = 8
        ,step = 6
        ,craft = 5
        ,exp = 255
        ,next_id = 89406
        ,limit = []
        ,pet_info = {pet_skill, 289400, [15], [{101011,[100,3,1,8500]}], [], 3}
    };
get_skill(89406) ->
    #demon_skill{
        id = 89406
        ,name = <<"神级急速治愈">>
        ,type = 8
        ,step = 7
        ,craft = 5
        ,exp = 510
        ,next_id = 89407
        ,limit = []
        ,pet_info = {pet_skill, 289400, [16], [{101011,[100,3,1,9000]}], [], 3}
    };
get_skill(89407) ->
    #demon_skill{
        id = 89407
        ,name = <<"神级急速治愈">>
        ,type = 8
        ,step = 8
        ,craft = 5
        ,exp = 1024
        ,next_id = 89408
        ,limit = []
        ,pet_info = {pet_skill, 289400, [17], [{101011,[100,3,1,9500]}], [], 3}
    };
get_skill(89408) ->
    #demon_skill{
        id = 89408
        ,name = <<"神级急速治愈">>
        ,type = 8
        ,step = 9
        ,craft = 5
        ,exp = 2048
        ,next_id = 89409
        ,limit = []
        ,pet_info = {pet_skill, 289400, [18], [{101011,[100,3,1,10000]}], [], 3}
    };
get_skill(89409) ->
    #demon_skill{
        id = 89409
        ,name = <<"神级急速治愈">>
        ,type = 8
        ,step = 10
        ,craft = 5
        ,exp = 2500
        ,next_id = 0
        ,limit = []
        ,pet_info = {pet_skill, 289400, [19], [{101011,[100,3,1,10500]}], [], 3}
    };
get_skill(89410) ->
    #demon_skill{
        id = 89410
        ,name = <<"神级金系护宠">>
        ,type = 9
        ,step = 1
        ,craft = 5
        ,exp = 6
        ,next_id = 89411
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289410, [26], [{102170,[100,3,1,180]}], [], 3}
    };
get_skill(89411) ->
    #demon_skill{
        id = 89411
        ,name = <<"神级金系护宠">>
        ,type = 9
        ,step = 2
        ,craft = 5
        ,exp = 15
        ,next_id = 89412
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289410, [27], [{102170,[100,3,1,190]}], [], 3}
    };
get_skill(89412) ->
    #demon_skill{
        id = 89412
        ,name = <<"神级金系护宠">>
        ,type = 9
        ,step = 3
        ,craft = 5
        ,exp = 30
        ,next_id = 89413
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289410, [28], [{102170,[100,3,1,200]}], [], 3}
    };
get_skill(89413) ->
    #demon_skill{
        id = 89413
        ,name = <<"神级金系护宠">>
        ,type = 9
        ,step = 4
        ,craft = 5
        ,exp = 63
        ,next_id = 89414
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289410, [29], [{102170,[100,3,1,210]}], [], 3}
    };
get_skill(89414) ->
    #demon_skill{
        id = 89414
        ,name = <<"神级金系护宠">>
        ,type = 9
        ,step = 5
        ,craft = 5
        ,exp = 126
        ,next_id = 89415
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289410, [30], [{102170,[100,3,1,220]}], [], 3}
    };
get_skill(89415) ->
    #demon_skill{
        id = 89415
        ,name = <<"神级金系护宠">>
        ,type = 9
        ,step = 6
        ,craft = 5
        ,exp = 255
        ,next_id = 89416
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289410, [31], [{102170,[100,3,1,230]}], [], 3}
    };
get_skill(89416) ->
    #demon_skill{
        id = 89416
        ,name = <<"神级金系护宠">>
        ,type = 9
        ,step = 7
        ,craft = 5
        ,exp = 510
        ,next_id = 89417
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289410, [32], [{102170,[100,3,1,240]}], [], 3}
    };
get_skill(89417) ->
    #demon_skill{
        id = 89417
        ,name = <<"神级金系护宠">>
        ,type = 9
        ,step = 8
        ,craft = 5
        ,exp = 1024
        ,next_id = 89418
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289410, [33], [{102170,[100,3,1,250]}], [], 3}
    };
get_skill(89418) ->
    #demon_skill{
        id = 89418
        ,name = <<"神级金系护宠">>
        ,type = 9
        ,step = 9
        ,craft = 5
        ,exp = 2048
        ,next_id = 89419
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289410, [34], [{102170,[100,3,1,260]}], [], 3}
    };
get_skill(89419) ->
    #demon_skill{
        id = 89419
        ,name = <<"神级金系护宠">>
        ,type = 9
        ,step = 10
        ,craft = 5
        ,exp = 2500
        ,next_id = 0
        ,limit = [2,3,4,5]
        ,pet_info = {pet_skill, 289410, [35], [{102170,[100,3,1,270]}], [], 3}
    };
get_skill(89420) ->
    #demon_skill{
        id = 89420
        ,name = <<"神级木系护宠">>
        ,type = 10
        ,step = 1
        ,craft = 5
        ,exp = 6
        ,next_id = 89421
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289420, [26], [{102180,[100,3,1,180]}], [], 3}
    };
get_skill(89421) ->
    #demon_skill{
        id = 89421
        ,name = <<"神级木系护宠">>
        ,type = 10
        ,step = 2
        ,craft = 5
        ,exp = 15
        ,next_id = 89422
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289420, [27], [{102180,[100,3,1,190]}], [], 3}
    };
get_skill(89422) ->
    #demon_skill{
        id = 89422
        ,name = <<"神级木系护宠">>
        ,type = 10
        ,step = 3
        ,craft = 5
        ,exp = 30
        ,next_id = 89423
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289420, [28], [{102180,[100,3,1,200]}], [], 3}
    };
get_skill(89423) ->
    #demon_skill{
        id = 89423
        ,name = <<"神级木系护宠">>
        ,type = 10
        ,step = 4
        ,craft = 5
        ,exp = 63
        ,next_id = 89424
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289420, [29], [{102180,[100,3,1,210]}], [], 3}
    };
get_skill(89424) ->
    #demon_skill{
        id = 89424
        ,name = <<"神级木系护宠">>
        ,type = 10
        ,step = 5
        ,craft = 5
        ,exp = 126
        ,next_id = 89425
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289420, [30], [{102180,[100,3,1,220]}], [], 3}
    };
get_skill(89425) ->
    #demon_skill{
        id = 89425
        ,name = <<"神级木系护宠">>
        ,type = 10
        ,step = 6
        ,craft = 5
        ,exp = 255
        ,next_id = 89426
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289420, [31], [{102180,[100,3,1,230]}], [], 3}
    };
get_skill(89426) ->
    #demon_skill{
        id = 89426
        ,name = <<"神级木系护宠">>
        ,type = 10
        ,step = 7
        ,craft = 5
        ,exp = 510
        ,next_id = 89427
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289420, [32], [{102180,[100,3,1,240]}], [], 3}
    };
get_skill(89427) ->
    #demon_skill{
        id = 89427
        ,name = <<"神级木系护宠">>
        ,type = 10
        ,step = 8
        ,craft = 5
        ,exp = 1024
        ,next_id = 89428
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289420, [33], [{102180,[100,3,1,250]}], [], 3}
    };
get_skill(89428) ->
    #demon_skill{
        id = 89428
        ,name = <<"神级木系护宠">>
        ,type = 10
        ,step = 9
        ,craft = 5
        ,exp = 2048
        ,next_id = 89429
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289420, [34], [{102180,[100,3,1,260]}], [], 3}
    };
get_skill(89429) ->
    #demon_skill{
        id = 89429
        ,name = <<"神级木系护宠">>
        ,type = 10
        ,step = 10
        ,craft = 5
        ,exp = 2500
        ,next_id = 0
        ,limit = [1,3,4,5]
        ,pet_info = {pet_skill, 289420, [35], [{102180,[100,3,1,270]}], [], 3}
    };
get_skill(89430) ->
    #demon_skill{
        id = 89430
        ,name = <<"神级水系护宠">>
        ,type = 11
        ,step = 1
        ,craft = 5
        ,exp = 6
        ,next_id = 89431
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289430, [26], [{102200,[100,3,1,180]}], [], 3}
    };
get_skill(89431) ->
    #demon_skill{
        id = 89431
        ,name = <<"神级水系护宠">>
        ,type = 11
        ,step = 2
        ,craft = 5
        ,exp = 15
        ,next_id = 89432
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289430, [27], [{102200,[100,3,1,190]}], [], 3}
    };
get_skill(89432) ->
    #demon_skill{
        id = 89432
        ,name = <<"神级水系护宠">>
        ,type = 11
        ,step = 3
        ,craft = 5
        ,exp = 30
        ,next_id = 89433
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289430, [28], [{102200,[100,3,1,200]}], [], 3}
    };
get_skill(89433) ->
    #demon_skill{
        id = 89433
        ,name = <<"神级水系护宠">>
        ,type = 11
        ,step = 4
        ,craft = 5
        ,exp = 63
        ,next_id = 89434
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289430, [29], [{102200,[100,3,1,210]}], [], 3}
    };
get_skill(89434) ->
    #demon_skill{
        id = 89434
        ,name = <<"神级水系护宠">>
        ,type = 11
        ,step = 5
        ,craft = 5
        ,exp = 126
        ,next_id = 89435
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289430, [30], [{102200,[100,3,1,220]}], [], 3}
    };
get_skill(89435) ->
    #demon_skill{
        id = 89435
        ,name = <<"神级水系护宠">>
        ,type = 11
        ,step = 6
        ,craft = 5
        ,exp = 255
        ,next_id = 89436
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289430, [31], [{102200,[100,3,1,230]}], [], 3}
    };
get_skill(89436) ->
    #demon_skill{
        id = 89436
        ,name = <<"神级水系护宠">>
        ,type = 11
        ,step = 7
        ,craft = 5
        ,exp = 510
        ,next_id = 89437
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289430, [32], [{102200,[100,3,1,240]}], [], 3}
    };
get_skill(89437) ->
    #demon_skill{
        id = 89437
        ,name = <<"神级水系护宠">>
        ,type = 11
        ,step = 8
        ,craft = 5
        ,exp = 1024
        ,next_id = 89438
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289430, [33], [{102200,[100,3,1,250]}], [], 3}
    };
get_skill(89438) ->
    #demon_skill{
        id = 89438
        ,name = <<"神级水系护宠">>
        ,type = 11
        ,step = 9
        ,craft = 5
        ,exp = 2048
        ,next_id = 89439
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289430, [34], [{102200,[100,3,1,260]}], [], 3}
    };
get_skill(89439) ->
    #demon_skill{
        id = 89439
        ,name = <<"神级水系护宠">>
        ,type = 11
        ,step = 10
        ,craft = 5
        ,exp = 2500
        ,next_id = 0
        ,limit = [1,2,4,5]
        ,pet_info = {pet_skill, 289430, [35], [{102200,[100,3,1,270]}], [], 3}
    };
get_skill(89440) ->
    #demon_skill{
        id = 89440
        ,name = <<"神级火系护宠">>
        ,type = 12
        ,step = 1
        ,craft = 5
        ,exp = 6
        ,next_id = 89441
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289440, [26], [{102190,[100,3,1,180]}], [], 3}
    };
get_skill(89441) ->
    #demon_skill{
        id = 89441
        ,name = <<"神级火系护宠">>
        ,type = 12
        ,step = 2
        ,craft = 5
        ,exp = 15
        ,next_id = 89442
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289440, [27], [{102190,[100,3,1,190]}], [], 3}
    };
get_skill(89442) ->
    #demon_skill{
        id = 89442
        ,name = <<"神级火系护宠">>
        ,type = 12
        ,step = 3
        ,craft = 5
        ,exp = 30
        ,next_id = 89443
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289440, [28], [{102190,[100,3,1,200]}], [], 3}
    };
get_skill(89443) ->
    #demon_skill{
        id = 89443
        ,name = <<"神级火系护宠">>
        ,type = 12
        ,step = 4
        ,craft = 5
        ,exp = 63
        ,next_id = 89444
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289440, [29], [{102190,[100,3,1,210]}], [], 3}
    };
get_skill(89444) ->
    #demon_skill{
        id = 89444
        ,name = <<"神级火系护宠">>
        ,type = 12
        ,step = 5
        ,craft = 5
        ,exp = 126
        ,next_id = 89445
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289440, [30], [{102190,[100,3,1,220]}], [], 3}
    };
get_skill(89445) ->
    #demon_skill{
        id = 89445
        ,name = <<"神级火系护宠">>
        ,type = 12
        ,step = 6
        ,craft = 5
        ,exp = 255
        ,next_id = 89446
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289440, [31], [{102190,[100,3,1,230]}], [], 3}
    };
get_skill(89446) ->
    #demon_skill{
        id = 89446
        ,name = <<"神级火系护宠">>
        ,type = 12
        ,step = 7
        ,craft = 5
        ,exp = 510
        ,next_id = 89447
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289440, [32], [{102190,[100,3,1,240]}], [], 3}
    };
get_skill(89447) ->
    #demon_skill{
        id = 89447
        ,name = <<"神级火系护宠">>
        ,type = 12
        ,step = 8
        ,craft = 5
        ,exp = 1024
        ,next_id = 89448
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289440, [33], [{102190,[100,3,1,250]}], [], 3}
    };
get_skill(89448) ->
    #demon_skill{
        id = 89448
        ,name = <<"神级火系护宠">>
        ,type = 12
        ,step = 9
        ,craft = 5
        ,exp = 2048
        ,next_id = 89449
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289440, [34], [{102190,[100,3,1,260]}], [], 3}
    };
get_skill(89449) ->
    #demon_skill{
        id = 89449
        ,name = <<"神级火系护宠">>
        ,type = 12
        ,step = 10
        ,craft = 5
        ,exp = 2500
        ,next_id = 0
        ,limit = [1,2,3,5]
        ,pet_info = {pet_skill, 289440, [35], [{102190,[100,3,1,270]}], [], 3}
    };
get_skill(89450) ->
    #demon_skill{
        id = 89450
        ,name = <<"神级土系护宠">>
        ,type = 13
        ,step = 1
        ,craft = 5
        ,exp = 6
        ,next_id = 89451
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289450, [26], [{102210,[100,3,1,180]}], [], 3}
    };
get_skill(89451) ->
    #demon_skill{
        id = 89451
        ,name = <<"神级土系护宠">>
        ,type = 13
        ,step = 2
        ,craft = 5
        ,exp = 15
        ,next_id = 89452
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289450, [27], [{102210,[100,3,1,190]}], [], 3}
    };
get_skill(89452) ->
    #demon_skill{
        id = 89452
        ,name = <<"神级土系护宠">>
        ,type = 13
        ,step = 3
        ,craft = 5
        ,exp = 30
        ,next_id = 89453
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289450, [28], [{102210,[100,3,1,200]}], [], 3}
    };
get_skill(89453) ->
    #demon_skill{
        id = 89453
        ,name = <<"神级土系护宠">>
        ,type = 13
        ,step = 4
        ,craft = 5
        ,exp = 63
        ,next_id = 89454
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289450, [29], [{102210,[100,3,1,210]}], [], 3}
    };
get_skill(89454) ->
    #demon_skill{
        id = 89454
        ,name = <<"神级土系护宠">>
        ,type = 13
        ,step = 5
        ,craft = 5
        ,exp = 126
        ,next_id = 89455
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289450, [30], [{102210,[100,3,1,220]}], [], 3}
    };
get_skill(89455) ->
    #demon_skill{
        id = 89455
        ,name = <<"神级土系护宠">>
        ,type = 13
        ,step = 6
        ,craft = 5
        ,exp = 255
        ,next_id = 89456
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289450, [31], [{102210,[100,3,1,230]}], [], 3}
    };
get_skill(89456) ->
    #demon_skill{
        id = 89456
        ,name = <<"神级土系护宠">>
        ,type = 13
        ,step = 7
        ,craft = 5
        ,exp = 510
        ,next_id = 89457
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289450, [32], [{102210,[100,3,1,240]}], [], 3}
    };
get_skill(89457) ->
    #demon_skill{
        id = 89457
        ,name = <<"神级土系护宠">>
        ,type = 13
        ,step = 8
        ,craft = 5
        ,exp = 1024
        ,next_id = 89458
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289450, [33], [{102210,[100,3,1,250]}], [], 3}
    };
get_skill(89458) ->
    #demon_skill{
        id = 89458
        ,name = <<"神级土系护宠">>
        ,type = 13
        ,step = 9
        ,craft = 5
        ,exp = 2048
        ,next_id = 89459
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289450, [34], [{102210,[100,3,1,260]}], [], 3}
    };
get_skill(89459) ->
    #demon_skill{
        id = 89459
        ,name = <<"神级土系护宠">>
        ,type = 13
        ,step = 10
        ,craft = 5
        ,exp = 2500
        ,next_id = 0
        ,limit = [1,2,3,4]
        ,pet_info = {pet_skill, 289450, [35], [{102210,[100,3,1,270]}], [], 3}
    };
get_skill(89460) ->
    #demon_skill{
        id = 89460
        ,name = <<"神级轮回天生">>
        ,type = 14
        ,step = 1
        ,craft = 5
        ,exp = 6
        ,next_id = 89461
        ,limit = []
        ,pet_info = {pet_skill, 289460, [1,40,3], [], [], 99}
    };
get_skill(89461) ->
    #demon_skill{
        id = 89461
        ,name = <<"神级轮回天生">>
        ,type = 14
        ,step = 2
        ,craft = 5
        ,exp = 15
        ,next_id = 89462
        ,limit = []
        ,pet_info = {pet_skill, 289460, [1,45,4], [], [], 99}
    };
get_skill(89462) ->
    #demon_skill{
        id = 89462
        ,name = <<"神级轮回天生">>
        ,type = 14
        ,step = 3
        ,craft = 5
        ,exp = 30
        ,next_id = 89463
        ,limit = []
        ,pet_info = {pet_skill, 289460, [1,50,5], [], [], 99}
    };
get_skill(89463) ->
    #demon_skill{
        id = 89463
        ,name = <<"神级轮回天生">>
        ,type = 14
        ,step = 4
        ,craft = 5
        ,exp = 63
        ,next_id = 89464
        ,limit = []
        ,pet_info = {pet_skill, 289460, [1,55,6], [], [], 99}
    };
get_skill(89464) ->
    #demon_skill{
        id = 89464
        ,name = <<"神级轮回天生">>
        ,type = 14
        ,step = 5
        ,craft = 5
        ,exp = 126
        ,next_id = 89465
        ,limit = []
        ,pet_info = {pet_skill, 289460, [1,60,7], [], [], 99}
    };
get_skill(89465) ->
    #demon_skill{
        id = 89465
        ,name = <<"神级轮回天生">>
        ,type = 14
        ,step = 6
        ,craft = 5
        ,exp = 255
        ,next_id = 89466
        ,limit = []
        ,pet_info = {pet_skill, 289460, [1,65,8], [], [], 99}
    };
get_skill(89466) ->
    #demon_skill{
        id = 89466
        ,name = <<"神级轮回天生">>
        ,type = 14
        ,step = 7
        ,craft = 5
        ,exp = 510
        ,next_id = 89467
        ,limit = []
        ,pet_info = {pet_skill, 289460, [1,70,9], [], [], 99}
    };
get_skill(89467) ->
    #demon_skill{
        id = 89467
        ,name = <<"神级轮回天生">>
        ,type = 14
        ,step = 8
        ,craft = 5
        ,exp = 1024
        ,next_id = 89468
        ,limit = []
        ,pet_info = {pet_skill, 289460, [1,75,10], [], [], 99}
    };
get_skill(89468) ->
    #demon_skill{
        id = 89468
        ,name = <<"神级轮回天生">>
        ,type = 14
        ,step = 9
        ,craft = 5
        ,exp = 2048
        ,next_id = 89469
        ,limit = []
        ,pet_info = {pet_skill, 289460, [1,80,11], [], [], 99}
    };
get_skill(89469) ->
    #demon_skill{
        id = 89469
        ,name = <<"神级轮回天生">>
        ,type = 14
        ,step = 10
        ,craft = 5
        ,exp = 2500
        ,next_id = 0
        ,limit = []
        ,pet_info = {pet_skill, 289460, [1,90,12], [], [], 99}
    };
get_skill(_) -> false.

%% 根据技能品质和类型获取技能ID
get_skill_id(1, 1) -> 86000;
get_skill_id(2, 1) -> 86100;
get_skill_id(3, 1) -> 86200;
get_skill_id(4, 1) -> 86300;
get_skill_id(5, 1) -> 86400;
get_skill_id(6, 1) -> 86500;
get_skill_id(7, 1) -> 86600;
get_skill_id(8, 1) -> 89000;
get_skill_id(9, 1) -> 89010;
get_skill_id(10, 1) -> 89020;
get_skill_id(11, 1) -> 89030;
get_skill_id(12, 1) -> 89040;
get_skill_id(13, 1) -> 89050;
get_skill_id(14, 1) -> 89060;
get_skill_id(15, 1) -> 86900;
get_skill_id(16, 1) -> 86800;
get_skill_id(1, 2) -> 85000;
get_skill_id(2, 2) -> 85100;
get_skill_id(3, 2) -> 85200;
get_skill_id(4, 2) -> 85300;
get_skill_id(5, 2) -> 85400;
get_skill_id(6, 2) -> 85500;
get_skill_id(7, 2) -> 85600;
get_skill_id(8, 2) -> 89100;
get_skill_id(9, 2) -> 89110;
get_skill_id(10, 2) -> 89120;
get_skill_id(11, 2) -> 89130;
get_skill_id(12, 2) -> 89140;
get_skill_id(13, 2) -> 89150;
get_skill_id(14, 2) -> 89160;
get_skill_id(15, 2) -> 85900;
get_skill_id(16, 2) -> 85800;
get_skill_id(1, 3) -> 84000;
get_skill_id(2, 3) -> 84100;
get_skill_id(3, 3) -> 84200;
get_skill_id(4, 3) -> 84300;
get_skill_id(5, 3) -> 84400;
get_skill_id(6, 3) -> 84500;
get_skill_id(7, 3) -> 84600;
get_skill_id(8, 3) -> 89200;
get_skill_id(9, 3) -> 89210;
get_skill_id(10, 3) -> 89220;
get_skill_id(11, 3) -> 89230;
get_skill_id(12, 3) -> 89240;
get_skill_id(13, 3) -> 89250;
get_skill_id(14, 3) -> 89260;
get_skill_id(15, 3) -> 84900;
get_skill_id(16, 3) -> 84800;
get_skill_id(1, 4) -> 83000;
get_skill_id(2, 4) -> 83100;
get_skill_id(3, 4) -> 83200;
get_skill_id(4, 4) -> 83300;
get_skill_id(5, 4) -> 83400;
get_skill_id(6, 4) -> 83500;
get_skill_id(7, 4) -> 83600;
get_skill_id(8, 4) -> 89300;
get_skill_id(9, 4) -> 89310;
get_skill_id(10, 4) -> 89320;
get_skill_id(11, 4) -> 89330;
get_skill_id(12, 4) -> 89340;
get_skill_id(13, 4) -> 89350;
get_skill_id(14, 4) -> 89360;
get_skill_id(15, 4) -> 83900;
get_skill_id(16, 4) -> 83800;
get_skill_id(1, 5) -> 82000;
get_skill_id(2, 5) -> 82100;
get_skill_id(3, 5) -> 82200;
get_skill_id(4, 5) -> 82300;
get_skill_id(5, 5) -> 82400;
get_skill_id(6, 5) -> 82500;
get_skill_id(7, 5) -> 82600;
get_skill_id(8, 5) -> 89400;
get_skill_id(9, 5) -> 89410;
get_skill_id(10, 5) -> 89420;
get_skill_id(11, 5) -> 89430;
get_skill_id(12, 5) -> 89440;
get_skill_id(13, 5) -> 89450;
get_skill_id(14, 5) -> 89460;
get_skill_id(15, 5) -> 82900;
get_skill_id(16, 5) -> 82800;
get_skill_id(_Type, _Craft) -> 0.

%% 根据类型和幸运值，获取品质概率列表
get_skill_craft_polish_rand(1, LuckVal)
when LuckVal >= 0  andalso LuckVal =< 100  ->
    [{1,100},{2,0},{3,0},{4,0},{5,0}];
get_skill_craft_polish_rand(1, LuckVal)
when LuckVal >= 101  andalso LuckVal =< 200  ->
    [{1,98},{2,2},{3,0},{4,0},{5,0}];
get_skill_craft_polish_rand(1, LuckVal)
when LuckVal >= 201  andalso LuckVal =< 300  ->
    [{1,96},{2,4},{3,0},{4,0},{5,0}];
get_skill_craft_polish_rand(1, LuckVal)
when LuckVal >= 301  andalso LuckVal =< 400  ->
    [{1,91},{2,8},{3,1},{4,0},{5,0}];
get_skill_craft_polish_rand(1, LuckVal)
when LuckVal >= 401  andalso LuckVal =< 500  ->
    [{1,80},{2,16},{3,4},{4,0},{5,0}];
get_skill_craft_polish_rand(1, LuckVal)
when LuckVal >= 501  andalso LuckVal =< 600  ->
    [{1,60},{2,32},{3,8},{4,0},{5,0}];
get_skill_craft_polish_rand(1, LuckVal)
when LuckVal >= 601  andalso LuckVal =< 700  ->
    [{1,25},{2,60},{3,15},{4,0},{5,0}];
get_skill_craft_polish_rand(1, LuckVal)
when LuckVal >= 701  andalso LuckVal =< 800  ->
    [{1,20},{2,60},{3,20},{4,0},{5,0}];
get_skill_craft_polish_rand(1, LuckVal)
when LuckVal >= 801  andalso LuckVal =< 900  ->
    [{1,20},{2,55},{3,25},{4,0},{5,0}];
get_skill_craft_polish_rand(1, LuckVal)
when LuckVal >= 901  ->
    [{1,20},{2,50},{3,30},{4,0},{5,0}];
get_skill_craft_polish_rand(2, LuckVal)
when LuckVal >= 0  andalso LuckVal =< 100  ->
    [{1,98},{2,2},{3,0},{4,0},{5,0}];
get_skill_craft_polish_rand(2, LuckVal)
when LuckVal >= 101  andalso LuckVal =< 200  ->
    [{1,95},{2,4},{3,1},{4,0},{5,0}];
get_skill_craft_polish_rand(2, LuckVal)
when LuckVal >= 201  andalso LuckVal =< 300  ->
    [{1,88},{2,8},{3,4},{4,0},{5,0}];
get_skill_craft_polish_rand(2, LuckVal)
when LuckVal >= 301  andalso LuckVal =< 400  ->
    [{1,75},{2,16},{3,8},{4,1},{5,0}];
get_skill_craft_polish_rand(2, LuckVal)
when LuckVal >= 401  andalso LuckVal =< 500  ->
    [{1,48},{2,32},{3,16},{4,4},{5,0}];
get_skill_craft_polish_rand(2, LuckVal)
when LuckVal >= 501  andalso LuckVal =< 600  ->
    [{1,5},{2,55},{3,32},{4,8},{5,0}];
get_skill_craft_polish_rand(2, LuckVal)
when LuckVal >= 601  andalso LuckVal =< 700  ->
    [{1,0},{2,23},{3,60},{4,16},{5,1}];
get_skill_craft_polish_rand(2, LuckVal)
when LuckVal >= 701  andalso LuckVal =< 800  ->
    [{1,0},{2,8},{3,56},{4,32},{5,4}];
get_skill_craft_polish_rand(2, LuckVal)
when LuckVal >= 801  andalso LuckVal =< 900  ->
    [{1,0},{2,0},{3,52},{4,40},{5,8}];
get_skill_craft_polish_rand(2, LuckVal)
when LuckVal >= 901  ->
    [{1,0},{2,0},{3,48},{4,36},{5,16}];
get_skill_craft_polish_rand(_Type, _LuckVal) ->
    [].

%% 获取类型概率列表
%% [{Type, Rand} | ...]
get_skill_type_polish_rand() ->
    [
        {1, 8}
        ,{2, 8}
        ,{3, 8}
        ,{4, 8}
        ,{5, 8}
        ,{6, 8}
        ,{7, 3}
        ,{8, 5}
        ,{9, 7}
        ,{10, 7}
        ,{11, 7}
        ,{12, 7}
        ,{13, 7}
        ,{14, 3}
        ,{15, 3}
        ,{16, 3}
    ].
