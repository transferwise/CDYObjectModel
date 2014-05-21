//
//  NSString+MOMColorStyle.h
//  StyleTest
//
//  Created by Mats Trovik on 14/02/2014.
//  Copyright (c) 2014 Matsomatic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MOMStyle)

-(void)mapHexToRedNumber:(NSNumber* __strong*)red greenNumber:(NSNumber* __strong*)green blueNumber:(NSNumber* __strong*)blue alphaNumber:(NSNumber* __strong*)alpha;

@end
