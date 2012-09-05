//
//  QPhotoFrame.h
//  purscan
//
//  Created by Andrei on 9/1/12.
//  Copyright (c) 2012 Andrei. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *LAST_PHOTO_FRAME;

@interface QPhotoFrame : UIView

-(void) saveSelectedFrameRect;


@property (nonatomic, assign) CGRect photoFrame;
@property (nonatomic, assign) CGRect savedFrame;

@end
