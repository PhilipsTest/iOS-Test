//
//  PSProductDetailsViewController.m
//  ProductSelection
//
//  Created by sameer sulaiman on 1/27/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "PSProductDetailsViewController.h"
#import "PSSelectedProductViewController.h"
#import "PSConstants.h"
#import "PSHandler.h"
#import "PSUtility.h"
#import "PSAppInfraWrapper.h"
#import "UIImageView+AFNetworking.h"
@import PhilipsUIKitDLS;
@import PhilipsIconFontDLS;
@import PhilipsPRXClient;
@interface PSProductDetailsViewController()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSInteger currentIndex;
    __weak IBOutlet UIDLabel *productCTN;
    __weak IBOutlet UIDLabel *productTitle;
}
@property(nonatomic, weak) IBOutlet UIDPageControl *pageControl;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(strong, nonatomic) NSMutableArray *prxAssetImageArray;
@property (weak, nonatomic) IBOutlet UIDButton *btnSelectProduct;
@property (nonatomic, weak)IBOutlet UIDProgressIndicator *progressIndicatorView;
@property (nonatomic, strong) UIView  *progressTransparentView;

@end

@implementation PSProductDetailsViewController

static NSString * const reuseIdentifier = @"ProductDetailsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALIZE(kProductDetailTitle);
    [[PSAppInfraWrapper sharedInstance] log:AILogLevelInfo
                                      Event: @"Loading" Message: @"Product detail screen is displayed to the user"];
    [self updateDetailsUI];
    [self fetchProductAsset];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[PSAppInfraWrapper sharedInstance].productSelectionTagging trackPageWithInfo: kDetailPage paramKey: nil andParamValue: nil];
}

- (void)updateDetailsUI {
    currentIndex = 0;
    productCTN.text=_selectedProduct.ctn;
    productTitle.text=_selectedProduct.productTitle;
    // Progress indicator transparent view
    self.progressTransparentView = [[UIView alloc]init];
    self.progressTransparentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.progressTransparentView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"H:|-0-[progressTransparentView]-0-|"
                                                                      options: NSLayoutFormatDirectionLeadingToTrailing
                                                                      metrics: nil
                                                                        views: @{@"progressTransparentView": self.progressTransparentView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|-0-[progressTransparentView]-0-|"
                                                                      options: NSLayoutFormatDirectionLeadingToTrailing
                                                                      metrics: nil
                                                                        views:@{@"progressTransparentView": self.progressTransparentView}]];
    self.progressTransparentView.backgroundColor = [UIColor clearColor];
    self.progressTransparentView.hidden = YES;
    self.pageControl.userInteractionEnabled = NO;
}

- (void)fetchProductAsset {
    PRXAssetRequest *assetRequest = [[PRXAssetRequest alloc] initWithSector: [self getProductModelSelectionType].sector
                                                                  ctnNumber: _selectedProduct.ctn
                                                                    catalog: [self getProductModelSelectionType].catalog];
    PRXDependencies *prxDependencies = [[PRXDependencies alloc] init];
    prxDependencies.appInfra = [PSAppInfraWrapper sharedInstance].appInfra;
    PRXRequestManager *requestManager = [[PRXRequestManager alloc] initWithDependencies: prxDependencies];
    [self startProgressIndicator];
    [requestManager execute:assetRequest completion:^(PRXResponseData *response) {
        PRXAssetResponse *responseData;
        
        if([response isKindOfClass:[PRXAssetResponse class]]) {
            responseData = (PRXAssetResponse *)response;
        }
        if(responseData.success) {
            [self processResponseData:(NSArray*)responseData.data.assets.asset];
            self.pageControl.currentPage = self->currentIndex;
        }
        [self stopProgressIndicator];
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        [self  stopProgressIndicator];
    }];
}

