//
//  QNetworkRequests.h
//  Medicus
//
//  Created by Andrei on 9/8/12.
//  Copyright (c) 2012 Q. All rights reserved.
//

#import "QNetworkRequests.h"

@implementation QNetworkRequests

+(void) initializeNetwork
{
    static BOOL inited = NO;
    if(!inited)
    {
        RKURL *baseURL = [RKURL URLWithBaseURLString:@"http://ec2-23-23-30-144.compute-1.amazonaws.com:8080"];
        RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
        objectManager.client.baseURL = baseURL;
        objectManager.acceptMIMEType = [NSString stringWithFormat:@"%@,*/*", RKMIMETypeJSON, nil];
        
        RKObjectMapping *drugMapping = [RKObjectMapping mappingForClass:[QDrug class]];
        [drugMapping mapKeyPathsToAttributes:@"id", @"iD", @"rusName", @"rusName", @"engName", @"engName", @"zipInfo", @"zipInfo", @"registrationNumber", @"registrationNumber", nil];
        
        RKObjectMapping *medicamentMapping = [RKObjectMapping mappingForClass:[QScanResponse class]];
        [medicamentMapping mapKeyPathsToAttributes:@"rus", @"rus", @"eng", @"eng", nil];
        [medicamentMapping mapKeyPath:@"drug" toRelationship:@"drugs" withMapping:drugMapping];
        
        
        
        RKObjectMapping *productMapping = [RKObjectMapping mappingForClass:[QSearchProduct class]];
        [productMapping mapKeyPathsToAttributes:@"id", @"iD", @"rusName", @"rusName", @"engName", @"engName", @"zipInfo", @"zipInfo", @"registrationNumber", @"registrationNumber", nil];
        
        RKObjectMapping *searchMapping = [RKObjectMapping mappingForClass:[QSearchResponse class]];
        [searchMapping mapKeyPath:@"product" toRelationship:@"product" withMapping:productMapping];

        [objectManager.mappingProvider registerMapping:medicamentMapping withRootKeyPath:@"ocrResult"];
        [objectManager.mappingProvider registerMapping:searchMapping     withRootKeyPath:@""];
        objectManager.serializationMIMEType = RKMIMETypeJSON;
        
        inited = YES;
    }
}

@end
