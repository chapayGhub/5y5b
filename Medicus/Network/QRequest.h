//
//  QRequest.h
//  Medicus
//
//  Created by Andrei on 9/5/12.
//  Copyright (c) 2012 mozido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface QResponse : NSObject

@property (nonatomic, strong) NSString*     rus;
@property (nonatomic, strong) NSString*     eng;
@property (nonatomic, strong) NSArray*      drug;

@end

@interface QRequest : NSObject

+(RKRequest*) postRequest:(UIImage*)image withDelegate:(id<RKObjectLoaderDelegate>)delegate;

@end
