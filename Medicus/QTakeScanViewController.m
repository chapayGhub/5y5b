//
//  QTakeScanViewController.m
//  Medicus
//
//  Created by Andrei on 9/2/12.
//  Copyright (c) 2012 mozido. All rights reserved.
//

#import "QTakeScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>
#import "GPUImage.h"
#import "NYXImagesKit.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "QPhotoFrame.h"


@interface QTakeScanViewController ()

@property (nonatomic, assign) BOOL                       turnFlash;

@property(nonatomic, strong) AVCaptureSession           *session;
@property(nonatomic, strong) AVCaptureStillImageOutput  *stillImageOutput;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *photoLayer;
@property(nonatomic, strong) UIImage                    *rawImage;
@property(nonatomic, assign) NSInteger                   filterIndex;
@property(nonatomic, assign) CGRect                      cropRect;

@end

@interface QTakeScanViewController(Filters)

enum {  FILTERS_COUNT = 3};

- (void)     applyFilter;

- (UIImage*) noFilters:(UIImage*)sourceImage;
- (UIImage*) binaryFilter1:(UIImage*)sourceImage;
- (UIImage*) binaryFilter2:(UIImage*)sourceImage;

@end

@interface QTakeScanViewController(EditImage)

- (CGRect)   getImageCropRectFor:(UIImage*)image;
- (UIImage*) cropImage:(UIImage *)oldImage withRect:(CGRect)rect;

@end

@implementation QTakeScanViewController
@synthesize cameraView;
@synthesize frameView;
@synthesize resultsView;
@synthesize searchBtn;
@synthesize photoBtn;
@synthesize flashBtn;
@synthesize retakeBtn;
@synthesize turnFlash;
@synthesize session;
@synthesize stillImageOutput;
@synthesize rawImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];

    
    // Do any additional setup after loading the view from its nib.
    self.flashBtn.title      = self.turnFlash? NSLocalizedString(@"Flash On", nil): NSLocalizedString(@"Flash Off", nil);
    self.searchBtn.enabled   = NO;
    self.photoBtn.enabled    = YES;
    self.flashBtn.enabled    = YES;
    self.retakeBtn.enabled   = NO;
    
    self.resultsView.hidden = YES;
}

