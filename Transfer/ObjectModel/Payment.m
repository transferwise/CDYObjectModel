#import "Payment.h"
#import "MoneyFormatter.h"
#import "Currency.h"


@interface Payment ()

@end


@implementation Payment

- (void)willSave {
    NSDate *latest = [self latestChangeDate];
    if ([self.lastUpdateTime isEqualToDate:latest]) {
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
    NSDate *latestChangeDate = self.lastUpdateTime;
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

static NSCalendar *__gregorian;
+ (NSCalendar *)gregorian {
    if (!__gregorian) {
        __gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }

    return __gregorian;
}

@end
