//
//  UserDetailsOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransferwiseOperation.h"

@class PlainProfileDetails;

typedef void (^TWProfileDetailsHandler)(NSError *error);

@interface UserDetailsOperation : TransferwiseOperation

@property (nonatomic, copy) TWProfileDetailsHandler completionHandler;

+ (UserDetailsOperation *)detailsOperation;

@end
