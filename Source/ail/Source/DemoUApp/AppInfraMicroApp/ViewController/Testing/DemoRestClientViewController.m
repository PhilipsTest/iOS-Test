//
//  DemoRestClient.m
//  DemoAppInfra
//
//  Created by leslie on 25/08/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import "DemoRestClientViewController.h"
#import <AppInfra/AppInfra.h>
#import "RestClientParamsViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "AilShareduAppDependency.h"
#import <AppInfraMicroApp/AppInfraMicroApp-Swift.h>
@import PhilipsUIKitDLS;

@interface DemoRestClientViewController()<UITextFieldDelegate, UIDRadioGroupDelegate, UIDRadioGroupDataSource, TableViewControlDelegate>


@property (weak, nonatomic) IBOutlet UIDTextField *pathTextField;
@property (weak, nonatomic) IBOutlet UIDTextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIDButton *selectMethodButton;
@property (weak, nonatomic) IBOutlet UIDButton *selectCacheOptionsButton;

@property (weak, nonatomic) IBOutlet UIView *indicatorView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSArray * methodNames;
@property (strong, nonatomic) NSArray * serviceIDAPINames;
@property (strong, nonatomic) NSArray * cacheOptions;
@property (nonatomic) NSUInteger selectedMethodIndex;
@property (nonatomic) NSUInteger selectedCacheOptionIndex;
@property (nonatomic, copy)NSDictionary * parameters;
@property BOOL serviceIDAPI;
@property (weak, nonatomic) IBOutlet UIDRadioGroup *controlRadioGroup;
@property (weak, nonatomic) IBOutlet UIDRadioGroup *preferanceRadioGroup;
@property (assign , nonatomic) BOOL isMethodNamePressed;
@property AIRESTServiceIDPreference preference;
@property (strong, nonatomic) AFNetworkReachabilityManager * reachabilityManager;
@property (strong, nonatomic) id <TableViewControlDelegate> delegate ;
@end

