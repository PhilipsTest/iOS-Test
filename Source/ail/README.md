## Platform Version 1901
* Removed content manager module
* Removed Keybag manager module
* Deprecated Service Discovery apis, now using only two common apis for country and language specific
* Deprecated getCloudconsentIdentifier and hsdpuuid and moved to CloudLoggingConsent 
* Updated AdobeMobileSDK version from '4.17' to '4.18'
* CocoaLumberJack version updated from ‘3.4.2’ to ‘3.5.1’

## Platform Version 1805
* Added an api in rest client interface to clear all cache data (use it cautiously).
* Added an api in A/B-Test interface to tag events to firebase.
* Modified Adobe Privacy Status Opt-Out behaviour. For more Info on this please refer ([Confluence Page](https://confluence.atlas.philips.com/display/MOB/How+to+Use+Tagging)))

## Platform Version 1804
* Removed api configureAnalyticsWithFilePath in AIAppTaggingProtocol
* Modified the ABTest Protocol Completely.
* A/B testing now uses FireBase. ([How to integrate?](https://confluence.atlas.philips.com/pages/viewpage.action?pageId=29821684))

## Platform Version 1803
* Deprecated api configureAnalyticsWithFilePath in AIAppTaggingProtocol

## Platform Version 1802
* New feature is added for enabling and disabling Cloud logging
* Added new 2 new api's and 1 property setter in the logging protocol for the cloud logging.

## Platform Version 2018.1.0
* Consent manager is added for registering/deregistering consent handlers as a part of GDPR

## Platform Version 3.0.0
*  New feature mobile app key manager
*  logging config added to app configuratin
*  proposition specific ab test configurations
*  PSRA defect fixes
*  bug fixes

## Platform Version 2.2.0
*  new feature appupdate
*  logs component name is now TLA
*  appinfra code snippets added to repo
*  locale special handling for zh-Hans(zh_CN) & zh-Hant(zh_TW)
*  new api in logging for dictionary
*  Demo with microapp template
*  Timesync issues fixed
*  Tagging pagename validations
*  Deletion of language pack if locale change
*  AppConfig reset api added
*  one log to show device name and os


## Platform Version 2.1.0
*  new feature language pack . activate, refresh and generic api to get localized string
*  limiting service discovery environment
*  psr defects fixed
*  component version added
*  mutiple url configs merge in service discovery
*  Logging configurations added to appconfig file
*  new how to pages in confluence
*  isSyncronised api in Time module, also few bugs were fixed
*  fixed REST client cache encryption bug
*  callback api for tagging
*  option to disable proposition microsite id
*  new api in tagging to get tracking identifier
*  api to detect device is jailbroken
*  sd improvements - caching home country
*  repos are migrated to tfs


## Platform Version 1.1.0
<p>

*	US11828 - Service Discovery inject parameters in the URL
*	US13345 - Service Discovery refresh when home country is changed
*	App config keys are now case insensitive
*   App config cloud support
*   Service discovery data persistant across app launches
*   Service Discovery server call will be locked for 10 seconds
*   PRX dependancy removed from AppInfra
*   Service Discovery alternate implementation using CSV available as seperate repo
*   Service discovery match by country result filtered based on user preferred languages in case of multiple locales for a country
*   Inject parameters to service url in service discovery
*   Multiple microsite id support one for proposition one for platform
*   Content loader data will be flushed for language change
*   content loader limit per instance
*   Network reachability is implemented in AppInfra as part of REST client
*   Internationalization now returnes the locale that app UI was rendered. Country part may not be there

## Description

App Infra provides a range of modules that are the basis for any mobile application. App Infra is integrated as one single library in the application. App Infra in itself is not an operational entity but only exists in the context of an application. App Infra ensures that all modules provided by App Infra are linked to each other where needed. All modules together are exposed to the application through a single set of well-defined interfaces. App Infra is not only used by the application but also by all common components that are integrated in the application.
As such App Infra can be seen as a basic layer of functionality in the SW stack that is positioned somewhere between the app and the device’s OS. App Infra is not designed to abstract the operating system; App Infra provides additional functionality on top of the operating system making use of the operating system.
Some of the App Infra depend on cloud servers to provide the required functionality. In those cases, App Infra abstracts the cloud server such that the users of App Infra are not directly exposed to the typical problems of remote services.

## Modules
* Secure storage module - Secure Storage is used to store secret value in device storage with encrypted way using AES Encryption. It uses key value pair concept to store data inside the apps.

* Service discovery module - Service Discovery reduces the hard dependency between app and cloud services. The main idea is that the list of URLs that are to be used by an application is maintained server side, at the service discovery server. The app only has to download this list from one single global location, this list tells the app where all other cloud services can be found.

* App tagging module - App tagging is used to track pages and button actions of the propositions or common components with page/action name and several other default values such as timestamps,device info,OS info etc.

* Logging module - Logging is used to maintain the logs which user access of the propositions or common components with page/action name and several other default values such as UTC timestamps, Log type, Component ID, Event and Message.

* Time module - feature provides an APIs to retrieve the UTC server time accurately.
It also perform synchronization for every 24hrs and whenever there is a Data and time change.

* Internationalization module - provided APIs to fetch Locale from Android settings.

* App identity module - The App identity feature shall provide an API to get the app release status: development, test, acceptance, production.
The App identity feature shall obtain the technical app name, app version and app release status automatically from the build application build process.



* App config module - The app configuration module maintains configuration settings of the app and it’s included common components, in the form of key value pair.

* REST client module - The REST client module simplifies communication with cloud services that use a REST based interface. Which is built upon AFNetworking Library

* A/B test module - 
The A/B test client module assists in performing A/B tests in the application. The client communicates with server which distributes users over the test experiences. A test is identified by its test name. when offline, the cached data is used if available instead of the default value to ensure a consistent user experience irrespective of network availability.

* Content loader module - This feature has a dedicated purpose of caching the articles from the CQ5 server for the application. The articles could be in the form of text, images, document etc. This library will download all the articles available at the application specified URL and store it internally

* API signing module - Some HSDP services use API signing (and not an oAuth token) to prove the caller is a known app. App Infra is providing an API which can create a signature for a given data blob. The signature is created using an algorithm provided by Philips Security Technologies plus a key. As multiple services may require different signatures, the key may differ per signature created.
* Language Pack - All apps contain text which is visualized to the user in some way, mainly this text is shown directly in the UI. A part of this text is more or less static and fundamental to the operation of the app. For that reason, this text is embedded according to the App UI internationalization guidelines. The text is shown in the locale as selected by the user on his device. This module enable to change these texts dynamically from cloud

## Installation

* Using cocoapods - add philips cocoapod repo and add   ```  pod 'AppInfra' ``` to pod file
* Using Frameworks - AppInfra library binary code is available in AppInfra repository under Binary folder. All the dependency frameworks needs to be installed separately. AppInfra depends on the following libraries.
    - AdobeMobileSDK
    - CocoaLumberJack
    - AFNetworking
    - TrueTime
    - PlatformInterfaces


## Code Example - Quick integration

Refer integration document. Integration document is part of appinfra repo (Documents/External/Integration Document_Appinfra).
 - Intergration Doc [Dev portal,](http://devportal.spssvr1.htce.nl.philips.com/releases) [TFS](http://tfsemea1.ta.philips.com:8080/tfs/TPC_Region24/CDP2/TEAM%20Huma/_git/plf-ios?path=%2FSource%2Fail%2FDocuments%2FExternal&version=GBdevelop&_a=contents), [Confluence](https://confluence.atlas.philips.com/display/MOB/AIL+IOS+integration+document)



## Documentation - 

[How to articles](https://confluence.atlas.philips.com/display/MOB/How-to+articles+-+AIL)

* [AppInfra Getting Started](https://confluence.atlas.philips.com/display/MOB/AppInfra+Getting+Started?src=contextnavpagetreemode)
* [AppInfra Logging](https://confluence.atlas.philips.com/display/MOB/AppInfra+Logging?src=contextnavpagetreemode)
* [How to configure A/B testing](https://confluence.atlas.philips.com/pages/viewpage.action?pageId=29821684&src=contextnavpagetreemode)
* [How to setup App Configuration for an app](https://confluence.atlas.philips.com/display/MOB/How+to+setup+App+Configuration+for+an+app?src=contextnavpagetreemode)
* [How to set up Cloud configuration](https://confluence.atlas.philips.com/display/MOB/How+to+set+up+Cloud+configuration?src=contextnavpagetreemode)
* [How to Use App update information](https://confluence.atlas.philips.com/display/MOB/How+to+Use+App+update+information?src=contextnavpagetreemode)
* [How to use Cloud Logging?](https://confluence.atlas.philips.com/pages/viewpage.action?pageId=45894064&src=contextnavpagetreemode)
* [How-To-Use-InApp Text updates (Language Pack)](https://confluence.atlas.philips.com/pages/viewpage.action?pageId=19012137&src=contextnavpagetreemode)
* [How to use Secure Data Base (Android )](https://confluence.atlas.philips.com/pages/viewpage.action?pageId=24216834&src=contextnavpagetreemode)
* [How to Use Tagging](https://confluence.atlas.philips.com/display/MOB/How+to+Use+Tagging?src=contextnavpagetreemode)
* [How to use UTC Timesync module](https://confluence.atlas.philips.com/display/MOB/How+to+use+UTC+Timesync+module?src=contextnavpagetreemode)
* [SSL pinning](https://confluence.atlas.philips.com/display/MOB/SSL+pinning?src=contextnavpagetreemode)



## <a name="team-members"></a>Contact details

 * Team Amaron - <dl_iet_amaron@philips.com> 


## License
 * Copyright (c) Koninklijke Philips N.V., 2018 All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*

