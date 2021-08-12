//
//  WalletObject.h
//  Runner
//
//  Created by MWT on 2/11/2020.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletObject : NSObject

@property (nonatomic,copy) NSString * address;
@property (nonatomic,copy) NSString * prvKey;
@property (nonatomic,copy) NSString * pubKey;
@property (nonatomic,copy) NSString * subPubKey;
@property (nonatomic,copy) NSString * subPrvKey;
@property (nonatomic,copy) NSString * keyStore;
@property (nonatomic,copy) NSString * masterPubKey;
@property (nonatomic,assign) int coinType;
@property (nonatomic,copy) NSString * walletID ;
@property (nonatomic,copy) NSString * keys;
@property (nonatomic,assign) int originType;


-(NSString*)deckAESCBC:(NSString*)desk ;



@end

NS_ASSUME_NONNULL_END
