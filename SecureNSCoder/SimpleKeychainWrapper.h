//
//  SimpleKeychainWrapper.h
//  SecureNSCoder
//
//  Created by Tom Daniels on 9/5/13.
//  Copyright (c) 2013 iSEC Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>


#define NSCoderCryptoKey @"com.isecpartners.CryptoKey"
#define NSCoderCryptoService @"com.isecpartners.NSCoder+Crypto"

@interface SimpleKeychainWrapper : NSObject
+ (id)fetchFromKeychain:(NSString *)identifier forService:(NSString *)service;
+ (BOOL)addToKeychain:(NSData *)item withIdentifier:(NSString *)identifier forService:(NSString *)service;
+ (NSMutableDictionary *)dictForId:(NSString *)identifier withService:(NSString *)service;
@end
