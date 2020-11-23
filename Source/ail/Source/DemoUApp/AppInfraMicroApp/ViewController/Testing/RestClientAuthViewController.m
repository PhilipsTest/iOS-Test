//
//  RestClientAuthViewController.m
//  DemoAppInfra
//
//  Created by Hashim MH on 09/09/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import "RestClientAuthViewController.h"
#import "AilShareduAppDependency.h"
@import PhilipsUIKitDLS;

@interface RestClientAuthViewController ()<AIRESTClientDelegate>{
}
@property(nonatomic,strong)NSString *authToken;
@property (weak, nonatomic) IBOutlet UIDLabel *statusLabel;

@end


@implementation RestClientAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setAuthToken:(NSString *)authToken{
    if (authToken) {
        self.statusLabel.text = [NSString stringWithFormat:@"Logged in\n%@",authToken];
    }
    else{
       self.statusLabel.text = @"Logged out";
    }
    _authToken = authToken;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)loginPressed:(UIButton *)sender {
    
    NSString * URLString = @"https://hashim.herokuapp.com/RCT/test.php";
    NSDictionary *parameters = @{@"action":@"authtoken"};
    if ([parameters allKeys].count > 0) {
        NSMutableURLRequest * getRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
        URLString = getRequest.URL.absoluteString;
    }

    id<AIRESTClientProtocol>  restClient = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient createInstanceWithBaseURL:nil sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] withCachePolicy:0];
    
    //restClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [restClient GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideIndicator];
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSData * data = (NSData *)responseObject;
            NSString * response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
            [self showAlertWithMessage:response title:@"success"];
        }
        if ([responseObject isKindOfClass:[NSDictionary class]] && responseObject[@"access_token"]) {
            
            self.authToken = responseObject[@"access_token"];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideIndicator];
        [self showAlertWithMessage:error.localizedDescription title:@"Error"];
    }];

}

- (IBAction)checkPressed:(UIButton *)sender {
    
    NSString * URLString = @"https://hashim.herokuapp.com/RCT/test.php?action=authcheck";
    URLString = @"https://hashim.herokuapp.com/RCT/test.php";
    

    NSDictionary *parameters = @{@"action":@"authcheck"};
    if ([parameters allKeys].count > 0) {
        NSMutableURLRequest * getRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
        URLString = getRequest.URL.absoluteString;
    }
    
    id<AIRESTClientProtocol>  restClient = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient createInstanceWithBaseURL:nil sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] withCachePolicy:0];
    
    restClient.responseSerializer = [AIRESTClientHTTPResponseSerializer serializer];
    restClient.delegate = self;
    [restClient GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideIndicator];
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSData * data = (NSData *)responseObject;
            NSString * response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
            [self showAlertWithMessage:response title:@"success"];
        }
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            
            [self showAlertWithMessage:[responseObject description] title:@"success"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideIndicator];
        [self showAlertWithMessage:error.localizedDescription title:@"Error"];
    }];

}


- (IBAction)logoutPressed:(UIButton *)sender {
    self.authToken = nil;
}


- (IBAction)dismissPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)showAlertWithMessage:(NSString *)message title:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

-(void)showIndicator {
    //self.indicatorView.hidden = NO;
    //[self.activityIndicator startAnimating];
}

-(void)hideIndicator {
    //self.indicatorView.hidden = YES;
    //[self.activityIndicator stopAnimating];
}

-(AIRESTClientTokenType)getTokenType{
    return AIRESTClientTokenTypeOAUTH2;
}
-(nullable NSString *)getTokenValue{
   
    return self.authToken;
}
@end
