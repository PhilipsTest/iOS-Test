//
//  URGoogleLoginHandler.m
//  PhilipsRegistration
//
//  Created by Adarsh Kumar Rai on 10/05/18.
//  Copyright © 2018 Philips. All rights reserved.
//

#import "URGoogleLoginHandler.h"
#import "DIRegistrationConstants.h"
#import "DIHTTPUtility.h"
#import "URJWTParser.h"
#import "debug_log.h"
@import SafariServices;
@import PhilipsUIKitDLS;

#define GOOGLE_AUTH_URL         @"https://accounts.google.com/o/oauth2/v2/auth"
#define GOOGLE_TOKEN_URL        @"https://www.googleapis.com/oauth2/v4/token"
#define GOOGLE_SCOPE            @"openid%20profile%20email%20address%20phone"
#define GOOGLE_TOKEN_URL        @"https://www.googleapis.com/oauth2/v4/token"

@interface URGoogleLoginHandler()<SFSafariViewControllerDelegate>

@property (nonatomic, strong) NSString *googleClientId;
@property (nonatomic, strong) NSString *googleRedirectURI;
@property (nonatomic, strong) URGoogleLoginCompletion completion;
@property (nonatomic, strong) SFSafariViewController *safariController;
@property (nonatomic, strong) UIViewController *presentingController;
@property (nonatomic, strong) DIHTTPUtility *httpUtility;

@end

@implementation URGoogleLoginHandler

#pragma mark - Initializer -
- (instancetype)initWithClientId:(nonnull NSString *)clientId redirectURI:(nonnull NSString *)redirectURI {
    self = [super init];
    if (self) {
        _googleClientId = clientId;
        _googleRedirectURI = redirectURI;
    }
    return self;
}


#pragma mark - Public Method -
- (void)startGoogleLoginFrom:(nonnull UIViewController *)controller completion:(nonnull URGoogleLoginCompletion)completion {
    self.completion = completion;
    NSString *authURLString = [NSString stringWithFormat:@"%@?response_type=code&client_id=%@&redirect_uri=%@&scope=%@&state=1SVxJOk90JIizFUStlqRYXAgSSN8Is3DOQItp9q1p7Q", GOOGLE_AUTH_URL, self.googleClientId, self.googleRedirectURI, GOOGLE_SCOPE];
    SFSafariViewControllerConfiguration *configuration = [[SFSafariViewControllerConfiguration alloc] init];
    configuration.entersReaderIfAvailable = NO;
    configuration.barCollapsingEnabled = YES;
    self.safariController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:authURLString] configuration:configuration];
    self.safariController.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleCancel;
    self.safariController.preferredBarTintColor = [[UINavigationBar appearance] barTintColor];
    self.safariController.preferredControlTintColor = [[UINavigationBar appearance] tintColor];
    self.safariController.delegate = self;
    [controller presentViewController:self.safariController animated:YES completion:nil];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    if (![url.absoluteString containsString:self.googleRedirectURI]) {
        return false;
    }
    [self.safariController dismissViewControllerAnimated:YES completion:nil];
    NSError *urlError = nil;
    NSString *authCode = [self parseAuthCodeFromURL:url error:&urlError];
    if (authCode.length > 0 && urlError == nil) {
        [self getTokenForAuthCode:authCode completion:^(NSString *token, NSString *email, NSError *error) {
            self.completion(token, email, error);
        }];
    } else {
        self.completion(nil, nil, urlError);
    }
    return true;
}


#pragma mark - SFSafariViewControllerDelegate Methods -
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    self.completion(nil, nil, [NSError errorWithDomain:@"URErrorDomain" code:DIRegAuthenticationError userInfo:@{NSLocalizedDescriptionKey: @"Authentication Cancelled"}]);
}


#pragma mark - Helper Methods -
- (DIHTTPUtility *)httpUtility {
    if (!self->_httpUtility) {
        self->_httpUtility = [[DIHTTPUtility alloc] init];
    }
    return self->_httpUtility;
}


