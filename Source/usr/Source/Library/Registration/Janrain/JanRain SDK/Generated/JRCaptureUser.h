/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>
#import "JRCaptureObject.h"
#import "JRCaptureTypes.h"
#import "JRNSDate+ISO8601_CaptureDateTimeString.h"
#import "JRBadgeVillePlayerIDsElement.h"
#import "JRCampaignsElement.h"
#import "JRChildrenElement.h"
#import "JRClientsElement.h"
#import "JRCloudsearch.h"
#import "JRConsentsElement.h"
#import "JRConsumerInterestsElement.h"
#import "JRDeviceIdentificationElement.h"
#import "JRFriendsElement.h"
#import "JRIdentifierInformation.h"
#import "JRJanrain.h"
#import "JRLastUsedDevice.h"
#import "JRMarketingOptIn.h"
#import "JRMigration.h"
#import "JROptIn.h"
#import "JRPhotosElement.h"
#import "JRPost_login_confirmationElement.h"
#import "JRPrimaryAddress.h"
#import "JRProfilesElement.h"
#import "JRRolesElement.h"
#import "JRSitecatalystIDsElement.h"
#import "JRStatusesElement.h"
#import "JRVisitedMicroSitesElement.h"

/**
 * @brief A JRCaptureUser object
 **/