- (void)viewDidUnload
{
    if(self.session.running){
        [self.session stopRunning];
    }
    self.session = nil;
    self.stillImageOutput = nil;
    
    [self setResultsView:nil];
    [self setFrameView:nil];
    [self setPhotoBtn:nil];
    [self setFlashBtn:nil];
    [self setRetakeBtn:nil];
    [self setSearchBtn:nil];
    [self setCameraView:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewDidAppear:(BOOL)animated
{
    if(!self.session)
            [self setupPhotoSession];

    if(!self.session.running)
        [self.session startRunning];
}

-(void) viewDidDisappear:(BOOL)animated
{
    if(self.session.running)
        [self.session stopRunning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)searchBtnPressed:(id)sender {
}

- (IBAction)photoBtnPressed:(id)sender {
    self.searchBtn.enabled   = YES;
    self.photoBtn.enabled    = NO;
    self.flashBtn.enabled    = NO;
    self.retakeBtn.enabled   = YES;

    self.resultsView.hidden  = NO;
    
    self.filterIndex = 0;
    
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in stillImageOutput.connections)
	{
		for (AVCaptureInputPort *port in [connection inputPorts])
		{
			if ([[port mediaType] isEqual:AVMediaTypeVideo] )
			{
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) { break; }
	}
    [self turnTorchOn:YES];
	NSLog(@"about to request a capture from: %@", stillImageOutput);
	[stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = (CFDictionaryRef)CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
		 if (exifAttachments)
		 {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
		 }
         else
             NSLog(@"no attachments");
         
         NSData *imageData  = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image     = [[UIImage alloc] initWithData:imageData];
         
         self.cropRect           = [self getImageCropRectFor:image];
         self.rawImage           = [self cropImage:image withRect:self.cropRect];

         [self.frameView saveSelectedFrameRect];
         
         self.resultsView.frame  = self.frameView.savedFrame;
         self.resultsView.image  = self.rawImage;
         
	 }];
    [self turnTorchOn:NO];
//    [self applyFilter];
}

- (IBAction)flashBtnPressed:(id)sender {
    self.turnFlash = !self.turnFlash;
    self.flashBtn.title = self.turnFlash? NSLocalizedString(@"Flash On", nil): NSLocalizedString(@"Flash Off", nil);
}

- (IBAction)retakeBtnPressed:(id)sender {

    self.searchBtn.enabled   = NO;
    self.photoBtn.enabled    = YES;
    self.flashBtn.enabled    = YES;
    self.retakeBtn.enabled   = NO;

    self.resultsView.hidden  = YES;

}

//take frame by action
-(void) setupPhotoSession
{
    if(self.session)
    {
        [self.session stopRunning];
        self.session =  nil;
    }
    
	self.session = [[AVCaptureSession alloc] init];
	self.session.sessionPreset = AVCaptureSessionPresetMedium;
    
	self.photoLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    
    CGRect bounds=self.cameraView.bounds;
    self.photoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.photoLayer.bounds=bounds;
    self.photoLayer.position=CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    
	[self.cameraView.layer addSublayer:self.photoLayer];
    
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
	NSError *error = nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!input) {
		// Handle the error appropriately.
		NSLog(@"ERROR: trying to open camera: %@", error);
	}
	[self.session addInput:input];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    [self.session addOutput:self.stillImageOutput];
}

- (void) turnTorchOn:(bool) on {
    
    if(!self.turnFlash)
        return;
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

@end

@implementation QTakeScanViewController(Filters)

-(void) applyFilter{
    SEL filters[FILTERS_COUNT] = {@selector(noFilters:), @selector(binaryFilter1:), @selector(binaryFilter2:)};
    
    if(self.filterIndex>=FILTERS_COUNT)
        self.filterIndex = 0;
    
    self.resultsView.hidden = NO;
    
    if([self respondsToSelector:filters[self.filterIndex]])
    {
            self.resultsView.image = [self performSelector:filters[self.filterIndex] withObject:self.rawImage];
    }
    
//    NSString* filterName = NSStringFromSelector(filters[self.filterIndex]);
//    [self.filterBtn setTitle:filterName forState:UIControlStateNormal];
    
    self.filterIndex++;
}

-(UIImage*) noFilters:(UIImage*)sourceImage
{
    return self.rawImage;
}

-(UIImage*) binaryFilter1:(UIImage*)sourceImage
{
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:sourceImage];
    
    GPUImageAdaptiveThresholdFilter *stillImageFilter = [[GPUImageAdaptiveThresholdFilter alloc] init];
    [stillImageSource addTarget:stillImageFilter];
    [stillImageSource processImage];
    
    UIImage *imageWithAppliedThreshold = [stillImageFilter imageFromCurrentlyProcessedOutput];
    return imageWithAppliedThreshold;
}

-(UIImage*) binaryFilter2:(UIImage*)sourceImage
{
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:sourceImage];
    GPUImageLuminanceThresholdFilter *stillImageFilter = [[GPUImageLuminanceThresholdFilter alloc] init];
    stillImageFilter.threshold = 0.5;
    [stillImageSource addTarget:stillImageFilter];
    [stillImageSource processImage];
    
    UIImage *imageWithAppliedThreshold = [stillImageFilter imageFromCurrentlyProcessedOutput];
    return imageWithAppliedThreshold;
    
}

@end

@implementation QTakeScanViewController(EditImage)

- (CGRect) getImageCropRectFor:(UIImage*)image
{
    CGSize size     = image.size;
    
    CGRect rect     = self.frameView.photoFrame;
    float xFactor   = size.width/self.cameraView.frame.size.width;
    float yFactor   = size.height/self.cameraView.frame.size.height;
    
    rect.origin.x   *=xFactor;
    rect.origin.y   *=yFactor;
    
    rect.size.width *=xFactor;
    rect.size.height*=yFactor;
    
    return rect;
}

- (UIImage*)cropImage:(UIImage *)oldImage withRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // translated rectangle for drawing sub image
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, oldImage.size.width, oldImage.size.height);
    
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // draw image
    [oldImage drawInRect:drawRect];
    
    // grab image
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return subImage;
}

@end
