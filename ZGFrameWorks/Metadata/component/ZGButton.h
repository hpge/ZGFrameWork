///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarButton.h
/// @brief 按钮控件头文件
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

#define MENU_BUTTON 1
#define NORMAL_BUTTON 0

#import <Foundation/Foundation.h>

#import "ZGComponent.h"

/** 本类的功能：创建按钮
 *  
 */

@interface ZGButton : ZGComponent<NSCoding>
{
 @private
  /** 按钮控件 */
	UIButton* uiButton;
  /** 选中图片 */
    UIImage* selectedImage;
  /** 文字颜色 */
    UIColor* fontColor;
    int style;
}

/** 异步方法返回修改被选中图片
 */
- (void) selectedFinishLoaded: (UIImage*) image;

/** 按钮控件 */
@property (nonatomic, retain) UIButton* uiButton;
/** 选中图片 */
@property (nonatomic, retain) UIImage* selectedImage;
/** 文字颜色 */
@property (nonatomic, retain) UIColor* fontColor;

@end