@implementation DemoRestClientViewController {
    NSArray *controlDataArray ;
    NSArray *preferanceDataArray ;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.selectedMethodIndex = 0;
    controlDataArray = @[@"URL Request",@"ServiceID Request"];
    preferanceDataArray = @[@"By Country",@"By Language"];
    [self prinCachetDBPath];
    
    self.methodNames = [NSArray arrayWithObjects:@"GET",@"POST",@"PUT",@"PATCH",@"DELETE",@"downloadTaskWithRequest",@"downloadTaskWithResumeData",@"uploadTaskWithRequestFromFile",@"uploadTaskWithRequestFromData",@"uploadTaskWithStreamedRequest",@"dataTaskWithRequest",@"dataTaskWithRequestAndProgress", nil];
    self.serviceIDAPINames = [NSArray arrayWithObjects:@"GETWithServiceID", @"HEADWithServiceID", @"POSTWithServiceID", @"PUTWithServiceID", @"PATCHWithServiceID", @"DELETEWithServiceID", nil];
    self.cacheOptions = [NSArray arrayWithObjects: @"RequestUseProtocolCachePolicy",@"RequestReloadIgnoringLocalCacheData", @"RequestReturnCacheDataElseLoad", nil];
    self.serviceIDAPI = NO;
    
    self.preference = AIRESTServiceIDPreferenceCountry;
    

    [AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient.responseSerializer = [AIRESTClientHTTPResponseSerializer serializer];
    
    self.reachabilityManager = [AFNetworkReachabilityManager manager];
    
    [self.reachabilityManager startMonitoring];
    
    [self setURLRequests:YES];
    
    [self.controlRadioGroup setDelegate:self];
    [self.controlRadioGroup setDataSource:self];
    [self.controlRadioGroup refreshRadioGroup];
    [self.preferanceRadioGroup setDelegate:self];
    [self.preferanceRadioGroup setDataSource:self];
    [self.preferanceRadioGroup refreshRadioGroup];
}


-(NSInteger)numberOfRadioButtonsFor:(UIDRadioGroup *)radioGroup {
    if (radioGroup.tag == 0) {
        return controlDataArray.count ;
    } else {
        return preferanceDataArray.count;
    }
}

-(NSString *)radioGroup:(UIDRadioGroup *)radioGroup titleAtIndex:(NSInteger)titleAtIndex {
    if (radioGroup.tag == 0) {
        return controlDataArray[titleAtIndex];
    } else {
        return preferanceDataArray[titleAtIndex];
    }
}


-(void)radioGroup:(UIDRadioGroup *)radioGroup selectedIndex:(NSInteger)selectedIndex {
    if (radioGroup.tag == 0 ) {
        switch (selectedIndex) {
            case 0: [self setURLRequests:YES]; break;
            case 1: [self setURLRequests:NO]; break ;
            default: break;
        }
    } else {
        switch (selectedIndex) {
            case 0: self.preference = AIRESTServiceIDPreferenceCountry; break;
            case 1: self.preference = AIRESTServiceIDPreferenceLanguage; break;
            default: break;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient.responseSerializer = [AIRESTClientHTTPResponseSerializer serializer];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
        [AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient.responseSerializer = [AIRESTClientJSONResponseSerializer serializer];
}
-(void)prinCachetDBPath{
    
    NSLog(@"%@Cache.db",[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject]);
}

- (IBAction)selectButtonTapped:(id)sender {
    NSArray * apis;
    if (self.serviceIDAPI) {
        apis = self.serviceIDAPINames;
    }
    else {
        apis = self.methodNames;
    }
    
    CustomTableViewController * list = (CustomTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"customTableViewController"];
    list.delegate = self;
    list.dataSource = apis;
    [self.navigationController pushViewController:list animated:YES];
    self.isMethodNamePressed = true;
}


-(void)updateControl:(NSInteger)selectedOption {
    if (self.isMethodNamePressed) {
        NSArray * apis;
        self.selectedMethodIndex = selectedOption;
        self.isMethodNamePressed = false;
        if (self.serviceIDAPI) {
            apis = self.serviceIDAPINames;
        }
        else {
            apis = self.methodNames;
        }
        [self.selectMethodButton setTitle: apis[selectedOption] forState:UIControlStateNormal];
        if (self.selectedMethodIndex == 0 || self.selectedMethodIndex == 10|| self.selectedMethodIndex == 11){
            self.selectCacheOptionsButton.hidden = NO;
        }
        else {
            self.selectCacheOptionsButton.hidden = YES;
        }
    } else {
        self.selectedCacheOptionIndex = selectedOption;
        [self.selectCacheOptionsButton setTitle:self.cacheOptions[selectedOption] forState:UIControlStateNormal];
    }
}


-(BOOL)validateUI {
    if ([self.urlTextField.text isEqualToString:@""] || self.urlTextField.text == nil) {
        [self showAlertWithMessage:@"Please enter URL / Service ID" title:@"Error"];
        return NO;
    }
    return YES;
}

- (IBAction)selectCacheOptionsButtonTapped:(id)sender {
    CustomTableViewController * list = (CustomTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"customTableViewController"];
    list.dataSource = self.cacheOptions;
    list.delegate = self;
    [self.navigationController pushViewController:list animated:YES];
    
}

-(void)setURLRequests:(BOOL)URLRequest {
    if (URLRequest) {
        self.pathTextField.hidden = YES;
        self.preferanceRadioGroup.hidden = true;
        self.serviceIDAPI = NO;
        [self.selectMethodButton setTitle: self.methodNames[0] forState:UIControlStateNormal];
        self.selectedMethodIndex = 0;
    }
    else {
        self.pathTextField.hidden = NO;
        self.preferanceRadioGroup.hidden = false;
        self.serviceIDAPI = YES;
        [self.selectMethodButton setTitle: self.serviceIDAPINames[0] forState:UIControlStateNormal];
        self.selectedMethodIndex = 0;
    }
    self.selectedCacheOptionIndex = 0;
    [self.selectCacheOptionsButton setTitle:self.cacheOptions[0] forState:UIControlStateNormal];
    self.selectCacheOptionsButton.hidden = NO;
}

-(void)sendURLRequests:(NSString *)URLString {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlTextField.text]];
    
    switch (self.selectedMethodIndex) {
        case 0:
            
            @try {
                [self showIndicator];
                id<AIRESTClientProtocol>  restClient = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient createInstanceWithBaseURL:nil sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] withCachePolicy:self.selectedCacheOptionIndex];
                
                restClient.responseSerializer = [AIRESTClientHTTPResponseSerializer serializer];
                
                [restClient GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self hideIndicator];
                    if ([responseObject isKindOfClass:[NSData class]]) {
                        NSData * data = (NSData *)responseObject;
                        NSString * response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
                        [self showAlertWithMessage:response title:@"success"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self hideIndicator];
                    [self showAlertWithMessage:error.localizedDescription title:@"Error"];
                }];
            }
            @catch (NSException *exception) {
                [self hideIndicator];
                [self showAlertWithMessage:exception.reason title:@"Exception"];
            }
            break;
            
        case 1:
            @try {
                [self showIndicator];
                [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient POST:URLString parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self hideIndicator];
                    if ([responseObject isKindOfClass:[NSData class]]) {
                        NSData * data = (NSData *)responseObject;
                        NSString * response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
                        [self showAlertWithMessage:response title:@"success"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self hideIndicator];
                    [self showAlertWithMessage:error.localizedDescription title:@"Error"];
                }];
            }
            @catch (NSException *exception) {
                [self hideIndicator];
                [self showAlertWithMessage:exception.reason title:@"Exception"];
            }
            break;
            
        case 2:
            @try {
                [self showIndicator];
                [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient PUT:URLString parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self hideIndicator];
                    if ([responseObject isKindOfClass:[NSData class]]) {
                        NSData * data = (NSData *)responseObject;
                        NSString * response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
                        [self showAlertWithMessage:response title:@"success"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self hideIndicator];
                    [self showAlertWithMessage:error.localizedDescription title:@"Error"];
                }];
            }
            @catch (NSException *exception) {
                [self hideIndicator];
                [self showAlertWithMessage:exception.reason title:@"Exception"];
            }
            break;
            
        case 3:
            @try {
                [self showIndicator];
                [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient PATCH:URLString parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self hideIndicator];
                    if ([responseObject isKindOfClass:[NSData class]]) {
                        NSData * data = (NSData *)responseObject;
                        NSString * response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
                        [self showAlertWithMessage:response title:@"success"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self hideIndicator];
                    [self showAlertWithMessage:error.localizedDescription title:@"Error"];
                }];
            }
            @catch (NSException *exception) {
                [self hideIndicator];
                [self showAlertWithMessage:exception.reason title:@"Exception"];
            }
            break;
            
        case 4:
            @try {
                [self showIndicator];
                [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient DELETE:URLString parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self hideIndicator];
                    if ([responseObject isKindOfClass:[NSData class]]) {
                        NSData * data = (NSData *)responseObject;
                        NSString * response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
                        [self showAlertWithMessage:response title:@"success"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self hideIndicator];
                    [self showAlertWithMessage:error.localizedDescription title:@"Error"];
                }];
            }
            @catch (NSException *exception) {
                [self hideIndicator];
                [self showAlertWithMessage:exception.reason title:@"Exception"];
            }
            break;
            
        case 5:
            @try {
                [self showIndicator];
                NSURLSessionDownloadTask * downloadTask = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                    return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                    [self hideIndicator];
                    if (error == nil) {
                        NSString * responseString = [NSString stringWithFormat:@"%@",response];
                        [self showAlertWithMessage:responseString title:@"success"];
                    }
                    else {
                        [self showAlertWithMessage:error.localizedDescription title:@"Error"];
                    }
                }];
                [downloadTask resume];
            }
            @catch (NSException *exception) {
                [self hideIndicator];
                [self showAlertWithMessage:exception.reason title:@"Exception"];
            }
            break;
            
        case 6:
            [self showAlertWithMessage:@"Un supported" title:@"Alert"];
            break;
            
        case 7:
            @try {
                [self showIndicator];
                NSURL *filePath = [NSURL fileURLWithPath:[[NSBundle bundleForClass:self.class] pathForResource:@"TestFileForUpload" ofType:@"txt"]];
                NSURLSessionUploadTask *uploadTask = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                    [self hideIndicator];
                    if (error == nil) {
                        if ([responseObject isKindOfClass:[NSData class]]) {
                            NSData * data = (NSData *)responseObject;
                            NSString * response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
                            [self showAlertWithMessage:response title:@"success"];
                        }
                    }
                    else {
                        [self showAlertWithMessage:error.localizedDescription title:@"Error"];
                    }
                }];
                [uploadTask resume];
            }
            @catch (NSException *exception) {
                [self hideIndicator];
                [self showAlertWithMessage:exception.reason title:@"Exception"];
            }
            break;
            
        case 8:
            [self showAlertWithMessage:@"Un supported" title:@"Alert"];
            break;
            
        case 9:
            [self showAlertWithMessage:@"Un supported" title:@"Alert"];
            break;
            
        case 10:
            @try {
                [self showIndicator];
                NSMutableURLRequest *requestCache = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlTextField.text]];
                    requestCache.cachePolicy = self.selectedCacheOptionIndex;
                
                NSURLSessionDataTask *dataTask10 = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient dataTaskWithRequest:requestCache completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                    [self hideIndicator];
                    if (error == nil) {
                        if ([responseObject isKindOfClass:[NSData class]]) {
                            NSData * data = (NSData *)responseObject;
                            NSString * response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
                            [self showAlertWithMessage:response title:@"success"];
                        }
                    }
                    else {
                        [self showAlertWithMessage:error.localizedDescription title:@"Error"];
                    }
                }];
                [dataTask10 resume];
            }
            @catch (NSException *exception) {
                [self hideIndicator];
                [self showAlertWithMessage:exception.reason title:@"Exception"];
            }
            break;
            
        case 11:
            @try {
                [self showIndicator];
                NSMutableURLRequest *requestCache = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlTextField.text]];
                requestCache.cachePolicy = self.selectedCacheOptionIndex;
                
                NSURLSessionDataTask *dataTask11 = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient dataTaskWithRequest:requestCache uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                    [self hideIndicator];
                    if (error == nil) {
                        if ([responseObject isKindOfClass:[NSData class]]) {
                            NSData * data = (NSData *)responseObject;
                            NSString * response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
                            [self showAlertWithMessage:response title:@"success"];
                        }
                    }
                    else {
                        [self showAlertWithMessage:error.localizedDescription title:@"Error"];
                    }
                }];
                [dataTask11 resume];
            }
            @catch (NSException *exception) {
                [self hideIndicator];
                [self showAlertWithMessage:exception.reason title:@"Exception"];
            }
            break;
            
        default:
            [self showAlertWithMessage:@"Un supported" title:@"Alert"];
            break;
    }
}

