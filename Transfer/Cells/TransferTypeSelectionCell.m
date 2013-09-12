//
//  TransferTypeSelectionCell.m
//  Transfer
//
//  Created by Henri Mägi on 17.06.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferTypeSelectionCell.h"
#import "RoundedCellWhiteBackgroundView.h"
#import "RecipientType.h"
#import "Constants.h"
#import "UIColor+Theme.h"

NSString *const TWTypeSelectionCellIdentifier = @"TWTypeSelectionCellIdentifier";

@interface TransferTypeSelectionCell ()

@property (strong, nonatomic) IBOutlet RoundedCellWhiteBackgroundView *selectedView;

@property (nonatomic, strong) RecipientType *selectedType;
@property (nonatomic, strong) NSArray *allRecipientTypes;
@property (strong, nonatomic) NSMutableArray *presentedLabels;

@end

@implementation TransferTypeSelectionCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [self setBackgroundColor:[UIColor controllerBackgroundColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)adjustSelectedView {
    for (RecipientType *type in self.allRecipientTypes) {
        NSUInteger index = [self.allRecipientTypes indexOfObject:type];
        CGFloat groupedCellWidth = CGRectGetWidth(self.frame) - (IOS_7 ? 0 : 20);
        if ([type.type isEqualToString:self.selectedType.type]) {
            if (index == 0 && !IOS_7) {
                [self.selectedView setRoundedCorner:UIRectCornerTopLeft];
            } else if (index == (self.allRecipientTypes.count - 1) && !IOS_7) {
                [self.selectedView setRoundedCorner:UIRectCornerTopRight];
            }
            CGRect frame = self.selectedView.frame;
            frame.origin.x = groupedCellWidth / self.allRecipientTypes.count * index;
            frame.size.width = groupedCellWidth / self.allRecipientTypes.count;
            self.selectedView.frame = frame;
            [self.selectedView setNeedsDisplay];
        }
    }
}

- (void)setSelectedType:(RecipientType *)selected allTypes:(NSArray *)allTypes {
    if ([allTypes isEqualToArray:self.allRecipientTypes] && self.presentedLabels.count == allTypes.count) {
        [self setSelectedType:selected];
        [self adjustSelectedView];
        return;
    }
    
    [self setSelectedType:selected];
    [self setAllRecipientTypes:allTypes];

    for (UILabel *presented in self.presentedLabels) {
        [presented removeFromSuperview];
    }
    
    for (UIView *view in self.subviews) {
        //Removing the separation lines
        if(CGRectGetWidth(view.frame) == 1)
            [view removeFromSuperview];
    }

    self.presentedLabels = [NSMutableArray array];

    CGFloat groupedCellWidth = CGRectGetWidth(self.frame) - 20;
    CGFloat xStep = groupedCellWidth / (allTypes.count + 1);
    CGFloat xOffset = xStep;
    NSUInteger index = 0;

    for (RecipientType *type in allTypes) {
        UILabel *label = [self createLabel];
        [label setText:type.title];
        [label setTextAlignment:NSTextAlignmentCenter];
        CGRect frame = CGRectMake(groupedCellWidth / allTypes.count * index + 10, 0, groupedCellWidth / allTypes.count, CGRectGetHeight(self.frame));
        [label setFrame:frame];

        [self addSubview:label];
        [self.presentedLabels addObject:label];

        //Adding separation lines
        if (index > 0 && !IOS_7) {
            CGFloat lineStep = groupedCellWidth / (self.allRecipientTypes.count);
            CGRect lineFrame = CGRectMake(lineStep * index + 10, 0, 1, CGRectGetHeight(self.frame));
            UIView *line = [[UIView alloc] initWithFrame:lineFrame];
            [line setBackgroundColor:[UIColor grayColor]];
            [self addSubview:line];
        }

        xOffset += xStep;
        index += 1;
    }

    [self adjustSelectedView];

}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    [label setTextColor:[UIColor mainTextColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
    [label addGestureRecognizer:tap];
    [label setUserInteractionEnabled:YES];
    return label;
}

- (void)labelTapped:(id)sender {
    MCLog(@"Tapped");
    UITapGestureRecognizer *tap = sender;
    UILabel *label = (UILabel *) tap.view;
    NSUInteger index = [self.presentedLabels indexOfObject:label];
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