@interface JRCaptureUser : JRCaptureObject
@property (nonatomic, copy)     NSString *CPF; /**< The object's \e CPF property */ 
@property (nonatomic, copy)     NSString *NRIC; /**< The object's \e NRIC property */ 
@property (nonatomic, copy)     NSString *aboutMe; /**< The object's \e aboutMe property */ 
@property (nonatomic, copy)     JRBoolean *avmTCAgreed; /**< The object's \e avmTCAgreed property @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     JRDateTime *avmTermsAgreedDate; /**< The object's \e avmTermsAgreedDate property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSArray *badgeVillePlayerIDs; /**< Badgeville Site and PlayerIDs which are alphanumeric and 24 chars long according to Badgeville itself @note This is an array of JRBadgeVillePlayerIDsElement objects */ 
@property (nonatomic, copy)     NSString *batchId; /**< The object's \e batchId property */ 
@property (nonatomic, copy)     JRDate *birthday; /**< The object's \e birthday property @note A ::JRDate property is a property of type \ref typesTable "date" and a typedef of \e NSDate. The accepted format should be an ISO 8601 date string (e.g., <code>yyyy-MM-dd</code>) */ 
@property (nonatomic, copy)     NSString *campaignID; /**< The object's \e campaignID property */ 
@property (nonatomic, copy)     NSArray *campaigns; /**< The object's \e campaigns property @note This is an array of JRCampaignsElement objects */ 
@property (nonatomic, copy)     NSString *catalogLocaleItem; /**< The object's \e catalogLocaleItem property */ 
@property (nonatomic, copy)     NSArray *children; /**< The object's \e children property @note This is an array of JRChildrenElement objects */ 
@property (nonatomic, copy)     NSArray *clients; /**< The object's \e clients property @note This is an array of JRClientsElement objects */ 
@property (nonatomic,strong)    JRCloudsearch *cloudsearch; /**< The object's \e cloudsearch property */ 
@property (nonatomic, copy)     JRBoolean *consentVerified; /**< Consent Verified @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     JRDateTime *consentVerifiedAt; /**< The object's \e consentVerifiedAt property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSArray *consents; /**< The object's \e consents property @note This is an array of JRConsentsElement objects */ 
@property (nonatomic, copy)     NSArray *consumerInterests; /**< The object's \e consumerInterests property @note This is an array of JRConsumerInterestsElement objects */ 
@property (nonatomic, copy)     JRInteger *consumerPoints; /**< The object's \e consumerPoints property @note A ::JRInteger property is a property of type \ref typesTable "integer" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithInteger:<em>myInteger</em>]</code>, <code>[NSNumber numberWithInt:<em>myInt</em>]</code>, or <code>nil</code> */ 
@property (nonatomic, copy)     NSString *controlField; /**< The object's \e controlField property */ 
@property (nonatomic, copy)     JRDateTime *coppaCommunicationSentAt; /**< The object's \e coppaCommunicationSentAt property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSString *currentLocation; /**< The object's \e currentLocation property */ 
@property (nonatomic, copy)     JRDateTime *deactivateAccount; /**< The object's \e deactivateAccount property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     JRDateTime *deactivatedAccount; /**< The object's \e deactivatedAccount property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSArray *deviceIdentification; /**< The object's \e deviceIdentification property @note This is an array of JRDeviceIdentificationElement objects */ 
@property (nonatomic, copy)     JRJsonObject *display; /**< The object's \e display property @note A ::JRJsonObject property is a property of type \ref typesTable "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     NSString *displayName; /**< The name of this Contact, suitable for display to end-users. */ 
@property (nonatomic, copy)     NSString *email; /**< The object's \e email property */ 
@property (nonatomic, copy)     JRDateTime *emailVerified; /**< The object's \e emailVerified property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSString *externalId; /**< The object's \e externalId property */ 
@property (nonatomic, copy)     NSString *familyId; /**< The object's \e familyId property */ 
@property (nonatomic, copy)     NSString *familyName; /**< The object's \e familyName property */ 
@property (nonatomic, copy)     NSString *familyRole; /**< The object's \e familyRole property */ 
@property (nonatomic, copy)     NSString *firstNamePronunciation; /**< The object's \e firstNamePronunciation property */ 
@property (nonatomic, copy)     NSArray *friends; /**< The object's \e friends property @note This is an array of JRFriendsElement objects */ 
@property (nonatomic, copy)     NSString *gender; /**< The object's \e gender property */ 
@property (nonatomic, copy)     NSString *givenName; /**< The object's \e givenName property */ 
@property (nonatomic,strong)    JRIdentifierInformation *identifierInformation; /**< The object's \e identifierInformation property */ 
@property (nonatomic, copy)     JRBoolean *interestAvent; /**< The object's \e interestAvent property @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     JRBoolean *interestCampaigns; /**< The object's \e interestCampaigns property @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     NSString *interestCategories; /**< The object's \e interestCategories property */ 
@property (nonatomic, copy)     JRBoolean *interestCommunications; /**< The object's \e interestCommunications property @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     JRBoolean *interestPromotions; /**< The object's \e interestPromotions property @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     JRBoolean *interestStreamiumSurveys; /**< The object's \e interestStreamiumSurveys property @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     JRBoolean *interestStreamiumUpgrades; /**< The object's \e interestStreamiumUpgrades property @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     JRBoolean *interestSurveys; /**< The object's \e interestSurveys property @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     JRBoolean *interestWULsounds; /**< The object's \e interestWULsounds property @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic,strong)    JRJanrain *janrain; /**< The object's \e janrain property */ 
@property (nonatomic, copy)     JRDateTime *lastLogin; /**< The object's \e lastLogin property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSString *lastLoginMethod; /**< The object's \e lastLoginMethod property */ 
@property (nonatomic, copy)     JRDateTime *lastModifiedDate; /**< The object's \e lastModifiedDate property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSString *lastModifiedSource; /**< The object's \e lastModifiedSource property */ 
@property (nonatomic, copy)     NSString *lastNamePronunciation; /**< The object's \e lastNamePronunciation property */ 
@property (nonatomic,strong)    JRLastUsedDevice *lastUsedDevice; /**< The object's \e lastUsedDevice property */ 
@property (nonatomic, copy)     JRInteger *legacyID; /**< The object's \e legacyID property @note A ::JRInteger property is a property of type \ref typesTable "integer" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithInteger:<em>myInteger</em>]</code>, <code>[NSNumber numberWithInt:<em>myInt</em>]</code>, or <code>nil</code> */ 
@property (nonatomic, copy)     NSString *maritalStatus; /**< The object's \e maritalStatus property */ 
@property (nonatomic,strong)    JRMarketingOptIn *marketingOptIn; /**< The object's \e marketingOptIn property */ 
@property (nonatomic, copy)     NSString *medicalProfessionalRoleSpecified; /**< The object's \e medicalProfessionalRoleSpecified property */ 
@property (nonatomic, copy)     NSString *middleName; /**< The object's \e middleName property */ 
@property (nonatomic,strong)    JRMigration *migration; /**< The object's \e migration property */ 
@property (nonatomic, copy)     NSString *mobileNumber; /**< The object's \e mobileNumber property */ 
@property (nonatomic, copy)     JRBoolean *mobileNumberNeedVerification; /**< The object's \e mobileNumberNeedVerification property @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     JRDateTime *mobileNumberSmsRequestedAt; /**< The object's \e mobileNumberSmsRequestedAt property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     JRDateTime *mobileNumberVerified; /**< The object's \e mobileNumberVerified property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     JRBoolean *nettvTCAgreed; /**< The object's \e nettvTCAgreed property @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     JRDateTime *nettvTermsAgreedDate; /**< The object's \e nettvTermsAgreedDate property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSString *nickName; /**< The object's \e nickName property */ 
@property (nonatomic, copy)     JRBoolean *olderThanAgeLimit; /**< The object's \e olderThanAgeLimit property @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic,strong)    JROptIn *optIn; /**< The object's \e optIn property */ 
@property (nonatomic, copy)     JRPassword *password; /**< The object's \e password property @note A ::JRPassword property is a property of type \ref typesTable "password", which can be either an \e NSString or \e NSDictionary, and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     JRDateTime *personalDataMarketingProfiling; /**< The object's \e personalDataMarketingProfiling property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     JRDateTime *personalDataTransferAcceptance; /**< The object's \e personalDataTransferAcceptance property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     JRDateTime *personalDataUsageAcceptance; /**< The object's \e personalDataUsageAcceptance property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSArray *photos; /**< The object's \e photos property @note This is an array of JRPhotosElement objects */ 
@property (nonatomic, copy)     NSArray *post_login_confirmation; /**< The object's \e post_login_confirmation property @note This is an array of JRPost_login_confirmationElement objects */ 
@property (nonatomic, copy)     NSString *preferredLanguage; /**< The object's \e preferredLanguage property */ 
@property (nonatomic,strong)    JRPrimaryAddress *primaryAddress; /**< The object's \e primaryAddress property */ 
@property (nonatomic, copy)     NSArray *profiles; /**< The object's \e profiles property @note This is an array of JRProfilesElement objects */ 
@property (nonatomic, copy)     NSString *providerMergedLast; /**< The object's \e providerMergedLast property */ 
@property (nonatomic, copy)     JRBoolean *receiveMarketingEmail; /**< The object's \e receiveMarketingEmail property @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     JRBoolean *requiresVerification; /**< The object's \e requiresVerification property @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     JRDateTime *retentionConsentGivenAt; /**< The object's \e retentionConsentGivenAt property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSArray *roles; /**< The object's \e roles property @note This is an array of JRRolesElement objects */ 
@property (nonatomic, copy)     NSString *salutation; /**< The object's \e salutation property */ 
@property (nonatomic, copy)     NSArray *sitecatalystIDs; /**< The object's \e sitecatalystIDs property @note This is an array of JRSitecatalystIDsElement objects */ 
@property (nonatomic, copy)     NSString *ssn; /**< The object's \e ssn property */ 
@property (nonatomic, copy)     NSArray *statuses; /**< The object's \e statuses property @note This is an array of JRStatusesElement objects */ 
@property (nonatomic, copy)     JRBoolean *streamiumServicesTCAgreed; /**< The object's \e streamiumServicesTCAgreed property @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     JRDateTime *termsAndConditionsAcceptance; /**< Terms And Conditions Acceptance @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSArray *visitedMicroSites; /**< The object's \e visitedMicroSites property @note This is an array of JRVisitedMicroSitesElement objects */ 
@property (nonatomic, copy)     JRDateTime *weddingDate; /**< The object's \e weddingDate property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSString *wishList; /**< The object's \e wishList property */ 
@property (nonatomic, readonly) JRObjectId *captureUserId; /**< Simple identifier for this entity @note The \e id of the object should not be set. */ 
@property (nonatomic, readonly) JRUuid *uuid; /**< Globally unique indentifier for this entity @note A ::JRUuid property is a property of type \ref typesTable "uuid" and a typedef of \e NSString */ 
@property (nonatomic, readonly) JRDateTime *lastUpdated; /**< When this entity was last updated @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, readonly) JRDateTime *created; /**< When this entity was created @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default instance constructor. Returns an empty JRCaptureUser object
 *
 * @return
 *   A JRCaptureUser object
 **/
