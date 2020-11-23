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
#import "JRIdentifierInformation.h"
#import "debug_log.h"

@interface JRIdentifierInformation ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRIdentifierInformation
{
    NSString *_answerOne;
    NSString *_answerTwo;
    NSString *_questionOne;
    NSString *_questionThree;
    NSString *_questionTwo;
    NSString *_questionsThree;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)answerOne
{
    return _answerOne;
}

- (void)setAnswerOne:(NSString *)newAnswerOne
{
    [self.dirtyPropertySet addObject:@"answerOne"];

    _answerOne = [newAnswerOne copy];
}

- (NSString *)answerTwo
{
    return _answerTwo;
}

- (void)setAnswerTwo:(NSString *)newAnswerTwo
{
    [self.dirtyPropertySet addObject:@"answerTwo"];

    _answerTwo = [newAnswerTwo copy];
}

- (NSString *)questionOne
{
    return _questionOne;
}

- (void)setQuestionOne:(NSString *)newQuestionOne
{
    [self.dirtyPropertySet addObject:@"questionOne"];

    _questionOne = [newQuestionOne copy];
}

- (NSString *)questionThree
{
    return _questionThree;
}

- (void)setQuestionThree:(NSString *)newQuestionThree
{
    [self.dirtyPropertySet addObject:@"questionThree"];

    _questionThree = [newQuestionThree copy];
}

- (NSString *)questionTwo
{
    return _questionTwo;
}

- (void)setQuestionTwo:(NSString *)newQuestionTwo
{
    [self.dirtyPropertySet addObject:@"questionTwo"];

    _questionTwo = [newQuestionTwo copy];
}

- (NSString *)questionsThree
{
    return _questionsThree;
}

- (void)setQuestionsThree:(NSString *)newQuestionsThree
{
    [self.dirtyPropertySet addObject:@"questionsThree"];

    _questionsThree = [newQuestionsThree copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/identifierInformation";
        self.canBeUpdatedOnCapture = YES;


        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)identifierInformation
{
    return [[JRIdentifierInformation alloc] init];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.answerOne ? self.answerOne : [NSNull null])
                   forKey:@"answerOne"];
    [dictionary setObject:(self.answerTwo ? self.answerTwo : [NSNull null])
                   forKey:@"answerTwo"];
    [dictionary setObject:(self.questionOne ? self.questionOne : [NSNull null])
                   forKey:@"questionOne"];
    [dictionary setObject:(self.questionThree ? self.questionThree : [NSNull null])
                   forKey:@"questionThree"];
    [dictionary setObject:(self.questionTwo ? self.questionTwo : [NSNull null])
                   forKey:@"questionTwo"];
    [dictionary setObject:(self.questionsThree ? self.questionsThree : [NSNull null])
                   forKey:@"questionsThree"];

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

+ (id)identifierInformationObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRIdentifierInformation *identifierInformation = [JRIdentifierInformation identifierInformation];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        identifierInformation.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
    }

    identifierInformation.answerOne =
        [dictionary objectForKey:@"answerOne"] != [NSNull null] ? 
        [dictionary objectForKey:@"answerOne"] : nil;

    identifierInformation.answerTwo =
        [dictionary objectForKey:@"answerTwo"] != [NSNull null] ? 
        [dictionary objectForKey:@"answerTwo"] : nil;

    identifierInformation.questionOne =
        [dictionary objectForKey:@"questionOne"] != [NSNull null] ? 
        [dictionary objectForKey:@"questionOne"] : nil;

    identifierInformation.questionThree =
        [dictionary objectForKey:@"questionThree"] != [NSNull null] ? 
        [dictionary objectForKey:@"questionThree"] : nil;

    identifierInformation.questionTwo =
        [dictionary objectForKey:@"questionTwo"] != [NSNull null] ? 
        [dictionary objectForKey:@"questionTwo"] : nil;

    identifierInformation.questionsThree =
        [dictionary objectForKey:@"questionsThree"] != [NSNull null] ? 
        [dictionary objectForKey:@"questionsThree"] : nil;

    if (fromDecoder)
        [identifierInformation.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [identifierInformation.dirtyPropertySet removeAllObjects];

    return identifierInformation;
}

