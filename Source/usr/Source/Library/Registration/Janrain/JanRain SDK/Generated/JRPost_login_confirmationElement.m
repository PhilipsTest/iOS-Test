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
#import "JRPost_login_confirmationElement.h"
#import "debug_log.h"

@interface JRPost_login_confirmationElement ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRPost_login_confirmationElement
{
    JRDateTime *_approved_at;
    NSString *_screen_name;
}
@synthesize canBeUpdatedOnCapture;

- (JRDateTime *)approved_at
{
    return _approved_at;
}

- (void)setApproved_at:(JRDateTime *)newApproved_at
{
    [self.dirtyPropertySet addObject:@"approved_at"];

    _approved_at = [newApproved_at copy];
}

- (NSString *)screen_name
{
    return _screen_name;
}

- (void)setScreen_name:(NSString *)newScreen_name
{
    [self.dirtyPropertySet addObject:@"screen_name"];

    _screen_name = [newScreen_name copy];
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

+ (id)post_login_confirmationElement
{
    return [[JRPost_login_confirmationElement alloc] init];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.approved_at ? [self.approved_at stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"approved_at"];
    [dictionary setObject:(self.screen_name ? self.screen_name : [NSNull null])
                   forKey:@"screen_name"];

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

+ (id)post_login_confirmationElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRPost_login_confirmationElement *post_login_confirmationElement = [JRPost_login_confirmationElement post_login_confirmationElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        post_login_confirmationElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        post_login_confirmationElement.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        post_login_confirmationElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"post_login_confirmation", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        post_login_confirmationElement.canBeUpdatedOnCapture = YES;
    }

    post_login_confirmationElement.approved_at =
        [dictionary objectForKey:@"approved_at"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"approved_at"]] : nil;

    post_login_confirmationElement.screen_name =
        [dictionary objectForKey:@"screen_name"] != [NSNull null] ? 
        [dictionary objectForKey:@"screen_name"] : nil;

    if (fromDecoder)
        [post_login_confirmationElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [post_login_confirmationElement.dirtyPropertySet removeAllObjects];

    return post_login_confirmationElement;
}

+ (id)post_login_confirmationElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRPost_login_confirmationElement post_login_confirmationElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"post_login_confirmation", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.approved_at =
        [dictionary objectForKey:@"approved_at"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"approved_at"]] : nil;

    self.screen_name =
        [dictionary objectForKey:@"screen_name"] != [NSNull null] ? 
        [dictionary objectForKey:@"screen_name"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"approved_at", @"screen_name", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"post_login_confirmationElement"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"post_login_confirmationElement"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"post_login_confirmationElement"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"approved_at"])
        [dictionary setObject:(self.approved_at ? [self.approved_at stringFromISO8601DateTime] : [NSNull null]) forKey:@"approved_at"];

    if ([self.dirtyPropertySet containsObject:@"screen_name"])
        [dictionary setObject:(self.screen_name ? self.screen_name : [NSNull null]) forKey:@"screen_name"];

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

    [dictionary setObject:(self.approved_at ? [self.approved_at stringFromISO8601DateTime] : [NSNull null]) forKey:@"approved_at"];
    [dictionary setObject:(self.screen_name ? self.screen_name : [NSNull null]) forKey:@"screen_name"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToPost_login_confirmationElement:(JRPost_login_confirmationElement *)otherPost_login_confirmationElement
{
    if (!self.approved_at && !otherPost_login_confirmationElement.approved_at) /* Keep going... */;
    else if ((self.approved_at == nil) ^ (otherPost_login_confirmationElement.approved_at == nil)) return NO; // xor
    else if (![self.approved_at isEqualToDate:otherPost_login_confirmationElement.approved_at]) return NO;

    if (!self.screen_name && !otherPost_login_confirmationElement.screen_name) /* Keep going... */;
    else if ((self.screen_name == nil) ^ (otherPost_login_confirmationElement.screen_name == nil)) return NO; // xor
    else if (![self.screen_name isEqualToString:otherPost_login_confirmationElement.screen_name]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"JRDateTime" forKey:@"approved_at"];
    [dictionary setObject:@"NSString" forKey:@"screen_name"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
