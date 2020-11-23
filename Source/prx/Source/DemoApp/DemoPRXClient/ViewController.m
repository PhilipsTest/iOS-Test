//
//  ViewController.m
//  DemoPRXClient
//
//  Created by sameer sulaiman on 10/22/15.
//  Copyright © 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import "ViewController.h"
#import <AppInfra/AppInfra.h>

#import "PRXRequestManager.h"
#import "PRXResponseData.h"

#import "PRXAssetResponse.h"
#import "PRXAssetData.h"
#import "PRXAssetRequest.h"
#import "PRXAssetAssets.h"
#import "AssetsViewController.h"

#import "PRXSummaryData.h"
#import "PRXSummaryRequest.h"
#import "PRXSummaryResponse.h"
#import "PRXSummaryListRequest.h"
#import "PRXSummaryListResponse.h"

#import "SummaryViewController.h"


#import "SupportViewController.h"
#import "PRXSupportResponse.h"
#import "PRXFaqRichTexts.h"
#import "PRXFaqRichText.h"
#import "PRXFaqData.h"
#import "PRXSupportRequest.h"
#import "AppDelegate.h"

@import PhilipsUIKitDLS;
@interface ViewController ()<UIPickerViewDelegate, UIPickerViewDataSource> {
    AssetsViewController *detailVC;
    SummaryViewController *summeryVC;
    SupportViewController *supportVC;
    id <AIAppInfraProtocol>appInfra;
    id <AILoggingProtocol>logging;
    NSDictionary *countries;
    PRXRequestManager *requestManager;
    NSOperationQueue *queue;
    UIActivityIndicatorView *activityIndicator;
}
@property (weak, nonatomic) IBOutlet UIView *assetViewController;
@property (weak, nonatomic) IBOutlet UIView *summeryViewController;
@property (weak, nonatomic) IBOutlet UIView *supportViewController;

@property (strong, nonatomic) NSArray * sectors;
@property (weak, nonatomic) IBOutlet UIDButton *selectSectorButton;
@property (weak, nonatomic) IBOutlet UIDTextField *ctnNoTextField;
@property (weak, nonatomic) IBOutlet UIDButton *selectCatalogButton;
@property (weak, nonatomic) IBOutlet UIDButton *countryButton;

@property (strong, nonatomic) UIDPickerView *countryPopover;
@property (strong, nonatomic) UIDPickerView *catalogPopOver;
@property (strong, nonatomic) UIDPickerView *sectorPopOver;

@property (strong, nonatomic) NSArray * catalogs;
@property (nonatomic) NSUInteger selectedMethodIndex;
@property (nonatomic) NSUInteger selectedCatalogIndex;
@property (nonatomic) NSInteger selectedCountryIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    appInfra  = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).applicationAppInfra;
    logging = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).prxLogging;
    
    PRXDependencies *dependencies = [[PRXDependencies alloc]initWithAppInfra:appInfra parentTLA:@"PRXDEMO"];
    requestManager = [[PRXRequestManager alloc] initWithDependencies:dependencies];
    
    queue = [[NSOperationQueue alloc]init];
    //queue = [NSOperationQueue mainQueue];
    
    
    activityIndicator = [[UIActivityIndicatorView alloc]init];
    [activityIndicator hidesWhenStopped];
    [self.view addSubview:activityIndicator];
    
    self.sectors = [NSArray arrayWithObjects:@"DEFAULT",
                    @"B2C",
                    @"B2B_LI",
                    @"B2B_HC", nil];
    self.catalogs = [NSArray arrayWithObjects:@"CATALOG_DEFAULT",
                     @"CONSUMER",
                     @"NONCONSUMER",
                     @"CARE",
                     @"PROFESSIONAL",
                     @"LP_OEM_ATG",
                     @"LP_PROF_ATG",
                     @"HC",
                     @"HHSSHOP",
                     @"MOBILE",
                     @"COPPA",
                     @"EXTENDEDCONSENT",
                     nil];
    
    [self.selectSectorButton setTitle: self.sectors[1] forState:UIControlStateNormal];
    self.selectedMethodIndex = 1;
   
    [self.selectCatalogButton setTitle: self.catalogs[1] forState:UIControlStateNormal];
    self.selectedCatalogIndex = 1;

    
    self.assetViewController.hidden = NO;
    self.summeryViewController.hidden = YES;
    self.supportViewController.hidden = YES;

    [self loadCountry];
    [self changeCurrentCountry:nil];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getData:(id)sender {
    [self fetchAssetsData];
    [self fetchSummaryData];
    [self fetchSupportData];
    [self fetchSummaryListData];
    return;
}