-(void)sendServiceIDRequests:(NSString *)serviceID {
    switch (self.selectedMethodIndex) {
        case 0:
            @try {
                [self showIndicator];
                id<AIRESTClientProtocol>  restClient = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient createInstanceWithBaseURL:nil sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] withCachePolicy:self.selectedCacheOptionIndex];
                
                restClient.responseSerializer = [AIRESTClientHTTPResponseSerializer serializer];
                
                [restClient GETWithServiceID:serviceID preference:self.preference pathComponent:self.pathTextField.text serviceURLCompletion:nil parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self hideIndicator];
                    if ([responseObject isKindOfClass:[NSData class]]) {
                        NSData * data = (NSData *)responseObject;
                        NSString * response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
                        NSLog(@"response: %@", response);
                        [self showAlertWithMessage:response title:@"success"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self hideIndicator];
                    [self showAlertWithMessage:error.localizedDescription title:@"Error1"];
                    NSLog(@"aaaaaaaa");
                    NSLog(@"%@", error.localizedDescription);
                }];
            }
            @catch (NSException *exception) {
                [self hideIndicator];
                [self showAlertWithMessage:exception.reason title:@"Exception"];
            }
            break;
            
        case 1:
            @try {
                [self showIndicator];
                [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient HEADWithServiceID:serviceID preference:self.preference pathComponent:self.pathTextField.text serviceURLCompletion:nil parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task) {
                    [self hideIndicator];
                    [self showAlertWithMessage:@"Success" title:@"success"];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self hideIndicator];
                    [self showAlertWithMessage:error.localizedDescription title:@"Error"];
                }];
            }
            @catch (NSException *exception) {
                [self hideIndicator];
                [self showAlertWithMessage:exception.reason title:@"Exception"];
            }
            break;
        case 2:
            @try {
                [self showIndicator];
                [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient POSTWithServiceID:serviceID preference:self.preference pathComponent:self.pathTextField.text serviceURLCompletion:nil parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self hideIndicator];
                    if ([responseObject isKindOfClass:[NSData class]]) {
                        NSData * data = (NSData *)responseObject;
                        NSString * response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
                        [self showAlertWithMessage:response title:@"success"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self hideIndicator];
                    [self showAlertWithMessage:error.localizedDescription title:@"Error"];
                }];
            }
            @catch (NSException *exception) {
                [self hideIndicator];
                [self showAlertWithMessage:exception.reason title:@"Exception"];
            }
            break;
        case 3:
            @try {
                [self showIndicator];
                [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient PUTWithServiceID:serviceID preference:self.preference pathComponent:self.pathTextField.text serviceURLCompletion:nil parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self hideIndicator];
                    if ([responseObject isKindOfClass:[NSData class]]) {
                        NSData * data = (NSData *)responseObject;
                        NSString * response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
                        [self showAlertWithMessage:response title:@"success"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self hideIndicator];
                    [self showAlertWithMessage:error.localizedDescription title:@"Error"];
                }];
            }
            @catch (NSException *exception) {
                [self hideIndicator];
                [self showAlertWithMessage:exception.reason title:@"Exception"];
            }
            break;
        case 4:
            @try {
                [self showIndicator];
                [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient PATCHWithServiceID:serviceID preference:self.preference pathComponent:self.pathTextField.text serviceURLCompletion:nil parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self hideIndicator];
                    if ([responseObject isKindOfClass:[NSData class]]) {
                        NSData * data = (NSData *)responseObject;
                        NSString * response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
                        [self showAlertWithMessage:response title:@"success"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self hideIndicator];
                    [self showAlertWithMessage:error.localizedDescription title:@"Error"];
                }];
            }
            @catch (NSException *exception) {
                [self hideIndicator];
                [self showAlertWithMessage:exception.reason title:@"Exception"];
            }
            break;
        case 5:
            @try {
                [self showIndicator];
                [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient DELETEWithServiceID:serviceID preference:self.preference pathComponent:self.pathTextField.text serviceURLCompletion:nil parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self hideIndicator];
                    if ([responseObject isKindOfClass:[NSData class]]) {
                        NSData * data = (NSData *)responseObject;
                        NSString * response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
                        [self showAlertWithMessage:response title:@"success"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self hideIndicator];
                    [self showAlertWithMessage:error.localizedDescription title:@"Error"];
                }];
            }
            @catch (NSException *exception) {
                [self hideIndicator];
                [self showAlertWithMessage:exception.reason title:@"Exception"];
            }
            break;
        default:
            break;
    }
}

