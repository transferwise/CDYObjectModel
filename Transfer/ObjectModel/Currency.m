#import "Currency.h"
#import "RecipientType.h"

@interface Currency ()

@end


@implementation Currency

- (NSString *)formattedCodeAndName {
    return [NSString stringWithFormat:@"%@ %@", self.code, self.name];
}

- (BOOL)isBicRequiredForType:(RecipientType*)type
{

    if(self.recipientBicRequiredValue)
    {
        NSOrderedSet *fieldNames = [type.fields valueForKey:@"name"];
        BOOL bicFieldIsAvailable = [fieldNames indexOfObject:@"BIC"] != NSNotFound;
        return bicFieldIsAvailable;
    }
    return NO;
    
}


@end
