

-define(MONTH_CARD_GOLD, 300).  %% ��ֵ�¿�������
-define(MONTH_DAY, 30).		    %% �¿�ʧЧ����
-define(MONTH_DAY_GOLD, 120).   %% ÿ�쾫����
-define(MONTH_DAY_1_GOLD, 300). %% ��һ�쾫����

-record(month_card, {
	charge_time	 = 0	    %% ��ֵʱ��unix_time		charge_time = 0ʱ��û�г�ֵ
    ,charge_0_time = 0      %% ��ֵ�����㳿ʱ���
	,last_gold_day = 0	    %% �ϴ���ȡ������  1~30
}).
