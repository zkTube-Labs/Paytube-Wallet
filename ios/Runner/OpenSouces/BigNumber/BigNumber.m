//
//  BigNumber.h
//  Created by QiaoBaHui on 2019/01/14.
//  Copyright © 2019年 QiaoBaHui. All rights reserved.
//

#import "BigNumber.h"
#include "tommath.h"
#import "RegEx.h"

static RegEx *RegexDecimal = nil;
static RegEx *RegexHex = nil;

static BigNumber *ConstantNegativeOne = nil;
static BigNumber *ConstantZero = nil;
static BigNumber *ConstantOne = nil;
static BigNumber *ConstantTwo = nil;

static BigNumber *ConstantMaxSafeUnsignedInteger = nil;
static BigNumber *ConstantMaxSafeSignedInteger = nil;

@implementation BigNumber {
	mp_int _bigNumber;
}

#pragma mark - Life-Cycle

+ (void)initialize {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		RegexDecimal = [RegEx regExWithPattern:@"^-?[0-9]*$"];
		RegexHex = [RegEx regExWithPattern:@"^-?0x[0-9A-Fa-f]*$"];
		
		ConstantNegativeOne = [BigNumber bigNumberWithInteger:-1];
		ConstantZero = [BigNumber bigNumberWithInteger:0];
		ConstantOne = [BigNumber bigNumberWithInteger:1];
		ConstantTwo = [BigNumber bigNumberWithInteger:2];
		
		ConstantMaxSafeSignedInteger = [BigNumber bigNumberWithHexString:@"0x7fffffffffffffff"];
		ConstantMaxSafeUnsignedInteger = [BigNumber bigNumberWithHexString:@"0xffffffffffffffff"];
	});
}

#pragma mark - Constants

+ (BigNumber *)constantNegativeOne {
	return ConstantNegativeOne;
}

+ (BigNumber *)constantZero {
	return ConstantZero;
}

+ (BigNumber *)constantOne {
	return ConstantOne;
}

+ (BigNumber *)constantTwo {
	return ConstantTwo;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		mp_init(&_bigNumber);
	}
	
	return self;
}

- (instancetype)initWithValue:(mp_digit)value {
	self = [super init];
	if (self) {
		mp_init_set(&_bigNumber, value);
	}
	
	return self;
}

+ (instancetype)bigNumberWithDecimalString:(NSString *)decimalString {
	if (![RegexDecimal matchesExactly:decimalString]) { return nil; }
	
	BigNumber *bigNumber = [[BigNumber alloc] init];
	if (self) {
		mp_read_radix([bigNumber _bigNumber], [decimalString cStringUsingEncoding:NSASCIIStringEncoding], 10);
	}
	
	return bigNumber;
}

+ (instancetype)bigNumberWithHexString:(NSString *)hexString {
	if (![RegexHex matchesExactly:hexString]) { return nil; }
	
	if ([hexString hasPrefix:@"-"]) {
		hexString = [@"-" stringByAppendingString:[hexString substringFromIndex:3]];
	} else {
		hexString = [hexString substringFromIndex:2];
	}
	
	BigNumber *bigNumber = [[BigNumber alloc] init];
	if (self) {
		mp_read_radix([bigNumber _bigNumber], [hexString cStringUsingEncoding:NSASCIIStringEncoding], 16);
	}
	
	return bigNumber;
}

+ (instancetype)bigNumberWithNumber:(NSNumber *)number {
	return [self bigNumberWithDecimalString:[number stringValue]];
}

+ (instancetype)bigNumberWithInteger:(NSInteger)integer {
	return [self bigNumberWithDecimalString:[[NSNumber numberWithInteger:integer] stringValue]];
}

- (void)dealloc {
	mp_clear(&_bigNumber);
}

- (mp_int *)_bigNumber {
	return &_bigNumber;
}

#pragma mark - Operations

- (BigNumber *)add:(BigNumber *)other {
	BigNumber *result = [[BigNumber alloc] init];
	mp_add(&_bigNumber, [other _bigNumber], [result _bigNumber]);
	
	return result;
}

- (BigNumber *)sub:(BigNumber *)other {
	BigNumber *result = [[BigNumber alloc] init];
	mp_sub(&_bigNumber, [other _bigNumber], [result _bigNumber]);
	
	return result;
}

- (BigNumber *)mul:(BigNumber *)other {
	BigNumber *result = [[BigNumber alloc] init];
	mp_mul(&_bigNumber, [other _bigNumber], [result _bigNumber]);
	
	return result;
}

- (BigNumber *)div:(BigNumber *)other {
	BigNumber *result = [[BigNumber alloc] init];
	mp_div(&_bigNumber, [other _bigNumber], [result _bigNumber], NULL);
	
	return result;
}

