//
//  ViewController.m
//  KeyManagerTool
//
//  Created by Hashim MH on 04/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "ViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "CHCSVParser.h"

@interface ViewController()<CHCSVParserDelegate>{
    NSURL *selectedFile;
}
@property (weak) IBOutlet NSTextField *fileNameLabel;
@property (weak) IBOutlet NSButton *doButton;
@property (nonatomic, strong) NSMutableArray * lines;
@property (nonatomic, strong) NSMutableArray * currentLine;

@end

@implementation ViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UI Actions
- (IBAction)selectFilePressed:(id)sender {
    [self reset];
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    NSArray  * fileTypes;
    if ([self.doButton.title isEqualToString:@"Encrypt"]) {
        fileTypes = [NSArray arrayWithObjects:@"csv", nil];
    }
    else {
        fileTypes = [NSArray arrayWithObjects:@"json", nil];
    }
    
    [openDlg setAllowedFileTypes:fileTypes];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setAllowsMultipleSelection:NO];
    NSInteger clicked = [openDlg runModal];
    NSURL *file;
    
    if (clicked == NSFileHandlingPanelOKButton && [openDlg URLs].count) {
        file = [openDlg URLs][0];
        [self processFile:file];
    }
}

- (IBAction)encryptFilePressed:(id)sender {
    if (!selectedFile) {
        [self showAlert:@"Please select a file to encrypt . ." title:@"No File selcted"];
        
        return;
    }
    if ([self.doButton.title isEqualToString:@"Encrypt"]) {
        NSDictionary * inputKeyFormat = [self convertCSVToKeyInputFile:selectedFile];
        NSData * encrypted = [self encryptData:inputKeyFormat];
        if (encrypted) {
            NSData * csvData = [self generateCSV];
            
            NSSavePanel*    panel = [NSSavePanel savePanel];
            [panel setNameFieldStringValue:@"AIKMap.json"];
            [panel beginWithCompletionHandler:^(NSInteger result) {
                if (result != 0) {
                    NSURL * dest = [panel URL];
                    [encrypted writeToURL:dest  atomically:YES];
                    [self exportDocument:@"Final-csv.csv" toType:@"csv" data:csvData];
                }
            }];
        }
    }
    else {
        [self exportDocument:@"KeyInput.json" toType:@"json" data:[self decryptData]];
    }
}

- (IBAction)segmentValueChanged:(NSSegmentedControl *)sender {
    [self reset];
    switch (sender.intValue) {
        case 0:
            [self.doButton setTitle:@"Encrypt"];
            break;
            
        case 1:
            [self.doButton setTitle:@"Decrypt"];
            break;
        default:
            break;
    }
}

#pragma mark - Utilities

-(void)showAlert:(NSString *)message title:(NSString *)title{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:title];
    [alert setInformativeText:message];
    [alert setAlertStyle:NSAlertStyleInformational];
    
    if ([alert runModal] == NSAlertFirstButtonReturn) {
        // OK clicked,
    }
}

- (void)exportDocument:(NSString*)name toType:(NSString*)typeUTI data:(NSData*)data
{
    NSSavePanel*    panel = [NSSavePanel savePanel];
    [panel setNameFieldStringValue:name];
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result != 0) {
            [data writeToURL:[panel URL]  atomically:YES];
            [self showAlert:@"Saved successfully" title:@"Alert"];
        }
    }];
}

- (unsigned char *) convertToHexValueFromString:(NSString *)hexString
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wsign-conversion"
#pragma clang diagnostic ignored "-Wsign-compare"
    unsigned char *myBuffer = (unsigned char *)malloc((int)[hexString length] / 2 + 1);
    
    bzero(myBuffer, [hexString length] / 2 + 1);
    
    for (int i = 0; i < [hexString length] - 1; i += 2)
    {
        unsigned int anInt;
        
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        
        myBuffer[i / 2] = (char)anInt;
    }
#pragma clang diagnostic pop
    return myBuffer;
}

#pragma mark - logic

-(void)reset{
    selectedFile = nil;
    [self.fileNameLabel setStringValue:@"no files selected"];
}
-(void)processFile:(NSURL*)file{
    NSData *data = [NSData dataWithContentsOfURL:file];
    
    if (data) {
        NSString * fileName = [file resourceSpecifier];
        [self.fileNameLabel setStringValue:fileName];
        selectedFile = file;
    }
    else{
        [self showAlert:@"File cannot be read" title:@"Invalid File!"];
    }
}


- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

-(int)createStartStateFrom:(NSString *)input{
    NSString * md5 = [self md5:input];
    NSString *first4 =[md5 substringToIndex:4];
    
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:first4];
    
    [scanner scanHexInt:&result];
    return result;
    //return 0xACE1u;
}

-(NSData *)decryptData {
    NSData *data = [NSData dataWithContentsOfURL:selectedFile];
    NSError * error;
    NSMutableDictionary * output = [NSMutableDictionary new];
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (json) {
        for (NSString * key in [json allKeys]) {
            NSArray * arr = [json objectForKey:key];
            for (int i=0; i<arr.count; i++) {
                NSString * newKey = [NSString stringWithFormat:@"%@.kindex %d",key,i];
                NSDictionary * offuscatedJson = arr[i];
                NSMutableDictionary * deOffuscatedDict = [NSMutableDictionary new];
                for (NSString * offuscationKey in [offuscatedJson allKeys]) {
                    NSString * inputString = [NSString stringWithFormat:@"%@%d%@",key, i, offuscationKey];
                    int startState = [self createStartStateFrom:inputString];
                    char * s = (char *)[self convertToHexValueFromString:[offuscatedJson objectForKey:offuscationKey]];
                    unsigned int length = (unsigned int)strlen(s);
                    char message[length];
                    strcpy(message, s);
                    lfsr16_obfuscate(s, length, startState);
                    [deOffuscatedDict setObject:[NSString stringWithFormat:@"%s",s] forKey:offuscationKey];
                }
                [output setObject:deOffuscatedDict forKey:newKey];
            }
        }
    }
    else {
        [self showAlert:@"Invalid Json" title:@"Error"];
    }
    
    NSData *outputData =[NSJSONSerialization dataWithJSONObject:output options:NSJSONWritingPrettyPrinted error:nil];
    return outputData;
}

