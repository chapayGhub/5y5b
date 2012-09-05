//
//  QFrameButton.m
//  Medicus
//
//  Created by Andrei on 9/5/12.
//  Copyright (c) 2012 mozido. All rights reserved.
//

#import "QFrameButton.h"

@implementation QFrameButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect rectangle = self.frame;
    rectangle.origin = CGPointZero;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    CGContextSetFillColorWithColor(context, [[UIColor darkGrayColor] colorWithAlphaComponent:0.3].CGColor);
    
    CGContextFillRect(context, rectangle);
    
    CGContextSetLineWidth(context, 2.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
}




@end
