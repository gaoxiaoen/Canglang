%%----------------------------------------------------
%% 品质套装属性数据
%% @author shawnoyc@163.com
%%----------------------------------------------------

-module(suitcraft_data).
-export([
        get_attr/3
    ]
).

-include("item.hrl").
get_attr(_Id, _Craft, Num) when Num < 2 -> [];
get_attr(160, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,360}];
get_attr(160, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,360}, {24,9}];
get_attr(160, 1, Num) when Num =:= 6 ->
    [{15,360}, {24,9}, {18,45},{17,1}];
get_attr(170, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,420}];
get_attr(170, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,420}, {24,10}];
get_attr(170, 1, Num) when Num =:= 6 ->
    [{15,420}, {24,10}, {18,52},{17,1}];
get_attr(170, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,700}];
get_attr(170, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,700}, {24,17}];
get_attr(170, 2, Num) when Num =:= 6 ->
    [{15,700}, {24,17}, {18,87},{17,2}];
get_attr(180, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,480}];
get_attr(180, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,480}, {24,12}];
get_attr(180, 1, Num) when Num =:= 6 ->
    [{15,480}, {24,12}, {18,60},{17,1}];
get_attr(180, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,800}];
get_attr(180, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,800}, {24,20}];
get_attr(180, 2, Num) when Num =:= 6 ->
    [{15,800}, {24,20}, {18,100},{17,2}];
get_attr(180, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1120}];
get_attr(180, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1120}, {24,28}];
get_attr(180, 3, Num) when Num =:= 6 ->
    [{15,1120}, {24,28}, {18,140},{17,3}];
get_attr(190, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,540}];
get_attr(190, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,540}, {24,13}];
get_attr(190, 1, Num) when Num =:= 6 ->
    [{15,540}, {24,13}, {18,67},{17,4}];
get_attr(190, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,900}];
get_attr(190, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,900}, {24,22}];
get_attr(190, 2, Num) when Num =:= 6 ->
    [{15,900}, {24,22}, {18,112},{17,4}];
get_attr(190, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1260}];
get_attr(190, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1260}, {24,31}];
get_attr(190, 3, Num) when Num =:= 6 ->
    [{15,1260}, {24,31}, {18,157},{17,4}];
get_attr(190, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1620}];
get_attr(190, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1620}, {24,40}];
get_attr(190, 4, Num) when Num =:= 6 ->
    [{15,1620}, {24,40}, {18,202},{17,5}];
get_attr(1100, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,600}];
get_attr(1100, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,600}, {24,15}];
get_attr(1100, 1, Num) when Num =:= 6 ->
    [{15,600}, {24,15}, {18,75},{17,5}];
get_attr(1100, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1000}];
get_attr(1100, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1000}, {24,25}];
get_attr(1100, 2, Num) when Num =:= 6 ->
    [{15,1000}, {24,25}, {18,125},{17,5}];
get_attr(1100, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1400}];
get_attr(1100, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1400}, {24,35}];
get_attr(1100, 3, Num) when Num =:= 6 ->
    [{15,1400}, {24,35}, {18,175},{17,5}];
get_attr(1100, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1800}];
get_attr(1100, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1800}, {24,45}];
get_attr(1100, 4, Num) when Num =:= 6 ->
    [{15,1800}, {24,45}, {18,225},{17,5}];
get_attr(1100, 5, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2200}];
get_attr(1100, 5, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2200}, {24,55}];
get_attr(1100, 5, Num) when Num =:= 6 ->
    [{15,2200}, {24,55}, {18,275},{17,6}];
get_attr(260, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,315}];
get_attr(260, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,315}, {24,9}];
get_attr(260, 1, Num) when Num =:= 6 ->
    [{15,315}, {24,9}, {18,40},{17,1}];
get_attr(270, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,367}];
get_attr(270, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,367}, {24,10}];
get_attr(270, 1, Num) when Num =:= 6 ->
    [{15,367}, {24,10}, {18,46},{17,1}];
get_attr(270, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,612}];
get_attr(270, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,612}, {24,17}];
get_attr(270, 2, Num) when Num =:= 6 ->
    [{15,612}, {24,17}, {18,77},{17,2}];
get_attr(280, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,420}];
get_attr(280, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,420}, {24,12}];
get_attr(280, 1, Num) when Num =:= 6 ->
    [{15,420}, {24,12}, {18,54},{17,1}];
get_attr(280, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,700}];
get_attr(280, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,700}, {24,20}];
get_attr(280, 2, Num) when Num =:= 6 ->
    [{15,700}, {24,20}, {18,90},{17,2}];
get_attr(280, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,980}];
get_attr(280, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,980}, {24,28}];
get_attr(280, 3, Num) when Num =:= 6 ->
    [{15,980}, {24,28}, {18,126},{17,3}];
get_attr(290, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,472}];
get_attr(290, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,472}, {24,13}];
get_attr(290, 1, Num) when Num =:= 6 ->
    [{15,472}, {24,13}, {18,60},{17,4}];
