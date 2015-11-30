///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file  TdCalendarView.h
/// @brief 日历控件视图头文件
///
/// 定义日历控件类，声明相关方法。该类为日历控件视图部分，负责展示/选择日期，选定或者取消日期动作。
/// 还定义了日历代理协议，负责处理日历控件修改所引起的行为变更
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

@protocol CalendarViewDelegate;

/** 日历控件类，本类为日历控件展示用，定义了日历控件和用户的交互行为，
 *  以及交互行为的传递和处理方式。
 * 
 *  本类为日历控件展示层的定义类，该类中定义了用户使用该类时所需要展示
 *  的相关内容，和用户交互的动作类型和处理方式，并能返回用户所选择的日
 *  期。该类还定义了日历控件类对应的代理协议，定义了交互行为触发的时间
 *  、类型和处理方式。
 */
@interface TdCalendarView : UIView
{
  /** 控件中目前展示的月份 */
  CFGregorianDate currentMonthDate;
  /** 用户选择的日期 */
  CFGregorianDate currentSelectDate;
  /** 当前时间 */
  CFAbsoluteTime	currentTime;
  /** 绘制日期的面版 */
  UIImageView*    viewImageView;
  /** 当前日历控件所展示日期的标志位 */
  int*            monthFlagArray;
  /** 日历控件代理用于处理日期控件产生的用户交互行为 */
}

/** 控件中目前展示的月份 */
@property CFGregorianDate currentMonthDate;
/** 用户选择的日期 */
@property CFGregorianDate currentSelectDate;
/** 当前时间 */
@property CFAbsoluteTime  currentTime;
/** 绘制日期的面版 */
@property (nonatomic, retain) UIImageView* viewImageView;
/** 日历控件代理用于处理日期控件产生的用户交互行为 */
@property (nonatomic, assign) id<CalendarViewDelegate> calendarViewDelegate;

/** 获取指定月份的天数
 *
 *  根据传入的月份，计算传入的月份应有的天数。
 *  @param date 传入的月份变量
 *  @return 该月的天数
 */
- (int) getDayCountOfaMonth: (CFGregorianDate) date;

/** 获取指定月份中周末的数量
 *
 *  根据传入的月份，计算传入的月份中周末的数量
 *  @param date 传入的月份变量
 *  @return 该月中周末的数量
 */
- (int) getMonthWeekday: (CFGregorianDate) date;

/** 获取指定序号日期的标志位
 *
 *  根据传入的日期编号，获取该日期的标志位，用于判断该日期是否被选中
 *  @param day 传入的日期序号，从当月1日开始计数
 *  @return 该日期的标志位，是否被选中
 */
- (int) getDayFlag: (int) day;

/** 修改指定序号日期的标志位
 *
 *  根据传入的日期编号，标志位的值，将指定日期的状态变更
 *  @param day 传入的日期序号，当月1日为1，取值范围为1～31
 *  @param flag 传入的日期欲更新的状态值，正值为选中，负值为未选中，0表示不修改
 */
- (void) setDayFlag: (int)day
               flag: (int)flag;

/** 清除目前月份所有天的标志位，初始化日期标志位数组
 *
 *  清除目前月份所有天的标志位，初始化日期标志位数组
 */
- (void)clearAllDayFlag;

@end

/** 日历控件代理协议，本协议定义了日历控件和用户交互行为
 * 
 *  本协议定义了日历控件和用户的交互行为，目前包括日期变更，
 *  月份变更前和月份变更后。
 */
@protocol CalendarViewDelegate<NSObject>

@optional

/** 日历控件日期变更选中状态后的事件处理
 *
 *  当日历控件中日期发生变更时调用已经注册的代理接口处理日期变更事件。
 *  该方法可以不实现。
 *  @param selectDate 选择状态变更的日期
 */
- (void) selectDateChanged: (CFGregorianDate) selectDate;

/** 日历控件中切换月份后的事件处理
 *
 *  当日历控件中当前月份变更后触发该事件，用于刷新和初始化新的月份日期列表
 *  @param currentMonth 切换的月份
 *  @param viewLeftTop 视图界面的原点
 *  @param height 新界面的高度
 */
- (void) monthChanged: (CFGregorianDate) currentMonth
          viewLeftTop: (CGPoint) viewLeftTop
               height: (float) height;

/** 日历控件中切换月份后的事件处理
 *
 *  当日历控件中当前月份变更前触发该事件
 *  @param calendarView 当前日历控件
 *  @param currentMonth 变更前的月份
 */
- (void) beforeMonthChange: (TdCalendarView*) calendarView
                    willto: (CFGregorianDate) currentMonth;

@end
