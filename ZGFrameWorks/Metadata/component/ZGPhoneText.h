///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarPhoneText.h
/// @brief 数字输入头文件
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

#import "ZGUIPhoneText.h"

/** 本类的功能：创建数字输入框
 *  用于输入手机号码
 */

@interface ZGPhoneText : ZGComponent <UITextFieldDelegate>
{
    /** 数字输入框控件 */
  ZGUIPhoneText* uiTextField;
  /** 字体颜色设置 */
  UIColor* fontColor;
  /** 初始化默认文字 */
  NSString* placeholder;
}
/** 数字输入框控件 */
@property (nonatomic, retain) ZGUIPhoneText *uiTextField;
/** 字体颜色设置 */
@property (nonatomic, retain) UIColor* fontColor;
/** 初始化默认文字 */
@property (nonatomic, retain) NSString* placeholder;

@end