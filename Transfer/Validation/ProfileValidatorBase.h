//
//  ProfileValidatorBase.h
//  Transfer
//
//  Created by Juhan Hion on 15.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransferwiseOperation.h"
#import "ObjectModel.h"
#import "Constants.h"

@interface ProfileValidatorBase : NSObject

@property (strong, nonatomic) TransferwiseOperation *executedOperation;
@property (strong, nonatomic) ObjectModel *objectModel;
@property (copy, nonatomic) TRWActionBlock successBlock;

@end
