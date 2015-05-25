//
//  UserDetailsOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransferwiseOperation.h"
#import "Constants.h"

typedef void (^TWProfileDetailsHandler)(NSError *error);

@interface UserDetailsOperation : TransferwiseOperation

@property (nonatomic, copy) TRWErrorBlock completionHandler;

+ (UserDetailsOperation *)detailsOperation;

@end