- (IBAction)sendButtonTapped:(id)sender {
    
    if (self.reachabilityManager.isReachable) {
        if ([self validateUI]) {
            NSString * URLString = self.urlTextField.text;
            if ([self.parameters allKeys].count > 0) {
                NSMutableURLRequest * getRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:self.parameters error:nil];
                URLString = getRequest.URL.absoluteString;
            }
            
            if (self.urlTextField.text.length > 0) {
                if (self.serviceIDAPI) {
                    [self sendServiceIDRequests:URLString];
                }
                else {
                    [self sendURLRequests:URLString];
                }
            }
        }
    }
    else {
        [self showAlertWithMessage:@"Internet not available" title:@"Error"];
    }
}

- (IBAction)checkThreadsButtonAction:(id)sender {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSLog(@"1st thread start");
        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient GET:@"https://www.oldchaphome.nl/RCT/test.php?action=timewithcache" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"1st thread success");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"1st thread fail");
        }];
    });
    
    dispatch_async(queue, ^{
        NSLog(@"2nd thread start");
        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient GET:@"https://www.oldchaphome.nl/RCT/test.php?action=timewithcache" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"2nd thread success");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"2nd thread fail");
        }];
    });
    
    dispatch_async(queue, ^{
        NSLog(@"3rd thread start");
        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient GET:@"https://www.oldchaphome.nl/RCT/test.php?action=timewithcache" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"3rd thread success");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"3rd thread fail");
        }];
    });
    
    dispatch_async(queue, ^{
        NSLog(@"4th thread start");
        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient GET:@"https://www.oldchaphome.nl/RCT/test.php?action=timewithcache" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"4th thread success");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"4th thread fail");
        }];
    });
    
    dispatch_async(queue, ^{
        NSLog(@"5th thread start");
        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient GET:@"https://www.oldchaphome.nl/RCT/test.php?action=timewithcache" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"5th thread success");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"5th thread fail");
        }];
    });
    
    dispatch_async(queue, ^{
        NSLog(@"6th thread start");
        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient GET:@"https://www.oldchaphome.nl/RCT/test.php?action=timewithcache" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"6th thread success");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"6th thread fail");
        }];
    });
    
    dispatch_async(queue, ^{
        NSLog(@"7th thread start");
        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient GET:@"https://www.oldchaphome.nl/RCT/test.php?action=timewithcache" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"7th thread success");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"7th thread fail");
        }];
    });
}

- (IBAction)userWantsToClearCache:(id)sender {
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.RESTClient clearCacheResponse];
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
    self.indicatorView.hidden = NO;
    [self.activityIndicator startAnimating];
}

-(void)hideIndicator {
    self.indicatorView.hidden = YES;
    [self.activityIndicator stopAnimating];
}

#pragma mark - PopOver


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[RestClientParamsViewController class]]) {
        RestClientParamsViewController * paramsVC = (RestClientParamsViewController *)segue.destinationViewController;
        [paramsVC setCompletionHandler:^(NSDictionary *params) {
            NSLog(@"%@",params);
            self.parameters = params;
        }];
        
    }
}

@end
