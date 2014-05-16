//
//  NSError+TRWErrors.h
//  Transfer
//
//  Created by Jaanus Siim on 4/26/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (TRWErrors)

- (BOOL)isTransferwiseError;
- (NSString *)localizedTransferwiseMessage;
- (BOOL)twCodeNotFound;

@end
