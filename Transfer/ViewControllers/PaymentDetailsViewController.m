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
#import "SupportCoordinator.h"
#import "UINavigationController+StackManipulations.h"
#import "GoogleAnalytics.h"
#import "Currency.h"
#import "Recipient.h"

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

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if (self.flattenStack) {
		[self.navigationController flattenStack];
	}
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
        if(!self.payment.targetCurrency.paymentReferenceAllowedValue)
        {
            [self appendReferenceMessageToLabel:label];
        }

        TableHeaderView *headerView = [TableHeaderView loadInstance];
        [headerView setMessage:[NSString stringWithFormat:NSLocalizedString(@"payment.detail.sent.header.message", nil), self.payment.remoteId]];
        [self.tableView setTableHeaderView:headerView];
        return;
    } else {
        if(!self.payment.targetCurrency.paymentReferenceAllowedValue)
        {
            [self appendReferenceMessageToLabel:label];
        }
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

-(void)appendReferenceMessageToLabel:(OHAttributedLabel*)label
{
    NSMutableAttributedString *result = [label.attributedText mutableCopy];
    
    NSString* referenceMessage;
    NSDictionary* messageLookup = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NoRefCurrencyMessages" ofType:@"plist"]][self.payment.targetCurrency.code];
    if(messageLookup)
    {
        referenceMessage = [NSString stringWithFormat:NSLocalizedString(@"confirm.payment.reference.message", nil),self.payment.recipient.name,self.payment.recipient.name,messageLookup[@"partner"],messageLookup[@"location"],self.payment.recipient.name];
        
    }
    else if([@"USD" caseInsensitiveCompare:self.payment.targetCurrency.code] == NSOrderedSame)
    {
        referenceMessage = [NSString stringWithFormat:NSLocalizedString(@"confirm.payment.reference.message.USD", nil),self.payment.recipient.name,self.payment.recipient.name];
    }
    else
    {
        referenceMessage = [NSString stringWithFormat:NSLocalizedString(@"confirm.payment.reference.message.default", nil),self.payment.recipient.name,self.payment.recipient.name,self.payment.recipient.name];
    }
    [result appendAttributedString:[NSAttributedString attributedStringWithString:@"\n\n"]];
    [result appendAttributedString:[self attributedStringWithBase:referenceMessage markedString:referenceMessage]];
    
    [label setAttributedText:result];
}

- (void)setCancelledDate:(OHAttributedLabel *)label {
    NSString *dateString = [self.payment cancelDateString];
    NSString *dateMessageString = [NSString stringWithFormat:NSLocalizedString(@"payment.detail.cancel.date.message", nil), dateString];
    NSAttributedString *paymentDateString = [self attributedStringWithBase:dateMessageString markedString:dateString];
    [label setAttributedText:paymentDateString];
}

- (IBAction)contactSupportPressed {
    [[GoogleAnalytics sharedInstance] sendAppEvent:@"ContactSupport" withLabel:@"Transfer details"];
    NSString *subject = [NSString stringWithFormat:NSLocalizedString(@"support.email.payment.subject.base", nil), self.payment.remoteId];
    [[SupportCoordinator sharedInstance] presentOnController:self emailSubject:subject];
}

@end
