//
//  SwipeToCancelCellTableViewCell.h
//  Transfer
//
//  Created by Juhan Hion on 08.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface SwipeToCancelCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (nonatomic, readonly) BOOL isCancelVisible;
@property (nonatomic) BOOL canBeCancelled;
@property (nonatomic, strong) NSString* cancelButtonTitle;

- (void)configureWithWillShowCancelBlock:(TRWActionBlock)willShowCancelBlock
					  didShowCancelBlock:(TRWActionBlock)didShowCancelBlock
					  didHideCancelBlock:(TRWActionBlock)didHideCancelBlock
					   cancelTappedBlock:(TRWActionBlock)cancelTappedBlock;

- (void)setIsCancelVisible:(BOOL)isCancelVisible animated:(BOOL)animated;

@end
