//
//  CompanyAttributesOperation.h
//  Transfer
//
//  Created by Juhan Hion on 05.05.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
#import "Constants.h"

@interface CompanyAttributesOperation : TransferwiseOperation

@property (nonatomic, copy) TRWErrorBlock resultHandler;

+ (CompanyAttributesOperation *)operation;

@end
