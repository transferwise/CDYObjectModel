#import "User.h"
#import "PlainProfileDetails.h"
#import "PersonalProfile.h"
#import "BusinessProfile.h"

@interface User ()

@end


@implementation User

- (PlainProfileDetails *)plainUserDetails {
    PlainProfileDetails *plain = [[PlainProfileDetails alloc] init];
    [plain setEmail:self.email];
    [plain setReference:self.pReference];
    [plain setPersonalProfile:[self.personalProfile plainProfile]];
    [plain setBusinessProfile:[self.businessProfile plainProfile]];
    return plain;
}

- (NSString *)displayName {
    return self.personalProfile ? [self.personalProfile fullName] : self.email;
}

@end
