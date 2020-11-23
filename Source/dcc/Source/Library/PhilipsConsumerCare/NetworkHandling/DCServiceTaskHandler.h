//
//  DCDataHandler.h
//  DigitalCare
//
//  Created by sameer sulaiman on 16/02/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>
#import "DCParser.h"

typedef void(^CompletionBlock)(id response);
typedef void(^ExceptionBlock)(id response);

@interface DCServiceTaskHandler : NSObject
{
    DCParser *dcParser;
}
@property (nonatomic, copy)   CompletionBlock completionBlock;
@property (nonatomic, copy)   ExceptionBlock exceptionBlock;
@property (nonatomic, assign) DCParserType parserType;
@property (nonatomic, assign) Class parserClass;
@property (nonatomic, strong) NSString *requestUrl;

- (DCParser*) getParserInstance;
- (void)initializeTaskHandler;
- (void)downloadData;

@end
