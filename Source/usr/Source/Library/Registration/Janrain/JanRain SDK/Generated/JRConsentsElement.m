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
#import "JRConsentsElement.h"
#import "debug_log.h"

@interface JRConsentsElement ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRConsentsElement
{
    NSString *_campaignId;
    JRDateTime *_communicationSentAt;
    JRDateTime *_confirmationCommunicationSentAt;
    JRDateTime *_confirmationCommunicationToSendAt;
    JRBoolean *_confirmationGiven;
    JRDateTime *_confirmationStoredAt;
    JRBoolean *_given;
    NSString *_locale;
    NSString *_microSiteID;
    JRDateTime *_storedAt;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)campaignId
{
    return _campaignId;
}

- (void)setCampaignId:(NSString *)newCampaignId
{
    [self.dirtyPropertySet addObject:@"campaignId"];

    _campaignId = [newCampaignId copy];
}

- (JRDateTime *)communicationSentAt
{
    return _communicationSentAt;
}

- (void)setCommunicationSentAt:(JRDateTime *)newCommunicationSentAt
{
    [self.dirtyPropertySet addObject:@"communicationSentAt"];

    _communicationSentAt = [newCommunicationSentAt copy];
}

- (JRDateTime *)confirmationCommunicationSentAt
{
    return _confirmationCommunicationSentAt;
}

- (void)setConfirmationCommunicationSentAt:(JRDateTime *)newConfirmationCommunicationSentAt
{
    [self.dirtyPropertySet addObject:@"confirmationCommunicationSentAt"];

    _confirmationCommunicationSentAt = [newConfirmationCommunicationSentAt copy];
}

- (JRDateTime *)confirmationCommunicationToSendAt
{
    return _confirmationCommunicationToSendAt;
}

- (void)setConfirmationCommunicationToSendAt:(JRDateTime *)newConfirmationCommunicationToSendAt
{
    [self.dirtyPropertySet addObject:@"confirmationCommunicationToSendAt"];

    _confirmationCommunicationToSendAt = [newConfirmationCommunicationToSendAt copy];
}

- (JRBoolean *)confirmationGiven
{
    return _confirmationGiven;
}

- (void)setConfirmationGiven:(JRBoolean *)newConfirmationGiven
{
    [self.dirtyPropertySet addObject:@"confirmationGiven"];

    _confirmationGiven = [newConfirmationGiven copy];
}

- (BOOL)getConfirmationGivenBoolValue
{
    return [_confirmationGiven boolValue];
}

- (void)setConfirmationGivenWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"confirmationGiven"];

    _confirmationGiven = [NSNumber numberWithBool:boolVal];
}

- (JRDateTime *)confirmationStoredAt
{
    return _confirmationStoredAt;
}

- (void)setConfirmationStoredAt:(JRDateTime *)newConfirmationStoredAt
{
    [self.dirtyPropertySet addObject:@"confirmationStoredAt"];

    _confirmationStoredAt = [newConfirmationStoredAt copy];
}

- (JRBoolean *)given
{
    return _given;
}

- (void)setGiven:(JRBoolean *)newGiven
{
    [self.dirtyPropertySet addObject:@"given"];

    _given = [newGiven copy];
}

- (BOOL)getGivenBoolValue
{
    return [_given boolValue];
}

- (void)setGivenWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"given"];

    _given = [NSNumber numberWithBool:boolVal];
}

- (NSString *)locale
{
    return _locale;
}

- (void)setLocale:(NSString *)newLocale
{
    [self.dirtyPropertySet addObject:@"locale"];

    _locale = [newLocale copy];
}

- (NSString *)microSiteID
{
    return _microSiteID;
}

- (void)setMicroSiteID:(NSString *)newMicroSiteID
{
    [self.dirtyPropertySet addObject:@"microSiteID"];

    _microSiteID = [newMicroSiteID copy];
}

- (JRDateTime *)storedAt
{
    return _storedAt;
}

