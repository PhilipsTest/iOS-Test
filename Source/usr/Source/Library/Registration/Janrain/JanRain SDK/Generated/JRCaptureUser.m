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


#import "JRCaptureObject+Internal.h"
#import "JRCaptureUser.h"
#import "debug_log.h"

@interface JRBadgeVillePlayerIDsElement (JRBadgeVillePlayerIDsElement_InternalMethods)
+ (id)badgeVillePlayerIDsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToBadgeVillePlayerIDsElement:(JRBadgeVillePlayerIDsElement *)otherBadgeVillePlayerIDsElement;
@end

@interface JRCampaignsElement (JRCampaignsElement_InternalMethods)
+ (id)campaignsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToCampaignsElement:(JRCampaignsElement *)otherCampaignsElement;
@end

@interface JRChildrenElement (JRChildrenElement_InternalMethods)
+ (id)childrenElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToChildrenElement:(JRChildrenElement *)otherChildrenElement;
@end

@interface JRClientsElement (JRClientsElement_InternalMethods)
+ (id)clientsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToClientsElement:(JRClientsElement *)otherClientsElement;
@end

@interface JRCloudsearch (JRCloudsearch_InternalMethods)
+ (id)cloudsearchObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToCloudsearch:(JRCloudsearch *)otherCloudsearch;
@end

@interface JRConsentsElement (JRConsentsElement_InternalMethods)
+ (id)consentsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToConsentsElement:(JRConsentsElement *)otherConsentsElement;
@end

@interface JRConsumerInterestsElement (JRConsumerInterestsElement_InternalMethods)
+ (id)consumerInterestsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToConsumerInterestsElement:(JRConsumerInterestsElement *)otherConsumerInterestsElement;
@end

@interface JRDeviceIdentificationElement (JRDeviceIdentificationElement_InternalMethods)
+ (id)deviceIdentificationElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToDeviceIdentificationElement:(JRDeviceIdentificationElement *)otherDeviceIdentificationElement;
@end

@interface JRFriendsElement (JRFriendsElement_InternalMethods)
+ (id)friendsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToFriendsElement:(JRFriendsElement *)otherFriendsElement;
@end

@interface JRIdentifierInformation (JRIdentifierInformation_InternalMethods)
+ (id)identifierInformationObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToIdentifierInformation:(JRIdentifierInformation *)otherIdentifierInformation;
@end

@interface JRJanrain (JRJanrain_InternalMethods)
+ (id)janrainObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToJanrain:(JRJanrain *)otherJanrain;
@end

@interface JRLastUsedDevice (JRLastUsedDevice_InternalMethods)
+ (id)lastUsedDeviceObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToLastUsedDevice:(JRLastUsedDevice *)otherLastUsedDevice;
@end

@interface JRMarketingOptIn (JRMarketingOptIn_InternalMethods)
+ (id)marketingOptInObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToMarketingOptIn:(JRMarketingOptIn *)otherMarketingOptIn;
@end

@interface JRMigration (JRMigration_InternalMethods)
+ (id)migrationObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToMigration:(JRMigration *)otherMigration;
@end

@interface JROptIn (JROptIn_InternalMethods)
+ (id)optInObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToOptIn:(JROptIn *)otherOptIn;
@end

@interface JRPhotosElement (JRPhotosElement_InternalMethods)
+ (id)photosElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPhotosElement:(JRPhotosElement *)otherPhotosElement;
@end

@interface JRPost_login_confirmationElement (JRPost_login_confirmationElement_InternalMethods)
+ (id)post_login_confirmationElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPost_login_confirmationElement:(JRPost_login_confirmationElement *)otherPost_login_confirmationElement;
@end

@interface JRPrimaryAddress (JRPrimaryAddress_InternalMethods)
+ (id)primaryAddressObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPrimaryAddress:(JRPrimaryAddress *)otherPrimaryAddress;
@end

@interface JRProfilesElement (JRProfilesElement_InternalMethods)
+ (id)profilesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToProfilesElement:(JRProfilesElement *)otherProfilesElement;
@end

@interface JRRolesElement (JRRolesElement_InternalMethods)
+ (id)rolesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToRolesElement:(JRRolesElement *)otherRolesElement;
@end

@interface JRSitecatalystIDsElement (JRSitecatalystIDsElement_InternalMethods)
+ (id)sitecatalystIDsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToSitecatalystIDsElement:(JRSitecatalystIDsElement *)otherSitecatalystIDsElement;
@end

@interface JRStatusesElement (JRStatusesElement_InternalMethods)
+ (id)statusesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToStatusesElement:(JRStatusesElement *)otherStatusesElement;
@end

@interface JRVisitedMicroSitesElement (JRVisitedMicroSitesElement_InternalMethods)
+ (id)visitedMicroSitesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToVisitedMicroSitesElement:(JRVisitedMicroSitesElement *)otherVisitedMicroSitesElement;
@end

@implementation NSArray (JRArray_BadgeVillePlayerIDs_ToFromDictionary)
- (NSArray*)arrayOfBadgeVillePlayerIDsElementsFromBadgeVillePlayerIDsDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredBadgeVillePlayerIDsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredBadgeVillePlayerIDsArray addObject:[JRBadgeVillePlayerIDsElement badgeVillePlayerIDsElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredBadgeVillePlayerIDsArray;
}

- (NSArray*)arrayOfBadgeVillePlayerIDsElementsFromBadgeVillePlayerIDsDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfBadgeVillePlayerIDsElementsFromBadgeVillePlayerIDsDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfBadgeVillePlayerIDsDictionariesFromBadgeVillePlayerIDsElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRBadgeVillePlayerIDsElement class]])
            [filteredDictionaryArray addObject:[(JRBadgeVillePlayerIDsElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfBadgeVillePlayerIDsDictionariesFromBadgeVillePlayerIDsElements
{
    return [self arrayOfBadgeVillePlayerIDsDictionariesFromBadgeVillePlayerIDsElementsForEncoder:NO];
}

- (NSArray*)arrayOfBadgeVillePlayerIDsReplaceDictionariesFromBadgeVillePlayerIDsElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRBadgeVillePlayerIDsElement class]])
            [filteredDictionaryArray addObject:[(JRBadgeVillePlayerIDsElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_Campaigns_ToFromDictionary)
- (NSArray*)arrayOfCampaignsElementsFromCampaignsDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredCampaignsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredCampaignsArray addObject:[JRCampaignsElement campaignsElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredCampaignsArray;
}

- (NSArray*)arrayOfCampaignsElementsFromCampaignsDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfCampaignsElementsFromCampaignsDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfCampaignsDictionariesFromCampaignsElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRCampaignsElement class]])
            [filteredDictionaryArray addObject:[(JRCampaignsElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfCampaignsDictionariesFromCampaignsElements
{
    return [self arrayOfCampaignsDictionariesFromCampaignsElementsForEncoder:NO];
}

- (NSArray*)arrayOfCampaignsReplaceDictionariesFromCampaignsElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRCampaignsElement class]])
            [filteredDictionaryArray addObject:[(JRCampaignsElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_Children_ToFromDictionary)
- (NSArray*)arrayOfChildrenElementsFromChildrenDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredChildrenArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredChildrenArray addObject:[JRChildrenElement childrenElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredChildrenArray;
}

- (NSArray*)arrayOfChildrenElementsFromChildrenDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfChildrenElementsFromChildrenDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfChildrenDictionariesFromChildrenElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRChildrenElement class]])
            [filteredDictionaryArray addObject:[(JRChildrenElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfChildrenDictionariesFromChildrenElements
{
    return [self arrayOfChildrenDictionariesFromChildrenElementsForEncoder:NO];
}

- (NSArray*)arrayOfChildrenReplaceDictionariesFromChildrenElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRChildrenElement class]])
            [filteredDictionaryArray addObject:[(JRChildrenElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_Clients_ToFromDictionary)
- (NSArray*)arrayOfClientsElementsFromClientsDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredClientsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredClientsArray addObject:[JRClientsElement clientsElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredClientsArray;
}

- (NSArray*)arrayOfClientsElementsFromClientsDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfClientsElementsFromClientsDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfClientsDictionariesFromClientsElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRClientsElement class]])
            [filteredDictionaryArray addObject:[(JRClientsElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfClientsDictionariesFromClientsElements
{
    return [self arrayOfClientsDictionariesFromClientsElementsForEncoder:NO];
}

- (NSArray*)arrayOfClientsReplaceDictionariesFromClientsElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRClientsElement class]])
            [filteredDictionaryArray addObject:[(JRClientsElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_Consents_ToFromDictionary)
- (NSArray*)arrayOfConsentsElementsFromConsentsDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredConsentsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredConsentsArray addObject:[JRConsentsElement consentsElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredConsentsArray;
}

- (NSArray*)arrayOfConsentsElementsFromConsentsDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfConsentsElementsFromConsentsDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfConsentsDictionariesFromConsentsElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRConsentsElement class]])
            [filteredDictionaryArray addObject:[(JRConsentsElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfConsentsDictionariesFromConsentsElements
{
    return [self arrayOfConsentsDictionariesFromConsentsElementsForEncoder:NO];
}

- (NSArray*)arrayOfConsentsReplaceDictionariesFromConsentsElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRConsentsElement class]])
            [filteredDictionaryArray addObject:[(JRConsentsElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_ConsumerInterests_ToFromDictionary)
- (NSArray*)arrayOfConsumerInterestsElementsFromConsumerInterestsDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredConsumerInterestsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredConsumerInterestsArray addObject:[JRConsumerInterestsElement consumerInterestsElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredConsumerInterestsArray;
}

- (NSArray*)arrayOfConsumerInterestsElementsFromConsumerInterestsDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfConsumerInterestsElementsFromConsumerInterestsDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfConsumerInterestsDictionariesFromConsumerInterestsElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRConsumerInterestsElement class]])
            [filteredDictionaryArray addObject:[(JRConsumerInterestsElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfConsumerInterestsDictionariesFromConsumerInterestsElements
{
    return [self arrayOfConsumerInterestsDictionariesFromConsumerInterestsElementsForEncoder:NO];
}

- (NSArray*)arrayOfConsumerInterestsReplaceDictionariesFromConsumerInterestsElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRConsumerInterestsElement class]])
            [filteredDictionaryArray addObject:[(JRConsumerInterestsElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_DeviceIdentification_ToFromDictionary)
- (NSArray*)arrayOfDeviceIdentificationElementsFromDeviceIdentificationDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredDeviceIdentificationArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDeviceIdentificationArray addObject:[JRDeviceIdentificationElement deviceIdentificationElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredDeviceIdentificationArray;
}

- (NSArray*)arrayOfDeviceIdentificationElementsFromDeviceIdentificationDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfDeviceIdentificationElementsFromDeviceIdentificationDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfDeviceIdentificationDictionariesFromDeviceIdentificationElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRDeviceIdentificationElement class]])
            [filteredDictionaryArray addObject:[(JRDeviceIdentificationElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfDeviceIdentificationDictionariesFromDeviceIdentificationElements
{
    return [self arrayOfDeviceIdentificationDictionariesFromDeviceIdentificationElementsForEncoder:NO];
}

- (NSArray*)arrayOfDeviceIdentificationReplaceDictionariesFromDeviceIdentificationElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRDeviceIdentificationElement class]])
            [filteredDictionaryArray addObject:[(JRDeviceIdentificationElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_Friends_ToFromDictionary)
- (NSArray*)arrayOfFriendsElementsFromFriendsDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredFriendsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredFriendsArray addObject:[JRFriendsElement friendsElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredFriendsArray;
}

- (NSArray*)arrayOfFriendsElementsFromFriendsDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfFriendsElementsFromFriendsDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfFriendsDictionariesFromFriendsElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRFriendsElement class]])
            [filteredDictionaryArray addObject:[(JRFriendsElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfFriendsDictionariesFromFriendsElements
{
    return [self arrayOfFriendsDictionariesFromFriendsElementsForEncoder:NO];
}

- (NSArray*)arrayOfFriendsReplaceDictionariesFromFriendsElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRFriendsElement class]])
            [filteredDictionaryArray addObject:[(JRFriendsElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_Photos_ToFromDictionary)
- (NSArray*)arrayOfPhotosElementsFromPhotosDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredPhotosArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPhotosArray addObject:[JRPhotosElement photosElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredPhotosArray;
}

- (NSArray*)arrayOfPhotosElementsFromPhotosDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfPhotosElementsFromPhotosDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfPhotosDictionariesFromPhotosElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhotosElement class]])
            [filteredDictionaryArray addObject:[(JRPhotosElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPhotosDictionariesFromPhotosElements
{
    return [self arrayOfPhotosDictionariesFromPhotosElementsForEncoder:NO];
}

- (NSArray*)arrayOfPhotosReplaceDictionariesFromPhotosElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhotosElement class]])
            [filteredDictionaryArray addObject:[(JRPhotosElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_Post_login_confirmation_ToFromDictionary)
- (NSArray*)arrayOfPost_login_confirmationElementsFromPost_login_confirmationDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredPost_login_confirmationArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPost_login_confirmationArray addObject:[JRPost_login_confirmationElement post_login_confirmationElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredPost_login_confirmationArray;
}

- (NSArray*)arrayOfPost_login_confirmationElementsFromPost_login_confirmationDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfPost_login_confirmationElementsFromPost_login_confirmationDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfPost_login_confirmationDictionariesFromPost_login_confirmationElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPost_login_confirmationElement class]])
            [filteredDictionaryArray addObject:[(JRPost_login_confirmationElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPost_login_confirmationDictionariesFromPost_login_confirmationElements
{
    return [self arrayOfPost_login_confirmationDictionariesFromPost_login_confirmationElementsForEncoder:NO];
}

- (NSArray*)arrayOfPost_login_confirmationReplaceDictionariesFromPost_login_confirmationElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPost_login_confirmationElement class]])
            [filteredDictionaryArray addObject:[(JRPost_login_confirmationElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_Profiles_ToFromDictionary)
- (NSArray*)arrayOfProfilesElementsFromProfilesDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredProfilesArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredProfilesArray addObject:[JRProfilesElement profilesElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredProfilesArray;
}

- (NSArray*)arrayOfProfilesElementsFromProfilesDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfProfilesElementsFromProfilesDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfProfilesDictionariesFromProfilesElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfilesElement class]])
            [filteredDictionaryArray addObject:[(JRProfilesElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfProfilesDictionariesFromProfilesElements
{
    return [self arrayOfProfilesDictionariesFromProfilesElementsForEncoder:NO];
}

- (NSArray*)arrayOfProfilesReplaceDictionariesFromProfilesElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfilesElement class]])
            [filteredDictionaryArray addObject:[(JRProfilesElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_Roles_ToFromDictionary)
- (NSArray*)arrayOfRolesElementsFromRolesDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredRolesArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredRolesArray addObject:[JRRolesElement rolesElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredRolesArray;
}

- (NSArray*)arrayOfRolesElementsFromRolesDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfRolesElementsFromRolesDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfRolesDictionariesFromRolesElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRRolesElement class]])
            [filteredDictionaryArray addObject:[(JRRolesElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfRolesDictionariesFromRolesElements
{
    return [self arrayOfRolesDictionariesFromRolesElementsForEncoder:NO];
}

- (NSArray*)arrayOfRolesReplaceDictionariesFromRolesElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRRolesElement class]])
            [filteredDictionaryArray addObject:[(JRRolesElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_SitecatalystIDs_ToFromDictionary)
- (NSArray*)arrayOfSitecatalystIDsElementsFromSitecatalystIDsDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredSitecatalystIDsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredSitecatalystIDsArray addObject:[JRSitecatalystIDsElement sitecatalystIDsElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredSitecatalystIDsArray;
}

- (NSArray*)arrayOfSitecatalystIDsElementsFromSitecatalystIDsDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfSitecatalystIDsElementsFromSitecatalystIDsDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfSitecatalystIDsDictionariesFromSitecatalystIDsElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRSitecatalystIDsElement class]])
            [filteredDictionaryArray addObject:[(JRSitecatalystIDsElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfSitecatalystIDsDictionariesFromSitecatalystIDsElements
{
    return [self arrayOfSitecatalystIDsDictionariesFromSitecatalystIDsElementsForEncoder:NO];
}

- (NSArray*)arrayOfSitecatalystIDsReplaceDictionariesFromSitecatalystIDsElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRSitecatalystIDsElement class]])
            [filteredDictionaryArray addObject:[(JRSitecatalystIDsElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_Statuses_ToFromDictionary)
- (NSArray*)arrayOfStatusesElementsFromStatusesDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredStatusesArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredStatusesArray addObject:[JRStatusesElement statusesElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredStatusesArray;
}

- (NSArray*)arrayOfStatusesElementsFromStatusesDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfStatusesElementsFromStatusesDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfStatusesDictionariesFromStatusesElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRStatusesElement class]])
            [filteredDictionaryArray addObject:[(JRStatusesElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfStatusesDictionariesFromStatusesElements
{
    return [self arrayOfStatusesDictionariesFromStatusesElementsForEncoder:NO];
}

- (NSArray*)arrayOfStatusesReplaceDictionariesFromStatusesElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRStatusesElement class]])
            [filteredDictionaryArray addObject:[(JRStatusesElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_VisitedMicroSites_ToFromDictionary)
- (NSArray*)arrayOfVisitedMicroSitesElementsFromVisitedMicroSitesDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredVisitedMicroSitesArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredVisitedMicroSitesArray addObject:[JRVisitedMicroSitesElement visitedMicroSitesElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredVisitedMicroSitesArray;
}

- (NSArray*)arrayOfVisitedMicroSitesElementsFromVisitedMicroSitesDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfVisitedMicroSitesElementsFromVisitedMicroSitesDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfVisitedMicroSitesDictionariesFromVisitedMicroSitesElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRVisitedMicroSitesElement class]])
            [filteredDictionaryArray addObject:[(JRVisitedMicroSitesElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfVisitedMicroSitesDictionariesFromVisitedMicroSitesElements
{
    return [self arrayOfVisitedMicroSitesDictionariesFromVisitedMicroSitesElementsForEncoder:NO];
}

- (NSArray*)arrayOfVisitedMicroSitesReplaceDictionariesFromVisitedMicroSitesElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRVisitedMicroSitesElement class]])
            [filteredDictionaryArray addObject:[(JRVisitedMicroSitesElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (CaptureUser_ArrayComparison)
- (BOOL)isEqualToBadgeVillePlayerIDsArray:(NSArray *)otherArray;
- (BOOL)isEqualToCampaignsArray:(NSArray *)otherArray;
- (BOOL)isEqualToChildrenArray:(NSArray *)otherArray;
- (BOOL)isEqualToClientsArray:(NSArray *)otherArray;
- (BOOL)isEqualToConsentsArray:(NSArray *)otherArray;
- (BOOL)isEqualToConsumerInterestsArray:(NSArray *)otherArray;
- (BOOL)isEqualToDeviceIdentificationArray:(NSArray *)otherArray;
- (BOOL)isEqualToFriendsArray:(NSArray *)otherArray;
- (BOOL)isEqualToPhotosArray:(NSArray *)otherArray;
- (BOOL)isEqualToPost_login_confirmationArray:(NSArray *)otherArray;
- (BOOL)isEqualToProfilesArray:(NSArray *)otherArray;
- (BOOL)isEqualToRolesArray:(NSArray *)otherArray;
- (BOOL)isEqualToSitecatalystIDsArray:(NSArray *)otherArray;
- (BOOL)isEqualToStatusesArray:(NSArray *)otherArray;
- (BOOL)isEqualToVisitedMicroSitesArray:(NSArray *)otherArray;
@end

@implementation NSArray (CaptureUser_ArrayComparison)

- (BOOL)isEqualToBadgeVillePlayerIDsArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRBadgeVillePlayerIDsElement *)[self objectAtIndex:i]) isEqualToBadgeVillePlayerIDsElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToCampaignsArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRCampaignsElement *)[self objectAtIndex:i]) isEqualToCampaignsElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToChildrenArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRChildrenElement *)[self objectAtIndex:i]) isEqualToChildrenElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToClientsArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRClientsElement *)[self objectAtIndex:i]) isEqualToClientsElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToConsentsArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRConsentsElement *)[self objectAtIndex:i]) isEqualToConsentsElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToConsumerInterestsArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRConsumerInterestsElement *)[self objectAtIndex:i]) isEqualToConsumerInterestsElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToDeviceIdentificationArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRDeviceIdentificationElement *)[self objectAtIndex:i]) isEqualToDeviceIdentificationElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToFriendsArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRFriendsElement *)[self objectAtIndex:i]) isEqualToFriendsElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToPhotosArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPhotosElement *)[self objectAtIndex:i]) isEqualToPhotosElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToPost_login_confirmationArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPost_login_confirmationElement *)[self objectAtIndex:i]) isEqualToPost_login_confirmationElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToProfilesArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRProfilesElement *)[self objectAtIndex:i]) isEqualToProfilesElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToRolesArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRRolesElement *)[self objectAtIndex:i]) isEqualToRolesElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToSitecatalystIDsArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRSitecatalystIDsElement *)[self objectAtIndex:i]) isEqualToSitecatalystIDsElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToStatusesArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRStatusesElement *)[self objectAtIndex:i]) isEqualToStatusesElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToVisitedMicroSitesArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRVisitedMicroSitesElement *)[self objectAtIndex:i]) isEqualToVisitedMicroSitesElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}
@end

@interface JRCaptureUser ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRCaptureUser
{
    NSString *_CPF;
    NSString *_NRIC;
    NSString *_aboutMe;
    JRBoolean *_avmTCAgreed;
    JRDateTime *_avmTermsAgreedDate;
    NSArray *_badgeVillePlayerIDs;
    NSString *_batchId;
    JRDate *_birthday;
    NSString *_campaignID;
    NSArray *_campaigns;
    NSString *_catalogLocaleItem;
    NSArray *_children;
    NSArray *_clients;
    JRCloudsearch *_cloudsearch;
    JRBoolean *_consentVerified;
    JRDateTime *_consentVerifiedAt;
    NSArray *_consents;
    NSArray *_consumerInterests;
    JRInteger *_consumerPoints;
    NSString *_controlField;
    JRDateTime *_coppaCommunicationSentAt;
    NSString *_currentLocation;
    JRDateTime *_deactivateAccount;
    JRDateTime *_deactivatedAccount;
    NSArray *_deviceIdentification;
    JRJsonObject *_display;
    NSString *_displayName;
    NSString *_email;
    JRDateTime *_emailVerified;
    NSString *_externalId;
    NSString *_familyId;
    NSString *_familyName;
    NSString *_familyRole;
    NSString *_firstNamePronunciation;
    NSArray *_friends;
    NSString *_gender;
    NSString *_givenName;
    JRIdentifierInformation *_identifierInformation;
    JRBoolean *_interestAvent;
    JRBoolean *_interestCampaigns;
    NSString *_interestCategories;
    JRBoolean *_interestCommunications;
    JRBoolean *_interestPromotions;
    JRBoolean *_interestStreamiumSurveys;
    JRBoolean *_interestStreamiumUpgrades;
    JRBoolean *_interestSurveys;
    JRBoolean *_interestWULsounds;
    JRJanrain *_janrain;
    JRDateTime *_lastLogin;
    NSString *_lastLoginMethod;
    JRDateTime *_lastModifiedDate;
    NSString *_lastModifiedSource;
    NSString *_lastNamePronunciation;
    JRLastUsedDevice *_lastUsedDevice;
    JRInteger *_legacyID;
    NSString *_maritalStatus;
    JRMarketingOptIn *_marketingOptIn;
    NSString *_medicalProfessionalRoleSpecified;
    NSString *_middleName;
    JRMigration *_migration;
    NSString *_mobileNumber;
    JRBoolean *_mobileNumberNeedVerification;
    JRDateTime *_mobileNumberSmsRequestedAt;
    JRDateTime *_mobileNumberVerified;
    JRBoolean *_nettvTCAgreed;
    JRDateTime *_nettvTermsAgreedDate;
    NSString *_nickName;
    JRBoolean *_olderThanAgeLimit;
    JROptIn *_optIn;
    JRPassword *_password;
    JRDateTime *_personalDataMarketingProfiling;
    JRDateTime *_personalDataTransferAcceptance;
    JRDateTime *_personalDataUsageAcceptance;
    NSArray *_photos;
    NSArray *_post_login_confirmation;
    NSString *_preferredLanguage;
    JRPrimaryAddress *_primaryAddress;
    NSArray *_profiles;
    NSString *_providerMergedLast;
    JRBoolean *_receiveMarketingEmail;
    JRBoolean *_requiresVerification;
    JRDateTime *_retentionConsentGivenAt;
    NSArray *_roles;
    NSString *_salutation;
    NSArray *_sitecatalystIDs;
    NSString *_ssn;
    NSArray *_statuses;
    JRBoolean *_streamiumServicesTCAgreed;
    JRDateTime *_termsAndConditionsAcceptance;
    NSArray *_visitedMicroSites;
    JRDateTime *_weddingDate;
    NSString *_wishList;
    JRObjectId *_captureUserId;
    JRUuid *_uuid;
    JRDateTime *_lastUpdated;
    JRDateTime *_created;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)CPF
{
    return _CPF;
}

