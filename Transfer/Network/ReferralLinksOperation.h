//
//  ReferralLinksOperation.h
//  Transfer
//
//  Created by Juhan Hion on 11.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^ReferralLinksBlock)(NSError *error, NSArray *links);

@interface ReferralLinksOperation : TransferwiseOperation

@property (nonatomic, strong) ReferralLinksBlock resultHandler;

+ (ReferralLinksOperation *)operation;

@end
