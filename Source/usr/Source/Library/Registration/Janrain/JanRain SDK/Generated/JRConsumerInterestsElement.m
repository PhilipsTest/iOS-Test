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
#import "JRConsumerInterestsElement.h"
#import "debug_log.h"

@interface JRConsumerInterestsElement ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRConsumerInterestsElement
{
    NSString *_campaignName;
    NSString *_subjectArea;
    NSString *_topicCommunicationKey;
    NSString *_topicValue;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)campaignName
{
    return _campaignName;
}

- (void)setCampaignName:(NSString *)newCampaignName
{
    [self.dirtyPropertySet addObject:@"campaignName"];

    _campaignName = [newCampaignName copy];
}

- (NSString *)subjectArea
{
    return _subjectArea;
}

- (void)setSubjectArea:(NSString *)newSubjectArea
{
    [self.dirtyPropertySet addObject:@"subjectArea"];

    _subjectArea = [newSubjectArea copy];
}

- (NSString *)topicCommunicationKey
{
    return _topicCommunicationKey;
}

- (void)setTopicCommunicationKey:(NSString *)newTopicCommunicationKey
{
    [self.dirtyPropertySet addObject:@"topicCommunicationKey"];

    _topicCommunicationKey = [newTopicCommunicationKey copy];
}

- (NSString *)topicValue
{
    return _topicValue;
}

- (void)setTopicValue:(NSString *)newTopicValue
{
    [self.dirtyPropertySet addObject:@"topicValue"];

    _topicValue = [newTopicValue copy];
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

- (id)initWithSubjectArea:(NSString *)newSubjectArea andTopicCommunicationKey:(NSString *)newTopicCommunicationKey andTopicValue:(NSString *)newTopicValue
{
    if (!newSubjectArea || !newTopicCommunicationKey || !newTopicValue)
    {
        return nil;
     }

    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOnCapture  = NO;

        _subjectArea = [newSubjectArea copy];
        _topicCommunicationKey = [newTopicCommunicationKey copy];
        _topicValue = [newTopicValue copy];

        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)consumerInterestsElement
{
    return [[JRConsumerInterestsElement alloc] init];
}

+ (id)consumerInterestsElementWithSubjectArea:(NSString *)subjectArea andTopicCommunicationKey:(NSString *)topicCommunicationKey andTopicValue:(NSString *)topicValue
{
    return [[JRConsumerInterestsElement alloc] initWithSubjectArea:subjectArea andTopicCommunicationKey:topicCommunicationKey andTopicValue:topicValue];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.campaignName ? self.campaignName : [NSNull null])
                   forKey:@"campaignName"];
    [dictionary setObject:(self.subjectArea ? self.subjectArea : [NSNull null])
                   forKey:@"subjectArea"];
    [dictionary setObject:(self.topicCommunicationKey ? self.topicCommunicationKey : [NSNull null])
                   forKey:@"topicCommunicationKey"];
    [dictionary setObject:(self.topicValue ? self.topicValue : [NSNull null])
                   forKey:@"topicValue"];

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

+ (id)consumerInterestsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRConsumerInterestsElement *consumerInterestsElement = [JRConsumerInterestsElement consumerInterestsElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        consumerInterestsElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        consumerInterestsElement.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        consumerInterestsElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"consumerInterests", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        consumerInterestsElement.canBeUpdatedOnCapture = YES;
    }

    consumerInterestsElement.campaignName =
        [dictionary objectForKey:@"campaignName"] != [NSNull null] ? 
        [dictionary objectForKey:@"campaignName"] : nil;

    consumerInterestsElement.subjectArea =
        [dictionary objectForKey:@"subjectArea"] != [NSNull null] ? 
        [dictionary objectForKey:@"subjectArea"] : nil;

    consumerInterestsElement.topicCommunicationKey =
        [dictionary objectForKey:@"topicCommunicationKey"] != [NSNull null] ? 
        [dictionary objectForKey:@"topicCommunicationKey"] : nil;

    consumerInterestsElement.topicValue =
        [dictionary objectForKey:@"topicValue"] != [NSNull null] ? 
        [dictionary objectForKey:@"topicValue"] : nil;

    if (fromDecoder)
        [consumerInterestsElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [consumerInterestsElement.dirtyPropertySet removeAllObjects];

    return consumerInterestsElement;
}

