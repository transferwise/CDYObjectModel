//
//  ObjectModel.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"
#import "Constants.h"

@interface ObjectModel ()

@end

@implementation ObjectModel

- (id)init {
    self = [super initWithDataModelName:@"Transfer" storeType:NSInMemoryStoreType];
    if (self) {
        [self setWipeDatabaseOnSchemaConflict:YES];
    }

    return self;
}

@end
