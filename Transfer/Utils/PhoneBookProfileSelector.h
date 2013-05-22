//
//  PhoneBookProfileSelector.h
//  Transfer
//
//  Created by Jaanus Siim on 5/22/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhoneBookProfile;

typedef void (^PhoneBookProfileBlock)(PhoneBookProfile *profile);

@interface PhoneBookProfileSelector : NSObject

- (void)presentOnController:(UIViewController *)controller completionHandler:(PhoneBookProfileBlock)completion;

@end
