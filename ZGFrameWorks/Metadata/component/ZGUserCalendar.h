///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarUserCalendar.h
/// @brief
///
/// descirption
///
/// @version    0.0.1
/// @date       2011.8.1
///
/// 修订历史：
/// 日期      描述                                                 修订人员\n
/// -------- --------------------------------------------------- --------------
///
///////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "ZGComponent.h"
#import "TdCalendarView.h"

/** 本类的功能：创建日历
 *
 */

@interface ZGUserCalendar : ZGComponent
{
@private
    /** 日历控件 */
    TdCalendarView* calendar;
}
/** 日历控件 */
@property (retain, nonatomic) TdCalendarView* calendar;

@end
