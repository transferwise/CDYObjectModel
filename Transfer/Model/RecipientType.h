//
//  RecipientType.h
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipientType : NSObject

@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, strong, readonly) NSArray *fields;

+ (RecipientType *)typeWithData:(NSDictionary *)data;

@end
