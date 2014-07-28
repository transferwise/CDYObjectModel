//
//  UITextField+ModifiedText.h
//  Transfer
//
//  Created by Juhan Hion on 28.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ModifiedText)

- (NSString *)modifiedText:(NSRange)range newText:(NSString *)text;

@end
