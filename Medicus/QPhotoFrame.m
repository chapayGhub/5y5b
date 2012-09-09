//
//  QPhotoFrame.m
//  purscan
//
//  Created by Andrei on 9/1/12.
//  Copyright (c) 2012 Andrei. All rights reserved.
//

#import "QPhotoFrame.h"

NSString *LAST_PHOTO_FRAME = @"Last_Photo_Frame";

@interface QPhotoFrame()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat      firstX;
@property (nonatomic, assign) CGFloat      firstY;
@property (nonatomic, assign) CGSize       frameSize;
@property (nonatomic, assign) CGSize       maxSize;

@end

@implementation QPhotoFrame
@synthesize firstX;
@synthesize firstY;
@synthesize frameSize;
@synthesize photoFrame;
@synthesize savedFrame;
@synthesize frozeFrame;
@synthesize rects;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    self.backgroundColor = [UIColor clearColor];

    CGRect  rect    = self.frame;
    self.photoFrame = CGRectMake(0,0,316,432);
    self.frameSize  = rect.size;
    self.maxSize    = self.frame.size;
    self.savedFrame = CGRectZero;
    
    NSString *defaultRect = [[NSUserDefaults standardUserDefaults] stringForKey:LAST_PHOTO_FRAME];
    if(defaultRect)
    {
        self.photoFrame = CGRectFromString(defaultRect);
        self.frameSize  = self.photoFrame.size;
        self.savedFrame = self.photoFrame;
    }
    
    
    if(![self.gestureRecognizers count])
    {
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(move:)];
        panRecognizer.minimumNumberOfTouches = 1;
        panRecognizer.maximumNumberOfTouches = 1;
        panRecognizer.delegate               = self;
        [self addGestureRecognizer:panRecognizer];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGRect rectangle = self.photoFrame;
    CGRect shadow    = rectangle;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor);
    
    shadow.origin    = CGPointMake(0,0);
    shadow.size      = CGSizeMake(rect.size.width, rectangle.origin.y);
    CGContextFillRect(context, shadow);
    
    shadow.origin    = CGPointMake(0,rectangle.origin.y);
    shadow.size      = CGSizeMake(rectangle.origin.x, rectangle.size.height);
    CGContextFillRect(context, shadow);
    
    shadow.origin    = CGPointMake(rectangle.origin.x+rectangle.size.width,rectangle.origin.y);
    shadow.size      = CGSizeMake(rect.size.width-(rectangle.origin.x+rectangle.size.width), rectangle.size.height);
    CGContextFillRect(context, shadow);
    
    shadow.origin    = CGPointMake(0, rectangle.origin.y+rectangle.size.height);
    shadow.size      = CGSizeMake(rect.size.width, rect.size.height-(rectangle.origin.y+rectangle.size.height));
    CGContextFillRect(context, shadow);
    
    [self drawRects:context];
    
    CGContextSetLineWidth(context, 3.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    rectangle.origin.x    -=1;
    rectangle.origin.y    -=1;
    rectangle.size.width  +=2;
    rectangle.size.height +=2;
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
}

-(void) drawRects:(CGContextRef) context
{
    if(!self.rects)
        return;
    
    CGContextSetLineWidth(context, 2.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
    for (NSValue *value in self.rects) {
        CGRect rectangle = [value CGRectValue];
        CGContextAddRect(context, rectangle);
    }
}

-(void)move:(id)sender {
    
    if(self.frozeFrame)
        return
    
	[self bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self];
    
    UIGestureRecognizerState state = [(UIPanGestureRecognizer*)sender state];
	if(state == UIGestureRecognizerStateBegan) {
		self.firstX = translatedPoint.x;
		self.firstY = translatedPoint.y;
        return;
	}
  
    CGSize sz           = self.frameSize;
    CGFloat newWidth    = sz.width+self.firstX-translatedPoint.x;
    sz.width            = newWidth<0? 0: newWidth>self.maxSize.width? self.maxSize.width: newWidth;
    
    CGFloat newHeight   = sz.height+self.firstY-translatedPoint.y;
    sz.height           = newHeight<0? 0: newHeight>self.maxSize.height? self.maxSize.height: newHeight;
    
    self.frameSize = sz;
    NSLog(@"%@", NSStringFromCGSize(self.frameSize));
    
    CGRect rect;
    rect.origin.x = (int)(self.maxSize.width-sz.width)/2;
    rect.origin.y = (int)(self.maxSize.height-sz.height)/2;
    rect.size = self.frameSize;
    
    self.photoFrame = rect;
    
    [self setNeedsDisplay];
    
    self.firstX = translatedPoint.x;
    self.firstY = translatedPoint.y;
}

-(void) saveSelectedFrameRect
{
    self.savedFrame = self.photoFrame;
    [[NSUserDefaults standardUserDefaults] setObject:NSStringFromCGRect(self.photoFrame)
                                              forKey:LAST_PHOTO_FRAME];
}


@end
