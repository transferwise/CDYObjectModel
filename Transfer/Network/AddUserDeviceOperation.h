//
//  AddUserDeviceOperation.h
//  Transfer
//
//  Created by Juhan Hion on 14.04.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
#import "Constants.h"

@interface AddUserDeviceOperation : TransferwiseOperation

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) TRWErrorBlock completionHandler;

+ (AddUserDeviceOperation *)addDeviceOperation;

@end
