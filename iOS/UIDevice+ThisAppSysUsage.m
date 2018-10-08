//
//  UIDevice+ThisAppSysUsage.m
//  FaceMagic
//
//  Created by light Sun on 16/9/27.
//  Copyright © 2016年 light Sun. All rights reserved.
//

#import "UIDevice+ThisAppSysUsage.h"
#import <sys/utsname.h>
#import <mach/mach.h>
#import <mach/mach_host.h>

@implementation UIDevice (ThisAppSysUsage)

//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{
                          @"iPhone1,1" : @"iPhone 2G (A1203)",
                          @"iPhone1,2" : @"iPhone 3G (A1241/A1324)",
                          @"iPhone2,1" : @"iPhone 3GS (A1303/A1325)",
                          @"iPhone3,1" : @"iPhone 4 (A1332)",
                          @"iPhone3,2" : @"iPhone 4 (A1332)",
                          @"iPhone3,3" : @"iPhone 4 (A1349)",
                          @"iPhone4,1" : @"iPhone 4S (A1387/A1431)",
                          @"iPhone5,1" : @"iPhone 5 (A1428)",
                          @"iPhone5,2" : @"iPhone 5 (A1429/A1442)",
                          @"iPhone5,3" : @"iPhone 5c (A1456/A1532)",
                          @"iPhone5,4" : @"iPhone 5c (A1507/A1516/A1526/A1529)",
                          @"iPhone6,1" : @"iPhone 5s (A1453/A1533)",
                          @"iPhone6,2" : @"iPhone 5s (A1457/A1518/A1528/A1530)",
                          @"iPhone7,1" : @"iPhone 6 Plus (A1522/A1524)",
                          @"iPhone7,2" : @"iPhone 6 (A1549/A1586)",
                          @"iPhone8,1" : @"iPhone 6s (A1633/A1688/A1691/A1700)",
                          @"iPhone8,2" : @"iPhone 6s Plus (A1634/A1687/A1690/A1699)",
                          @"iPhone8,4" : @"iPhone SE",
                          @"iPhone9,1" : @"iPhone 7",
                          @"iPhone9,2" : @"iPhone 7 Plus",
                          
                          @"iPod1,1" : @"iPod Touch 1G (A1213)",
                          @"iPod2,1" : @"iPod Touch 2G (A1288)",
                          @"iPod3,1" : @"iPod Touch 3G (A1318)",
                          @"iPod4,1" : @"iPod Touch 4G (A1367)",
                          @"iPod5,1" : @"iPod Touch 5G (A1421/A1509)",
                          @"iPod7,1" : @"iPod Touch 6G (A1574)",
                          
                          @"iPad1,1" : @"iPad 1G (A1219/A1337)",
                          @"iPad2,1" : @"iPad 2 (A1395)",
                          @"iPad2,2" : @"iPad 2 (A1396)",
                          @"iPad2,3" : @"iPad 2 (A1397)",
                          @"iPad2,4" : @"iPad 2 (A1395+New Chip)",
                          @"iPad2,5" : @"iPad Mini 1G (A1432)",
                          @"iPad2,6" : @"iPad Mini 1G (A1454)",
                          @"iPad2,7" : @"iPad Mini 1G (A1455)",
                          @"iPad3,1" : @"iPad 3 (A1416)",
                          @"iPad3,2" : @"iPad 3 (A1403)",
                          @"iPad3,3" : @"iPad 3 (A1430)",
                          @"iPad3,4" : @"iPad 4 (A1458)",
                          @"iPad3,5" : @"iPad 4 (A1459)",
                          @"iPad3,6" : @"iPad 4 (A1460)",
                          @"iPad4,1" : @"iPad Air (A1474)",
                          @"iPad4,2" : @"iPad Air (A1475)",
                          @"iPad4,3" : @"iPad Air (A1476)",
                          @"iPad4,4" : @"iPad Mini 2G (A1489)",
                          @"iPad4,5" : @"iPad Mini 2G (A1490)",
                          @"iPad4,6" : @"iPad Mini 2G (A1491)",
                          @"iPad4,7" : @"iPad mini 3 (A1599)",
                          @"iPad4,8" : @"iPad mini 3 (A1600)",
                          @"iPad4,9" : @"iPad mini 3 (A1601)",
                          @"iPad5,1" : @"iPad mini 4 (A1538)",
                          @"iPad5,2" : @"iPad mini 4 (A1550)",
                          @"iPad5,3" : @"iPad Air 2 (A1566)",
                          @"iPad5,4" : @"iPad Air 2 (A1567)",
                          
                          @"i386"   : @"iPhone Simulator",
                          @"x86_64" : @"iPhone Simulator"
                          };
    
    return dic[platform];
}

+ (float)cpuUsageInThisAPP
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    
    for (int j = 0; j < thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,(thread_info_t)thinfo, &thread_info_count);
        
        if (kr != KERN_SUCCESS) return -1;
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

+ (int)usedMemoryInThisAPP
{
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),TASK_BASIC_INFO,(task_info_t)&info,&size);
    return (int)(kerr == KERN_SUCCESS ? info.resident_size/1024/1024 : -1);
}

@end
