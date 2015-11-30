///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarCheckBox.h
/// @brief 选择框按钮头文件
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

#import "ZGUICheckBox.h"
#import "ZGComponent.h"

@class ZGCheckBoxGroup;

/** 本类的功能：创建选择框按钮
 *
 */
@interface ZGCheckBox : ZGComponent
{
@private
  /** 选择框控件 */
	ZGUICheckBox* checkBox;
  /** */
  ZGCheckBoxGroup* marGroup;
}

@property (nonatomic, retain) ZGUICheckBox *checkBox;
@property (nonatomic, retain) ZGCheckBoxGroup* marGroup;

/** 全局释放内存方法
 *
 *  释放静态变量
 */
//+ (void) staticFree;

/** 返回是否选中状态
 *
 *  @return
 */
- (BOOL) checkBoxIsCheck;

/** 设置选中状态
 *
 *  @param checkState
 */
- (void) setCheckBoxCheck: (BOOL) checkState;

/** 异步方法返回修改背景图片
 */
- (void) unselectedFinishLoaded: (UIImage*) image;

/** 异步方法返回修改被选中图片
 */
- (void) selectedFinishLoaded: (UIImage*) image;

@end
