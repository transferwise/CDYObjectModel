//
//  Constants.h
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#if DEBUG
#define MCLog(s, ...) NSLog( @"<%@:%@ (%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], NSStringFromSelector(_cmd), __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define MCLog(s, ...) //
#endif

typedef void (^TRWActionBlock)();

#define ABSTRACT_METHOD MCLog(@"You must override %@ in a subclass", NSStringFromSelector(_cmd)); [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]

#define USE_TESTFLIGHT 1

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
  static dispatch_once_t pred = 0; \
  __strong static id _sharedObject = nil; \
  dispatch_once(&pred, ^{ \
    _sharedObject = block(); \
  }); \
  return _sharedObject; \
