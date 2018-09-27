//
//  MBEncryptorAES.h
//  Maubank
//
//  Created by Winjit-Suyog on 2017/01/13.
//  Copyright © 2017 Winjit Technologies. All rights reserved.
//

#import "MBEncryptorAES.h"
#import "NSData+Base64.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation MBEncryptorAES
    
NSString *PREFIX_AT_CARD_NO  = @"0000";
NSString *PREFIX_ATM_PIN  = @"04";
NSUInteger MAX_PADDED_PIN_LENGTH  = 16;
    
/**
     function to create password
     
     @param keyString password string
     @param length password to get generated of length
     @return password
*/
+ (NSString *) createPassword:(NSString *)keyString withLength:(NSUInteger)length
    {
        // Create NSData object.
        NSData *nsdata = [keyString
                          dataUsingEncoding:NSUTF8StringEncoding];
        // Get NSString from NSData object in Base64.
        NSString *base64Encoded = [nsdata base64EncodedStringWithSeparateLines:false];
        int finalKeyLength = 32;
        int totalLength = (int)base64Encoded.length;
        int chunkSize = finalKeyLength / 4;
        int tempChunkStartIndex = (int)length;
        int tempChunkEndIndex = 0;
        
        NSMutableArray *tempKey = [[NSMutableArray alloc] init];
        for (int step = 0; step < 4; step++)
        {
            tempChunkEndIndex = tempChunkStartIndex + chunkSize;
            if (tempChunkEndIndex < totalLength)
            {
                NSString *str = [base64Encoded substringWithRange:NSMakeRange(tempChunkStartIndex, tempChunkEndIndex - tempChunkStartIndex)];
                [tempKey addObject:str];
                tempChunkStartIndex = tempChunkEndIndex;
            }
            else
            {
                NSString *str1 = [base64Encoded substringWithRange:NSMakeRange(tempChunkStartIndex, totalLength - tempChunkStartIndex)];
                NSString *str2 = [base64Encoded substringWithRange:NSMakeRange(0, tempChunkEndIndex - totalLength)];
                
                NSString *concatStr = [NSString stringWithFormat:@"%@%@",str1,str2];
                
                [tempKey addObject:concatStr];
                tempChunkStartIndex = tempChunkEndIndex - totalLength;
            }
        }
        
        if ([tempKey count] <= 4)
        {
            NSString *strRev1 = [self reverseString:tempKey[1]];
            NSString *strRev3 = [self reverseString:tempKey[3]];
            NSString *str0 = tempKey[0];
            NSString *str2 = tempKey[2];
            
            NSString *FinalStr = [NSString stringWithFormat:@"%@%@%@%@",strRev1,str0,strRev3,str2];
            NSString *trimmedString12 = [FinalStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            return trimmedString12;
        }
        else
        {
            return @"";
        }
        
    }
    
/**
     function to reverse a string
     
     @param input string as input
     @return reversed string
*/
+ (NSString *)reverseString:(NSString *)input {
    NSUInteger len = [input length];
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:len];
    for (int i = (int)len - 1; i >= 0; i--) {
        [result appendFormat:@"%c", [input characterAtIndex:i]];
    }
    return result;
}


/**
 Function to get data from hex string

 @param hex hex string
 @return return data
 */
+ (NSData *)dataFromHexString: (NSString *) hex {
    const char *chars = [hex UTF8String];
    NSUInteger i = 0, len = hex.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}


/**
 Function to get paddent atm pin

 @param pin atm pin
 @return padded pin
 */
+ (NSString *)getPaddedATMPin: (NSString *) pin {
    pin = [NSString stringWithFormat:@"%@%@", PREFIX_ATM_PIN, pin];
    
    if ([pin length] < MAX_PADDED_PIN_LENGTH)
    {
        NSUInteger diff_length = MAX_PADDED_PIN_LENGTH - [pin length];
        NSString *sb = pin;
        for (int i = 0; i < diff_length; i++) {
            sb = [NSString stringWithFormat:@"%@%@", sb, @"F"];
        }
        return sb;
    }
    return pin;
}


/**
 Function to generate message for tripple des string

 @param strCardNo card no
 @param generatedPin generated pin
 @return return string
 */
