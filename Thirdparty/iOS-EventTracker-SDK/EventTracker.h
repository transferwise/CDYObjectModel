//
//  irEventTracker.h
//  irEventTracker
//
//  Created by Tyler Thomas on 10/14/13.
//  Copyright (c) 2013 Impact Radius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventTracker : NSObject

@property (nonatomic, assign, getter=isDebug) BOOL debug;

@property (nonatomic, strong) NSString *actionTrackerId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

- (void) initEventTracker:(NSString*)actionTrackerId username:(NSString*)username password:(NSString *)password;

- (Event*) newEvent:(NSString *)evnetName;

- (void) trackUpdate;
- (void) trackInstall;
- (void) trackEvent:(NSString*)eventName;
- (void) trackEvent:(NSString*)eventName amount:(NSString*)amount;
- (void) submit:(Event*)conv;
- (void) submit:(Event*)conv withItemArray:(NSMutableArray*)itemArray;

#pragma mark - Singleton sharedManager
+ (id) sharedManager;

@end

