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
#import "MOMStyle.h"
#import "NetworkErrorCodes.h"
#import "Mixpanel+Customisation.h"
#import "ObjectModel+PendingPayments.h"

#define textCellHeight (IPAD?70.0f:60.0f)

@interface PersonalProfileIdentificationViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ValidationCellDelegate, UIAlertViewDelegate>

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
@property (nonatomic, strong) TextEntryCell *ssnCell;
@property (nonatomic, strong) TextEntryCell *paymentPurposeCell;

@property (nonatomic, assign) float uploadProgressId,uploadProgressAddress;

@property (nonatomic, assign) BOOL hideSSN;
@property (nonatomic, assign) BOOL hideID;

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
    [self.tableView registerNib:[UINib nibWithNibName:IPAD?@"TextEntryCellValidation":@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
    
    [[GoogleAnalytics sharedInstance] sendScreen:GAPersonalVerification];
    if(self.objectModel.pendingPayment)
    {
        [[Mixpanel sharedInstance] sendPageView:MPVerification withProperties:[self.objectModel.pendingPayment trackingProperties]];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self buildCells];

    NSInteger numberOfDocuments = [self numberOfDocumentsNeeded];
    if(numberOfDocuments > 1)
    {
        [self.navigationItem setTitle:[NSString stringWithFormat:NSLocalizedString(IPAD?@"identification.controller.title.ipad":@"identification.controller.title", nil), numberOfDocuments]];
    }
    else if(numberOfDocuments == 1)
    {
        [self.navigationItem setTitle:[NSString stringWithFormat:NSLocalizedString(IPAD?@"identification.controller.single.title.ipad":@"identification.controller.single.title", nil), numberOfDocuments]];
    }
    else
    {
        [self.navigationItem setTitle:NSLocalizedString(IPAD?@"identification.only.purpose":@"identification.controller.fields.title", nil)];
    }

    [self.tableView adjustFooterViewSize];

    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];
    
    [self validateInput];
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

    if ([self ssnVerificationRequired]) {
        TextEntryCell *entryCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
        [self setSsnCell:entryCell];
        entryCell.clipsToBounds = YES;
        entryCell.entryField.keyboardType = UIKeyboardTypeNumberPad;
        [photoCells addObject:entryCell];
        [entryCell.entryField addTarget:self action:@selector(validateInput) forControlEvents:UIControlEventAllEditingEvents];
        [entryCell configureWithTitle:NSLocalizedString(@"identification.ssn", nil) value:@""];
        entryCell.presentationPattern = @"***-**-****";
        if(IPAD)
        {
            CGRect newFrame = entryCell.separatorLine.frame;
            newFrame.size.height = 1.0f/[[UIScreen mainScreen] scale];
            entryCell.separatorLine.frame=newFrame;
        }
    }
    
    if ([self idVerificationRequired]) {
        ValidationCell *idDocumentCell = [self.tableView dequeueReusableCellWithIdentifier:ValidationCellIdentifier];
        [self setIdDocumentCell:idDocumentCell];
        [photoCells addObject:idDocumentCell];
        [idDocumentCell configureWithButtonTitle:NSLocalizedString(@"identification.id.document", @"") buttonImage:[UIImage imageNamed:@"camera_icon_button"] caption:NSLocalizedString(self.driversLicenseFirst?@"identification.id.description.drivers.first":@"identification.id.description", @"") selectedCaption:NSLocalizedString(@"identification.id.selected.description", @"")];
        [idDocumentCell documentSelected:[PendingPayment isIdVerificationImagePresent]];
        idDocumentCell.delegate = self;
        idDocumentCell.contentView.bgStyle = @"lightblueHighlighted.alpha4";
        self.idVerificationRowIndex = [photoCells count] - 1;
    }


    if ([self addressVerificationRequired]) {
        ValidationCell *proofOfAddressCell = [self.tableView dequeueReusableCellWithIdentifier:ValidationCellIdentifier];
        [self setProofOfAddressCell:proofOfAddressCell];
        [photoCells addObject:proofOfAddressCell];
        [proofOfAddressCell configureWithButtonTitle:NSLocalizedString(@"identification.proof.of.address", @"") buttonImage:[UIImage imageNamed:@"camera_icon_button"] caption:NSLocalizedString(@"identification.proof.of.address.description", @"") selectedCaption:NSLocalizedString(@"identification.proof.of.address.selected.description", @"")];
        [proofOfAddressCell documentSelected:[PendingPayment isAddressVerificationImagePresent]];
        proofOfAddressCell.delegate = self;
        proofOfAddressCell.contentView.bgStyle = @"lightblueHighlighted";
        self.addressVerificationRowIndex = [photoCells count] - 1;
    }

    
    if ([self paymentPurposeRequired]) {
        TextEntryCell *entryCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
        [self setPaymentPurposeCell:entryCell];
        [entryCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
        [photoCells addObject:entryCell];
        [entryCell.entryField addTarget:self action:@selector(validateInput) forControlEvents:UIControlEventAllEditingEvents];
        [entryCell configureWithTitle:NSLocalizedString(@"identification.payment.purpose", nil) value:self.proposedPaymentPurpose];
        if(IPAD)
        {
            CGRect newFrame = entryCell.separatorLine.frame;
            newFrame.size.height = 1.0f/[[UIScreen mainScreen] scale];
            entryCell.separatorLine.frame=newFrame;
        }
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

- (BOOL)ssnVerificationRequired {
    return NO; //Disable SSN as it's not working  (self.identificationRequired & IdentificationSSNRequired) == IdentificationSSNRequired;
}

#pragma mark - ValidationCell delegate

-(void)actionTappedOnValidationCell:(ValidationCell *)cell
{
    [self validateInput];
    if([self ssnVerificationRequired] && cell == self.idDocumentCell)
    {
        if(self.hideID)
            return;
    }
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
            if(self.ssnCell)
            {
                self.ssnCell.value = @"";
            }
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
    NSString *inputValidationError = [self validateEnteredText];
    if(inputValidationError)
    {
        [[GoogleAnalytics sharedInstance] sendAlertEvent:GAVerificationalert withLabel:inputValidationError];
        TRWAlertView *alert = [[TRWAlertView alloc] initWithTitle:NSLocalizedString(@"identification.error",nil) message:inputValidationError delegate:nil cancelButtonTitle:NSLocalizedString(@"button.title.ok",nil) otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [self complete:NO];
    }
}

-(void)complete:(BOOL)skip
{    
	TRWProgressHUD *hud;
	hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
	[hud setMessage:self.completionMessage];
	
    if (!skip)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:TRWUploadProgressNotification object:nil];
    }
    
    self.completionHandler(skip, [self.paymentPurposeCell.entryField text], [[self.ssnCell.entryField text] stringByReplacingOccurrencesOfString:@"-" withString:@""], ^(void){
		[hud hide];
		if (!skip)
		{
            [[GoogleAnalytics sharedInstance] sendAppEvent:GAVerification withLabel:@"sent"];
			[[NSNotificationCenter defaultCenter] removeObserver:self name:TRWUploadProgressNotification object:nil];
		}
        else
        {
            [[GoogleAnalytics sharedInstance] sendAppEvent:GAVerification withLabel:@"skipped"];
        }
		[PendingPayment removePossibleImages];
    }, ^(NSError *error) {
        [hud hide];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:TRWUploadProgressNotification object:nil];
        if (error) {
            
            //Check for SSN specific errors
            NSArray *errors = error.userInfo[TRWErrors];
            NSString* message;
            for (NSDictionary* errorDictionary in errors)
            {
                NSString *code = errorDictionary[@"code"];
                if([code rangeOfString:@"SSN"].location != NSNotFound || [code isEqualToString:@"PROFILE_INVALID"])
                {
                    message = NSLocalizedString(@"identification.ssn.generic.error", nil);
                }

            }
            
            
            TRWAlertView *alertView;
            if(message)
            {
                alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"identification.ssn.error.title", nil) message:message];
                [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                alertView.delegate = self;
            }
            else
            {
                alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"identification.payment.error.title", nil) error:error];
            }
            [alertView show];
            [[GoogleAnalytics sharedInstance] sendAlertEvent:GAVerificationalert withLabel:alertView.message];
            self.continueButton.progress = 0.0f;
        }
    });
}

