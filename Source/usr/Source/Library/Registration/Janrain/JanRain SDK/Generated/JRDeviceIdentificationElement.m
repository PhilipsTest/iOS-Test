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
#import "JRDeviceIdentificationElement.h"
#import "debug_log.h"

@interface JRDeviceIdentificationElement ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRDeviceIdentificationElement
{
    NSString *_deviceToken;
    JRDateTime *_lastUsedAt;
    NSString *_tokenType;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)deviceToken
{
    return _deviceToken;
}

- (void)setDeviceToken:(NSString *)newDeviceToken
{
    [self.dirtyPropertySet addObject:@"deviceToken"];

    _deviceToken = [newDeviceToken copy];
}

- (JRDateTime *)lastUsedAt
{
    return _lastUsedAt;
}

- (void)setLastUsedAt:(JRDateTime *)newLastUsedAt
{
    [self.dirtyPropertySet addObject:@"lastUsedAt"];

    _lastUsedAt = [newLastUsedAt copy];
}

- (NSString *)tokenType
{
    return _tokenType;
}

- (void)setTokenType:(NSString *)newTokenType
{
    [self.dirtyPropertySet addObject:@"tokenType"];

    _tokenType = [newTokenType copy];
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

- (id)initWithDeviceToken:(NSString *)newDeviceToken
{
    if (!newDeviceToken)
    {
        return nil;
     }

    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOnCapture  = NO;

        _deviceToken = [newDeviceToken copy];

        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)deviceIdentificationElement
{
    return [[JRDeviceIdentificationElement alloc] init];
}

+ (id)deviceIdentificationElementWithDeviceToken:(NSString *)deviceToken
{
    return [[JRDeviceIdentificationElement alloc] initWithDeviceToken:deviceToken];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.deviceToken ? self.deviceToken : [NSNull null])
                   forKey:@"deviceToken"];
    [dictionary setObject:(self.lastUsedAt ? [self.lastUsedAt stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"lastUsedAt"];
    [dictionary setObject:(self.tokenType ? self.tokenType : [NSNull null])
                   forKey:@"tokenType"];

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

+ (id)deviceIdentificationElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRDeviceIdentificationElement *deviceIdentificationElement = [JRDeviceIdentificationElement deviceIdentificationElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        deviceIdentificationElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        deviceIdentificationElement.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        deviceIdentificationElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"deviceIdentification", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        deviceIdentificationElement.canBeUpdatedOnCapture = YES;
    }

    deviceIdentificationElement.deviceToken =
        [dictionary objectForKey:@"deviceToken"] != [NSNull null] ? 
        [dictionary objectForKey:@"deviceToken"] : nil;

    deviceIdentificationElement.lastUsedAt =
        [dictionary objectForKey:@"lastUsedAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUsedAt"]] : nil;

    deviceIdentificationElement.tokenType =
        [dictionary objectForKey:@"tokenType"] != [NSNull null] ? 
        [dictionary objectForKey:@"tokenType"] : nil;

    if (fromDecoder)
        [deviceIdentificationElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [deviceIdentificationElement.dirtyPropertySet removeAllObjects];

    return deviceIdentificationElement;
}

+ (id)deviceIdentificationElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRDeviceIdentificationElement deviceIdentificationElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"deviceIdentification", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.deviceToken =
        [dictionary objectForKey:@"deviceToken"] != [NSNull null] ? 
        [dictionary objectForKey:@"deviceToken"] : nil;

    self.lastUsedAt =
        [dictionary objectForKey:@"lastUsedAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUsedAt"]] : nil;

    self.tokenType =
        [dictionary objectForKey:@"tokenType"] != [NSNull null] ? 
        [dictionary objectForKey:@"tokenType"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"deviceToken", @"lastUsedAt", @"tokenType", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"deviceIdentificationElement"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"deviceIdentificationElement"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"deviceIdentificationElement"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"deviceToken"])
        [dictionary setObject:(self.deviceToken ? self.deviceToken : [NSNull null]) forKey:@"deviceToken"];

    if ([self.dirtyPropertySet containsObject:@"lastUsedAt"])
        [dictionary setObject:(self.lastUsedAt ? [self.lastUsedAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"lastUsedAt"];

    if ([self.dirtyPropertySet containsObject:@"tokenType"])
        [dictionary setObject:(self.tokenType ? self.tokenType : [NSNull null]) forKey:@"tokenType"];

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

    [dictionary setObject:(self.deviceToken ? self.deviceToken : [NSNull null]) forKey:@"deviceToken"];
    [dictionary setObject:(self.lastUsedAt ? [self.lastUsedAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"lastUsedAt"];
    [dictionary setObject:(self.tokenType ? self.tokenType : [NSNull null]) forKey:@"tokenType"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToDeviceIdentificationElement:(JRDeviceIdentificationElement *)otherDeviceIdentificationElement
{
    if (!self.deviceToken && !otherDeviceIdentificationElement.deviceToken) /* Keep going... */;
    else if ((self.deviceToken == nil) ^ (otherDeviceIdentificationElement.deviceToken == nil)) return NO; // xor
    else if (![self.deviceToken isEqualToString:otherDeviceIdentificationElement.deviceToken]) return NO;

    if (!self.lastUsedAt && !otherDeviceIdentificationElement.lastUsedAt) /* Keep going... */;
    else if ((self.lastUsedAt == nil) ^ (otherDeviceIdentificationElement.lastUsedAt == nil)) return NO; // xor
    else if (![self.lastUsedAt isEqualToDate:otherDeviceIdentificationElement.lastUsedAt]) return NO;

    if (!self.tokenType && !otherDeviceIdentificationElement.tokenType) /* Keep going... */;
    else if ((self.tokenType == nil) ^ (otherDeviceIdentificationElement.tokenType == nil)) return NO; // xor
    else if (![self.tokenType isEqualToString:otherDeviceIdentificationElement.tokenType]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"deviceToken"];
    [dictionary setObject:@"JRDateTime" forKey:@"lastUsedAt"];
    [dictionary setObject:@"NSString" forKey:@"tokenType"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
