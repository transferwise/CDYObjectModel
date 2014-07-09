//
//  FloatingLabelTextField.h
//  Transfer
//
//  Created by Juhan Hion on 09.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "JVFloatLabeledTextField.h"

@interface FloatingLabelTextField : JVFloatLabeledTextField

- (void)configureWithTitle:(NSString *)title value:(NSString *)value;
- (BOOL)hasValue;

@end
