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
static NSString *const kPRXSectorKey = @"sector";
static NSString *const kPRXCatalogKey = @"catalog";
static NSString *const kPRXCtnsKey = @"ctns";
static NSString *const kPRXServiceURLErrorKey = @"Service URL not found";
static NSString *const kPRXClientKey = @"PRXClient";

static NSString *const kPRXSummaryPriceFormattedPrice = @"formattedPrice";
static NSString *const kPRXSummaryPriceDisplayPriceType = @"displayPriceType";
static NSString *const kPRXSummaryPriceCurrencyCode = @"currencyCode";
static NSString *const kPRXSummaryPriceFormattedDisplayPrice = @"formattedDisplayPrice";
static NSString *const kPRXSummaryPriceDisplayPrice = @"displayPrice";
static NSString *const kPRXSummaryPriceProductPrice = @"productPrice";

static NSString *const kPRXSummaryPRXResponseDataSuccess = @"success";
static NSString *const kPRXSummaryPRXResponseDataData = @"data";
static NSString *const kPRXSummaryInvalidCTNs = @"invalidCtns";

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

//Disclaimer constant
static NSString *const kPRXDisclaimers = @"disclaimers";
static NSString *const kPRXDisclaimer = @"disclaimer";
static NSString *const kPRXDisclaimerText = @"disclaimerText";
static NSString *const kPRXDisclaimerCode = @"code";
static NSString *const kPRXDisclaimerRank = @"rank";
static NSString *const kPRXDisclaimerReferenceName = @"referenceName";
static NSString *const kPRXDisclaimerDisclaimElements = @"disclaimElements";
static NSString *const kPRXDisclaimerBaseClassSuccess = @"success";
static NSString *const kPRXDisclaimerBaseClassData = @"data";

//Specifications constants
static NSString *const kPRXSpecificationsBaseClassData = @"data";
static NSString *const kPRXSpecificationsChapter = @"csChapter";
static NSString *const kPRXSpecificationsChapterCode = @"csChapterCode";
static NSString *const kPRXSpecificationsChapterName = @"csChapterName";
static NSString *const kPRXSpecificationsChapterRank = @"csChapterRank";
static NSString *const kPRXSpecificationsItem = @"csItem";
static NSString *const kPRXSpecificationsItemCode = @"csItemCode";
static NSString *const kPRXSpecificationsItemName = @"csItemName";
static NSString *const kPRXSpecificationsItemRank = @"csItemRank";
static NSString *const kPRXSpecificationsItemIsFreeFormat = @"csItemIsFreeFormat";
static NSString *const kPRXSpecificationsItemValue = @"csValue";
static NSString *const kPRXSpecificationsItemValueCode = @"csValueCode";
static NSString *const kPRXSpecificationsItemValueName = @"csValueName";
static NSString *const kPRXSpecificationsItemValueRank = @"csValueRank";
static NSString *const kPRXSpecificationsItemMeasure = @"unitOfMeasure";
static NSString *const kPRXSpecificationsItemMeasureCode = @"unitOfMeasureCode";
static NSString *const kPRXSpecificationsItemMeasureName = @"unitOfMeasureName";
static NSString *const kPRXSpecificationsItemMeasureSymbol = @"unitOfMeasureSymbol";

//Features constants
static NSString *const kPRXFeaturesBaseClassData = @"data";
static NSString *const kPRXFeaturesKeyBenefitArea = @"keyBenefitArea";
static NSString *const kPRXFeaturesKeyBenefitAreaCode = @"keyBenefitAreaCode";
static NSString *const kPRXFeaturesKeyBenefitAreaName = @"keyBenefitAreaName";
static NSString *const kPRXFeaturesKeyBenefitAreaRank = @"keyBenefitAreaRank";
static NSString *const kPRXFeaturesFeature = @"feature";
static NSString *const kPRXFeaturesFeatureCode = @"featureCode";
static NSString *const kPRXFeaturesFeatureReferenceName = @"featureReferenceName";
static NSString *const kPRXFeaturesFeatureName = @"featureName";
static NSString *const kPRXFeaturesFeatureLongDescription = @"featureLongDescription";
static NSString *const kPRXFeaturesFeatureGlossary = @"featureGlossary";
static NSString *const kPRXFeaturesFeatureRank = @"featureRank";
static NSString *const kPRXFeaturesFeatureTopRank = @"featureTopRank";
static NSString *const kPRXFeaturesFeatureHighlight = @"featureHighlight";
static NSString *const kPRXFeaturesFeatureHighlightRank = @"featureHighlightRank";
static NSString *const kPRXFeaturesCode = @"code";
static NSString *const kPRXFeaturesDescription = @"description";
static NSString *const kPRXFeaturesExtension = @"extension";
static NSString *const kPRXFeaturesExtent = @"extent";
static NSString *const kPRXFeaturesLastModified = @"lastModified";
static NSString *const kPRXFeaturesLocale = @"locale";
static NSString *const kPRXFeaturesNumber = @"number";
static NSString *const kPRXFeaturesType = @"type";
static NSString *const kPRXFeaturesAsset = @"asset";
