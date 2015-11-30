///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file   TdCalendarView.m
/// @brief  日历控件视图文件
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

#import "TdCalendarView.h"
#import <QuartzCore/QuartzCore.h>

/* 头部高度 */
const float headHeight = 60;
/* 每个按钮高度 */
const float itemHeight = 35;
/* 头部高度 */
const float prevNextButtonSize = 20;
/* 头部高度 */
const float prevNextButtonSpaceWidth = 15;
/* 头部高度 */
const float prevNextButtonSpaceHeight = 12;
/* 头部高度 */
const float titleFontSize = 30;
/* 头部高度 */
const int	weekFontSize = 12;

@implementation TdCalendarView

@synthesize currentMonthDate;
@synthesize currentSelectDate;
@synthesize currentTime;
@synthesize viewImageView;
@synthesize calendarViewDelegate;

/** 初始化方法
 *
 *  负责初始化当前时间，初始化选定的日期，日期对应标志位数组等
 */
- (void) initCalView
{
  currentTime = CFAbsoluteTimeGetCurrent();
  CFTimeZoneRef tz = CFTimeZoneCopyDefault();
  currentMonthDate = CFAbsoluteTimeGetGregorianDate(currentTime, tz);
  currentMonthDate.day = 1;
  currentSelectDate.year = 0;
  monthFlagArray = malloc(sizeof(int)*31);
  [self clearAllDayFlag];	
}

/** 初始化方法
 *
 *  调用父类的initWithCoder方法，而后调用initCalView方法
 */
- (id) initWithCoder: (NSCoder*) coder
{
  if (self = [super initWithCoder: coder])
  {
    [self initCalView];
  }
  return self;
}

/** 初始化方法
 *
 *  调用父类的initWithFrame方法，而后调用initCalView方法
 */
- (id) initWithFrame: (CGRect) frame
{
  
  if (self = [super initWithFrame: frame]) {
    [self initCalView];
  }
  return self;
}

/** 获取指定月份的天数
 *
 *  根据传入的月份，计算传入的月份应有的天数。
 *  @param date 传入的月份变量
 *  @return 该月的天数
 */
- (int) getDayCountOfaMonth: (CFGregorianDate) date
{
  switch (date.month)
  {
      // 31天的月份
    case 1:
    case 3:
    case 5:
    case 7:
    case 8:
    case 10:
    case 12:
      return 31;
      
      // 二月份判断是否为闰年
    case 2:
      if((date.year % 400)
         && ((date.year % 4) || !(date.year % 100)))
        return 28;
      else
        return 29;
      // 30天的月份
    case 4:
    case 6:
    case 9:		
    case 11:
      return 30;
    default:
      return 31;
  }
}

/** 绘制向前按钮
 *
 *  根据传入的位置，绘制向前按钮，不提供外部调用
 *  @param leftTop 左上角坐标
 */
- (void) drawPrevButton: (CGPoint) leftTop
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSetGrayStrokeColor(ctx, 0, 1);
  CGContextMoveToPoint(ctx,  0 + leftTop.x, prevNextButtonSize / 2 + leftTop.y);
  CGContextAddLineToPoint(ctx, prevNextButtonSize + leftTop.x,  0 + leftTop.y);
  CGContextAddLineToPoint(ctx, prevNextButtonSize + leftTop.x,  prevNextButtonSize + leftTop.y);
  CGContextAddLineToPoint(ctx,  0 + leftTop.x,  prevNextButtonSize/2 + leftTop.y);
  CGContextFillPath(ctx);
}

/** 绘制向后按钮
 *
 *  根据传入的位置，绘制向后按钮，不提供外部调用
 *  @param leftTop 左上角坐标
 */
