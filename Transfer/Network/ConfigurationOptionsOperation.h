//
//  ConfigurationOptionsOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 10/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
#import "JCSObjectModel.h"

@interface ConfigurationOptionsOperation : TransferwiseOperation

@property (nonatomic, copy) JCSActionBlock completion;

@end