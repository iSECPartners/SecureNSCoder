//
//  SecureArchiverDelegate.m
//  SecureNSCoder
//
//  Created by Tom Daniels on 9/17/13.
//  Copyright (c) 2013 iSEC Partners. All rights reserved.
//

#import "SecureArchiverDelegate.h"

// Private category to limit access to the encryption routine to instances of SecureArchiverDelegate
@interface SecureArchiverDelegate ()

- (BOOL)crypt:(NSData *)object withOperation:(CCOperation)operation andOutput:(NSMutableData **)output;

@end

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
    // Serialize objects to NSData so that we can encrypt them before they are passed to the archiver and persisted.
    
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
    // Decrypt objects after they are restored and deserialize them from NSData. The object will be
    // casted back to it's original type in [UIApplicationDelegate decodeRestorableStateWithCoder].
    
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
    // Fetch the encryption/decryption key from the Keychain. The keychain wrapper in this example is far
    // from complete and serves to imitate the use of robust wrapper in real-world applications.
    NSMutableData *cryptKey;
    cryptKey = [SimpleKeychainWrapper fetchFromKeychain:NSCoderCryptoKey forService:NSCoderCryptoService];
    
    if (!cryptKey) {
        
        // If they key does not exist, generate a new one using the built-in PRNG and store it into the Keychain.
        
        cryptKey = [[NSMutableData alloc] initWithLength:kCCKeySizeAES256];
        SecRandomCopyBytes(kSecRandomDefault, kCCKeySizeAES256, [cryptKey mutableBytes]);
        
        if (![SimpleKeychainWrapper addToKeychain:cryptKey withIdentifier:NSCoderCryptoKey forService:NSCoderCryptoService]) {
            return NO;
        }
    }
    
    NSMutableData * iv;
    
    if (operation == kCCDecrypt) {
        
        // The IV is the first 32 bytes of the ciphertext.
        
        NSRange ivRange = {0,32};
        iv = [[NSMutableData alloc] initWithData:[object subdataWithRange:ivRange]];
        
        NSRange dataRange = {32, [object length]-32};
        object = [object subdataWithRange:dataRange];
        
    } else {
        
        // For encryption we need to generate a new IV using the PRNG.
        
        iv = [[NSMutableData alloc] initWithLength:kCCKeySizeAES256];
        SecRandomCopyBytes(kSecRandomDefault, kCCKeySizeAES256, [iv mutableBytes]);
    }
    
    // Perform the crypto operation
    
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
        
        if (operation == kCCEncrypt) {
            
            // Prepend the IV to the ciphertext so it's easily accessible when decrypting.
            *output = [[NSMutableData alloc] initWithData:iv];
            [*output appendBytes:buff length:length];
            
        } else {
            *output = [NSMutableData dataWithBytes:buff length:length];
        }
        free(buff);
        return YES;
        
    } else {
        NSLog(@"Encryption failed! %d", status);
        free(buff);
        return NO;
    }
}

@end
