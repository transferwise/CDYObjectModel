//
//  ValidationCell.m
//  Transfer
//
//  Created by Mats Trovik on 12/08/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ValidationCell.h"

@interface ValidationCell ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;


@end

@implementation ValidationCell

-(void)configureWithButtonTitle:(NSString*)buttonTitle buttonImage:(UIImage*)image andCaption:(NSString*)caption
{
    [self.button setTitle:buttonTitle forState:UIControlStateNormal];
    [self.button setImage:image forState:UIControlStateNormal];
    self.captionLabel.text = caption;
    
    [self.deleteButton setTitle:NSLocalizedString(@"identification.delete.button", nil) forState:UIControlStateNormal];
}

- (IBAction)buttonTapped:(id)sender {
    if([self.delegate respondsToSelector:@selector(actionTappedOnValidationCell:)])
    {
        [self.delegate actionTappedOnValidationCell:self];
    }
}

- (IBAction)deleteTapped:(id)sender {
    if([self.delegate respondsToSelector:@selector(deleteTappedOnValidationCell:)])
    {
        [self.delegate deleteTappedOnValidationCell:self];
    }
}

-(void)documentSelected:(BOOL)documentSelectedState{
    
    self.button.hidden = documentSelectedState;
    self.captionLabel.hidden = documentSelectedState;
    self.selectedImage.hidden = !documentSelectedState;
    self.deleteButton.hidden = !documentSelectedState;
}

@end
