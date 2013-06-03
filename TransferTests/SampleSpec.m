//
//  SampleSpec.m
//  Transfer
//
//  Created by Jaanus Siim on 6/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(MathSpec)

describe(@"Math", ^{
    it(@"is pretty cool", ^{
        NSUInteger a = 16;
        NSUInteger b = 26;
        [[theValue(a + b) should] equal:theValue(42)];
    });
});

SPEC_END