//
//  SupportDetailsViewController.m
//  DemoPRXClient
//
//  Created by Hashim MH on 20/12/16.
//  Copyright © 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import "SupportDetailsViewController.h"
#import "PRXFaqItem.h"
#import "PRXFaqChapter.h"
@import PhilipsUIKitDLS;

@interface SupportDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *faqTableView;


@end

@implementation SupportDetailsViewController
@synthesize richText = _richText;


- (void)viewDidLoad {
    [super viewDidLoad];
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

-(NSArray*)richText{
    if (!_richText) {
        _richText = [[NSArray alloc]init];
    }
    return _richText;
}
-(void)setRichText:(NSArray *)richText{
    _richText = richText;
    [self.faqTableView reloadData];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.richText.count;
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"FaqDetailCell";
    UIDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    PRXFaqItem *rt = self.richText[indexPath.row];
    UILabel *textLabel = [cell viewWithTag:1];
    UILabel *chapterName = [cell viewWithTag:2];
    textLabel.text = rt.head;
    chapterName.text = rt.asset;
    return cell;
}
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PRXFaqItem *item = self.richText[indexPath.row];
     NSURL* url = [NSURL URLWithString: item.asset];
     if (url &&     [[UIApplication sharedApplication] canOpenURL:url] ) {
         [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil ];
     }
    
}
- (IBAction)closeButtonPressed:(UIDButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
