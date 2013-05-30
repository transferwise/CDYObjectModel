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
#import "PaymentVerificationRequired.h"
#import "NSMutableString+Issues.h"
#import "NSString+Validation.h"
#import "TRWAlertView.h"

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

    NSMutableArray *photoCells = [NSMutableArray array];

    if (self.requiredVerification.idVerificationRequired) {
        TextCell *idDocumentCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
        [self setIdDocumentCell:idDocumentCell];
        [photoCells addObject:idDocumentCell];
        [idDocumentCell configureWithTitle:NSLocalizedString(@"identification.id.document", @"") text:NSLocalizedString(@"identification.take.photo", @"")];
        self.idVerificationRowIndex = [photoCells count] - 1;
    }


    if (self.requiredVerification.addressVerificationRequired) {
        TextCell *proofOfAddressCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
        [self setProofOfAddressCell:proofOfAddressCell];
        [photoCells addObject:proofOfAddressCell];
        [proofOfAddressCell configureWithTitle:NSLocalizedString(@"identification.proof.of.address", @"") text:NSLocalizedString(@"identification.take.photo", @"")];
        self.addressVerificationRowIndex = [photoCells count] - 1;
    }

    [self setPresentedSectionCells:@[photoCells]];

    [self.requiredVerification removePossibleImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:NSLocalizedString(@"identification.controller.title", nil)];
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

    [self presentModalViewController:cameraUI animated:YES];
}

#pragma mark - UIImagePickerController delegate

// For responding to the user tapping Cancel.
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissModalViewControllerAnimated:YES];
}

// For responding to the user accepting a newly-captured picture or movie
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];

    if (self.selectedRow == self.idVerificationRowIndex) {
        [self.requiredVerification setIdPhoto:originalImage];
        self.idDocumentCell.detailTextLabel.text = @"";
        self.idDocumentCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (self.selectedRow == self.addressVerificationRowIndex) {
        [self.requiredVerification setAddressPhoto:originalImage];
        self.proofOfAddressCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.proofOfAddressCell.detailTextLabel.text = @"";
    }

    [picker dismissModalViewControllerAnimated:YES];
}


#pragma mark - Continue

- (IBAction)continueClicked:(id)sender {
    [self.requiredVerification setSendLater:self.skipSwitch.isOn];

    NSString *issues = [self validateInput];
    if ([issues hasValue]) {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"identification.input.error.title", nil) message:issues];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }
}

- (NSString *)validateInput {
    if (self.requiredVerification.sendLater) {
        return @"";
    }

    NSMutableString *issues = [NSMutableString string];

    if (self.requiredVerification.idVerificationRequired && !self.requiredVerification.isIdVerificationImagePresent) {
        [issues appendIssue:NSLocalizedString(@"identification.id.image.missing.message", nil)];
    } else if (self.requiredVerification.addressVerificationRequired && !self.requiredVerification.isAddressVerificationImagePresent) {
        [issues appendIssue:NSLocalizedString(@"identification.address.image.missing.message", nil)];
    }

    return [NSString stringWithString:issues];
}

- (void)viewDidUnload {
    [self setReasonTitle:nil];
    [self setExcuseLabel:nil];
    [self setExplanationLabel:nil];
    [self setSkipLabel:nil];
    [self setContinueButton:nil];
    [self setSkipSwitch:nil];
    [super viewDidUnload];
}
@end