- (void) drawNextButton: (CGPoint) leftTop
{
  CGContextRef ctx=UIGraphicsGetCurrentContext();
  CGContextSetGrayStrokeColor(ctx,0,1);
  CGContextMoveToPoint(ctx,  0 + leftTop.x,  0 + leftTop.y);
  CGContextAddLineToPoint(ctx, prevNextButtonSize + leftTop.x,  prevNextButtonSize/2 + leftTop.y);
  CGContextAddLineToPoint(ctx,  0 + leftTop.x,  prevNextButtonSize + leftTop.y);
  CGContextAddLineToPoint(ctx,  0 + leftTop.x,  0 + leftTop.y);
  CGContextFillPath(ctx);
}

/** 获取指定序号日期的标志位
 *
 *  根据传入的日期编号，获取该日期的标志位，用于判断该日期是否被选中
 *  @param day 传入的日期序号，从当月1日开始计数
 *  @return 该日期的标志位，是否被选中
 */
- (int) getDayFlag: (int) day
{
  if(day>=1 && day<=31)
  {
    return *(monthFlagArray+day-1);
  }
  else 
    return 0;
}

/** 清除目前月份所有天的标志位，初始化日期标志位数组
 *
 *  清除目前月份所有天的标志位，初始化日期标志位数组
 */
- (void) clearAllDayFlag
{
  memset(monthFlagArray,0,sizeof(int)*31);
}

/** 修改指定序号日期的标志位
 *
 *  根据传入的日期编号，标志位的值，将指定日期的状态变更
 *  @param day 传入的日期序号，当月1日为1，取值范围为1～31
 *  @param flag 传入的日期欲更新的状态值，正值为选中，负值为未选中，0表示不修改
 */
- (void) setDayFlag: (int) day
               flag: (int) flag
{
  if(day >= 1 && day <= 31)
  {
    if(flag > 0)
      *(monthFlagArray + day - 1) = 1;
    else if(flag < 0)
      *(monthFlagArray + day - 1) = -1;
  }
  
}

/** 绘制顶部导航条
 *
 *  绘制顶部导航条，不提供外部调用
 */
- (void) drawTopGradientBar
{  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  size_t num_locations = 3;
  CGFloat locations[3] = {0.0, 0.5, 1.0};
  CGFloat components[12] =
  {
    1.0, 1.0, 1.0, 1.0,
    0.5, 0.5, 0.5, 1.0,
    1.0, 1.0, 1.0, 1.0
  };
  
  CGGradientRef myGradient;
  CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
  myGradient = CGGradientCreateWithColorComponents(myColorspace, components,
                                                   locations, num_locations);
  CGPoint myStartPoint, myEndPoint;
  myStartPoint.x = headHeight;
  myStartPoint.y = 0.0;
  myEndPoint.x = headHeight;
  myEndPoint.y = headHeight;
  
  CGContextDrawLinearGradient(ctx, myGradient, myStartPoint, myEndPoint, 0);
  CGGradientRelease(myGradient);
  
  [self drawPrevButton: CGPointMake(prevNextButtonSpaceWidth, prevNextButtonSpaceHeight)];
  [self drawNextButton: CGPointMake(
                                    self.frame.size.width - prevNextButtonSpaceWidth - prevNextButtonSize, prevNextButtonSpaceHeight)];
}

/** 绘制顶部导航条文字
 *
 *  绘制顶部导航条文字，不提供外部调用
 */
