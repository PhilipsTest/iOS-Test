//
//  DICoppaExtensionConstants.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.


/**
 An enum that represents different states of a COPPA consent.
 */
typedef NS_ENUM(NSInteger, DICOPPASTATUS) {
    /**
     *  User has not provided any response for the consent probably because consent is yet to be displayed.
     *
     *  @since 1.0.0
     */
    kDICOPPAConsentPending,
    
    /**
     *  User has declined the consent.
     *
     *  @since 1.0.0
     */
    kDICOPPAConsentNotGiven,
    
    /**
     *  User has accepted the consent.
     *
     *  @since 1.0.0
     */
    kDICOPPAConsentGiven,
    
    /**
     *  User has not provided any response for the consent confirmation probably because confirmation is yet to be displayed.
     *
     *  @since 1.0.0
     */
    kDICOPPAConfirmationPending,
    
    /**
     *  User has declined the consent confirmation.
     *
     *  @since 1.0.0
     */
    kDICOPPAConfirmationNotGiven,
    
    /**
     *  User has accepted the consent confirmation.
     *
     *  @since 1.0.0
     */
    kDICOPPAConfirmationGiven,
};
