//
//  QSearchRequest
//  Medicus
//
//  Created by Andrei on 9/5/12.
//  Copyright (c) 2012 Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "QScanRequest.h"


@class QSearchProduct;

@interface QSearchResponse : NSObject

@property (nonatomic, strong) QSearchProduct* product;

@end

@interface QSearchProduct : QDrug

//@property (nonatomic, strong) NSString*     iD;
//@property (nonatomic, strong) NSString*     rusName;
//@property (nonatomic, strong) NSString*     engName;
//@property (nonatomic, strong) NSString*     zipInfo;
//@property (nonatomic, strong) NSString*     registrationNumber;

@end

@interface QSearchRequest : NSObject

+(RKRequest*) postRequest:(NSString*)searchText withDelegate:(id<RKObjectLoaderDelegate>)delegate;

@end

@interface QSearchResult : NSObject

+(QSearchResult*) instance;

@property (nonatomic, strong) NSArray* result;

@end

