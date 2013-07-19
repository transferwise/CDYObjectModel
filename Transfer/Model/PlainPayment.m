//
//  PlainPayment.m
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PlainPayment.h"
#import "PlainRecipient.h"
#import "MoneyFormatter.h"
#import "NSDate+ServerTime.h"

static NSArray *__activeStatuses;

@interface PlainPayment ()

@property (nonatomic, strong) NSNumber *paymentId;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *sourceCurrency;
@property (nonatomic, copy) NSString *targetCurrency;
@property (nonatomic, strong) NSNumber *priority;
@property (nonatomic, strong) NSNumber *limitRate;
@property (nonatomic, strong) NSNumber *paymentFee;
@property (nonatomic, strong) NSNumber *payIn;
@property (nonatomic, strong) NSNumber *matchedPercent;
@property (nonatomic, strong) PlainRecipient *recipient;
@property (nonatomic, strong) NSDate *submittedDate;
@property (nonatomic, strong) NSDate *receivedDate;
@property (nonatomic, strong) NSDate *transferredDate;
@property (nonatomic, strong) NSDate *cancelledDate;
@property (nonatomic, copy) NSString *paymentReference;
@property (nonatomic, strong) PlainRecipient *refundRecipient;
@property (nonatomic, strong) NSDate *estimatedDelivery;
@property (nonatomic, strong) PlainRecipient *settlementRecipient;

@end

@implementation PlainPayment

+ (void)initialize {
    __activeStatuses = @[@"submitted", @"received", @"matched"];
}

+ (PlainPayment *)paymentWithData:(NSDictionary *)data {
    PlainPayment *payment = [[PlainPayment alloc] init];

    [payment setPaymentId:data[@"id"]];
    [payment setStatus:data[@"paymentStatus"]];
    [payment setSourceCurrency:data[@"sourceCurrency"]];
    [payment setTargetCurrency:data[@"targetCurrency"]];
    [payment setPriority:data[@"priority"]];
    [payment setLimitRate:data[@"limitRate"]];
    [payment setPaymentFee:data[@"paymentFee"]];
    [payment setPayIn:data[@"payIn"]];
    [payment setMatchedPercent:data[@"matchedPercent"]];
    [payment setRecipient:[PlainRecipient recipientWithData:data[@"recipient"]]];
    [payment setSubmittedDate:[NSDate dateFromServerString:data[@"submittedDate"]]];
    [payment setReceivedDate:[NSDate dateFromServerString:data[@"receivedDate"]]];
    [payment setTransferredDate:[NSDate dateFromServerString:data[@"transferredDate"]]];
    [payment setCancelledDate:[NSDate dateFromServerString:data[@"cancelledDate"]]];
    [payment setPaymentReference:data[@"paymentReference"]];
    [payment setRefundRecipient:[PlainRecipient recipientWithData:data[@"refundRecipient"]]];
    [payment setEstimatedDelivery:[NSDate dateFromServerString:data[@"estimatedDelivery"]]];
    [payment setSettlementRecipient:[PlainRecipient recipientWithData:data[@"settlementRecipient"]]];

    return payment;
}

- (NSString *)localizedStatus {
    NSString *statusKey = [NSString stringWithFormat:@"payment.status.%@.description", self.status];
    return NSLocalizedString(statusKey, nil);
}

- (NSString *)recipientName {
    return [self.recipient name];
}

- (NSString *)transferredAmountString {
    return [NSString stringWithFormat:@"%@ %@ > %@", [[MoneyFormatter sharedInstance] formatAmount:self.payIn], self.sourceCurrency, self.targetCurrency];
}

- (NSDate *)latestChangeDate {
    NSDate *result = self.submittedDate;
    result = [result laterDate:self.receivedDate];
    result = [result laterDate:self.transferredDate];
    result = [result laterDate:self.cancelledDate];
    return result;
}

- (NSString *)latestChangeTimeString {
    NSDate *latestChangeDate = [self latestChangeDate];
    NSDateComponents *components = [[PlainPayment gregorian] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:latestChangeDate toDate:[NSDate date] options:0];

    if (components.year > 1) {
        return [NSString stringWithFormat:NSLocalizedString(@"payment.change.time.years.ago", nil), components.year];
    } else if (components.year == 1) {
        return NSLocalizedString(@"payment.change.time.one.year.ago", nil);
    } else if (components.month > 1) {
        return [NSString stringWithFormat:NSLocalizedString(@"payment.change.time.months.ago", nil), components.month];
    } else if (components.month == 1) {
        return NSLocalizedString(@"payment.change.time.one.month.ago", nil);
    } else if (components.day > 1) {
        return [NSString stringWithFormat:NSLocalizedString(@"payment.change.time.days.ago", nil), components.day];
    } else if (components.day == 1) {
        return NSLocalizedString(@"payment.change.time.one.day.ago", nil);
    } else if (components.hour > 1) {
        return [NSString stringWithFormat:NSLocalizedString(@"payment.change.time.hours.ago", nil), components.hour];
    } else if (components.hour == 1) {
        return NSLocalizedString(@"payment.change.time.one.hour.ago", nil);
    } else if (components.minute > 1) {
        return [NSString stringWithFormat:NSLocalizedString(@"payment.change.time.minutes.ago", nil), components.minute];
    } else {
        return NSLocalizedString(@"payment.change.time.one.minute.ago", nil);
    }
}

- (BOOL)isActive {
    return [__activeStatuses containsObject:self.status];
}

- (NSString *)payInWithCurrency {
    return [[MoneyFormatter sharedInstance] formatAmount:self.payIn withCurrency:self.sourceCurrency];
}

static NSCalendar *__gregorian;
+ (NSCalendar *)gregorian {
    if (!__gregorian) {
        __gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }

    return __gregorian;
}

@end
