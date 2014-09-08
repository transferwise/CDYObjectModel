//
//  ConnectionAwareViewController.h
//  Transfer
//
//  Created by Mats Trovik on 27/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionAwareViewController : UIViewController

+(instancetype)createWrappedNavigationControllerWithRoot:(UIViewController*)rootController navBarHidden:(BOOL)hidden;

- (id)initWithWrappedViewController:(UIViewController*)wrappedViewController;

@end
