//
//  UpdateBusinessProfileOperation.h
//  Transfer
//
//  Created by Henri Mägi on 01.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
#import "Constants.h"

@class ProfileDetails;

typedef void (^TWUpdateBusinessDetailsHandler)(ProfileDetails *result, NSError *error);

@interface UpdateBusinessProfileOperation : TransferwiseOperation

@property (nonatomic, copy) TWUpdateBusinessDetailsHandler completionHandler;

+ (UpdateBusinessProfileOperation *)updateWithWithDictionary:(NSDictionary *)dict completionHandler:(TWUpdateBusinessDetailsHandler)handler;

@end
