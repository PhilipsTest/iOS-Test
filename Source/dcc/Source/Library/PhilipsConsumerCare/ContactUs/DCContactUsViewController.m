//
//  DCContactUsViewController.m
//  DigitalCare
//
//  Created by sameer sulaiman on 19/01/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import "DCContactUsViewController.h"
#import "DCUtilities.h"
#import <MessageUI/MessageUI.h>
#import "UILabel+DCExternal.h"
#import "UIButton+DCExternal.h"
#import "DCServiceTaskHandler.h"
#import "DCServiceTaskFactory.h"
#import "DCContactsRequestUrl.h"
#import <Accounts/Accounts.h>
#import "DCPluginManager.h"
#import "DCCustomButtonCell.h"
#import "DCHandler.h"
#import "DCConsumerProductInformation.h"
#import "DCCategoryRequestUrl.h"
#import "DCAppInfraWrapper.h"
#import "DCWebViewController.h"
#import "DCWebViewModel.h"
@import PhilipsIconFontDLS;

@interface DCContactUsViewController ()<MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    DCContactsModel *model;
    BOOL isCategory, tableHeader;
}
@property(nonatomic,weak)IBOutlet UIDButton *liveChatButton;
@property(nonatomic,weak)IBOutlet UIDButton *callButton;
@property (weak, nonatomic) IBOutlet UITableView *tblMenuItems;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *socialListTableHeightConstraint;
@property (strong, nonatomic) NSMutableArray *socialProvidersArray;
@property (weak, nonatomic) IBOutlet UITextView *detailTimeView;

-(IBAction)onCall:(id)sender;
@end

@implementation DCContactUsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self configureTimeDetailsUI];
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"User viewing the screen" Message:@"Contact us"];
    self.socialProvidersArray = [NSMutableArray arrayWithArray:SharedInstance.socialServiceProvidersConfig.socialServiceProvidersArray];
    [self updateSocialMenu];
    tableHeader = YES;
    if([[DCHandler getConsumerProductInfo] productSubCategory])
        [self getCategory];
    else
        [self disableUIComponents];
    self.title = SharedInstance.themeConfig.navigationBarTitleRequired? LOCALIZE(KContactUs):nil;
    if([self verifyLiveChatNotavailable]){
        [self.liveChatButton removeFromSuperview];
    }
    _tblMenuItems.delegate=self;
    _tblMenuItems.dataSource=self;
    isCategory = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackPageWithInfo:kContactUSPage params:nil];
}

-(void)configureTimeDetailsUI {
    self.detailTimeView.textColor = [UIDThemeManager sharedInstance].defaultTheme.labelValueText;
}

- (void) updateSocialMenu{
    if([ServiceDiscoveryDict[kSDEMAILFORMURL] valueForKey:@"url"] == nil)
        [self removeMenuItems:KSendEmail];
    if([self isFacebookURLEmpty])
        [self removeMenuItems:@"Facebook"];
    if([self isTwitterURLEmpty])
        [self removeMenuItems:@"Twitter"];
}

- (BOOL)isFacebookURLEmpty{
    return (([ServiceDiscoveryDict[kSDFACEBOOKURL] valueForKey:@"url"] == nil) && ((!SharedInstance.socialConfig.facebookProductPageID) || [SharedInstance.socialConfig.facebookProductPageID isEqualToString:@""]));
}

- (BOOL)isTwitterURLEmpty{
    return (([ServiceDiscoveryDict[kSDTWITTERURL] valueForKey:@"url"] == nil) && ((!SharedInstance.socialConfig.twitterPage) || [SharedInstance.socialConfig.twitterPage isEqualToString:@""]));
}

