//
//  PlainProfileDetails.h
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PlainBusinessProfile;

@interface PlainProfileDetails : NSObject

@property (nonatomic, copy) NSString *email;
@property (nonatomic, strong) PlainBusinessProfile *businessProfile;
@property (nonatomic, copy) NSString *reference;

@end
