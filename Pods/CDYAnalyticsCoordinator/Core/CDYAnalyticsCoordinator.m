/*
 * Copyright 2014 Coodly OÜ
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "CDYAnalyticsCoordinator.h"

@interface CDYAnalyticsCoordinator ()

@property (nonatomic, strong) NSMutableArray *services;

@end

@implementation CDYAnalyticsCoordinator

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] initSingleton];
    });
    return _sharedObject;

}

- (id)initSingleton {
    self = [super init];
    if (self) {
        _services = [NSMutableArray array];
    }
    return self;
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
                                                                     NSStringFromClass([self class]),
                                                                     NSStringFromSelector(@selector(sharedInstance))]
                                 userInfo:nil];
    return nil;
}

- (void)addAnalyticsService:(id)service {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.services addObject:service];
    });
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id service in self.services) {
            [anInvocation invokeWithTarget:service];
        }
    });
}

@end
