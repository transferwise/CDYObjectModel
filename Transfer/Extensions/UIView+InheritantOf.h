//
//  UIView+InheritantOf.h
//  Transfer
//
//  Created by Juhan Hion on 12.09.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (InheritantOf)

- (BOOL)isInheritantOfClass:(Class)class
				orClassName:(NSString *)className;

@end
