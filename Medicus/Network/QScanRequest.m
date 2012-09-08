//
//  QScanRequest.m
//  Medicus
//
//  Created by Andrei on 9/5/12.
//  Copyright (c) 2012 Q. All rights reserved.
//

#import "QScanRequest.h"

@implementation QScanResponse

@synthesize rus;
@synthesize eng;
@synthesize drugs;

-(NSString*) description{
    
    NSString *result = [NSString stringWithFormat:@"%@ rus=%@\n eng=%@\n", [self class], self.rus, self.eng];
    for (QDrug* drug in self.drugs) {
        result = [NSString stringWithFormat:@"%@\n%@", result, drug];
    }
    return result;
}

@end

@implementation QDrug

@synthesize iD;
@synthesize rusName;
@synthesize engName;
@synthesize zipInfo;
@synthesize registrationNumber;

-(NSString*) description{
    return [NSString stringWithFormat:@"%@\n iD=%@\n rusName=%@\n engName=%@\n zipInfo=%@\n registrationNumber=%@", [self class], self.iD, self.rusName, self.engName, self.zipInfo, self.registrationNumber];
}


@end

@implementation QScanRequest

+(RKRequest*) postRequest:(UIImage*)image withDelegate:(id<RKObjectLoaderDelegate>)delegate
{    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/ocr/api/ocr/upload" usingBlock:^(RKObjectLoader *loader) {
        RKParams* params     = [RKParams params];
        NSData* imageData    = UIImagePNGRepresentation(image);
        [params setData:imageData MIMEType:@"image/png" forParam:@"uploadedFile"];
        loader.delegate      = delegate;
        loader.method        = RKRequestMethodPOST;
        loader.params        = params;
        loader.objectMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[QScanResponse class]];
    }];
    
    return nil;
}    
@end

@implementation QScanResult

@synthesize result;

+(QScanResult*) instance
{
    static QScanResult* instance_ = nil;
    if(!instance_)
    {
        instance_ = [[QScanResult alloc] init];
    }
    return instance_;
}

@end
