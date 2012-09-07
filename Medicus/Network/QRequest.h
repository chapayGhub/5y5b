//
//  QRequest.h
//  Medicus
//
//  Created by Andrei on 9/5/12.
//  Copyright (c) 2012 Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface QResponse : NSObject

@property (nonatomic, strong) NSString*     rus;
@property (nonatomic, strong) NSString*     eng;
@property (nonatomic, strong) NSArray*      drugs;

@end

@interface QDrug : NSObject

@property (nonatomic, strong) NSString*     iD;
@property (nonatomic, strong) NSString*     rusName;
@property (nonatomic, strong) NSString*     engName;
@property (nonatomic, strong) NSString*     zipInfo;
@property (nonatomic, strong) NSString*     registrationNumber;

@end

@interface QRequest : NSObject

+(RKRequest*) postRequest:(UIImage*)image withDelegate:(id<RKObjectLoaderDelegate>)delegate;

@end

@interface QSearchResult : NSObject

+(QSearchResult*) instance;

@property (nonatomic, strong) NSArray* result;

@end

