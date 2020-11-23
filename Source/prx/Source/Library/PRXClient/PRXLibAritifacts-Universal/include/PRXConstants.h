//
//  PRXConstants.h
//  PRXClient
//
//  Created by sameer sulaiman on 10/28/15.
//  Copyright (c) 2015 philips. All rights reserved.
//



// DLog

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...) do {} while (0);
#endif

//FAQ constants
static NSString *const kPRXFaqChapterReferenceName = @"referenceName";
static NSString *const kPRXFaqChapterCode = @"code";
static NSString *const kPRXFaqChapterName = @"name";
static NSString *const kPRXFaqChapterRank = @"rank";

static NSString *const kPRXFaqDataRichTexts = @"richTexts";

static NSString *const kPRXFaqItemCode = @"code";
static NSString *const kPRXFaqItemAsset = @"asset";
static NSString *const kPRXFaqItemLang = @"lang";
static NSString *const kPRXFaqItemRank = @"rank";
static NSString *const kPRXFaqItemHead = @"head";

static NSString *const kPRXFaqPRXResponseDataSuccess = @"success";
static NSString *const kPRXFaqPRXResponseDataData = @"data";

static NSString *const kPRXFaqRichTextType = @"type";
static NSString *const kPRXFaqRichTextChapter = @"chapter";
static NSString *const kPRXFaqRichTextItem = @"item";

static NSString *const kPRXFaqRichTextsRichText = @"richText";

//Summary Constants
static NSString *const kPRXSummaryBrandBrandLogo = @"brandLogo";

static NSString *const kPRXSummaryDataProductStatus = @"productStatus";
static NSString *const kPRXSummaryDataIsDeleted = @"isDeleted";
static NSString *const kPRXSummaryDataLeafletUrl = @"leafletUrl";
static NSString *const kPRXSummaryDataFamilyName = @"familyName";
static NSString *const kPRXSummaryDataAlphanumeric = @"alphanumeric";
static NSString *const kPRXSummaryDataProductPagePath = @"productPagePath";
static NSString *const kPRXSummaryDataDescriptor = @"descriptor";
static NSString *const kPRXSummaryDataBrand = @"brand";
static NSString *const kPRXSummaryDataCtn = @"ctn";
static NSString *const kPRXSummaryDataProductTitle = @"productTitle";
static NSString *const kPRXSummaryDataSubWOW = @"subWOW";
static NSString *const kPRXSummaryDataLocale = @"locale";
static NSString *const kPRXSummaryDataWow = @"wow";
static NSString *const kPRXSummaryDataImageURL = @"imageURL";
static NSString *const kPRXSummaryDataBrandName = @"brandName";
static NSString *const kPRXSummaryDataDomain = @"domain";
static NSString *const kPRXSummaryDataPriority = @"priority";
static NSString *const kPRXSummaryDataSubcategory = @"subcategory";
static NSString *const kPRXSummaryDataProductURL = @"productURL";
static NSString *const kPRXSummaryDataVersions = @"versions";
static NSString *const kPRXSummaryDataSop = @"sop";
static NSString *const kPRXSummaryDataCareSop = @"careSop";
static NSString *const kPRXSummaryDataMarketingTextHeader = @"marketingTextHeader";
static NSString *const kPRXSummaryDataSomp = @"somp";
static NSString *const kPRXSummaryDataEop = @"eop";
static NSString *const kPRXSummaryDataDtn = @"dtn";
static NSString *const kPRXSummaryDataPrice = @"price";
static NSString *const kPRXSummaryDataFilterKeys = @"filterKeys";

static NSString *const kPRXSummaryPriceFormattedPrice = @"formattedPrice";
static NSString *const kPRXSummaryPriceDisplayPriceType = @"displayPriceType";
static NSString *const kPRXSummaryPriceCurrencyCode = @"currencyCode";
static NSString *const kPRXSummaryPriceFormattedDisplayPrice = @"formattedDisplayPrice";
static NSString *const kPRXSummaryPriceDisplayPrice = @"displayPrice";
static NSString *const kPRXSummaryPriceProductPrice = @"productPrice";

static NSString *const kPRXSummaryPRXResponseDataSuccess = @"success";
static NSString *const kPRXSummaryPRXResponseDataData = @"data";

//Asset Constant
static NSString *const kPRXAssetAssetLocale = @"locale";
static NSString *const kPRXAssetAssetNumber = @"number";
static NSString *const kPRXAssetAssetExtent = @"extent";
static NSString *const kPRXAssetAssetLastModified = @"lastModified";
static NSString *const kPRXAssetAssetCode = @"code";
static NSString *const kPRXAssetAssetType = @"type";
static NSString *const kPRXAssetAssetDescription = @"description";
static NSString *const kPRXAssetAssetExtension = @"extension";
static NSString *const kPRXAssetAssetAsset = @"asset";

static NSString *const kPRXAssetAssetsAsset = @"asset";

static NSString *const kPRXAssetDataAssets = @"assets";

static NSString *const kPRXAssetBaseClassSuccess = @"success";
static NSString *const kPRXAssetBaseClassData = @"data";