- (id)init;

/**
 * Default class constructor. Returns an empty JRCaptureUser object
 *
 * @return
 *   A JRCaptureUser object
 **/
+ (id)captureUser;

/*@}*/

/**
 * @name Manage Remotely 
 **/
/*@{*/
/**
 * Use this method to replace the JRCaptureUser#badgeVillePlayerIDs array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#badgeVillePlayerIDs property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#badgeVillePlayerIDs property, and the name of the replaced array: \c "badgeVillePlayerIDs".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#badgeVillePlayerIDs property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRBadgeVillePlayerIDsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#badgeVillePlayerIDs or JRBadgeVillePlayerIDsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRBadgeVillePlayerIDsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRBadgeVillePlayerIDsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRBadgeVillePlayerIDsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#badgeVillePlayerIDs array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRBadgeVillePlayerIDsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#badgeVillePlayerIDs array, but
 * you have locally updated the properties of a JRBadgeVillePlayerIDsElement, you can just call
 * JRBadgeVillePlayerIDsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRBadgeVillePlayerIDsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceBadgeVillePlayerIDsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#campaigns array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#campaigns property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#campaigns property, and the name of the replaced array: \c "campaigns".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#campaigns property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRCampaignsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#campaigns or JRCampaignsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRCampaignsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRCampaignsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRCampaignsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#campaigns array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRCampaignsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#campaigns array, but
 * you have locally updated the properties of a JRCampaignsElement, you can just call
 * JRCampaignsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRCampaignsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceCampaignsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#children array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#children property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#children property, and the name of the replaced array: \c "children".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#children property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRChildrenElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#children or JRChildrenElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRChildrenElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRChildrenElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRChildrenElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#children array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRChildrenElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#children array, but
 * you have locally updated the properties of a JRChildrenElement, you can just call
 * JRChildrenElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRChildrenElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceChildrenArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#clients array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#clients property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#clients property, and the name of the replaced array: \c "clients".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#clients property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRClientsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#clients or JRClientsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRClientsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRClientsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRClientsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#clients array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRClientsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#clients array, but
 * you have locally updated the properties of a JRClientsElement, you can just call
 * JRClientsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRClientsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceClientsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#consents array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#consents property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#consents property, and the name of the replaced array: \c "consents".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#consents property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRConsentsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#consents or JRConsentsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRConsentsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRConsentsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRConsentsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#consents array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRConsentsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#consents array, but
 * you have locally updated the properties of a JRConsentsElement, you can just call
 * JRConsentsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRConsentsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceConsentsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#consumerInterests array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#consumerInterests property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#consumerInterests property, and the name of the replaced array: \c "consumerInterests".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#consumerInterests property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRConsumerInterestsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#consumerInterests or JRConsumerInterestsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRConsumerInterestsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRConsumerInterestsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRConsumerInterestsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#consumerInterests array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRConsumerInterestsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#consumerInterests array, but
 * you have locally updated the properties of a JRConsumerInterestsElement, you can just call
 * JRConsumerInterestsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRConsumerInterestsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceConsumerInterestsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#deviceIdentification array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#deviceIdentification property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#deviceIdentification property, and the name of the replaced array: \c "deviceIdentification".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#deviceIdentification property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRDeviceIdentificationElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#deviceIdentification or JRDeviceIdentificationElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRDeviceIdentificationElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRDeviceIdentificationElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRDeviceIdentificationElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#deviceIdentification array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRDeviceIdentificationElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#deviceIdentification array, but
 * you have locally updated the properties of a JRDeviceIdentificationElement, you can just call
 * JRDeviceIdentificationElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRDeviceIdentificationElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceDeviceIdentificationArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#friends array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#friends property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#friends property, and the name of the replaced array: \c "friends".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#friends property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRFriendsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#friends or JRFriendsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRFriendsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRFriendsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRFriendsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#friends array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRFriendsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#friends array, but
 * you have locally updated the properties of a JRFriendsElement, you can just call
 * JRFriendsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRFriendsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceFriendsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#photos array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#photos property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#photos property, and the name of the replaced array: \c "photos".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#photos property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRPhotosElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#photos or JRPhotosElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRPhotosElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRPhotosElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRPhotosElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#photos array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRPhotosElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#photos array, but
 * you have locally updated the properties of a JRPhotosElement, you can just call
 * JRPhotosElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRPhotosElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replacePhotosArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#post_login_confirmation array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#post_login_confirmation property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#post_login_confirmation property, and the name of the replaced array: \c "post_login_confirmation".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#post_login_confirmation property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRPost_login_confirmationElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#post_login_confirmation or JRPost_login_confirmationElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRPost_login_confirmationElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRPost_login_confirmationElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRPost_login_confirmationElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#post_login_confirmation array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRPost_login_confirmationElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#post_login_confirmation array, but
 * you have locally updated the properties of a JRPost_login_confirmationElement, you can just call
 * JRPost_login_confirmationElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRPost_login_confirmationElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replacePost_login_confirmationArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#profiles array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#profiles property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#profiles property, and the name of the replaced array: \c "profiles".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#profiles property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRProfilesElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#profiles or JRProfilesElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRProfilesElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRProfilesElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRProfilesElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#profiles array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRProfilesElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#profiles array, but
 * you have locally updated the properties of a JRProfilesElement, you can just call
 * JRProfilesElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRProfilesElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceProfilesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#roles array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#roles property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#roles property, and the name of the replaced array: \c "roles".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#roles property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRRolesElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#roles or JRRolesElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRRolesElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRRolesElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRRolesElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#roles array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRRolesElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#roles array, but
 * you have locally updated the properties of a JRRolesElement, you can just call
 * JRRolesElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRRolesElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceRolesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#sitecatalystIDs array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#sitecatalystIDs property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#sitecatalystIDs property, and the name of the replaced array: \c "sitecatalystIDs".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#sitecatalystIDs property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRSitecatalystIDsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#sitecatalystIDs or JRSitecatalystIDsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRSitecatalystIDsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRSitecatalystIDsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRSitecatalystIDsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#sitecatalystIDs array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRSitecatalystIDsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#sitecatalystIDs array, but
 * you have locally updated the properties of a JRSitecatalystIDsElement, you can just call
 * JRSitecatalystIDsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRSitecatalystIDsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceSitecatalystIDsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#statuses array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#statuses property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#statuses property, and the name of the replaced array: \c "statuses".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#statuses property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRStatusesElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#statuses or JRStatusesElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRStatusesElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRStatusesElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRStatusesElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#statuses array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRStatusesElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#statuses array, but
 * you have locally updated the properties of a JRStatusesElement, you can just call
 * JRStatusesElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRStatusesElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceStatusesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#visitedMicroSites array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#visitedMicroSites property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#visitedMicroSites property, and the name of the replaced array: \c "visitedMicroSites".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#visitedMicroSites property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRVisitedMicroSitesElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#visitedMicroSites or JRVisitedMicroSitesElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRVisitedMicroSitesElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRVisitedMicroSitesElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRVisitedMicroSitesElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#visitedMicroSites array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRVisitedMicroSitesElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#visitedMicroSites array, but
 * you have locally updated the properties of a JRVisitedMicroSitesElement, you can just call
 * JRVisitedMicroSitesElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRVisitedMicroSitesElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceVisitedMicroSitesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to determine if the object or element needs to be updated remotely.
 * That is, if there are local changes to any of the object/elements's properties or
 * sub-objects, then this object will need to be updated on Capture. You can update
 * an object on Capture by using the method updateOnCaptureForDelegate:context:().
 *
 * @return
 * \c YES if this object or any of it's sub-objects have any properties that have changed
 * locally. This does not include properties that are arrays, if any, or the elements contained
 * within the arrays. \c NO if no non-array properties or sub-objects have changed locally.
 *
 * @note
 * This method recursively checks all of the sub-objects of JRCaptureUser:
 *   - JRCaptureUser#cloudsearch
 *   - JRCaptureUser#identifierInformation
 *   - JRCaptureUser#janrain
 *   - JRCaptureUser#lastUsedDevice
 *   - JRCaptureUser#marketingOptIn
 *   - JRCaptureUser#migration
 *   - JRCaptureUser#optIn
 *   - JRCaptureUser#primaryAddress
 * .
 * @par
 * If any of these objects are new, or if they need to be updated, this method returns \c YES.
 *
 * @warning
 * This method recursively checks all of the sub-objects of JRCaptureUser
 * but does not check any of the arrays of the JRCaptureUser or the arrays' elements:
 *   - JRCaptureUser#badgeVillePlayerIDs, JRBadgeVillePlayerIDsElement
 *   - JRCaptureUser#campaigns, JRCampaignsElement
 *   - JRCaptureUser#children, JRChildrenElement
 *   - JRCaptureUser#clients, JRClientsElement
 *   - JRCaptureUser#consents, JRConsentsElement
 *   - JRCaptureUser#consumerInterests, JRConsumerInterestsElement
 *   - JRCaptureUser#deviceIdentification, JRDeviceIdentificationElement
 *   - JRCaptureUser#friends, JRFriendsElement
 *   - JRCaptureUser#photos, JRPhotosElement
 *   - JRCaptureUser#post_login_confirmation, JRPost_login_confirmationElement
 *   - JRCaptureUser#profiles, JRProfilesElement
 *   - JRCaptureUser#roles, JRRolesElement
 *   - JRCaptureUser#sitecatalystIDs, JRSitecatalystIDsElement
 *   - JRCaptureUser#statuses, JRStatusesElement
 *   - JRCaptureUser#visitedMicroSites, JRVisitedMicroSitesElement
 * .
 * @par
 * If you have added or removed any elements from the arrays, you must call the following methods
 * to update the array on Capture: replaceBadgeVillePlayerIDsArrayOnCaptureForDelegate:context:(),
 *   replaceCampaignsArrayOnCaptureForDelegate:context:(),
 *   replaceChildrenArrayOnCaptureForDelegate:context:(),
 *   replaceClientsArrayOnCaptureForDelegate:context:(),
 *   replaceConsentsArrayOnCaptureForDelegate:context:(),
 *   replaceConsumerInterestsArrayOnCaptureForDelegate:context:(),
 *   replaceDeviceIdentificationArrayOnCaptureForDelegate:context:(),
 *   replaceFriendsArrayOnCaptureForDelegate:context:(),
 *   replacePhotosArrayOnCaptureForDelegate:context:(),
 *   replacePost_login_confirmationArrayOnCaptureForDelegate:context:(),
 *   replaceProfilesArrayOnCaptureForDelegate:context:(),
 *   replaceRolesArrayOnCaptureForDelegate:context:(),
 *   replaceSitecatalystIDsArrayOnCaptureForDelegate:context:(),
 *   replaceStatusesArrayOnCaptureForDelegate:context:(),
 *   replaceVisitedMicroSitesArrayOnCaptureForDelegate:context:()
 *
 * @par
 * Otherwise, if the array elements' JRCaptureObject#canBeUpdatedOnCapture and JRCaptureObject#needsUpdate returns \c YES, you can update
 * the elements by calling updateOnCaptureForDelegate:context:().
 **/
