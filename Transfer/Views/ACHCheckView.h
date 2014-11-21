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

@property (nonatomic, weak) UIView* inactiveHostView;
@property (nonatomic, weak) UIView*  activeHostView;

-(void)setState:(ACHCheckViewState)state animated:(BOOL)shouldAnimate;

@end
