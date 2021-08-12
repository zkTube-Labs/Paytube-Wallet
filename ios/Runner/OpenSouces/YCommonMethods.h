//
//  YCommonMethods.h
//  CoinID
//
//  Created by Wind on 2018/8/27.
//  Copyright © 2018年 新明华区块链技术（深圳）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface YCommonMethods : NSObject


/**去掉空格*/
+ (NSString *)deleteBlank:(NSString *)string;

/**去掉回车和空格*/
+ (NSString *)deleteBlankAndEnter:(NSString *)string;

//纯中文
+ (BOOL)isChinese:(NSString*)string ;

//全英文
+ (BOOL)isChar:(NSString*)string ;

/**根据iPhone6大小适配*/
+ (double)adaptationIphone6Height:(double)height;

/**根据iPhone6大小适配*/
+ (double)adaptationIphone6Width:(double)width;

//设置颜色
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)colorWithRGB:(CGFloat)R G:(CGFloat)G B:(CGFloat)B;
+ (UIColor *)colorWithRGB:(CGFloat)R G:(CGFloat)G B:(CGFloat)B alpha:(CGFloat)alpha;

+(NSDictionary *)addHeaderBaseParams ;
+(NSString*)getNumberFromHex:(NSString*)str;
+ (NSString *)convertDataToHexStr:(NSData *)data ;
+(NSBundle*)fetchCurrentLanguageBundle ;
@end
