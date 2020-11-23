//
//  PhilipsRegistration.h
//  PhilipsRegistration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <UIKit/UIKit.h>

//! Project version number for PhilipsRegistration.
FOUNDATION_EXPORT double PhilipsRegistrationVersionNumber;

//! Project version string for PhilipsRegistration.
FOUNDATION_EXPORT const unsigned char PhilipsRegistrationVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Philips../Registration/PublicHeader.h>
#import "../Registration/DIUser.h"
#import "../Registration/DIUser+Authentication.h"
#import "../Registration/DIRegistrationConstants.h"
#import "../Registration/Janrain/DIConsumerInterest.h"
#import "../Registration/Coppa/DICOPPAExtension.h"
#import "../Registration/Coppa/DICoppaExtensionConstants.h"
#import "../Registration/RegistrationUI/Configuration/DIRegistrationFlowConfiguration.h"
#import "../Registration/RegistrationUI/Configuration/DIRegistrationUIConfiguration.h"
#import "../Registration/RegistrationUI/Configuration/DIRegistrationContentConfiguration.h"
#import "../Registration/Utilities/DIRegistrationVersion.h"
#import "../Registration/URDependencies.h"
#import "../Registration/URInterface.h"
#import "../Registration/URLaunchInput.h"
#import "../Registration/URRegistrationProtocols.h"
#import "../Registration/GDPR/URConsentProvider.h"
#import "../Registration/GDPR/URMarketingConsentHandler.h"
