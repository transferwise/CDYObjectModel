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

@interface ContactDetailsViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerBackground;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *sendMoneyButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


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
    UINib * cellNib = [UINib nibWithNibName:@"PlainPresentationCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:PlainPresentationCellIdentifier];
    [self.tableView reloadData];
    self.nameLabel.text = self.recipient.name;
    [self.sendMoneyButton setTitle:NSLocalizedString(@"contact.detail.send",nil) forState:UIControlStateNormal];
    
    //TODO: m@s replace with loading user image once API is implemented.
    UIImage *userImage = [UIImage imageNamed:[NSString stringWithFormat:@"User%d",arc4random()%4]];
    self.userImage.image = userImage;
    
    __weak typeof(self) weakSelf = self;
    CGSize blurSize = userImage.size;
    CGSize wantedSize = weakSelf.headerBackground.frame.size;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Crop blurred image
        NSUInteger scale = userImage.scale;
        CGRect rect = CGRectMake(blurSize.width/400.0f *(60.0f)*scale,
                                 blurSize.height/400.0f *(20.0f)*scale,
                                 blurSize.width/400.0f *199 *scale,
                                 blurSize.height/400.0f * 140.0f *scale);
            
        CGImageRef imageRef = CGImageCreateWithImageInRect([userImage CGImage], rect);
        UIImage *cropped = [UIImage imageWithCGImage:imageRef
                                                   scale:scale
                                             orientation:userImage.imageOrientation];
        CGImageRelease(imageRef);
        
        //Scale it up
        
        UIGraphicsBeginImageContextWithOptions(wantedSize, NO, 0.0);
        [cropped drawInRect:CGRectMake(0, 0, wantedSize.width, wantedSize.height)];
        UIImage *scaledup = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        
        
        //Blur
        [UIImage blurImageInBackground:scaledup withRadius:20 iterations:8 tintColor:nil withCompletionBlock:^(UIImage *result) {
            self.headerBackground.alpha = 0.0f;
            self.headerBackground.image = result;
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.headerBackground.alpha = 0.2f;
            } completion:nil];
        }];
        
    });
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


@end
