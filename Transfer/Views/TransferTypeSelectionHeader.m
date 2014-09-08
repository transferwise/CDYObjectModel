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
#import "HeaderTabView.h"

NSString *const TWTypeSelectionCellIdentifier = @"TWTypeSelectionCellIdentifier";

@interface TransferTypeSelectionHeader () <HeaderTabViewDelegate>

@property (nonatomic, strong) RecipientType *selectedType;
@property (nonatomic, strong) NSArray *allRecipientTypes;
@property (nonatomic, weak) IBOutlet HeaderTabView* tabView;

@end

@implementation TransferTypeSelectionHeader


- (void)setSelectedType:(RecipientType *)selected allTypes:(NSArray *)allTypes {
    if (![allTypes isEqualToArray:self.allRecipientTypes])
    {
        self.allRecipientTypes = allTypes;
        [self.tabView setTabTitles:[allTypes valueForKey:@"title"]];
    }
    [self setSelectedType:selected];
    [self.tabView setSelectedIndex:[allTypes indexOfObject:selected]];
}

- (void)headerTabView:(HeaderTabView *)tabView tabTappedAtIndex:(NSUInteger)index {
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
