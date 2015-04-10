#import "CalculationResult.h"
#import "PendingPayment.h"
#import "MoneyFormatter.h"
#import "Currency.h"
#import "NSString+DeviceSpecificLocalisation.h"
#import "PaymentMadeIndicator.h"

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
    BOOL overrideReceivedStatus = NO;
    if([@"USD" caseInsensitiveCompare:self.sourceCurrency.code] == NSOrderedSame)
    {
        if([statusNumber unsignedIntegerValue] == PaymentStatusReceived)
        {
            if(self.paymentMadeIndicator)
            {
                overrideReceivedStatus = [@"ACH" caseInsensitiveCompare:self.paymentMadeIndicator.payInMethodName] == NSOrderedSame;
            }
            else
            {
                overrideReceivedStatus = YES;
            }
        }
    }
    if((self.paymentMadeIndicator && [statusNumber unsignedIntegerValue] == PaymentStatusSubmitted) || overrideReceivedStatus)
    {
        statusNumber = @(PaymentStatusUserHasPaid);
    }
    return statusNumber?[statusNumber unsignedIntegerValue]:PaymentStatusUnknown;
}

- (NSString *)localizedStatus {
    NSString *statusKey = [NSString stringWithFormat:@"payment.status.%@.description", self.paymentStatusString];
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
    return self.status == PaymentStatusSubmitted;
}

- (NSString *)payInStringWithCurrency {
    return [[MoneyFormatter sharedInstance] formatAmount:[self payIn] withCurrency:self.sourceCurrency.code];
}

- (NSString *)payInString {
	return [[MoneyFormatter sharedInstance] formatAmount:[self payIn]];
}

- (NSString *)payOutString {
    return [[MoneyFormatter sharedInstance] formatAmount:[self payOut]];
}

- (NSString *)payOutStringWithCurrency {
    return [[MoneyFormatter sharedInstance] formatAmount:self.payOut withCurrency:self.targetCurrency.code];
}

- (NSString *)rateString {
    return [CalculationResult rateStringFrom:self.conversionRate];
}

- (NSString *)paymentDateString {
    
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    if (self.estimatedDeliveryStringFromServer && [language isEqualToString:@"en"]) {
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
    return self.status == PaymentStatusCancelled || self.status == PaymentStatusRefunded;
}

- (BOOL)moneyReceived {
    return self.status == PaymentStatusMatched || self.status == PaymentStatusReceived;
}

- (BOOL)moneyTransferred {
    return self.status == PaymentStatusTransferred;
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


- (NSOrderedSet*)enabledPayInMethods
{
    NSOrderedSet *result = [self.payInMethods filteredOrderedSetUsingPredicate:[NSPredicate predicateWithFormat:@"disabled == false"]];
    return result;
}

-(NSString*)paymentStatusString
{
    NSString *status = self.status == PaymentStatusUserHasPaid ? @"submitted" : self.paymentStatus;
    return status;
}

-(NSDictionary*)trackingProperties
{
    return @{@"SourceCurrency":self.sourceCurrency.code,@"SourceAmount":self.payInString};
}
@end
