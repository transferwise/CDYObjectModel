//
//  UpdateUserDeviceOperation.h
//  Transfer
//
//  Created by Juhan Hion on 14.04.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
#import "Constants.h"

@interface UpdateUserDeviceOperation : TransferwiseOperation

@property (nonatomic, strong) NSString *existingToken;
@property (nonatomic, strong) NSString *updatedToken;
@property (nonatomic, copy) TRWErrorBlock completionHandler;

+ (UpdateUserDeviceOperation *)updateDeviceOperation;

@end
