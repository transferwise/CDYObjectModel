//
//  PersonalProfileIdentificationViewController.m
//  Transfer
//
//  Created by Henri Mägi on 08.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PersonalProfileIdentificationViewController.h"
#import "UIColor+Theme.h"
#import "TextCell.h"
#import "BlueButton.h"
#import "NSMutableString+Issues.h"
#import "NSString+Validation.h"
#import "TRWAlertView.h"
#import "TRWProgressHUD.h"
#import "PaymentFlow.h"
#import "ObjectModel.h"
#import "PendingPayment.h"
#import "ObjectModel+PendingPayments.h"
#import "TextEntryCell.h"
#import "TransferBackButtonItem.h"
#import "UITableView+FooterPositioning.h"

@interface PersonalProfileIdentificationViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) TextCell *idDocumentCell;
@property (strong, nonatomic) TextCell *proofOfAddressCell;
@property (strong, nonatomic) IBOutlet UILabel *reasonTitle;
@property (strong, nonatomic) IBOutlet UILabel *excuseLabel;
@property (strong, nonatomic) IBOutlet UILabel *explanationLabel;
@property (strong, nonatomic) IBOutlet UILabel *skipLabel;
@property (strong, nonatomic) IBOutlet BlueButton *continueButton;
@property (strong, nonatomic) IBOutlet UISwitch *skipSwitch;
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

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;

    [self.reasonTitle setText:NSLocalizedString(@"identification.reason.title", @"")];
    [self.excuseLabel setText:NSLocalizedString(@"identification.excuse", @"")];
    [self.explanationLabel setText:NSLocalizedString(@"identification.explanation", @"")];
    [self.skipLabel setText:NSLocalizedString(@"identification.skip.send", @"")];
    if (self.proposedFooterButtonTitle) {
        [self.continueButton setTitle:self.proposedFooterButtonTitle forState:UIControlStateNormal];
    } else {
        [self.continueButton setTitle:NSLocalizedString(@"identification.upload.and.continue.button", @"") forState:UIControlStateNormal];
    }

    [self.tableView registerNib:[UINib nibWithNibName:@"TextCell" bundle:nil] forCellReuseIdentifier:TWTextCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
    [PendingPayment removePossibleImages];

    [self.skipSwitch setHidden:self.hideSkipOption];
    [self.skipLabel setHidden:self.hideSkipOption];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:NSLocalizedString(@"identification.controller.title", nil)];

    [self buildCells];

    [self.tableView adjustFooterViewSize];

    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonWithTapHandler:^{
        [self.navigationController popViewControllerAnimated:YES];
    }]];
}

- (void)buildCells {
    if ([self.presentedSectionCells count] > 0) {
        return;
    }

    NSMutableArray *photoCells = [NSMutableArray array];

    if ([self idVerificationRequired]) {
        TextCell *idDocumentCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
        [self setIdDocumentCell:idDocumentCell];
        [photoCells addObject:idDocumentCell];
        [idDocumentCell configureWithTitle:NSLocalizedString(@"identification.id.document", @"") text:NSLocalizedString(@"identification.take.photo", @"")];
        self.idVerificationRowIndex = [photoCells count] - 1;
    }


    if ([self addressVerificationRequired]) {
        TextCell *proofOfAddressCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
        [self setProofOfAddressCell:proofOfAddressCell];
        [photoCells addObject:proofOfAddressCell];
        [proofOfAddressCell configureWithTitle:NSLocalizedString(@"identification.proof.of.address", @"") text:NSLocalizedString(@"identification.take.photo", @"")];
        self.addressVerificationRowIndex = [photoCells count] - 1;
    }

    if ([self paymentPurposeRequired]) {
        TextEntryCell *entryCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
        [self setPaymentPurposeCell:entryCell];
        [entryCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
        [photoCells addObject:entryCell];
        [entryCell configureWithTitle:NSLocalizedString(@"identification.payment.puprose", nil) value:self.proposedPaymentPurpose];
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

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0 && (indexPath.row == self.idVerificationRowIndex || indexPath.row == self.addressVerificationRowIndex)) {
        [self presentCameraController];
        self.selectedRow = indexPath.row;
    }
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
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];

        if (self.selectedRow == self.idVerificationRowIndex) {
            [PendingPayment setIdPhoto:originalImage];
            self.idDocumentCell.detailTextLabel.text = @"";
            self.idDocumentCell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else if (self.selectedRow == self.addressVerificationRowIndex) {
            [PendingPayment setAddressPhoto:originalImage];
            self.proofOfAddressCell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.proofOfAddressCell.detailTextLabel.text = @"";
        }

        [self.tableView reloadData];

        [picker dismissViewControllerAnimated:YES completion:nil];
    });
}


#pragma mark - Continue

- (IBAction)continueClicked:(id)sender {
    NSString *issues = [self validateInput];
    if ([issues hasValue]) {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"identification.input.error.title", nil) message:issues];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
    [hud setMessage:self.completionMessage];

    self.completionHandler(self.skipSwitch.isOn, [self.paymentPurposeCell.entryField text], ^(NSError *error) {
        [hud hide];
        if (error) {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"identification.payment.error.title", nil) error:error];
            [alertView show];
        }
    });
}

- (NSString *)validateInput {
    if (self.skipSwitch.isOn) {
        return @"";
    }

    NSMutableString *issues = [NSMutableString string];

    if ([self idVerificationRequired] && ![PendingPayment isIdVerificationImagePresent]) {
        [issues appendIssue:NSLocalizedString(@"identification.id.image.missing.message", nil)];
    }

    if ([self addressVerificationRequired] && ![PendingPayment isAddressVerificationImagePresent]) {
        [issues appendIssue:NSLocalizedString(@"identification.address.image.missing.message", nil)];
    }

    if ([self paymentPurposeRequired] && ![self.paymentPurposeCell.entryField.text hasValue]) {
        [issues appendIssue:NSLocalizedString(@"identification.payment.purpose.missing.message", nil)];
    }

    return [NSString stringWithString:issues];
}

@end