-(BOOL)verifyLiveChatNotavailable{
    BOOL chatVal = NO;
    NSString *serviceDiscUrl = [ServiceDiscoveryDict[kSDLIVECHATURL] valueForKey:@"url"];
    BOOL liveChatRequired = SharedInstance.socialConfig.liveChatRequired;
    NSString *chatURL = SharedInstance.socialConfig.liveChatUrl;
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"Service Discovery Chat URL" Message:serviceDiscUrl];
    if([DCHandler getAppSpecificLiveChatURL])
        chatVal = NO;
    else if(((serviceDiscUrl == nil) && ((!liveChatRequired) || (!chatURL) || [chatURL isEqualToString:@""])))
        chatVal = YES;
    return chatVal;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-parameter"
- (void) removeMenuItems:(NSString*)title{
    [self.socialProvidersArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if([[dict objectForKey:kLocalizeKey] isEqualToString:title]){
            [self.socialProvidersArray removeObjectAtIndex:idx];
            [self.tblMenuItems reloadData];
        }
    }];
}

- (IBAction)onCall:(id)sender{
    if(![DCUtilities isIphone]){
        [self contactUsAlertTitle:LOCALIZE(kERRORTITLE) message:LOCALIZE(KCallNotSupported) tag:0];
    }
    else if(model.phoneNumber){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"telprompt:"]]){
            [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kServiceRequest paramKey:kServiceChannel andParamValue:kCallNumber];
            [DCUtilities ccOpenURL:[self phoneNoURL]];
        }
    }
}

-(IBAction)onLiveChat:(id)sender{
    if(![DCUtilities isNetworkReachable]){
        [self contactUsAlertTitle:LOCALIZE(KNONetwork) message:nil tag:0];
        return;
    }
    else{
        if([[DCPluginManager sharedInstance].strHomeCountry isEqualToString:kCOUNTRYCHINA]){
            [self launchWebViewWithType:DCLIVECHAT andURL:[DCHandler getAppSpecificLiveChatURL]];
        }
        else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:KContactUs bundle:StoryboardBundle];
            UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ChatWithPhilips"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"User clicked on the button" Message:@"live chat"];
}

#pragma mark MFMailComposer Delegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSString *statusString;
    switch (result) {
        case MFMailComposeResultSaved:
            statusString = LOCALIZE(KMailSaved);
            break;
        case MFMailComposeResultCancelled:
            statusString = LOCALIZE(KMailCancelled);
            break;
        case MFMailComposeResultSent:
            [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kServiceRequest paramKey:kServiceChannel andParamValue:kEmail];
            statusString = LOCALIZE(KMailSuccessful);
            break;
        case MFMailComposeResultFailed:
            statusString = LOCALIZE(KMailFailed);
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self contactUsAlertTitle:statusString message:nil tag:0];
}

- (void)contactUsAlertTitle:(NSString*)title message:(NSString*)message tag:(NSUInteger)tag {
    UIDAlertController * contactAlert = [[UIDAlertController alloc] initWithTitle:title icon:nil message:message];
    UIDAction *contactAction = [[UIDAction alloc] initWithTitle:LOCALIZE(kOKKEY) style:UIDActionStylePrimary handler:^(UIDAction * _Nonnull action) {
        [contactAlert dismissViewControllerAnimated:NO completion:^{}];
        if(tag == 5)
            [self.navigationController popViewControllerAnimated:YES];
    }];
    [contactAlert addAction:contactAction];
    [self presentViewController:contactAlert animated:YES completion:nil];
}


-(void)LoadTwitterPostComposer{
    [self openTwitterWebPageOrApp];    
}

