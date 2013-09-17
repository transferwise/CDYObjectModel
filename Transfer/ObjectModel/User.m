#import "User.h"
#import "PersonalProfile.h"
#import "BusinessProfile.h"

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

@end