- (void)setStoredAt:(JRDateTime *)newStoredAt
{
    [self.dirtyPropertySet addObject:@"storedAt"];

    _storedAt = [newStoredAt copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOnCapture  = NO;


        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

- (id)initWithCampaignId:(NSString *)newCampaignId
{
    if (!newCampaignId)
    {
        return nil;
     }

    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOnCapture  = NO;

        _campaignId = [newCampaignId copy];

        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)consentsElement
{
    return [[JRConsentsElement alloc] init];
}

+ (id)consentsElementWithCampaignId:(NSString *)campaignId
{
    return [[JRConsentsElement alloc] initWithCampaignId:campaignId];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.campaignId ? self.campaignId : [NSNull null])
                   forKey:@"campaignId"];
    [dictionary setObject:(self.communicationSentAt ? [self.communicationSentAt stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"communicationSentAt"];
    [dictionary setObject:(self.confirmationCommunicationSentAt ? [self.confirmationCommunicationSentAt stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"confirmationCommunicationSentAt"];
    [dictionary setObject:(self.confirmationCommunicationToSendAt ? [self.confirmationCommunicationToSendAt stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"confirmationCommunicationToSendAt"];
    [dictionary setObject:(self.confirmationGiven ? [NSNumber numberWithBool:[self.confirmationGiven boolValue]] : [NSNull null])
                   forKey:@"confirmationGiven"];
    [dictionary setObject:(self.confirmationStoredAt ? [self.confirmationStoredAt stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"confirmationStoredAt"];
    [dictionary setObject:(self.given ? [NSNumber numberWithBool:[self.given boolValue]] : [NSNull null])
                   forKey:@"given"];
    [dictionary setObject:(self.locale ? self.locale : [NSNull null])
                   forKey:@"locale"];
    [dictionary setObject:(self.microSiteID ? self.microSiteID : [NSNull null])
                   forKey:@"microSiteID"];
    [dictionary setObject:(self.storedAt ? [self.storedAt stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"storedAt"];

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

+ (id)consentsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRConsentsElement *consentsElement = [JRConsentsElement consentsElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        consentsElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        consentsElement.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        consentsElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"consents", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        consentsElement.canBeUpdatedOnCapture = YES;
    }

    consentsElement.campaignId =
        [dictionary objectForKey:@"campaignId"] != [NSNull null] ? 
        [dictionary objectForKey:@"campaignId"] : nil;

    consentsElement.communicationSentAt =
        [dictionary objectForKey:@"communicationSentAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"communicationSentAt"]] : nil;

    consentsElement.confirmationCommunicationSentAt =
        [dictionary objectForKey:@"confirmationCommunicationSentAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"confirmationCommunicationSentAt"]] : nil;

    consentsElement.confirmationCommunicationToSendAt =
        [dictionary objectForKey:@"confirmationCommunicationToSendAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"confirmationCommunicationToSendAt"]] : nil;

    consentsElement.confirmationGiven =
        [dictionary objectForKey:@"confirmationGiven"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"confirmationGiven"] boolValue]] : nil;

    consentsElement.confirmationStoredAt =
        [dictionary objectForKey:@"confirmationStoredAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"confirmationStoredAt"]] : nil;

    consentsElement.given =
        [dictionary objectForKey:@"given"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"given"] boolValue]] : nil;

    consentsElement.locale =
        [dictionary objectForKey:@"locale"] != [NSNull null] ? 
        [dictionary objectForKey:@"locale"] : nil;

    consentsElement.microSiteID =
        [dictionary objectForKey:@"microSiteID"] != [NSNull null] ? 
        [dictionary objectForKey:@"microSiteID"] : nil;

    consentsElement.storedAt =
        [dictionary objectForKey:@"storedAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"storedAt"]] : nil;

    if (fromDecoder)
        [consentsElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [consentsElement.dirtyPropertySet removeAllObjects];

    return consentsElement;
}

+ (id)consentsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRConsentsElement consentsElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"consents", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.campaignId =
        [dictionary objectForKey:@"campaignId"] != [NSNull null] ? 
        [dictionary objectForKey:@"campaignId"] : nil;

    self.communicationSentAt =
        [dictionary objectForKey:@"communicationSentAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"communicationSentAt"]] : nil;

    self.confirmationCommunicationSentAt =
        [dictionary objectForKey:@"confirmationCommunicationSentAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"confirmationCommunicationSentAt"]] : nil;

    self.confirmationCommunicationToSendAt =
        [dictionary objectForKey:@"confirmationCommunicationToSendAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"confirmationCommunicationToSendAt"]] : nil;

    self.confirmationGiven =
        [dictionary objectForKey:@"confirmationGiven"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"confirmationGiven"] boolValue]] : nil;

    self.confirmationStoredAt =
        [dictionary objectForKey:@"confirmationStoredAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"confirmationStoredAt"]] : nil;

    self.given =
        [dictionary objectForKey:@"given"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"given"] boolValue]] : nil;

    self.locale =
        [dictionary objectForKey:@"locale"] != [NSNull null] ? 
        [dictionary objectForKey:@"locale"] : nil;

    self.microSiteID =
        [dictionary objectForKey:@"microSiteID"] != [NSNull null] ? 
        [dictionary objectForKey:@"microSiteID"] : nil;

    self.storedAt =
        [dictionary objectForKey:@"storedAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"storedAt"]] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"campaignId", @"communicationSentAt", @"confirmationCommunicationSentAt", @"confirmationCommunicationToSendAt", @"confirmationGiven", @"confirmationStoredAt", @"given", @"locale", @"microSiteID", @"storedAt", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"consentsElement"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"consentsElement"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"consentsElement"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"campaignId"])
        [dictionary setObject:(self.campaignId ? self.campaignId : [NSNull null]) forKey:@"campaignId"];

    if ([self.dirtyPropertySet containsObject:@"communicationSentAt"])
        [dictionary setObject:(self.communicationSentAt ? [self.communicationSentAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"communicationSentAt"];

    if ([self.dirtyPropertySet containsObject:@"confirmationCommunicationSentAt"])
        [dictionary setObject:(self.confirmationCommunicationSentAt ? [self.confirmationCommunicationSentAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"confirmationCommunicationSentAt"];

    if ([self.dirtyPropertySet containsObject:@"confirmationCommunicationToSendAt"])
        [dictionary setObject:(self.confirmationCommunicationToSendAt ? [self.confirmationCommunicationToSendAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"confirmationCommunicationToSendAt"];

    if ([self.dirtyPropertySet containsObject:@"confirmationGiven"])
        [dictionary setObject:(self.confirmationGiven ? [NSNumber numberWithBool:[self.confirmationGiven boolValue]] : [NSNull null]) forKey:@"confirmationGiven"];

    if ([self.dirtyPropertySet containsObject:@"confirmationStoredAt"])
        [dictionary setObject:(self.confirmationStoredAt ? [self.confirmationStoredAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"confirmationStoredAt"];

    if ([self.dirtyPropertySet containsObject:@"given"])
        [dictionary setObject:(self.given ? [NSNumber numberWithBool:[self.given boolValue]] : [NSNull null]) forKey:@"given"];

    if ([self.dirtyPropertySet containsObject:@"locale"])
        [dictionary setObject:(self.locale ? self.locale : [NSNull null]) forKey:@"locale"];

    if ([self.dirtyPropertySet containsObject:@"microSiteID"])
        [dictionary setObject:(self.microSiteID ? self.microSiteID : [NSNull null]) forKey:@"microSiteID"];

    if ([self.dirtyPropertySet containsObject:@"storedAt"])
        [dictionary setObject:(self.storedAt ? [self.storedAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"storedAt"];

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

    [dictionary setObject:(self.campaignId ? self.campaignId : [NSNull null]) forKey:@"campaignId"];
    [dictionary setObject:(self.communicationSentAt ? [self.communicationSentAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"communicationSentAt"];
    [dictionary setObject:(self.confirmationCommunicationSentAt ? [self.confirmationCommunicationSentAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"confirmationCommunicationSentAt"];
    [dictionary setObject:(self.confirmationCommunicationToSendAt ? [self.confirmationCommunicationToSendAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"confirmationCommunicationToSendAt"];
    [dictionary setObject:(self.confirmationGiven ? [NSNumber numberWithBool:[self.confirmationGiven boolValue]] : [NSNull null]) forKey:@"confirmationGiven"];
    [dictionary setObject:(self.confirmationStoredAt ? [self.confirmationStoredAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"confirmationStoredAt"];
    [dictionary setObject:(self.given ? [NSNumber numberWithBool:[self.given boolValue]] : [NSNull null]) forKey:@"given"];
    [dictionary setObject:(self.locale ? self.locale : [NSNull null]) forKey:@"locale"];
    [dictionary setObject:(self.microSiteID ? self.microSiteID : [NSNull null]) forKey:@"microSiteID"];
    [dictionary setObject:(self.storedAt ? [self.storedAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"storedAt"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToConsentsElement:(JRConsentsElement *)otherConsentsElement
{
    if (!self.campaignId && !otherConsentsElement.campaignId) /* Keep going... */;
    else if ((self.campaignId == nil) ^ (otherConsentsElement.campaignId == nil)) return NO; // xor
    else if (![self.campaignId isEqualToString:otherConsentsElement.campaignId]) return NO;

    if (!self.communicationSentAt && !otherConsentsElement.communicationSentAt) /* Keep going... */;
    else if ((self.communicationSentAt == nil) ^ (otherConsentsElement.communicationSentAt == nil)) return NO; // xor
    else if (![self.communicationSentAt isEqualToDate:otherConsentsElement.communicationSentAt]) return NO;

    if (!self.confirmationCommunicationSentAt && !otherConsentsElement.confirmationCommunicationSentAt) /* Keep going... */;
    else if ((self.confirmationCommunicationSentAt == nil) ^ (otherConsentsElement.confirmationCommunicationSentAt == nil)) return NO; // xor
    else if (![self.confirmationCommunicationSentAt isEqualToDate:otherConsentsElement.confirmationCommunicationSentAt]) return NO;

    if (!self.confirmationCommunicationToSendAt && !otherConsentsElement.confirmationCommunicationToSendAt) /* Keep going... */;
    else if ((self.confirmationCommunicationToSendAt == nil) ^ (otherConsentsElement.confirmationCommunicationToSendAt == nil)) return NO; // xor
    else if (![self.confirmationCommunicationToSendAt isEqualToDate:otherConsentsElement.confirmationCommunicationToSendAt]) return NO;

    if (!self.confirmationGiven && !otherConsentsElement.confirmationGiven) /* Keep going... */;
    else if ((self.confirmationGiven == nil) ^ (otherConsentsElement.confirmationGiven == nil)) return NO; // xor
    else if (![self.confirmationGiven isEqualToNumber:otherConsentsElement.confirmationGiven]) return NO;

    if (!self.confirmationStoredAt && !otherConsentsElement.confirmationStoredAt) /* Keep going... */;
    else if ((self.confirmationStoredAt == nil) ^ (otherConsentsElement.confirmationStoredAt == nil)) return NO; // xor
    else if (![self.confirmationStoredAt isEqualToDate:otherConsentsElement.confirmationStoredAt]) return NO;

    if (!self.given && !otherConsentsElement.given) /* Keep going... */;
    else if ((self.given == nil) ^ (otherConsentsElement.given == nil)) return NO; // xor
    else if (![self.given isEqualToNumber:otherConsentsElement.given]) return NO;

    if (!self.locale && !otherConsentsElement.locale) /* Keep going... */;
    else if ((self.locale == nil) ^ (otherConsentsElement.locale == nil)) return NO; // xor
    else if (![self.locale isEqualToString:otherConsentsElement.locale]) return NO;

    if (!self.microSiteID && !otherConsentsElement.microSiteID) /* Keep going... */;
    else if ((self.microSiteID == nil) ^ (otherConsentsElement.microSiteID == nil)) return NO; // xor
    else if (![self.microSiteID isEqualToString:otherConsentsElement.microSiteID]) return NO;

    if (!self.storedAt && !otherConsentsElement.storedAt) /* Keep going... */;
    else if ((self.storedAt == nil) ^ (otherConsentsElement.storedAt == nil)) return NO; // xor
    else if (![self.storedAt isEqualToDate:otherConsentsElement.storedAt]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"campaignId"];
    [dictionary setObject:@"JRDateTime" forKey:@"communicationSentAt"];
    [dictionary setObject:@"JRDateTime" forKey:@"confirmationCommunicationSentAt"];
    [dictionary setObject:@"JRDateTime" forKey:@"confirmationCommunicationToSendAt"];
    [dictionary setObject:@"JRBoolean" forKey:@"confirmationGiven"];
    [dictionary setObject:@"JRDateTime" forKey:@"confirmationStoredAt"];
    [dictionary setObject:@"JRBoolean" forKey:@"given"];
    [dictionary setObject:@"NSString" forKey:@"locale"];
    [dictionary setObject:@"NSString" forKey:@"microSiteID"];
    [dictionary setObject:@"JRDateTime" forKey:@"storedAt"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
