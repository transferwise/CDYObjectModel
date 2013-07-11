//
//  PlainStringValue.m
//  Transfer
//
//  Created by Jaanus Siim on 5/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PlainStringValue.h"

@interface PlainStringValue ()

@property (nonatomic, copy) NSString *value;

@end

@implementation PlainStringValue

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