- (void)processResponseData: (NSArray*)assetsArray {
    self.prxAssetImageArray = [[NSMutableArray alloc]init];
    int count = 0;
    for (PRXAssetAsset *assetModel in assetsArray) {
        if([PSUtility isRequiredTypeImage: assetModel.type]){
            [self.prxAssetImageArray addObject: assetModel.asset];
            count ++;
        }
        if(count == 5)
            break;
    }
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.pageControl.numberOfPages = [self.prxAssetImageArray count];
    [_collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [[PSAppInfraWrapper sharedInstance] log: AILogLevelInfo  Event: @"Image Collection:"
                                    Message: [NSString stringWithFormat:@"found %lu images for this product", (unsigned long)self.prxAssetImageArray.count]];
    return self.prxAssetImageArray.count == 0 ? 1 : self.prxAssetImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath: indexPath];
    __weak UIImageView *productImage = (UIImageView*)[cell viewWithTag: 300];
    UIImage *placeHolderImage = [UIImage imageNamed: kNoProductImage
                                           inBundle: StoryboardBundle compatibleWithTraitCollection: nil];
    
    if(self.prxAssetImageArray.count > 0) {
        NSURL *imageURL = [NSURL URLWithString: [self getImageURL: [self.prxAssetImageArray objectAtIndex:indexPath.item]]];
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL: imageURL];
        
        [productImage setImageWithURLRequest: imageRequest
                            placeholderImage: placeHolderImage
                                     success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                         productImage.image = image;
                                     } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                         [productImage setBackgroundColor:[UIColor blackColor]];
                                     }];
    } else {
        productImage.image = placeHolderImage;
    }
    return  cell;
}

- (NSString*)getImageURL: (NSString*)url {
    NSString *imageurl = [url stringByReplacingOccurrencesOfString:@"content" withString:@"image"];
    CGSize imageSize = [self getSizeForImageThumnail];
    float width = imageSize.width;
    float height = imageSize.height;
    [[PSAppInfraWrapper sharedInstance] log:AILogLevelDebug
                                      Event:@"Image URL"
                                    Message: [NSString stringWithFormat:@"User seeing the image from URl %@", [NSString stringWithFormat: kImageURLFormat, imageurl, width, height]]];
    return [NSString stringWithFormat: kImageURLFormat, imageurl, width, height];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self getSizeForImageThumnail];
}

- (CGSize)getSizeForImageThumnail{
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    currentIndex = (int)round(scrollView.contentOffset.x/scrollView.frame.size.width);
    self.pageControl.currentPage = currentIndex;
    [[PSAppInfraWrapper sharedInstance] log:AILogLevelInfo  Event:@"Image Collection:"
                                    Message: [NSString stringWithFormat: @"User seeing the %lu image",(unsigned long)currentIndex+1]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SelectedProductIdentifier"]) {
        [[PSAppInfraWrapper sharedInstance] log: AILogLevelInfo
                                          Event: @"Clicked"
                                        Message: @"User clicked on the button \"Select this product\""];
        PSSelectedProductViewController *selectedViewController=segue.destinationViewController;
        [selectedViewController setProductModel:self.productModel];
        [[PSAppInfraWrapper sharedInstance].productSelectionTagging trackActionWithInfo: kSendData
                                                                               paramKey: kProductSelected
                                                                          andParamValue:_selectedProduct.productTitle];
        [selectedViewController setSelectedProductSummary: self.selectedProduct];
    }
}

#pragma  mark - Orientation Handlers

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.collectionView?[self.collectionView.collectionViewLayout invalidateLayout]:nil;
}

- (void)startProgressIndicator {
    [self.progressIndicatorView startAnimating];
    [self.view bringSubviewToFront:self.progressTransparentView];
    [self.view bringSubviewToFront:self.progressIndicatorView];
    [UIView animateWithDuration:0.5 animations:^{
        self.progressTransparentView.hidden = NO;
    }];
}

- (void)stopProgressIndicator {
    [self.progressIndicatorView stopAnimating];
    [UIView animateWithDuration:0.5 animations:^{
        self.progressTransparentView.hidden = YES;
    }];
}

- (void) dealloc{
    self.collectionView.delegate = nil;
    self.collectionView = nil;
}

@end