+ (id)identifierInformationObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRIdentifierInformation identifierInformationObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;

    self.answerOne =
        [dictionary objectForKey:@"answerOne"] != [NSNull null] ? 
        [dictionary objectForKey:@"answerOne"] : nil;

    self.answerTwo =
        [dictionary objectForKey:@"answerTwo"] != [NSNull null] ? 
        [dictionary objectForKey:@"answerTwo"] : nil;

    self.questionOne =
        [dictionary objectForKey:@"questionOne"] != [NSNull null] ? 
        [dictionary objectForKey:@"questionOne"] : nil;

    self.questionThree =
        [dictionary objectForKey:@"questionThree"] != [NSNull null] ? 
        [dictionary objectForKey:@"questionThree"] : nil;

    self.questionTwo =
        [dictionary objectForKey:@"questionTwo"] != [NSNull null] ? 
        [dictionary objectForKey:@"questionTwo"] : nil;

    self.questionsThree =
        [dictionary objectForKey:@"questionsThree"] != [NSNull null] ? 
        [dictionary objectForKey:@"questionsThree"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"answerOne", @"answerTwo", @"questionOne", @"questionThree", @"questionTwo", @"questionsThree", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"identifierInformation"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"identifierInformation"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"identifierInformation"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"answerOne"])
        [dictionary setObject:(self.answerOne ? self.answerOne : [NSNull null]) forKey:@"answerOne"];

    if ([self.dirtyPropertySet containsObject:@"answerTwo"])
        [dictionary setObject:(self.answerTwo ? self.answerTwo : [NSNull null]) forKey:@"answerTwo"];

    if ([self.dirtyPropertySet containsObject:@"questionOne"])
        [dictionary setObject:(self.questionOne ? self.questionOne : [NSNull null]) forKey:@"questionOne"];

    if ([self.dirtyPropertySet containsObject:@"questionThree"])
        [dictionary setObject:(self.questionThree ? self.questionThree : [NSNull null]) forKey:@"questionThree"];

    if ([self.dirtyPropertySet containsObject:@"questionTwo"])
        [dictionary setObject:(self.questionTwo ? self.questionTwo : [NSNull null]) forKey:@"questionTwo"];

    if ([self.dirtyPropertySet containsObject:@"questionsThree"])
        [dictionary setObject:(self.questionsThree ? self.questionsThree : [NSNull null]) forKey:@"questionsThree"];

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

    [dictionary setObject:(self.answerOne ? self.answerOne : [NSNull null]) forKey:@"answerOne"];
    [dictionary setObject:(self.answerTwo ? self.answerTwo : [NSNull null]) forKey:@"answerTwo"];
    [dictionary setObject:(self.questionOne ? self.questionOne : [NSNull null]) forKey:@"questionOne"];
    [dictionary setObject:(self.questionThree ? self.questionThree : [NSNull null]) forKey:@"questionThree"];
    [dictionary setObject:(self.questionTwo ? self.questionTwo : [NSNull null]) forKey:@"questionTwo"];
    [dictionary setObject:(self.questionsThree ? self.questionsThree : [NSNull null]) forKey:@"questionsThree"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToIdentifierInformation:(JRIdentifierInformation *)otherIdentifierInformation
{
    if (!self.answerOne && !otherIdentifierInformation.answerOne) /* Keep going... */;
    else if ((self.answerOne == nil) ^ (otherIdentifierInformation.answerOne == nil)) return NO; // xor
    else if (![self.answerOne isEqualToString:otherIdentifierInformation.answerOne]) return NO;

    if (!self.answerTwo && !otherIdentifierInformation.answerTwo) /* Keep going... */;
    else if ((self.answerTwo == nil) ^ (otherIdentifierInformation.answerTwo == nil)) return NO; // xor
    else if (![self.answerTwo isEqualToString:otherIdentifierInformation.answerTwo]) return NO;

    if (!self.questionOne && !otherIdentifierInformation.questionOne) /* Keep going... */;
    else if ((self.questionOne == nil) ^ (otherIdentifierInformation.questionOne == nil)) return NO; // xor
    else if (![self.questionOne isEqualToString:otherIdentifierInformation.questionOne]) return NO;

    if (!self.questionThree && !otherIdentifierInformation.questionThree) /* Keep going... */;
    else if ((self.questionThree == nil) ^ (otherIdentifierInformation.questionThree == nil)) return NO; // xor
    else if (![self.questionThree isEqualToString:otherIdentifierInformation.questionThree]) return NO;

    if (!self.questionTwo && !otherIdentifierInformation.questionTwo) /* Keep going... */;
    else if ((self.questionTwo == nil) ^ (otherIdentifierInformation.questionTwo == nil)) return NO; // xor
    else if (![self.questionTwo isEqualToString:otherIdentifierInformation.questionTwo]) return NO;

    if (!self.questionsThree && !otherIdentifierInformation.questionsThree) /* Keep going... */;
    else if ((self.questionsThree == nil) ^ (otherIdentifierInformation.questionsThree == nil)) return NO; // xor
    else if (![self.questionsThree isEqualToString:otherIdentifierInformation.questionsThree]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"answerOne"];
    [dictionary setObject:@"NSString" forKey:@"answerTwo"];
    [dictionary setObject:@"NSString" forKey:@"questionOne"];
    [dictionary setObject:@"NSString" forKey:@"questionThree"];
    [dictionary setObject:@"NSString" forKey:@"questionTwo"];
    [dictionary setObject:@"NSString" forKey:@"questionsThree"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