- (BOOL)validateInput {

    int numberOfMissingFields = 0;
    int numberOfMissingDocuments = 0;
    BOOL missingReason = NO;

    if ([self addressVerificationRequired] && ![PendingPayment isAddressVerificationImagePresent]) {
        numberOfMissingFields++;
        numberOfMissingDocuments++;
    }

    if ([self paymentPurposeRequired] && ![self.paymentPurposeCell.entryField.text hasValue]) {
        numberOfMissingFields++;
        missingReason = YES;
    }
    
    if ([self ssnVerificationRequired])
    {
        // If SSNVerification requires an SSN OR uploaded Id
        BOOL idBefore = self.hideID;
        BOOL ssnBefore = self.hideSSN;
        self.hideSSN = NO;
        self.hideID = NO;
        if([self idVerificationRequired] && ![PendingPayment isIdVerificationImagePresent] && [[self.ssnCell value] length] < 11) {
            numberOfMissingFields +=2;
            numberOfMissingDocuments++;
        }
        else if (![self.ssnCell.entryField.text hasValue])
        {
            self.hideSSN = YES;
        }
        else
        {
            self.hideID = YES;
        }
        
        if(idBefore != self.hideID || ssnBefore != self.hideSSN)
        {
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }
    }
    else
    {
        if ([self idVerificationRequired] && ![PendingPayment isIdVerificationImagePresent]) {
            numberOfMissingFields++;
            numberOfMissingDocuments++;
        }
    }
    
    self.reasonIcon.image = nil;
    
    if (numberOfMissingFields <= 0)
    {
        self.skipButton.hidden = YES;
        self.continueButton.hidden = NO;
        User* user = [self.objectModel currentUser];
        if(IPAD)
        {
            [self.navigationItem setTitle:[NSString stringWithFormat:NSLocalizedString(@"identification.well.done.format", @""),user.personalProfile.firstName]];
        }
        else
        {
            [self.reasonTitle setText:[NSString stringWithFormat:NSLocalizedString(@"identification.well.done.format", @""),user.personalProfile.firstName]];
        }

    }
    else
    {
        self.skipButton.hidden = NO;
        self.continueButton.hidden = YES;
        if(numberOfMissingFields == [self.presentedSectionCells[0] count])
        {
            if(IPAD)
            {
                NSInteger numberOfDocuments = [self numberOfDocumentsNeeded];
                if(numberOfDocuments > 1)
                {
                    [self.navigationItem setTitle:[NSString stringWithFormat:NSLocalizedString(IPAD?@"identification.controller.title.ipad":@"identification.controller.title", nil), numberOfDocuments]];
                }
                else if(numberOfDocuments == 1)
                {
                    [self.navigationItem setTitle:[NSString stringWithFormat:NSLocalizedString(IPAD?@"identification.controller.single.title.ipad":@"identification.controller.single.title", nil), numberOfDocuments]];
                }
                else
                {
                    [self.navigationItem setTitle:NSLocalizedString(@"identification.only.purpose", nil)];
                }
            }
            else
            {
                self.reasonIcon.image = [UIImage imageNamed:@"icon_status_documents_needed"];
                [self.reasonTitle setText:NSLocalizedString(@"identification.reason.title", @"")];
            }
        }
        else
        {
            if(numberOfMissingDocuments == 1)
            {
                if(IPAD)
                {
                    [self.navigationItem setTitle:NSLocalizedString(@"identification.good.single.ipad", nil)];
                }
                else
                {
                    [self.reasonTitle setText:[NSString stringWithFormat:NSLocalizedString(@"identification.good.single.format", @""),numberOfMissingDocuments]];
                }
            }
            else if(numberOfMissingDocuments > 0)
            {
                if(IPAD)
                {
                    [self.navigationItem setTitle:[NSString stringWithFormat:NSLocalizedString(@"identification.controller.title.ipad", nil),numberOfMissingDocuments]];
                }
                else
                {
                    [self.reasonTitle setText:[NSString stringWithFormat:NSLocalizedString(@"identification.good.format", @""),numberOfMissingDocuments]];
                }
            }
            else if(numberOfMissingFields >1)
            {
                if(IPAD)
                {
                    [self.navigationItem setTitle:NSLocalizedString(@"identification.fields", nil)];
                }
                else
                {
                    [self.reasonTitle setText:NSLocalizedString(@"identification.fields", nil)];
                }
            }
            else if(missingReason)
            {
                
                if(IPAD)
                {
                    [self.navigationItem setTitle:NSLocalizedString(@"identification.only.purpose", nil)];
                }
                else
                {
                    [self.reasonTitle setText:NSLocalizedString(@"identification.only.purpose", nil)];
                }
            }
            else
            {
                if(IPAD)
                {
                    [self.navigationItem setTitle:NSLocalizedString(@"identification.only.ssn", nil)];
                }
                else
                {
                    [self.reasonTitle setText:NSLocalizedString(@"identification.only.ssn", nil)];
                }
            }

        }

    }
    
    [self resizeHeader];
    
    return numberOfMissingFields<=0;
}

