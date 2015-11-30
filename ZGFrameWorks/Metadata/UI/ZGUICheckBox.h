///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file   MarUICheckBox.h
/// @brief  选择框展示控件定义文件
///
/// 选择框展示控件的定义文件，该文件定义了选择框组件的界面展示类，和选择框类型的枚举类型
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

/** 选择框类别
 * 
 *  选择框类别定义
 */
typedef enum
{
  /** 默认类型，单选框 */
  CheckButtonStyleDefault = 0,
  /** 多选框 */
  CheckButtonStyleBox = 1,
  /** readio Button类型 */
  CheckButtonStyleRadio = 2
} CheckButtonStyle;

/** 选择框控件
 *
 *  选择框界面控件，用于绘制选择框，并响应用户操作，同时提供选择状态查询功能
 */
@interface ZGUICheckBox : UIControl
{
@private
  /** 是否被选中 */
  BOOL isChecked;
  /** 选择框类型代码 */
  CheckButtonStyle style;
  /** 被选中的图片 */
  UIImage* checkedImage;
  /** 未选中时的图片 */
  UIImage* uncheckedImage;
  /** 被选中时展示图片的View元素 */
  UIImageView* checkedImageView;
}

/** 返回是否选中的信息
 *
 *  返回该选择框是否被选中
 *  @return 返回该选择框是否被选中
 */
- (BOOL) isChecked;

/** 设置是否选中
 *
 *  设置该选择框是否被选中
 *  @param checkState 选中状态
 */
- (void) setChecked: (BOOL) checkState;

/** 选择框初始化方法
 *
 *  根据初始化Frame和已选择/未选择所展示的图片创建选择框显示组件
 *  @param initFrame 初始化界面大小和位置
 *  @param unchecked 未选时中的图片
 *  @param checked 已选中时的图片
 *  @return 初始化后的选择框组件
 */
- (id) initWithFrame: (CGRect) initFrame
  withUncheckedImage: (UIImage*) unchecked
    withCheckedImage: (UIImage*) checked;

@property (assign, nonatomic, readonly) CheckButtonStyle style;
@property (retain, nonatomic) UIImage* checkedImage;
@property (retain, nonatomic) UIImage* uncheckedImage;
@property BOOL isChecked;

@end