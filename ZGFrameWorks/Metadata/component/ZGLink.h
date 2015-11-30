///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarLink.h
/// @brief 文本链接头文件
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

/** 本类的功能：创建文本链接
 *  在创建的按钮上添加文本，
 *  点击后进入该链接
 */

@interface ZGLink : ZGComponent {
@protected
  /** 按钮控件,文本链接 */
  UIButton* uiButton;
  /** 选择后背景图片 */
  UIImage* selectedImage;
  /** 字体颜色设置 */
  UIColor* fontColor;
}
/** 按钮控件，文本链接 */
@property (nonatomic, retain) UIButton* uiButton;
/** 选择后背景图片 */
@property (nonatomic, retain) UIImage* selectedImage;
/** 字体颜色设置 */
@property (nonatomic, retain) UIColor* fontColor;

@end