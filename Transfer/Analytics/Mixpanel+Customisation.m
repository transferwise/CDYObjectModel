//
//  Mixpanel+Customisation.m
//  Transfer
//
//  Created by Mats Trovik on 15/10/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "Mixpanel+Customisation.h"

@implementation Mixpanel (Customisation)


- (void)sendPageView:(NSString *)page {
    [self track:[NSString stringWithFormat:@"Page View - %@", page]];
}

- (void)sendPageView:(NSString *)page withProperties:(NSDictionary*)properties
{
    [self track:[NSString stringWithFormat:@"Page View - %@", page] properties:properties];
}
@end
