//
//  AISDService.h
//  AppInfra
//
//  Created by Hashim MH on 08/08/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Model class for service discovery service object.
 * @since 1.0.0
 */
@interface AISDService : NSObject

/**
 * service discovery URL value
 * @since 1.0.0
 */
@property(nonatomic, strong)NSString *url;
/**
 * locale from service discovery
 * @since 1.0.0
 */
@property(nonatomic, strong)NSString *locale;
/**
 * will return error if url from service discovery is nil.
 * @since 1.0.0
 */
@property(nonatomic, strong)NSError *error;

- (instancetype)initWithUrl:(NSString *)url andLocale:(NSString*)locale;

@end
