///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarImageLink.h
/// @brief 图片链接头文件
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

/** 本类的功能：创建图片链接
 *  点击图片进入该链接
 */

@interface ZGImageLink : ZGComponent {
    /** 图片链接按钮 */
    UIButton* uiImageLink;
    /** 按钮是否是圆角 */
    BOOL isRoundedRect;
}

/** 图片链接按钮 */
@property (nonatomic, retain) UIButton* uiImageLink;

@end
