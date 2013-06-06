//
//  EmailCheckOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^EmailCheckBlock)(BOOL available, NSError *error);

@interface EmailCheckOperation : TransferwiseOperation

@property (nonatomic, copy) EmailCheckBlock resultHandler;

- (id)initWithEmail:(NSString *)email;

+ (EmailCheckOperation *)operationWithEmail:(NSString *)email;

@end
