//
//  PlainRecipientTypeField.h
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlainRecipientTypeField : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSMutableArray *possibleValues;

@end
