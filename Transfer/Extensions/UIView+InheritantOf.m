//
//  UIView+InheritantOf.m
//  Transfer
//
//  Created by Juhan Hion on 12.09.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "UIView+InheritantOf.h"

@implementation UIView (InheritantOf)

- (BOOL)isInheritantOfClass:(Class)class
				orClassName:(NSString *)className
{
	return [[self class] doForEachView:self
								action:^BOOL(UIView *view) {
									return [view isKindOfClass:class]
										|| [[view superclass] isKindOfClass:class]
										|| (className && [NSStringFromClass([view class]) isEqualToString:className])
										|| (className && [NSStringFromClass([view superclass]) isEqualToString:className]);
								}];
}

+ (BOOL)doForEachView:(UIView *)view
			   action:(BOOL (^)(UIView* view))action

{
	return action(view)
		|| (view.superview && [self doForEachView:view.superview
										   action:action]);
}


@end
