//
//  ColoredButton.h
//  Transfer
//
//  Created by Juhan Hion on 18.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColoredButton : UIButton

@property (nonatomic, assign) BOOL addShadow;

- (void)commonSetup;

- (void)configureWithCompoundStyle:(NSString *)compoundStyle;
- (void)configureWithCompoundStyle:(NSString *)compoundStyle
					   shadowColor:(NSString *)shadowColor;

@end
