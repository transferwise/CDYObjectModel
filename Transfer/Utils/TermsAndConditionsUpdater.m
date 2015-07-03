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
	if (additionalDocs)
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