- (BOOL)needsUpdate;

/**
 * TODO: Doxygen doc
 **/
- (void)updateOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;
/*@}*/

/**
 * @name Primitive Getters/Setters 
 **/
/*@{*/
/**
 * Returns the primitive boolean value stored in the avmTCAgreed property. Will return \c NO if the
 * avmTCAgreed is  nil. **/
- (BOOL)getAvmTCAgreedBoolValue;

/**
 * Sets the avmTCAgreed property to a the primitive boolean value.
 **/
- (void)setAvmTCAgreedWithBool:(BOOL)boolVal;

/**
 * Returns the primitive boolean value stored in the consentVerified property. Will return \c NO if the
 * consentVerified is  nil. **/
- (BOOL)getConsentVerifiedBoolValue;

/**
 * Sets the consentVerified property to a the primitive boolean value.
 **/
- (void)setConsentVerifiedWithBool:(BOOL)boolVal;

/**
 * Returns the primitive boolean value stored in the interestAvent property. Will return \c NO if the
 * interestAvent is  nil. **/
- (BOOL)getInterestAventBoolValue;

/**
 * Sets the interestAvent property to a the primitive boolean value.
 **/
- (void)setInterestAventWithBool:(BOOL)boolVal;

/**
 * Returns the primitive boolean value stored in the interestCampaigns property. Will return \c NO if the
 * interestCampaigns is  nil. **/
