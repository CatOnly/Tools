//
//  UIImage+ImgFormatTrans.m
//
//  Created by light Sun on 16/9/27.
//  Copyright © 2016年 light Sun. All rights reserved.
//

#import "UIImage+ImgFormatTrans.h"

@implementation UIImage (ImgFormatTrans)

+ (UIImage *)imageFromRGBAFormateBuffer:(unsigned char *)buffer width:(int)width height:(int)height
{
    size_t bufferLength = width * height * 4 * sizeof(unsigned char);
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, NULL);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    if(colorSpaceRef == NULL) {
        NSLog(@"Error allocating color space");
        CGDataProviderRelease(provider);
        return nil;
    }
    
    CGImageRef cgImgRef = CGImageCreate(width,
                                        height,
                                        8,         // bitsPerComponent
                                        32,        // bitsPerPixel
                                        4 * width, // bytesPerRow
                                        colorSpaceRef,
                                        kCGBitmapByteOrderDefault, // CGBitmapInfo
                                        provider,  // data provider
                                        NULL,      // 解码器
                                        NO,        // 能否插入数据
                                        kCGRenderingIntentDefault); // CGColorRenderingIntent
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    
    UIImage* image = [UIImage imageWithCGImage:cgImgRef];
    CGImageRelease(cgImgRef);
    buffer = NULL;
    
    return image;
}

+ (UIImage *)imageGrayScaleFromRGBBuffer:(unsigned char *)buffer type:(GrayScaleType)type width:(int)width height:(int)height
{
    unsigned char *rgba = (unsigned char *)malloc(width * height * 4 * sizeof(unsigned char));
    for(int i=0; i < width*height; i++) {
        rgba[4*i]   = buffer[3*i+type];
        rgba[4*i+1] = buffer[3*i+type];
        rgba[4*i+2] = buffer[3*i+type];
        rgba[4*i+3] = 255;
    }

    return [self imageFromRGBAFormateBuffer:rgba width:width height:height];
}

// BitmapRGBA8 -> UIImage
+ (UIImage *)imageFromRGBFormateBuffer:(unsigned char *)buffer width:(int)width height:(int)height
{
    
    unsigned char *rgba = (unsigned char *)malloc(width * height * 4 * sizeof(unsigned char));
    for(int i=0; i < width*height; i++) {
        rgba[4*i]   = buffer[3*i];
        rgba[4*i+1] = buffer[3*i+1];
        rgba[4*i+2] = buffer[3*i+2];
        rgba[4*i+3] = 255;
    }
    return [self imageFromRGBAFormateBuffer:rgba width:width height:height];
}

+ (UIImage *)imageRGBFormateDvalueFromOrigin:(unsigned char *)origin newBuffer:(unsigned char *)newBuffer width:(int)width height:(int)height
{
    unsigned char *rgba = (unsigned char *)malloc(width * height * 4 * sizeof(unsigned char));
    
    for(int i=0; i < width*height; i++) {
        rgba[4*i]   = newBuffer[3*i] - origin[3*i];
        rgba[4*i+1] = newBuffer[3*i+1] - origin[3*i+1];
        rgba[4*i+2] = newBuffer[3*i+2] - origin[3*i+2];
        rgba[4*i+3] = 255;
    }
    
    return [self imageFromRGBAFormateBuffer:rgba width:width height:height];
}

+ (UIImage *)imageFromYUVNV12FormatBuffer:(unsigned char *)data imgWidth:(int)imgWidth imgHeight:(int)imgHeight
{
    //YUV(NV12)-->CIImage--->UIImage Conversion
    NSDictionary *pixelAttributes = @{(id)kCVPixelBufferIOSurfacePropertiesKey : @{}};
    CVPixelBufferRef pixelBuffer = NULL;
    CVReturn result = CVPixelBufferCreate(kCFAllocatorDefault,
                                          imgWidth,imgHeight,
                                          kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange,
                                          (__bridge CFDictionaryRef)(pixelAttributes),
                                          &pixelBuffer);
    if (result != kCVReturnSuccess) {
        NSLog(@"CVPixelBuffer 创建失败!%d", result);
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer,0);
    
    unsigned char *yDestPlane = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    unsigned char *uvDestPlane = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    memcpy(yDestPlane, data, imgWidth * imgHeight); // Y-Plane
    memcpy(uvDestPlane, data + imgWidth * imgHeight, imgWidth * imgHeight / 2); //UV-Plane
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    CIContext *tmpContext = [CIContext contextWithOptions:nil];
    
    CIImage *coreImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    CGImageRef coreGraphyImg = [tmpContext createCGImage:coreImage fromRect:CGRectMake(0, 0, imgWidth, imgHeight)];
//    UIImage *newImg = [[UIImage alloc] initWithCGImage:coreGraphyImg scale:1.0 orientation:UIImageOrientationUp];
    UIImage *newImg = [UIImage imageWithCGImage:coreGraphyImg];
    
    CVPixelBufferRelease(pixelBuffer);
    CGImageRelease(coreGraphyImg);
    
    return newImg;
}

@end
