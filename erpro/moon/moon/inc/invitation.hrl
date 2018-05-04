
-define(invitee_award_baseid, 5325170).  %% 被邀请者奖励
-define(inviter_1_award_baseid, 532518). %% 邀请一人奖励
-define(inviter_2_award_baseid, 532519). %% ...
-define(inviter_3_award_baseid, 532520).
-define(inviter_4_award_baseid, 532521).
-define(inviter_5_award_baseid, 532522).


-define(inviter_gen_code_lev, 20).  %% 产生邀请码的等级

-define(inviter_awards, [{532518, 1}, {532519, 2}, {532520, 3}, {532521, 4}, {532522, 5}]).

-record(invitation, {
   code = <<>>
}).