- (BOOL)getInterestCampaignsBoolValue;

/**
 * Sets the interestCampaigns property to a the primitive boolean value.
 **/
- (void)setInterestCampaignsWithBool:(BOOL)boolVal;

/**
 * Returns the primitive boolean value stored in the interestCommunications property. Will return \c NO if the
 * interestCommunications is  nil. **/
- (BOOL)getInterestCommunicationsBoolValue;

/**
 * Sets the interestCommunications property to a the primitive boolean value.
 **/
- (void)setInterestCommunicationsWithBool:(BOOL)boolVal;

/**
 * Returns the primitive boolean value stored in the interestPromotions property. Will return \c NO if the
 * interestPromotions is  nil. **/
- (BOOL)getInterestPromotionsBoolValue;

/**
 * Sets the interestPromotions property to a the primitive boolean value.
 **/
- (void)setInterestPromotionsWithBool:(BOOL)boolVal;

/**
 * Returns the primitive boolean value stored in the interestStreamiumSurveys property. Will return \c NO if the
 * interestStreamiumSurveys is  nil. **/
- (BOOL)getInterestStreamiumSurveysBoolValue;

/**
 * Sets the interestStreamiumSurveys property to a the primitive boolean value.
 **/
- (void)setInterestStreamiumSurveysWithBool:(BOOL)boolVal;