get_attr(290, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,787}];
get_attr(290, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,787}, {24,22}];
get_attr(290, 2, Num) when Num =:= 6 ->
    [{15,787}, {24,22}, {18,100},{17,4}];
get_attr(290, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1102}];
get_attr(290, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1102}, {24,31}];
get_attr(290, 3, Num) when Num =:= 6 ->
    [{15,1102}, {24,31}, {18,140},{17,4}];
get_attr(290, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1417}];
get_attr(290, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1417}, {24,40}];
get_attr(290, 4, Num) when Num =:= 6 ->
    [{15,1417}, {24,40}, {18,180},{17,5}];
get_attr(2100, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,555}];
get_attr(2100, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,555}, {24,15}];
get_attr(2100, 1, Num) when Num =:= 6 ->
    [{15,555}, {24,15}, {18,66},{17,5}];
get_attr(2100, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,925}];
get_attr(2100, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,925}, {24,25}];
get_attr(2100, 2, Num) when Num =:= 6 ->
    [{15,925}, {24,25}, {18,110},{17,5}];
get_attr(2100, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1295}];
get_attr(2100, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1295}, {24,35}];
get_attr(2100, 3, Num) when Num =:= 6 ->
    [{15,1295}, {24,35}, {18,154},{17,5}];
get_attr(2100, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1665}];
get_attr(2100, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1665}, {24,45}];
get_attr(2100, 4, Num) when Num =:= 6 ->
    [{15,1665}, {24,45}, {18,198},{17,5}];
get_attr(2100, 5, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2035}];
get_attr(2100, 5, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2035}, {24,55}];
get_attr(2100, 5, Num) when Num =:= 6 ->
    [{15,2035}, {24,55}, {18,242},{17,6}];
get_attr(360, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,270}];
get_attr(360, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,270}, {14,40}];
get_attr(360, 1, Num) when Num =:= 6 ->
    [{15,270}, {14,40}, {18,36},{17,1}];
get_attr(370, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,315}];
get_attr(370, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,315}, {14,60}];
get_attr(370, 1, Num) when Num =:= 6 ->
    [{15,315}, {14,60}, {18,39},{17,1}];
get_attr(370, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,525}];
get_attr(370, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,525}, {14,80}];
get_attr(370, 2, Num) when Num =:= 6 ->
    [{15,525}, {14,80}, {18,65},{17,2}];
get_attr(380, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,360}];
get_attr(380, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,360}, {14,50}];
get_attr(380, 1, Num) when Num =:= 6 ->
    [{15,360}, {14,50}, {18,48},{17,1}];
get_attr(380, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,600}];
get_attr(380, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,600}, {14,75}];
get_attr(380, 2, Num) when Num =:= 6 ->
    [{15,600}, {14,75}, {18,80},{17,2}];
get_attr(380, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,840}];
get_attr(380, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,840}, {14,100}];
get_attr(380, 3, Num) when Num =:= 6 ->
    [{15,840}, {14,100}, {18,112},{17,3}];
get_attr(390, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,420}];
get_attr(390, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,420}, {14,54}];
get_attr(390, 1, Num) when Num =:= 6 ->
    [{15,420}, {14,54}, {18,54},{17,4}];
get_attr(390, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,700}];
get_attr(390, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,700}, {14,90}];
get_attr(390, 2, Num) when Num =:= 6 ->
    [{15,700}, {14,90}, {18,90},{17,4}];
get_attr(390, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,980}];
get_attr(390, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,980}, {14,126}];
get_attr(390, 3, Num) when Num =:= 6 ->
    [{15,980}, {14,126}, {18,126},{17,4}];
get_attr(390, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1260}];
get_attr(390, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1260}, {14,162}];
get_attr(390, 4, Num) when Num =:= 6 ->
    [{15,1260}, {14,162}, {18,162},{17,5}];
get_attr(3100, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,480}];
get_attr(3100, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,480}, {14,60}];
get_attr(3100, 1, Num) when Num =:= 6 ->
    [{15,480}, {14,60}, {18,60},{17,5}];
get_attr(3100, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,800}];
get_attr(3100, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,800}, {14,100}];
get_attr(3100, 2, Num) when Num =:= 6 ->
    [{15,800}, {14,100}, {18,100},{17,5}];
get_attr(3100, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1120}];
get_attr(3100, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1120}, {14,140}];
get_attr(3100, 3, Num) when Num =:= 6 ->
    [{15,1120}, {14,140}, {18,140},{17,5}];
get_attr(3100, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1440}];
get_attr(3100, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1440}, {14,180}];
get_attr(3100, 4, Num) when Num =:= 6 ->
    [{15,1440}, {14,180}, {18,180},{17,5}];
get_attr(3100, 5, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1760}];
get_attr(3100, 5, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1760}, {14,220}];
get_attr(3100, 5, Num) when Num =:= 6 ->
    [{15,1760}, {14,220}, {18,220},{17,6}];
