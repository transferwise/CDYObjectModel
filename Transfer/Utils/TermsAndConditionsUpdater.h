//
//  TermsAndConditionsUpdater.h
//  Transfer
//
//  Created by Juhan Hion on 03.07.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TermsAndConditionsUpdater : NSObject

- (void)getTermsAndConditionsForCountry:(NSString *)countryCode
							   currency:(NSString *)currencyCode
						completionBlock:(void (^)(NSAttributedString *tcString))completionBlock
								   font:(UIFont *)font
								  color:(UIColor *)color;

@end
