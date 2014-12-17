#import "_ReferralLink.h"

NS_ENUM(NSInteger, ReferralChannel)
{
	ReferralChannelLink = 0,
	ReferralChannelEmail,
	ReferralChannelFb,
	ReferralChannelSms
};

@interface ReferralLink : _ReferralLink {}
// Custom logic goes here.
@end
