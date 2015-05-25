//
//  UITextField+CustomDelegate.h
//  Transfer
//
//  Created by Mats Trovik on 24/04/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (CustomDelegate)

+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string presentationPattern:(NSString*)pattern maxValueLength:(NSInteger)maxValueLength enforceAlphaNumeric:(BOOL)alphaNumeric;
+ (NSString*)stripAccentsFromString:(NSString*)source;
+ (NSCharacterSet *)englishCharacterExclusionSet;

@end
