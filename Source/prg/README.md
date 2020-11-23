# PhilipsProductRegistration

![Build Status](http://cdp2-jenkins.htce.nl.philips.com:8080/buildStatus/icon?job=ProductRegistration/prg_iOS/develop) ![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg) ![CocoaPods](https://img.shields.io/badge/pod-v2017.5.0-blue.svg) ![Language](https://img.shields.io/badge/language-Swift-yellow.svg)

PhilipsProductRegistration is an **Product Management framework** that enables iOS applications across Philips to perform product registration.

With PhilipsProductRegistration framework, you can allow your users to register products and fetch the registered product.

PhilipsProductRegistration APIs allow applications to build their own UI or launch framework's UI, which uses Philips wide **DLS standard**, for product registration.



## Compatibility

PhilipsRegistration requires **iOS 10+** and is compatible with **Objective-C** or **Swift 3** and above.



## Dependencies

PhilipsProductRegistration has dependency on following frameworks:

* AppInfra
* AppAuth
* libPhoneNumber-iOS
* PhilipsUIKitDLS
* PhilipsIconFontDLS
* UAPPFramework
* PhilipsRegistration



## Installation

PhilipsProductRegistration supports installation via pods or can be included as framework.

* Installation via [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

  ```ruby
  source 'http://tfsemea1.ta.philips.com:8080/tfs/TPC_Region24/CDP2/_git/cocoapod-specs’

  platform :ios, '10.0'
  target 'ProjectName' do
  	use_frameworks!
  	pod 'PhilipsProductRegistration'
  end
  ```

* Embed **PhilipsProductRegistration.framework** into your project by downloading it from Artifactory. Make sure to download and include dependent frameworks as well.

For more details, please find the [integration document](https://confluence.atlas.philips.com/display/UC/PR+%7C+Product+Registration)