-(void)fetchAssetsData{
    //asset
    [logging log:AILogLevelInfo eventId:@"Data Fetch" message:@"Asset Request Started"];
    detailVC.assets = nil;
    Sector sector = (Sector)self.selectedMethodIndex ;
    Catalog catalog = (Catalog)self.selectedCatalogIndex;
    PRXAssetRequest *request = [[PRXAssetRequest alloc] initWithSector:sector ctnNumber:self.ctnNoTextField.text catalog:catalog];
    
    [requestManager execute:request completion:^(PRXResponseData *response) {
        // [[(PRXAssetResponse*)response data]  assets][0].assetDescription
        PRXAssetAssets *prxassets = (PRXAssetAssets *)[[(PRXAssetResponse*)response data]  assets];
        NSArray *assets = [prxassets asset];
        
        detailVC.assets = assets;
        NSString *message = [NSString stringWithFormat:@"Asset Request completed. Total asset Fetched: %lu",(unsigned long)assets.count];
        [logging log:AILogLevelInfo eventId:@"Data Fetch" message:message];

        
    } failure:^(NSError *error) {
        NSString *message = [NSString stringWithFormat:@"Asset Request Failed. Error: %@",[error localizedDescription]];
        [logging log:AILogLevelInfo eventId:@"Data Fetch" message:message];

        UIDAlertController *alert = [[UIDAlertController alloc] initWithTitle:@"Error" icon:nil message:error.localizedDescription];
        UIDAction *action = [[UIDAction alloc] initWithTitle:@"OK" style:UIDActionStylePrimary handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:true completion:nil];
    }];
    
}


-(void)fetchSummaryData{
    //summary
    [logging log:AILogLevelInfo eventId:@"Data Fetch" message:@"Summary Request Started"];

    summeryVC.summary = nil;
    Sector sector = (Sector)self.selectedMethodIndex ;
    Catalog catalog = (Catalog)self.selectedCatalogIndex;
    PRXSummaryRequest *summaryrequest = [[PRXSummaryRequest alloc] initWithSector:sector ctnNumber:self.ctnNoTextField.text catalog:catalog];
    [requestManager execute:summaryrequest completion:^(PRXResponseData *response) {
        // [[(PRXAssetResponse*)response data]  assets][0].assetDescription
        PRXSummaryData *summary = (PRXSummaryData *)[(PRXSummaryResponse*)response data] ;
        summeryVC.summary = summary;
        NSString *message = [NSString stringWithFormat:@"Summary Request completed for : %@",summary.productTitle];
        [logging log:AILogLevelInfo eventId:@"Data Fetch" message:message];

    } failure:^(NSError *error) {
        NSString *message = [NSString stringWithFormat:@"Summary Request Failed. Error: %@",[error localizedDescription]];
        [logging log:AILogLevelInfo eventId:@"Data Fetch" message:message];
        
    }];
    
  
}

