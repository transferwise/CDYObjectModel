//
//  TransferTypeSelectionCell.m
//  Transfer
//
//  Created by Henri Mägi on 17.06.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferTypeSelectionCell.h"
#import "RecipientType.h"
#import "Constants.h"

NSString *const TWTypeSelectionCellIdentifier = @"TWTypeSelectionCellIdentifier";

@interface TransferTypeSelectionCell ()

@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;
@property (strong, nonatomic) IBOutlet UIImageView *leftImage;
@property (strong, nonatomic) IBOutlet UIImageView *rightImage;

@property (nonatomic, strong) RecipientType *selectedType;
@property (nonatomic, strong) NSArray *allRecipientTypes;

@end

@implementation TransferTypeSelectionCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSelectedType:(RecipientType *)selected allTypes:(NSArray *)allTypes {
    MCLog(@"Selected:%@", selected);
    MCLog(@"All types:%@", allTypes);
    
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
    
}

- (void)buttonTapped:(id)sender {
    MCLog(@"Tapped");
    UITapGestureRecognizer *tap = sender;
    RecipientType *tappedOn;
    if(tap.view == self.leftLabel)
    {
        tappedOn = [self.allRecipientTypes objectAtIndex:0];
    }
    else
    {
        tappedOn = [self.allRecipientTypes objectAtIndex:1];
    }
    
    [self changeSelectedTypeTo:tappedOn];
}

- (void)changeSelectedTypeTo:(RecipientType *)tappedOn {
    
    if([self.allRecipientTypes indexOfObject:tappedOn] == 0){
        [self.leftImage setHidden:NO];
        [self.rightImage setHidden:YES];
    }
    else{
        [self.leftImage setHidden:YES];
        [self.rightImage setHidden:NO];
    }
    
    if ([tappedOn.type isEqualToString:self.selectedType.type]) {
        MCLog(@"Tapped on selected one");
        return;
    }
    
    [self setSelectedType:tappedOn];
    self.selectionChangeHandler(tappedOn);
}

@end
