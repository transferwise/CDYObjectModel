//
//  RecipientTypeField.h
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipientTypeField : NSObject

@property (nonatomic, copy, readonly) NSString *title;

+ (RecipientTypeField *)fieldWithData:(NSDictionary *)data;

@end
