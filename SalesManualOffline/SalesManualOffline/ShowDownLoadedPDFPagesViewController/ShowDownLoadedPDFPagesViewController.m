//
//  ShowDownLoadedPDFPagesViewController.m
//  SalesManualOffline
//
//  Created by Abhishek Shrivastava on 22/02/18.
//  Copyright © 2018 Abhishek Shrivastava. All rights reserved.
//

#import "ShowDownLoadedPDFPagesViewController.h"
#import <WebKit/WebKit.h>
#import <PDFKit/PDFKit.h>

@interface ShowDownLoadedPDFPagesViewController ()<WKUIDelegate>
{
    NSData *pdfData;
}
@property(nonatomic,weak) IBOutlet WKWebView *webViewObj;

@end

@implementation ShowDownLoadedPDFPagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *pdfFolderPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"PDFPages"]];
    NSString *pdfFilePath=[pdfFolderPath stringByAppendingPathComponent:self.strPdfFileName];
    
   [self.webViewObj loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:pdfFilePath]]];
    
    PDFView *View = [[PDFView alloc] initWithFrame: self.view.bounds];
    View.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    View.autoScales = YES ;
    View.displayDirection = kPDFDisplayDirectionVertical;
    View.displayMode = kPDFDisplaySinglePageContinuous;
    View.displaysRTL = YES ;
    [View setDisplaysPageBreaks:NO];
    [View setDisplayBox:kPDFDisplayBoxTrimBox];
    //[View zoomIn:self];
    [self.view addSubview:View];
    
    
    PDFDocument * document = [[PDFDocument alloc] initWithURL: [NSURL fileURLWithPath:pdfFilePath]];
    View.document = document;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
