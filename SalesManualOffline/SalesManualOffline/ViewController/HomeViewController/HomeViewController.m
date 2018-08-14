//
//  HomeViewController.m
//  SalesManualOffline
//
//  Created by Abhishek Shrivastava on 21/02/18.
//  Copyright © 2018 Abhishek Shrivastava. All rights reserved.
//

#import "LoadWebPageViewController.h"
#import "HomeViewController.h"
#import <AFNetworkReachabilityManager.h>

@interface HomeViewController ()
{
    BOOL isNetworkAvailable;
}

@property(nonatomic,weak)IBOutlet UITextField *txtSearchURL;
@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    // Do any additional setup after loading the view.
    [self checkNeworkStatus];
    self.txtSearchURL.text=@"http://dlrdoc.deere.com/sales/salesmanual/index.html";
}

-(void)checkNeworkStatus
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                
                isNetworkAvailable=YES;
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:
            default:
            {
               
                 isNetworkAvailable=NO;
                break;
            }
        }
    }];
}
#pragma mark Reachability Function
//- (void)reachabilityDidChange:(NSNotification *)notification {
//    Reachability *reachability = (Reachability *)[notification object];
//
//
//    if ([reachability isReachableViaWiFi]||[reachability isReachableViaWWAN]) {
//        isNetworkAvailable = YES;
//    } else {
//        isNetworkAvailable = NO;
//        [self showOfflineContentConfirmation];
//    }
//}
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

-(IBAction)btnSearchWebPage:(UIButton *)sender
{
    if(self.txtSearchURL.text.length>0&&isNetworkAvailable)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        LoadWebPageViewController *loadWebPageVc = [storyboard instantiateViewControllerWithIdentifier:@"LoadWebPageViewControllerIdentifier"];
        loadWebPageVc.strWebPageUrl=[[NSMutableString alloc]initWithString:self.txtSearchURL.text.copy];
        //NSLog(@"The obejct is=%@",loadWebPageVc.strWebPageUrl);
        [self.navigationController pushViewController:loadWebPageVc animated:YES];
    }
    else
    {
        [self showOfflineContentConfirmation];
    }
   
}
#pragma mark Show Download Pages
-(void)btnShowDownlaodedPages
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ShowListOfDownloadedPdfViewControllerIdentifier"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}
//-(IBAction)btnShowAllDownlaodedPages:(UIButton *)btnSender
//{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ShowListOfDownloadedPdfViewControllerIdentifier"];
//
//    [self.navigationController pushViewController:viewController animated:YES];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
