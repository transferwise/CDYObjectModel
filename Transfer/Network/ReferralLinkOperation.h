//
//  ReferralLinkOperation.h
//  Transfer
//
//  Created by Juhan Hion on 21.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^ReferralLinkBlock)(NSError *error, NSString *link);

@interface ReferralLinkOperation : TransferwiseOperation

@property (nonatomic, strong) ReferralLinkBlock resultHandler;

+ (ReferralLinkOperation *)operation;

@end
