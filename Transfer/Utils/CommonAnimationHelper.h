//
//  BottomButtonAnimator.h
//  Transfer
//
//  Created by Mats Trovik on 22/10/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonAnimationHelper : NSObject

/**
 *  set this constraint if using with autolayout
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionButtonBottomConstraint;

/**
 *  Set this property if using springs and struts
 */
@property (weak, nonatomic) IBOutlet UIButton *button;

-(void)viewWillAppear:(BOOL)animated;


@end
