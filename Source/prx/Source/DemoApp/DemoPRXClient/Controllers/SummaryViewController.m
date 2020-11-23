//
//  SummaryViewController.m
//  DemoPRXClient
//
//  Created by Hashim MH on 19/12/16.
//  Copyright © 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import "SummaryViewController.h"
#import "PRXSummaryPrice.h"
@interface SummaryViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *productTitle;
@property (weak, nonatomic) IBOutlet UILabel *wow;
@property (weak, nonatomic) IBOutlet UILabel *subwow;

@property (weak, nonatomic) IBOutlet UILabel *marketingTextHeader;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end

@implementation SummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSummary:(PRXSummaryData *)summary{
    self.marketingTextHeader.text = summary.marketingTextHeader;
   
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:summary.imageURL]]];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            self.image.image = image;
        });
    });

    self.price.text = [NSString stringWithFormat:@"Price : %@",summary.price.formattedDisplayPrice];
        self.productTitle.text = summary.productTitle;
        self.wow.text = summary.wow;
        self.subwow.text = summary.subWOW;
    
    _summary = summary;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
