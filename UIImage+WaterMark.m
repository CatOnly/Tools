//
//  UIImage+WaterMark.m
//
//  Created by light Sun on 16/9/27.
//  Copyright © 2016年 light Sun. All rights reserved.
//

#import "UIImage+WaterMark.h"

@implementation UIImage (WaterMark)

- (UIImage *)addWaterMarkTipWithInfo:(NSString *)info
{
    NSAssert(self, @"UIImage 对象不能为空！");
    if(info == nil) return self;

    int w = self.size.width;
    NSDictionary *attr = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:30], //设置字体
                           NSForegroundColorAttributeName : [UIColor redColor]    //设置字体颜色
                         };
    return [self addWaterMarkWithInfo:info attr:attr infoFrame:CGRectMake(15, 15, w, 50)];
}

- (UIImage *)addWaterMarkWithInfo:(NSString *)info attr:(NSDictionary *)attr infoFrame:(CGRect)infoFrame
{
    NSAssert(self, @"UIImage 对象不能为空！");
    if(info == nil) return self;
    
    int w = self.size.width;
    int h = self.size.height;
    
    UIGraphicsBeginImageContext(self.size);
    
    [self drawInRect:CGRectMake(0, 0, w, h)];
    [info drawInRect:infoFrame withAttributes:attr];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImg;
}

@end
