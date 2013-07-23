//
//  PlainProfileDetails.m
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PlainProfileDetails.h"
#import "PlainPersonalProfile.h"
#import "PlainPersonalProfileInput.h"

@interface PlainProfileDetails ()

@end

@implementation PlainProfileDetails

- (PlainPersonalProfileInput *)profileInput {
    PlainPersonalProfileInput *input = [self.personalProfile input];

    if (!input) {
        input = [[PlainPersonalProfileInput alloc] init];
    }

    [input setEmail:self.email];
    return input;
}

@end
