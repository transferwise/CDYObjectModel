//
//  ProfileSource.m
//  Transfer
//
//  Created by Jaanus Siim on 6/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ProfileSource.h"
#import "PhoneBookProfile.h"

@implementation ProfileSource

- (NSArray *)presentedCells {
    return @[];
}

- (NSString *)editViewTitle {
    return nil;
}

- (void)pullDetailsWithHandler:(ProfileActionBlock)handler {

}

- (void)loadDataFromProfile:(PhoneBookProfile *)profile {

}

- (BOOL)inputValid {
    return NO;
}

- (id)enteredProfile {
    return nil;
}

- (void)validateProfile:(id)profile withValidation:(id)validation completion:(ProfileActionBlock)completion {

}

@end
