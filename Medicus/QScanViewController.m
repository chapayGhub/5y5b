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
#import "QNetworkRequests.h"
#import "MBProgressHUD.h"
#import "QSearchRequest.h"

@interface QScanViewController ()

@property (strong, nonatomic) UISearchBar *searchBar;

@end

@interface QScanViewController(NetworkDelegate)<RKObjectLoaderDelegate>
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
    
    [QNetworkRequests initializeNetwork];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [QSearchRequest postRequest:self.searchBar.text withDelegate:self];
}

- (IBAction)pressTakePhoto:(id)sender {
    [self startScan];
}
@end

@implementation QScanViewController(TabelDelegate)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( [[QScanResult instance].result count])
    {
        QScanResponse* response = [[QScanResult instance].result objectAtIndex:0];
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

    QScanResponse* response = [[QScanResult instance].result objectAtIndex:0];
    [cell fillWith:[response.drugs objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
}

@end

@implementation QScanViewController(NetworkDelegate)

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error{
    
    NSLog(@"Error: %@", [error localizedDescription]);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)request:(RKRequest*)request :(RKResponse*)response {
    
    if ([request isGET]) {
        if ([response isOK]) {
            NSLog(@"Data returned: %@", [response bodyAsString]);
        }
    } else if ([request isPOST]) {
        NSLog(@"Body: %@", [[NSString alloc]initWithData:response.body encoding:response.bodyEncoding]);
        if ([response isJSON]) {
            NSLog(@"POST returned a JSON response");
        }
    } else if ([request isDELETE]) {
        if ([response isNotFound]) {
            NSLog(@"Resource '%@' not exists", [request resourcePath]);
        }
    }
    
    NSLog(@"response code: %d", [response statusCode]);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects{
    
    NSLog(@"objects[%d]", [objects count]);
    NSLog(@"objects = %@", objects);
    
    QScanResponse *response = nil;
    if([objects count])
    {
        response = [QScanResponse new];
        NSMutableArray *products = [NSMutableArray array];
        for(QSearchResponse *resp in objects)
            [products addObject:resp.product];
        
        response.drugs = products;

        [QScanResult instance].result = [NSArray arrayWithObject:response];
        [self.searchResultsTbl reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    }
}

@end
