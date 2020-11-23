//
//  DCProductDetailsViewController.m
//  DigitalCare
//
//  Created by sameer sulaiman on 19/01/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//
#import "DCProductDetailsViewController.h"
#import "DCUtilities.h"
#import "UILabel+DCExternal.h"
#import "UIButton+DCExternal.h"
#import "UIImageView+DCExternal.h"
#import "DCConstants.h"
#import "DCPluginManager.h"
#import "DCCustomButtonCell.h"
#import "DCViewProductCollectionCell.h"
#import "DCHandler.h"
#import "DCConsumerProductInformation.h"
#import "UIImageView+AFNetworking.h"
#import "DCAppInfraWrapper.h"
#import "DCProductInformationTableViewCell.h"
#import "DCWebViewController.h"
@import AVFoundation;
@import AVKit;
@import PhilipsPRXClient;
@import PhilipsIconFontDLS;
@import SafariServices;

@interface DCProductDetailsViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSUInteger currentIndex;
    NSMutableArray *productDetails;
    NSString *videoName;
}
@property(nonatomic, weak) IBOutlet UIDLabel *productTitleLabel;
@property(nonatomic, weak) IBOutlet UIDLabel *productNOLabel;
@property(weak, nonatomic) IBOutlet UIImageView *productImage;
@property(weak, nonatomic) IBOutlet UIImageView *videoImage;
@property(weak, nonatomic) IBOutlet UIDButton *videoLeftArrow;
@property(weak, nonatomic) IBOutlet UIDButton *videoRightArrow;
@property(weak, nonatomic) IBOutlet UIDButton *videoPlayButton;
@property(weak, nonatomic) IBOutlet UITableView *tblProductMenu;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tblHeightConstraint;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property(nonatomic, strong) NSArray *prxAssetArray;
@property(nonatomic, strong) NSMutableArray *prxAssetVideoArray;
@property(nonatomic, strong) NSString *pdfLink;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property(nonatomic, strong) AVPlayerViewController *videoController;
- (IBAction)onVideoLeftTap:(id)sender;
- (IBAction)onVideoRightTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIDView *videoTitleView;

@end

@implementation DCProductDetailsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackPageWithInfo:kProductDetailsPage params:nil];
    self.title = SharedInstance.themeConfig.navigationBarTitleRequired? LOCALIZE(KViewProductInformation):nil;
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"User viewing the screen" Message:@"View product information"];
    self.productTitleLabel.text = [[DCHandler getConsumerProductInfo] productTitle];
    self.productNOLabel.text = [[DCHandler getConsumerProductInfo] productCTN];
    self.videoTitleView.backgroundColor = [UIDThemeManager sharedInstance].defaultTheme.contentSecondaryBackground;
    [self setVideoArrowIcons];
    _tblProductMenu.delegate=self;
    _tblProductMenu.dataSource=self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"DCViewProductCollectionCell" bundle:StoryboardBundle] forCellWithReuseIdentifier:@"VideoCollectionCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    ![DCUtilities isIphone]?[self.collectionView setPagingEnabled:NO]:nil;
    float height = [DCUtilities isIphone]?162:70;
    self.collectionViewHeightConstraint.constant = height;
    productDetails=[[NSMutableArray alloc] initWithArray:SharedInstance.productConfig.productConfigArray];
    [self.collectionView updateConstraintsIfNeeded];
    currentIndex = 0;
    [self.productImage imageWithURLString:[[DCHandler getConsumerProductInfo] productImageURL]
                              placeholder:[UIImage imageNamed:kImageThumbNail
                                                     inBundle:StoryboardBundle
                                compatibleWithTraitCollection:nil]
                               Completion:^(NSError *error) {
        [self.productImage setContentMode:UIViewContentModeScaleAspectFit];
        [self.productImage setClipsToBounds:YES];
        if(error){
            NSMutableDictionary *dataObj;
            dataObj=[NSMutableDictionary new];
            [dataObj setObject:kERRORLOADING forKey:kTechnicalError];
            [dataObj setObject:[[DCHandler getConsumerProductInfo] productImageURL] forKey:kURL];
            [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError params:dataObj];
        }
    }];
    [DCUtilities isNetworkReachable]?[self sendPRXAssetRequest]:[self showNetworkError];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void) showNetworkError{
    [self productDetailsAlertWithTitle:nil withMessage:LOCALIZE(KNONetwork) andBtnTitle:LOCALIZE(kOKKEY)];
    [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError
                                                                       paramKey:kTechnicalError
                                                                  andParamValue:kNETWORKERROR];
    return;
}

