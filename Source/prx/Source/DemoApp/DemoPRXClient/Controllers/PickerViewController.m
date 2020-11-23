//
//  PickerViewController.m
//  DemoPRXClient
//
//  Created by Prasad Devadiga on 07/12/18.
//  Copyright © 2018 sameer sulaiman. All rights reserved.
//

#import "PickerViewController.h"

typedef enum : NSUInteger {
    typeSector,
    typeCatalog,
    typeCountry,
} PickerType;

@interface PickerViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic) PickerType pickerType;
@end

@implementation PickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_pickerType == typeSector) {
        return  self.sectors.count;
    } else if (_pickerType == typeCatalog) {
        return  self.catalogs.count;
    } else if (_pickerType == typeCountry) {
        return  self.sectors.count;
    } return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_pickerType == typeSector) {
        return  self.sectors[row];
    } else if (_pickerType == typeCatalog) {
        return  self.catalogs[row];
    } else if (_pickerType == typeCountry) {
        return self.countries[row];
    }
    return @"";
}

@end
