//
//  ContactDetailsViewController.m
//  Transfer
//
//  Created by Mats Trovik on 17/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ContactDetailsViewController.h"
#import "PlainPresentationCell.h"
#import "RecipientTypeField.h"
#import "TypeFieldValue.h"
#import "UIView+RenderBlur.h"
#import "UIImage+RenderBlur.h"
#import "RecipientType.h"
#import "TRWAlertView.h"
#import "Recipient.h"
#import "ObjectModel.h"
#import "ObjectModel+CurrencyPairs.h"
#import "GoogleAnalytics.h"
#import "NewPaymentViewController.h"
#import "ConnectionAwareViewController.h"
#import "Currency.h"
#import "TRWProgressHUD.h"
#import "DeleteRecipientOperation.h"
#import "UIColor+MOMStyle.h"
#import "NavigationBarCustomiser.h"
#import "MOMStyle.h"
#import "UIImage+Color.h"
#import "TransferBackButtonItem.h"

@interface ContactDetailsViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerBackground;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *sendMoneyButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagIcon;


@end

@implementation ContactDetailsViewController

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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UINib * cellNib = [UINib nibWithNibName:@"PlainPresentationCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:PlainPresentationCellIdentifier];
    [self.tableView reloadData];
    
    
    NSMutableAttributedString* nameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ - %@", self.recipient.name, self.recipient.currency.code]];
    NSRange hyphenRange = NSMakeRange([self.recipient.name length], 3);
    [nameString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromStyle:@"corefont"] range:hyphenRange];
    self.nameLabel.attributedText = nameString;
    
    [self.sendMoneyButton setTitle:NSLocalizedString(@"contact.detail.send",nil) forState:UIControlStateNormal];
    
    self.flagIcon.image = [UIImage imageNamed:self.recipient.currency.code?[NSString stringWithFormat:@"%@_flag_30px",self.recipient.currency.code]:@"flag_default_30px"];
    
    //TODO: m@s replace with loading user image once API is implemented.
    UIImage *userImage = [UIImage imageNamed:[NSString stringWithFormat:@"User%d",arc4random()%4]];
    self.userImage.image = userImage;
    
    __weak typeof(self) weakSelf = self;
    [UIImage headerBackgroundFromImage:userImage finalImageSize:CGSizeMake(473, 270) completionBlock:^(UIImage *result) {
        weakSelf.headerBackground.alpha = 0.0f;
        weakSelf.headerBackground.image = result;
        [UIView animateWithDuration:0.7f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.headerBackground.alpha = 0.25f;
        } completion:nil];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!IPAD)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(!IPAD)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recipient.fieldValues count] + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlainPresentationCell* cell = [self.tableView dequeueReusableCellWithIdentifier:PlainPresentationCellIdentifier];
    if(indexPath.row < [self.recipient.fieldValues count])
    {
        TypeFieldValue* value = [self.recipient.fieldValues objectAtIndex:indexPath.row];
        [cell configureWithTitle:value.valueForField.title text:value.value];
    }
    else
    {
        [cell configureWithTitle:NSLocalizedString(@"recipient.controller.cell.label.email", nil) text:self.recipient.email?:@"-"];
    }
    return cell;
}

#pragma mark - button actions

-(IBAction)sendTapped:(id)sender
{
    if ([self.recipient.type hideFromCreationValue])
    {
        return;
    }
    
    if (![self.objectModel canMakePaymentToCurrency:self.recipient.currency])
    {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"payment.controller.currency.payment.error.title", nil)
                                                           message:[NSString stringWithFormat:NSLocalizedString(@"payment.controller.currency.payment.error.message", nil), self.recipient.currency.code]];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }
    
    [[GoogleAnalytics sharedInstance] sendScreen:@"New payment to"];
    NewPaymentViewController *controller = [[NewPaymentViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [controller setRecipient:self.recipient];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [navigationController setNavigationBarHidden:YES];
    ConnectionAwareViewController *wrapper = [[ConnectionAwareViewController alloc] initWithWrappedViewController:navigationController];
    
    [self presentViewController:wrapper animated:YES completion:nil];
    
}

- (IBAction)deleteTapped:(id)sender
{
    if(self.deletionDelegate)
    {
        [self.deletionDelegate contactDetailsController:self didDeleteContact:self.recipient];
    }
}

- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end