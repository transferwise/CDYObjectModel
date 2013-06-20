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

@property (strong, nonatomic) IBOutlet RoundedCellWhiteBackgroundView *backgroundView;

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

- (void)awakeFromNib
{
    [self setPresentedLabels:[NSMutableArray array]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSelectedType:(RecipientType *)selected allTypes:(NSArray *)allTypes {
    /*MCLog(@"Selected:%@", selected);
    MCLog(@"All types:%@", allTypes);
    
    [self.backgroundView setRoundedCorner:UIRectCornerTopLeft];
    
    [self setSelectedType:selected];
    [self setAllRecipientTypes:allTypes];
    
    if(allTypes.count < 2)
        return;
    
    RecipientType *type1 = [allTypes objectAtIndex:0];
    NSString *titleKey1 = [NSString stringWithFormat:@"recipient.type.%@.name", type1.type];
    [self.leftLabel setText:NSLocalizedString(titleKey1, nil)];
    
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonTapped:)];
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonTapped:)];
    [self.leftLabel addGestureRecognizer:leftTap];
    [self.rightLabel addGestureRecognizer:rightTap];
    
    RecipientType *type2 = [allTypes objectAtIndex:1];
    NSString *titleKey2 = [NSString stringWithFormat:@"recipient.type.%@.name", type2.type];
    [self.rightLabel setText:NSLocalizedString(titleKey2, nil)];
    
    [self changeSelectedTypeTo:selected];
    */
    MCLog(@"Selected:%@", selected);
    MCLog(@"All types:%@", allTypes);
    
    if([allTypes isEqualToArray:self.allRecipientTypes]){
        [self changeSelectedTypeTo:selected];
        return;
    }
    
    [self setSelectedType:selected];
    [self setAllRecipientTypes:allTypes];

    for (UILabel *presented in self.presentedLabels) {
        [presented removeFromSuperview];
    }
    [self.presentedLabels setArray:@[]];

    
    CGFloat xOffset = CGRectGetWidth(self.frame)/(allTypes.count+1);
    
    for (RecipientType *type in allTypes) {
        UILabel *label = [self createLabel];
        NSString *titleKey = [NSString stringWithFormat:@"recipient.type.%@.name", type.type];
        [label setText:NSLocalizedString(titleKey, nil)];
        [label sizeToFit];
        
        if ([type.type isEqualToString:selected.type]) {
            //TODO: 
        }
        
        CGRect frame = label.frame;
        frame.origin.x = xOffset - CGRectGetWidth(frame)/2;
        frame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(frame)) / 2;
        [label setFrame:frame];
        
        [self addSubview:label];
        [self.presentedLabels addObject:label];
        
        xOffset += CGRectGetWidth(self.frame)/(allTypes.count+1);
    }
    
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    [label setTextColor:[UIColor mainTextColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTapped:)];
    [label addGestureRecognizer:tap];
    [label setUserInteractionEnabled:YES];
    return label;
}

- (void)labelTapped:(id)sender {
    MCLog(@"Tapped");
    UITapGestureRecognizer *tap = sender;
    UILabel *label = (UILabel*)tap.view;
    NSUInteger index = [self.presentedLabels indexOfObject:label];
    RecipientType *tappedOn = self.allRecipientTypes[index];
    [self changeSelectedTypeTo:tappedOn];
}

- (void)changeSelectedTypeTo:(RecipientType *)tappedOn {

    
    // TODO: More generic
    /*
    if([self.allRecipientTypes indexOfObject:tappedOn] == 0){
        [self.leftImage setHidden:NO];
        [self.rightImage setHidden:YES];
    }
    else{
        [self.leftImage setHidden:YES];
        [self.rightImage setHidden:NO];
    }*/
    
    if ([tappedOn.type isEqualToString:self.selectedType.type]) {
        MCLog(@"Tapped on selected one");
        return;
    }
    
    
    [self setSelectedType:tappedOn];
    self.selectionChangeHandler(tappedOn);
}

@end