+(NSString *) generateMessageToEncrypt:(NSString *) strCardNo withPaddedPin :(NSString *)generatedPin{
    NSString *rString = [strCardNo substringWithRange: NSMakeRange(3, 16 - 3)];
    NSString *generatedCardNumber = [NSString stringWithFormat:@"%@%@",PREFIX_AT_CARD_NO,rString];
    NSUInteger len = [generatedCardNumber length];
    Byte *keyBytes = (Byte*)malloc((len -1) + 1);
    
    NSUInteger num3 = len - 1;
    NSString *str5 = @"";
    
    for (int i = 0; i < num3 ; i++ )
    {
        keyBytes[i] = (UInt64)strtoull([[generatedCardNumber substringWithRange:NSMakeRange(i,1)] UTF8String], NULL, 16);
        NSString *str6 = [NSString stringWithFormat:@"%d",keyBytes[i]];
        keyBytes[i] = (UInt64)strtoull([[generatedPin substringWithRange:NSMakeRange(i,1)] UTF8String], NULL, 16);
        NSString *str7 = [NSString stringWithFormat:@"%d",keyBytes[i]];
        int num2 = str6.intValue ^ str7.intValue;
        NSString *str4 = [NSString stringWithFormat:@"%x",num2];
        str5 = [NSString stringWithFormat:@"%@%@",str5,str4];
    }
    return [str5 uppercaseString];
}


/**
 Function to do the tripple des

 @param debitCardNo debit card no
 @param pin pin
 @param encryptOrDecrypt encrypt or decrypt
 @return return string
 */
