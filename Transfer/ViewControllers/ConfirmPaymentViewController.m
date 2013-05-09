//
//  ConfirmPaymentViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 5/8/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ConfirmPaymentViewController.h"
#import "UIColor+Theme.h"
#import "ConfirmPaymentCell.h"
#import "ProfileDetails.h"
#import "PersonalProfile.h"

static NSUInteger const kReceiverSection = 1;

@interface ConfirmPaymentViewController ()

@property (nonatomic, strong) IBOutlet UIView *footerView;
@property (nonatomic, strong) IBOutlet UIButton *footerButton;
@property (nonatomic, strong) IBOutlet UIView *headerView;

@property (nonatomic, strong) ConfirmPaymentCell *senderNameCell;
@property (nonatomic, strong) ConfirmPaymentCell *senderEmailCell;
@property (nonatomic, strong) ConfirmPaymentCell *receiverNameCell;
@property (nonatomic, strong) NSArray *receiverFieldCells;
@property (nonatomic, strong) ConfirmPaymentCell *referenceCell;
@property (nonatomic, strong) ConfirmPaymentCell *receiverEmailCell;

- (IBAction)footerButtonPressed:(id)sender;

@end

@implementation ConfirmPaymentViewController

- (id)init {
    self = [super initWithNibName:@"ConfirmPaymentViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];

    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView setTableFooterView:self.footerView];

    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmPaymentCell" bundle:nil] forCellReuseIdentifier:TWRConfirmPaymentCellIdentifier];

    NSMutableArray *senderCells = [NSMutableArray array];
    ConfirmPaymentCell *senderNameCell = [self.tableView dequeueReusableCellWithIdentifier:TWRConfirmPaymentCellIdentifier];
    [self setSenderNameCell:senderNameCell];
    [senderNameCell.imageView setImage:[UIImage imageNamed:@"ProfileIcon.png"]];
    [senderCells addObject:senderNameCell];

    ConfirmPaymentCell *senderEmailCell = [self.tableView dequeueReusableCellWithIdentifier:TWRConfirmPaymentCellIdentifier];
    [self setSenderEmailCell:senderEmailCell];
    [senderCells addObject:senderEmailCell];

    NSMutableArray *receiverCells = [NSMutableArray array];
    ConfirmPaymentCell *receiverNameCell = [self.tableView dequeueReusableCellWithIdentifier:TWRConfirmPaymentCellIdentifier];
    [self setReceiverNameCell:receiverNameCell];
    [receiverNameCell.imageView setImage:[UIImage imageNamed:@"ProfileIcon.png"]];
    [receiverCells addObject:receiverNameCell];

    NSArray *fieldCells = @[];
    [self setReceiverFieldCells:fieldCells];
    [receiverCells addObjectsFromArray:fieldCells];

    ConfirmPaymentCell *referenceCell = [self.tableView dequeueReusableCellWithIdentifier:TWRConfirmPaymentCellIdentifier];
    [self setReferenceCell:referenceCell];
    [receiverCells addObject:referenceCell];

    ConfirmPaymentCell *receiverEmailCell = [self.tableView dequeueReusableCellWithIdentifier:TWRConfirmPaymentCellIdentifier];
    [self setReceiverEmailCell:receiverEmailCell];
    [receiverCells addObject:receiverEmailCell];

    [self setPresentedSectionCells:@[senderCells, receiverCells]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:NSLocalizedString(@"confirm.payment.controller.title", nil)];

    [self fillDataCells];
}

- (void)fillDataCells {
    [self.senderNameCell.textLabel setText:[self.senderDetails.personalProfile fullName]];
    [self.senderNameCell.detailTextLabel setText:NSLocalizedString(@"confirm.payment.sender.marker.label", nil)];

    [self.senderEmailCell.textLabel setText:NSLocalizedString(@"confirm.payment.email.label", nil)];
    [self.senderEmailCell.detailTextLabel setText:self.senderDetails.email];
}

- (IBAction)footerButtonPressed:(id)sender {

}

@end
