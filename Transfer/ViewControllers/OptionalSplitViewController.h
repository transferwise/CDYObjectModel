//
//  OptionalSplitViewController.h
//  Transfer
//
//  Created by Mats Trovik on 16/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  View controller intented to provide the option of a split view on iPad and normal navigation controller stack on iPhone simply by only assigning a detailContainer view in the iPad nib and not on iPhone.
 */
@interface OptionalSplitViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *detailContainer;

/**
 *  shows the argument viewcontroller in the detailContainer if it is assigned. Otherwise, pushes on the nav stack.
 *
 *  @param controller view controller to show.
 */
-(void)presentDetail:(UIViewController*)controller;

-(UIViewController*)currentDetailController;
@end
