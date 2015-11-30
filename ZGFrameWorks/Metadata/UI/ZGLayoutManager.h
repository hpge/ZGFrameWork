///////////////////////////////////////////////////////////////////////////////
/// COPYRIGHT NOTICE
/// Copyright (c) 2011，紫光信业（版权声明）
/// All rights reserved
///
/// @file   MarLayoutManager.h
/// @brief  布局管理器组件，负责计算各个控件的宽度和高度
///
/// 布局管理器组件，负责计算各个控件的宽度和高度，并保存目前容器的大小，位置，
/// 现在绘制的位置和已经绘制的组件列表
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
#import "UIComponent.h"
/** 布局管理器组件
 * 
 *  布局管理器组件，负责计算各个控件的宽度和高度，并保存目前容器的大小，位置，
 *  现在绘制的位置和已经绘制的组件列表
 */
@interface ZGLayoutManager : NSObject {
@private
  /** 当前绘制行的行高 */
  CGFloat rowHeight;
  /** 当前绘制总大小 */
  CGSize totalShowRect;
  /** 可以进行绘制的范围 */
  CGSize availableSize;
  /** 布局管理器所属容器 */
//  ZGContainer *targetContainer;
  CGSize percentBaseSize;
@public
  /** 当前的绘制位置 */
  CGPoint currPosition;
  CGSize maxShowRect;
}

/** 当前绘制总大小 */
@property (nonatomic) CGSize totalShowRect;
/** 布局管理器所属容器 */
@property (nonatomic, assign) ZGContainer* targetContainer;
/** 当前点 */
@property (nonatomic) CGPoint currPosition;
/** 最大体积 */
@property (nonatomic, readonly) CGSize maxShowRect;
@property (nonatomic, readonly) CGSize percentBaseSize;

/** 根据父容器大小和布局容器相关属性进行布局管理的初始化
 *
 *  根据父容器大小和布局容器相关属性进行布局管理的初始化
 *  @param container 当前容器
 *  @param defaultSize 该容器计算后的偏移量和默认宽高
 *  @param maxRect 最大大小，用于计算宽高的百分比
 *  @param parentContainer 父容器
 *  @return 初始化后的布局管理器
 */
- (ZGLayoutManager*) initWithContainer: (ZGContainer*) container
                            definedSize: (const CGSize) xmlDefineSize
                             remainSize: (const CGSize) remainSize
                         maxSeeableSize: (const CGSize) maxSeeableSize
                        percentBaseSize: (const CGSize) percentBaseSize
                        parentContainer: (ZGContainer*) parentContainer;

/** 布局管理器返回下一块可用空间
 *
 *  下一块可用空间
 *  @return 下一个可用的空间
 */
- (CGSize) nextAvailableSize;

/** 布局管理器返回当前可视范围
 *
 *  下一块可用空间
 *  @return 下一个可用的空间
 */
- (CGSize) remainSeeableSize;

/** 布局管理根据组件计算的位置进行微调，确定是否需要换行等
 *
 *  @param 组件计算的绘制位置和范围
 *  @return 微调后的范围，交由组件进行绘制
 */
- (CGRect) finetuningDrawRect: (CGSize) compDrawSize;

/** 本行布局计算结束，另起新行
 *
 *  本行布局计算结束，另起新行
 */
- (void) newLine;

/** 调整当前绘制行的组件
 *
 *  调整当前绘制行的组件，对每个组件均进行重新计算
 */
- (void) resizeLine;

/** 移动当前布局管理器所管理的view的视图
 *
 *  动当前布局管理器所管理的view的视图
 *  @param destPos 移动目标原点
 *  @param compList 重新绘制的组件列表
 */
- (void) moveOrginToPosition: (CGPoint) destPos
              compontentList: (NSArray*) compList;

@end