- (void)setVideoArrowIcons{
    [self.videoLeftArrow.titleLabel setFont:[UIFont iconFontWithSize:18.0]];
    [self.videoLeftArrow setTitle:[PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeNavigationLeft24] forState:UIControlStateNormal];
    [self.videoLeftArrow setTitleColor:[UIDThemeManager sharedInstance].defaultTheme.buttonPrimaryDisabledText  forState:UIControlStateDisabled];
    [self.videoRightArrow.titleLabel setFont:[UIFont iconFontWithSize:18.0]];
    [self.videoRightArrow setTitle:[PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeNavigationRight24] forState:UIControlStateNormal];
    [self.videoRightArrow setTitleColor:[UIDThemeManager sharedInstance].defaultTheme.buttonPrimaryDisabledText  forState:UIControlStateDisabled];
}

- (void)sendPRXAssetRequest{
    PRXAssetRequest *assetRequest=[[PRXAssetRequest alloc] initWithSector:[[DCHandler getConsumerProductInfo] productSector] ctnNumber:[[DCHandler getConsumerProductInfo] productCTN] catalog:[[DCHandler getConsumerProductInfo] productCatalog]];
    PRXDependencies *prxDependencies = [[PRXDependencies alloc]init];
    prxDependencies.appInfra = [DCAppInfraWrapper sharedInstance].appInfra;
    PRXRequestManager *requestManager = [[PRXRequestManager alloc]initWithDependencies:prxDependencies];
    [self startProgressIndicator];
    [requestManager execute:assetRequest completion:^(PRXResponseData *response) {
        PRXAssetResponse *responseData = (PRXAssetResponse *)response;
        if(responseData.success){
            self.prxAssetArray = (NSArray*)responseData.data.assets.asset;
            [self processResponseData:((NSArray*)responseData.data.assets.asset)];
        }
        else{
            [self hideViews];
            [self removeProductManual];
        }
        [self stopProgressIndicator];
    } failure:^(NSError *error) {
        [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"Error:" Message:@"PRX asset call error"];
        [self hideViews];
        [self removeProductManual];
        [self stopProgressIndicator];
        [self productDetailsAlertWithTitle:nil withMessage:[error localizedDescription] andBtnTitle:LOCALIZE(kOKKEY)];
        [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError paramKey:kTechnicalError andParamValue:kNETWORKERROR];
        return;
    }];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-parameter"
- (void)productDetailsAlertWithTitle:(NSString*)title withMessage:(NSString*)msg andBtnTitle:(NSString*)btn{
    UIDAlertController * productAlertVC = [[UIDAlertController alloc] initWithTitle:title icon:nil message:msg];
    UIDAction *productAction = [[UIDAction alloc] initWithTitle:btn style:UIDActionStylePrimary handler:^(UIDAction * _Nonnull action) {
        [productAlertVC dismissViewControllerAnimated:NO completion:^{}];
    }];
    [productAlertVC addAction:productAction];
    [self presentViewController:productAlertVC animated:YES completion:nil];
}

- (void) removeProductDetailsBtn:(NSString*)buttonTitle{
    [productDetails enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if([[dict objectForKey:@"LocalizedKey"] isEqualToString:buttonTitle])
            [self->productDetails removeObjectAtIndex:idx];
        [self.tblProductMenu reloadData];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if([DCUtilities isIphone]){
        NSInteger index = (NSInteger)(self.collectionView.contentOffset.x / self.collectionView.frame.size.width + 0.5);
        [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"Scroll Index:"
        Message:[NSString stringWithFormat:@"currentIndex in scrollview= %ld",(long)index]];
        self.pageControl.currentPage = (NSInteger)index;
        currentIndex = index;
        [self handleVideoArrows];
    }
}

- (IBAction)onVideoLeftTap:(id)sender{
    if(currentIndex > 0)
        currentIndex--;
    [self scrollCollectionViewVideoThumbnail];
}

- (IBAction)onVideoRightTap:(id)sender{
    if(currentIndex < ([self.prxAssetVideoArray count] -1))
        currentIndex++;
    [self scrollCollectionViewVideoThumbnail];
}

- (void) scrollCollectionViewVideoThumbnail{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(NSInteger)currentIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:YES];
    self.pageControl.currentPage = (NSInteger)currentIndex;
    [DCUtilities isIphone]?[self handleVideoArrows]:nil;
}

#pragma mark - Collection view data source & delegates
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return (NSInteger)[self.prxAssetVideoArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DCViewProductCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCollectionCell" forIndexPath:indexPath];
    [[cell videoPlayButton] addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    [cell videoPlayButton].tag = indexPath.row;
    if([self.prxAssetArray count]) {
        NSURL *videoURL = [NSURL URLWithString:[self getImageURL: [self.prxAssetVideoArray objectAtIndex:(NSUInteger)indexPath.item]]];
        NSURLRequest *videoURLRequest = [NSURLRequest requestWithURL:videoURL];
        [cell.videoImageView setImageWithURLRequest: videoURLRequest
                                   placeholderImage: nil
                                            success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            cell.videoImageView.image = image;
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            cell.videoImageView.backgroundColor = [UIColor blackColor];
        }];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self getSizeForVideoThumnail];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if([DCUtilities isIphone])
        return UIEdgeInsetsMake(0, 0, 0, 0);
    return UIEdgeInsetsMake(0, 0, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if(![DCUtilities isIphone])
        return 10;
    return 0;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)[productDetails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"CustomMenuCell";
    DCProductInformationTableViewCell *cell = (DCProductInformationTableViewCell *)[_tblProductMenu dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil){
        NSArray *nib = [StoryboardBundle loadNibNamed:@"DCProductInformationTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.contentView.backgroundColor = [UIDThemeManager sharedInstance].defaultTheme.contentPrimary;
    cell.lblMenuTitle.text = LOCALIZE([[productDetails objectAtIndex:(NSUInteger)indexPath.row] objectForKey:@"LocalizedKey"]);
    [cell.lblMenuImage setFont:[UIFont iconFontWithSize:18.0]];
    if([[[productDetails objectAtIndex:(NSUInteger)indexPath.row] objectForKey:@"LocalizedKey"] isEqualToString:@"ReadFAQs"]){
        [cell.lblMenuImage setText:[PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeNavigationRight24]];
    }
    else{
        [cell.lblMenuImage setText:[PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeLinkExternal]];
    }
    cell.lblMenuImage.textColor = [UIDThemeManager sharedInstance].defaultTheme.buttonPrimaryFocusBackground;
    cell.lblMenuTitle.textAlignment = NSTextAlignmentLeft;
    self.tblHeightConstraint.constant=_tblProductMenu.contentSize.height;
    [_tblProductMenu updateConstraintsIfNeeded];
    return cell;
}
#pragma clang diagnostic pop

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BOOL actionTaken=NO;
    NSDictionary *dict = [productDetails objectAtIndex:(NSUInteger)indexPath.row];
    NSString *title = [dict objectForKey:kLocalizeKey];
    if ([self.dCMenuDelegates respondsToSelector:@selector(productMenuItemSelected:)]){
        actionTaken = [[self.dCMenuDelegates performSelector:@selector(productMenuItemSelected:) withObject:title] boolValue];
    }
    if(!actionTaken){
        if(![DCUtilities isNetworkReachable]){
            [self showNetworkError];
        }
        else{
            SEL currentSEL= NSSelectorFromString([dict objectForKey:kLocalizeKey]);
            NSMethodSignature * methodSig= [[self class] instanceMethodSignatureForSelector: currentSEL];
            if(methodSig != nil){
                NSInvocation * invocation=[NSInvocation invocationWithMethodSignature:methodSig];
                [invocation setTarget: self];
                [invocation setSelector:currentSEL];
                [invocation invoke];
            }
        }
    }
}

- (void)createPRXVideoAssetArray{
    if(!self.prxAssetVideoArray)
        self.prxAssetVideoArray = [[NSMutableArray alloc] init];
}

- (void)processResponseData:(NSArray*)assetsArray{
    for (PRXAssetAsset *assetModel in assetsArray){
        if([assetModel.extension isEqualToString:@"pdf"]){
            if([assetModel.assetDescription isEqualToString:@"Quick start guide"])
                self.pdfLink = assetModel.asset;
            else if((self.pdfLink == nil) && [assetModel.assetDescription isEqualToString:@"User manual"]){
                self.pdfLink = assetModel.asset;
                [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"Product manual url" Message:self.pdfLink];
            }
        }
        if([assetModel.extension isEqualToString:@"mp4"]){
            [self createPRXVideoAssetArray];
            [self.prxAssetVideoArray addObject:assetModel.asset];
        }
    }
    if(!self.pdfLink){
        [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"Product manual not available"
                                        Message:@"No data available in PRX asset"];
        [self removeProductManual];
    }
    [self.prxAssetVideoArray count] >0?[self updateUI]:[self hideViews];
}

-(void) removeProductManual{
    [self removeProductDetailsBtn:@"productDownloadManual"];
}

- (void)hideViews{
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo
                                      Event:@"Removing the menu as it is not available in backend"
                                    Message:@"Product videos"];
    [self.collectionView setHidden:YES];
    [self.videoTitleView setHidden:YES];
    [self.videoLeftArrow setHidden:YES];
    [self.videoRightArrow setHidden:YES];
    [self.pageControl setHidden:YES];
}

- (void)updateUI{
    [self.collectionView reloadData];
    if(![DCUtilities isIphone]){
        [self.videoLeftArrow setHidden:YES];
        [self.videoRightArrow setHidden:YES];
        [self.pageControl setHidden:YES];
    }
    else
    {
        self.pageControl.numberOfPages = (NSInteger)[self.prxAssetVideoArray count];
        [self.prxAssetVideoArray count] == 1 ? ((void)([self.videoLeftArrow setHidden:YES]),[self.videoRightArrow setHidden:YES]):((void)([self.videoLeftArrow setHidden:NO]),[self.videoRightArrow setHidden:NO]);
    }
    
}

// Selector Invocation for pdf download
- (void) productDownloadManual{
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"Tapped on button" Message:@"Product manual"];
    [self launchProductInfoWebpage:DCPRODUCTMANUAL andURL:self.pdfLink];
}

// Selector Invocation for productInformationOnWebsite
- (void) productInformationOnWebsite{
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"Tapped on button" Message:@"Product information"];
    if([[DCHandler getConsumerProductInfo] productDomain] && [[DCHandler getConsumerProductInfo] productReviewURL]){
        [self launchProductInfoWebpage:DCPRODUCTINFO andURL:[NSString stringWithFormat:@"%@%@",[[DCHandler getConsumerProductInfo] productDomain],[[DCHandler getConsumerProductInfo] productReviewURL]]];
    }
    else{
        [self productDetailsAlertWithTitle:nil withMessage:LOCALIZE(KNoProductInfoAvailable) andBtnTitle:LOCALIZE(kERRORTITLE)];
    }
}

