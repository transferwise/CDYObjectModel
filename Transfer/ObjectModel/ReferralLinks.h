#import "_ReferralLinks.h"

NS_ENUM(NSInteger, ReferralChannel)
{
	ReferralChannelLink = 0,
	ReferralChannelEmail,
	ReferralChannelFb,
	ReferralChannelSms
};

@interface ReferralLinks : _ReferralLinks {}

@end
