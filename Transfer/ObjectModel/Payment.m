#import "CalculationResult.h"
#import "PendingPayment.h"
#import "MoneyFormatter.h"
#import "Currency.h"


@interface Payment ()

@end


@implementation Payment

- (void)willSave {
    NSDate *latest = [self latestChangeDate];
    if (!latest || [self.lastUpdateTime isEqualToDate:latest]) {
        return;
    }

    [self setLastUpdateTime:latest];
}

- (NSDate *)latestChangeDate {
    NSDate *result = self.submittedDate;
    result = [result laterDate:self.receivedDate];
    result = [result laterDate:self.transferredDate];
    result = [result laterDate:self.cancelledDate];
    return result;
}

- (NSString *)localizedStatus {
    NSString *statusKey = [NSString stringWithFormat:@"payment.status.%@.description", self.paymentStatus];
    return NSLocalizedString(statusKey, nil);
}

- (NSString *)transferredAmountString {
    return [NSString stringWithFormat:@"%@ %@ > %@", [[MoneyFormatter sharedInstance] formatAmount:self.payIn], self.sourceCurrency.code, self.targetCurrency.code];
}

- (NSString *)latestChangeTimeString {
    NSDate *latestChangeDate = self.submittedDate;
    if (!latestChangeDate) {
        return @"";
    }

    NSDateComponents *components = [[Payment gregorian] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:latestChangeDate toDate:[NSDate date] options:0];

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

- (NSString *)payInWithCurrency {
    return [[MoneyFormatter sharedInstance] formatAmount:self.payIn withCurrency:self.sourceCurrency.code];
}

- (BOOL)isSubmitted {
    return [self.paymentStatus isEqualToString:@"submitted"];
}

- (NSString *)payInStringWithCurrency {
    return [[MoneyFormatter sharedInstance] formatAmount:[self payIn] withCurrency:self.sourceCurrency.code];
}

- (NSString *)payOutStringWithCurrency {
    return [[MoneyFormatter sharedInstance] formatAmount:self.payOut withCurrency:self.targetCurrency.code];
}

- (NSString *)rateString {
    return [CalculationResult rateStringFrom:self.conversionRate];
}

- (NSString *)paymentDateString {
    if (self.estimatedDeliveryStringFromServer) {
        return self.estimatedDeliveryStringFromServer;
    }

    return [[CalculationResult paymentDateFormatter] stringFromDate:self.estimatedDelivery];
}

- (NSString *)cancelDateString {
    return [[CalculationResult paymentDateFormatter] stringFromDate:self.cancelledDate];
}

- (BOOL)businessProfileUsed {
    return [self.profileUsed isEqualToString:@"business"];
}


- (BOOL)isCancelled {
    return [self.paymentStatus isEqualToString:@"cancelled"] || [self.paymentStatus isEqualToString:@"refunded"];
}

- (BOOL)moneyReceived {
    return [self.paymentStatus isEqualToString:@"matched"] || [self.paymentStatus isEqualToString:@"received"];
}

- (BOOL)moneyTransferred {
    return [self.paymentStatus isEqualToString:@"transferred"];
}

- (NSString *)transferredDateString {
    return [[CalculationResult paymentDateFormatter] stringFromDate:self.submittedDate];
}

- (BOOL)multiplePaymentMethods {
   return [[self enabledPayInMethods] count] > 1;
}

static NSCalendar *__gregorian;
+ (NSCalendar *)gregorian {
    if (!__gregorian) {
        __gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }

    return __gregorian;
}

- (NSOrderedSet*)enabledPayInMethods
{
    NSOrderedSet *result = [self.payInMethods filteredOrderedSetUsingPredicate:[NSPredicate predicateWithFormat:@"disabled == false"]];
    return result;
}

@end
