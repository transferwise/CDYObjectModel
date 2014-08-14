//
//  InviteViewController.m
//  Transfer
//
//  Created by Mats Trovik on 14/08/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "InviteViewController.h"
#import <MessageUI/MessageUI.h>
#import "TRWAlertView.h"
#import <FBDialogs.h>
#import "ObjectModel+Users.h"
#import "User.h"
#import "PersonalProfile.h"
#import <Social/Social.h>
#import <FBErrorUtility+Internal.h>

#define _TEMPORARY_URL @"http://www.transferwise.com"

@interface InviteViewController () <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *smsButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contextLabel;

@end

@implementation InviteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.facebookButton setTitle:NSLocalizedString(@"invite.fb.button.title", @"") forState:UIControlStateNormal];
    [self.emailButton setTitle:NSLocalizedString(@"invite.email.button.title", @"") forState:UIControlStateNormal];
    [self.smsButton setTitle:NSLocalizedString(@"invite.sms.button.title", @"") forState:UIControlStateNormal];
    self.titleLabel.text = NSLocalizedString(@"invite.modal.title", nil);
    self.contextLabel.text = NSLocalizedString(@"invite.context", nil);
    
    self.smsButton.hidden = ![MFMessageComposeViewController canSendText];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookTapped:(id)sender {
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    NSURL* url = [NSURL URLWithString:_TEMPORARY_URL];
    params.link = url;
    BOOL canShare = [FBDialogs canPresentShareDialogWithParams:params];
    if (canShare) {
        // FBDialogs call to open Share dialog
        [FBDialogs presentShareDialogWithLink:url
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              if([FBErrorUtility shouldNotifyUserForError:error])
                                              {
                                                  TRWAlertView* alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"invite.error.facebook.title",nil) message:[FBErrorUtility userMessageForError:error]];
                                                  [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                                                  [alertView show];
                                              }
                                          } else {
                                              [self dismiss];
                                          }
                                      }];
        
    }
    else
    {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [controller setInitialText:[NSString stringWithFormat:NSLocalizedString(@"invite.facebook.default.message",nil),[self.objectModel currentUser].personalProfile.firstName]];
            [controller addURL:url];
            [self presentViewController:controller animated:YES completion:nil];
        }
        else
        {
            TRWAlertView* alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"invite.error.facebook.title",nil) message:NSLocalizedString(@"invite.error.facebook.message",nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
            [alertView show];
        }
    }
}

- (IBAction)emailTapped:(id)sender {
    if(! [MFMailComposeViewController canSendMail])
    {
        TRWAlertView* alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"support.cant.send.email.title",nil) message:NSLocalizedString(@"support.cant.send.email.message",nil)];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
    }
    else
    {
        NSURL* url = [NSURL URLWithString:_TEMPORARY_URL];
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        [controller setMailComposeDelegate:self];
        [controller setSubject:NSLocalizedString(@"invite.email.subject", nil)];
        NSString *messageBody = [NSString stringWithFormat:NSLocalizedString(@"invite.email.message", nil), [url absoluteString], [self.objectModel currentUser].personalProfile.firstName];
        [controller setMessageBody:messageBody isHTML:YES];
        [self  presentViewController:controller animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
}

- (IBAction)smsTapped:(id)sender {
 
    NSURL* url = [NSURL URLWithString:_TEMPORARY_URL];
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    [controller setMessageComposeDelegate:self];
    NSString *messageBody = [NSString stringWithFormat:NSLocalizedString(@"invite.sms.message", nil), [url absoluteString]];
    [controller setBody:messageBody];
    [self  presentViewController:controller animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];


}

#pragma mark mail and sms delegate

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (result == MessageComposeResultSent)
        {
            [self dismiss];
        }
    }];
   
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (result == MFMailComposeResultSaved || result == MFMailComposeResultSent)
        {
            [self dismiss];
        }
    }];
}

@end
