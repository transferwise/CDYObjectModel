#import "Setting.h"


@interface Setting ()

@end

@implementation Setting

- (BOOL)booleanValue {
    return [self.value boolValue];
}

- (void)setBooleanValue:(BOOL)value {
    [self setValue:[NSString stringWithFormat:@"%d", value]];
}

@end