- (BigNumber *)mod:(BigNumber *)other {
	BigNumber *result = [[BigNumber alloc] init];
	mp_div(&_bigNumber, [other _bigNumber], NULL, [result _bigNumber]);
	
	return result;
}

#pragma mark - Query API

- (BOOL)isZero {
	return (mp_cmp([ConstantZero _bigNumber], &_bigNumber) == MP_EQ);
}

- (BOOL)isNegative {
	return (_bigNumber.sign == MP_NEG);
}

#pragma mark - String Operations

- (NSString *)formatString:(int)radix {
	int radixSize;
	mp_radix_size(&_bigNumber, radix, &radixSize);
	
	char result[radixSize];
	mp_toradix(&_bigNumber, result, radix);
	
	return [[NSString alloc] initWithCString:result encoding:NSASCIIStringEncoding];
}

- (NSString *)decimalString {
	return [self formatString:10];
}

- (NSString *)hexString {
	NSString *hexString = [self formatString:16];
	
	if (self.isNegative) {
		hexString = [hexString substringFromIndex:1];
	}
	
	if (hexString.length % 2) {
		hexString = [@"0" stringByAppendingString:hexString];
	}
	
	hexString = [@"0x" stringByAppendingString:hexString];
	
	if (self.isNegative) {
		hexString = [@"-" stringByAppendingString:hexString];
	}
	
	return hexString;
}

- (BOOL)isSafeUnsignedIntegerValue {
	return (mp_cmp(&_bigNumber, [ConstantMaxSafeUnsignedInteger _bigNumber]) == MP_LT && ![self isNegative]);
}

- (BOOL)isSafeIntegerValue {
	return mp_cmp(&_bigNumber, [ConstantMaxSafeSignedInteger _bigNumber]) == MP_LT;
}

// @TODO: there are certainly better ways to do this
- (NSUInteger)unsignedIntegerValue {
	int radixSize;
	mp_radix_size(&_bigNumber, 16, &radixSize);
	
	char hexString[radixSize];
	mp_toradix(&_bigNumber, hexString, 16);
	
	NSUInteger result = 0;
	
	// Skip null-termination
	for (int i = 0; i < radixSize - 1; i++) {
		result <<= 4;
		unsigned char c = hexString[i];
		if (c <= '9') {
			result += (c - '0');
		} else if (c <= 'F') {
			result += 10 + (c - 'A');
		} else if (c <= 'f') {
			result += 10 + (c - 'a');
		}
	}
	
	return result;
}

- (NSInteger)integerValue {
	NSInteger multiplier = 1;
	BigNumber *value = self;
	if (self.isNegative) {
		multiplier = -1;
		value = [value mul:[BigNumber constantNegativeOne]];
	}
	return multiplier * [value unsignedIntegerValue];
}

#pragma mark - More intuitive inequalities

- (BOOL)isEqualTo:(BigNumber *)other {
	int result = mp_cmp(&_bigNumber, [((BigNumber *)other) _bigNumber]);
	return (result == MP_EQ);
}

- (BOOL)lessThan:(BigNumber *)other {
	int result = mp_cmp(&_bigNumber, [((BigNumber *)other) _bigNumber]);
	return (result == MP_LT);
}

- (BOOL)lessThanEqualTo:(BigNumber*)other {
	int result = mp_cmp(&_bigNumber, [((BigNumber *)other) _bigNumber]);
	return (result == MP_EQ || result == MP_LT);
}

- (BOOL)greaterThan:(BigNumber *)other {
	int result = mp_cmp(&_bigNumber, [((BigNumber *)other) _bigNumber]);
	return (result == MP_GT);
}

- (BOOL)greaterThanEqualTo:(BigNumber *)other {
	int result = mp_cmp(&_bigNumber, [((BigNumber *)other) _bigNumber]);
	return (result == MP_EQ || result == MP_GT);
}

#pragma mark - NSObject goodness

- (instancetype)copy {
	return self;
}

- (BOOL)isEqual:(id)object {
	return [self compare:object] == NSOrderedSame;
}

- (NSComparisonResult)compare:(id)other {
	if (![other isKindOfClass:[BigNumber class]]) {
		return NSOrderedDescending;
	}
	
	int result = mp_cmp(&_bigNumber, [((BigNumber *)other) _bigNumber]);
	if (result == MP_EQ) {
		return NSOrderedSame;
	} else if (result == MP_LT) {
		return NSOrderedAscending;
	} else {
		return NSOrderedDescending;
	}
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<BigNumber: %@>", self.decimalString];
}

@end
