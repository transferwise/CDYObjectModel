//
//  SupportCoordinator.m
//  Transfer
//
//  Created by Jaanus Siim on 9/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "SupportCoordinator.h"
#import "Constants.h"

@interface SupportCoordinator () <UIActionSheetDelegate>

@property (nonatomic, assign) NSInteger writeButtonIndex;
@property (nonatomic, assign) NSInteger callButtonIndex;

@end

@implementation SupportCoordinator

+ (SupportCoordinator *)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initSingleton];
    });
}

- (id)initSingleton {
    self = [super init];
    if (self) {

    }

    return self;
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
                                                                     NSStringFromClass([self class]),
                                                                     NSStringFromSelector(@selector(sharedClient))]
                                 userInfo:nil];
    return nil;
}

- (void)presentOnView:(UIView *)view {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"support.sheet.title", nil)
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];

    [self setWriteButtonIndex:[actionSheet addButtonWithTitle:NSLocalizedString(@"support.sheet.write.message", nil)]];
    [self setCallButtonIndex:[actionSheet addButtonWithTitle:NSLocalizedString(@"support.sheet.call", nil)]];
    NSInteger cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"button.title.cancel", nil)];
    [actionSheet setCancelButtonIndex:cancelButtonIndex];

    [actionSheet showInView:view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    MCLog(@"clickedButtonAtIndex:%d", buttonIndex);
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        MCLog(@"Cancel pressed");
        return;
    }
    
    if (buttonIndex == self.callButtonIndex) {
        MCLog(@"Call pressed");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://+442081234020"]];
    }
}

@end
