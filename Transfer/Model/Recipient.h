//
//  Recipient.h
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recipient : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *IBAN;
@property (nonatomic, copy, readonly) NSString *BIC;
@property (nonatomic, strong, readonly) NSNumber *recipientId;
@property (nonatomic, copy, readonly) NSString *type;

- (NSString *)detailsRowOne;
- (NSString *)detailsRowTwo;

+ (Recipient *)recipientWithData:(NSDictionary *)data;

@end
