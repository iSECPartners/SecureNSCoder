//
//  ViewController.h
//  SecureNSCoder
//
//  Created by Tom Daniels on 9/17/13.
//  Copyright (c) 2013 iSEC Partners. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecureArchiverDelegate.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) SecureArchiverDelegate *delegate;

@end
