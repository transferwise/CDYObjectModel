#import "BusinessProfile.h"
#import "NSString+Validation.h"

@interface BusinessProfile ()

@end

@implementation BusinessProfile

- (BOOL)isFieldReadonly:(NSString *)fieldName
{
    return [self.readonlyFields hasValue] && [self.readonlyFields rangeOfString:fieldName].location != NSNotFound;
}

- (NSDictionary *)data
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"businessName"] = self.name;
    data[@"registrationNumber"] = self.registrationNumber;
    data[@"descriptionOfBusiness"] = self.businessDescription;
	data[@"companyRole"] = self.companyRole;
	data[@"companyType"] = self.companyType;
    data[@"addressFirstLine"] = self.addressFirstLine;
    data[@"postCode"] = self.postCode;
    data[@"city"] = self.city;
    data[@"countryCode"] = self.countryCode;
    data[@"state"] = ([@"usa" caseInsensitiveCompare:self.countryCode]==NSOrderedSame && self.state)?self.state:@"";
	data[@"acn"] = ([@"aus" caseInsensitiveCompare:self.countryCode]==NSOrderedSame && self.acn)?self.acn:@"";
	data[@"abn"] = ([@"aus" caseInsensitiveCompare:self.countryCode]==NSOrderedSame && self.abn)?self.abn:@"";
    return [NSDictionary dictionaryWithDictionary:data];
}

/**
 *  Check to see if  all required business profile fields have all been filled
 *
 *  @return TRUE if all fields filled
 */

- (BOOL) isFilled
{
    // I have made this method more verbose than strictly necessary to allow easy debugging
    BOOL nameFilled = self.name.hasValue;
    BOOL registrationNumberFilled = self.registrationNumber.hasValue;
    BOOL businessDescriptionFilled = self.businessDescription.hasValue;
    BOOL companyRoleFilled = self.companyRole.hasValue;
    BOOL companyTypeFilled = self.companyType.hasValue;
    BOOL addressFirstLineFilled = self.addressFirstLine.hasValue;
    BOOL postCodeFilled = self.postCode.hasValue;
    BOOL cityFilled = self.city.hasValue;
    BOOL countryCodeFilled = self.countryCode.hasValue;
    
    // Are all fields filled? (Before checking for exceptions)
    BOOL allFieldsFilled = nameFilled & registrationNumberFilled & businessDescriptionFilled & companyRoleFilled & companyTypeFilled & addressFirstLineFilled & postCodeFilled & cityFilled & countryCodeFilled;
    
    // Now check for exceptions
    if ([@"usa" caseInsensitiveCompare: self.countryCode] == NSOrderedSame)
    {
        //Are we USA, but with no state field filled?
        if (self.state.hasValue == NO)
        {
            // We are missing the state field, so indicate failure
            allFieldsFilled = NO;
        }
    }
    else if ([@"aus" caseInsensitiveCompare: self.countryCode] == NSOrderedSame)
    {
        // If we are in Australia, then we need either ACN or ABN or ARBN fiels filled
        if (self.acn.hasValue == NO && self.abn.hasValue == NO && self.arbn.hash == NO)
        {
            // We have neither acn nor abn fields filled, so indicate failure
            allFieldsFilled = NO;
        }
    }
    
    return allFieldsFilled;
}

@end
