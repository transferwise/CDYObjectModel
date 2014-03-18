#import "_RecipientTypeField.h"

@interface RecipientTypeField : _RecipientTypeField

- (BOOL)hasPredefinedValues;
- (NSString *)hasIssueWithValue:(NSString *)value;
- (NSString *)stripPossiblePatternFromValue:(NSString *)value;

@end