+ (NSString*) doTrippleDES:(NSString*)debitCardNo withATMPin:(NSString*)pin enc:(CCOperation)encryptOrDecrypt withKey:(NSString *)key{
   
    NSString *message = [self generateMessageToEncrypt:debitCardNo withPaddedPin:[self getPaddedATMPin:pin]];
    
    NSData * str =  [self dataFromHexString:key];
    NSString *uppercase = @"";
    NSUInteger len = [str length];
    Byte *keyBytes = (Byte*)malloc(len+8);
    memcpy(keyBytes, [str bytes], len);
    
    for (int j = 0, k = 16; j < 8;) {
        keyBytes[k++] = keyBytes[j++];
    }
    
    NSData * datMessage =  [self dataFromHexString:message];
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData =[NSData dataFromBase64String:message];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        plainTextBufferSize = [message length]/2;
        vplainText = (const void *) [message UTF8String];
    }
    
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    uint8_t iv[kCCBlockSize3DES];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionECBMode ,
                       keyBytes,
                       kCCKeySize3DES,
                       iv,
                       datMessage.bytes,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    /*if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    else */if (ccStatus == kCCParamError) return @"PARAM ERROR";
    else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
    else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
    else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
    else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
    else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED";
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [ [NSString alloc] initWithData: [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSASCIIStringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        NSString * str = [self NSDataToHex:myData];
        uppercase = [str uppercaseString];
        uppercase = [uppercase stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return uppercase;
}


/**
 Function to get hex string from data

 @param data data
 @return string in hex
 */
+ (NSString *) NSDataToHex:(NSData*)data
{
        const unsigned char *dbytes = [data bytes];
        NSMutableString *hexStr =
        [NSMutableString stringWithCapacity:[data length]*2];
        int i;
        for (i = 0; i < [data length]; i++) {
            [hexStr appendFormat:@"%02x ", dbytes[i]];
        }
        return [NSString stringWithString: hexStr];
}


/**
 Function to get string from hex

 @param str string in hex
 @return string
 */
+ (NSString *) stringFromHex:(NSString *)str{
        
        NSMutableData *stringData = [[NSMutableData alloc] init];
        unsigned char whole_byte;
        char byte_chars[3] = {'\0','\0','\0'};
        int i;
        for (i=0; i < [str length] / 2; i++) {
            byte_chars[0] = [str characterAtIndex:i*2];
            byte_chars[1] = [str characterAtIndex:i*2+1];
            whole_byte = strtol(byte_chars, NULL, 16);
            [stringData appendBytes:&whole_byte length:1];
        }
        return [[NSString alloc] initWithData:stringData encoding:NSASCIIStringEncoding];
}


/**
 Function to perform sha1

 @param str str
 @return return sha1 string
 */
+ (NSString *)sha1:(NSString *)str;
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return [output uppercaseString];
}

/**
 Fuction used to encrypt the mPin with 3DES using key and iv

 @param encryptValue value to be encrypted using 3DES
 @param key24Byte Key for encrypting
 @param IV IV for encrypting
 @return 3DES encrypted value
 */
+ (NSString *)encrypt:(NSString *)encryptValue key:(NSString *)key24Byte IV:(NSString *)IV{
    
    int keyLength = 24;
    int ivLength = 8;
    
    //Here we need to get the characters upto 24 only for Key
    NSString *newkey = key24Byte;
    if ([newkey length] > keyLength)
    {
        newkey = [newkey substringWithRange:NSMakeRange(0, keyLength)];
    }
    else
    {
        newkey = [newkey stringByAppendingString:@"uhfgkjsdcbxvskjdvszjnbkjsadhbzjhasdvfvddacs"];
        newkey = [newkey substringWithRange:NSMakeRange(0, keyLength)];
    }

    //Here we need to hey the iv for 8 characters for iv only
    NSString *newIV = IV;
    if ([newIV length] > ivLength)
    {
        newIV = [newIV substringWithRange:NSMakeRange(0, ivLength)];
    }
    
    
    NSData *keyData = [newkey dataUsingEncoding:NSUTF8StringEncoding];
    
    // our key is ready, let's prepare other buffers and moved bytes length
    NSData *encryptData = [encryptValue dataUsingEncoding:NSUTF8StringEncoding];
    size_t resultBufferSize = [encryptData length] + kCCBlockSize3DES;
    unsigned char resultBuffer[resultBufferSize];
    size_t moved = 0;
    
    // DES-CBC requires an explicit Initialization Vector (IV)
    // IV - second half of md5 key
    NSMutableData *ivData = [[newIV dataUsingEncoding:NSUTF8StringEncoding]mutableCopy];
    NSMutableData *iv = [NSMutableData dataWithData:ivData];
    
    CCCryptorStatus cryptorStatus = CCCrypt(kCCEncrypt, kCCAlgorithm3DES,
                                            kCCOptionPKCS7Padding , [keyData bytes],
                                            kCCKeySize3DES, [iv bytes],
                                            [encryptData bytes], [encryptData length],
                                            resultBuffer, resultBufferSize, &moved);
    
    if (cryptorStatus == kCCSuccess) {
        return [[NSData dataWithBytes:resultBuffer length:moved] base64EncodedStringWithOptions:0];
    } else {
        return nil;
    }
}
    
    /**
     Fuction used to encrypt the mPin with 3DES using key and iv
     
     @param decryptValue value to be encrypted using 3DES
     @param key24Byte Key for encrypting
     @param IV IV for encrypting
     @return 3DES encrypted value
     */
+ (NSString *)decrypt:(NSString *)decryptValue key:(NSString *)key24Byte IV:(NSString *)IV{
    
    int keyLength = 24;
    int ivLength = 8;
    
    //Here we need to get the characters upto 24 only for Key
    NSString *newkey = key24Byte;
    if ([newkey length] > keyLength)
    {
        newkey = [newkey substringWithRange:NSMakeRange(0, keyLength)];
    }
    else
    {
        newkey = [newkey stringByAppendingString:@"uhfgkjsdcbxvskjdvszjnbkjsadhbzjhasdvfvddacs"];
        newkey = [newkey substringWithRange:NSMakeRange(0, keyLength)];
    }
    
    //Here we need to hey the iv for 8 characters for iv only
    NSString *newIV = IV;
    if ([newIV length] > ivLength)
    {
        newIV = [newIV substringWithRange:NSMakeRange(0, ivLength)];
    }
    
    NSData *keyData = [newkey dataUsingEncoding:NSUTF8StringEncoding];
    
    // our key is ready, let's prepare other buffers and moved bytes length
    NSData *encryptData = [NSData dataFromBase64String:decryptValue];
    size_t resultBufferSize = [encryptData length];
    unsigned char resultBuffer[resultBufferSize];
    size_t moved = 0;
    
    // DES-CBC requires an explicit Initialization Vector (IV)
    // IV - second half of md5 key
    NSMutableData *ivData = [[newIV dataUsingEncoding:NSUTF8StringEncoding]mutableCopy];
    NSMutableData *iv = [NSMutableData dataWithData:ivData];
    
    CCCryptorStatus cryptorStatus = CCCrypt(kCCDecrypt, kCCAlgorithm3DES,
                                            kCCOptionPKCS7Padding , [keyData bytes],
                                            kCCKeySize3DES, [iv bytes],
                                            [encryptData bytes], [encryptData length],
                                            resultBuffer, resultBufferSize, &moved);
    
    
    
    if (cryptorStatus == kCCSuccess) {
        return [ [NSString alloc] initWithData: [NSData dataWithBytes:(const void *)resultBuffer length:(NSUInteger)moved] encoding:NSASCIIStringEncoding];
    } else {
        return nil;
    }
}
    
@end
