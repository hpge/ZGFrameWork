///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarSpace.m
/// @brief 空白区域文件
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
#import "ExpressionUtil.h"
#import "OtherUtils.h"

@implementation ZGSpace

#pragma mark -
#pragma mark init & dealloc method

/** 组件内容初始化方法
 *
 *  XML解析器在读取标签内容后调用，用于初始化标签内容属性
 *  @param tagContent 标签内容
 */
- (void) specInit
{
  [super specInit];
}

#pragma mark -
#pragma mark draw rect & draw method

/** 初步计算组件的大小和各个元素绘制范围的方法
 *
 *  由布局管理器调用，传入当前绘制的点，以及计算百分比表达式的高度以及宽度
 *  各个组件负责计算自己宽度和高度，同时计算最合适的绘制范围，并返回给布局
 *  管理器，方法中orgPoint和maxSize均不可修改。
 *  @param orgPoint 绘制原点
 *  @param defaultSize 容器计算的目前默认宽度和高度
 *  @param maxSize 用于计算百分比的宽度和高度
 *  @return 最合适的绘制范围，其中point表示左右和上下的偏移量
 */
- (CGSize) calculateFitableSize: (const CGSize) xmlDefineSize
                     remainSize: (const CGSize) remainSize
                 maxSeeableSize: (const CGSize) maxSeeableSize
                percentBaseSize: (const CGSize) percentBaseSize
                    inContainer: (ZGContainer*) container
{
  CGSize drawSize = [super calculateFitableSize: xmlDefineSize
                                     remainSize: remainSize
                                 maxSeeableSize: maxSeeableSize
                                percentBaseSize: percentBaseSize
                                    inContainer: container];
  if (parent.isHorizontal)
  {
    if (drawSize.height == NULL_NUMBER_VALUE)
    {
      drawSize.height = [MAR_TAG_ATTR_SPACE_DEF_HEIGHT floatValue];
      defaultSizeSource.heightSource = DefinedByConstant;
    }
  } else {
    if (drawSize.width == NULL_NUMBER_VALUE)
    {
      drawSize.width = [MAR_TAG_ATTR_SPACE_DEF_HEIGHT floatValue];
      defaultSizeSource.widthSource = DefinedByConstant;
    }
  }
  return drawSize;
}

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
  return [super drawCompontentOnContainer: container OnView: view WithRect: drawRect];
}

@end