/**
 * Returns the primitive boolean value stored in the interestStreamiumUpgrades property. Will return \c NO if the
 * interestStreamiumUpgrades is  nil. **/
- (BOOL)getInterestStreamiumUpgradesBoolValue;

/**
 * Sets the interestStreamiumUpgrades property to a the primitive boolean value.
 **/
- (void)setInterestStreamiumUpgradesWithBool:(BOOL)boolVal;

/**
 * Returns the primitive boolean value stored in the interestSurveys property. Will return \c NO if the
 * interestSurveys is  nil. **/
- (BOOL)getInterestSurveysBoolValue;

/**
 * Sets the interestSurveys property to a the primitive boolean value.
 **/
- (void)setInterestSurveysWithBool:(BOOL)boolVal;

/**
 * Returns the primitive boolean value stored in the interestWULsounds property. Will return \c NO if the
 * interestWULsounds is  nil. **/
- (BOOL)getInterestWULsoundsBoolValue;

/**
 * Sets the interestWULsounds property to a the primitive boolean value.
 **/
- (void)setInterestWULsoundsWithBool:(BOOL)boolVal;

/**
 * Returns the primitive boolean value stored in the mobileNumberNeedVerification property. Will return \c NO if the
 * mobileNumberNeedVerification is  nil. **/
