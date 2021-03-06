# PXSDK

[![CI Status](http://img.shields.io/travis/agilie/PXSDK.svg?style=flat)](https://travis-ci.org/agilie/PXSDK)
[![Version](https://img.shields.io/cocoapods/v/PXSDK.svg?style=flat)](http://cocoapods.org/pods/PXSDK)
[![License](https://img.shields.io/cocoapods/l/PXSDK.svg?style=flat)](http://cocoapods.org/pods/PXSDK)
[![Platform](https://img.shields.io/cocoapods/p/PXSDK.svg?style=flat)](http://cocoapods.org/pods/PXSDK)

#SDK integration instructions

PXSDK is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PXSDK"
```

Import "PXTracker.h" to your AppDelegate.m file, and init PXTracker with your game API key in didFinishLaunchingWithOptions delegate passing YES param if you want to use APNS for tracking:
```obj-c
[PXTracker initializeWithGameKey:@"Testgame01" enableDeviceToken:NO];
```

If you want to enable device token just perform method setupUserPredictionsForToken in didRegisterForRemoteNotificationsWithDeviceToken:

```obj-c

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [PXTracker setupUserPredictionsForToken:[deviceToken description]];
}
```
To show APNS rewards as UIAlerView you should add

```obj-c
 
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  .....
  if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
    [PXTracker processLaunchOptions:launchOptions];
  }
  
  
  return YES;
}
 
- (void)application:(UIApplication )application didReceiveRemoteNotification:(NSDictionary )userInfo {
    [PXTracker processPushNotification:userInfo];
 }
```

To handle virtual currency from rewards your class should conforms to protocol PXTrackerProtocol and responds to selector:

- (void)addVirtualCurrency:(NSNumber *)virtualCurrency;

Import "PXTracker.h" in all the files where you want to track events.

Add that requirements frameworks to your project:
  * MobileCoreServices.framework
  * SystemConfiguration.framework
  * CFNetwork.framework

#List of tracking events and offer availability
  * sendEvent         - eventName, parameters dictonary
  * levelChange       - timeStamp, fromLevel, toLevel, currency
  * tutorialChange    - timeStamp, fromStep, toStep
  * transactionEvent  - timeStamp, withName, buyVirtualCurrenct, receivingAmount, usingRealCurrency, spendingAmount
  * userHasIAPOffer  - no parameters, return YES if IAPOffer is avaible

##Custom event

Level change event consists of two fields that you can use to describe a users level change in your app:
* NSString eventName
* NSDictionary custom parametersList

```obj-c
[PXTracker sendEvent:@"myCustomEvent" withParams:@{@"paramName":@"paramValue"}];
```

##Level change event

Level change event consists of two fields that you can use to describe a users level change in your app:
* NSNumber fromLevel
* NSNumber toLevel

```obj-c
[PXTracker recordLevelChangeEventFromLevel:@0 toLevel:@2 andCurrency:@20];
```
 
##Tutorial step change event

Tutorial step change event consists of two fields that you can use to describe a users level change in your app:
* NSNumber fromStep
* NSNumber toStep

```obj-c
[PXTracker recordTutorialChangeEventFromStep:@0 toStep:@3];
```     

##Transaction event

Transaction event consists of five fields that you can use to describe a users level change in your app:
* NSString WithName
* NSString buyVirtualCurrency
* NSNumber receivingAmount
* NSString usingRealCurrency
* NSNumber spendingAmount

```obj-c
[PXTracker recordTransactionEventWithName:@"test" buyVirtualCurrency:@"coins" receivingAmount:@21 usingRealCurrency:@"usd" spendingAmount:@3];
```

##Availability of IAPOffer 

Return  YES BOOL value if IAPOffer enabled for the moment:

```obj-c
BOOL offerPresent = [PXTracker userHasIAPOffer];
```   

# Author

Sid99

# License

PXSDK is available under the MIT license. See the LICENSE file for more info.
