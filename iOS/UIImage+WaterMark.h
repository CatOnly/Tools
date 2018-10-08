//
//  UIImage+WaterMark.h
//
//  Created by light Sun on 16/9/27.
//  Copyright © 2016年 light Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WaterMark)

/** 给图片添加简单的文字标志 */
- (UIImage *)addWaterMarkTipWithInfo:(NSString *)info;

/** 给图片添加水印可配置参数 */
- (UIImage *)addWaterMarkWithInfo:(NSString *)info attr:(NSDictionary *)attr infoFrame:(CGRect)infoFrame;

@end