- (BOOL)getMobileNumberNeedVerificationBoolValue;

/**
 * Sets the mobileNumberNeedVerification property to a the primitive boolean value.
 **/
- (void)setMobileNumberNeedVerificationWithBool:(BOOL)boolVal;

/**
 * Returns the primitive boolean value stored in the nettvTCAgreed property. Will return \c NO if the
 * nettvTCAgreed is  nil. **/
- (BOOL)getNettvTCAgreedBoolValue;

/**
 * Sets the nettvTCAgreed property to a the primitive boolean value.
 **/
- (void)setNettvTCAgreedWithBool:(BOOL)boolVal;

/**
 * Returns the primitive boolean value stored in the olderThanAgeLimit property. Will return \c NO if the
 * olderThanAgeLimit is  nil. **/
- (BOOL)getOlderThanAgeLimitBoolValue;

/**
 * Sets the olderThanAgeLimit property to a the primitive boolean value.
 **/
- (void)setOlderThanAgeLimitWithBool:(BOOL)boolVal;

/**
 * Returns the primitive boolean value stored in the receiveMarketingEmail property. Will return \c NO if the
 * receiveMarketingEmail is  nil. **/
- (BOOL)getReceiveMarketingEmailBoolValue;

/**
 * Sets the receiveMarketingEmail property to a the primitive boolean value.
 **/