get_attr(460, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,270}];
get_attr(460, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,270}, {22,9}];
get_attr(460, 1, Num) when Num =:= 6 ->
    [{15,270}, {22,9}, {18,43},{17,1}];
get_attr(470, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,315}];
get_attr(470, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,315}, {22,10}];
get_attr(470, 1, Num) when Num =:= 6 ->
    [{15,315}, {22,10}, {18,49},{17,1}];
get_attr(470, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,525}];
get_attr(470, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,525}, {22,17}];
get_attr(470, 2, Num) when Num =:= 6 ->
    [{15,525}, {22,17}, {18,82},{17,2}];
get_attr(480, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,360}];
get_attr(480, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,360}, {22,12}];
get_attr(480, 1, Num) when Num =:= 6 ->
    [{15,360}, {22,12}, {18,57},{17,1}];
get_attr(480, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,600}];
get_attr(480, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,600}, {22,20}];
get_attr(480, 2, Num) when Num =:= 6 ->
    [{15,600}, {22,20}, {18,95},{17,2}];
get_attr(480, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,840}];
get_attr(480, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,840}, {22,28}];
get_attr(480, 3, Num) when Num =:= 6 ->
    [{15,840}, {22,28}, {18,133},{17,3}];
get_attr(490, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,420}];
get_attr(490, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,420}, {22,13}];
get_attr(490, 1, Num) when Num =:= 6 ->
    [{15,420}, {22,13}, {18,64},{17,4}];
get_attr(490, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,700}];
get_attr(490, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,700}, {22,22}];
get_attr(490, 2, Num) when Num =:= 6 ->
    [{15,700}, {22,22}, {18,107},{17,4}];
get_attr(490, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,980}];
get_attr(490, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,980}, {22,31}];
get_attr(490, 3, Num) when Num =:= 6 ->
    [{15,980}, {22,31}, {18,150},{17,4}];
get_attr(490, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1260}];
get_attr(490, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1260}, {22,40}];
get_attr(490, 4, Num) when Num =:= 6 ->
    [{15,1260}, {22,40}, {18,193},{17,5}];
get_attr(4100, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,480}];
get_attr(4100, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,480}, {22,15}];
get_attr(4100, 1, Num) when Num =:= 6 ->
    [{15,480}, {22,15}, {18,72},{17,5}];
get_attr(4100, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,800}];
get_attr(4100, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,800}, {22,25}];
get_attr(4100, 2, Num) when Num =:= 6 ->
    [{15,800}, {22,25}, {18,120},{17,5}];
get_attr(4100, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1120}];
get_attr(4100, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1120}, {22,35}];
get_attr(4100, 3, Num) when Num =:= 6 ->
    [{15,1120}, {22,35}, {18,168},{17,5}];
get_attr(4100, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1440}];
get_attr(4100, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1440}, {22,45}];
get_attr(4100, 4, Num) when Num =:= 6 ->
    [{15,1440}, {22,45}, {18,216},{17,5}];
get_attr(4100, 5, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1760}];
get_attr(4100, 5, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1760}, {22,55}];
get_attr(4100, 5, Num) when Num =:= 6 ->
    [{15,1760}, {22,55}, {18,264},{17,6}];
get_attr(560, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,432}];
get_attr(560, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,432}, {21,186},{30,172}];
get_attr(560, 1, Num) when Num =:= 6 ->
    [{15,432}, {21,186},{30,172}, {18,40},{17,1}];
get_attr(570, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,504}];
get_attr(570, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,504}, {21,228},{30,211}];
get_attr(570, 1, Num) when Num =:= 6 ->
    [{15,504}, {21,228},{30,211}, {18,46},{17,1}];
get_attr(570, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,840}];
get_attr(570, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,840}, {21,380},{30,352}];
get_attr(570, 2, Num) when Num =:= 6 ->
    [{15,840}, {21,380},{30,352}, {18,77},{17,2}];
get_attr(580, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,576}];
get_attr(580, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,576}, {21,267},{30,249}];
get_attr(580, 1, Num) when Num =:= 6 ->
    [{15,576}, {21,267},{30,249}, {18,54},{17,1}];
get_attr(580, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,960}];
get_attr(580, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,960}, {21,445},{30,416}];
get_attr(580, 2, Num) when Num =:= 6 ->
    [{15,960}, {21,445},{30,416}, {18,90},{17,2}];
get_attr(580, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1344}];
get_attr(580, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1344}, {21,623},{30,582}];
get_attr(580, 3, Num) when Num =:= 6 ->
    [{15,1344}, {21,623},{30,582}, {18,126},{17,3}];
get_attr(590, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,648}];
get_attr(590, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,648}, {21,315},{30,285}];
get_attr(590, 1, Num) when Num =:= 6 ->
    [{15,648}, {21,315},{30,285}, {18,60},{17,4}];
