//
//  SwipeToCancelCellTableViewCell.h
//  Transfer
//
//  Created by Juhan Hion on 08.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "SeparatorViewCell.h"

@interface SwipeActionCell : SeparatorViewCell<UIGestureRecognizerDelegate>

@property (readonly, nonatomic) UIView *slidingContentView;
@property (nonatomic, readonly) BOOL isActionbuttonVisible;
@property (nonatomic) BOOL canPerformAction;
@property (nonatomic, strong) NSString* actionButtonTitle;

- (void)configureWithActionButtonFromColor:(UIColor*)fromColor
                               toColor:(UIColor*)toColor
               willShowActionButtonBlock:(TRWActionBlock)willShowCancelBlock
                didShowActionButtonBlock:(TRWActionBlock)didShowCancelBlock
                didHideActionButtonBlock:(TRWActionBlock)didHideCancelBlock
                       actionTappedBlock:(TRWActionBlock)cancelTappedBlock;

- (void)setIsActionButtonVisible:(BOOL)isActionButtonVisible animated:(BOOL)animated;

@end
