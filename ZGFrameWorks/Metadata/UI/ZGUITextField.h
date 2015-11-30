///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file   MarUITextField.h
/// @brief  用户输入框组件定义文件
///
/// 用户输入框组件实现文件，该文件负责定义用户输入框展示组件客户端系统的相关接口和属性
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
#import "ZGPage.h"
/** 用户输入框组件类
 *
 *  该类为用户输入框组件类，负责绘制用户输入框，并提供相关事件触发和访问机制
 */
@interface ZGUITextField : UITextField <UITextFieldDelegate>
{
@protected
  /** 该输入框所在页面 */
  ZGPage* marPage;
  BOOL isRegister;
}

/** 全局释放内存方法
 *
 *  释放静态变量
 */
+ (void) staticFree;

/** 设置当前编辑的用户输入框
 *
 *  设置当前正在编辑的用户输入框，该方法为静态方法，在静态变量中保存目前正在编辑的
 *  用户输入框
 *  @param textField 正在使用的用户输入框
 */
+ (void) setActiveField: (UITextField*) textField;

/** 获取组件绘制范围的中间部分
 *
 *  通过传入的组件绘制范围，使用当前字体计算字体所占范围，而后返回字体居中显示的位置，
 *  主要调整基线的高度
 *  @param bounds 组件的绘制范围
 *  @return 根据字体高度计算出来居中显示的绘制范围
 */
- (CGRect) getCenterRectForBounds: (CGRect) bounds;

/** 注册响应KeyboardNotifications事件的MarPage容器
 *
 *  注册响应KeyboardNotifications事件的MarPage容器，并在该输入框显示或者
 *  隐藏键盘时发送KeyboardNotifications事件
 *  @param uiMarPage MarPage控件，该控件用于响应KeyboardNotifications消息
 */
- (void) registerForKeyboardNotifications: (ZGPage*) uiMarPage;

/** 移除已经注册的键盘显示消息
 *
 *  移除响应KeyboardNotifications事件的MarPage容器
 */
- (void) removeRegisterForKeyboardNotifications;

/** 组件失去焦点的行为
 *
 *  当组件没有处于焦点时调用，调用代码处于getCenterRectForBounds方法中
 */
- (void) didLostFocus;

@end