
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The `AIAFURLResponseSerialization` protocol is adopted by an object that decodes data into a more useful object representation, according to details in the server response. Response serializers may additionally perform validation on the incoming response and data.
 
 For example, a JSON response serializer may check for an acceptable status code (`2XX` range) and content type (`application/json`), decoding a valid JSON response into an object.
 */

@protocol AIRESTClientURLResponseSerialization <AFURLResponseSerialization>

/**
 The response object decoded from the data associated with a specified response.
 
 @param response The response to be processed.
 @param data The response data to be decoded.
 @param error The error that occurred while attempting to decode the response data.
 
 @return The object decoded from the specified response data.
 */
- (nullable id)responseObjectForResponse:(nullable NSURLResponse *)response
                                    data:(nullable NSData *)data
                                   error:(NSError * _Nullable __autoreleasing *)error NS_SWIFT_NOTHROW;

@end

#pragma mark -

/**
 `AIAFHTTPResponseSerializer` offering a concrete base implementation of query string / URL form-encoded parameter serialization and default request headers, as well as response status code and content type validation.
 */

@interface AIRESTClientHTTPResponseSerializer : AFHTTPResponseSerializer <AIRESTClientURLResponseSerialization>

@end

#pragma mark -


/**
 `AIAFJSONResponseSerializer` is a subclass of `AFJSONResponseSerializer` that validates and decodes JSON responses.
 
 By default, `AFJSONResponseSerializer` accepts the following MIME types, which includes the official standard, `application/json`, as well as other commonly-used types:
 
 - `application/json`
 - `text/json`
 - `text/javascript`
 */

@interface AIRESTClientJSONResponseSerializer : AFJSONResponseSerializer <AIRESTClientURLResponseSerialization>

@end

#pragma mark -

/**
 `AIAFXMLParserResponseSerializer` is a subclass of `AFXMLParserResponseSerializer` that validates and decodes XML responses as an `NSXMLParser` objects.
 
 By default, `AFXMLParserResponseSerializer` accepts the following MIME types, which includes the official standard, `application/xml`, as well as other commonly-used types:
 
 - `application/xml`
 - `text/xml`
 */
@interface AIRESTClientXMLParserResponseSerializer : AFXMLParserResponseSerializer <AIRESTClientURLResponseSerialization>

@end

#pragma mark -

/**
 `AIAFPropertyListResponseSerializer` is a subclass of `AFPropertyListResponseSerializer` that validates and decodes XML responses as an `NSXMLDocument` objects.
 
 By default, `AFPropertyListResponseSerializer` accepts the following MIME types:
 
 - `application/x-plist`
 */

@interface AIRESTClientPropertyListResponseSerializer : AFPropertyListResponseSerializer <AIRESTClientURLResponseSerialization>

@end

#pragma mark -

/**
 `AIAFImageResponseSerializer` is a subclass of `AFImageResponseSerializer` that validates and decodes image responses.
 
 By default, `AFImageResponseSerializer` accepts the following MIME types, which correspond to the image formats supported by UIImage or NSImage:
 
 - `image/tiff`
 - `image/jpeg`
 - `image/gif`
 - `image/png`
 - `image/ico`
 - `image/x-icon`
 - `image/bmp`
 - `image/x-bmp`
 - `image/x-xbitmap`
 - `image/x-win-bitmap`
 */
@interface AIRESTClientImageResponseSerializer : AFImageResponseSerializer <AIRESTClientURLResponseSerialization>

@end

#pragma mark -

/**
 `AIAFCompoundResponseSerializer` is a subclass of `AFCompoundResponseSerializer` that delegates the response serialization to the first `AFHTTPResponseSerializer` object that returns an object for `responseObjectForResponse:data:error:`, falling back on the default behavior of `AFHTTPResponseSerializer`. This is useful for supporting multiple potential types and structures of server responses with a single serializer.
 */
@interface AIRESTClientCompoundResponseSerializer : AFCompoundResponseSerializer <AIRESTClientURLResponseSerialization>

@end

NS_ASSUME_NONNULL_END