-(NSString*)validateEnteredText
{
    if([[self.ssnCell value] hasValue] && [[self.ssnCell value] length] < 11)
    {
        return NSLocalizedString(@"identification.ssn.short",nil);
    }
    return nil;
}

/**
 *  Resize the header to take account of any error messages
 */

- (void) resizeHeader
{
    CGRect headerFrame = self.headerView.frame;
    CGRect reasonFrame = self.reasonTitle.frame;
   [self.reasonTitle sizeToFit];
    
    headerFrame.size.height = headerFrame.size.height - reasonFrame.size.height + self.reasonTitle.frame.size.height;
    reasonFrame.size.height = self.reasonTitle.frame.size.height;
    
    self.headerView.frame = headerFrame;
    self.reasonTitle.frame = reasonFrame;
    
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView reloadData];
}

#pragma mark - number helpers
-(NSInteger)numberOfDocumentsNeeded
{
    if([self addressVerificationRequired] && [self idVerificationRequired])
    {
        return 2;
    }
    else if ([self addressVerificationRequired] || [self idVerificationRequired])
    {
        return 1;
    }
    return 0;
}

#pragma mark - upload progress

-(void)updateProgress:(NSNotification*)note{
    NSDictionary* userInfo = note.userInfo;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *file = userInfo[TRWUploadFileKey];
        if([@"id" caseInsensitiveCompare:file] == NSOrderedSame)
        {
            self.uploadProgressId = [userInfo[TRWUploadProgressKey] floatValue];
        }
        else if ([@"address" caseInsensitiveCompare:file] == NSOrderedSame)
        {
            self.uploadProgressAddress = [userInfo[TRWUploadProgressKey] floatValue];
        }
        
        float progress = self.uploadProgressAddress + self.uploadProgressId;
        
        if(self.identificationRequired && self.addressVerificationRowIndex != NSNotFound)
        {
            progress /= 2;
        }
        
        [self.continueButton setProgress:progress animated:YES];
    });
    
}

