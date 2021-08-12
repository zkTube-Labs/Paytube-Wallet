
#import <Foundation/Foundation.h>

@interface RegEx : NSObject

+ (instancetype)regExWithPattern:(NSString *)pattern;

- (BOOL)matchesAny:(NSString *)string;
- (BOOL)matchesExactly:(NSString*)string;

@end
