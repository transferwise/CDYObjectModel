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
    } else {
        [super fillDeliveryDetails:label];
    }
}

- (void)setCancelledDate:(OHAttributedLabel *)label {
    NSString *dateString = [self.payment cancelDateString];
    NSString *dateMessageString = [NSString stringWithFormat:NSLocalizedString(@"payment.detail.cancel.date.message", nil), dateString];
    NSAttributedString *paymentDateString = [self attributedStringWithBase:dateMessageString markedString:dateString];
    [label setAttributedText:paymentDateString];
}

@end
