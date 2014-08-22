//
//  ReferralListOperation.h
//  Transfer
//
//  Created by Juhan Hion on 22.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^ReferralListBlock)(NSError *error, NSInteger successCount);

@interface ReferralListOperation : TransferwiseOperation

@property (nonatomic, strong) ReferralListBlock resultHandler;

+ (ReferralListOperation *)operation;

@end
