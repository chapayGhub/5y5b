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

@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation QScanViewController
@synthesize searchBar;
@synthesize searchResultsTbl;
@synthesize topToolBar;

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
    self.searchBar                 = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,250, 42)];
    self.searchBar.barStyle        = UIBarStyleBlack;
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.delegate        = self;
    
    UIView *searchBarContainer = [[UIView alloc] initWithFrame:self.searchBar.frame];
    [searchBarContainer addSubview:self.searchBar];

    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:searchBarContainer];
    NSArray* toolBarItems = [[NSArray arrayWithObjects:searchBarItem, nil] arrayByAddingObjectsFromArray:self.topToolBar.items];
    [self.topToolBar setItems:toolBarItems animated:YES];
}

- (void)viewDidUnload
{
    [self setSearchResultsTbl:nil];
    [self setSearchBar:nil];
    [self setTopToolBar:nil];
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
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationSlide];
    
    takePhotoController.modalTransitionStyle    = UIModalTransitionStyleCrossDissolve;
    takePhotoController.modalPresentationStyle  = UIModalPresentationFullScreen;
    [self presentModalViewController:takePhotoController animated:YES];
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