- (void) drawTopBarWords
{
  int width = self.frame.size.width;
  int s_width = width / 7;
  
  [[UIColor blackColor] set];
  NSString *title_Month = [[NSString alloc] initWithFormat:@"%d年%d月",
                           currentMonthDate.year, currentMonthDate.month];
  
  int fontsize = [UIFont buttonFontSize];
  UIFont* font = [UIFont systemFontOfSize : titleFontSize];
  CGPoint location = CGPointMake(width / 2 - 2.5 * titleFontSize, 0);
  [title_Month drawAtPoint: location withFont:font];
  
  UIFont *weekfont = [UIFont boldSystemFontOfSize: weekFontSize];
  fontsize += 3;
  fontsize += 20;
  [@"周一" drawAtPoint: CGPointMake(s_width * 0 + 9, fontsize)
            withFont: weekfont];
  [@"周二" drawAtPoint: CGPointMake(s_width * 1 + 9, fontsize)
            withFont: weekfont];
  [@"周三" drawAtPoint: CGPointMake(s_width * 2 + 9, fontsize)
            withFont: weekfont];
  [@"周四" drawAtPoint: CGPointMake(s_width * 3 + 9, fontsize)
            withFont: weekfont];
  [@"周五" drawAtPoint: CGPointMake(s_width * 4 + 9, fontsize)
            withFont: weekfont];
  [[UIColor redColor] set];
  [@"周六" drawAtPoint: CGPointMake(s_width * 5 + 9, fontsize)
            withFont: weekfont];
  [@"周日" drawAtPoint: CGPointMake(s_width * 6 + 9, fontsize)
            withFont: weekfont];
  [[UIColor blackColor] set];
  
}

/** 绘制分格线
 *
 *  绘制分格线，不提供外部调用
 */
- (void) drawGirdLines
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  int width = self.frame.size.width;
  int row_Count = ([self getDayCountOfaMonth:currentMonthDate] +
                   [self getMonthWeekday:currentMonthDate] - 2) / 7 + 1;
  
  int s_width = width / 7;
  int tabHeight = row_Count * itemHeight+headHeight;
  
  CGContextSetGrayStrokeColor(ctx,0,1);
  CGContextMoveToPoint(ctx, 0, headHeight);
  CGContextAddLineToPoint(ctx, 0, tabHeight);
  CGContextStrokePath(ctx);
  CGContextMoveToPoint(ctx, width, headHeight);
  CGContextAddLineToPoint(ctx, width, tabHeight);
  CGContextStrokePath(ctx);
  
  for(int i = 1; i < 7; i++)
  {
    CGContextSetGrayStrokeColor(ctx, 1, 1);
    CGContextMoveToPoint(ctx, i * s_width - 1, headHeight);
    CGContextAddLineToPoint(ctx, i * s_width - 1,tabHeight);
    CGContextStrokePath(ctx);
  }
  
  for(int i = 0; i < row_Count + 1; i++)
  {
    CGContextSetGrayStrokeColor(ctx, 1, 1);
    CGContextMoveToPoint(ctx, 0, i * itemHeight + headHeight + 3);
    CGContextAddLineToPoint(ctx, width, i * itemHeight + headHeight + 3);
    CGContextStrokePath(ctx);
    
    CGContextSetGrayStrokeColor(ctx, 0.3, 1);
    CGContextMoveToPoint(ctx, 0, i * itemHeight + headHeight);
    CGContextAddLineToPoint(ctx, width,i * itemHeight + headHeight);
    CGContextStrokePath(ctx);
  }
  
  for(int i = 1; i < 7; i++){
    CGContextSetGrayStrokeColor(ctx, 0.3, 1);
    CGContextMoveToPoint(ctx, i * s_width + 2, headHeight);
    CGContextAddLineToPoint(ctx, i * s_width + 2, tabHeight);
    CGContextStrokePath(ctx);
  }
}

/** 获取指定月份中周末的数量
 *
 *  根据传入的月份，计算传入的月份中周末的数量
 *  @param date 传入的月份变量
 *  @return 该月中周末的数量
 */
- (int) getMonthWeekday: (CFGregorianDate) date
{
  CFTimeZoneRef tz = CFTimeZoneCopyDefault();
  CFGregorianDate month_date;
  month_date.year = date.year;
  month_date.month = date.month;
  month_date.day = 1;
  month_date.hour = 0;
  month_date.minute = 0;
  month_date.second = 1;
  return (int)CFAbsoluteTimeGetDayOfWeek(CFGregorianDateGetAbsoluteTime(month_date, tz),tz);
}

/** 绘制日期文字
 *
 *  绘制日期文字，不提供外部调用
 */