+ (id)consumerInterestsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRConsumerInterestsElement consumerInterestsElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"consumerInterests", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.campaignName =
        [dictionary objectForKey:@"campaignName"] != [NSNull null] ? 
        [dictionary objectForKey:@"campaignName"] : nil;

    self.subjectArea =
        [dictionary objectForKey:@"subjectArea"] != [NSNull null] ? 
        [dictionary objectForKey:@"subjectArea"] : nil;

    self.topicCommunicationKey =
        [dictionary objectForKey:@"topicCommunicationKey"] != [NSNull null] ? 
        [dictionary objectForKey:@"topicCommunicationKey"] : nil;

    self.topicValue =
        [dictionary objectForKey:@"topicValue"] != [NSNull null] ? 
        [dictionary objectForKey:@"topicValue"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"campaignName", @"subjectArea", @"topicCommunicationKey", @"topicValue", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"consumerInterestsElement"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"consumerInterestsElement"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"consumerInterestsElement"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"campaignName"])
        [dictionary setObject:(self.campaignName ? self.campaignName : [NSNull null]) forKey:@"campaignName"];

    if ([self.dirtyPropertySet containsObject:@"subjectArea"])
        [dictionary setObject:(self.subjectArea ? self.subjectArea : [NSNull null]) forKey:@"subjectArea"];

    if ([self.dirtyPropertySet containsObject:@"topicCommunicationKey"])
        [dictionary setObject:(self.topicCommunicationKey ? self.topicCommunicationKey : [NSNull null]) forKey:@"topicCommunicationKey"];

    if ([self.dirtyPropertySet containsObject:@"topicValue"])
        [dictionary setObject:(self.topicValue ? self.topicValue : [NSNull null]) forKey:@"topicValue"];

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

    [dictionary setObject:(self.campaignName ? self.campaignName : [NSNull null]) forKey:@"campaignName"];
    [dictionary setObject:(self.subjectArea ? self.subjectArea : [NSNull null]) forKey:@"subjectArea"];
    [dictionary setObject:(self.topicCommunicationKey ? self.topicCommunicationKey : [NSNull null]) forKey:@"topicCommunicationKey"];
    [dictionary setObject:(self.topicValue ? self.topicValue : [NSNull null]) forKey:@"topicValue"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToConsumerInterestsElement:(JRConsumerInterestsElement *)otherConsumerInterestsElement
{
    if (!self.campaignName && !otherConsumerInterestsElement.campaignName) /* Keep going... */;
    else if ((self.campaignName == nil) ^ (otherConsumerInterestsElement.campaignName == nil)) return NO; // xor
    else if (![self.campaignName isEqualToString:otherConsumerInterestsElement.campaignName]) return NO;

    if (!self.subjectArea && !otherConsumerInterestsElement.subjectArea) /* Keep going... */;
    else if ((self.subjectArea == nil) ^ (otherConsumerInterestsElement.subjectArea == nil)) return NO; // xor
    else if (![self.subjectArea isEqualToString:otherConsumerInterestsElement.subjectArea]) return NO;

    if (!self.topicCommunicationKey && !otherConsumerInterestsElement.topicCommunicationKey) /* Keep going... */;
    else if ((self.topicCommunicationKey == nil) ^ (otherConsumerInterestsElement.topicCommunicationKey == nil)) return NO; // xor
    else if (![self.topicCommunicationKey isEqualToString:otherConsumerInterestsElement.topicCommunicationKey]) return NO;

    if (!self.topicValue && !otherConsumerInterestsElement.topicValue) /* Keep going... */;
    else if ((self.topicValue == nil) ^ (otherConsumerInterestsElement.topicValue == nil)) return NO; // xor
    else if (![self.topicValue isEqualToString:otherConsumerInterestsElement.topicValue]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"campaignName"];
    [dictionary setObject:@"NSString" forKey:@"subjectArea"];
    [dictionary setObject:@"NSString" forKey:@"topicCommunicationKey"];
    [dictionary setObject:@"NSString" forKey:@"topicValue"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