- (void)getTokenForAuthCode:(NSString *)authCode completion:(void(^)(NSString *token, NSString *email, NSError *error))completion {
    NSString *postData = [NSString stringWithFormat:@"code=%@&client_id=%@&redirect_uri=%@&grant_type=authorization_code", authCode, self.googleClientId, self.googleRedirectURI];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:GOOGLE_TOKEN_URL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    [self.httpUtility startURLConnectionWithRequest:request completionHandler:^(id response, NSData *data, NSError *error) {
        if (data.length > 0 && error == nil) {
            NSError *parsingError = nil;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parsingError];
            URJWTParser *jwtParser = [[URJWTParser alloc] initWithJWTToken:responseDict[@"id_token"]];
            completion(responseDict[@"access_token"], jwtParser.payload[@"email"], parsingError);
        } else {
            completion(nil, nil, error);
        }
    }];
}


- (NSString *)parseAuthCodeFromURL:(NSURL *)url error:(NSError * __autoreleasing *)error {
    NSArray<NSURLQueryItem *> *queryItems = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:YES].queryItems;
    NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
    for (NSURLQueryItem *item in queryItems) {
        responseDict[item.name] = item.value;
    }
    NSString *socialError = responseDict[@"error"];
    if (socialError.length > 0 && *error == NULL) {
        if (*error == NULL) {
            NSInteger error_code = [responseDict[@"error_code"] integerValue] > 0 ? [responseDict[@"error_code"] integerValue] : DIRegAuthenticationError;
            *error = [NSError errorWithDomain:@"URErrorDomain" code:error_code userInfo:@{@"error": responseDict[@"error"],
                                                                                          @"error_description": responseDict[@"error_description"]}];
        }
        return nil;
    }
    return responseDict[@"code"];
}

@end


@implementation AppleUser

@synthesize firstName;
@synthesize accessToken;
@synthesize lastName;
@synthesize appleUser;
@synthesize appleToken;
@synthesize emailID;

@end

API_AVAILABLE(ios(13.0))

@interface URAppleSignInHandler() <ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@property (nonatomic, strong) URAppleLoginCompletion completion;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) ASAuthorizationAppleIDProvider *provider;
@property (nonatomic, strong) ASAuthorizationAppleIDRequest *request;
@property (nonatomic, strong) ASAuthorizationController *controller;

@end

@implementation URAppleSignInHandler

@synthesize completion;
@synthesize window;

#pragma mark - ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
    if (@available(iOS 13.0, *)) {
        if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
            ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
            AppleUser *aUser = [[AppleUser alloc] init];
            aUser.appleUser = appleIDCredential.user;
            aUser.firstName = appleIDCredential.fullName.givenName;
            aUser.lastName = appleIDCredential.fullName.familyName;
            aUser.emailID = appleIDCredential.email;
            aUser.accessToken = [[NSString alloc] initWithData:appleIDCredential.authorizationCode encoding:NSUTF8StringEncoding];
            aUser.appleToken = [[NSString alloc] initWithData:appleIDCredential.identityToken encoding:NSUTF8StringEncoding];
            self.completion(aUser,nil);
        }
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
    DLog(@"Sign in with apple Error: %@", error.localizedDescription);
    self.completion(nil,error);
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding
-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
         return self.window;
}


- (void)startAppleLoginFrom:(UIWindow * _Nonnull)controller completion:(nonnull URAppleLoginCompletion)completion {
    if (@available(iOS 13, *)) {
        self.provider = [[ASAuthorizationAppleIDProvider alloc] init];
        self.request = [self.provider createRequest];
        self.request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        self.controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:[NSArray arrayWithObjects:self.request,nil]];
        self.controller.delegate = self;
        self.controller.presentationContextProvider = self;
        self.completion = completion;
        self.window = controller;
        [self.controller performRequests];
    }
}

@end
