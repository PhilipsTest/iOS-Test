//
//  PRXProductMetaDataRequest.h
//  PRXClient
//
//  Created by Sumit Prasad on 07/03/16.
//  Copyright © 2016 sameer sulaiman. All rights reserved.
//

#import "PRXRequest.h"

@interface PRXAssetRequest : PRXRequest
- (instancetype)initWithSector:(Sector) sec
                     ctnNumber:(NSString *) ctnNumber
                       catalog:(Catalog) cat;
@end
