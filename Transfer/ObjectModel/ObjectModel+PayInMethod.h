//
//  ObjectModel+PayInMethod.h
//  Transfer
//
//  Created by Mats Trovik on 18/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"

@interface ObjectModel (PayInMethod)

-(NSOrderedSet*)createPayInMethodsWithData:(NSArray*)data;

@end
