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
#import "JRBadgeVillePlayerIDsElement.h"
#import "debug_log.h"

@interface JRBadgeVillePlayerIDsElement ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRBadgeVillePlayerIDsElement
{
    NSString *_playerID;
    NSString *_siteID;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)playerID
{
    return _playerID;
}

- (void)setPlayerID:(NSString *)newPlayerID
{
    [self.dirtyPropertySet addObject:@"playerID"];

    _playerID = [newPlayerID copy];
}

- (NSString *)siteID
{
    return _siteID;
}

- (void)setSiteID:(NSString *)newSiteID
{
    [self.dirtyPropertySet addObject:@"siteID"];

    _siteID = [newSiteID copy];
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

- (id)initWithPlayerID:(NSString *)newPlayerID andSiteID:(NSString *)newSiteID
{
    if (!newPlayerID || !newSiteID)
    {
        return nil;
     }

    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOnCapture  = NO;

        _playerID = [newPlayerID copy];
        _siteID = [newSiteID copy];

        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)badgeVillePlayerIDsElement
{
    return [[JRBadgeVillePlayerIDsElement alloc] init];
}

+ (id)badgeVillePlayerIDsElementWithPlayerID:(NSString *)playerID andSiteID:(NSString *)siteID
{
    return [[JRBadgeVillePlayerIDsElement alloc] initWithPlayerID:playerID andSiteID:siteID];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.playerID ? self.playerID : [NSNull null])
                   forKey:@"playerID"];
    [dictionary setObject:(self.siteID ? self.siteID : [NSNull null])
                   forKey:@"siteID"];

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

+ (id)badgeVillePlayerIDsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRBadgeVillePlayerIDsElement *badgeVillePlayerIDsElement = [JRBadgeVillePlayerIDsElement badgeVillePlayerIDsElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        badgeVillePlayerIDsElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        badgeVillePlayerIDsElement.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        badgeVillePlayerIDsElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"badgeVillePlayerIDs", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        badgeVillePlayerIDsElement.canBeUpdatedOnCapture = YES;
    }

    badgeVillePlayerIDsElement.playerID =
        [dictionary objectForKey:@"playerID"] != [NSNull null] ? 
        [dictionary objectForKey:@"playerID"] : nil;

    badgeVillePlayerIDsElement.siteID =
        [dictionary objectForKey:@"siteID"] != [NSNull null] ? 
        [dictionary objectForKey:@"siteID"] : nil;

    if (fromDecoder)
        [badgeVillePlayerIDsElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [badgeVillePlayerIDsElement.dirtyPropertySet removeAllObjects];

    return badgeVillePlayerIDsElement;
}

+ (id)badgeVillePlayerIDsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRBadgeVillePlayerIDsElement badgeVillePlayerIDsElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"badgeVillePlayerIDs", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.playerID =
        [dictionary objectForKey:@"playerID"] != [NSNull null] ? 
        [dictionary objectForKey:@"playerID"] : nil;

    self.siteID =
        [dictionary objectForKey:@"siteID"] != [NSNull null] ? 
        [dictionary objectForKey:@"siteID"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"playerID", @"siteID", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"badgeVillePlayerIDsElement"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"badgeVillePlayerIDsElement"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"badgeVillePlayerIDsElement"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"playerID"])
        [dictionary setObject:(self.playerID ? self.playerID : [NSNull null]) forKey:@"playerID"];

    if ([self.dirtyPropertySet containsObject:@"siteID"])
        [dictionary setObject:(self.siteID ? self.siteID : [NSNull null]) forKey:@"siteID"];

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

    [dictionary setObject:(self.playerID ? self.playerID : [NSNull null]) forKey:@"playerID"];
    [dictionary setObject:(self.siteID ? self.siteID : [NSNull null]) forKey:@"siteID"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToBadgeVillePlayerIDsElement:(JRBadgeVillePlayerIDsElement *)otherBadgeVillePlayerIDsElement
{
    if (!self.playerID && !otherBadgeVillePlayerIDsElement.playerID) /* Keep going... */;
    else if ((self.playerID == nil) ^ (otherBadgeVillePlayerIDsElement.playerID == nil)) return NO; // xor
    else if (![self.playerID isEqualToString:otherBadgeVillePlayerIDsElement.playerID]) return NO;

    if (!self.siteID && !otherBadgeVillePlayerIDsElement.siteID) /* Keep going... */;
    else if ((self.siteID == nil) ^ (otherBadgeVillePlayerIDsElement.siteID == nil)) return NO; // xor
    else if (![self.siteID isEqualToString:otherBadgeVillePlayerIDsElement.siteID]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"playerID"];
    [dictionary setObject:@"NSString" forKey:@"siteID"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
