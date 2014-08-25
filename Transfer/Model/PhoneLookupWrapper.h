//
//  PhoneLookupWrapper.h
//  Transfer
//
//  Created by Juhan Hion on 25.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "PersonLookupWrapper.h"

@interface PhoneLookupWrapper : PersonLookupWrapper

@property (nonatomic, readonly) NSArray* phones;

- (BOOL)hasMatchingCountryPhone:(NSString *)sourcePhone;

@end
