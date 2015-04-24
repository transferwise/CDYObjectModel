//
//  UITextField+CustomDelegate.m
//  Transfer
//
//  Created by Mats Trovik on 24/04/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "UITextField+CustomDelegate.h"

#import "NSString+Validation.h"
#import "NSString+Presentation.h"
#import "UITextField+CaretPosition.h"

@implementation UITextField (CustomDelegate)

+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string presentationPattern:(NSString*)pattern maxValueLength:(NSInteger)maxValueLength enforceAlphaNumeric:(BOOL)alphaNumeric
{
    NSString* originalText = textField.text?:@"";
    if(alphaNumeric)
    {
        string = [self stripAccentsFromString:string];
    }
    
    NSString *modified = [originalText stringByReplacingCharactersInRange:range withString:string];
    NSRange caretRange = NSMakeRange(range.location, [string length]);
    
    
    if([pattern hasValue])
    {
        if ([pattern hasValue] && [modified length] > [pattern length])
        {
            return NO;
        }
        
        if ([string length] == 0)
        {
            modified = [modified stringByRemovingPatterChar:pattern];
        }
        else
        {
            modified = [modified applyPattern:pattern];
            modified = [modified stringByAddingPatternChar:pattern];
        }
        
    }
    else
    {
        if (maxValueLength > 0 && [modified length] > maxValueLength)
        {
            return NO;
        }
    }
    
    
    textField.text = modified;
    if(![pattern hasValue] && caretRange.location + caretRange.length < [modified length])
    {
        [textField moveCaretToAfterRange:caretRange];
    }
    [textField sendActionsForControlEvents:UIControlEventEditingChanged];
    return NO;
    
}

+(NSString*)stripAccentsFromString:(NSString*)source
{
    NSString *modified = [source decomposedStringWithCanonicalMapping];
    modified = [[modified componentsSeparatedByCharactersInSet:self.englishCharacterExclusionSet] componentsJoinedByString:@""];
    return modified;
}

static NSCharacterSet* _englishCharacterExclusionSet;
+(NSCharacterSet *)englishCharacterExclusionSet
{
    if (!_englishCharacterExclusionSet)
    {
        _englishCharacterExclusionSet = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 ."] invertedSet];
    }
    
    return _englishCharacterExclusionSet;
}

@end
