//
//  AssetsViewController.m
//  DemoPRXClient
//
//  Created by Hashim MH on 19/12/16.
//  Copyright © 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import "AssetsViewController.h"
#import "PRXAssetAsset.h"
@import PhilipsUIKitDLS;

@interface AssetsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *assetsTableView;

@end

@implementation AssetsViewController

@synthesize assets = _assets;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSArray*)assets{
    if (!_assets) {
        _assets = [[NSArray alloc]init];
    }
    return _assets;
}
-(void)setAssets:(NSArray *)assets{
    _assets = assets;
               [self.assetsTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  self.assets.count;
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"AssetCell";
    UIDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    PRXAssetAsset *asset = self.assets[indexPath.row];
    UILabel *textLabel = [cell viewWithTag:1];
    textLabel.text = asset.assetDescription;
    return cell;
}
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PRXAssetAsset *asset = self.assets[indexPath.row];
    NSURL* url = [NSURL URLWithString: asset.asset];
    if (url &&     [[UIApplication sharedApplication] canOpenURL:url] ) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil ];
    }
    
}
@end