get_attr(590, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1080}];
get_attr(590, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1080}, {21,525},{30,475}];
get_attr(590, 2, Num) when Num =:= 6 ->
    [{15,1080}, {21,525},{30,475}, {18,100},{17,4}];
get_attr(590, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1512}];
get_attr(590, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1512}, {21,735},{30,665}];
get_attr(590, 3, Num) when Num =:= 6 ->
    [{15,1512}, {21,735},{30,665}, {18,140},{17,4}];
get_attr(590, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1944}];
get_attr(590, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1944}, {21,945},{30,855}];
get_attr(590, 4, Num) when Num =:= 6 ->
    [{15,1944}, {21,945},{30,855}, {18,180},{17,5}];
get_attr(5100, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,720}];
get_attr(5100, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,720}, {21,330},{30,300}];
get_attr(5100, 1, Num) when Num =:= 6 ->
    [{15,720}, {21,330},{30,300}, {18,66},{17,5}];
get_attr(5100, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1200}];
get_attr(5100, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1200}, {21,550},{30,500}];
get_attr(5100, 2, Num) when Num =:= 6 ->
    [{15,1200}, {21,550},{30,500}, {18,110},{17,5}];
get_attr(5100, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1680}];
get_attr(5100, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1680}, {21,770},{30,700}];
get_attr(5100, 3, Num) when Num =:= 6 ->
    [{15,1680}, {21,770},{30,700}, {18,154},{17,5}];
get_attr(5100, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2160}];
get_attr(5100, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2160}, {21,990},{30,900}];
get_attr(5100, 4, Num) when Num =:= 6 ->
    [{15,2160}, {21,990},{30,900}, {18,198},{17,5}];
get_attr(5100, 5, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2640}];
get_attr(5100, 5, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2640}, {21,1210},{30,1100}];
get_attr(5100, 5, Num) when Num =:= 6 ->
    [{15,2640}, {21,1210},{30,1100}, {18,242},{17,6}];
get_attr(660, 1, Num) when Num =:= 2 ->
    [{15,210}];
get_attr(660, 1, Num) when Num =:= 3 ->
    [{15,210}, {24,9}];
get_attr(660, 1, Num) when Num =:= 4 ->
    [{15,210}, {24,9}, {18,36},{25,7}];
get_attr(670, 1, Num) when Num =:= 2 ->
    [{15,255}];
get_attr(670, 1, Num) when Num =:= 3 ->
    [{15,255}, {24,10}];
get_attr(670, 1, Num) when Num =:= 4 ->
    [{15,255}, {24,10}, {18,45},{25,9}];
get_attr(670, 2, Num) when Num =:= 2 ->
    [{15,425}];
get_attr(670, 2, Num) when Num =:= 3 ->
    [{15,425}, {24,17}];
get_attr(670, 2, Num) when Num =:= 4 ->
    [{15,425}, {24,17}, {18,75},{25,15}];
get_attr(680, 1, Num) when Num =:= 2 ->
    [{15,300}];
get_attr(680, 1, Num) when Num =:= 3 ->
    [{15,300}, {24,12}];
get_attr(680, 1, Num) when Num =:= 4 ->
    [{15,300}, {24,12}, {18,54},{25,10}];
get_attr(680, 2, Num) when Num =:= 2 ->
    [{15,500}];
get_attr(680, 2, Num) when Num =:= 3 ->
    [{15,500}, {24,20}];
get_attr(680, 2, Num) when Num =:= 4 ->
    [{15,500}, {24,20}, {18,90},{25,17}];
get_attr(680, 3, Num) when Num =:= 2 ->
    [{15,700}];
get_attr(680, 3, Num) when Num =:= 3 ->
    [{15,700}, {24,28}];
get_attr(680, 3, Num) when Num =:= 4 ->
    [{15,700}, {24,28}, {18,126},{25,24}];
get_attr(690, 1, Num) when Num =:= 2 ->
    [{15,345}];
get_attr(690, 1, Num) when Num =:= 3 ->
    [{15,345}, {24,13}];
get_attr(690, 1, Num) when Num =:= 4 ->
    [{15,345}, {24,13}, {18,63},{25,12}];
get_attr(690, 2, Num) when Num =:= 2 ->
    [{15,575}];
get_attr(690, 2, Num) when Num =:= 3 ->
    [{15,575}, {24,22}];
get_attr(690, 2, Num) when Num =:= 4 ->
    [{15,575}, {24,22}, {18,105},{25,20}];
get_attr(690, 3, Num) when Num =:= 2 ->
    [{15,805}];
get_attr(690, 3, Num) when Num =:= 3 ->
    [{15,805}, {24,31}];
get_attr(690, 3, Num) when Num =:= 4 ->
    [{15,805}, {24,31}, {18,147},{25,28}];
get_attr(690, 4, Num) when Num =:= 2 ->
    [{15,1035}];
get_attr(690, 4, Num) when Num =:= 3 ->
    [{15,1035}, {24,40}];
get_attr(690, 4, Num) when Num =:= 4 ->
    [{15,1035}, {24,40}, {18,189},{25,36}];
