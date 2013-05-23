//
//  StringValue.m
//  Transfer
//
//  Created by Jaanus Siim on 5/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "StringValue.h"

@interface StringValue ()

@property (nonatomic, copy) NSString *value;

@end

@implementation StringValue

- (id)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        _value = string;
    }
    return self;
}

- (NSString *)name {
    return self.value;
}

@end
