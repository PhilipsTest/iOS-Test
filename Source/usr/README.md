# PhilipsRegistration

![Build Status](http://cdp2-jenkins.htce.nl.philips.com:8080/buildStatus/icon?job=UserRegistration/usr_iOS/develop) ![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg) ![CocoaPods](https://img.shields.io/badge/pod-v11.0.0-blue.svg) ![Language](https://img.shields.io/badge/language-Objective--C-yellow.svg)![Documentation](http://cdp2-jenkins.htce.nl.philips.com:8080/view/CI-pipeline-develop%20iOS/job/UserRegistration/job/usr_iOS/job/develop/Documentation/badge.svg)

PhilipsRegistration is an **Identity Management framework** that enables iOS applications across Philips to perform user authentication and authorisation.

With PhilipsRegistration framework, you can allow your users to register or login to your application using Janrain Backend and optionally HSDP Backend.

PhilipsRegistration APIs allow applications to build their own UI or launch framework's UI, which uses Philips wide **DLS standard**, for user authentication.



## Compatibility

PhilipsRegistration requires platform supported versions and is compatible with **Objective-C** or **Swift 3** and above.



## Dependencies

PhilipsRegistration has dependency on following frameworks:

* AppInfra
* AppAuth
* libPhoneNumber-iOS
* PhilipsUIKitDLS
* PhilipsIconFontDLS
* UAPPFramework

For version dependencies please refer this soup list link.
[SOUP list](https://confluence.atlas.philips.com/display/CPA/SDK%27s%2C+3rd+Party+libraries)

## Installation

PhilipsRegistration supports installation via pods or can be included as framework.

* Installation via [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

  ```ruby
  source 'https://bitbucket.atlas.philips.com/scm/pi/cocoapod-specs-stage.git'

  platform :ios, '10.0'
  target 'ProjectName' do
  	use_frameworks!
  	pod 'PhilipsRegistration'
  end
  ```

* Embed **PhilipsRegistration.framework** into your project by downloading it from Artifactory. Make sure to download and include dependent frameworks as well.



## Usage

* **Configuration:** `PhilipsRegistration` reads all its configurations from `AppInfra`'s appConfig except for flow and content configurations which need to be provided via `URLaunchInput` during launch. Configurations can be provided either via `AppConfig.json` file in app bundle or via code at runtime. Theme configurations can be set `PhilipsRegistration` via `UIDThemeManager` that is used by all components to set theming.

  * **AppConfig.json**

    ```json
    {
        "UserRegistration": {
            "JanRainConfiguration.RegistrationClientID.Staging": {"default":"c_id"},
            "JanRainConfiguration.RegistrationClientID.Production": {"default":"c_id"},
            "SigninProviders": {"CN":["wechat"],"default":["facebook","googleplus"]}
        },
        "appinfra": {
            "appidentity.micrositeId" : "77000",
            "appidentity.sector"  : "b2c",
            "appidentity.appState"  : "Staging",
            "appidentity.serviceDiscoveryEnvironment"  : "Production",
            "abtest.precache":["DOT-ReceiveMarketingOptIn"],
            "servicediscovery.platformMicrositeId": "70000",
            "servicediscovery.platformEnvironment": "Production"
        }
    }
    ```

    Note that ==**_myphilips_** login option is mandatory== and must not be provided in `SigninProviders`. Please [see here](https://confluence.atlas.philips.com/display/MOB/Complete+AppConfig.json) for all the possible configurations (and their format) that can be provided via `AppConfig.json`.

  * **Runtime Configurations**

    ```objective-c
    //Create AppInfra object
    AppInfra *appInfra = [[AppInfra alloc] initWithBuilder:nil];

    //Set configurations to AppInfra's AppConfig property
    [appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.ApplicationName"
                                    group:@"UserRegistration"
                                    value:@"uGrow"
                                    error:&error];

    [appInfra.appConfig setPropertyForKey:@"servicediscovery.countryMapping"
                                    group:@"appinfra"
                                    value:@{@"LU": @"BE", @"MO": @"HK"}
                                    error:&error];
    ```

    Please [see here](https://confluence.atlas.philips.com/display/MOB/Complete+Runtime+Configurations) for all the possible configurations that can be provided via code.

    ​

  * **DLS Theme Configuration**

    ```objective-c
    //Create theme configuration
    UIDThemeConfiguration *themeConfiguration = [[UIDThemeConfiguration alloc] initWithColorRange:UIDColorRangeGroupBlue tonalRange:UIDTonalRangeUltraLight navigationTonalRange:UIDTonalRangeUltraLight];

    //Create theme from the theme configuration
    UIDTheme *theme = [[UIDTheme alloc] initWithThemeConfiguration:themeConfiguration];

    //Optinally set background image for components to use as screen background
    theme.applicationBackgroundImage = self.selectedBackgroundImage;

    //Set created theme as default theme
    [[UIDThemeManager sharedInstance] setDefaultThemeWithTheme:theme
     							    applyNavigationBarStyling:YES];
    ```

    More details on DLS i.e. `PhilipsUIKitDLS` API documentation can be found [here](http://cdp2-jenkins.htce.nl.philips.com:8080/job/DLS-UIKit/job/DLS-UIKit-iOS/job/develop/Documentation/).

    ​

* **Initialization:** `PhilipsRegistration` ==requires to be initialized before any of its APIs could be called==, as below:

  ```objective-c
  //AppInfra object is required to intialize PhilipsRegistration. It is used to read app configurations, ServiceDiscovery, AppTagging other purposes.
  AppInfra *appInfra = [[AppInfra alloc] initWithBuilder:nil];
  
  //Set any/all runtime configuration(s)
  [appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.ApplicationName"
                                  group:@"UserRegistration"
                                  value:@"Your_HSDP_APP_NAME"
                                  error:&error];
  
  //Once you have AppInfra object, create URDependencies and assign appInfra object to it.
  URDependencies *dependencies = [[URDependencies alloc] init];
  dependencies.appInfra = appInfra;
  
  //Once dependencies are ready, PhilipsRegistration can be initialized by creating URInterface object.
  URInterface *urInterface = [[URInterface alloc] initWithDependencies:dependencies andSettings:nil];
  ```

  ​

* **Launching**: Launching **PhilipsRegistration UI** requires `URLaunchInput` object. This `URLaunchInput` object can be used to inform `PhilipsRegistration` which flow to launch and what content to display, as below:

  ```objective-c
  //Create URLaunchInput object.
  URLaunchInput *launchInput = [[URLaunchInput alloc] init];
  
  //Set launch input delegate to receive callback to display Terms & Conditions and Privacy Policy.
  launchInput.delegate = self; //self should implement DIRegistrationConfigurationDelegate
  
  //Set flow configurations for launchInput.
  launchInput.registrationFlowConfiguration.hideCountrySelection = YES;
  launchInput.registrationFlowConfiguration.enableLastName = YES;
  
  //Set content configurations for launch input.
  launchInput.registrationContentConfiguration.valueForRegistrationTitle = @"Your_Title_String";
  launchInput.registrationContentConfiguration.valueForRegistrationDescription = @"Your_Description_String";
  
  //Once launch input is prepared, PhilipsRegistration can be asked to return screen based on launch input
  UIViewController *viewController = [self.urInterface instantiateViewController:launchInput withErrorHandler:^(NSError * _Nullable error) {
    //This block will be called when PhilipsRegistration exits
    //Here check if user is logged in and allow them to continue
    if ([[DIUser getInstance] userLoggedInState] == URLoggedInStateUserLoggedIn) {
        //User is logged in
    } else {
        //User is not logged in
    }
  }];
  
  //Launch PhilipsRegistration by pushing it to your navigation controller.
  [self.navigationController pushViewController:viewController animated:YES];
  ```

  **Note:** `PhilipsRegistration` does not launch and start navigation automatically. If instantiated correctly, it returns a UIViewController instance which needs to be added to UINavigationController by application to start PhilipsRegistration navigation.

  ​

* **Other APIs:** PhilipsRegistration provides other APIs that can be called without launching the UI **(though initialization is still necessary before this step)**. Some of which are:

  * **Refresh Login Session:** Applications can ask `PhilipsRegistration` to refresh session of currently logged in user by invoking this API. This API will try to refresh and generate new access tokens for currently logged in user from Janrain and optionally from HSDP.

    ```objective-c
     //Add listener to be informed if refresh was successful or failed
    [[DIUser getInstance] addSessionRefreshListener:self];
    
    //Implement SessionRefreshDelegate methods
    //-(void)loginSessionRefreshSucceed {}
    //-(void)loginSessionRefreshFailedWithError:(nonnull NSError*)error {}
    //-(void)loginSessionRefreshFailedAndLoggedout {}
    
    //Call session refresh
    [[DIUser getInstance] refreshLoginSession];
    ```

  * **Refetch User Profile:** Applications can request `PhilipsRegistration` to refetch latest user profile from server.

    ```objective-c
    //Add listener to be informed if refetch was successful
    [[DIUser getInstance] addUserDetailsListener:self];
    
    //Implement Delegate methods
    //-(void)didUserInfoFetchingFailedWithError:(nonnull NSError *)error {}
    //-(void)didUserInfoFetchingSuccessWithUser:(nonnull DIUser *)profile {}
    
    //Call refetch profile
    [[DIUser getInstance] refetchUserProfile];
    ```

  * **Update User Profile:** Applications can update user's profile by invoking `PhilipsRegistration` APIs as below:

    ```objective-c
    //Add listener to be informed if update was successful
    [[DIUser getInstance] addUserDetailsListener:self];
    
    //Implement update delegate methods
    //-(void)didUpdateSuccess {}
    //-(void)didUpdateFailedWithError:(nonnull NSError *)error {}
    
    //Call update API
    [[DIUser getInstance] updateGender:UserGenderFemale withBirthday:[NSDate date]];
    ```

  * **GDPR:** Applications can integrate GDPR  by invoking `PhilipsRegistration` APIs as below:

    ```objective-c
    //Create ConsentDefinition object by calling fetchMarketingConsentDefinition method and pass locale as a parameter
    ConsentDefinition *consentDefinition = [URConsentProvider fetchMarketingConsentDefinition:@"locale_value e.g en_US"];
    
    //Create marketing consent handler
    URMarketingConsentHandler *marketingConsentHandler = [[URMarketingConsentHandler alloc] init];
    
    //URMarketingConsentHandler implements ConsentHandlerProtocol methods to fetch/store marketing consent of user. Using URMarketingConsentHandler object, following set of methods can be called as per need
    //- (void)fetchConsentTypeStateFor:(NSString * _Nonnull)consentType completion:(void (^ _Nonnull)(ConsentStatus * _Nullable, NSError * _Nullable))completion
    //- (void)storeConsentStateFor:(NSString * _Nonnull)consentType withStatus:(BOOL)status withVersion:(NSInteger)version completion:(void (^ _Nonnull)(BOOL, NSError * _Nullable))completion
    ```
    More details on GDPR can be found [here](https://confluence.atlas.philips.com/display/HDC/GDPR)

  * **Facebook SDK Integration:**   `PhilipsRegistration` allows applications to take benefit of enhanced user experience during *Facebook* login by adding *Facebook iOS SDK* and configuring it. More this can be found [here](https://confluence.atlas.philips.com/pages/viewpage.action?pageId=45883669). 

  More details on  `PhilipsRegistration` APIs can be found [here](http://cdp2-jenkins.htce.nl.philips.com:8080/view/CI-pipeline-develop%20iOS/job/UserRegistration/job/usr_iOS/job/develop/Documentation/)
  
 * **COPPA:** Applications can integrate COPPA flow  by invoking `PhilipsRegistration` APIs as below:
  
    ```objective-c
   //DIUser has a property called "consents" which returns all the user consents stored in Janrain Backend. Currently applicable only for COPPA Consents. 
   //@property (nonatomic, strong, readonly, nullable) NSArray *consents;
  
   //DIUser has following methods to update the consent and also to get the consent approval confirmation.
   //- (void)updateUserConsent:(BOOL)accepted withCompletion:(void(^_Nullable)(NSError * _Nullable error))completion{}
   //- (void)updateUserConsentApproval:(BOOL)accepted withCompletion:(void(^_Nullable)(NSError * _Nullable error))completion{}
  
   //DICOPPAExtension defines methods that can be used by applications to query COPPA Consent status of logged in user.
   //- (DICOPPASTATUS)getCoppaEmailConsentStatus{}
   //- (NSString *)getCoppaConsentLocale{}
   //- (void)fetchCoppaEmailConsentStatusWithCompletion:(void(^)(DICOPPASTATUS status, NSError *error))completion{}
   ```


## Upgrading to PhilipsRegistration DLS

If you already have `PhilipsRegistration` integrated in your application and you would like to upgrade to DLS version of it, you could find all the changes we have to our APUs and file [over here](https://confluence.atlas.philips.com/pages/viewpage.action?pageId=29840582).



## Getting Help

* Join our [slack channel](https://cdp-registration.slack.com/)
* Send us an <a href="DL_URPR@philips.com">email</a>
* Post at our [social cast](https://philips.socialcast.com/groups/6184-userregistrationcocointegrationsupport)





## FAQ

**Q: What is white box API signing and where can I get secure Secret Key for HSDP?**
**A:** HSDP APIs require their payload to be signed with _Secret Key_ provided to application by HSDP backend team. This key needs to be obfuscated before it could be embedded inside the application to avoid any possible leak of actual secret key. More details can be found [here](https://confluence.atlas.philips.com/display/MOB/HSDP+Configuration+and+White-box+API+Signing).

**Q: How to configure Google login?**
**A:** To enable Google login in `PhilipsRegistration`, applications need to supply _GooglePlus_ ClientID and _GooglePlus_ redirect URI. _GooglePlus_ ClientID for each environment can be requested by raising ticket to **DigitalServices Team** and then provided to `PhilipsRegistration` under 'GooglePlusClientId' and 'GooglePlusRedirectUri' keys in appconfig configuration. Detailed steps can be found [here](https://confluence.atlas.philips.com/display/MOB/How+to+Integrate+new+authentication+for+Google).

**Q: How to configure WeChat login for China?**
**A:** Application can enable WeChat login for China users by adding '**wechat**' under '**signinproviders**' configuration. WeChat also requires applications to supply 'WeChatAppId' and 'WeChatAppSecret' to `PhilipsRegistration` and add URL scheme to application build phases. Complete detail on WeChat configuration can be found [here](https://confluence.atlas.philips.com/display/MOB/How+to+integrate+the+WeChat+in+the+Mobile+apps).

**Q: How to override countries displayed by PhilipsRegistration to display only a subset?**
**A:** By default `PhilipsRegistration` displays all the [countries supported] by **CDP Platform**. Applications can choose to display only a subset of countries by providing list of countries in _AppConfig.json_ or _AppInfra.AppConfig_ under 'supportedHomeCountries' field. Applications are encouraged to provide fallback home country if they are overriding platform supported countries which should be from provided list. More details can be found [here](https://confluence.atlas.philips.com/display/MOB/Country+configuration+for+the+UR).

**Q: How to add a unsupported country to PhilipsRegistration?**
**A:** Though highly discouraged, `PhilipsRegistration` allows applications to add countries that are not supported by **CDP Platform**. Because `PhilipsRegistration` uses _ServiceDiscovery_ to determine which server URLs to use for each country, applications need to provide a mapping country for each unsupported country and mapped country's URLs will be used for unsupported countries. This can be configured via _AppConfig.json_ or _AppInfra.AppConfig_ by providing a key:value map under 'servicediscovery.countryMapping' field in 'appinfra' group. More details on this configuration can be found [here](https://confluence.atlas.philips.com/display/UR/Complete+Runtime+Configurations).

**Q: Why is user logged out while refreshing login session?**
**A:** There a number of reasons when a user will be logged when refreshing login session some which include more than three active HSDP login sessions, wrong device date and time (partially fixed by using server time) or tampered access token. All these cases are known, communicated and accepted.

**Q: User is logged our immediately after login in iOS simulator.**
**A:** `PhilipsRegistration` stores sensitive information like encryption keys and session tokens in iOS keychain. Due to a bug in iOS Simulator, KeyChain sharing capablity is required to be able to store data in keychain. Please add kechain capability to your application in capability pane of target settings to alleviate this issue.

**Q: Why do I always get Staging URLs from ServiceDiscovery despite environment being set to Development or Testing?**
**A:** **CDP Platform** _ServiceDiscovery_ is configured to return Staging URLs for all environments except **Production** due to instability of other environments. If you are using platform _ServiceDiscovery_, this is expected behaviour. More details on the environment can be found [here](https://confluence.atlas.philips.com/display/MPA/Environment+Deployment).

**Q: After launching, PhilipsRegistration displays loading indicator continuously and does not allow any interaction with UI.?**
**A:** Please make sure to initialize `PhilipsRegistration` as in [Initialization][] section before calling any of its APIs like `[[DIUser getInstance] isLoggedIn]` or `[[DIUser getInstance] refreshLoginSession]` etc. Initialization helps `PhilipsRegistration` identify what action to take when the APIs are called.

**Q: PhilipsRegistration gets stuck when calling logout and does not provide any callback.**
**A:** Please make sure to initialize `PhilipsRegistration` and add appropriate listeners on `DIUser` before calling any API like logout or updateReceiveMarketing email.



## IFAQ

**Q: What is AppInfra and how is it used in PhilipsRegistration?**
**A:** _AppInfra_ is a collection of microservices that provides basic building blocks for **CDP Platform** components. These microservices include _AppTagging_ used for Data Analytics, _AppLogging_ used for centralized console/file logging, _ServiceDiscovery_ used to discover correct servers and URLs for user's country, _SecureStorage_ used for storing sensitive data with AES-256 encryption and others. More details on microservices provided by _AppInfra_ can be found [here](https://confluence.atlas.philips.com/display/MOB/Quick+AppInfra+feature+overview).