- (void)noTwitterAccountError{
    [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError paramKey:kUserError andParamValue:kNOTWITTER];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHUD];
        [self contactUsAlertTitle:LOCALIZE(KNoTwitterAccounts) message:LOCALIZE(KNoTwitterAccountDesc) tag:0];
    });
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)[self.socialProvidersArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0 &&  [self.socialProvidersArray count] >0 && tableHeader)
        return  kLastRowSpacing;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0 &&  [self.socialProvidersArray count] >0 && tableHeader){
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tblMenuItems.frame.size.width, kLastRowSpacing)];
        headerView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme.contentSecondaryBackground;
        UIDSeparator *seperator = [[UIDSeparator alloc] initWithFrame:CGRectMake(headerView.frame.origin.x,headerView.frame.origin.y,headerView.frame.size.width,1.0f)];
        seperator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [headerView addSubview:seperator];
        UIDLabel *headerLabel = [[UIDLabel alloc] initWithFrame:CGRectMake(headerView.frame.origin.x+16.0, headerView.frame.origin.y + 10.0f, self.tblMenuItems.frame.size.width-32.0, kLastRowSpacing-10.0f)];
        headerLabel.text = LOCALIZE(KSendUsMessage);
        headerLabel.labelType = UIDLabelTypeRegular;
        headerLabel.theme = UIDThemeManager.sharedInstance.defaultTheme;
        headerLabel.numberOfLines=2;
        headerLabel.textAlignment= NSTextAlignmentLeft;
        [headerView addSubview:headerLabel];
        return headerView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"CustomMenuCell";
    DCCustomButtonCell *cell = (DCCustomButtonCell *)[_tblMenuItems dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil){
        NSArray *nib = [StoryboardBundle loadNibNamed:@"CustomButtonView" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.lblMenuTitle.text = LOCALIZE([[self.socialProvidersArray objectAtIndex:(NSUInteger) indexPath.row] objectForKey:@"LocalizedKey"]);
    NSString *icon = [[DCUtilities dcMenuIconIcons] objectForKey:[[self.socialProvidersArray objectAtIndex:(NSUInteger) indexPath.row] objectForKey:@"IconName"]];
    [cell.lblMenuIcon setFont:[UIFont iconFontWithSize:26.0]];
    cell.lblMenuIcon.text = icon;
    cell.lblMenuIcon.textColor = [UIDThemeManager sharedInstance].defaultTheme.buttonSocialMediaPrimaryBackground;
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:[NSString stringWithFormat:@"%@ menu available",cell.lblMenuTitle.text] Message:@"Data available in backend system"];
    cell.imgIconForButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"images/%@",[[self.socialProvidersArray objectAtIndex:(NSUInteger) indexPath.row] objectForKey:@"IconName"]] inBundle:StoryboardBundle compatibleWithTraitCollection:nil];
    cell.contentView.backgroundColor = [UIDThemeManager sharedInstance].defaultTheme.contentPrimary;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIDThemeManager sharedInstance].defaultTheme.listItemDefaultPressedBackground;
    [cell setSelectedBackgroundView:bgColorView];
    CGRect frame = self.tblMenuItems.frame;
    frame.size.height = _tblMenuItems.contentSize.height;
    _tblMenuItems.frame=frame;
    [_tblMenuItems updateConstraintsIfNeeded];
    self.socialListTableHeightConstraint.constant=_tblMenuItems.contentSize.height;
    return cell;
}
#pragma clang diagnostic pop

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BOOL actionTaken=NO;
    NSDictionary *dict = [self.socialProvidersArray objectAtIndex:(NSUInteger) indexPath.row];
    NSString *title = [dict objectForKey:kLocalizeKey];
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"User clicked on the button" Message:[dict objectForKey:kLocalizeKey]];
    if ([self.dCMenuDelegates respondsToSelector:@selector(socialMenuItemSelected:)])
        actionTaken = [[self.dCMenuDelegates performSelector:@selector(socialMenuItemSelected:) withObject:title] boolValue];
    if(!actionTaken){
        if(![DCUtilities isNetworkReachable]){
            [self contactUsAlertTitle:LOCALIZE(KNONetwork) message:nil tag:0];
            return;
        }
        else
            [self OpenContactUS:title];
    }
}

# pragma mark - Category request

-(void)getCategory{
    if([ServiceDiscoveryDict[kPRXCATEGORY] valueForKey:@"url"]!=nil){
        [self startProgressIndicator];
        DCServiceTaskHandler *handler = [self getCategoryTaskhandler];
        handler.completionBlock = ^(id response){
            [self receiveCategoryResponse:response];
        };
        handler.exceptionBlock = ^(id response){
            [self handleError:response];
        };
        [handler initializeTaskHandler];
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHUD];
        });
        [self contactUsAlertTitle:LOCALIZE(kNOSERVICEURLAVAILABLE) message:nil tag:5];
    }
}

