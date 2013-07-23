//
//  PlainRecipientType.h
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlainRecipientType : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSArray *fields;

@end
