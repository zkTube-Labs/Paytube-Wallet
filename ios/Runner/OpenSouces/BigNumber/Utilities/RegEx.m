
#import "RegEx.h"

@implementation RegEx {
	NSRegularExpression *_regex;
}

- (instancetype)initWithPattern:(NSString *)pattern {
	self = [super init];
	if (self) {
		NSError *error = nil;
		_regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
		if (error) {
			NSLog(@"RegEx: Error creating pattern /%@/ - %@", pattern, error);
			return nil;
		}
	}
	
	return self;
}

+ (instancetype)regExWithPattern:(NSString *)pattern {
	return [[RegEx alloc] initWithPattern:pattern];
}

- (BOOL)matchesAny:(NSString *)string {
	NSRange range = [_regex rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
	return (range.location != NSNotFound);
}

- (BOOL)matchesExactly:(NSString *)string {
	NSRange range = [_regex rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
	return (range.location == 0 && range.length == string.length);
}

@end