- (DCServiceTaskHandler*)getCategoryTaskhandler{
    DCServiceTaskFactory *factory = [[DCServiceTaskFactory alloc] init];
    DCCategoryRequestUrl *request = [[DCCategoryRequestUrl alloc] init];
    request.subUrl = [[ServiceDiscoveryDict[kPRXCATEGORY] valueForKey:@"url"] stringByReplacingOccurrencesOfString:@"%productSubCategory%" withString:[[DCHandler getConsumerProductInfo] productSubCategory]];
    request.parserType = kCategoryParser;
    return [factory getInstanceforRequest:request];
}

- (void) handleError:(id)errorResponse{
    NSString *errorMsg ;
    NSInteger errorStatus = 0;
    if([errorResponse isKindOfClass:[NSError class]]){
        errorMsg = [errorResponse localizedDescription];
        errorStatus = [errorResponse code];
    }
    else
        errorMsg = errorResponse;
    [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError paramKey:kTechnicalError andParamValue:errorMsg];
    [self hideHUD];
    if(errorStatus == kNoNetworkStatus){
        [self contactUsAlertTitle:LOCALIZE(KNONetwork) message:nil tag:5];
        [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError paramKey:kTechnicalError andParamValue:kNETWORKERROR];
    }
}

-(void)receiveCategoryResponse:(id)response{
    DCCategoryModel *categoryModel=(DCCategoryModel *)response;
    if(categoryModel.success){
        [self hideHUD];
        [[DCHandler getConsumerProductInfo] setProductCategory:categoryModel.productCategory];
    }
    else if (categoryModel.exceptionMessage){
        [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError paramKey:kTechnicalError andParamValue:model.exceptionMessage];
        [self hideHUD];
    }
    [self sendCDLSSubcategoryCall];
}

- (void)sendCDLSSubcategoryCall{
    [[DCHandler getConsumerProductInfo] productSubCategory]?[self sendCDLSRequestWith:[[DCHandler getConsumerProductInfo] productSubCategory]]:nil;
}

# pragma mark - CDLS Request
- (void)sendCDLSRequestWith:(NSString*)category{
    if([ServiceDiscoveryDict[kCDLS] valueForKey:@"url"]!=nil){
        [self startProgressIndicator];
        DCServiceTaskHandler *handler = [self getCDLSTaskhandler:category];
        handler.completionBlock = ^(id response){
            [self receiveResponse:response];
        };
        handler.exceptionBlock = ^(id response){
            [self disableUIComponents];
            [self handleError:response];
        };
        [handler initializeTaskHandler];
    }
    else{
        [self hideHUD];
        [self contactUsAlertTitle:LOCALIZE(kNOSERVICEURLAVAILABLE) message:nil tag:5];
    }
}

- (DCServiceTaskHandler*)getCDLSTaskhandler:(NSString*)category{
    DCServiceTaskFactory *factory = [[DCServiceTaskFactory alloc] init];
    DCContactsRequestUrl *contRequest = [[DCContactsRequestUrl alloc] init];
    category ? contRequest.productCategory = category:nil;
    contRequest.subUrl = [ServiceDiscoveryDict[kCDLS] valueForKey:@"url"];
    contRequest.parserType = kContactsParser;
    return [factory getInstanceforRequest:contRequest];
}

