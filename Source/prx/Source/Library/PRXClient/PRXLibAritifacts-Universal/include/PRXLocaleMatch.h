//
//  PRXLocaleMatch.h
//  PRXClient
//
//  Created by Sumit Prasad on 10/03/16.
//  Copyright © 2016 sameer sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PhilipsLocaleMatch/PILLocaleManager.h>

@interface PRXLocaleMatch : NSObject

+ (PRXLocaleMatch *) sharedInstances;

typedef void (^success)(PILLocale *data);
- (void) refreshLocale:(Sector) inputSector
               catalog:(Catalog) inputCatalog
     completionHandler:(success) successBlock;
@end
