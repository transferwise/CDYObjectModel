//
//  BusinessProfileCommitter.h
//  Transfer
//
//  Created by Jaanus Siim on 6/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusinessProfileValidation.h"

@class ObjectModel;

@interface BusinessProfileCommitter : NSObject <BusinessProfileValidation>

@property (nonatomic, strong) ObjectModel *objectModel;

@end
