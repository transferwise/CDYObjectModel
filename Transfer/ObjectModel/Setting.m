#import "Setting.h"


@interface Setting ()

@end

@implementation Setting

- (BOOL)booleanValue {
    return [self.value boolValue];
}

@end
