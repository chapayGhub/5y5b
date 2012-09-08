//
//  QSearchRequest.m
//  Medicus
//
//  Created by Andrei on 9/5/12.
//  Copyright (c) 2012 Q. All rights reserved.
//

#import "QSearchRequest.h"

@implementation QSearchResponse

@synthesize product;

-(NSString*) description{    
    NSString *result = [NSString stringWithFormat:@"%@\n", [self class], nil];
    result = [NSString stringWithFormat:@"%@\n%@",result, product];
    return result;
}

@end

@implementation QSearchProduct
@end

@implementation QSearchRequest

+(RKRequest*) postRequest:(NSString*)searchText withDelegate:(id<RKObjectLoaderDelegate>)delegate
{
    NSString *postPath = [NSString stringWithFormat:@"/ocr/api/drugs/%@",searchText,nil];
    postPath           = [postPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:postPath
                                                    usingBlock:^(RKObjectLoader *loader) {
        loader.delegate      = delegate;
        loader.objectMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[QSearchResponse class]];
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