- (void)setCPF:(NSString *)newCPF
{
    [self.dirtyPropertySet addObject:@"CPF"];

    _CPF = [newCPF copy];
}

- (NSString *)NRIC
{
    return _NRIC;
}

- (void)setNRIC:(NSString *)newNRIC
{
    [self.dirtyPropertySet addObject:@"NRIC"];

    _NRIC = [newNRIC copy];
}

- (NSString *)aboutMe
{
    return _aboutMe;
}

- (void)setAboutMe:(NSString *)newAboutMe
{
    [self.dirtyPropertySet addObject:@"aboutMe"];

    _aboutMe = [newAboutMe copy];
}

- (JRBoolean *)avmTCAgreed
{
    return _avmTCAgreed;
}

- (void)setAvmTCAgreed:(JRBoolean *)newAvmTCAgreed
{
    [self.dirtyPropertySet addObject:@"avmTCAgreed"];

    _avmTCAgreed = [newAvmTCAgreed copy];
}

- (BOOL)getAvmTCAgreedBoolValue
{
    return [_avmTCAgreed boolValue];
}

- (void)setAvmTCAgreedWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"avmTCAgreed"];

    _avmTCAgreed = [NSNumber numberWithBool:boolVal];
}

- (JRDateTime *)avmTermsAgreedDate
{
    return _avmTermsAgreedDate;
}

- (void)setAvmTermsAgreedDate:(JRDateTime *)newAvmTermsAgreedDate
{
    [self.dirtyPropertySet addObject:@"avmTermsAgreedDate"];

    _avmTermsAgreedDate = [newAvmTermsAgreedDate copy];
}

- (NSArray *)badgeVillePlayerIDs
{
    return _badgeVillePlayerIDs;
}

- (void)setBadgeVillePlayerIDs:(NSArray *)newBadgeVillePlayerIDs
{
    _badgeVillePlayerIDs = [newBadgeVillePlayerIDs copy];
}

- (NSString *)batchId
{
    return _batchId;
}

- (void)setBatchId:(NSString *)newBatchId
{
    [self.dirtyPropertySet addObject:@"batchId"];

    _batchId = [newBatchId copy];
}

- (JRDate *)birthday
{
    return _birthday;
}

- (void)setBirthday:(JRDate *)newBirthday
{
    [self.dirtyPropertySet addObject:@"birthday"];

    _birthday = [newBirthday copy];
}

- (NSString *)campaignID
{
    return _campaignID;
}

- (void)setCampaignID:(NSString *)newCampaignID
{
    [self.dirtyPropertySet addObject:@"campaignID"];

    _campaignID = [newCampaignID copy];
}

- (NSArray *)campaigns
{
    return _campaigns;
}

- (void)setCampaigns:(NSArray *)newCampaigns
{
    _campaigns = [newCampaigns copy];
}

- (NSString *)catalogLocaleItem
{
    return _catalogLocaleItem;
}

- (void)setCatalogLocaleItem:(NSString *)newCatalogLocaleItem
{
    [self.dirtyPropertySet addObject:@"catalogLocaleItem"];

    _catalogLocaleItem = [newCatalogLocaleItem copy];
}

- (NSArray *)children
{
    return _children;
}

- (void)setChildren:(NSArray *)newChildren
{
    _children = [newChildren copy];
}

- (NSArray *)clients
{
    return _clients;
}

- (void)setClients:(NSArray *)newClients
{
    _clients = [newClients copy];
}

- (JRCloudsearch *)cloudsearch
{
    return _cloudsearch;
}

- (void)setCloudsearch:(JRCloudsearch *)newCloudsearch
{
    [self.dirtyPropertySet addObject:@"cloudsearch"];

    _cloudsearch = newCloudsearch;

    [_cloudsearch setAllPropertiesToDirty];
}

- (JRBoolean *)consentVerified
{
    return _consentVerified;
}

- (void)setConsentVerified:(JRBoolean *)newConsentVerified
{
    [self.dirtyPropertySet addObject:@"consentVerified"];

    _consentVerified = [newConsentVerified copy];
}

- (BOOL)getConsentVerifiedBoolValue
{
    return [_consentVerified boolValue];
}

- (void)setConsentVerifiedWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"consentVerified"];

    _consentVerified = [NSNumber numberWithBool:boolVal];
}

- (JRDateTime *)consentVerifiedAt
{
    return _consentVerifiedAt;
}

- (void)setConsentVerifiedAt:(JRDateTime *)newConsentVerifiedAt
{
    [self.dirtyPropertySet addObject:@"consentVerifiedAt"];

    _consentVerifiedAt = [newConsentVerifiedAt copy];
}

- (NSArray *)consents
{
    return _consents;
}

- (void)setConsents:(NSArray *)newConsents
{
    _consents = [newConsents copy];
}

- (NSArray *)consumerInterests
{
    return _consumerInterests;
}

- (void)setConsumerInterests:(NSArray *)newConsumerInterests
{
    _consumerInterests = [newConsumerInterests copy];
}

- (JRInteger *)consumerPoints
{
    return _consumerPoints;
}

- (void)setConsumerPoints:(JRInteger *)newConsumerPoints
{
    [self.dirtyPropertySet addObject:@"consumerPoints"];

    _consumerPoints = [newConsumerPoints copy];
}

- (NSInteger)getConsumerPointsIntegerValue
{
    return [_consumerPoints integerValue];
}

- (void)setConsumerPointsWithInteger:(NSInteger)integerVal
{
    [self.dirtyPropertySet addObject:@"consumerPoints"];

    _consumerPoints = [NSNumber numberWithInteger:integerVal];
}

- (NSString *)controlField
{
    return _controlField;
}

- (void)setControlField:(NSString *)newControlField
{
    [self.dirtyPropertySet addObject:@"controlField"];

    _controlField = [newControlField copy];
}

- (JRDateTime *)coppaCommunicationSentAt
{
    return _coppaCommunicationSentAt;
}

- (void)setCoppaCommunicationSentAt:(JRDateTime *)newCoppaCommunicationSentAt
{
    [self.dirtyPropertySet addObject:@"coppaCommunicationSentAt"];

    _coppaCommunicationSentAt = [newCoppaCommunicationSentAt copy];
}

- (NSString *)currentLocation
{
    return _currentLocation;
}

- (void)setCurrentLocation:(NSString *)newCurrentLocation
{
    [self.dirtyPropertySet addObject:@"currentLocation"];

    _currentLocation = [newCurrentLocation copy];
}

- (JRDateTime *)deactivateAccount
{
    return _deactivateAccount;
}

- (void)setDeactivateAccount:(JRDateTime *)newDeactivateAccount
{
    [self.dirtyPropertySet addObject:@"deactivateAccount"];

    _deactivateAccount = [newDeactivateAccount copy];
}

- (JRDateTime *)deactivatedAccount
{
    return _deactivatedAccount;
}

- (void)setDeactivatedAccount:(JRDateTime *)newDeactivatedAccount
{
    [self.dirtyPropertySet addObject:@"deactivatedAccount"];

    _deactivatedAccount = [newDeactivatedAccount copy];
}

- (NSArray *)deviceIdentification
{
    return _deviceIdentification;
}

- (void)setDeviceIdentification:(NSArray *)newDeviceIdentification
{
    _deviceIdentification = [newDeviceIdentification copy];
}

- (JRJsonObject *)display
{
    return _display;
}

- (void)setDisplay:(JRJsonObject *)newDisplay
{
    [self.dirtyPropertySet addObject:@"display"];

    _display = [newDisplay copy];
}

- (NSString *)displayName
{
    return _displayName;
}

- (void)setDisplayName:(NSString *)newDisplayName
{
    [self.dirtyPropertySet addObject:@"displayName"];

    _displayName = [newDisplayName copy];
}

- (NSString *)email
{
    return _email;
}

- (void)setEmail:(NSString *)newEmail
{
    [self.dirtyPropertySet addObject:@"email"];

    _email = [newEmail copy];
}

- (JRDateTime *)emailVerified
{
    return _emailVerified;
}

- (void)setEmailVerified:(JRDateTime *)newEmailVerified
{
    [self.dirtyPropertySet addObject:@"emailVerified"];

    _emailVerified = [newEmailVerified copy];
}

- (NSString *)externalId
{
    return _externalId;
}

- (void)setExternalId:(NSString *)newExternalId
{
    [self.dirtyPropertySet addObject:@"externalId"];

    _externalId = [newExternalId copy];
}

- (NSString *)familyId
{
    return _familyId;
}

- (void)setFamilyId:(NSString *)newFamilyId
{
    [self.dirtyPropertySet addObject:@"familyId"];

    _familyId = [newFamilyId copy];
}

- (NSString *)familyName
{
    return _familyName;
}

- (void)setFamilyName:(NSString *)newFamilyName
{
    [self.dirtyPropertySet addObject:@"familyName"];

    _familyName = [newFamilyName copy];
}

- (NSString *)familyRole
{
    return _familyRole;
}

- (void)setFamilyRole:(NSString *)newFamilyRole
{
    [self.dirtyPropertySet addObject:@"familyRole"];

    _familyRole = [newFamilyRole copy];
}

- (NSString *)firstNamePronunciation
{
    return _firstNamePronunciation;
}

- (void)setFirstNamePronunciation:(NSString *)newFirstNamePronunciation
{
    [self.dirtyPropertySet addObject:@"firstNamePronunciation"];

    _firstNamePronunciation = [newFirstNamePronunciation copy];
}

- (NSArray *)friends
{
    return _friends;
}

- (void)setFriends:(NSArray *)newFriends
{
    _friends = [newFriends copy];
}

- (NSString *)gender
{
    return _gender;
}

- (void)setGender:(NSString *)newGender
{
    [self.dirtyPropertySet addObject:@"gender"];

    _gender = [newGender copy];
}

- (NSString *)givenName
{
    return _givenName;
}

- (void)setGivenName:(NSString *)newGivenName
{
    [self.dirtyPropertySet addObject:@"givenName"];

    _givenName = [newGivenName copy];
}

- (JRIdentifierInformation *)identifierInformation
{
    return _identifierInformation;
}

- (void)setIdentifierInformation:(JRIdentifierInformation *)newIdentifierInformation
{
    [self.dirtyPropertySet addObject:@"identifierInformation"];

    _identifierInformation = newIdentifierInformation;

    [_identifierInformation setAllPropertiesToDirty];
}

- (JRBoolean *)interestAvent
{
    return _interestAvent;
}

- (void)setInterestAvent:(JRBoolean *)newInterestAvent
{
    [self.dirtyPropertySet addObject:@"interestAvent"];

    _interestAvent = [newInterestAvent copy];
}

- (BOOL)getInterestAventBoolValue
{
    return [_interestAvent boolValue];
}

- (void)setInterestAventWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"interestAvent"];

    _interestAvent = [NSNumber numberWithBool:boolVal];
}

- (JRBoolean *)interestCampaigns
{
    return _interestCampaigns;
}

- (void)setInterestCampaigns:(JRBoolean *)newInterestCampaigns
{
    [self.dirtyPropertySet addObject:@"interestCampaigns"];

    _interestCampaigns = [newInterestCampaigns copy];
}

- (BOOL)getInterestCampaignsBoolValue
{
    return [_interestCampaigns boolValue];
}

- (void)setInterestCampaignsWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"interestCampaigns"];

    _interestCampaigns = [NSNumber numberWithBool:boolVal];
}

- (NSString *)interestCategories
{
    return _interestCategories;
}

- (void)setInterestCategories:(NSString *)newInterestCategories
{
    [self.dirtyPropertySet addObject:@"interestCategories"];

    _interestCategories = [newInterestCategories copy];
}

- (JRBoolean *)interestCommunications
{
    return _interestCommunications;
}

- (void)setInterestCommunications:(JRBoolean *)newInterestCommunications
{
    [self.dirtyPropertySet addObject:@"interestCommunications"];

    _interestCommunications = [newInterestCommunications copy];
}

- (BOOL)getInterestCommunicationsBoolValue
{
    return [_interestCommunications boolValue];
}

- (void)setInterestCommunicationsWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"interestCommunications"];

    _interestCommunications = [NSNumber numberWithBool:boolVal];
}

- (JRBoolean *)interestPromotions
{
    return _interestPromotions;
}

- (void)setInterestPromotions:(JRBoolean *)newInterestPromotions
{
    [self.dirtyPropertySet addObject:@"interestPromotions"];

    _interestPromotions = [newInterestPromotions copy];
}

- (BOOL)getInterestPromotionsBoolValue
{
    return [_interestPromotions boolValue];
}

- (void)setInterestPromotionsWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"interestPromotions"];

    _interestPromotions = [NSNumber numberWithBool:boolVal];
}

- (JRBoolean *)interestStreamiumSurveys
{
    return _interestStreamiumSurveys;
}

- (void)setInterestStreamiumSurveys:(JRBoolean *)newInterestStreamiumSurveys
{
    [self.dirtyPropertySet addObject:@"interestStreamiumSurveys"];

    _interestStreamiumSurveys = [newInterestStreamiumSurveys copy];
}

- (BOOL)getInterestStreamiumSurveysBoolValue
{
    return [_interestStreamiumSurveys boolValue];
}

- (void)setInterestStreamiumSurveysWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"interestStreamiumSurveys"];

    _interestStreamiumSurveys = [NSNumber numberWithBool:boolVal];
}

- (JRBoolean *)interestStreamiumUpgrades
{
    return _interestStreamiumUpgrades;
}

- (void)setInterestStreamiumUpgrades:(JRBoolean *)newInterestStreamiumUpgrades
{
    [self.dirtyPropertySet addObject:@"interestStreamiumUpgrades"];

    _interestStreamiumUpgrades = [newInterestStreamiumUpgrades copy];
}

- (BOOL)getInterestStreamiumUpgradesBoolValue
{
    return [_interestStreamiumUpgrades boolValue];
}

- (void)setInterestStreamiumUpgradesWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"interestStreamiumUpgrades"];

    _interestStreamiumUpgrades = [NSNumber numberWithBool:boolVal];
}

- (JRBoolean *)interestSurveys
{
    return _interestSurveys;
}

- (void)setInterestSurveys:(JRBoolean *)newInterestSurveys
{
    [self.dirtyPropertySet addObject:@"interestSurveys"];

    _interestSurveys = [newInterestSurveys copy];
}

- (BOOL)getInterestSurveysBoolValue
{
    return [_interestSurveys boolValue];
}

- (void)setInterestSurveysWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"interestSurveys"];

    _interestSurveys = [NSNumber numberWithBool:boolVal];
}

- (JRBoolean *)interestWULsounds
{
    return _interestWULsounds;
}

- (void)setInterestWULsounds:(JRBoolean *)newInterestWULsounds
{
    [self.dirtyPropertySet addObject:@"interestWULsounds"];

    _interestWULsounds = [newInterestWULsounds copy];
}

- (BOOL)getInterestWULsoundsBoolValue
{
    return [_interestWULsounds boolValue];
}

- (void)setInterestWULsoundsWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"interestWULsounds"];

    _interestWULsounds = [NSNumber numberWithBool:boolVal];
}

- (JRJanrain *)janrain
{
    return _janrain;
}

- (void)setJanrain:(JRJanrain *)newJanrain
{
    [self.dirtyPropertySet addObject:@"janrain"];

    _janrain = newJanrain;

    [_janrain setAllPropertiesToDirty];
}

- (JRDateTime *)lastLogin
{
    return _lastLogin;
}

- (void)setLastLogin:(JRDateTime *)newLastLogin
{
    [self.dirtyPropertySet addObject:@"lastLogin"];

    _lastLogin = [newLastLogin copy];
}

- (NSString *)lastLoginMethod
{
    return _lastLoginMethod;
}

- (void)setLastLoginMethod:(NSString *)newLastLoginMethod
{
    [self.dirtyPropertySet addObject:@"lastLoginMethod"];

    _lastLoginMethod = [newLastLoginMethod copy];
}

- (JRDateTime *)lastModifiedDate
{
    return _lastModifiedDate;
}

- (void)setLastModifiedDate:(JRDateTime *)newLastModifiedDate
{
    [self.dirtyPropertySet addObject:@"lastModifiedDate"];

    _lastModifiedDate = [newLastModifiedDate copy];
}

- (NSString *)lastModifiedSource
{
    return _lastModifiedSource;
}

- (void)setLastModifiedSource:(NSString *)newLastModifiedSource
{
    [self.dirtyPropertySet addObject:@"lastModifiedSource"];

    _lastModifiedSource = [newLastModifiedSource copy];
}

- (NSString *)lastNamePronunciation
{
    return _lastNamePronunciation;
}

- (void)setLastNamePronunciation:(NSString *)newLastNamePronunciation
{
    [self.dirtyPropertySet addObject:@"lastNamePronunciation"];

    _lastNamePronunciation = [newLastNamePronunciation copy];
}

- (JRLastUsedDevice *)lastUsedDevice
{
    return _lastUsedDevice;
}

- (void)setLastUsedDevice:(JRLastUsedDevice *)newLastUsedDevice
{
    [self.dirtyPropertySet addObject:@"lastUsedDevice"];

    _lastUsedDevice = newLastUsedDevice;

    [_lastUsedDevice setAllPropertiesToDirty];
}

- (JRInteger *)legacyID
{
    return _legacyID;
}

- (void)setLegacyID:(JRInteger *)newLegacyID
{
    [self.dirtyPropertySet addObject:@"legacyID"];

    _legacyID = [newLegacyID copy];
}

- (NSInteger)getLegacyIDIntegerValue
{
    return [_legacyID integerValue];
}

- (void)setLegacyIDWithInteger:(NSInteger)integerVal
{
    [self.dirtyPropertySet addObject:@"legacyID"];

    _legacyID = [NSNumber numberWithInteger:integerVal];
}

- (NSString *)maritalStatus
{
    return _maritalStatus;
}

- (void)setMaritalStatus:(NSString *)newMaritalStatus
{
    [self.dirtyPropertySet addObject:@"maritalStatus"];

    _maritalStatus = [newMaritalStatus copy];
}

- (JRMarketingOptIn *)marketingOptIn
{
    return _marketingOptIn;
}

- (void)setMarketingOptIn:(JRMarketingOptIn *)newMarketingOptIn
{
    [self.dirtyPropertySet addObject:@"marketingOptIn"];

    _marketingOptIn = newMarketingOptIn;

    [_marketingOptIn setAllPropertiesToDirty];
}

- (NSString *)medicalProfessionalRoleSpecified
{
    return _medicalProfessionalRoleSpecified;
}

- (void)setMedicalProfessionalRoleSpecified:(NSString *)newMedicalProfessionalRoleSpecified
{
    [self.dirtyPropertySet addObject:@"medicalProfessionalRoleSpecified"];

    _medicalProfessionalRoleSpecified = [newMedicalProfessionalRoleSpecified copy];
}

- (NSString *)middleName
{
    return _middleName;
}

- (void)setMiddleName:(NSString *)newMiddleName
{
    [self.dirtyPropertySet addObject:@"middleName"];

    _middleName = [newMiddleName copy];
}

- (JRMigration *)migration
{
    return _migration;
}

- (void)setMigration:(JRMigration *)newMigration
{
    [self.dirtyPropertySet addObject:@"migration"];

    _migration = newMigration;

    [_migration setAllPropertiesToDirty];
}

- (NSString *)mobileNumber
{
    return _mobileNumber;
}

- (void)setMobileNumber:(NSString *)newMobileNumber
{
    [self.dirtyPropertySet addObject:@"mobileNumber"];

    _mobileNumber = [newMobileNumber copy];
}

- (JRBoolean *)mobileNumberNeedVerification
{
    return _mobileNumberNeedVerification;
}

- (void)setMobileNumberNeedVerification:(JRBoolean *)newMobileNumberNeedVerification
{
    [self.dirtyPropertySet addObject:@"mobileNumberNeedVerification"];

    _mobileNumberNeedVerification = [newMobileNumberNeedVerification copy];
}

- (BOOL)getMobileNumberNeedVerificationBoolValue
{
    return [_mobileNumberNeedVerification boolValue];
}

- (void)setMobileNumberNeedVerificationWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"mobileNumberNeedVerification"];

    _mobileNumberNeedVerification = [NSNumber numberWithBool:boolVal];
}

- (JRDateTime *)mobileNumberSmsRequestedAt
{
    return _mobileNumberSmsRequestedAt;
}

- (void)setMobileNumberSmsRequestedAt:(JRDateTime *)newMobileNumberSmsRequestedAt
{
    [self.dirtyPropertySet addObject:@"mobileNumberSmsRequestedAt"];

    _mobileNumberSmsRequestedAt = [newMobileNumberSmsRequestedAt copy];
}

- (JRDateTime *)mobileNumberVerified
{
    return _mobileNumberVerified;
}

- (void)setMobileNumberVerified:(JRDateTime *)newMobileNumberVerified
{
    [self.dirtyPropertySet addObject:@"mobileNumberVerified"];

    _mobileNumberVerified = [newMobileNumberVerified copy];
}

- (JRBoolean *)nettvTCAgreed
{
    return _nettvTCAgreed;
}

- (void)setNettvTCAgreed:(JRBoolean *)newNettvTCAgreed
{
    [self.dirtyPropertySet addObject:@"nettvTCAgreed"];

    _nettvTCAgreed = [newNettvTCAgreed copy];
}

- (BOOL)getNettvTCAgreedBoolValue
{
    return [_nettvTCAgreed boolValue];
}

- (void)setNettvTCAgreedWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"nettvTCAgreed"];

    _nettvTCAgreed = [NSNumber numberWithBool:boolVal];
}

- (JRDateTime *)nettvTermsAgreedDate
{
    return _nettvTermsAgreedDate;
}

- (void)setNettvTermsAgreedDate:(JRDateTime *)newNettvTermsAgreedDate
{
    [self.dirtyPropertySet addObject:@"nettvTermsAgreedDate"];

    _nettvTermsAgreedDate = [newNettvTermsAgreedDate copy];
}

- (NSString *)nickName
{
    return _nickName;
}

- (void)setNickName:(NSString *)newNickName
{
    [self.dirtyPropertySet addObject:@"nickName"];

    _nickName = [newNickName copy];
}

- (JRBoolean *)olderThanAgeLimit
{
    return _olderThanAgeLimit;
}

- (void)setOlderThanAgeLimit:(JRBoolean *)newOlderThanAgeLimit
{
    [self.dirtyPropertySet addObject:@"olderThanAgeLimit"];

    _olderThanAgeLimit = [newOlderThanAgeLimit copy];
}

- (BOOL)getOlderThanAgeLimitBoolValue
{
    return [_olderThanAgeLimit boolValue];
}

- (void)setOlderThanAgeLimitWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"olderThanAgeLimit"];

    _olderThanAgeLimit = [NSNumber numberWithBool:boolVal];
}

- (JROptIn *)optIn
{
    return _optIn;
}

- (void)setOptIn:(JROptIn *)newOptIn
{
    [self.dirtyPropertySet addObject:@"optIn"];

    _optIn = newOptIn;

    [_optIn setAllPropertiesToDirty];
}

- (JRPassword *)password
{
    return _password;
}

- (void)setPassword:(JRPassword *)newPassword
{
    [self.dirtyPropertySet addObject:@"password"];

    _password = [newPassword copy];
}

- (JRDateTime *)personalDataMarketingProfiling
{
    return _personalDataMarketingProfiling;
}

- (void)setPersonalDataMarketingProfiling:(JRDateTime *)newPersonalDataMarketingProfiling
{
    [self.dirtyPropertySet addObject:@"personalDataMarketingProfiling"];

    _personalDataMarketingProfiling = [newPersonalDataMarketingProfiling copy];
}

- (JRDateTime *)personalDataTransferAcceptance
{
    return _personalDataTransferAcceptance;
}

- (void)setPersonalDataTransferAcceptance:(JRDateTime *)newPersonalDataTransferAcceptance
{
    [self.dirtyPropertySet addObject:@"personalDataTransferAcceptance"];

    _personalDataTransferAcceptance = [newPersonalDataTransferAcceptance copy];
}

- (JRDateTime *)personalDataUsageAcceptance
{
    return _personalDataUsageAcceptance;
}