- (void) drawDateWords
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  int width = self.frame.size.width;
  
  int dayCount = [self getDayCountOfaMonth: currentMonthDate];
  int day = 0;
  int x = 0;
  int y = 0;
  int s_width = width / 7;
  int curr_Weekday = [self getMonthWeekday: currentMonthDate];
  UIFont* weekfont = [UIFont boldSystemFontOfSize: 12];
  
  for(int i = 1; i < dayCount + 1; i++)
  {
    day = i + curr_Weekday - 2;
    x = day % 7;
    y = day / 7;
    NSString *date = [NSString stringWithFormat: @"%2d", i];
    [date drawAtPoint: CGPointMake(x * s_width + 15, y * itemHeight + headHeight)
             withFont: weekfont];
    if([self getDayFlag : i] == 1)
    {
      CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
      [@"." drawAtPoint: CGPointMake(x * s_width + 19, y * itemHeight + headHeight + 6)
               withFont: [UIFont boldSystemFontOfSize: 25]];
    }
    else if([self getDayFlag: i] == -1)
    {
      CGContextSetRGBFillColor(ctx, 0, 8.5, 0.3, 1);
      [@"." drawAtPoint: CGPointMake(x * s_width + 19, y * itemHeight + headHeight + 6)
               withFont: [UIFont boldSystemFontOfSize: 25]];
    }
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 1);
  }
}

/** 向前或者向后翻页
 *
 *  向前或者向后翻页，不提供外部调用，在此方法中调用delegate的beforeMonthChange
 *  和monthChanged两个方法
 *  @param isPrev 1为向后，其它为向前
 */
- (void) movePrevNext: (int) isPrev
{
  currentSelectDate.year = 0;
  [calendarViewDelegate beforeMonthChange:self willto: currentMonthDate];
  int width = self.frame.size.width;
  int posX;
  if(isPrev == 1)
  {
    posX = width;
  }
  else
  {
    posX = -width;
  }
  
  UIImage *viewImage;
  
  UIGraphicsBeginImageContext(self.bounds.size);
  [self.layer renderInContext:UIGraphicsGetCurrentContext()];	
  viewImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  if(viewImageView == nil)
  {
    viewImageView=[[UIImageView alloc] initWithImage: viewImage];
    
    viewImageView.center = self.center;
    [[self superview] addSubview: viewImageView];
  }
  else
  {
    viewImageView.image = viewImage;
  }
  
  viewImageView.hidden = NO;
  viewImageView.transform = CGAffineTransformMakeTranslation(0, 0);
  self.hidden = YES;
  [self setNeedsDisplay];
  self.transform = CGAffineTransformMakeTranslation(posX, 0);
  
  float height;
  int row_Count = ([self getDayCountOfaMonth: currentMonthDate]
                   + [self getMonthWeekday: currentMonthDate] - 2) / 7 + 1;
  height = row_Count * itemHeight + headHeight;
  //self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
  self.hidden = NO;
  [UIView beginAnimations: nil	context: nil];
  [UIView setAnimationDuration: 0.5];
  self.transform = CGAffineTransformMakeTranslation(0, 0);
  viewImageView.transform = CGAffineTransformMakeTranslation(-posX, 0);
  [UIView commitAnimations];
  [calendarViewDelegate monthChanged: currentMonthDate
                         viewLeftTop: self.frame.origin
                              height: height];
  
}

/** 计算向前翻页时月份序号
 *
 *  计算向前翻页时月份序号，不提供外部调用。
 */
- (void) movePrevMonth
{
  if(currentMonthDate.month > 1)
    currentMonthDate.month -= 1;
  else
  {
    currentMonthDate.month = 12;
    currentMonthDate.year -= 1;
  }
  [self movePrevNext: 0];
}

/** 计算向后翻页时月份序号
 *
 *  计算向后翻页时月份序号，不提供外部调用。
 */
