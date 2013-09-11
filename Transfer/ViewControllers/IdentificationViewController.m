//
//  IdentificationViewController.m
//  Transfer
//
//  Created by Henri Mägi on 08.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "IdentificationViewController.h"
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

@interface IdentificationViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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

@implementation IdentificationViewController

- (id)init {
    self = [super initWithNibName:@"IdentificationViewController" bundle:nil];
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
    [self.continueButton setTitle:NSLocalizedString(@"identification.upload.and.continue.button", @"") forState:UIControlStateNormal];

    [self.tableView registerNib:[UINib nibWithNibName:@"TextCell" bundle:nil] forCellReuseIdentifier:TWTextCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
    [PendingPayment removePossibleImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:NSLocalizedString(@"identification.controller.title", nil)];

    [self buildCells];
}

- (void)buildCells {
    NSMutableArray *photoCells = [NSMutableArray array];

    PendingPayment *payment = [self.objectModel pendingPayment];

    if ([payment idVerificationRequiredValue]) {
        TextCell *idDocumentCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
        [self setIdDocumentCell:idDocumentCell];
        [photoCells addObject:idDocumentCell];
        [idDocumentCell configureWithTitle:NSLocalizedString(@"identification.id.document", @"") text:NSLocalizedString(@"identification.take.photo", @"")];
        self.idVerificationRowIndex = [photoCells count] - 1;
    }


    if ([payment addressVerificationRequiredValue]) {
        TextCell *proofOfAddressCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
        [self setProofOfAddressCell:proofOfAddressCell];
        [photoCells addObject:proofOfAddressCell];
        [proofOfAddressCell configureWithTitle:NSLocalizedString(@"identification.proof.of.address", @"") text:NSLocalizedString(@"identification.take.photo", @"")];
        self.addressVerificationRowIndex = [photoCells count] - 1;
    }

    if ([payment paymentPurposeRequiredValue]) {
        TextEntryCell *entryCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
        [self setPaymentPurposeCell:entryCell];
        [photoCells addObject:entryCell];
        [entryCell configureWithTitle:NSLocalizedString(@"identification.payment.puprose", nil) value:[payment proposedPaymentsPurpose]];
    }

    [self setPresentedSectionCells:@[photoCells]];
    [self.tableView reloadData];
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
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

    PendingPayment *payment = [self.objectModel pendingPayment];
    [payment setSendVerificationLaterValue:self.skipSwitch.isOn];
    [payment setPaymentPurpose:[self.paymentPurposeCell.entryField text]];

    [self.objectModel saveContext:^{
        TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
        [hud setMessage:NSLocalizedString(@"identification.creating.payment.message", nil)];

        [self.paymentFlow commitPaymentWithErrorHandler:^(NSError *error) {
            [hud hide];
            if (error) {
                TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"identification.payment.error.title", nil) error:error];
                [alertView show];
            }
        }];
    }];
}

- (NSString *)validateInput {
    if (self.skipSwitch.isOn) {
        return @"";
    }

    PendingPayment *payment = [self.objectModel pendingPayment];

    NSMutableString *issues = [NSMutableString string];

    if ([payment idVerificationRequiredValue] && ![PendingPayment isIdVerificationImagePresent]) {
        [issues appendIssue:NSLocalizedString(@"identification.id.image.missing.message", nil)];
    }

    if ([payment addressVerificationRequiredValue] && ![PendingPayment isAddressVerificationImagePresent]) {
        [issues appendIssue:NSLocalizedString(@"identification.address.image.missing.message", nil)];
    }

    if ([payment paymentPurposeRequiredValue] && ![self.paymentPurposeCell.entryField.text hasValue]) {
        [issues appendIssue:NSLocalizedString(@"identification.payment.purpose.missing.message", nil)];
    }

    return [NSString stringWithString:issues];
}

@end
