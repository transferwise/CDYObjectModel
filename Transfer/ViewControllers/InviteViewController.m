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
#import "NavigationBarCustomiser.h"
#import "UIImage+Color.h"
#import "GoogleAnalytics.h"


@interface InviteViewController () <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *smsButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contextLabel;
@property (weak, nonatomic) IBOutlet UIButton *urlCopyButton;

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
    [self.urlCopyButton setTitle:NSLocalizedString(@"invite.copy.button.title", @"") forState:UIControlStateNormal];
    self.titleLabel.text = NSLocalizedString(@"invite.modal.title", nil);
    self.contextLabel.text = NSLocalizedString(@"invite.context", nil);
    
    
    self.smsButton.hidden = ![MFMessageComposeViewController canSendText];
    [[GoogleAnalytics sharedInstance] sendScreen:[NSString stringWithFormat:@"Invite friends modal"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookTapped:(id)sender {
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    NSURL* url = [NSURL URLWithString:self.inviteUrl];
    params.link = url;
    BOOL canShare = [FBDialogs canPresentShareDialogWithParams:params];
    if (canShare) {
        [[GoogleAnalytics sharedInstance] sendAppEvent:@"InviteViaFBInitiated"];
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
                                              [[GoogleAnalytics sharedInstance] sendAppEvent:@"InviteViaFBSent"];
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
            [controller setCompletionHandler:^(SLComposeViewControllerResult result)
             {
                if(result ==SLComposeViewControllerResultDone)
                {
                    [[GoogleAnalytics sharedInstance] sendAppEvent:@"InviteViaFBSent"];
                    [self dismiss];
                }
             }];
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

        [[GoogleAnalytics sharedInstance] sendAppEvent:@"InviteViaEmailInitiated"];
        NSURL* url = [NSURL URLWithString:self.inviteUrl];
        [NavigationBarCustomiser noStyling];
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        [controller setMailComposeDelegate:self];
        [controller setSubject:[NSString stringWithFormat:NSLocalizedString(@"invite.email.subject", nil), [self.objectModel currentUser].personalProfile.firstName]];
        NSString *messageBody = [NSString stringWithFormat:NSLocalizedString(@"invite.email.message", nil), [url absoluteString], [self.objectModel currentUser].personalProfile.firstName, [self.objectModel currentUser].personalProfile.firstName];
        [controller setMessageBody:messageBody isHTML:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [self  presentViewController:controller animated:YES completion:^{
        }];
    }
}

- (IBAction)smsTapped:(id)sender {
 
    [[GoogleAnalytics sharedInstance] sendAppEvent:@"InviteViaSMSInitiated"];
    NSURL* url = [NSURL URLWithString:self.inviteUrl];
    [NavigationBarCustomiser noStyling];

    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    [controller setMessageComposeDelegate:self];
    NSString *messageBody = [NSString stringWithFormat:NSLocalizedString(@"invite.sms.message", nil), [url absoluteString], [self.objectModel currentUser].personalProfile.firstName];
    [controller setBody:messageBody];
    [self  presentViewController:controller animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }];


}

- (IBAction)urlCopyTapped:(id)sender {
    [self.urlCopyButton setTitle:NSLocalizedString(@"invite.copied.button.title", @"") forState:UIControlStateNormal];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    self.urlCopyButton.alpha = 0.5f;
    pasteboard.string = self.inviteUrl;
    [[GoogleAnalytics sharedInstance] sendAppEvent:@"CopyInviteLink"];

    
}

#pragma mark mail and sms delegate

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [NavigationBarCustomiser setDefault];
    [self dismissViewControllerAnimated:YES completion:^{
        if (result == MessageComposeResultSent)
        {
            [[GoogleAnalytics sharedInstance] sendAppEvent:@"InviteViaSMSSent"];
            [self dismiss];
        }
    }];
   
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [NavigationBarCustomiser setDefault];
    [self dismissViewControllerAnimated:YES completion:^{
        if (result == MFMailComposeResultSaved || result == MFMailComposeResultSent)
        {
            [[GoogleAnalytics sharedInstance] sendAppEvent:@"InviteViaEmailSent"];
            [self dismiss];
        }
    }];
}

@end
