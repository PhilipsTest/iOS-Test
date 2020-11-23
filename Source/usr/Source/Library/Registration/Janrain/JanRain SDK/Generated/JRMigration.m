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
#import "JRMigration.h"
#import "debug_log.h"

@interface JRMigration ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRMigration
{
    JRDateTime *_migratedAt;
    NSString *_source;
}
@synthesize canBeUpdatedOnCapture;

- (JRDateTime *)migratedAt
{
    return _migratedAt;
}

- (void)setMigratedAt:(JRDateTime *)newMigratedAt
{
    [self.dirtyPropertySet addObject:@"migratedAt"];

    _migratedAt = [newMigratedAt copy];
}

- (NSString *)source
{
    return _source;
}

- (void)setSource:(NSString *)newSource
{
    [self.dirtyPropertySet addObject:@"source"];

    _source = [newSource copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/migration";
        self.canBeUpdatedOnCapture = YES;


        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)migration
{
    return [[JRMigration alloc] init];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.migratedAt ? [self.migratedAt stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"migratedAt"];
    [dictionary setObject:(self.source ? self.source : [NSNull null])
                   forKey:@"source"];

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

+ (id)migrationObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRMigration *migration = [JRMigration migration];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        migration.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
    }

    migration.migratedAt =
        [dictionary objectForKey:@"migratedAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"migratedAt"]] : nil;

    migration.source =
        [dictionary objectForKey:@"source"] != [NSNull null] ? 
        [dictionary objectForKey:@"source"] : nil;

    if (fromDecoder)
        [migration.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [migration.dirtyPropertySet removeAllObjects];

    return migration;
}

+ (id)migrationObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRMigration migrationObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;

    self.migratedAt =
        [dictionary objectForKey:@"migratedAt"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"migratedAt"]] : nil;

    self.source =
        [dictionary objectForKey:@"source"] != [NSNull null] ? 
        [dictionary objectForKey:@"source"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"migratedAt", @"source", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"migration"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"migration"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"migration"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"migratedAt"])
        [dictionary setObject:(self.migratedAt ? [self.migratedAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"migratedAt"];

    if ([self.dirtyPropertySet containsObject:@"source"])
        [dictionary setObject:(self.source ? self.source : [NSNull null]) forKey:@"source"];

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

    [dictionary setObject:(self.migratedAt ? [self.migratedAt stringFromISO8601DateTime] : [NSNull null]) forKey:@"migratedAt"];
    [dictionary setObject:(self.source ? self.source : [NSNull null]) forKey:@"source"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToMigration:(JRMigration *)otherMigration
{
    if (!self.migratedAt && !otherMigration.migratedAt) /* Keep going... */;
    else if ((self.migratedAt == nil) ^ (otherMigration.migratedAt == nil)) return NO; // xor
    else if (![self.migratedAt isEqualToDate:otherMigration.migratedAt]) return NO;

    if (!self.source && !otherMigration.source) /* Keep going... */;
    else if ((self.source == nil) ^ (otherMigration.source == nil)) return NO; // xor
    else if (![self.source isEqualToString:otherMigration.source]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"JRDateTime" forKey:@"migratedAt"];
    [dictionary setObject:@"NSString" forKey:@"source"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