-(void)fetchSummaryListData{
    //summary
    [logging log:AILogLevelInfo eventId:@"Data Fetch" message:@"Summary list Request Started"];
    
    summeryVC.summary = nil;
    Sector sector = (Sector)self.selectedMethodIndex ;
    Catalog catalog = (Catalog)self.selectedCatalogIndex;
    PRXSummaryListRequest *summaryrequest = [[PRXSummaryListRequest alloc] initWithSector:sector ctnNumbers:[self.ctnNoTextField.text componentsSeparatedByString:@","] catalog:catalog];
    [requestManager execute:summaryrequest completion:^(PRXResponseData *response) {
        // [[(PRXAssetResponse*)response data]  assets][0].assetDescription
        for (PRXSummaryData *summary in [(PRXSummaryResponse*)response data]) {
            summeryVC.summary = summary;
            NSString *message = [NSString stringWithFormat:@"Summary Request completed for : %@",summary.productTitle];
            [logging log:AILogLevelInfo eventId:@"Data Fetch" message:message];
        }
        
    } failure:^(NSError *error) {
        NSString *message = [NSString stringWithFormat:@"Summary Request Failed. Error: %@",[error localizedDescription]];
        [logging log:AILogLevelInfo eventId:@"Data Fetch" message:message];
        
    }];
    
    
}

-(void)fetchSupportData{
    //support
    [logging log:AILogLevelInfo eventId:@"Data Fetch" message:@"Support Request Started"];

    supportVC.richText = nil;
    Sector sector = (Sector)self.selectedMethodIndex ;
    Catalog catalog = (Catalog)self.selectedCatalogIndex;
    PRXSupportRequest *supportrequest = [[PRXSupportRequest alloc] initWithSector:sector ctnNumber:self.ctnNoTextField.text catalog:catalog];
    
    [requestManager execute:supportrequest completion:^(PRXResponseData *response) {
        NSString *message = [NSString stringWithFormat:@"Support Request completed"];
        [logging log:AILogLevelInfo eventId:@"Data Fetch" message:message];
        // [[(PRXAssetResponse*)response data]  assets][0].assetDescription
        PRXFaqData *supportData = (PRXFaqData *)[(PRXSupportResponse*)response data] ;
        PRXFaqRichTexts *richTexts = [supportData richTexts];
        supportVC.richText = richTexts.richText;
    } failure:^(NSError *error) {
        NSString *message = [NSString stringWithFormat:@"Support Request Failed. Error: %@",[error localizedDescription]];
        [logging log:AILogLevelInfo eventId:@"Data Fetch" message:message];
        
    }];
 
}
- (IBAction)selectSectorTapped:(UIDButton *)sender {

    UIDDialogController *dialog = [self getdialogue];
    self.sectorPopOver = [UIDPickerView new];
    self.sectorPopOver.delegate = self;
    self.sectorPopOver.dataSource = self;
    self.sectorPopOver.showsSelectionIndicator = YES;
    dialog.containerView = self.sectorPopOver;
    [self presentViewController:dialog animated:true completion:nil];

}
- (IBAction)selectCatalogTapped:(UIDButton *)sender {
    UIDDialogController *dialog = [self getdialogue];
    self.catalogPopOver = [UIDPickerView new];
    self.catalogPopOver.delegate = self;
    self.catalogPopOver.dataSource = self;
    self.catalogPopOver.showsSelectionIndicator = YES;
    dialog.containerView = self.catalogPopOver;
    [self presentViewController:dialog animated:true completion:nil];
}

- (UIDDialogController *)getdialogue {
    UIDDialogController *dialog = [[UIDDialogController alloc] initWithTitle:@"" icon:nil backgroundStyle:0];
    UIDAction *action = [[UIDAction alloc]initWithTitle:@"OK" style:UIDActionStylePrimary handler:^(UIDAction *action) {

    }];
    [dialog addAction:action];
    return dialog;
}

