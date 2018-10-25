//
//  MBEncryptorAES.h
//  Maubank
//
//  Created by Winjit-Suyog on 2017/01/13.
//  Copyright © 2017 Winjit Technologies. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>


#define FBENCRYPT_ALGORITHM     kCCAlgorithmAES128
#define FBENCRYPT_BLOCK_SIZE    kCCBlockSizeAES128
#define FBENCRYPT_KEY_SIZE      kCCKeySizeAES256

/**
 This class is used to generate the password
 */
@interface MBEncryptorAES : NSObject
{}


//-----------------
// API (utilities)
//-----------------
+ (NSString *) createPassword:(NSString *)keyString withLength:(NSUInteger)length;
+ (NSString *)reverseString:(NSString *)input;
+ (NSString*) doTrippleDES:(NSString*)debitCardNo withATMPin:(NSString*)pin enc:(CCOperation)encryptOrDecrypt withKey:(NSString *)key;
+ (NSString *)encrypt:(NSString *)encryptValue key:(NSString *)key24Byte IV:(NSString *)IV;
+ (NSString *)decrypt:(NSString *)decryptValue key:(NSString *)key24Byte IV:(NSString *)IV;
+ (NSString *)sha1:(NSString *)str;
@end
