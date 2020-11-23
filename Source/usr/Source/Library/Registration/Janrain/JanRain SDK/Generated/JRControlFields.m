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
#import "JRControlFields.h"
#import "debug_log.h"

@interface JRControlFields ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRControlFields
{
    NSString *_one;
    NSString *_three;
    NSString *_two;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)one
{
    return _one;
}

- (void)setOne:(NSString *)newOne
{
    [self.dirtyPropertySet addObject:@"one"];

    _one = [newOne copy];
}

- (NSString *)three
{
    return _three;
}

- (void)setThree:(NSString *)newThree
{
    [self.dirtyPropertySet addObject:@"three"];

    _three = [newThree copy];
}

- (NSString *)two
{
    return _two;
}

- (void)setTwo:(NSString *)newTwo
{
    [self.dirtyPropertySet addObject:@"two"];

    _two = [newTwo copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/janrain/controlFields";
        self.canBeUpdatedOnCapture = YES;


        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)controlFields
{
    return [[JRControlFields alloc] init];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.one ? self.one : [NSNull null])
                   forKey:@"one"];
    [dictionary setObject:(self.three ? self.three : [NSNull null])
                   forKey:@"three"];
    [dictionary setObject:(self.two ? self.two : [NSNull null])
                   forKey:@"two"];

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

+ (id)controlFieldsObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRControlFields *controlFields = [JRControlFields controlFields];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        controlFields.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
    }

    controlFields.one =
        [dictionary objectForKey:@"one"] != [NSNull null] ? 
        [dictionary objectForKey:@"one"] : nil;

    controlFields.three =
        [dictionary objectForKey:@"three"] != [NSNull null] ? 
        [dictionary objectForKey:@"three"] : nil;

    controlFields.two =
        [dictionary objectForKey:@"two"] != [NSNull null] ? 
        [dictionary objectForKey:@"two"] : nil;

    if (fromDecoder)
        [controlFields.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [controlFields.dirtyPropertySet removeAllObjects];

    return controlFields;
}

+ (id)controlFieldsObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRControlFields controlFieldsObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;

    self.one =
        [dictionary objectForKey:@"one"] != [NSNull null] ? 
        [dictionary objectForKey:@"one"] : nil;

    self.three =
        [dictionary objectForKey:@"three"] != [NSNull null] ? 
        [dictionary objectForKey:@"three"] : nil;

    self.two =
        [dictionary objectForKey:@"two"] != [NSNull null] ? 
        [dictionary objectForKey:@"two"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"one", @"three", @"two", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"controlFields"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"controlFields"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"controlFields"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"one"])
        [dictionary setObject:(self.one ? self.one : [NSNull null]) forKey:@"one"];

    if ([self.dirtyPropertySet containsObject:@"three"])
        [dictionary setObject:(self.three ? self.three : [NSNull null]) forKey:@"three"];

    if ([self.dirtyPropertySet containsObject:@"two"])
        [dictionary setObject:(self.two ? self.two : [NSNull null]) forKey:@"two"];

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

    [dictionary setObject:(self.one ? self.one : [NSNull null]) forKey:@"one"];
    [dictionary setObject:(self.three ? self.three : [NSNull null]) forKey:@"three"];
    [dictionary setObject:(self.two ? self.two : [NSNull null]) forKey:@"two"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToControlFields:(JRControlFields *)otherControlFields
{
    if (!self.one && !otherControlFields.one) /* Keep going... */;
    else if ((self.one == nil) ^ (otherControlFields.one == nil)) return NO; // xor
    else if (![self.one isEqualToString:otherControlFields.one]) return NO;

    if (!self.three && !otherControlFields.three) /* Keep going... */;
    else if ((self.three == nil) ^ (otherControlFields.three == nil)) return NO; // xor
    else if (![self.three isEqualToString:otherControlFields.three]) return NO;

    if (!self.two && !otherControlFields.two) /* Keep going... */;
    else if ((self.two == nil) ^ (otherControlFields.two == nil)) return NO; // xor
    else if (![self.two isEqualToString:otherControlFields.two]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"one"];
    [dictionary setObject:@"NSString" forKey:@"three"];
    [dictionary setObject:@"NSString" forKey:@"two"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
