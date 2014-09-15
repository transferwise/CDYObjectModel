//
//  CountrySuggestionCellProvider.h
//  Transfer
//
//  Created by Juhan Hion on 30.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "SuggestionCellProvider.h"

@class Country;

@interface CountrySuggestionCellProvider : SuggestionCellProvider

- (Country *)getCountryByCodeOrName:(NSString *)codeOrName;

@end
