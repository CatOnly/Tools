//
//  UIImage+ImgFormatTrans.m
//
//  Created by light Sun on 16/9/27.
//  Copyright © 2016年 light Sun. All rights reserved.
//

#import "UIImage+ImgFormatTrans.h"

@implementation UIImage (ImgFormatTrans)

+ (UIImage *)imageFromYUVNV12FormatData:(unsigned char *)data imgWidth:(int)imgWidth imgHeight:(int)imgHeight
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
    UIImage *newImg = [[UIImage alloc] initWithCGImage:coreGraphyImg scale:1.0 orientation:UIImageOrientationUp];
    
    CVPixelBufferRelease(pixelBuffer);
    CGImageRelease(coreGraphyImg);
    
    return newImg;
}
@end