- (void)setPersonalDataUsageAcceptance:(JRDateTime *)newPersonalDataUsageAcceptance
{
    [self.dirtyPropertySet addObject:@"personalDataUsageAcceptance"];

    _personalDataUsageAcceptance = [newPersonalDataUsageAcceptance copy];
}

- (NSArray *)photos
{
    return _photos;
}

- (void)setPhotos:(NSArray *)newPhotos
{
    _photos = [newPhotos copy];
}

- (NSArray *)post_login_confirmation
{
    return _post_login_confirmation;
}

- (void)setPost_login_confirmation:(NSArray *)newPost_login_confirmation
{
    _post_login_confirmation = [newPost_login_confirmation copy];
}

- (NSString *)preferredLanguage
{
    return _preferredLanguage;
}

- (void)setPreferredLanguage:(NSString *)newPreferredLanguage
{
    [self.dirtyPropertySet addObject:@"preferredLanguage"];

    _preferredLanguage = [newPreferredLanguage copy];
}

- (JRPrimaryAddress *)primaryAddress
{
    return _primaryAddress;
}

- (void)setPrimaryAddress:(JRPrimaryAddress *)newPrimaryAddress
{
    [self.dirtyPropertySet addObject:@"primaryAddress"];

    _primaryAddress = newPrimaryAddress;

    [_primaryAddress setAllPropertiesToDirty];
}

- (NSArray *)profiles
{
    return _profiles;
}

- (void)setProfiles:(NSArray *)newProfiles
{
    _profiles = [newProfiles copy];
}

- (NSString *)providerMergedLast
{
    return _providerMergedLast;
}

- (void)setProviderMergedLast:(NSString *)newProviderMergedLast
{
    [self.dirtyPropertySet addObject:@"providerMergedLast"];

    _providerMergedLast = [newProviderMergedLast copy];
}

- (JRBoolean *)receiveMarketingEmail
{
    return _receiveMarketingEmail;
}

- (void)setReceiveMarketingEmail:(JRBoolean *)newReceiveMarketingEmail
{
    [self.dirtyPropertySet addObject:@"receiveMarketingEmail"];

    _receiveMarketingEmail = [newReceiveMarketingEmail copy];
}

- (BOOL)getReceiveMarketingEmailBoolValue
{
    return [_receiveMarketingEmail boolValue];
}

- (void)setReceiveMarketingEmailWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"receiveMarketingEmail"];

    _receiveMarketingEmail = [NSNumber numberWithBool:boolVal];
}

- (JRBoolean *)requiresVerification
{
    return _requiresVerification;
}

- (void)setRequiresVerification:(JRBoolean *)newRequiresVerification
{
    [self.dirtyPropertySet addObject:@"requiresVerification"];

    _requiresVerification = [newRequiresVerification copy];
}

- (BOOL)getRequiresVerificationBoolValue
{
    return [_requiresVerification boolValue];
}

- (void)setRequiresVerificationWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"requiresVerification"];

    _requiresVerification = [NSNumber numberWithBool:boolVal];
}

- (JRDateTime *)retentionConsentGivenAt
{
    return _retentionConsentGivenAt;
}

- (void)setRetentionConsentGivenAt:(JRDateTime *)newRetentionConsentGivenAt
{
    [self.dirtyPropertySet addObject:@"retentionConsentGivenAt"];

    _retentionConsentGivenAt = [newRetentionConsentGivenAt copy];
}

- (NSArray *)roles
{
    return _roles;
}

- (void)setRoles:(NSArray *)newRoles
{
    _roles = [newRoles copy];
}

- (NSString *)salutation
{
    return _salutation;
}

- (void)setSalutation:(NSString *)newSalutation
{
    [self.dirtyPropertySet addObject:@"salutation"];

    _salutation = [newSalutation copy];
}

- (NSArray *)sitecatalystIDs
{
    return _sitecatalystIDs;
}

- (void)setSitecatalystIDs:(NSArray *)newSitecatalystIDs
{
    _sitecatalystIDs = [newSitecatalystIDs copy];
}

- (NSString *)ssn
{
    return _ssn;
}

- (void)setSsn:(NSString *)newSsn
{
    [self.dirtyPropertySet addObject:@"ssn"];

    _ssn = [newSsn copy];
}

- (NSArray *)statuses
{
    return _statuses;
}

- (void)setStatuses:(NSArray *)newStatuses
{
    _statuses = [newStatuses copy];
}

- (JRBoolean *)streamiumServicesTCAgreed
{
    return _streamiumServicesTCAgreed;
}

- (void)setStreamiumServicesTCAgreed:(JRBoolean *)newStreamiumServicesTCAgreed
{
    [self.dirtyPropertySet addObject:@"streamiumServicesTCAgreed"];

    _streamiumServicesTCAgreed = [newStreamiumServicesTCAgreed copy];
}

- (BOOL)getStreamiumServicesTCAgreedBoolValue
{
    return [_streamiumServicesTCAgreed boolValue];
}

- (void)setStreamiumServicesTCAgreedWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"streamiumServicesTCAgreed"];

    _streamiumServicesTCAgreed = [NSNumber numberWithBool:boolVal];
}

- (JRDateTime *)termsAndConditionsAcceptance
{
    return _termsAndConditionsAcceptance;
}

- (void)setTermsAndConditionsAcceptance:(JRDateTime *)newTermsAndConditionsAcceptance
{
    [self.dirtyPropertySet addObject:@"termsAndConditionsAcceptance"];

    _termsAndConditionsAcceptance = [newTermsAndConditionsAcceptance copy];
}

- (NSArray *)visitedMicroSites
{
    return _visitedMicroSites;
}

- (void)setVisitedMicroSites:(NSArray *)newVisitedMicroSites
{
    _visitedMicroSites = [newVisitedMicroSites copy];
}

- (JRDateTime *)weddingDate
{
    return _weddingDate;
}

- (void)setWeddingDate:(JRDateTime *)newWeddingDate
{
    [self.dirtyPropertySet addObject:@"weddingDate"];

    _weddingDate = [newWeddingDate copy];
}

- (NSString *)wishList
{
    return _wishList;
}

- (void)setWishList:(NSString *)newWishList
{
    [self.dirtyPropertySet addObject:@"wishList"];

    _wishList = [newWishList copy];
}

- (JRObjectId *)captureUserId
{
    return _captureUserId;
}

- (void)setCaptureUserId:(JRObjectId *)newCaptureUserId
{
    [self.dirtyPropertySet addObject:@"captureUserId"];

    _captureUserId = [newCaptureUserId copy];
}

- (JRUuid *)uuid
{
    return _uuid;
}

- (void)setUuid:(JRUuid *)newUuid
{
    [self.dirtyPropertySet addObject:@"uuid"];

    _uuid = [newUuid copy];
}

- (JRDateTime *)lastUpdated
{
    return _lastUpdated;
}

- (void)setLastUpdated:(JRDateTime *)newLastUpdated
{
    [self.dirtyPropertySet addObject:@"lastUpdated"];

    _lastUpdated = [newLastUpdated copy];
}

- (JRDateTime *)created
{
    return _created;
}