get_attr(6100, 1, Num) when Num =:= 2 ->
    [{15,390}];
get_attr(6100, 1, Num) when Num =:= 3 ->
    [{15,390}, {24,15}];
get_attr(6100, 1, Num) when Num =:= 4 ->
    [{15,390}, {24,15}, {18,72},{25,13}];
get_attr(6100, 2, Num) when Num =:= 2 ->
    [{15,650}];
get_attr(6100, 2, Num) when Num =:= 3 ->
    [{15,650}, {24,25}];
get_attr(6100, 2, Num) when Num =:= 4 ->
    [{15,650}, {24,25}, {18,120},{25,22}];
get_attr(6100, 3, Num) when Num =:= 2 ->
    [{15,910}];
get_attr(6100, 3, Num) when Num =:= 3 ->
    [{15,910}, {24,35}];
get_attr(6100, 3, Num) when Num =:= 4 ->
    [{15,910}, {24,35}, {18,168},{25,31}];
get_attr(6100, 4, Num) when Num =:= 2 ->
    [{15,1170}];
get_attr(6100, 4, Num) when Num =:= 3 ->
    [{15,1170}, {24,45}];
get_attr(6100, 4, Num) when Num =:= 4 ->
    [{15,1170}, {24,45}, {18,216},{25,40}];
get_attr(6100, 5, Num) when Num =:= 2 ->
    [{15,1430}];
get_attr(6100, 5, Num) when Num =:= 3 ->
    [{15,1430}, {24,55}];
get_attr(6100, 5, Num) when Num =:= 4 ->
    [{15,1430}, {24,55}, {18,264},{25,49}];
get_attr(182, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,960}];
get_attr(182, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,960}, {24,18}];
get_attr(182, 1, Num) when Num =:= 6 ->
    [{15,960}, {24,18}, {18,120},{25,0}];
get_attr(182, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1600}];
get_attr(182, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1600}, {24,30}];
get_attr(182, 2, Num) when Num =:= 6 ->
    [{15,1600}, {24,30}, {18,200},{25,1}];
get_attr(182, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2240}];
get_attr(182, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2240}, {24,42}];
get_attr(182, 3, Num) when Num =:= 6 ->
    [{15,2240}, {24,42}, {18,280},{25,2}];
get_attr(192, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1080}];
get_attr(192, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1080}, {24,20}];
get_attr(192, 1, Num) when Num =:= 6 ->
    [{15,1080}, {24,20}, {18,135},{25,1}];
get_attr(192, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1800}];
get_attr(192, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1800}, {24,34}];
get_attr(192, 2, Num) when Num =:= 6 ->
    [{15,1800}, {24,34}, {18,225},{25,2}];
get_attr(192, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2520}];
get_attr(192, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2520}, {24,47}];
get_attr(192, 3, Num) when Num =:= 6 ->
    [{15,2520}, {24,47}, {18,315},{25,3}];
get_attr(192, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,3240}];
get_attr(192, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,3240}, {24,61}];
get_attr(192, 4, Num) when Num =:= 6 ->
    [{15,3240}, {24,61}, {18,405},{25,4}];
get_attr(1102, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1200}];
get_attr(1102, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1200}, {24,22}];
get_attr(1102, 1, Num) when Num =:= 6 ->
    [{15,1200}, {24,22}, {18,150},{25,1}];
get_attr(1102, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2000}];
get_attr(1102, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2000}, {24,37}];
get_attr(1102, 2, Num) when Num =:= 6 ->
    [{15,2000}, {24,37}, {18,250},{25,3}];
get_attr(1102, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2800}];
get_attr(1102, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2800}, {24,52}];
get_attr(1102, 3, Num) when Num =:= 6 ->
    [{15,2800}, {24,52}, {18,350},{25,4}];
get_attr(1102, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,3600}];
get_attr(1102, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,3600}, {24,67}];
get_attr(1102, 4, Num) when Num =:= 6 ->
    [{15,3600}, {24,67}, {18,450},{25,5}];
get_attr(1102, 5, Num) when Num >= 2 andalso Num < 4 ->
    [{15,4400}];
get_attr(1102, 5, Num) when Num >= 4 andalso Num < 6 ->
    [{15,4400}, {24,82}];
get_attr(1102, 5, Num) when Num =:= 6 ->
    [{15,4400}, {24,82}, {18,550},{25,7}];
get_attr(282, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,840}];
get_attr(282, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,840}, {24,18}];
get_attr(282, 1, Num) when Num =:= 6 ->
    [{15,840}, {24,18}, {18,108},{25,0}];
get_attr(282, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1400}];
get_attr(282, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1400}, {24,30}];
get_attr(282, 2, Num) when Num =:= 6 ->
    [{15,1400}, {24,30}, {18,180},{25,1}];
get_attr(282, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1960}];
get_attr(282, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1960}, {24,42}];
get_attr(282, 3, Num) when Num =:= 6 ->
    [{15,1960}, {24,42}, {18,252},{25,2}];
