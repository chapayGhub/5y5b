//
//  QSearchResultCell.m
//  Medicus
//
//  Created by Andrei on 9/7/12.
//  Copyright (c) 2012 Q. All rights reserved.
//

#import "QSearchResultCell.h"

@implementation QSearchResultCell
@synthesize nameLbl;
@synthesize latinName;
@synthesize regNumber;
@synthesize zip;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(QSearchResultCell*) cellWith:(id)owner {
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QSearchResultCell"
                                                 owner:owner options:nil];
	QSearchResultCell *cell = (QSearchResultCell *)[nib objectAtIndex:0];
	return cell;
}
-(void) fillWith:(QDrug*)drug
{
    self.nameLbl.text   = [QSearchResultCell formatString:drug.rusName];
    self.latinName.text = [QSearchResultCell formatString:drug.engName];
    self.regNumber.text = [QSearchResultCell formatString:drug.registrationNumber];
    self.zip.text       = [QSearchResultCell formatString:drug.zipInfo];
}

+(NSString*) formatString:(NSString*)source
{
    NSString* result = [source stringByReplacingOccurrencesOfString:@"<SUP>&reg" withString:@""];
    return [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}


@end
