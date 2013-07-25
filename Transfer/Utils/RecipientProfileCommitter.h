//
//  RecipientProfileCommitter.h
//  Transfer
//
//  Created by Jaanus Siim on 6/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipientProfileValidation.h"

@class ObjectModel;

@interface RecipientProfileCommitter : NSObject <RecipientProfileValidation>

@property (nonatomic, strong) ObjectModel *objectModel;

@end