get_attr(292, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,945}];
get_attr(292, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,945}, {24,20}];
get_attr(292, 1, Num) when Num =:= 6 ->
    [{15,945}, {24,20}, {18,120},{25,1}];
get_attr(292, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1575}];
get_attr(292, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1575}, {24,34}];
get_attr(292, 2, Num) when Num =:= 6 ->
    [{15,1575}, {24,34}, {18,200},{25,2}];
get_attr(292, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2205}];
get_attr(292, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2205}, {24,47}];
get_attr(292, 3, Num) when Num =:= 6 ->
    [{15,2205}, {24,47}, {18,280},{25,3}];
get_attr(292, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2835}];
get_attr(292, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2835}, {24,61}];
get_attr(292, 4, Num) when Num =:= 6 ->
    [{15,2835}, {24,61}, {18,360},{25,4}];
get_attr(2102, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1110}];
get_attr(2102, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1110}, {24,22}];
get_attr(2102, 1, Num) when Num =:= 6 ->
    [{15,1110}, {24,22}, {18,132},{25,1}];
get_attr(2102, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1850}];
get_attr(2102, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1850}, {24,37}];
get_attr(2102, 2, Num) when Num =:= 6 ->
    [{15,1850}, {24,37}, {18,220},{25,3}];
get_attr(2102, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2590}];
get_attr(2102, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2590}, {24,52}];
get_attr(2102, 3, Num) when Num =:= 6 ->
    [{15,2590}, {24,52}, {18,308},{25,4}];
get_attr(2102, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,3330}];
get_attr(2102, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,3330}, {24,67}];
get_attr(2102, 4, Num) when Num =:= 6 ->
    [{15,3330}, {24,67}, {18,396},{25,5}];
get_attr(2102, 5, Num) when Num >= 2 andalso Num < 4 ->
    [{15,4070}];
get_attr(2102, 5, Num) when Num >= 4 andalso Num < 6 ->
    [{15,4070}, {24,82}];
get_attr(2102, 5, Num) when Num =:= 6 ->
    [{15,4070}, {24,82}, {18,484},{25,7}];
get_attr(382, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,720}];
get_attr(382, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,720}, {24,96}];
get_attr(382, 1, Num) when Num =:= 6 ->
    [{15,720}, {24,96}, {18,96},{25,0}];
get_attr(382, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1200}];
get_attr(382, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1200}, {24,160}];
get_attr(382, 2, Num) when Num =:= 6 ->
    [{15,1200}, {24,160}, {18,160},{25,1}];
get_attr(382, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1680}];
get_attr(382, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1680}, {24,224}];
get_attr(382, 3, Num) when Num =:= 6 ->
    [{15,1680}, {24,224}, {18,224},{25,2}];
get_attr(392, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,840}];
get_attr(392, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,840}, {24,108}];
get_attr(392, 1, Num) when Num =:= 6 ->
    [{15,840}, {24,108}, {18,108},{25,1}];
get_attr(392, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1400}];
get_attr(392, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1400}, {24,180}];
get_attr(392, 2, Num) when Num =:= 6 ->
    [{15,1400}, {24,180}, {18,180},{25,2}];
get_attr(392, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1960}];
get_attr(392, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1960}, {24,252}];
get_attr(392, 3, Num) when Num =:= 6 ->
    [{15,1960}, {24,252}, {18,252},{25,3}];
get_attr(392, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2520}];
get_attr(392, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2520}, {24,324}];
get_attr(392, 4, Num) when Num =:= 6 ->
    [{15,2520}, {24,324}, {18,324},{25,4}];
get_attr(3102, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,960}];
get_attr(3102, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,960}, {24,120}];
get_attr(3102, 1, Num) when Num =:= 6 ->
    [{15,960}, {24,120}, {18,120},{25,1}];
get_attr(3102, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1600}];
get_attr(3102, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1600}, {24,200}];
get_attr(3102, 2, Num) when Num =:= 6 ->
    [{15,1600}, {24,200}, {18,200},{25,3}];
get_attr(3102, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2240}];
get_attr(3102, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2240}, {24,280}];
get_attr(3102, 3, Num) when Num =:= 6 ->
    [{15,2240}, {24,280}, {18,280},{25,4}];
get_attr(3102, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2880}];
get_attr(3102, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2880}, {24,360}];
get_attr(3102, 4, Num) when Num =:= 6 ->
    [{15,2880}, {24,360}, {18,360},{25,5}];
get_attr(3102, 5, Num) when Num >= 2 andalso Num < 4 ->
    [{15,3520}];
get_attr(3102, 5, Num) when Num >= 4 andalso Num < 6 ->
    [{15,3520}, {24,440}];
get_attr(3102, 5, Num) when Num =:= 6 ->
    [{15,3520}, {24,440}, {18,440},{25,7}];
