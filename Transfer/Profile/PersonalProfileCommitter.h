//
//  PersonalProfileCommitter.h
//  Transfer
//
//  Created by Jaanus Siim on 5/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonalProfileValidation.h"

@class ObjectModel;

@interface PersonalProfileCommitter : NSObject <PersonalProfileValidation>

@property (nonatomic, strong) ObjectModel *objectModel;

@end
