//
//  SimpleKeychainWrapper.m
//  SecureNSCoder
//
//  Created by Tom Daniels on 9/5/13.
//  Copyright (c) 2013 iSEC Partners. All rights reserved.
//

#import "SimpleKeychainWrapper.h"

@implementation SimpleKeychainWrapper

+ (NSMutableData *)fetchFromKeychain:(NSString *)identifier forService:(NSString *)service
{
    NSMutableDictionary *searchDictionary = [self dictForId:identifier withService:service];
    
    // Add search attributes
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    // Add search return types
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    CFMutableDictionaryRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, (CFTypeRef *)&result);
    if (status == errSecSuccess) {
        return (__bridge id)(result);
    } else {
        return nil;
    }
}

+ (BOOL)addToKeychain:(NSData *)item withIdentifier:(NSString *)identifier forService:(NSString *)service
{
    NSMutableDictionary *dictionary = [self dictForId:identifier withService:service];
    
    [dictionary setObject:(__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    
    [dictionary setObject:item forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

+ (NSMutableDictionary *)dictForId:(NSString *)identifier withService:(NSString *)service
{
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:service forKey:(__bridge id)kSecAttrService];
    
    return searchDictionary;
}

@end
