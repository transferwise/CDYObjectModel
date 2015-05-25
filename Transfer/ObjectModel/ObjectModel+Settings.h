//
//  ObjectModel+Settings.h
//  Transfer
//
//  Created by Jaanus Siim on 10/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"

@interface ObjectModel (Settings)

- (BOOL)shouldShowRatingPopup;
- (void)markReviewPopupShown;
- (BOOL)shouldShowDirectUserSignup;
- (void)markDirectSignupEnabled:(BOOL)enabled;
- (BOOL)hasIntroBeenShown;
- (void)markIntroShown;
- (BOOL)hasExistingUserIntroBeenShown;
- (void)markExistingUserIntroShown;

@end
