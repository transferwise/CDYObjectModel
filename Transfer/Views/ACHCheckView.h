//
//  ACHCheckView.h
//  Transfer
//
//  Created by Mats Trovik on 20/11/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(short, ACHCheckViewState)
{
    CheckStatePlain,
    CheckStateRoutingHighlighted,
    CheckStateAccountHighlighted
};

@interface ACHCheckView : UIView

/**
 *  host view used in the inactive state.
 */
@property (nonatomic, weak) UIView* inactiveHostView;
/**
 *  Host used in the active state (used for overlaying the nav bar)
 */
@property (nonatomic, weak) UIView*  activeHostView;
/**
 *  Current state
 */
@property (nonatomic, readonly) ACHCheckViewState state;

/**
 *  Set state
 *
 *  @param state         Plain for inacitve, Routing or Account highlighted for active
 *  @param shouldAnimate indicates wether to animate the transition or not.
 */
-(void)setState:(ACHCheckViewState)state animated:(BOOL)shouldAnimate;

@end
