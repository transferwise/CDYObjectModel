//
//  UITextField+CaretPosition.m
//  Transfer
//
//  Created by Mats Trovik on 27/11/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "UITextField+CaretPosition.h"

@implementation UITextField (CaretPosition)

-(void)moveCaretToAfterRange:(NSRange)range
{
    UITextPosition *newPosition = [self positionFromPosition:self.beginningOfDocument offset:range.location + range.length];
    self.selectedTextRange = [self textRangeFromPosition:newPosition toPosition:newPosition];
}

@end
