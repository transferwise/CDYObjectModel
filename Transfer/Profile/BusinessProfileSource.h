//
//  BusinessProfileSource.h
//  Transfer
//
//  Created by Jaanus Siim on 6/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ProfileSource.h"

@interface BusinessProfileSource : ProfileSource

@property (readonly) TextEntryCell *acnCell;
@property (readonly) TextEntryCell *abnCell;

- (void)reloadDropDowns;

@end
