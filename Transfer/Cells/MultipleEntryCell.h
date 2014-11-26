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

@property (strong, nonatomic) UIView* secondSeparator;

@property (nonatomic, weak) id<MultipleEntryCellDelegate> multipleEntryDelegate;
@property (nonatomic, strong, readonly) UITextField* selectedTextField;

- (void)activate;
- (BOOL)shouldNavigateAway;
- (void)navigateAway;

- (void)addSingleSeparator;
- (void)addDoubleSeparators;
- (void)removeDoubleSeparators;

@end