- (IBAction)countryPressed:(UIDButton *)sender {
    UIDDialogController *dialog = [[UIDDialogController alloc] initWithTitle:@"" icon:nil backgroundStyle:0];
    self.countryPopover = [[UIDPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    self.countryPopover.delegate = self;
    self.countryPopover.dataSource = self;
    self.countryPopover.showsSelectionIndicator = YES;
    dialog.containerView = self.countryPopover;
    UIDAction *action = [[UIDAction alloc]initWithTitle:@"OK" style:UIDActionStylePrimary handler:^(UIDAction *action) {
        NSString *country = [[self->countries allKeys] sortedArrayUsingSelector:@selector(compare:)][self.selectedCountryIndex];
        [self changeCurrentCountry:country];

    }];
    [dialog addAction:action];



    [self presentViewController:dialog animated:true completion:nil];
}

#pragma mark - PopOver

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.sectorPopOver) {
        return  self.sectors.count;
    } else if (pickerView == self.catalogPopOver) {
        return  self.catalogs.count;
    } else if (pickerView == self.countryPopover) {
        return  [countries allKeys].count;
    } return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.sectorPopOver) {
        return  self.sectors[row];
    } else if (pickerView == self.catalogPopOver) {
        return  self.catalogs[row];
    } else if (pickerView == self.countryPopover) {
        NSArray *country = [[countries allKeys] sortedArrayUsingSelector:@selector(compare:)];
        return [country objectAtIndex:row];
    }
    return @"";
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.sectorPopOver) {
        [self.selectSectorButton setTitle: self.sectors[row] forState:UIControlStateNormal];
        self.selectedMethodIndex = row;
    }

    if (pickerView == self.catalogPopOver) {
        [self.selectCatalogButton setTitle: self.catalogs[row] forState:UIControlStateNormal];
        self.selectedCatalogIndex = row;
    }

    if (pickerView == self.countryPopover) {
        self.selectedCountryIndex = row;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"DetailsView"]) {
        detailVC = [segue destinationViewController];
    }
    if ([segue.identifier isEqualToString:@"SummeryView"]) {
        summeryVC = [segue destinationViewController];
    }
    if ([segue.identifier isEqualToString:@"SupportView"]) {
        supportVC = [segue destinationViewController];
    }
}

- (IBAction)segColorBtnTapped:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 1) {
        self.assetViewController.hidden = YES;
        self.summeryViewController.hidden = NO;
        self.supportViewController.hidden = YES;
    } else if (sender.selectedSegmentIndex == 2) {
        self.assetViewController.hidden = YES;
        self.summeryViewController.hidden = YES;
        self.supportViewController.hidden = NO;
    } else if (sender.selectedSegmentIndex == 3) {
        self.assetViewController.hidden = YES;
        self.summeryViewController.hidden = YES;
        self.supportViewController.hidden = NO;
    }else {
        self.assetViewController.hidden = NO;
        self.summeryViewController.hidden = YES;
        self.supportViewController.hidden = YES;
    }
}

- (void)changeCurrentCountry:(NSString*)country {
    if (country) {
        [appInfra.serviceDiscovery setHomeCountry:country];
    }
    [appInfra.serviceDiscovery getHomeCountry:^(NSString *countryCode, NSString *sourceType, NSError *error) {
        NSString *title= [NSString stringWithFormat:@"Country: %@",countries[countryCode][0]];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.countryButton setTitle:title forState:UIControlStateNormal];
            //  [self addTestCtnNumbers];
        });
    }];
}

//this method is only for testing
- (void)addTestCtnNumbers {
    if(self.selectedMethodIndex ==  B2B_HC && self.selectedCatalogIndex == PROFESSIONAL){
        self.ctnNoTextField.text = @"HCNCTB107";
    } else {
        //@"SPA150/94",@"GC1903",@"HP8316"
        
        NSDictionary* sampleCTNs = @{@"India": @[@"QT4001/15",@"HP8100/06",@"HD4928/01",@"SBCHL140/98",@"43PUT7791/V7",@"BT106/94"],
                                     @"China":@[@"HC9450_15"],
                                     @"Australia":@[@"HD9621/11"],
                                     @"Belgium":@[@"HR1871_00"],
                                     @"France":@[@"HD9380/20"],
                                     @"America":@[@"DL8791/50"],
                                     @"United Kingdom":@[@"HX6322/04"],
                                     @"Netherlands":@[@"S9711/31",@"65PUS8601/12",@"DVP2880/12",@"PD9025/12"]
                                };
        
        for (NSString *testCountry in [sampleCTNs allKeys]) {
            if ([self.countryButton.titleLabel.text containsString:testCountry]) {
                NSArray *countryCTNs = sampleCTNs[testCountry];
                uint32_t randomindex = arc4random() %(countryCTNs.count);
                self.ctnNoTextField.text = sampleCTNs[testCountry][randomindex];
            }
        }
    }
}

