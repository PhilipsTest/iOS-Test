//
//  CountrySelectionViewController.m
//  PhilipsConsumerCare
//
//  Created by Niharika Bundela on 2/2/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "DCCountrySelectionViewController.h"

@interface DCCountrySelectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSArray *countryArray;
@property(nonatomic,strong) NSArray *countryCodeArray;
@property(nonatomic,strong) NSDictionary *countryDict;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation DCCountrySelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *countryFilePath = [[NSBundle bundleForClass:self.class]pathForResource:@"CountryName" ofType:@"plist"];
    if(countryFilePath)
    {
        self.countryDict = [[NSDictionary alloc]initWithContentsOfFile:countryFilePath];
    }
    _countryCodeArray = [self.countryDict allKeys];
    _countryArray =  [self.countryDict allValues];
    _countryCodeArray = [[self.countryDict allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    _countryArray = [self.countryDict objectsForKeys:_countryCodeArray notFoundMarker: [NSNull null]];
   // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.countryCodeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.countryArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(getCountry:countryCode:)]) {
        [self.delegate getCountry:[self.countryArray objectAtIndex:indexPath.row] countryCode:[self.countryCodeArray objectAtIndex:indexPath.row]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
