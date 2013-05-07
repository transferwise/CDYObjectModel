//
//  RecipientSectionHeaderView.m
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientSectionHeaderView.h"
#import "UIColor+Theme.h"
#import "RecipientType.h"
#import "Constants.h"

@interface RecipientSectionHeaderView ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *presentedButtons;
@property (nonatomic, strong) RecipientType *selectedType;
@property (nonatomic, strong) NSArray *allRecipientTypes;
@property (nonatomic, strong) UIImage *checkedImage;
@property (nonatomic, strong) UIImage *uncheckedImage;

@end

@implementation RecipientSectionHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.titleLabel setTextColor:[UIColor mainTextColor]];
    [self setPresentedButtons:[NSMutableArray array]];

    [self setCheckedImage:[UIImage imageNamed:@"CheckSelected.png"]];
    [self setUncheckedImage:[UIImage imageNamed:@"CheckUnselected.png"]];
}


- (void)setText:(NSString *)text {
    [self.titleLabel setText:text];
}

- (void)setSelectedType:(RecipientType *)selected allTypes:(NSArray *)allTypes {
    MCLog(@"Selected:%@", selected);
    MCLog(@"All types:%@", allTypes);

    [self setSelectedType:selected];
    [self setAllRecipientTypes:allTypes];

    if ([allTypes count] == 1) {
        for (UIButton *presented in self.presentedButtons) {
            [presented removeFromSuperview];
        }
        [self.presentedButtons setArray:@[]];

        return;
    }

    CGFloat xOffset = CGRectGetWidth(self.frame) - 10;

    for (RecipientType *type in allTypes) {
        UIButton *button = [self createButton];
        NSString *titleKey = [NSString stringWithFormat:@"recipient.type.%@.name", type.type];
        [button setTitle:NSLocalizedString(titleKey, nil) forState:UIControlStateNormal];
        [button sizeToFit];

        if ([type.type isEqualToString:selected.type]) {
            [button setImage:self.checkedImage forState:UIControlStateNormal];
        }

        CGRect frame = button.frame;
        frame.origin.x = xOffset - CGRectGetWidth(frame);
        frame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(frame)) / 2;
        [button setFrame:frame];

        [self addSubview:button];
        [self.presentedButtons addObject:button];

        xOffset -= (CGRectGetWidth(frame) + 5);
    }
}

- (UIButton *)createButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [button setImage:self.uncheckedImage forState:UIControlStateNormal];
    [button setTitleColor:[UIColor mainTextColor] forState:UIControlStateNormal];
    [button setAdjustsImageWhenHighlighted:NO];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonTapped:(id)sender {
    MCLog(@"Tapped");
    UIButton *button = sender;
    NSUInteger index = [self.presentedButtons indexOfObject:button];
    RecipientType *tappedOn = self.allRecipientTypes[index];
    if ([tappedOn.type isEqualToString:self.selectedType.type]) {
        MCLog(@"Tapped on selected one");
        return;
    }

    NSUInteger checkIndex = 0;
    for (RecipientType *type in self.allRecipientTypes) {
        UIImage *buttonImage = [type.type isEqualToString:tappedOn.type] ? self.checkedImage : self.uncheckedImage;
        UIButton *typeButton = self.presentedButtons[checkIndex];
        [typeButton setImage:buttonImage forState:UIControlStateNormal];
        checkIndex++;
    }

    [self setSelectedType:tappedOn];
    self.selectionChangeHandler(tappedOn);
}

@end