get_attr(482, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,720}];
get_attr(482, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,720}, {24,18}];
get_attr(482, 1, Num) when Num =:= 6 ->
    [{15,720}, {24,18}, {18,114},{25,0}];
get_attr(482, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1200}];
get_attr(482, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1200}, {24,30}];
get_attr(482, 2, Num) when Num =:= 6 ->
    [{15,1200}, {24,30}, {18,190},{25,1}];
get_attr(482, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1680}];
get_attr(482, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1680}, {24,42}];
get_attr(482, 3, Num) when Num =:= 6 ->
    [{15,1680}, {24,42}, {18,266},{25,2}];
get_attr(492, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,840}];
get_attr(492, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,840}, {24,20}];
get_attr(492, 1, Num) when Num =:= 6 ->
    [{15,840}, {24,20}, {18,129},{25,1}];
get_attr(492, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1400}];
get_attr(492, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1400}, {24,34}];
get_attr(492, 2, Num) when Num =:= 6 ->
    [{15,1400}, {24,34}, {18,215},{25,2}];
get_attr(492, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1960}];
get_attr(492, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1960}, {24,47}];
get_attr(492, 3, Num) when Num =:= 6 ->
    [{15,1960}, {24,47}, {18,301},{25,3}];
get_attr(492, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2520}];
get_attr(492, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2520}, {24,61}];
get_attr(492, 4, Num) when Num =:= 6 ->
    [{15,2520}, {24,61}, {18,387},{25,4}];
get_attr(4102, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,960}];
get_attr(4102, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,960}, {24,22}];
get_attr(4102, 1, Num) when Num =:= 6 ->
    [{15,960}, {24,22}, {18,144},{25,1}];
get_attr(4102, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1600}];
get_attr(4102, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1600}, {24,37}];
get_attr(4102, 2, Num) when Num =:= 6 ->
    [{15,1600}, {24,37}, {18,240},{25,3}];
get_attr(4102, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2240}];
get_attr(4102, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2240}, {24,52}];
get_attr(4102, 3, Num) when Num =:= 6 ->
    [{15,2240}, {24,52}, {18,336},{25,4}];
get_attr(4102, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2880}];
get_attr(4102, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2880}, {24,67}];
get_attr(4102, 4, Num) when Num =:= 6 ->
    [{15,2880}, {24,67}, {18,432},{25,5}];
get_attr(4102, 5, Num) when Num >= 2 andalso Num < 4 ->
    [{15,3520}];
get_attr(4102, 5, Num) when Num >= 4 andalso Num < 6 ->
    [{15,3520}, {24,82}];
get_attr(4102, 5, Num) when Num =:= 6 ->
    [{15,3520}, {24,82}, {18,528},{25,7}];
get_attr(582, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1152}];
get_attr(582, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1152}, {24,400}];
get_attr(582, 1, Num) when Num =:= 6 ->
    [{15,1152}, {24,400}, {18,499},{25,108}];
get_attr(582, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1920}];
get_attr(582, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1920}, {24,667}];
get_attr(582, 2, Num) when Num =:= 6 ->
    [{15,1920}, {24,667}, {18,832},{25,180}];
get_attr(582, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2688}];
get_attr(582, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2688}, {24,934}];
get_attr(582, 3, Num) when Num =:= 6 ->
    [{15,2688}, {24,934}, {18,1164},{25,252}];
get_attr(592, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1296}];
get_attr(592, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1296}, {24,472}];
get_attr(592, 1, Num) when Num =:= 6 ->
    [{15,1296}, {24,472}, {18,570},{25,120}];
get_attr(592, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2160}];
get_attr(592, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2160}, {24,787}];
get_attr(592, 2, Num) when Num =:= 6 ->
    [{15,2160}, {24,787}, {18,950},{25,200}];
get_attr(592, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,3024}];
get_attr(592, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,3024}, {24,1102}];
get_attr(592, 3, Num) when Num =:= 6 ->
    [{15,3024}, {24,1102}, {18,1330},{25,280}];
get_attr(592, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,3888}];
get_attr(592, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,3888}, {24,1417}];
get_attr(592, 4, Num) when Num =:= 6 ->
    [{15,3888}, {24,1417}, {18,1710},{25,360}];
get_attr(5102, 1, Num) when Num >= 2 andalso Num < 4 ->
    [{15,1440}];
get_attr(5102, 1, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1440}, {24,495}];
get_attr(5102, 1, Num) when Num =:= 6 ->
    [{15,1440}, {24,495}, {18,600},{25,132}];
get_attr(5102, 2, Num) when Num >= 2 andalso Num < 4 ->
    [{15,2400}];
get_attr(5102, 2, Num) when Num >= 4 andalso Num < 6 ->
    [{15,2400}, {24,825}];
get_attr(5102, 2, Num) when Num =:= 6 ->
    [{15,2400}, {24,825}, {18,1000},{25,220}];
get_attr(5102, 3, Num) when Num >= 2 andalso Num < 4 ->
    [{15,3360}];
