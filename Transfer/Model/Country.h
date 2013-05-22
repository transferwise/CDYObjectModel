//
//  Country.h
//  Transfer
//
//  Created by Jaanus Siim on 4/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *isoCode2;
@property (nonatomic, copy, readonly) NSString *isoCode3;

+ (Country *)countryWithData:(NSDictionary *)data;

@end
