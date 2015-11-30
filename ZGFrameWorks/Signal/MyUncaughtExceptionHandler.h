//
//  UncaughtExceptionHandler.h
//  Game
//
//  Created by Melvin on 15-7-17.
//  Copyright (c) 2015年 ntstudio.imzone.in. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <mach_debug/mach_debug_types.h>
@interface MyUncaughtExceptionHandler : NSObject

+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler *)getHandler;
+ (void)TakeException:(NSException *) exception;

@end
