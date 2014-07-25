//
//  StyledPlaceholderTextField.h
//  Transfer
//
//  Created by Juhan Hion on 25.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOMBasicStyle.h"

@interface StyledPlaceholderTextField : UITextField

@property (nonatomic,strong) MOMBasicStyle* placeholderStyle;

- (void)configureWithTitle:(NSString *)title value:(NSString *)value;

@end
