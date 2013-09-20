//
//  ViewController.m
//  SecureNSCoder
//
//  Created by Tom Daniels on 9/17/13.
//  Copyright (c) 2013 iSEC Partners. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

#pragma mark -

- (id)initWithCoder:(NSKeyedUnarchiver *)coder
{
    if (self = [super initWithCoder:coder]) {
        return self;
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
    // Set the restoration identifier to let UIKit know we support state restoration
    self.restorationIdentifier = NSStringFromClass([self class]);
}

#pragma mark - UIStateRestoration

- (void)encodeRestorableStateWithCoder:(NSKeyedArchiver *)coder
{
    // Preserve the state of the view controller.
    
    // Set our SecureArchiverDelegate as the delegate for the NSKeyedArchiver.
    SecureArchiverDelegate *saDelegate = [[SecureArchiverDelegate alloc] init];
    [self setDelegate:saDelegate];
    [coder setDelegate:[self delegate]];
    
    // Encode the objects we need to preserve. They will then be encrypted by the delegate
    // when [NSKeyedArchiverDelegate archiver:willEncodeObject:] is called.
    [coder encodeObject:[[self textField] text] forKey:@"textFieldText"];
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSKeyedUnarchiver *)coder
{
    // Restore the state of the view controller.
    
    // Set our SecureArchiverDelegate as the delegate for the NSKeyedUnarchiver.
    SecureArchiverDelegate *saDelegate = [[SecureArchiverDelegate alloc] init];
    [self setDelegate:saDelegate];
    [coder setDelegate:[self delegate]];
    
    // Decode the objects preserved by the archiver. They will be decrypted by the delegate
    // when [NSKeyedUnarchiver unarchiver:didDecodeObject:] is called.
    [[self textField] setText:[coder decodeObjectForKey:@"textFieldText"]];
    [super decodeRestorableStateWithCoder:coder];
}

@end