- (void) moveNextMonth
{
  if(currentMonthDate.month < 12)
    currentMonthDate.month += 1;
  else
  {
    currentMonthDate.month = 1;
    currentMonthDate.year += 1;
  }
  [self movePrevNext: 1];	
}

/** 设置并绘制当天按钮
 *
 *  设置并绘制当天按钮，不提供外部调用。
 */
- (void) drawToday
{
  int x;
  int y;
  int day;
  CFGregorianDate today = CFAbsoluteTimeGetGregorianDate(currentTime, CFTimeZoneCopyDefault());
  if(today.month == currentMonthDate.month && today.year == currentMonthDate.year)
  {
    int width = self.frame.size.width;
    int swidth = width / 7;
    int weekday = [self getMonthWeekday: currentMonthDate];
    day = today.day + weekday - 2;
    x = day % 7;
    y = day / 7;
    CGContextRef ctx = UIGraphicsGetCurrentContext(); 
    CGContextSetRGBFillColor(ctx, 0.5, 0.5, 0.5, 1);
    CGContextMoveToPoint(ctx, x * swidth + 1, y * itemHeight + headHeight);
    CGContextAddLineToPoint(ctx, x * swidth + swidth + 2, y * itemHeight + headHeight);
    CGContextAddLineToPoint(ctx, x * swidth + swidth + 2, y * itemHeight + headHeight + itemHeight);
    CGContextAddLineToPoint(ctx, x * swidth + 1, y * itemHeight + headHeight + itemHeight);
    CGContextFillPath(ctx);
    
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    UIFont* weekfont = [UIFont boldSystemFontOfSize: 12];
    NSString* date = [NSString stringWithFormat: @"%2d",today.day];
    [date drawAtPoint: CGPointMake(x * swidth + 15, y * itemHeight + headHeight)
             withFont: weekfont];
    if([self getDayFlag: today.day]==1)
    {
      CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
      [@"." drawAtPoint: CGPointMake(x * swidth + 19, y * itemHeight + headHeight + 6)
               withFont: [UIFont boldSystemFontOfSize: 25]];
    }
    else if([self getDayFlag: today.day] == -1)
    {
      CGContextSetRGBFillColor(ctx, 0, 8.5, 0.3, 1);
      [@"." drawAtPoint: CGPointMake(x * swidth + 19, y * itemHeight + headHeight + 6)
               withFont: [UIFont boldSystemFontOfSize: 25]];
    }
  }
}

/** 设置并绘制当前选定的按钮
 *
 *  设置并绘制当前选定的按钮，不提供外部调用。
 */
- (void) drawCurrentSelectDate{
  int x;
  int y;
  int day;
  int todayFlag;
  if(currentSelectDate.year != 0)
  {
    CFGregorianDate today = CFAbsoluteTimeGetGregorianDate(currentTime, CFTimeZoneCopyDefault());
    
    if(today.year == currentSelectDate.year && today.month == currentSelectDate.month
       && today.day == currentSelectDate.day)
      todayFlag = 1;
    else
      todayFlag = 0;
    
    int width = self.frame.size.width;
    int swidth = width / 7;
    int weekday = [self getMonthWeekday: currentMonthDate];
    day = currentSelectDate.day + weekday - 2;
    x = day % 7;
    y = day / 7;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if(todayFlag == 1)
      CGContextSetRGBFillColor(ctx, 0, 0, 0.7, 1);
    else
      CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
    CGContextMoveToPoint(ctx, x * swidth + 1, y * itemHeight + headHeight);
    CGContextAddLineToPoint(ctx, x * swidth + swidth + 2, y * itemHeight + headHeight);
    CGContextAddLineToPoint(ctx, x * swidth + swidth + 2, y * itemHeight + headHeight+ itemHeight);
    CGContextAddLineToPoint(ctx, x * swidth + 1, y * itemHeight + headHeight + itemHeight);
    CGContextFillPath(ctx);	
    
    if(todayFlag == 1)
    {
      CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
      CGContextMoveToPoint(ctx, x*swidth+4,			y*itemHeight+headHeight+3);
      CGContextAddLineToPoint(ctx, x * swidth + swidth - 1,	y * itemHeight + headHeight + 3);
      CGContextAddLineToPoint(ctx, x * swidth + swidth - 1,	y * itemHeight + headHeight + itemHeight - 3);
      CGContextAddLineToPoint(ctx, x * swidth + 4, y * itemHeight + headHeight + itemHeight - 3);
      CGContextFillPath(ctx);	
    }
    
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    
    UIFont* weekfont = [UIFont boldSystemFontOfSize: 12];
    NSString* date = [NSString stringWithFormat: @"%2d", currentSelectDate.day];
    [date drawAtPoint: CGPointMake(x * swidth + 15, y * itemHeight + headHeight)
             withFont: weekfont];
    if([self getDayFlag: currentSelectDate.day] != 0)
    {
      [@"." drawAtPoint: CGPointMake(x * swidth + 19, y * itemHeight + headHeight + 6)
               withFont: [UIFont boldSystemFontOfSize: 25]];
    }		
  }
}

