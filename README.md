# PXSDK

[![CI Status](http://img.shields.io/travis/Ankudinov Alexander/PXSDK.svg?style=flat)](https://travis-ci.org/Ankudinov Alexander/PXSDK)
[![Version](https://img.shields.io/cocoapods/v/PXSDK.svg?style=flat)](http://cocoapods.org/pods/PXSDK)
[![License](https://img.shields.io/cocoapods/l/PXSDK.svg?style=flat)](http://cocoapods.org/pods/PXSDK)
[![Platform](https://img.shields.io/cocoapods/p/PXSDK.svg?style=flat)](http://cocoapods.org/pods/PXSDK)

#SDK integration instructions

PXSDK is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PXSDK"
```

Import "GITracker.h" to your AppDelegate.m file, and init GITracker with your game API key in didFinishLaunchingWithOptions delegate:
```obj-c
[GITracker setGameKey:@"THATYOURAPIKEY"];
```
Import "GITracker.h" in all the files where you want to track events.

Add that requirements frameworks to your project:
  * MobileCoreServices.framework
  * SystemConfiguration.framework
  * CoreLocation.framework
  * CFNetwork.framework

#List of tracking events and offer availability
  * sendEvent         - eventName
  * levelChange       - timeStamp, fromLevel, toLevel
  * tutorialChange    - timeStamp, fromStep, toStep
  * transactionEvent  - timeStamp, withName, buyVirtualCurrenct, receivingAmount, usingRealCurrency, spendingAmount
  * userHasIAPOffer  - no parameters, return YES if IAPOffer is avaible

##Custom event

Level change event consists of two fields that you can use to describe a users level change in your app:
* NSString eventName

```obj-c
[GITracker sendEvent:@"customEventName"];
```

##Level change event

Level change event consists of two fields that you can use to describe a users level change in your app:
* NSNumber fromLevel
* NSNumber toLevel

```obj-c
[GITracker recordLevelChangeEventFromLevel:@0 toLevel:@2];
```
 
##Tutorial step change event

Tutorial step change event consists of two fields that you can use to describe a users level change in your app:
* NSNumber fromStep
* NSNumber toStep

```obj-c
[GITracker recordTutorialChangeEventFromStep:@0 toStep:@3];
```     

##Transaction event

Transaction event consists of five fields that you can use to describe a users level change in your app:
* NSString WithName
* NSString buyVirtualCurrency
* NSNumber receivingAmount
* NSString usingRealCurrency
* NSNumber spendingAmount

```obj-c
    [GITracker recordTransactionEventWithName:@"test" buyVirtualCurrency:@"coins" receivingAmount:@21 usingRealCurrency:@"usd" spendingAmount:@3];
```

##Availability of IAPOffer 

Return  YES BOOL value if IAPOffer enabled for the moment:

```obj-c
BOOL offerPresent = [GITracker userHasIAPOffer];
```   

# Author

Ankudinov Alexander, sasha@ankudinov.org.ua

# License

PXSDK is available under the MIT license. See the LICENSE file for more info.
