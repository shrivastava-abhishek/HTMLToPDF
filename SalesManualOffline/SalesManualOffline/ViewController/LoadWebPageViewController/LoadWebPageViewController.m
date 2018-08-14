//
//  LoadWebPageViewController.m
//  SalesManualOffline
//
//  Created by Abhishek Shrivastava on 22/02/18.
//  Copyright © 2018 Abhishek Shrivastava. All rights reserved.
//

#import "LoadWebPageViewController.h"
#import <WebKit/WebKit.h>
#import "SalesManualPdfKitPageRenderer.h"
#import "Reachability.h"
#import "SVProgressHUD.h"

@interface LoadWebPageViewController ()<WKUIDelegate,SalesManualPdfKitDelegate>
{
    SalesManualPdfKitPageRenderer *salesManualPdfPageRenderObj;
    NSString *strPdfFileName;
    BOOL isAppOffline;
}
@property(nonatomic,weak) IBOutlet WKWebView *webViewObj;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *activityIndicatorObj;
@property(nonatomic,weak)IBOutlet UIProgressView *progressView;
@end

@implementation LoadWebPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    
    [self.webViewObj addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webViewObj addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.activityIndicatorObj setHidden:YES];
    [self configureBackButton];
    salesManualPdfPageRenderObj=[[SalesManualPdfKitPageRenderer alloc]init];
    salesManualPdfPageRenderObj.delegate=self;
    [self.webViewObj loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strWebPageUrl]]];
}
-(void)configureBackButton
{
    UIImage* imgBack = [UIImage imageNamed:@"back"];
    CGRect frameback = CGRectMake(0, 0, imgBack.size.width,imgBack.size.height);
    UIButton *btnBack = [[UIButton alloc] initWithFrame:frameback];
    [btnBack setBackgroundImage:imgBack forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchDown];
    [btnBack setShowsTouchWhenHighlighted:NO];
    
    UIBarButtonItem *btnBackNavigation =[[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItems=@[btnBackNavigation];
    
  
    CGRect frameRight = CGRectMake(0, 0, 110,64);
    UIButton *btnRight = [[UIButton alloc] initWithFrame:frameRight];
    [btnRight setTitle:@"Offline Mode" forState:UIControlStateNormal];
    [btnRight setTitle:@"Offline Mode" forState:UIControlStateSelected];
    [btnRight setTitle:@"Offline Mode" forState:UIControlStateHighlighted];
    [btnRight setBackgroundColor:[UIColor blackColor]];
    [btnRight addTarget:self action:@selector(btnShowDownlaodedPages) forControlEvents:UIControlEventTouchDown];
    [btnRight setShowsTouchWhenHighlighted:NO];
    
    UIBarButtonItem *btnRightNavigation =[[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=btnRightNavigation;
}
-(void)backButtonAction
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Message"
                                 message:@"Are you sure, you want to leave this screen?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                    
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                               }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark Download ans Show Downlaoded Pages Action
-(void)btnShowDownlaodedPages
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ShowListOfDownloadedPdfViewControllerIdentifier"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}
-(IBAction)btnDownlaodPages:(UIButton *)sender
{
    [SVProgressHUD show];
    salesManualPdfPageRenderObj.webView=self.webViewObj;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"PDFPages/%@.pdf",strPdfFileName]];
    
    [salesManualPdfPageRenderObj savePDFActionOnPath:pdfPath];
}
#pragma mark Salesmual PDF Rendrer Delegate
-(void)htmlPdfKit:(SalesManualPdfKitPageRenderer *)htmlPdfKit didSavePdfFile:(NSString *)file
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Message"
                                 message:@"Download Completed."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* btnOk = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    
                                    
                                }];
    
   
    
    //Add your buttons to alert controller
    
    [alert addAction:btnOk];
    
    [self presentViewController:alert animated:YES completion:nil];
    [SVProgressHUD dismiss];
    [self.activityIndicatorObj stopAnimating];
}
#pragma mark Web Page Change Notification Action
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"estimatedProgress"])
    {
        self.progressView.progress=(float)self.webViewObj.estimatedProgress;
        
        if(self.progressView.progress==100.0)
        {
            self.progressView.progress=0.0;
        }
    }
    else{
    NSString *strFileName=[[object valueForKeyPath:keyPath] lastPathComponent];
    NSArray *arrComponents=[strFileName componentsSeparatedByString:@"."];
    if(arrComponents.count>0)
    {
        strPdfFileName=arrComponents[0];
    }
  }
}

#pragma mark Reachability Function
- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    
    if ([reachability isReachable]&&!isAppOffline) {
        isAppOffline=NO;
    } else {
        isAppOffline=YES;
        [self showOfflineContentConfirmation];
    }
}
#pragma Alert Message Action
- (void)showOfflineContentConfirmation
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Message"
                                 message:@"Sorry, You lost the internet connection. Would you like to see offline content?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [self btnShowDownlaodedPages];
                                   
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
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
