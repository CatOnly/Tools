//
//  UIDevice+ThisAppSysUsage.h
//  FaceMagic
//
//  Created by light Sun on 16/9/27.
//  Copyright © 2016年 light Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (ThisAppSysUsage)

/** 返回：本应用的 CPU 使用率 */
+ (float)cpuUsageInThisAPP;

/** 返回：本应用的 内存 占用大小 MB */
+ (int)usedMemoryInThisAPP;

/** 获得当前设备的型号 */
+ (NSString *)getCurrentDeviceModel;
@end
