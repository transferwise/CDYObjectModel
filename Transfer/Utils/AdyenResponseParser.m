//
//  AdyenResponseParser.m
//  Transfer
//
//  Created by Juhan Hion on 13.07.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "AdyenResponseParser.h"

@implementation AdyenResponseParser

+ (void)handleAdyenResponse:(NSError *)error
				   response:(NSDictionary *)response
			 successHandler:(void (^)())successHandler
				failHandler:(void (^)(NSError *error, NSString *errorKeySuffix))failHandler
{
	NSString* resultCode = response[@"resultCode"];
	
	if (!error
		&& [@"Authorised" caseInsensitiveCompare: resultCode] == NSOrderedSame)
	{
		successHandler();
	}
	else
	{
		if (resultCode
			&& [@"Received" caseInsensitiveCompare: resultCode] != NSOrderedSame
			&& [@"RedirectShopper" caseInsensitiveCompare: resultCode] != NSOrderedSame)
		{
			failHandler(error, [resultCode lowercaseString]);
		}
		else
		{
			failHandler(error, nil);
		}
	}
}

@end
