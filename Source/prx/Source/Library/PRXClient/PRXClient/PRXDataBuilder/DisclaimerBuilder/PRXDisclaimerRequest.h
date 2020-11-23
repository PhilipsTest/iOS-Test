//
//  PRXDisclaimerRequest.h
//  PRXClient
//
//  Created by Prasad Devadiga on 11/09/18.
//  Copyright © 2018 Koninklijke Philips N.V. All rights reserved.
//

#import "PRXRequest.h"

@interface PRXDisclaimerRequest : PRXRequest

- (instancetype)initWithSector:(Sector) sec
                     ctnNumber:(NSString *) ctnNumber
                       catalog:(Catalog) cat;
@end
