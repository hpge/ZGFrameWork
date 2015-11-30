///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarLabel.h
/// @brief 标签头文件
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

/** 本类的功能：创建标签
 *
 */

@interface ZGLabel : ZGComponent {
@protected
  /** 标签控件 */
  UILabel* uiLabel;
  /** 字体颜色 */
  UIColor* fontColor;
}
/** 标签控件 */
@property (nonatomic, retain) UILabel* uiLabel;
/** 字体颜色 */
@property (nonatomic, retain) UIColor* fontColor;

@end
