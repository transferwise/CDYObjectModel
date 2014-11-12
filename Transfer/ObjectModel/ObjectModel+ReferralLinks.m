//
//  ObjectModel+ReferralLinks.m
//  Transfer
//
//  Created by Juhan Hion on 11.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ReferralLink.h"
#import "ObjectModel+ReferralLinks.h"

@implementation ObjectModel (ReferralLinks)

- (NSArray *)referralLinks
{
	return [self fetchEntityNamed:[ReferralLink entityName] atOffset:0];
}

- (NSArray *)createOrUpdateReferralLinks:(NSDictionary *)referralLinks
{
	NSMutableArray *returnLinks = [[NSMutableArray alloc] init];
	
	for (NSString* key in referralLinks)
	{
		NSInteger channel = [ObjectModel getReferralChannel:key];
		
		if (channel > -1)
		{
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"channel = %li", (long)channel];
			ReferralLink *referralLink = [self fetchEntityNamed:[ReferralLink entityName] withPredicate:predicate];
			
			if (!referralLink)
			{
				referralLink = [ReferralLink insertInManagedObjectContext:self.managedObjectContext];
				[referralLink setChannelValue:channel];
				[referralLink setUrl:referralLinks[key]];
			}
			
			if (referralLink)
			{
				[returnLinks addObject:referralLink];
			}
		}
	}
	
	return [NSArray arrayWithArray:returnLinks];
}

+ (NSInteger)getReferralChannel:(NSString *)key
{
	NSInteger (^selectedChannel)() = @{
								  @"emailfromios" : ^{
									  return ReferralChannelEmail;
								  },
								  @"fbfromios" : ^{
									  return ReferralChannelFb;
								  },
								  @"smsfromios" : ^{
									  return ReferralChannelSms;
								  },
								  @"ios" : ^{
									  return ReferralChannelLink;
								  },
								  }[key];
	if (selectedChannel)
	{
		return selectedChannel();
	}
	else
	{
		return -1;
	}
}

@end
