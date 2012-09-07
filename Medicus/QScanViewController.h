//
//  QScanViewController.h
//  Medicus
//
//  Created by Andrei on 9/2/12.
//  Copyright (c) 2012 Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QScanViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView        *searchResultsTbl;
@property (weak, nonatomic) IBOutlet UINavigationBar *bar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *takePhoto;

- (IBAction)pressTakePhoto:(id)sender;
@end
