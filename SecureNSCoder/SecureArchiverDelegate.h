//
//  SecureArchiverDelegate.h
//  SecureNSCoder
//
//  Created by Tom Daniels on 9/17/13.
//  Copyright (c) 2013 iSEC Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleKeychainWrapper.h"

@interface SecureArchiverDelegate : NSObject <NSKeyedArchiverDelegate, NSKeyedUnarchiverDelegate>

- (BOOL)crypt:(NSData *)object withOperation:(CCOperation)operation andOutput:(NSMutableData **)output;

@end