- (void)setReceiveMarketingEmailWithBool:(BOOL)boolVal;

/**
 * Returns the primitive boolean value stored in the requiresVerification property. Will return \c NO if the
 * requiresVerification is  nil. **/
- (BOOL)getRequiresVerificationBoolValue;

/**
 * Sets the requiresVerification property to a the primitive boolean value.
 **/
- (void)setRequiresVerificationWithBool:(BOOL)boolVal;

/**
 * Returns the primitive boolean value stored in the streamiumServicesTCAgreed property. Will return \c NO if the
 * streamiumServicesTCAgreed is  nil. **/
- (BOOL)getStreamiumServicesTCAgreedBoolValue;

/**
 * Sets the streamiumServicesTCAgreed property to a the primitive boolean value.
 **/
- (void)setStreamiumServicesTCAgreedWithBool:(BOOL)boolVal;

/**
 * Returns the primitive integer value stored in the consumerPoints property. Will return \c 0 if the
 * consumerPoints is  nil. **/
- (NSInteger)getConsumerPointsIntegerValue;

/**
 * Sets the consumerPoints property to a the primitive integer value.
 **/
- (void)setConsumerPointsWithInteger:(NSInteger)integerVal;

/**
 * Returns the primitive integer value stored in the legacyID property. Will return \c 0 if the
 * legacyID is  nil. **/
- (NSInteger)getLegacyIDIntegerValue;

/**
 * Sets the legacyID property to a the primitive integer value.
 **/
- (void)setLegacyIDWithInteger:(NSInteger)integerVal;
/*@}*/

@end
