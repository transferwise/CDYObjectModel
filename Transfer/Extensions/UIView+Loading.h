//
//  UIView+Loading.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Loading)

+ (UINib *)viewNib;
+ (id)loadInstance;
+ (UIView *)loadViewFromXib:(NSString *)xibName;

@end
