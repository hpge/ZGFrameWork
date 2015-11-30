///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file   MarUIPhoneText.m
/// @brief  用户输入电话号的输入框展示组件实现
///
/// 该类负责实现用户输入电话号的输入框展示组件的实现
///
/// @version    0.0.1
/// @date       2011.8.1
///
/// 修订历史：
/// 日期      描述                                                 修订人员\n
/// -------- --------------------------------------------------- --------------
///
///////////////////////////////////////////////////////////////////////////////

#import "ZGUIPhoneText.h"

/** 用户输入电话号的输入框展示组件定义类
 *
 *  该类定义了用户输入电话号时使用的输入框组件，其主要负责展示和触发事件的调用
 */
@implementation ZGUIPhoneText

- (ZGUIPhoneText*) init
{
  if (self = [super init])
  {
  }
  return self;
}

- (void) drawDoneButton
{
  if ([self isEditing] && !doneButton)
  {
    doneButton = [UIButton buttonWithType: UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 163, 106, 53);
    doneButton.adjustsImageWhenHighlighted = NO;
    [doneButton setImage: [UIImage imageNamed:@"DoneUp.png"]
                forState: UIControlStateNormal];
    [doneButton setImage: [UIImage imageNamed:@"DoneDown.png"]
                forState: UIControlStateHighlighted];
    [doneButton addTarget: self
                   action: @selector(doneButton:)
         forControlEvents: UIControlEventTouchUpInside];
    
    // locate keyboard view
    NSArray* windowsArray = [[UIApplication sharedApplication] windows];
    LOG(@"windows count %lu", (unsigned long)[windowsArray count]);
    if (windowsArray)
    {
      LOG(@"finding window...");
      UIWindow* currWindow = nil;
      if  ([windowsArray count] < 2)
      {
        currWindow = [windowsArray objectAtIndex: 0];
      } else {
        currWindow = [windowsArray objectAtIndex: 1];
      }
      for(int i = 0; i < [currWindow.subviews count]; i++)
      {
        LOG(@"currWindow number : %lu", (unsigned long)[currWindow.subviews count]);
        currView = [currWindow.subviews objectAtIndex:i];
        LOG(@"currView desc : %@", [currView description]);
        if(([[currView description] hasPrefix:@"<UIPeripheralHostView"] == YES) ||
           (([[currView description] hasPrefix:@"<UIKeyboard"] == YES)))
        {
          [currView addSubview: doneButton];
          LOG(@"find view!!!!");
        }
      }
    }
  }
}

- (void) removeDoneButton
{
  LOG(@"into removeDoneButton");
  if (currView)
  {
    currView = nil;
    [doneButton removeFromSuperview];
    doneButton = nil;
  }
}

/** 获取组件绘制范围的中间部分
 *
 *  通过传入的组件绘制范围，使用当前字体计算字体所占范围，而后返回字体居中显示的位置，
 *  主要调整基线的高度
 *  @param bounds 组件的绘制范围
 *  @return 根据字体高度计算出来居中显示的绘制范围
 */
- (CGRect) getCenterRectForBounds: (CGRect) bounds
{
  CGRect rect = [super getCenterRectForBounds: bounds];
  [self drawDoneButton];
  return rect;
}

/** 析构函数
 */
//- (void) dealloc
//{
//  if (doneButton)
//  {
//    [doneButton release];
//  }
//  [super dealloc];
//}

/** 组件失去焦点的行为
 *
 *  当组件没有处于焦点时调用，调用代码处于getCenterRectForBounds方法中
 */
- (void) didLostFocus
{
  [self removeDoneButton];
}

- (BOOL) becomeFirstResponder
{
  LOG(@"into becomeFirstResponder");
  BOOL result = [super becomeFirstResponder];
  [self drawDoneButton];
  return result;
}

- (BOOL) resignFirstResponder
{
  LOG(@"into resignFirstResponder");
  BOOL result = [super resignFirstResponder];
  [self removeDoneButton];
  return result;
}

- (void) doneButton: (id)sender {
  LOG(@"into doneButton");
  [self resignFirstResponder];
}
@end
