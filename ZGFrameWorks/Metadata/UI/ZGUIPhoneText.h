///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file   MarUIPhoneText.h
/// @brief  用户输入电话号的输入框展示组件定义类
///
/// 该文件定义了用户输入电话号时使用的输入框组件，该类主要自定义完成按钮
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
#import "ZGUITextField.h"

/** 用户输入电话号的输入框展示组件定义类
 *
 *  该类定义了用户输入电话号时使用的输入框组件，其主要负责展示和触发事件的调用
 */
@interface ZGUIPhoneText : ZGUITextField
{
  UIButton* doneButton;
  UIView* currView;
}

- (ZGUIPhoneText*) init;
- (void) drawDoneButton;
- (void) removeDoneButton;
- (BOOL) becomeFirstResponder;
- (BOOL) resignFirstResponder;
- (void) doneButton: (id)sender;

@end