# pragma mark - CDLS Response
- (void)receiveResponse:(id)response{
    [self hideHUD];
    model = (DCContactsModel*)response;
    if(model.success == true){
        isCategory = NO;
        if(model.phoneNumber){
            tableHeader = YES;
            [self.callButton setTitle:[NSString stringWithFormat:@"%@ %@",LOCALIZE(kCallNumber),model.phoneNumber] forState:UIControlStateNormal];
        }
        else{
            [self.callButton removeFromSuperview];
            self.callButton.alpha = 0.6f;
        }
        [self setupTimeDetailView];
    }
    else if(model.success == false && !isCategory){
        isCategory = YES;
        [[DCHandler getConsumerProductInfo] productCategory]?[self sendCDLSRequestWith:[[DCHandler getConsumerProductInfo] productCategory]]:nil;
    }
    else if (model.exceptionMessage){
        [self disableUIComponents];
        [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"The contact us request response is" Message:@"No contact info available from CDLS Server"];
        [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError paramKey:kTechnicalError andParamValue:model.exceptionMessage];
    }
}

- (void) removeTableHeader{
    if(!SharedInstance.socialConfig.liveChatRequired){
        tableHeader = NO;
        [self.tblMenuItems reloadData];
    }
}

- (void)setupTimeDetailView {
    NSString *formatedText = [self formattedTimeDetailsString];
    if(formatedText.length != 0){
        tableHeader = YES;
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
        paragraph.lineSpacing = 10;
        NSDictionary *attributedOptions = @{NSForegroundColorAttributeName:self.detailTimeView.textColor,
                                            NSParagraphStyleAttributeName:paragraph
                                            };
        NSMutableAttributedString *formattedAttributedText = [self getFormattedTimeStringFor:formatedText];
        NSRange textRange = NSMakeRange(0, formattedAttributedText.mutableString.length);
        [formattedAttributedText addAttributes:attributedOptions range:textRange];
        self.detailTimeView.attributedText = formattedAttributedText;
    }
}

- (NSMutableAttributedString *)getFormattedTimeStringFor:(NSString *)text {
    UIFont *font = self.detailTimeView.font;
    NSString *timeWithNewFont = [text stringByAppendingString:[NSString stringWithFormat:@"<style>* {font-family: '%@'; font-size:%fpx;}</style>", font.familyName, font.pointSize]];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithData:[timeWithNewFont dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    return attributedText;
}

- (void)disableUIComponents{
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"User cannot see CALL button" Message:@"No data available in CDLS system"];
    [self.callButton removeFromSuperview];
    [self.detailTimeView setHidden:YES];
    [self removeTableHeader];
}

-(NSURL*)phoneNoURL{
    NSString *cleanedString = [[model.phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"User clicked on the button" Message:[NSString stringWithFormat:@"call %@",escapedPhoneNumber]];
    NSString *phoneURLString = [NSString stringWithFormat:@"telprompt:%@", escapedPhoneNumber];
    return [NSURL URLWithString:phoneURLString];
}

-(void)sendEmail{
    if(![DCUtilities isNetworkReachable]){
        [self contactUsAlertTitle:LOCALIZE(KNONetwork) message:nil tag:0];
        return;
    }
    else
        [self launchWebViewWithType:DCEMAIL andURL:[self getEmailServiceUrl]];
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"User clicked on the button" Message:@"send email"];
}

- (void)launchWebViewWithType:(DCWebViewType)type andURL:(NSString*)url{
    DCWebViewController *controller = [DCWebViewController createWebViewForUrl:url andType:type];
    [self.navigationController pushViewController:controller animated:YES];
}

-(NSString*) getEmailServiceUrl{
    if([ServiceDiscoveryDict[kSDEMAILFORMURL] valueForKey:@"url"]!=nil){
        NSString *urlString = [ServiceDiscoveryDict[kSDEMAILFORMURL] valueForKey:@"url"];
        if([[DCHandler getConsumerProductInfo] productCategory]!=nil){
            urlString = [urlString stringByReplacingOccurrencesOfString:@"%productCategory%" withString:[[DCHandler getConsumerProductInfo] productCategory]];
        }
        else{
            urlString = [urlString stringByReplacingOccurrencesOfString:@"%productCategory%" withString:@""];
        }
        return [DCUtilities urlEncode:urlString];
    }
    else{
        [self contactUsAlertTitle:LOCALIZE(kNOSERVICEURLAVAILABLE) message:nil tag:0];
        return nil;
    }
}

