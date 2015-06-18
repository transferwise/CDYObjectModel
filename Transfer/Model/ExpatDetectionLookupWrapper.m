//
//  ExpatDetectionLookupWrapper.m
//  Transfer
//
//  Created by Juhan Hion on 25.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ExpatDetectionLookupWrapper.h"

#define COUNTRY_PREFIX_PATTERN	@"^\\+(999|998|997|996|995|994|993|992|991|990|979|978|977|976|975|974|973|972|971|970|969|968|967|966|965|964|963|962|961|960|899|898|897|896|895|894|893|892|891|890|889|888|887|886|885|884|883|882|881|880|879|878|877|876|875|874|873|872|871|870|859|858|857|856|855|854|853|852|851|850|839|838|837|836|835|834|833|832|831|830|809|808|807|806|805|804|803|802|801|800|699|698|697|696|695|694|693|692|691|690|689|688|687|686|685|684|683|682|681|680|679|678|677|676|675|674|673|672|671|670|599|598|597|596|595|594|593|592|591|590|509|508|507|506|505|504|503|502|501|500|429|428|427|426|425|424|423|422|421|420|389|388|387|386|385|384|383|382|381|380|379|378|377|376|375|374|373|372|371|370|359|358|357|356|355|354|353|352|351|350|299|298|297|296|295|294|293|292|291|290|289|288|287|286|285|284|283|282|281|280|269|268|267|266|265|264|263|262|261|260|259|258|257|256|255|254|253|252|251|250|249|248|247|246|245|244|243|242|241|240|239|238|237|236|235|234|233|232|231|230|229|228|227|226|225|224|223|222|221|220|219|218|217|216|215|214|213|212|211|210|98|95|94|93|92|91|90|86|84|82|81|66|65|64|63|62|61|60|58|57|56|55|54|53|52|51|49|48|47|46|45|44|43|41|40|39|36|34|33|32|31|30|27|20|7|1)"

@interface ExpatDetectionLookupWrapper ()

@property (nonatomic, strong) NSArray *phones;
@property (nonatomic, strong) NSArray *emails;
@property (nonatomic, strong) NSRegularExpression *regex;

@end

@implementation ExpatDetectionLookupWrapper

static NSDictionary *knownPrefixesAndEmails;

#pragma mark - Init
- (instancetype)initWithRecordId:(ABRecordID)recordId
					   firstname:(NSString *)first
						lastName:(NSString *)last
						  phones:(NSArray *)phones
						  emails:(NSArray *)emails
{
	self = [super initWithRecordId:recordId
						 firstname:first
						  lastName:last];
	if(self)
	{
		self.phones = phones;
		self.emails = emails;
	}
	
	return self;
}

- (instancetype)initWithManagedObjectId:(NSManagedObjectID *)objectId
							  firstname:(NSString *)first
							   lastName:(NSString *)last
								 phones:(NSArray *)phones
								 emails:(NSArray *)emails
{
	self = [super initWithManagedObjectId:objectId
								firstname:first
								 lastName:last];
	if(self)
	{
		self.phones = phones;
		self.emails = emails;
	}
	
	return self;
}

#pragma mark - Setters
- (void)setPhones:(NSArray *)phones
{
	NSPredicate *phonePredicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
		return [self getCountryCode:evaluatedObject] != nil;
	}];
	
	_phones = [phones filteredArrayUsingPredicate:phonePredicate];
}

- (void)setEmails:(NSArray *)emails
{
	NSPredicate *emailPredicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
		return [self getDomain:evaluatedObject].length == 2;
	}];
	
	_emails = [emails filteredArrayUsingPredicate:emailPredicate];
}

#pragma mark - Condition checks
- (BOOL)hasPhonesWithDifferentCountryCodes
{
	return [self hasItemsWithDifferentProperties:self.phones
									getProperty:^NSString *(NSString *item) {
										return [self getCountryCode:item];
									}];
}

