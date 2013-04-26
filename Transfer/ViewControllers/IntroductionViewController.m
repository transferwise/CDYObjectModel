//
//  IntroductionViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "IntroductionViewController.h"
#import "TableHeaderView.h"
#import "MoneyEntryCell.h"
#import "LoginViewController.h"
#import "UIColor+Theme.h"
#import "UIView+Loading.h"
#import "MoneyCalculator.h"
#import "Constants.h"
#import "CalculationResult.h"
#import "WhyView.h"
#import "TSAlertView.h"
#import <OHAttributedLabel/OHAttributedLabel.h>
#import <OHAttributedLabel/NSAttributedString+Attributes.h>
#import <OHAttributedLabel/OHASBasicMarkupParser.h>

static NSUInteger const kRowYouSend = 0;

@interface IntroductionViewController () <UITextFieldDelegate, OHAttributedLabelDelegate>

@property (nonatomic, strong) IBOutlet UIView *controlsView;
@property (nonatomic, strong) IBOutlet OHAttributedLabel *savingsLabel;
@property (nonatomic, strong) IBOutlet UILabel *loginTitle;
@property (nonatomic, strong) IBOutlet UIButton *startedButton;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) MoneyEntryCell *youSendCell;
@property (nonatomic, strong) MoneyEntryCell *theyReceiveCell;
@property (nonatomic, strong) MoneyCalculator *calculator;
@property (nonatomic, strong) CalculationResult *result;

- (IBAction)loginPressed:(id)sender;

@end
@implementation IntroductionViewController

- (id)init {
    self = [super initWithNibName:@"IntroductionViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];

    [self.tableView registerNib:[UINib nibWithNibName:@"MoneyEntryCell" bundle:nil] forCellReuseIdentifier:TWMoneyEntryCellIdentifier];

    [self setYouSendCell:[self.tableView dequeueReusableCellWithIdentifier:TWMoneyEntryCellIdentifier]];
    [self.youSendCell setTitle:NSLocalizedString(@"money.entry.you.send.title", nil)];
    [self.youSendCell setAmount:@"1000.00" currency:@"EUR"];
    [self.youSendCell.moneyField setDelegate:self];
    [self.youSendCell.moneyField setReturnKeyType:UIReturnKeyDone];

    [self setTheyReceiveCell:[self.tableView dequeueReusableCellWithIdentifier:TWMoneyEntryCellIdentifier]];
    [self.theyReceiveCell setTitle:NSLocalizedString(@"money.entry.they.receive.title", nil)];
    [self.theyReceiveCell setAmount:@"" currency:@"GBP"];
    [self.theyReceiveCell.moneyField setDelegate:self];
    [self.theyReceiveCell.moneyField setReturnKeyType:UIReturnKeyDone];

    TableHeaderView *header = [TableHeaderView loadInstance];
    [header setMessage:NSLocalizedString(@"introduction.header.title.text", nil)];
    [self.tableView setTableHeaderView:header];
    [self.tableView setTableFooterView:self.controlsView];

    [self.savingsLabel setText:@""];
    [self.savingsLabel setTextColor:[UIColor mainTextColor]];
    [self.loginTitle setText:NSLocalizedString(@"introduction.login.section.title", nil)];
    [self.loginTitle setTextColor:[UIColor mainTextColor]];

    [self.startedButton setTitle:NSLocalizedString(@"button.title.get.started", nil) forState:UIControlStateNormal];
    [self.loginButton setTitle:NSLocalizedString(@"button.title.log.in", nil) forState:UIControlStateNormal];

    MoneyCalculator *calculator = [[MoneyCalculator alloc] init];
    [self setCalculator:calculator];

    [calculator setSendCell:self.youSendCell];
    [calculator setReceiveCell:self.theyReceiveCell];

    [calculator setCalculationHandler:^(CalculationResult *result, NSError *error) {
        if (error) {
            MCLog(@"Calculation error:%@", error);
            return;
        }
        self.result = result;
        NSString* txt = [NSMutableString stringWithFormat:@"%@. %@", [NSString stringWithFormat:NSLocalizedString(@"introduction.savings.message.base", nil), [result formattedWinAmount]], NSLocalizedString(@"introduction.savings.message.why", nil)];
        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:txt];
        
        OHParagraphStyle* paragraphStyle = [OHParagraphStyle defaultParagraphStyle];
        paragraphStyle.textAlignment = kCTTextAlignmentCenter;
        paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
        [attrStr setParagraphStyle:paragraphStyle];
        [attrStr setFont:self.savingsLabel.font];
        
        NSString* linkURLString = @"why:"; // build the "why" link
        [attrStr setLink:[NSURL URLWithString:linkURLString] range:[txt rangeOfString:NSLocalizedString(@"introduction.savings.message.why", nil)]];
        self.savingsLabel.attributedText = attrStr;
    }];

    [calculator forceCalculate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:NSLocalizedString(@"introduction.controller.title", nil)];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kRowYouSend) {
        return self.youSendCell;
    }

    return self.theyReceiveCell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == kRowYouSend) {
        [self.youSendCell.moneyField becomeFirstResponder];
    } else {
        [self.theyReceiveCell.moneyField becomeFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)loginPressed:(id)sender {
    LoginViewController *controller = [[LoginViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)whyPressed:(id)sender {
    WhyView *whyView = [[WhyView alloc] init];
    [whyView setupWithResult:self.result];
    TSAlertView *alert = [[TSAlertView alloc]initWithTitle:whyView.title view:whyView delegate:nil cancelButtonTitle:NSLocalizedString(@"whypopup.button", nil) otherButtonTitles:nil];
    [alert show];
}

/////////////////////////////////////////////////////////////////////////////
#pragma mark - OHAttributedString Delegate Method
/////////////////////////////////////////////////////////////////////////////


-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
	if ([[linkInfo.URL scheme] isEqualToString:@"why"])
    {
        WhyView *whyView = [[WhyView alloc] init];
        [whyView setupWithResult:self.result];
        TSAlertView *alert = [[TSAlertView alloc]initWithTitle:whyView.title view:whyView delegate:nil cancelButtonTitle:NSLocalizedString(@"whypopup.button", nil) otherButtonTitles:nil];
        [alert show];
		return NO;
	}
    else
    {
        return NO;
	}
}


@end