#pragma mark - keyboard show/hide

-(void)keyboardWillShow:(NSNotification *)note
{
    if(!IPAD)
    {
        [super keyboardWillShow:note];
    }
    else
    {
        
        CGRect newframe = [self.view.window convertRect:[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] toView:self.view];
        NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:curve];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, newframe.size.height, 0);
        [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:self.paymentPurposeCell] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [UIView commitAnimations];
    }
}

-(void)keyboardWillHide:(NSNotification *)note
{
    if (!IPAD)
    {
        [super keyboardWillHide:note];
    }
    else
    {
        
        NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:curve];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.tableView.contentInset = UIEdgeInsetsZero;
        self.tableView.contentOffset = CGPointZero;
        [UIView commitAnimations];
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.ssnCell.value = @"";
    [self validateInput];
}

#pragma mark - textfield delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.ssnCell.entryField)
    {
        NSCharacterSet* excludedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
        if([string rangeOfCharacterFromSet:excludedCharacters].location != NSNotFound)
        {
            return NO;
        }
        
    }
    return [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

#pragma mark - Tableview data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.presentedSectionCells[0][indexPath.row];
    if([self ssnVerificationRequired])
    {
        if(cell == self.idDocumentCell)
        {
            ValidationCell* validationCell = (ValidationCell*) cell;
            return self.hideID?0.0f:[validationCell requiredHeight];
        }
        else if (cell == self.ssnCell)
        {
            return self.hideSSN?0.0f:textCellHeight;
        }
    }
    
    if([cell isKindOfClass:[ValidationCell class]])
    {
        return [((ValidationCell*)cell) requiredHeight];
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
@end
