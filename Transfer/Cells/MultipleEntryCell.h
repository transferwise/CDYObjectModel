//
//  MultipleEntryCell.h
//  Transfer
//
//  Created by Juhan Hion on 28.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextEntryCell.h"

@protocol MultipleEntryCellDelegate <NSObject>

- (void)navigateAwayFrom:(UITableViewCell *)cell;

@end

@interface MultipleEntryCell : TextEntryCell<UITextFieldDelegate>;

@property (nonatomic, weak) id<MultipleEntryCellDelegate> delegate;
@property (nonatomic, strong, readonly) UITextField* selectedTextField;

- (BOOL)shouldNavigateAway;
- (void)navigateAway;

@end