- (void)launchProductInfoWebpage:(DCWebViewType)type andURL:(NSString*)url{
    NSURL *urlObject = [[NSURL alloc] initWithString:url];
    if (urlObject != nil) {
        SFSafariViewController *viewController = [[SFSafariViewController alloc] initWithURL:urlObject];
        [self.navigationController presentViewController:viewController animated:true completion:^{
            DCWebViewModel *webViewModel = [DCWebViewModel getModelForType:type andUrl:url];
            [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kServiceRequest paramKey:kServiceChannel andParamValue:webViewModel.tagParamValue];
            [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackPageWithInfo:webViewModel.tagPageKey params:nil];
        }];
    }
}

// Selector Invocation for ReadFAQs
-(void) ReadFAQs{
    [self.navigationController pushViewController:[self getFAQViewController] animated:YES];
}

-(DCBaseViewController*)getFAQViewController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:KReadFAQs bundle:StoryboardBundle];
    DCBaseViewController *controller = [storyboard instantiateViewControllerWithIdentifier:KReadFAQs];
    controller.dCMenuDelegates = self.dCMenuDelegates;
    return controller;
}

- (CGSize)getSizeForVideoThumnail{
    if([DCUtilities isIphone])
        return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    return CGSizeMake(153, self.collectionView.frame.size.height);
}

