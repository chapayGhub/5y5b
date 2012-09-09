//
//  QAboutViewController.m
//  Medicus
//
//  Created by Andrei on 9/9/12.
//  Copyright (c) 2012 Q. All rights reserved.
//

#import "QAboutViewController.h"

@interface QAboutViewController ()

@end

@implementation QAboutViewController

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)pressAboutBtn:(id)sender {
  [TestFlight openFeedbackView];
}
@end
