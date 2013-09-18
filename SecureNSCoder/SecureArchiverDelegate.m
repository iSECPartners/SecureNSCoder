//
//  SecureArchiverDelegate.m
//  SecureNSCoder
//
//  Created by Tom Daniels on 9/17/13.
//  Copyright (c) 2013 iSEC Partners. All rights reserved.
//

#import "SecureArchiverDelegate.h"

@implementation SecureArchiverDelegate

#pragma mark -

- (id)init
{
    if (self = [super init]) {
        return self;
    }
    return nil;
}

#pragma mark - NSKeyedArchiverDelegate methods

- (id)archiver:(NSKeyedArchiver *)archiver willEncodeObject:(id)object
{    
    NSData *serializedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    
    NSMutableData *buffer = [[NSMutableData alloc] init];
    
    if ([self crypt:serializedObject withOperation:kCCEncrypt andOutput:&buffer]) {
        return buffer;
    }
    return nil;
}

#pragma mark - NSKeyedUnarchiverDelegate methods

- (id)unarchiver:(NSKeyedUnarchiver *)unarchiver didDecodeObject:(id)object
{
    NSMutableData *buffer = [[NSMutableData alloc] init];
    
    if ([self crypt:object withOperation:kCCDecrypt andOutput:&buffer] ) {
        id decodedObject = [NSKeyedUnarchiver unarchiveObjectWithData:buffer];
        return decodedObject;
    }
    return nil;
}

#pragma mark - Crypto routines

- (BOOL)crypt:(NSData *)object withOperation:(CCOperation)operation andOutput:(NSMutableData **)output
{
    NSData *cryptKey = [SimpleKeychainWrapper fetchFromKeychain:NSCoderCryptoKey forService:NSCoderCryptoService];
    NSData * iv = [SimpleKeychainWrapper fetchFromKeychain:NSCoderIvKey forService:NSCoderCryptoService];
    size_t length = 0;
    
    size_t bufferSize = [object length] + kCCBlockSizeAES128;
    void* buff = malloc(bufferSize);
    
    CCCryptorStatus status = CCCrypt(operation,
                                     kCCAlgorithmAES128,
                                     kCCOptionPKCS7Padding,
                                     [cryptKey bytes],
                                     [cryptKey length],
                                     [iv bytes],
                                     [object bytes],
                                     [object length],
                                     buff,
                                     bufferSize,
                                     &length);
    
    if (status == kCCSuccess) {
        *output = [NSMutableData dataWithBytes:buff length:length];
        return YES;
    } else {
        NSLog(@"Encryption failed! %d", status);
        return NO;
    }
}

@end
