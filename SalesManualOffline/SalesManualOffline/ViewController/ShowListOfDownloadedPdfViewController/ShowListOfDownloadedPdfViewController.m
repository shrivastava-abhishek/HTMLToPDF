//
//  ShowListOfDownloadedPdfViewController.m
//  SalesManualOffline
//
//  Created by Abhishek Shrivastava on 22/02/18.
//  Copyright © 2018 Abhishek Shrivastava. All rights reserved.
//

#import "ShowListOfDownloadedPdfViewController.h"
#import "ShowDownLoadedPDFPagesViewController.h"

@interface ShowListOfDownloadedPdfViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arrPdfFilesPath;
}
@property(nonatomic,weak)IBOutlet UITableView *tblListOfPdfPages;
@end

@implementation ShowListOfDownloadedPdfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"PDFPages"]];
    
    arrPdfFilesPath = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:pdfPath  error:nil];
    if(arrPdfFilesPath.count>0)
    {
        [self.tblListOfPdfPages reloadData];
    }

}
#pragma mark UITableView DataSource and Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrPdfFilesPath.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DownlaodedPdfPages"];
    if(arrPdfFilesPath.count>indexPath.row)
    {
        [cell.textLabel setText:arrPdfFilesPath[indexPath.row]];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(arrPdfFilesPath.count>indexPath.row)
    {
        NSString *pdfFilePath=arrPdfFilesPath[indexPath.row];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ShowDownLoadedPDFPagesViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ShowDownLoadedPDFPagesViewControllerIdentifier"];
        viewController.strPdfFileName=[[NSMutableString alloc]initWithString:pdfFilePath];
        [self.navigationController pushViewController:viewController animated:YES];
    }
  
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
