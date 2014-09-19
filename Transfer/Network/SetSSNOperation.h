//
//  setSSNOperation.h
//  Transfer
//
//  Created by Mats Trovik on 15/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

@interface SetSSNOperation : TransferwiseOperation

+(instancetype)operationWithSsn:(NSString*)ssn resultHandler:(void(^)(NSError* error))resultHandler;

@end
