#import "QDetectText.h"

#include <trg.hpp>


@implementation  QDetectText

+(NSArray*) textRegionsFor:(UIImage*)image
{
    NSMutableArray* rects = [NSMutableArray array];
    
    std::vector<std::vector<trg::Rgb> > pixels;
    [self imageDump:image to:pixels];
 
    std::vector<trg::Rect> rawRects = trg::get_textlike_regions(pixels);
    
    for(std::size_t i=0; i<rawRects.size(); ++i)
    {
        trg::Rect rect =  rawRects[i];
        CGRect tmp = CGRectMake(MIN(rect.x1, rect.x2), MIN(rect.y1, rect.y2), fabs(rect.x1 - rect.x2), fabs(rect.y1 - rect.y2));
        [rects addObject:[NSValue valueWithCGRect:tmp] ];
        NSLog(@"Found text rects: %@", NSStringFromCGRect(tmp) );
    }
    return rects;
}

+(void) imageDump:(UIImage*)image to:(std::vector<std::vector<trg::Rgb> >&)raw
{
    CGImageRef cgimage = image.CGImage;
    
    size_t width  = CGImageGetWidth(cgimage);
    size_t height = CGImageGetHeight(cgimage);
    
    size_t bpr = CGImageGetBytesPerRow(cgimage);
    size_t bpp = CGImageGetBitsPerPixel(cgimage);
    size_t bpc = CGImageGetBitsPerComponent(cgimage);
    size_t bytes_per_pixel = bpp / bpc;
    
    std::vector<std::vector<trg::Rgb> > pixels(width, height);
    raw = pixels;
    
    CGDataProviderRef provider = CGImageGetDataProvider(cgimage);

    CFDataRef dataRef   = CGDataProviderCopyData(provider);
    Byte *bytes         = new Byte[CFDataGetLength(dataRef)];
    CFDataGetBytes(dataRef, CFRangeMake(0, CFDataGetLength(dataRef)), bytes);

    
    for(size_t row = 0; row < height; row++)
    {
        for(size_t col = 0; col < width; col++)
        {
            uint8_t* pixel = &bytes[row * bpr + col * bytes_per_pixel];
            trg::Rgb rgb;
            rgb.r = pixel[0];
            rgb.g = pixel[1];
            rgb.b = pixel[2];
            raw[row][col] = rgb;
            
//            printf("r%d g%d b%d", raw[row][col].r, raw[row][col].g, raw[row][col].b);
        }
    }
}


/*
    -(void)imageDump:(NSString*)file
    {
        UIImage* image = [UIImage imageNamed:file];
        CGImageRef cgimage = image.CGImage;
        
        size_t width  = CGImageGetWidth(cgimage);
        size_t height = CGImageGetHeight(cgimage);
        
        size_t bpr = CGImageGetBytesPerRow(cgimage);
        size_t bpp = CGImageGetBitsPerPixel(cgimage);
        size_t bpc = CGImageGetBitsPerComponent(cgimage);
        size_t bytes_per_pixel = bpp / bpc;
        
        CGBitmapInfo info = CGImageGetBitmapInfo(cgimage);
        
        NSLog(
              @"\n"
              "===== %@ =====\n"
              "CGImageGetHeight: %d\n"
              "CGImageGetWidth:  %d\n"
              "CGImageGetColorSpace: %@\n"
              "CGImageGetBitsPerPixel:     %d\n"
              "CGImageGetBitsPerComponent: %d\n"
              "CGImageGetBytesPerRow:      %d\n"
              "CGImageGetBitmapInfo: 0x%.8X\n"
              "  kCGBitmapAlphaInfoMask     = %s\n"
              "  kCGBitmapFloatComponents   = %s\n"
              "  kCGBitmapByteOrderMask     = %s\n"
              "  kCGBitmapByteOrderDefault  = %s\n"
              "  kCGBitmapByteOrder16Little = %s\n"
              "  kCGBitmapByteOrder32Little = %s\n"
              "  kCGBitmapByteOrder16Big    = %s\n"
              "  kCGBitmapByteOrder32Big    = %s\n",
              file,
              (int)width,
              (int)height,
              CGImageGetColorSpace(cgimage),
              (int)bpp,
              (int)bpc,
              (int)bpr,
              (unsigned)info,
              (info & kCGBitmapAlphaInfoMask)     ? "YES" : "NO",
              (info & kCGBitmapFloatComponents)   ? "YES" : "NO",
              (info & kCGBitmapByteOrderMask)     ? "YES" : "NO",
              (info & kCGBitmapByteOrderDefault)  ? "YES" : "NO",
              (info & kCGBitmapByteOrder16Little) ? "YES" : "NO",
              (info & kCGBitmapByteOrder32Little) ? "YES" : "NO",
              (info & kCGBitmapByteOrder16Big)    ? "YES" : "NO",
              (info & kCGBitmapByteOrder32Big)    ? "YES" : "NO"
              );
        
        CGDataProviderRef provider = CGImageGetDataProvider(cgimage);
        NSData* data = (id)CGDataProviderCopyData(provider);
        [data autorelease];
        const uint8_t* bytes = [data bytes];
        
        printf("Pixel Data:\n");
        for(size_t row = 0; row < height; row++)
        {
            for(size_t col = 0; col < width; col++)
            {
                const uint8_t* pixel =
                &bytes[row * bpr + col * bytes_per_pixel];
                
                printf("(");
                for(size_t x = 0; x < bytes_per_pixel; x++)
                {
                    printf("%.2X", pixel[x]);
                    if( x < bytes_per_pixel - 1 )
                        printf(",");
                }
                
                printf(")");
                if( col < width - 1 )
                    printf(", ");
            }
            
            printf("\n");
        }
    }
*/
@end
