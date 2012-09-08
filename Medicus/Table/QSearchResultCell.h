//
//  QSearchResultCell.h
//  Medicus
//
//  Created by Andrei on 9/7/12.
//  Copyright (c) 2012 Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QScanRequest.h"

@interface QSearchResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *latinName;
@property (weak, nonatomic) IBOutlet UILabel *regNumber;
@property (weak, nonatomic) IBOutlet UILabel *zip;

+(QSearchResultCell*) cellWith:(id)owner;
-(void)               fillWith:(QDrug*)drug;

@end
