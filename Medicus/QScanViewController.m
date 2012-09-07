//
//  QScanViewController.m
//  Medicus
//
//  Created by Andrei on 9/2/12.
//  Copyright (c) 2012 Q. All rights reserved.
//

#import "QScanViewController.h"
#import "QTakeScanViewController.h"
#import "QSearchResultCell.h"

@interface QScanViewController ()

@property (weak, nonatomic) UISearchBar *searchBar;

@end

@implementation QScanViewController
@synthesize searchBar;
@synthesize searchResultsTbl;
@synthesize bar;
@synthesize takePhoto;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    
//    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,300, 44)];
//    self.searchBar.backgroundColor = [UIColor clearColor];
//    UIBarButtonItem * scanBtn     = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
//                                                                                  target:self
//                                                                                  action:@selector(startScan)];
//    [scanBtn setBackgroundImage:[UIImage imageNamed:@"btn-scan-norm"]
//                       forState:UIControlStateNormal
//                     barMetrics:UIBarMetricsDefault];
//    [scanBtn setBackgroundImage:[UIImage imageNamed:@"btn-scan-active"]
//                       forState:UIControlStateHighlighted
//                     barMetrics:UIBarMetricsDefault];
//
//    self.navigation.leftBarButtonItems = [NSArray arrayWithObjects:self.searchBar, nil];
//    self.navigation.rightBarButtonItems = [NSArray arrayWithObjects:scanBtn, nil];
//    self.searchBar.delegate = self;
}

- (void)viewDidUnload
{
    [self setSearchResultsTbl:nil];
    [self setSearchBar:nil];
    [self setBar:nil];
    [self setTakePhoto:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {    
    [self.searchResultsTbl reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)showTakePhotoScreen {
    QTakeScanViewController *takePhotoController = [[QTakeScanViewController alloc] initWithNibName:@"QTakeScanViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *navController   = [[UINavigationController alloc] initWithRootViewController:takePhotoController];
    [self presentModalViewController:navController animated:NO];
}

- (void)startScan {
    [self.searchBar resignFirstResponder];    
    [self showTakePhotoScreen];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (IBAction)pressTakePhoto:(id)sender {
    [self startScan];
}
@end

@implementation QScanViewController(TabelDelegate)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( [[QSearchResult instance].result count])
    {
        QResponse* response = [[QSearchResult instance].result objectAtIndex:0];
        return [response.drugs count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QSearchResultCell *cell = [self.searchResultsTbl dequeueReusableCellWithIdentifier:@"QSearchResultCell"];
    
    if (cell == nil) {
        cell = [QSearchResultCell cellWith:self];
    }

    QResponse* response = [[QSearchResult instance].result objectAtIndex:0];
    [cell fillWith:[response.drugs objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
}

@end