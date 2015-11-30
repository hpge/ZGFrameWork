//
//  CommonMacro.h
//  ZGFrameWorks
//
//  Created by gehaipeng on 15/11/24.
//  Copyright © 2015年 Melvins inc. All rights reserved.
//

#ifndef CommonMacro_h
#define CommonMacro_h

#define YTKLog(format, ...) do {\
   va_list argptr;      \
   va_start(argptr, format);\
   NSLogv(format, argptr);\
    va_end(argptr); \
}while(0)

#define COMMON_FS_FILE @"common.xml"


#define DEBUG_LOG

#endif /* CommonMacro_h */
