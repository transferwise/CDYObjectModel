//
//  Mixpanel+Customisation.h
//  Transfer
//
//  Created by Mats Trovik on 15/10/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "Mixpanel.h"

@interface Mixpanel (Customisation)

- (void)sendPageView:(NSString *)page;
- (void)sendPageView:(NSString *)page withProperties:(NSDictionary*)properties;

@end
