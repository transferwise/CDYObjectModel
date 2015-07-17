//
//  TermsAndConditionsUpdater.m
//  Transfer
//
//  Created by Juhan Hion on 03.07.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "TermsAndConditionsUpdater.h"
#import "TermsOperation.h"
#import "Constants.h"

@interface TermsAndConditionsUpdater ()

@property (nonatomic, strong) TermsOperation* executedOperation;

@end

@implementation TermsAndConditionsUpdater

- (void)getTermsAndConditionsForCountry:(NSString *)countryCode
							   currency:(NSString *)currencyCode
						completionBlock:(void (^)(NSAttributedString *tcString))completionBlock
								   font:(UIFont *)font
								  color:(UIColor *)color
{
	BOOL isUS = [@"usa" caseInsensitiveCompare:countryCode] == NSOrderedSame || [@"us" caseInsensitiveCompare:countryCode] == NSOrderedSame;
	BOOL isAU = [@"aus" caseInsensitiveCompare:countryCode] == NSOrderedSame || [@"au" caseInsensitiveCompare:countryCode] == NSOrderedSame;
	
	if (([@"usd" caseInsensitiveCompare:currencyCode] == NSOrderedSame && isUS)
		|| ([@"aud" caseInsensitiveCompare:currencyCode] == NSOrderedSame && isAU))
	{
		self.executedOperation = [TermsOperation operationWithSourceCurrency:currencyCode
																	 country:countryCode
														   completionHandler:^(NSError *error, NSDictionary *result) {
															   if (!error && result)
															   {
																   //parse dictionary
																   NSString *termsOfUse = result[@"termsOfUse"];
																   
																   //if no terms of use then no point in continuing
																   if (termsOfUse)
																   {
																	   NSString *termsAndConditions = result[@"termsAndConditions"];
																	   
																	   completionBlock([self generateLegaleze:termsOfUse
																									   tcLink:termsAndConditions
																							   additionalDocs:result[@"customDocuments"]
																										 font:font
																										color:color]);
																	   return;
																   }
															   }
															   
															   completionBlock(nil);
														   }];
		
		[self.executedOperation execute];
	}
	else
	{
		//everything else should not show t&c
		completionBlock(nil);
	}
}

- (NSAttributedString *)generateLegaleze:(NSString *)touLink
								  tcLink:(NSString *)tcLink
						  additionalDocs:(NSDictionary *)additionalDocs
									font:(UIFont *)font
								   color:(UIColor *)color

{
	//terms of use should be always present
	NSAssert(touLink, @"terms of use link cannot be nil");
	
	NSMutableDictionary *mainDocs = [[NSMutableDictionary alloc] initWithCapacity:2];
	
	[mainDocs setObject:touLink
				 forKey:NSLocalizedString(@"general.terms.of.use", nil)];
	
	//terms & consitions link is only for US
	if (tcLink)
	{
		[mainDocs setObject:tcLink
					 forKey:NSLocalizedString(@"usd.state.specific", nil)];
	}
	
	NSString* legaleze = [NSString stringWithFormat:NSLocalizedString(@"general.legaleze", nil), [self concatStringFromDict:mainDocs]];
	
	NSMutableAttributedString *attributedLegaleze;
	
	//handle additional docs
	if (additionalDocs && additionalDocs.count > 0)
	{
		legaleze = [NSString stringWithFormat:@"%@\n%@", legaleze, [self concatStringFromDict:additionalDocs]];
		
		[mainDocs addEntriesFromDictionary:additionalDocs];
	}
	
	attributedLegaleze = [[NSMutableAttributedString alloc] initWithString:legaleze];
	
	NSRange wholeString = NSMakeRange(0, [legaleze length]);
	
	[attributedLegaleze addAttribute:NSForegroundColorAttributeName
							   value:color
							   range:wholeString];
	[attributedLegaleze addAttribute:NSFontAttributeName
							   value:font
							   range:wholeString];
	
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setAlignment:NSTextAlignmentCenter];
	[attributedLegaleze addAttribute:NSParagraphStyleAttributeName
							   value:paragraphStyle
							   range:wholeString];
	
	[self setUrls:attributedLegaleze
			 text:legaleze
			links:mainDocs];
	
	return attributedLegaleze;
}

- (NSString *)concatStringFromDict:(NSDictionary *)dict
{
	return [[dict allKeys] componentsJoinedByString:@" & "];
}

- (void)setUrls:(NSMutableAttributedString *)attributedText
		   text:(NSString *)text
		  links:(NSDictionary *)links
{
	for (NSString *key in [links allKeys])
	{
		NSRange linkRange = [text rangeOfString:key];
		
		[attributedText addAttribute:NSLinkAttributeName
							   value:[NSString stringWithFormat:@"%@%@", TRWServerAddress, links[key]]
							   range:linkRange];
	}
}

@end