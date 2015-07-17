//
//  PXViewController.m
//  PXSDK
//
//  Created by Ankudinov Alexander on 07/16/2015.
//  Copyright (c) 2015 Ankudinov Alexander. All rights reserved.
//

#import "PXViewController.h"
#import "GITracker.h"

@interface PXViewController ()

@end

@implementation PXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendLevel:(id)sender {
    [GITracker recordLevelChangeEventFromLevel:@0 toLevel:@2];
}

- (IBAction)sendTutor:(id)sender {
    [GITracker recordTutorialChangeEventFromStep:@0 toStep:@3];
}

- (IBAction)sendTranaction:(id)sender {
    [GITracker recordTransactionEventWithName:@"test" buyVirtualCurrency:@"coins" receivingAmount:@21 usingRealCurrency:@"usd" spendingAmount:@3];
}

- (IBAction)sendCustom:(id)sender {
    [GITracker sendEvent:@"poppop"];
}

- (IBAction)sendCurrency:(id)sender {
    [GITracker recordСurrencyChangeEventWithLevel:@1 andCurrency:@300];
}

- (IBAction)testUserHaveOffer:(id)sender {
    
    BOOL offerPresent = [GITracker userHasIAPOffer];
    
    NSString *stringOffer = offerPresent ? @"Yes" : @"No";
    
    [[[UIAlertView alloc] initWithTitle:@"userHasIAPOffer" message:stringOffer delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
}

@end
