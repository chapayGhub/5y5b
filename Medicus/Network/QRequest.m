//
//  QRequest.m
//  Medicus
//
//  Created by Andrei on 9/5/12.
//  Copyright (c) 2012 mozido. All rights reserved.
//

#import "QRequest.h"

@implementation QResponse

@synthesize rus;
@synthesize eng;
@synthesize drug;

-(NSString*) description{
    return [NSString stringWithFormat:@"%@\n %@\n %@\n", self.rus, self.eng, drug];
}

@end

@interface Image : NSObject

@property (nonatomic, strong) UIImage*  image;
- (NSData*)avatarImageData;

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
        
        RKObjectMapping *medicamentMapping = [RKObjectMapping mappingForClass:[QResponse class]];
        [medicamentMapping mapKeyPathsToAttributes:@"rus", @"rus", @"eng", @"eng", @"drug", @"drug",nil];
        
        [objectManager.mappingProvider registerMapping:medicamentMapping withRootKeyPath:@"ocrResult"];
        objectManager.serializationMIMEType = RKMIMETypeJSON;
    }
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/ocr/api/ocr/upload" usingBlock:^(RKObjectLoader *loader) {
        RKParams* params     = [RKParams params];
        NSData* imageData    = UIImagePNGRepresentation([UIImage imageNamed:@"33.png"]);
        [params setData:imageData MIMEType:@"image/png" forParam:@"uploadedFile"];
        loader.delegate      = delegate;
        loader.method        = RKRequestMethodPOST;
        loader.params        = params;
        loader.objectMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[QResponse class]];
    }];
    
    return nil;
}    
@end
