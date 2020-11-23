//
//  AIAppTaggingWrapper.h
//  AppInfra
//
//  Created by Ravi Kiran HR on 22/06/16.
/*  Copyright ©  Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//

#import <Foundation/Foundation.h>
#import "AIAppTagging.h"
#import "AIClientComponent.h"

@interface AIAppTaggingWrapper : AIAppTagging

/**
 *  Convenience initializer
 *
 *  @param component component requesting for tagging wrapper
 *
 *  @return Returns a tagging wrapper object for given component
 */
- (instancetype)initWithComponent:(AIClientComponent *)component;



@end
