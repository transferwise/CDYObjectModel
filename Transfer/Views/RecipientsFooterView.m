//
//  RecipientsFooterView.m
//  Transfer
//
//  Created by Juhan Hion on 17.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "RecipientsFooterView.h"
#import "ReferralsCoordinator.h"

@interface RecipientsFooterView ()

@property (strong, nonatomic) IBOutlet UILabel *inviteLabel;
@property (strong, nonatomic) IBOutlet UIButton *inviteButton;

@end

@implementation RecipientsFooterView

- (void)awakeFromNib
{
	[self.inviteButton setTitle:NSLocalizedString(@"contacts.controller.footer.invite.button.title", nil) forState:UIControlStateNormal];
}

-(void)setAmountString:(NSString*)amountString
{
    [self.inviteLabel setText:[NSString stringWithFormat:NSLocalizedString(@"contacts.controller.footer.invite", nil),amountString]];
}

- (IBAction)inviteTapped:(id)sender
{
    [self.delegate inviteFriends];
}

@end
