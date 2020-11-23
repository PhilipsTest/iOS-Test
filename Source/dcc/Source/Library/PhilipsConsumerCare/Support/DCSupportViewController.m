//
//  ViewController.m
//  DigitalCare
//
//  Created by sameer sulaiman on 05/12/14.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//
#import "DCSupportViewController.h"
#import "DCSupportTableViewCell.h"
#import "DCUtilities.h"
#import "DCPluginManager.h"
#import "UILabel+DCExternal.h"
#import "DCConstants.h"
#import "DCHandler.h"
#import "DCServiceTaskHandler.h"
#import "DCServiceTaskFactory.h"
#import "DCContactsRequestUrl.h"
#import "DCConsumerProductInformation.h"
#import "DCAppInfraWrapper.h"
#import "DCWebViewController.h"
@import PhilipsPRXClient;
#import <PlatformInterfaces/PlatformInterfaces-Swift.h>

static NSString*supportTableCellIdentifier = @"SupportCell";

@interface DCSupportViewController()
@property (weak, nonatomic) IBOutlet UIDLabel *howCanWeHelpLabel;
@property (nonatomic,weak) IBOutlet UITableView *supportTable;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation DCSupportViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self checkAndRefreshSavedProduct];
    [DCHandler setConsumerProductInfo:nil];
    self.dataArray = [NSMutableArray arrayWithArray:SharedInstance.supportConfig.supportConfigArray];
    self.title = SharedInstance.themeConfig.navigationBarTitleRequired? LOCALIZE(KSupport):nil;
    if(([self.productList.hardcodedProductListArray count]>1) && (![[NSUserDefaults standardUserDefaults] valueForKey:kSelectedProductCTN]))
        [self removeSelBtnWithTitle:KChangeSelectedProduct];
    [DCUtilities isNetworkReachable]?[self getSummaryData]:[self showError];
}

- (void)showError{
    [self.productList.hardcodedProductListArray count]<=1?[self removeSelBtnWithTitle:KChangeSelectedProduct]:nil;
    [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError paramKey:kTechnicalError andParamValue:kNETWORKERROR];
    [self noNetworkAlert];
    [self stopProgressIndicator];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-parameter"
- (void)noNetworkAlert{
    UIDAlertController * alertVC = [[UIDAlertController alloc] initWithTitle:LOCALIZE(KNONetwork) icon:nil message:nil];
    UIDAction *alertAction = [[UIDAction alloc] initWithTitle:LOCALIZE(kOKKEY) style:UIDActionStylePrimary handler:^(UIDAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:NO completion:^{}];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertVC addAction:alertAction];
    UIViewController *topVC = [DCUtilities topViewController:nil];
    [topVC presentViewController:alertVC animated:YES completion:nil];
}

- (void)supportResponseErrorAlert:(NSString*)msg{
    UIDAlertController * alertVC = [[UIDAlertController alloc] initWithTitle:msg icon:nil message:nil];
    UIDAction *alertAction = [[UIDAction alloc] initWithTitle:LOCALIZE(kOKKEY) style:UIDActionStylePrimary handler:^(UIDAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:NO completion:^{}];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertVC addAction:alertAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)removeSelBtnWithTitle:(NSString *)title{
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:[NSString stringWithFormat:@"%@ menu not available", title] Message:@"Product is not configure for multi product / no configured product available in region"];
    [self.dataArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if([[dict objectForKey:@"LocalizedKey"] isEqualToString:title])
            [self.dataArray removeObjectAtIndex:idx];
    }];
}

#pragma mark - Table view data source and delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return  kLastRowSpacing;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kSupportRowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIDHeaderView * headerView = [[UIDHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.supportTable.frame.size.width, kLastRowSpacing)];
        headerView.headerLabel.text = LOCALIZE(KHowCanWeHelp);
        headerView.headerLabel.numberOfLines=2;
        return headerView;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (NSInteger)self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DCSupportTableViewCell *supportCell = [tableView dequeueReusableCellWithIdentifier:supportTableCellIdentifier];
    if(supportCell != nil){
        NSDictionary *dict = [self.dataArray objectAtIndex:(NSUInteger)indexPath.row];
        [supportCell updateCellWithSupportData:LOCALIZE([dict objectForKey:kLocalizeKey]) andImage:[dict objectForKey:kIconName]];
        [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:[NSString stringWithFormat:@"%@ menu available",LOCALIZE([dict objectForKey:kLocalizeKey])] Message:@"Data available in PRX system"];
        supportCell.backgroundColor=[UIColor clearColor];
        supportCell.contentView.backgroundColor = [UIDThemeManager sharedInstance].defaultTheme.contentPrimary;
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor =  [UIDThemeManager sharedInstance].defaultTheme.listItemDefaultPressedBackground;
        [supportCell setSelectedBackgroundView:bgColorView];
    }
    return supportCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BOOL actionTaken=NO;
    NSDictionary *dict = [self.dataArray objectAtIndex:(NSUInteger)indexPath.row];
    NSString *title = [dict objectForKey:kLocalizeKey];
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"User clicked on button" Message:title];
    if([self.dCMenuDelegates respondsToSelector:@selector(mainMenuItemSelected:withIndex:)])
        actionTaken = [self.dCMenuDelegates mainMenuItemSelected:title withIndex:indexPath.row];
    if(!actionTaken){
        if([DCUtilities isNetworkReachable]){
            if([title isEqualToString:KChangeSelectedProduct] || ((![[NSUserDefaults standardUserDefaults] valueForKey:kSelectedProductCTN]) && [self.productList.hardcodedProductListArray count] > 1)){
                [self invokeProductSelection];
                return;
            }
                [self launchSupportStoryboard:title];
        }
        else if([title isEqualToString:KContactUs] && ([[NSUserDefaults standardUserDefaults] valueForKey:kSelectedProductCTN] || [self.productList.hardcodedProductListArray count] == 1))
            [self launchSupportStoryboard:title];
        else{
            [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError paramKey:kTechnicalError andParamValue:KNONetwork];
            [self noNetworkAlert];
        }
    }
    else
        [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"User control is changed:" Message:@"Control will got to Integrated app !!!"];
}
#pragma clang diagnostic pop

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"Loading" Message:@"Support view"];
    [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackPageWithInfo:kHomePage params:nil];
}

