//
//  PXViewController.m
//  PXSDK
//

#import "PXViewController.h"
#import "PXTracker.h"

@interface PXViewController ()

@end

@implementation PXViewController

- (IBAction)sendLevel:(id)sender {
    [PXTracker recordLevelChangeEventFromLevel:@0 toLevel:@2];
}

- (IBAction)sendTutor:(id)sender {
    [PXTracker recordTutorialChangeEventFromStep:@0 toStep:@3];
}

- (IBAction)sendTranaction:(id)sender {
    [PXTracker recordTransactionEventWithName:@"test" buyVirtualCurrency:@"coins" receivingAmount:@21 usingRealCurrency:@"usd" spendingAmount:@3];
}

- (IBAction)sendCustom:(id)sender {
    [PXTracker sendEvent:@"myCustomEvent"];
}

- (IBAction)sendCurrency:(id)sender {
    [PXTracker recordСurrencyChangeEventWithLevel:@1 andCurrency:@300];
}

- (IBAction)testUserHaveOffer:(id)sender {
    BOOL offerPresent = [PXTracker userHasIAPOffer];
    NSString *stringOffer = offerPresent ? @"Yes" : @"No";
    [[[UIAlertView alloc] initWithTitle:@"userHasIAPOffer" message:stringOffer delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

@end