get_attr(5102, 3, Num) when Num >= 4 andalso Num < 6 ->
    [{15,3360}, {24,1155}];
get_attr(5102, 3, Num) when Num =:= 6 ->
    [{15,3360}, {24,1155}, {18,1400},{25,308}];
get_attr(5102, 4, Num) when Num >= 2 andalso Num < 4 ->
    [{15,4320}];
get_attr(5102, 4, Num) when Num >= 4 andalso Num < 6 ->
    [{15,4320}, {24,1485}];
get_attr(5102, 4, Num) when Num =:= 6 ->
    [{15,4320}, {24,1485}, {18,1800},{25,396}];
get_attr(5102, 5, Num) when Num >= 2 andalso Num < 4 ->
    [{15,5280}];
get_attr(5102, 5, Num) when Num >= 4 andalso Num < 6 ->
    [{15,5280}, {24,1815}];
get_attr(5102, 5, Num) when Num =:= 6 ->
    [{15,5280}, {24,1815}, {18,2200},{25,484}];
get_attr(682, 1, Num) when Num =:= 2 ->
    [{15,600}];
get_attr(682, 1, Num) when Num =:= 3 ->
    [{15,600}, {24,18}];
get_attr(682, 1, Num) when Num =:= 4 ->
    [{15,600}, {24,18}, {18,108},{25,21}];
get_attr(682, 2, Num) when Num =:= 2 ->
    [{15,1000}];
get_attr(682, 2, Num) when Num =:= 3 ->
    [{15,1000}, {24,30}];
get_attr(682, 2, Num) when Num =:= 4 ->
    [{15,1000}, {24,30}, {18,180},{25,35}];
get_attr(682, 3, Num) when Num =:= 2 ->
    [{15,1400}];
get_attr(682, 3, Num) when Num =:= 3 ->
    [{15,1400}, {24,42}];
get_attr(682, 3, Num) when Num =:= 4 ->
    [{15,1400}, {24,42}, {18,252},{25,49}];
get_attr(692, 1, Num) when Num =:= 2 ->
    [{15,690}];
get_attr(692, 1, Num) when Num =:= 3 ->
    [{15,690}, {24,20}];
get_attr(692, 1, Num) when Num =:= 4 ->
    [{15,690}, {24,20}, {18,126},{25,24}];
get_attr(692, 2, Num) when Num =:= 2 ->
    [{15,1150}];
get_attr(692, 2, Num) when Num =:= 3 ->
    [{15,1150}, {24,34}];
get_attr(692, 2, Num) when Num =:= 4 ->
    [{15,1150}, {24,34}, {18,210},{25,40}];
get_attr(692, 3, Num) when Num =:= 2 ->
    [{15,1610}];
get_attr(692, 3, Num) when Num =:= 3 ->
    [{15,1610}, {24,47}];
get_attr(692, 3, Num) when Num =:= 4 ->
    [{15,1610}, {24,47}, {18,294},{25,56}];
get_attr(692, 4, Num) when Num =:= 2 ->
    [{15,2070}];
get_attr(692, 4, Num) when Num =:= 3 ->
    [{15,2070}, {24,61}];
get_attr(692, 4, Num) when Num =:= 4 ->
    [{15,2070}, {24,61}, {18,378},{25,72}];
get_attr(6102, 1, Num) when Num =:= 2 ->
    [{15,780}];
get_attr(6102, 1, Num) when Num =:= 3 ->
    [{15,780}, {24,22}];
get_attr(6102, 1, Num) when Num =:= 4 ->
    [{15,780}, {24,22}, {18,144},{25,27}];
get_attr(6102, 2, Num) when Num =:= 2 ->
    [{15,1300}];
get_attr(6102, 2, Num) when Num =:= 3 ->
    [{15,1300}, {24,37}];
get_attr(6102, 2, Num) when Num =:= 4 ->
    [{15,1300}, {24,37}, {18,240},{25,45}];
get_attr(6102, 3, Num) when Num =:= 2 ->
    [{15,1820}];
get_attr(6102, 3, Num) when Num =:= 3 ->
    [{15,1820}, {24,52}];
get_attr(6102, 3, Num) when Num =:= 4 ->
    [{15,1820}, {24,52}, {18,336},{25,63}];
get_attr(6102, 4, Num) when Num =:= 2 ->
    [{15,2340}];
get_attr(6102, 4, Num) when Num =:= 3 ->
    [{15,2340}, {24,67}];
get_attr(6102, 4, Num) when Num =:= 4 ->
    [{15,2340}, {24,67}, {18,432},{25,81}];
get_attr(6102, 5, Num) when Num =:= 2 ->
    [{15,2860}];
get_attr(6102, 5, Num) when Num =:= 3 ->
    [{15,2860}, {24,82}];
get_attr(6102, 5, Num) when Num =:= 4 ->
    [{15,2860}, {24,82}, {18,528},{25,99}];
get_attr(_Id, _Craft, _Num) -> [].
