//
//  PersonalProfile.h
//  Transfer
//
//  Created by Jaanus Siim on 4/24/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalProfile : NSObject

- (NSString *)fullName;

+ (PersonalProfile *)profileWithData:(NSDictionary *)data;

@end