- (void)openSettings{
    NSURL *settings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settings]){
        [DCUtilities ccOpenURL:settings];
        [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kExitLink paramKey:kExitLinkName andParamValue:[NSString stringWithFormat:@"%@",settings]];
    }
}

-(void)OpenContactUS:(NSString *)title{
    if([title rangeOfString:@"facebook" options:NSCaseInsensitiveSearch].location!=NSNotFound){
        // This will launch Facebook Webpage or Native Facebook App
        NSURL *url = [self getFacebookProfileURL];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]])
            [DCUtilities ccOpenURL:url];
        else
            [self launchWebViewWithType:DCFACEBOOK andURL:[self getFacebookURL]];
    }
    else if([title rangeOfString:@"twitter" options:NSCaseInsensitiveSearch].location!=NSNotFound)
        [self LoadTwitterPostComposer];
    else if([title rangeOfString:@"email" options:NSCaseInsensitiveSearch].location!=NSNotFound)
        [self sendEmail];
}

-(NSURL*)getFacebookProfileURL{
    NSString *urlString;
    if([ServiceDiscoveryDict[kSDFACEBOOKURL] valueForKey:@"url"] != nil)
        urlString = [NSString stringWithFormat:@"fb://profile/%@",[[NSURL URLWithString:[ServiceDiscoveryDict[kSDFACEBOOKURL] valueForKey:@"url"]] lastPathComponent]];
    else{
        urlString = [NSString stringWithFormat:@"fb://profile/%@",SharedInstance.socialConfig.facebookProductPageID];
    }
    return [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
}

- (NSString*)getFacebookURL{
    return [ServiceDiscoveryDict[kSDFACEBOOKURL] valueForKey:@"url"]?[ServiceDiscoveryDict[kSDFACEBOOKURL] valueForKey:@"url"]:[NSString stringWithFormat:@"%@%@",kFacebookURL,SharedInstance.socialConfig.facebookProductPageID];
}

- (void)openTwitterWebPageOrApp{
    NSString *contentStr = [DCUtilities urlEncode:[NSString stringWithFormat:@"%@ %@ %@ %@",[DCUtilities getTwitterPageName],LOCALIZE(KcanYouHelpMeWithMy),[[DCHandler getConsumerProductInfo] productTitle],[[DCHandler getConsumerProductInfo] productCTN]]];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]){
        NSURL *twitterAppUrl = [NSURL URLWithString:[DCUtilities urlEncode:[NSString stringWithFormat:@"twitter://post?message=%@",contentStr]]];
        [DCUtilities ccOpenURL:twitterAppUrl];
    }
    else
        [self launchWebViewWithType:DCTWITTER andURL:[NSString stringWithFormat:@"https://twitter.com/intent/tweet?source=webclient&text=%@",contentStr]];
}

- (void)hideHUD{
    [self stopProgressIndicator];
}

-(NSString *)formattedTimeDetailsString{
    return [NSString stringWithFormat:@"%@%@%@%@%@%@",
            (model.openingHoursWeekdays.length != 0)?[NSString stringWithFormat:@"%@<br>",model.openingHoursWeekdays]:@"",
            (model.openingHoursSaturday.length != 0)?[NSString stringWithFormat:@"%@<br>",model.openingHoursSaturday]:@"",
            (model.openingHoursSunday.length!=0)?[NSString stringWithFormat:@"%@<br>",model.openingHoursSunday]:@"",
            (model.optionalData1.length!=0)?[NSString stringWithFormat:@"%@<br>",model.optionalData1]:@"",
            (model.optionalData2.length!=0)?[NSString stringWithFormat:@"%@<br>",model.optionalData2]:@"",
            (model.phoneTariff.length!=0)?[NSString stringWithFormat:@"%@",model.phoneTariff]:@""];
}

@end