- (BOOL)hasPhoneWithMatchingCountryCode:(NSString *)sourcePhone
{
	NSString *sourcePrefix = [self getCountryCode:sourcePhone];
	
	//no point in continuing, if source phone has no country prefix
	if (!sourcePrefix)
	{
		return NO;
	}
	
	return [self hasPhoneWithPrefix:sourcePrefix];
}

- (BOOL)hasPhoneAndEmailFromDifferentCountries
{
	NSDictionary *dict = [[self class] knownPrefixesAndEmails];
	
	for (NSString *prefix in [dict allKeys])
	{
		//at least one phone and one email is present
		if (self.phones && self.emails
			//and the phone has the known country code prefix we are currently interested in
			&& [self hasPhoneWithPrefix:[NSString stringWithFormat:@"%@%@", @"+", prefix]]
			//and the user has an email address that has a two letter domain and is not the same with the phone's country
			&& [self hasTwoLetterDomainEmailExceptSource:dict[prefix]])
		{
			return YES;
		}
	}
	
	return NO;
}

#pragma mark - Helpers
+ (NSDictionary *)knownPrefixesAndEmails
{
	if (!knownPrefixesAndEmails)
	{
		knownPrefixesAndEmails = @{@"44": @"uk",
								   @"1": @"us",
								   @"33": @"fr",
								   @"49": @"de",
								   @"91": @"in",
								   @"34": @"es",
								   @"39": @"it",
								   @"352": @"ie",
								   @"31": @"nl",
								   @"41": @"ch",
								   @"61": @"au",
								   @"46": @"se",
								   @"36": @"hu",
								   @"32": @"be",
								   @"48": @"pl"
								   };
	}
	
	return knownPrefixesAndEmails;
}

- (BOOL)hasPhoneWithPrefix:(NSString *)sourcePrefix
{
	for (NSString* phone in self.phones)
	{
		NSString* prefix = [self getCountryCode:phone];
		
		if ([prefix isEqualToString:sourcePrefix])
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)hasTwoLetterDomainEmailExceptSource:(NSString *)sourceSuffix
{
	for (NSString* email in self.emails)
	{
		if(sourceSuffix && [email hasSuffix:sourceSuffix])
		{
			continue;
		}
		
		NSString *domain = [self getDomain:email];
		
		return domain.length == 2;
	}
	
	return NO;
}

- (BOOL)hasEmailFromDifferentCountries
{
	return [self hasItemsWithDifferentProperties:self.emails
									getProperty:^NSString *(NSString *item) {
										return [self getDomain:item];
									}];
}

#pragma mark - Helpers
- (NSString *)getCountryCode:(NSString *)source
{
	NSRange range = [self.regex rangeOfFirstMatchInString:source
												  options:NSMatchingWithoutAnchoringBounds
													range:NSMakeRange(0, source.length)];
	if (range.location == NSNotFound)
	{
		return nil;
	}
	
	return [source substringWithRange:range];
}

- (NSRegularExpression *)regex
{
	if (!_regex)
	{
		_regex = [NSRegularExpression regularExpressionWithPattern:COUNTRY_PREFIX_PATTERN
														   options:NSRegularExpressionCaseInsensitive
															 error:nil];
	}
	
	return _regex;
}

- (NSString *)getDomain:(NSString *)source
{
	NSRange dotRange = [source rangeOfString:@"."
									 options:NSBackwardsSearch];
	
	if (dotRange.location == NSNotFound)
	{
		return nil;
	}
	
	return [source substringFromIndex:dotRange.location + 1];
}

- (BOOL)hasItemsWithDifferentProperties:(NSArray *)items
						   getProperty:(NSString *(^)(NSString *item))getProperty
{
	//need to have at least two items
	if ([items count] < 2)
	{
		return NO;
	}
	
	NSString* existingProperty = nil;
	
	for (NSString* item in items)
	{
		NSString* property = getProperty(item);
		
		//either the property is not available or it is equal to previous property
		if (!property || [existingProperty isEqualToString:property])
		{
			continue;
		}
		//no previous properties
		else if (!existingProperty)
		{
			existingProperty = property;
		}
		//the property is available
		//it is not the same as previous property
		else
		{
			return YES;
		}
	}
	
	return NO;
}

@end
