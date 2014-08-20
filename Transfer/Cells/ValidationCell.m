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
@property (weak, nonatomic) NSString *caption;
@property (weak, nonatomic) NSString *selectedCaption;
@property (weak, nonatomic) IBOutlet UIView *separatorLine;


@end

@implementation ValidationCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    if (self.separatorLine)
    {
        CGRect newFrame = self.separatorLine.frame;
        newFrame.size.height = 1.0f/[[UIScreen mainScreen] scale];
        self.separatorLine.frame = newFrame;
    }
}

-(void)configureWithButtonTitle:(NSString*)buttonTitle buttonImage:(UIImage*)image caption:(NSString*)caption selectedCaption:(NSString*)selectedCaption
{
    [self.button setTitle:buttonTitle forState:UIControlStateNormal];
    [self.button setImage:image forState:UIControlStateNormal];
    self.caption = caption;
    self.selectedCaption = selectedCaption;
    
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
    self.captionLabel.text = documentSelectedState?self.selectedCaption:self.caption;
    self.selectedImage.hidden = !documentSelectedState;
    self.deleteButton.hidden = !documentSelectedState;
}

@end
