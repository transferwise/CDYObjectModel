//
//  ImageColoredButton.h
//  Transfer
//
//  Created by Juhan Hion on 14.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ColoredButton.h"

@interface ImageColoredButton : ColoredButton

- (void)configureWithCompoundStyle:(NSString *)compoundStyle
					   shadowColor:(NSString *)shadowColor
						 imageName:(NSString *)imageName;

@end
