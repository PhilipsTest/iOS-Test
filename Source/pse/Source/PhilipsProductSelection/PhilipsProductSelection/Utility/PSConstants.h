//
//  PSConstants.h
//  ProductSelection
//
//  Created by sameer sulaiman on 1/18/16.
//  Copyright © 2016 Philips. All rights reserved.
//

// Log

#import "PSConstants.h"
#import "PSUtility.h"

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...) do {} while (0);
#endif

#define TEXT_GRAY_CLR    ([UIColor colorWithRed:0.705 green:0.709 blue:0.713 alpha:1.0])

// Screen Constants

#define KSPLITVIEWWIDTH self.view.frame.size.width*0.4
#define kRowHeight 124

// Storyboard String Constants


static NSString *const kStoryBoardName = @"ProductSelection";
static NSString *const kProductBannerImage = @"bgProduct";
static NSString *const kNoProductImage = @"product_placeholder";
static NSString *const kSelectedProductKey= @"isProductSelected";
static NSString *const kSelectedProductCTN= @"selectedProductCTN";
static NSString *const kPSNavigation= @"PSNavigationVC";
static NSString *const kSelectYourProduct= @"SelectYourProduct";
static NSString *const kProductSelStoryboard= @"ProductSelection";
static NSString *const kProductListViewController = @"ProductList";
static NSString *const kSelectedProductViewController = @"SelectedProduct";
static NSString *const kConfirmationTitle = @"Confirmation_Title";
static NSString *const kSelectYourProductTitle = @"Select_Your_Product_Title";
static NSString *const kFindProductTitle= @"Find_Your_Product_Title";
static NSString *const kProductDetailTitle = @"Product_Detail_Title";
static NSString *const kNoProduct = @"No_Result";
static NSString *const kSupport= @"Support";
static NSString *const kSplitViewController = @"SplitViewController";
static NSString *const kCellIdentifier = @"ProductCellIdentifier";
static NSString *const kSplitViewContainer = @"PSSplitViewContainer";

static NSString *const kProductScreenTitle = @"Products";
static NSString *const kProductCell = @"PSProductCell";
static NSString *const kProductUnavailableCell = @"PSProductUnavailableCell";

static NSString *const kProductDetail = @"ProductDetails";

static NSString *const kImageURLFormat = @"%@?wid=%.f&hei=%.f&fit=fit,1";

//Macro for getting the localized string for the given key

#define StoryboardBundle [NSBundle bundleForClass:PSUtility.class]

#define LOCALIZE(key) NSLocalizedStringFromTableInBundle(key,nil,StoryboardBundle,@"Localized string not available")

static NSString *const kHomePage = @"productselection:home";
static NSString *const kProductsPage = @"productselection:home:productslist";
static NSString *const kDetailPage = @"productselection:home:productslist:productdetail";
static NSString *const kConfirmationPage = @"productselection:home:productslist:productdetail:confirmation";
static NSString *const kSendData = @"sendData";
static NSString *const kFindProductAction = @"findProduct";
static NSString *const kSpecialEvent = @"specialEvent";
static NSString *const kSetError = @"setError";
static NSString *const kNetworkError = @"networkError";
static NSString *const kTechnicalError = @"technicalError";
static int             kNotFoundError = 404;
static NSString *const kProductView = @"prodView";
static NSString *const kProductsAction = @"&&products";
static NSString *const kProductSelected = @"productSelected";
static NSString *const kContinueAction = @"continue";
static NSString *const kChangeProductAction = @"changeProduct";
static NSString *const kOK =@"OKMessage";
static NSString *const kNoNetwork = @"NOInternteError";
static NSString *const kPSInfoType = @"plist";
static NSString *const kPSInfoFile = @"PSInfo";
static NSString *const kPSIcon = @"PSIcon";
static NSString *const kVersionKey = @"PSVersion";
static NSString *const kProductSelectionKey =@"Product Selection";