- (void)setCreated:(JRDateTime *)newCreated
{
    [self.dirtyPropertySet addObject:@"created"];

    _created = [newCreated copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"";
        self.canBeUpdatedOnCapture = YES;

        _cloudsearch = [[JRCloudsearch alloc] init];
        _identifierInformation = [[JRIdentifierInformation alloc] init];
        _janrain = [[JRJanrain alloc] init];
        _lastUsedDevice = [[JRLastUsedDevice alloc] init];
        _marketingOptIn = [[JRMarketingOptIn alloc] init];
        _migration = [[JRMigration alloc] init];
        _optIn = [[JROptIn alloc] init];
        _primaryAddress = [[JRPrimaryAddress alloc] init];

        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)captureUser
{
    return [[JRCaptureUser alloc] init];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.CPF ? self.CPF : [NSNull null])
                   forKey:@"CPF"];
    [dictionary setObject:(self.NRIC ? self.NRIC : [NSNull null])
                   forKey:@"NRIC"];
    [dictionary setObject:(self.aboutMe ? self.aboutMe : [NSNull null])
                   forKey:@"aboutMe"];
    [dictionary setObject:(self.avmTCAgreed ? [NSNumber numberWithBool:[self.avmTCAgreed boolValue]] : [NSNull null])
                   forKey:@"avmTCAgreed"];
    [dictionary setObject:(self.avmTermsAgreedDate ? [self.avmTermsAgreedDate stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"avmTermsAgreedDate"];
    [dictionary setObject:(self.badgeVillePlayerIDs ? [self.badgeVillePlayerIDs arrayOfBadgeVillePlayerIDsDictionariesFromBadgeVillePlayerIDsElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"badgeVillePlayerIDs"];
    [dictionary setObject:(self.batchId ? self.batchId : [NSNull null])
                   forKey:@"batchId"];
    [dictionary setObject:(self.birthday ? [self.birthday stringFromISO8601Date] : [NSNull null])
                   forKey:@"birthday"];
    [dictionary setObject:(self.campaignID ? self.campaignID : [NSNull null])
                   forKey:@"campaignID"];
    [dictionary setObject:(self.campaigns ? [self.campaigns arrayOfCampaignsDictionariesFromCampaignsElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"campaigns"];
    [dictionary setObject:(self.catalogLocaleItem ? self.catalogLocaleItem : [NSNull null])
                   forKey:@"catalogLocaleItem"];
    [dictionary setObject:(self.children ? [self.children arrayOfChildrenDictionariesFromChildrenElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"children"];
    [dictionary setObject:(self.clients ? [self.clients arrayOfClientsDictionariesFromClientsElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"clients"];
    [dictionary setObject:(self.cloudsearch ? [self.cloudsearch newDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"cloudsearch"];
    [dictionary setObject:(self.consentVerified ? [NSNumber numberWithBool:[self.consentVerified boolValue]] : [NSNull null])
                   forKey:@"consentVerified"];
    [dictionary setObject:(self.consentVerifiedAt ? [self.consentVerifiedAt stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"consentVerifiedAt"];
    [dictionary setObject:(self.consents ? [self.consents arrayOfConsentsDictionariesFromConsentsElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"consents"];
    [dictionary setObject:(self.consumerInterests ? [self.consumerInterests arrayOfConsumerInterestsDictionariesFromConsumerInterestsElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"consumerInterests"];
    [dictionary setObject:(self.consumerPoints ? [NSNumber numberWithInteger:[self.consumerPoints integerValue]] : [NSNull null])
                   forKey:@"consumerPoints"];
    [dictionary setObject:(self.controlField ? self.controlField : [NSNull null])
                   forKey:@"controlField"];
    [dictionary setObject:(self.coppaCommunicationSentAt ? [self.coppaCommunicationSentAt stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"coppaCommunicationSentAt"];
    [dictionary setObject:(self.currentLocation ? self.currentLocation : [NSNull null])
                   forKey:@"currentLocation"];
    [dictionary setObject:(self.deactivateAccount ? [self.deactivateAccount stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"deactivateAccount"];
    [dictionary setObject:(self.deactivatedAccount ? [self.deactivatedAccount stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"deactivatedAccount"];
    [dictionary setObject:(self.deviceIdentification ? [self.deviceIdentification arrayOfDeviceIdentificationDictionariesFromDeviceIdentificationElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"deviceIdentification"];
    [dictionary setObject:(self.display ? self.display : [NSNull null])
                   forKey:@"display"];
    [dictionary setObject:(self.displayName ? self.displayName : [NSNull null])
                   forKey:@"displayName"];
    [dictionary setObject:(self.email ? self.email : [NSNull null])
                   forKey:@"email"];
    [dictionary setObject:(self.emailVerified ? [self.emailVerified stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"emailVerified"];
    [dictionary setObject:(self.externalId ? self.externalId : [NSNull null])
                   forKey:@"externalId"];
    [dictionary setObject:(self.familyId ? self.familyId : [NSNull null])
                   forKey:@"familyId"];
    [dictionary setObject:(self.familyName ? self.familyName : [NSNull null])
                   forKey:@"familyName"];
    [dictionary setObject:(self.familyRole ? self.familyRole : [NSNull null])
                   forKey:@"familyRole"];
    [dictionary setObject:(self.firstNamePronunciation ? self.firstNamePronunciation : [NSNull null])
                   forKey:@"firstNamePronunciation"];
    [dictionary setObject:(self.friends ? [self.friends arrayOfFriendsDictionariesFromFriendsElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"friends"];
    [dictionary setObject:(self.gender ? self.gender : [NSNull null])
                   forKey:@"gender"];
    [dictionary setObject:(self.givenName ? self.givenName : [NSNull null])
                   forKey:@"givenName"];
    [dictionary setObject:(self.identifierInformation ? [self.identifierInformation newDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"identifierInformation"];
    [dictionary setObject:(self.interestAvent ? [NSNumber numberWithBool:[self.interestAvent boolValue]] : [NSNull null])
                   forKey:@"interestAvent"];
    [dictionary setObject:(self.interestCampaigns ? [NSNumber numberWithBool:[self.interestCampaigns boolValue]] : [NSNull null])
                   forKey:@"interestCampaigns"];
    [dictionary setObject:(self.interestCategories ? self.interestCategories : [NSNull null])
                   forKey:@"interestCategories"];
    [dictionary setObject:(self.interestCommunications ? [NSNumber numberWithBool:[self.interestCommunications boolValue]] : [NSNull null])
                   forKey:@"interestCommunications"];
    [dictionary setObject:(self.interestPromotions ? [NSNumber numberWithBool:[self.interestPromotions boolValue]] : [NSNull null])
                   forKey:@"interestPromotions"];
    [dictionary setObject:(self.interestStreamiumSurveys ? [NSNumber numberWithBool:[self.interestStreamiumSurveys boolValue]] : [NSNull null])
                   forKey:@"interestStreamiumSurveys"];
    [dictionary setObject:(self.interestStreamiumUpgrades ? [NSNumber numberWithBool:[self.interestStreamiumUpgrades boolValue]] : [NSNull null])
                   forKey:@"interestStreamiumUpgrades"];
    [dictionary setObject:(self.interestSurveys ? [NSNumber numberWithBool:[self.interestSurveys boolValue]] : [NSNull null])
                   forKey:@"interestSurveys"];
    [dictionary setObject:(self.interestWULsounds ? [NSNumber numberWithBool:[self.interestWULsounds boolValue]] : [NSNull null])
                   forKey:@"interestWULsounds"];
    [dictionary setObject:(self.janrain ? [self.janrain newDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"janrain"];
    [dictionary setObject:(self.lastLogin ? [self.lastLogin stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"lastLogin"];
    [dictionary setObject:(self.lastLoginMethod ? self.lastLoginMethod : [NSNull null])
                   forKey:@"lastLoginMethod"];
    [dictionary setObject:(self.lastModifiedDate ? [self.lastModifiedDate stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"lastModifiedDate"];
    [dictionary setObject:(self.lastModifiedSource ? self.lastModifiedSource : [NSNull null])
                   forKey:@"lastModifiedSource"];
    [dictionary setObject:(self.lastNamePronunciation ? self.lastNamePronunciation : [NSNull null])
                   forKey:@"lastNamePronunciation"];
    [dictionary setObject:(self.lastUsedDevice ? [self.lastUsedDevice newDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"lastUsedDevice"];
    [dictionary setObject:(self.legacyID ? [NSNumber numberWithInteger:[self.legacyID integerValue]] : [NSNull null])
                   forKey:@"legacyID"];
    [dictionary setObject:(self.maritalStatus ? self.maritalStatus : [NSNull null])
                   forKey:@"maritalStatus"];
    [dictionary setObject:(self.marketingOptIn ? [self.marketingOptIn newDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"marketingOptIn"];
    [dictionary setObject:(self.medicalProfessionalRoleSpecified ? self.medicalProfessionalRoleSpecified : [NSNull null])
                   forKey:@"medicalProfessionalRoleSpecified"];
    [dictionary setObject:(self.middleName ? self.middleName : [NSNull null])
                   forKey:@"middleName"];
    [dictionary setObject:(self.migration ? [self.migration newDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"migration"];
    [dictionary setObject:(self.mobileNumber ? self.mobileNumber : [NSNull null])
                   forKey:@"mobileNumber"];
    [dictionary setObject:(self.mobileNumberNeedVerification ? [NSNumber numberWithBool:[self.mobileNumberNeedVerification boolValue]] : [NSNull null])
                   forKey:@"mobileNumberNeedVerification"];
    [dictionary setObject:(self.mobileNumberSmsRequestedAt ? [self.mobileNumberSmsRequestedAt stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"mobileNumberSmsRequestedAt"];
    [dictionary setObject:(self.mobileNumberVerified ? [self.mobileNumberVerified stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"mobileNumberVerified"];
    [dictionary setObject:(self.nettvTCAgreed ? [NSNumber numberWithBool:[self.nettvTCAgreed boolValue]] : [NSNull null])
                   forKey:@"nettvTCAgreed"];
    [dictionary setObject:(self.nettvTermsAgreedDate ? [self.nettvTermsAgreedDate stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"nettvTermsAgreedDate"];
    [dictionary setObject:(self.nickName ? self.nickName : [NSNull null])
                   forKey:@"nickName"];
    [dictionary setObject:(self.olderThanAgeLimit ? [NSNumber numberWithBool:[self.olderThanAgeLimit boolValue]] : [NSNull null])
                   forKey:@"olderThanAgeLimit"];
    [dictionary setObject:(self.optIn ? [self.optIn newDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"optIn"];
    [dictionary setObject:(self.password ? self.password : [NSNull null])
                   forKey:@"password"];
    [dictionary setObject:(self.personalDataMarketingProfiling ? [self.personalDataMarketingProfiling stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"personalDataMarketingProfiling"];
    [dictionary setObject:(self.personalDataTransferAcceptance ? [self.personalDataTransferAcceptance stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"personalDataTransferAcceptance"];
    [dictionary setObject:(self.personalDataUsageAcceptance ? [self.personalDataUsageAcceptance stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"personalDataUsageAcceptance"];
    [dictionary setObject:(self.photos ? [self.photos arrayOfPhotosDictionariesFromPhotosElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"photos"];
    [dictionary setObject:(self.post_login_confirmation ? [self.post_login_confirmation arrayOfPost_login_confirmationDictionariesFromPost_login_confirmationElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"post_login_confirmation"];
    [dictionary setObject:(self.preferredLanguage ? self.preferredLanguage : [NSNull null])
                   forKey:@"preferredLanguage"];
    [dictionary setObject:(self.primaryAddress ? [self.primaryAddress newDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"primaryAddress"];
    [dictionary setObject:(self.profiles ? [self.profiles arrayOfProfilesDictionariesFromProfilesElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"profiles"];
    [dictionary setObject:(self.providerMergedLast ? self.providerMergedLast : [NSNull null])
                   forKey:@"providerMergedLast"];
    [dictionary setObject:(self.receiveMarketingEmail ? [NSNumber numberWithBool:[self.receiveMarketingEmail boolValue]] : [NSNull null])
                   forKey:@"receiveMarketingEmail"];
    [dictionary setObject:(self.requiresVerification ? [NSNumber numberWithBool:[self.requiresVerification boolValue]] : [NSNull null])
                   forKey:@"requiresVerification"];
    [dictionary setObject:(self.retentionConsentGivenAt ? [self.retentionConsentGivenAt stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"retentionConsentGivenAt"];
    [dictionary setObject:(self.roles ? [self.roles arrayOfRolesDictionariesFromRolesElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"roles"];
    [dictionary setObject:(self.salutation ? self.salutation : [NSNull null])
                   forKey:@"salutation"];
    [dictionary setObject:(self.sitecatalystIDs ? [self.sitecatalystIDs arrayOfSitecatalystIDsDictionariesFromSitecatalystIDsElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"sitecatalystIDs"];
    [dictionary setObject:(self.ssn ? self.ssn : [NSNull null])
                   forKey:@"ssn"];
    [dictionary setObject:(self.statuses ? [self.statuses arrayOfStatusesDictionariesFromStatusesElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"statuses"];
    [dictionary setObject:(self.streamiumServicesTCAgreed ? [NSNumber numberWithBool:[self.streamiumServicesTCAgreed boolValue]] : [NSNull null])
                   forKey:@"streamiumServicesTCAgreed"];
    [dictionary setObject:(self.termsAndConditionsAcceptance ? [self.termsAndConditionsAcceptance stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"termsAndConditionsAcceptance"];
    [dictionary setObject:(self.visitedMicroSites ? [self.visitedMicroSites arrayOfVisitedMicroSitesDictionariesFromVisitedMicroSitesElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"visitedMicroSites"];
    [dictionary setObject:(self.weddingDate ? [self.weddingDate stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"weddingDate"];
    [dictionary setObject:(self.wishList ? self.wishList : [NSNull null])
                   forKey:@"wishList"];
    [dictionary setObject:(self.captureUserId ? [NSNumber numberWithInteger:[self.captureUserId integerValue]] : [NSNull null])
                   forKey:@"id"];
    [dictionary setObject:(self.uuid ? self.uuid : [NSNull null])
                   forKey:@"uuid"];
    [dictionary setObject:(self.lastUpdated ? [self.lastUpdated stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"lastUpdated"];
    [dictionary setObject:(self.created ? [self.created stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"created"];

    if (forEncoder)
    {
        [dictionary setObject:([self.dirtyPropertySet allObjects] ? [self.dirtyPropertySet allObjects] : [NSArray array])
                       forKey:@"dirtyPropertiesSet"];
        [dictionary setObject:(self.captureObjectPath ? self.captureObjectPath : [NSNull null])
                       forKey:@"captureObjectPath"];
        [dictionary setObject:[NSNumber numberWithBool:self.canBeUpdatedOnCapture]
                       forKey:@"canBeUpdatedOnCapture"];
    }

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRCaptureUser *captureUser = [JRCaptureUser captureUser];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        captureUser.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
    }

    captureUser.CPF =
        [dictionary objectForKey:@"CPF"] != [NSNull null] ? 
        [dictionary objectForKey:@"CPF"] : nil;

    captureUser.NRIC =
        [dictionary objectForKey:@"NRIC"] != [NSNull null] ? 
        [dictionary objectForKey:@"NRIC"] : nil;

    captureUser.aboutMe =
        [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
        [dictionary objectForKey:@"aboutMe"] : nil;

    captureUser.avmTCAgreed =
        [dictionary objectForKey:@"avmTCAgreed"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"avmTCAgreed"] boolValue]] : nil;

    captureUser.avmTermsAgreedDate =
        [dictionary objectForKey:@"avmTermsAgreedDate"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"avmTermsAgreedDate"]] : nil;

    captureUser.badgeVillePlayerIDs =
        [dictionary objectForKey:@"badgeVillePlayerIDs"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"badgeVillePlayerIDs"] arrayOfBadgeVillePlayerIDsElementsFromBadgeVillePlayerIDsDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.batchId =
        [dictionary objectForKey:@"batchId"] != [NSNull null] ? 
        [dictionary objectForKey:@"batchId"] : nil;

    captureUser.birthday =
        [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
        [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"birthday"]] : nil;

    captureUser.campaignID =
        [dictionary objectForKey:@"campaignID"] != [NSNull null] ? 
        [dictionary objectForKey:@"campaignID"] : nil;

    captureUser.campaigns =
        [dictionary objectForKey:@"campaigns"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"campaigns"] arrayOfCampaignsElementsFromCampaignsDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.catalogLocaleItem =
        [dictionary objectForKey:@"catalogLocaleItem"] != [NSNull null] ? 
        [dictionary objectForKey:@"catalogLocaleItem"] : nil;

    captureUser.children =
        [dictionary objectForKey:@"children"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"children"] arrayOfChildrenElementsFromChildrenDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.clients =
        [dictionary objectForKey:@"clients"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"clients"] arrayOfClientsElementsFromClientsDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.cloudsearch =
        [dictionary objectForKey:@"cloudsearch"] != [NSNull null] ? 
        [JRCloudsearch cloudsearchObjectFromDictionary:[dictionary objectForKey:@"cloudsearch"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.consentVerified =
        [dictionary objectForKey:@"consentVerified"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"consentVerified"] boolValue]] : nil;

    captureUser.consentVerifiedAt =
        [dictionary objectForKey:@"consentVerifiedAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"consentVerifiedAt"]] : nil;

    captureUser.consents =
        [dictionary objectForKey:@"consents"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"consents"] arrayOfConsentsElementsFromConsentsDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.consumerInterests =
        [dictionary objectForKey:@"consumerInterests"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"consumerInterests"] arrayOfConsumerInterestsElementsFromConsumerInterestsDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.consumerPoints =
        [dictionary objectForKey:@"consumerPoints"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"consumerPoints"] integerValue]] : nil;

    captureUser.controlField =
        [dictionary objectForKey:@"controlField"] != [NSNull null] ? 
        [dictionary objectForKey:@"controlField"] : nil;

    captureUser.coppaCommunicationSentAt =
        [dictionary objectForKey:@"coppaCommunicationSentAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"coppaCommunicationSentAt"]] : nil;

    captureUser.currentLocation =
        [dictionary objectForKey:@"currentLocation"] != [NSNull null] ? 
        [dictionary objectForKey:@"currentLocation"] : nil;

    captureUser.deactivateAccount =
        [dictionary objectForKey:@"deactivateAccount"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"deactivateAccount"]] : nil;

    captureUser.deactivatedAccount =
        [dictionary objectForKey:@"deactivatedAccount"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"deactivatedAccount"]] : nil;

    captureUser.deviceIdentification =
        [dictionary objectForKey:@"deviceIdentification"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"deviceIdentification"] arrayOfDeviceIdentificationElementsFromDeviceIdentificationDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.display =
        [dictionary objectForKey:@"display"] != [NSNull null] ? 
        [dictionary objectForKey:@"display"] : nil;

    captureUser.displayName =
        [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
        [dictionary objectForKey:@"displayName"] : nil;

    captureUser.email =
        [dictionary objectForKey:@"email"] != [NSNull null] ? 
        [dictionary objectForKey:@"email"] : nil;

    captureUser.emailVerified =
        [dictionary objectForKey:@"emailVerified"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"emailVerified"]] : nil;

    captureUser.externalId =
        [dictionary objectForKey:@"externalId"] != [NSNull null] ? 
        [dictionary objectForKey:@"externalId"] : nil;

    captureUser.familyId =
        [dictionary objectForKey:@"familyId"] != [NSNull null] ? 
        [dictionary objectForKey:@"familyId"] : nil;

    captureUser.familyName =
        [dictionary objectForKey:@"familyName"] != [NSNull null] ? 
        [dictionary objectForKey:@"familyName"] : nil;

    captureUser.familyRole =
        [dictionary objectForKey:@"familyRole"] != [NSNull null] ? 
        [dictionary objectForKey:@"familyRole"] : nil;

    captureUser.firstNamePronunciation =
        [dictionary objectForKey:@"firstNamePronunciation"] != [NSNull null] ? 
        [dictionary objectForKey:@"firstNamePronunciation"] : nil;

    captureUser.friends =
        [dictionary objectForKey:@"friends"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"friends"] arrayOfFriendsElementsFromFriendsDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.gender =
        [dictionary objectForKey:@"gender"] != [NSNull null] ? 
        [dictionary objectForKey:@"gender"] : nil;

    captureUser.givenName =
        [dictionary objectForKey:@"givenName"] != [NSNull null] ? 
        [dictionary objectForKey:@"givenName"] : nil;

    captureUser.identifierInformation =
        [dictionary objectForKey:@"identifierInformation"] != [NSNull null] ? 
        [JRIdentifierInformation identifierInformationObjectFromDictionary:[dictionary objectForKey:@"identifierInformation"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.interestAvent =
        [dictionary objectForKey:@"interestAvent"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestAvent"] boolValue]] : nil;

    captureUser.interestCampaigns =
        [dictionary objectForKey:@"interestCampaigns"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestCampaigns"] boolValue]] : nil;

    captureUser.interestCategories =
        [dictionary objectForKey:@"interestCategories"] != [NSNull null] ? 
        [dictionary objectForKey:@"interestCategories"] : nil;

    captureUser.interestCommunications =
        [dictionary objectForKey:@"interestCommunications"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestCommunications"] boolValue]] : nil;

    captureUser.interestPromotions =
        [dictionary objectForKey:@"interestPromotions"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestPromotions"] boolValue]] : nil;

    captureUser.interestStreamiumSurveys =
        [dictionary objectForKey:@"interestStreamiumSurveys"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestStreamiumSurveys"] boolValue]] : nil;

    captureUser.interestStreamiumUpgrades =
        [dictionary objectForKey:@"interestStreamiumUpgrades"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestStreamiumUpgrades"] boolValue]] : nil;

    captureUser.interestSurveys =
        [dictionary objectForKey:@"interestSurveys"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestSurveys"] boolValue]] : nil;

    captureUser.interestWULsounds =
        [dictionary objectForKey:@"interestWULsounds"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestWULsounds"] boolValue]] : nil;

    captureUser.janrain =
        [dictionary objectForKey:@"janrain"] != [NSNull null] ? 
        [JRJanrain janrainObjectFromDictionary:[dictionary objectForKey:@"janrain"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.lastLogin =
        [dictionary objectForKey:@"lastLogin"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastLogin"]] : nil;

    captureUser.lastLoginMethod =
        [dictionary objectForKey:@"lastLoginMethod"] != [NSNull null] ? 
        [dictionary objectForKey:@"lastLoginMethod"] : nil;

    captureUser.lastModifiedDate =
        [dictionary objectForKey:@"lastModifiedDate"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastModifiedDate"]] : nil;

    captureUser.lastModifiedSource =
        [dictionary objectForKey:@"lastModifiedSource"] != [NSNull null] ? 
        [dictionary objectForKey:@"lastModifiedSource"] : nil;

    captureUser.lastNamePronunciation =
        [dictionary objectForKey:@"lastNamePronunciation"] != [NSNull null] ? 
        [dictionary objectForKey:@"lastNamePronunciation"] : nil;

    captureUser.lastUsedDevice =
        [dictionary objectForKey:@"lastUsedDevice"] != [NSNull null] ? 
        [JRLastUsedDevice lastUsedDeviceObjectFromDictionary:[dictionary objectForKey:@"lastUsedDevice"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.legacyID =
        [dictionary objectForKey:@"legacyID"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"legacyID"] integerValue]] : nil;

    captureUser.maritalStatus =
        [dictionary objectForKey:@"maritalStatus"] != [NSNull null] ? 
        [dictionary objectForKey:@"maritalStatus"] : nil;

    captureUser.marketingOptIn =
        [dictionary objectForKey:@"marketingOptIn"] != [NSNull null] ? 
        [JRMarketingOptIn marketingOptInObjectFromDictionary:[dictionary objectForKey:@"marketingOptIn"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.medicalProfessionalRoleSpecified =
        [dictionary objectForKey:@"medicalProfessionalRoleSpecified"] != [NSNull null] ? 
        [dictionary objectForKey:@"medicalProfessionalRoleSpecified"] : nil;

    captureUser.middleName =
        [dictionary objectForKey:@"middleName"] != [NSNull null] ? 
        [dictionary objectForKey:@"middleName"] : nil;

    captureUser.migration =
        [dictionary objectForKey:@"migration"] != [NSNull null] ? 
        [JRMigration migrationObjectFromDictionary:[dictionary objectForKey:@"migration"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.mobileNumber =
        [dictionary objectForKey:@"mobileNumber"] != [NSNull null] ? 
        [dictionary objectForKey:@"mobileNumber"] : nil;

    captureUser.mobileNumberNeedVerification =
        [dictionary objectForKey:@"mobileNumberNeedVerification"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"mobileNumberNeedVerification"] boolValue]] : nil;

    captureUser.mobileNumberSmsRequestedAt =
        [dictionary objectForKey:@"mobileNumberSmsRequestedAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"mobileNumberSmsRequestedAt"]] : nil;

    captureUser.mobileNumberVerified =
        [dictionary objectForKey:@"mobileNumberVerified"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"mobileNumberVerified"]] : nil;

    captureUser.nettvTCAgreed =
        [dictionary objectForKey:@"nettvTCAgreed"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"nettvTCAgreed"] boolValue]] : nil;

    captureUser.nettvTermsAgreedDate =
        [dictionary objectForKey:@"nettvTermsAgreedDate"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"nettvTermsAgreedDate"]] : nil;

    captureUser.nickName =
        [dictionary objectForKey:@"nickName"] != [NSNull null] ? 
        [dictionary objectForKey:@"nickName"] : nil;

    captureUser.olderThanAgeLimit =
        [dictionary objectForKey:@"olderThanAgeLimit"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"olderThanAgeLimit"] boolValue]] : nil;

    captureUser.optIn =
        [dictionary objectForKey:@"optIn"] != [NSNull null] ? 
        [JROptIn optInObjectFromDictionary:[dictionary objectForKey:@"optIn"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.password =
        [dictionary objectForKey:@"password"] != [NSNull null] ? 
        [dictionary objectForKey:@"password"] : nil;

    captureUser.personalDataMarketingProfiling =
        [dictionary objectForKey:@"personalDataMarketingProfiling"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"personalDataMarketingProfiling"]] : nil;

    captureUser.personalDataTransferAcceptance =
        [dictionary objectForKey:@"personalDataTransferAcceptance"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"personalDataTransferAcceptance"]] : nil;

    captureUser.personalDataUsageAcceptance =
        [dictionary objectForKey:@"personalDataUsageAcceptance"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"personalDataUsageAcceptance"]] : nil;

    captureUser.photos =
        [dictionary objectForKey:@"photos"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfPhotosElementsFromPhotosDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.post_login_confirmation =
        [dictionary objectForKey:@"post_login_confirmation"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"post_login_confirmation"] arrayOfPost_login_confirmationElementsFromPost_login_confirmationDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.preferredLanguage =
        [dictionary objectForKey:@"preferredLanguage"] != [NSNull null] ? 
        [dictionary objectForKey:@"preferredLanguage"] : nil;

    captureUser.primaryAddress =
        [dictionary objectForKey:@"primaryAddress"] != [NSNull null] ? 
        [JRPrimaryAddress primaryAddressObjectFromDictionary:[dictionary objectForKey:@"primaryAddress"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.profiles =
        [dictionary objectForKey:@"profiles"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"profiles"] arrayOfProfilesElementsFromProfilesDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.providerMergedLast =
        [dictionary objectForKey:@"providerMergedLast"] != [NSNull null] ? 
        [dictionary objectForKey:@"providerMergedLast"] : nil;

    captureUser.receiveMarketingEmail =
        [dictionary objectForKey:@"receiveMarketingEmail"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"receiveMarketingEmail"] boolValue]] : nil;

    captureUser.requiresVerification =
        [dictionary objectForKey:@"requiresVerification"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"requiresVerification"] boolValue]] : nil;

    captureUser.retentionConsentGivenAt =
        [dictionary objectForKey:@"retentionConsentGivenAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"retentionConsentGivenAt"]] : nil;

    captureUser.roles =
        [dictionary objectForKey:@"roles"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"roles"] arrayOfRolesElementsFromRolesDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.salutation =
        [dictionary objectForKey:@"salutation"] != [NSNull null] ? 
        [dictionary objectForKey:@"salutation"] : nil;

    captureUser.sitecatalystIDs =
        [dictionary objectForKey:@"sitecatalystIDs"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"sitecatalystIDs"] arrayOfSitecatalystIDsElementsFromSitecatalystIDsDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.ssn =
        [dictionary objectForKey:@"ssn"] != [NSNull null] ? 
        [dictionary objectForKey:@"ssn"] : nil;

    captureUser.statuses =
        [dictionary objectForKey:@"statuses"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"statuses"] arrayOfStatusesElementsFromStatusesDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.streamiumServicesTCAgreed =
        [dictionary objectForKey:@"streamiumServicesTCAgreed"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"streamiumServicesTCAgreed"] boolValue]] : nil;

    captureUser.termsAndConditionsAcceptance =
        [dictionary objectForKey:@"termsAndConditionsAcceptance"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"termsAndConditionsAcceptance"]] : nil;

    captureUser.visitedMicroSites =
        [dictionary objectForKey:@"visitedMicroSites"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"visitedMicroSites"] arrayOfVisitedMicroSitesElementsFromVisitedMicroSitesDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.weddingDate =
        [dictionary objectForKey:@"weddingDate"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"weddingDate"]] : nil;

    captureUser.wishList =
        [dictionary objectForKey:@"wishList"] != [NSNull null] ? 
        [dictionary objectForKey:@"wishList"] : nil;

    captureUser.captureUserId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    captureUser.uuid =
        [dictionary objectForKey:@"uuid"] != [NSNull null] ? 
        [dictionary objectForKey:@"uuid"] : nil;

    captureUser.lastUpdated =
        [dictionary objectForKey:@"lastUpdated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]] : nil;

    captureUser.created =
        [dictionary objectForKey:@"created"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]] : nil;

    if (fromDecoder)
        [captureUser.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [captureUser.dirtyPropertySet removeAllObjects];

    return captureUser;
}

+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRCaptureUser captureUserObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)decodeFromDictionary:(NSDictionary*)dictionary
{
    NSSet *dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];

    self.captureObjectPath = @"";
    self.canBeUpdatedOnCapture = YES;

    self.CPF =
        [dictionary objectForKey:@"CPF"] != [NSNull null] ? 
        [dictionary objectForKey:@"CPF"] : nil;

    self.NRIC =
        [dictionary objectForKey:@"NRIC"] != [NSNull null] ? 
        [dictionary objectForKey:@"NRIC"] : nil;

    self.aboutMe =
        [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
        [dictionary objectForKey:@"aboutMe"] : nil;

    self.avmTCAgreed =
        [dictionary objectForKey:@"avmTCAgreed"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"avmTCAgreed"] boolValue]] : nil;

    self.avmTermsAgreedDate =
        [dictionary objectForKey:@"avmTermsAgreedDate"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"avmTermsAgreedDate"]] : nil;

    self.badgeVillePlayerIDs =
        [dictionary objectForKey:@"badgeVillePlayerIDs"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"badgeVillePlayerIDs"] arrayOfBadgeVillePlayerIDsElementsFromBadgeVillePlayerIDsDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.batchId =
        [dictionary objectForKey:@"batchId"] != [NSNull null] ? 
        [dictionary objectForKey:@"batchId"] : nil;

    self.birthday =
        [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
        [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"birthday"]] : nil;

    self.campaignID =
        [dictionary objectForKey:@"campaignID"] != [NSNull null] ? 
        [dictionary objectForKey:@"campaignID"] : nil;

    self.campaigns =
        [dictionary objectForKey:@"campaigns"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"campaigns"] arrayOfCampaignsElementsFromCampaignsDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.catalogLocaleItem =
        [dictionary objectForKey:@"catalogLocaleItem"] != [NSNull null] ? 
        [dictionary objectForKey:@"catalogLocaleItem"] : nil;

    self.children =
        [dictionary objectForKey:@"children"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"children"] arrayOfChildrenElementsFromChildrenDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.clients =
        [dictionary objectForKey:@"clients"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"clients"] arrayOfClientsElementsFromClientsDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.cloudsearch =
        [dictionary objectForKey:@"cloudsearch"] != [NSNull null] ? 
        [JRCloudsearch cloudsearchObjectFromDictionary:[dictionary objectForKey:@"cloudsearch"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.consentVerified =
        [dictionary objectForKey:@"consentVerified"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"consentVerified"] boolValue]] : nil;

    self.consentVerifiedAt =
        [dictionary objectForKey:@"consentVerifiedAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"consentVerifiedAt"]] : nil;

    self.consents =
        [dictionary objectForKey:@"consents"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"consents"] arrayOfConsentsElementsFromConsentsDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.consumerInterests =
        [dictionary objectForKey:@"consumerInterests"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"consumerInterests"] arrayOfConsumerInterestsElementsFromConsumerInterestsDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.consumerPoints =
        [dictionary objectForKey:@"consumerPoints"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"consumerPoints"] integerValue]] : nil;

    self.controlField =
        [dictionary objectForKey:@"controlField"] != [NSNull null] ? 
        [dictionary objectForKey:@"controlField"] : nil;

    self.coppaCommunicationSentAt =
        [dictionary objectForKey:@"coppaCommunicationSentAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"coppaCommunicationSentAt"]] : nil;

    self.currentLocation =
        [dictionary objectForKey:@"currentLocation"] != [NSNull null] ? 
        [dictionary objectForKey:@"currentLocation"] : nil;

    self.deactivateAccount =
        [dictionary objectForKey:@"deactivateAccount"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"deactivateAccount"]] : nil;

    self.deactivatedAccount =
        [dictionary objectForKey:@"deactivatedAccount"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"deactivatedAccount"]] : nil;

    self.deviceIdentification =
        [dictionary objectForKey:@"deviceIdentification"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"deviceIdentification"] arrayOfDeviceIdentificationElementsFromDeviceIdentificationDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.display =
        [dictionary objectForKey:@"display"] != [NSNull null] ? 
        [dictionary objectForKey:@"display"] : nil;

    self.displayName =
        [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
        [dictionary objectForKey:@"displayName"] : nil;

    self.email =
        [dictionary objectForKey:@"email"] != [NSNull null] ? 
        [dictionary objectForKey:@"email"] : nil;

    self.emailVerified =
        [dictionary objectForKey:@"emailVerified"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"emailVerified"]] : nil;

    self.externalId =
        [dictionary objectForKey:@"externalId"] != [NSNull null] ? 
        [dictionary objectForKey:@"externalId"] : nil;

    self.familyId =
        [dictionary objectForKey:@"familyId"] != [NSNull null] ? 
        [dictionary objectForKey:@"familyId"] : nil;

    self.familyName =
        [dictionary objectForKey:@"familyName"] != [NSNull null] ? 
        [dictionary objectForKey:@"familyName"] : nil;

    self.familyRole =
        [dictionary objectForKey:@"familyRole"] != [NSNull null] ? 
        [dictionary objectForKey:@"familyRole"] : nil;

    self.firstNamePronunciation =
        [dictionary objectForKey:@"firstNamePronunciation"] != [NSNull null] ? 
        [dictionary objectForKey:@"firstNamePronunciation"] : nil;

    self.friends =
        [dictionary objectForKey:@"friends"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"friends"] arrayOfFriendsElementsFromFriendsDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.gender =
        [dictionary objectForKey:@"gender"] != [NSNull null] ? 
        [dictionary objectForKey:@"gender"] : nil;

    self.givenName =
        [dictionary objectForKey:@"givenName"] != [NSNull null] ? 
        [dictionary objectForKey:@"givenName"] : nil;

    self.identifierInformation =
        [dictionary objectForKey:@"identifierInformation"] != [NSNull null] ? 
        [JRIdentifierInformation identifierInformationObjectFromDictionary:[dictionary objectForKey:@"identifierInformation"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.interestAvent =
        [dictionary objectForKey:@"interestAvent"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestAvent"] boolValue]] : nil;

    self.interestCampaigns =
        [dictionary objectForKey:@"interestCampaigns"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestCampaigns"] boolValue]] : nil;

    self.interestCategories =
        [dictionary objectForKey:@"interestCategories"] != [NSNull null] ? 
        [dictionary objectForKey:@"interestCategories"] : nil;

    self.interestCommunications =
        [dictionary objectForKey:@"interestCommunications"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestCommunications"] boolValue]] : nil;

    self.interestPromotions =
        [dictionary objectForKey:@"interestPromotions"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestPromotions"] boolValue]] : nil;

    self.interestStreamiumSurveys =
        [dictionary objectForKey:@"interestStreamiumSurveys"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestStreamiumSurveys"] boolValue]] : nil;

    self.interestStreamiumUpgrades =
        [dictionary objectForKey:@"interestStreamiumUpgrades"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestStreamiumUpgrades"] boolValue]] : nil;

    self.interestSurveys =
        [dictionary objectForKey:@"interestSurveys"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestSurveys"] boolValue]] : nil;

    self.interestWULsounds =
        [dictionary objectForKey:@"interestWULsounds"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestWULsounds"] boolValue]] : nil;

    self.janrain =
        [dictionary objectForKey:@"janrain"] != [NSNull null] ? 
        [JRJanrain janrainObjectFromDictionary:[dictionary objectForKey:@"janrain"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.lastLogin =
        [dictionary objectForKey:@"lastLogin"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastLogin"]] : nil;

    self.lastLoginMethod =
        [dictionary objectForKey:@"lastLoginMethod"] != [NSNull null] ? 
        [dictionary objectForKey:@"lastLoginMethod"] : nil;

    self.lastModifiedDate =
        [dictionary objectForKey:@"lastModifiedDate"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastModifiedDate"]] : nil;

    self.lastModifiedSource =
        [dictionary objectForKey:@"lastModifiedSource"] != [NSNull null] ? 
        [dictionary objectForKey:@"lastModifiedSource"] : nil;

    self.lastNamePronunciation =
        [dictionary objectForKey:@"lastNamePronunciation"] != [NSNull null] ? 
        [dictionary objectForKey:@"lastNamePronunciation"] : nil;

    self.lastUsedDevice =
        [dictionary objectForKey:@"lastUsedDevice"] != [NSNull null] ? 
        [JRLastUsedDevice lastUsedDeviceObjectFromDictionary:[dictionary objectForKey:@"lastUsedDevice"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.legacyID =
        [dictionary objectForKey:@"legacyID"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"legacyID"] integerValue]] : nil;

    self.maritalStatus =
        [dictionary objectForKey:@"maritalStatus"] != [NSNull null] ? 
        [dictionary objectForKey:@"maritalStatus"] : nil;

    self.marketingOptIn =
        [dictionary objectForKey:@"marketingOptIn"] != [NSNull null] ? 
        [JRMarketingOptIn marketingOptInObjectFromDictionary:[dictionary objectForKey:@"marketingOptIn"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.medicalProfessionalRoleSpecified =
        [dictionary objectForKey:@"medicalProfessionalRoleSpecified"] != [NSNull null] ? 
        [dictionary objectForKey:@"medicalProfessionalRoleSpecified"] : nil;

    self.middleName =
        [dictionary objectForKey:@"middleName"] != [NSNull null] ? 
        [dictionary objectForKey:@"middleName"] : nil;

    self.migration =
        [dictionary objectForKey:@"migration"] != [NSNull null] ? 
        [JRMigration migrationObjectFromDictionary:[dictionary objectForKey:@"migration"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.mobileNumber =
        [dictionary objectForKey:@"mobileNumber"] != [NSNull null] ? 
        [dictionary objectForKey:@"mobileNumber"] : nil;

    self.mobileNumberNeedVerification =
        [dictionary objectForKey:@"mobileNumberNeedVerification"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"mobileNumberNeedVerification"] boolValue]] : nil;

    self.mobileNumberSmsRequestedAt =
        [dictionary objectForKey:@"mobileNumberSmsRequestedAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"mobileNumberSmsRequestedAt"]] : nil;

    self.mobileNumberVerified =
        [dictionary objectForKey:@"mobileNumberVerified"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"mobileNumberVerified"]] : nil;

    self.nettvTCAgreed =
        [dictionary objectForKey:@"nettvTCAgreed"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"nettvTCAgreed"] boolValue]] : nil;

    self.nettvTermsAgreedDate =
        [dictionary objectForKey:@"nettvTermsAgreedDate"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"nettvTermsAgreedDate"]] : nil;

    self.nickName =
        [dictionary objectForKey:@"nickName"] != [NSNull null] ? 
        [dictionary objectForKey:@"nickName"] : nil;

    self.olderThanAgeLimit =
        [dictionary objectForKey:@"olderThanAgeLimit"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"olderThanAgeLimit"] boolValue]] : nil;

    self.optIn =
        [dictionary objectForKey:@"optIn"] != [NSNull null] ? 
        [JROptIn optInObjectFromDictionary:[dictionary objectForKey:@"optIn"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.password =
        [dictionary objectForKey:@"password"] != [NSNull null] ? 
        [dictionary objectForKey:@"password"] : nil;

    self.personalDataMarketingProfiling =
        [dictionary objectForKey:@"personalDataMarketingProfiling"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"personalDataMarketingProfiling"]] : nil;

    self.personalDataTransferAcceptance =
        [dictionary objectForKey:@"personalDataTransferAcceptance"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"personalDataTransferAcceptance"]] : nil;

    self.personalDataUsageAcceptance =
        [dictionary objectForKey:@"personalDataUsageAcceptance"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"personalDataUsageAcceptance"]] : nil;

    self.photos =
        [dictionary objectForKey:@"photos"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfPhotosElementsFromPhotosDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.post_login_confirmation =
        [dictionary objectForKey:@"post_login_confirmation"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"post_login_confirmation"] arrayOfPost_login_confirmationElementsFromPost_login_confirmationDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.preferredLanguage =
        [dictionary objectForKey:@"preferredLanguage"] != [NSNull null] ? 
        [dictionary objectForKey:@"preferredLanguage"] : nil;

    self.primaryAddress =
        [dictionary objectForKey:@"primaryAddress"] != [NSNull null] ? 
        [JRPrimaryAddress primaryAddressObjectFromDictionary:[dictionary objectForKey:@"primaryAddress"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.profiles =
        [dictionary objectForKey:@"profiles"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"profiles"] arrayOfProfilesElementsFromProfilesDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.providerMergedLast =
        [dictionary objectForKey:@"providerMergedLast"] != [NSNull null] ? 
        [dictionary objectForKey:@"providerMergedLast"] : nil;

    self.receiveMarketingEmail =
        [dictionary objectForKey:@"receiveMarketingEmail"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"receiveMarketingEmail"] boolValue]] : nil;

    self.requiresVerification =
        [dictionary objectForKey:@"requiresVerification"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"requiresVerification"] boolValue]] : nil;

    self.retentionConsentGivenAt =
        [dictionary objectForKey:@"retentionConsentGivenAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"retentionConsentGivenAt"]] : nil;

    self.roles =
        [dictionary objectForKey:@"roles"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"roles"] arrayOfRolesElementsFromRolesDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.salutation =
        [dictionary objectForKey:@"salutation"] != [NSNull null] ? 
        [dictionary objectForKey:@"salutation"] : nil;

    self.sitecatalystIDs =
        [dictionary objectForKey:@"sitecatalystIDs"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"sitecatalystIDs"] arrayOfSitecatalystIDsElementsFromSitecatalystIDsDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.ssn =
        [dictionary objectForKey:@"ssn"] != [NSNull null] ? 
        [dictionary objectForKey:@"ssn"] : nil;

    self.statuses =
        [dictionary objectForKey:@"statuses"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"statuses"] arrayOfStatusesElementsFromStatusesDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.streamiumServicesTCAgreed =
        [dictionary objectForKey:@"streamiumServicesTCAgreed"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"streamiumServicesTCAgreed"] boolValue]] : nil;

    self.termsAndConditionsAcceptance =
        [dictionary objectForKey:@"termsAndConditionsAcceptance"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"termsAndConditionsAcceptance"]] : nil;

    self.visitedMicroSites =
        [dictionary objectForKey:@"visitedMicroSites"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"visitedMicroSites"] arrayOfVisitedMicroSitesElementsFromVisitedMicroSitesDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.weddingDate =
        [dictionary objectForKey:@"weddingDate"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"weddingDate"]] : nil;

    self.wishList =
        [dictionary objectForKey:@"wishList"] != [NSNull null] ? 
        [dictionary objectForKey:@"wishList"] : nil;

    self.captureUserId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.uuid =
        [dictionary objectForKey:@"uuid"] != [NSNull null] ? 
        [dictionary objectForKey:@"uuid"] : nil;

    self.lastUpdated =
        [dictionary objectForKey:@"lastUpdated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]] : nil;

    self.created =
        [dictionary objectForKey:@"created"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;

    self.CPF =
        [dictionary objectForKey:@"CPF"] != [NSNull null] ? 
        [dictionary objectForKey:@"CPF"] : nil;

    self.NRIC =
        [dictionary objectForKey:@"NRIC"] != [NSNull null] ? 
        [dictionary objectForKey:@"NRIC"] : nil;

    self.aboutMe =
        [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
        [dictionary objectForKey:@"aboutMe"] : nil;

    self.avmTCAgreed =
        [dictionary objectForKey:@"avmTCAgreed"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"avmTCAgreed"] boolValue]] : nil;

    self.avmTermsAgreedDate =
        [dictionary objectForKey:@"avmTermsAgreedDate"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"avmTermsAgreedDate"]] : nil;

    self.badgeVillePlayerIDs =
        [dictionary objectForKey:@"badgeVillePlayerIDs"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"badgeVillePlayerIDs"] arrayOfBadgeVillePlayerIDsElementsFromBadgeVillePlayerIDsDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.batchId =
        [dictionary objectForKey:@"batchId"] != [NSNull null] ? 
        [dictionary objectForKey:@"batchId"] : nil;

    self.birthday =
        [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
        [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"birthday"]] : nil;

    self.campaignID =
        [dictionary objectForKey:@"campaignID"] != [NSNull null] ? 
        [dictionary objectForKey:@"campaignID"] : nil;

    self.campaigns =
        [dictionary objectForKey:@"campaigns"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"campaigns"] arrayOfCampaignsElementsFromCampaignsDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.catalogLocaleItem =
        [dictionary objectForKey:@"catalogLocaleItem"] != [NSNull null] ? 
        [dictionary objectForKey:@"catalogLocaleItem"] : nil;

    self.children =
        [dictionary objectForKey:@"children"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"children"] arrayOfChildrenElementsFromChildrenDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.clients =
        [dictionary objectForKey:@"clients"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"clients"] arrayOfClientsElementsFromClientsDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    if (![dictionary objectForKey:@"cloudsearch"] || [dictionary objectForKey:@"cloudsearch"] == [NSNull null])
        self.cloudsearch = nil;
    else if (!self.cloudsearch)
        self.cloudsearch = [JRCloudsearch cloudsearchObjectFromDictionary:[dictionary objectForKey:@"cloudsearch"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.cloudsearch replaceFromDictionary:[dictionary objectForKey:@"cloudsearch"] withPath:self.captureObjectPath];

    self.consentVerified =
        [dictionary objectForKey:@"consentVerified"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"consentVerified"] boolValue]] : nil;

    self.consentVerifiedAt =
        [dictionary objectForKey:@"consentVerifiedAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"consentVerifiedAt"]] : nil;

    self.consents =
        [dictionary objectForKey:@"consents"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"consents"] arrayOfConsentsElementsFromConsentsDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.consumerInterests =
        [dictionary objectForKey:@"consumerInterests"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"consumerInterests"] arrayOfConsumerInterestsElementsFromConsumerInterestsDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.consumerPoints =
        [dictionary objectForKey:@"consumerPoints"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"consumerPoints"] integerValue]] : nil;

    self.controlField =
        [dictionary objectForKey:@"controlField"] != [NSNull null] ? 
        [dictionary objectForKey:@"controlField"] : nil;

    self.coppaCommunicationSentAt =
        [dictionary objectForKey:@"coppaCommunicationSentAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"coppaCommunicationSentAt"]] : nil;

    self.currentLocation =
        [dictionary objectForKey:@"currentLocation"] != [NSNull null] ? 
        [dictionary objectForKey:@"currentLocation"] : nil;

    self.deactivateAccount =
        [dictionary objectForKey:@"deactivateAccount"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"deactivateAccount"]] : nil;

    self.deactivatedAccount =
        [dictionary objectForKey:@"deactivatedAccount"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"deactivatedAccount"]] : nil;

    self.deviceIdentification =
        [dictionary objectForKey:@"deviceIdentification"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"deviceIdentification"] arrayOfDeviceIdentificationElementsFromDeviceIdentificationDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.display =
        [dictionary objectForKey:@"display"] != [NSNull null] ? 
        [dictionary objectForKey:@"display"] : nil;

    self.displayName =
        [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
        [dictionary objectForKey:@"displayName"] : nil;

    self.email =
        [dictionary objectForKey:@"email"] != [NSNull null] ? 
        [dictionary objectForKey:@"email"] : nil;

    self.emailVerified =
        [dictionary objectForKey:@"emailVerified"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"emailVerified"]] : nil;

    self.externalId =
        [dictionary objectForKey:@"externalId"] != [NSNull null] ? 
        [dictionary objectForKey:@"externalId"] : nil;

    self.familyId =
        [dictionary objectForKey:@"familyId"] != [NSNull null] ? 
        [dictionary objectForKey:@"familyId"] : nil;

    self.familyName =
        [dictionary objectForKey:@"familyName"] != [NSNull null] ? 
        [dictionary objectForKey:@"familyName"] : nil;

    self.familyRole =
        [dictionary objectForKey:@"familyRole"] != [NSNull null] ? 
        [dictionary objectForKey:@"familyRole"] : nil;

    self.firstNamePronunciation =
        [dictionary objectForKey:@"firstNamePronunciation"] != [NSNull null] ? 
        [dictionary objectForKey:@"firstNamePronunciation"] : nil;

    self.friends =
        [dictionary objectForKey:@"friends"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"friends"] arrayOfFriendsElementsFromFriendsDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.gender =
        [dictionary objectForKey:@"gender"] != [NSNull null] ? 
        [dictionary objectForKey:@"gender"] : nil;

    self.givenName =
        [dictionary objectForKey:@"givenName"] != [NSNull null] ? 
        [dictionary objectForKey:@"givenName"] : nil;

    if (![dictionary objectForKey:@"identifierInformation"] || [dictionary objectForKey:@"identifierInformation"] == [NSNull null])
        self.identifierInformation = nil;
    else if (!self.identifierInformation)
        self.identifierInformation = [JRIdentifierInformation identifierInformationObjectFromDictionary:[dictionary objectForKey:@"identifierInformation"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.identifierInformation replaceFromDictionary:[dictionary objectForKey:@"identifierInformation"] withPath:self.captureObjectPath];

    self.interestAvent =
        [dictionary objectForKey:@"interestAvent"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestAvent"] boolValue]] : nil;

    self.interestCampaigns =
        [dictionary objectForKey:@"interestCampaigns"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestCampaigns"] boolValue]] : nil;

    self.interestCategories =
        [dictionary objectForKey:@"interestCategories"] != [NSNull null] ? 
        [dictionary objectForKey:@"interestCategories"] : nil;

    self.interestCommunications =
        [dictionary objectForKey:@"interestCommunications"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestCommunications"] boolValue]] : nil;

    self.interestPromotions =
        [dictionary objectForKey:@"interestPromotions"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestPromotions"] boolValue]] : nil;

    self.interestStreamiumSurveys =
        [dictionary objectForKey:@"interestStreamiumSurveys"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestStreamiumSurveys"] boolValue]] : nil;

    self.interestStreamiumUpgrades =
        [dictionary objectForKey:@"interestStreamiumUpgrades"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestStreamiumUpgrades"] boolValue]] : nil;

    self.interestSurveys =
        [dictionary objectForKey:@"interestSurveys"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestSurveys"] boolValue]] : nil;

    self.interestWULsounds =
        [dictionary objectForKey:@"interestWULsounds"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"interestWULsounds"] boolValue]] : nil;

    if (![dictionary objectForKey:@"janrain"] || [dictionary objectForKey:@"janrain"] == [NSNull null])
        self.janrain = nil;
    else if (!self.janrain)
        self.janrain = [JRJanrain janrainObjectFromDictionary:[dictionary objectForKey:@"janrain"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.janrain replaceFromDictionary:[dictionary objectForKey:@"janrain"] withPath:self.captureObjectPath];

    self.lastLogin =
        [dictionary objectForKey:@"lastLogin"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastLogin"]] : nil;

    self.lastLoginMethod =
        [dictionary objectForKey:@"lastLoginMethod"] != [NSNull null] ? 
        [dictionary objectForKey:@"lastLoginMethod"] : nil;

    self.lastModifiedDate =
        [dictionary objectForKey:@"lastModifiedDate"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastModifiedDate"]] : nil;

    self.lastModifiedSource =
        [dictionary objectForKey:@"lastModifiedSource"] != [NSNull null] ? 
        [dictionary objectForKey:@"lastModifiedSource"] : nil;

    self.lastNamePronunciation =
        [dictionary objectForKey:@"lastNamePronunciation"] != [NSNull null] ? 
        [dictionary objectForKey:@"lastNamePronunciation"] : nil;

    if (![dictionary objectForKey:@"lastUsedDevice"] || [dictionary objectForKey:@"lastUsedDevice"] == [NSNull null])
        self.lastUsedDevice = nil;
    else if (!self.lastUsedDevice)
        self.lastUsedDevice = [JRLastUsedDevice lastUsedDeviceObjectFromDictionary:[dictionary objectForKey:@"lastUsedDevice"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.lastUsedDevice replaceFromDictionary:[dictionary objectForKey:@"lastUsedDevice"] withPath:self.captureObjectPath];

    self.legacyID =
        [dictionary objectForKey:@"legacyID"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"legacyID"] integerValue]] : nil;

    self.maritalStatus =
        [dictionary objectForKey:@"maritalStatus"] != [NSNull null] ? 
        [dictionary objectForKey:@"maritalStatus"] : nil;

    if (![dictionary objectForKey:@"marketingOptIn"] || [dictionary objectForKey:@"marketingOptIn"] == [NSNull null])
        self.marketingOptIn = nil;
    else if (!self.marketingOptIn)
        self.marketingOptIn = [JRMarketingOptIn marketingOptInObjectFromDictionary:[dictionary objectForKey:@"marketingOptIn"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.marketingOptIn replaceFromDictionary:[dictionary objectForKey:@"marketingOptIn"] withPath:self.captureObjectPath];

    self.medicalProfessionalRoleSpecified =
        [dictionary objectForKey:@"medicalProfessionalRoleSpecified"] != [NSNull null] ? 
        [dictionary objectForKey:@"medicalProfessionalRoleSpecified"] : nil;

    self.middleName =
        [dictionary objectForKey:@"middleName"] != [NSNull null] ? 
        [dictionary objectForKey:@"middleName"] : nil;

    if (![dictionary objectForKey:@"migration"] || [dictionary objectForKey:@"migration"] == [NSNull null])
        self.migration = nil;
    else if (!self.migration)
        self.migration = [JRMigration migrationObjectFromDictionary:[dictionary objectForKey:@"migration"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.migration replaceFromDictionary:[dictionary objectForKey:@"migration"] withPath:self.captureObjectPath];

    self.mobileNumber =
        [dictionary objectForKey:@"mobileNumber"] != [NSNull null] ? 
        [dictionary objectForKey:@"mobileNumber"] : nil;

    self.mobileNumberNeedVerification =
        [dictionary objectForKey:@"mobileNumberNeedVerification"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"mobileNumberNeedVerification"] boolValue]] : nil;

    self.mobileNumberSmsRequestedAt =
        [dictionary objectForKey:@"mobileNumberSmsRequestedAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"mobileNumberSmsRequestedAt"]] : nil;

    self.mobileNumberVerified =
        [dictionary objectForKey:@"mobileNumberVerified"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"mobileNumberVerified"]] : nil;

    self.nettvTCAgreed =
        [dictionary objectForKey:@"nettvTCAgreed"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"nettvTCAgreed"] boolValue]] : nil;

    self.nettvTermsAgreedDate =
        [dictionary objectForKey:@"nettvTermsAgreedDate"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"nettvTermsAgreedDate"]] : nil;

    self.nickName =
        [dictionary objectForKey:@"nickName"] != [NSNull null] ? 
        [dictionary objectForKey:@"nickName"] : nil;

    self.olderThanAgeLimit =
        [dictionary objectForKey:@"olderThanAgeLimit"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"olderThanAgeLimit"] boolValue]] : nil;

    if (![dictionary objectForKey:@"optIn"] || [dictionary objectForKey:@"optIn"] == [NSNull null])
        self.optIn = nil;
    else if (!self.optIn)
        self.optIn = [JROptIn optInObjectFromDictionary:[dictionary objectForKey:@"optIn"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.optIn replaceFromDictionary:[dictionary objectForKey:@"optIn"] withPath:self.captureObjectPath];

    self.password =
        [dictionary objectForKey:@"password"] != [NSNull null] ? 
        [dictionary objectForKey:@"password"] : nil;

    self.personalDataMarketingProfiling =
        [dictionary objectForKey:@"personalDataMarketingProfiling"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"personalDataMarketingProfiling"]] : nil;

    self.personalDataTransferAcceptance =
        [dictionary objectForKey:@"personalDataTransferAcceptance"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"personalDataTransferAcceptance"]] : nil;

    self.personalDataUsageAcceptance =
        [dictionary objectForKey:@"personalDataUsageAcceptance"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"personalDataUsageAcceptance"]] : nil;

    self.photos =
        [dictionary objectForKey:@"photos"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfPhotosElementsFromPhotosDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.post_login_confirmation =
        [dictionary objectForKey:@"post_login_confirmation"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"post_login_confirmation"] arrayOfPost_login_confirmationElementsFromPost_login_confirmationDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.preferredLanguage =
        [dictionary objectForKey:@"preferredLanguage"] != [NSNull null] ? 
        [dictionary objectForKey:@"preferredLanguage"] : nil;

    if (![dictionary objectForKey:@"primaryAddress"] || [dictionary objectForKey:@"primaryAddress"] == [NSNull null])
        self.primaryAddress = nil;
    else if (!self.primaryAddress)
        self.primaryAddress = [JRPrimaryAddress primaryAddressObjectFromDictionary:[dictionary objectForKey:@"primaryAddress"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.primaryAddress replaceFromDictionary:[dictionary objectForKey:@"primaryAddress"] withPath:self.captureObjectPath];

    self.profiles =
        [dictionary objectForKey:@"profiles"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"profiles"] arrayOfProfilesElementsFromProfilesDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.providerMergedLast =
        [dictionary objectForKey:@"providerMergedLast"] != [NSNull null] ? 
        [dictionary objectForKey:@"providerMergedLast"] : nil;

    self.receiveMarketingEmail =
        [dictionary objectForKey:@"receiveMarketingEmail"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"receiveMarketingEmail"] boolValue]] : nil;

    self.requiresVerification =
        [dictionary objectForKey:@"requiresVerification"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"requiresVerification"] boolValue]] : nil;

    self.retentionConsentGivenAt =
        [dictionary objectForKey:@"retentionConsentGivenAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"retentionConsentGivenAt"]] : nil;

    self.roles =
        [dictionary objectForKey:@"roles"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"roles"] arrayOfRolesElementsFromRolesDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.salutation =
        [dictionary objectForKey:@"salutation"] != [NSNull null] ? 
        [dictionary objectForKey:@"salutation"] : nil;

    self.sitecatalystIDs =
        [dictionary objectForKey:@"sitecatalystIDs"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"sitecatalystIDs"] arrayOfSitecatalystIDsElementsFromSitecatalystIDsDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.ssn =
        [dictionary objectForKey:@"ssn"] != [NSNull null] ? 
        [dictionary objectForKey:@"ssn"] : nil;

    self.statuses =
        [dictionary objectForKey:@"statuses"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"statuses"] arrayOfStatusesElementsFromStatusesDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.streamiumServicesTCAgreed =
        [dictionary objectForKey:@"streamiumServicesTCAgreed"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"streamiumServicesTCAgreed"] boolValue]] : nil;

    self.termsAndConditionsAcceptance =
        [dictionary objectForKey:@"termsAndConditionsAcceptance"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"termsAndConditionsAcceptance"]] : nil;

    self.visitedMicroSites =
        [dictionary objectForKey:@"visitedMicroSites"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"visitedMicroSites"] arrayOfVisitedMicroSitesElementsFromVisitedMicroSitesDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.weddingDate =
        [dictionary objectForKey:@"weddingDate"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"weddingDate"]] : nil;

    self.wishList =
        [dictionary objectForKey:@"wishList"] != [NSNull null] ? 
        [dictionary objectForKey:@"wishList"] : nil;

    self.captureUserId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.uuid =
        [dictionary objectForKey:@"uuid"] != [NSNull null] ? 
        [dictionary objectForKey:@"uuid"] : nil;

    self.lastUpdated =
        [dictionary objectForKey:@"lastUpdated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]] : nil;

    self.created =
        [dictionary objectForKey:@"created"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"CPF", @"NRIC", @"aboutMe", @"avmTCAgreed", @"avmTermsAgreedDate", @"batchId", @"birthday", @"campaignID", @"catalogLocaleItem", @"cloudsearch", @"consentVerified", @"consentVerifiedAt", @"consumerPoints", @"controlField", @"coppaCommunicationSentAt", @"currentLocation", @"deactivateAccount", @"deactivatedAccount", @"display", @"displayName", @"email", @"emailVerified", @"externalId", @"familyId", @"familyName", @"familyRole", @"firstNamePronunciation", @"gender", @"givenName", @"identifierInformation", @"interestAvent", @"interestCampaigns", @"interestCategories", @"interestCommunications", @"interestPromotions", @"interestStreamiumSurveys", @"interestStreamiumUpgrades", @"interestSurveys", @"interestWULsounds", @"janrain", @"lastLogin", @"lastLoginMethod", @"lastModifiedDate", @"lastModifiedSource", @"lastNamePronunciation", @"lastUsedDevice", @"legacyID", @"maritalStatus", @"marketingOptIn", @"medicalProfessionalRoleSpecified", @"middleName", @"migration", @"mobileNumber", @"mobileNumberNeedVerification", @"mobileNumberSmsRequestedAt", @"mobileNumberVerified", @"nettvTCAgreed", @"nettvTermsAgreedDate", @"nickName", @"olderThanAgeLimit", @"optIn", @"password", @"personalDataMarketingProfiling", @"personalDataTransferAcceptance", @"personalDataUsageAcceptance", @"preferredLanguage", @"primaryAddress", @"providerMergedLast", @"receiveMarketingEmail", @"requiresVerification", @"retentionConsentGivenAt", @"salutation", @"ssn", @"streamiumServicesTCAgreed", @"termsAndConditionsAcceptance", @"weddingDate", @"wishList", @"captureUserId", @"uuid", @"lastUpdated", @"created", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"captureUser"];

    if (self.cloudsearch)
        [snapshotDictionary setObject:[self.cloudsearch snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"cloudsearch"];

    if (self.identifierInformation)
        [snapshotDictionary setObject:[self.identifierInformation snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"identifierInformation"];

    if (self.janrain)
        [snapshotDictionary setObject:[self.janrain snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"janrain"];

    if (self.lastUsedDevice)
        [snapshotDictionary setObject:[self.lastUsedDevice snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"lastUsedDevice"];

    if (self.marketingOptIn)
        [snapshotDictionary setObject:[self.marketingOptIn snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"marketingOptIn"];

    if (self.migration)
        [snapshotDictionary setObject:[self.migration snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"migration"];

    if (self.optIn)
        [snapshotDictionary setObject:[self.optIn snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"optIn"];

    if (self.primaryAddress)
        [snapshotDictionary setObject:[self.primaryAddress snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"primaryAddress"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"captureUser"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"captureUser"] allObjects]];

    if ([snapshotDictionary objectForKey:@"cloudsearch"])
        [self.cloudsearch restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"cloudsearch"]];

    if ([snapshotDictionary objectForKey:@"identifierInformation"])
        [self.identifierInformation restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"identifierInformation"]];

    if ([snapshotDictionary objectForKey:@"janrain"])
        [self.janrain restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"janrain"]];

    if ([snapshotDictionary objectForKey:@"lastUsedDevice"])
        [self.lastUsedDevice restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"lastUsedDevice"]];

    if ([snapshotDictionary objectForKey:@"marketingOptIn"])
        [self.marketingOptIn restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"marketingOptIn"]];

    if ([snapshotDictionary objectForKey:@"migration"])
        [self.migration restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"migration"]];

    if ([snapshotDictionary objectForKey:@"optIn"])
        [self.optIn restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"optIn"]];

    if ([snapshotDictionary objectForKey:@"primaryAddress"])
        [self.primaryAddress restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"primaryAddress"]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"CPF"])
        [dictionary setObject:(self.CPF ? self.CPF : [NSNull null]) forKey:@"CPF"];

    if ([self.dirtyPropertySet containsObject:@"NRIC"])
        [dictionary setObject:(self.NRIC ? self.NRIC : [NSNull null]) forKey:@"NRIC"];

    if ([self.dirtyPropertySet containsObject:@"aboutMe"])
        [dictionary setObject:(self.aboutMe ? self.aboutMe : [NSNull null]) forKey:@"aboutMe"];

    if ([self.dirtyPropertySet containsObject:@"avmTCAgreed"])
        [dictionary setObject:(self.avmTCAgreed ? [NSNumber numberWithBool:[self.avmTCAgreed boolValue]] : [NSNull null]) forKey:@"avmTCAgreed"];

    if ([self.dirtyPropertySet containsObject:@"avmTermsAgreedDate"])
        [dictionary setObject:(self.avmTermsAgreedDate ? [self.avmTermsAgreedDate stringFromISO8601DateTime] : [NSNull null]) forKey:@"avmTermsAgreedDate"];

    if ([self.dirtyPropertySet containsObject:@"batchId"])
        [dictionary setObject:(self.batchId ? self.batchId : [NSNull null]) forKey:@"batchId"];

    if ([self.dirtyPropertySet containsObject:@"birthday"])
        [dictionary setObject:(self.birthday ? [self.birthday stringFromISO8601Date] : [NSNull null]) forKey:@"birthday"];

    if ([self.dirtyPropertySet containsObject:@"campaignID"])
        [dictionary setObject:(self.campaignID ? self.campaignID : [NSNull null]) forKey:@"campaignID"];

    if ([self.dirtyPropertySet containsObject:@"catalogLocaleItem"])
        [dictionary setObject:(self.catalogLocaleItem ? self.catalogLocaleItem : [NSNull null]) forKey:@"catalogLocaleItem"];

//    if ([self.dirtyPropertySet containsObject:@"cloudsearch"])
//        [dictionary setObject:(self.cloudsearch ?
//                              [self.cloudsearch toUpdateDictionary] :
//                              [[JRCloudsearch cloudsearch] toUpdateDictionary]) /* Use the default constructor to create an empty object */
//                       forKey:@"cloudsearch"];
//    else if ([self.cloudsearch needsUpdate])
//        [dictionary setObject:[self.cloudsearch toUpdateDictionary]
//                       forKey:@"cloudsearch"];

    if ([self.dirtyPropertySet containsObject:@"consentVerified"])
        [dictionary setObject:(self.consentVerified ? [NSNumber numberWithBool:[self.consentVerified boolValue]] : [NSNull null]) forKey:@"consentVerified"];

    if ([self.dirtyPropertySet containsObject:@"consentVerifiedAt"])
        [dictionary setObject:(self.consentVerifiedAt ? [self.consentVerifiedAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"consentVerifiedAt"];

    if ([self.dirtyPropertySet containsObject:@"consumerPoints"])
        [dictionary setObject:(self.consumerPoints ? [NSNumber numberWithInteger:[self.consumerPoints integerValue]] : [NSNull null]) forKey:@"consumerPoints"];

    if ([self.dirtyPropertySet containsObject:@"controlField"])
        [dictionary setObject:(self.controlField ? self.controlField : [NSNull null]) forKey:@"controlField"];

    if ([self.dirtyPropertySet containsObject:@"coppaCommunicationSentAt"])
        [dictionary setObject:(self.coppaCommunicationSentAt ? [self.coppaCommunicationSentAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"coppaCommunicationSentAt"];

    if ([self.dirtyPropertySet containsObject:@"currentLocation"])
        [dictionary setObject:(self.currentLocation ? self.currentLocation : [NSNull null]) forKey:@"currentLocation"];

    if ([self.dirtyPropertySet containsObject:@"deactivateAccount"])
        [dictionary setObject:(self.deactivateAccount ? [self.deactivateAccount stringFromISO8601DateTime] : [NSNull null]) forKey:@"deactivateAccount"];

    if ([self.dirtyPropertySet containsObject:@"deactivatedAccount"])
        [dictionary setObject:(self.deactivatedAccount ? [self.deactivatedAccount stringFromISO8601DateTime] : [NSNull null]) forKey:@"deactivatedAccount"];

    if ([self.dirtyPropertySet containsObject:@"display"])
        [dictionary setObject:(self.display ? self.display : [NSNull null]) forKey:@"display"];

    if ([self.dirtyPropertySet containsObject:@"displayName"])
        [dictionary setObject:(self.displayName ? self.displayName : [NSNull null]) forKey:@"displayName"];

    if ([self.dirtyPropertySet containsObject:@"email"])
        [dictionary setObject:(self.email ? self.email : [NSNull null]) forKey:@"email"];

    if ([self.dirtyPropertySet containsObject:@"emailVerified"])
        [dictionary setObject:(self.emailVerified ? [self.emailVerified stringFromISO8601DateTime] : [NSNull null]) forKey:@"emailVerified"];

    if ([self.dirtyPropertySet containsObject:@"externalId"])
        [dictionary setObject:(self.externalId ? self.externalId : [NSNull null]) forKey:@"externalId"];

    if ([self.dirtyPropertySet containsObject:@"familyId"])
        [dictionary setObject:(self.familyId ? self.familyId : [NSNull null]) forKey:@"familyId"];

    if ([self.dirtyPropertySet containsObject:@"familyName"])
        [dictionary setObject:(self.familyName ? self.familyName : [NSNull null]) forKey:@"familyName"];

    if ([self.dirtyPropertySet containsObject:@"familyRole"])
        [dictionary setObject:(self.familyRole ? self.familyRole : [NSNull null]) forKey:@"familyRole"];

    if ([self.dirtyPropertySet containsObject:@"firstNamePronunciation"])
        [dictionary setObject:(self.firstNamePronunciation ? self.firstNamePronunciation : [NSNull null]) forKey:@"firstNamePronunciation"];

    if ([self.dirtyPropertySet containsObject:@"gender"])
        [dictionary setObject:(self.gender ? self.gender : [NSNull null]) forKey:@"gender"];

    if ([self.dirtyPropertySet containsObject:@"givenName"])
        [dictionary setObject:(self.givenName ? self.givenName : [NSNull null]) forKey:@"givenName"];

    if ([self.dirtyPropertySet containsObject:@"identifierInformation"])
        [dictionary setObject:(self.identifierInformation ?
                              [self.identifierInformation toUpdateDictionary] :
                              [[JRIdentifierInformation identifierInformation] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"identifierInformation"];
    else if ([self.identifierInformation needsUpdate])
        [dictionary setObject:[self.identifierInformation toUpdateDictionary]
                       forKey:@"identifierInformation"];

    if ([self.dirtyPropertySet containsObject:@"interestAvent"])
        [dictionary setObject:(self.interestAvent ? [NSNumber numberWithBool:[self.interestAvent boolValue]] : [NSNull null]) forKey:@"interestAvent"];

    if ([self.dirtyPropertySet containsObject:@"interestCampaigns"])
        [dictionary setObject:(self.interestCampaigns ? [NSNumber numberWithBool:[self.interestCampaigns boolValue]] : [NSNull null]) forKey:@"interestCampaigns"];

    if ([self.dirtyPropertySet containsObject:@"interestCategories"])
        [dictionary setObject:(self.interestCategories ? self.interestCategories : [NSNull null]) forKey:@"interestCategories"];

    if ([self.dirtyPropertySet containsObject:@"interestCommunications"])
        [dictionary setObject:(self.interestCommunications ? [NSNumber numberWithBool:[self.interestCommunications boolValue]] : [NSNull null]) forKey:@"interestCommunications"];

    if ([self.dirtyPropertySet containsObject:@"interestPromotions"])
        [dictionary setObject:(self.interestPromotions ? [NSNumber numberWithBool:[self.interestPromotions boolValue]] : [NSNull null]) forKey:@"interestPromotions"];

    if ([self.dirtyPropertySet containsObject:@"interestStreamiumSurveys"])
        [dictionary setObject:(self.interestStreamiumSurveys ? [NSNumber numberWithBool:[self.interestStreamiumSurveys boolValue]] : [NSNull null]) forKey:@"interestStreamiumSurveys"];

    if ([self.dirtyPropertySet containsObject:@"interestStreamiumUpgrades"])
        [dictionary setObject:(self.interestStreamiumUpgrades ? [NSNumber numberWithBool:[self.interestStreamiumUpgrades boolValue]] : [NSNull null]) forKey:@"interestStreamiumUpgrades"];

    if ([self.dirtyPropertySet containsObject:@"interestSurveys"])
        [dictionary setObject:(self.interestSurveys ? [NSNumber numberWithBool:[self.interestSurveys boolValue]] : [NSNull null]) forKey:@"interestSurveys"];

    if ([self.dirtyPropertySet containsObject:@"interestWULsounds"])
        [dictionary setObject:(self.interestWULsounds ? [NSNumber numberWithBool:[self.interestWULsounds boolValue]] : [NSNull null]) forKey:@"interestWULsounds"];

    if ([self.dirtyPropertySet containsObject:@"janrain"])
        [dictionary setObject:(self.janrain ?
                              [self.janrain toUpdateDictionary] :
                              [[JRJanrain janrain] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"janrain"];
    else if ([self.janrain needsUpdate])
        [dictionary setObject:[self.janrain toUpdateDictionary]
                       forKey:@"janrain"];

    if ([self.dirtyPropertySet containsObject:@"lastLogin"])
        [dictionary setObject:(self.lastLogin ? [self.lastLogin stringFromISO8601DateTime] : [NSNull null]) forKey:@"lastLogin"];

    if ([self.dirtyPropertySet containsObject:@"lastLoginMethod"])
        [dictionary setObject:(self.lastLoginMethod ? self.lastLoginMethod : [NSNull null]) forKey:@"lastLoginMethod"];

    if ([self.dirtyPropertySet containsObject:@"lastModifiedDate"])
        [dictionary setObject:(self.lastModifiedDate ? [self.lastModifiedDate stringFromISO8601DateTime] : [NSNull null]) forKey:@"lastModifiedDate"];

    if ([self.dirtyPropertySet containsObject:@"lastModifiedSource"])
        [dictionary setObject:(self.lastModifiedSource ? self.lastModifiedSource : [NSNull null]) forKey:@"lastModifiedSource"];

    if ([self.dirtyPropertySet containsObject:@"lastNamePronunciation"])
        [dictionary setObject:(self.lastNamePronunciation ? self.lastNamePronunciation : [NSNull null]) forKey:@"lastNamePronunciation"];

    if ([self.dirtyPropertySet containsObject:@"lastUsedDevice"])
        [dictionary setObject:(self.lastUsedDevice ?
                              [self.lastUsedDevice toUpdateDictionary] :
                              [[JRLastUsedDevice lastUsedDevice] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"lastUsedDevice"];
    else if ([self.lastUsedDevice needsUpdate])
        [dictionary setObject:[self.lastUsedDevice toUpdateDictionary]
                       forKey:@"lastUsedDevice"];

    if ([self.dirtyPropertySet containsObject:@"legacyID"])
        [dictionary setObject:(self.legacyID ? [NSNumber numberWithInteger:[self.legacyID integerValue]] : [NSNull null]) forKey:@"legacyID"];

    if ([self.dirtyPropertySet containsObject:@"maritalStatus"])
        [dictionary setObject:(self.maritalStatus ? self.maritalStatus : [NSNull null]) forKey:@"maritalStatus"];

    if ([self.dirtyPropertySet containsObject:@"marketingOptIn"])
        [dictionary setObject:(self.marketingOptIn ?
                              [self.marketingOptIn toUpdateDictionary] :
                              [[JRMarketingOptIn marketingOptIn] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"marketingOptIn"];
    else if ([self.marketingOptIn needsUpdate])
        [dictionary setObject:[self.marketingOptIn toUpdateDictionary]
                       forKey:@"marketingOptIn"];

    if ([self.dirtyPropertySet containsObject:@"medicalProfessionalRoleSpecified"])
        [dictionary setObject:(self.medicalProfessionalRoleSpecified ? self.medicalProfessionalRoleSpecified : [NSNull null]) forKey:@"medicalProfessionalRoleSpecified"];

    if ([self.dirtyPropertySet containsObject:@"middleName"])
        [dictionary setObject:(self.middleName ? self.middleName : [NSNull null]) forKey:@"middleName"];

//    if ([self.dirtyPropertySet containsObject:@"migration"])
//        [dictionary setObject:(self.migration ?
//                              [self.migration toUpdateDictionary] :
//                              [[JRMigration migration] toUpdateDictionary]) /* Use the default constructor to create an empty object */
//                       forKey:@"migration"];
//    else if ([self.migration needsUpdate])
//        [dictionary setObject:[self.migration toUpdateDictionary]
//                       forKey:@"migration"];

    if ([self.dirtyPropertySet containsObject:@"mobileNumber"])
        [dictionary setObject:(self.mobileNumber ? self.mobileNumber : [NSNull null]) forKey:@"mobileNumber"];

    if ([self.dirtyPropertySet containsObject:@"mobileNumberNeedVerification"])
        [dictionary setObject:(self.mobileNumberNeedVerification ? [NSNumber numberWithBool:[self.mobileNumberNeedVerification boolValue]] : [NSNull null]) forKey:@"mobileNumberNeedVerification"];

    if ([self.dirtyPropertySet containsObject:@"mobileNumberSmsRequestedAt"])
        [dictionary setObject:(self.mobileNumberSmsRequestedAt ? [self.mobileNumberSmsRequestedAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"mobileNumberSmsRequestedAt"];

    if ([self.dirtyPropertySet containsObject:@"mobileNumberVerified"])
        [dictionary setObject:(self.mobileNumberVerified ? [self.mobileNumberVerified stringFromISO8601DateTime] : [NSNull null]) forKey:@"mobileNumberVerified"];

    if ([self.dirtyPropertySet containsObject:@"nettvTCAgreed"])
        [dictionary setObject:(self.nettvTCAgreed ? [NSNumber numberWithBool:[self.nettvTCAgreed boolValue]] : [NSNull null]) forKey:@"nettvTCAgreed"];

    if ([self.dirtyPropertySet containsObject:@"nettvTermsAgreedDate"])
        [dictionary setObject:(self.nettvTermsAgreedDate ? [self.nettvTermsAgreedDate stringFromISO8601DateTime] : [NSNull null]) forKey:@"nettvTermsAgreedDate"];

    if ([self.dirtyPropertySet containsObject:@"nickName"])
        [dictionary setObject:(self.nickName ? self.nickName : [NSNull null]) forKey:@"nickName"];

    if ([self.dirtyPropertySet containsObject:@"olderThanAgeLimit"])
        [dictionary setObject:(self.olderThanAgeLimit ? [NSNumber numberWithBool:[self.olderThanAgeLimit boolValue]] : [NSNull null]) forKey:@"olderThanAgeLimit"];

    if ([self.dirtyPropertySet containsObject:@"optIn"])
        [dictionary setObject:(self.optIn ?
                              [self.optIn toUpdateDictionary] :
                              [[JROptIn optIn] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"optIn"];
    else if ([self.optIn needsUpdate])
        [dictionary setObject:[self.optIn toUpdateDictionary]
                       forKey:@"optIn"];

//    if ([self.dirtyPropertySet containsObject:@"password"])
//        [dictionary setObject:(self.password ? self.password : [NSNull null]) forKey:@"password"];

    if ([self.dirtyPropertySet containsObject:@"personalDataMarketingProfiling"])
        [dictionary setObject:(self.personalDataMarketingProfiling ? [self.personalDataMarketingProfiling stringFromISO8601DateTime] : [NSNull null]) forKey:@"personalDataMarketingProfiling"];

    if ([self.dirtyPropertySet containsObject:@"personalDataTransferAcceptance"])
        [dictionary setObject:(self.personalDataTransferAcceptance ? [self.personalDataTransferAcceptance stringFromISO8601DateTime] : [NSNull null]) forKey:@"personalDataTransferAcceptance"];

    if ([self.dirtyPropertySet containsObject:@"personalDataUsageAcceptance"])
        [dictionary setObject:(self.personalDataUsageAcceptance ? [self.personalDataUsageAcceptance stringFromISO8601DateTime] : [NSNull null]) forKey:@"personalDataUsageAcceptance"];

    if ([self.dirtyPropertySet containsObject:@"preferredLanguage"])
        [dictionary setObject:(self.preferredLanguage ? self.preferredLanguage : [NSNull null]) forKey:@"preferredLanguage"];

    if ([self.dirtyPropertySet containsObject:@"primaryAddress"])
        [dictionary setObject:(self.primaryAddress ?
                              [self.primaryAddress toUpdateDictionary] :
                              [[JRPrimaryAddress primaryAddress] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"primaryAddress"];
    else if ([self.primaryAddress needsUpdate])
        [dictionary setObject:[self.primaryAddress toUpdateDictionary]
                       forKey:@"primaryAddress"];

    if ([self.dirtyPropertySet containsObject:@"providerMergedLast"])
        [dictionary setObject:(self.providerMergedLast ? self.providerMergedLast : [NSNull null]) forKey:@"providerMergedLast"];

    if ([self.dirtyPropertySet containsObject:@"receiveMarketingEmail"])
        [dictionary setObject:(self.receiveMarketingEmail ? [NSNumber numberWithBool:[self.receiveMarketingEmail boolValue]] : [NSNull null]) forKey:@"receiveMarketingEmail"];

    if ([self.dirtyPropertySet containsObject:@"requiresVerification"])
        [dictionary setObject:(self.requiresVerification ? [NSNumber numberWithBool:[self.requiresVerification boolValue]] : [NSNull null]) forKey:@"requiresVerification"];

    if ([self.dirtyPropertySet containsObject:@"retentionConsentGivenAt"])
        [dictionary setObject:(self.retentionConsentGivenAt ? [self.retentionConsentGivenAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"retentionConsentGivenAt"];

    if ([self.dirtyPropertySet containsObject:@"salutation"])
        [dictionary setObject:(self.salutation ? self.salutation : [NSNull null]) forKey:@"salutation"];

    if ([self.dirtyPropertySet containsObject:@"ssn"])
        [dictionary setObject:(self.ssn ? self.ssn : [NSNull null]) forKey:@"ssn"];

    if ([self.dirtyPropertySet containsObject:@"streamiumServicesTCAgreed"])
        [dictionary setObject:(self.streamiumServicesTCAgreed ? [NSNumber numberWithBool:[self.streamiumServicesTCAgreed boolValue]] : [NSNull null]) forKey:@"streamiumServicesTCAgreed"];

    if ([self.dirtyPropertySet containsObject:@"termsAndConditionsAcceptance"])
        [dictionary setObject:(self.termsAndConditionsAcceptance ? [self.termsAndConditionsAcceptance stringFromISO8601DateTime] : [NSNull null]) forKey:@"termsAndConditionsAcceptance"];

    if ([self.dirtyPropertySet containsObject:@"weddingDate"])
        [dictionary setObject:(self.weddingDate ? [self.weddingDate stringFromISO8601DateTime] : [NSNull null]) forKey:@"weddingDate"];

    if ([self.dirtyPropertySet containsObject:@"wishList"])
        [dictionary setObject:(self.wishList ? self.wishList : [NSNull null]) forKey:@"wishList"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)updateOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [super updateOnCaptureForDelegate:delegate context:context];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.CPF ? self.CPF : [NSNull null]) forKey:@"CPF"];
    [dictionary setObject:(self.NRIC ? self.NRIC : [NSNull null]) forKey:@"NRIC"];
    [dictionary setObject:(self.aboutMe ? self.aboutMe : [NSNull null]) forKey:@"aboutMe"];
    [dictionary setObject:(self.avmTCAgreed ? [NSNumber numberWithBool:[self.avmTCAgreed boolValue]] : [NSNull null]) forKey:@"avmTCAgreed"];
    [dictionary setObject:(self.avmTermsAgreedDate ? [self.avmTermsAgreedDate stringFromISO8601DateTime] : [NSNull null]) forKey:@"avmTermsAgreedDate"];

    [dictionary setObject:(self.badgeVillePlayerIDs ?
                          [self.badgeVillePlayerIDs arrayOfBadgeVillePlayerIDsReplaceDictionariesFromBadgeVillePlayerIDsElements] :
                          [NSArray array])
                   forKey:@"badgeVillePlayerIDs"];
    [dictionary setObject:(self.batchId ? self.batchId : [NSNull null]) forKey:@"batchId"];
    [dictionary setObject:(self.birthday ? [self.birthday stringFromISO8601Date] : [NSNull null]) forKey:@"birthday"];
    [dictionary setObject:(self.campaignID ? self.campaignID : [NSNull null]) forKey:@"campaignID"];

    [dictionary setObject:(self.campaigns ?
                          [self.campaigns arrayOfCampaignsReplaceDictionariesFromCampaignsElements] :
                          [NSArray array])
                   forKey:@"campaigns"];
    [dictionary setObject:(self.catalogLocaleItem ? self.catalogLocaleItem : [NSNull null]) forKey:@"catalogLocaleItem"];

    [dictionary setObject:(self.children ?
                          [self.children arrayOfChildrenReplaceDictionariesFromChildrenElements] :
                          [NSArray array])
                   forKey:@"children"];

    [dictionary setObject:(self.clients ?
                          [self.clients arrayOfClientsReplaceDictionariesFromClientsElements] :
                          [NSArray array])
                   forKey:@"clients"];

    [dictionary setObject:(self.cloudsearch ?
                          [self.cloudsearch toReplaceDictionary] :
                          [[JRCloudsearch cloudsearch] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"cloudsearch"];
    [dictionary setObject:(self.consentVerified ? [NSNumber numberWithBool:[self.consentVerified boolValue]] : [NSNull null]) forKey:@"consentVerified"];
    [dictionary setObject:(self.consentVerifiedAt ? [self.consentVerifiedAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"consentVerifiedAt"];

    [dictionary setObject:(self.consents ?
                          [self.consents arrayOfConsentsReplaceDictionariesFromConsentsElements] :
                          [NSArray array])
                   forKey:@"consents"];

    [dictionary setObject:(self.consumerInterests ?
                          [self.consumerInterests arrayOfConsumerInterestsReplaceDictionariesFromConsumerInterestsElements] :
                          [NSArray array])
                   forKey:@"consumerInterests"];
    [dictionary setObject:(self.consumerPoints ? [NSNumber numberWithInteger:[self.consumerPoints integerValue]] : [NSNull null]) forKey:@"consumerPoints"];
    [dictionary setObject:(self.controlField ? self.controlField : [NSNull null]) forKey:@"controlField"];
    [dictionary setObject:(self.coppaCommunicationSentAt ? [self.coppaCommunicationSentAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"coppaCommunicationSentAt"];
    [dictionary setObject:(self.currentLocation ? self.currentLocation : [NSNull null]) forKey:@"currentLocation"];
    [dictionary setObject:(self.deactivateAccount ? [self.deactivateAccount stringFromISO8601DateTime] : [NSNull null]) forKey:@"deactivateAccount"];
    [dictionary setObject:(self.deactivatedAccount ? [self.deactivatedAccount stringFromISO8601DateTime] : [NSNull null]) forKey:@"deactivatedAccount"];

    [dictionary setObject:(self.deviceIdentification ?
                          [self.deviceIdentification arrayOfDeviceIdentificationReplaceDictionariesFromDeviceIdentificationElements] :
                          [NSArray array])
                   forKey:@"deviceIdentification"];
    [dictionary setObject:(self.display ? self.display : [NSNull null]) forKey:@"display"];
    [dictionary setObject:(self.displayName ? self.displayName : [NSNull null]) forKey:@"displayName"];
    [dictionary setObject:(self.email ? self.email : [NSNull null]) forKey:@"email"];
    [dictionary setObject:(self.emailVerified ? [self.emailVerified stringFromISO8601DateTime] : [NSNull null]) forKey:@"emailVerified"];
    [dictionary setObject:(self.externalId ? self.externalId : [NSNull null]) forKey:@"externalId"];
    [dictionary setObject:(self.familyId ? self.familyId : [NSNull null]) forKey:@"familyId"];
    [dictionary setObject:(self.familyName ? self.familyName : [NSNull null]) forKey:@"familyName"];
    [dictionary setObject:(self.familyRole ? self.familyRole : [NSNull null]) forKey:@"familyRole"];
    [dictionary setObject:(self.firstNamePronunciation ? self.firstNamePronunciation : [NSNull null]) forKey:@"firstNamePronunciation"];

    [dictionary setObject:(self.friends ?
                          [self.friends arrayOfFriendsReplaceDictionariesFromFriendsElements] :
                          [NSArray array])
                   forKey:@"friends"];
    [dictionary setObject:(self.gender ? self.gender : [NSNull null]) forKey:@"gender"];
    [dictionary setObject:(self.givenName ? self.givenName : [NSNull null]) forKey:@"givenName"];

    [dictionary setObject:(self.identifierInformation ?
                          [self.identifierInformation toReplaceDictionary] :
                          [[JRIdentifierInformation identifierInformation] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"identifierInformation"];
    [dictionary setObject:(self.interestAvent ? [NSNumber numberWithBool:[self.interestAvent boolValue]] : [NSNull null]) forKey:@"interestAvent"];
    [dictionary setObject:(self.interestCampaigns ? [NSNumber numberWithBool:[self.interestCampaigns boolValue]] : [NSNull null]) forKey:@"interestCampaigns"];
    [dictionary setObject:(self.interestCategories ? self.interestCategories : [NSNull null]) forKey:@"interestCategories"];
    [dictionary setObject:(self.interestCommunications ? [NSNumber numberWithBool:[self.interestCommunications boolValue]] : [NSNull null]) forKey:@"interestCommunications"];
    [dictionary setObject:(self.interestPromotions ? [NSNumber numberWithBool:[self.interestPromotions boolValue]] : [NSNull null]) forKey:@"interestPromotions"];
    [dictionary setObject:(self.interestStreamiumSurveys ? [NSNumber numberWithBool:[self.interestStreamiumSurveys boolValue]] : [NSNull null]) forKey:@"interestStreamiumSurveys"];
    [dictionary setObject:(self.interestStreamiumUpgrades ? [NSNumber numberWithBool:[self.interestStreamiumUpgrades boolValue]] : [NSNull null]) forKey:@"interestStreamiumUpgrades"];
    [dictionary setObject:(self.interestSurveys ? [NSNumber numberWithBool:[self.interestSurveys boolValue]] : [NSNull null]) forKey:@"interestSurveys"];
    [dictionary setObject:(self.interestWULsounds ? [NSNumber numberWithBool:[self.interestWULsounds boolValue]] : [NSNull null]) forKey:@"interestWULsounds"];

    [dictionary setObject:(self.janrain ?
                          [self.janrain toReplaceDictionary] :
                          [[JRJanrain janrain] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"janrain"];
    [dictionary setObject:(self.lastLogin ? [self.lastLogin stringFromISO8601DateTime] : [NSNull null]) forKey:@"lastLogin"];
    [dictionary setObject:(self.lastLoginMethod ? self.lastLoginMethod : [NSNull null]) forKey:@"lastLoginMethod"];
    [dictionary setObject:(self.lastModifiedDate ? [self.lastModifiedDate stringFromISO8601DateTime] : [NSNull null]) forKey:@"lastModifiedDate"];
    [dictionary setObject:(self.lastModifiedSource ? self.lastModifiedSource : [NSNull null]) forKey:@"lastModifiedSource"];
    [dictionary setObject:(self.lastNamePronunciation ? self.lastNamePronunciation : [NSNull null]) forKey:@"lastNamePronunciation"];

    [dictionary setObject:(self.lastUsedDevice ?
                          [self.lastUsedDevice toReplaceDictionary] :
                          [[JRLastUsedDevice lastUsedDevice] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"lastUsedDevice"];
    [dictionary setObject:(self.legacyID ? [NSNumber numberWithInteger:[self.legacyID integerValue]] : [NSNull null]) forKey:@"legacyID"];
    [dictionary setObject:(self.maritalStatus ? self.maritalStatus : [NSNull null]) forKey:@"maritalStatus"];

    [dictionary setObject:(self.marketingOptIn ?
                          [self.marketingOptIn toReplaceDictionary] :
                          [[JRMarketingOptIn marketingOptIn] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"marketingOptIn"];
    [dictionary setObject:(self.medicalProfessionalRoleSpecified ? self.medicalProfessionalRoleSpecified : [NSNull null]) forKey:@"medicalProfessionalRoleSpecified"];
    [dictionary setObject:(self.middleName ? self.middleName : [NSNull null]) forKey:@"middleName"];

    [dictionary setObject:(self.migration ?
                          [self.migration toReplaceDictionary] :
                          [[JRMigration migration] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"migration"];
    [dictionary setObject:(self.mobileNumber ? self.mobileNumber : [NSNull null]) forKey:@"mobileNumber"];
    [dictionary setObject:(self.mobileNumberNeedVerification ? [NSNumber numberWithBool:[self.mobileNumberNeedVerification boolValue]] : [NSNull null]) forKey:@"mobileNumberNeedVerification"];
    [dictionary setObject:(self.mobileNumberSmsRequestedAt ? [self.mobileNumberSmsRequestedAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"mobileNumberSmsRequestedAt"];
    [dictionary setObject:(self.mobileNumberVerified ? [self.mobileNumberVerified stringFromISO8601DateTime] : [NSNull null]) forKey:@"mobileNumberVerified"];
    [dictionary setObject:(self.nettvTCAgreed ? [NSNumber numberWithBool:[self.nettvTCAgreed boolValue]] : [NSNull null]) forKey:@"nettvTCAgreed"];
    [dictionary setObject:(self.nettvTermsAgreedDate ? [self.nettvTermsAgreedDate stringFromISO8601DateTime] : [NSNull null]) forKey:@"nettvTermsAgreedDate"];
    [dictionary setObject:(self.nickName ? self.nickName : [NSNull null]) forKey:@"nickName"];
    [dictionary setObject:(self.olderThanAgeLimit ? [NSNumber numberWithBool:[self.olderThanAgeLimit boolValue]] : [NSNull null]) forKey:@"olderThanAgeLimit"];

    [dictionary setObject:(self.optIn ?
                          [self.optIn toReplaceDictionary] :
                          [[JROptIn optIn] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"optIn"];
    [dictionary setObject:(self.password ? self.password : [NSNull null]) forKey:@"password"];
    [dictionary setObject:(self.personalDataMarketingProfiling ? [self.personalDataMarketingProfiling stringFromISO8601DateTime] : [NSNull null]) forKey:@"personalDataMarketingProfiling"];
    [dictionary setObject:(self.personalDataTransferAcceptance ? [self.personalDataTransferAcceptance stringFromISO8601DateTime] : [NSNull null]) forKey:@"personalDataTransferAcceptance"];
    [dictionary setObject:(self.personalDataUsageAcceptance ? [self.personalDataUsageAcceptance stringFromISO8601DateTime] : [NSNull null]) forKey:@"personalDataUsageAcceptance"];

    [dictionary setObject:(self.photos ?
                          [self.photos arrayOfPhotosReplaceDictionariesFromPhotosElements] :
                          [NSArray array])
                   forKey:@"photos"];

    [dictionary setObject:(self.post_login_confirmation ?
                          [self.post_login_confirmation arrayOfPost_login_confirmationReplaceDictionariesFromPost_login_confirmationElements] :
                          [NSArray array])
                   forKey:@"post_login_confirmation"];
    [dictionary setObject:(self.preferredLanguage ? self.preferredLanguage : [NSNull null]) forKey:@"preferredLanguage"];

    [dictionary setObject:(self.primaryAddress ?
                          [self.primaryAddress toReplaceDictionary] :
                          [[JRPrimaryAddress primaryAddress] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"primaryAddress"];

    [dictionary setObject:(self.profiles ?
                          [self.profiles arrayOfProfilesReplaceDictionariesFromProfilesElements] :
                          [NSArray array])
                   forKey:@"profiles"];
    [dictionary setObject:(self.providerMergedLast ? self.providerMergedLast : [NSNull null]) forKey:@"providerMergedLast"];
    [dictionary setObject:(self.receiveMarketingEmail ? [NSNumber numberWithBool:[self.receiveMarketingEmail boolValue]] : [NSNull null]) forKey:@"receiveMarketingEmail"];
    [dictionary setObject:(self.requiresVerification ? [NSNumber numberWithBool:[self.requiresVerification boolValue]] : [NSNull null]) forKey:@"requiresVerification"];
    [dictionary setObject:(self.retentionConsentGivenAt ? [self.retentionConsentGivenAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"retentionConsentGivenAt"];

    [dictionary setObject:(self.roles ?
                          [self.roles arrayOfRolesReplaceDictionariesFromRolesElements] :
                          [NSArray array])
                   forKey:@"roles"];
    [dictionary setObject:(self.salutation ? self.salutation : [NSNull null]) forKey:@"salutation"];

    [dictionary setObject:(self.sitecatalystIDs ?
                          [self.sitecatalystIDs arrayOfSitecatalystIDsReplaceDictionariesFromSitecatalystIDsElements] :
                          [NSArray array])
                   forKey:@"sitecatalystIDs"];
    [dictionary setObject:(self.ssn ? self.ssn : [NSNull null]) forKey:@"ssn"];

    [dictionary setObject:(self.statuses ?
                          [self.statuses arrayOfStatusesReplaceDictionariesFromStatusesElements] :
                          [NSArray array])
                   forKey:@"statuses"];
    [dictionary setObject:(self.streamiumServicesTCAgreed ? [NSNumber numberWithBool:[self.streamiumServicesTCAgreed boolValue]] : [NSNull null]) forKey:@"streamiumServicesTCAgreed"];
    [dictionary setObject:(self.termsAndConditionsAcceptance ? [self.termsAndConditionsAcceptance stringFromISO8601DateTime] : [NSNull null]) forKey:@"termsAndConditionsAcceptance"];

    [dictionary setObject:(self.visitedMicroSites ?
                          [self.visitedMicroSites arrayOfVisitedMicroSitesReplaceDictionariesFromVisitedMicroSitesElements] :
                          [NSArray array])
                   forKey:@"visitedMicroSites"];
    [dictionary setObject:(self.weddingDate ? [self.weddingDate stringFromISO8601DateTime] : [NSNull null]) forKey:@"weddingDate"];
    [dictionary setObject:(self.wishList ? self.wishList : [NSNull null]) forKey:@"wishList"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)replaceBadgeVillePlayerIDsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.badgeVillePlayerIDs named:@"badgeVillePlayerIDs" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceCampaignsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.campaigns named:@"campaigns" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceChildrenArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.children named:@"children" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceClientsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.clients named:@"clients" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceConsentsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.consents named:@"consents" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceConsumerInterestsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.consumerInterests named:@"consumerInterests" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceDeviceIdentificationArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.deviceIdentification named:@"deviceIdentification" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceFriendsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.friends named:@"friends" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replacePhotosArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.photos named:@"photos" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replacePost_login_confirmationArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.post_login_confirmation named:@"post_login_confirmation" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceProfilesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.profiles named:@"profiles" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceRolesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.roles named:@"roles" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceSitecatalystIDsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.sitecatalystIDs named:@"sitecatalystIDs" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceStatusesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.statuses named:@"statuses" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceVisitedMicroSitesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.visitedMicroSites named:@"visitedMicroSites" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if ([self.cloudsearch needsUpdate])
        return YES;

    if ([self.identifierInformation needsUpdate])
        return YES;

    if ([self.janrain needsUpdate])
        return YES;

    if ([self.lastUsedDevice needsUpdate])
        return YES;

    if ([self.marketingOptIn needsUpdate])
        return YES;

    if ([self.migration needsUpdate])
        return YES;

    if ([self.optIn needsUpdate])
        return YES;

    if ([self.primaryAddress needsUpdate])
        return YES;

    return NO;
}

- (BOOL)isEqualToCaptureUser:(JRCaptureUser *)otherCaptureUser
{
    if (!self.CPF && !otherCaptureUser.CPF) /* Keep going... */;
    else if ((self.CPF == nil) ^ (otherCaptureUser.CPF == nil)) return NO; // xor
    else if (![self.CPF isEqualToString:otherCaptureUser.CPF]) return NO;

    if (!self.NRIC && !otherCaptureUser.NRIC) /* Keep going... */;
    else if ((self.NRIC == nil) ^ (otherCaptureUser.NRIC == nil)) return NO; // xor
    else if (![self.NRIC isEqualToString:otherCaptureUser.NRIC]) return NO;

    if (!self.aboutMe && !otherCaptureUser.aboutMe) /* Keep going... */;
    else if ((self.aboutMe == nil) ^ (otherCaptureUser.aboutMe == nil)) return NO; // xor
    else if (![self.aboutMe isEqualToString:otherCaptureUser.aboutMe]) return NO;

    if (!self.avmTCAgreed && !otherCaptureUser.avmTCAgreed) /* Keep going... */;
    else if ((self.avmTCAgreed == nil) ^ (otherCaptureUser.avmTCAgreed == nil)) return NO; // xor
    else if (![self.avmTCAgreed isEqualToNumber:otherCaptureUser.avmTCAgreed]) return NO;

    if (!self.avmTermsAgreedDate && !otherCaptureUser.avmTermsAgreedDate) /* Keep going... */;
    else if ((self.avmTermsAgreedDate == nil) ^ (otherCaptureUser.avmTermsAgreedDate == nil)) return NO; // xor
    else if (![self.avmTermsAgreedDate isEqualToDate:otherCaptureUser.avmTermsAgreedDate]) return NO;

    if (!self.badgeVillePlayerIDs && !otherCaptureUser.badgeVillePlayerIDs) /* Keep going... */;
    else if (!self.badgeVillePlayerIDs && ![otherCaptureUser.badgeVillePlayerIDs count]) /* Keep going... */;
    else if (!otherCaptureUser.badgeVillePlayerIDs && ![self.badgeVillePlayerIDs count]) /* Keep going... */;
    else if (![self.badgeVillePlayerIDs isEqualToBadgeVillePlayerIDsArray:otherCaptureUser.badgeVillePlayerIDs]) return NO;

    if (!self.batchId && !otherCaptureUser.batchId) /* Keep going... */;
    else if ((self.batchId == nil) ^ (otherCaptureUser.batchId == nil)) return NO; // xor
    else if (![self.batchId isEqualToString:otherCaptureUser.batchId]) return NO;

    if (!self.birthday && !otherCaptureUser.birthday) /* Keep going... */;
    else if ((self.birthday == nil) ^ (otherCaptureUser.birthday == nil)) return NO; // xor
    else if (![self.birthday isEqualToDate:otherCaptureUser.birthday]) return NO;

    if (!self.campaignID && !otherCaptureUser.campaignID) /* Keep going... */;
    else if ((self.campaignID == nil) ^ (otherCaptureUser.campaignID == nil)) return NO; // xor
    else if (![self.campaignID isEqualToString:otherCaptureUser.campaignID]) return NO;

    if (!self.campaigns && !otherCaptureUser.campaigns) /* Keep going... */;
    else if (!self.campaigns && ![otherCaptureUser.campaigns count]) /* Keep going... */;
    else if (!otherCaptureUser.campaigns && ![self.campaigns count]) /* Keep going... */;
    else if (![self.campaigns isEqualToCampaignsArray:otherCaptureUser.campaigns]) return NO;

    if (!self.catalogLocaleItem && !otherCaptureUser.catalogLocaleItem) /* Keep going... */;
    else if ((self.catalogLocaleItem == nil) ^ (otherCaptureUser.catalogLocaleItem == nil)) return NO; // xor
    else if (![self.catalogLocaleItem isEqualToString:otherCaptureUser.catalogLocaleItem]) return NO;

    if (!self.children && !otherCaptureUser.children) /* Keep going... */;
    else if (!self.children && ![otherCaptureUser.children count]) /* Keep going... */;
    else if (!otherCaptureUser.children && ![self.children count]) /* Keep going... */;
    else if (![self.children isEqualToChildrenArray:otherCaptureUser.children]) return NO;

    if (!self.clients && !otherCaptureUser.clients) /* Keep going... */;
    else if (!self.clients && ![otherCaptureUser.clients count]) /* Keep going... */;
    else if (!otherCaptureUser.clients && ![self.clients count]) /* Keep going... */;
    else if (![self.clients isEqualToClientsArray:otherCaptureUser.clients]) return NO;

    if (!self.cloudsearch && !otherCaptureUser.cloudsearch) /* Keep going... */;
    else if (!self.cloudsearch && [otherCaptureUser.cloudsearch isEqualToCloudsearch:[JRCloudsearch cloudsearch]]) /* Keep going... */;
    else if (!otherCaptureUser.cloudsearch && [self.cloudsearch isEqualToCloudsearch:[JRCloudsearch cloudsearch]]) /* Keep going... */;
    else if (![self.cloudsearch isEqualToCloudsearch:otherCaptureUser.cloudsearch]) return NO;

    if (!self.consentVerified && !otherCaptureUser.consentVerified) /* Keep going... */;
    else if ((self.consentVerified == nil) ^ (otherCaptureUser.consentVerified == nil)) return NO; // xor
    else if (![self.consentVerified isEqualToNumber:otherCaptureUser.consentVerified]) return NO;

    if (!self.consentVerifiedAt && !otherCaptureUser.consentVerifiedAt) /* Keep going... */;
    else if ((self.consentVerifiedAt == nil) ^ (otherCaptureUser.consentVerifiedAt == nil)) return NO; // xor
    else if (![self.consentVerifiedAt isEqualToDate:otherCaptureUser.consentVerifiedAt]) return NO;

    if (!self.consents && !otherCaptureUser.consents) /* Keep going... */;
    else if (!self.consents && ![otherCaptureUser.consents count]) /* Keep going... */;
    else if (!otherCaptureUser.consents && ![self.consents count]) /* Keep going... */;
    else if (![self.consents isEqualToConsentsArray:otherCaptureUser.consents]) return NO;

    if (!self.consumerInterests && !otherCaptureUser.consumerInterests) /* Keep going... */;
    else if (!self.consumerInterests && ![otherCaptureUser.consumerInterests count]) /* Keep going... */;
    else if (!otherCaptureUser.consumerInterests && ![self.consumerInterests count]) /* Keep going... */;
    else if (![self.consumerInterests isEqualToConsumerInterestsArray:otherCaptureUser.consumerInterests]) return NO;

    if (!self.consumerPoints && !otherCaptureUser.consumerPoints) /* Keep going... */;
    else if ((self.consumerPoints == nil) ^ (otherCaptureUser.consumerPoints == nil)) return NO; // xor
    else if (![self.consumerPoints isEqualToNumber:otherCaptureUser.consumerPoints]) return NO;

    if (!self.controlField && !otherCaptureUser.controlField) /* Keep going... */;
    else if ((self.controlField == nil) ^ (otherCaptureUser.controlField == nil)) return NO; // xor
    else if (![self.controlField isEqualToString:otherCaptureUser.controlField]) return NO;

    if (!self.coppaCommunicationSentAt && !otherCaptureUser.coppaCommunicationSentAt) /* Keep going... */;
    else if ((self.coppaCommunicationSentAt == nil) ^ (otherCaptureUser.coppaCommunicationSentAt == nil)) return NO; // xor
    else if (![self.coppaCommunicationSentAt isEqualToDate:otherCaptureUser.coppaCommunicationSentAt]) return NO;

    if (!self.currentLocation && !otherCaptureUser.currentLocation) /* Keep going... */;
    else if ((self.currentLocation == nil) ^ (otherCaptureUser.currentLocation == nil)) return NO; // xor
    else if (![self.currentLocation isEqualToString:otherCaptureUser.currentLocation]) return NO;

    if (!self.deactivateAccount && !otherCaptureUser.deactivateAccount) /* Keep going... */;
    else if ((self.deactivateAccount == nil) ^ (otherCaptureUser.deactivateAccount == nil)) return NO; // xor
    else if (![self.deactivateAccount isEqualToDate:otherCaptureUser.deactivateAccount]) return NO;

    if (!self.deactivatedAccount && !otherCaptureUser.deactivatedAccount) /* Keep going... */;
    else if ((self.deactivatedAccount == nil) ^ (otherCaptureUser.deactivatedAccount == nil)) return NO; // xor
    else if (![self.deactivatedAccount isEqualToDate:otherCaptureUser.deactivatedAccount]) return NO;

    if (!self.deviceIdentification && !otherCaptureUser.deviceIdentification) /* Keep going... */;
    else if (!self.deviceIdentification && ![otherCaptureUser.deviceIdentification count]) /* Keep going... */;
    else if (!otherCaptureUser.deviceIdentification && ![self.deviceIdentification count]) /* Keep going... */;
    else if (![self.deviceIdentification isEqualToDeviceIdentificationArray:otherCaptureUser.deviceIdentification]) return NO;

    if (!self.display && !otherCaptureUser.display) /* Keep going... */;
    else if ((self.display == nil) ^ (otherCaptureUser.display == nil)) return NO; // xor
    else if (![self.display isEqual:otherCaptureUser.display]) return NO;

    if (!self.displayName && !otherCaptureUser.displayName) /* Keep going... */;
    else if ((self.displayName == nil) ^ (otherCaptureUser.displayName == nil)) return NO; // xor
    else if (![self.displayName isEqualToString:otherCaptureUser.displayName]) return NO;

    if (!self.email && !otherCaptureUser.email) /* Keep going... */;
    else if ((self.email == nil) ^ (otherCaptureUser.email == nil)) return NO; // xor
    else if (![self.email isEqualToString:otherCaptureUser.email]) return NO;

    if (!self.emailVerified && !otherCaptureUser.emailVerified) /* Keep going... */;
    else if ((self.emailVerified == nil) ^ (otherCaptureUser.emailVerified == nil)) return NO; // xor
    else if (![self.emailVerified isEqualToDate:otherCaptureUser.emailVerified]) return NO;

    if (!self.externalId && !otherCaptureUser.externalId) /* Keep going... */;
    else if ((self.externalId == nil) ^ (otherCaptureUser.externalId == nil)) return NO; // xor
    else if (![self.externalId isEqualToString:otherCaptureUser.externalId]) return NO;

    if (!self.familyId && !otherCaptureUser.familyId) /* Keep going... */;
    else if ((self.familyId == nil) ^ (otherCaptureUser.familyId == nil)) return NO; // xor
    else if (![self.familyId isEqualToString:otherCaptureUser.familyId]) return NO;

    if (!self.familyName && !otherCaptureUser.familyName) /* Keep going... */;
    else if ((self.familyName == nil) ^ (otherCaptureUser.familyName == nil)) return NO; // xor
    else if (![self.familyName isEqualToString:otherCaptureUser.familyName]) return NO;

    if (!self.familyRole && !otherCaptureUser.familyRole) /* Keep going... */;
    else if ((self.familyRole == nil) ^ (otherCaptureUser.familyRole == nil)) return NO; // xor
    else if (![self.familyRole isEqualToString:otherCaptureUser.familyRole]) return NO;

    if (!self.firstNamePronunciation && !otherCaptureUser.firstNamePronunciation) /* Keep going... */;
    else if ((self.firstNamePronunciation == nil) ^ (otherCaptureUser.firstNamePronunciation == nil)) return NO; // xor
    else if (![self.firstNamePronunciation isEqualToString:otherCaptureUser.firstNamePronunciation]) return NO;

    if (!self.friends && !otherCaptureUser.friends) /* Keep going... */;
    else if (!self.friends && ![otherCaptureUser.friends count]) /* Keep going... */;
    else if (!otherCaptureUser.friends && ![self.friends count]) /* Keep going... */;
    else if (![self.friends isEqualToFriendsArray:otherCaptureUser.friends]) return NO;

    if (!self.gender && !otherCaptureUser.gender) /* Keep going... */;
    else if ((self.gender == nil) ^ (otherCaptureUser.gender == nil)) return NO; // xor
    else if (![self.gender isEqualToString:otherCaptureUser.gender]) return NO;

    if (!self.givenName && !otherCaptureUser.givenName) /* Keep going... */;
    else if ((self.givenName == nil) ^ (otherCaptureUser.givenName == nil)) return NO; // xor
    else if (![self.givenName isEqualToString:otherCaptureUser.givenName]) return NO;

    if (!self.identifierInformation && !otherCaptureUser.identifierInformation) /* Keep going... */;
    else if (!self.identifierInformation && [otherCaptureUser.identifierInformation isEqualToIdentifierInformation:[JRIdentifierInformation identifierInformation]]) /* Keep going... */;
    else if (!otherCaptureUser.identifierInformation && [self.identifierInformation isEqualToIdentifierInformation:[JRIdentifierInformation identifierInformation]]) /* Keep going... */;
    else if (![self.identifierInformation isEqualToIdentifierInformation:otherCaptureUser.identifierInformation]) return NO;

    if (!self.interestAvent && !otherCaptureUser.interestAvent) /* Keep going... */;
    else if ((self.interestAvent == nil) ^ (otherCaptureUser.interestAvent == nil)) return NO; // xor
    else if (![self.interestAvent isEqualToNumber:otherCaptureUser.interestAvent]) return NO;

    if (!self.interestCampaigns && !otherCaptureUser.interestCampaigns) /* Keep going... */;
    else if ((self.interestCampaigns == nil) ^ (otherCaptureUser.interestCampaigns == nil)) return NO; // xor
    else if (![self.interestCampaigns isEqualToNumber:otherCaptureUser.interestCampaigns]) return NO;

    if (!self.interestCategories && !otherCaptureUser.interestCategories) /* Keep going... */;
    else if ((self.interestCategories == nil) ^ (otherCaptureUser.interestCategories == nil)) return NO; // xor
    else if (![self.interestCategories isEqualToString:otherCaptureUser.interestCategories]) return NO;

    if (!self.interestCommunications && !otherCaptureUser.interestCommunications) /* Keep going... */;
    else if ((self.interestCommunications == nil) ^ (otherCaptureUser.interestCommunications == nil)) return NO; // xor
    else if (![self.interestCommunications isEqualToNumber:otherCaptureUser.interestCommunications]) return NO;

    if (!self.interestPromotions && !otherCaptureUser.interestPromotions) /* Keep going... */;
    else if ((self.interestPromotions == nil) ^ (otherCaptureUser.interestPromotions == nil)) return NO; // xor
    else if (![self.interestPromotions isEqualToNumber:otherCaptureUser.interestPromotions]) return NO;

    if (!self.interestStreamiumSurveys && !otherCaptureUser.interestStreamiumSurveys) /* Keep going... */;
    else if ((self.interestStreamiumSurveys == nil) ^ (otherCaptureUser.interestStreamiumSurveys == nil)) return NO; // xor
    else if (![self.interestStreamiumSurveys isEqualToNumber:otherCaptureUser.interestStreamiumSurveys]) return NO;

    if (!self.interestStreamiumUpgrades && !otherCaptureUser.interestStreamiumUpgrades) /* Keep going... */;
    else if ((self.interestStreamiumUpgrades == nil) ^ (otherCaptureUser.interestStreamiumUpgrades == nil)) return NO; // xor
    else if (![self.interestStreamiumUpgrades isEqualToNumber:otherCaptureUser.interestStreamiumUpgrades]) return NO;

    if (!self.interestSurveys && !otherCaptureUser.interestSurveys) /* Keep going... */;
    else if ((self.interestSurveys == nil) ^ (otherCaptureUser.interestSurveys == nil)) return NO; // xor
    else if (![self.interestSurveys isEqualToNumber:otherCaptureUser.interestSurveys]) return NO;

    if (!self.interestWULsounds && !otherCaptureUser.interestWULsounds) /* Keep going... */;
    else if ((self.interestWULsounds == nil) ^ (otherCaptureUser.interestWULsounds == nil)) return NO; // xor
    else if (![self.interestWULsounds isEqualToNumber:otherCaptureUser.interestWULsounds]) return NO;

    if (!self.janrain && !otherCaptureUser.janrain) /* Keep going... */;
    else if (!self.janrain && [otherCaptureUser.janrain isEqualToJanrain:[JRJanrain janrain]]) /* Keep going... */;
    else if (!otherCaptureUser.janrain && [self.janrain isEqualToJanrain:[JRJanrain janrain]]) /* Keep going... */;
    else if (![self.janrain isEqualToJanrain:otherCaptureUser.janrain]) return NO;

    if (!self.lastLogin && !otherCaptureUser.lastLogin) /* Keep going... */;
    else if ((self.lastLogin == nil) ^ (otherCaptureUser.lastLogin == nil)) return NO; // xor
    else if (![self.lastLogin isEqualToDate:otherCaptureUser.lastLogin]) return NO;

    if (!self.lastLoginMethod && !otherCaptureUser.lastLoginMethod) /* Keep going... */;
    else if ((self.lastLoginMethod == nil) ^ (otherCaptureUser.lastLoginMethod == nil)) return NO; // xor
    else if (![self.lastLoginMethod isEqualToString:otherCaptureUser.lastLoginMethod]) return NO;

    if (!self.lastModifiedDate && !otherCaptureUser.lastModifiedDate) /* Keep going... */;
    else if ((self.lastModifiedDate == nil) ^ (otherCaptureUser.lastModifiedDate == nil)) return NO; // xor
    else if (![self.lastModifiedDate isEqualToDate:otherCaptureUser.lastModifiedDate]) return NO;

    if (!self.lastModifiedSource && !otherCaptureUser.lastModifiedSource) /* Keep going... */;
    else if ((self.lastModifiedSource == nil) ^ (otherCaptureUser.lastModifiedSource == nil)) return NO; // xor
    else if (![self.lastModifiedSource isEqualToString:otherCaptureUser.lastModifiedSource]) return NO;

    if (!self.lastNamePronunciation && !otherCaptureUser.lastNamePronunciation) /* Keep going... */;
    else if ((self.lastNamePronunciation == nil) ^ (otherCaptureUser.lastNamePronunciation == nil)) return NO; // xor
    else if (![self.lastNamePronunciation isEqualToString:otherCaptureUser.lastNamePronunciation]) return NO;

    if (!self.lastUsedDevice && !otherCaptureUser.lastUsedDevice) /* Keep going... */;
    else if (!self.lastUsedDevice && [otherCaptureUser.lastUsedDevice isEqualToLastUsedDevice:[JRLastUsedDevice lastUsedDevice]]) /* Keep going... */;
    else if (!otherCaptureUser.lastUsedDevice && [self.lastUsedDevice isEqualToLastUsedDevice:[JRLastUsedDevice lastUsedDevice]]) /* Keep going... */;
    else if (![self.lastUsedDevice isEqualToLastUsedDevice:otherCaptureUser.lastUsedDevice]) return NO;

    if (!self.legacyID && !otherCaptureUser.legacyID) /* Keep going... */;
    else if ((self.legacyID == nil) ^ (otherCaptureUser.legacyID == nil)) return NO; // xor
    else if (![self.legacyID isEqualToNumber:otherCaptureUser.legacyID]) return NO;

    if (!self.maritalStatus && !otherCaptureUser.maritalStatus) /* Keep going... */;
    else if ((self.maritalStatus == nil) ^ (otherCaptureUser.maritalStatus == nil)) return NO; // xor
    else if (![self.maritalStatus isEqualToString:otherCaptureUser.maritalStatus]) return NO;

    if (!self.marketingOptIn && !otherCaptureUser.marketingOptIn) /* Keep going... */;
    else if (!self.marketingOptIn && [otherCaptureUser.marketingOptIn isEqualToMarketingOptIn:[JRMarketingOptIn marketingOptIn]]) /* Keep going... */;
    else if (!otherCaptureUser.marketingOptIn && [self.marketingOptIn isEqualToMarketingOptIn:[JRMarketingOptIn marketingOptIn]]) /* Keep going... */;
    else if (![self.marketingOptIn isEqualToMarketingOptIn:otherCaptureUser.marketingOptIn]) return NO;

    if (!self.medicalProfessionalRoleSpecified && !otherCaptureUser.medicalProfessionalRoleSpecified) /* Keep going... */;
    else if ((self.medicalProfessionalRoleSpecified == nil) ^ (otherCaptureUser.medicalProfessionalRoleSpecified == nil)) return NO; // xor
    else if (![self.medicalProfessionalRoleSpecified isEqualToString:otherCaptureUser.medicalProfessionalRoleSpecified]) return NO;

    if (!self.middleName && !otherCaptureUser.middleName) /* Keep going... */;
    else if ((self.middleName == nil) ^ (otherCaptureUser.middleName == nil)) return NO; // xor
    else if (![self.middleName isEqualToString:otherCaptureUser.middleName]) return NO;

    if (!self.migration && !otherCaptureUser.migration) /* Keep going... */;
    else if (!self.migration && [otherCaptureUser.migration isEqualToMigration:[JRMigration migration]]) /* Keep going... */;
    else if (!otherCaptureUser.migration && [self.migration isEqualToMigration:[JRMigration migration]]) /* Keep going... */;
    else if (![self.migration isEqualToMigration:otherCaptureUser.migration]) return NO;

    if (!self.mobileNumber && !otherCaptureUser.mobileNumber) /* Keep going... */;
    else if ((self.mobileNumber == nil) ^ (otherCaptureUser.mobileNumber == nil)) return NO; // xor
    else if (![self.mobileNumber isEqualToString:otherCaptureUser.mobileNumber]) return NO;

    if (!self.mobileNumberNeedVerification && !otherCaptureUser.mobileNumberNeedVerification) /* Keep going... */;
    else if ((self.mobileNumberNeedVerification == nil) ^ (otherCaptureUser.mobileNumberNeedVerification == nil)) return NO; // xor
    else if (![self.mobileNumberNeedVerification isEqualToNumber:otherCaptureUser.mobileNumberNeedVerification]) return NO;

    if (!self.mobileNumberSmsRequestedAt && !otherCaptureUser.mobileNumberSmsRequestedAt) /* Keep going... */;
    else if ((self.mobileNumberSmsRequestedAt == nil) ^ (otherCaptureUser.mobileNumberSmsRequestedAt == nil)) return NO; // xor
    else if (![self.mobileNumberSmsRequestedAt isEqualToDate:otherCaptureUser.mobileNumberSmsRequestedAt]) return NO;

    if (!self.mobileNumberVerified && !otherCaptureUser.mobileNumberVerified) /* Keep going... */;
    else if ((self.mobileNumberVerified == nil) ^ (otherCaptureUser.mobileNumberVerified == nil)) return NO; // xor
    else if (![self.mobileNumberVerified isEqualToDate:otherCaptureUser.mobileNumberVerified]) return NO;

    if (!self.nettvTCAgreed && !otherCaptureUser.nettvTCAgreed) /* Keep going... */;
    else if ((self.nettvTCAgreed == nil) ^ (otherCaptureUser.nettvTCAgreed == nil)) return NO; // xor
    else if (![self.nettvTCAgreed isEqualToNumber:otherCaptureUser.nettvTCAgreed]) return NO;

    if (!self.nettvTermsAgreedDate && !otherCaptureUser.nettvTermsAgreedDate) /* Keep going... */;
    else if ((self.nettvTermsAgreedDate == nil) ^ (otherCaptureUser.nettvTermsAgreedDate == nil)) return NO; // xor
    else if (![self.nettvTermsAgreedDate isEqualToDate:otherCaptureUser.nettvTermsAgreedDate]) return NO;

    if (!self.nickName && !otherCaptureUser.nickName) /* Keep going... */;
    else if ((self.nickName == nil) ^ (otherCaptureUser.nickName == nil)) return NO; // xor
    else if (![self.nickName isEqualToString:otherCaptureUser.nickName]) return NO;

    if (!self.olderThanAgeLimit && !otherCaptureUser.olderThanAgeLimit) /* Keep going... */;
    else if ((self.olderThanAgeLimit == nil) ^ (otherCaptureUser.olderThanAgeLimit == nil)) return NO; // xor
    else if (![self.olderThanAgeLimit isEqualToNumber:otherCaptureUser.olderThanAgeLimit]) return NO;

    if (!self.optIn && !otherCaptureUser.optIn) /* Keep going... */;
    else if (!self.optIn && [otherCaptureUser.optIn isEqualToOptIn:[JROptIn optIn]]) /* Keep going... */;
    else if (!otherCaptureUser.optIn && [self.optIn isEqualToOptIn:[JROptIn optIn]]) /* Keep going... */;
    else if (![self.optIn isEqualToOptIn:otherCaptureUser.optIn]) return NO;

    if (!self.password && !otherCaptureUser.password) /* Keep going... */;
    else if ((self.password == nil) ^ (otherCaptureUser.password == nil)) return NO; // xor
    else if (![self.password isEqual:otherCaptureUser.password]) return NO;

    if (!self.personalDataMarketingProfiling && !otherCaptureUser.personalDataMarketingProfiling) /* Keep going... */;
    else if ((self.personalDataMarketingProfiling == nil) ^ (otherCaptureUser.personalDataMarketingProfiling == nil)) return NO; // xor
    else if (![self.personalDataMarketingProfiling isEqualToDate:otherCaptureUser.personalDataMarketingProfiling]) return NO;

    if (!self.personalDataTransferAcceptance && !otherCaptureUser.personalDataTransferAcceptance) /* Keep going... */;
    else if ((self.personalDataTransferAcceptance == nil) ^ (otherCaptureUser.personalDataTransferAcceptance == nil)) return NO; // xor
    else if (![self.personalDataTransferAcceptance isEqualToDate:otherCaptureUser.personalDataTransferAcceptance]) return NO;

    if (!self.personalDataUsageAcceptance && !otherCaptureUser.personalDataUsageAcceptance) /* Keep going... */;
    else if ((self.personalDataUsageAcceptance == nil) ^ (otherCaptureUser.personalDataUsageAcceptance == nil)) return NO; // xor
    else if (![self.personalDataUsageAcceptance isEqualToDate:otherCaptureUser.personalDataUsageAcceptance]) return NO;

    if (!self.photos && !otherCaptureUser.photos) /* Keep going... */;
    else if (!self.photos && ![otherCaptureUser.photos count]) /* Keep going... */;
    else if (!otherCaptureUser.photos && ![self.photos count]) /* Keep going... */;
    else if (![self.photos isEqualToPhotosArray:otherCaptureUser.photos]) return NO;

    if (!self.post_login_confirmation && !otherCaptureUser.post_login_confirmation) /* Keep going... */;
    else if (!self.post_login_confirmation && ![otherCaptureUser.post_login_confirmation count]) /* Keep going... */;
    else if (!otherCaptureUser.post_login_confirmation && ![self.post_login_confirmation count]) /* Keep going... */;
    else if (![self.post_login_confirmation isEqualToPost_login_confirmationArray:otherCaptureUser.post_login_confirmation]) return NO;

    if (!self.preferredLanguage && !otherCaptureUser.preferredLanguage) /* Keep going... */;
    else if ((self.preferredLanguage == nil) ^ (otherCaptureUser.preferredLanguage == nil)) return NO; // xor
    else if (![self.preferredLanguage isEqualToString:otherCaptureUser.preferredLanguage]) return NO;

    if (!self.primaryAddress && !otherCaptureUser.primaryAddress) /* Keep going... */;
    else if (!self.primaryAddress && [otherCaptureUser.primaryAddress isEqualToPrimaryAddress:[JRPrimaryAddress primaryAddress]]) /* Keep going... */;
    else if (!otherCaptureUser.primaryAddress && [self.primaryAddress isEqualToPrimaryAddress:[JRPrimaryAddress primaryAddress]]) /* Keep going... */;
    else if (![self.primaryAddress isEqualToPrimaryAddress:otherCaptureUser.primaryAddress]) return NO;

    if (!self.profiles && !otherCaptureUser.profiles) /* Keep going... */;
    else if (!self.profiles && ![otherCaptureUser.profiles count]) /* Keep going... */;
    else if (!otherCaptureUser.profiles && ![self.profiles count]) /* Keep going... */;
    else if (![self.profiles isEqualToProfilesArray:otherCaptureUser.profiles]) return NO;

    if (!self.providerMergedLast && !otherCaptureUser.providerMergedLast) /* Keep going... */;
    else if ((self.providerMergedLast == nil) ^ (otherCaptureUser.providerMergedLast == nil)) return NO; // xor
    else if (![self.providerMergedLast isEqualToString:otherCaptureUser.providerMergedLast]) return NO;

    if (!self.receiveMarketingEmail && !otherCaptureUser.receiveMarketingEmail) /* Keep going... */;
    else if ((self.receiveMarketingEmail == nil) ^ (otherCaptureUser.receiveMarketingEmail == nil)) return NO; // xor
    else if (![self.receiveMarketingEmail isEqualToNumber:otherCaptureUser.receiveMarketingEmail]) return NO;

    if (!self.requiresVerification && !otherCaptureUser.requiresVerification) /* Keep going... */;
    else if ((self.requiresVerification == nil) ^ (otherCaptureUser.requiresVerification == nil)) return NO; // xor
    else if (![self.requiresVerification isEqualToNumber:otherCaptureUser.requiresVerification]) return NO;

    if (!self.retentionConsentGivenAt && !otherCaptureUser.retentionConsentGivenAt) /* Keep going... */;
    else if ((self.retentionConsentGivenAt == nil) ^ (otherCaptureUser.retentionConsentGivenAt == nil)) return NO; // xor
    else if (![self.retentionConsentGivenAt isEqualToDate:otherCaptureUser.retentionConsentGivenAt]) return NO;

    if (!self.roles && !otherCaptureUser.roles) /* Keep going... */;
    else if (!self.roles && ![otherCaptureUser.roles count]) /* Keep going... */;
    else if (!otherCaptureUser.roles && ![self.roles count]) /* Keep going... */;
    else if (![self.roles isEqualToRolesArray:otherCaptureUser.roles]) return NO;

    if (!self.salutation && !otherCaptureUser.salutation) /* Keep going... */;
    else if ((self.salutation == nil) ^ (otherCaptureUser.salutation == nil)) return NO; // xor
    else if (![self.salutation isEqualToString:otherCaptureUser.salutation]) return NO;

    if (!self.sitecatalystIDs && !otherCaptureUser.sitecatalystIDs) /* Keep going... */;
    else if (!self.sitecatalystIDs && ![otherCaptureUser.sitecatalystIDs count]) /* Keep going... */;
    else if (!otherCaptureUser.sitecatalystIDs && ![self.sitecatalystIDs count]) /* Keep going... */;
    else if (![self.sitecatalystIDs isEqualToSitecatalystIDsArray:otherCaptureUser.sitecatalystIDs]) return NO;

    if (!self.ssn && !otherCaptureUser.ssn) /* Keep going... */;
    else if ((self.ssn == nil) ^ (otherCaptureUser.ssn == nil)) return NO; // xor
    else if (![self.ssn isEqualToString:otherCaptureUser.ssn]) return NO;

    if (!self.statuses && !otherCaptureUser.statuses) /* Keep going... */;
    else if (!self.statuses && ![otherCaptureUser.statuses count]) /* Keep going... */;
    else if (!otherCaptureUser.statuses && ![self.statuses count]) /* Keep going... */;
    else if (![self.statuses isEqualToStatusesArray:otherCaptureUser.statuses]) return NO;

    if (!self.streamiumServicesTCAgreed && !otherCaptureUser.streamiumServicesTCAgreed) /* Keep going... */;
    else if ((self.streamiumServicesTCAgreed == nil) ^ (otherCaptureUser.streamiumServicesTCAgreed == nil)) return NO; // xor
    else if (![self.streamiumServicesTCAgreed isEqualToNumber:otherCaptureUser.streamiumServicesTCAgreed]) return NO;

    if (!self.termsAndConditionsAcceptance && !otherCaptureUser.termsAndConditionsAcceptance) /* Keep going... */;
    else if ((self.termsAndConditionsAcceptance == nil) ^ (otherCaptureUser.termsAndConditionsAcceptance == nil)) return NO; // xor
    else if (![self.termsAndConditionsAcceptance isEqualToDate:otherCaptureUser.termsAndConditionsAcceptance]) return NO;

    if (!self.visitedMicroSites && !otherCaptureUser.visitedMicroSites) /* Keep going... */;
    else if (!self.visitedMicroSites && ![otherCaptureUser.visitedMicroSites count]) /* Keep going... */;
    else if (!otherCaptureUser.visitedMicroSites && ![self.visitedMicroSites count]) /* Keep going... */;
    else if (![self.visitedMicroSites isEqualToVisitedMicroSitesArray:otherCaptureUser.visitedMicroSites]) return NO;

    if (!self.weddingDate && !otherCaptureUser.weddingDate) /* Keep going... */;
    else if ((self.weddingDate == nil) ^ (otherCaptureUser.weddingDate == nil)) return NO; // xor
    else if (![self.weddingDate isEqualToDate:otherCaptureUser.weddingDate]) return NO;

    if (!self.wishList && !otherCaptureUser.wishList) /* Keep going... */;
    else if ((self.wishList == nil) ^ (otherCaptureUser.wishList == nil)) return NO; // xor
    else if (![self.wishList isEqualToString:otherCaptureUser.wishList]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"CPF"];
    [dictionary setObject:@"NSString" forKey:@"NRIC"];
    [dictionary setObject:@"NSString" forKey:@"aboutMe"];
    [dictionary setObject:@"JRBoolean" forKey:@"avmTCAgreed"];
    [dictionary setObject:@"JRDateTime" forKey:@"avmTermsAgreedDate"];
    [dictionary setObject:@"NSArray" forKey:@"badgeVillePlayerIDs"];
    [dictionary setObject:@"NSString" forKey:@"batchId"];
    [dictionary setObject:@"JRDate" forKey:@"birthday"];
    [dictionary setObject:@"NSString" forKey:@"campaignID"];
    [dictionary setObject:@"NSArray" forKey:@"campaigns"];
    [dictionary setObject:@"NSString" forKey:@"catalogLocaleItem"];
    [dictionary setObject:@"NSArray" forKey:@"children"];
    [dictionary setObject:@"NSArray" forKey:@"clients"];
    [dictionary setObject:@"JRCloudsearch" forKey:@"cloudsearch"];
    [dictionary setObject:@"JRBoolean" forKey:@"consentVerified"];
    [dictionary setObject:@"JRDateTime" forKey:@"consentVerifiedAt"];
    [dictionary setObject:@"NSArray" forKey:@"consents"];
    [dictionary setObject:@"NSArray" forKey:@"consumerInterests"];
    [dictionary setObject:@"JRInteger" forKey:@"consumerPoints"];
    [dictionary setObject:@"NSString" forKey:@"controlField"];
    [dictionary setObject:@"JRDateTime" forKey:@"coppaCommunicationSentAt"];
    [dictionary setObject:@"NSString" forKey:@"currentLocation"];
    [dictionary setObject:@"JRDateTime" forKey:@"deactivateAccount"];
    [dictionary setObject:@"JRDateTime" forKey:@"deactivatedAccount"];
    [dictionary setObject:@"NSArray" forKey:@"deviceIdentification"];
    [dictionary setObject:@"JRJsonObject" forKey:@"display"];
    [dictionary setObject:@"NSString" forKey:@"displayName"];
    [dictionary setObject:@"NSString" forKey:@"email"];
    [dictionary setObject:@"JRDateTime" forKey:@"emailVerified"];
    [dictionary setObject:@"NSString" forKey:@"externalId"];
    [dictionary setObject:@"NSString" forKey:@"familyId"];
    [dictionary setObject:@"NSString" forKey:@"familyName"];
    [dictionary setObject:@"NSString" forKey:@"familyRole"];
    [dictionary setObject:@"NSString" forKey:@"firstNamePronunciation"];
    [dictionary setObject:@"NSArray" forKey:@"friends"];
    [dictionary setObject:@"NSString" forKey:@"gender"];
    [dictionary setObject:@"NSString" forKey:@"givenName"];
    [dictionary setObject:@"JRIdentifierInformation" forKey:@"identifierInformation"];
    [dictionary setObject:@"JRBoolean" forKey:@"interestAvent"];
    [dictionary setObject:@"JRBoolean" forKey:@"interestCampaigns"];
    [dictionary setObject:@"NSString" forKey:@"interestCategories"];
    [dictionary setObject:@"JRBoolean" forKey:@"interestCommunications"];
    [dictionary setObject:@"JRBoolean" forKey:@"interestPromotions"];
    [dictionary setObject:@"JRBoolean" forKey:@"interestStreamiumSurveys"];
    [dictionary setObject:@"JRBoolean" forKey:@"interestStreamiumUpgrades"];
    [dictionary setObject:@"JRBoolean" forKey:@"interestSurveys"];
    [dictionary setObject:@"JRBoolean" forKey:@"interestWULsounds"];
    [dictionary setObject:@"JRJanrain" forKey:@"janrain"];
    [dictionary setObject:@"JRDateTime" forKey:@"lastLogin"];
    [dictionary setObject:@"NSString" forKey:@"lastLoginMethod"];
    [dictionary setObject:@"JRDateTime" forKey:@"lastModifiedDate"];
    [dictionary setObject:@"NSString" forKey:@"lastModifiedSource"];
    [dictionary setObject:@"NSString" forKey:@"lastNamePronunciation"];
    [dictionary setObject:@"JRLastUsedDevice" forKey:@"lastUsedDevice"];
    [dictionary setObject:@"JRInteger" forKey:@"legacyID"];
    [dictionary setObject:@"NSString" forKey:@"maritalStatus"];
    [dictionary setObject:@"JRMarketingOptIn" forKey:@"marketingOptIn"];
    [dictionary setObject:@"NSString" forKey:@"medicalProfessionalRoleSpecified"];
    [dictionary setObject:@"NSString" forKey:@"middleName"];
    [dictionary setObject:@"JRMigration" forKey:@"migration"];
    [dictionary setObject:@"NSString" forKey:@"mobileNumber"];
    [dictionary setObject:@"JRBoolean" forKey:@"mobileNumberNeedVerification"];
    [dictionary setObject:@"JRDateTime" forKey:@"mobileNumberSmsRequestedAt"];
    [dictionary setObject:@"JRDateTime" forKey:@"mobileNumberVerified"];
    [dictionary setObject:@"JRBoolean" forKey:@"nettvTCAgreed"];
    [dictionary setObject:@"JRDateTime" forKey:@"nettvTermsAgreedDate"];
    [dictionary setObject:@"NSString" forKey:@"nickName"];
    [dictionary setObject:@"JRBoolean" forKey:@"olderThanAgeLimit"];
    [dictionary setObject:@"JROptIn" forKey:@"optIn"];
    [dictionary setObject:@"JRPassword" forKey:@"password"];
    [dictionary setObject:@"JRDateTime" forKey:@"personalDataMarketingProfiling"];
    [dictionary setObject:@"JRDateTime" forKey:@"personalDataTransferAcceptance"];
    [dictionary setObject:@"JRDateTime" forKey:@"personalDataUsageAcceptance"];
    [dictionary setObject:@"NSArray" forKey:@"photos"];
    [dictionary setObject:@"NSArray" forKey:@"post_login_confirmation"];
    [dictionary setObject:@"NSString" forKey:@"preferredLanguage"];
    [dictionary setObject:@"JRPrimaryAddress" forKey:@"primaryAddress"];
    [dictionary setObject:@"NSArray" forKey:@"profiles"];
    [dictionary setObject:@"NSString" forKey:@"providerMergedLast"];
    [dictionary setObject:@"JRBoolean" forKey:@"receiveMarketingEmail"];
    [dictionary setObject:@"JRBoolean" forKey:@"requiresVerification"];
    [dictionary setObject:@"JRDateTime" forKey:@"retentionConsentGivenAt"];
    [dictionary setObject:@"NSArray" forKey:@"roles"];
    [dictionary setObject:@"NSString" forKey:@"salutation"];
    [dictionary setObject:@"NSArray" forKey:@"sitecatalystIDs"];
    [dictionary setObject:@"NSString" forKey:@"ssn"];
    [dictionary setObject:@"NSArray" forKey:@"statuses"];
    [dictionary setObject:@"JRBoolean" forKey:@"streamiumServicesTCAgreed"];
    [dictionary setObject:@"JRDateTime" forKey:@"termsAndConditionsAcceptance"];
    [dictionary setObject:@"NSArray" forKey:@"visitedMicroSites"];
    [dictionary setObject:@"JRDateTime" forKey:@"weddingDate"];
    [dictionary setObject:@"NSString" forKey:@"wishList"];
    [dictionary setObject:@"JRObjectId" forKey:@"captureUserId"];
    [dictionary setObject:@"JRUuid" forKey:@"uuid"];
    [dictionary setObject:@"JRDateTime" forKey:@"lastUpdated"];
    [dictionary setObject:@"JRDateTime" forKey:@"created"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
