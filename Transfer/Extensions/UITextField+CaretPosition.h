//
//  UITextField+CaretPosition.h
//  Transfer
//
//  Created by Mats Trovik on 27/11/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (CaretPosition)

-(void)moveCaretToAfterRange:(NSRange)range;

@end
