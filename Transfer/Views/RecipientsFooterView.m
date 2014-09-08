//
//  RecipientsFooterView.m
//  Transfer
//
//  Created by Juhan Hion on 17.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "RecipientsFooterView.h"

@interface RecipientsFooterView ()

@property (strong, nonatomic) IBOutlet UILabel *inviteLabel;
@property (strong, nonatomic) IBOutlet UIButton *inviteButton;

@end

@implementation RecipientsFooterView

- (void)commonSetup
{
	[self.inviteLabel setText:NSLocalizedString(@"contacts.controller.footer.invite", nil)];
	[self.inviteButton setTitle:NSLocalizedString(@"contacts.controller.footer.invite.button.title", nil) forState:UIControlStateNormal];
}

- (IBAction)inviteTapped:(id)sender
{

    [self.delegate inviteFriends];
}

@end
