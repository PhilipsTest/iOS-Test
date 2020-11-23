//
//  DCFAQQuestionViewController.m
//  DigitalCareLibrary
//
//  Created by KRISHNA KUMAR on 06/04/16.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import "DCFAQQuestionViewController.h"
#import "DCUtilities.h"
#import "DCPluginManager.h"
#import "DCConstants.h"
#import "DCHandler.h"
#import "DCConsumerProductInformation.h"
#import "DCFAQCell.h"
#import "DCQuestionCell.h"
#import "UILabel+DCExternal.h"
#import "DCConstants.h"
#import "DCAppInfraWrapper.h"
#import "DCWebViewController.h"
@import PhilipsPRXClient;
@import PhilipsIconFontDLS;

#define kRowHeight 60

@interface DCFAQQuestionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *questionData;
    BOOL iSExpandedView,isReferesh;
    NSInteger selectedIndex;
}
@property(nonatomic,strong)NSMutableArray *tableData;
@end

@implementation DCFAQQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_tblQuestionList setSeparatorInset:UIEdgeInsetsZero];
    [_tblQuestionList setContentInset:UIEdgeInsetsMake(0,0,0,0)];
    selectedIndex=-1;
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"User viewing the screen" Message:@"FAQs"];
    _tblQuestionList.estimatedRowHeight=kRowHeight;
    _tblQuestionList.rowHeight = UITableViewAutomaticDimension;
    SharedInstance.themeConfig.navigationBarTitleRequired?[DCUtilities isIphone]?[self setTitle:LOCALIZE(KReadFAQs)]:[self setTitle:LOCALIZE(KFrequentlyAskedQuestions)]:nil;
    [DCUtilities isNetworkReachable]?[self sendPRXSupportRequest]:[self showNetworkError];
    self.tblQuestionList.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tblQuestionList.estimatedSectionHeaderHeight = 40;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackPageWithInfo:kFaqPage params:nil];
}

-(void) sendPRXSupportRequest
{
    __weak DCFAQQuestionViewController *faqQuestionVC=self;
    PRXSupportRequest *supportRequest=[[PRXSupportRequest alloc] initWithSector:[[DCHandler getConsumerProductInfo] productSector] ctnNumber:[[DCHandler getConsumerProductInfo] productCTN] catalog:[[DCHandler getConsumerProductInfo] productCatalog]];
    [self startProgressIndicator];
    PRXDependencies *prxDependencies = [[PRXDependencies alloc]init];
    prxDependencies.appInfra = [DCAppInfraWrapper sharedInstance].appInfra;
    PRXRequestManager *requestManager = [[PRXRequestManager alloc]initWithDependencies:prxDependencies];
    [requestManager execute:supportRequest completion:^(PRXResponseData *response) {
        PRXSupportResponse *responseData = (PRXSupportResponse *)response;
        responseData.success?[faqQuestionVC parseFAQFromResponse:responseData.data.richTexts.richText]:[faqQuestionVC showResponseError];
        [self stopProgressIndicator];
    } failure:^(NSError *error) {
        [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"Error:" Message:@"Error in prx summary"];
        [self stopProgressIndicator];
        [self faqErrorAlert:nil andMessage:[error localizedDescription]];
        [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError paramKey:kTechnicalError andParamValue:kNETWORKERROR];
    }];
}

-(void)showResponseError
{
    [self faqErrorAlert:LOCALIZE(kNOSUPPORT) andMessage:nil];
}

