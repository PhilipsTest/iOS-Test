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
#import "JRCampaignsElement.h"
#import "debug_log.h"

@interface JRCampaignsElement ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRCampaignsElement
{
    NSString *_campaignId;
    JRBoolean *_consent;
    NSString *_contentType;
    JRDateTime *_createdAt;
    JRDateTime *_lastUpdatedAt;
    NSString *_locale;
    JRInteger *_order;
    JRJsonObject *_payload;
    NSString *_status;
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

- (JRBoolean *)consent
{
    return _consent;
}

- (void)setConsent:(JRBoolean *)newConsent
{
    [self.dirtyPropertySet addObject:@"consent"];

    _consent = [newConsent copy];
}

- (BOOL)getConsentBoolValue
{
    return [_consent boolValue];
}

- (void)setConsentWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"consent"];

    _consent = [NSNumber numberWithBool:boolVal];
}

- (NSString *)contentType
{
    return _contentType;
}

- (void)setContentType:(NSString *)newContentType
{
    [self.dirtyPropertySet addObject:@"contentType"];

    _contentType = [newContentType copy];
}

- (JRDateTime *)createdAt
{
    return _createdAt;
}

- (void)setCreatedAt:(JRDateTime *)newCreatedAt
{
    [self.dirtyPropertySet addObject:@"createdAt"];

    _createdAt = [newCreatedAt copy];
}

- (JRDateTime *)lastUpdatedAt
{
    return _lastUpdatedAt;
}

