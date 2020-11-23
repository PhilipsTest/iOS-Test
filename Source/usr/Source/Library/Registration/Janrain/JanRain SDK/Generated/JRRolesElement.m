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
#import "JRRolesElement.h"
#import "debug_log.h"

@interface JRRolesElement ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRRolesElement
{
    JRDate *_expiryDate;
    NSString *_role;
    JRDateTime *_role_assigned;
    NSString *_verifier;
}
@synthesize canBeUpdatedOnCapture;

- (JRDate *)expiryDate
{
    return _expiryDate;
}

- (void)setExpiryDate:(JRDate *)newExpiryDate
{
    [self.dirtyPropertySet addObject:@"expiryDate"];

    _expiryDate = [newExpiryDate copy];
}

- (NSString *)role
{
    return _role;
}

- (void)setRole:(NSString *)newRole
{
    [self.dirtyPropertySet addObject:@"role"];

    _role = [newRole copy];
}

- (JRDateTime *)role_assigned
{
    return _role_assigned;
}

- (void)setRole_assigned:(JRDateTime *)newRole_assigned
{
    [self.dirtyPropertySet addObject:@"role_assigned"];

    _role_assigned = [newRole_assigned copy];
}

- (NSString *)verifier
{
    return _verifier;
}

- (void)setVerifier:(NSString *)newVerifier
{
    [self.dirtyPropertySet addObject:@"verifier"];

    _verifier = [newVerifier copy];
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

- (id)initWithRole:(NSString *)newRole
{
    if (!newRole)
    {
        return nil;
     }

    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOnCapture  = NO;

        _role = [newRole copy];

        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)rolesElement
{
    return [[JRRolesElement alloc] init];
}

+ (id)rolesElementWithRole:(NSString *)role
{
    return [[JRRolesElement alloc] initWithRole:role];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.expiryDate ? [self.expiryDate stringFromISO8601Date] : [NSNull null])
                   forKey:@"expiryDate"];
    [dictionary setObject:(self.role ? self.role : [NSNull null])
                   forKey:@"role"];
    [dictionary setObject:(self.role_assigned ? [self.role_assigned stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"role_assigned"];
    [dictionary setObject:(self.verifier ? self.verifier : [NSNull null])
                   forKey:@"verifier"];

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

+ (id)rolesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRRolesElement *rolesElement = [JRRolesElement rolesElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        rolesElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        rolesElement.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        rolesElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"roles", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        rolesElement.canBeUpdatedOnCapture = YES;
    }

    rolesElement.expiryDate =
        [dictionary objectForKey:@"expiryDate"] != [NSNull null] ? 
        [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"expiryDate"]] : nil;

    rolesElement.role =
        [dictionary objectForKey:@"role"] != [NSNull null] ? 
        [dictionary objectForKey:@"role"] : nil;

    rolesElement.role_assigned =
        [dictionary objectForKey:@"role_assigned"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"role_assigned"]] : nil;

    rolesElement.verifier =
        [dictionary objectForKey:@"verifier"] != [NSNull null] ? 
        [dictionary objectForKey:@"verifier"] : nil;

    if (fromDecoder)
        [rolesElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [rolesElement.dirtyPropertySet removeAllObjects];

    return rolesElement;
}

+ (id)rolesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRRolesElement rolesElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"roles", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.expiryDate =
        [dictionary objectForKey:@"expiryDate"] != [NSNull null] ? 
        [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"expiryDate"]] : nil;

    self.role =
        [dictionary objectForKey:@"role"] != [NSNull null] ? 
        [dictionary objectForKey:@"role"] : nil;

    self.role_assigned =
        [dictionary objectForKey:@"role_assigned"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"role_assigned"]] : nil;

    self.verifier =
        [dictionary objectForKey:@"verifier"] != [NSNull null] ? 
        [dictionary objectForKey:@"verifier"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"expiryDate", @"role", @"role_assigned", @"verifier", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"rolesElement"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"rolesElement"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"rolesElement"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"expiryDate"])
        [dictionary setObject:(self.expiryDate ? [self.expiryDate stringFromISO8601Date] : [NSNull null]) forKey:@"expiryDate"];

    if ([self.dirtyPropertySet containsObject:@"role"])
        [dictionary setObject:(self.role ? self.role : [NSNull null]) forKey:@"role"];

    if ([self.dirtyPropertySet containsObject:@"role_assigned"])
        [dictionary setObject:(self.role_assigned ? [self.role_assigned stringFromISO8601DateTime] : [NSNull null]) forKey:@"role_assigned"];

    if ([self.dirtyPropertySet containsObject:@"verifier"])
        [dictionary setObject:(self.verifier ? self.verifier : [NSNull null]) forKey:@"verifier"];

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

    [dictionary setObject:(self.expiryDate ? [self.expiryDate stringFromISO8601Date] : [NSNull null]) forKey:@"expiryDate"];
    [dictionary setObject:(self.role ? self.role : [NSNull null]) forKey:@"role"];
    [dictionary setObject:(self.role_assigned ? [self.role_assigned stringFromISO8601DateTime] : [NSNull null]) forKey:@"role_assigned"];
    [dictionary setObject:(self.verifier ? self.verifier : [NSNull null]) forKey:@"verifier"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToRolesElement:(JRRolesElement *)otherRolesElement
{
    if (!self.expiryDate && !otherRolesElement.expiryDate) /* Keep going... */;
    else if ((self.expiryDate == nil) ^ (otherRolesElement.expiryDate == nil)) return NO; // xor
    else if (![self.expiryDate isEqualToDate:otherRolesElement.expiryDate]) return NO;

    if (!self.role && !otherRolesElement.role) /* Keep going... */;
    else if ((self.role == nil) ^ (otherRolesElement.role == nil)) return NO; // xor
    else if (![self.role isEqualToString:otherRolesElement.role]) return NO;

    if (!self.role_assigned && !otherRolesElement.role_assigned) /* Keep going... */;
    else if ((self.role_assigned == nil) ^ (otherRolesElement.role_assigned == nil)) return NO; // xor
    else if (![self.role_assigned isEqualToDate:otherRolesElement.role_assigned]) return NO;

    if (!self.verifier && !otherRolesElement.verifier) /* Keep going... */;
    else if ((self.verifier == nil) ^ (otherRolesElement.verifier == nil)) return NO; // xor
    else if (![self.verifier isEqualToString:otherRolesElement.verifier]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"JRDate" forKey:@"expiryDate"];
    [dictionary setObject:@"NSString" forKey:@"role"];
    [dictionary setObject:@"JRDateTime" forKey:@"role_assigned"];
    [dictionary setObject:@"NSString" forKey:@"verifier"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
