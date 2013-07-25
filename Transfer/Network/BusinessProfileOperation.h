//
//  UpdateBusinessProfileOperation.h
//  Transfer
//
//  Created by Henri Mägi on 01.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
#import "UserDetailsOperation.h"

@interface BusinessProfileOperation : TransferwiseOperation

@property (nonatomic, copy) TWProfileDetailsHandler saveResultHandler;

+ (BusinessProfileOperation *)commitWithData:(NSManagedObjectID *)data;
+ (BusinessProfileOperation *)validateWithData:(NSManagedObjectID *)data;

@end
