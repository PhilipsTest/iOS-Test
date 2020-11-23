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
#import "JRSitecatalystIDsElement.h"
#import "debug_log.h"

@interface JRSitecatalystIDsElement ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRSitecatalystIDsElement
{
    NSString *_appID;
    NSString *_propositionId;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)appID
{
    return _appID;
}

- (void)setAppID:(NSString *)newAppID
{
    [self.dirtyPropertySet addObject:@"appID"];

    _appID = [newAppID copy];
}

- (NSString *)propositionId
{
    return _propositionId;
}

- (void)setPropositionId:(NSString *)newPropositionId
{
    [self.dirtyPropertySet addObject:@"propositionId"];

    _propositionId = [newPropositionId copy];
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

+ (id)sitecatalystIDsElement
{
    return [[JRSitecatalystIDsElement alloc] init];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.appID ? self.appID : [NSNull null])
                   forKey:@"appID"];
    [dictionary setObject:(self.propositionId ? self.propositionId : [NSNull null])
                   forKey:@"propositionId"];

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

+ (id)sitecatalystIDsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRSitecatalystIDsElement *sitecatalystIDsElement = [JRSitecatalystIDsElement sitecatalystIDsElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        sitecatalystIDsElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        sitecatalystIDsElement.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        sitecatalystIDsElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"sitecatalystIDs", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        sitecatalystIDsElement.canBeUpdatedOnCapture = YES;
    }

    sitecatalystIDsElement.appID =
        [dictionary objectForKey:@"appID"] != [NSNull null] ? 
        [dictionary objectForKey:@"appID"] : nil;

    sitecatalystIDsElement.propositionId =
        [dictionary objectForKey:@"propositionId"] != [NSNull null] ? 
        [dictionary objectForKey:@"propositionId"] : nil;

    if (fromDecoder)
        [sitecatalystIDsElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [sitecatalystIDsElement.dirtyPropertySet removeAllObjects];

    return sitecatalystIDsElement;
}

+ (id)sitecatalystIDsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRSitecatalystIDsElement sitecatalystIDsElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"sitecatalystIDs", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.appID =
        [dictionary objectForKey:@"appID"] != [NSNull null] ? 
        [dictionary objectForKey:@"appID"] : nil;

    self.propositionId =
        [dictionary objectForKey:@"propositionId"] != [NSNull null] ? 
        [dictionary objectForKey:@"propositionId"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"appID", @"propositionId", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"sitecatalystIDsElement"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"sitecatalystIDsElement"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"sitecatalystIDsElement"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"appID"])
        [dictionary setObject:(self.appID ? self.appID : [NSNull null]) forKey:@"appID"];

    if ([self.dirtyPropertySet containsObject:@"propositionId"])
        [dictionary setObject:(self.propositionId ? self.propositionId : [NSNull null]) forKey:@"propositionId"];

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

    [dictionary setObject:(self.appID ? self.appID : [NSNull null]) forKey:@"appID"];
    [dictionary setObject:(self.propositionId ? self.propositionId : [NSNull null]) forKey:@"propositionId"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToSitecatalystIDsElement:(JRSitecatalystIDsElement *)otherSitecatalystIDsElement
{
    if (!self.appID && !otherSitecatalystIDsElement.appID) /* Keep going... */;
    else if ((self.appID == nil) ^ (otherSitecatalystIDsElement.appID == nil)) return NO; // xor
    else if (![self.appID isEqualToString:otherSitecatalystIDsElement.appID]) return NO;

    if (!self.propositionId && !otherSitecatalystIDsElement.propositionId) /* Keep going... */;
    else if ((self.propositionId == nil) ^ (otherSitecatalystIDsElement.propositionId == nil)) return NO; // xor
    else if (![self.propositionId isEqualToString:otherSitecatalystIDsElement.propositionId]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"appID"];
    [dictionary setObject:@"NSString" forKey:@"propositionId"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
