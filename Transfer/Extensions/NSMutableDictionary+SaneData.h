//
//  NSMutableDictionary+SaneData.h
//  Transfer
//
//  Created by Jaanus Siim on 7/24/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SaneData)

- (void)setNotNilValue:(id)value forKey:(NSString *)key;

@end
