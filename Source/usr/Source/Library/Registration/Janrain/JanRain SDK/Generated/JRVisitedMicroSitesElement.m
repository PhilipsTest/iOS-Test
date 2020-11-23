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
#import "JRVisitedMicroSitesElement.h"
#import "debug_log.h"

@interface JRVisitedMicroSitesElement ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRVisitedMicroSitesElement
{
    NSString *_microSiteID;
    JRDateTime *_timestamp;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)microSiteID
{
    return _microSiteID;
}

- (void)setMicroSiteID:(NSString *)newMicroSiteID
{
    [self.dirtyPropertySet addObject:@"microSiteID"];

    _microSiteID = [newMicroSiteID copy];
}

- (JRDateTime *)timestamp
{
    return _timestamp;
}

- (void)setTimestamp:(JRDateTime *)newTimestamp
{
    [self.dirtyPropertySet addObject:@"timestamp"];

    _timestamp = [newTimestamp copy];
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

+ (id)visitedMicroSitesElement
{
    return [[JRVisitedMicroSitesElement alloc] init];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.microSiteID ? self.microSiteID : [NSNull null])
                   forKey:@"microSiteID"];
    [dictionary setObject:(self.timestamp ? [self.timestamp stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"timestamp"];

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

+ (id)visitedMicroSitesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRVisitedMicroSitesElement *visitedMicroSitesElement = [JRVisitedMicroSitesElement visitedMicroSitesElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        visitedMicroSitesElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        visitedMicroSitesElement.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        visitedMicroSitesElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"visitedMicroSites", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        visitedMicroSitesElement.canBeUpdatedOnCapture = YES;
    }

    visitedMicroSitesElement.microSiteID =
        [dictionary objectForKey:@"microSiteID"] != [NSNull null] ? 
        [dictionary objectForKey:@"microSiteID"] : nil;

    visitedMicroSitesElement.timestamp =
        [dictionary objectForKey:@"timestamp"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"timestamp"]] : nil;

    if (fromDecoder)
        [visitedMicroSitesElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [visitedMicroSitesElement.dirtyPropertySet removeAllObjects];

    return visitedMicroSitesElement;
}

+ (id)visitedMicroSitesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRVisitedMicroSitesElement visitedMicroSitesElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"visitedMicroSites", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.microSiteID =
        [dictionary objectForKey:@"microSiteID"] != [NSNull null] ? 
        [dictionary objectForKey:@"microSiteID"] : nil;

    self.timestamp =
        [dictionary objectForKey:@"timestamp"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"timestamp"]] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"microSiteID", @"timestamp", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"visitedMicroSitesElement"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"visitedMicroSitesElement"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"visitedMicroSitesElement"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"microSiteID"])
        [dictionary setObject:(self.microSiteID ? self.microSiteID : [NSNull null]) forKey:@"microSiteID"];

    if ([self.dirtyPropertySet containsObject:@"timestamp"])
        [dictionary setObject:(self.timestamp ? [self.timestamp stringFromISO8601DateTime] : [NSNull null]) forKey:@"timestamp"];

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

    [dictionary setObject:(self.microSiteID ? self.microSiteID : [NSNull null]) forKey:@"microSiteID"];
    [dictionary setObject:(self.timestamp ? [self.timestamp stringFromISO8601DateTime] : [NSNull null]) forKey:@"timestamp"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToVisitedMicroSitesElement:(JRVisitedMicroSitesElement *)otherVisitedMicroSitesElement
{
    if (!self.microSiteID && !otherVisitedMicroSitesElement.microSiteID) /* Keep going... */;
    else if ((self.microSiteID == nil) ^ (otherVisitedMicroSitesElement.microSiteID == nil)) return NO; // xor
    else if (![self.microSiteID isEqualToString:otherVisitedMicroSitesElement.microSiteID]) return NO;

    if (!self.timestamp && !otherVisitedMicroSitesElement.timestamp) /* Keep going... */;
    else if ((self.timestamp == nil) ^ (otherVisitedMicroSitesElement.timestamp == nil)) return NO; // xor
    else if (![self.timestamp isEqualToDate:otherVisitedMicroSitesElement.timestamp]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"microSiteID"];
    [dictionary setObject:@"JRDateTime" forKey:@"timestamp"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
