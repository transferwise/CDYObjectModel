//
//  TransferwiseOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjectModel;

typedef NS_ENUM(short, TRWNetworkErrorCode) {
    ResponseFormatError,
    ResponseServerError
};

extern NSString *const TRWErrorDomain;

@interface TransferwiseOperation : NSObject

@property (nonatomic, strong) ObjectModel *objectModel;

- (void)execute;

@end
