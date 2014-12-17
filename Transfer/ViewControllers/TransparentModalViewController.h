//
//  TransparentModalViewController.h
//  Transfer
//
//  Created by Mats Trovik on 12/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TransparentModalViewController;

typedef NS_ENUM(short, TransparentModalPresentationStyle)
{
    TransparentPresentationSlide = 0,
    TransparentPresentationFade
};

@protocol TransparentModalViewControllerDelegate <NSObject>

@optional

-(void)dismissCompleted:(TransparentModalViewController*) dismissedController;

@end

@interface TransparentModalViewController : UIViewController

@property (nonatomic, weak) id<TransparentModalViewControllerDelegate> delegate;
@property (nonatomic, assign) TransparentModalPresentationStyle presentationStyle;

-(void)presentOnViewController:(UIViewController*)hostViewcontroller withPresentationStyle:(TransparentModalPresentationStyle)presentationStyle;
-(void)presentOnViewController:(UIViewController*)hostViewcontroller;
-(IBAction)dismiss;
-(UIViewController*)hostViewController;

@end
