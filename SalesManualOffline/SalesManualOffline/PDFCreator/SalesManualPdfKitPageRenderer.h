//
//  SalesManualPdfKitPageRenderer.h
//  SalesManualOffline
//
//  Created by Abhishek Shrivastava on 21/02/18.
//  Copyright © 2018 Abhishek Shrivastava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol SalesManualPdfKitDelegate;

// http://en.wikipedia.org/wiki/Paper_size
typedef enum {
    BNPageSizeLetter,
    BNPageSizeGovernmentLetter,
    BNPageSizeLegal,
    BNPageSizeJuniorLegal,
    BNPageSizeLedger,
    BNPageSizeTabloid,
    BNPageSizeA0,
    BNPageSizeA1,
    BNPageSizeA2,
    BNPageSizeA3,
    BNPageSizeA4,
    BNPageSizeA5,
    BNPageSizeA6,
    BNPageSizeA7,
    BNPageSizeA8,
    BNPageSizeA9,
    BNPageSizeA10,
    BNPageSizeB0,
    BNPageSizeB1,
    BNPageSizeB2,
    BNPageSizeB3,
    BNPageSizeB4,
    BNPageSizeB5,
    BNPageSizeB6,
    BNPageSizeB7,
    BNPageSizeB8,
    BNPageSizeB9,
    BNPageSizeB10,
    BNPageSizeC0,
    BNPageSizeC1,
    BNPageSizeC2,
    BNPageSizeC3,
    BNPageSizeC4,
    BNPageSizeC5,
    BNPageSizeC6,
    BNPageSizeC7,
    BNPageSizeC8,
    BNPageSizeC9,
    BNPageSizeC10,
    BNPageSizeJapaneseB0,
    BNPageSizeJapaneseB1,
    BNPageSizeJapaneseB2,
    BNPageSizeJapaneseB3,
    BNPageSizeJapaneseB4,
    BNPageSizeJapaneseB5,
    BNPageSizeJapaneseB6,
    BNPageSizeJapaneseB7,
    BNPageSizeJapaneseB8,
    BNPageSizeJapaneseB9,
    BNPageSizeJapaneseB10,
    BNPageSizeJapaneseB11,
    BNPageSizeJapaneseB12,
    BNPageSizeCustom
} BNPageSize;

@interface SalesManualPdfKitPageRenderer : NSObject <UIWebViewDelegate> {
  
   
}
@property(nonatomic,assign)WKWebView *webView;
- (CGSize)_sizeFromPageSize:(BNPageSize)pageSize;

/**
 The paper size of the generated PDF.
 */
@property (nonatomic, assign) BNPageSize pageSize;

/**
 Custom page size.
 */
@property (nonatomic, assign) CGSize customPageSize;

/**
 Top and Bottom page margins.
 */
@property (nonatomic, assign) CGFloat topAndBottomMarginSize;

/**
 Left and Right page margins.
 */
@property (nonatomic, assign) CGFloat leftAndRightMarginSize;

/**
 The receiver's `delegate`.
 
 The `delegate` is sent messages when content is loading.
 */
@property (nonatomic, assign) id<SalesManualPdfKitDelegate> delegate;

/**
 Initializes BNHtmlPdfKit with a BNPageSize.
 
 @param pageSize The page size the output should be at.
 
 @return An initialized `BNHtmlPdfKit` object.
 */
- (id)initWithPageSize:(BNPageSize)pageSize;

/**
 Initializes BNHtmlPdfKit with a custom page size.
 
 @param pageSize The page size the output should be at.
 
 @return An initialized `BNHtmlPdfKit` object.
 */
- (id)initWithCustomPageSize:(CGSize)pageSize;

/**
 The size of the paper to print on.
 */
- (CGSize)actualPageSize;

/**
 Saves an html string to PDF data.
 
 @param html The HTML to save as a pdf.
 */
- (void)saveHtmlAsPdf:(NSString *)html;


/**
 Saves an html string to a PDF file.
 
 @param html The HTML to save as a pdf file.
 */
- (void)saveHtmlAsPdf:(NSString *)html toFile:(NSString *)file;

/**
 Saves an html string to PDF data.
 
 @param url The URL to save as a pdf.
 */
- (void)saveUrlAsPdf:(NSURL *)url;


/**
 Saves an html string to a PDF file.
 
 @param url The URL to save as a pdf file.
 */
- (void)saveUrlAsPdf:(NSURL *)url toFile:(NSString *)file;
-(void)savePDFActionOnPath:(NSString *)strPDFDestinationPath;
@end;


/**
 The `BNHtmlPdfKitDelegate` protocol defines methods that a delegate of a `BNHtmlPdfKit` object that provides feedback
 based on the operations being performed.
 
 @warning **Important:** Before releasing an instance of `SSWebView` set the `BNHtmlPdfKit` delegate property to `nil`
 before disposing of the `BNHtmlPdfKit` instance. This can be done in the `dealloc` method.
 */
@protocol SalesManualPdfKitDelegate <NSObject>

@optional

/**
 Sent when pdf data has been generated.
 
 @param htmlPdfKit The `BNHtmlPdfKit` that data is being saved from.
 @param data The PDF data that was created from HTML/URL.
 */
- (void)htmlPdfKit:(SalesManualPdfKitPageRenderer *)htmlPdfKit didSavePdfData:(NSData *)data;

/**
 Sent when pdf data has been generated.
 
 @param htmlPdfKit The `BNHtmlPdfKit` that data is being saved from.
 @param data The PDF data that was created from HTML/URL.
 */
- (void)htmlPdfKit:(SalesManualPdfKitPageRenderer *)htmlPdfKit didSavePdfFile:(NSString *)file;

/**
 Sent when there was an error trying to generate the PDF.
 
 @param htmlPdfKit The `BNHtmlPdfKit` that theerror generated from.
 */
- (void)htmlPdfKit:(SalesManualPdfKitPageRenderer *)htmlPdfKit didFailWithError:(NSError *)error;
@end
