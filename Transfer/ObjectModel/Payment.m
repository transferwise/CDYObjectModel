#import "CalculationResult.h"
#import "PendingPayment.h"
#import "MoneyFormatter.h"
#import "Currency.h"
#import "NSString+DeviceSpecificLocalisation.h"


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

static NSDictionary* statusLookupDictionary;
-(NSDictionary*)statusLookup
{
    if(!statusLookupDictionary)
    {
        statusLookupDictionary = @{@"unknown":@(PaymentStatusUnknown),
                                   @"cancelled":@(PaymentStatusCancelled),
                                   @"matched":@(PaymentStatusMatched),
                                   @"received":@(PaymentStatusReceived),
                                   @"refunded":@(PaymentStatusRefunded),
                                   @"submitted":@(PaymentStatusSubmitted),
                                   @"transferred":@(PaymentStatusTransferred),
                                   @"receivedwaitingrecipient":@(PaymentStatusReceivedWaitingRecipient)
                                   };
    }
    return statusLookupDictionary;
}

-(PaymentStatus)status
{
    NSString* key = [self.paymentStatus lowercaseString];
    NSNumber *statusNumber =[self statusLookup][key];
    return statusNumber?[statusNumber unsignedIntegerValue]:PaymentStatusUnknown;
}

- (NSString *)localizedStatus {
    NSString *statusKey = [NSString stringWithFormat:@"payment.status.%@.description", self.paymentStatus];
    NSString *statusString = NSLocalizedString(statusKey, nil);
    if([statusString rangeOfString:@"%@"].location != NSNotFound)
    {
        statusString = [NSString stringWithFormat:statusString, [self latestChangeTimeString]];
    }
    
    return statusString;
}

- (NSString *)transferredAmountString {
    return [NSString stringWithFormat:@"%@", [[MoneyFormatter sharedInstance] formatAmount:self.payIn]];
}

- (NSString *)transferredCurrenciesString
{
    NSString* currenciesFormat = NSLocalizedString(@"payment.currencies.format",nil);
    return [NSString stringWithFormat:currenciesFormat, self.sourceCurrency.code, self.targetCurrency.code];
}

- (NSString *)latestChangeTimeString {
    NSDate *latestChangeDate = [self latestChangeDate];
    if (!latestChangeDate) {
        return @"";
    }

    NSDateComponents *latestChangeComponents = [[Payment gregorian] components:NSYearCalendarUnit  fromDate:latestChangeDate];
    
    NSDateComponents *nowComponents = [[Payment gregorian] components:NSYearCalendarUnit fromDate:[NSDate date]];

    NSDateFormatter* formatter;
    if(latestChangeComponents.year != nowComponents.year)
    {
        formatter = [Payment longDateFormatter];
    }
    else
    {
        formatter = [Payment shortDateFormatter];
    }
    return [formatter stringFromDate:latestChangeDate];
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
    NSUInteger count = 0;
    if (self.paymentOptionsValue & PaymentRegular) {
        count++;
    }
    if (self.paymentOptionsValue & PaymentCard) {
        count++;
    }
    return count > 1;
}

static NSCalendar *__gregorian;
+ (NSCalendar *)gregorian {
    if (!__gregorian) {
        __gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }

    return __gregorian;
}

static NSDateFormatter *__longDateFormatter;
+ (NSDateFormatter *)longDateFormatter {
    if (!__longDateFormatter) {
        __longDateFormatter = [[NSDateFormatter alloc] init];
        __longDateFormatter.dateFormat = NSLocalizedString(@"payment.date.format.long", nil);
    }
    
    return __longDateFormatter;
}

static NSDateFormatter *__shortDateFormatter;
+ (NSDateFormatter *)shortDateFormatter {
    if (!__shortDateFormatter) {
        __shortDateFormatter = [[NSDateFormatter alloc] init];
        __shortDateFormatter.dateFormat = NSLocalizedString(@"payment.date.format.short", nil);
    }
    
    return __shortDateFormatter;
}

+ (PaymentMethod)methodsWithData:(NSArray *)methods {
    PaymentMethod result = PaymentNone;
    for (NSString *method in methods) {
        if ([@"REGULAR" isEqualToString:method]) {
            result = result | PaymentRegular;
        } else if ([@"CARD" isEqualToString:method]) {
            result = result | PaymentCard;
        }
    }

    return result;
}

@end
