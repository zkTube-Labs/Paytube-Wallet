//
//  ImportObject.h
//  Runner
//
//  Created by MWT on 27/7/2020.
//

#import <Foundation/Foundation.h>
#import "Enum.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImportObject : NSObject

@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy)   NSString * content ;
@property (nonatomic,copy)   NSString * pin ;
@property (nonatomic,assign) int mLeadType;
@property (nonatomic,assign) int mCoinType;
@property (nonatomic,assign) int mOriginType;



@end

NS_ASSUME_NONNULL_END
