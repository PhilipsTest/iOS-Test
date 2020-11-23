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

/**
 * @brief A JRCampaignsElement object
 **/
@interface JRCampaignsElement : JRCaptureObject
@property (nonatomic, copy)     NSString *campaignId; /**< The object's \e campaignId property */ 
@property (nonatomic, copy)     JRBoolean *consent; /**< The object's \e consent property @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     NSString *contentType; /**< The object's \e contentType property */ 
@property (nonatomic, copy)     JRDateTime *createdAt; /**< The object's \e createdAt property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     JRDateTime *lastUpdatedAt; /**< The object's \e lastUpdatedAt property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSString *locale; /**< The object's \e locale property */ 
@property (nonatomic, copy)     JRInteger *order; /**< The object's \e order property @note A ::JRInteger property is a property of type \ref typesTable "integer" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithInteger:<em>myInteger</em>]</code>, <code>[NSNumber numberWithInt:<em>myInt</em>]</code>, or <code>nil</code> */ 
@property (nonatomic, copy)     JRJsonObject *payload; /**< The object's \e payload property @note A ::JRJsonObject property is a property of type \ref typesTable "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     NSString *status; /**< The object's \e status property */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default instance constructor. Returns an empty JRCampaignsElement object
 *
 * @return
 *   A JRCampaignsElement object
 *
 * @note 
 * Method creates a object without the required properties: \e campaignId, \e consent, \e contentType, \e createdAt, \e lastUpdatedAt, \e locale, \e order, \e status.
 * These properties are required when updating the object on Capture. That is, you must set them before calling
 * updateOnCaptureForDelegate:context:().
 **/
- (id)init;

/**
 * Default class constructor. Returns an empty JRCampaignsElement object
 *
 * @return
 *   A JRCampaignsElement object
 *
 * @note 
 * Method creates a object without the required properties: \e campaignId, \e consent, \e contentType, \e createdAt, \e lastUpdatedAt, \e locale, \e order, \e status.
 * These properties are required when updating the object on Capture. That is, you must set them before calling
 * updateOnCaptureForDelegate:context:().
 **/
+ (id)campaignsElement;

/**
 * Returns a JRCampaignsElement object initialized with the given required properties: \c newCampaignId, \c newConsent, \c newContentType, \c newCreatedAt, \c newLastUpdatedAt, \c newLocale, \c newOrder, \c newStatus
 *
 * @param newCampaignId
 *   The object's \e campaignId property
 *
 * @param newConsent
 *   The object's \e consent property
 *
 * @param newContentType
 *   The object's \e contentType property
 *
 * @param newCreatedAt
 *   The object's \e createdAt property
 *
 * @param newLastUpdatedAt
 *   The object's \e lastUpdatedAt property
 *
 * @param newLocale
 *   The object's \e locale property
 *
 * @param newOrder
 *   The object's \e order property
 *
 * @param newStatus
 *   The object's \e status property
 *
 * @return
 *   A JRCampaignsElement object initialized with the given required properties: \e newCampaignId, \e newConsent, \e newContentType, \e newCreatedAt, \e newLastUpdatedAt, \e newLocale, \e newOrder, \e newStatus.
 *   If the required arguments are \e nil or \e [NSNull null], returns \e nil
 **/
- (id)initWithCampaignId:(NSString *)newCampaignId andConsent:(JRBoolean *)newConsent andContentType:(NSString *)newContentType andCreatedAt:(JRDateTime *)newCreatedAt andLastUpdatedAt:(JRDateTime *)newLastUpdatedAt andLocale:(NSString *)newLocale andOrder:(JRInteger *)newOrder andStatus:(NSString *)newStatus;

/**
 * Returns a JRCampaignsElement object initialized with the given required properties: \c campaignId, \c consent, \c contentType, \c createdAt, \c lastUpdatedAt, \c locale, \c order, \c status
 *
 * @param campaignId
 *   The object's \e campaignId property
 *
 * @param consent
 *   The object's \e consent property
 *
 * @param contentType
 *   The object's \e contentType property
 *
 * @param createdAt
 *   The object's \e createdAt property
 *
 * @param lastUpdatedAt
 *   The object's \e lastUpdatedAt property
 *
 * @param locale
 *   The object's \e locale property
 *
 * @param order
 *   The object's \e order property
 *
 * @param status
 *   The object's \e status property
 *
 * @return
 *   A JRCampaignsElement object initialized with the given required properties: \e campaignId, \e consent, \e contentType, \e createdAt, \e lastUpdatedAt, \e locale, \e order, \e status.
 *   If the required arguments are \e nil or \e [NSNull null], returns \e nil
 **/
+ (id)campaignsElementWithCampaignId:(NSString *)campaignId andConsent:(JRBoolean *)consent andContentType:(NSString *)contentType andCreatedAt:(JRDateTime *)createdAt andLastUpdatedAt:(JRDateTime *)lastUpdatedAt andLocale:(NSString *)locale andOrder:(JRInteger *)order andStatus:(NSString *)status;

/*@}*/

/**
 * @name Manage Remotely 
 **/
/*@{*/
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
 * @warning
 * This object, or one of its ancestors, is an element of a plural. If any elements of the plural have changed,
 * (added or removed) the array must be replaced on Capture before the elements or their sub-objects can be
 * updated. Please use the appropriate <code>replace&lt;<em>ArrayName</em>&gt;ArrayOnCaptureForDelegate:context:</code>
 * method first. Even if JRCaptureObject#needsUpdate returns \c YES, this object cannot be updated on Capture unless
 * JRCaptureObject#canBeUpdatedOnCapture also returns \c YES.
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
 * Returns the primitive boolean value stored in the consent property. Will return \c NO if the
 * consent is  nil. **/
- (BOOL)getConsentBoolValue;

/**
 * Sets the consent property to a the primitive boolean value.
 **/
- (void)setConsentWithBool:(BOOL)boolVal;

/**
 * Returns the primitive integer value stored in the order property. Will return \c 0 if the
 * order is  nil. **/
- (NSInteger)getOrderIntegerValue;

/**
 * Sets the order property to a the primitive integer value.
 **/
- (void)setOrderWithInteger:(NSInteger)integerVal;
/*@}*/

@end
