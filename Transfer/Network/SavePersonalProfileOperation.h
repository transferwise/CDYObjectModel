//
//  SavePersonalProfileOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/7/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
#import "UserDetailsOperation.h"

@class PersonalProfile;

@interface SavePersonalProfileOperation : TransferwiseOperation

@property (nonatomic, copy) TWProfileDetailsHandler saveResultHandler;

+ (SavePersonalProfileOperation *)operationWithProfile:(PersonalProfile *)profile;

@end
