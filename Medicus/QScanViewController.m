//
//  QScanViewController.m
//  Medicus
//
//  Created by Andrei on 9/2/12.
//  Copyright (c) 2012 mozido. All rights reserved.
//

#import "QScanViewController.h"
#import "QTakeScanViewController.h"

@interface QScanViewController ()

@end

@implementation QScanViewController

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {

    [self showTakePhotoScreen];
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
    navController.toolbarHidden             = YES;
    navController.navigationBarHidden       = YES;
    navController.modalTransitionStyle      = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:navController animated:NO];
}

@end
