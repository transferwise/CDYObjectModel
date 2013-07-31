//
//  NSStringPatternTest.m
//  Transfer
//
//  Created by Jaanus Siim on 7/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "Kiwi.h"
#import "NSString+Presentation.h"

SPEC_BEGIN(NSStringPatternSpec)

        __block NSString *testPattern = @"**-**-**";

        describe(@"Pattern remove", ^{
            it(@"Should work on partial entry one", ^{
                NSString *result = [@"12-" stripPattern:testPattern];
                [[result should] equal:@"12"];
            });

            it(@"Should work on partial entry two", ^{
                NSString *result = [@"12-21-" stripPattern:testPattern];
                [[result should] equal:@"1221"];
            });
        });

        describe(@"Add pattern", ^{
            it(@"Should apply partial patter", ^{
                NSString *result = [@"12" applyPattern:testPattern];
                [[result should] equal:@"12-"];
            });

            it(@"Should apply full patter", ^{
                NSString *result = [@"122134" applyPattern:testPattern];
                [[result should] equal:@"12-21-34"];
            });

            it(@"No apply on empty string", ^{
                NSString *result = [@"" applyPattern:testPattern];
                [[result should] equal:@""];
            });

            it(@"No crash on long source", ^{
                NSString *result = [@"12312312312312312312312" applyPattern:testPattern];
                [[result should] equal:@"12-31-2312312312312312312"];
            });

            it(@"Should not add pattern to pattern", ^{
                NSString *result = [@"12-31-" applyPattern:testPattern];
                [[result should] equal:@"12-31-"];
            });
        });

        describe(@"Add pattern char", ^{
            it(@"Should add it when needed", ^{
                NSString *result = [@"12-22" stringByAddingPatternChar:testPattern];
                [[result should] equal:@"12-22-"];
            });

            it(@"Should not add it when not needed", ^{
                NSString *result = [@"12-22-3" stringByAddingPatternChar:testPattern];
                [[result should] equal:@"12-22-3"];
            });

        });

        describe(@"Remove pattern char", ^{
            it(@"Should remove when needed", ^{
                NSString *result = [@"12-22-" stringByRemovingPatterChar:testPattern];
                [[result should] equal:@"12-22"];
            });

            it(@"Should not remove when not needed", ^{
                NSString *result = [@"12-2" stringByRemovingPatterChar:testPattern];
                [[result should] equal:@"12-2"];
            });

            it(@"Should do nothing with empty string", ^{
                NSString *result = [@"" stringByRemovingPatterChar:testPattern];
                [[result should] equal:@""];
            });
        });
SPEC_END