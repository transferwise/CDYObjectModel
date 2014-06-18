//
//  ColoredButton.h
//  Transfer
//
//  Created by Juhan Hion on 18.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColoredButton : UIButton

- (void)commonSetup;
- (void)configureWithTitleColor:(NSString *)titleColor
					 titleFont:(NSString *)titleFont
						 color:(NSString *)color
				highlightColor:(NSString *)highlightColor;

@end