- (void)setLastUpdatedAt:(JRDateTime *)newLastUpdatedAt
{
    [self.dirtyPropertySet addObject:@"lastUpdatedAt"];

    _lastUpdatedAt = [newLastUpdatedAt copy];
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

- (JRInteger *)order
{
    return _order;
}

- (void)setOrder:(JRInteger *)newOrder
{
    [self.dirtyPropertySet addObject:@"order"];

    _order = [newOrder copy];
}

- (NSInteger)getOrderIntegerValue
{
    return [_order integerValue];
}

- (void)setOrderWithInteger:(NSInteger)integerVal
{
    [self.dirtyPropertySet addObject:@"order"];

    _order = [NSNumber numberWithInteger:integerVal];
}

- (JRJsonObject *)payload
{
    return _payload;
}

- (void)setPayload:(JRJsonObject *)newPayload
{
    [self.dirtyPropertySet addObject:@"payload"];

    _payload = [newPayload copy];
}

- (NSString *)status
{
    return _status;
}

- (void)setStatus:(NSString *)newStatus
{
    [self.dirtyPropertySet addObject:@"status"];

    _status = [newStatus copy];
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

- (id)initWithCampaignId:(NSString *)newCampaignId andConsent:(JRBoolean *)newConsent andContentType:(NSString *)newContentType andCreatedAt:(JRDateTime *)newCreatedAt andLastUpdatedAt:(JRDateTime *)newLastUpdatedAt andLocale:(NSString *)newLocale andOrder:(JRInteger *)newOrder andStatus:(NSString *)newStatus
{
    if (!newCampaignId || !newConsent || !newContentType || !newCreatedAt || !newLastUpdatedAt || !newLocale || !newOrder || !newStatus)
    {
        return nil;
     }

    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOnCapture  = NO;

        _campaignId = [newCampaignId copy];
        _consent = [newConsent copy];
        _contentType = [newContentType copy];
        _createdAt = [newCreatedAt copy];
        _lastUpdatedAt = [newLastUpdatedAt copy];
        _locale = [newLocale copy];
        _order = [newOrder copy];
        _status = [newStatus copy];

        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)campaignsElement
{
    return [[JRCampaignsElement alloc] init];
}

+ (id)campaignsElementWithCampaignId:(NSString *)campaignId andConsent:(JRBoolean *)consent andContentType:(NSString *)contentType andCreatedAt:(JRDateTime *)createdAt andLastUpdatedAt:(JRDateTime *)lastUpdatedAt andLocale:(NSString *)locale andOrder:(JRInteger *)order andStatus:(NSString *)status
{
    return [[JRCampaignsElement alloc] initWithCampaignId:campaignId andConsent:consent andContentType:contentType andCreatedAt:createdAt andLastUpdatedAt:lastUpdatedAt andLocale:locale andOrder:order andStatus:status];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.campaignId ? self.campaignId : [NSNull null])
                   forKey:@"campaignId"];
    [dictionary setObject:(self.consent ? [NSNumber numberWithBool:[self.consent boolValue]] : [NSNull null])
                   forKey:@"consent"];
    [dictionary setObject:(self.contentType ? self.contentType : [NSNull null])
                   forKey:@"contentType"];
    [dictionary setObject:(self.createdAt ? [self.createdAt stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"createdAt"];
    [dictionary setObject:(self.lastUpdatedAt ? [self.lastUpdatedAt stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"lastUpdatedAt"];
    [dictionary setObject:(self.locale ? self.locale : [NSNull null])
                   forKey:@"locale"];
    [dictionary setObject:(self.order ? [NSNumber numberWithInteger:[self.order integerValue]] : [NSNull null])
                   forKey:@"order"];
    [dictionary setObject:(self.payload ? self.payload : [NSNull null])
                   forKey:@"payload"];
    [dictionary setObject:(self.status ? self.status : [NSNull null])
                   forKey:@"status"];

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

+ (id)campaignsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRCampaignsElement *campaignsElement = [JRCampaignsElement campaignsElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        campaignsElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        campaignsElement.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        campaignsElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"campaigns", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        campaignsElement.canBeUpdatedOnCapture = YES;
    }

    campaignsElement.campaignId =
        [dictionary objectForKey:@"campaignId"] != [NSNull null] ? 
        [dictionary objectForKey:@"campaignId"] : nil;

    campaignsElement.consent =
        [dictionary objectForKey:@"consent"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"consent"] boolValue]] : nil;

    campaignsElement.contentType =
        [dictionary objectForKey:@"contentType"] != [NSNull null] ? 
        [dictionary objectForKey:@"contentType"] : nil;

    campaignsElement.createdAt =
        [dictionary objectForKey:@"createdAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"createdAt"]] : nil;

    campaignsElement.lastUpdatedAt =
        [dictionary objectForKey:@"lastUpdatedAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdatedAt"]] : nil;

    campaignsElement.locale =
        [dictionary objectForKey:@"locale"] != [NSNull null] ? 
        [dictionary objectForKey:@"locale"] : nil;

    campaignsElement.order =
        [dictionary objectForKey:@"order"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"order"] integerValue]] : nil;

    campaignsElement.payload =
        [dictionary objectForKey:@"payload"] != [NSNull null] ? 
        [dictionary objectForKey:@"payload"] : nil;

    campaignsElement.status =
        [dictionary objectForKey:@"status"] != [NSNull null] ? 
        [dictionary objectForKey:@"status"] : nil;

    if (fromDecoder)
        [campaignsElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [campaignsElement.dirtyPropertySet removeAllObjects];

    return campaignsElement;
}

+ (id)campaignsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRCampaignsElement campaignsElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"campaigns", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.campaignId =
        [dictionary objectForKey:@"campaignId"] != [NSNull null] ? 
        [dictionary objectForKey:@"campaignId"] : nil;

    self.consent =
        [dictionary objectForKey:@"consent"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"consent"] boolValue]] : nil;

    self.contentType =
        [dictionary objectForKey:@"contentType"] != [NSNull null] ? 
        [dictionary objectForKey:@"contentType"] : nil;

    self.createdAt =
        [dictionary objectForKey:@"createdAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"createdAt"]] : nil;

    self.lastUpdatedAt =
        [dictionary objectForKey:@"lastUpdatedAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdatedAt"]] : nil;

    self.locale =
        [dictionary objectForKey:@"locale"] != [NSNull null] ? 
        [dictionary objectForKey:@"locale"] : nil;

    self.order =
        [dictionary objectForKey:@"order"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"order"] integerValue]] : nil;

    self.payload =
        [dictionary objectForKey:@"payload"] != [NSNull null] ? 
        [dictionary objectForKey:@"payload"] : nil;

    self.status =
        [dictionary objectForKey:@"status"] != [NSNull null] ? 
        [dictionary objectForKey:@"status"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"campaignId", @"consent", @"contentType", @"createdAt", @"lastUpdatedAt", @"locale", @"order", @"payload", @"status", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"campaignsElement"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"campaignsElement"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"campaignsElement"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"campaignId"])
        [dictionary setObject:(self.campaignId ? self.campaignId : [NSNull null]) forKey:@"campaignId"];

    if ([self.dirtyPropertySet containsObject:@"consent"])
        [dictionary setObject:(self.consent ? [NSNumber numberWithBool:[self.consent boolValue]] : [NSNull null]) forKey:@"consent"];

    if ([self.dirtyPropertySet containsObject:@"contentType"])
        [dictionary setObject:(self.contentType ? self.contentType : [NSNull null]) forKey:@"contentType"];

    if ([self.dirtyPropertySet containsObject:@"createdAt"])
        [dictionary setObject:(self.createdAt ? [self.createdAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"createdAt"];

    if ([self.dirtyPropertySet containsObject:@"lastUpdatedAt"])
        [dictionary setObject:(self.lastUpdatedAt ? [self.lastUpdatedAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"lastUpdatedAt"];

    if ([self.dirtyPropertySet containsObject:@"locale"])
        [dictionary setObject:(self.locale ? self.locale : [NSNull null]) forKey:@"locale"];

    if ([self.dirtyPropertySet containsObject:@"order"])
        [dictionary setObject:(self.order ? [NSNumber numberWithInteger:[self.order integerValue]] : [NSNull null]) forKey:@"order"];

    if ([self.dirtyPropertySet containsObject:@"payload"])
        [dictionary setObject:(self.payload ? self.payload : [NSNull null]) forKey:@"payload"];

    if ([self.dirtyPropertySet containsObject:@"status"])
        [dictionary setObject:(self.status ? self.status : [NSNull null]) forKey:@"status"];

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
    [dictionary setObject:(self.consent ? [NSNumber numberWithBool:[self.consent boolValue]] : [NSNull null]) forKey:@"consent"];
    [dictionary setObject:(self.contentType ? self.contentType : [NSNull null]) forKey:@"contentType"];
    [dictionary setObject:(self.createdAt ? [self.createdAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"createdAt"];
    [dictionary setObject:(self.lastUpdatedAt ? [self.lastUpdatedAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"lastUpdatedAt"];
    [dictionary setObject:(self.locale ? self.locale : [NSNull null]) forKey:@"locale"];
    [dictionary setObject:(self.order ? [NSNumber numberWithInteger:[self.order integerValue]] : [NSNull null]) forKey:@"order"];
    [dictionary setObject:(self.payload ? self.payload : [NSNull null]) forKey:@"payload"];
    [dictionary setObject:(self.status ? self.status : [NSNull null]) forKey:@"status"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToCampaignsElement:(JRCampaignsElement *)otherCampaignsElement
{
    if (!self.campaignId && !otherCampaignsElement.campaignId) /* Keep going... */;
    else if ((self.campaignId == nil) ^ (otherCampaignsElement.campaignId == nil)) return NO; // xor
    else if (![self.campaignId isEqualToString:otherCampaignsElement.campaignId]) return NO;

    if (!self.consent && !otherCampaignsElement.consent) /* Keep going... */;
    else if ((self.consent == nil) ^ (otherCampaignsElement.consent == nil)) return NO; // xor
    else if (![self.consent isEqualToNumber:otherCampaignsElement.consent]) return NO;

    if (!self.contentType && !otherCampaignsElement.contentType) /* Keep going... */;
    else if ((self.contentType == nil) ^ (otherCampaignsElement.contentType == nil)) return NO; // xor
    else if (![self.contentType isEqualToString:otherCampaignsElement.contentType]) return NO;

    if (!self.createdAt && !otherCampaignsElement.createdAt) /* Keep going... */;
    else if ((self.createdAt == nil) ^ (otherCampaignsElement.createdAt == nil)) return NO; // xor
    else if (![self.createdAt isEqualToDate:otherCampaignsElement.createdAt]) return NO;

    if (!self.lastUpdatedAt && !otherCampaignsElement.lastUpdatedAt) /* Keep going... */;
    else if ((self.lastUpdatedAt == nil) ^ (otherCampaignsElement.lastUpdatedAt == nil)) return NO; // xor
    else if (![self.lastUpdatedAt isEqualToDate:otherCampaignsElement.lastUpdatedAt]) return NO;

    if (!self.locale && !otherCampaignsElement.locale) /* Keep going... */;
    else if ((self.locale == nil) ^ (otherCampaignsElement.locale == nil)) return NO; // xor
    else if (![self.locale isEqualToString:otherCampaignsElement.locale]) return NO;

    if (!self.order && !otherCampaignsElement.order) /* Keep going... */;
    else if ((self.order == nil) ^ (otherCampaignsElement.order == nil)) return NO; // xor
    else if (![self.order isEqualToNumber:otherCampaignsElement.order]) return NO;

    if (!self.payload && !otherCampaignsElement.payload) /* Keep going... */;
    else if ((self.payload == nil) ^ (otherCampaignsElement.payload == nil)) return NO; // xor
    else if (![self.payload isEqual:otherCampaignsElement.payload]) return NO;

    if (!self.status && !otherCampaignsElement.status) /* Keep going... */;
    else if ((self.status == nil) ^ (otherCampaignsElement.status == nil)) return NO; // xor
    else if (![self.status isEqualToString:otherCampaignsElement.status]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"campaignId"];
    [dictionary setObject:@"JRBoolean" forKey:@"consent"];
    [dictionary setObject:@"NSString" forKey:@"contentType"];
    [dictionary setObject:@"JRDateTime" forKey:@"createdAt"];
    [dictionary setObject:@"JRDateTime" forKey:@"lastUpdatedAt"];
    [dictionary setObject:@"NSString" forKey:@"locale"];
    [dictionary setObject:@"JRInteger" forKey:@"order"];
    [dictionary setObject:@"JRJsonObject" forKey:@"payload"];
    [dictionary setObject:@"NSString" forKey:@"status"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
