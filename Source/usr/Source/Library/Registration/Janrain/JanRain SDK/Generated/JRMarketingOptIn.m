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
#import "JRMarketingOptIn.h"
#import "debug_log.h"

@interface JRMarketingOptIn ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRMarketingOptIn
{
    NSString *_locale;
    JRDateTime *_timestamp;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)locale
{
    return _locale;
}

- (void)setLocale:(NSString *)newLocale
{
    [self.dirtyPropertySet addObject:@"locale"];

    _locale = [newLocale copy];
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
        self.captureObjectPath = @"/marketingOptIn";
        self.canBeUpdatedOnCapture = YES;


        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)marketingOptIn
{
    return [[JRMarketingOptIn alloc] init];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.locale ? self.locale : [NSNull null])
                   forKey:@"locale"];
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

+ (id)marketingOptInObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRMarketingOptIn *marketingOptIn = [JRMarketingOptIn marketingOptIn];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        marketingOptIn.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
    }

    marketingOptIn.locale =
        [dictionary objectForKey:@"locale"] != [NSNull null] ? 
        [dictionary objectForKey:@"locale"] : nil;

    marketingOptIn.timestamp =
        [dictionary objectForKey:@"timestamp"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"timestamp"]] : nil;

    if (fromDecoder)
        [marketingOptIn.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [marketingOptIn.dirtyPropertySet removeAllObjects];

    return marketingOptIn;
}

+ (id)marketingOptInObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRMarketingOptIn marketingOptInObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;

    self.locale =
        [dictionary objectForKey:@"locale"] != [NSNull null] ? 
        [dictionary objectForKey:@"locale"] : nil;

    self.timestamp =
        [dictionary objectForKey:@"timestamp"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"timestamp"]] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"locale", @"timestamp", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"marketingOptIn"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"marketingOptIn"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"marketingOptIn"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"locale"])
        [dictionary setObject:(self.locale ? self.locale : [NSNull null]) forKey:@"locale"];

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

    [dictionary setObject:(self.locale ? self.locale : [NSNull null]) forKey:@"locale"];
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

- (BOOL)isEqualToMarketingOptIn:(JRMarketingOptIn *)otherMarketingOptIn
{
    if (!self.locale && !otherMarketingOptIn.locale) /* Keep going... */;
    else if ((self.locale == nil) ^ (otherMarketingOptIn.locale == nil)) return NO; // xor
    else if (![self.locale isEqualToString:otherMarketingOptIn.locale]) return NO;

    if (!self.timestamp && !otherMarketingOptIn.timestamp) /* Keep going... */;
    else if ((self.timestamp == nil) ^ (otherMarketingOptIn.timestamp == nil)) return NO; // xor
    else if (![self.timestamp isEqualToDate:otherMarketingOptIn.timestamp]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"locale"];
    [dictionary setObject:@"JRDateTime" forKey:@"timestamp"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