-(void)parseFAQFromResponse:(NSArray *)response
{
    self.tableData=[[NSMutableArray alloc] init];
    for(PRXFaqRichText *faqObject in response)
    {
        if([faqObject.supportType isEqualToString:@"FAQ"] || [faqObject.supportType isEqualToString:@"TUT"] || [faqObject.supportType isEqualToString:@"FEF"])
        {
            NSMutableArray *questionListArray=[[NSMutableArray alloc] initWithArray:[faqObject questionList]];
            for(PRXFaqItem *question in [faqObject questionList])
            {
                if([[[DCHandler getConsumerProductInfo] productLocale]hasPrefix:@"en_"])
                {
                    !([question.lang isEqualToString:@"AEN"] || [question.lang isEqualToString:@"ENG"])?[questionListArray removeObject:question]:nil;
                }
                else
                {
                    [question.lang isEqualToString:@"AEN"] || [question.lang isEqualToString:@"ENG"]?[questionListArray removeObject:question]:nil;
                }
            }
            [faqObject setQuestionList:questionListArray];
            [self.tableData addObject:faqObject];
        }
    }
    ([self.tableData count]<=0)?[self showResponseError]:[_tblQuestionList reloadData];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-parameter"
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (NSInteger)[self.tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(selectedIndex==section && iSExpandedView)
    {
        return (NSInteger)[[[self.tableData objectAtIndex:(NSUInteger)section] questionList] count];
    }
    else
    {
        if([[[self.tableData objectAtIndex:(NSUInteger)section] questionList] count] > 5)
            return 3;
        else
            return (NSInteger)[[[self.tableData objectAtIndex:(NSUInteger)section] questionList] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DCQuestionCell  *cell = [_tblQuestionList dequeueReusableCellWithIdentifier:kQuestionCellIdentifier];
    if(cell==nil){
        NSArray *topLevelObjects = [StoryboardBundle loadNibNamed:kQuestionCellIdentifier owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"Tapped on FAQ" Message:[[[[self.tableData objectAtIndex:(NSUInteger)indexPath.section] questionList]objectAtIndex:(NSUInteger)indexPath.row] head]];
    NSMutableAttributedString* attrString = [[NSMutableAttributedString  alloc] initWithString:[[[[self.tableData objectAtIndex:(NSUInteger)indexPath.section] questionList]objectAtIndex:(NSUInteger)indexPath.row] head]];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:5];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, attrString.length)];
    cell.contentView.backgroundColor = [UIDThemeManager sharedInstance].defaultTheme.contentPrimary;
    cell.lblQuestion.attributedText = attrString;
    [cell.lblImage setFont:[UIFont iconFontWithSize:18.0]];
    cell.lblImage.textColor = [UIDThemeManager sharedInstance].defaultTheme.buttonPrimaryFocusBackground;
    cell.lblImage.text = [PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeNavigationRight32];
    cell.lblQuestion.lineBreakMode = NSLineBreakByWordWrapping;
    cell.lblQuestion.numberOfLines = 0;
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [DCUtilities isNetworkReachable]?[self pushWebViewWithUrlString:[[[[self.tableData objectAtIndex:(NSUInteger)indexPath.section] questionList] objectAtIndex:(NSUInteger)indexPath.row] asset]]:[self showNetworkError];
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DCFAQCell *cell = [_tblQuestionList dequeueReusableCellWithIdentifier:kFAQCellIdentifier];
    if(cell==nil){
        NSArray *topLevelObjects = [StoryboardBundle loadNibNamed:kFAQCellIdentifier owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    cell.contentView.backgroundColor = [UIDThemeManager sharedInstance].defaultTheme.contentSecondaryBackground;
    cell.lblQuestionAndAnswer.text =[NSString stringWithFormat:@"%@ (%lu)",[[[self.tableData objectAtIndex:(NSUInteger)section] chapter] name],(unsigned long)[[[self.tableData objectAtIndex:(NSUInteger)section] questionList] count]];
    cell.lblQuestionAndAnswer.textColor = [UIDThemeManager sharedInstance].defaultTheme.contentItemTertiaryText;
    cell.lblQuestionAndAnswer.font = [[UIFont alloc] initWithUidFont:UIDFontBook size:14.0];
    UIDSeparator *seperator = [[UIDSeparator alloc] initWithFrame:CGRectMake(cell.contentView.frame.origin.x,cell.contentView.frame.size.height - 0.5f,cell.contentView.frame.size.width,1.0f)];
    seperator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [cell.contentView addSubview:seperator];
    [DCUtilities isDeviceLanguageRTL]?[self changeTextAlignment:cell.lblQuestionAndAnswer]:nil;
    UIDHyperLinkModel *hyperLinkModel = [[UIDHyperLinkModel alloc] init];
    [cell.lblDownIcon setText:LOCALIZE(KShowAll)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblDownIcon.tag = section;
    if(selectedIndex==section && iSExpandedView){
        [cell.lblDownIcon setText:LOCALIZE(KShowLess)];
        isReferesh=NO;
    }
    if([[[self.tableData objectAtIndex:(NSUInteger)section] questionList] count]<=5)
        cell.lblDownIcon.hidden = YES;
    else
        cell.lblDownIcon.hidden = NO;
    [cell.lblDownIcon addLink:hyperLinkModel handler:^(NSRange range) {
        [self sectionHeaderTapped:cell.lblDownIcon];
    }];
    return cell.contentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize constraintSize = {230.0, 20000}; //230 is cell width & 20000 is max height for cell
    CGRect textRect = [[NSString stringWithFormat:@"%@",[[[[self.tableData objectAtIndex:(NSUInteger)indexPath.section] questionList]objectAtIndex:(NSUInteger)indexPath.row] head]] boundingRectWithSize:constraintSize
                                                                                                                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                                                                                                                  attributes:@{NSFontAttributeName:[[UIFont alloc] initWithUidFont:UIDFontBook size:16.0]}
                                                                                                                                                                     context:nil];
    CGSize size = textRect.size;
    return MAX(45, size.height +33);
    
}

- (void)faqErrorAlert:(NSString*)title andMessage:(NSString*)msg{
    UIDAlertController * alertVC = [[UIDAlertController alloc] initWithTitle:title icon:nil message:msg];
    UIDAction *alertAction = [[UIDAction alloc] initWithTitle:LOCALIZE(kOKKEY) style:UIDActionStylePrimary handler:^(UIDAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:NO completion:^{}];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertVC addAction:alertAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma clang diagnostic pop

- (BOOL)allowsHeaderViewsToFloat{
    return NO;
}

#pragma mark - Table header gesture tapped

- (void)sectionHeaderTapped:(UIDHyperLinkLabel *)gestureRecognizer{
    if (iSExpandedView) {
        if(selectedIndex!=-1){
            if(selectedIndex == gestureRecognizer.tag)
                iSExpandedView=NO;
            else{
                iSExpandedView=YES;
                selectedIndex = gestureRecognizer.tag;
            }
        }
    }
    else{
        iSExpandedView=YES;
        selectedIndex = gestureRecognizer.tag;
    }
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [_tblQuestionList numberOfSections])];
    [_tblQuestionList beginUpdates];
    [_tblQuestionList reloadSections:sections withRowAnimation:UITableViewRowAnimationFade];
    [_tblQuestionList endUpdates];
}

-(void)pushWebViewWithUrlString:(NSString *)urlString{
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    DCWebViewController *controller = [DCWebViewController createWebViewForUrl:urlString andType:DCFAQDETAILS];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void) showNetworkError{
    [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError paramKey:kTechnicalError andParamValue:kNETWORKERROR];
    [self faqErrorAlert:LOCALIZE(KNONetwork) andMessage:nil];
}

-(void)changeTextAlignment:(UIDLabel *)textLabel{
    [textLabel setTextAlignment:NSTextAlignmentRight];
}
@end
