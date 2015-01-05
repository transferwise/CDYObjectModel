//
//  NSObject+NSNull.h
//  Transfer
//
//  Created by Juhan Hion on 19.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSNull)

/**
 * Returns either the object or reference to [NSNull null] if the object is nil.
 **/
+ (id)getObjectOrNsNull:(id)object;

/**
 * Returns either the object or nil if the object is reference to [NSNull null].
 **/
+ (id)getObjectOrNil:(id)object;

@end