-(NSData*)encryptData:(NSDictionary*)dictionary{
    
    NSMutableDictionary * output = [NSMutableDictionary new];
    
    NSArray * sortedArray = [[dictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    if (sortedArray.count == 0) {
        [self showAlert:@"There is no kindex values in the csv" title:@"Error"];
        return nil;
    }
    
    for (NSString * groupKey in sortedArray) {
        NSString * group = [groupKey componentsSeparatedByString:@".kindex"].firstObject;
        NSString * keyIndex = [groupKey componentsSeparatedByString:@"."].lastObject;
        NSString * seed = [keyIndex componentsSeparatedByString:@" "].lastObject;
        NSString * value = [dictionary objectForKey:groupKey];
        
        if (value && ![value isEqualToString:@""]) {
            NSMutableDictionary * offuscatedDict = [NSMutableDictionary new];
            value = [value stringByReplacingOccurrencesOfString:@"\"\"" withString:@"\'"];
            value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\'" withString:@"\""];
            NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (json == nil) {
                NSString * message = [NSString stringWithFormat:@"%@    is not in expected json format", value];
                [self showAlert:message title:@"Error"];
                return nil;
            }
            
            for (NSString * key in json.allKeys) {
                NSString * value = [json objectForKey:key];
                NSString * valuetoOffuscate = value;
                char * s = (char *)[valuetoOffuscate UTF8String];
                unsigned int length = (unsigned int)strlen(s);
                char message[length];
                strcpy(message, s);
                NSString * inputString = [NSString stringWithFormat:@"%@%d%@",group, seed.intValue, key];
                int startState = [self createStartStateFrom:inputString];
                lfsr16_obfuscate(message, (int)value.length, startState);
                
                
                NSMutableString * hex = [NSMutableString string];
                for (int i = 0; i<length; i++) {
                    [hex appendFormat:@"%02hhx",message[i]];
                }
                [offuscatedDict setObject:hex forKey:key];
            }
            
            NSMutableArray * groupArray = [output objectForKey:group];
            if (!groupArray) {
                groupArray = [NSMutableArray new];
                [output setObject:groupArray forKey:group];
            }
            
            [groupArray addObject:offuscatedDict];
        }
    }
    
    
    NSData *data =[NSJSONSerialization dataWithJSONObject:output options:NSJSONWritingPrettyPrinted error:nil];
    return data;
}

- (NSData *)generateCSV {
//    NSData *data = [NSData dataWithContentsOfURL:selectedFile];
//    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    NSArray * rows = [str componentsSeparatedByString:@"\r"];
//    NSArray * titles = [rows[0] componentsSeparatedByString:@","];
    
    NSArray * titles = _lines[0];
    NSMutableArray * mutableRows = [NSMutableArray new];
    
    for (NSArray * row in _lines) {
        NSMutableArray * newRow = [row mutableCopy];
        [mutableRows addObject:newRow];
    }
    
    for (int i=0; i<titles.count; i++) {
        NSString * title = titles[i];
        if ([title containsString:@".kindex"]) {
            NSMutableArray * kIndexValues = [NSMutableArray new];
            
            for (int j=1; j<_lines.count; j++) {
                NSArray * values = _lines[j];
                if (values.count >= i) {
                    NSString * value = values[i];
                    if (value && ![value isEqualToString:@""]) {
                        if (![kIndexValues containsObject:value]) {
                            [kIndexValues addObject:value];
                        }
                        NSInteger index = [kIndexValues indexOfObject:value];
                        NSString * url = [NSString stringWithFormat:@"https://philips.com/%ld",index];
                        mutableRows[j][i] = url;
                    }
                }
            }
        }
    }
    
    NSMutableArray * output = [NSMutableArray new];
    
    for (NSArray * row in mutableRows) {
        NSString * rowString = [row componentsJoinedByString:@","];
        [output addObject:rowString];
    }
    
    NSData * outputData = [[output componentsJoinedByString:@"\r"] dataUsingEncoding:NSUTF8StringEncoding];
    return outputData;
}

-(NSDictionary *)convertCSVToKeyInputFile:(NSURL *)path {
    CHCSVParser * p = [[CHCSVParser alloc]initWithContentsOfCSVURL:path];
    [p setDelegate:self];
    [p parse];
    
//    NSData *data = [NSData dataWithContentsOfURL:path];
//    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    NSArray * rows = [str componentsSeparatedByString:@"\r"];
    NSArray * titles = _lines[0];
    
    NSMutableDictionary * keyInput = [NSMutableDictionary new];
    for (int i=0; i<titles.count; i++) {
        NSString * title = titles[i];
        if ([title containsString:@".kindex"]) {
            NSString * group = [title componentsSeparatedByString:@".kindex"][0];
            
            NSMutableArray * kIndexValues = [NSMutableArray new];
            
            for (int j=1; j<_lines.count; j++) {
                NSArray * values = _lines[j];
                if (values.count >= i) {
                    
                    NSString * value = values[i];
                    if (![kIndexValues containsObject:value] && ![value isEqualToString:@""]) {
                        [kIndexValues addObject:value];
                        NSInteger kIndex = [kIndexValues indexOfObject:value];
                        NSString * key = [NSString stringWithFormat:@"%@.kindex %ld",group, kIndex];
                        [keyInput setObject:value forKey:key];
                    }
                }
            }
        }
    }
    
    return keyInput;
}

void lfsr16_obfuscate(char *s, unsigned int length, int seed)
{
    unsigned int i, lsb;
    unsigned int lfsr = seed;
    
    for (i = 0; i < length*8; i++) // Iterating over bits
    {
        lsb = lfsr & 1u;
        // Finding least significant bit
        lfsr >>= 1u;
        // Right shifting
        if (lsb == 1u)
        {
            lfsr ^= 0xB400u;
            s[i / 8] ^= 1 << (i % 8);
        }
    }
}
#pragma mark CHCSVParserDelegate
- (void)parserDidBeginDocument:(CHCSVParser *)parser {
    _lines = [[NSMutableArray alloc] init];
}
- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber {
    _currentLine = [[NSMutableArray alloc] init];
}
- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex {
    NSLog(@"%@", field);
    [_currentLine addObject:field];
}
- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber {
    [_lines addObject:_currentLine];
    _currentLine = nil;
}
- (void)parserDidEndDocument:(CHCSVParser *)parser {
    //	NSLog(@"parser ended: %@", csvFile);
}
- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"ERROR: %@", error);
    _lines = nil;
}

@end
