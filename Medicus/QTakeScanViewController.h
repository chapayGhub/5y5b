//
//  QTakeScanViewController.h
//  Medicus
//
//  Created by Andrei on 9/2/12.
//  Copyright (c) 2012 Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPhotoFrame.h"

@interface QTakeScanViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *cameraView;
@property (weak, nonatomic) IBOutlet QPhotoFrame *frameView;
@property (weak, nonatomic) IBOutlet UIImageView *resultsView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *photoBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *flashBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *retakeBtn;
@property (weak, nonatomic) IBOutlet UIButton        *filterButton;


- (IBAction)searchBtnPressed:(id)sender;
- (IBAction)photoBtnPressed:(id)sender;
- (IBAction)flashBtnPressed:(id)sender;
- (IBAction)retakeBtnPressed:(id)sender;
- (IBAction)applyNextFilter:(id)sender;
- (IBAction)cancelBtnPressed:(id)sender;



@end
