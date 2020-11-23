//
//  UIControl+ProductSelectionLocalization.h
//  PhilipsProductSelection
//
//  Created by Niharika Bundela on 6/9/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Localization)

- (void)setProductSelectionLocalizedText:(NSString *)localizationKey;
@end

@interface UIButton (Localization)

- (void)setProductSelectionLocalizedText:(NSString *)localizationKey;

@end


@interface UITextField (Localization)

- (void)setProductSelectionLocalizedText:(NSString *)localizationKey;

@end

