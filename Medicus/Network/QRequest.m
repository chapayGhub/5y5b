//
//  QRequest.m
//  Medicus
//
//  Created by Andrei on 9/5/12.
//  Copyright (c) 2012 Q. All rights reserved.
//

#import "QRequest.h"

@implementation QResponse

@synthesize rus;
@synthesize eng;
@synthesize drugs;

-(NSString*) description{
    return [NSString stringWithFormat:@"rus=%@\n eng=%@\n drugs=%@\n", self.rus, self.eng, self.drugs];
}

@end

@implementation QDrug

@synthesize iD;
@synthesize rusName;
@synthesize engName;
@synthesize zipInfo;
@synthesize registrationNumber;

-(NSString*) description{
    return [NSString stringWithFormat:@"iD=%@\n rusName=%@\n engName=%@\n zipInfo=%@\n registrationNumber=%@", self.iD, self.rusName, self.engName, self.zipInfo, self.registrationNumber];
}


@end

@implementation QRequest

+(RKRequest*) postRequest:(UIImage*)image withDelegate:(id<RKObjectLoaderDelegate>)delegate
{
    static RKObjectManager *objectManager = nil;
    
    if(!objectManager)
    {
        RKURL *baseURL = [RKURL URLWithBaseURLString:@"http://ec2-23-23-30-144.compute-1.amazonaws.com:8080"];
        RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
        objectManager.client.baseURL = baseURL;
        objectManager.acceptMIMEType = [NSString stringWithFormat:@"%@,*/*", RKMIMETypeJSON, nil];

        RKObjectMapping *drugMapping = [RKObjectMapping mappingForClass:[QDrug class]];
        [drugMapping mapKeyPathsToAttributes:@"id", @"iD", @"rusName", @"rusName", @"engName", @"engName", @"zipInfo", @"zipInfo", @"registrationNumber", @"registrationNumber", nil];
        
        RKObjectMapping *medicamentMapping = [RKObjectMapping mappingForClass:[QResponse class]];
        [medicamentMapping mapKeyPathsToAttributes:@"rus", @"rus", @"eng", @"eng", nil];
        [medicamentMapping mapKeyPath:@"drug" toRelationship:@"drugs" withMapping:drugMapping];

        [objectManager.mappingProvider registerMapping:medicamentMapping withRootKeyPath:@"ocrResult"];
        objectManager.serializationMIMEType = RKMIMETypeJSON;
    }
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/ocr/api/ocr/upload" usingBlock:^(RKObjectLoader *loader) {
        RKParams* params     = [RKParams params];
        NSData* imageData    = UIImagePNGRepresentation(image);
        [params setData:imageData MIMEType:@"image/png" forParam:@"uploadedFile"];
        loader.delegate      = delegate;
        loader.method        = RKRequestMethodPOST;
        loader.params        = params;
        loader.objectMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[QResponse class]];
    }];
    
    return nil;
}    
@end

@implementation QSearchResult

@synthesize result;

+(QSearchResult*) instance
{
    static QSearchResult* instance_ = nil;
    if(!instance_)
    {
        instance_ = [[QSearchResult alloc] init];
    }
    return instance_;
}

@end