- (IBAction)fillCTNNoPressed:(UIDButton *)sender {
    [self addTestCtnNumbers];
}

-(void)loadCountry {
    
    /*
     countries = [NSDictionary dictionaryWithObjectsAndKeys:
     @[@"Afghanistan",@"93"],@"AF",
     @[@"Aland Islands",@"358"],@"AX",
     @[@"Albania",@"355"],@"AL",
     @[@"Algeria",@"213"],@"DZ",
     @[@"American Samoa",@"1"],@"AS",
     @[@"Andorra",@"376"],@"AD",
     @[@"Angola",@"244"],@"AO",
     @[@"Anguilla",@"1"],@"AI",
     @[@"Antarctica",@"672"],@"AQ",
     @[@"Antigua and Barbuda",@"1"],@"AG",
     @[@"Argentina",@"54"],@"AR",
     @[@"Armenia",@"374"],@"AM",
     @[@"Aruba",@"297"],@"AW",
     @[@"Australia",@"61"],@"AU",
     @[@"Austria",@"43"],@"AT",
     @[@"Azerbaijan",@"994"],@"AZ",
     @[@"Bahamas",@"1"],@"BS",
     @[@"Bahrain",@"973"],@"BH",
     @[@"Bangladesh",@"880"],@"BD",
     @[@"Barbados",@"1"],@"BB",
     @[@"Belarus",@"375"],@"BY",
     @[@"Belgium",@"32"],@"BE",
     @[@"Belize",@"501"],@"BZ",
     @[@"Benin",@"229"],@"BJ",
     @[@"Bermuda",@"1"],@"BM",
     @[@"Bhutan",@"975"],@"BT",
     @[@"Bolivia",@"591"],@"BO",
     @[@"Bosnia and Herzegovina",@"387"],@"BA",
     @[@"Botswana",@"267"],@"BW",
     @[@"Bouvet Island",@"47"],@"BV",
     @[@"BQ",@"599"],@"BQ",
     @[@"Brazil",@"55"],@"BR",
     @[@"British Indian Ocean Territory",@"246"],@"IO",
     @[@"British Virgin Islands",@"1"],@"VG",
     @[@"Brunei Darussalam",@"673"],@"BN",
     @[@"Bulgaria",@"359"],@"BG",
     @[@"Burkina Faso",@"226"],@"BF",
     @[@"Burundi",@"257"],@"BI",
     @[@"Cambodia",@"855"],@"KH",
     @[@"Cameroon",@"237"],@"CM",
     @[@"Canada",@"1"],@"CA",
     @[@"Cape Verde",@"238"],@"CV",
     @[@"Cayman Islands",@"345"],@"KY",
     @[@"Central African Republic",@"236"],@"CF",
     @[@"Chad",@"235"],@"TD",
     @[@"Chile",@"56"],@"CL",
     @[@"China",@"86"],@"CN",
     @[@"Christmas Island",@"61"],@"CX",
     @[@"Cocos (Keeling) Islands",@"61"],@"CC",
     @[@"Colombia",@"57"],@"CO",
     @[@"Comoros",@"269"],@"KM",
     @[@"Congo (Brazzaville)",@"242"],@"CG",
     @[@"Congo, Democratic Republic of the",@"243"],@"CD",
     @[@"Cook Islands",@"682"],@"CK",
     @[@"Costa Rica",@"506"],@"CR",
     @[@"Côte d'Ivoire",@"225"],@"CI",
     @[@"Croatia",@"385"],@"HR",
     @[@"Cuba",@"53"],@"CU",
     @[@"Curacao",@"599"],@"CW",
     @[@"Cyprus",@"537"],@"CY",
     @[@"Czech Republic",@"420"],@"CZ",
     @[@"Denmark",@"45"],@"DK",
     @[@"Djibouti",@"253"],@"DJ",
     @[@"Dominica",@"1"],@"DM",
     @[@"Dominican Republic",@"1"],@"DO",
     @[@"Ecuador",@"593"],@"EC",
     @[@"Egypt",@"20"],@"EG",
     @[@"El Salvador",@"503"],@"SV",
     @[@"Equatorial Guinea",@"240"],@"GQ",
     @[@"Eritrea",@"291"],@"ER",
     @[@"Estonia",@"372"],@"EE",
     @[@"Ethiopia",@"251"],@"ET",
     @[@"Falkland Islands (Malvinas)",@"500"],@"FK",
     @[@"Faroe Islands",@"298"],@"FO",
     @[@"Fiji",@"679"],@"FJ",
     @[@"Finland",@"358"],@"FI",
     @[@"France",@"33"],@"FR",
     @[@"French Guiana",@"594"],@"GF",
     @[@"French Polynesia",@"689"],@"PF",
     @[@"French Southern Territories",@"689"],@"TF",
     @[@"Gabon",@"241"],@"GA",
     @[@"Gambia",@"220"],@"GM",
     @[@"Georgia",@"995"],@"GE",
     @[@"Germany",@"49"],@"DE",
     @[@"Ghana",@"233"],@"GH",
     @[@"Gibraltar",@"350"],@"GI",
     @[@"Greece",@"30"],@"GR",
     @[@"Greenland",@"299"],@"GL",
     @[@"Grenada",@"1"],@"GD",
     @[@"Guadeloupe",@"590"],@"GP",
     @[@"Guam",@"1"],@"GU",
     @[@"Guatemala",@"502"],@"GT",
     @[@"Guernsey",@"44"],@"GG",
     @[@"Guinea",@"224"],@"GN",
     @[@"Guinea-Bissau",@"245"],@"GW",
     @[@"Guyana",@"595"],@"GY",
     @[@"Haiti",@"509"],@"HT",
     @[@"Holy See (Vatican City State)",@"379"],@"VA",
     @[@"Honduras",@"504"],@"HN",
     @[@"Hong Kong, Special Administrative Region of China",@"852"],@"HK",
     @[@"Hungary",@"36"],@"HU",
     @[@"Iceland",@"354"],@"IS",
     @[@"India",@"91"],@"IN",
     @[@"Indonesia",@"62"],@"ID",
     @[@"Iran, Islamic Republic of",@"98"],@"IR",
     @[@"Iraq",@"964"],@"IQ",
     @[@"Ireland",@"353"],@"IE",
     @[@"Isle of Man",@"44"],@"IM",
     @[@"Israel",@"972"],@"IL",
     @[@"Italy",@"39"],@"IT",
     @[@"Jamaica",@"1"],@"JM",
     @[@"Japan",@"81"],@"JP",
     @[@"Jersey",@"44"],@"JE",
     @[@"Jordan",@"962"],@"JO",
     @[@"Kazakhstan",@"77"],@"KZ",
     @[@"Kenya",@"254"],@"KE",
     @[@"Kiribati",@"686"],@"KI",
     @[@"Korea, Democratic People's Republic of",@"850"],@"KP",
     @[@"Korea, Republic of",@"82"],@"KR",
     @[@"Kuwait",@"965"],@"KW",
     @[@"Kyrgyzstan",@"996"],@"KG",
     @[@"Lao PDR",@"856"],@"LA",
     @[@"Latvia",@"371"],@"LV",
     @[@"Lebanon",@"961"],@"LB",
     @[@"Lesotho",@"266"],@"LS",
     @[@"Liberia",@"231"],@"LR",
     @[@"Libya",@"218"],@"LY",
     @[@"Liechtenstein",@"423"],@"LI",
     @[@"Lithuania",@"370"],@"LT",
     @[@"Luxembourg",@"352"],@"LU",
     @[@"Macao, Special Administrative Region of China",@"853"],@"MO",
     @[@"Macedonia, Republic of",@"389"],@"MK",
     @[@"Madagascar",@"261"],@"MG",
     @[@"Malawi",@"265"],@"MW",
     @[@"Malaysia",@"60"],@"MY",
     @[@"Maldives",@"960"],@"MV",
     @[@"Mali",@"223"],@"ML",
     @[@"Malta",@"356"],@"MT",
     @[@"Marshall Islands",@"692"],@"MH",
     @[@"Martinique",@"596"],@"MQ",
     @[@"Mauritania",@"222"],@"MR",
     @[@"Mauritius",@"230"],@"MU",
     @[@"Mayotte",@"262"],@"YT",
     @[@"Mexico",@"52"],@"MX",
     @[@"Micronesia, Federated States of",@"691"],@"FM",
     @[@"Moldova",@"373"],@"MD",
     @[@"Monaco",@"377"],@"MC",
     @[@"Mongolia",@"976"],@"MN",
     @[@"Montenegro",@"382"],@"ME",
     @[@"Montserrat",@"1"],@"MS",
     @[@"Morocco",@"212"],@"MA",
     @[@"Mozambique",@"258"],@"MZ",
     @[@"Myanmar",@"95"],@"MM",
     @[@"Namibia",@"264"],@"NA",
     @[@"Nauru",@"674"],@"NR",
     @[@"Nepal",@"977"],@"NP",
     @[@"Netherlands",@"31"],@"NL",
     @[@"Netherlands Antilles",@"599"],@"AN",
     @[@"New Caledonia",@"687"],@"NC",
     @[@"New Zealand",@"64"],@"NZ",
     @[@"Nicaragua",@"505"],@"NI",
     @[@"Niger",@"227"],@"NE",
     @[@"Nigeria",@"234"],@"NG",
     @[@"Niue",@"683"],@"NU",
     @[@"Norfolk Island",@"672"],@"NF",
     @[@"Northern Mariana Islands",@"1"],@"MP",
     @[@"Norway",@"47"],@"NO",
     @[@"Oman",@"968"],@"OM",
     @[@"Pakistan",@"92"],@"PK",
     @[@"Palau",@"680"],@"PW",
     @[@"Palestinian Territory, Occupied",@"970"],@"PS",
     @[@"Panama",@"507"],@"PA",
     @[@"Papua New Guinea",@"675"],@"PG",
     @[@"Paraguay",@"595"],@"PY",
     @[@"Peru",@"51"],@"PE",
     @[@"Philippines",@"63"],@"PH",
     @[@"Pitcairn",@"872"],@"PN",
     @[@"Poland",@"48"],@"PL",
     @[@"Portugal",@"351"],@"PT",
     @[@"Puerto Rico",@"1"],@"PR",
     @[@"Qatar",@"974"],@"QA",
     @[@"Réunion",@"262"],@"RE",
     @[@"Romania",@"40"],@"RO",
     @[@"Russian Federation",@"7"],@"RU",
     @[@"Rwanda",@"250"],@"RW",
     @[@"Saint Helena",@"290"],@"SH",
     @[@"Saint Kitts and Nevis",@"1"],@"KN",
     @[@"Saint Lucia",@"1"],@"LC",
     @[@"Saint Pierre and Miquelon",@"508"],@"PM",
     @[@"Saint Vincent and Grenadines",@"1"],@"VC",
     @[@"Saint-Barthélemy",@"590"],@"BL",
     @[@"Saint-Martin (French part)",@"590"],@"MF",
     @[@"Samoa",@"685"],@"WS",
     @[@"San Marino",@"378"],@"SM",
     @[@"Sao Tome and Principe",@"239"],@"ST",
     @[@"Saudi Arabia",@"966"],@"SA",
     @[@"Senegal",@"221"],@"SN",
     @[@"Serbia",@"381"],@"RS",
     @[@"Seychelles",@"248"],@"SC",
     @[@"Sierra Leone",@"232"],@"SL",
     @[@"Singapore",@"65"],@"SG",
     @[@"Sint Maarten",@"1"],@"SX",
     @[@"Slovakia",@"421"],@"SK",
     @[@"Slovenia",@"386"],@"SI",
     @[@"Solomon Islands",@"677"],@"SB",
     @[@"Somalia",@"252"],@"SO",
     @[@"South Africa",@"27"],@"ZA",
     @[@"South Georgia and the South Sandwich Islands",@"500"],@"GS",
     @[@"South Sudan",@"211"],@"SS​",
     @[@"Spain",@"34"],@"ES",
     @[@"Sri Lanka",@"94"],@"LK",
     @[@"Sudan",@"249"],@"SD",
     @[@"Suriname",@"597"],@"SR",
     @[@"Svalbard and Jan Mayen Islands",@"47"],@"SJ",
     @[@"Swaziland",@"268"],@"SZ",
     @[@"Sweden",@"46"],@"SE",
     @[@"Switzerland",@"41"],@"CH",
     @[@"Syrian Arab Republic (Syria)",@"963"],@"SY",
     @[@"Taiwan, Republic of China",@"886"],@"TW",
     @[@"Tajikistan",@"992"],@"TJ",
     @[@"Tanzania, United Republic of",@"255"],@"TZ",
     @[@"Thailand",@"66"],@"TH",
     @[@"Timor-Leste",@"670"],@"TL",
     @[@"Togo",@"228"],@"TG",
     @[@"Tokelau",@"690"],@"TK",
     @[@"Tonga",@"676"],@"TO",
     @[@"Trinidad and Tobago",@"1"],@"TT",
     @[@"Tunisia",@"216"],@"TN",
     @[@"Turkey",@"90"],@"TR",
     @[@"Turkmenistan",@"993"],@"TM",
     @[@"Turks and Caicos Islands",@"1"],@"TC",
     @[@"Tuvalu",@"688"],@"TV",
     @[@"Uganda",@"256"],@"UG",
     @[@"Ukraine",@"380"],@"UA",
     @[@"United Arab Emirates",@"971"],@"AE",
     @[@"United Kingdom",@"44"],@"GB",
     @[@"United States of America",@"1"],@"US",
     @[@"Uruguay",@"598"],@"UY",
     @[@"Uzbekistan",@"998"],@"UZ",
     @[@"Vanuatu",@"678"],@"VU",
     @[@"Venezuela (Bolivarian Republic of)",@"58"],@"VE",
     @[@"Viet Nam",@"84"],@"VN",
     @[@"Virgin Islands, US",@"1"],@"VI",
     @[@"Wallis and Futuna Islands",@"681"],@"WF",
     @[@"Western Sahara",@"212"],@"EH",
     @[@"Yemen",@"967"],@"YE",
     @[@"Zambia",@"260"],@"ZM",
     @[@"Zimbabwe",@"263"],@"ZW", nil];
    */
    
    
    
    countries = [NSDictionary dictionaryWithObjectsAndKeys:
                 @[@"Australia",@"61"],@"AU",
                 @[@"Belgium",@"32"],@"BE",
                 @[@"China",@"86"],@"CN",
                 @[@"France",@"33"],@"FR",
                 @[@"India",@"91"],@"IN",
                 @[@"Netherlands",@"31"],@"NL",
                 @[@"United Kingdom",@"44"],@"GB",
                 @[@"United States of America",@"1"],@"US",nil];
}


@end