/** 点击某一日期按钮
 *
 *  点击某一日期按钮，不提供外部调用。
 */
- (void) touchAtDate: (CGPoint) touchPoint
{
  int x;
  int y;
  int width = self.frame.size.width;
  int weekday = [self getMonthWeekday: currentMonthDate];
  int monthDayCount = [self getDayCountOfaMonth: currentMonthDate];
  x = touchPoint.x * 7 / width;
  y = (touchPoint.y - headHeight) / itemHeight;
  int monthday = x + y * 7 - weekday + 2;
  if(monthday > 0 && monthday < monthDayCount + 1)
  {
    currentSelectDate.year = currentMonthDate.year;
    currentSelectDate.month = currentMonthDate.month;
    currentSelectDate.day = monthday;
    currentSelectDate.hour = 0;
    currentSelectDate.minute = 0;
    currentSelectDate.second = 1;
    [calendarViewDelegate selectDateChanged: currentSelectDate];
    [self setNeedsDisplay];
  }
}

/** 点击某一日期按钮结束
 *
 *  点击某一日期按钮结束，不提供外部调用。
 */
- (void) touchesEnded: (NSSet*) touches
            withEvent: (UIEvent*)event
{
  int width = self.frame.size.width;
  UITouch* touch = [touches anyObject];
  CGPoint touchPoint = [touch locationInView:self];
  if(touchPoint.x < 40 && touchPoint.y < headHeight)
    [self movePrevMonth];
  else if(touchPoint.x > width - 40 && touchPoint.y < headHeight)
    [self moveNextMonth];
  else if(touchPoint.y > headHeight)
  {
    [self touchAtDate: touchPoint];
  }
}

/** 绘制日历组件
 *
 *  根据传入的绘制位置和绘制范围，绘制日历控件
 */
- (void) drawRect: (CGRect) rect
{
  static int once = 0;
  currentTime = CFAbsoluteTimeGetCurrent();
  
  [self drawTopGradientBar];
  [self drawTopBarWords];
  [self drawGirdLines];
  
  if(once == 0)
  {
    once = 1;
    float height;
    int row_Count = ([self getDayCountOfaMonth: currentMonthDate] 
                     + [self getMonthWeekday: currentMonthDate] - 2) / 7 + 1;
    height = row_Count * itemHeight + headHeight;
    [calendarViewDelegate monthChanged: currentMonthDate
                           viewLeftTop: self.frame.origin
                                height: height];
    [calendarViewDelegate beforeMonthChange: self willto: currentMonthDate];
    
  }
  [self drawDateWords];
  [self drawToday];
  [self drawCurrentSelectDate];
}

/** 析构函数
 *
 *  析构函数
 */
//- (void) dealloc
//{
//  free(monthFlagArray);
//  if (viewImageView)
//    [viewImageView release];
//  [super dealloc];
//}

@end