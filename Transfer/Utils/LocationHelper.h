//
//  LocationHelper.h
//  Transfer
//
//  Created by Juhan Hion on 12.02.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

@class Currency;
@class ObjectModel;

#import <Foundation/Foundation.h>

@interface LocationHelper : NSObject

- (id)init __attribute__((unavailable("init unavailable, this is a static class")));
+ (Currency *)getSourceCurrencyWithObjectModel:(ObjectModel *)objectModel;
+ (NSString *)getSupportPhoneNumber;
+ (NSString *)getLanguage;

@end
