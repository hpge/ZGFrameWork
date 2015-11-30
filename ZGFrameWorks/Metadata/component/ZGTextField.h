///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarTextField.h
/// @brief 文本输入框头文件
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

#import "ZGUITextField.h"
#import "ZGComponent.h"

/** 本类的功能：创建文本输入框
 *
 *  用于输入文本信息
 *  包括用户名，密码，需要查询的信息等
 */

@interface ZGTextField : ZGComponent <UITextFieldDelegate>{
    /** 文本输入框控件 */
  ZGUITextField *uiTextField;
  /** 字体颜色设置 */
  UIColor* fontColor;
  /** 初始化默认文字 */
  NSString* placeholder;
}
/** 文本输入框控件 */
@property (nonatomic, retain) UITextField *uiTextField;
/** 字体颜色设置 */
@property (nonatomic, retain) UIColor* fontColor;
/** 初始化默认文字 */
@property (nonatomic, retain) NSString* placeholder;

/** 在指定的文本字段中编辑时请求委托
 *
 *  @param textField 即将编辑的文本字段
 *  @return 编辑是否发起
 */
- (BOOL) textFieldShouldBeginEditing: (UITextField*) textField;

/** 在指定的文本字段中停止编辑时请求委托
 *
 *  @param textField 编辑结束的文本字段
 */
- (void) textFieldDidEndEditing: (UITextField*) textField;

/** 当文本字段按下返回按钮时请求委托，此方法捕获所有按下Return键的动作
 *  
 *  @param textField 按下返回按钮的文本字段
 *  @return 是否实现返回按钮按下的默认行为
 */
- (BOOL) textFieldShouldReturn: (UITextField*) textField;

/** 当前的文本字段中内容删除时请求委托
 *
 *  @param textField 当前包含文本的文本字段
 *  @return 是否应该被删除
 */
- (BOOL)textFieldShouldClear:(UITextField *)textField;

/** 当一个或多个手指触摸在视图或窗口上时，告诉接收器
 *  
 */
- (void) touchesBegan: (NSSet*) touches
            withEvent: (UIEvent*) event;

/** 返回输入框的文本
 *  
 */
- (NSString*) getWidgetValue;
- (void) setWidgetValue: (NSString*) value;

@end