- (void)handleVideoArrows{
    currentIndex == 0?[self.videoLeftArrow setEnabled:NO]:[self.videoLeftArrow setEnabled:YES];
    currentIndex == ([self.prxAssetVideoArray count] -1)?[self.videoRightArrow setEnabled:NO]:[self.videoRightArrow setEnabled:YES];
}

- (NSString*)getImageURL:(NSString*)url{
    NSString *imageurl = [url stringByReplacingOccurrencesOfString:@"content" withString:@"image"];
    CGSize imageSize = [self getSizeForVideoThumnail];
    NSString *width = [NSString stringWithFormat:@"%.0f", imageSize.width];
    NSString *height = [NSString stringWithFormat:@"%.0f", imageSize.height];
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"Scroll Index:" Message:[NSString stringWithFormat:@"%@?wid=%@&amp;hei=%@&amp;fit=crop&amp;$jpgsmall$",imageurl,width,height]];
    return [NSString stringWithFormat:@"%@?wid=%@&amp;hei=%@&amp;fit=crop&amp;$jpgsmall$",imageurl,width,height];
}

- (IBAction)playVideo:(UIDProgressButton *)sender {
    if(![DCUtilities isNetworkReachable]) {
        [self showNetworkError];
        return;
    }
    UIButton *button = (UIButton*)sender;
    NSInteger index = button.tag;
    sender.isActivityIndicatorVisible = true;
    videoName = [self.prxAssetVideoArray objectAtIndex:(NSUInteger)index];
    [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:KVIDEOSTART paramKey:KVIDEONAME andParamValue:videoName];
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"Video URL" Message:[self.prxAssetVideoArray objectAtIndex:(NSUInteger)index]];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *videoURL = [NSURL URLWithString:[self.prxAssetVideoArray objectAtIndex:(NSUInteger)index]];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoURL];
        AVAsset *asset = [AVAsset assetWithURL:videoURL];
        AVMutableVideoComposition *composition = [AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:asset];
        composition.renderScale = composition.renderScale/3;
        if (composition.renderSize.height > 0 && composition.renderSize.width > 0) {
            playerItem.videoComposition = composition;
        }
        
        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(itemDidFinishPlaying:)
                                                     name: AVPlayerItemDidPlayToEndTimeNotification
                                                   object: [player currentItem]];
        dispatch_async( dispatch_get_main_queue(), ^{
            self.videoController = [[AVPlayerViewController alloc]init];
            self.videoController.player = player;
            [self  presentViewController:self.videoController animated:YES completion:^{
                [self.videoController.player play];
                sender.isActivityIndicatorVisible = false;
            }];
        });
    });
}

- (void)itemDidFinishPlaying: (NSNotification *) notification {
    AVPlayerItem *playerItem = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    [self.videoController dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark - Orientation Handlers

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [DCUtilities isIphone] && [self.prxAssetVideoArray count]?[self scrollCollectionViewVideoThumbnail]:nil;
    self.collectionView?[self.collectionView.collectionViewLayout invalidateLayout]:nil;
}

- (void) dealloc{
    self.tblProductMenu.delegate = nil;
    self.tblProductMenu.dataSource = nil;
    self.collectionView.delegate = nil;
    self.collectionView = nil;
    self.videoController = nil;
}

@end
