//
//  PaymentDetailsViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 8/7/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <OHAttributedLabel/OHAttributedLabel.h>
#import "PaymentDetailsViewController.h"
#import "Payment.h"
#import "TextEntryCell.h"
#import "TableHeaderView.h"
#import "UIView+Loading.h"

@interface PaymentDetailsViewController ()

@end

@implementation PaymentDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:self.payment.localizedStatus];

    [self disableAllCells];

    [self.tableView setTableFooterView:nil];
}

- (void)disableAllCells {
    for (NSArray *sectionCells in self.presentedSectionCells) {
        for (UITableViewCell *cell in sectionCells) {
            if (![cell isKindOfClass:[TextEntryCell class]]) {
                continue;
            }

            TextEntryCell *entryCell = (TextEntryCell *) cell;
            [entryCell setEditable:NO];
        }
    }
}

- (void)fillDeliveryDetails:(OHAttributedLabel *)label {
    if ([self.payment isCancelled]) {
        [self setCancelledDate:label];
        return;
    } else if ([self.payment moneyTransferred]) {
        [self setTransferredDate:label];

        TableHeaderView *headerView = [TableHeaderView loadInstance];
        [headerView setMessage:[NSString stringWithFormat:NSLocalizedString(@"payment.detail.sent.header.message", nil), self.payment.remoteId]];
        [self.tableView setTableHeaderView:headerView];
        return;
    } else {
        [super fillDeliveryDetails:label];

        TableHeaderView *headerView = [TableHeaderView loadInstance];
        [headerView setMessage:[NSString stringWithFormat:NSLocalizedString(@"payment.detail.converting.header.message", nil), self.payment.remoteId]];
        [self.tableView setTableHeaderView:headerView];
    }
}

- (void)setTransferredDate:(OHAttributedLabel *)label {
    NSString *rateString = [self.payment rateString];
    NSString *messageString = [NSString stringWithFormat:NSLocalizedString(@"payment.detail.exchange.rate.message", nil), rateString];
    NSAttributedString *exchangeRateString = [self attributedStringWithBase:messageString markedString:rateString];

    NSString *dateString = [self.payment transferredDateString];
    NSString *dateMessageString = [NSString stringWithFormat:NSLocalizedString(@"payment.detail.transferred.date.message", nil), dateString];
    NSAttributedString *paymentDateString = [self attributedStringWithBase:dateMessageString markedString:dateString];

    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    [result appendAttributedString:exchangeRateString];
    [result appendAttributedString:[NSAttributedString attributedStringWithString:@"\n"]];
    [result appendAttributedString:paymentDateString];

    [label setAttributedText:result];
}

- (void)setCancelledDate:(OHAttributedLabel *)label {
    NSString *dateString = [self.payment cancelDateString];
    NSString *dateMessageString = [NSString stringWithFormat:NSLocalizedString(@"payment.detail.cancel.date.message", nil), dateString];
    NSAttributedString *paymentDateString = [self attributedStringWithBase:dateMessageString markedString:dateString];
    [label setAttributedText:paymentDateString];
}

@end
