///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarImage.h
/// @brief 图片视图头文件
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

/** 本类的功能：创建图片
 *
 */

@interface ZGImage : ZGComponent {
  /** 图片视图控件 */
  UIImageView* uiImageView;
  UIView* backView;
}

/** 图片视图控件 */
@property (nonatomic, retain) UIImageView* uiImageView;

@end
