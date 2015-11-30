///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file MarLayoutManager.m
/// @brief
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

#import "ZGLayoutManager.h"
#import "UIComponent.h"
#import "ExpressionUtil.h"
#import "OtherUtils.h"

/** 布局管理器组件
 * 
 *  布局管理器组件，负责计算各个控件的宽度和高度，并保存目前容器的大小，位置，
 *  现在绘制的位置和已经绘制的组件列表
 */
@implementation ZGLayoutManager

#pragma mark -
#pragma mark properties

/** 当前已绘制的范围 */
@synthesize totalShowRect;
/** 布局管理器所属容器 */
@synthesize targetContainer;
/** 当前绘制点位置 */
@synthesize currPosition;
/** 当前可绘制的最大范围 */
@synthesize maxShowRect;
@synthesize percentBaseSize;

#pragma mark -
#pragma mark init & dealloc methods

/** 根据父容器大小和布局容器相关属性进行布局管理的初始化
 *
 *  根据父容器大小和布局容器相关属性进行布局管理的初始化
 *  @param container 当前容器
 *  @param definedSize 该容器计算后的偏移量和默认宽高
 *  @param maxRect 最大大小，用于计算宽高的百分比
 *  @param parentContainer 父容器
 *  @return 初始化后的布局管理器
 */
- (ZGLayoutManager*) initWithContainer: (ZGContainer*) container
                            definedSize: (const CGSize) xmlDefineSize
                             remainSize: (const CGSize) remainSize
                         maxSeeableSize: (const CGSize) maxSeeableSize
                        percentBaseSize: (const CGSize) baseSize
                        parentContainer: (ZGContainer*) parentContainer
{
  self.targetContainer = container;
  rowHeight = 0;
  currPosition.x = 0;
  currPosition.y = 0;
  if (xmlDefineSize.width > 0)
  {
    //已绘制范围
    totalShowRect.width = xmlDefineSize.width;
    //可绘制范围
    maxShowRect.width = xmlDefineSize.width;
    availableSize.width = xmlDefineSize.width;
  } else {
    //已绘制范围
    totalShowRect.width = 0;
    //可绘制范围
    maxShowRect.width = maxSeeableSize.width;
    availableSize.width = remainSize.width;
  }
  if (xmlDefineSize.height > 0)
  {
    totalShowRect.height = xmlDefineSize.height;
    maxShowRect.height = xmlDefineSize.height;
    availableSize.height = xmlDefineSize.height;
  } else {
    totalShowRect.height = 0;
    maxShowRect.height = maxSeeableSize.height;
    availableSize.height = remainSize.height;
  }
  percentBaseSize = baseSize;
  return self;
}

/** 析构函数
 *  析构函数
 */
//- (void) dealloc
//{
//  targetContainer = nil;
//  [super dealloc];
//}

#pragma mark -
#pragma mark manage container's layout

/** 布局管理器返回下一块可用空间
 *
 *  下一块可用空间
 *  @return 下一个可用的空间
 */
- (CGSize) nextAvailableSize
{
  return CGSizeMake(availableSize.width - currPosition.x, availableSize.height - currPosition.y);
}

/** 布局管理器返回当前可视范围
 *
 *  下一块可用空间
 *  @return 下一个可用的空间
 */
- (CGSize) remainSeeableSize
{
  return CGSizeMake(maxShowRect.width, maxShowRect.height - currPosition.y);
}

/** 布局管理根据组件计算的位置进行微调，确定是否需要换行等
 *
 *  @param 组件计算的绘制位置和范围
 *  @return 微调后的范围，交由组件进行绘制
 */
