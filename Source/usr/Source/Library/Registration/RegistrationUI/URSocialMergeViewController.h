//
//  URSocialMergeViewController.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import "RegistrationBaseViewController.h"

@interface URSocialMergeViewController : RegistrationBaseViewController
@property (nonatomic, strong) NSString *existingProviderName;
@property (nonatomic, strong) NSString *socialProviderAuthorizedEmail;

@end
