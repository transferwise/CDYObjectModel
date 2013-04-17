//
//  ObjectModel+Credentials.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"

@interface ObjectModel (Credentials)

- (BOOL)userLoggedIn;
- (void)setUserToken:(NSString *)token;
- (NSString *)accessToken;

@end
