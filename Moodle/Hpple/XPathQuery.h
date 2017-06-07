/*
 *  XPathQuery.h
 *  Moodle
 *
 *  Created by Matt Gallagher on 4/08/08.
 *  See: http://www.cocoawithlove.com/2008/10/using-libxml2-for-parsing-and-xpath.html
 */

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Funktions
///--------------------
/// @name Funktions
///--------------------

 NSArray * _Nullable PerformHTMLXPathQuery(NSData *document, NSString *query);

 NSArray * _Nullable PerformHTMLXPathQueryWithEncoding(NSData *document, NSString *query,NSString * _Nullable encoding);

 NSArray * _Nullable PerformXMLXPathQuery(NSData *document, NSString *query);

 NSArray * _Nullable PerformXMLXPathQueryWithEncoding(NSData *document, NSString *query,NSString * _Nullable encoding);

NS_ASSUME_NONNULL_END
