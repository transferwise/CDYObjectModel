//
//  PersonalProfileIdentificationViewController.m
//  Transfer
//
//  Created by Henri Mägi on 08.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PersonalProfileIdentificationViewController.h"
#import "UIColor+Theme.h"
#import "ValidationCell.h"
#import "NSMutableString+Issues.h"
#import "NSString+Validation.h"
#import "TRWAlertView.h"
#import "TRWProgressHUD.h"
#import "PendingPayment.h"
#import "TextEntryCell.h"
#import "TransferBackButtonItem.h"
#import "UITableView+FooterPositioning.h"
#import "GoogleAnalytics.h"
#import "ObjectModel+Users.h"
#import "User.h"
#import "PersonalProfile.h"
#import "ColoredButton.h"

@interface PersonalProfileIdentificationViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ValidationCellDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *headerSeparator;
@property (strong, nonatomic) IBOutlet UILabel *reasonTitle;
@property (weak, nonatomic) IBOutlet UIImageView *reasonIcon;

@property (strong, nonatomic) ValidationCell *idDocumentCell;
@property (strong, nonatomic) ValidationCell *proofOfAddressCell;

@property (strong, nonatomic) IBOutlet ColoredButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton* skipButton;

@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) NSInteger idVerificationRowIndex;
@property (nonatomic, assign) NSInteger addressVerificationRowIndex;
@property (nonatomic, strong) TextEntryCell *paymentPurposeCell;

@end

@implementation PersonalProfileIdentificationViewController

- (id)init {
    self = [super initWithNibName:@"PersonalProfileIdentificationViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.idVerificationRowIndex = NSNotFound;
    self.addressVerificationRowIndex = NSNotFound;

    self.tableView.tableHeaderView = self.headerView;
    CGRect newFrame = self.headerSeparator.frame;
    newFrame.size.height = 1.0f/[[UIScreen mainScreen] scale];
    self.headerSeparator.frame=newFrame;

    [self.reasonTitle setText:NSLocalizedString(@"identification.reason.title", @"")];
    
     [self.skipButton setTitle:NSLocalizedString(@"identification.skip.button", @"") forState:UIControlStateNormal];
    [self.continueButton setTitle:NSLocalizedString(@"identification.upload.button", @"") forState:UIControlStateNormal];

    [self.tableView registerNib:[UINib nibWithNibName:@"ValidationCell" bundle:nil] forCellReuseIdentifier:ValidationCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self buildCells];

    [self.navigationItem setTitle:[NSString stringWithFormat:NSLocalizedString(@"identification.controller.title", nil),[self.presentedSectionCells[0] count]]];

    [self.tableView adjustFooterViewSize];

    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)buildCells {
    if ([self.presentedSectionCells count] > 0) {
        return;
    }

    NSMutableArray *photoCells = [NSMutableArray array];

    if ([self idVerificationRequired]) {
        ValidationCell *idDocumentCell = [self.tableView dequeueReusableCellWithIdentifier:ValidationCellIdentifier];
        [self setIdDocumentCell:idDocumentCell];
        [photoCells addObject:idDocumentCell];
        [idDocumentCell configureWithButtonTitle:NSLocalizedString(@"identification.id.document", @"") buttonImage:nil caption:NSLocalizedString(@"identification.id.description", @"") selectedCaption:NSLocalizedString(@"identification.id.selected.description", @"")];
        [idDocumentCell documentSelected:[PendingPayment isIdVerificationImagePresent]];
        idDocumentCell.delegate = self;
        self.idVerificationRowIndex = [photoCells count] - 1;
    }


    if ([self addressVerificationRequired]) {
        ValidationCell *proofOfAddressCell = [self.tableView dequeueReusableCellWithIdentifier:ValidationCellIdentifier];
        [self setProofOfAddressCell:proofOfAddressCell];
        [photoCells addObject:proofOfAddressCell];
        [proofOfAddressCell configureWithButtonTitle:NSLocalizedString(@"identification.proof.of.address", @"") buttonImage:nil caption:NSLocalizedString(@"identification.proof.of.address.description", @"") selectedCaption:NSLocalizedString(@"identification.proof.of.address.selected.description", @"")];
        [proofOfAddressCell documentSelected:[PendingPayment isAddressVerificationImagePresent]];
        proofOfAddressCell.delegate = self;
        self.addressVerificationRowIndex = [photoCells count] - 1;
    }

    if ([self paymentPurposeRequired]) {
        TextEntryCell *entryCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
        [self setPaymentPurposeCell:entryCell];
        [entryCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
        [photoCells addObject:entryCell];
        [entryCell.entryField addTarget:self action:@selector(validateInput) forControlEvents:UIControlEventAllEditingEvents];
        [entryCell configureWithTitle:NSLocalizedString(@"identification.payment.purpose", nil) value:self.proposedPaymentPurpose];
    }

    [self setPresentedSectionCells:@[photoCells]];
    [self.tableView reloadData];
}

- (BOOL)paymentPurposeRequired {
    return (self.identificationRequired & IdentificationPaymentPurposeRequired) == IdentificationPaymentPurposeRequired;
}

- (BOOL)addressVerificationRequired {
    return (self.identificationRequired & IdentificationAddressRequired) == IdentificationAddressRequired;
}

- (BOOL)idVerificationRequired {
    return (self.identificationRequired & IdentificationIdRequired) == IdentificationIdRequired;
}

#pragma mark - ValidationCell delegate

-(void)actionTappedOnValidationCell:(ValidationCell *)cell
{
    NSUInteger row = [self.presentedSectionCells[0] indexOfObject:cell];
    self.selectedRow = row;
    [self presentCameraController];
}

-(void)deleteTappedOnValidationCell:(ValidationCell *)cell
{
    NSUInteger row = [self.presentedSectionCells[0] indexOfObject:cell];
    if(row == self.idVerificationRowIndex)
    {
        [PendingPayment removeIdImage];
        [self.idDocumentCell documentSelected:NO];
    }
    else if (row == self.addressVerificationRowIndex)
    {
        [PendingPayment removeAddressImage];
        [self.proofOfAddressCell documentSelected:NO];
    }
    [self validateInput];
}

#pragma mark - Take photo

- (void)presentCameraController {

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }


    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.delegate = self;

    [self presentViewController:cameraUI animated:YES completion:nil];
}

#pragma mark - UIImagePickerController delegate

// For responding to the user tapping Cancel.
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:nil];
}

