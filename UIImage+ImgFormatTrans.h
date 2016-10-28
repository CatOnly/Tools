//
//  UIImage+ImgFormatTrans.h
//
//  Created by light Sun on 16/9/27.
//  Copyright © 2016年 light Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GrayScaleTypeR = 0,
    GrayScaleTypeG = 1,
    GrayScaleTypeB = 2
} GrayScaleType;

@interface UIImage (ImgFormatTrans)

/** 根据 RGB 格式的数据创建 UIImage 对象 */
+ (UIImage *)imageFromRGBFormateBuffer:(unsigned char *)buffer width:(int) width height:(int) height;
/** 根据 RGBA 格式的数据创建 UIImage 对象 */
+ (UIImage *)imageFromRGBAFormateBuffer:(unsigned char *)buffer width:(int)width height:(int)height;
/** 根据 NV12 格式的 YUV 数据创建 UIImage 对象 */
+ (UIImage *)imageFromYUVNV12FormatBuffer:(unsigned char *)data imgWidth:(int)imgWidth imgHeight:(int)imgHeight;
/** 根据数据创建灰度图 */
+ (UIImage *)imageGrayScaleFromRGBBuffer:(unsigned char *)buffer type:(GrayScaleType)type width:(int)width height:(int)height;
/** 求两张图的差异图 */
+ (UIImage *)imageRGBFormateDvalueFromOrigin:(unsigned char *)origin newBuffer:(unsigned char *)newBuffer width:(int)width height:(int)height;
@end
