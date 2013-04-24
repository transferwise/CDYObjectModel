//
//  TransferwiseClient.h
//  Transfer
//
//  Created by Jaanus Siim on 4/22/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "AFHTTPClient.h"
#import "UserDetailsOperation.h"

@class ObjectModel;

@interface TransferwiseClient : AFHTTPClient

@property (nonatomic, strong) ObjectModel *objectModel;

+ (TransferwiseClient *)sharedClient;
- (void)updateUserDetailsWithCompletionHandler:(TWProfileDetailsHandler)completion;

@end
