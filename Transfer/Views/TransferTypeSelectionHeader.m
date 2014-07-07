//
//  TransferTypeSelectionCell.m
//  Transfer
//
//  Created by Henri Mägi on 17.06.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferTypeSelectionHeader.h"
#import "RoundedCellWhiteBackgroundView.h"
#import "RecipientType.h"
#import "Constants.h"
#import "UIColor+Theme.h"
#import "MOMStyle.h"

NSString *const TWTypeSelectionCellIdentifier = @"TWTypeSelectionCellIdentifier";

@interface TransferTypeSelectionHeader ()

@property (nonatomic, strong) RecipientType *selectedType;
@property (nonatomic, strong) NSArray *allRecipientTypes;
@property (strong, nonatomic) NSMutableArray *presentedButtons;
@property (nonatomic, weak,) UIButton * lastSelectedButton;
@property (weak, nonatomic) IBOutlet UIView *tabContainer;

@end

@implementation TransferTypeSelectionHeader



-(void)updateSelectedButton
{
    self.lastSelectedButton.selected = NO;
    self.lastSelectedButton = self.presentedButtons[[self.allRecipientTypes indexOfObject:self.selectedType]];
    self.lastSelectedButton.selected = YES;
}

- (void)setSelectedType:(RecipientType *)selected allTypes:(NSArray *)allTypes {
    if ([allTypes isEqualToArray:self.allRecipientTypes] && self.presentedButtons.count == allTypes.count) {
        [self setSelectedType:selected];
        [self updateSelectedButton];
        return;
    }
    
    [self setSelectedType:selected];
    [self setAllRecipientTypes:allTypes];

    for (UILabel *presented in self.presentedButtons) {
        [presented removeFromSuperview];
    }
    
    for (UIView *view in self.subviews) {
        //Removing the separation lines
        if(CGRectGetWidth(view.frame) == 1)
            [view removeFromSuperview];
    }

    self.presentedButtons = [NSMutableArray array];

    CGFloat groupedCellWidth = CGRectGetWidth(self.tabContainer.frame) - 20;
    CGFloat gap = 4.0f;
    NSUInteger index = 0;

    for (RecipientType *type in allTypes) {
        UIButton *button = [self createButton];
        [button setTitle:type.title forState:UIControlStateNormal];
        CGRect frame = CGRectMake(groupedCellWidth / allTypes.count * index + 10.0 + gap/2 , 0, (groupedCellWidth / allTypes.count) - gap, CGRectGetHeight(self.tabContainer.frame));
        [button setFrame:frame];

        [self.tabContainer addSubview:button];
        [self.presentedButtons addObject:button];
        index ++;
    }

    [self updateSelectedButton];
}

- (UIButton *)createButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button setBackgroundImage:[UIImage imageNamed:@"DeselectedTab"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"SelectedTab"] forState:UIControlStateSelected];
    button.fontStyle = @"medium.@15.lighterBlue";
    button.selectedFontStyle = @"medium.@15.darkText2";
    [button addTarget:self action:@selector(tabTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)tabTapped:(UIButton*)sender {
    MCLog(@"Tapped");
    NSUInteger index = [self.presentedButtons indexOfObject:sender];
    RecipientType *tappedOn = self.allRecipientTypes[index];
    [self changeSelectedTypeTo:tappedOn];
}

- (void)changeSelectedTypeTo:(RecipientType *)tappedOn {
    if ([tappedOn.type isEqualToString:self.selectedType.type]) {
        MCLog(@"Tapped on selected one");
        return;
    }
    self.selectionChangeHandler(tappedOn, self.allRecipientTypes);
}

- (void)setEditable:(BOOL)editable {
    [self setUserInteractionEnabled:editable];
}


@end
