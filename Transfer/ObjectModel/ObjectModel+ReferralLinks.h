//
//  ObjectModel+ReferralLinks.h
//  Transfer
//
//  Created by Juhan Hion on 11.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"

@interface ObjectModel (ReferralLinks)

- (NSArray *)referralLinks;
- (void)createOrUpdateReferralLinks:(NSDictionary *)referralLinks;

@end
