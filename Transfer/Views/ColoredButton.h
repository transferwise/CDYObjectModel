//
//  ColoredButton.h
//  Transfer
//
//  Created by Juhan Hion on 18.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsetRespectingButton.h"

@interface ColoredButton : InsetRespectingButton

@property (nonatomic, assign) BOOL addShadow;
@property (nonatomic,assign) IBInspectable CGFloat progress;

- (void)commonSetup;

- (void)configureWithCompoundStyle:(NSString *)compoundStyle;
- (void)configureWithCompoundStyle:(NSString *)compoundStyle
					   shadowColor:(NSString *)shadowColor;

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated;
-(void)animateProgressFrom:(CGFloat)startValue to:(CGFloat)toValue delay:(NSTimeInterval)delay;
-(void)progressPushVCAnimationFrom:(CGFloat)startValue to:(CGFloat)toValue;

@end
