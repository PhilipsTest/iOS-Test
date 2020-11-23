//
//  DCRequestBase.h
//  DigitalCare
//
//  Created by sameer sulaiman on 18/02/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import <Foundation/Foundation.h>
#include "DCConstants.h"

@interface DCRequestBaseUrl : NSObject

@property (nonatomic, assign) DCParserType parserType;
@property (nonatomic, assign) Class parserClass;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) id postBody;
@property (nonatomic, strong) NSString *methodType;
-(NSString*)requestUrl;

@end