// For responding to the user accepting a newly-captured picture or movie
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __weak typeof(self) weakSelf =self;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];

        if (weakSelf.selectedRow == weakSelf.idVerificationRowIndex) {
            [PendingPayment setIdPhoto:originalImage];
            [weakSelf.idDocumentCell documentSelected:YES];
        } else if (weakSelf.selectedRow == weakSelf.addressVerificationRowIndex) {
            [PendingPayment setAddressPhoto:originalImage];
            [weakSelf.proofOfAddressCell documentSelected:YES];
        }

        [weakSelf.tableView reloadData];

        [picker dismissViewControllerAnimated:YES completion:nil];
        [weakSelf validateInput];
    });
}


#pragma mark - Continue
- (IBAction)skipTapped:(id)sender {
    [self complete:YES];
}

- (IBAction)continueClicked:(id)sender {
    [self complete:NO];
}

-(void)complete:(BOOL)skip
{
    __weak typeof(self) weakSelf = self;
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:self.completionMessage];
    
    
    if (skip) {
        [[GoogleAnalytics sharedInstance] sendAppEvent:@"Verification" withLabel:@"skipped"];
    } else {
        [[GoogleAnalytics sharedInstance] sendAppEvent:@"Verification" withLabel:@"sent"];
    }
    
    self.completionHandler(skip, [self.paymentPurposeCell.entryField text], ^(void){
        [hud hide];
    }, ^(NSError *error) {
        [hud hide];
        if (error) {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"identification.payment.error.title", nil) error:error];
            [alertView show];
        }
    },^(float progress){
        weakSelf.continueButton.progress = progress;
    });

    
}

- (BOOL)validateInput {

    int numberOfMissingFields = 0;
    int numberOfMissingDocuments = 0;
    int numberOfMissingReasons = 0;

    if ([self idVerificationRequired] && ![PendingPayment isIdVerificationImagePresent]) {
        numberOfMissingFields++;
        numberOfMissingDocuments++;
    }

    if ([self addressVerificationRequired] && ![PendingPayment isAddressVerificationImagePresent]) {
        numberOfMissingFields++;
        numberOfMissingDocuments++;
    }

    if ([self paymentPurposeRequired] && ![self.paymentPurposeCell.entryField.text hasValue]) {
        numberOfMissingFields++;
        numberOfMissingReasons++;
    }
    
    self.reasonIcon.image = nil;
    
    if (numberOfMissingFields <= 0)
    {
        self.skipButton.hidden = YES;
        self.continueButton.hidden = NO;
        User* user = [self.objectModel currentUser];
        [self.reasonTitle setText:[NSString stringWithFormat:NSLocalizedString(@"identification.well.done.format", @""),user.personalProfile.firstName]];

    }
    else
    {
        self.skipButton.hidden = NO;
        self.continueButton.hidden = YES;
        if(numberOfMissingFields == [self.presentedSectionCells[0] count])
        {
            self.reasonIcon.image = [UIImage imageNamed:@"icon_status_documents_needed"];
            [self.reasonTitle setText:NSLocalizedString(@"identification.reason.title", @"")];
        }
        else
        {
            if(numberOfMissingFields == 1)
            {
                [self.reasonTitle setText:[NSString stringWithFormat:NSLocalizedString(@"identification.good.single.format", @""),numberOfMissingFields]];
            }
            else
            {
                [self.reasonTitle setText:[NSString stringWithFormat:NSLocalizedString(@"identification.good.format", @""),numberOfMissingFields]];
            }

        }

    }

    return numberOfMissingFields<=0;
}

@end