-(void)checkAndRefreshSavedProduct {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kSelectedProductCTN]) {
        NSString *savedHomeCountry = [[NSUserDefaults standardUserDefaults] valueForKey:kSelectedProductForCountryCTN];
        NSString *currentHomeCountry = [[DCAppInfraWrapper sharedInstance].appInfra.serviceDiscovery getHomeCountry];
        if (![savedHomeCountry isEqualToString:currentHomeCountry]) {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:kSelectedProductCTN];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:kSelectedProductForCountryCTN];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
}

// Invoking Product Selection  Library
- (void)invokeProductSelection{
    [self startProgressIndicator];
    [PSHandler setAppInfraTagging:[DCAppInfraWrapper sharedInstance].appInfra];
    SharedInstance.themeConfig.backGroundImage?[PSHandler setBackGroundImage:[UIImage imageNamed:SharedInstance.themeConfig.backGroundImage]]:nil;
    [PSHandler invokeProductSelectionWithParentController:self productModelSelection:self.productList andCompletionHandler:^(PRXSummaryData* selectedPRXSummary){
        [self stopProgressIndicator];
        if(selectedPRXSummary){
            NSString *homeCountry = [[DCAppInfraWrapper sharedInstance].appInfra.serviceDiscovery getHomeCountry];
            if (homeCountry.length > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:selectedPRXSummary.ctn forKey:kSelectedProductCTN];
                [[NSUserDefaults standardUserDefaults] setObject:homeCountry forKey:kSelectedProductForCountryCTN];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            [DCHandler setConsumerProductInfo:[[DCConsumerProductInformation alloc] initWithSummaryData:selectedPRXSummary withSector:self.productList.sector withCatalog:self.productList.catalog]];
            self.dataArray = [NSMutableArray arrayWithArray:SharedInstance.supportConfig.supportConfigArray];
            [self getServiceURLs];
        }
        else{
            if([self.productList.prxSummaryList count] == 0){
                [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"Error" Message:LOCALIZE(kNoProductErrorMessage)];
                [self supportResponseErrorAlert:LOCALIZE(kNoProductErrorMessage)];
                [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError paramKey:kTechnicalError andParamValue:kNETWORKERROR];
                [self updateUI];
            }
        }
    }];
}

# pragma mark - CDLS Request
- (void)sendPRXrequestWith:(NSString*)productCtn{
    if(![DCUtilities isNetworkReachable]){
        [self hideHUD];;
        return;
    }
    PRXSummaryRequest *summaryRequest=[[PRXSummaryRequest alloc] initWithSector:self.productList.sector ctnNumber:productCtn catalog:self.productList.catalog];
    PRXDependencies *prxDependencies = [[PRXDependencies alloc]init];
    prxDependencies.appInfra = [DCAppInfraWrapper sharedInstance].appInfra;
    PRXRequestManager *requestManager = [[PRXRequestManager alloc]initWithDependencies:prxDependencies];
    [self startProgressIndicator];
    [requestManager execute:summaryRequest completion:^(PRXResponseData *response) {
        PRXSummaryResponse *summaryResponse = (PRXSummaryResponse *)response;
        if(summaryResponse.success){
            PRXSummaryData *summaryData=summaryResponse.data;
            [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"Error prx response :" Message:[ NSString stringWithFormat:@"%@",summaryData]];
            [DCHandler setConsumerProductInfo:[[DCConsumerProductInformation alloc] initWithSummaryData:summaryData withSector:self.productList.sector withCatalog:self.productList.catalog]];
            [DCUtilities isNetworkReachable]?[self getServiceURLs]:[self showError];
        }
    } failure:^(NSError *error) {
        [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"Error prx response :" Message:[ NSString stringWithFormat:@"%@",error]];
        ServiceDiscoveryDict = nil;
        [self updateUI];
        [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError paramKey:kTechnicalError andParamValue:kNETWORKERROR];
    }];
}

