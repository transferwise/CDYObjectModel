#import "User.h"
#import "PersonalProfile.h"
#import "BusinessProfile.h"
#import "Payment.h"
#import "NSString+DeducedId.h"

@interface User ()

@end


@implementation User

- (NSString *)displayName {
    return self.personalProfile ? [self.personalProfile fullName] : self.email;
}

- (PersonalProfile *)personalProfileObject {
    if (!self.personalProfile) {
        [self setPersonalProfile:[PersonalProfile insertInManagedObjectContext:self.managedObjectContext]];
    }

    return self.personalProfile;
}

- (BusinessProfile *)businessProfileObject {
    if (!self.businessProfile) {
        [self setBusinessProfile:[BusinessProfile insertInManagedObjectContext:self.managedObjectContext]];
    }

    return self.businessProfile;
}

- (BOOL)personalProfileFilled {
    return [self.personalProfile isFilled];
}

- (BOOL)businessProfileFilled {
    return [self.businessProfile isFilled];
}

-(BOOL)sendAsBusinessDefaultSettingValue
{
    NSNumber *result = [self sendAsBusinessDefaultSetting];
    if(result)
    {
        return [result boolValue];
    }
    else
    {
        NSArray *sortedPayments = [self.payments sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"remoteId" ascending:NO]]];
        if([sortedPayments count]>0)
        {
            Payment* latestPayment = sortedPayments[0];
            BOOL sendAsBusiness = [@"business" caseInsensitiveCompare:latestPayment.profileUsed]== NSOrderedSame;
            self.sendAsBusinessDefaultSettingValue = sendAsBusiness;
            return sendAsBusiness;
        }
    }
    return NO;
}

- (NSInteger)deducedId
{
    return [self.pReference deducedId];
}

@end
