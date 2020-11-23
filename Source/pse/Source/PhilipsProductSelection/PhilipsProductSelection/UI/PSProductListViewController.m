//
//  PSProductListViewController.m
//  ProductSelection
//
//  Created by KRISHNA KUMAR on 29/01/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "PSProductListViewController.h"
#import "PSProductCell.h"
#import "PSProductUnavailableCell.h"
#import "PSConstants.h"
#import "PSProductDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PSHandler.h"
#import "PSUtility.h"
#import "PSAppInfraWrapper.h"
@import PhilipsUIKitDLS;
@import PhilipsPRXClient;
@import PhilipsIconFontDLS;

@interface PSProductListViewController ()<UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>
{
    BOOL isSearched;
}
@property (strong,nonatomic) NSArray *ctnList;
@property(strong,nonatomic) UIDSearchController *searchController;
@property (nonatomic, strong) NSArray *filteredProducts;
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;
@property (strong, nonatomic) UIDProgressIndicator *progressIndicator;
@end

@implementation PSProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=LOCALIZE(kFindProductTitle);
    _tblProductListTable.delegate=self;
    _tblProductListTable.dataSource=self;
    [[PSAppInfraWrapper sharedInstance] log:AILogLevelInfo  Event:@"Loading" Message:@"Displaying the list of products for user to select their product"];
    _tblProductListTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tblProductListTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    self.searchController = [[UIDSearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;
    isSearched = NO;
    self.tblProductListTable.tableHeaderView = self.searchController.searchBar;
    self.tblProductListTable.tableHeaderView.backgroundColor = [UIDThemeManager sharedInstance].defaultTheme.contentSecondary;
    [self updateTableViewWithProductList];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ((([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) && [self isKindOfClass:[PSProductListViewController class]] && [[NSUserDefaults standardUserDefaults] valueForKey:kSelectedProductKey])) {
        [PSHandler excecuteProductSelectionVCRemoveCompletionHandler:nil];
    }
    [super viewWillDisappear:animated];
}

- (void)updateTableViewWithProductList{
    [self startProgressIndicator];
    [PSHandler fetchProductDetailWithProductModelType:self.productModel andCompletionHandler:^(NSArray *summaryList) {
        [self stopProgressIndicator];
        if (summaryList) {
            self.filteredProducts = [summaryList mutableCopy];
            [self.tblProductListTable reloadData];
        }
        [[PSAppInfraWrapper sharedInstance] log:AILogLevelInfo  Event:@"Product list" Message:[NSString stringWithFormat:@"Found %lu Product in this region",(unsigned long)[self.filteredProducts count]]];
    }];
}

- (void)startProgressIndicator {
    self.progressIndicator = [[UIDProgressIndicator alloc]init];
    [self.progressIndicator setProgressIndicatorStyle:UIDProgressIndicatorStyleIndeterminate];
    self.progressIndicator.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
    self.progressIndicator.center = self.view.center;
    self.view.userInteractionEnabled = false;
    [self.view addSubview:self.progressIndicator];
    [self.progressIndicator startAnimating];
}

- (void)stopProgressIndicator {
    self.view.userInteractionEnabled = true;
    [self.progressIndicator stopAnimating];
    [self.progressIndicator removeFromSuperview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearched == YES && [self.filteredProducts count]==0) {
        return 1;
    }
    else
    {
        return [self.filteredProducts count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearched == YES && [self.filteredProducts count]==0)
        return 95.0;
    return kRowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isSearched == YES && [self.filteredProducts count]==0) {
        
        PSProductUnavailableCell *productCell=[_tblProductListTable dequeueReusableCellWithIdentifier:@"cellIdentifier"];
        if(productCell == nil)
        {
            NSArray *nib = [StoryboardBundle loadNibNamed:kProductUnavailableCell owner:self options:nil];
            productCell = [nib objectAtIndex:0];
        }
        [productCell setLayoutMargins:UIEdgeInsetsZero];
        productCell.contentView.backgroundColor = [UIDThemeManager sharedInstance].defaultTheme.contentPrimary;
        [productCell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        productCell.lblMessageTitle.text = [[LOCALIZE(kNoProduct) stringByAppendingString:@" "] stringByAppendingString:self.searchController.searchBar.text];
        [productCell.lblAlert setFont:[UIFont iconFontWithSize:22.0]];
        [productCell.lblAlert setTextColor:[UIDThemeManager sharedInstance].defaultTheme.buttonPrimaryFocusBackground];
        [productCell.lblAlert setText:[PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeInfoCircle]];
        [productCell.lblAlert setTextAlignment:NSTextAlignmentLeft];
        return productCell;
        
    }
    else
    {
        PSProductCell *productCell = [_tblProductListTable dequeueReusableCellWithIdentifier:kCellIdentifier];
        if(productCell == nil) {
            NSArray *nib = [StoryboardBundle loadNibNamed:kProductCell owner:self options:nil];
            productCell = [nib objectAtIndex:0];
        }
        PRXSummaryData *summaryData = [self.filteredProducts objectAtIndex:indexPath.row];
        productCell.lblProductTitle.numberOfLines = 3.0;
        [productCell.lblProductTitle text: summaryData.productTitle lineSpacing:5.0];
        productCell.lblProductCTN.text = summaryData.ctn;
        [[PSAppInfraWrapper sharedInstance] log: AILogLevelInfo
                                          Event: @"Product list"
                                        Message: [NSString stringWithFormat:@"%@ %@",summaryData.productTitle, summaryData.ctn]];
        productCell.lblProductCTN.textColor = TEXT_GRAY_CLR;
        [productCell.imgProductIcon setImageWithURLRequest: [NSURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:kImageURLFormat,summaryData.imageURL,productCell.imgProductIcon.frame.size.width ,productCell.imgProductIcon.frame.size.height]]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            productCell.imgProductIcon.image = image;
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            productCell.imgProductIcon.backgroundColor = [UIColor blackColor];
        }];
        [productCell setLayoutMargins:UIEdgeInsetsZero];
        productCell.contentView.backgroundColor = [UIDThemeManager sharedInstance].defaultTheme.contentPrimary;
        [productCell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [productCell.imgRightArrow setFont:[UIFont iconFontWithSize:18.0]];
        productCell.imgRightArrow.textColor = [UIDThemeManager sharedInstance].defaultTheme.buttonPrimaryFocusBackground;
        productCell.imgRightArrow.text = [PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeNavigationRight32];
        [productCell.imgRightArrow setTextAlignment:NSTextAlignmentRight];
        return productCell;
    }
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearched == YES && [self.filteredProducts count]==0)
        return;
    PRXSummaryData *responseData=[self.filteredProducts objectAtIndex:indexPath.row];
    [[PSAppInfraWrapper sharedInstance] log:AILogLevelInfo  Event:@"Product Selected:" Message:[NSString stringWithFormat:@"User clicked on %@ : %@ to see its detail",responseData.productTitle,responseData.ctn]];
    [[PSAppInfraWrapper sharedInstance].productSelectionTagging trackActionWithInfo:kSendData params:@{kSpecialEvent:kProductView,kProductsAction:[NSString stringWithFormat:@"%@;%@",responseData.productTitle,responseData.ctn]}];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kProductSelStoryboard bundle:StoryboardBundle];
    PSProductDetailsViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:kProductDetail];
    [detailViewController setSelectedProduct:responseData];
    [detailViewController setProductModel:self.productModel];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    isSearched = YES;
    NSString *searchText = searchController.searchBar.text;
    NSPredicate *searchSearch = [NSPredicate predicateWithFormat:@"self.productTitle CONTAINS[cd] %@ OR self.ctn CONTAINS[cd] %@", searchText,searchText];
    
    if(searchText == nil || [searchText isEqualToString:@""])
    {
        self.filteredProducts = [self getProductModelSelectionType].prxSummaryList;
    }
    else
    {
        self.filteredProducts = [[self getProductModelSelectionType].prxSummaryList filteredArrayUsingPredicate:searchSearch];
    }
    [self.tblProductListTable reloadData];
    
}

@end
