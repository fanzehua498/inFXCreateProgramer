//
//  UIApplication+Memory.m
//  test
//
//  Created by rrjj on 2019/5/16.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import "UIApplication+Memory.h"
#import <mach/mach.h>
#import <arpa/inet.h>

@implementation UIApplication (Memory)

-(double)memoryUsed
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_name_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024 /1024;
}


-(double)availableMemory
{
    vm_statistics_data_t vmStatus;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStatus, &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    double free_count = (vm_page_size * vmStatus.free_count) / 1024.0 / 1024.0;
//    vmStatus.active_count * vm_page_size/1024.0/1024.0;
    return free_count;
}

@end
