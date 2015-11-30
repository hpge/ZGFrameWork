///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarTitle.m
/// @brief 标题文件
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

#import "UIComponent.h"

@implementation ZGTitle

#pragma mark -
#pragma mark draw rect & draw method

/** 根据传入的绘制范围绘制组件
 *
 *  由布局管理器调用，传入父容器，绘制视图，以及根据getBestFitRect方法
 *  计算并重新调整的绘制范围，在View中绘制组件，该方法由各个子类实现。
 *  @param container 父容器
 *  @param view 绘制视图
 *  @param drawRect 绘制范围
 */
- (CGRect) drawCompontentOnContainer: (ZGContainer*) container
                              OnView: (UIView*) view
                            WithRect: (CGRect) drawRect
{
  UIFont *font = [UIFont boldSystemFontOfSize: fontSize];
  [uiLabel setFont:font];/** 加粗 */

  uiLabel.textAlignment = UITextAlignmentCenter;/** 居中 */
  
  return [super drawCompontentOnContainer: container OnView: nil WithRect: drawRect];
}

#pragma mark -
#pragma mark get & set WidgetValue method

/** 更改组件的属性信息
 *
 *  @param attributeName 属性名称
 *  @param value 属性值
 */
- (void) setWidgetAttributeName: (NSString*) attributeName
                  AttributeVale: (NSString*) value
{
    [super setWidgetAttributeName: attributeName 
                    AttributeVale: value];
    if ([attributeName isEqualToString:MAR_TAG_ATTR_FONT_SIZE] ||
             [attributeName isEqualToString:MAR_TAG_ATTR_FONT_SIZE1]) {
        /** 字体设置大小 */
        int fSize = [value intValue];
        if (fSize <= 0)
        {
            fSize = MAR_DEFAULT_BUTTON_FONT_SIZE;
        }
        UIFont *font = [UIFont boldSystemFontOfSize: fSize];
        [uiLabel setFont:font];/** 加粗 */
    }
}

- (NSString*) getWidgetValue
{
  return uiLabel.text;
}

@end