- (CGRect) finetuningDrawRect: (CGSize) compDrawSize
{
  CGRect compDrawRect;
  int compWidth = compDrawSize.width;
  int compHeight = compDrawSize.height;
  if (compWidth > availableSize.width)
    availableSize.width = maxShowRect.width;
  if (targetContainer.isHorizontal) {
    //横向排版
    if (compWidth == NULL_NUMBER_VALUE)
    {
      compWidth = availableSize.width - currPosition.x;
    }
    if (compHeight == NULL_NUMBER_VALUE)
    {
      compHeight = rowHeight;
    }
    if (currPosition.x + compWidth > availableSize.width)
    {
      LOG(@"change line : %.0f, %d, %.0f", currPosition.x, compWidth, availableSize.width);
      currPosition.x = 0;
      currPosition.y += rowHeight;
      rowHeight = compHeight;
    } else {
      if (currPosition.x + compWidth > totalShowRect.width)
      {
        totalShowRect.width = currPosition.x + compWidth;
      }
      if (rowHeight < compHeight)
      {
        rowHeight = compHeight;
      }
    }
    if (currPosition.y + rowHeight > totalShowRect.height)
    {
      totalShowRect.height = currPosition.y + rowHeight;
    }
    compDrawRect.origin = CGPointMake(currPosition.x, currPosition.y);
    if (targetContainer.alignStyle.hAlign == UITextAlignmentRight)
    {
      compDrawRect.origin = CGPointMake(totalShowRect.width - compWidth - 10, currPosition.y);
    }
    currPosition.x += compWidth;
    if (currPosition.x >= availableSize.width)
    {
      currPosition.x = 0;
      currPosition.y += rowHeight;
      rowHeight = 0;
    }
  } else {
    //纵向排版
    if (compWidth == NULL_NUMBER_VALUE)
    {
      compWidth = availableSize.width;
    }
    if (compHeight == NULL_NUMBER_VALUE)
    {
      compHeight = availableSize.height - currPosition.y;
    }
    if (currPosition.x + compWidth > totalShowRect.width)
    {
      totalShowRect.width = currPosition.x + compWidth;
    }
    if (currPosition.y + compHeight > totalShowRect.height)
    {
      totalShowRect.height = currPosition.y + compHeight;
    }
    compDrawRect.origin = CGPointMake(currPosition.x, currPosition.y);
    if (targetContainer.alignStyle.hAlign == UITextAlignmentRight)
    {
      compDrawRect.origin = CGPointMake(totalShowRect.width - compWidth - 10, currPosition.y);
    }
    currPosition.y += compHeight;
  }
  compDrawRect.size = compDrawSize;
  LOG(@"计算之后currPosition : %.3f %.3f", currPosition.x, currPosition.y);
  LOG(@"返回compDrawRect : %.3f  %.3f  %.3f  %.3f", compDrawRect.origin.x, compDrawRect.origin.y, 
      compDrawRect.size.width,compDrawRect.size.height);
  return compDrawRect;
}

/** 本行布局计算结束，另起新行
 *
 *  本行布局计算结束，另起新行
 */
- (void) newLine
{
  if (self.targetContainer.isHorizontal)
    //横向排版
  {
    if (totalShowRect.width < currPosition.x)
      totalShowRect.width = currPosition.x;
    currPosition.x = 0;
    currPosition.y += rowHeight;
    if (totalShowRect.height < currPosition.y)
      totalShowRect.height = currPosition.y;
    rowHeight = 0;
  }
  else {
//    //纵向排版
//    currPosition.x += rowHeight;
//    currPosition.y = startPosition.y;
//    if (totalShowRect.width < currPosition.x - startPosition.x)
//      totalShowRect.width = currPosition.x - startPosition.x;
//    rowHeight = 0;
//    [lineCompontentArray removeAllObjects];
  }
}

/** 调整当前绘制行的组件
 *
 *  调整当前绘制行的组件，对每个组件均进行重新计算
 */
- (void) resizeLine
{
  //
}

#pragma mark -
#pragma mark methods for edit container


/** 移动当前布局管理器所管理的view的视图
 *
 *  动当前布局管理器所管理的view的视图
 *  @param destPos 移动目标原点
 *  @param compList 重新绘制的组件列表
 */
- (void) moveOrginToPosition: (CGPoint) destPos
              compontentList: (NSArray*) compList
{
  float deltX = destPos.x - currPosition.x;
  float deltY = destPos.x - currPosition.y;
  for (ZGComponent* comp in compList)
  {
    if (deltX != 0)
    {
      float orgX = [[comp getAttribute: MAR_TAG_ATTR_X] floatValue];
      [comp setAttributeByName: MAR_TAG_ATTR_X
                 attributeVale: [NSString stringWithFormat: @"%f", (orgX + deltX)]];
    }
    if (deltY != 0)
    {
      float orgY = [[comp getAttribute: MAR_TAG_ATTR_Y] floatValue];
      [comp setAttributeByName: MAR_TAG_ATTR_Y
                 attributeVale: [NSString stringWithFormat: @"%f", (orgY + deltY)]];
    }
  }
}

@end