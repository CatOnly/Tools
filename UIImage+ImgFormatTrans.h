//
//  UIImage+ImgFormatTrans.h
//
//  Created by light Sun on 16/9/27.
//  Copyright © 2016年 light Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImgFormatTrans)

/** 根据 NV12格式的 YUV 数据创建 UIImage 对象 */
+ (UIImage *)imageFromYUVNV12FormatData:(unsigned char *)data imgWidth:(int)imgWidth imgHeight:(int)imgHeight;
@end