-(void)updateUI{
    if(([self.productList.hardcodedProductListArray count]<=1))
        [self removeSelBtnWithTitle:KChangeSelectedProduct];
    NSMutableArray *deleteArray = [NSMutableArray array];
    if([[DCHandler getConsumerProductInfo] productCTN] == nil){
        for(NSUInteger i=0;i<[self.dataArray count];i++){
            NSDictionary *supportInfo = self.dataArray[i];
            NSString *localizedValue = supportInfo[@"LocalizedKey"];
            
            if([localizedValue isEqualToString:KViewProductInformation] ||
               [localizedValue isEqualToString:KReadFAQs] ||
               ([localizedValue isEqualToString:KChangeSelectedProduct] &&![[NSUserDefaults standardUserDefaults] valueForKey:kSelectedProductCTN]) ||
               ([localizedValue isEqualToString:KContactUs] &&[self noContactUsConfigData])) {
                
                NSString *eventStr = [NSString stringWithFormat:@"%@ menu not available",localizedValue];
                [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:eventStr Message:@"No data available in PRX"];
                [deleteArray addObject:supportInfo];
            }
        }
        [self.dataArray removeObjectsInArray:deleteArray];
    }
    (self.dataArray.count>0) ? [_supportTable reloadData] : [self showResponseError];
    [self hideHUD];
}

-(void)showResponseError{
    [_supportTable reloadData];
    [self supportResponseErrorAlert:LOCALIZE(kNOSUPPORT)];
}

- (BOOL)noContactUsConfigData{
    BOOL liveChatRequired = SharedInstance.socialConfig.liveChatRequired;
    if (((![DCHandler getConsumerProductInfo]) && ([SharedInstance.socialServiceProvidersConfig.socialServiceProvidersArray count] == 0)  && !liveChatRequired))
    {[[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"Contact us menu not available" Message:@"No contact us information found in backend"];
        return  YES;}
    return NO;
}

- (void)launchSupportStoryboard:(NSString*)title{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:title bundle:StoryboardBundle];
    DCBaseViewController *controller = [storyboard instantiateViewControllerWithIdentifier:title];
    controller.dCMenuDelegates = self.dCMenuDelegates;
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)isConsumerCareMenus{
    return YES;
}

- (void)updateSupportData:(NSInteger)index{
    [self.dataArray removeObjectAtIndex:(NSUInteger)index];
}

#pragma mark - ServiceDiscovery Call
-(void)getServiceURLs{
    [self startProgressIndicator];
    NSDictionary *map = @{@"productSector":[PRXRequestEnums stringWithSector:[[DCHandler getConsumerProductInfo] productSector]],@"productCatalog":[PRXRequestEnums stringWithCatalog:[[DCHandler getConsumerProductInfo] productCatalog]],@"appName":[DCUtilities appName]};
    [[DCAppInfraWrapper sharedInstance].appInfra.serviceDiscovery getServicesWithCountryPreference:@[kPRXCATEGORY,kSDEMAILFORMURL,KATOS,kCDLS,kPRODREVIEWURL,kSDFACEBOOKURL,kSDTWITTERURL,kSDLIVECHATURL] withCompletionHandler:^(NSDictionary<NSString*,AISDService*> *services,NSError *error)  {
        if(error==nil && services!=nil){
            ServiceDiscoveryDict = services;
            AISDService *service = services[@"cc.livechaturl"];
            [DCHandler setAppSpecificLiveChatURL:service.url];
            [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"ServiceDiscovery response :" Message:[NSString stringWithFormat:@"%@",[ServiceDiscoveryDict[kPRXCATEGORY] valueForKey:@"url"]]];
        }
        else{
            [DCHandler setConsumerProductInfo:nil];
            ServiceDiscoveryDict = nil;
            [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"Error ServiceDiscovery response :" Message:[error localizedDescription]];
            [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError paramKey:kTechnicalError andParamValue:kERRORRESPONSE];
        }
        [self updateUI];
    }replacement:map];
}
- (void)hideHUD{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopProgressIndicator];
    });
}

-(void)getSummaryData{
    if([self.productList.hardcodedProductListArray count] ==0)
        [NSException raise:@"Exception: Please provide atleast one valid CTN" format:@"Format: [hardcodedList setHardcodedProductListArray:@""]"];
    else{
        if([self.productList.hardcodedProductListArray count] == 1){
            [self sendPRXrequestWith:[self.productList.hardcodedProductListArray objectAtIndex:0]];
            [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"Requested CTN" Message:[self.productList.hardcodedProductListArray objectAtIndex:0]];
        }
        else{
            if([[NSUserDefaults standardUserDefaults] valueForKey:kSelectedProductCTN]) {
                [self sendPRXrequestWith:[[NSUserDefaults standardUserDefaults] valueForKey:kSelectedProductCTN]];
                [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"Selected CTN" Message:[[NSUserDefaults standardUserDefaults] valueForKey:kSelectedProductCTN]];
            }
            else
                [self hideHUD];
        }
    }
}

@end
