//
//  ViewController.m
//  SecureNSCoder
//
//  Created by Tom Daniels on 9/17/13.
//  Copyright (c) 2013 iSEC Partners. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

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
    self.restorationIdentifier = NSStringFromClass([self class]);
    self.restorationClass = [UIViewController class];
}

#pragma mark - UIStateRestoration

- (void)encodeRestorableStateWithCoder:(NSKeyedArchiver *)coder
{
    // preserve state
    SecureArchiverDelegate *saDelegate = [[SecureArchiverDelegate alloc] init];
    [self setDelegate:saDelegate];
    [coder setDelegate:[self delegate]];
    [coder encodeObject:[[self textField] text] forKey:@"textFieldText"];
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSKeyedUnarchiver *)coder
{
    // restore the preserved state
    SecureArchiverDelegate *saDelegate = [[SecureArchiverDelegate alloc] init];
    [self setDelegate:saDelegate];
    [coder setDelegate:[self delegate]];
    [[self textField] setText:[coder decodeObjectForKey:@"textFieldText"]];
    [super decodeRestorableStateWithCoder:coder];
}

@end
